<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	<!-- 가용율 Trend -->
	<script type="text/javascript">

	var enterSearchFlag = "Y";
	var materialCostOutsourcing = {

		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.grid.initGrid();
		},
			
		_siq    : "supply.purchase.materialCostOutsourcingList",
		
		initFilter : function() {
			
			var itemTypeEvent = {
				childId   : ["upItemGroup"],  
				childData : [this.comCode.codeMapEx.UPPER_ITEM_GROUP, this.comCode.codeMapEx.ROUTING],
				callback  : function() {
					//품목그룹 초기화
					gfn_setMsCombo("itemGroup", [], ["*"]);
				}
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
				{ target : 'divRoute', id : 'route', title : '<spring:message code="lbl.routing"/>', data : this.comCode.codeMapEx.ROUTING, exData:["*"] },
				{ target : 'divUpItemGroup', id : 'upItemGroup', title : '<spring:message code="lbl.upperItemGroup"/>', data : this.comCode.codeMapEx.UPPER_ITEM_GROUP, exData:["*"], event: upperItemEvent },
				{ target : 'divItemGroup', id : 'itemGroup', title : '<spring:message code="lbl.itemGroup"/>', data : this.comCode.codeMapEx.ITEM_GROUP, exData:["*"]},
				{ target : 'divRepCustGroup', id : 'reptCustGroup', title : '<spring:message code="lbl.reptCustGroup"/>', data : this.comCode.codeMapEx.REP_CUST_GROUP, exData:["*"] },
			]);
			
			MONTHPICKER(null, 0, 0);
			var baseDt = new Date();
			$("#fromMon").monthpicker("option", "maxDate", new Date(baseDt.getFullYear(), baseDt.getMonth(), '01'));
		},
		
		/*
		* common Code 
		*/
		comCode : {
			codeMapEx : null,
			codeMap : null,
			
			initCode  : function () {
				var grpCd = '';
				this.codeMap = gfn_getComCode(grpCd, 'Y'); //공통코드 조회
				this.codeMapEx = gfn_getComCodeEx(["ITEM_GROUP", "UPPER_ITEM_GROUP", "ROUTING", "REP_CUST_GROUP"]);
				
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
				this.gridInstance.custBucketFalg = true;
				
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
					
					if(id == "divItem"){
						EXCEL_SEARCH_DATA += $("#item_nm").val();
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
					}else if(id == "divMonth"){
						EXCEL_SEARCH_DATA += $("#fromMon").val();
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
						materialCostOutsourcing.grid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						materialCostOutsourcing.grid.grdMain.cancel();
						
						materialCostOutsourcing.grid.dataProvider.setRows(data.resList);
						materialCostOutsourcing.grid.dataProvider.clearSavePoints();
						materialCostOutsourcing.grid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(materialCostOutsourcing.grid.dataProvider.getRowCount());
						gfn_setRowTotalFixed(materialCostOutsourcing.grid.grdMain);
					}
				}
			}
			gfn_service(aOption, "obj");
		}
	};
	
	//조회
	var fn_apply = function (sqlFlag) {
		
		gfn_getMenuInit();
		
		if (!sqlFlag) {
			materialCostOutsourcing.grid.gridInstance.setDraw();
		}
    	
    	FORM_SEARCH = $("#searchForm").serializeObject(); 
    	FORM_SEARCH.sql        = sqlFlag;
   		FORM_SEARCH.dimList    = DIMENSION.user;
   		//FORM_SEARCH.hiddenList = DIMENSION.hidden;
   		//FORM_SEARCH.bucketList = BUCKET.query;
		materialCostOutsourcing.search();
		materialCostOutsourcing.excelSubSearch();
	}

	function fn_setFieldsBuket() {
    	//필드 배열 객체를  생성합니다.
        var fields = [
            {fieldName : "QTY", dataType : "number"},
            {fieldName : "SALES_PRICE_KRW", dataType : "number"},
            {fieldName : "PROD_AMT", dataType : "number"},
            {fieldName : "MAT_AMT", dataType : "number"},
            {fieldName : "SUB_AMT", dataType : "number"},
            {fieldName : "MAT_PRICE", dataType : "number"},
            {fieldName : "SUB_PRICE", dataType : "number"},
            {fieldName : "MAT_RATE", dataType : "number"},
            {fieldName : "SUB_RATE", dataType : "number"}
        ];
    	return fields;
    }

    function fn_setColumnsBuket() {
    	//필드와 연결된 컬럼 배열 객체를 생성합니다.
        var columns = 
		[	
			{//생산 입고량
				name : "QTY", fieldName: "QTY", editable: false, header: {text: '<spring:message code="lbl.prodEnterQty" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(0)],
				dataType : "number",
				width: 100
			}, {//단가
				name : "SALES_PRICE_KRW", fieldName: "SALES_PRICE_KRW", editable: false, header: {text: '<spring:message code="lbl.itemPrice" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(0)],
				dataType : "number",
				width: 100
			}, {//생산금액
				name : "PROD_AMT", fieldName: "PROD_AMT", editable: false, header: {text: '<spring:message code="lbl.prodAmt" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(0)],
				dataType : "number",
				width: 100
			}, {//재료비
				name : "MAT_AMT", fieldName: "MAT_AMT", editable: false, header: {text: '<spring:message code="lbl.materialCost" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(0)],
				dataType : "number",
				width: 100
			}, {//외주가공비
				name : "SUB_AMT", fieldName: "SUB_AMT", editable: false, header: {text: '<spring:message code="lbl.outsideOrderCost" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(0)],
				dataType : "number",
				width: 100
			}, {//재료비단가
				name : "MAT_PRICE", fieldName: "MAT_PRICE", editable: false, header: {text: '<spring:message code="lbl.materialCostKrw" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(0)],
				dataType : "number",
				width: 100
			}, {//외주비단가
				name : "SUB_PRICE", fieldName: "SUB_PRICE", editable: false, header: {text: '<spring:message code="lbl.outsideCost" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(0)],
				dataType : "number",
				width: 100
			}, {//재료비율
				name : "MAT_RATE", fieldName: "MAT_RATE", editable: false, header: {text: '<spring:message code="lbl.materialRatio" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(0)],
				dataType : "number",
				width: 100
			}, {//외주비율
				name : "SUB_RATE", fieldName: "SUB_RATE", editable: false, header: {text: '<spring:message code="lbl.outsideRate" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(0)],
				dataType : "number",
				width: 100
			}
		];
    	return columns;
    }

	// onload 
	$(document).ready(function() {
		materialCostOutsourcing.init();
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
					<div class="view_combo" id="divRoute"></div>
					<div class="view_combo" id="divRepCustGroup"></div>
					<div class="view_combo" id="divUpItemGroup"></div>
					<div class="view_combo" id="divItemGroup"></div>
					<div class="view_combo" id="divMonth">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.month" />  </div>
							<input type="text" id="fromMon" name="fromMon" class="iptdate datepicker2 monthpicker" value="">
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
			<%-- <div class="cbt_btn" style="height:25px">
				<div class="bleft">
				</div>
				<div class="bright">
					<a href="javascript:;" id="btnReset" class="app1 roleWrite"><spring:message code="lbl.reset" /></a>
					<a href="javascript:;" id="btnSave" class="app1 roleWrite"><spring:message code="lbl.save" /></a>
				</div>
			</div> --%>
		</div>
    </div>
</body>
</html>
