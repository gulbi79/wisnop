<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	<!-- 급증감 겈토-->
	<script type="text/javascript">

	var enterSearchFlag = "Y";
	var arrExtCol = ["M0_QTY","M0_QTY_AVG","M1_QTY","M1_QTY_AVG","M2_QTY","M2_QTY_AVG","M3_QTY","M3_QTY_AVG","M12_QTY_CUMULATIVE","M12_QTY_AVG"];
	var sterillzeReview = {

		init : function () {
			//$("#view_Her").hide();
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.sterillzeReviewGrid.initGrid();
		},
			
		_siq    : "supply.product.sterillzeReviewList",
		
		initFilter : function() {
			
			var itemTypeEvent = {
				childId   : ["upItemGroup"],  
				childData : [this.comCode.codeMapEx.UPPER_ITEM_GROUP, this.comCode.codeMapEx.ROUTING]
				
			};
	    	
	    	//품목대그룹
			var upperItemEvent = {
				childId   : ["itemGroup"],
				childData : [this.comCode.codeMapEx.ITEM_GROUP],
			};
			
			// 키워드팝업
			gfn_keyPopAddEvent([
				{ target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>'}
			]);
			
			// 콤보박스
			gfn_setMsComboAll([
				{target : 'divProcurType',   id : 'procurType',    title : '<spring:message code="lbl.procure"/>',        data : this.comCode.codeMap.PROCUR_TYPE, exData:[""]},
				{target : 'divItemGroup', id : 'itemGroup', title : '<spring:message code="lbl.itemGroup"/>', data : this.comCode.codeMapEx.ITEM_GROUP, exData:["*"]},
				{target : 'divUpItemGroup',  id : 'upItemGroup',   title : '<spring:message code="lbl.upperItemGroup"/>', data : this.comCode.codeMapEx.UPPER_ITEM_GROUP, exData:["*"], event: upperItemEvent, option: {allFlag:"Y"}},
				{target : 'divItemType', id : 'itemType', title : '<spring:message code="lbl.itemType"/>', data : this.comCode.codeMap.ITEM_TYPE, exData:[""], event: itemTypeEvent, option: {allFlag:"Y"}},
				{target : 'divVariationFilter', id : 'variationFilter', title : '<spring:message code="lbl.variationRateFilter"/>', data : this.comCode.codeMap.MONTH_TYPE_MINUS, exData:[""], type : "S"},
				{target : 'divOutboundFilter', id : 'outboundFilter', title : '<spring:message code="lbl.outboundQtyFilter"/>', data : this.comCode.codeMap.MONTH_TYPE_OUTBOUND, exData:["*"], type : "S"},
				{target : 'divInvenFilter', id : 'invenFilter', title : '<spring:message code="lbl.aipq"/>', data : this.comCode.codeMap.MONTH_TYPE_PLUS, exData:["*"], type : "S"},
			]);
			
			$(':radio[name=variationFilter]:input[value="M-12"]').attr("checked", true);
			$(':radio[name=outboundFilter]:input[value=""]').attr("checked", true);
			$(':radio[name=invenFilter]:input[value=""]').attr("checked", true);
			
		},
		
		/*
		* common Code 
		*/
		comCode : {
			codeMap : null,
			codeMapEx : null,
			
			initCode : function () {
				var grpCd    = 'MONTH_TYPE_MINUS,MONTH_TYPE_PLUS,ITEM_TYPE,PROCUR_TYPE,MONTH_TYPE_OUTBOUND';
				this.codeMap = gfn_getComCode(grpCd, 'Y'); //공통코드 조회
				this.codeMapEx = gfn_getComCodeEx(["REP_CUST_GROUP", "CUST_GROUP", "UPPER_ITEM_GROUP", "ITEM_GROUP", "ROUTING"], null, {itemType : "10,20,30,50" });
				
				this.codeMap.ITEM_TYPE = $.grep(this.codeMap.ITEM_TYPE, function(v,n) {
					return v.CODE_CD != '25' && v.CODE_CD != '35'; 
				});
			}
		},
	
		/* 
		* grid  선언
		*/
		sterillzeReviewGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				this.gridInstance.custNextBucketFalg = true;
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				
				gfn_setMonthSum(sterillzeReview.sterillzeReviewGrid.gridInstance, false, false, true);
			}
		},
	
		/*
		* event 정의
		*/
		events : function () {
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("#sQty,#sAmt").on("click", function(e) {
				fn_gridCtrl(this,arrExtCol);
			});
		},
		
		excelSubSearch : function (){
			
			$.each($(".view_combo"), function(i, val){
				
				var temp = "";
				var id = gfn_nvl($(this).attr("id"), "");
				
				if(id != ""){
					
					var name = gfn_nvl($("#" + id + " .ilist .itit").html(), "");
					
					if(name == ""){
						name = $("#" + id + " .filter_tit").html();
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
					}else if(id == "divVariationFilter"){
						EXCEL_SEARCH_DATA += $("#variationFilter option:selected").text();
					}else if(id == "divOutboundFilter"){
						EXCEL_SEARCH_DATA += $("#outboundFilter option:selected").text();
					}else if(id == "divInvenFilter"){
						EXCEL_SEARCH_DATA += $("#invenFilter option:selected").text();
					}else if(id == "divVariationRateArea"){
						EXCEL_SEARCH_DATA += $("#changeAreaStart").val() + " ~ " + $("#changeAreaEnd").val();
					}else if(id == "divQtyAmtGubun"){
						var cnt = 0;
						if($("#sQty").prop("checked")){
							cnt++;
							EXCEL_SEARCH_DATA += '<spring:message code="lbl.qty"/>';
						}
						if($("#sAmt").prop("checked")){
							if(cnt == 1){
								EXCEL_SEARCH_DATA += ", ";
							}
							EXCEL_SEARCH_DATA += '<spring:message code="lbl.amt"/>';
						}
					}
				}
			});
			
		},
		
		// 조회
		search : function () {
			
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{outDs : "resList", _siq : this._siq }];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						sterillzeReview.sterillzeReviewGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						sterillzeReview.sterillzeReviewGrid.grdMain.cancel();
						
						sterillzeReview.sterillzeReviewGrid.dataProvider.setRows(data.resList);
						sterillzeReview.sterillzeReviewGrid.dataProvider.clearSavePoints();
						sterillzeReview.sterillzeReviewGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_actionMonthSum(sterillzeReview.sterillzeReviewGrid.gridInstance);
						gfn_setRowTotalFixed(sterillzeReview.sterillzeReviewGrid.grdMain);
						
						//grid set
						$.each($("#sQty,#sAmt"), function(n,v) {
							if ($(v).is(":checked")) return true;
							fn_gridCtrl(v,arrExtCol);
						});
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		getBucket : function (sqlFlag) {
			var ajaxMap = {
				fromDate : gfn_replaceAll($("#fromCal").val(),"-",""),
				toDate   : gfn_replaceAll($("#toCal").val(),"-",""),
	       		week     : {isDown: "Y", isUp:"N", upCal:"M", isMt:"N", isExp:"N", expCnt:999},
	       		sqlId    : ["bucketFullWeek"]
			}
			gfn_getBucket(ajaxMap);
			
			if (!sqlFlag) {
				sterillzeReview.sterillzeReviewGrid.gridInstance.setDraw();
				
				var fileds = sterillzeReview.sterillzeReviewGrid.dataProvider.getFields();
				var filedsLen = fileds.length;
				
				for (var i = 0; i < filedsLen; i++) {
					var fieldName = fileds[i].fieldName;
					if (fieldName == 'SALES_PRICE_KRW_NM'){
						fileds[i].dataType = "number";
						sterillzeReview.sterillzeReviewGrid.grdMain.setColumnProperty(fieldName, "styles", {"numberFormat" : "#,##0"});	
					}
				}
				
				sterillzeReview.sterillzeReviewGrid.dataProvider.setFields(fileds);
				
				
			}
		}
	};
	
	//조회
	var fn_apply = function (sqlFlag) {
		
		var pChangeAreaStart = $("#changeAreaStart").val();
		var pChangeAreaEnd = $("#changeAreaEnd").val();
		
		if(pChangeAreaStart != "" && pChangeAreaEnd != "" && pChangeAreaStart > pChangeAreaEnd){
			alert('<spring:message code="msg.changeCheck" javaScriptEscape="true" />');
			return;
		}

		gfn_getMenuInit();
		
		sterillzeReview.getBucket(sqlFlag); 
    	
    	FORM_SEARCH = $("#searchForm").serializeObject(); 
    	FORM_SEARCH.sql        = sqlFlag;
   		FORM_SEARCH.dimList    = DIMENSION.user;
   		FORM_SEARCH.bucketList = BUCKET.query;
   		
		sterillzeReview.search();
		sterillzeReview.excelSubSearch();
	}

	// onload 
	$(document).ready(function() {
		sterillzeReview.init();
	});
	
	
	function fn_setNextFieldsBuket() {
    	//필드 배열 객체를  생성합니다.
        var fields = [
            {fieldName: "PAST_YEAR_QTY_AVG", dataType : "number"},
            {fieldName: "PAST_SIX_MONTH_QTY_AVG", dataType : "number"},
            {fieldName: "PAST_THREE_MONTH_QTY_AVG", dataType : "number"},
            {fieldName: "PAST_YEAR_AMT_AVG", dataType : "number"},
            {fieldName: "PAST_SIX_MONTH_AMT_AVG", dataType : "number"},
            {fieldName: "PAST_THREE_MONTH_AMT_AVG", dataType : "number"},
            {fieldName: "AVAIL_INVENTORY_QTY", dataType : "number"},
            {fieldName: "AVAIL_INVENTORY_AMT", dataType : "number"},
            {fieldName: "CURRENT_INVENTORY_QTY", dataType : "number"},
            {fieldName: "CURRENT_INVENTORY_AMT", dataType : "number"},
            {fieldName: "WIP_INVENTORY_QTY", dataType : "number"},
            {fieldName: "WIP_INVENTORY_AMT", dataType : "number"},
            {fieldName: "INBOUND_PLAN_QTY", dataType : "number"},
            {fieldName: "INBOUND_PLAN_AMT", dataType : "number"},
            {fieldName: "FUTURE_THREE_QTY_AVG", dataType : "number"},
            {fieldName: "FUTURE_THREE_AMT_AVG", dataType : "number"},
            {fieldName: "FUTURE_THREE_AVG_RATE", dataType : "number"},
            {fieldName: "M0_QTY", dataType : "number"},
            {fieldName: "M0_AMT_AVG", dataType : "number"},
            {fieldName: "M1_QTY", dataType : "number"},
            {fieldName: "M1_AMT_AVG", dataType : "number"},
            {fieldName: "M2_QTY", dataType : "number"},
            {fieldName: "M2_AMT_AVG", dataType : "number"},
            {fieldName: "M3_QTY", dataType : "number"},
            {fieldName: "M3_AMT_AVG", dataType : "number"},
            {fieldName: "M12_QTY_CUMULATIVE", dataType : "number"},
            {fieldName: "M12_AMT_AVG", dataType : "number"},
            {fieldName: "M0_AMT", dataType : "number"},
            {fieldName: "M1_AMT", dataType : "number"},
            {fieldName: "M2_AMT", dataType : "number"},
            {fieldName: "M3_AMT", dataType : "number"},
            {fieldName: "M12_AMT_CUMULATIVE", dataType : "number"},
            {fieldName: "ONE_YEAR_RESUTL_QTY", dataType : "number"},
            {fieldName: "WORK_QTY", dataType : "number"},
            {fieldName: "WORK_QTY_FINAL", dataType : "number"},
            {fieldName: "WORK_AMT", dataType : "number"},
            {fieldName: "AVG_TOT", dataType : "number"},
            {fieldName: "PROD_ORDER_QTY", dataType : "number"},
            {fieldName: "PROD_ORDER_AMT", dataType : "number"},
            {fieldName: "WEEK_REMAIN_QTY", dataType : "number"},
            {fieldName: "SS_QTY_DISP", dataType : "number"},
            {fieldName: "SBS_QTY", dataType : "number"}
        ];
    	
    	return fields;
    }
    
    function fn_setNextColumnsBuket() {
    	//필드와 연결된 컬럼 배열 객체를 생성합니다.
        var columns = [
        	{
                type: "group",
                name: '<spring:message code="lbl.releasedQty" javaScriptEscape="true" />',
                header: {text: '<spring:message code="lbl.releasedQty" javaScriptEscape="true" />'},
                fieldName: "PAST",
                width: 540,
                columns : [
                	{
						name : "PAST_YEAR_QTY_AVG", fieldName: "PAST_YEAR_QTY_AVG",  editable: false, header: {text: '<spring:message code="lbl.1yAvg" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0.0"},
						dataType : "number",
						width: 80
					}, {
						name : "PAST_YEAR_AMT_AVG", fieldName: "PAST_YEAR_AMT_AVG",  editable: false, header: {text: '<spring:message code="lbl.1yAmtAvg" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "PAST_SIX_MONTH_QTY_AVG", fieldName: "PAST_SIX_MONTH_QTY_AVG",  editable: false, header: {text: '<spring:message code="lbl.6mAvg" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0.0"},
						dataType : "number",
						width: 80
					}, {
						name : "PAST_SIX_MONTH_AMT_AVG", fieldName: "PAST_SIX_MONTH_AMT_AVG",  editable: false, header: {text: '<spring:message code="lbl.6mAmtAvg" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "PAST_THREE_MONTH_QTY_AVG", fieldName: "PAST_THREE_MONTH_QTY_AVG",  editable: false, header: {text: '<spring:message code="lbl.3mAvg" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0.0"},
						dataType : "number",
						width: 80
					}, {
						name : "PAST_THREE_MONTH_AMT_AVG", fieldName: "PAST_THREE_MONTH_AMT_AVG",  editable: false, header: {text: '<spring:message code="lbl.3mAmtAvg" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}
                ]
            }, {
                type: "group",
                name: '<spring:message code="lbl.avaiableInventory" javaScriptEscape="true" />',
                header: {text: '<spring:message code="lbl.avaiableInventory" javaScriptEscape="true" />'},
                fieldName: "AVAIL",
                width: 200,
                columns : [
                	{
						name : "AVAIL_INVENTORY_QTY", fieldName: "AVAIL_INVENTORY_QTY",  editable: false, header: {text: '<spring:message code="lbl.qty" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "AVAIL_INVENTORY_AMT", fieldName: "AVAIL_INVENTORY_AMT",  editable: false, header: {text: '<spring:message code="lbl.amount" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}
                ]
            }, {
                type: "group",
                name: '<spring:message code="lbl.inventoryStatus" javaScriptEscape="true" />',
                header: {text: '<spring:message code="lbl.inventoryStatus" javaScriptEscape="true" />'}, // + gv_expand
                fieldName: "INVEN_INFO",
                width: 600,
                columns : [
                	{
                        type: "group",
                        name: '<spring:message code="lbl.onHand2" javaScriptEscape="true" />',
                        header: {text: '<spring:message code="lbl.onHand2" javaScriptEscape="true" />'},
                        fieldName: "CURRENT",
                        width: 200,
                        columns : [
                        	{
        						name : "CURRENT_INVENTORY_QTY", fieldName: "CURRENT_INVENTORY_QTY",  editable: false, header: {text: '<spring:message code="lbl.qty" javaScriptEscape="true" />'},
        						dynamicStyles : [gfn_getDynamicStyle(-2)],
        						styles: {textAlignment: "far", numberFormat : "#,##0"},
        						dataType : "number",
        						width: 100
        					}, {
        						name : "CURRENT_INVENTORY_AMT", fieldName: "CURRENT_INVENTORY_AMT",  editable: false, header: {text: '<spring:message code="lbl.amount" javaScriptEscape="true" />'},
        						dynamicStyles : [gfn_getDynamicStyle(-2)],
        						styles: {textAlignment: "far", numberFormat : "#,##0"},
        						dataType : "number",
        						width: 100
        					}
                        ]
                    },
                    {
                        type: "group",
                        name: '<spring:message code="lbl.wip" javaScriptEscape="true" />',
                        header: {text: '<spring:message code="lbl.wip" javaScriptEscape="true" />'},
                        fieldName: "WIP",
                        width: 200,
                        columns : [
                        	{
        						name : "WIP_INVENTORY_QTY", fieldName: "WIP_INVENTORY_QTY",  editable: false, header: {text: '<spring:message code="lbl.qty" javaScriptEscape="true" />'},
        						dynamicStyles : [gfn_getDynamicStyle(-2)],
        						styles: {textAlignment: "far", numberFormat : "#,##0"},
        						dataType : "number",
        						width: 100
        					}, {
        						name : "WIP_INVENTORY_AMT", fieldName: "WIP_INVENTORY_AMT",  editable: false, header: {text: '<spring:message code="lbl.amount" javaScriptEscape="true" />'},
        						dynamicStyles : [gfn_getDynamicStyle(-2)],
        						styles: {textAlignment: "far", numberFormat : "#,##0"},
        						dataType : "number",
        						width: 100
        					}
                        ]
                    },
                    {
                        type: "group",
                        name: '<spring:message code="lbl.open" javaScriptEscape="true" />',
                        header: {text: '<spring:message code="lbl.open" javaScriptEscape="true" />'},
                        fieldName: "PROD_ORDER",
                        width: 200,
                        columns : [
                        	{
        						name : "PROD_ORDER_QTY", fieldName: "PROD_ORDER_QTY",  editable: false, header: {text: '<spring:message code="lbl.qty" javaScriptEscape="true" />'},
        						dynamicStyles : [gfn_getDynamicStyle(-2)],
        						styles: {textAlignment: "far", numberFormat : "#,##0"},
        						dataType : "number",
        						width: 100
        					}, {
        						name : "PROD_ORDER_AMT", fieldName: "PROD_ORDER_AMT",  editable: false, header: {text: '<spring:message code="lbl.amount" javaScriptEscape="true" />'},
        						dynamicStyles : [gfn_getDynamicStyle(-2)],
        						styles: {textAlignment: "far", numberFormat : "#,##0"},
        						dataType : "number",
        						width: 100
        					}
                        ]
                    },
                    {
                        type: "group",
                        name: '<spring:message code="lbl.expReciept" javaScriptEscape="true" />',
                        header: {text: '<spring:message code="lbl.expReciept" javaScriptEscape="true" />'},
                        fieldName: "INBOUND",
                        width: 200,
                        columns : [
                        	{
        						name : "INBOUND_PLAN_QTY", fieldName: "INBOUND_PLAN_QTY",  editable: false, header: {text: '<spring:message code="lbl.qty" javaScriptEscape="true" />'},
        						dynamicStyles : [gfn_getDynamicStyle(-2)],
        						styles: {textAlignment: "far", numberFormat : "#,##0"},
        						dataType : "number",
        						width: 100
        					}, {
        						name : "INBOUND_PLAN_AMT", fieldName: "INBOUND_PLAN_AMT",  editable: false, header: {text: '<spring:message code="lbl.amount" javaScriptEscape="true" />'},
        						dynamicStyles : [gfn_getDynamicStyle(-2)],
        						styles: {textAlignment: "far", numberFormat : "#,##0"},
        						dataType : "number",
        						width: 100
        					}
                        ]
                    }
                ]
            }, {
                type: "group",
                name: '<spring:message code="lbl.srv" javaScriptEscape="true" />',
                header: {text: '<spring:message code="lbl.srv" javaScriptEscape="true" />'},
                fieldName: "PLAN_RATE",
                width: 1520,
                columns : [
                	{
						name : "FUTURE_THREE_QTY_AVG", fieldName: "FUTURE_THREE_QTY_AVG",  editable: false, header: {text: '<spring:message code="lbl.avgDemand" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0.0"},
						dataType : "number",
						width: 80
					}, {
						name : "FUTURE_THREE_AMT_AVG", fieldName: "FUTURE_THREE_AMT_AVG",  editable: false, header: {text: '<spring:message code="lbl.avgAmtDemand" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 80
					}, {
						name : "FUTURE_THREE_AVG_RATE", fieldName: "FUTURE_THREE_AVG_RATE",  editable: false, header: {text: '<spring:message code="lbl.avgDemandReal" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0.0"},
						dataType : "number",
						width: 80
					}, { //안전재고(ERP)
						name : "SS_QTY_DISP", fieldName: "SS_QTY_DISP",  editable: false, header: {text: '<spring:message code="lbl.safetyInv2" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 80
					}, { //전략재고
						name : "SBS_QTY", fieldName: "SBS_QTY",  editable: false, header: {text: '<spring:message code="lbl.strategyStock" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 80
					},
					
					
					
					
					{ /*당주 잔량*/
						name : "WEEK_REMAIN_QTY", fieldName: "WEEK_REMAIN_QTY",  editable: false, header: {text: '<spring:message code="lbl.weekRemain" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 80
					}, {
						name : "M0_QTY", fieldName: "M0_QTY",  editable: false, header: {text: '<spring:message code="lbl.m0" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 80
					}, {
						name : "M0_AMT", fieldName: "M0_AMT",  editable: false, header: {text: '<spring:message code="lbl.mAmt0" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 80
					}, {
						name : "M0_AMT_AVG", fieldName: "M0_AMT_AVG",  editable: false, header: {text: '<spring:message code="lbl.m0DemandReal" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0.0"},
						dataType : "number",
						width: 80
					}, {
						name : "M1_QTY", fieldName: "M1_QTY",  editable: false, header: {text: '<spring:message code="lbl.m1" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 80
					}, {
						name : "M1_AMT", fieldName: "M1_AMT",  editable: false, header: {text: '<spring:message code="lbl.mAmt1" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 80
					}, {
						name : "M1_AMT_AVG", fieldName: "M1_AMT_AVG",  editable: false, header: {text: '<spring:message code="lbl.m1DemandReal" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0.0"},
						dataType : "number",
						width: 80
					}, {
						name : "M2_QTY", fieldName: "M2_QTY",  editable: false, header: {text: '<spring:message code="lbl.m2" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 80
					}, {
						name : "M2_AMT", fieldName: "M2_AMT",  editable: false, header: {text: '<spring:message code="lbl.mAmt2" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 80
					}, {
						name : "M2_AMT_AVG", fieldName: "M2_AMT_AVG",  editable: false, header: {text: '<spring:message code="lbl.m2DemandReal" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0.0"},
						dataType : "number",
						width: 80
					}, {
						name : "M3_QTY", fieldName: "M3_QTY",  editable: false, header: {text: '<spring:message code="lbl.m3" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 80
					}, {
						name : "M3_AMT", fieldName: "M3_AMT",  editable: false, header: {text: '<spring:message code="lbl.mAmt3" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 80
					}, {
						name : "M3_AMT_AVG", fieldName: "M3_AMT_AVG",  editable: false, header: {text: '<spring:message code="lbl.m3DemandReal" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0.0"},
						dataType : "number",
						width: 80
					}, {
						name : "M12_QTY_CUMULATIVE", fieldName: "M12_QTY_CUMULATIVE",  editable: false, header: {text: '<spring:message code="lbl.m12" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 80
					}, {
						name : "M12_AMT_CUMULATIVE", fieldName: "M12_AMT_CUMULATIVE",  editable: false, header: {text: '<spring:message code="lbl.mAmt12" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						width: 80
					}, {
						name : "M12_AMT_AVG", fieldName: "M12_AMT_AVG",  editable: false, header: {text: '<spring:message code="lbl.m12DemandReal" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0.0"},
						dataType : "number",
						width: 80
					}, {
						name      : "ONE_YEAR_RESUTL_QTY", 
						fieldName : "ONE_YEAR_RESUTL_QTY",
						header    : {text: '<spring:message code="lbl.oneYearQty" javaScriptEscape="true" />'},
						styles    : {textAlignment: "far", numberFormat : "#,##0.0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType  : "number",
						editable  : false,
						width     : 100
					}, {
						name      : "WORK_QTY", 
						fieldName : "WORK_QTY",
						header    : {text: '<spring:message code="lbl.workQty" javaScriptEscape="true" />'},
						styles    : {textAlignment: "far", numberFormat : "#,##0.0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType  : "number",
						editable  : false,
						width     : 100
					}, {
						name      : "WORK_QTY_FINAL", 
						fieldName : "WORK_QTY_FINAL",
						header    : {text: '<spring:message code="lbl.workQtyFinal" javaScriptEscape="true" />'},
						styles    : {textAlignment: "far", numberFormat : "#,##0.0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType  : "number",
						editable  : false,
						width     : 100
					}, {
						name      : "WORK_AMT", 
						fieldName : "WORK_AMT",
						header    : {text: '<spring:message code="lbl.workAmt" javaScriptEscape="true" />'},
						styles    : {textAlignment: "far", numberFormat : "#,##0.0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType  : "number",
						editable  : false,
						width     : 100
					}, {
						name      : "AVG_TOT", 
						fieldName : "AVG_TOT",
						header    : {text: '<spring:message code="lbl.pastFutureAvg" javaScriptEscape="true" />'},
						styles    : {textAlignment: "far", numberFormat : "#,##0.0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType  : "number",
						editable  : false,
						width     : 100
					}
                ]
            }
        ];
    	
    	return columns;
    }
    
    function fn_save() {
    	var grdData = gfn_getGrdSavedataAll(grdMain);
    }
    
  	//그리드 컨트롤
    function fn_gridCtrl(obj,arrExt) {
    	var tObjColNm = $(obj).attr("val");
		var grid = sterillzeReview.sterillzeReviewGrid.grdMain;
		var columnNames = grid.getColumnNames(true);
		var visi = $(obj).is(":checked");
		columnNames = $.grep(columnNames, function(v,n) {
			return v.indexOf(tObjColNm) > -1 && $.inArray(v,arrExt) == -1;
		});
		gfn_gridCtrl(grid,columnNames,visi);
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
				<%@ include file="/WEB-INF/view/common/filterMonthSum.jsp"%>
				<div class="tabMargin"></div>
				<div class="scroll">
					<div class="view_combo" id="divItem"></div>
					<div class="view_combo" id="divProcurType"></div>
					<div class="view_combo" id="divItemType"></div>
					<div class="view_combo" id="divUpItemGroup"></div>
					<div class="view_combo" id="divItemGroup"></div>
					<div class="view_combo" id="divVariationFilter"></div>
					<div class="view_combo" id="divOutboundFilter"></div>
					<div class="view_combo" id="divInvenFilter"></div>
					<div class="view_combo" id="divVariationRateArea">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.variationRateArea" /></div>
							<input type="text" id="changeAreaStart" name="changeAreaStart" class="ipt" style="width:55px"/> <span class="ihpen">~</span>
							<input type="text" id="changeAreaEnd" name="changeAreaEnd" class="ipt" style="width:55px"/>
						</div> 
					</div>
					<div class="view_combo" id="divQtyAmtGubun">
						<strong class="filter_tit"><spring:message code="lbl.qtyAmtGubun"/></strong>
						<ul class="rdofl">
							<li><input type="checkbox" id="sQty" name="sQty" val="_QTY" checked> <label for="sQty"><spring:message code="lbl.qty"/></label></li>
							<li><input type="checkbox" id="sAmt" name="sAmt" val="_AMT" checked> <label for="sAmt"><spring:message code="lbl.amt"/></label></li>
						</ul>
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
			<div class="scroll">
				<!-- 그리드영역 -->
				<div id="realgrid" style="width: 100%;" class="realgrid1"></div>
			</div>
		</div>
    </div>
</body>
</html>
