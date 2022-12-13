<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	<!-- Aging 재고 Trend -->
	<script type="text/javascript">

	var enterSearchFlag = "Y";
	var agingInventoryTrend = {

		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.agingInventoryTrendGrid.initGrid();
		},
			
		_siq    : "snop.bizKpi.agingInventoryTrendList",
		
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
				//{ target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>' }
			]);
			
			// 콤보박스
			gfn_setMsComboAll([
				{target : 'divUpItemGroup',  id : 'upItemGroup',   title : '<spring:message code="lbl.upperItemGroup"/>', data : this.comCode.codeMapEx.UPPER_ITEM_GROUP, exData:["*"], event: upperItemEvent },
				{target : 'divItemGroup', id : 'itemGroup', title : '<spring:message code="lbl.itemGroup"/>', data : this.comCode.codeMapEx.ITEM_GROUP, exData:["*"]},
				{target : 'divItemType', id : 'itemType', title : '<spring:message code="lbl.itemType"/>', data : this.comCode.codeMap.ITEM_TYPE, exData:["*"], event: itemTypeEvent},
				{target : 'divUnitPrice', id : 'unitPrice', title : '<spring:message code="lbl.unitPrice"/>', data : this.comCode.codeMap.PRICE_CD, exData:[""], type : "R"},
			]);
			
			$(':radio[name=unitPrice]:input[value="COST"]').attr("checked", true);
			
			MONTHPICKER(null, -12, 0);
			
			$('#fromMon').monthpicker("option", "minDate", -60);
			$('#toMon').monthpicker("option", "maxDate", 0);
		},
		
		/*
		* common Code 
		*/
		comCode : {
			codeMap : null,
			codeReptMap : null,
			
			initCode : function () {
				var grpCd = 'ITEM_TYPE,PRICE_CD';
				this.codeMap = gfn_getComCode(grpCd, 'N'); //공통코드 조회
				this.codeMapEx = gfn_getComCodeEx(["ITEM_GROUP", "UPPER_ITEM_GROUP"], null, {itemType : "10,20,30,50" });
				
				this.codeMap.ITEM_TYPE = $.grep(this.codeMap.ITEM_TYPE, function(v,n) {
					return v.CODE_CD != '25' && v.CODE_CD != '35'; 
				});
				
			}
		},
	
		/* 
		* grid  선언
		*/
		agingInventoryTrendGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				
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
					if(id == "divItemType"){
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
			
			EXCEL_SEARCH_DATA += "\n" + '<spring:message code="lbl.period"/>' + " : ";
			EXCEL_SEARCH_DATA += $("#fromMon").val() + " ~ " + $("#toMon").val();
			
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
						agingInventoryTrend.agingInventoryTrendGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						agingInventoryTrend.agingInventoryTrendGrid.grdMain.cancel();
						
						agingInventoryTrend.agingInventoryTrendGrid.dataProvider.setRows(data.resList);
						agingInventoryTrend.agingInventoryTrendGrid.dataProvider.clearSavePoints();
						agingInventoryTrend.agingInventoryTrendGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(agingInventoryTrend.agingInventoryTrendGrid.dataProvider.getRowCount());
						gfn_setRowTotalFixed(agingInventoryTrend.agingInventoryTrendGrid.grdMain);
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		getBucket : function (sqlFlag) {
			
			var ajaxMap = {
				fromDate : gfn_replaceAll($("#fromMon").val(), "-", "") + "01",
				toDate   : gfn_replaceAll($("#toMon").val(), "-", "") + "31",
				month    : {isDown: "Y", isUp:"N", upCal:"Q", isMt:"N", isExp:"N", expCnt:1},
				sqlId    : ["bucketMonth"]
			}
			
			gfn_getBucket(ajaxMap);
			
			var subBucket = [
				{CD : "AMT", NM : '<spring:message code="lbl.amt"/>'},
				{CD : "RATE", NM : '<spring:message code="lbl.rate"/>'},
			];
			gfn_setCustBucket(subBucket);
			
			if (!sqlFlag) {
				agingInventoryTrend.agingInventoryTrendGrid.gridInstance.setDraw();
			}
		}
	};
	

	//조회
	var fn_apply = function (sqlFlag) {
		
		// 디멘젼, 메져
		gfn_getMenuInit();
		
		agingInventoryTrend.getBucket(sqlFlag); //2. 버켓정보 조회
    	
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
   		FORM_SEARCH.dimList    = DIMENSION.user;
   		FORM_SEARCH.meaList    = MEASURE.user;
   		FORM_SEARCH.bucketList = BUCKET.query;
   		
		agingInventoryTrend.search();
		agingInventoryTrend.excelSubSearch();
	}

	// onload 
	$(document).ready(function() {
		agingInventoryTrend.init();
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
					<div class="view_combo" id="divItemType"></div>
					<div class="view_combo" id="divUpItemGroup"></div>
					<div class="view_combo" id="divItemGroup"></div>
					<div class="view_combo" id="divUnitPrice"></div>
					
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
