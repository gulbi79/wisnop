<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp"%>
<script type="text/javascript" src="${ctx}/statics/js/biz/gridcalc.js"></script>
<script type="text/javascript">
	//전역변수
	var enterSearchFlag = "Y"; 
	var codeMap;
	var gridInstance, grdMain, dataProvider;

	$(function() {
		gfn_formLoad(); 	//공통 초기화
		fn_initData(); 		//데이터 초기화
		fn_initGrid();		//그리드 초기화
		fn_initEvent();		//이벤트 초기화
	});

	//데이터 초기화
	function fn_initData() {
		codeMap = gfn_getComCode('PROFIT_CD', "Y");
		fn_initFilter();
	}

	//필터 초기화
	function fn_initFilter() {

		//키워드팝업
		gfn_keyPopAddEvent([
			{ target : 'divItem', id : 'item', type : 'COM_ITEM_PLAN', title : '<spring:message code="lbl.item"/>' }
		]);
		
		gfn_setMsComboAll([
			{target : 'divProfitCode', id : 'profitCode', title : '<spring:message code="lbl.contain"/>', data : this.codeMap.PROFIT_CD, exData:[""]}
		]);

		//숫자만입력
		$("#deltaFrom,#deltaTo").inputmask("numeric");
		
		DATEPICKET(null, -4, 0)
	}
	
	//그리드를 초기화
	function fn_initGrid() {
		
		//메저 width 설정
		gv_meaW = 120;
		
		//그리드 설정
		gridInstance = new GRID();
		gridInstance.init("realgrid");
		grdMain      = gridInstance.objGrid;
		dataProvider = gridInstance.objData;
		
		//그리드 옵션
		grdMain.setOptions({
			sorting : { enabled      : false },
			display : { columnMovable: false }
		});
	}
	
	//이벤트 정의
	function fn_initEvent() {
		// 버튼 이벤트
		$(".fl_app").click ("on", function() { fn_apply(); });
		//month sum omit0 처리
		gfn_setMonthSum(gridInstance, true, true, true);
	}
	
	//조회
	function fn_apply(sqlFlag) {
		
		gfn_getMenuInit();		//디멘전 메저 조회
		fn_getBucket();			//버켓정보 조회
		fn_drawGrid(sqlFlag);	//그리드를 그린다.
		
		var fromMon = gfn_replaceAll($("#fromCal").val(), "-", "").substring(0, 6);
		var toMon = gfn_replaceAll($("#toCal").val(), "-", "").substring(0, 6);
		
		$("#fromMonth").val(fromMon);
		$("#toMonth").val(toMon);

		//조회조건 설정
		FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
		FORM_SEARCH.sql		   = sqlFlag;
   		FORM_SEARCH.hrcyFlag   = true;
   		FORM_SEARCH.dimList	   = DIMENSION.user;
   		FORM_SEARCH.meaList	   = MEASURE.user;
   		FORM_SEARCH.bucketList = BUCKET.query;
   		
		//메인 데이터를 조회
		fn_getGridData();
		fn_getExcelData();
	}
	
	//버켓정보 조회
	function fn_getBucket(isWeekMt) {
		var ajaxMap = {
   			fromDate: gfn_replaceAll($("#fromCal").val(),"-",""),
	   		toDate  : gfn_replaceAll($("#toCal"  ).val(),"-",""),
	   		month   : {isDown: "Y", isUp:"N", upCal:"Q", isMt:"N", isExp:"Y", expCnt:999},
	   		week	: {isDown: "N", isUp:"Y", upCal:"M", isMt:"Y", isExp:"Y", expCnt:999},
	   		sqlId   : ["bucketMonth","bucketWeek"]
		}
		gfn_getBucket(ajaxMap);
	}
	
	//그리드를 그린다.
	function fn_drawGrid(sqlFlag) {
		
		if (sqlFlag) {
			return;
		}
		
		for (var i in DIMENSION.user) {
			if (DIMENSION.user[i].DIM_CD.indexOf("SALES_PRICE_KRW") > -1) {
				DIMENSION.user[i].numberFormat = "#,##0";
			}
		}
		
		gridInstance.setDraw();
		
		var fileds = dataProvider.getFields();
		
		for (var i in fileds) {
			if (fileds[i].fieldName.indexOf("SALES_PRICE_KRW") > -1) {
				fileds[i].dataType = "number";
			}
		}
		dataProvider.setFields(fileds);
	}
	
	//그리드 데이터 조회
	function fn_getGridData(sqlFlag) {
		
		FORM_SEARCH._mtd     = "getList";
		FORM_SEARCH.tranData = [{outDs:"gridList",_siq:"dp.salesProfit.salesProfitList"}];
		
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
	
	function fn_getExcelData(){
		
		EXCEL_SEARCH_DATA = "";
		EXCEL_SEARCH_DATA += "Product" + " : ";
		EXCEL_SEARCH_DATA += $("#loc_product").html();
		EXCEL_SEARCH_DATA += "\nCustomer" + " : ";
		EXCEL_SEARCH_DATA += $("#loc_customer").html();
		EXCEL_SEARCH_DATA += "\nSales Org" + " : ";
		EXCEL_SEARCH_DATA += $("#loc_salesOrg").html();
		
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
				}else if(id == "divProfitCode"){
					$.each($("#profitCode option:selected"), function(i2, val2){
						
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
		
		EXCEL_SEARCH_DATA += "\n" + '<spring:message code="lbl.period"/>' + " : ";
		EXCEL_SEARCH_DATA += $("#fromCal").val() + "(" + $("#fromPWeek").val() + ") ~ ";
		EXCEL_SEARCH_DATA += $("#toCal").val() + "(" + $("#toPWeek").val() + ")";
		
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
			<input type="hidden" id="fromMonth" name="fromMonth"/>
			<input type="hidden" id="toMonth" name="toMonth"/>
			<input type="hidden" id="omitBaseCd" name="omitBaseCd" value="BILLING_QTY"/>
				<div id="filterDv">
					<div class="inner">
						<h3>Filter</h3>
						<%@ include file="/WEB-INF/view/common/filterMonthSum.jsp"%>
						<div class="tabMargin"></div>
						<div class="scroll">
							<div class="view_combo" id="divItem"></div>
							<div class="view_combo" id="divProfitCode"></div>
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
			<div class="cbt_btn">
				<div class="bleft"></div>
				<div class="bright"></div>
			</div>
		</div>
	</div>
</body>
</html>
