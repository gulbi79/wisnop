<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	
	<script type="text/javascript">

	var enterSearchFlag = "Y";
	var searchData = null;
	var search_PLAN_ID = null;
	var dip = {

		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.dipGrid.initGrid();
			this.events();
		},
			
		_siq    : "aps.dynamic.dailySupplyPlanOrder",
		/*
		* common Code 
		*/
		comCode : {
			codeMapEx : null,			
			codeMap : null,
			
			initCode : function () {
				var grpCd = 'PROD_PART,APS_DEMAND_TYPE,ORDER_STATUS';
				this.codeMap = gfn_getComCode(grpCd, 'N'); 
				this.codeMapEx = gfn_getComCodeEx(["ROUTING", "ITEM_GROUP", "REP_CUST_GROUP", "CUST_GROUP" ], null, {itemType : "10,50"});
			}
		},
		
		initFilter : function() {
			
			gfn_getPlanIdwc({picketType : "W", planTypeCd : "FP"});
			
			gfn_keyPopAddEvent([
				{ target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>' }
			]);
			
			gfn_setMsComboAll([
				{ target : 'divRepCustGroup', id : 'reptCustGroup', title : '<spring:message code="lbl.reptCustGroup"/>', data : this.comCode.codeMapEx.REP_CUST_GROUP, exData:["*"] },
				{ target : 'divCustGroup', id : 'custGroup', title : '<spring:message code="lbl.custGroup"/>', data : this.comCode.codeMapEx.CUST_GROUP, exData:["*"] },
				{ target : 'divProdPart', id : 'prodPart', title : '<spring:message code="lbl.prodPart2"/>', data : this.comCode.codeMap.PROD_PART, exData:["*"]},
				{ target : 'divItemGroup', id : 'itemGroup', title : '<spring:message code="lbl.itemGroup"/>', data : this.comCode.codeMapEx.ITEM_GROUP, exData:["*"] },
				{ target : 'divRoute', id : 'route', title : '<spring:message code="lbl.routing"/>', data : this.comCode.codeMapEx.ROUTING, exData:["*"] },
				{ target : 'divApsDemandType', id : 'apsDemandType', title : '<spring:message code="lbl.apsDemandType"/>', data : this.comCode.codeMap.APS_DEMAND_TYPE, exData:[""]},
				{ target : 'divOrderStatus', id : 'orderStatus', title : '<spring:message code="lbl.orderStatus"/>', data : this.comCode.codeMap.ORDER_STATUS, exData:["*"] },
				
			]);
			$("#orderStatus").multipleSelect("setSelects", ["OP", "RL", "ST"]);
		},
		 
		/* grid  선언
		*/
		dipGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				
				this.grdMain.setOptions({
					stateBar: { visible : true },
				});
				
				this.grdMain.addCellStyles([{
					id         : "editStyle",
					editable   : true,
					background : gv_editColor
				}]);
				
				this.grdMain.addCellStyles([{
					id         : "noneEditStyle",
					editable   : false,
					background : gv_noneEditColor
				}]);
			},
		},
	
		/*
		* event 정의
		*/
		events : function () {
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("#btnReset").on('click', function (e) {
				dip.dipGrid.grdMain.cancel();
				dip.dipGrid.dataProvider.rollback(dip.dipGrid.dataProvider.getSavePoints()[0]);
				dip.gridCallback(searchData);
			});
			
			$("#btnSave").on('click', function (e) {
				dip.save();
			});
		},
		
		excelSubSearch : function (){
			
			$.each($(".view_combo"), function(i, val){
				
				var temp = "";
				var id = gfn_nvl($(this).attr("id"), "");
				
				if(id != ""){
					
					var name = $("#" + id + " .ilist .itit").html();
					
					//타이틀
					if(i == 0){
						EXCEL_SEARCH_DATA = name + " : ";	
					}else{
						EXCEL_SEARCH_DATA += "\n" + name + " : ";	
					}
					
					if(id == "divPlanId"){
						EXCEL_SEARCH_DATA += $("#planId option:selected").text();
					}else if(id == "divRepCustGroup"){
						$.each($("#reptCustGroup option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divCustGroup"){
						$.each($("#custGroup option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divProdPart"){
						$.each($("#prodPart option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divApsDemandType"){
						$.each($("#apsDemandType option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divProdOrderNo"){
						EXCEL_SEARCH_DATA += $("#prodOrderNo").val();
					}else if(id == "divRoute"){
						$.each($("#route option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divItemGroup"){
						$.each($("#itemGroup option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divItem"){
						EXCEL_SEARCH_DATA += $("#item_nm").val();
					}else if(id == "divOrderStatus"){
						$.each($("#orderStatus option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}
				}
			});

			EXCEL_SEARCH_DATA += "\n" + '<spring:message code="lbl.period"/>' + " : ";
			EXCEL_SEARCH_DATA += $("#fromCal").val() + "(" + $("#fromPWeek").val() + ") ~ ";
			EXCEL_SEARCH_DATA += $("#toCal").val() + "(" + $("#toPWeek").val() + ")";
			
		},
		
		// 조회
		search : function () {
			
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq }];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						dip.dipGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						dip.dipGrid.grdMain.cancel();
						
						dip.dipGrid.dataProvider.setRows(data.resList);
						dip.dipGrid.dataProvider.clearSavePoints();
						dip.dipGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(dip.dipGrid.dataProvider.getRowCount());
						searchData = data.resList;
						dip.gridCallback(data.resList);
						//gfn_actionMonthSum(dip.dipGrid.gridInstance);
						gfn_setRowTotalFixed(dip.dipGrid.grdMain);
					}
				}
			}
			
			search_PLAN_ID = $("#planId").val();
			gfn_service(aOption, "obj");
		},
		
		save : function (){
			
			try {
				this.dipGrid.grdMain.commit(true);
		    } catch (e) {
		        alert('<spring:message code="msg.saveErrorCheck"/>\n'+e.message);
		    }
			
			var grdData = gfn_getGrdSavedataAll(this.dipGrid.grdMain);
			var grdDataLen = grdData.length;
			
			if (grdDataLen == 0) {
				alert('<spring:message code="msg.noChangeData"/>');
				return;
			}
			
			var salesPlanDatas = [];
			var errCheck = true;
			
			$.each(grdData, function(i, row) {
				
				row.ADJ_PRIORITY_NM = $.trim(row.ADJ_PRIORITY_NM);
				
				var planData = {
					PLAN_ID : search_PLAN_ID,
					PROD_PART : row.PROD_PART,
					ITEM_CD : row.ITEM_CD,
					APS_DEMAND_TYPE : row.APS_DEMAND_TYPE,
					PLAN_DATE : row.PLAN_DATE,
					ADJ_PRIORITY : row.ADJ_PRIORITY_NM,
					PROD_ORDER_NO : row.PROD_ORDER_NO
				};
				
				if( row.ADJ_PRIORITY_NM ==  undefined || row.ADJ_PRIORITY_NM =="" ){
					
					errCheck = false;
					alert('<spring:message code="msg.dataCheck1"/>'); 
					var idex = {
					    itemIndex: row._ROWNUM-1,
					    fieldName: 'ADJ_PRIORITY_NM',
					};
				    dip.dipGrid.grdMain.setCurrent(idex);
					return false;
				}
				
				salesPlanDatas.push(planData);
			});
			
			if(errCheck){
				confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
						
					FORM_SAVE            = {}; //초기화
					FORM_SAVE._mtd       = "saveUpdate";
					FORM_SAVE.tranData   = [
						{outDs : "saveCnt", _siq : dip._siq, grdData : salesPlanDatas},
					];
					
					var ajaxOpt = {
						url     : GV_CONTEXT_PATH + "/biz/obj",
						data    : FORM_SAVE,
						success : function(data) {
							
							alert('<spring:message code="msg.saveOk"/>');
							
							dip.dipGrid.grdMain.cancel();
							
							$.each(grdData, function(i, row) {
								dip.dipGrid.dataProvider.setRowState(row._ROWNUM-1, 'none',true);
							});
							
							dip.dipGrid.dataProvider.clearSavePoints();
							dip.dipGrid.dataProvider.savePoint(); //초기화 포인트 저장
							fn_apply();
						},
					};
					
					gfn_service(ajaxOpt, "obj");
				});
			}
		},
		gridCallback : function (resList) {
					
			gfn_service({
			    async   : false,
			    url     : GV_CONTEXT_PATH + "/biz/obj",
			    data    : {
	    			_mtd : "getList",
	    			tranData : [
	    				{outDs : "authorityList", _siq : "aps.dynamic.dailySupplyPlanOrderAuthority"}
	    			]
			    },
			    success :function(data) {
			    	
			    	var dataLen = data.authorityList.length;
			    	var fileds = dip.dipGrid.dataProvider.getFields();
					var releaseflag = $("#releaseflag" ).val();
					var cols = dip.dipGrid.grdMain.getColumns();
					
					//일간 생산계획 수량 / 당주 계획 수량 비교 후 색깔
					var editStyleVal = {};
					var val = gfn_getDynamicStyle(-2);
					
					editStyleVal.background = gv_headerColor;
					editStyleVal.editable = false;
					
					val.criteria.push("(values['DIFF_YN'] = 'N')");
					val.styles.push(editStyleVal);
					
					dip.dipGrid.grdMain.setColumnProperty(dip.dipGrid.grdMain.columnByField("DAILY_PLAN_QTY_NM"), "dynamicStyles", [val]);
					dip.dipGrid.grdMain.setColumnProperty(dip.dipGrid.grdMain.columnByField("CUR_WEEK_PLAN_QTY_NM"), "dynamicStyles", [val]);
					
					
			    	for (var i = 2; i < cols.length; i++) {
			    		var colsNm = cols[i].name;
							
						if(colsNm == "ADJ_PRIORITY_NM"){
							dip.dipGrid.grdMain.setColumnProperty(colsNm, "styles", {background : gv_noneEditColor});
							dip.dipGrid.grdMain.setColumnProperty(colsNm, "zeroText", '');
							dip.dipGrid.grdMain.setColumnProperty(colsNm, "editor", {
		   						type         : "number",
		   						allowEmpty   :  true,
			 				    positiveOnly : true,
		   						textAlignment: "center",
		   						maxLength : 30,
		   						integerOnly  : true
		   					});
						}
			    	}
					
					for(var i = 0; i < dataLen; i++){
			    		
			    		var menuCd = data.authorityList[i].MENU_CD;
			    		
			    		$.each(resList, function(n, v){
			    			
			    			var prodPart = v.PROD_PART;
			    			
							for (var j = 2; j < fileds.length; j++) {
								
								var fieldName = fileds[j].fieldName;
								var fields_len = fileds[j];
								
								if (fieldName == 'ADJ_PRIORITY_NM'){
									        		
							        if(releaseflag == 'N'){
							        	if((menuCd == "APS30701" && prodPart == "LAM") || (menuCd == "APS30702" && prodPart == "TEL") || (menuCd == "APS30703" && prodPart == "DIFFUSION") || (menuCd == "APS30704" && prodPart == "MATERIAL")){
							        		dip.dipGrid.grdMain.setCellStyles(n, fieldName, "editStyle");
						    			}
							        }
								}
							}
			    		});
			    	}
		    	}
			}, "obj");
		}
	};

	//조회
	var fn_apply = function (sqlFlag) {
				
		// 디멘젼, 메져
		gfn_getMenuInit();
		
		DIMENSION.hidden = [];
		DIMENSION.hidden.push({CD : "DIFF_YN", dataType : "text"});
    	
    	if(!sqlFlag){
    		dip.dipGrid.gridInstance.setDraw();
		}		
		//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
    	FORM_SEARCH.dimList    = DIMENSION.user;
    	FORM_SEARCH.hiddenList = DIMENSION.hidden;
    	FORM_SEARCH.meaList	   = MEASURE.next;
    	
		if (!sqlFlag) {
			
			var fileds = dip.dipGrid.dataProvider.getFields();
			for (var i = 0; i < fileds.length; i++) {
				if (fileds[i].fieldName == 'SS_QTY_NM' ||
					fileds[i].fieldName == 'MFG_LT_NM'||
					fileds[i].fieldName == 'SALES_PRICE_KRW_NM') {
					fileds[i].dataType = "number";
					fileds[i].numberFormat = "#,##0";
					
					dip.dipGrid.grdMain.setColumnProperty(fileds[i].fieldName, "styles", {"numberFormat" : "#,##0"});	
				}
			}
			dip.dipGrid.dataProvider.setFields(fileds);
			
		}
		dip.search();	
		dip.excelSubSearch();	
	}

	// onload 
	$(document).ready(function() {
		dip.init();
		
		$("#prodPart").on("change", function(e) {
			
			 var planIdVal = $("#planId").val();
			 var prodPartVal = $.trim($("#prodPart").val());
             if(prodPartVal == undefined ) prodPartVal = null;
			
		});
		
		dip.dipGrid.grdMain.onKeyUp = function (grid, key, ctrl, shift, alt) {
			if(key == 46){  //Delete Key
				gfn_selBlockDelete(grid,dip.dipGrid.dataProvider);  
		   	}
		};
	});
	
	function gfn_getPlanIdwc(pOption) {
			
		try {
			
			if ($("#planId").length == 0) {
				return;
			}
			
			var params = $.extend({
				_mtd     : "getList",
				tranData : [{outDs : "rtnList", _siq : "common.planId"}
				  , {outDs : "defaultList", _siq : "common.planIdFp"}
				]
			}, pOption);
			
			gfn_service({
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : params,
				async   : false,
				success : function(data) {
					
					var defaultPlanId = data.defaultList[0].PLAN_ID;
					
					gfn_setMsCombo("planId", data.rtnList, [""]);
					
					$("#planId").on("change", function(e) {
						
						var fDs = gfn_getFindDataDsInDs(data.rtnList, {CODE_CD : {VALUE : $(this).val(), CONDI : "="}});
						
						if (fDs.length > 0) {
							
							var nowDate = fDs[0].FP_SW_START_DATE;
								    
					        SW_END_DATE = fDs[0].FP_END_DATE;
						    DATEPICKET(null, nowDate, SW_END_DATE);
							
							var sdt = gfn_getStringToDate(nowDate);
							var edt = gfn_getStringToDate(SW_END_DATE);
							
							$("#releaseflag").val(fDs[0].RELEASE_FLAG);
						
							var prodPartVal = $.trim($("#prodPart").val());
							if(prodPartVal == undefined ) prodPartVal = null;
						} 
					});
					
					$("#planId").trigger("change");
					$("#planId").val(defaultPlanId);
				}
			},"obj");
			
		} catch(e) {console.log(e);}
	}
	
	</script>

</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="a" class="split content split-horizontal">
		<form id="searchForm" name="searchForm">
		
		<div id="filterDv">
			<div class="inner">
				<h3>Filter</h3>
				<div class="tabMargin"></div>
				<div class="scroll">
					<div class="view_combo" id="divPlanId">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.planId"/></div>
							<div class="iptdv borNone">
								<select id="planId" name="planId" class="iptcombo"></select>
							</div>
						</div>
                    </div>
					<div class="view_combo" id="divRepCustGroup"></div>
					<div class="view_combo" id="divCustGroup"></div>
					<div class="view_combo" id="divProdPart"></div>
					<input type='hidden' id='releaseflag' name='releaseflag'>
                    <div class="view_combo" id="divApsDemandType"></div>
                    <div class="view_combo" id="divProdOrderNo">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.prodOrderNo4"/></div>
							<input type="text" id="prodOrderNo" name="prodOrderNo" class="ipt">
						</div>
					</div>
                    <div class="view_combo" id="divRoute"></div>
					<div class="view_combo" id="divItemGroup"></div>
					<div class="view_combo" id="divItem"></div>
					<div class="view_combo" id="divOrderStatus"></div>
					<jsp:include page="/WEB-INF/view/common/filterViewHorizon.jsp" flush="false" />
					
				</div>
				<div class="bt_btn">
					<a href="#" class="fl_app" id="btnSearch"><spring:message code="lbl.search"/></a>
				</div>
			</div>
		</div>
		</form>
	</div>
	
	<!-- contents -->
	<div id="b" class="split split-horizontal">
		<div id="grid1" class="fconbox">
			<%@ include file="/WEB-INF/view/common/commonLocation.jsp" %>
			<div class="scroll">
				<!-- 그리드영역 -->
				<div id="realgrid" style="width: 100%;" class="realgrid1"></div>
			</div>
			<div class="cbt_btn" style="height:25px">
				<div class="bright">
					<a href="javascript:;" id="btnReset" class="app1"><spring:message code="lbl.reset" /></a>
					<a href="javascript:;" id="btnSave" class="app2 roleWrite"><spring:message code="lbl.save" /></a>
				</div>
			</div>
		</div>
    </div>
</body>
</html>
