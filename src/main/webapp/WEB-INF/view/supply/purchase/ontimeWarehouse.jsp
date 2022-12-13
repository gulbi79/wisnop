<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
<script type="text/javascript">
	
	var enterSearchFlag = "Y";
	var warehouse = {
		init : function() {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.grid.initGrid();
		},
		
		initFilter : function() {
			
			// 키워드팝업
			gfn_keyPopAddEvent([
				{target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>' },
				{target : 'divCustomer', id : 'customer', type : 'CUSTOMER', title : '<spring:message code="lbl.customer"/>' }
			]);
			
			// 콤보박스
			gfn_setMsComboAll([
				{target : 'divItemGroup' , id : 'itemGroup' , title : '<spring:message code="lbl.itemGroup"/>'    , data : this.comCode.codeMapEx.ITEM_GROUP , exData:[""], option: {allFlag:"Y"}},
				{target : 'divUpItemGroup',  id : 'upItemGroup',   title : '<spring:message code="lbl.upperItemGroup"/>', data : this.comCode.codeMapEx.UPPER_ITEM_GROUP, exData:["*"], option: {allFlag:"Y"}},
				{target : 'divObeyYn'    , id : 'obeyYn'    , title : '<spring:message code="lbl.obeyYn"/>'       , data : this.comCode.codeMap.CUMULATIVE_CD, exData:["*"], type : "S"},
				{target : 'divItemType'  , id : 'itemType'  , title : '<spring:message code="lbl.materialsType"/>', data : this.comCode.codeMap.ITEM_TYPE    , exData:["*"], type : "S"},
				{target : 'divImportFlag', id : 'importFlag', title : '<spring:message code="lbl.customerType"/>' , data : this.comCode.codeMap.IMPORT_FLAG  , exData:["*"], type : "S"}
			]);
			
			DATEPICKET(null, -5, 0);
	       	
	       	$('#toCal').datepicker("option", "maxDate", 0);
		},
		
		comCode : {
			codeMap   : null,
			codeMapEx : null,
			
			initCode  : function() {
				var grpCd = 'CUMULATIVE_CD,IMPORT_FLAG';
				this.codeMap = gfn_getComCode(grpCd, 'Y'); //공통코드 조회
				this.codeMapEx = gfn_getComCodeEx(["ITEM_GROUP","UPPER_ITEM_GROUP"]);
				
				gfn_service({
					async   : false,
					url     : GV_CONTEXT_PATH + "/biz/obj",
					data    : {
						_mtd:"getList",
						tranData:[
							{outDs:"itemType"  ,_siq:"supply.purchase.itemType"}
						]
					},
					success : function(data) {
						warehouse.comCode.codeMap.ITEM_TYPE = data.itemType;
						warehouse.comCode.codeMap.ITEM_TYPE.unshift({GROUP_CD:"ITEM_TYPE", CODE_CD:"", CODE_NM:"All"});
					}
				}, "obj");
				
				gfn_service({
					async   : false,
					url     : GV_CONTEXT_PATH + "/biz/obj",
					data    : {
						_mtd:"getList",
						tranData:[
							{outDs:"grCompRate"  ,_siq:"supply.purchase.grCompRate"}
						]
					},
					success : function(data) {
						warehouse.comCode.codeMap.GR_COMP_RATE = data.grCompRate;
						
						var d1 = "80";
						var d2 = "1";
						
						if(data.grCompRate.length > 0) {
							d1 = data.grCompRate[0].ATTB_1_CD;
							d2 = data.grCompRate[0].ATTB_2_CD;
						}
						
						var str = '<spring:message code="lbl.grCompRate"/>';
						str = str.replace("#1", d1).replace("#2", d2);
						
						$("#grCompRate").html(str);
					}
				}, "obj");
			}
		},
		
		events : function() {
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
		},
		
		grid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function() {
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				this.gridInstance.custNextBucketFalg = true;
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				
				warehouse.setOptions();
				
				this.dataProvider.setOptions({
					softDeleting : true
				});
			}
		},
		
		setOptions : function () {
			warehouse.grid.grdMain.setOptions({
				stateBar: { visible       : false },
				display : { columnMovable : false }
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
					}else if(id == "divCustomer"){
						EXCEL_SEARCH_DATA += $("#customer_nm").val();
					}else if(id == "divObeyYn"){
						EXCEL_SEARCH_DATA += $("#obeyYn option:selected").text();
					}else if(id == "divItemType"){
						EXCEL_SEARCH_DATA += $("#itemType option:selected").text();
					}else if(id == "divImportFlag"){
						EXCEL_SEARCH_DATA += $("#importFlag option:selected").text();
					}
				}
			});
			
			EXCEL_SEARCH_DATA += "\n" + '<spring:message code="lbl.period"/>' + " : ";
			EXCEL_SEARCH_DATA += $("#fromCal").val() + "(" + $("#fromWeek").val() + ") ~ ";
			EXCEL_SEARCH_DATA += $("#toCal").val() + "(" + $("#toWeek").val() + ")";
			
		},
		
		
		search : function() {
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList", _siq : "supply.purchase.warehouse" }];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						warehouse.grid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						warehouse.grid.grdMain.cancel();
						
						warehouse.grid.dataProvider.setRows(data.resList);
						warehouse.grid.dataProvider.clearSavePoints();
						warehouse.grid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(warehouse.grid.dataProvider.getRowCount());
						gfn_setRowTotalFixed(warehouse.grid.grdMain);
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		getBucket : function(sqlFlag) {
			if (!sqlFlag) {
				warehouse.grid.gridInstance.setDraw();
			}
		}
	};
	
	//조회
	var fn_apply = function (sqlFlag) {
	
		gfn_getMenuInit();
		
	   	FORM_SEARCH = $("#searchForm").serializeObject(); 
	   	FORM_SEARCH.sql     = sqlFlag;
	   	FORM_SEARCH.dimList = DIMENSION.user;
	   	
	   	warehouse.getBucket(sqlFlag); 
	   	warehouse.search();
	   	warehouse.excelSubSearch();
	};
	
	function fn_setNextFieldsBuket() {
		var fields = [
			{fieldName: "PO_DATE"},
			{fieldName: "DLV_GR_BL_DATE"},
			{fieldName: "GR_BL_DATE"},
			{fieldName: "DATE_DIFF" , dataType : "number"},
			{fieldName: "PO_QTY"    , dataType : "number"},
			{fieldName: "GR_BL_QTY" , dataType : "number"},
			{fieldName: "QTY_DIFF"  , dataType : "number"},
			{fieldName: "QTY_RT"    , dataType : "number"},
			{fieldName: "OBSERVE"   , dataType : "number"},
			{fieldName: "UN_OBSERVE", dataType : "number"},
			{fieldName: "RT"        , dataType : "number"}
	       ];
	   	
	   	return fields;
	}
	
	function fn_setNextColumnsBuket() {
		var columns = [
			{
				name : "PO_DATE", fieldName: "PO_DATE", editable : false, header: {text: '<spring:message code="lbl.poDate" javaScriptEscape="true" />'},
				styles: {textAlignment: "center", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				width: 100
			}, {
				name : "DLV_GR_BL_DATE", fieldName: "DLV_GR_BL_DATE", editable : false, header: {text: '<spring:message code="lbl.dlvGrBlDate" javaScriptEscape="true" />'},
				styles: {textAlignment: "center", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				width: 100
			}, {
				name : "GR_BL_DATE", fieldName: "GR_BL_DATE", editable : false, header: {text: '<spring:message code="lbl.grBlDate" javaScriptEscape="true" />'},
				styles: {textAlignment: "center", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				width: 100
			}, {
				name : "DATE_DIFF", fieldName: "DATE_DIFF", editable : false, header: {text: '<spring:message code="lbl.dateDiff" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor},
				dataType : "number",
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				width: 100
			}, {
				name : "PO_QTY", fieldName: "PO_QTY", editable : false, header: {text: '<spring:message code="lbl.poQty" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 100
			}, {
				name : "GR_BL_QTY", fieldName: "GR_BL_QTY", editable : false, header: {text: '<spring:message code="lbl.grBlQty" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 100
			}, {
				name : "QTY_DIFF", fieldName: "QTY_DIFF", editable : false, header: {text: '<spring:message code="lbl.qtyDiff" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				width: 100
			}, {
				name : "QTY_RT", fieldName: "QTY_RT", editable : false, header: {text: '<spring:message code="lbl.qtyRt" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 80
			}, {
				name : "OBSERVE", fieldName: "OBSERVE", editable : false, header: {text: '<spring:message code="lbl.observe" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 80
			}, {
				name : "UN_OBSERVE", fieldName: "UN_OBSERVE", editable : false, header: {text: '<spring:message code="lbl.unObserve" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 80
			}, {
				name : "RT", fieldName: "RT", editable : true, header: {text: '<spring:message code="lbl.rt" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 80
			}
		];
		
		return columns;
	}
	
	// onload 
	$(document).ready(function() {
		warehouse.init();
		
		$("#filter_tit").html('<spring:message code="lbl.defectDvh2"/>');
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
					<div class="view_combo" id="divUpItemGroup"></div>
					<div class="view_combo" id="divItemGroup"></div>
					<div class="view_combo" id="divCustomer"></div>
					<div class="view_combo" id="divObeyYn"></div>
					<div class="view_combo" id="divItemType"></div>
					<div class="view_combo" id="divImportFlag"></div>
					<jsp:include page="/WEB-INF/view/common/filterViewHorizon.jsp" flush="false">
						<jsp:param name="radioYn" value="N"/>
						<jsp:param name="wType" value="SW"/>
					</jsp:include>
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
