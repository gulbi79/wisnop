<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	<!-- 생산 계획 대비 실적 -->
	<script type="text/javascript">
    
	var enterSearchFlag = "Y";
	var weekProdPrfm = {

		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.weekProdPrfmGrid.initGrid();
		},
			
		_siq    : "supply.product.weekProdPrfmList",
		
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
				{target : 'divProcurType'  , id : 'procurType',    title : '<spring:message code="lbl.procure"/>',        data : this.comCode.codeMap.PROCUR_TYPE, exData:[""]},
				{target : 'divUpItemGroup' , id : 'upItemGroup',   title : '<spring:message code="lbl.upperItemGroup"/>', data : this.comCode.codeMapEx.UPPER_ITEM_GROUP, exData:["*"], event: upperItemEvent},
				{target : 'divItemGroup', id : 'itemGroup', title : '<spring:message code="lbl.itemGroup"/>', data : this.comCode.codeMapEx.ITEM_GROUP, exData:["*"]},
				{target : 'divRoute', id : 'route', title : '<spring:message code="lbl.routing"/>', data : this.comCode.codeMapEx.ROUTING, exData:["*"]},
				{target : 'divRepCustGroup', id : 'reptCustGroup', title : '<spring:message code="lbl.reptCustGroup"/>', data : this.comCode.codeMapEx.REP_CUST_GROUP, exData:["*"]},
				{target : 'divCustGroup', id : 'custGroup', title : '<spring:message code="lbl.custGroup"/>', data : this.comCode.codeMapEx.CUST_GROUP, exData:["*"]},
				{target : 'divAmtQty', id : 'rdoAqType', title : '<spring:message code="lbl.quantityAmountPart"/>', data : this.comCode.codeMap.SALE_QA_TYPE, exData:[""], type : "R"},
			]);
			
			$(':radio[name=rdoAqType]:input[value="QTY"]').attr("checked", true);
			
			// 달력
			DATEPICKET(null, -5, 0);
			
			//$('#fromCal').datepicker("option", "minDate", new Date().getWeekDay(-53));
			$('#toCal').datepicker("option", "maxDate", new Date().getWeekDay(0, false));
		},
		
		/*
		* common Code 
		*/
		comCode : {
			codeMap : null,
			codeMapEx : null,
			
			initCode : function () {
				var grpCd    = 'SALE_QA_TYPE,PROCUR_TYPE';
				this.codeMap = gfn_getComCode(grpCd, 'Y'); //공통코드 조회
				this.codeMapEx = gfn_getComCodeEx(["REP_CUST_GROUP", "CUST_GROUP", "ITEM_GROUP", "ROUTING", "UPPER_ITEM_GROUP"], null, {itemType : "10,50"});
			}
		},
	
		/* 
		* grid  선언
		*/
		weekProdPrfmGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				$("#btnMonthOut").show();
				$("#btnSum").hide();
				gfn_setMonthSum(weekProdPrfm.weekProdPrfmGrid.gridInstance, true, false, true, false,true);
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
					}else if(id == "divAmtQty"){
						
						var qtyAmt = $('input[name="rdoAqType"]:checked').val();
						
						if(qtyAmt == "QTY"){
							EXCEL_SEARCH_DATA += '<spring:message code="lbl.qty"/>';
						}else if(qtyAmt == "AMT"){
							EXCEL_SEARCH_DATA += '<spring:message code="lbl.amt"/>';
						}
					}
				}
			});
			
			var weekType = $('input[name="vhWeekType"]:checked').val();
			
			if(weekType == "SW"){
				EXCEL_SEARCH_DATA += "\n" + '<spring:message code="lbl.stdWeek" /> ' +'<spring:message code="lbl.period"/>' + " : ";
				EXCEL_SEARCH_DATA += $("#fromCal").val() + "(" + $("#fromWeek").val() + ") ~ ";
				EXCEL_SEARCH_DATA += $("#toCal").val() + "(" + $("#toWeek").val() + ")";
			}else if(weekType == "PW"){
				EXCEL_SEARCH_DATA += "\n" + '<spring:message code="lbl.partialWeek" /> ' + '<spring:message code="lbl.period"/>' + " : ";
				EXCEL_SEARCH_DATA += $("#fromCal").val() + "(" + $("#fromPWeek").val() + ") ~ ";
				EXCEL_SEARCH_DATA += $("#toCal").val() + "(" + $("#toPWeek").val() + ")";	
			}
			
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
						weekProdPrfm.weekProdPrfmGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						weekProdPrfm.weekProdPrfmGrid.grdMain.cancel();
						
						weekProdPrfm.weekProdPrfmGrid.dataProvider.setRows(data.resList);
						weekProdPrfm.weekProdPrfmGrid.dataProvider.clearSavePoints();
						weekProdPrfm.weekProdPrfmGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_actionMonthSum(weekProdPrfm.weekProdPrfmGrid.gridInstance);
						gfn_setRowTotalFixed(weekProdPrfm.weekProdPrfmGrid.grdMain);
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		getBucket : function (sqlFlag) {
			
			var ajaxMap = {
				fromDate : gfn_replaceAll($("#fromCal").val(),"-",""),
				toDate   : gfn_replaceAll($("#toCal").val(),"-",""),
				vhWeekType : $(':radio[name=vhWeekType]:checked').val(),
				month     : {isDown: "Y", isUp:"N", upCal:"Q" , isMt:"N", isExp:"Y", expCnt:999},
				sqlId    : ["bucketMonth","supply.product.bucketWeekProd"]
			}
			gfn_getBucket(ajaxMap);
		
			var subBucket = new Array();
			
			subBucket = [
				{CD : "PLAN", NM : '<spring:message code="lbl.prodPlan"/>'},
				{CD : "RES", NM : '<spring:message code="lbl.prodPerformance"/>'},
				{CD : "RATE", NM : '<spring:message code="lbl.hittingRation"/>'} 
			];
			gfn_setCustBucket(subBucket);
			
			if (!sqlFlag) {
				for (var i in DIMENSION.user) {
                    if (DIMENSION.user[i].DIM_CD.indexOf("SALES_PRICE_KRW") > -1) {
                        DIMENSION.user[i].numberFormat = "#,##0";
                    }
                }
				weekProdPrfm.weekProdPrfmGrid.gridInstance.setDraw();
				

				$.grep(BUCKET.query, function(v, n) {
					
					var rootVal = v.ROOT_CD;
					var val = v.CD;
					
					if(rootVal.indexOf("WM") > -1){
						
						var setHeader = weekProdPrfm.weekProdPrfmGrid.grdMain.getColumnProperty(rootVal, "header");
						setHeader.styles = {background: gv_headerColor};
						weekProdPrfm.weekProdPrfmGrid.grdMain.setColumnProperty(rootVal, "header", setHeader);
					}
					
					if(val.indexOf("WM") > -1){
						
						var setHeader = weekProdPrfm.weekProdPrfmGrid.grdMain.getColumnProperty(val, "header");
						setHeader.styles = {background: gv_headerColor};
						weekProdPrfm.weekProdPrfmGrid.grdMain.setColumnProperty(val, "header", setHeader);
						weekProdPrfm.weekProdPrfmGrid.grdMain.setColumnProperty(val, "styles", {"background" : gv_headerColor});
					}
					
				});
				
				
				var fileds = weekProdPrfm.weekProdPrfmGrid.dataProvider.getFields();
				var filedsLen = fileds.length;
				
				for (var i = 0; i < filedsLen; i++) {
                    var fieldName = fileds[i].fieldName;
                    if (fieldName == 'SALES_PRICE_KRW_NM'){
                    	fileds[i].dataType = "number";
                        weekProdPrfm.weekProdPrfmGrid.grdMain.setColumnProperty(fieldName, "styles", {"numberFormat" : "#,##0"});
                    }
				}
				
				weekProdPrfm.weekProdPrfmGrid.dataProvider.setFields(fileds);
				
			}// end of if(!sqlFlag)
		}
	};

	//조회
	var fn_apply = function (sqlFlag) {

		gfn_getMenuInit();
		
		weekProdPrfm.getBucket(sqlFlag); 
    	
    	FORM_SEARCH = $("#searchForm").serializeObject(); 
    	FORM_SEARCH.sql        = sqlFlag;
   		FORM_SEARCH.hrcyFlag   = true;
   		FORM_SEARCH.dimList    = DIMENSION.user;
   		FORM_SEARCH.meaList    = MEASURE.user;
   		FORM_SEARCH.bucketList = BUCKET.query;
   		
		weekProdPrfm.search();
		weekProdPrfm.excelSubSearch();
	}

	// onload 
	$(document).ready(function() {
		weekProdPrfm.init();
	});
	
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
					<div class="view_combo" id="divAmtQty"></div>
					<jsp:include page="/WEB-INF/view/common/filterViewHorizon.jsp" flush="false">
						<jsp:param name="radioYn" value="Y"/>
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
