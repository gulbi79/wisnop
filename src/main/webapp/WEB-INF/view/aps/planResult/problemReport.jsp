<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	
	<script type="text/javascript">

	var enterSearchFlag = "Y";
	var dip = {

		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.dipGrid.initGrid();
			this.events();
		},
			
		_siq    : "aps.planResult.problemReport",
		/*
		* common Code 
		*/
		comCode : {
			codeMapEx : null,			
			codeMap : null,
			
			initCode : function () {
				var grpCd = 'PROD_PART,ORDER_STATUS,PROBLEM_TYPE_CD,FLAG_YN';
				this.codeMap = gfn_getComCode(grpCd, 'N'); 
				this.codeMapEx = gfn_getComCodeEx(["ROUTING", "ITEM_GROUP" ], null, {itemType : "10,50"});
			}
		},
		
		initFilter : function() {
			
			var t_planId = $("#planId").val();
			
			gfn_getPlanIdwc({picketType : "W", planTypeCd : "MP"});
			gfn_getPlanVerion({planId : t_planId, ProdPart : null});
			
			gfn_keyPopAddEvent([
				{ target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>' }
			]);
			
			gfn_setMsComboAll([
				{ target : 'divProdPart', id : 'prodPart', title : '<spring:message code="lbl.prodPart2"/>', data : this.comCode.codeMap.PROD_PART, exData:["*"]},
				{ target : 'divItemGroup', id : 'itemGroup', title : '<spring:message code="lbl.itemGroup"/>', data : this.comCode.codeMapEx.ITEM_GROUP,     exData:["*"] },
				{ target : 'divRoute', id : 'route', title : '<spring:message code="lbl.routing"/>', data : this.comCode.codeMapEx.ROUTING, exData:["*"] },
				{ target : 'divDelayFlag', id : 'delayFlag', title : '<spring:message code="lbl.delayFlag"/>', data : this.comCode.codeMap.FLAG_YN, exData:["*"] },
				{ target : 'divUnplannedFlag', id : 'unplannedFlag', title : '<spring:message code="lbl.unplannedFlag"/>', data : this.comCode.codeMap.FLAG_YN, exData:["*"] },
				{ target : 'divProblemType', id : 'problemType', title : '<spring:message code="lbl.problemType"/>', data : this.comCode.codeMap.PROBLEM_TYPE_CD, exData:["*"] },
			]);
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
			
			$("#divPlanVersion").click("on", function() { 
				 var planIdVal = $("#planId").val();
				 var prodPartVal = $.trim($("#prodPart").val());
	             if(prodPartVal == undefined ) prodPartVal = null;
				 gfn_getPlanVerion({planId:planIdVal,pPart:prodPartVal}); 
	    	});
	    	
	    	$("#divPlanVersion").css("cursor", "pointer");
			
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
					}else if(id == "divProdPart"){
						EXCEL_SEARCH_DATA += $("#prodPart option:selected").text();
					}else if(id == "divPlanVersion2"){
						EXCEL_SEARCH_DATA += $("#planVersion option:selected").text();
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
					}else if(id == "divDelayFlag"){
						$.each($("#delayFlag option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divUnplannedFlag"){
						$.each($("#unplannedFlag option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divProblemType"){
						$.each($("#problemType option:selected"), function(i2, val2){
							
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
						gfn_setRowTotalFixed(dip.dipGrid.grdMain);
						
						fn_setHeaderColor();
					}
				}
			}
			
			gfn_service(aOption, "obj");
		}
	};
	

	//조회
	var fn_apply = function (sqlFlag) {
		
		var tmpPlanVersion = $("#planVersion").val();
		
		if(tmpPlanVersion == "" || !tmpPlanVersion){
			alert('<spring:message code="msg.planVersionMsg"/>');
			return;
		}
		
		gfn_getMenuInit();
    	
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
				if (fileds[i].fieldName == 'SS_QTY_NM' || fileds[i].fieldName == 'MFG_LT_NM'|| fileds[i].fieldName == 'SALES_PRICE_KRW_NM') {
					
					fileds[i].dataType = "number";
					fileds[i].numberFormat = "#,##0";
					
					dip.dipGrid.grdMain.setColumnProperty(fileds[i].fieldName, "styles", {"numberFormat" : "#,##0"});	
				}
				
				if (fileds[i].fieldName == 'SP_DATE_NM' || fileds[i].fieldName == 'PLAN_DATE2_NM'){
					
					fileds[i].dataType = "datetime";
					fileds[i].datetimeFormat = "yyyyMMdd";
					
					dip.dipGrid.grdMain.setColumnProperty(fileds[i].fieldName, "styles", {"datetimeFormat" : "yyyy-MM-dd"});
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
			 gfn_getPlanVerion({planId : planIdVal, pPart : prodPartVal});
			
		});
	});
	
	function gfn_getPlanIdwc(pOption) {
			
		try {
			
			if ($("#planId").length == 0) {
				return;
			}
			
			var params = $.extend({
				_mtd     : "getList",
				tranData : [{outDs:"rtnList",_siq:"common.planId"}]
			}, pOption);
			
			gfn_service({
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : params,
				async   : false,
				success : function(data) {
					
					gfn_setMsCombo("planId",data.rtnList,[""]);
					
					$("#planId").on("change", function(e) {
						var fDs = gfn_getFindDataDsInDs(data.rtnList, {CODE_CD : {VALUE : $(this).val(), CONDI : "="}});
						
						if (fDs.length > 0) {
							
							var nowDate = fDs[0].APS_START_DATE;
					        SW_END_DATE = weekdatecal(fDs[0].APS_START_DATE);
						    DATEPICKET(null, nowDate, SW_END_DATE);
							
							var sdt = gfn_getStringToDate(fDs[0].APS_START_DATE);
							var edt = gfn_getStringToDate(fDs[0].APS_END_DATE);
							
							$("#fromCal").datepicker("option", "minDate", sdt);
							//$("#fromCal").datepicker("option", "maxDate", edt);
							//$("#toCal").datepicker("option", "maxDate", edt);
							$("#releaseflag" ).val(fDs[0].RELEASE_FLAG);
						  
							var prodPartVal = $.trim($("#prodPart").val());
                            if(prodPartVal == undefined ) prodPartVal = null;
							gfn_getPlanVerion({planId:fDs[0].CODE_CD,pPart:prodPartVal});
						} 
					});
					$("#planId").trigger("change");
				}
			},"obj");
			
		} catch(e) {console.log(e);}
	}
	
	    
	function gfn_getPlanVerion(pOption) {
		
		try {
			
			if(pOption.planId == null){
				return;
			}
			
			if ($("#planVersion").length == 0) {
				return;
			}
			
			var params = $.extend({
				_mtd     : "getList",
				tranData : [{outDs : "rtnList", _siq : "common.planVersion"}]
			}, pOption);
			
			
			gfn_service({
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : params,
				async   : false,
				success : function(data) {
					gfn_setMsCombo("planVersion", data.rtnList, [""]);
					
					$.each(data.rtnList, function(i, val){
						
						var codeCd = val.CODE_CD;
						var cutOffFlag = val.CUT_OFF_FLAG;
						var versionTypeCd = val.VERSION_TYPE_CD;
						
						if(cutOffFlag == "Y" && versionTypeCd == "M"){
							$("#planVersion option:eq("+ i +")").css("color", gv_redColor);
							return false;
						}
					});
				}
			},"obj");
			
		} catch(e) {console.log(e);}
	}
	
	
	//2주 뒤 날짜 구함
    function weekdatecal(dt){
    	
    	yyyy = dt.substr(0, 4);
    	mm = dt.substr(4, 2);
    	dd = dt.substr(6, 2);
    	
    	var dt_stamp = new Date(yyyy+"-"+mm+"-"+dd).getTime();
    	
    	var days = ((7 * 2) -1); //2주후
		    toDt = new Date(dt_stamp+(days*24*60*60*1000));
		var rdt = toDt.getFullYear() + '' + (toDt.getMonth() + 1  < 10 ? '0' + (toDt.getMonth() + 1 ) : toDt.getMonth() + 1 ) + (toDt.getDate() < 10 ? '0' + toDt.getDate() : toDt.getDate());
	    
    	return rdt
    	
    }
	
	function fn_setHeaderColor(){
		
		var fileds = dip.dipGrid.dataProvider.getFields();
		var filedsLen = fileds.length;
		
		for (var i = 0; i < filedsLen; i++) {
			
			var fieldName = fileds[i].fieldName;
			var param = fieldName + "_NM";
			
			//FONT 색 변경
			if(fieldName == "SEQ2" || fieldName == "PLAN_QTY" || fieldName == "LATE_QTY" || fieldName == "SHORT_QTY"){
				
				var column = dip.dipGrid.grdMain.columnByName(param);
		    	var	dynamicStyles = dip.dipGrid.grdMain.getColumnProperty(column, "dynamicStyles");
		   		dynamicStyles.unshift({criteria: "((values['SEQ2_NM'] = 0))", styles: "foreground=#FF0000"});
		   		dip.dipGrid.grdMain.setColumnProperty(param,"dynamicStyles", dynamicStyles);	
			} 
			
		}
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
					<div class="view_combo" id="divProdPart"></div>
					<input type='hidden' id='releaseflag' name='releaseflag'>
					<div class="view_combo" id="divPlanVersion2">
						<div class="ilist">
							<div class="itit" id="divPlanVersion"><spring:message code="lbl.planVersion"/></div>
							<div class="iptdv borNone">
								<select id="planVersion" name="planVersion" class="iptcombo"></select>
							</div>
						</div>
                    </div>
                    
                    <div class="view_combo" id="divRoute"></div>
					<div class="view_combo" id="divItemGroup"></div>
					<div class="view_combo" id="divItem"></div>
					<div class="view_combo" id="divDelayFlag"></div>
					<div class="view_combo" id="divUnplannedFlag"></div>
					<div class="view_combo" id="divProblemType"></div>
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
			
		</div>
    </div>
</body>
</html>
