<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	<!-- 일별판매생산현황 -->
	<script type="text/javascript">
	
	var enterSearchFlag = "Y";
	var dailySalesProd = {
		
		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.dailySalesProdGrid.initGrid();
		},
			
		_siq    : "supply.product.dailySalesProdList",
		
		initFilter : function() {
			
			
			var itemTypeEvent = {
				childId   : ["upItemGroup","route"],  
				childData : [this.comCode.codeMapEx.UPPER_ITEM_GROUP, this.comCode.codeMapEx.ROUTING]
				
			};
	    	
	    	//품목대그룹
			var upperItemEvent = {
				childId   : ["itemGroup"],
				childData : [this.comCode.codeMapEx.ITEM_GROUP],
			};
			
			// 키워드팝업
			gfn_keyPopAddEvent([
				{ target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>' }
			]);
			
			// 콤보박스
			gfn_setMsComboAll([
				{target : 'divProcurType',   id : 'procurType',    title : '<spring:message code="lbl.procure"/>',        data : this.comCode.codeMap.PROCUR_TYPE, exData:[""]},
				{target : 'divItemType',     id : 'itemType',      title : '<spring:message code="lbl.itemType"/>',       data : this.comCode.codeMap.ITEM_TYPE, exData:["*"], event : itemTypeEvent},
				{target : 'divUpItemGroup',  id : 'upItemGroup',   title : '<spring:message code="lbl.upperItemGroup"/>', data : this.comCode.codeMapEx.UPPER_ITEM_GROUP, exData:["*"], event: upperItemEvent },
				{target : 'divItemGroup',    id : 'itemGroup',     title : '<spring:message code="lbl.itemGroup"/>',      data : this.comCode.codeMapEx.ITEM_GROUP, exData:["*"]},
				{target : 'divRoute',        id : 'route',         title : '<spring:message code="lbl.routing"/>',        data : this.comCode.codeMapEx.ROUTING, exData:["*"]},
				{target : 'divRepCustGroup', id : 'reptCustGroup', title : '<spring:message code="lbl.reptCustGroup"/>',  data : this.comCode.codeMapEx.REP_CUST_GROUP, exData:["*"]},
				{target : 'divCustGroup',    id : 'custGroup',     title : '<spring:message code="lbl.custGroup"/>',      data : this.comCode.codeMapEx.CUST_GROUP, exData:["*"]},
				{target : 'divDailyCdSales', id : 'dailyCdSales',  title : '<spring:message code="lbl.progressSales"/>',       data : this.comCode.codeMap.DAILY_CD, exData:["*"], type : "S"},
				{target : 'divDailyCdProd',  id : 'dailyCdProd',   title : '<spring:message code="lbl.progressProd"/>',       data : this.comCode.codeMap.DAILY_CD, exData:["*"], type : "S"},
			]);
			
			var dateParam = {
				arrTarget : [
					{calId : "fromCal", weekId : "fromWeek", defVal : 0}
				]
			};
			DATEPICKET(dateParam);
			$('#fromCal').datepicker("option", "maxDate", new Date().getWeekDay(0, false));
			
			dayDate();
		},
		
		/*
		* common Code 
		*/
		comCode : {
			codeMap : null,
			codeMapEx : null,
			
			initCode : function () {
				var grpCd    = 'MONTH_TYPE_MINUS,MONTH_TYPE_PLUS,ITEM_TYPE,CHANGE_AREA,PROCUR_TYPE,DAILY_CD';
				this.codeMap = gfn_getComCode(grpCd, 'Y'); //공통코드 조회
				this.codeMapEx = gfn_getComCodeEx(["REP_CUST_GROUP", "CUST_GROUP", "UPPER_ITEM_GROUP", "ITEM_GROUP", "ROUTING"], null, {itemType : "10,50" });
				
				this.codeMap.ITEM_TYPE = $.grep(this.codeMap.ITEM_TYPE, function(v,n) {
					return v.CODE_CD == '10' || v.CODE_CD == '50'; 
				});
			},
		},
	
		/* 
		* grid  선언
		*/
		dailySalesProdGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				this.gridInstance.custNextBucketFalg = true;
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				
				gfn_setMonthSum(dailySalesProd.dailySalesProdGrid.gridInstance, false, false, true);
			}
		},
	
		/*
		* event 정의
		*/
		events : function () {
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
		},
		
		excelSubSearch : function (){
			
			$.each($(".view_combo"), function(i, val){
				
				var temp = "";
				var id = gfn_nvl($(this).attr("id"), "");
				
				if(id != ""){
					
					var name = gfn_nvl($("#" + id + " .ilist .itit").html(), "");
					
					if(name == ""){
						name = gfn_nvl($("#" + id + " .filter_tit").html(), "");
					}
					
					//타이틀
					if(i == 0){
						EXCEL_SEARCH_DATA = name + " : ";	
					}else{
						EXCEL_SEARCH_DATA += "\n" + name + " : ";	
					}
					
					//데이터
					if(id == "divItem"){
						EXCEL_SEARCH_DATA += $("#item_nm").val();
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
					}else if(id == "divDailyCd"){
						EXCEL_SEARCH_DATA += $("#dailyCd option:selected").text();
					}else if(id == "divDailyCdSales"){
						EXCEL_SEARCH_DATA += $("#dailyCdSales option:selected").text();
					}else if(id == "divDailyCdProd"){
						EXCEL_SEARCH_DATA += $("#dailyCdProd option:selected").text();
					}
				}
			});
			
			EXCEL_SEARCH_DATA += "\n" + '<spring:message code="lbl.weekDim"/>' + " : ";
			EXCEL_SEARCH_DATA += $("#fromCal").val() + "(" + $("#fromWeek").val() + ")";
			
		},
		
		// 조회
		search : function () {
			
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq }];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj.do",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						dailySalesProd.dailySalesProdGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						dailySalesProd.dailySalesProdGrid.grdMain.cancel();
						
						dailySalesProd.dailySalesProdGrid.dataProvider.setRows(data.resList);
						dailySalesProd.dailySalesProdGrid.dataProvider.clearSavePoints();
						dailySalesProd.dailySalesProdGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_actionMonthSum(dailySalesProd.dailySalesProdGrid.gridInstance);
						gfn_setRowTotalFixed(dailySalesProd.dailySalesProdGrid.grdMain);
						
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		getBucket : function (sqlFlag) {
			
			var ajaxMap = {
				fromDate : gfn_replaceAll($("#salesFromDate").val(), "-", ""),
				toDate   : gfn_replaceAll($("#salesToDate").val(), "-", ""),
	       		week     : {isDown: "Y", isUp:"N", upCal:"M", isMt:"N", isExp:"N", expCnt:1},
	       		day      : {isDown: "N", isUp:"Y", upCal:"W", isMt:"N", isExp:"N", expCnt:999}, 
				sqlId    : ["bucketWeek", "bucketDay"]
			};
			
			gfn_getBucket(ajaxMap);
			
			var bucketLen = BUCKET.query.length;
			
			for(var i = 0; i < bucketLen; i++){
				BUCKET.query[i].CD_SUB1 = ("SALES_DAY" + i);
			}
			
			BUCKET.query.unshift({BUCKET_ID : "S_QTY", BUCKET_TYPE : "", BUCKET_VAL : "S_QTY", CD : "S_QTY", NM : "수량", ROOT_CD : "", TYPE : "group"});
			BUCKET.query.unshift({BUCKET_ID : "S_AMT", BUCKET_TYPE : "", BUCKET_VAL : "S_AMT", CD : "S_AMT", NM : "금액", ROOT_CD : "", TYPE : "group"});
			BUCKET.query.push({BUCKET_ID : "S_TOT_QTY", BUCKET_TYPE : "", BUCKET_VAL : "S_TOT_QTY", CD : "S_TOT_QTY", NM : "수량합계", ROOT_CD : "", TYPE : "group"});
			BUCKET.query.push({BUCKET_ID : "S_TOT_AMT", BUCKET_TYPE : "", BUCKET_VAL : "S_TOT_AMT", CD : "S_TOT_AMT", NM : "금액합계", ROOT_CD : "", TYPE : "group"});
			BUCKET.query.push({BUCKET_ID : "S_JIN", BUCKET_TYPE : "", BUCKET_VAL : "S_JIN", CD : "S_JIN", NM : "진척율", ROOT_CD : "", TYPE : "group"});
			BUCKET.query.push({BUCKET_ID : "S_DIV", BUCKET_TYPE : "", BUCKET_VAL : "S_DIV", CD : "S_DIV", NM : "과부족", ROOT_CD : "", TYPE : "group"});
			
			FORM_SEARCH.bucketList = BUCKET.query;
			
			ajaxMap = {
				fromDate : gfn_replaceAll($("#prodFromDate").val(), "-", ""),
				toDate   : gfn_replaceAll($("#prodToDate").val(), "-", ""),
	       		week     : {isDown: "Y", isUp:"N", upCal:"M", isMt:"N", isExp:"N", expCnt:1},
	       		day      : {isDown: "N", isUp:"Y", upCal:"W", isMt:"N", isExp:"N", expCnt:999}, 
				sqlId    : ["bucketWeek", "bucketDay"]
			};
			
			gfn_getBucket(ajaxMap);
			
			bucketLen = BUCKET.query.length;
			
			for(var i = 0; i < bucketLen; i++){
				BUCKET.query[i].CD_SUB1 = ("PROD_DAY" + i);
			}
			
			BUCKET.query.unshift({BUCKET_ID : "S_QTY", BUCKET_TYPE : "", BUCKET_VAL : "S_QTY", CD : "S_QTY", NM : "수량", ROOT_CD : "", TYPE : "group"});
			BUCKET.query.unshift({BUCKET_ID : "S_AMT", BUCKET_TYPE : "", BUCKET_VAL : "S_AMT", CD : "S_AMT", NM : "금액", ROOT_CD : "", TYPE : "group"});
			BUCKET.query.push({BUCKET_ID : "S_TOT_QTY", BUCKET_TYPE : "", BUCKET_VAL : "S_TOT_QTY", CD : "S_TOT_QTY", NM : "수량합계", ROOT_CD : "", TYPE : "group"});
			BUCKET.query.push({BUCKET_ID : "S_TOT_AMT", BUCKET_TYPE : "", BUCKET_VAL : "S_TOT_AMT", CD : "S_TOT_AMT", NM : "금액합계", ROOT_CD : "", TYPE : "group"});
			BUCKET.query.push({BUCKET_ID : "S_JIN", BUCKET_TYPE : "", BUCKET_VAL : "S_JIN", CD : "S_JIN", NM : "진척율", ROOT_CD : "", TYPE : "group"});
			BUCKET.query.push({BUCKET_ID : "S_DIV", BUCKET_TYPE : "", BUCKET_VAL : "S_DIV", CD : "S_DIV", NM : "과부족", ROOT_CD : "", TYPE : "group"});
			
			FORM_SEARCH.bucketList2 = BUCKET.query;
			
			if (!sqlFlag) {
				BUCKET.all[0] = null;
				dailySalesProd.dailySalesProdGrid.gridInstance.setDraw();
				
				for(var i = 2; i <= 8; i++) {
					var headerName = dayReplace(FORM_SEARCH.bucketList[i].NM);
					dailySalesProd.dailySalesProdGrid.grdMain.setColumnProperty("SALES_DAY" + (i-2), "header", headerName);
					
					var headerName2 = dayReplace(FORM_SEARCH.bucketList2[i].NM);
					dailySalesProd.dailySalesProdGrid.grdMain.setColumnProperty("PROD_DAY" + (i-2), "header", headerName2);
				}
			}
		}
	};

	//조회
	var fn_apply = function (sqlFlag) {
		
		gfn_getMenuInit();
		
    	FORM_SEARCH         = $("#searchForm").serializeObject(); 
    	FORM_SEARCH.sql     = sqlFlag;
    	FORM_SEARCH.dimList = DIMENSION.user;
   		
   		dailySalesProd.getBucket(sqlFlag); 
		dailySalesProd.search();
		dailySalesProd.excelSubSearch();
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
	    
		if(type == "SALES"){
			$("#salesFromDate").val(gfn_replaceAll(year + "-" + month + "-" + day, "-", ""));
		    $("#salesToDate").val(gfn_replaceAll(year2 + "-" + month2 + "-" + day2, "-", ""));	
		}else if(type == "PROD"){
			$("#prodFromDate").val(gfn_replaceAll(year + "-" + month + "-" + day, "-", ""));
		    $("#prodToDate").val(gfn_replaceAll(year2 + "-" + month2 + "-" + day2, "-", ""));	
		}
	}
	
	function dayDate(){
		
		var params  = {};
		params._mtd = "getList";
		params.tranData = [{outDs : "resList", _siq : "supply.product.commonDay"}];
		
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
			}
		};
		gfn_service(opt, "obj");
		
	}
	
	function dayReplace(headerName){
		
		headerName = gfn_replaceAll(headerName, "(SUN)", "");
		headerName = gfn_replaceAll(headerName, "(MON)", "");
		headerName = gfn_replaceAll(headerName, "(TUE)", "");
		headerName = gfn_replaceAll(headerName, "(WED)", "");
		headerName = gfn_replaceAll(headerName, "(THU)", "");
		headerName = gfn_replaceAll(headerName, "(FRI)", "");
		headerName = gfn_replaceAll(headerName, "(SAT)", "");
		
		return headerName;
	}
	
	function fn_setNextFieldsBuket() {
		var fields = [
			{fieldName: "SALES_PRICE_KRW", dataType : "number"},
			{fieldName: "INV_QTY", dataType : "number"},
			{fieldName: "WIP_QTY", dataType : "number"},
			{fieldName: "TOTAL", dataType : "number"},
			{fieldName: "TOTAL_AMT", dataType : "number"},
			{fieldName: "SALES_PL_QTY", dataType : "number"},
			{fieldName: "SALES_PL_QTY_AMT", dataType : "number"},
			{fieldName: "SALES_DAY0", dataType : "number"},
			{fieldName: "SALES_DAY1", dataType : "number"},
			{fieldName: "SALES_DAY2", dataType : "number"},
			{fieldName: "SALES_DAY3", dataType : "number"},
			{fieldName: "SALES_DAY4", dataType : "number"},
			{fieldName: "SALES_DAY5", dataType : "number"},
			{fieldName: "SALES_DAY6", dataType : "number"},
			{fieldName: "SALES_QTY_TOTAL", dataType : "number"},
			{fieldName: "SALES_AMT_TOTAL", dataType : "number"},
			{fieldName: "SALES_JIN", dataType : "number"},
			{fieldName: "SALES_OVER", dataType : "number"},
			{fieldName: "PROD_PL_QTY", dataType : "number"},
			{fieldName: "PROD_PL_QTY_AMT", dataType : "number"},
			{fieldName: "PROD_DAY0", dataType : "number"},
			{fieldName: "PROD_DAY1", dataType : "number"},
			{fieldName: "PROD_DAY2", dataType : "number"},
			{fieldName: "PROD_DAY3", dataType : "number"},
			{fieldName: "PROD_DAY4", dataType : "number"},
			{fieldName: "PROD_DAY5", dataType : "number"},
			{fieldName: "PROD_DAY6", dataType : "number"},
			{fieldName: "PROD_QTY_TOTAL", dataType : "number"},
			{fieldName: "PROD_AMT_TOTAL", dataType : "number"},
			{fieldName: "PROD_JIN", dataType : "number"},
			{fieldName: "PROD_OVER", dataType : "number"}
			
        ];
    	
    	return fields;
	}
	
	function fn_setNextColumnsBuket() {
		var columns = [	
			{
				name : "SALES_PRICE_KRW", fieldName: "SALES_PRICE_KRW", editable: false, header: {text: '<spring:message code="lbl.salesPrice" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 80
			}, {
				name : "INV_QTY", fieldName: "INV_QTY", editable: false, header: {text: '<spring:message code="lbl.onhand" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 80
			}, {
				name : "WIP_QTY", fieldName: "WIP_QTY", editable: false, header: {text: '<spring:message code="lbl.fqc" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 80
			}, {
				name : "TOTAL", fieldName: "TOTAL", editable: false, header: {text: '<spring:message code="lbl.onhandTotal" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 80
			}, {
				name : "TOTAL_AMT", fieldName: "TOTAL_AMT", editable: false, header: {text: '<spring:message code="lbl.totalAmount" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 80
			},
			{
                type: "group",
                name: '<spring:message code="lbl.sales" javaScriptEscape="true" />',
                header: {text : '<spring:message code="lbl.sales"/>' + gv_expand },
                fieldName: "SALES_GROUP",
                width: 960,
                columns : [
                	{
						name : "SALES_PL_QTY", fieldName: "SALES_PL_QTY", editable: false, header: {text: '<spring:message code="lbl.salesPlanQty" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "SALES_PL_QTY_AMT", fieldName: "SALES_PL_QTY_AMT", editable: false, header: {text: '<spring:message code="lbl.salesPlanAmount" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "SALES_DAY0", fieldName: "SALES_DAY0", editable: false, header: {text: '<spring:message code="lbl.sunday" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "SALES_DAY1", fieldName: "SALES_DAY1", editable: false, header: {text: '<spring:message code="lbl.monday" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "SALES_DAY2", fieldName: "SALES_DAY2", editable: false, header: {text: '<spring:message code="lbl.tuesday" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "SALES_DAY3", fieldName: "SALES_DAY3", editable: false, header: {text: '<spring:message code="lbl.wednesday" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "SALES_DAY4", fieldName: "SALES_DAY4", editable: false, header: {text: '<spring:message code="lbl.thursday" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "SALES_DAY5", fieldName: "SALES_DAY5", editable: false, header: {text: '<spring:message code="lbl.friday" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "SALES_DAY6", fieldName: "SALES_DAY6", editable: false, header: {text: '<spring:message code="lbl.saturday" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "SALES_QTY_TOTAL", fieldName: "SALES_QTY_TOTAL", editable: false, header: {text: '<spring:message code="lbl.actualQty" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "SALES_AMT_TOTAL", fieldName: "SALES_AMT_TOTAL", editable: false, header: {text: '<spring:message code="lbl.actualAmt" javaScriptEscape="true" />', styles : {background : "#FF6C6C"}},
						styles: {textAlignment: "far", background : gv_arrDimColor[0], numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "SALES_JIN", fieldName: "SALES_JIN", editable: false, header: {text: '<spring:message code="lbl.progress" javaScriptEscape="true" />', styles : {background : "#FF6C6C"}},
						styles: {textAlignment: "far", background : gv_arrDimColor[0], numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}
					, {
						name : "SALES_OVER", fieldName: "SALES_OVER", editable: false, header: {text: '<spring:message code="lbl.overShort" javaScriptEscape="true" />', styles : {background : "#FF6C6C"}},
						styles: {textAlignment: "far", background : gv_arrDimColor[0], numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}
                ]
            }
			,
            {
                type: "group",
                name: '<spring:message code="lbl.prod" javaScriptEscape="true" />',
                header: {text : '<spring:message code="lbl.prod"/>' + gv_expand },
                fieldName: "PROD_GROUP",
                width: 960,
                columns : [
                	{
						name : "PROD_PL_QTY", fieldName: "PROD_PL_QTY", editable: false, header: {text: '<spring:message code="lbl.qty" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "PROD_PL_QTY_AMT", fieldName: "PROD_PL_QTY_AMT", editable: false, header: {text: '<spring:message code="lbl.amt" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "PROD_DAY0", fieldName: "PROD_DAY0", editable: false, header: {text: '<spring:message code="lbl.sunday" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "PROD_DAY1", fieldName: "PROD_DAY1", editable: false, header: {text: '<spring:message code="lbl.monday" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "PROD_DAY2", fieldName: "PROD_DAY2", editable: false, header: {text: '<spring:message code="lbl.tuesday" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "PROD_DAY3", fieldName: "PROD_DAY3", editable: false, header: {text: '<spring:message code="lbl.wednesday" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "PROD_DAY4", fieldName: "PROD_DAY4", editable: false, header: {text: '<spring:message code="lbl.thursday" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "PROD_DAY5", fieldName: "PROD_DAY5", editable: false, header: {text: '<spring:message code="lbl.friday" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "PROD_DAY6", fieldName: "PROD_DAY6", editable: false, header: {text: '<spring:message code="lbl.saturday" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "PROD_QTY_TOTAL", fieldName: "PROD_QTY_TOTAL", editable: false, header: {text: '<spring:message code="lbl.actualQty" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "PROD_AMT_TOTAL", fieldName: "PROD_AMT_TOTAL", editable: false, header: {text: '<spring:message code="lbl.actualAmt" javaScriptEscape="true" />', styles : {background : "#FF6C6C"}},
						styles: {textAlignment: "far", background : gv_arrDimColor[0], numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "PROD_JIN", fieldName: "PROD_JIN", editable: false, header: {text: '<spring:message code="lbl.progress" javaScriptEscape="true" />', styles : {background : "#FF6C6C"}},
						styles: {textAlignment: "far", background : gv_arrDimColor[0], numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}
					, {
						name : "PROD_OVER", fieldName: "PROD_OVER", editable: false, header: {text: '<spring:message code="lbl.overShort" javaScriptEscape="true" />', styles : {background : "#FF6C6C"}},
						styles: {textAlignment: "far", background : gv_arrDimColor[0], numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}
              	]
            }
		];
		
		
		return columns;
	}

	// onload 
	$(document).ready(function() {
		dailySalesProd.init();
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
				<%@ include file="/WEB-INF/view/common/filterMonthSum.jsp" %> 
				<div class="tabMargin"></div>
				<div class="scroll">
					<div class="view_combo" id="divItem"></div>
					<div class="view_combo" id="divProcurType"></div>
					<div class="view_combo" id="divItemType"></div>
					<div class="view_combo" id="divUpItemGroup"></div>
					<div class="view_combo" id="divItemGroup"></div>
					<div class="view_combo" id="divRoute"></div>
					<div class="view_combo" id="divRepCustGroup"></div>
					<div class="view_combo" id="divCustGroup"></div>
					<div class="view_combo" id="divDailyCdSales"></div>
					<div class="view_combo" id="divDailyCdProd"></div>
					<div class="view_combo">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.weekId"/></div>
							<input type="text" id="fromCal" name="fromCal" class="iptdate datepicker2" onchange="javascript:dayDate();"/>
							<input type="text" id="fromWeek" name="fromWeek" class="iptdateweek" disabled="disabled" value=""/>
							<input type="hidden" id="swFromDate" name="swFromDate"/>
							<input type="hidden" id="swToDate" name="swToDate"/>
							<input type="hidden" id="prodFromDate" name="prodFromDate"/>
							<input type="hidden" id="prodToDate" name="prodToDate"/>
							<input type="hidden" id="salesFromDate" name="salesFromDate"/>
							<input type="hidden" id="salesToDate" name="salesToDate"/>
						</div>
					</div>
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
			<!-- <div class="use_tit">
				<h3>My Opportunities</h3> <h4>- recently created</h4>
			</div> -->
			<div class="scroll">
				<!-- 그리드영역 -->
				<div id="realgrid" style="width: 100%;" class="realgrid1"></div>
			</div>
		</div>
    </div>
</body>
</html>
