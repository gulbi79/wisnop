<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	
	<script type="text/javascript">
	gv_total = "Average";
	var enterSearchFlag = "Y";
	var manLtTrend = {

		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.manLtTrendGrid.initGrid();
		},
			
		_siq    : "supply.product.manLtTrendList",
		
		initFilter : function() {
			
			// 키워드팝업
			gfn_keyPopAddEvent([
				{ target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>'}
			]);
			
			// 콤보박스
			gfn_setMsComboAll([
				{target : 'divRepCustGroup', id : 'reptCustGroup', title : '<spring:message code="lbl.reptCustGroup"/>', data : this.comCode.codeMapEx.REP_CUST_GROUP, exData:["*"] },
				{target : 'divCustGroup', id : 'custGroup', title : '<spring:message code="lbl.custGroup"/>', data : this.comCode.codeMapEx.CUST_GROUP, exData:["*"] },
				{target : 'divRoute', id : 'route', title : '<spring:message code="lbl.routing"/>', data : this.comCode.codeMapEx.ROUTING, exData:["*"] },
				{target : 'divItemType', id : 'itemType', title : '<spring:message code="lbl.itemType"/>', data : this.comCode.codeMap.ITEM_TYPE, exData:[""], option: {allFlag:"Y"}},
				{target : 'divProdPart', id : 'prodPart', title : '<spring:message code="lbl.prodPart2"/>', data : this.comCode.codeMap.PROD_PART, exData:[""], option: {allFlag:"Y"} },
				{target : 'divLtCompPoint', id : 'ltCompPoint', title : '<spring:message code="lbl.comPoint"/>', data : this.comCode.codeMap.LT_COMP_POINT, exData:["*"], type : "S"},
				{target : 'divItemGroup', id : 'itemGroup', title : '<spring:message code="lbl.itemGroup"/>', data : this.comCode.codeMapEx.ITEM_GROUP, exData:["*"]},
			]);
			
			MONTHPICKER(null, -3, 0);
			
			$('#fromMon').monthpicker("option", "minDate", gfn_getStringToDate("20180101"));
			$('#toMon').monthpicker("option", "maxDate", 0);
		},
		
		/*
		* common Code 
		*/
		comCode : {
			codeMap : null,
			codeMapEx : null,
			
			initCode : function () {
				var grpCd    = 'PROD_PART,LT_COMP_POINT,ITEM_TYPE';
				this.codeMap = gfn_getComCode(grpCd, 'Y'); //공통코드 조회
				this.codeMapEx = gfn_getComCodeEx(["ITEM_GROUP", "REP_CUST_GROUP", "CUST_GROUP", "ROUTING"], null, {itemType : "" });
				
				this.codeMap.PROD_PART[0].CODE_NM = "";
				this.codeMap.LT_COMP_POINT[0].CODE_NM = "";
			}
		},
	
		/* 
		* grid  선언
		*/
		manLtTrendGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				this.gridInstance.custBeforeBucketFalg = true;
				
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
			
			$("#btnDetail").on('click', function (e) {
				
				var prodPart = gfn_nvl($("#prodPart").val(), "");
				var ltCompPoint = gfn_nvl($("#ltCompPoint").val(), "");
				
				if(prodPart == ""){
					alert('<spring:message code="msg.prodPartMsg" javaScriptEscape="true" />');
					return;
				}
				
				if(ltCompPoint == ""){
					alert('<spring:message code="msg.comPointMsg" javaScriptEscape="true" />');
					return;
				}
				
				gfn_comPopupOpen("PROD_MAN_LT_TREND", {
					rootUrl : "supply/product",
					url     : "manLtTrendDetail",
					width   : 1150,
					height  : 680,
					item : $("#item_nm").val(),
					prodPart : $("#prodPart").val(),
					ltCompPoint : $("#ltCompPoint").val(),
					itemGroup : $("#itemGroup").val(),
					fromDate : gfn_replaceAll($("#fromMon").val(), "-", "") + "01",
					toDate : gfn_replaceAll($("#toMon").val(), "-", "") + "31",
					menuCd : "MP111"
				});
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
					if(id == "divProdPart"){
						EXCEL_SEARCH_DATA += $("#prodPart option:selected").text();						
					}else if(id == "divLtCompPoint"){
						EXCEL_SEARCH_DATA += $("#ltCompPoint option:selected").text();
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
					}else if(id == "divItem"){
						EXCEL_SEARCH_DATA += $("#item_nm").val();
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
					}
				}
			});
			
			EXCEL_SEARCH_DATA += "\n" + $("#view_Her .tlist .tit").html() + " : ";
			EXCEL_SEARCH_DATA += $("#fromMon").val() + " ~ " + $("#toMon").val();
		},
		
		// 조회
		search : function () {
			
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{outDs : "resList", _siq : this._siq }];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj.do",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						manLtTrend.manLtTrendGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						manLtTrend.manLtTrendGrid.grdMain.cancel();
						
						manLtTrend.manLtTrendGrid.dataProvider.setRows(data.resList);
						manLtTrend.manLtTrendGrid.dataProvider.clearSavePoints();
						manLtTrend.manLtTrendGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_actionMonthSum(manLtTrend.manLtTrendGrid.gridInstance);
						gfn_setRowTotalFixed(manLtTrend.manLtTrendGrid.grdMain);
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		getBucket : function (sqlFlag) {
			var ajaxMap = {
				fromDate : gfn_replaceAll($("#fromMon").val(), "-", "") + "01",
				toDate   : gfn_replaceAll($("#toMon").val(), "-", "") + "31",
	       		sqlId    : ["supply.product.manLtTrendBucket"]
			}
			gfn_getBucket(ajaxMap);
			
			if (!sqlFlag) {
				manLtTrend.manLtTrendGrid.gridInstance.setDraw();
				
				$.each(BUCKET.query, function(n, v) {
					manLtTrend.manLtTrendGrid.grdMain.setColumnProperty(v.CD, "styles", {"numberFormat" : "#,##0.0"});
	    		});
			}
		}
	};
	
	//조회
	var fn_apply = function (sqlFlag) {
		
		var prodPart = gfn_nvl($("#prodPart").val(), "");
		var ltCompPoint = gfn_nvl($("#ltCompPoint").val(), "");
		
		if(prodPart == ""){
			alert('<spring:message code="msg.prodPartMsg" javaScriptEscape="true" />');
			return;
		}
		
		if(ltCompPoint == ""){
			alert('<spring:message code="msg.comPointMsg" javaScriptEscape="true" />');
			return;
		}
		
		gfn_getMenuInit();
		
		manLtTrend.getBucket(sqlFlag); 
    	
    	FORM_SEARCH = $("#searchForm").serializeObject(); 
    	FORM_SEARCH.sql        = sqlFlag;
   		FORM_SEARCH.dimList    = DIMENSION.user;
   		FORM_SEARCH.bucketList = BUCKET.query;
   		FORM_SEARCH.bucketSize = BUCKET.query.length;
   		
		manLtTrend.search();
		manLtTrend.excelSubSearch();
	}
	
	function fn_setBeforeFieldsBuket() {
		var fields = [
			{fieldName: "AVG_VALUE", dataType : "number"},
			{fieldName: "MIN_VALUE", dataType : "number"},
			{fieldName: "MAX_VALUE", dataType : "number"}
        ];
    	return fields;
	}
	
	function fn_setBeforeColumnsBuket() {
		var columns = [	
			{
				name : "AVG_VALUE", fieldName: "AVG_VALUE", editable: false, header: {text: '<spring:message code="lbl.average" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0.0"},
				dynamicStyles : [gfn_getDynamicStyle(0)],
				dataType : "number",
				width: 80
			}, {
				name : "MIN_VALUE", fieldName: "MIN_VALUE", editable: false, header: {text: '<spring:message code="lbl.mixPlQty" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0.0"},
				dynamicStyles : [gfn_getDynamicStyle(0)],
				dataType : "number",
				width: 80
			}, {
				name : "MAX_VALUE", fieldName: "MAX_VALUE", editable: false, header: {text: '<spring:message code="lbl.maxPlQty" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0.0"},
				dynamicStyles : [gfn_getDynamicStyle(0)],
				dataType : "number",
				width: 80
			}
		];
		return columns;
	}

	// onload 
	$(document).ready(function() {
		manLtTrend.init();
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
					
					<div class="view_combo" id="divProdPart"></div>
					<div class="view_combo" id="divLtCompPoint"></div>
					<div class="view_combo" id="divRepCustGroup"></div>
					<div class="view_combo" id="divCustGroup"></div>
					<div class="view_combo" id="divRoute"></div>
					<div class="view_combo" id="divItemType"></div>
					<div class="view_combo" id="divItemGroup"></div>
					<div class="view_combo" id="divItem"></div>
					<jsp:include page="/WEB-INF/view/common/filterViewHorizonMonth.jsp" flush="false" />
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
			<div class="cbt_btn" style="height:25px">
				<div class="bleft">
				</div>
				<div class="bright">
					<a href="javascript:;" id="btnDetail" class="app1"><spring:message code="lbl.detail2" /></a> 
				</div>
			</div>
		</div>
    </div>
</body>
</html>
