<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	<script type="text/javascript">
	
	//전역변수
	var enterSearchFlag = "Y";
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
		// 공통코드 조회 
		codeMap = gfn_getComCode('FLAG_YN', "Y");
	}
	
	//필터 초기화
	function fn_initFilter() {
		
		// 키워드팝업
		gfn_keyPopAddEvent([
			{ target : 'divCustomer', id : 'customer', type : 'CUSTOMER', title : '<spring:message code="lbl.customer"/>' }
		]);
		
		// 콤보박스
		gfn_setMsComboAll([
			{ target : 'divValidYnERP', id : 'validYnERP', title : '<spring:message code="lbl.validYnErp"/>', data : codeMap.FLAG_YN, exData:[], type : "S" },
		]);
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
			{ fieldName : "CUST_CD" },
			{ fieldName : "CUST_NM" },
			{ fieldName : "CUST_TYPE" },
			{ fieldName : "CUST_TYPE_NM" },
			{ fieldName : "COUNTRY_CD" },
			{ fieldName : "CURRENCY" },
			{ fieldName : "CUST_GROUP_CD" },
			{ fieldName : "CUST_GROUP_NM" },
			{ fieldName : "REP_CUST_GROUP_CD" },
			{ fieldName : "REP_CUST_GROUP_NM" },
			{ fieldName : "CUST_LVL1_CD" },
			{ fieldName : "CUST_LVL1_NM" },
			{ fieldName : "CUST_LVL2_CD" },
			{ fieldName : "CUST_LVL2_NM" },
			{ fieldName : "CUST_LVL3_CD" },
			{ fieldName : "CUST_LVL3_NM" },
			{ fieldName : "CUST_LVL4_CD" },
			{ fieldName : "CUST_LVL4_NM" },
			{ fieldName : "VALID_FLAG" },
			{ fieldName : "UPDATE_DTTM" },
			{ fieldName : "UPDATE_ID" },
			{ fieldName : "CREATE_DTTM" },
			{ fieldName : "CREATE_ID" },
		];
		dataProvider.setFields(fields);
	}
	
	//그리드컬럼
	function fn_setColumns(grd) {
		var columns = [
			{
				name         : "CUST_CD",
				fieldName    : "CUST_CD",
				editable     : false,
				header       : { text: '<spring:message code="lbl.customer"/>' },
				styles       : { textAlignment: "near" },
				width        : 80,
			},
			{
				name         : "CUST_NM",
				fieldName    : "CUST_NM",
				editable     : false,
				header       : { text: '<spring:message code="lbl.customerName"/>' },
				styles       : { textAlignment: "near" },
				width        : 150,
			},
			{
				name         : "CUST_TYPE_NM",
				fieldName    : "CUST_TYPE_NM",
				editable     : false,
				header       : { text: '<spring:message code="lbl.customerType"/>' },
				styles       : { textAlignment: "near" },
				width        : 100,
			},
			{
				name         : "COUNTRY_CD",
				fieldName    : "COUNTRY_CD",
				editable     : false,
				header       : { text: '<spring:message code="lbl.country"/>' },
				width        : 80,
			},
			{
				name         : "CURRENCY",
				fieldName    : "CURRENCY",
				editable     : false,
				header       : { text: '<spring:message code="lbl.currency"/>' },
				width        : 80,
			},
			{
				name         : "CUST_GROUP_CD",
				fieldName    : "CUST_GROUP_CD",
				editable     : false,
				header       : { text: '<spring:message code="lbl.custGroup"/>' },
				styles       : { textAlignment: "near" },
				width        : 80,
			},
			{
				name         : "CUST_GROUP_NM",
				fieldName    : "CUST_GROUP_NM",
				editable     : false,
				header       : { text: '<spring:message code="lbl.custGroupName"/>' },
				styles       : { textAlignment: "near" },
				width        : 150,
			},
			{
				name         : "REP_CUST_GROUP_CD",
				fieldName    : "REP_CUST_GROUP_CD",
				editable     : false,
				header       : { text: '<spring:message code="lbl.reptCustGroup"/>' },
				styles       : { textAlignment: "near" },
				width        : 80,
			},
			{
				name         : "REP_CUST_GROUP_NM",
				fieldName    : "REP_CUST_GROUP_NM",
				editable     : false,
				header       : { text: '<spring:message code="lbl.reptCustGroupName"/>' },
				styles       : { textAlignment: "near" },
				width        : 150,
			},
			{
				name         : "CUST_LVL1_NM",
				fieldName    : "CUST_LVL1_NM",
				editable     : false,
				header       : { text: '<spring:message code="lbl.custL1Name"/>' },
				styles       : { textAlignment: "near" },
				width        : 150,
			},
			{
				name         : "CUST_LVL2_NM",
				fieldName    : "CUST_LVL2_NM",
				editable     : false,
				header       : { text: '<spring:message code="lbl.custL2Name"/>' },
				styles       : { textAlignment: "near" },
				width        : 150,
			},
			{
				name         : "CUST_LVL3_NM",
				fieldName    : "CUST_LVL3_NM",
				editable     : false,
				header       : { text: '<spring:message code="lbl.custL3Name"/>' },
				styles       : { textAlignment: "near" },
				width        : 150,
			},
			{
				name         : "VALID_FLAG",
				fieldName    : "VALID_FLAG",
				editable     : false,
				header       : { text: '<spring:message code="lbl.validYnErp"/>' },
				width        : 80,
			},
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
			},
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
		FORM_SEARCH.tranData = [{outDs:"rtnList",_siq:"master.master.customer"}];
		
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
		EXCEL_SEARCH_DATA += "Customer" + " : ";
		EXCEL_SEARCH_DATA += $("#loc_customer").html();
		
		$.each($(".view_combo"), function(i, val){
			
			var temp = "";
			var id = gfn_nvl($(this).attr("id"), "");
			
			if(id != ""){
				
				var name = $("#" + id + " .ilist .itit").html();
				
				//타이틀
				EXCEL_SEARCH_DATA += "\n" + name + " : ";	
				
				//데이터
				if(id == "divCustomer"){
					EXCEL_SEARCH_DATA += $("#customer_nm").val();
				}else if(id == "divValidYnERP"){
					EXCEL_SEARCH_DATA += $("#validYnERP option:selected").text();
				}
			}
		});
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
							<div class="view_combo" id="divCustomer"></div>
							<div class="view_combo" id="divValidYnERP"></div>
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
