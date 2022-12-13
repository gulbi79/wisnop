<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="wi.com.wisnop.dto.common.MenuVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp"%>
<script type="text/javascript" src="${ctx}/statics/js/biz/gridcalcBucket.js"></script>
<script type="text/javascript">
	var enterSearchFlag = "Y";
	var codeMap;
	var gridInstance, grdMain, dataProvider;
	var gridInstanceExcel, grdMainExcel, dataProviderExcel;
	var datePickerOption;
	var planConfirmWidth = 0;
	
	//그리드 자동계산용
	var apMeaCompare = "AP2_SP";
	var apMeaCd = "CFM_SP"; 
	var apAmtCd = "CFM_SP_AMT_KRW";
	var EXCEL_GRID_DATA;
	
	$(function() {
		gfn_formLoad(); 	//공통 초기화
		fn_initData(); 		//데이터 초기화
		fn_initFilter(); 	//필터 초기화
		fn_initGrid();		//그리드 초기화
		fn_initEvent();		//이벤트 초기화
	});
	
	//데이터 초기화
	function fn_initData() {
		
		// 공통코드 조회 
		codeMap = gfn_getComCode('SP_DATA_CHECK,SO_DATA_CHECK,DISAGGREGATION_RULE', "Y");
		//Plan Version & AP1 조회
		fn_getInitData();
	}

	//Plan Version & AP1 조회
	function fn_getInitData() {
		gfn_service({
			async   : false,
			url     : GV_CONTEXT_PATH + "/biz/obj",
			data    : {_mtd : "getList", menuParam : "CFM", tranData:[
				{outDs:"planList",_siq:"dp.planMonth.planConfirmationVersion"},
				{outDs:"roleList",_siq:"dp.planCommon.salesPlanRole"},
				{outDs:"ap13mWeek" ,_siq:"dp.planCommon.ap13mWeek"},
				{outDs:"planIdPast" ,_siq:"dp.planMonth.planIdPast"},
				{outDs:"currentWeek" ,_siq:"dp.planCommon.currentWeek"},
			]},
			success : function(data) {
				
				codeMap.PLAN_INFO = data.planList[0];
				codeMap.ROLE_INFO = data.roleList[0];
				codeMap.AP1_3M_WEEK = data.ap13mWeek;
				codeMap.CURRENT_WEEK = data.currentWeek;
				codeMap.PLAN_ID_PAST = data.planIdPast;
			}
		}, "obj");
		
	}

	//필터 초기화
	function fn_initFilter() {

		//키워드팝업
		gfn_keyPopAddEvent([
			{ target : 'divItem', id : 'item', type : 'COM_ITEM_PLAN', title : '<spring:message code="lbl.item"/>' }
		]);
		
		//콤보박스
		gfn_setMsComboAll([
			{ target : 'divDataCheck', id : 'dataCheck', title : '<spring:message code="lbl.dataCheck"/>', data : codeMap.SP_DATA_CHECK, exData:["INV_WIP", "WIP_SP"], type : "S" },
			{ target : 'divSoDataCheck', id : 'soDataCheck', title : '<spring:message code="lbl.soDataCheck"/>', data : codeMap.SO_DATA_CHECK, exData:["OPEN_SO_SP", "OPEN_SO_SP2", "OPEN_SO_INV_WIP"], type : "S" },
			{ target : 'divDataAddSales', id : 'dataAddSales', title : '<spring:message code="lbl.dataAddSales"/>', data : codeMap.SP_DATA_CHECK, exData:["SALES_PRICE", "CFM_AP2_DIFF"], type : "S" },
			{ target : 'divDisaRule', id : 'disaRule', title : '<spring:message code="lbl.disaggregationRule"/>', data : codeMap.DISAGGREGATION_RULE, exData:[''], type : "S" },
			{ target : 'divPlanIdPast', id : 'planIdPast', title : '<spring:message code="lbl.planId"/>', data : codeMap.PLAN_ID_PAST, exData:[''], type : "S" },
		]);
		
		var baseDt = new Date();
		var yymmdd = baseDt.getFullYear() + '' + (baseDt.getMonth() + 1 < 10 ? '0' + (baseDt.getMonth() + 1) : baseDt.getMonth() + 1) + (baseDt.getDate() < 10 ? '0' + baseDt.getDate() : baseDt.getDate());
		
		//달력
		datePickerOption = DATEPICKET(null, codeMap.PLAN_INFO.MIN_DATE.split("-").join(""), codeMap.PLAN_INFO.MAX_DATE.split("-").join(""));
		
		$("#fromCal").datepicker("option", "minDate", codeMap.PLAN_INFO.MIN_LAST_DATE);
		$("#fromCal").datepicker('disable').removeAttr('disabled')
		$("#toCal").datepicker("option", "maxDate", codeMap.PLAN_INFO.MAX_LAST_DATE);
		$("#toCal").datepicker('disable').removeAttr('disabled');

		//필터값 초기화
		$("#disaRule").val("SALES_3M");
		
		//Plan Version 정보
		$("#planStartPW").val(codeMap.PLAN_INFO.MIN_PWEEK);
		$("#planEndPW").val(codeMap.PLAN_INFO.MAX_PWEEK);
		$("#planStartDay").val(codeMap.PLAN_INFO.MIN_DATE.split("-").join(""));
		$("#planEndDay").val(codeMap.PLAN_INFO.MAX_DATE.split("-").join(""));
		$("#planId").val(codeMap.PLAN_INFO.PLAN_ID);
		gv_bucketW = 60;

		//권한정보
		$("#ap1_yn").val(codeMap.ROLE_INFO.AP1_YN);
		$("#ap2_yn").val(codeMap.ROLE_INFO.AP2_YN);
		$("#goc_yn").val(codeMap.ROLE_INFO.GOC_YN);
		$("#currentDay").val(yymmdd);
		$("#dimWeek").val(codeMap.PLAN_ID_PAST[0].DIM_WEEK);
		$("#partADimWeek").val(codeMap.PLAN_ID_PAST[0].PART_A_DIM_WEEK);
		$("#partBDimWeek").val(codeMap.PLAN_ID_PAST[0].PART_B_DIM_WEEK);
		$("#qtyDate").val(codeMap.PLAN_ID_PAST[0].QTY_DATE);
		$("#planStartWeek").val(codeMap.PLAN_ID_PAST[0].START_WEEK);
		$("#planEndWeek").val(codeMap.PLAN_ID_PAST[0].END_WEEK);
		$("#startRemains").val(codeMap.PLAN_ID_PAST[0].START_REMAINS);
		$("#endRemains").val(codeMap.PLAN_ID_PAST[0].END_REMAINS);
		$("#startMonth").val(codeMap.PLAN_ID_PAST[0].START_MONTH);
		
	}
	
	//그리드를 초기화
	function fn_initGrid() {
		//메저 width 설정
		gv_meaW = 140;
		//메인그리드 초기화
		fn_initGridMain();
		
		GRIDCALC.gridInst = gridInstance;
		GRIDCALC.apMeaCd = apMeaCd;
		GRIDCALC.amtMeaCd = [apAmtCd];
	}
	
	//그리드를 그린다.
	function fn_drawGridExcel() {
		
		gridInstanceExcel.setDraw();

		// Dimension 중에 숫자 타입인 필드 number 타입으로 변경
		fn_setNumberFields(dataProviderExcel);
		
		// 수정 가능하도록 변경
		var columns = grdMainExcel.getColumns();
		
		$.each(columns, function(n, v) {
			// Bucket
			if (v.type == "group") {
				
				$.each(v.columns, function(n1, v1) {
					v1.styles.background = gv_editColor;
					v1.editable = true;
					v1.editor = {
						type         : "number",
						positiveOnly : true,
						integerOnly  : true
					};
				});
			} else {
				// Remark
				if (v.name == "REMARK_NM") {
					v.styles.background = gv_editColor;
					v.editable = true;
				} else {
					v.editable = false;
				}
			}
		});
		
		grdMainExcel.setColumns(columns);
	}
	
	//메인그리드 초기화
	function fn_initGridMain() {
		
		//그리드 설정
		gridInstance = new GRID();
		gridInstance.init("realgrid");
		gridInstance.custNextBucketFalg = true;
		grdMain = gridInstance.objGrid;
		dataProvider = gridInstance.objData;
		
		//gridInstance.totalFlag = true;
		gridInstance.measureHFlag = true;
		
		//그리드 옵션
		grdMain.setOptions({
			stateBar: { visible      : true  },
			sorting : { enabled      : false },
			display : { columnMovable: false }
		});
	}
	
	//이벤트 정의
	function fn_initEvent() {
		
		//달력 이벤트
		$("#fromCal").change("on", function() {
			var tmpV = gfn_getFindDataDsInDs(datePickerOption.arrTarget, {calId : {VALUE : "fromCal", CONDI : "="}});
			gfn_onSelectFn(tmpV[0],$(this).val());
		});
		
		$("#toCal").change("on", function() { 
			var tmpV = gfn_getFindDataDsInDs(datePickerOption.arrTarget, {calId : {VALUE : "toCal", CONDI : "="}});
			gfn_onSelectFn(tmpV[0],$(this).val());
		});
		
		$("#btnSummary").on('click', function (e) {
			gfn_comPopupOpen("PLAN_SUMMARY", {
				rootUrl : "dp/salesPlan",
				url     : "PlanConfirmationMonthSummary",
				width   : 1200,
				height  : 680,
				startMonth : $("#startMonth").val(),
				pastPlanId : $("#planIdPast").val(),
				menuCd 	   : "DP208"
			});
		});
		
		$("#btnChart").on('click', function (e) {
			gfn_comPopupOpen("PLAN_MONTH_CHART", {
				rootUrl : "dp/salesPlan",
				url     : "PlanConfirmationMonthChart",
				width   : 440,
				height  : 510,
				startMonth : $("#startMonth").val(),
				pastPlanId : $("#planIdPast").val() 
			});
		});
		
		$("#planIdPast").change("on", function(){
			var tPlanIdPast = $("#planIdPast").val();
			$.each(codeMap.PLAN_ID_PAST, function(n, v){
				
				var tempVal = v.CODE_CD;
				var tStartDay = v.START_DAY.substring(0, 4) + "-" + v.START_DAY.substring(4, 6) + "-" + v.START_DAY.substring(6, 8);
				var tEndDay = v.END_DAY.substring(0, 4) + "-" + v.END_DAY.substring(4, 6) + "-" + v.END_DAY.substring(6, 8);
				var tStartWeek = v.START_WEEK;
				var tEndWeek = v.END_WEEK;
				var tDimWeek = v.DIM_WEEK;
				var tPartADimWeek = v.PART_A_DIM_WEEK;
				var tPartBDimWeek = v.PART_B_DIM_WEEK;
				var tQtyDate = v.QTY_DATE;
				var tStartRemains = v.START_REMAINS;
				var tEndRemains = v.END_REMAINS;
				var tMinLastDate = v.MIN_LAST_DATE;
				var tMaxLastDate = v.MAX_LAST_DATE;
				var tStartMonth = v.START_MONTH;
				
				if(tPlanIdPast == tempVal){
					
					$("#fromCal").datepicker("option", "minDate", tMinLastDate);
					$("#toCal").datepicker("option", "maxDate", tMaxLastDate);
					
					$("#fromCal").val(tStartDay);
					var tmpV = gfn_getFindDataDsInDs(datePickerOption.arrTarget, {calId : {VALUE : "fromCal", CONDI : "="}});
					gfn_onSelectFn(tmpV[0], tStartDay);
					
					$("#toCal").val(tEndDay);		
					var tmpV = gfn_getFindDataDsInDs(datePickerOption.arrTarget, {calId : {VALUE : "toCal", CONDI : "="}});
					gfn_onSelectFn(tmpV[0], tEndDay);	
					
					//디멘저 생산계획, 생산미반영, 예상주말재고, 가용수량을 구하기 위한 주차 세팅
					$("#dimWeek").val(tDimWeek);
					$("#partADimWeek").val(tPartADimWeek);
					$("#partBDimWeek").val(tPartBDimWeek);
					$("#planStartWeek").val(tStartWeek);
					$("#planEndWeek").val(tEndWeek);
					$("#qtyDate").val(tQtyDate);
					$("#startRemains").val(tStartRemains);
					$("#endRemains").val(tEndRemains);
					$("#startMonth").val(tStartMonth);
				}
			});
		});
		
		// 버튼 이벤트
		$(".fl_app").click ("on", function() { fn_apply(); });
		$("#btnMonthOut").show();
		
		//month sum omit0 처리
		gfn_setMonthSum(gridInstance, true, true, true, false, true);
	}
	
	//조회
	function fn_apply(sqlFlag) {
		
		if (sqlFlag != true) {
			//메인그리드 보이기
			if (!$("#realgrid").is(":visible")) {
				$("#realgridExcel").hide();
				$("#realgrid").show();
			}
		}
		
		gfn_getMenuInit();		//디멘전 메저 조회
		fn_getBucket("Y").then(function() {
			
			fn_drawGrid(sqlFlag);	//그리드를 그린다.
			
			// 파람값 셋팅
			$.each(BUCKET.query, function(n, v) {
     			
     			var vCd = v.CD;
         		var vRootCd = v.ROOT_CD;
         		if(vRootCd.indexOf("MT_") != -1){ //토탈일경우
         			var tmpWorkCnt = 0;
         			$.each(BUCKET.all[1], function(nn, vv) {
         				var bucketId = vv.BUCKET_ID;
						var vvRootCd = vv.ROOT_CD;
						var vvWrokCnt = vv.WORK_CNT;
						if(vRootCd == bucketId){
							tmpWorkCnt += Number(vvWrokCnt);
							v.ROOT_CD = vvRootCd;
						}
         			});
         			v.WORK_CNT = tmpWorkCnt;
         			v.TOT_TYPE = "MT";
         			
         		}else{ //토탈이 아닐경우
         			$.each(BUCKET.all[1], function(nn, vv) {
						var bucketId = vv.BUCKET_ID;
						var vvRootCd = vv.ROOT_CD;
						var vvWrokCnt = vv.WORK_CNT;
						if(vRootCd == bucketId){
							v.ROOT_CD = vvRootCd;
							v.WORK_CNT = vvWrokCnt;
						}
         			});
         		}
         		
         		if(vCd.indexOf("_CFM_SP_AMT_KRW") != -1){
    				v.FLAG = "KRW";
    			}else{
    				if(vCd.indexOf("_CFM_SP") != -1){
    					v.FLAG = "QTY";	
    					v.CD_SUB = v.CD + "_" + apMeaCompare;
    				}
    			}
         	});
			
			 
			var tCurrentWeek = codeMap.CURRENT_WEEK[0]; // 현재주차
			var tFomWeek = $("#fromWeek").val();
			var tFormPWeek = $("#fromPWeek").val();
			var tToWeek = $("#toWeek").val();
			var tToPWeek = $("#toPWeek").val();
			
			$("#futurePlanIdStartWeek").val(tFormPWeek);  
			$("#futurePlanIdEndWeek").val(tToPWeek); 
			
			FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
			FORM_SEARCH.sql		   = sqlFlag;
	   		FORM_SEARCH.hrcyFlag   = true;
	   		FORM_SEARCH.dimList	   = DIMENSION.user;
	   		FORM_SEARCH.hiddenList = DIMENSION.hidden;
	   		FORM_SEARCH.meaList	   = MEASURE.user;
	   		
	   		fn_BUCKET_CUSTOM();
	   		
	   		FORM_SEARCH.bucketList = BUCKET.query;
	   		
	   		fn_getGridData();	   		
	   		fn_getExcelData();
		});
	}
	
	//버켓정보 조회(그리드 타이틀 세팅 조회)
	function fn_getBucket(isWeekMt) {
		
		var deferred = $.Deferred();
		
		$("#fromMon").val("");
		$("#toMon").val("");
		
		var fromDate, toDate;
		if (isWeekMt == "Y") {
			fromDate = gfn_replaceAll($("#fromCal").val(),"-","");
			toDate   = gfn_replaceAll($("#toCal").val(),"-","");
		} else {
			fromDate = gfn_replaceAll(codeMap.PLAN_INFO.MIN_DATE,"-","");
			toDate   = gfn_replaceAll(codeMap.PLAN_INFO.MAX_DATE,"-","");
		}
		
		var ajaxMap = {
   			fromDate: fromDate,
	   		toDate  : toDate,
	   		month   : {isDown: "Y", isUp:"N", upCal:"Q", isMt:"N", isExp:"Y", expCnt:999},
	   		week	: {isDown: isWeekMt, isUp:"Y", upCal:"M", isMt:isWeekMt, isExp:"N", expCnt:999},
	   		sqlId   : ["bucketMonth", "bucketWeek"]
		}
		
		if (isWeekMt == "Y") {
			gfn_getBucket(ajaxMap, true, fn_bucketMeasure);	
		}else{
			gfn_getBucket(ajaxMap);	
		}
		
		return deferred.resolve();
	}
	
	//버켓정보 조회(그리드 타이틀 세팅 조회) 콜백
	function fn_bucketMeasure() {
    	
		// Month Total 컬럼(타이틀) 셋팅
		$.each(BUCKET.all[1], function(n, v) {
    		var vRootCd = gfn_replaceAll(v.ROOT_CD, "M", "");
    		var tFromMon = gfn_nvl($("#fromMon").val(), "");
    		var tToMon = gfn_nvl($("#toMon").val(), "");
    		
    		if (v.TOT_TYPE == "MT") {
    			v.TOT_TYPE = "";
    			v.TYPE = "group";
    			
    			if(tFromMon == ""){
    				$("#fromMon").val(vRootCd);
    			}
    			$("#toMon").val(vRootCd);
    		}
    	});
		
    }
	// Dimension 중에 숫자 타입인 필드 number 타입으로 변경 
	function fn_setNumberFields(provider) {
		var fileds = provider.getFields();
		var tDimWeek = $("#dimWeek").val().substring(4, 6);
		var tPartADimWeek = $("#partADimWeek").val().substring(4, 7);
		var tPartBDimWeek = $("#partBDimWeek").val().substring(4, 7);
		var tStartWeek = $("#planStartWeek").val().substring(4, 6);
		for (var i = 0; i < fileds.length; i++) {
			
			var fieldName = fileds[i].fieldName;
			
			if (fieldName == 'SS_QTY_NM' || fieldName == 'SO_QTY_NM' || fieldName == 'INV_QTY_NM' || fieldName == 'WIP_MFG_QTY_NM' || fieldName == 'WIP_QC_QTY_NM' ||
				fieldName == 'SALES_QTY_Y1_NM' || fieldName == 'YTD_QTY_NM' || fieldName == 'SALES_1M_WEEK_NM' || fieldName == 'SALES_3M_WEEK_NM' || fieldName == 'SALES_12M_WEEK_NM' ||
				fieldName == 'TOTAL_OPEN_SO_NM' || fieldName == 'SALES_PRICE_KRW_NM' || fieldName == 'DIM_PROD_PLAN_QTY_NM' || fieldName == 'DIM_PROD_NO_REFLECTION_NM' || fieldName == 'DIM_CALC_EOH_QTY_NM' ||
				fieldName == 'DIM_AVAIL_QTY_NM' || fieldName == 'DIM_ALLOC_QTY_W_NM' || fieldName == 'DIM_PROD_PLAN_QTY_REMAINS_NM'
			) {
				fileds[i].dataType = "number";
				
				if (fieldName == 'DIM_ALLOC_QTY_W_NM'){
					grdMain.setColumnProperty(fieldName, "styles", {"numberFormat" : "#,##0.0"});
				}else{
					grdMain.setColumnProperty(fieldName, "styles", {"numberFormat" : "#,##0"});	
				}
				
				if(fieldName == 'DIM_PROD_PLAN_QTY_NM' || fieldName == 'DIM_PROD_NO_REFLECTION_NM' ||
				   fieldName == 'DIM_CALC_EOH_QTY_NM' || fieldName == 'DIM_AVAIL_QTY_NM' || fieldName == 'DIM_ALLOC_QTY_W_NM'
				   || fieldName == 'DIM_PROD_PLAN_QTY_REMAINS_NM'){
					
					var headerName = gfn_nvl(grdMain.getColumnProperty(fieldName, "header"), "")
					
					if(headerName != ""){
						var tText = headerName.text;
						
						if(fieldName == 'DIM_PROD_PLAN_QTY_REMAINS_NM'){
							grdMain.setColumnProperty(fieldName, "header", tStartWeek + ' <spring:message code="lbl.weekDim"/> ' + tText);
						}else if(fieldName == 'DIM_AVAIL_QTY_NM'){
							grdMain.setColumnProperty(fieldName, "header", tPartADimWeek + ' <spring:message code="lbl.weekDim"/> ' + tText);
						}else if(fieldName == 'DIM_CALC_EOH_QTY_NM'){
							grdMain.setColumnProperty(fieldName, "header", tPartBDimWeek + ' <spring:message code="lbl.weekDim"/> ' + tText);
						}else{
							grdMain.setColumnProperty(fieldName, "header", tDimWeek + ' <spring:message code="lbl.weekDim"/> ' + tText);	
						}
					}
				}
			}
		}
		provider.setFields(fileds);
	}
	
	//그리드를 그린다.
	function fn_drawGrid(sqlFlag) {
		
		if (sqlFlag) {
			return;
		}
		
		// 데이터셋에만 존재하는 컬럼 추가
    	DIMENSION.hidden = [];
    	DIMENSION.hidden.push({CD : "SALES_1M", dataType : "number"});
    	DIMENSION.hidden.push({CD : "SALES_3M", dataType : "number"});
    	DIMENSION.hidden.push({CD : "SALES_12M", dataType : "number"});
    	DIMENSION.hidden.push({CD : "SALES_PRICE_KRW_HIDDEN", dataType : "number"});
    	DIMENSION.hidden.push({CD : "SALES_3M_WEEK_HIDDEN", dataType : "number"});
    	DIMENSION.hidden.push({CD : "PROD_LVL2_CD", dataType : "text"});
    	DIMENSION.hidden.push({CD : "CONFIRM_YN", dataType : "text"});
    	DIMENSION.hidden.push({CD : "CATEGORY_CD", dataType : "text"});
    	DIMENSION.hidden.push({CD : "DIM_AVAIL_QTY_HIDDEN", dataType : "number"});
    	DIMENSION.hidden.push({CD : "DIM_CFM_SP_HIDDEN", dataType : "number"});

		gridInstance.setDraw();
		
		// Dimension 중에 숫자 타입인 필드 number 타입으로 변경
		fn_setNumberFields(dataProvider);
	}
	
	//그리드 데이터 조회
	function fn_getGridData() {
		
		FORM_SEARCH._mtd     = "getList";
		FORM_SEARCH.tranData = [
			{outDs : "gridList", _siq : "dp.planMonth.planConfirmation"}
		];
		
		gfn_service({
			url    : GV_CONTEXT_PATH + "/biz/obj",
			data   : FORM_SEARCH,
			success: function(data) {
				
				var tPlanIdPast = $("#planIdPast").val(); 
				
				//그리드 데이터 삭제
				dataProvider.clearRows();
				grdMain.cancel();
				//그리드 데이터 생성
				dataProvider.setRows(data.gridList);
				//그리드 초기화 포인트 저장
				dataProvider.clearSavePoints();
				dataProvider.savePoint();
				
				//month sum omit0
				gfn_actionMonthSum(gridInstance);
				planConfirmWidth = MEASURE.user.length * 60; 
			}
		}, "obj");
	}
	
	function fn_getExcelData(){
		
		EXCEL_SEARCH_DATA = "";
		EXCEL_SEARCH_DATA += "Product" + " : ";
		EXCEL_SEARCH_DATA += $("#loc_product").html();
		EXCEL_SEARCH_DATA += "\nCustomer" + " : ";
		EXCEL_SEARCH_DATA += $("#loc_customer").html();
		
		$.each($(".view_combo"), function(i, val){
			
			var temp = "";
			var id = gfn_nvl($(this).attr("id"), "");
			
			if(id != ""){
				
				var name = $("#" + id + " .ilist .itit").html();
				
				//타이틀
				EXCEL_SEARCH_DATA += "\n" + name + " : ";	
				
				//데이터
				if(id == "divItem"){
					EXCEL_SEARCH_DATA += $("#item_nm").val();
				}else if(id == "divRemark"){
					EXCEL_SEARCH_DATA += $("#remark").val();
				}else if(id == "divDrawNo"){
					EXCEL_SEARCH_DATA += $("#drawNo").val();
				}else if(id == "divDataCheck"){
					EXCEL_SEARCH_DATA += $("#dataCheck option:selected").text();
				}else if(id == "divDataAddSales"){
					EXCEL_SEARCH_DATA += $("#dataAddSales option:selected").text();
				}else if(id == "divSoDataCheck"){
					EXCEL_SEARCH_DATA += $("#soDataCheck option:selected").text();
				}else if(id == "divDisaRule"){
					EXCEL_SEARCH_DATA += $("#disaRule option:selected").text();
				}else if(id == "divPlanIdPast"){
					EXCEL_SEARCH_DATA += $("#planIdPast option:selected").text();
				}
			}
		});
		
		EXCEL_SEARCH_DATA += "\n" + '<spring:message code="lbl.period"/>' + " : ";
		EXCEL_SEARCH_DATA += $("#fromCal").val() + "(" + $("#fromPWeek").val() + ") ~ ";
		EXCEL_SEARCH_DATA += $("#toCal").val() + "(" + $("#toPWeek").val() + ")";
		
	}
	
	function fn_BUCKET_CUSTOM(bucket){
		   
		
		for(i=0;i < MEASURE.user.length;i++){
			
			BUCKET.query[i].BUCKET_RND = 1;
			
		}
		
	}
