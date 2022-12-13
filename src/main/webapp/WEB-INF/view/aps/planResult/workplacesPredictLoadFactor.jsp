<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
<!-- 과거 실적 조회 -->
	<script type="text/javascript">

	var enterSearchFlag = "Y";
	
	var workplacesPredictLoadFactor = {

		init : function () {
			
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.workGrid.initGrid();
		},
			
		_siq    : "aps.planResult.workplacesPredictLoadFactor",
		
		initFilter : function() {
			// 콤보박스
			gfn_setMsComboAll([
				{ target : 'divPlanId', id : 'planId', title : '<spring:message code="lbl.planId2"/>', data : this.comCode.codeMap.PLAN_ID, exData:[''], type : "S" },
				{ target : 'divProdPart', id : 'prodPart', title : '<spring:message code="lbl.prodPart2"/>', data : this.comCode.codeMap.PROD_PART, exData:[""]},
				{ target : 'divWorkplaces', id : 'workplaces', title : '<spring:message code="lbl.workplaces"/>', data : this.comCode.codeMapEx.WORK_PLACES_CD, exData:[""]},
				{ target : 'divWeekMonth', id : 'weekMonth', title : '<spring:message code="lbl.horizon"/>', data : this.comCode.codeMap.BUCKET_CD, exData:[""], type : "R"}
			]);
			
			$('input:radio[name=weekMonth]:input[value=WEEK]').attr("checked", true);
			
			$("#planId").change(function() {
				
				var planId = $("#planId").val();
				var planIdArray = workplacesPredictLoadFactor.comCode.codeMap.PLAN_ID;
				
				$.each(planIdArray, function(i, val){
					
					var codeCd = val.CODE_CD;
					
					if(planId == codeCd){
						
						var startDay = val.START_DAY;
						
						var DATE_plus_42 = weekdatecal(startDay,42);
					    var DATE_plus_180 = weekdatecal(startDay,364);
					    
						var tStartMon = startDay.substring(0, 4) + startDay.substring(4, 6);
						var tCloseMon = gfn_addDate("month", 5, "", tStartMon + "01").substring(0, 6);
						var ttCloseMon = gfn_addDate("month", 11, "", tStartMon + "01").substring(0, 6);
						
						var sdt = gfn_getStringToDate(startDay);
						var edt = gfn_getStringToDate(DATE_plus_180);
						
						
						var minMonthStart = gfn_getStringToDate(tStartMon + "01");
						var maxMonthClose = gfn_getStringToDate(tCloseMon + "01");
						var maxMonthEdt =  gfn_getStringToDate(ttCloseMon + "01");
						
						datePickerOption = DATEPICKET(null, startDay, DATE_plus_42);
						$("#fromCal").datepicker("option", "minDate", sdt);
						$("#toCal").datepicker("option", "maxDate", edt);
						
						MONTHPICKER(null, tStartMon, tCloseMon);
						$("#fromMon").monthpicker("option", "minDate", minMonthStart);
						$("#toMon").monthpicker("option", "maxDate", maxMonthEdt);
						
						return false;
					}
				});
			});
		},
		
		/*
		* common Code 
		*/
		comCode : {
			
			codeMap   : null,
			codeMapEx : null,
			
			initCode  : function () {
				var grpCd    = 'PROD_PART,BUCKET_CD';
				this.codeMap = gfn_getComCode(grpCd);
				this.codeMapEx = gfn_getComCodeEx(["WORK_PLACES_CD" ], null, {});
				
				gfn_service({
					async   : false,
					url     : GV_CONTEXT_PATH + "/biz/obj",
					data    : {_mtd : "getList", tranData:[
						{outDs : "planList", _siq : "aps.planResult.planIdLoadFactor"},
					]},
					success : function(data) {
						
						workplacesPredictLoadFactor.comCode.codeMap.PLAN_ID = data.planList;
						
						
						
						var startDay = data.planList[0].START_DAY;
						var DATE_plus_42 = weekdatecal(startDay,42);
					    var DATE_plus_180 = weekdatecal(startDay,364);
					    
						var tStartMon = startDay.substring(0, 4) + startDay.substring(4, 6);
						var tCloseMon = gfn_addDate("month", 5, "", tStartMon + "01").substring(0, 6);
						var ttCloseMon = gfn_addDate("month", 11, "", tStartMon + "01").substring(0, 6);
						
						var sdt = gfn_getStringToDate(startDay);
						var edt = gfn_getStringToDate(DATE_plus_180);
						
						
						var minMonthStart = gfn_getStringToDate(tStartMon + "01");
						var maxMonthClose = gfn_getStringToDate(tCloseMon + "01");
						var maxMonthEdt =  gfn_getStringToDate(ttCloseMon + "01");
						
						datePickerOption = DATEPICKET(null, startDay, DATE_plus_42);
						$("#fromCal").datepicker("option", "minDate", sdt);
						$("#toCal").datepicker("option", "maxDate", edt);
						
						MONTHPICKER(null, tStartMon, tCloseMon);
						$("#fromMon").monthpicker("option", "minDate", minMonthStart);
						$("#toMon").monthpicker("option", "maxDate", maxMonthEdt);
					
						$("#filterViewMonth").hide();
					}
				}, "obj");
			}
		},
	
		/* 
		* grid  선언
		*/
		workGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				this.gridInstance.custBeforeDimensionFalg = true;
				this.gridInstance.totalFlag = true;
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				
				gfn_setMonthSum(workplacesPredictLoadFactor.workGrid.gridInstance, false, false, true);
			}
		},
	
		/*
		* event 정의
		*/
		events : function () {
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("input:radio[name=weekMonth]").click(function(){
				
				var selectVal = $(':radio[name="weekMonth"]:checked').val();
				
				if(selectVal == "WEEK"){
					$("#filterViewWeek").show();
					$("#filterViewMonth").hide();
				}else if(selectVal == "MONTH"){
					$("#filterViewMonth").show();
					$("#filterViewWeek").hide();
				}
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
					
					if(id == "divPlanId"){
						EXCEL_SEARCH_DATA += $("#planId option:selected").text();
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
					}else if(id == "divWeekMonth"){
						
						var weekMonth = $('input[name="weekMonth"]:checked').val();
						
						if(weekMonth == "WEEK"){
							EXCEL_SEARCH_DATA += '<spring:message code="lbl.week"/>';
						}else if(weekMonth == "MONTH"){
							EXCEL_SEARCH_DATA += '<spring:message code="lbl.mon"/>';
						}
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
						workplacesPredictLoadFactor.workGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						workplacesPredictLoadFactor.workGrid.grdMain.cancel();
						
						workplacesPredictLoadFactor.workGrid.dataProvider.setRows(data.resList);
						workplacesPredictLoadFactor.workGrid.dataProvider.clearSavePoints();
						workplacesPredictLoadFactor.workGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(workplacesPredictLoadFactor.workGrid.dataProvider.getRowCount());
						
						workplacesPredictLoadFactor.workGrid.grdMain.setColumnProperty("CATEGORY_NM", "dynamicStyles", function(grid, index, value) {
							return {background : gfn_getArrDimColor(0)};
						});
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		getBucket : function (sqlFlag) {
			
			var ajaxMap;
			var selectVal = $(':radio[name="weekMonth"]:checked').val();
			
			if(selectVal == "WEEK"){
				ajaxMap = {
					fromDate : gfn_replaceAll($("#fromCal").val(),"-",""),
					toDate   : gfn_replaceAll($("#toCal").val(),"-",""),
					week     : {isDown: "Y", isUp : "N", upCal : "M", isMt : "N", isExp : "N", expCnt : 999},
					sqlId    : ["bucketFullWeek"]
				}	
			}else if(selectVal == "MONTH"){
				ajaxMap = {
					fromDate : gfn_replaceAll($("#fromMon").val(),"-","") + "01",
					toDate   : gfn_replaceAll($("#toMon").val(),"-","") + "31",
					month    : {isDown: "Y", isUp : "N", upCal : "Q", isMt : "N", isExp : "N", expCnt : 999},
					sqlId    : ["bucketMonth"]
				}
			}
			
			gfn_getBucket(ajaxMap);
			
			if (!sqlFlag) {
				workplacesPredictLoadFactor.workGrid.gridInstance.setDraw();
				
				$.each(BUCKET.query, function(n, v) {
					workplacesPredictLoadFactor.workGrid.grdMain.setColumnProperty(v.CD, "dynamicStyles", [
						{
		    				criteria : "(values['CATEGORY_CD'] = 'NEED_TIME')",
		    				styles   : {numberFormat : "#,##0"}
		    			},
		    			{
		    				criteria : "(values['CATEGORY_CD'] = 'AVAIL_TIME')",
		    				styles   : {numberFormat : "#,##0"}
		    			},
		    			{
		    				criteria : "(values['CATEGORY_CD'] = 'LOAD_FACTOR') and (value > 0)",
		    				styles   : {numberFormat : "#,##0", suffix: " %"}
		    			}
					]);
				});
				
				workplacesPredictLoadFactor.workGrid.grdMain.setColumnProperty("TOTAL", "dynamicStyles", [
					{
	    				criteria : "(values['CATEGORY_CD'] = 'NEED_TIME')",
	    				styles   : {numberFormat : "#,##0"}
	    			},
	    			{
	    				criteria : "(values['CATEGORY_CD'] = 'AVAIL_TIME')",
	    				styles   : {numberFormat : "#,##0"}
	    			},
	    			{
	    				criteria : "(values['CATEGORY_CD'] = 'LOAD_FACTOR') and (value > 0)",
	    				styles   : {numberFormat : "#,##0", suffix: " %"}
	    			}
				]);
			}
		}
	};

	//조회
	var fn_apply = function (sqlFlag) {
		
		// 디멘젼, 메져
		gfn_getMenuInit();
		
		workplacesPredictLoadFactor.getBucket(sqlFlag); //2. 버켓정보 조회
    	
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
   		//FORM_SEARCH.hrcyFlag   = true;
   		FORM_SEARCH.dimList    = DIMENSION.user;
   		FORM_SEARCH.meaList    = MEASURE.user;
   		FORM_SEARCH.bucketList = BUCKET.query;
   		FORM_SEARCH.totalFlag  = workplacesPredictLoadFactor.workGrid.gridInstance.totalFlag;
   		
		workplacesPredictLoadFactor.search();
		workplacesPredictLoadFactor.excelSubSearch();
	};
	
	function fn_setNextFieldsBuket() {
		var fields = [
			{fieldName: "PROD_PART", dataType : "text"},
			{fieldName: "PROD_OR_QC", dataType : "text"},
			{fieldName: "WC_CD", dataType : "text"},
			{fieldName: "WC_NM", dataType : "text"},
			{fieldName: "RESOURCE_TYPE", dataType : "text"},
			{fieldName: "RESOURCE_CNT", dataType : "text"},
			{fieldName: "AVAIL_CNT", dataType : "text"}
        ];
    	
    	return fields;
	}
	
	function fn_setNextColumnsBuket() {
		var totAr =  ['PROD_PART', 'PROD_OR_QC', 'WC_CD', 'WC_NM', 'RESOURCE_TYPE', 'RESOURCE_CNT'];
		var columns = 
		[
			{ 
				name : "PROD_PART", fieldName : "PROD_PART", editable : false, header: {text: '<spring:message code="lbl.prodPart2" javaScriptEscape="true" />'},
				styles : {textAlignment: "near", background : gfn_getArrDimColor(0)},
				width : 80,
				mergeRule : { criteria: "value" },
				dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
			}, {
				name : "PROD_OR_QC", fieldName : "PROD_OR_QC", editable : false, header: {text: '<spring:message code="lbl.prodOrQc" javaScriptEscape="true" />'},
				styles : {textAlignment: "center", background : gfn_getArrDimColor(0)},
				width : 80,
				mergeRule : { criteria: "value" },
				dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
			}, { 
				name : "WC_CD", fieldName : "WC_CD", editable : false, header: {text: '<spring:message code="lbl.workplacesCode" javaScriptEscape="true" />'},
				styles : {textAlignment: "near", background : gfn_getArrDimColor(0)},
				width : 80,
				mergeRule : { criteria: "value" },
				dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
			}, {
				name : "WC_NM", fieldName : "WC_NM", editable : false, header: {text: '<spring:message code="lbl.workplacesName" javaScriptEscape="true" />'},
				styles : {textAlignment: "center", background : gfn_getArrDimColor(0)},
				width : 80,
				mergeRule : { criteria: "value" },
				dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
			}, { 
				name : "RESOURCE_TYPE", fieldName : "RESOURCE_TYPE", editable : false, header: {text: '<spring:message code="lbl.workplacesType" javaScriptEscape="true" />'},
				styles : {textAlignment: "near", background : gfn_getArrDimColor(0)},
				width : 80,
				mergeRule : { criteria: "value" },
				dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
			}, {
				name : "RESOURCE_CNT", fieldName : "RESOURCE_CNT", editable : false, header: {text: '<spring:message code="lbl.resourceCnt" javaScriptEscape="true" />'},
				styles : {textAlignment: "center", background : gfn_getArrDimColor(0)},
				width : 80,
				mergeRule : { criteria: "value" },
				dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
			},{
				name : "AVAIL_CNT", fieldName : "AVAIL_CNT", editable : false, header: {text: '<spring:message code="lbl.availResourceCnt" javaScriptEscape="true" />'},
				styles : {textAlignment: "center", background : gfn_getArrDimColor(0)},
				width : 80,
				mergeRule : { criteria: "value" },
				dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
			}
			
		];
		
		return columns;
	}
	
	function weekdatecal(dt, days){
		
    	yyyy = dt.substr(0, 4);
    	mm   = dt.substr(4, 2);
    	dd   = dt.substr(6, 2);
    	
    	var date = new Date(yyyy + "/" + mm + "/" + dd);
    	
    	date.setDate(date.getDate() + days);
    	
    	var rdt = date.getFullYear() + '' + ((date.getMonth() + 1)  < 10 ? '0' + (date.getMonth() + 1) : (date.getMonth() + 1) ) + (date.getDate() < 10 ? '0' + date.getDate() : date.getDate());
    	
    	return rdt;
    }
	
	// onload 
	$(document).ready(function() {
		workplacesPredictLoadFactor.init();
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
					<div class="view_combo" id="divWorkplaces"></div> 
					<div class="view_combo" id="divWeekMonth"></div> 
					<div id="filterViewWeek"><%@ include file="/WEB-INF/view/common/filterViewHorizon.jsp" %></div>
					<div id="filterViewMonth"><%@ include file="/WEB-INF/view/common/filterViewHorizonMonth.jsp" %></div>
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
