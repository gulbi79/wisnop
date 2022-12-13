<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	
	<script type="text/javascript">

	var enterSearchFlag = "Y";
	var searchData = null;
	var search_PLAN_ID = null;
	var search_VERSION_ID = null;
	var dip = {

		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.dipGrid.initGrid();
			this.events();
		},
			
		_siq    : "aps.dynamic.wipHoldingReq",
		/*
		* common Code 
		*/
		comCode : {
			codeMapEx : null,			
			codeMap : null,
			
			initCode : function () {
				var grpCd = 'PROD_PART,PROCUR_TYPE';
				this.codeMap = gfn_getComCode(grpCd, 'N'); 
				this.codeMapEx = gfn_getComCodeEx([ "REP_CUST_GROUP", "CUST_GROUP", "UPPER_ITEM_GROUP", "ITEM_GROUP", "ROUTING" ], null, {itemType : "10,50"});
			}
		},
		
		initFilter : function() {
			
			var itemTypeEvent = {
				childId   : ["upItemGroup"],  
				childData : [this.comCode.codeMapEx.UPPER_ITEM_GROUP, this.comCode.codeMapEx.ROUTING],
				callback  : function() {
					//품목그룹 초기화
					gfn_setMsCombo("itemGroup", [], ["*"]);
				}
			};
			
			//품목대그룹
			var upperItemEvent = {
				childId   : ["itemGroup"],
				childData : [this.comCode.codeMapEx.ITEM_GROUP],
			};
			
			gfn_keyPopAddEvent([
				{ target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>' }
			]);
			
			gfn_setMsComboAll([
				{ target : 'divProdPart', id : 'prodPart', title : '<spring:message code="lbl.prodPart2"/>', data : this.comCode.codeMap.PROD_PART, exData:["*"]},
				{ target : 'divRepCustGroup', id : 'reptCustGroup', title : '<spring:message code="lbl.reptCustGroup"/>', data : this.comCode.codeMapEx.REP_CUST_GROUP, exData:["*"] },
				{ target : 'divCustGroup', id : 'custGroup', title : '<spring:message code="lbl.custGroup"/>', data : this.comCode.codeMapEx.CUST_GROUP, exData:["*"] },
				{ target : 'divUpItemGroup', id : 'upItemGroup',   title : '<spring:message code="lbl.upperItemGroup"/>', data : this.comCode.codeMapEx.UPPER_ITEM_GROUP, exData:["*"], event: upperItemEvent },
				{ target : 'divItemGroup', id : 'itemGroup', title : '<spring:message code="lbl.itemGroup"/>', data : this.comCode.codeMapEx.ITEM_GROUP, exData:["*"] },
				{ target : 'divRoute', id : 'route', title : '<spring:message code="lbl.routing"/>', data : this.comCode.codeMapEx.ROUTING, exData:["*"] },
				{ target : 'divProcurType', id : 'procurType', title : '<spring:message code="lbl.procureType"/>', data : this.comCode.codeMap.PROCUR_TYPE, exData:[""]},
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
					checkBar: { visible : true },
					stateBar: { visible : true },
				});

				this.grdMain.setOptions({
					softDeleting : true
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
			
			$("#btnAddChild").on('click', function (e) {
				dip.addRow();
			});
			
			$("#btnDeleteRows").on('click', function (e) {
				var rows = dip.dipGrid.grdMain.getCheckedRows();
				dip.dipGrid.dataProvider.removeRows(rows, false);
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
					
					
					if(id == "divProdPart"){
						$.each($("#prodPart option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
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
					}else if(id == "divUpItemGroup"){
						$.each($("#upItemGroup option:selected"), function(i2, val2){
							
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
					}else if(id == "divProcurType"){
						$.each($("#procurType option:selected"), function(i2, val2){
							
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
					}
				}
			});
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
			
			gfn_service(aOption, "obj");
		},
		
		save : function() {
			var grdData = gfn_getGrdSavedataAll(this.dipGrid.grdMain);
			
			var grdDataLen = grdData.length;
			if (grdDataLen == 0) {
				alert('<spring:message code="msg.noChangeData"/>');
				return;
			}
			
			confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
				
				FORM_SAVE            = {}; //초기화
				FORM_SAVE._mtd       = "saveAll";
				FORM_SAVE.tranData   = [
					{outDs : "saveCnt", _siq : dip._siq, grdData : grdData, mergeFlag : "Y"}
				];
				
				var ajaxOpt = {
					url     : GV_CONTEXT_PATH + "/biz/obj",
					data    : FORM_SAVE,
					success : function(data) {
						
						alert('<spring:message code="msg.saveOk"/>');
						fn_apply(false);
					},
				};
				
				gfn_service(ajaxOpt, "obj");
			});
		},
		
		gridCallback : function (resList) {
			dip.getReset.resetAdd = [];
			dip.getReset.resetSearch = [];
			dip.getReset.resetPart   = [];
					
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
					
			    	for (var i = 2; i < cols.length; i++) {
			    		var colsNm = cols[i].name;
							
						if(colsNm == "ADJ_PRIORITY_NM"){
							dip.dipGrid.grdMain.setColumnProperty(colsNm,"styles",{background:gv_noneEditColor});
							dip.dipGrid.grdMain.setColumnProperty(colsNm,"zeroText",'');
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
								
								if (fieldName == 'ADJ_PRIORITY_NM' && releaseflag =='N'){
						        	if((menuCd == "APS30701" && prodPart == "LAM") || (menuCd == "APS30702" && prodPart == "TEL") || (menuCd == "APS30703" && prodPart == "DIFFUSION") || (menuCd == "APS30704" && prodPart == "MATERIAL")){
						        		dip.dipGrid.grdMain.setCellStyles(n, fieldName, "editStyle");
					    			}
								}
							}
			    		});
			    	}
					/* alert(); */
					$.each(resList, function(n, v){
		    			
		    			var prodPart = v.PART_CD;
		    			var useValue = v.USE_YN;
		    			
						for (var i = 2; i < cols.length; i++) {
							
							var colsName = cols[i].name;
							if (colsName == 'HOLD_DATE_NM' || colsName == 'HOLD_REASON_NM' || colsName == 'REQ_USER_NM_NM'){
								dip.dipGrid.grdMain.setCellStyles(n, colsName, "editStyle");
							}
						}
		    		});
				   
				    dip.dipGrid.grdMain.setColumnProperty("HOLD_DATE_NM", "styles",{textAlignment : "center", background : gv_noneEditColor, datetimeFormat : "yyyy-MM-dd"});
				    dip.dipGrid.grdMain.setColumnProperty("HOLD_DATE_NM", "zeroText", '');
				    dip.dipGrid.grdMain.setColumnProperty("HOLD_DATE_NM", "editor", {
				    	type : "date", 
						mask : {editMask : "99999999", placeHolder : "yyyyMMdd", includedFormat : true}, 
						datetimeFormat : "yyyyMMdd",
						minDate : getAddDay(0)
   					});
				    dip.dipGrid.grdMain.setColumnProperty("HOLD_REASON_NM", "editor", {maxLength : 50});
				    dip.dipGrid.grdMain.setColumnProperty("REQ_USER_NM_NM", "editor", {maxLength : 20});
		    	}
			}, "obj");
		},
		
		addRow : function() {
			gfn_comPopupOpen("WORK_ORDER_NO", {
				callback : "fnAddItemCallback",
				item_type : "10",
				item_type_disabled : "disable"
			});
		},
		
		getReset : {
			resetAdd    : [],
			resetSearch : [],
			resetPart   : []
		}
		
	};
	
	function fnAddItemCallback(returnData) {
		var rowCnt = dip.dipGrid.dataProvider.getRowCount();
		
		dip.dipGrid.dataProvider.clearSavePoints();
		
		$.each(returnData, function(n, v) {
			var rowAddData = {
				ITEM_CD_NM : v.ITEM_CD,
				ITEM_NM_NM : v.ITEM_NM_NM,
				UPPER_ITEM_GROUP_NM_NM : v.UPPER_ITEM_GROUP_NM,
				PROD_ORDER_NO_NM : v.PROD_ORDER_NO,
				ORDER_STATUS_NM : v.ORDER_STATUS_NM,
				PROD_ORDER_QTY_NM : v.PROD_ORDER_QTY,
				REMAIN_QTY_NM : v.REMAIN_QTY
			};
			dip.dipGrid.dataProvider.insertRow(rowCnt + n, rowAddData);
			dip.getReset.resetAdd.push(rowCnt + n);
			var date = new Date();
			var nowDate = date.getFullYear() + '' + (date.getMonth() + 1 < 10 ? '0' + (date.getMonth() + 1) : date.getMonth() + 1) + (date.getDate() < 10 ? '0' + date.getDate() : date.getDate());
			dip.dipGrid.grdMain.setValue(rowCnt + n, "HOLD_DATE_NM", nowDate);
		});
		
		dip.dipGrid.dataProvider.savePoint(); //초기화 포인트 저장
		
		dip.dipGrid.grdMain.setCellStyles(dip.getReset.resetAdd, "HOLD_DATE_NM", "editStyle");
		dip.dipGrid.grdMain.setCellStyles(dip.getReset.resetAdd, "HOLD_REASON_NM", "editStyle");
		dip.dipGrid.grdMain.setCellStyles(dip.getReset.resetAdd, "REQ_USER_NM_NM", "editStyle"); 
	}
	

	//조회
	var fn_apply = function (sqlFlag) {
		
		// 디멘젼, 메져
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
				if (fileds[i].fieldName == 'CREATE_DTTM_NM') {
					fileds[i].dataType = "datetime";
					fileds[i].datetimeFormat = "yyyy-MM-dd HH:mm:ss";
					dip.dipGrid.grdMain.setColumnProperty(fileds[i].fieldName, "styles", {"datetimeFormat" : "yyyy-MM-dd HH:mm:ss"});
				}
				dip.dipGrid.dataProvider.setFields(fileds);
			}
		}
		dip.search();
		dip.excelSubSearch();
	}
	
	function getAddDay(days) {
		var date = new Date();
		date.setDate(date.getDate() + days);
		return date;
	}

	// onload 
	$(document).ready(function() {
		dip.init();
		
		$("#prodPart").on("change", function(e) {			
			 var prodPartVal = $.trim($("#prodPart").val());
             if(prodPartVal == undefined ) prodPartVal = null;			
		});
		
		dip.dipGrid.grdMain.onKeyUp = function (grid, key, ctrl, shift, alt) {
		   if(key == 46){  //Delete Key
			  gfn_selBlockDelete(grid,dip.dipGrid.dataProvider);  
		   }
		};
	});
	
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
					<div class="view_combo" id="divProdPart"></div>
					<input type='hidden' id='releaseflag' name='releaseflag'>
					<div class="view_combo" id="divRepCustGroup"></div>
					<div class="view_combo" id="divCustGroup"></div>
					<div class="view_combo" id="divUpItemGroup"></div>
					<div class="view_combo" id="divItemGroup"></div>
                    <div class="view_combo" id="divRoute"></div>
                    <div class="view_combo" id="divProcurType"></div>
					<div class="view_combo" id="divItem"></div>
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
					<a id="btnAddChild" href="#" class="app1 roleWrite"><spring:message code="lbl.add"/></a>
					<a id="btnDeleteRows" href="#" class="app1 roleWrite"><spring:message code="lbl.delete"/></a>
					<a href="javascript:;" id="btnSave" class="app2 roleWrite"><spring:message code="lbl.save" /></a>
				</div>
			</div>
		</div>
    </div>
</body>
</html>
