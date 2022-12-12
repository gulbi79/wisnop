<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	<!-- 가용율 Trend -->
	<script type="text/javascript">

	var enterSearchFlag = "Y";
	var availableRateTrend = {

		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.availableRateTrendGrid.initGrid();
		},
			
		_siq    : "supply.purchase.availableRateTrendList",
		
		
		initFilter : function() {
			
			var itemTypeEvent = {
				childId   : ["upItemGroup"],  
				childData : [this.comCode.codeMapEx.UPPER_ITEM_GROUP, this.comCode.codeMapEx.ROUTING]
				
			};
	    	
	    	//품목대그룹
			var upperItemEvent = {
				childId   : ["itemGroup"],
				childData : [this.comCode.codeMapEx.ITEM_GROUP],
			};
			
			// 키워드팝업
			gfn_keyPopAddEvent([
				{ target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>' }
			]);
			
			// 콤보박스
			gfn_setMsComboAll([
				{target : 'divProcurType',   id : 'procurType',    title : '<spring:message code="lbl.procure"/>',        data : this.comCode.codeMap.PROCUR_TYPE, exData:[""]},
				{target : 'divUpItemGroup',  id : 'upItemGroup',   title : '<spring:message code="lbl.upperItemGroup"/>', data : this.comCode.codeMapEx.UPPER_ITEM_GROUP, exData:["*"], event: upperItemEvent },
				{target : 'divItemGroup', id : 'itemGroup', title : '<spring:message code="lbl.itemGroup"/>', data : this.comCode.codeMapEx.ITEM_GROUP, exData:["*"]},
				{target : 'divItemType', id : 'itemType', title : '<spring:message code="lbl.itemType"/>', data : this.comCode.codeMap.ITEM_TYPE, exData:[""], event : itemTypeEvent},
			]);
			
			$(':radio[name=rdoAqType]:input[value="QTY"]').attr("checked", true);
			
			// 달력
			DATEPICKET(null, -5, 0);
		},
		
		/*
		* common Code 
		*/
		comCode : {
			codeMapEx : null,
			codeMap : null,
			
			initCode  : function () {
				var grpCd = 'ITEM_TYPE,PROCUR_TYPE';
				this.codeMap = gfn_getComCode(grpCd, 'Y'); //공통코드 조회
				this.codeMapEx = gfn_getComCodeEx(["ITEM_GROUP", "UPPER_ITEM_GROUP"]);
			}
		},
	
		/* 
		* grid  선언
		*/
		availableRateTrendGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
			},
		},
	
		/*
		* event 정의
		*/
		events : function () {
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("#bucket").on("change", function(e) {
				calendarChange();
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
					
					//데이터
					if(id == "divItem"){
						EXCEL_SEARCH_DATA += $("#item_nm").val();
					}else if(id == "divProcurType"){
						$.each($("#procurType option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
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
					}else if(id == "divUpItemGroup"){
						$.each($("#upItemGroup option:selected"), function(i2, val2){
							
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
					}
				}
			});
			
			EXCEL_SEARCH_DATA += "\n" + '<spring:message code="lbl.period"/>' + " : ";
			EXCEL_SEARCH_DATA += $("#fromCal").val() + "(" + $("#fromWeek").val() + ") ~ ";
			EXCEL_SEARCH_DATA += $("#toCal").val() + "(" + $("#toWeek").val() + ")"; 
			
		},
		
		// 조회
		search : function () {
			
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq }];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj.do",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						availableRateTrend.availableRateTrendGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						availableRateTrend.availableRateTrendGrid.grdMain.cancel();
						
						availableRateTrend.availableRateTrendGrid.dataProvider.setRows(data.resList);
						availableRateTrend.availableRateTrendGrid.dataProvider.clearSavePoints();
						availableRateTrend.availableRateTrendGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(availableRateTrend.availableRateTrendGrid.dataProvider.getRowCount());
						gfn_setRowTotalFixed(availableRateTrend.availableRateTrendGrid.grdMain);
						
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		getBucket : function (sqlFlag) {
			
			var ajaxMap = {
				fromDate : gfn_replaceAll($("#swFromDate").val(), "-", ""),
				toDate   : gfn_replaceAll($("#swToDate").val(), "-", ""),
	       		week     : {isDown: "N", isUp:"N", upCal:"M", isMt:"N", isExp:"N", expCnt:999},
				sqlId    : ["bucketFullWeek"]
			}
			gfn_getBucket(ajaxMap);
			
			if (!sqlFlag) {
				availableRateTrend.availableRateTrendGrid.gridInstance.setDraw();
			}
		}
	};
	

	//조회
	var fn_apply = function (sqlFlag) {
		
		gfn_getMenuInit();
		
		availableRateTrend.getBucket(sqlFlag); 
    	
    	FORM_SEARCH = $("#searchForm").serializeObject(); 
    	FORM_SEARCH.sql        = sqlFlag;
   		FORM_SEARCH.dimList    = DIMENSION.user;
   		FORM_SEARCH.bucketList = BUCKET.query;
		availableRateTrend.search();
		availableRateTrend.excelSubSearch();
	}

	// onload 
	$(document).ready(function() {
		availableRateTrend.init();
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
					<div class="view_combo" id="divItem"></div>
					<div class="view_combo" id="divProcurType"></div>
					<div class="view_combo" id="divItemType"></div>
					<div class="view_combo" id="divUpItemGroup"></div>
					<div class="view_combo" id="divItemGroup"></div>
					
					<div id="weekCalendar">
					<jsp:include page="/WEB-INF/view/common/filterViewHorizon.jsp" flush="false">
						<jsp:param name="radioYn" value="N"/>
						<jsp:param name="wType" value="SW"/>
					</jsp:include>
					</div>
					
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
