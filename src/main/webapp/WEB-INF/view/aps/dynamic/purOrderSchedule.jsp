<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	
	<script type="text/javascript">

	var enterSearchFlag = "Y";
	var purOrderSchedule = {

		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.purOrderSchedGrid.initGrid();
			this.events();
		},
			
		_siq    : "aps.dynamic.purOrderSchedule",
		/*
		* common Code 
		*/
		comCode : {
			codeMapEx : null,			
			codeMap : null,
			
			initCode : function () {
				var grpCd = 'ITEM_TYPE,PROCUR_TYPE,FLAG_YN,MATERIAL_ARRIVAL_TYPE';
				this.codeMap = gfn_getComCode(grpCd, 'N'); 
				this.codeMapEx = gfn_getComCodeEx(["REP_CUST_GROUP", "CUST_GROUP", "ROUTING", "ITEM_GROUP", "UPPER_ITEM_GROUP"], null, {itemType : "20,30"});
				
			}
		},
		
		initFilter : function() {
			
			var itemTypeEvent = {
				childId   : ["upItemGroup"],  
				childData : [this.comCode.codeMapEx.UPPER_ITEM_GROUP, this.comCode.codeMapEx.ROUTING],
				
			};
	    	
	    	//품목대그룹
			var upperItemEvent = {
				childId   : ["itemGroup"],
				childData : [this.comCode.codeMapEx.ITEM_GROUP],
			};
			
			gfn_keyPopAddEvent([
				{ target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>' },
			]);
			
			gfn_setMsComboAll([
				{ target : 'divProcurType'  , id : 'procurType',    title : '<spring:message code="lbl.procureType"/>',        data : this.comCode.codeMap.PROCUR_TYPE, exData:[""]},
				{ target : 'divUpItemGroup' , id : 'upItemGroup',   title : '<spring:message code="lbl.upperItemGroup"/>', data : this.comCode.codeMapEx.UPPER_ITEM_GROUP, exData:["*"], event: upperItemEvent, option: {allFlag:"Y"} },
				{ target : 'divItemGroup'   , id : 'itemGroup'    , title : '<spring:message code="lbl.itemGroup"/>'    , data : this.comCode.codeMapEx.ITEM_GROUP,     exData:["*"] },
				{ target : 'divMaterialArrivalType'   , id : 'materialArrivalType'    , title : '<spring:message code="lbl.schedType"/>'  , data : this.comCode.codeMap.MATERIAL_ARRIVAL_TYPE,  exData:["*"] },
				{ target : 'divItemType'    , id : 'itemType', title : '<spring:message code="lbl.itemType"/>', data : this.comCode.codeMap.ITEM_TYPE, exData:[""], event : itemTypeEvent, option: {allFlag:"Y"}},
				
			]);
			
			var nowDt = new Date();
		    
			var dt_stamp = nowDt.getTime();
		    var days = (7 * 53); //4주전 일요일
		    var weekday = nowDt.getDay();
		    days = days + weekday;
		    toDt = new Date(dt_stamp - (days * 24 * 60 * 60 * 1000));
		    var startDt = toDt.getFullYear() + '' + (toDt.getMonth() + 1 < 10 ? '0' + (toDt.getMonth() + 1) : toDt.getMonth() + 1) + (toDt.getDate() < 10 ? '0' + toDt.getDate() : toDt.getDate());
		    
		    fromDt = new Date(dt_stamp+(((7 * 52) + (6 - weekday)) * 24 * 60 * 60 * 1000)); // 1주 후 토요일
		    var endDt = fromDt.getFullYear() + '' + (fromDt.getMonth() + 1 < 10 ? '0' + (fromDt.getMonth() + 1) : fromDt.getMonth() + 1) + (fromDt.getDate() < 10 ? '0' + fromDt.getDate() : fromDt.getDate());
		    DATEPICKET(null, startDt, endDt);
		    
		    var dateParam = {
				arrTarget : [
					{calId : "fromCal2", weekId : "fromWeek2", defVal : 0}
				]
			};
			DATEPICKET(dateParam);
			//$('#fromCal2').datepicker("option", "maxDate", new Date().getWeekDay(0, false));
			
			dayDate();
		},
		
		/* 
		* grid  선언
		*/
		purOrderSchedGrid : {
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
			},
		},
		
		fn_setFields : function (dataProvider) {
		   
			var fields = [
				{ fieldName : "ITEM_CD" , dataType : 'text' },
				{ fieldName : "ITEM_NM" , dataType : 'text' },
				{ fieldName : "SPEC" , dataType : 'text' },
				{ fieldName : "ITEM_TYPE" , dataType : 'text' },
				{ fieldName : "PROCUR_TYPE" , dataType : 'text' },
				{ fieldName : "SALES_PRICE_KRW" , dataType : 'number' },
				{ fieldName : "PUR_LT" , dataType : 'number' },
				{ fieldName : "ITEM_GROUP_CD" , dataType : 'text' },
				{ fieldName : "ITEM_GROUP_NM" , dataType : 'text' },
				{ fieldName : "SS_QTY" , dataType : 'number' },
				{ fieldName : "PO_NO" , dataType : 'text' },
				{ fieldName : "CUST_CD" , dataType : 'text' },
				{ fieldName : "CUST_NM" , dataType : 'text' },
				{ fieldName : "PO_TYPE_NM" , dataType : 'text' },
				{ fieldName : "BASE_UOM_CD" , dataType : 'text' },
				{ fieldName : "PO_QTY" , dataType : 'number' },
				{ fieldName : "CC_QTY" , dataType : 'number' },
				{ fieldName : "BL_QTY" , dataType : 'number' },
				{ fieldName : "RCPT_QTY" , dataType : 'number' },
				{ fieldName : "BLC_QTY" , dataType : 'number' },
				{ fieldName : "SEQ" , dataType : 'text' },
				{ fieldName : "SCHED_DATE" , dataType : 'text' },
				{ fieldName : "SCHED_QTY" , dataType : 'number' }
			];
			dataProvider.setFields(fields);
		},
		
		fn_setColumns : function(grdMain){
			var columns = [
				{
					name         : "ITEM_CD",
					fieldName    : "ITEM_CD",
					editable     : false,
					header       : { text: '<spring:message code="lbl.itemCd"/>' },
					styles       : { textAlignment: "near", background : "rgba(237, 247, 253, 1)" },
					width        : 80,
					mergeRule    : { criteria: "value" },
					visible      : true
				},
				{
					name         : "ITEM_NM",
					fieldName    : "ITEM_NM",
					editable     : false,
					header       : { text: '<spring:message code="lbl.itemName"/>' },
					styles       : { textAlignment: "near", background : "rgba(237, 247, 253, 1)" },
					width        : 200,
					mergeRule    : { criteria: "prevvalues + value" },
					visible      : true
				},
				{
					name         : "SPEC",
					fieldName    : "SPEC",
					editable     : false,
					header       : { text: '<spring:message code="lbl.spec"/>' },
					styles       : { textAlignment: "near", background : "rgba(237, 247, 253, 1)" },
					width        : 220,
					mergeRule    : { criteria: "prevvalues + value" },
					visible      : true
				},
				{
					name         : "ITEM_TYPE",
					fieldName    : "ITEM_TYPE",
					editable     : false,
					header       : { text: '<spring:message code="lbl.itemType"/>' },
					styles       : { textAlignment: "near", background : "rgba(237, 247, 253, 1)" },
					width        : 70,
					mergeRule    : { criteria: "prevvalues + value" },
					visible      : true
				},
				{
					name         : "PROCUR_TYPE",
					fieldName    : "PROCUR_TYPE",
					editable     : false,
					header       : { text: '<spring:message code="lbl.procureType"/>' },
					styles       : { textAlignment: "near", background : "rgba(237, 247, 253, 1)" },
					width        : 70,
					mergeRule    : { criteria: "prevvalues + value" },
					visible      : true
				},
				{
					name         : "SALES_PRICE_KRW",
					fieldName    : "SALES_PRICE_KRW",
					editable     : false,
					header       : { text: '<spring:message code="lbl.salesPrice"/>' },
					styles       : { textAlignment: "far", background : "rgba(237, 247, 253, 1)" ,numberFormat : "#,##0"},
					width        : 70,
					mergeRule    : { criteria: "prevvalues + value" },
					visible      : true
				},
				{
					name         : "PUR_LT",
					fieldName    : "PUR_LT",
					editable     : false,
					header       : { text: '<spring:message code="lbl.purLt"/>' },
					styles       : { textAlignment: "center", background : "rgba(237, 247, 253, 1)" ,numberFormat : "#,##0"},
					width        : 70,
					mergeRule    : { criteria: "prevvalues + value" },
					visible      : true
				},
				{
					name         : "ITEM_GROUP_CD",
					fieldName    : "ITEM_GROUP_CD",
					editable     : false,
					header       : { text: '<spring:message code="lbl.itemGroupCd"/>' },
					styles       : { textAlignment: "near", background : "rgba(237, 247, 253, 1)" },
					width        : 80,
					mergeRule    : { criteria: "prevvalues + value" },
					visible      : true
				},
				{
					name         : "ITEM_GROUP_NM",
					fieldName    : "ITEM_GROUP_NM",
					editable     : false,
					header       : { text: '<spring:message code="lbl.itemGroupName"/>' },
					styles       : { textAlignment: "near", background : "rgba(237, 247, 253, 1)" },
					width        : 120,
					mergeRule    : { criteria: "prevvalues + value" },
					visible      : true
				},
				{
					name         : "SS_QTY",
					fieldName    : "SS_QTY",
					editable     : false,
					header       : { text: '<spring:message code="lbl.safetyInv"/>' },
					styles       : { textAlignment: "far", background : "rgba(237, 247, 253, 1)",numberFormat : "#,##0" },
					width        : 60,
					mergeRule    : { criteria: "prevvalues + value" },
					visible      : true
				},
				{
					name         : "PO_NO",
					fieldName    : "PO_NO",
					editable     : false,
					header       : { text: '<spring:message code="lbl.poNo"/>' },
					styles       : { textAlignment: "near", background : "rgba(237, 247, 253, 1)" },
					width        : 120,
					visible      : true
				},
				{
					name         : "CUST_CD",
					fieldName    : "CUST_CD",
					editable     : false,
					header       : { text: '<spring:message code="lbl.customerCd"/>' },
					styles       : { textAlignment: "near", background : "rgba(237, 247, 253, 1)" },
					width        : 80,
					visible      : true
				},
				{
					name         : "CUST_NM",
					fieldName    : "CUST_NM",
					editable     : false,
					header       : { text: '<spring:message code="lbl.customerNm"/>' },
					styles       : { textAlignment: "near", background : "rgba(237, 247, 253, 1)" },
					width        : 80,
					visible      : true
				},
				{
					name         : "PO_TYPE_NM",
					fieldName    : "PO_TYPE_NM",
					editable     : false,
					header       : { text: '<spring:message code="lbl.poTypeNm"/>' },
					styles       : { textAlignment: "near", background : "rgba(237, 247, 253, 1)" },
					width        : 80,
					visible      : true
				},
				{
					name         : "BASE_UOM_CD",
					fieldName    : "BASE_UOM_CD",
					editable     : false,
					header       : { text: '<spring:message code="lbl.baseUomCd"/>' },
					styles       : { textAlignment: "center", background : "rgba(237, 247, 253, 1)" },
					width        : 60,
					visible      : true
				},
				{
					name         : "PO_QTY",
					fieldName    : "PO_QTY",
					editable     : false,
					header       : { text: '<spring:message code="lbl.poQty2"/>' },
					styles       : { textAlignment: "far", background : "rgba(237, 247, 253, 1)",numberFormat : "#,##0" },
					width        : 80,
					visible      : true
				},
				{
					name         : "CC_QTY",
					fieldName    : "CC_QTY",
					editable     : false,
					header       : { text: '<spring:message code="lbl.ccQty"/>' },
					styles       : { textAlignment: "far", background : "rgba(237, 247, 253, 1)" ,numberFormat : "#,##0"},
					width        : 80,
					visible      : true
				},
				{
					name         : "BL_QTY",
					fieldName    : "BL_QTY",
					editable     : false,
					header       : { text: '<spring:message code="lbl.blQty"/>' },
					styles       : { textAlignment: "far", background : "rgba(237, 247, 253, 1)",numberFormat : "#,##0" },
					width        : 80,
					visible      : true
				},
				{
					name         : "RCPT_QTY",
					fieldName    : "RCPT_QTY",
					editable     : false,
					header       : { text: '<spring:message code="lbl.expQty"/>' },
					styles       : { textAlignment: "far", background : "rgba(237, 247, 253, 1)" ,numberFormat : "#,##0" },
					width        : 80,
					visible      : true
				},
				{
					name         : "BLC_QTY",
					fieldName    : "BLC_QTY",
					editable     : false,
					header       : { text: '<spring:message code="lbl.blcQty"/>' },
					styles       : { textAlignment: "far", background : "rgba(237, 247, 253, 1)",numberFormat : "#,##0" },
					width        : 80,
					visible      : true
				},
				{
					name         : "SEQ",
					fieldName    : "SEQ",
					editable     : false,
					header       : { text: '<spring:message code="lbl.schedSeq"/>' },
					styles       : { textAlignment: "near", background : "rgba(237, 247, 253, 1)" },
					width        : 80,
					visible      : true
				},
				{
					name         : "SCHED_DATE",
					fieldName    : "SCHED_DATE",
					editable     : false,
					header       : { text: '<spring:message code="lbl.schedDate"/>' },
					styles       : { textAlignment: "center", background : "rgba(237, 247, 253, 1)" },
					width        : 80,
					visible      : true
				},
				{
					name         : "SCHED_QTY",
					fieldName    : "SCHED_QTY",
					editable     : false,
					header       : { text: '<spring:message code="lbl.schedQty"/>' },
					styles       : { textAlignment: "center", background : "rgba(237, 247, 253, 1)" ,numberFormat : "#,##0"},
					width        : 80,
					visible      : true
				}
			];
			grdMain.setColumns(columns);
		},
		
		/*
		* event 정의
		*/
		events : function () {
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
		}
	};
	
	//조회
	function fn_apply(sqlFlag) {
		
		gfn_getMenuInit();
		
    	if(!sqlFlag){
    		purOrderSchedule.purOrderSchedGrid.gridInstance.setDraw();
		}
		
		//조회조건 설정
		FORM_SEARCH = $("#searchForm").serializeObject();
		FORM_SEARCH.sql        = sqlFlag;
    	FORM_SEARCH.dimList    = DIMENSION.user;
    	FORM_SEARCH.hiddenList = DIMENSION.hidden;
    	FORM_SEARCH.meaList	   = MEASURE.next;
    	
        if (!sqlFlag) {
			
			var fileds = purOrderSchedule.purOrderSchedGrid.dataProvider.getFields();
			
			for (var i = 0; i < fileds.length; i++) {
				if (fileds[i].fieldName == 'SS_QTY_NM' || fileds[i].fieldName == 'MFG_LT_NM'|| fileds[i].fieldName == 'PUR_LT_NM'|| fileds[i].fieldName == 'REMAIN_QTY_NM'||
					fileds[i].fieldName == 'SCHED_QTY_NM'|| fileds[i].fieldName == 'SALES_PRICE_KRW_NM') {
					
					fileds[i].dataType = "number";
					fileds[i].numberFormat = "#,##0";
					
					purOrderSchedule.purOrderSchedGrid.grdMain.setColumnProperty(fileds[i].fieldName, "styles", {"numberFormat" : "#,##0"});	
				}
				if (fileds[i].fieldName == 'HANDOVER_DATE_NM' || fileds[i].fieldName == 'ORIGINAL_DATE_NM' || fileds[i].fieldName == 'SCHED_DATE_NM' || fileds[i].fieldName == 'PO_DATE_NM'
					|| fileds[i].fieldName == "SCHED_DATE_PRE_RECV_NM" || fileds[i].fieldName == "SCHED_DATE_ORG_NM"){
					fileds[i].dataType = "datetime";
					fileds[i].datetimeFormat = "yyyyMMdd";
					
					purOrderSchedule.purOrderSchedGrid.grdMain.setColumnProperty(fileds[i].fieldName, "styles", {"datetimeFormat" : "yyyy-MM-dd"});
				}
			}
			purOrderSchedule.purOrderSchedGrid.dataProvider.setFields(fileds);
		}
    	
		//그리드 데이터 조회
		fn_getGridData(sqlFlag);
		fn_getExcelData();
	}

	//그리드 데이터 조회
	function fn_getGridData(sqlFlag) {
		
		FORM_SEARCH.sql	     = sqlFlag;
		FORM_SEARCH._mtd     = "getList";
		FORM_SEARCH.tranData = [{outDs:"rtnList",_siq:"aps.dynamic.purOrderSchedule"}];
		
		gfn_service({
			url    : GV_CONTEXT_PATH + "/biz/obj.do",
			data   : FORM_SEARCH,
			success: function(data) {
				//그리드 데이터 삭제
				purOrderSchedule.purOrderSchedGrid.dataProvider.clearRows();
				purOrderSchedule.purOrderSchedGrid.grdMain.cancel();
				//그리드 데이터 생성
				purOrderSchedule.purOrderSchedGrid.dataProvider.setRows(data.rtnList);
				//그리드 초기화 포인트 저장
				purOrderSchedule.purOrderSchedGrid.dataProvider.clearSavePoints();
				purOrderSchedule.purOrderSchedGrid.dataProvider.savePoint();
				// 그리드 데이터 건수 출력
				gfn_setSearchRow(purOrderSchedule.purOrderSchedGrid.dataProvider.getRowCount());
				
			}
		}, "obj");
	}
	
	function dayDate(){
		
		var params  = {};
		params._mtd = "getList";
		params.tranData = [{outDs : "resList", _siq : "aps.planResult.commonDay"}];
		
		var opt = {
			url     : GV_CONTEXT_PATH + "/biz/obj.do",
			data    : params,
			async   : false,
			success : function(data) {
				var list = data.resList;
				var listLen = list.length;
				
				for(var i = 0; i < listLen; i++){
					
					var codeCd = list[i].CODE_CD;
					var attb1Cd = list[i].ATTB_1_CD;
					
					setDayDeat(codeCd, attb1Cd);
				}
			    var d = new Date();
			    var dayOfMonth = d.getDate();
			    d.setDate(dayOfMonth - 21);
			    var d1 = new Date();
			  
			    $("#fromCal2").datepicker("option", "minDate", d);
			    $("#fromCal2").datepicker("option", "maxDate", d1);
			}
		};
		gfn_service(opt, "obj");
	}
	
	function setDayDeat(type, val){
		var paramFrom = $("#swFromDate").val().replace("-", "");
		var paramTo = $("#swToDate").val().replace("-", "");
		
		var dataFrom = paramFrom.substring(0, 4) + "/" + paramFrom.substring(4, 6) + "/" + paramFrom.substring(6, 8);
		var dataTo = paramTo.substring(0, 4) + "/" + paramTo.substring(4, 6) + "/" + paramTo.substring(6, 8);
		
		var date = new Date(dataFrom);
		var date2 = new Date(dataTo);
		
		date.setDate(date.getDate() + Number(val));
	    date2.setDate(date2.getDate() + Number(val));
	    
	    		
		var year = date.getFullYear();
	    var month = date.getMonth() + 1;
	    var day = date.getDate();
	    
	    var year2 = date2.getFullYear();
	    var month2 = date2.getMonth() + 1;
	    var day2 = date2.getDate();
	    
	    if(month < 10){
	    	month = "0" + month;
	    }
	    
	    if(day < 10){
	    	day = "0" + day;
	    }
	    
	    if(month2 < 10){
	    	month2 = "0" + month2;
	    }
	    
	    if(day2 < 10){
	    	day2 = "0" + day2;
	    }
	    
	}
	
	function fn_getExcelData(){
		
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
				
				if(id == "divStandDate"){
					EXCEL_SEARCH_DATA += $("#fromCal2").val() + "(" + $("#fromWeek2").val() + ")";
				}else if(id == "divItem"){
					EXCEL_SEARCH_DATA += $("#item_nm").val();
				}else if(id == "divPoNo"){
					EXCEL_SEARCH_DATA += $("#poNo").val();
				}else if(id == "divMaterialArrivalType"){
					$.each($("#materialArrivalType option:selected"), function(i2, val2){
						
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
				}else if(id == "divItemType"){
					$.each($("#itemType option:selected"), function(i2, val2){
						
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
				}else if(id == "divCustomer"){
					EXCEL_SEARCH_DATA += $("#customer").val();
				}
			}
		});
		
		EXCEL_SEARCH_DATA += "\n" + '<spring:message code="lbl.period"/>' + " : ";
		EXCEL_SEARCH_DATA += $("#fromCal").val() + "(" + $("#fromPWeek").val() + ") ~ ";
		EXCEL_SEARCH_DATA += $("#toCal").val() + "(" + $("#toPWeek").val() + ")";

	}
	
	// onload 
	$(document).ready(function() {
		purOrderSchedule.init();
		
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
					<div class="view_combo" id="divStandDate">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.standDate"/></div>
							<input type="text" id="fromCal2" name="fromCal2" class="iptdate datepicker2" onchange="javascript:dayDate();"/>
							<input type="text" id="fromWeek2" name="fromWeek2" class="iptdateweek" disabled="disabled" value=""/>
						</div>
					</div>
					<div class="view_combo" id="divItem"></div>
					<div class="view_combo" id="divPoNo">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.poNo" /></div>
							<input type="text" id="poNo" name="poNo" class="ipt">
						</div>
					</div>
					<div class="view_combo" id="divMaterialArrivalType"></div>
					<div class="view_combo" id="divProcurType"></div>
					<div class="view_combo" id="divItemType"></div>
					<div class="view_combo" id="divUpItemGroup"></div>
					<div class="view_combo" id="divItemGroup"></div>
					<div class="view_combo" id="divCustomer">
					   <div class="ilist">
							<div class="itit"><spring:message code="lbl.customer2"/></div>
							<input type="text" id="customer" name="customer" class="ipt">
						</div>
					</div>
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
