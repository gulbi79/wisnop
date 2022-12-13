<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp"%>
<script type="text/javascript" src="${ctx}/statics/js/biz/gridcalc.js"></script>
<script type="text/javascript">
	var enterSearchFlag = "Y";
	//코드데이터
	var codeMap = {};
	var codeMapEx;
	//그리드
	var gridInstance, grdMain, dataProvider;

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
		
		codeMap = gfn_getComCode('PTSP_TYPE', "Y");
		codeMapEx = gfn_getComCodeEx(["REP_CUST_GROUP", "CUST_GROUP", "ITEM_GROUP"]);
		//Date조회
		fn_getInitData();
	}
	
	//Date조회
	function fn_getInitData() {

		gfn_service({
			async   : false,
			url     : GV_CONTEXT_PATH + "/biz/obj",
			data    : {_mtd : "getList", menuParam : "CFM", tranData : [
				{outDs:"dateList", _siq:"dp.salesPerform.planSalesStatusDate"},
			]},
			success : function(data) {
				codeMap.DATE_INFO = data.dateList[0];
			}
		}, "obj");
	}
	
	//필터 초기화
	function fn_initFilter() {
		
		gfn_keyPopAddEvent([
			{target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>'}
		]);

		// 콤보박스
		gfn_setMsComboAll([
			{target : 'divItemGroup', id : 'itemGroup', title : '<spring:message code="lbl.itemGroup"/>', data : codeMapEx.ITEM_GROUP, exData:["*"]},
			{target : 'divReptCustGroup', id : 'reptCustGroup', title : '<spring:message code="lbl.reptCustGroup"/>', data : codeMapEx.REP_CUST_GROUP, exData:["*"]},
			{target : 'divCustGroup', id : 'custGroup', title : '<spring:message code="lbl.custGroup"/>', data : codeMapEx.CUST_GROUP, exData:["*"]},
			{target : 'divPtspType', id : 'ptspType', title : '<spring:message code="lbl.type"/>', data : codeMap.PTSP_TYPE , exData:['*'], type : "S"},
		]);
		
		//달력
		DATEPICKET(null, codeMap.DATE_INFO.TO_DATE.split("-").join(""), codeMap.DATE_INFO.TO_DATE.split("-").join(""));
		$("#toCal").datepicker("option", "maxDate", codeMap.DATE_INFO.TO_DATE);
		
		$("#ptspType").val("PTSP_TYPE_3");
	}
	
	//그리드를 초기화
	function fn_initGrid() {
		
		//메저 width 설정
		gv_meaW = 100;
		
		//그리드 설정
		gridInstance = new GRID();
		gridInstance.init("realgrid");
		grdMain      = gridInstance.objGrid;
		dataProvider = gridInstance.objData;
		
		//그리드 옵션
		grdMain.setOptions({
			display : { columnMovable: false }
		});
	}
	
	//이벤트 정의
	function fn_initEvent() {
		//버튼 이벤트
		$(".fl_app").click ("on", function() { 
			fn_apply(); 
		});
		
		$("#btnChart").on('click', function (e) {
			gfn_comPopupOpen("PLAN_CHART", {
				rootUrl : "dp/salesPerform",
				url     : "planSalesStatusChart",
				width   : 1060,
				height  : 540,
				fromWeek: $("#fromWeek").val(),
		   		toWeek  : $("#toWeek").val(),
		   		ptspType : $("#ptspType").val()
			});
		});
		
		
		
		//month sum omit0 처리
		gfn_setMonthSum(gridInstance, true, true, true);
	}
	
	//조회
	function fn_apply(sqlFlag) {

		gfn_getMenuInit();		//디멘전 메저 조회
		fn_getBucket();			//버켓정보 조회
		fn_drawGrid(sqlFlag);	//그리드를 그린다.

		//조회조건 설정
		FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
		FORM_SEARCH.sql		   = sqlFlag;
		FORM_SEARCH.hrcyFlag   = true;
		FORM_SEARCH.dimList	   = DIMENSION.user;
		FORM_SEARCH.meaList	   = MEASURE.user;
		FORM_SEARCH.bucketList = BUCKET.query;
		
		//console.log("FORM_SEARCH : ", FORM_SEARCH);

		//메인 데이터를 조회
		fn_getGridData();
	}
	
	//버켓정보 조회
	function fn_getBucket() {
		var ajaxMap = {
			fromDate : $("#fromCal").val().replace(/-/g, ''),
			toDate   : $("#toCal"  ).val().replace(/-/g, ''),
			month   : {isDown: "Y", isUp:"N", upCal:"Q", isMt:"N", isExp:"Y", expCnt:999},
	   		week	: {isDown: "N", isUp:"Y", upCal:"M", isMt:"Y", isExp:"Y", expCnt:999},
	   		sqlId   : ["bucketMonth", "bucketFullWeek"]
		}
		gfn_getBucket(ajaxMap);
		
		$.each(BUCKET.query, function(n, v){
			var vCd = v.CD;
			v.CD_SUB1 = vCd + "_PLAN_SET_ITEM_COUNT"; 
			v.CD_SUB2 = vCd + "_PLAN_ACHIEVE_ITEM_COUNT"; 
			v.CD_SUB3 = vCd + "_PLAN_OVER_ITEM_COUNT"; 
			v.CD_SUB4 = vCd + "_PLAN_SHORT_ITEM_COUNT"; 
		});
	}
	
	//그리드를 그린다.
	function fn_drawGrid(sqlFlag) {
		
		if (sqlFlag) {
			return;
		}
    	
		gridInstance.setDraw();
	}
	
	//그리드 데이터 조회
	function fn_getGridData(sqlFlag) {
		
		FORM_SEARCH._mtd     = "getList";
		FORM_SEARCH.tranData = [{outDs:"gridList",_siq:"dp.salesPerform.planSalesStatus"}];
		
		gfn_service({
			url    : GV_CONTEXT_PATH + "/biz/obj",
			data   : FORM_SEARCH,
			success: function(data) {
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
				gfn_setRowTotalFixed(grdMain);
			}
		}, "obj");
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
			<input type="hidden" id="omitBaseCd" name="omitBaseCd" value="PLAN_SET_ITEM_COUNT"/>
				<div id="filterDv">
					<div class="inner">
						<h3>Filter</h3>
						<%@ include file="/WEB-INF/view/common/filterMonthSum.jsp"%>
						<div class="tabMargin"></div>
						<div class="scroll">
							<div class="view_combo" id="divPtspType"></div>
							<div class="view_combo" id="divItem"></div>
							<div class="view_combo" id="divItemGroup"></div>
							<div class="view_combo" id="divReptCustGroup"></div>
							<div class="view_combo" id="divCustGroup"></div>
							<jsp:include page="/WEB-INF/view/common/filterViewHorizon.jsp" flush="false">
								<jsp:param name="radioYn" value="N" />
								<jsp:param name="wType" value="SW" />
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
			</div>
			<div class="cbt_btn">
				<div class="bleft"></div>
				<div class="bright">
					<a href="javascript:;" id="btnChart" class="app1"><spring:message code="lbl.chart" /></a>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
