<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	
	<script type="text/javascript">
	var enterSearchFlag = "Y";
	var workerGroupProdPlan = {

		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.workerGroupProdPlanGrid.initGrid();
			this.events();
		},
			
		_siq    : "aps.dynamic.workerGroupProdPlan",
		
		/*
		* common Code 
		*/
		comCode : {
			codeMapEx : null,			
			codeMap : null,
			
			initCode : function () {
				
				var grpCd = "PROD_PART,ITEM_TYPE";
				this.codeMap = gfn_getComCode(grpCd, 'Y'); 
				this.codeMapEx = gfn_getComCodeEx(["ITEM_GROUP"], null, {});
				this.codeMap.PROD_PART[0].CODE_NM = "";
				//this.codeMap.ITEM_TYPE = this.codeMap.ITEM_TYPE.slice(1, 2);
				
				gfn_service({
					async   : false,
					url     : GV_CONTEXT_PATH + "/biz/obj",
					data    : {_mtd : "getList", tranData:[
						{outDs : "planList", _siq : workerGroupProdPlan._siq + "PlanId"},
					]},
					success : function(data) {
						
						workerGroupProdPlan.comCode.codeMap.PLAN_ID = data.planList;
						
						$("#fromCal").val(data.planList[0].START_DAY);
						$("#toCal").val(data.planList[0].END_DAY);
						$("#startWeek").val(data.planList[0].START_WEEK);
						$("#endWeek").val(data.planList[0].END_WEEK);
						
					}
				}, "obj");
			}
		},
		 
		initFilter : function() {
			
			gfn_setMsComboAll([
				{ target : 'divPlanId', id : 'planId', title : '<spring:message code="lbl.planId"/>', data : this.comCode.codeMap.PLAN_ID, exData:[''], type : "S" },  
				{ target : 'divProdPart', id : 'prodPart', title : '<spring:message code="lbl.prodPart"/>', data : this.comCode.codeMap.PROD_PART, exData:["*"], type : "S"},
				{ target : 'divItemType', id : 'itemType', title : '<spring:message code="lbl.itemType"/>', data : this.comCode.codeMap.ITEM_TYPE, exData:[""]},
				{ target : 'divItemGroup', id : 'itemGroup'  , title : '<spring:message code="lbl.itemGroup"/>', data : this.comCode.codeMapEx.ITEM_GROUP, exData:["*"] },
				{ target : 'divWorkplaces', id : 'workplaces'  , title : '<spring:message code="lbl.workplaces"/>', data : "", exData:["*"], type : "S"},
				{ target : 'divWorkerGroup', id : 'workerGroup'  , title : '<spring:message code="lbl.workerGroup"/>', data : "", exData:["*"], type : "S"}
			]);
			
			$("#planId").change(function() {
				
				var planId = $("#planId").val();
				var planIdArray = workerGroupProdPlan.comCode.codeMap.PLAN_ID;
				
				$.each(planIdArray, function(i, val){
					
					var codeCd = val.CODE_CD;
					
					if(planId == codeCd){

						$("#fromCal").val(val.START_DAY);
						$("#toCal").val(val.END_DAY);
						$("#startWeek").val(val.START_WEEK);
						$("#endWeek").val(val.END_WEEK);
						
						return false;
					}
				});
				
			});
			
			$("#prodPart,#planId").change(function() {
				var prodPart = gfn_nvl($("#prodPart").val(), "");
				
				$("#itemType").multipleSelect("setSelects", ["10"]);
				$("#itemType").multipleSelect("disable");
				
				if(prodPart == "DIFFUSION"){
					$("#itemGroup").multipleSelect("setSelects", ["1BLB", "1BMB", "1BRB", "1TOT", "1TPT", "1TIT", "1PFP", "1PCP", "1NIN"]);
				}else if(prodPart == "TEL"){
					$("#itemGroup").multipleSelect("checkAll");
				}else{
					$("#itemGroup").multipleSelect("uncheckAll");
				}
				$("#itemGroup").multipleSelect("disable");
				
				fn_getworkplaces();
				fn_getworkerGroup();
			});
			
		},
	
		/* 
		* grid  선언
		*/
		workerGroupProdPlanGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				this.gridInstance.custNextBucketFalg = true;
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				
				var imgs = new RealGridJS.ImageList("images1", GV_CONTEXT_PATH + "/statics/images/common/");
			    imgs.addUrls([
			        "ico_srh.png"
			    ]);

			    this.grdMain.registerImageList(imgs); 
			},
		},
	
		/*
		* event 정의
		*/
		events : function () {
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			this.workerGroupProdPlanGrid.grdMain.onDataCellDblClicked = function (grid, index) {
		    	var rowId     = index.itemIndex;
	       		var field     = index.fieldName;
	       		var planId    = $("#planId").val();
	       		var startWeek = $("#startWeek").val();
	       		
	       		if(field == "REMAIN_QTY") {
	       			var prodPart = gfn_nvl($("#prodPart").val(), "");
	       			var itemType = gfn_nvl($("#itemType").val(), "");
	       			var itemGroup = gfn_nvl($("#itemGroup").val(), "");
	       			var workplaces = grid.getValue(rowId, "WC_CD");
	       			var workerGroup = grid.getValue(rowId, "WORKER_GROUP_CD");
	       			var fromCal = $("#fromCal").val();
					var toCal = $("#toCal").val();
	       			
	       			gfn_comPopupOpen("JOB_LIST", {
						rootUrl     : "aps/dynamic",
						url         : "workerGroupProdPlanJobList",
						width       : 1200,
						height      : 680,
						planId      : planId,
						prodPart    : prodPart,
						itemType    : itemType,
						itemGroup   : itemGroup,
						workplaces  : workplaces,
						workerGroup : workerGroup,
						fromCal     : fromCal,
						toCal       : toCal,
						menuCd      : "APS316",
						startWeek   : startWeek
					});
	       		}
		    };
			
		},
		
		getBucket : function(sqlFlag) {
			
			var ajaxMap = {
				fromDate : gfn_replaceAll($("#fromCal").val(), "-", ""),
				toDate   : gfn_replaceAll($("#toCal").val(), "-", ""),
	       		week     : {isDown: "Y", isUp:"N", upCal:"M", isMt:"N", isExp:"N", expCnt:1},
	       		day      : {isDown: "N", isUp:"Y", upCal:"W", isMt:"N", isExp:"N", expCnt:999}, 
				sqlId    : ["bucketWeek", "bucketDay"]
			};
			
			gfn_getBucket(ajaxMap);
			
			FORM_SEARCH.bucketList = BUCKET.query;

			if (!sqlFlag) {
				
				BUCKET.all[0] = null;
				workerGroupProdPlan.workerGroupProdPlanGrid.gridInstance.setDraw();
				
				workerGroupProdPlan.workerGroupProdPlanGrid.grdMain.setColumnProperty("REMAIN_QTY", "imageList", "images1");
				workerGroupProdPlan.workerGroupProdPlanGrid.grdMain.setColumnProperty("REMAIN_QTY", "renderer", {type : "icon"}); 
				
				workerGroupProdPlan.workerGroupProdPlanGrid.grdMain.setColumnProperty("REMAIN_QTY", "styles", {
				    textAlignment: "far",
				    iconIndex: 0,
				    iconLocation: "left",
				    iconAlignment: "center",
				    iconOffset: 4,
				    iconPadding: 2
				}); 
				
				var toDay = new Date();
				toDay = toDay.getFullYear() + '' + (toDay.getMonth() + 1 < 10 ? '0' + (toDay.getMonth() + 1) : toDay.getMonth() + 1) + (toDay.getDate() < 10 ? '0' + toDay.getDate() : toDay.getDate());
				
				for(var i = 1; i <= 7; i++) {
					workerGroupProdPlan.workerGroupProdPlanGrid.grdMain.setColumnProperty("QTY_D" + i, "header", FORM_SEARCH.bucketList[i-1].NM);
					if(FORM_SEARCH.bucketList[i-1].BUCKET_VAL >= toDay){
						workerGroupProdPlan.workerGroupProdPlanGrid.grdMain.setColumnProperty("QTY_D" + i, "styles", {"background" : "#ffffffff"});
					}
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
					
					if(id == "divPlanId"){
						EXCEL_SEARCH_DATA += $("#planId option:selected").text();
					}else if(id == "divProdPart"){
						EXCEL_SEARCH_DATA += $("#prodPart option:selected").text();
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
					}else if(id == "divWorkplaces"){
						$.each($("#workplaces option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divWorkerGroup"){
						$.each($("#workerGroup option:selected"), function(i2, val2){
							
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
						
						workerGroupProdPlan.workerGroupProdPlanGrid.dataProvider.clearRows(); //데이터 초기화
						
						//그리드 데이터 생성
						workerGroupProdPlan.workerGroupProdPlanGrid.grdMain.cancel();
						
						workerGroupProdPlan.workerGroupProdPlanGrid.dataProvider.setRows(data.resList);
						workerGroupProdPlan.workerGroupProdPlanGrid.dataProvider.clearSavePoints();
						workerGroupProdPlan.workerGroupProdPlanGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(workerGroupProdPlan.workerGroupProdPlanGrid.dataProvider.getRowCount());
						
					}
				}
			}
			
			gfn_service(aOption, "obj");
		}
		
	
	};
	
 	function fn_getworkplaces(){
		var prodPart = gfn_nvl($("#prodPart").val(), "");
		
		if(prodPart != ""){
			gfn_service({
				async   : false,
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : {_mtd : "getList", prodPart : prodPart, tranData:[
					{outDs : "workplaces", _siq : workerGroupProdPlan._siq + "Workplaces"},
				]},
				success : function(data) {
					
					gfn_setMsComboAll([
						{ target : 'divWorkplaces', id : 'workplaces'  , title : '<spring:message code="lbl.workplaces"/>', data : data.workplaces, exData:["*"], option: {allFlag:"Y"}}
					]);
					
				}
			}, "obj");
		}	
	} 
 	
 	function fn_getworkerGroup(){
		var prodPart = gfn_nvl($("#prodPart").val(), "");
		
		if(prodPart != ""){
			gfn_service({
				async   : false,
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : {_mtd : "getList", prodPart : prodPart, tranData:[
					{outDs : "workerGroup", _siq : workerGroupProdPlan._siq + "WorkerGroup"},
				]},
				success : function(data) {
					
					gfn_setMsComboAll([
						{ target : 'divWorkerGroup', id : 'workerGroup'  , title : '<spring:message code="lbl.workerGroup"/>', data : data.workerGroup, exData:["*"], option: {allFlag:"Y"}}
					]);
					
				}
			}, "obj");
		}	
	} 
	

	//조회
	var fn_apply = function (sqlFlag) {
		
		var tmpProd = gfn_nvl($("#prodPart").val(), "");
		
		if(tmpProd == ""){
			alert('<spring:message code="msg.prodPartMsg"/>');
			return;
		}
		
		// 디멘젼, 메져
		gfn_getMenuInit();
		
		DIMENSION.user = [];
		DIMENSION.user.push({DIM_CD:"PROD_PART", DIM_NM:'<spring:message code="lbl.prodPart2"/>', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"WC_CD", DIM_NM:'<spring:message code="lbl.workplacesCode"/>', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"WC_NM", DIM_NM:'<spring:message code="lbl.workplacesName"/>', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"WORKER_GROUP", DIM_NM:'<spring:message code="lbl.workerGroup"/>', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		DIMENSION.hidden.push({CD:"WORKER_GROUP_CD", dataType:"text"});
		
		//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
    	FORM_SEARCH.dimList    = DIMENSION.user;
    	
    	workerGroupProdPlan.getBucket(sqlFlag);
    	
		workerGroupProdPlan.search();
		workerGroupProdPlan.excelSubSearch();
	}
	
	function fn_setNextFieldsBuket() {
		var fields = [
			{fieldName: "REMAIN_QTY", dataType : "number"},  // 잔여수량
			{fieldName: "PLAN_QTY_W1", dataType : "number"}, // 주간 생산계획
			{fieldName: "RATE_W1", dataType : "number"},     // 당주 반영 비율
			{fieldName: "PRE_PROD", dataType : "number"},    // W - 1 선행생산
			{fieldName: "QTY_D1", dataType : "number"},
			{fieldName: "QTY_D2", dataType : "number"},
			{fieldName: "QTY_D3", dataType : "number"},
			{fieldName: "QTY_D4", dataType : "number"},
			{fieldName: "QTY_D5", dataType : "number"},
			{fieldName: "QTY_D6", dataType : "number"},
			{fieldName: "QTY_D7", dataType : "number"},
			{fieldName: "TOTAL", dataType : "number"},       // 예상 합계
			
			// 20211123 컬럼추가 요청 FROM 김동현B //////////////////////////////////////////////////
			{fieldName: "WEEKLY_PROD_PLAN_AMT", dataType : "number"},       // 주간 생산계획 금액
			{fieldName: "WEEKLY_PROD_RESULT_AMT", dataType : "number"},       // 주간 생산실적 금액
			///////////////////////////////////////////////////////////////////////////////////
			
			{fieldName: "COMP_RATE", dataType : "number"},   // 예상 달성률
			{fieldName: "PLAN_QTY_W2", dataType : "number"}, // 주간 생산계획
			{fieldName: "RATE_W2", dataType : "number"}      // 반영 비율
			
        ];
    	
    	return fields;
	}
	
	function fn_setNextColumnsBuket() {
		var columns = [	
			{ // 잔여수량
				name : "REMAIN_QTY", fieldName: "REMAIN_QTY", editable: false, header: {text: '<spring:message code="lbl.remainQty2" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 80
			}, { 
                type: "group",
                name: $("#startWeek").val(),
                header: {text : $("#startWeek").val()},
                width: 960,
                columns : [
                	{   // 주간 생산계획
						name : "PLAN_QTY_W1", fieldName: "PLAN_QTY_W1", editable: false, header: {text: '<spring:message code="lbl.prodPlanQty2" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {// 당주 반영 비율
						name : "RATE_W1", fieldName: "RATE_W1", editable: false, header: {text: '<spring:message code="lbl.refRate2" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {
		                type: "group", // 실적/계획 group
		                name: '<spring:message code="lbl.actualPlan" javaScriptEscape="true" />',
		                header: {text : '<spring:message code="lbl.actualPlan"/>'},
		                width: 560,
		                columns : [
		                	{   // W - 1 선행생산
								name : "PRE_PROD", fieldName: "PRE_PROD", editable: false, header: {text: '<spring:message code="lbl.PreproductionW1" javaScriptEscape="true" />'},
								styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
								dynamicStyles : [gfn_getDynamicStyle(-2)],
								dataType : "number",
								width: 80
							}, {
								name : "QTY_D1", fieldName: "QTY_D1", editable: false, header: {text: '<spring:message code="lbl.sunday" javaScriptEscape="true" />'},
								styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
								dynamicStyles : [gfn_getDynamicStyle(-2)],
								dataType : "number",
								width: 80
							}, {
								name : "QTY_D2", fieldName: "QTY_D2", editable: false, header: {text: '<spring:message code="lbl.monday" javaScriptEscape="true" />'},
								styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
								dynamicStyles : [gfn_getDynamicStyle(-2)],
								dataType : "number",
								width: 80
							}, {
								name : "QTY_D3", fieldName: "QTY_D3", editable: false, header: {text: '<spring:message code="lbl.tuesday" javaScriptEscape="true" />'},
								styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
								dynamicStyles : [gfn_getDynamicStyle(-2)],
								dataType : "number",
								width: 80
							}, {
								name : "QTY_D4", fieldName: "QTY_D4", editable: false, header: {text: '<spring:message code="lbl.wednesday" javaScriptEscape="true" />'},
								styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
								dynamicStyles : [gfn_getDynamicStyle(-2)],
								dataType : "number",
								width: 80
							}, {
								name : "QTY_D5", fieldName: "QTY_D5", editable: false, header: {text: '<spring:message code="lbl.thursday" javaScriptEscape="true" />'},
								styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
								dynamicStyles : [gfn_getDynamicStyle(-2)],
								dataType : "number",
								width: 80
							}, {
								name : "QTY_D6", fieldName: "QTY_D6", editable: false, header: {text: '<spring:message code="lbl.friday" javaScriptEscape="true" />'},
								styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
								dynamicStyles : [gfn_getDynamicStyle(-2)],
								dataType : "number",
								width: 80
							}, {
								name : "QTY_D7", fieldName: "QTY_D7", editable: false, header: {text: '<spring:message code="lbl.saturday" javaScriptEscape="true" />'},
								styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
								dynamicStyles : [gfn_getDynamicStyle(-2)],
								dataType : "number",
								width: 80
							}
						]
					}, { // 예상 합계
						name : "TOTAL", fieldName: "TOTAL", editable: false, header: {text: '<spring:message code="lbl.expTotal" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, 
					
					
			        // 20211123 컬럼추가 요청 FROM 김동현B //////////////////////////////////////////////////
					// WEEKLY_PROD_PLAN_AMT  주간 생산계획 금액
					{ // 예상 합계
                        name : "WEEKLY_PROD_PLAN_AMT", fieldName: "WEEKLY_PROD_PLAN_AMT", editable: false, header: {text: '<spring:message code="lbl.weekProdPlanAmt" javaScriptEscape="true" />'},
                        styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
                        dynamicStyles : [gfn_getDynamicStyle(-2)],
                        dataType : "number",
                        width: 80
                    },
					
					// WEEKLY_PROD_RESULT_AMT 주간 생산실적 금액
					{ // 예상 합계
                        name : "WEEKLY_PROD_RESULT_AMT", fieldName: "WEEKLY_PROD_RESULT_AMT", editable: false, header: {text: '<spring:message code="lbl.weekProdResultAmt" javaScriptEscape="true" />'},
                        styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
                        dynamicStyles : [gfn_getDynamicStyle(-2)],
                        dataType : "number",
                        width: 80
                    },
                    ///////////////////////////////////////////////////////////////////////////////////
					
                    
					{ // 예상 달성률
						name : "COMP_RATE", fieldName: "COMP_RATE", editable: false, header: {text: '<spring:message code="lbl.expAchieRate" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}
              	]
            },  {
                type: "group",
                name: $("#endWeek").val(),
                header: {text : $("#endWeek").val()},
                width: 160,
                columns : [
                	{   // 주간 생산계획
						name : "PLAN_QTY_W2", fieldName: "PLAN_QTY_W2", editable: false, header: {text: '<spring:message code="lbl.prodPlanQty2" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}, {// 반영 비율
						name : "RATE_W2", fieldName: "RATE_W2", editable: false, header: {text: '<spring:message code="lbl.refRate" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}
              	]
            }
		];
		return columns;
	}
	
	$(document).ready(function() {
		workerGroupProdPlan.init();
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
					<div class="view_combo" id="divPlanId"></div>
					<div class="view_combo" id="divProdPart"></div>
					<div class="view_combo" id="divItemType"></div>
					<div class="view_combo" id="divItemGroup"></div>
					<div class="view_combo" id="divWorkplaces"></div>
					<div class="view_combo" id="divWorkerGroup"></div>
					<input type="hidden" id="fromCal" name="fromCal"/>
					<input type="hidden" id="toCal" name="toCal"/>
					<input type="hidden" id="startWeek" name="startWeek"/>
					<input type="hidden" id="endWeek" name="endWeek"/>
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