</script>
</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp"%>
	<!-- left -->
	<div id="a" class="split split-horizontal">
		<!-- tree -->
		<div id="c" class="split content">
			<%@ include file="/WEB-INF/view/common/leftTree.jsp"%>
		</div>
		<!-- filter -->
		<div id="d" class="split content">
			<form id="searchForm" name="searchForm">
				<%-- Plan ID 정보 --%>
				<input type="hidden" id="planStartPW" name="planStartPW" />
				<input type="hidden" id="planEndPW" name="planEndPW" />
				<input type="hidden" id="planStartDay" name="planStartDay" />
				<input type="hidden" id="planEndDay" name="planEndDay" />
				<input type="hidden" id="planId" name="planId" />
				<input type="hidden" id="ap1_yn" name="ap1_yn" />
				<input type="hidden" id="ap2_yn" name="ap2_yn" />
				<input type="hidden" id="goc_yn" name="goc_yn" />
				<input type="hidden" id="fromMon" name="fromMon" />
				<input type="hidden" id="toMon" name="toMon" />
				<input type="hidden" id="currentDay" name="currentDay" />
				<input type="hidden" id="pastPlanIdStartWeek" name="pastPlanIdStartWeek" />
				<input type="hidden" id="pastPlanIdEndWeek" name="pastPlanIdEndWeek" />
				<input type="hidden" id="futurePlanIdStartWeek" name="futurePlanIdStartWeek" />
				<input type="hidden" id="futurePlanIdEndWeek" name="futurePlanIdEndWeek" />
				<input type="hidden" id="dimWeek" name="dimWeek" />
				<input type="hidden" id="partADimWeek" name="partADimWeek" />
				<input type="hidden" id="partBDimWeek" name="partBDimWeek" />
				<input type="hidden" id="planStartWeek" name="planStartWeek" />
				<input type="hidden" id="planEndWeek" name="planEndWeek" />
				<input type="hidden" id="qtyDate" name="qtyDate" />
				<input type="hidden" id="startRemains" name="startRemains" />
				<input type="hidden" id="endRemains" name="endRemains" />
				<input type="hidden" id="startMonth" name="startMonth" />
				<!-- <input type="hidden" id="menuParam" name="menuParam" value="CFM" /> -->
				<div id="filterDv">
					<div class="inner">
						<h3>Filter</h3>
						<%@ include file="/WEB-INF/view/common/filterMonthSum.jsp"%>
						<div class="tabMargin"></div>
						<div class="scroll">
							<div class="view_combo" id="divItem"></div>
							<div class="view_combo" id="divRemark">
								<div class="ilist">
									<div class="itit"><spring:message code="lbl.remark"/></div>
									<input type="text" id="remark" name="remark" class="ipt"/>
								</div>
							</div>
							<div class="view_combo" id="divDrawNo">
								<div class="ilist">
									<div class="itit"><spring:message code="lbl.drawNo"/></div>
									<input type="text" id="drawNo" name="drawNo" class="ipt"/>
								</div>
							</div>
							<div class="view_combo" id="divDataCheck"></div>
							<div class="view_combo" id="divDataAddSales"></div>
							<div class="view_combo" id="divSoDataCheck"></div>
							<div class="view_combo" id="divDisaRule"></div>
							<div class="view_combo" id="divPlanIdPast"></div>
							<jsp:include page="/WEB-INF/view/common/filterViewHorizon.jsp" flush="false">
								<jsp:param name="radioYn" value="N" />
								<jsp:param name="wType" value="PW" />
							</jsp:include>
						</div>
						<div class="bt_btn">
							<a href="javascript:;" class="fl_app"><spring:message code="lbl.search" /></a>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
	<!-- contents -->
	<div id="b" class="split split-horizontal">
		<div id="grid1" class="fconbox">
			<%@ include file="/WEB-INF/view/common/commonLocation.jsp"%>
			<div class="scroll">
				<!-- 그리드영역 -->
				<div id="realgrid" class="realgrid1"></div>
				<div id="realgridExcel" class="realgrid1" style="display: none"></div>
			</div>
			<div class="cbt_btn">
				<div class="bleft"></div>
				<div class="bright">
					<a href="javascript:;" id="btnChart" class="app1"><spring:message code="lbl.chart" /></a>
					<a href="javascript:;" id="btnSummary" class="app1"><spring:message code="lbl.summary" /></a>
				</div>
			</div>
		</div>
		
	</div>
</body>
</html>
