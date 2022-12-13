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
		
		//tree filter set 
    	gv_zTreeFilter.P = {lvl: ["L2","L3"]};
    	gv_zTreeFilter.C = {lvl: ["L2"]};
		
		gfn_formLoad(); 	//공통 초기화
		fn_initData(); 		//데이터 초기화
		fn_initFilter(); 	//필터 초기화
		fn_initGrid();		//그리드 초기화
		fn_initEvent();		//이벤트 초기화
	});

	//데이터 초기화
	function fn_initData() {
		codeMap = {};
	}

	//필터 초기화
	function fn_initFilter() {
		//Plan ID
    	gfn_getPlanId({picketType:"M",planTypeCd:"DP_W",cutOffFlag:"Y"});
		//숫자만입력
		$("#fillRateFrom,#fillRateTo,#deltaFrom,#deltaTo").inputmask("numeric");
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
		gridInstance.bnFormat = "#,###.#";
		
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
		
		//그리드 이벤트
       	grdMain.onDataCellDblClicked = function (grid, index) {
			
			//버킷확인
			if (index.fieldName.indexOf("MT_") == 0 || index.fieldName.indexOf("PW") == 0) {
				//메저확인
				if (dataProvider.getValue(index.dataRow, "CATEGORY_CD") == "AP2_SP") {
					
					//버킷정리
					var bucketList = [];
					if (index.fieldName.indexOf("MT_") == 0) {
						$.each(grdMain.getColumnProperty(grdMain.columnByName(index.fieldName).parent, "columns"), function() {
							if (this._name.indexOf("MT_") != 0) {
								bucketList.push(this._name);
							}
						});
					} else {
						bucketList.push(index.fieldName);
					}
					
					//팝업 오픈
					gfn_comPopupOpen("DP_AP2_SP_DETAIL", {
						rootUrl : "dp",
						url     : "ap2SalesPlanDetail",
						width   : 800,
						height  : 500,
						dataRow : index.dataRow,
						bucket  : bucketList.join(","),
					});
				}
			}
		};
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

		//메인 데이터를 조회
		fn_getGridData();
		fn_getExcelData();
	}
	
	//버켓정보 조회
	function fn_getBucket() {
		var ajaxMap = {
   			fromDate: gfn_replaceAll($("#fromMon").val(),"-","")+"01",
	   		toDate  : fn_getLastDay ($("#toMon"  ).val()),
	   		month   : {isDown: "Y", isUp:"N", upCal:"Q", isMt:"N", isExp:"Y", expCnt:999},
	   		week	: {isDown: "N", isUp:"Y", upCal:"M", isMt:"Y", isExp:"Y", expCnt:999},
	   		sqlId   : ["bucketMonth","bucketWeek"]
		}
		gfn_getBucket(ajaxMap);
	}
	
	function fn_getLastDay(month) {
		var temp = month.split("-");
		temp.push(new Date(temp[0], temp[1], 0).getDate());
		return temp.join("");
	}
	
	//그리드를 그린다.
	function fn_drawGrid(sqlFlag) {
		
		if (sqlFlag) {
			return;
		}

		//메저정보 수정
		$.each(MEASURE.user, function(idx, item) {
			if      (item.CD == "ALLOC_QTY") { item.NM = item.NM + " ①"; }
			else if (item.CD == "AP2_SP"   ) { item.NM = item.NM + " ②"; }
			else if (item.CD == "DELTA"    ) { item.NM = item.NM + " (② - ③ - ①)"; }
			else if (item.CD == "FILL_RATE") { item.NM = item.NM + " (②-③)/①, %"; }
			else if (item.CD == "INV_BOH") { item.NM = item.NM + " ③"; }
		});
		
		gridInstance.setDraw();
		
		var fileds = dataProvider.getFields();
		$.each(DIMENSION.user, function(i,v) {
			fileds.push({
				fieldName : v.DIM_CD + "_CD",
				dataType  : "text",
			});
		});
		dataProvider.setFields(fileds);
	}
	
	//그리드 데이터 조회
	function fn_getGridData(sqlFlag) {
		
		FORM_SEARCH._mtd     = "getList";
		FORM_SEARCH.tranData = [{outDs:"gridList",_siq:"dp.salesPlan.salesPlanReview"}];
		
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
				
				
				//7월 20일 배포
				if($("#btnOmit0").attr("class") != "on") {
					$("#btnOmit0").trigger("click");	
				} 
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
				if(id == "divPlanId"){
					EXCEL_SEARCH_DATA += $("#planId option:selected").text();
					EXCEL_SEARCH_DATA += "\n" + $("#view_Her .tlist .tit").html() + " : ";
					EXCEL_SEARCH_DATA += $("#fromMon").val() + " ~ " + $("#toMon").val();
				}else if(id == "divFillRate"){
					EXCEL_SEARCH_DATA += $("#fillRateFrom").val() + " ~ " + $("#fillRateTo").val();
				}else if(id == "divDelta"){
					EXCEL_SEARCH_DATA += $("#deltaFrom").val() + " ~ " + $("#deltaTo").val();
				}
			}
		});
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
			<input type="hidden" id="omitBaseCd" name="omitBaseCd" value="ALLOC_QTY"/>
				<div id="filterDv">
					<div class="inner">
						<h3>Filter</h3>
						<%@ include file="/WEB-INF/view/common/filterMonthSum.jsp"%>
						<div class="tabMargin"></div>
						<div class="scroll">
							<jsp:include page="/WEB-INF/view/common/filterPlanViewHorizon.jsp" flush="false">
								<jsp:param name="wType" value="M"/>
							</jsp:include>
							<div class="view_combo" id="divFillRate">
								<div class="ilist">
									<div class="itit"><spring:message code="lbl.fillRate" /></div>
									<input type="text" id="fillRateFrom" name="fillRateFrom" class="ipt" style="width:55px"/><span class="ihpen">~</span>
									<input type="text" id="fillRateTo" name="fillRateTo" class="ipt" style="width:55px"/>
								</div> 
							</div>
							<div class="view_combo" id="divDelta">
								<div class="ilist">
									<div class="itit"><spring:message code="lbl.delta" /></div>
									<input type="text" id="deltaFrom" name="deltaFrom" class="ipt" style="width:55px"/><span class="ihpen">~</span>
									<input type="text" id="deltaTo" name="deltaTo" class="ipt" style="width:55px"/>
								</div> 
							</div>
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
