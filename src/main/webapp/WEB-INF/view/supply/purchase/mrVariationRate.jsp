<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	<!-- 가용율 Trend -->
	<script type="text/javascript">

	var enterSearchFlag = "Y";
	var mrVariationRate = {

		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.mrVariationRateGrid.initGrid();
		},
			
		_siq    : "supply.purchase.mrVariationRateList",
		
		
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
				{target : 'divProcurType', id : 'procurType', title : '<spring:message code="lbl.procure"/>', data : this.comCode.codeMap.PROCUR_TYPE, exData:[""], option: {allFlag:"Y"}},
				{target : 'divUpItemGroup', id : 'upItemGroup', title : '<spring:message code="lbl.upperItemGroup"/>', data : this.comCode.codeMapEx.UPPER_ITEM_GROUP, exData:["*"], event: upperItemEvent },
				{target : 'divItemGroup', id : 'itemGroup', title : '<spring:message code="lbl.itemGroup"/>', data : this.comCode.codeMapEx.ITEM_GROUP, exData:["*"]},
				{target : 'divItemType', id : 'itemType', title : '<spring:message code="lbl.itemType"/>', data : this.comCode.codeMap.ITEM_TYPE, exData:[""], event : itemTypeEvent, option: {allFlag:"Y"}},
			]);
			
			var nowDt = new Date();
		    
			var dt_stamp = nowDt.getTime();
		    var days = (7 * 4); //4주전 일요일
		    var weekday = nowDt.getDay();
		    days = days + weekday;
		    toDt = new Date(dt_stamp-(days*24*60*60*1000));
		    var startDt = toDt.getFullYear() + '' + (toDt.getMonth()+1  < 10 ? '0' + (toDt.getMonth()+1 ) : toDt.getMonth()+1 ) + (toDt.getDate() < 10 ? '0' + toDt.getDate() : toDt.getDate());
		    
		    fromDt = new Date(dt_stamp+((7+(6-weekday))*24*60*60*1000)   ); // 1주 후 토요일
		    var endDt = fromDt.getFullYear() + '' + (fromDt.getMonth()+1  < 10 ? '0' + (fromDt.getMonth()+1 ) : fromDt.getMonth()+1 ) + (fromDt.getDate() < 10 ? '0' + fromDt.getDate() : fromDt.getDate());
		    
		    DATEPICKET(null, startDt, endDt);
			    
		    var dateParam = {
				arrTarget : [
					{calId : "fromCal", weekId : "fromWeek", defVal : 0}
				]
			};
			DATEPICKET(dateParam);
			$('#fromCal').datepicker("option", "maxDate", new Date().getWeekDay(0, false));
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
				
				this.codeMap.PROCUR_TYPE = $.grep(this.codeMap.PROCUR_TYPE, function(v, n) {
					return v.CODE_CD != 'MG'; 
				});
				
				this.codeMap.ITEM_TYPE = $.grep(this.codeMap.ITEM_TYPE, function(v, n) {
					return v.CODE_CD != '50'; 
				});
			}
		},
	
		/* 
		* grid  선언
		*/
		mrVariationRateGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				this.gridInstance.custBucketFalg = true;
				
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
					}else if(id == "divStandDate"){
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
					
					if(data.resList.length == 1){
						data.resList = [];
					}
					
					if (FORM_SEARCH.sql == 'N') {
						mrVariationRate.mrVariationRateGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						mrVariationRate.mrVariationRateGrid.grdMain.cancel();
						
						mrVariationRate.mrVariationRateGrid.dataProvider.setRows(data.resList);
						mrVariationRate.mrVariationRateGrid.dataProvider.clearSavePoints();
						mrVariationRate.mrVariationRateGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(mrVariationRate.mrVariationRateGrid.dataProvider.getRowCount());
						gfn_setRowTotalFixed(mrVariationRate.mrVariationRateGrid.grdMain);
						
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
				mrVariationRate.mrVariationRateGrid.gridInstance.setDraw();
			}
		}
	};
	

	//조회
	var fn_apply = function (sqlFlag) {
		
		gfn_getMenuInit();
		
		//mrVariationRate.getBucket(sqlFlag); 
		
		if (!sqlFlag) {
			mrVariationRate.mrVariationRateGrid.gridInstance.setDraw();
		}
    	
    	FORM_SEARCH = $("#searchForm").serializeObject(); 
    	FORM_SEARCH.sql        = sqlFlag;
   		FORM_SEARCH.dimList    = DIMENSION.user;
   		FORM_SEARCH.bucketList = BUCKET.query;
		mrVariationRate.search();
		mrVariationRate.excelSubSearch();
	}
	

	function fn_setFieldsBuket() {
    	//필드 배열 객체를  생성합니다.
        var fields = [
            {fieldName : "MRP_QTY_W-01_F", dataType : "number"},
            {fieldName : "GAP", dataType : "number"},
            {fieldName : "MRP_QTY_W-01", dataType : "number"},
            {fieldName : "MRP_QTY_W-02", dataType : "number"},
            {fieldName : "MRP_QTY_W-03", dataType : "number"},
            {fieldName : "MRP_QTY_W-04", dataType : "number"},
            {fieldName : "MRP_QTY_W-05", dataType : "number"},
            {fieldName : "MRP_QTY_W-06", dataType : "number"},
            {fieldName : "MRP_QTY_W-07", dataType : "number"},
            {fieldName : "MRP_QTY_W-08", dataType : "number"},
            {fieldName : "MRP_QTY_W-09", dataType : "number"},
            {fieldName : "MRP_QTY_W-10", dataType : "number"},
            {fieldName : "MRP_QTY_W-11", dataType : "number"},
            {fieldName : "MRP_QTY_W-12", dataType : "number"},
            {fieldName : "MIN_MRP_QTY", dataType : "number"},
            {fieldName : "MAX_MRP_QTY", dataType : "number"},
            {fieldName : "AVG_MRP_QTY", dataType : "number"},
            {fieldName : "STDEV_MRP_QTY", dataType : "number"},
            {fieldName : "F/P_CHG", dataType : "number"},
            {fieldName : "W-02_CHG", dataType : "number"},
            {fieldName : "W-03_CHG", dataType : "number"},
            {fieldName : "W-04_CHG", dataType : "number"},
            {fieldName : "W-05_CHG", dataType : "number"},
            {fieldName : "W-08_CHG", dataType : "number"},
            {fieldName : "W-12_CHG", dataType : "number"}
        ];
    	
    	return fields;
    }

    function fn_setColumnsBuket() {
    	//필드와 연결된 컬럼 배열 객체를 생성합니다.
        var columns = 
		[	
			{
                type: "group",
                name: '<spring:message code="lbl.confirmFinalVersion" javaScriptEscape="true" />',
                header: {text: '<spring:message code="lbl.confirmFinalVersion" javaScriptEscape="true" />'},
                fieldName: "WEEK_GROUP",
                width: 160,
                columns : [
                	{
						name : "MRP_QTY_W-01_F", fieldName: "MRP_QTY_W-01_F", editable: false, header: {text: '<spring:message code="lbl.w01Final" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 80
					}, {
						name : "GAP", fieldName: "GAP", editable: false, header: {text: '<spring:message code="lbl.gapFinPre" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 80
					}
                ]
            }, {
                type: "group",
                name: '<spring:message code="lbl.planPreVersion" javaScriptEscape="true" />',
                header: {text: '<spring:message code="lbl.planPreVersion" javaScriptEscape="true" />' + gv_expand},
                fieldName: "WEEK_GROUP2",
                width: 1280,
                columns : [
                	{
						name : "MRP_QTY_W-01", fieldName: "MRP_QTY_W-01", editable: false, header: {text: '<spring:message code="lbl.w01" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 80
					}, {
						name : "MRP_QTY_W-02", fieldName: "MRP_QTY_W-02", editable: false, header: {text: '<spring:message code="lbl.w02" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 80
					}, {
						name : "MRP_QTY_W-03", fieldName: "MRP_QTY_W-03", editable: false, header: {text: '<spring:message code="lbl.w03" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 80
					}, {
						name : "MRP_QTY_W-04", fieldName: "MRP_QTY_W-04", editable: false, header: {text: '<spring:message code="lbl.w04" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 80
					}, {
						name : "MRP_QTY_W-05", fieldName: "MRP_QTY_W-05", editable: false, header: {text: '<spring:message code="lbl.w05" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 80
					}, {
						name : "MRP_QTY_W-06", fieldName: "MRP_QTY_W-06", editable: false, header: {text: '<spring:message code="lbl.w06" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 80
					}, {
						name : "MRP_QTY_W-07", fieldName: "MRP_QTY_W-07", editable: false, header: {text: '<spring:message code="lbl.w07" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 80
					}, {
						name : "MRP_QTY_W-08", fieldName: "MRP_QTY_W-08", editable: false, header: {text: '<spring:message code="lbl.w08" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 80
					}, {
						name : "MRP_QTY_W-09", fieldName: "MRP_QTY_W-09", editable: false, header: {text: '<spring:message code="lbl.w09" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 80
					}, {
						name : "MRP_QTY_W-10", fieldName: "MRP_QTY_W-10", editable: false, header: {text: '<spring:message code="lbl.w10" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 80
					}, {
						name : "MRP_QTY_W-11", fieldName: "MRP_QTY_W-11", editable: false, header: {text: '<spring:message code="lbl.w11" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 80
					}, {
						name : "MRP_QTY_W-12", fieldName: "MRP_QTY_W-12", editable: false, header: {text: '<spring:message code="lbl.w12" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 80
					}, {
						name : "MIN_MRP_QTY", fieldName: "MIN_MRP_QTY", editable: false, header: {text: '<spring:message code="lbl.min" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 80
					}, {
						name : "MAX_MRP_QTY", fieldName: "MAX_MRP_QTY", editable: false, header: {text: '<spring:message code="lbl.max" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 80
					}, {
						name : "AVG_MRP_QTY", fieldName: "AVG_MRP_QTY", editable: false, header: {text: '<spring:message code="lbl.average" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 80
					}, {
						name : "STDEV_MRP_QTY", fieldName: "STDEV_MRP_QTY", editable: false, header: {text: '<spring:message code="lbl.stdevPlQty" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 80
					}
                ]
            }, {
                type: "group",
                name: '<spring:message code="lbl.variationRate" javaScriptEscape="true" />',
                header: {text: '<spring:message code="lbl.variationRate" javaScriptEscape="true" />' + gv_expand},
                fieldName: "WEEK_GROUP3",
                width: 560,
                columns : [
                	{
						name : "F/P_CHG", fieldName: "F/P_CHG", editable: false, header: {text: '<spring:message code="lbl.finPre" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 80
					}, {
						name : "W-02_CHG", fieldName: "W-02_CHG", editable: false, header: {text: '<spring:message code="lbl.w02Com" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 80
					}, {
						name : "W-03_CHG", fieldName: "W-03_CHG", editable: false, header: {text: '<spring:message code="lbl.w03Com" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 80
					}, {
						name : "W-04_CHG", fieldName: "W-04_CHG", editable: false, header: {text: '<spring:message code="lbl.w04Com" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 80
					}, {
						name : "W-05_CHG", fieldName: "W-05_CHG", editable: false, header: {text: '<spring:message code="lbl.w05Com" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 80
					}, {
						name : "W-08_CHG", fieldName: "W-08_CHG", editable: false, header: {text: '<spring:message code="lbl.w08Com" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 80
					}, {
						name : "W-12_CHG", fieldName: "W-12_CHG", editable: false, header: {text: '<spring:message code="lbl.w12Com" javaScriptEscape="true" />'},
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
		mrVariationRate.init();
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
					<div class="view_combo" id="divStandDate">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.standDate"/></div>
							<input type="text" id="fromCal" name="fromCal" class="iptdate datepicker2"/>
							<input type="text" id="fromWeek" name="fromWeek" class="iptdateweek" disabled="disabled" value=""/>
						</div>
					</div>
					<div class="view_combo" id="divItem"></div>
					<div class="view_combo" id="divProcurType"></div>
					<div class="view_combo" id="divItemType"></div>
					<div class="view_combo" id="divUpItemGroup"></div>
					<div class="view_combo" id="divItemGroup"></div>
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
