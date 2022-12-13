<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
<!-- Sales Plan Volatility  판매계획 변동율  -->
	<script type="text/javascript">

var enterSearchFlag = "Y";
	
	var salesPlanCng = {

		init : function () {
			
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.salesGrid.initGrid();
		},
			
		_siq    : "dp.salesPerform.salesPlanCngRt",
		
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
				{ target : 'divItemGroup'   , id : 'itemGroup'    , title : '<spring:message code="lbl.itemGroup"/>'    , data : this.comCode.codeMapEx.ITEM_GROUP,     exData:["*"] },
				{ target : 'divRoute'       , id : 'route'        , title : '<spring:message code="lbl.routing"/>'      , data : this.comCode.codeMapEx.ROUTING,        exData:["*"] },
				{ target : 'divRepCustGroup', id : 'reptCustGroup', title : '<spring:message code="lbl.reptCustGroup"/>', data : this.comCode.codeMapEx.REP_CUST_GROUP, exData:["*"] },
				{ target : 'divCustGroup'   , id : 'custGroup'    , title : '<spring:message code="lbl.custGroup"/>'    , data : this.comCode.codeMapEx.CUST_GROUP,     exData:["*"] },
			]);

			var dateParam = {
	   			arrTarget : [
	 				{calId : "fromCal", weekId : "fromWeek", defVal : -1}
	   			]
	     	};
	       	DATEPICKET(dateParam);
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
				this.gridInstance.custNextBucketFalg = true;
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
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
					}else if(id == "divWeekId"){
						EXCEL_SEARCH_DATA += $("#fromCal").val() + "(" + $("#fromWeek").val() + ")";
					}
				}
			});
		},
		
		// 조회
		search : function () {
			
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq }];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						
						salesPlanCng.salesGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						salesPlanCng.salesGrid.grdMain.cancel();
						
						salesPlanCng.salesGrid.dataProvider.setRows(data.resList);
						salesPlanCng.salesGrid.dataProvider.clearSavePoints();
						salesPlanCng.salesGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(salesPlanCng.salesGrid.dataProvider.getRowCount());
						
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		getBucket : function (sqlFlag) {
			
			var fromDate = dateCal($("#fromCal").val(), -112);
			var toDate = dateCal($("#fromCal").val(), -7);
			
			$("#dateW-16").val(fromDate);
			$("#dateW-1").val(toDate);
			
			$("#dateYear").val(fromDate.substring(0, 4));
			
			var ajaxMap = {
				fromDate : fromDate,
				toDate   : toDate,
				week     : {isDown: "Y", isUp : "N", upCal : "M", isMt : "N", isExp : "N", expCnt : 999},
				sqlId    : ["bucketFullWeek"]
			}
			gfn_getBucket(ajaxMap);
			
			if (!sqlFlag) {
				salesPlanCng.salesGrid.gridInstance.setDraw();
			}
		}
	};
	

	//조회
	var fn_apply = function (sqlFlag) {

		// 디멘젼, 메져
		gfn_getMenuInit();
		
		salesPlanCng.getBucket(sqlFlag); //2. 버켓정보 조회
		
		var weekVal = 16;
		$.each(BUCKET.query, function(n, v){
			v.WEEK_VAL = "W-" + weekVal;
			weekVal = weekVal - 1;
		});
    	
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
   		FORM_SEARCH.hrcyFlag   = true;
   		FORM_SEARCH.dimList    = DIMENSION.user;
   		FORM_SEARCH.meaList    = MEASURE.user;
   		FORM_SEARCH.bucketList = BUCKET.query;
		
		salesPlanCng.search();
		salesPlanCng.excelSubSearch();
	}

	// onload 
	$(document).ready(function() {
		salesPlanCng.init();
	});
	
	function dateCal(data, val){
		
		data = gfn_replaceAll(data, "-", "/")
		
		var today = new Date(data);

		today.setDate(today.getDate() + val); 

		var year = today.getFullYear();
		var month = today.getMonth() + 1;
		var day = today.getDate();
		
		if(month < 10){
			month = "0" + month;
		}
		
		if(day < 10){
			day = "0" + day;
		}
		
		return year + "" + month + day;
	}
	
	function fn_setNextFieldsBuket() {
    	//필드 배열 객체를  생성합니다.
        var fields = [
            {fieldName: "RS_QTY", dataType : "number"},
            {fieldName: "TOTAL_WEEK_PER", dataType : "number"},
            {fieldName: "FIRST_WEEK_PER", dataType : "number"},
            {fieldName: "LAST_WEEK_PER", dataType : "number"},
            {fieldName: "MIN_PL_QTY", dataType : "number"},
            {fieldName: "MAX_PL_QTY", dataType : "number"},
            {fieldName: "AVG_PL_QTY", dataType : "number"},
            {fieldName: "STDEV_PL_QTY", dataType : "number"}
        ];
    	
    	return fields;
    }
    
    function fn_setNextColumnsBuket() {
    	//필드와 연결된 컬럼 배열 객체를 생성합니다.
        var columns = 
		[	
			{
				name      : "RS_QTY", 
				fieldName : "RS_QTY",
				header    : {text: '<spring:message code="lbl.rsQty" javaScriptEscape="true" />'},
				styles    : {textAlignment: "far", numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType  : "number",
				editable  : false,
				width     : 100
			}, {
				name      : "TOTAL_WEEK_PER", 
				fieldName : "TOTAL_WEEK_PER",
				header    : {text: '<spring:message code="lbl.compare16_1_prer" javaScriptEscape="true" />'},
				styles    : {textAlignment: "far", numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType  : "number",
				editable  : false,
				width     : 100
			}, {
				name      : "FIRST_WEEK_PER", 
				fieldName : "FIRST_WEEK_PER",
				header    : {text: '<spring:message code="lbl.compare4_1_prer" javaScriptEscape="true" />'},
				styles    : {textAlignment: "far", numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType  : "number",
				editable  : false,
				width     : 100
			}, {
				name      : "LAST_WEEK_PER", 
				fieldName : "LAST_WEEK_PER",
				header    : {text: '<spring:message code="lbl.compare16_13_prer" javaScriptEscape="true" />'},
				styles    : {textAlignment: "far", numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType  : "number",
				editable  : false,
				width     : 100
			}, {
				name      : "MIN_PL_QTY", 
				fieldName : "MIN_PL_QTY",
				header    : {text: '<spring:message code="lbl.mixPlQty" javaScriptEscape="true" />'},
				styles    : {textAlignment: "far", numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType  : "number",
				editable  : false,
				width     : 100
			}, {
				name      : "MAX_PL_QTY", 
				fieldName : "MAX_PL_QTY",
				header    : {text: '<spring:message code="lbl.maxPlQty" javaScriptEscape="true" />'},
				styles    : {textAlignment: "far", numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType  : "number",
				editable  : false,
				width     : 100
			}, {
				name      : "AVG_PL_QTY", 
				fieldName : "AVG_PL_QTY",
				header    : {text: '<spring:message code="lbl.avgPlQty" javaScriptEscape="true" />'},
				styles    : {textAlignment: "far", numberFormat : "#,##0.0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType  : "number",
				editable  : false,
				width     : 100
			}, {
				name      : "STDEV_PL_QTY", 
				fieldName : "STDEV_PL_QTY",
				header    : {text: '<spring:message code="lbl.stdevPlQty" javaScriptEscape="true" />'},
				styles    : {textAlignment: "far", numberFormat : "#,##0.0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType  : "number",
				editable  : false,
				width     : 100
			}
		];
    	
    	return columns;
    }
	
	
	</script>

</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="a" class="split content split-horizontal">
		<form id="searchForm" name="searchForm">
		<input type="hidden" id="itemType" name="itemType" value="10"/>
		<div id="filterDv">
			<div class="inner">
				<h3>Filter</h3>
				<div class="tabMargin"></div>
				<div class="scroll">
					<div class="view_combo" id="divItem"></div>
					<div class="view_combo" id="divProcurType"></div>
					<div class="view_combo" id="divUpItemGroup"></div>
					<div class="view_combo" id="divItemGroup"></div>
					<div class="view_combo" id="divRoute"></div>
					<div class="view_combo" id="divRepCustGroup"></div>
					<div class="view_combo" id="divCustGroup"></div>
					<div class="view_combo" id="divWeekId">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.weekId"/></div>
							<input type="text" id="fromCal" name="fromCal" class="iptdate datepicker2"/>
							<input type="text" id="fromWeek" name="fromWeek" class="iptdateweek" disabled="disabled" value=""/>
							<input type="hidden" id="swFromDate" name="swFromDate"/>
							<input type="hidden" id="swToDate" name="swToDate"/>
							<input type="hidden" id="dateW-16" name="dateW-16"/>
							<input type="hidden" id="dateW-1" name="dateW-1"/>
							<input type="hidden" id="dateYear" name="dateYear"/>
						</div>
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
