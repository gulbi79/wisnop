<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>

	<script type="text/javascript">

	var enterSearchFlag = "Y";
	
	var salesPSI = {

		init : function () {
			
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.salesGrid.initGrid();
		},
			
		_siq    : "dp.salesPerform.salesPSI",
		 
		initFilter : function() {
			
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
				{ target : 'divProcurType'  , id : 'procurType',    title : '<spring:message code="lbl.procure"/>',        data : this.comCode.codeMap.PROCUR_TYPE, exData:[""]},
				{ target : 'divUpItemGroup' , id : 'upItemGroup',   title : '<spring:message code="lbl.upperItemGroup"/>', data : this.comCode.codeMapEx.UPPER_ITEM_GROUP, exData:["*"], event: upperItemEvent},
				{ target : 'divItemGroup'   , id : 'itemGroup',     title : '<spring:message code="lbl.itemGroup"/>',      data : this.comCode.codeMapEx.ITEM_GROUP,     exData:["*"]},
				{ target : 'divRoute'       , id : 'route'        , title : '<spring:message code="lbl.routing"/>'      , data : this.comCode.codeMapEx.ROUTING,        exData:["*"] },
				{ target : 'divRepCustGroup', id : 'reptCustGroup', title : '<spring:message code="lbl.reptCustGroup"/>', data : this.comCode.codeMapEx.REP_CUST_GROUP, exData:["*"] },
				{ target : 'divCustGroup'   , id : 'custGroup'    , title : '<spring:message code="lbl.custGroup"/>'    , data : this.comCode.codeMapEx.CUST_GROUP,     exData:["*"] },
			]);
			
			// 달력
			DATEPICKET(null, 0, 10);
			$('#fromCal').datepicker("option", "minDate", new Date().getWeekDay(0));
			$('#toCal')  .datepicker("option", "maxDate", new Date().getWeekDay(53, false));
			$('#fromCal').attr('disabled', "disabled");
		},
		
		/*
		* common Code 
		*/
		comCode : {
			codeMap   : null,
			codeMapEx : null,
			
			initCode  : function () {
				var grpCd = 'PROCUR_TYPE';
				this.codeMap = gfn_getComCode(grpCd, 'Y'); //공통코드 조회
				this.codeMapEx = gfn_getComCodeEx(["REP_CUST_GROUP", "CUST_GROUP", "ITEM_GROUP", "ROUTING", "UPPER_ITEM_GROUP"], null, {itemType : "10"});
			}
		},
	
		/* 
		* grid  선언
		*/
		salesGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				
				gfn_setMonthSum(salesPSI.salesGrid.gridInstance, false, false, true);
			}
		},
	
		/*
		* event 정의
		*/
		events : function () {
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
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
					}else if(id == "divRoute"){
						$.each($("#route option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divRepCustGroup"){
						$.each($("#reptCustGroup option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divCustGroup"){
						$.each($("#custGroup option:selected"), function(i2, val2){
							
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
						salesPSI.salesGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						salesPSI.salesGrid.grdMain.cancel();
						
						salesPSI.salesGrid.dataProvider.setRows(data.resList);
						salesPSI.salesGrid.dataProvider.clearSavePoints();
						salesPSI.salesGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_actionMonthSum(salesPSI.salesGrid.gridInstance);
						gfn_setRowTotalFixed(salesPSI.salesGrid.grdMain);
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		getBucket : function (sqlFlag) {
			var ajaxMap = {
				fromDate : gfn_replaceAll($("#fromCal").val(),"-",""),
				toDate   : gfn_replaceAll($("#toCal").val(),"-",""),
				week     : {isDown: "Y", isUp : "N", upCal : "M", isMt : "N", isExp : "N", expCnt : 999},
				sqlId    : ["bucketFullWeek"]
			}
			gfn_getBucket(ajaxMap);
			
			if (!sqlFlag) {
				
				for (var i in DIMENSION.user) {
					if (DIMENSION.user[i].DIM_CD.indexOf("SALES_PRICE_KRW") > -1) {
						DIMENSION.user[i].numberFormat = "#,##0";
					}
				}
				
				salesPSI.salesGrid.gridInstance.setDraw();
				
				var fileds = salesPSI.salesGrid.dataProvider.getFields();
				
				for (var i in fileds) {
					if (fileds[i].fieldName.indexOf("SALES_PRICE_KRW") > -1) {
						fileds[i].dataType = "number";
					}
				}
				salesPSI.salesGrid.dataProvider.setFields(fileds);
				
			}
		}
	};

	//조회
	var fn_apply = function (sqlFlag) {

		// 디멘젼, 메져
		gfn_getMenuInit();
		
		salesPSI.getBucket(sqlFlag); //2. 버켓정보 조회
    	
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
   		FORM_SEARCH.hrcyFlag   = true;
   		FORM_SEARCH.dimList    = DIMENSION.user;
   		FORM_SEARCH.meaList    = MEASURE.user;
   		FORM_SEARCH.bucketList = BUCKET.query;
		
		salesPSI.search();
		salesPSI.excelSubSearch();
	}

	// onload 
	$(document).ready(function() {
		salesPSI.init();
	});
	
	</script>

</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="a" class="split content split-horizontal">
		<form id="searchForm" name="searchForm">
		<input type="hidden" id="itemType" name="itemType" value="10"/>
		<input type="hidden" id="omitBaseCd" name="omitBaseCd" value="FCST_QTY"/>
		<div id="filterDv">
			<div class="inner">
				<h3>Filter</h3>
				<%@ include file="/WEB-INF/view/common/filterMonthSum.jsp" %>
				<div class="tabMargin"></div>
				<div class="scroll">
					<div class="view_combo" id="divItem"></div>
					<div class="view_combo" id="divProcurType"></div>
					<div class="view_combo" id="divUpItemGroup"></div>
					<div class="view_combo" id="divItemGroup"></div>
					<div class="view_combo" id="divRoute"></div>
					<div class="view_combo" id="divRepCustGroup"></div>
					<div class="view_combo" id="divCustGroup"></div>
					<%@ include file="/WEB-INF/view/common/filterViewHorizon.jsp" %>
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
			<!-- <div class="cbt_btn">
				<div class="bright">
				<a href="#" class="app1">Reset</a>
				<a href="#" class="app2">Save</a>
				</div>
			</div> -->
		</div>
    </div>
</body>
</html>
