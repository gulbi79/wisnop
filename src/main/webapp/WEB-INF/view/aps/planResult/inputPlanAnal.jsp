<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
<script type="text/javascript">
	var enterSearchFlag = "Y";
	
	var inputPlanAnal = {
		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.grid.initGrid();
		},
		
		_siq    : "aps.planResult.inputPlanAnal",
		
		comCode : {
			codeMapEx : null,
			codeMap   : null,
			initCode  : function() {
				var grpCd      = 'PROD_PART,VERSION_TYPE_CD,ITEM_TYPE,APS_DEMAND_TYPE,FLAG_YN';
				this.codeMap   = gfn_getComCode(grpCd, 'Y'); 
				this.codeMapEx = gfn_getComCodeEx(["ROUTING", "ITEM_GROUP", "REP_CUST_GROUP"], null, {});
				
				this.codeMap.VERSION_TYPE_CD = $.grep(this.codeMap.VERSION_TYPE_CD, function(v, n) {
		           	return $.inArray(v.ATTB_1_CD, ["Y"]) > -1;
		        });
				
				//레이저 가공
				this.codeMapEx.ROUTING = $.grep(this.codeMapEx.ROUTING, function(v, n) {
		           	return $.inArray(v.CODE_CD, ["레이저 가공"]) == -1;
		        });
			}
		},
		
		initFilter : function() {
			// 키워드팝업
			gfn_keyPopAddEvent([
				{ target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>' }
			]);
			
			//Plan ID
	    	fn_getPlanId({picketType:"W",planTypeCd:"MP"});
			
	    	// 콤보박스
			gfn_setMsComboAll([
				{target : 'divProdPart', id : 'prodPart', title : '<spring:message code="lbl.prodPart2"/>', data : this.comCode.codeMap.PROD_PART, exData:[""]},
				{target : 'divItemType', id : 'itemType', title : '<spring:message code="lbl.itemType"/>', data : this.comCode.codeMap.ITEM_TYPE, exData:[""], option: {allFlag:"Y"}},
				{target : 'divVersionTypeCd', id : 'versionTypeCd', title : '<spring:message code="lbl.confirmPlan"/>' , data : this.comCode.codeMap.VERSION_TYPE_CD , exData:[""], type : "S"},
				{target : 'divRoute', id : 'route', title : '<spring:message code="lbl.routing"/>', data : this.comCode.codeMapEx.ROUTING, exData:[""]},
				{target : 'divItemGroup', id : 'itemGroup', title : '<spring:message code="lbl.itemGroup"/>', data : this.comCode.codeMapEx.ITEM_GROUP  , exData:[""]},
				{target : 'divRepCustGroup', id : 'reptCustGroup', title : '<spring:message code="lbl.reptCustGroup"/>', data : this.comCode.codeMapEx.REP_CUST_GROUP, exData:["*"] },
				{target : 'divApsDemandType', id : 'apsDemandType', title : '<spring:message code="lbl.apsDemandType"/>', data : this.comCode.codeMap.APS_DEMAND_TYPE, exData:[""]},
				{target : 'divInputConfirmYn', id : 'inputConfirmYn', title : '<spring:message code="lbl.inputConfirmYn"/>', data : this.comCode.codeMap.FLAG_YN, exData:["*"], type : "S"},
			]);
		},
		
		grid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid : function() {
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				this.gridInstance.custNextBucketFalg = true;
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				
				this.setOptions();
			},
			
			setOptions : function() {
				this.grdMain.setOptions({
					//stateBar: { visible : true }
				});

				this.dataProvider.setOptions({
					softDeleting : true
				});
				
				this.grdMain.addCellStyles([{
					id         : "editStyle",
					editable   : true,
					background : gv_editColor
				}]);
			}
		},
		
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
					
					if(id == "divPlanId"){
						EXCEL_SEARCH_DATA += $("#planId option:selected").text();
					}else if(id == "divProdPart"){
						
						$.each($("#prodPart option:selected"), function(i2, val2){
							
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
					}else if(id == "divReptCust"){
						EXCEL_SEARCH_DATA += $("#reptCust").val();
					}else if(id == "divApsDemandType"){
						$.each($("#apsDemandType option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divDemandId"){
						EXCEL_SEARCH_DATA += $("#demandId").val();
					}else if(id == "divInputConfirmYn"){
						EXCEL_SEARCH_DATA += $("#inputConfirmYn option:selected").text();
					}else if(id == "divItem"){
						EXCEL_SEARCH_DATA += $("#item_nm").val();
					}
				}
			});
			
			EXCEL_SEARCH_DATA += "\n" + '<spring:message code="lbl.period"/>' + " : ";
			EXCEL_SEARCH_DATA += $("#fromCal").val() + "(" + $("#fromPWeek").val() + ") ~ ";
			EXCEL_SEARCH_DATA += $("#toCal").val() + "(" + $("#toPWeek").val() + ")";
		},
		
		search : function () {
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList",_siq : inputPlanAnal._siq }];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						inputPlanAnal.grid.dataProvider.clearRows(); //데이터 초기화
						
						//그리드 데이터 생성
						inputPlanAnal.grid.grdMain.cancel();
						
						inputPlanAnal.grid.dataProvider.setRows(data.resList);
						inputPlanAnal.grid.dataProvider.clearSavePoints();
						inputPlanAnal.grid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(inputPlanAnal.grid.dataProvider.getRowCount());
						gfn_setRowTotalFixed(inputPlanAnal.grid.grdMain);
					}
				}
			}
			gfn_service(aOption, "obj");
		}
	};
	
	function fn_setNextFieldsBuket() {
		var fields = [
			{fieldName: "FIN_QTY_W1", dataType : "number"},
			{fieldName: "PRE_QTY_W1", dataType : "number"},
			{fieldName: "PRE_QTY_W2", dataType : "number"},
			{fieldName: "PRE_QTY_W3", dataType : "number"},
			{fieldName: "PRE_QTY_W4", dataType : "number"},
			{fieldName: "PRE_QTY_W5", dataType : "number"},
			{fieldName: "PRE_QTY_W6", dataType : "number"},
        ];
    	
    	return fields;
	}
	
	function fn_setNextColumnsBuket() {
		var columns = [	
			{
                type: "group",
                name: '<spring:message code="lbl.finalVersion" javaScriptEscape="true" />',
                header: {text : '<spring:message code="lbl.finalVersion"/>' },
                fieldName: "FINAL_VERSION",
                width: 120,
                columns : [
                	{
						name : "FIN_QTY_W1", fieldName: "FIN_QTY_W1", editable: false, header: {text: '<spring:message code="lbl.finalQtyW1" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 120
					}
              	]
            }, {
                type: "group",
                name: '<spring:message code="lbl.preVersion" javaScriptEscape="true" />',
                header: {text : '<spring:message code="lbl.preVersion"/>' + gv_expand },
                fieldName: "PRE_VERSION",
                width: 480,
                columns : [
                	{
						name : "PRE_QTY_W1", fieldName: "PRE_QTY_W1", editable: false, header: {text: '<spring:message code="lbl.preQtyW1" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					},
					{
						name : "PRE_QTY_W2", fieldName: "PRE_QTY_W2", editable: false, header: {text: '<spring:message code="lbl.preQtyW2" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					},
					{
						name : "PRE_QTY_W3", fieldName: "PRE_QTY_W3", editable: false, header: {text: '<spring:message code="lbl.preQtyW3" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					},
					{
						name : "PRE_QTY_W4", fieldName: "PRE_QTY_W4", editable: false, header: {text: '<spring:message code="lbl.preQtyW4" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					},
					{
						name : "PRE_QTY_W5", fieldName: "PRE_QTY_W5", editable: false, header: {text: '<spring:message code="lbl.preQtyW5" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					},
					{
						name : "PRE_QTY_W6", fieldName: "PRE_QTY_W6", editable: false, header: {text: '<spring:message code="lbl.preQtyW6" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						width: 80
					}
              	]
            }
		];
		
		return columns;
	}
	
	//조회
	var fn_apply = function (sqlFlag) {
		gfn_getMenuInit();
		if(!sqlFlag){
			inputPlanAnal.grid.gridInstance.setDraw();
			fn_setNumberFields();
		}
		//조회조건 설정
    	FORM_SEARCH            = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
    	FORM_SEARCH.dimList    = DIMENSION.user;
   		FORM_SEARCH.meaList	   = MEASURE.user;
   		
    	inputPlanAnal.search();
    	inputPlanAnal.excelSubSearch();
	}
	
	function fn_getPlanId(pOption) {
		
		try {
			
			if ($("#planId").length == 0) {
				return;
			}
			
			var params = $.extend({
				_mtd     : "getList",
				tranData : [{outDs:"rtnList",_siq:"common.planId"}]
			}, pOption);
			
			gfn_service({
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : params,
				async   : false,
				success : function(data) {
					
					gfn_setMsCombo("planId",data.rtnList,[""]);
					
					$("#planId").on("change", function(e) {
						var fDs = gfn_getFindDataDsInDs(data.rtnList, {CODE_CD : {VALUE : $(this).val(), CONDI : "="}});
						var nowDate = fDs[0].SW_START_DATE;
						SW_END_DATE = weekdatecal(fDs[0].SW_START_DATE);
					    DATEPICKET(null, nowDate, SW_END_DATE);
						
						var sdt = gfn_getStringToDate(fDs[0].SW_START_DATE);
						var edt = gfn_getStringToDate(fDs[0].SW_END_DATE);
						
						$("#fromCal").datepicker("option", "minDate", sdt);
						$("#fromCal").datepicker("option", "maxDate", edt);
						$("#toCal").datepicker("option", "maxDate", edt);
					});
					
					$("#planId").trigger("change");
				}
			},"obj");
			
		} catch(e) {console.log(e);}
	}
	
	//2주 뒤 날짜 구함
    function weekdatecal(dt){
    	
    	yyyy = dt.substr(0, 4);
    	mm = dt.substr(4, 2);
    	dd = dt.substr(6, 2);
    	
    	var dt_stamp = new Date(yyyy+"-"+mm+"-"+dd).getTime();
    	
    	var days = ((7 * 2) -1); //2주후
		    toDt = new Date(dt_stamp+(days*24*60*60*1000));
		var rdt = toDt.getFullYear() + '' + (toDt.getMonth() + 1  < 10 ? '0' + (toDt.getMonth() + 1 ) : toDt.getMonth() + 1 ) + (toDt.getDate() < 10 ? '0' + toDt.getDate() : toDt.getDate());
	    
    	return rdt
    }
	
	function fn_setNumberFields(){
		
		var fileds = inputPlanAnal.grid.dataProvider.getFields();
		var filedsLen = fileds.length;
		
		for (var i = 0; i < filedsLen; i++) {
			
			var fieldName = fileds[i].fieldName;
			
			if(fieldName == "SALES_PRICE_KRW_NM"){
				fileds[i].dataType = "number";
				inputPlanAnal.grid.grdMain.setColumnProperty(fieldName, "styles", {"numberFormat" : "#,##0"});
			}
		}
		
		inputPlanAnal.grid.dataProvider.setFields(fileds);
	}
	
	// onload 
	$(document).ready(function() {
		inputPlanAnal.init();
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
					<div class="view_combo" id="divPlanId">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.planId"/></div>
							<div class="iptdv borNone">
								<select id="planId" name="planId" class="iptcombo"></select>
							</div>
						</div>
					</div>
					<input type='hidden' id='cutOffFlag' name='cutOffFlag'>
					<div class="view_combo" id="divProdPart"></div>
					<div class="view_combo" id="divItemType"></div>
					<div class="view_combo" id="divRoute"></div>
					<div class="view_combo" id="divItemGroup"></div>
					<div class="view_combo" id="divRepCustGroup"></div>
					<div class="view_combo" id="divReptCust">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.reptCust"/></div>
							<input type="text" id="reptCust" name="reptCust" class="ipt">
						</div>
					</div>
                    <div class="view_combo" id="divApsDemandType"></div>
					<div class="view_combo" id="divDemandId">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.demandId"/></div>
							<input type="text" id="demandId" name="demandId" class="ipt"/>
						</div>
					</div>
					<div class="view_combo" id="divInputConfirmYn"></div>
					<div class="view_combo" id="divItem"></div>
					<jsp:include page="/WEB-INF/view/common/filterViewHorizon.jsp" flush="false" />
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
		</div>
    </div>
</body>
</html>