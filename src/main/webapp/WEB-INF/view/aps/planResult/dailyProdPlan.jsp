<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
<script type="text/javascript">
	var enterSearchFlag = "Y";
	
	var dailyProdPlan = {
		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.grid.initGrid();
			this.events();
		},
		
		_siq    : "aps.planResult.dailyProdPlan",
		
		comCode : {
			codeMap : null,
			codeMapEx : null,
			
			initCode : function () {
				var grpCd    = 'MONTH_TYPE_MINUS,MONTH_TYPE_PLUS,ITEM_TYPE,CHANGE_AREA,PROCUR_TYPE,DAILY_CD';
				this.codeMap = gfn_getComCode(grpCd, 'Y'); //공통코드 조회
				this.codeMapEx = gfn_getComCodeEx(["REP_CUST_GROUP", "CUST_GROUP", "UPPER_ITEM_GROUP", "ITEM_GROUP", "ROUTING"], null, {itemType : "10,20" });
				
				this.codeMap.PROCUR_TYPE = $.grep(this.codeMap.PROCUR_TYPE, function(v,n) {
					return v.CODE_CD == 'MG' || v.CODE_CD == 'MH'; 
				});
				
			 	this.codeMap.ITEM_TYPE = $.grep(this.codeMap.ITEM_TYPE, function(v,n) {
					 return v.CODE_CD == '10' || v.CODE_CD == '20';    
				}); 
			}
		},
		
		initFilter : function() {
			var itemTypeEvent = {
				childId   : ["upItemGroup","route"],  
				childData : [this.comCode.codeMapEx.UPPER_ITEM_GROUP, this.comCode.codeMapEx.ROUTING],
				
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
				{target : 'divDailyCdSales', id : 'dailyCdSales',  title : '<spring:message code="lbl.progressSales"/>',  data : this.comCode.codeMap.DAILY_CD, exData:["*"], type : "S"},
				{target : 'divDailyCdProd',  id : 'dailyCdProd',   title : '<spring:message code="lbl.progressProd"/>',   data : this.comCode.codeMap.DAILY_CD, exData:["*"], type : "S"},
			]);
			
			$("#itemType").multipleSelect("setSelects", ["10"]);
			
			var dateParam = {
				arrTarget : [
					{calId : "fromCal", weekId : "fromWeek", defVal : 0},
					{calId : "toCal", weekId : "toWeek", defVal : 1}
				]
			};
			DATEPICKET(dateParam);
			$('#fromCal').datepicker("option", "maxDate", new Date().getWeekDay(0, false));
			
			dayDate();
		},
		
		grid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid : function() {
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				
				this.gridInstance.custNextBucketFalg = true;
				
				this.setOptions();
				
				gfn_setMonthSum(dailyProdPlan.grid.gridInstance, false, false, true);
			},
			
			setOptions : function() {
				this.grdMain.setOptions({
					stateBar: { visible : true }
				});

				this.dataProvider.setOptions({
					softDeleting : true
				});
				
				this.grdMain.addCellStyles([{
					id         : "editStyle",
					editable   : true,
					background : gv_editColor
				}]);
			}
		},
		
		events : function () {
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
		},
		
		getBucket : function(sqlFlag) {
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
			
			ajaxMap = {
				fromDate : gfn_replaceAll($("#prodFromDate2").val(), "-", ""),
				toDate   : gfn_replaceAll($("#prodToDate2").val(), "-", ""),
	       		week     : {isDown: "Y", isUp:"N", upCal:"M", isMt:"N", isExp:"N", expCnt:1},
	       		day      : {isDown: "N", isUp:"Y", upCal:"W", isMt:"N", isExp:"N", expCnt:999}, 
				sqlId    : ["bucketWeek", "bucketDay"]
			};
			
			gfn_getBucket(ajaxMap);
			
			bucketLen = BUCKET.query.length;
			
			for(var i = 0; i < bucketLen; i++){
				BUCKET.query[i].CD_SUB1 = ("NEXT_PROD_DAY" + i);
			}
			
			BUCKET.query.unshift({BUCKET_ID : "S_QTY", BUCKET_TYPE : "", BUCKET_VAL : "S_QTY", CD : "S_QTY", NM : "수량", ROOT_CD : "", TYPE : "group"});
			BUCKET.query.unshift({BUCKET_ID : "S_AMT", BUCKET_TYPE : "", BUCKET_VAL : "S_AMT", CD : "S_AMT", NM : "금액", ROOT_CD : "", TYPE : "group"});
			BUCKET.query.push({BUCKET_ID : "S_TOT_QTY", BUCKET_TYPE : "", BUCKET_VAL : "S_TOT_QTY", CD : "S_TOT_QTY", NM : "수량합계", ROOT_CD : "", TYPE : "group"});
			BUCKET.query.push({BUCKET_ID : "S_TOT_AMT", BUCKET_TYPE : "", BUCKET_VAL : "S_TOT_AMT", CD : "S_TOT_AMT", NM : "금액합계", ROOT_CD : "", TYPE : "group"});
			BUCKET.query.push({BUCKET_ID : "S_JIN", BUCKET_TYPE : "", BUCKET_VAL : "S_JIN", CD : "S_JIN", NM : "진척율", ROOT_CD : "", TYPE : "group"});
			BUCKET.query.push({BUCKET_ID : "S_DIV", BUCKET_TYPE : "", BUCKET_VAL : "S_DIV", CD : "S_DIV", NM : "과부족", ROOT_CD : "", TYPE : "group"});
			
			FORM_SEARCH.bucketList3 = BUCKET.query;
			
			if (!sqlFlag) {
				BUCKET.all[0] = null;
				dailyProdPlan.grid.gridInstance.setDraw();
				
				for(var i = 2; i <= 8; i++) {
					var headerName = dayReplace(FORM_SEARCH.bucketList[i].NM);
					dailyProdPlan.grid.grdMain.setColumnProperty("SALES_DAY" + (i-2), "header", headerName);
					
					var headerName2 = dayReplace(FORM_SEARCH.bucketList2[i].NM);
					dailyProdPlan.grid.grdMain.setColumnProperty("PROD_DAY" + (i-2), "header", headerName2);
					
					var headerName3 = dayReplace(FORM_SEARCH.bucketList3[i].NM);
					dailyProdPlan.grid.grdMain.setColumnProperty("NEXT_PROD_DAY" + (i-2), "header", headerName3);
				}
			}
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
					}else if(id == "divDailyCdSales"){
						EXCEL_SEARCH_DATA += $("#dailyCdSales option:selected").text();
					}else if(id == "divDailyCdProd"){
						EXCEL_SEARCH_DATA += $("#dailyCdProd option:selected").text();
					}else if(id == "divWeekId"){
						EXCEL_SEARCH_DATA += $("#fromCal").val() + "(" + $("#fromWeek").val() + ")";
					} 
				}
			});
			
		},
		
		search : function () {
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList", _siq : this._siq }];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj.do",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						dailyProdPlan.grid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						dailyProdPlan.grid.grdMain.cancel();
						
						dailyProdPlan.grid.dataProvider.setRows(data.resList);
						dailyProdPlan.grid.dataProvider.clearSavePoints();
						dailyProdPlan.grid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_actionMonthSum(dailyProdPlan.grid.gridInstance);
						gfn_setRowTotalFixed(dailyProdPlan.grid.grdMain);
						
						dailyProdPlan.gridCallback();
						
					}
				}
			}
			gfn_service(aOption, "obj");
		},
		
		gridCallback : function(){
			
			var today = new Date();
			var dd = today.getDate();
			var mm = today.getMonth() + 1;
			var yyyy = today.getFullYear();

			if(dd < 10) {
			    dd = "0" + dd;
			} 

			if(mm < 10) {
			    mm = "0" + mm;
			} 

			today = String(yyyy) + String(mm) + String(dd);
			
			var list = FORM_SEARCH.bucketList;
			var list2 = FORM_SEARCH.bucketList2;
			var list3 = FORM_SEARCH.bucketList3;
			
			for(i = 2; i < 9; i++){
				
				var val = list[i].BUCKET_VAL;
				var val2 = list2[i].BUCKET_VAL;
				var val3 = list3[i].BUCKET_VAL;
				var name = list[i].CD_SUB1;
				var name2 = list2[i].CD_SUB1;
				var name3 = list3[i].CD_SUB1;
				
				if(val >= today){
					dailyProdPlan.grid.grdMain.setColumnProperty(name, "styles", {"background" : gv_whiteColor});
				}
				
				if(val2 >= today){
					dailyProdPlan.grid.grdMain.setColumnProperty(name2, "styles", {"background" : gv_whiteColor});
				}
				
				if(val3 >= today){
					dailyProdPlan.grid.grdMain.setColumnProperty(name3, "styles", {"background" : gv_whiteColor});
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
   		
   		dailyProdPlan.getBucket(sqlFlag); 
   		dailyProdPlan.search();
   		dailyProdPlan.excelSubSearch();
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
			{fieldName: "PROD_INV_QTY", dataType : "number"},
			{fieldName: "QC_INV_QTY", dataType : "number"},
			{fieldName: "INV_QTY", dataType : "number"},
			{fieldName: "INV_AMT", dataType : "number"},
			
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
			{fieldName: "W1_PREPRODUCTION_QTY", dataType : "number"},
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
			{fieldName: "PROD_OVER", dataType : "number"},
			
			{fieldName: "NEXT_PROD_PL_QTY", dataType : "number"},
			{fieldName: "NEXT_PROD_PL_QTY_AMT", dataType : "number"},
			{fieldName: "NEXT_PROD_DAY0", dataType : "number"},
			{fieldName: "NEXT_PROD_DAY1", dataType : "number"},
			{fieldName: "NEXT_PROD_DAY2", dataType : "number"},
			{fieldName: "NEXT_PROD_DAY3", dataType : "number"},
			{fieldName: "NEXT_PROD_DAY4", dataType : "number"},
			{fieldName: "NEXT_PROD_DAY5", dataType : "number"},
			{fieldName: "NEXT_PROD_DAY6", dataType : "number"},
			{fieldName: "NEXT_PROD_QTY_TOTAL", dataType : "number"},
			{fieldName: "NEXT_PROD_AMT_TOTAL", dataType : "number"},
			{fieldName: "NEXT_PROD_JIN", dataType : "number"},
			{fieldName: "NEXT_PROD_OVER", dataType : "number"}
			
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
				name : "PROD_INV_QTY", fieldName: "PROD_INV_QTY", editable: false, header: {text: '<spring:message code="lbl.prodInvQty" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 80
			}, {
				name : "QC_INV_QTY", fieldName: "QC_INV_QTY", editable: false, header: {text: '<spring:message code="lbl.qcInvQty" javaScriptEscape="true" />'},
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
				name : "INV_AMT", fieldName: "INV_AMT", editable: false, header: {text: '<spring:message code="lbl.totalAmount" javaScriptEscape="true" />'},
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
						name : "SALES_PL_QTY", fieldName: "SALES_PL_QTY", editable: false, header: {text: '<spring:message code="lbl.planQty2nd" javaScriptEscape="true" />'},
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
						name : "SALES_QTY_TOTAL", fieldName: "SALES_QTY_TOTAL", editable: false, header: {text: '<spring:message code="lbl.totalQty" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "SALES_AMT_TOTAL", fieldName: "SALES_AMT_TOTAL", editable: false, header: {text: '<spring:message code="lbl.totalAmt" javaScriptEscape="true" />', styles : {background : "#FF6C6C"}},
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
					}, 
					
					{
						name : "W1_PREPRODUCTION_QTY", fieldName: "W1_PREPRODUCTION_QTY", editable: false, header: {text: '<spring:message code="lbl.PreproductionW1" javaScriptEscape="true" />'},
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
						name : "PROD_QTY_TOTAL", fieldName: "PROD_QTY_TOTAL", editable: false, header: {text: '<spring:message code="lbl.totalQty" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "PROD_AMT_TOTAL", fieldName: "PROD_AMT_TOTAL", editable: false, header: {text: '<spring:message code="lbl.totalAmt" javaScriptEscape="true" />', styles : {background : "#FF6C6C"}},
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
            },
            {
                type: "group",
                name: '<spring:message code="lbl.prodNextWeek" javaScriptEscape="true" />',
                header: {text : '<spring:message code="lbl.prodNextWeek"/>' + gv_expand },
                fieldName: "NEXT_PROD_GROUP",
                width: 960,
                columns : [
                	{
						name : "NEXT_PROD_PL_QTY", fieldName: "NEXT_PROD_PL_QTY", editable: false, header: {text: '<spring:message code="lbl.qty" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "NEXT_PROD_PL_QTY_AMT", fieldName: "NEXT_PROD_PL_QTY_AMT", editable: false, header: {text: '<spring:message code="lbl.amt" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "NEXT_PROD_DAY0", fieldName: "NEXT_PROD_DAY0", editable: false, header: {text: '<spring:message code="lbl.sunday" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "NEXT_PROD_DAY1", fieldName: "NEXT_PROD_DAY1", editable: false, header: {text: '<spring:message code="lbl.monday" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "NEXT_PROD_DAY2", fieldName: "NEXT_PROD_DAY2", editable: false, header: {text: '<spring:message code="lbl.tuesday" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "NEXT_PROD_DAY3", fieldName: "NEXT_PROD_DAY3", editable: false, header: {text: '<spring:message code="lbl.wednesday" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "NEXT_PROD_DAY4", fieldName: "NEXT_PROD_DAY4", editable: false, header: {text: '<spring:message code="lbl.thursday" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "NEXT_PROD_DAY5", fieldName: "NEXT_PROD_DAY5", editable: false, header: {text: '<spring:message code="lbl.friday" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "NEXT_PROD_DAY6", fieldName: "NEXT_PROD_DAY6", editable: false, header: {text: '<spring:message code="lbl.saturday" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "NEXT_PROD_QTY_TOTAL", fieldName: "NEXT_PROD_QTY_TOTAL", editable: false, header: {text: '<spring:message code="lbl.totalQty" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "NEXT_PROD_AMT_TOTAL", fieldName: "NEXT_PROD_AMT_TOTAL", editable: false, header: {text: '<spring:message code="lbl.totalAmt" javaScriptEscape="true" />', styles : {background : "#FF6C6C"}},
						styles: {textAlignment: "far", background : gv_arrDimColor[0], numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
						name : "NEXT_PROD_JIN", fieldName: "NEXT_PROD_JIN", editable: false, header: {text: '<spring:message code="lbl.progress" javaScriptEscape="true" />', styles : {background : "#FF6C6C"}},
						styles: {textAlignment: "far", background : gv_arrDimColor[0], numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}
					, {
						name : "NEXT_PROD_OVER", fieldName: "NEXT_PROD_OVER", editable: false, header: {text: '<spring:message code="lbl.overShort" javaScriptEscape="true" />', styles : {background : "#FF6C6C"}},
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
	
	function dayDate(){
		
		var params  = {};
		params._mtd = "getList";
		params.fromCal = $("#swFromDate").val().replace("-", "");
		params.tranData = [
			{outDs : "resList", _siq : "aps.planResult.commonDay"},
			{outDs : "weekList", _siq : "aps.planResult.weekList"}
		];
		
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
				
				$("#toWeek").val(data.weekList[0].YEARWEEK);
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
	    
	    
		if(type == "SALES"){
			$("#salesFromDate").val(gfn_replaceAll(year + "-" + month + "-" + day, "-", ""));
		    $("#salesToDate").val(gfn_replaceAll(year2 + "-" + month2 + "-" + day2, "-", ""));	
		}else if(type == "PROD"){
			$("#prodFromDate").val(gfn_replaceAll(year + "-" + month + "-" + day, "-", ""));
		    $("#prodToDate").val(gfn_replaceAll(year2 + "-" + month2 + "-" + day2, "-", ""));	
		    
		    var dateNextWeekFrom = new Date(year + "/" + month + "/" + day);
		    var dateNextWeekTo   = new Date(year2 + "/" + month2 + "/" + day2);
		    
		    dateNextWeekFrom.setDate(dateNextWeekFrom.getDate() + 7);
		    dateNextWeekTo.setDate(dateNextWeekTo.getDate() + 7);
		   
		    var year3  = dateNextWeekFrom.getFullYear();
		    var month3 = dateNextWeekFrom.getMonth() + 1;
		    var day3   = dateNextWeekFrom.getDate();
		    
		    var year4  = dateNextWeekTo.getFullYear();
		    var month4 = dateNextWeekTo.getMonth() + 1;
		    var day4   = dateNextWeekTo.getDate();
		    
		    if(month3 < 10){
		    	month3 = "0" + month3;
		    }
		    
		    if(day3 < 10){
		    	day3 = "0" + day3;
		    }
		    
		    if(month4 < 10){
		    	month4 = "0" + month4;
		    }
		    
		    if(day4 < 10){
		    	day4 = "0" + day4;
		    }
		    
		    $("#prodFromDate2").val(gfn_replaceAll(year3 + "-" + month3 + "-" + day3, "-", ""));
		    $("#prodToDate2").val(gfn_replaceAll(year4 + "-" + month4 + "-" + day4, "-", ""));
		}
	}
	
	// onload 
	$(document).ready(function() {
		dailyProdPlan.init();
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
					<div class="view_combo" id="divWeekId">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.weekId"/></div>
							<input type="text" id="fromCal" name="fromCal" class="iptdate datepicker2" onchange="javascript:dayDate();"/>
							<input type="text" id="fromWeek" name="fromWeek" class="iptdateweek" disabled="disabled" value=""/>
							<input type="hidden" id="toCal" name="toCal"/>
							<input type="hidden" id="toWeek" name="toWeek"/>
							<input type="hidden" id="swFromDate" name="swFromDate"/>
							<input type="hidden" id="swToDate" name="swToDate"/>
							<input type="hidden" id="prodFromDate" name="prodFromDate"/>
							<input type="hidden" id="prodToDate" name="prodToDate"/>
							<input type="hidden" id="prodFromDate2" name="prodFromDate2"/>
							<input type="hidden" id="prodToDate2" name="prodToDate2"/>
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