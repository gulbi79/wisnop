<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	<!-- 재고현황종합 -->
	<script type="text/javascript">
	gv_cellDefaultStyles = [];
	var enterSearchFlag = "Y";
	var inventorySynthesis = {

		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.inventorySynthesisGrid.initGrid();
		},
			
		_siq    : "snop.bizKpi.inventorySynthesisList",
		
		initFilter : function() {
			
			var itemTypeEvent = {
				childId   : ["upItemGroup"],  
				childData : [this.comCode.codeMapEx.UPPER_ITEM_GROUP, this.comCode.codeMapEx.ROUTING],
				callback  : function() {
					gfn_eventChkAllMsCombo("upItemGroup"); //하위오브젝트중 전체체크할 오브젝트 아이디를 파라미터로 던진다.
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
				{target : 'divProcurType',   id : 'procurType',    title : '<spring:message code="lbl.procure"/>',        data : this.comCode.codeMap.PROCUR_TYPE, exData:[""]},
				{target : 'divUpItemGroup',  id : 'upItemGroup',   title : '<spring:message code="lbl.upperItemGroup"/>', data : this.comCode.codeMapEx.UPPER_ITEM_GROUP, exData:["*"], event: upperItemEvent, option: {allFlag:"Y"}},
				{target : 'divItemGroup', id : 'itemGroup', title : '<spring:message code="lbl.itemGroup"/>', data : this.comCode.codeMapEx.ITEM_GROUP, exData:["*"]},
				{target : 'divItemType', id : 'itemType', title : '<spring:message code="lbl.itemType"/>', data : this.comCode.codeMap.ITEM_TYPE, exData:[""], event : itemTypeEvent, option: {allFlag:"Y"}},
				{target : 'divBucket', id : 'bucket', title : '<spring:message code="lbl.bucket"/>', data : this.comCode.codeMap.BUCKET_CD, exData:[""], type : "S"},
				{target : 'divComOut', id : 'comOut', title : '<spring:message code="lbl.storage"/>', data : this.comCode.codeMap.COM_OUT_CD, exData:[""]},
				{target : 'divAmtQty', id : 'rdoAqType', title : '<spring:message code="lbl.quantityAmountPart"/>', data : this.comCode.codeMap.SALE_QA_TYPE, exData:[""], type : "R"},
				{target : 'divUnitPrice', id : 'unitPrice', title : '<spring:message code="lbl.unitPrice"/>', data : this.comCode.codeMap.PRICE_CD, exData:[""], type : "R"},
			]);
			
			$(':radio[name=rdoAqType]:input[value="AMT"]').attr("checked", true);
			$(':radio[name=unitPrice]:input[value="COST"]').attr("checked", true);
			
			DATEPICKET(null, -4, 0);
			MONTHPICKER(null, -1, 0);
			
			$('#fromCal').datepicker("option", "minDate", new Date().getWeekDay(-104, false));
			$('#toCal').datepicker("option", "maxDate", new Date().getWeekDay(0, false));
			
			$('#fromMon').monthpicker("option", "minDate", -24);
			$('#toMon').monthpicker("option", "maxDate", 0);
			
			$("#currentDay").val(gfn_replaceAll($("#toCal").val(), "-", ""));
		},
		
		/*
		* common Code 
		*/
		comCode : {
			codeMapEx : null,
			codeMap : null,
			
			initCode  : function () {
				var grpCd = 'SALE_QA_TYPE,ITEM_TYPE,BUCKET_CD,PROCUR_TYPE,COM_OUT_CD,PRICE_CD';
				this.codeMap = gfn_getComCode(grpCd, 'Y'); //공통코드 조회
				this.codeMapEx = gfn_getComCodeEx(["ITEM_GROUP", "UPPER_ITEM_GROUP", "SALES_ORG_LVL5_CD"], null, {itemType : "10,20,30,50" });
				
				this.codeMap.ITEM_TYPE = $.grep(this.codeMap.ITEM_TYPE, function(v,n) {
					return v.CODE_CD != '25' && v.CODE_CD != '35'; 
				});
			}
		},
	
		/* 
		* grid  선언
		*/
		inventorySynthesisGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				this.gridInstance.measureHFlag = true;
				
				gfn_setMonthSum(inventorySynthesis.inventorySynthesisGrid.gridInstance, false, false, true);
			},
		},
	
		/*
		* event 정의
		*/
		events : function () {
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("#bucket").on("change", function(e) {
				calendarChange();
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
					}else if(id == "divBucket"){
						EXCEL_SEARCH_DATA += $("#bucket option:selected").text();
					}else if(id == "divComOut"){
						$.each($("#comOut option:selected"), function(i2, val2){
							
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
					}else if(id == "divUnitPrice"){
						
						var qtyAmt = $('input[name="unitPrice"]:checked').val();
						
						if(qtyAmt == "COST"){
							EXCEL_SEARCH_DATA += '<spring:message code="lbl.costChart"/>';
						}else if(qtyAmt == "SALE_COST"){
							EXCEL_SEARCH_DATA += '<spring:message code="lbl.amtChart"/>';
						}
					}
				}
			});
			
			var bucketVal = $("#bucket").val();
			
			if(bucketVal == "WEEK"){
				EXCEL_SEARCH_DATA += "\n" + '<spring:message code="lbl.period"/>' + " : ";
				EXCEL_SEARCH_DATA += $("#fromCal").val() + "(" + $("#fromWeek").val() + ") ~ ";
				EXCEL_SEARCH_DATA += $("#toCal").val() + "(" + $("#toWeek").val() + ")";
			}else if(bucketVal == "MONTH"){
				EXCEL_SEARCH_DATA += "\n" + '<spring:message code="lbl.period"/>' + " : ";
				EXCEL_SEARCH_DATA += $("#fromMon").val() + " ~ " + $("#toMon").val();
			}
		},
		
		// 조회
		search : function () {
			
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList", _siq : this._siq }];
			
			
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						inventorySynthesis.inventorySynthesisGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						inventorySynthesis.inventorySynthesisGrid.grdMain.cancel();
						
						inventorySynthesis.inventorySynthesisGrid.dataProvider.setRows(data.resList);
						inventorySynthesis.inventorySynthesisGrid.dataProvider.clearSavePoints();
						inventorySynthesis.inventorySynthesisGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_actionMonthSum(inventorySynthesis.inventorySynthesisGrid.gridInstance);
						gfn_setRowTotalFixed(inventorySynthesis.inventorySynthesisGrid.grdMain);
						
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		getBucket : function (sqlFlag) {
			
			var ajaxMap;
			var paramBucket = $("#bucket").val();
			if(paramBucket == "WEEK"){//주단위
				ajaxMap = {
					fromDate : gfn_replaceAll($("#swFromDate").val(), "-", ""),
					toDate   : gfn_replaceAll($("#swToDate").val(), "-", ""),
		       		week     : {isDown: "Y", isUp:"N", upCal:"M", isMt:"N", isExp:"Y", expCnt:999},
					sqlId    : ["bucketFullWeek"]
				}
			}else if(paramBucket == "MONTH"){ //월단위
				ajaxMap = {
					fromDate : gfn_replaceAll($("#fromMon").val(), "-", "") + "01",
					toDate   : gfn_replaceAll($("#toMon").val(), "-", "") + "31",
					month    : {isDown: "Y", isUp:"N", upCal:"Q", isMt:"N", isExp:"Y", expCnt:999},
					sqlId    : ["bucketMonth"]
				}
			}
			
			gfn_getBucket(ajaxMap, true, fn_bucketMeasure);	
			 
			if (!sqlFlag) {
				inventorySynthesis.inventorySynthesisGrid.gridInstance.setDraw();
				
				$.grep(BUCKET.query, function(v, n) {
					var val = v.CD;
					if(val.indexOf("_COMPARE") > -1){
						
						var setHeader = inventorySynthesis.inventorySynthesisGrid.grdMain.getColumnProperty(val, "header");
						setHeader.styles = {background: "#FF6C6C"};
						inventorySynthesis.inventorySynthesisGrid.grdMain.setColumnProperty(val, "header", setHeader);
						 
						var setDynamicStyles = inventorySynthesis.inventorySynthesisGrid.grdMain.getColumnProperty(val, "dynamicStyles"); 
						setDynamicStyles.push({
							criteria: "value > 0",
							styles   : "foreground=#FF0000"
						});
						inventorySynthesis.inventorySynthesisGrid.grdMain.setColumnProperty(val, "dynamicStyles", setDynamicStyles);
					}
				}); 
			}
		}
	};
	

	//조회
	var fn_apply = function (sqlFlag) {
		
		gfn_eventChkAllMsCombo("upItemGroup"); 
		
		setTimeout(function(){
			// 디멘젼, 메져
			gfn_getMenuInit();
			
			inventorySynthesis.getBucket(sqlFlag); //2. 버켓정보 조회
			
			var tComOut = $("#comOut").val();
			var tComOutLen = tComOut.length;
			
			if(tComOutLen == 0){
				$("#companyYn").val("Y");
	   			$("#outsideYn").val("Y");
	   			$("#consignYn").val("Y");
	   			$("#customerYn").val("Y");
	   			
			}else{
				$("#companyYn").val("N");
	   			$("#outsideYn").val("N");
	   			$("#consignYn").val("N");
	   			$("#customerYn").val("N");
				
				if(tComOut.indexOf("COMPANY") > -1){
	   				$("#companyYn").val("Y");
	   			}
				if(tComOut.indexOf("OUTSIDE") > -1){
	   	   			$("#outsideYn").val("Y");	
	   			}	
				if(tComOut.indexOf("CONSIGN") > -1){
	   	   			$("#consignYn").val("Y");	
	   			}	
				if(tComOut.indexOf("CUSTOMER") > -1){
	   	   			$("#customerYn").val("Y");	
	   			}	
			}
			
	    	//조회조건 설정
	    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
	    	FORM_SEARCH.sql        = sqlFlag;
	   		FORM_SEARCH.dimList    = DIMENSION.user;
	   		FORM_SEARCH.meaList    = MEASURE.user;
	   		FORM_SEARCH.bucketList = BUCKET.query;
	   		
	   		var paramBucket = $("#bucket").val();
	   		var monthBuckList = BUCKET.all[0];
	   		var monthBuckListLen = monthBuckList.length;
	   		var monthWeekBuckArry = new Array();
	   		var monthWeekBuckArryCnt = 0;
	   		var temp = "";
	   		
	   		
	   		if(paramBucket == "WEEK"){
	   			for(var i = 0; i < monthBuckListLen; i++){
	   				var cd = monthBuckList[i].CD;
	   				var bucketVal = monthBuckList[i].BUCKET_VAL;
	   				
	   				if(temp.indexOf(cd) == -1){
	   					if(temp == ""){
	   						temp = cd;
	   					}else{
	   						temp += ", " + cd;
	   					}
	   					
	   					var arry = {"MONTH_WEEK_KEY" : cd, "MONTH_WEEK_VAL" : bucketVal};
	   					
	   					monthWeekBuckArry[monthWeekBuckArryCnt] = arry;
	   					monthWeekBuckArryCnt++;
	   				}
	   			}
	   		}else if(paramBucket == "MONTH"){
	   			for(var i = 0; i < monthBuckListLen; i++){
	   				var rootCd = monthBuckList[i].CD;
	   				
	   				var arry = {"MONTH_WEEK_KEY" : rootCd, "MONTH_WEEK_VAL" : gfn_replaceAll(rootCd, "M", "")};
	   				monthWeekBuckArry[i] = arry;
	   			}
	   		}
	   		
	   		FORM_SEARCH.monthWeekBuckArry = monthWeekBuckArry;
			inventorySynthesis.search();
			inventorySynthesis.excelSubSearch();
		}, 500);
	}

	// onload 
	$(document).ready(function() {
		inventorySynthesis.init();
	});
	
	//버켓 변경
	function calendarChange(){
		var paramBucket = $("#bucket").val();
		var invenTrans = "";
		
		if(paramBucket == "WEEK"){ //주단위
			$("#monthCalendar").hide();
			$("#weekCalendar").show();
			
			invenTrans = '<spring:message code="lbl.invenWeek"/>';
			
		}else if(paramBucket == "MONTH"){ //월단위
			$("#monthCalendar").show();
			$("#weekCalendar").hide();
			
			invenTrans = '<spring:message code="lbl.invenMonth"/>';
		}
		
		$("#invenTrans").html(invenTrans);
	}
	
	function fn_bucketMeasure(){
		$.each(BUCKET.all[0], function(n, v) {
    		if (v.TOT_TYPE == "MT") {
    			v.TOT_TYPE = "";
    			v.TYPE = "group";
    		}
    	});
	}
	
	</script>

