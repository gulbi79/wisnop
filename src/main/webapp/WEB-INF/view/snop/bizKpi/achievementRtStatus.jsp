<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
<!-- Achievement Rate Status (목표 달성 현황) -->
	<script type="text/javascript">

	var enterSearchFlag = "Y";
	
	var achievementRtStatus = {

		init : function () {
			
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.salesGrid.initGrid();
		},
			
		_siq    : "snop.bizKpi.achievementRtStatus",
		
		
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
				{ target : 'divProcurType',   id : 'procurType',    title : '<spring:message code="lbl.procure"/>',        data : this.comCode.codeMap.PROCUR_TYPE, exData:[""]},
				{ target : 'divUpItemGroup',  id : 'upItemGroup',   title : '<spring:message code="lbl.upperItemGroup"/>', data : this.comCode.codeMapEx.UPPER_ITEM_GROUP, exData:["*"], event: upperItemEvent },
				{ target : 'divItemGroup'   , id : 'itemGroup'    , title : '<spring:message code="lbl.itemGroup"/>'    , data : this.comCode.codeMapEx.ITEM_GROUP,     exData:["*"] },
				{ target : 'divRoute'       , id : 'route'        , title : '<spring:message code="lbl.routing"/>'      , data : this.comCode.codeMapEx.ROUTING,        exData:["*"] },
				{ target : 'divRepCustGroup', id : 'reptCustGroup', title : '<spring:message code="lbl.reptCustGroup"/>', data : this.comCode.codeMapEx.REP_CUST_GROUP, exData:["*"] },
				{ target : 'divCustGroup'   , id : 'custGroup'    , title : '<spring:message code="lbl.custGroup"/>'    , data : this.comCode.codeMapEx.CUST_GROUP,     exData:["*"] },
			]);
		},
		
		/*
		* common Code 
		*/
		comCode : {
			codeMap   : null,
			codeMapEx : null,
			
			initCode  : function () {
				var grpCd    = 'SALE_QA_TYPE,PROCUR_TYPE';
				this.codeMap = gfn_getComCode(grpCd); //공통코드 조회

				this.codeMapEx = gfn_getComCodeEx(["REP_CUST_GROUP", "CUST_GROUP", "ITEM_GROUP", "ROUTING", "UPPER_ITEM_GROUP"], null, {itemType : "10,50"});
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
				this.gridInstance.custBucketFalg = true;
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				
				gfn_setMonthSum(achievementRtStatus.salesGrid.gridInstance, false, false, true);
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
						achievementRtStatus.salesGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						achievementRtStatus.salesGrid.grdMain.cancel();
						
						achievementRtStatus.salesGrid.dataProvider.setRows(data.resList);
						achievementRtStatus.salesGrid.dataProvider.clearSavePoints();
						achievementRtStatus.salesGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_actionMonthSum(achievementRtStatus.salesGrid.gridInstance);
						gfn_setRowTotalFixed(achievementRtStatus.salesGrid.grdMain);
						
					}
				}
			}
			gfn_service(aOption, "obj");
		},
	};
	
	//조회
	var fn_apply = function (sqlFlag) {

		// 디멘젼, 메져
		gfn_getMenuInit();
		
		if (!sqlFlag) {
			achievementRtStatus.salesGrid.gridInstance.setDraw();
			
			for (var i in DIMENSION.user) {
				if (DIMENSION.user[i].DIM_CD.indexOf("SALES_PRICE_KRW") > -1) {
					DIMENSION.user[i].numberFormat = "#,##0";
				}
			}
			achievementRtStatus.salesGrid.gridInstance.setDraw();
			
			var fileds = achievementRtStatus.salesGrid.dataProvider.getFields();
			
			for (var i in fileds) {
				if (fileds[i].fieldName.indexOf("SALES_PRICE_KRW") > -1) {
					fileds[i].dataType = "number";
				}
			}
			achievementRtStatus.salesGrid.dataProvider.setFields(fileds);
		}
    	
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
   		FORM_SEARCH.hrcyFlag   = true;
   		FORM_SEARCH.dimList    = DIMENSION.user;
   		FORM_SEARCH.meaList    = MEASURE.user;
   		FORM_SEARCH.bucketList = BUCKET.query;
		
		achievementRtStatus.search();
		achievementRtStatus.excelSubSearch();
	}

	// onload 
	$(document).ready(function() {
		achievementRtStatus.init();
	});
	
	
	function fn_setFieldsBuket() {
    	//필드 배열 객체를  생성합니다.
        var fields = [
            {fieldName : "BP_VAL"        , dataType  : "number"},
            {fieldName : "AP_AMT"        , dataType  : "number"},
            {fieldName : "OD_AMT"        , dataType  : "number"},
            {fieldName : "BIZ_DIFF"      , dataType  : "number"},
            {fieldName : "BIZ_JIN"       , dataType  : "number"},
            {fieldName : "ACT_DIFF"      , dataType  : "number"},
            {fieldName : "ACT_JIN"       , dataType  : "number"},
            {fieldName : "FCST_AMT"      , dataType  : "number"},
            {fieldName : "FCST_BIZ_DIFF" , dataType  : "number"},
            {fieldName : "FCST_BIZ_DAL"  , dataType  : "number"},
            {fieldName : "FCST_ACT_DIFF" , dataType  : "number"},
            {fieldName : "FCST_ACT_DAL"  , dataType  : "number"},
        ];
    	
    	return fields;
    }

    function fn_setColumnsBuket() {
    	//필드와 연결된 컬럼 배열 객체를 생성합니다.
        var columns = 
		[	
			{
				name      : "BP_VAL", //경영계획
				fieldName : "BP_VAL",
				header    : {text : '<spring:message code="lbl.bizPlan"/>'},
				styles    : {textAlignment : "far", numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType  : "number",
				editable  : false,
				width     : 100
			}, {
				name      : "AP_AMT", 
				fieldName : "AP_AMT", 
				header    : {text: '<spring:message code="lbl.monthlyPlan" javaScriptEscape="true" />'},
				styles    : {textAlignment: "far", numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType  : "number",
				editable  : false,
				width     : 100
			}, {
                type      : "group",
				name      : "DUMMY1", 
				header    : { fixedHeight : 20, text : '<spring:message code="lbl.currentMonth" javaScriptEscape="true" />' },
				width     : 500, 
				columns   : [
					{
						name      : "OD_AMT", //실적
						fieldName : "OD_AMT",
						header    : {text: '<spring:message code="lbl.actual" javaScriptEscape="true" />'},
						styles    : {textAlignment: "far", numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType  : "number",
						editable  : false,
						width     : 100
					}, {
						type  : "group", 
						name  : "<spring:message code='lbl.vsBizPlan'/>",
						columns   : [
							{
								name      : "BIZ_DIFF", 
								fieldName : "BIZ_DIFF", 
								header    : { text : "<spring:message code='lbl.difference'/>" }, 
								styles    : { textAlignment : "far", numberFormat : "#,##0"}, 
								dynamicStyles : [gfn_getDynamicStyle(-2)],
								dataType  : "number",
								width     : 100, 
								editable  : false 
							}, {
								name      : "BIZ_JIN", 
								fieldName : "BIZ_JIN", 
								header    : { text: "<spring:message code='lbl.progress'/>"},
								styles    : { textAlignment : "far", numberFormat : "#,##0.0"},
								dynamicStyles : [gfn_getDynamicStyle(-2)],
								dataType  : "number",
								editable  : false,
								width     : 100
							}
						]
					}, {
						type  : "group", 
						name  : "<spring:message code='lbl.vsMonthlyPlan'/>",
						columns   : [
							{
								name      : "ACT_DIFF", 
								fieldName : "ACT_DIFF", 
								header    : { text : "<spring:message code='lbl.difference'/>" }, 
								styles    : { textAlignment : "far", numberFormat : "#,##0"}, 
								dynamicStyles : [gfn_getDynamicStyle(-2)],
								dataType  : "number",
								width     : 100, 
								editable  : false 
							}, {
								name      : "ACT_JIN",
								fieldName : "ACT_JIN",
								header    : { text: "<spring:message code='lbl.progress'/>"},
								styles    : { textAlignment : "far", numberFormat : "#,##0.0"},
								dynamicStyles : [gfn_getDynamicStyle(-2)],
								dataType  : "number",
								editable  : false,
								width     : 100
							}
						]
					}
				]
			}, {
				type      : "group",
				name      : "DUMMY2", 
				header    : { fixedHeight : 20, text : "<spring:message code='lbl.expCurrentMonth'/>"},
				width     : 500, 
				columns   : [
					{
						name      : "FCST_AMT", 
						fieldName : "FCST_AMT",
						header    : {text: '<spring:message code="lbl.expActual" javaScriptEscape="true" />'},
						styles    : {textAlignment: "far", numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType  : "number",
						editable  : false,
						width     : 100
					}, {
						type  : "group", 
						name  : "<spring:message code='lbl.vsBizPlan'/>",
						columns   : [
							{
								name      : "FCST_BIZ_DIFF", 
								fieldName : "FCST_BIZ_DIFF", 
								header    : { text : "<spring:message code='lbl.difference'/>" }, 
								styles    : { textAlignment : "far", numberFormat : "#,##0"}, 
								dynamicStyles : [gfn_getDynamicStyle(-2)],
								dataType  : "number",
								width     : 100, 
								editable  : false 
							}, {
								name      : "FCST_BIZ_DAL", 
								fieldName : "FCST_BIZ_DAL", 
								header    : { text: "<spring:message code='lbl.achieRate'/>"},
								styles    : { textAlignment : "far", numberFormat : "#,##0.0"},
								dynamicStyles : [gfn_getDynamicStyle(-2)],
								dataType  : "number",
								editable  : false,
								width     : 100
							}
						]
					}, {
						type  : "group", 
						name  : "<spring:message code='lbl.vsMonthlyPlan'/>",
						columns   : [
							{
								name      : "FCST_ACT_DIFF", 
								fieldName : "FCST_ACT_DIFF", 
								header    : { text : "<spring:message code='lbl.difference'/>" }, 
								styles    : { textAlignment : "far", numberFormat : "#,##0"}, 
								dynamicStyles : [gfn_getDynamicStyle(-2)],
								dataType  : "number",
								width     : 100, 
								editable  : false 
							}, {
								name      : "FCST_ACT_DAL",
								fieldName : "FCST_ACT_DAL",
								header    : { text: "<spring:message code='lbl.achieRate'/>"},
								styles    : { textAlignment : "far", numberFormat : "#,##0.0"},
								dynamicStyles : [gfn_getDynamicStyle(-2)],
								dataType  : "number",
								editable  : false,
								width     : 100
							}
						]
					}
				]
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
		<input type="hidden" id="itemType" name="itemType" value="10,50"/>
		<div id="filterDv">
			<div class="inner">
				<h3>Filter</h3>
				<%@ include file="/WEB-INF/view/common/filterMonthSum.jsp"%>
				<div class="tabMargin"></div>
				<div class="scroll">
					<div class="view_combo" id="divItem"></div>
					<div class="view_combo" id="divProcurType"></div>
					<div class="view_combo" id="divUpItemGroup"></div>
					<div class="view_combo" id="divItemGroup"></div>
					<div class="view_combo" id="divRoute"></div>
					<div class="view_combo" id="divRepCustGroup"></div>
					<div class="view_combo" id="divCustGroup"></div>
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
