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
		//Role조회
		fn_getInitData();
	}
	
	//Role조회
	function fn_getInitData() {
		gfn_service({
			async   : false,
			url     : GV_CONTEXT_PATH + "/biz/obj.do",
			data    : {_mtd:"getList",menuParam:"CFM",tranData:[
				{outDs:"roleList",_siq:"dp.targetMgmt.monthlyProfitLossRole"},
			]},
			success : function(data) {
				codeMap = {};
				codeMap.ROLE_INFO = data.roleList[0];
			}
		}, "obj");
	}
	
	//필터 초기화
	function fn_initFilter() {
		
		//키워드팝업
		gfn_keyPopAddEvent([
			{ target : 'divItem', id : 'item', type : 'COM_ITEM_PLAN', title : '<spring:message code="lbl.item"/>' }
		]);
		
		//Plan ID
    	gfn_getPlanId({picketType:"M",planTypeCd:"DP_M",cutOffFlag:"Y"});
    	//Start Month가 포함된 년도의 직전년도 1월까지만 선택 가능
		var preYear = new Date(parseInt($("#startMonth" ).val().substring(0,4))-1, 0, 1);
    	$("#fromMon").monthpicker("option", "minDate", preYear);
		
		//숫자만입력
		$("#opRateFrom,#opRateTo").inputmask("numeric");
		
		//권한정보
		$("#ap1_yn").val(codeMap.ROLE_INFO.AP1_YN);
		$("#ap2_yn").val(codeMap.ROLE_INFO.AP2_YN);
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
		
		// Total
		gridInstance.totalFlag = true;
		
		//그리드 옵션
		grdMain.setOptions({
			display : { columnMovable: false }
		});
	}
	
	//이벤트 정의
	function fn_initEvent() {
		//버튼 이벤트
		$(".fl_app").click ("on", function() { fn_apply(); });
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
		FORM_SEARCH.totalFlag  = gridInstance.totalFlag;

		//메인 데이터를 조회
		fn_getGridData();
		fn_getExcelData();
	}
	
	//버켓정보 조회
	function fn_getBucket() {
		var ajaxMap = {
			fromDate : $("#fromMon").val().replace(/-/g, '')+"01",
			toDate   : $("#toMon"  ).val().replace(/-/g, '')+"01",
			month    : {isDown: "N", isUp:"N", upCal:"Q", isMt:"N", isExp:"N", expCnt:999},
			sqlId    : ["bucketMonth"]
		}
		gfn_getBucket(ajaxMap);
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
		FORM_SEARCH.tranData = [{outDs:"gridList",_siq:"dp.targetMgmt.monthlyProfitLoss"}];
		
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
				}else if(id == "divOpRate"){
					EXCEL_SEARCH_DATA += $("#opRateFrom").val() + " ~ " + $("#opRateTo").val();
				}else if(id == "divPlanId"){
					EXCEL_SEARCH_DATA += $("#planId option:selected").text();
				}
			}
		});
		
		EXCEL_SEARCH_DATA += "\n" + $("#view_Her .tlist .tit").html() + " : ";
		EXCEL_SEARCH_DATA += $("#fromMon").val() + " ~ " + $("#toMon").val();
		
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
				<input type="hidden" id="ap2_yn" name="ap2_yn" />
				<div id="filterDv">
					<div class="inner">
						<h3>Filter</h3>
						<%@ include file="/WEB-INF/view/common/filterMonthSum.jsp"%>
						<div class="tabMargin"></div>
						<div class="scroll">
							<div class="view_combo" id="divItem"></div>
							<div class="view_combo" id="divOpRate">
								<div class="ilist">
									<div class="itit"><spring:message code="lbl.opRate" /></div>
									<input type="text" id="opRateFrom" name="opRateFrom" class="ipt" style="width:55px"/> <span class="ihpen">~</span>
									<input type="text" id="opRateTo" name="opRateTo" class="ipt" style="width:55px"/>
								</div> 
							</div>
							<jsp:include page="/WEB-INF/view/common/filterPlanViewHorizon.jsp" flush="false">
								<jsp:param name="wType" value="M"/>
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
