<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	<!-- 제공현황 -->
	<script type="text/javascript">

	var enterSearchFlag = "Y";
	var supplyPresent = {

		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.supplyPresentGrid.initGrid();
		},
			
		_siq    : "supply.product.supplyPresentList",
		
		initFilter : function() {
			
			var itemTypeEvent = {
				childId   : ["upItemGroup","route"],  
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
				{target : 'divProcurType',   id : 'procurType',    title : '<spring:message code="lbl.procure"/>',        data : this.comCode.codeMap.PROCUR_TYPE, exData:[""]},
				{target : 'divWipCd',   id : 'wipCd',    title : '<spring:message code="lbl.wipt"/>',        data : this.comCode.codeMap.WIP_CD, exData:["*"], type : "S"},
				{target : 'divUpItemGroup',  id : 'upItemGroup',   title : '<spring:message code="lbl.upperItemGroup"/>', data : this.comCode.codeMapEx.UPPER_ITEM_GROUP, exData:["*"], event: upperItemEvent },
				{target : 'divItemGroup', id : 'itemGroup', title : '<spring:message code="lbl.itemGroup"/>', data : this.comCode.codeMapEx.ITEM_GROUP, exData:["*"]},
				{target : 'divRoute', id : 'route', title : '<spring:message code="lbl.routing"/>', data : this.comCode.codeMapEx.ROUTING, exData:["*"]},
				{target : 'divCustGroup', id : 'custGroup', title : '<spring:message code="lbl.custGroup"/>', data : this.comCode.codeMapEx.CUST_GROUP, exData:["*"]},
			]);
			
			$(':radio[name=rdoAqType]:input[value="QTY"]').attr("checked", true);
			
			// 달력
			DATEPICKET(null, -5, 0);
			
			//$('#fromCal').datepicker("option", "minDate", new Date().getWeekDay(-53));
			$('#toCal').datepicker("option", "minDate", 0);
			$('#toCal').datepicker("option", "maxDate", 0);
		},
		
		/*
		* common Code 
		*/
		comCode : {
			codeMap : null,
			codeMapEx : null,
			
			initCode : function () {
				var grpCd    = 'SALE_QA_TYPE,PROCUR_TYPE,WIP_CD';
				this.codeMap = gfn_getComCode(grpCd, 'Y'); //공통코드 조회
				this.codeMapEx = gfn_getComCodeEx(["REP_CUST_GROUP", "CUST_GROUP", "UPPER_ITEM_GROUP", "ITEM_GROUP", "ROUTING"], null, {itemType : "10"});
			}
		},
	
		/* 
		* grid  선언
		*/
		supplyPresentGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				this.gridInstance.custNextBucketFalg = true;
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				
				gfn_setMonthSum(supplyPresent.supplyPresentGrid.gridInstance, false, false, true);
			}
		},
	
		/*
		* event 정의
		*/
		events : function () {
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});

			$("#sQty, #sAmt").on("click", function(e) {
				fn_gridCtrl(this, ["ONE_WIP_QTY", "EIGHT_WIP_QTY", "ONE_WIP_AMT_KRW", "EIGHT_WIP_AMT_KRW"]);
			});
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
					}else if(id == "divWipCd"){
						EXCEL_SEARCH_DATA += $("#wipCd option:selected").text();
					}else if(id == "divQtyAmtGubun"){
						
						var cnt = 0;
						if($("#sQty").prop("checked")){
							cnt++;
							EXCEL_SEARCH_DATA += '<spring:message code="lbl.qty"/>';
						}
						if($("#sAmt").prop("checked")){
							if(cnt == 1){
								EXCEL_SEARCH_DATA += ", ";
							}
							EXCEL_SEARCH_DATA += '<spring:message code="lbl.amt"/>';
						}
					}
				}
			});
			
			EXCEL_SEARCH_DATA += "\n" + '<spring:message code="lbl.period"/>' + " : ";
			EXCEL_SEARCH_DATA += $("#fromCal").val() + "(" + $("#fromWeek").val() + ") ~ ";
			EXCEL_SEARCH_DATA += $("#toCal").val() + "(" + $("#toWeek").val() + ")";
			
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
						supplyPresent.supplyPresentGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						supplyPresent.supplyPresentGrid.grdMain.cancel();
						
						supplyPresent.supplyPresentGrid.dataProvider.setRows(data.resList);
						supplyPresent.supplyPresentGrid.dataProvider.clearSavePoints();
						supplyPresent.supplyPresentGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_actionMonthSum(supplyPresent.supplyPresentGrid.gridInstance);
						gfn_setRowTotalFixed(supplyPresent.supplyPresentGrid.grdMain);
						
						//grid set
						$.each($("#sQty,#sAmt"), function(n,v) {
							if ($(v).is(":checked")) return true;
							fn_gridCtrl(v,["ONE_WIP_QTY","EIGHT_WIP_QTY"]);
						});
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		getBucket : function (sqlFlag) {
			var ajaxMap = {
				fromDate : gfn_replaceAll($("#fromCal").val(),"-",""),
				toDate   : gfn_replaceAll($("#toCal").val(),"-",""),
	       		week     : {isDown: "Y", isUp:"N", upCal:"M", isMt:"N", isExp:"N", expCnt:999},
	       		sqlId    : ["bucketFullWeek"]
			}
			gfn_getBucket(ajaxMap);
			
			var subBucket = new Array();
			subBucket = [
				{CD : "QTY", NM : '<spring:message code="lbl.qty"/>'},
				{CD : "AMT", NM : '<spring:message code="lbl.amt"/>'},
			];
			gfn_setCustBucket(subBucket);
			
			if (!sqlFlag) {
	            
	            for (var i in DIMENSION.user) {
	                if (DIMENSION.user[i].DIM_CD.indexOf("SALES_PRICE_KRW") > -1) {
	                   DIMENSION.user[i].numberFormat = "#,##0";
	                }
	             }
	             
	            supplyPresent.supplyPresentGrid.gridInstance.setDraw();
	            
	            var fileds = supplyPresent.supplyPresentGrid.dataProvider.getFields();
	             
	            for (var i in fileds) {
	                if (fileds[i].fieldName.indexOf("SALES_PRICE_KRW") > -1) {
	                   fileds[i].dataType = "number";
	                }
	            }
	            supplyPresent.supplyPresentGrid.dataProvider.setFields(fileds);
			}
		}
	};
	
	//조회
	var fn_apply = function (sqlFlag) {

		gfn_getMenuInit();
		
		supplyPresent.getBucket(sqlFlag); 
    	
    	FORM_SEARCH = $("#searchForm").serializeObject(); 
    	FORM_SEARCH.sql        = sqlFlag;
   		FORM_SEARCH.dimList    = DIMENSION.user;
   		FORM_SEARCH.bucketList = BUCKET.query;
   		
		supplyPresent.search();
		supplyPresent.excelSubSearch();
	}

	// onload 
	$(document).ready(function() {
		supplyPresent.init();
	});
	
	function fn_setNextFieldsBuket() {
    	//필드 배열 객체를  생성합니다.
        var fields = [
            {fieldName: "ONE_WIP_QTY", dataType : "number"},
            {fieldName: "EIGHT_WIP_QTY", dataType : "number"},
            {fieldName: "ONE_WIP_AMT_KRW", dataType : "number"},
            {fieldName: "EIGHT_WIP_AMT_KRW", dataType : "number"}
        ];
    	
    	return fields;
    }
    
    function fn_setNextColumnsBuket() {
    	//필드와 연결된 컬럼 배열 객체를 생성합니다.
        var columns = [
        	{
                type: "group",
                name: '<spring:message code="lbl.increaseDecrease" javaScriptEscape="true" />',
                header: {text: '<spring:message code="lbl.increaseDecrease" javaScriptEscape="true" />'},
                fieldName: "WEEK_GROUP",
                width: 400,
                columns : [
                	{
						name : "ONE_WIP_QTY", fieldName: "ONE_WIP_QTY",  editable: false, header: {text: '<spring:message code="lbl.lastWeekCompare" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						width: 100
					}, {
						name : "EIGHT_WIP_QTY", fieldName: "EIGHT_WIP_QTY",  editable: false, header: {text: '<spring:message code="lbl.8wkMoveAvg" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						width: 100
					}, {
						name : "ONE_WIP_AMT_KRW", fieldName: "ONE_WIP_AMT_KRW",  editable: false, header: {text: '<spring:message code="lbl.lastWeekCompareAmt" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						width: 100
					}, {
						name : "EIGHT_WIP_AMT_KRW", fieldName: "EIGHT_WIP_AMT_KRW",  editable: false, header: {text: '<spring:message code="lbl.8wkAmtAvg" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						width: 100
					}
                ]
            }
        ];
    	
    	return columns;
    }
    
    function fn_save() {
    	var grdData = gfn_getGrdSavedataAll(grdMain);
    }
    
    //그리드 컨트롤
    function fn_gridCtrl(obj,arrExt) {
    	var tObjColNm = $(obj).attr("val");
		var grid = supplyPresent.supplyPresentGrid.grdMain;
		var columnNames = grid.getColumnNames(true);
		var visi = $(obj).is(":checked");
		columnNames = $.grep(columnNames, function(v,n) {
			return v.indexOf(tObjColNm) > -1 && $.inArray(v,arrExt) == -1;
		});
		gfn_gridCtrl(grid,columnNames,visi);
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
				<%@ include file="/WEB-INF/view/common/filterMonthSum.jsp"%>
				<div class="tabMargin"></div>
				<div class="scroll">
					<div class="view_combo" id="divItem"></div>
					<div class="view_combo" id="divProcurType"></div>
					<div class="view_combo" id="divUpItemGroup"></div>
					<div class="view_combo" id="divItemGroup"></div>
					<div class="view_combo" id="divRoute"></div>
					<div class="view_combo" id="divCustGroup"></div>
					<div class="view_combo" id="divWipCd"></div>
					<div class="view_combo" id="divQtyAmtGubun">
						<strong class="filter_tit"><spring:message code="lbl.qtyAmtGubun"/></strong>
						<ul class="rdofl">
							<li><input type="checkbox" id="sQty" name="sQty" val="_QTY" checked> <label for="sQty"><spring:message code="lbl.qty"/></label></li>
							<li><input type="checkbox" id="sAmt" name="sAmt" val="_AMT" checked> <label for="sAmt"><spring:message code="lbl.amt"/></label></li>
						</ul>
					</div>
					<jsp:include page="/WEB-INF/view/common/filterViewHorizon.jsp" flush="false">
						<jsp:param name="radioYn" value="N"/>
						<jsp:param name="wType" value="SW"/>
					</jsp:include>
					<!-- check box case -->
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
