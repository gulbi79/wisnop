<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp"%>
<script type="text/javascript" src="${ctx}/statics/js/biz/gridcalc.js"></script>
<script type="text/javascript">
	var enterSearchFlag = "Y";
	//코드데이터
	var codeMap;
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
		codeMap = gfn_getComCode('PTSP_TYPE,PTSP_REASON_ID');
		//Date조회
		fn_getInitData();
	}
	
	//Date조회
	function fn_getInitData() {
		gfn_service({
			async   : false,
			url     : GV_CONTEXT_PATH + "/biz/obj.do",
			data    : {_mtd:"getList",menuParam:"AP1",tranData:[
				{outDs:"dateList",_siq:"dp.salesPerform.planSalesStatusDate"},
				{outDs:"roleList",_siq:"dp.salesPerform.planSalesStatusReasonRole"},
			]},
			success : function(data) {
				codeMap.DATE_INFO = data.dateList[0];
				codeMap.ROLE_INFO = data.roleList[0];
			}
		}, "obj");
	}
	
	//필터 초기화
	function fn_initFilter() {

		// 콤보박스
		gfn_setMsComboAll([
			{ target : 'divPtspType', id : 'ptspType', title : '<spring:message code="lbl.type"/>', data : codeMap.PTSP_TYPE , exData:[''] },
		]);
		
		//숫자만입력
		$("#ptspFrom,#ptspTo,#deltaFrom,#deltaTo").inputmask("numeric");
		
		//달력
		DATEPICKET(null, codeMap.DATE_INFO.FROM_DATE.split("-").join(""), codeMap.DATE_INFO.TO_DATE.split("-").join(""));
		$("#toCal").datepicker("option", "maxDate", codeMap.DATE_INFO.MAX_DATE);
		
		//권한정보
		$("#ap1_yn").val(codeMap.ROLE_INFO.AP1_YN);
		
		$('#ptspType').multipleSelect('setSelects', ["PTSP_TYPE_3"]);
	}
	
	//그리드를 초기화
	function fn_initGrid() {
		
		//메저 width 설정
		gv_meaW = 150;
		
		//그리드 설정
		gridInstance = new GRID();
		gridInstance.init("realgrid");
		grdMain      = gridInstance.objGrid;
		dataProvider = gridInstance.objData;
		
		fn_setFields(dataProvider);
		fn_setColumns(grdMain);
		fn_setOptions(grdMain);
		
		//스타일 추가
		grdMain.addCellStyles([
			{ id : "editStyleRow", editable : true, background : gv_editColor }
		]);
	}
	
	//그리드필드
	function fn_setFields(provider) {
		var fields = [
			{ fieldName : "YEARPWEEK" },
			{ fieldName : "CUST_GROUP_CD" },
			{ fieldName : "CUST_GROUP_NM" },
			{ fieldName : "ITEM_CD" },
			{ fieldName : "ITEM_NM" },
			{ fieldName : "SPEC" },
			{ fieldName : "DRAW_NO" },
			{ fieldName : "SALES_PLAN_QTY", dataType : "number" },
			{ fieldName : "SALES_QTY", dataType : "number" },
			{ fieldName : "PROD_PLAN_QTY", dataType : "number" },
			{ fieldName : "PROD_QTY", dataType : "number" },
			{ fieldName : "DELTA_SALES", dataType : "number" },
			{ fieldName : "DELTA_PROD", dataType : "number" },
			{ fieldName : "INV_QTY", dataType : "number" },
			{ fieldName : "PTSP", dataType : "number" },
			{ fieldName : "PTSP_TYPE" },
			{ fieldName : "QTY" },
			{ fieldName : "PTSP_REASON_ID" },
			{ fieldName : "REMARK" },
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
				name         : "YEARPWEEK",
				fieldName    : "YEARPWEEK",
				editable     : false,
				header       : { text: '<spring:message code="lbl.week"/>' },
				styles       : { background : gv_noneEditColor, lineAlignment: "near" },
				mergeRule    : { criteria : "value" },
				width        : 50,
			},
			{
				name         : "CUST_GROUP_CD",
				fieldName    : "CUST_GROUP_CD",
				editable     : false,
				header       : { text: '<spring:message code="lbl.custGroup"/>' },
				styles       : { background : gv_noneEditColor, lineAlignment: "near" },
				mergeRule    : { criteria : "values['YEARPWEEK'] + values['CUST_GROUP_CD'] + values['ITEM_CD']" },
				width        : 50,
			},
			{
				name         : "CUST_GROUP_NM",
				fieldName    : "CUST_GROUP_NM",
				editable     : false,
				header       : { text: '<spring:message code="lbl.custGroupName"/>' },
				styles       : { textAlignment: "near", background : gv_noneEditColor, lineAlignment: "near" },
				mergeRule    : { criteria : "values['YEARPWEEK'] + values['CUST_GROUP_CD'] + values['ITEM_CD']" },
				width        : 100,
			},
			{
				name         : "ITEM_CD",
				fieldName    : "ITEM_CD",
				editable     : false,
				header       : { text: '<spring:message code="lbl.item"/>' },
				styles       : { background : gv_noneEditColor, lineAlignment: "near" },
				mergeRule    : { criteria : "values['YEARPWEEK'] + values['CUST_GROUP_CD'] + values['ITEM_CD']" },
				width        : 80,
			},
			{
				name         : "ITEM_NM",
				fieldName    : "ITEM_NM",
				editable     : false,
				header       : { text: '<spring:message code="lbl.itemName"/>' },
				styles       : { textAlignment: "near", background : gv_noneEditColor, lineAlignment: "near" },
				mergeRule    : { criteria : "values['YEARPWEEK'] + values['CUST_GROUP_CD'] + values['ITEM_CD']" },
				width        : 120,
			},
			{
				name         : "SPEC",
				fieldName    : "SPEC",
				editable     : false,
				header       : { text: '<spring:message code="lbl.spec"/>' },
				styles       : { textAlignment: "near", background : gv_noneEditColor, lineAlignment: "near" },
				mergeRule    : { criteria : "values['YEARPWEEK'] + values['CUST_GROUP_CD'] + values['ITEM_CD']" },
				width        : 150,
			},
			{
				name         : "DRAW_NO",
				fieldName    : "DRAW_NO",
				editable     : false,
				header       : { text: '<spring:message code="lbl.drawNo"/>' },
				styles       : { textAlignment: "near", background : gv_noneEditColor, lineAlignment: "near" },
				mergeRule    : { criteria : "values['YEARPWEEK'] + values['CUST_GROUP_CD'] + values['ITEM_CD']" },
				width        : 120,
			},
			{
				name         : "SALES_PLAN_QTY",
				fieldName    : "SALES_PLAN_QTY",
				editable     : false,
				header       : { text: '<spring:message code="lbl.salesPlan"/>' },
				styles       : { textAlignment: "far", background : gv_noneEditColor, lineAlignment: "near", numberFormat : "#,###" },
				mergeRule    : { criteria : "values['YEARPWEEK'] + values['CUST_GROUP_CD'] + values['ITEM_CD']" },
				width        : 60,
			},
			{
				name         : "SALES_QTY",
				fieldName    : "SALES_QTY",
				editable     : false,
				header       : { text: '<spring:message code="lbl.salesQty"/>' },
				styles       : { textAlignment: "far", background : gv_noneEditColor, lineAlignment: "near", numberFormat : "#,###" },
				mergeRule    : { criteria : "values['YEARPWEEK'] + values['CUST_GROUP_CD'] + values['ITEM_CD']" },
				width        : 60,
			},
			{
				name         : "PROD_PLAN_QTY",
				fieldName    : "PROD_PLAN_QTY",
				editable     : false,
				header       : { text: '<spring:message code="lbl.prodPlan"/>' },
				styles       : { textAlignment: "far", background : gv_noneEditColor, lineAlignment: "near", numberFormat : "#,###" },
				mergeRule    : { criteria : "values['YEARPWEEK'] + values['CUST_GROUP_CD'] + values['ITEM_CD']" },
				width        : 60,
			},
			{
				name         : "PROD_QTY",
				fieldName    : "PROD_QTY",
				editable     : false,
				header       : { text: '<spring:message code="lbl.productionQty"/>' },
				styles       : { textAlignment: "far", background : gv_noneEditColor, lineAlignment: "near", numberFormat : "#,###" },
				mergeRule    : { criteria : "values['YEARPWEEK'] + values['CUST_GROUP_CD'] + values['ITEM_CD']" },
				width        : 60,
			},
			{
				name         : "DELTA_SALES",
				fieldName    : "DELTA_SALES",
				editable     : false,
				header       : { text: '<spring:message code="lbl.deltaSales"/>' },
				styles       : { textAlignment: "far", background : gv_noneEditColor, lineAlignment: "near", numberFormat : "#,###" },
				mergeRule    : { criteria : "values['YEARPWEEK'] + values['CUST_GROUP_CD'] + values['ITEM_CD']" },
				width        : 60,
			},
			{
				name         : "DELTA_PROD",
				fieldName    : "DELTA_PROD",
				editable     : false,
				header       : { text: '<spring:message code="lbl.deltaProd"/>' },
				styles       : { textAlignment: "far", background : gv_noneEditColor, lineAlignment: "near", numberFormat : "#,###" },
				mergeRule    : { criteria : "values['YEARPWEEK'] + values['CUST_GROUP_CD'] + values['ITEM_CD']" },
				width        : 60,
			},
			{
				name         : "INV_QTY",
				fieldName    : "INV_QTY",
				editable     : false,
				header       : { text: '<spring:message code="lbl.invBoh"/>' },
				styles       : { textAlignment: "far", background : gv_noneEditColor, lineAlignment: "near", numberFormat : "#,###" },
				mergeRule    : { criteria : "values['YEARPWEEK'] + values['CUST_GROUP_CD'] + values['ITEM_CD']" },
				width        : 60,
			},
			{
				name         : "PTSP",
				fieldName    : "PTSP",
				editable     : false,
				header       : { text: '<spring:message code="lbl.ptsp"/>' },
				styles       : { textAlignment: "far", background : gv_noneEditColor, lineAlignment: "near", numberFormat : "#,###.0" },
				mergeRule    : { criteria : "values['YEARPWEEK'] + values['CUST_GROUP_CD'] + values['ITEM_CD']" },
				width        : 60,
			},
			{
				name         : "PTSP_TYPE",
				fieldName    : "PTSP_TYPE",
				editable     : false,
				header       : { text: '<spring:message code="lbl.type"/>' },
				styles       : { textAlignment: "near", background : gv_noneEditColor },
				editor       : { type: "dropDown", domainOnly: true },
				values       : gfn_getArrayExceptInDs(codeMap.PTSP_TYPE, "CODE_CD", ""),
				labels       : gfn_getArrayExceptInDs(codeMap.PTSP_TYPE, "CODE_NM", ""),
				nanText      : "",
				lookupDisplay: true,
				width        : 100
			},
			{
				name         : "QTY",
				fieldName    : "QTY",
				editable     : false,
				header       : { text: '<spring:message code="lbl.qty"/>' },
				styles       : { textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,###" },
				width        : 60,
			},
			{
				name         : "PTSP_REASON_ID",
				fieldName    : "PTSP_REASON_ID",
				editable     : false,
				header       : { text: '<spring:message code="lbl.reason"/>' },
				styles       : { textAlignment: "near", background : gv_noneEditColor },
				editor       : { type: "dropDown", domainOnly: true },
				nanText      : "",
				lookupDisplay: true,
				width        : 200,
				lookupSourceId :"LOOKUP_PTSP_REASON_ID", 
				lookupKeyFields:["PTSP_TYPE","PTSP_REASON_ID"]
			},
			{
				name         : "REMARK",
				fieldName    : "REMARK",
				editable     : false,
				header       : { text: '<spring:message code="lbl.remark"/>' },
				styles       : { textAlignment: "near", background : gv_noneEditColor },
				width        : 150,
			},
			{
				name         : "UPDATE_DTTM",
				fieldName    : "UPDATE_DTTM",
				editable     : false,
				header       : { text: '<spring:message code="lbl.updateDttm"/>' },
				styles       : { background : gv_noneEditColor },
				width        : 120,
			},
			{
				name         : "UPDATE_ID",
				fieldName    : "UPDATE_ID",
				editable     : false,
				header       : { text: '<spring:message code="lbl.updateBy"/>' },
				styles       : { background : gv_noneEditColor },
				width        : 100,
			},
			{
				name         : "CREATE_DTTM",
				fieldName    : "CREATE_DTTM",
				editable     : false,
				header       : { text: '<spring:message code="lbl.createDttm"/>' },
				styles       : { background : gv_noneEditColor },
				width        : 120,
			},
			{
				name         : "CREATE_ID",
				fieldName    : "CREATE_ID",
				editable     : false,
				header       : { text: '<spring:message code="lbl.createBy"/>' },
				styles       : { background : gv_noneEditColor },
				width        : 100,
			},
		];
		grdMain.setColumns(columns);
		
		//동적콤보 데이터 생성
		var lookUptemp   = "";
		var lookUpKeys   = [];
		var lookUpValues = [];
		
		$.each(codeMap.PTSP_REASON_ID, function() {
			
			if (this.ATTB_1_CD != lookUptemp) {
				lookUpKeys.push([this.ATTB_1_CD," "]);
				lookUpValues.push(" ");
				lookUptemp = this.ATTB_1_CD;
			}
			
			lookUpKeys.push([this.ATTB_1_CD,this.CODE_CD]);
			lookUpValues.push(this.CODE_NM);
		});
		
		//동적콤보 설정
		grd.setLookups([{
			id     : "LOOKUP_PTSP_REASON_ID",
			levels : 2,
			ordered: true,
			keys   : lookUpKeys,
			values : lookUpValues,
		}]);
	}
	
	//그리드 옵션
	function fn_setOptions(grd) {
		grdMain.setOptions({
			stateBar: { visible      : true  },
			sorting : { enabled      : false },
			display : { columnMovable: false }
		});
	}
	
	//이벤트 정의
	function fn_initEvent() {
		//버튼 이벤트
		$(".fl_app"  ).click("on", function() { fn_apply(); });
		$("#btnReset").click("on", function() { fn_reset(); });
		$("#btnSave" ).click("on", function() { fn_save(); });
	}
	
	//조회
	function fn_apply(sqlFlag) {

		//조회조건 설정
		FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
		FORM_SEARCH.sql		 = sqlFlag;
		FORM_SEARCH.hrcyFlag = true;
		
		//메인 데이터를 조회
		fn_getGridData();
	}
	
	//그리드 데이터 조회
	function fn_getGridData(sqlFlag) {
		
		FORM_SEARCH._mtd     = "getList";
		FORM_SEARCH.tranData = [{outDs:"gridList",_siq:"dp.salesPerform.planSalesStatusReason"}];
		
		gfn_service({
			url    : GV_CONTEXT_PATH + "/biz/obj.do",
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
				// 그리드 데이터 건수 출력
				gfn_setSearchRow(dataProvider.getRowCount());
				//
				fn_gridCallback();
			}
		}, "obj");
	}
	
	function fn_gridCallback() {
		
		if (codeMap.ROLE_INFO.AP1_YN != "Y") {
			return;
		}
				
		var pweek, editDataRows = [];
		for (var i=0; i<dataProvider.getRowCount(); i++) {
			
			pweek = dataProvider.getValue(i, "YEARPWEEK");
			if (codeMap.DATE_INFO.TO_PWEEK <= pweek && pweek <= codeMap.DATE_INFO.MAX_PWEEK) {
				if (dataProvider.getValue(i, "PTSP_TYPE") != "PTSP_TYPE_1") {
					editDataRows.push(i);
				}
			}
		}
		
		if (editDataRows.length > 0) {
			grdMain.setCellStyles(editDataRows, ["PTSP_REASON_ID","REMARK"], "editStyleRow");
			$("#btnReset,#btnSave").show();
		}
	}
	
	//그리드 초기화
	function fn_reset() {
		grdMain.cancel();
		dataProvider.rollback(dataProvider.getSavePoints()[0]);
	}
	
	//그리드 저장
	function fn_save() {
		
		//수정된 그리드 데이터
		var grdData = gfn_getGrdSavedataAll(grdMain);
		if (grdData.length == 0) {
			alert('<spring:message code="msg.noChangeData"/>');
			return;
		}
		
		confirm('<spring:message code="msg.saveCfm"/>', function() {
			//저장
			FORM_SAVE          = {}; //초기화
			FORM_SAVE._mtd     = "saveUpdate";
			FORM_SAVE.tranData = [
				{outDs:"saveCnt",_siq:"dp.salesPerform.planSalesStatusReason",grdData:grdData},
			];
			gfn_service({
				url     : GV_CONTEXT_PATH + "/biz/obj.do",
				data    : FORM_SAVE,
				success : function(data) {
					alert('<spring:message code="msg.saveOk"/>');
					fn_apply();
				}
			}, "obj");
		});
	}
	
	function fn_checkClose() {
		return gfn_getGrdSaveCount(grdMain) == 0;
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
				<input type="hidden" id="ap1_yn" name="ap1_yn" />
				<div id="filterDv">
					<div class="inner">
						<h3>Filter</h3>
						<div class="tabMargin"></div>
						<div class="scroll">
							<div class="view_combo" id="divPtspType"></div>
							<div class="view_combo">
								<div class="ilist">
									<div class="itit"><spring:message code="lbl.ptsp" /></div>
									<input type="text" id="ptspFrom" name="ptspFrom" class="ipt" style="width:55px"> <span class="ihpen">~</span>
									<input type="text" id="ptspTo" name="ptspTo" class="ipt" style="width:55px">
								</div> 
							</div>
							<div class="view_combo">
								<div class="ilist">
									<div class="itit"><spring:message code="lbl.deltaSales" /></div>
									<input type="text" id="deltaFrom" name="deltaFrom" class="ipt" style="width:55px"> <span class="ihpen">~</span>
									<input type="text" id="deltaTo" name="deltaTo" class="ipt" style="width:55px">
								</div> 
							</div>
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
			</div>
			<div class="cbt_btn" style="height:25px">
				<div class="bleft"></div>
				<div class="bright">
					<a style="display:none" href="javascript:;" id="btnReset" class="app1"><spring:message code="lbl.reset"/></a>
					<a style="display:none" href="javascript:;" id="btnSave" class="app2 roleWrite"><spring:message code="lbl.save"/></a>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