</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="a" class="split content split-horizontal">
		<form id="searchForm" name="searchForm">
		<input type="hidden" id="currentDay" name="currentDay"/>
		<input type="hidden" id="companyYn" name="companyYn"/>
		<input type="hidden" id="outsideYn" name="outsideYn"/>
		<input type="hidden" id="consignYn" name="consignYn"/>
		<input type="hidden" id="customerYn" name="customerYn"/>
		<div id="filterDv">
			<div class="inner">
				<h3>Filter</h3>
				<%@ include file="/WEB-INF/view/common/filterMonthSum.jsp"%>
				<div class="tabMargin"></div>
				<div class="scroll">
					<div class="view_combo" id="divItem"></div>
					<div class="view_combo" id="divProcurType"></div>
					<div class="view_combo" id="divItemType"></div>
					<div class="view_combo" id="divUpItemGroup"></div>
					<div class="view_combo" id="divItemGroup"></div>
					<div class="view_combo" id="divBucket"></div>
					<div class="view_combo" id="divComOut"></div>
					<div class="view_combo" id="divAmtQty"></div>
					<div class="view_combo" id="divUnitPrice"></div>
					
					<div id="weekCalendar">
					<jsp:include page="/WEB-INF/view/common/filterViewHorizon.jsp" flush="false">
						<jsp:param name="radioYn" value="N"/>
						<jsp:param name="wType" value="SW"/>
					</jsp:include>
					</div>
					<div id="monthCalendar" style="display:none;">
					<jsp:include page="/WEB-INF/view/common/filterViewHorizonMonth.jsp" flush="false" />
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
