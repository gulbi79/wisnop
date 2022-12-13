<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>

	<script type="text/javascript">

	var enterSearchFlag = "Y";
	var lamSalesTrendWeekly = {

		init : function () {
			
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.grid.initGrid();
		},
			
		_siq : "dp.salesPerform.lamSalesTrendWeekly",
		
		initFilter : function() {
			
			gfn_keyPopAddEvent([
				{ target : 'divItem', id : 'item', type : 'COM_ITEM_PLAN', title : '<spring:message code="lbl.item"/>' }
			]);
			
			// 콤보박스
			gfn_setMsComboAll([
				{ target : 'divYear', id : 'year', title : '<spring:message code="lbl.year"/>', data : this.comCode.codeMap.YEAR_INFO, exData:[  ], type : "S" },
				{ target : 'divLamOrdType', id : 'lamOrdType', title : '<spring:message code="lbl.keyProd"/>', data : this.comCode.codeMap.LAM_ORD_TYPE, exData:["*"], type : "S"},
			]);
			
			$("#year").val(new Date().getFullYear());
		},
		
		/*
		* common Code 
		*/
		comCode : {
			
			codeMap : null,
			codeMapEx : null,
			
			initCode  : function () {
				var grpCd = 'LAM_ORD_TYPE';
				this.codeMap = gfn_getComCode(grpCd, 'Y'); //공통코드 조회
				
				gfn_service({
					async   : false,
					url     : GV_CONTEXT_PATH + "/biz/obj",
					data    : {_mtd : "getList", menuParam : "YP", tranData:[
						{outDs : "yearList", _siq : "dp.salesPerform.yearList"}
					]},
					success : function(data) {
						lamSalesTrendWeekly.comCode.codeMap.YEAR_INFO = data.yearList;
					}
				}, "obj");
			}
		},
	
		/* 
		* grid  선언
		*/
		grid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				this.gridInstance.custNextBucketFalg = true;
				
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
		},
		
		excelSubSearch : function (){
			
			$.each($(".view_combo"), function(i, val){
				
				var temp = "";
				var id = gfn_nvl($(this).attr("id"), "");
				
				if(id != ""){
					
					var name = $("#" + id + " .ilist .itit").html();
					
					//타이틀
					if(i == 0){
						EXCEL_SEARCH_DATA = name + " : ";	
					}else{
						EXCEL_SEARCH_DATA += "\n" + name + " : ";	
					}
					
					if(id == "divItem"){
						EXCEL_SEARCH_DATA += $("#item_nm").val();
					}else if(id == "divSpec"){
						EXCEL_SEARCH_DATA += $("#spec").val();
					}else if(id == "divLamOrdType"){
						EXCEL_SEARCH_DATA += $("#lamOrdType option:selected").text();
					}else if(id == "divYear"){
						EXCEL_SEARCH_DATA += $("#year option:selected").text();
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
						
						lamSalesTrendWeekly.grid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						lamSalesTrendWeekly.grid.grdMain.cancel();
						
						lamSalesTrendWeekly.grid.dataProvider.setRows(data.resList);
						lamSalesTrendWeekly.grid.dataProvider.clearSavePoints();
						lamSalesTrendWeekly.grid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(lamSalesTrendWeekly.grid.dataProvider.getRowCount());
						gfn_setRowTotalFixed(lamSalesTrendWeekly.grid.grdMain);
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		getBucket : function (sqlFlag) {

			var ajaxMap = {
	   			fromDate: $("#year").val() + "0101",
		   		toDate  : $("#year").val() + "1231",
		   		month   : {isDown : "Y", isUp : "N", upCal : "Q", isMt : "N", isExp : "Y", expCnt : 999},
		   		week	: {isDown : "N", isUp : "Y", upCal : "M", isMt : "Y", isExp : "N", expCnt : 999},
		   		sqlId   : ["bucketMonth", "bucketWeek"]
			}
			
			gfn_getBucket(ajaxMap);
			
			if(!sqlFlag) {
				lamSalesTrendWeekly.grid.gridInstance.setDraw();
				
				var fileds = lamSalesTrendWeekly.grid.dataProvider.getFields();
				var filedsLen = fileds.length;
				
				for (var i = 0; i < filedsLen; i++) {
					var fieldName = fileds[i].fieldName;
					if (fieldName == 'SALES_PRICE_KRW_NM'){
						fileds[i].dataType = "number";
						lamSalesTrendWeekly.grid.grdMain.setColumnProperty(fieldName, "styles", {"numberFormat" : "#,##0"});	
					}else if(fieldName == 'WEEK_GROUP7'){
						
						var year = "Y" + $("#year").val();
						lamSalesTrendWeekly.grid.grdMain.setColumnProperty("WEEK_GROUP7", "header", year);
					}
				}
				lamSalesTrendWeekly.grid.dataProvider.setFields(fileds);
			} 
		}
	};

	//조회
	var fn_apply = function (sqlFlag) {
		
		// 디멘젼, 메져
		gfn_getMenuInit();
		
    	lamSalesTrendWeekly.getBucket(sqlFlag); //2. 버켓정보 조회
    	
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
   		FORM_SEARCH.hrcyFlag   = true;
   		FORM_SEARCH.dimList    = DIMENSION.user;
   		FORM_SEARCH.meaList    = MEASURE.user;
   		FORM_SEARCH.bucketList = BUCKET.query;
   		
		lamSalesTrendWeekly.search();
		lamSalesTrendWeekly.excelSubSearch();
	};
	

	function fn_setNextFieldsBuket() {
    	//필드 배열 객체를  생성합니다.
        var fields = [
        	{fieldName : "WEEK_GROUP7", dataType : "text"},
            {fieldName : "Q1_QTY", dataType : "number"},
            {fieldName : "Q2_QTY", dataType : "number"},
            {fieldName : "Q3_QTY", dataType : "number"},
            {fieldName : "Q4_QTY", dataType : "number"},
            {fieldName : "Q1_AVG", dataType : "number"},
            {fieldName : "Q2_AVG", dataType : "number"},
            {fieldName : "Q3_AVG", dataType : "number"},
            {fieldName : "Q4_AVG", dataType : "number"},
            {fieldName : "FIRST_QTY", dataType : "number"},
            {fieldName : "FIRST_AVG", dataType : "number"},
            {fieldName : "SECOND_QTY", dataType : "number"},
            {fieldName : "SECOND_AVG", dataType : "number"},
            {fieldName : "YEAR_QTY", dataType : "number"},
            {fieldName : "YEAR_AMT", dataType : "number"},
            
        ];
    	return fields;
    }

    function fn_setNextColumnsBuket() {
    	//필드와 연결된 컬럼 배열 객체를 생성합니다.
        var columns = 
		[	
			{
                type: "group",
                name: '<spring:message code="lbl.q1" javaScriptEscape="true" />',
                header: {text: '<spring:message code="lbl.q1" javaScriptEscape="true" />'},
                fieldName: "WEEK_GROUP",
                width: 160,
                columns : [
                	{
						name : "Q1_QTY", fieldName: "Q1_QTY", editable: false, header: {text: '<spring:message code="lbl.qty" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 80
					}, {
						name : "Q1_AVG", fieldName: "Q1_AVG", editable: false, header: {text: '<spring:message code="lbl.avgPlQty" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0.0"},
						dataType : "number",
						nanText : "",
						width: 80
					}
                ]
            }, {
                type: "group",
                name: '<spring:message code="lbl.q2" javaScriptEscape="true" />',
                header: {text: '<spring:message code="lbl.q2" javaScriptEscape="true" />'},
                fieldName: "WEEK_GROUP2",
                width: 160,
                columns : [
                	{
						name : "Q2_QTY", fieldName: "Q2_QTY", editable: false, header: {text: '<spring:message code="lbl.qty" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 80
					}, {
						name : "Q2_AVG", fieldName: "Q2_AVG", editable: false, header: {text: '<spring:message code="lbl.avgPlQty" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0.0"},
						dataType : "number",
						nanText : "",
						width: 80
					}
                ]
            }, {
                type: "group",
                name: '<spring:message code="lbl.q3" javaScriptEscape="true" />',
                header: {text: '<spring:message code="lbl.q3" javaScriptEscape="true" />'},
                fieldName: "WEEK_GROUP3",
                width: 160,
                columns : [
                	{
						name : "Q3_QTY", fieldName: "Q3_QTY", editable: false, header: {text: '<spring:message code="lbl.qty" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 80
					}, {
						name : "Q3_AVG", fieldName: "Q3_AVG", editable: false, header: {text: '<spring:message code="lbl.avgPlQty" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0.0"},
						dataType : "number",
						nanText : "",
						width: 80
					}
                ]
            }, {
                type: "group",
                name: '<spring:message code="lbl.q4" javaScriptEscape="true" />',
                header: {text: '<spring:message code="lbl.q4" javaScriptEscape="true" />'},
                fieldName: "WEEK_GROUP4",
                width: 160,
                columns : [
                	{
						name : "Q4_QTY", fieldName: "Q4_QTY", editable: false, header: {text: '<spring:message code="lbl.qty" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 80
					}, {
						name : "Q4_AVG", fieldName: "Q4_AVG", editable: false, header: {text: '<spring:message code="lbl.avgPlQty" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0.0"},
						dataType : "number",
						nanText : "",
						width: 80
					}
                ]
            }, {
                type: "group",
                name: '<spring:message code="lbl.firstHalf" javaScriptEscape="true" />',
                header: {text: '<spring:message code="lbl.firstHalf" javaScriptEscape="true" />'},
                fieldName: "WEEK_GROUP5",
                width: 160,
                columns : [
                	{
						name : "FIRST_QTY", fieldName: "FIRST_QTY", editable: false, header: {text: '<spring:message code="lbl.qty" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 80
					}, {
						name : "FIRST_AVG", fieldName: "FIRST_AVG", editable: false, header: {text: '<spring:message code="lbl.avgPlQty" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0.0"},
						dataType : "number",
						nanText : "",
						width: 80
					}
                ]
            }, {
                type: "group",
                name: '<spring:message code="lbl.secondHalf" javaScriptEscape="true" />',
                header: {text: '<spring:message code="lbl.secondHalf" javaScriptEscape="true" />'},
                fieldName: "WEEK_GROUP6",
                width: 160,
                columns : [
                	{
						name : "SECOND_QTY", fieldName: "SECOND_QTY", editable: false, header: {text: '<spring:message code="lbl.qty" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 80
					}, {
						name : "SECOND_AVG", fieldName: "SECOND_AVG", editable: false, header: {text: '<spring:message code="lbl.avgPlQty" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0.0"},
						dataType : "number",
						nanText : "",
						width: 80
					}
                ]
            }, {
                type: "group",
                name: 'WEEK_GROUP7',
                header: {text: '<spring:message code="lbl.year" javaScriptEscape="true" />'},
                fieldName: "WEEK_GROUP7",
                width: 160,
                columns : [
                	{
						name : "YEAR_QTY", fieldName: "YEAR_QTY", editable: false, header: {text: '<spring:message code="lbl.qty" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 80
					}, {
						name : "YEAR_AMT", fieldName: "YEAR_AMT", editable: false, header: {text: '<spring:message code="lbl.amount" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 80
					}
                ]
            }
		];
    	return columns;
    }


	// onload 
	$(document).ready(function() {
		lamSalesTrendWeekly.init();
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
				<%-- <%@ include file="/WEB-INF/view/common/filterMonthSum.jsp" %>  --%>
				<div class="tabMargin"></div>
				<div class="scroll">
					<div class="view_combo" id="divItem"></div>
					<div class="view_combo" id="divSpec">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.spec"/></div>
							<input type="text" id="spec" name="spec" class="ipt"/>
						</div>
					</div>
					<div class="view_combo" id="divLamOrdType"></div>
					<div class="view_combo" id="divYear"></div>
					
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
