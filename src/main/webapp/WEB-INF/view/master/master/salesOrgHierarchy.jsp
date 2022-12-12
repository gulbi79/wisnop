<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	<script type="text/javascript">
	
	//전역변수
	var codeMap;
	var gridInstance, grdMain, dataProvider;
	
	$(function() {
		gfn_formLoad();		//공통 초기화
		fn_initData();		//데이터 초기화
		fn_initFilter();	//필터 초기화
		fn_initGrid();		//그리드 초기화
		fn_initEvent();		//이벤트 초기화
	});
	
	//데이터 초기화
	function fn_initData() {
		
	}
	
	//필터 초기화
	function fn_initFilter() {
		
	}
	
	//그리드 초기화
	function fn_initGrid() {
		//그리드 설정
		gridInstance = new GRID();
		gridInstance.init("realgrid");
		grdMain	     = gridInstance.objGrid;
		dataProvider = gridInstance.objData;
		
		fn_setFields(dataProvider);
		fn_setColumns(grdMain);
	}
	
	//그리드필드
	function fn_setFields(provider) {
		var fields = [
			{ fieldName : "COMPANY_CD" },
			{ fieldName : "BU_CD" },
			{ fieldName : "SALES_ORG_LVL1_CD" },
			{ fieldName : "SALES_ORG_LVL1_NM" },
			{ fieldName : "SALES_ORG_LVL2_CD" },
			{ fieldName : "SALES_ORG_LVL2_NM" },
			{ fieldName : "SALES_ORG_LVL3_CD" },
			{ fieldName : "SALES_ORG_LVL3_NM" },
			{ fieldName : "SALES_ORG_LVL4_CD" },
			{ fieldName : "SALES_ORG_LVL4_NM" },
			{ fieldName : "SALES_ORG_LVL5_CD" },
			{ fieldName : "SALES_ORG_LVL5_NM" }
			/*
			2020-11-30
			UV_MAP_SALES_ORG 테이블 컬럼에 아래 컬럼 정보가 존재하지 않아 수정함
			
			{ fieldName : "UPDATE_DTTM" },
			{ fieldName : "UPDATE_ID" },
			{ fieldName : "CREATE_DTTM" },
			{ fieldName : "CREATE_ID" },
			*/
		];
		dataProvider.setFields(fields);
	}
	
	//그리드컬럼
	function fn_setColumns(grd) {
		var columns = [
			{
				name         : "SALES_ORG_LVL1_CD",
				fieldName    : "SALES_ORG_LVL1_CD",
				editable     : false,
				header       : { text: '<spring:message code="lbl.salesOrgL1"/>' },
				styles       : { textAlignment: "near" },
				width        : 80,
			},
			{
				name         : "SALES_ORG_LVL1_NM",
				fieldName    : "SALES_ORG_LVL1_NM",
				editable     : false,
				header       : { text: '<spring:message code="lbl.salesOrgL1Name"/>' },
				styles       : { textAlignment: "near" },
				width        : 150,
			},
			{
				name         : "SALES_ORG_LVL2_CD",
				fieldName    : "SALES_ORG_LVL2_CD",
				editable     : false,
				header       : { text: '<spring:message code="lbl.salesOrgL2"/>' },
				styles       : { textAlignment: "near" },
				width        : 80,
			},
			{
				name         : "SALES_ORG_LVL2_NM",
				fieldName    : "SALES_ORG_LVL2_NM",
				editable     : false,
				header       : { text: '<spring:message code="lbl.salesOrgL2Name"/>' },
				styles       : { textAlignment: "near" },
				width        : 150,
			},
			{
				name         : "SALES_ORG_LVL3_CD",
				fieldName    : "SALES_ORG_LVL3_CD",
				editable     : false,
				header       : { text: '<spring:message code="lbl.salesOrgL3"/>' },
				styles       : { textAlignment: "near" },
				width        : 80,
			},
			{
				name         : "SALES_ORG_LVL3_NM",
				fieldName    : "SALES_ORG_LVL3_NM",
				editable     : false,
				header       : { text: '<spring:message code="lbl.salesOrgL3Name"/>' },
				styles       : { textAlignment: "near" },
				width        : 150,
			},
			{
				name         : "SALES_ORG_LVL4_CD",
				fieldName    : "SALES_ORG_LVL4_CD",
				editable     : false,
				header       : { text: '<spring:message code="lbl.salesOrgL4"/>' },
				styles       : { textAlignment: "near" },
				width        : 80,
			},
			{
				name         : "SALES_ORG_LVL4_NM",
				fieldName    : "SALES_ORG_LVL4_NM",
				editable     : false,
				header       : { text: '<spring:message code="lbl.salesOrgL4Name"/>' },
				styles       : { textAlignment: "near" },
				width        : 150,
			},
			{
				name         : "SALES_ORG_LVL5_CD",
				fieldName    : "SALES_ORG_LVL5_CD",
				editable     : false,
				header       : { text: '<spring:message code="lbl.salesOrgL5"/>' },
				styles       : { textAlignment: "near" },
				width        : 80,
			},
			{
				name         : "SALES_ORG_LVL5_NM",
				fieldName    : "SALES_ORG_LVL5_NM",
				editable     : false,
				header       : { text: '<spring:message code="lbl.salesOrgL5Name"/>' },
				styles       : { textAlignment: "near" },
				width        : 150,
			}
			/*
			2020-11-30
			UV_MAP_SALES_ORG 테이블 컬럼에 아래 컬럼 정보가 존재하지 않아 수정함
			
			{
				name         : "UPDATE_DTTM",
				fieldName    : "UPDATE_DTTM",
				editable     : false,
				header       : { text: '<spring:message code="lbl.updateDttm"/>' },
				width        : 120,
			},
			{
				name         : "UPDATE_ID",
				fieldName    : "UPDATE_ID",
				editable     : false,
				header       : { text: '<spring:message code="lbl.updateBy"/>' },
				styles       : { textAlignment: "near" },
				width        : 100,
			},
			{
				name         : "CREATE_DTTM",
				fieldName    : "CREATE_DTTM",
				editable     : false,
				header       : { text: '<spring:message code="lbl.createDttm"/>' },
				width        : 120,
			},
			{
				name         : "CREATE_ID",
				fieldName    : "CREATE_ID",
				editable     : false,
				header       : { text: '<spring:message code="lbl.createBy"/>' },
				styles       : { textAlignment: "near" },
				width        : 100,
			}
			*/
		];
		grdMain.setColumns(columns);
	}
	
	//이벤트 초기화
	function fn_initEvent() {
		$(".fl_app").click("on", function() { fn_apply(); });
	}
	
	//조회
	function fn_apply(sqlFlag) {
		
		//조회조건 설정
		FORM_SEARCH = $("#searchForm").serializeObject();
		
		//그리드 데이터 조회
		fn_getGridData(sqlFlag);
		fn_getExcelData();
	}
	
	//그리드 데이터 조회
	function fn_getGridData(sqlFlag) {
		
		FORM_SEARCH.sql	     = sqlFlag;
		FORM_SEARCH.hrcyFlag = true;
		FORM_SEARCH._mtd     = "getList";
		FORM_SEARCH.tranData = [{outDs:"rtnList",_siq:"master.master.salesOrgHierarchy"}];
		
		gfn_service({
			url    : GV_CONTEXT_PATH + "/biz/obj.do",
			data   : FORM_SEARCH,
			success: function(data) {
				//그리드 데이터 삭제
				dataProvider.clearRows();
				grdMain.cancel();
				//그리드 데이터 생성
				dataProvider.setRows(data.rtnList);
				//그리드 초기화 포인트 저장
				dataProvider.clearSavePoints();
				dataProvider.savePoint();
				// 그리드 데이터 건수 출력
				gfn_setSearchRow(dataProvider.getRowCount());
			}
		}, "obj");
	}
	
	function fn_getExcelData(){
		
		EXCEL_SEARCH_DATA = "";
		EXCEL_SEARCH_DATA += "Sales Org" + " : ";
		EXCEL_SEARCH_DATA += $("#loc_salesOrg").html();
		
	}
	
	</script>

</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<!-- left -->
	<div id="a" class="split split-horizontal">
		<!-- tree -->
		<div id="c" class="split content">
			<%@ include file="/WEB-INF/view/common/leftTree.jsp" %>
		</div>
		<!-- filter -->
		<div id="d" class="split content">
			<form id="searchForm" name="searchForm">
				<div id="filterDv">
					<div class="inner">
						<h3>Filter</h3>
						<div class="tabMargin"></div>
						<div class="scroll">
						</div>
						<div class="bt_btn">
							<a href="javascript:;" class="fl_app"><spring:message code="lbl.search"/></a>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
	<!-- contents -->
	<div id="b" class="split split-horizontal">
		<div id="grid1" class="fconbox">
			<%@ include file="/WEB-INF/view/common/commonLocation.jsp" %>
			<div class="scroll">
				<!-- 그리드영역 -->
				<div id="realgrid" class="realgrid1"></div>
			</div>
			<div class="cbt_btn">
				<div class="bleft"></div>
				<div class="bright"></div>
			</div>
		</div>
	</div>
</body>
</html>
