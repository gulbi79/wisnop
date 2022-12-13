<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	
	<script type="text/javascript">

	var enterSearchFlag = "Y";
	var searchData = null;
	var search_PLAN_ID = null;
	var wip = {

		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.wipGrid.initGrid();
			this.events();
		},
			
		_siq    : "aps.dynamic.weeklySupplyPlanOrder",
		/*
		* common Code 
		*/
		comCode : {
			codeMapEx : null,			
			codeMap : null,
			
			initCode : function () {
				var grpCd = 'PROD_PART,APS_DEMAND_TYPE,PROCUR_TYPE,FLAG_YN';
				this.codeMap = gfn_getComCode(grpCd, 'Y'); 
				this.codeMapEx = gfn_getComCodeEx(["ROUTING", "REP_CUST_GROUP", "CUST_GROUP" ], null);
			}
		},
		
		initFilter : function() {
			
			gfn_getPlanIdwc({picketType:"W",planTypeCd:"MP"});
			
			gfn_keyPopAddEvent([
				{ target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>' }
			]);
			
			gfn_setMsComboAll([
				{ target : 'divRepCustGroup', id : 'reptCustGroup', title : '<spring:message code="lbl.reptCustGroup"/>', data : this.comCode.codeMapEx.REP_CUST_GROUP, exData:["*"] },
				{ target : 'divCustGroup', id : 'custGroup', title : '<spring:message code="lbl.custGroup"/>', data : this.comCode.codeMapEx.CUST_GROUP, exData:["*"] },
				{ target : 'divProdPart', id : 'prodPart', title : '<spring:message code="lbl.prodPart2"/>', data : this.comCode.codeMap.PROD_PART, exData:[""]},
				{ target : 'divItemGroup', id : 'itemGroup', title : '<spring:message code="lbl.itemGroup"/>', data : "", exData:["*"] },
				{ target : 'divProcurType', id : 'procurType', title : '<spring:message code="lbl.procureType"/>', data : this.comCode.codeMap.PROCUR_TYPE, exData:[""]},
				{ target : 'divRoute', id : 'route', title : '<spring:message code="lbl.routing"/>', data : this.comCode.codeMapEx.ROUTING, exData:["*"] },
				{ target : 'divApsDemandType', id : 'apsDemandType', title : '<spring:message code="lbl.apsDemandType"/>', data : this.comCode.codeMap.APS_DEMAND_TYPE, exData:[""]},
				{ target : 'divEngineYn', id : 'engineYn', title : '<spring:message code="lbl.engineYn"/>', data : this.comCode.codeMap.FLAG_YN, exData:["*"], type : "S"}
			]);
			
			fn_itemGroupList();
			fn_getVersionType();
			
			$("#engineYn").val("Y");
		},
		 
		/* grid  선언
		*/
		wipGrid : {
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
				
				this.grdMain.addCellStyles([{
					id         : "overlapStyle",
					editable   : true,
					background : gv_headerColor
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
				wip.wipGrid.grdMain.cancel();
				wip.wipGrid.dataProvider.rollback(wip.wipGrid.dataProvider.getSavePoints()[0]);
				wip.gridCallback(searchData);
			});
			
			$("#btnSave").on('click', function (e) {
				wip.save();
			});
			
			$("#planId").on("change", function(e) {
				fn_itemGroupList();
			});
			
			this.wipGrid.grdMain.onEditRowChanged = function (grid, itemIndex, dataRow, field, oldValue, newValue){
				grid.commit(true);
				var valFieldName = grid.getDataProvider().getFields()[field].fieldName;
				
				if(valFieldName == "ADJ_CONFIRM_PRIORITY_NM"){
					return;
				}
				
				var prodPart =  grid.getValue(itemIndex, "PROD_PART");
				var repCustGroup =  grid.getValue(itemIndex, "REP_CUST_GROUP_NM");
				var itemGroup =  grid.getValue(itemIndex, "ITEM_GROUP_CD");
				var planWeek =  grid.getValue(itemIndex, "PLAN_WEEK");
				var arrNewValue = [];
				var arrOldValue = [];
				//console.log("grid.getDataProvider().getJsonRows():",grid.getDataProvider().getJsonRows());
				//console.log(itemIndex)
				//wip.wipGrid.grdMain.setValue(itemIndex, field, newValue);
				var rows = grid.getDataProvider().getJsonRows();
				
				$.each(rows, function(n, v) {
					
					//if(v.PROD_PART == prodPart && v.REP_CUST_GROUP_NM == repCustGroup && v.ITEM_GROUP_CD == itemGroup && v.PROD_IN_WEEK == prodInWeek){
					if(v.PROD_PART == prodPart && v.REP_CUST_GROUP_NM == repCustGroup && v.ITEM_GROUP_CD == itemGroup && v.PLAN_WEEK == planWeek){	
						if(v.ADJ_PRIORITY_ITEM_GROUP_NM == newValue){
							arrNewValue.push(n);
						}
						if(v.ADJ_PRIORITY_ITEM_GROUP_NM == oldValue){
							arrOldValue.push(n);
						}
					}
				});
				
				if(arrNewValue.length == 1){
					wip.wipGrid.grdMain.setCellStyles(itemIndex, "ADJ_PRIORITY_ITEM_GROUP_NM", "editStyle");
				}else{
					for(var i = 0; i < arrNewValue.length; i++){
						wip.wipGrid.grdMain.setCellStyles(itemIndex, "ADJ_PRIORITY_ITEM_GROUP_NM", "overlapStyle");
						wip.wipGrid.grdMain.setCellStyles(arrNewValue[i], "ADJ_PRIORITY_ITEM_GROUP_NM", "overlapStyle");
					}
				}
				
				if(arrOldValue.length == 1){
					wip.wipGrid.grdMain.setCellStyles(arrOldValue[0], "ADJ_PRIORITY_ITEM_GROUP_NM", "editStyle");
				}
			};
			
			this.wipGrid.grdMain.onEditRowPasted = function (grid, itemIndex, itemIndex, fields, oldValues, newValues){
				newValues = grid.getValue(itemIndex, "ADJ_PRIORITY_ITEM_GROUP_NM");
				wip.wipGrid.grdMain.onEditRowChanged(grid, itemIndex, itemIndex, fields, oldValues, newValues);
			};
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
					
					//데이터
					if(id == "divPlanId"){
						EXCEL_SEARCH_DATA += $("#planId option:selected").text();
					}else if(id == "divEngineYn"){
						EXCEL_SEARCH_DATA += $("#engineYn option:selected").text();
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
					}else if(id == "divVersionType"){
						EXCEL_SEARCH_DATA += $("#versionType option:selected").text();
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
			FORM_SEARCH.tranData = [{ outDs : "resList", _siq : this._siq }];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						wip.wipGrid.dataProvider.clearRows(); //데이터 초기화
						//그리드 데이터 생성
						wip.wipGrid.grdMain.cancel();
						wip.wipGrid.dataProvider.setRows(data.resList);
						wip.wipGrid.dataProvider.clearSavePoints();
						wip.wipGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(wip.wipGrid.dataProvider.getRowCount());
						searchData = data.resList;
						wip.gridCallback(data.resList);
						gfn_setRowTotalFixed(wip.wipGrid.grdMain);
					}
				}
			}
			
			search_PLAN_ID = $("#planId").val();
			gfn_service(aOption, "obj");
		},
		
		save : function (){
			
			try {
				this.wipGrid.grdMain.commit(true);
			} catch (e) {
				alert('<spring:message code="msg.saveErrorCheck"/>\n'+e.message);
			}
			
			var grdData = gfn_getGrdSavedataAll(this.wipGrid.grdMain);
			var grdDataLen = grdData.length;
			if (grdDataLen == 0) {
				alert('<spring:message code="msg.noChangeData"/>');
				return;
			}
			
			var salesPlanDatas = [];
			var errCheck = true;
			
			$.each(grdData, function(i, row) {
				
				row.ADJ_PRIORITY_ITEM_GROUP_NM = gfn_nvl(row.ADJ_PRIORITY_ITEM_GROUP_NM, "");
				
				var planData = {
					PLAN_ID : search_PLAN_ID,
					PROD_PART : row.PROD_PART,
					ITEM_CD : row.ITEM_CD,
					APS_DEMAND_TYPE : row.APS_DEMAND_TYPE,
					SP_WEEK : row.SP_WEEK,
					ADJ_PRIORITY_ITEM_GROUP : row.ADJ_PRIORITY_ITEM_GROUP_NM,
					ADJ_CONFIRM_PRIORITY : row.ADJ_CONFIRM_PRIORITY_NM,
					DEMAND_ID : row.DEMAND_ID
				};
				
				if(row.ADJ_PRIORITY_ITEM_GROUP_NM == "" || row.ADJ_PRIORITY_ITEM_GROUP_NM == "0"){
					
					errCheck = false;
					alert('<spring:message code="msg.dataCheck1"/>'); 
					var idex = {
					    itemIndex: row._ROWNUM-1,
					    fieldName: 'ADJ_PRIORITY_ITEM_GROUP_NM',
					};
				    wip.wipGrid.grdMain.setCurrent(idex);
					return false;
				}
				
				salesPlanDatas.push(planData);
			});
			
			if(errCheck){
				confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
						
					FORM_SAVE            = {}; //초기화
					FORM_SAVE._mtd       = "saveUpdate";
					FORM_SAVE.tranData   = [
						{outDs : "saveCnt", _siq : wip._siq, grdData : salesPlanDatas},
					];
					
					var ajaxOpt = {
						url     : GV_CONTEXT_PATH + "/biz/obj",
						data    : FORM_SAVE,
						success : function(data) {
							
							alert('<spring:message code="msg.saveOk"/>');
							
							wip.wipGrid.grdMain.cancel();
							
							$.each(grdData, function(i, row) {
								wip.wipGrid.dataProvider.setRowState(row._ROWNUM-1, 'none',true);
							});
							
							wip.wipGrid.dataProvider.clearSavePoints();
							wip.wipGrid.dataProvider.savePoint(); //초기화 포인트 저장
							fn_apply();
						},
					};
					
					gfn_service(ajaxOpt, "obj");
				});
			}
		},
		gridCallback : function (resList) {
			
			var priorityCutOffFlag = gfn_nvl($("#priorityCutOffFlag").val(), "N");
			var priorityCutOffFlagCon = gfn_nvl($("#priorityCutOffFlagCon").val(), "N");
			
			if(priorityCutOffFlag == "N"){ //품목그룹별 순위
				
				$.each(resList, function(n, v){
					
					// 권한에 따라 수정
					if(n == 0){
						var editStyle = {};
						var val = gfn_getDynamicStyle(-2);
						
						editStyle.background = gv_editColor;
						editStyle.editable = true;
						
						val.criteria.push("(values['ADJ_PRIORITY_ITEM_GROUP_YN'] = 'Y')");
						val.styles.push(editStyle);
						
						wip.wipGrid.grdMain.setColumnProperty(wip.wipGrid.grdMain.columnByField("ADJ_PRIORITY_ITEM_GROUP_NM"), "dynamicStyles", [val]);
					} 
					
					if(v.COLOR_FLAG == "Y"){
						wip.wipGrid.grdMain.setCellStyles(n, "ADJ_PRIORITY_ITEM_GROUP_NM", "overlapStyle");
					};
	    		});
			}
			
			if(priorityCutOffFlag == "Y" && priorityCutOffFlagCon == "N"){ //전체 순위 조정
				var editStyle = {};
				var val = gfn_getDynamicStyle(-2);
				
				editStyle.background = gv_editColor;
				editStyle.editable = true;
				
				val.criteria.push("(values['ADJ_CONFIRM_PRIORITY_YN'] = 'Y')");
				val.styles.push(editStyle);
				
				wip.wipGrid.grdMain.setColumnProperty(wip.wipGrid.grdMain.columnByField("ADJ_CONFIRM_PRIORITY_NM"), "dynamicStyles", [val]);
			}
			
		}
	};

	//조회
	var fn_apply = function (sqlFlag) {
		
		var versionType = $("#versionType").val()
		
		if(versionType == "null"){
			alert('<spring:message code="msg.versionTypeMsg"/>');
			return;
		}
		
		gfn_getMenuInit();
		
		DIMENSION.hidden = [];
		DIMENSION.hidden.push({CD : "ADJ_PRIORITY_ITEM_GROUP_YN", dataType : "text"});
		DIMENSION.hidden.push({CD : "ADJ_CONFIRM_PRIORITY_YN", dataType : "text"});
		DIMENSION.hidden.push({CD : "ENGINE_YN_HD", dataType : "text"});
		
    	if(!sqlFlag){
    		wip.wipGrid.gridInstance.setDraw();
		}		
    	
		//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
    	FORM_SEARCH.dimList    = DIMENSION.user;
    	FORM_SEARCH.hiddenList = DIMENSION.hidden;
    	FORM_SEARCH.meaList	   = MEASURE.next;
    	
		if (!sqlFlag) {
			
			var fileds = wip.wipGrid.dataProvider.getFields();
			var filedsLen = fileds.length;
			
			for (var i = 0; i < filedsLen; i++) {
				
				var fieldName = fileds[i].fieldName;
				
				if (fieldName == 'SS_QTY_NM' || fieldName == 'MFG_LT_NM'|| fieldName == 'SALES_PRICE_KRW_NM'|| fieldName == 'APS_PRIORITY_NM'||
					fieldName == 'APS_ADJ_PRIORITY_NM'|| fieldName == 'PRIORITY_ITEM_GROUP_NM'|| fieldName == 'ADJ_PRIORITY_ITEM_GROUP_NM'||
					fieldName == 'MFG_LT_NM' || fieldName == 'ALLOC_WIP_QTY_NM' || fieldName == 'NEW_INPUT_REQ_QTY_NM') {
					fileds[i].dataType = "number";
					fileds[i].numberFormat = "#,##0";
					
					wip.wipGrid.grdMain.setColumnProperty(fieldName, "styles", {"numberFormat" : "#,##0"});	
				}
				if (fieldName == 'PLAN_DATE_NM'){
					fileds[i].dataType = "datetime";
					fileds[i].datetimeFormat = "yyyyMMdd";
					
					wip.wipGrid.grdMain.setColumnProperty(fieldName, "styles", {"datetimeFormat" : "yyyy-MM-dd"});
				}

				//엔진반영여부가 'Y' 일경우 회색처리
		   		var editStyle = {};
				var val = gfn_getDynamicStyle(-2);
				
				editStyle.background = gv_noneEditColor;
				editStyle.editable = false;
				
				val.criteria.push("(values['ENGINE_YN_HD'] = 'N')");
				val.styles.push(editStyle);
				
				wip.wipGrid.grdMain.setColumnProperty(wip.wipGrid.grdMain.columnByField(fieldName), "dynamicStyles", [val]);
			}
			wip.wipGrid.dataProvider.setFields(fileds);
		}
		wip.search();
		wip.excelSubSearch();
	}

	// onload 
	$(document).ready(function() {
		wip.init();
		
		$("#prodPart").on("change", function(e) {
			 var planIdVal = $("#planId").val();
			 var prodPartVal = $.trim($("#prodPart").val());
             if(prodPartVal == undefined ) prodPartVal = null;
		});
		
		wip.wipGrid.grdMain.onKeyUp = function (grid, key, ctrl, shift, alt) {
			if(key == 46){  //Delete Key
				gfn_selBlockDelete(grid,wip.wipGrid.dataProvider);  
		   	}
		};
	});
	
	function fn_getVersionType() {
		
		var params  = {};
		params._mtd = "getList";
		params.tranData = [{outDs : "resList", _siq : "aps.dynamic.versionTypeCd"}];
		
		var opt = {
			url     : GV_CONTEXT_PATH + "/biz/obj",
			data    : params,
			async   : false,
			success : function(data) {
				
				data.resList.unshift({CODE_CD: null, CODE_NM: ""});
				gfn_setMsCombo("versionType", data.resList, [""]);
			}
		};
		gfn_service(opt, "obj");
	}
	
	function fn_itemGroupList(){
		
		FORM_SEARCH          = $("#searchForm").serializeObject(); //초기화
		FORM_SEARCH._mtd     = "getList";
		FORM_SEARCH.tranData = [{ outDs : "getItemGroup", _siq : "aps.dynamic.weeklySupplyPlanOrderItemGroup"}];
		
		gfn_service({
		    async   : false,
		    url     : GV_CONTEXT_PATH + "/biz/obj",
		    data    : FORM_SEARCH,
		    success : function(data) {
		    	gfn_setMsCombo("itemGroup", data.getItemGroup, [""]);
		    }
		},"obj");
	}
	
	function gfn_getPlanIdwc(pOption) {
			
		try {
			
			if ($("#planId").length == 0) {
				return;
			}
			
			var params = $.extend({
				_mtd     : "getList",
				tranData : [{outDs : "rtnList", _siq : "aps.dynamic.weeklySupplyPlanOrderPlanId"}]
			}, pOption);
			
			gfn_service({
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : params,
				async   : false,
				success : function(data) {
					
					gfn_setMsCombo("planId", data.rtnList, [""]);
					
					$("#planId").on("change", function(e) {
						
						var fDs = gfn_getFindDataDsInDs(data.rtnList, {CODE_CD : {VALUE : $(this).val(), CONDI : "="}});
						
						if (fDs.length > 0) {
							
							var nowDate = fDs[0].APS_START_DATE;
							
					        SW_END_DATE = weekdatecal(fDs[0].APS_START_DATE);
						    DATEPICKET(null, nowDate, SW_END_DATE);
						    
							var sdt = gfn_getStringToDate(fDs[0].APS_START_DATE);
							var edt = gfn_getStringToDate(SW_END_DATE);
							
							$("#fromCal").datepicker("option", "minDate", sdt);
							$("#fromCal").datepicker("option", "maxDate", edt);
							$("#toCal").datepicker("option", "maxDate", edt);
							$("#releaseflag").val(fDs[0].RELEASE_FLAG);
							$("#priorityCutOffFlag").val(fDs[0].PRIORITY_CUT_OFF_FLAG);
							$("#priorityCutOffFlagCon").val(fDs[0].PRIORITY_CUT_OFF_FLAG_CON);
						
							var prodPartVal = $.trim($("#prodPart").val());
                            if(prodPartVal == undefined ) prodPartVal = null;
						} 
					});
					$("#planId").trigger("change");
				}
			},"obj");
			
		} catch(e) {console.log(e);}
	}
	
	//6달 뒤 날짜 구함
    function weekdatecal(dt){
    	
    	yyyy = dt.substr(0, 4);
    	mm = dt.substr(4, 2);
    	dd = dt.substr(6, 2);
    	
    	var dt_stamp = new Date(yyyy + "-" + mm + "-" + dd).getTime();
    	
    	var days = ((7 * 53) - 1); 
		    toDt = new Date(dt_stamp+(days*24*60*60*1000));
		var rdt = toDt.getFullYear() + '' + (toDt.getMonth() + 1  < 10 ? '0' + (toDt.getMonth() + 1 ) : toDt.getMonth() + 1 ) + (toDt.getDate() < 10 ? '0' + toDt.getDate() : toDt.getDate());
	    
    	return rdt
    	
    }
	
	</script>

</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="a" class="split content split-horizontal">
		<form id="searchForm" name="searchForm">
		<input type='hidden' id='releaseflag' name='releaseflag'/>
		<input type='hidden' id='priorityCutOffFlag' name='priorityCutOffFlag'/>
		<input type='hidden' id='priorityCutOffFlagCon' name='priorityCutOffFlagCon'/>
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
                    <div class="view_combo" id="divVersionType">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.versionType2"/></div>
							<div class="iptdv borNone">
								<select id="versionType" name="versionType" class="iptcombo"></select>
							</div>
						</div>
					</div>
					<div class="view_combo" id="divRepCustGroup"></div>
					<div class="view_combo" id="divCustGroup"></div>
					<div class="view_combo" id="divProdPart"></div>
                    <div class="view_combo" id="divApsDemandType"></div>
                    <div class="view_combo" id="divProcurType"></div>
                    <div class="view_combo" id="divRoute"></div>
					<div class="view_combo" id="divItemGroup"></div>
					<div class="view_combo" id="divItem"></div>
					<div class="view_combo" id="divEngineYn"></div>
					
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
