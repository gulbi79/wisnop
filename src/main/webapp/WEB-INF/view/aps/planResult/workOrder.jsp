<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	
	<script type="text/javascript">
	var enterSearchFlag = "Y";
	var workOrder = {

		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.workOrderGrid.initGrid();
			this.events();
		},
			
		_siq    : "aps.planResult.workOrderList",
		 
		initFilter : function() {
			
			gfn_keyPopAddEvent([
				{ target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>' },
				{ target : 'divMyItem', id : 'myItem', type : 'COM_ITEM', title : '<spring:message code="lbl.myItem2"/>' }
			]);
			
			gfn_setMsComboAll([
				{ target : 'divPlanId', id : 'planId', title : '<spring:message code="lbl.planId2"/>', data : this.comCode.codeMap.PLAN_ID, exData:[''], type : "S" },  
				{ target : 'divProdPart', id : 'prodPart', title : '<spring:message code="lbl.prodPart2"/>', data : this.comCode.codeMap.PROD_PART, exData:[""]},
				{ target : 'divItemType', id : 'itemType', title : '<spring:message code="lbl.itemType"/>', data : this.comCode.codeMap.ITEM_TYPE, exData:[""]},
				{ target : 'divProcurType', id : 'procurType',    title : '<spring:message code="lbl.procure"/>', data : this.comCode.codeMap.PROCUR_TYPE, exData:[""]},
				{ target : 'divApsDemandType', id : 'apsDemandType', title : '<spring:message code="lbl.apsDemandType"/>', data : this.comCode.codeMap.APS_DEMAND_TYPE, exData:[""]},
				{ target : 'divItemGroup', id : 'itemGroup'  , title : '<spring:message code="lbl.itemGroup"/>', data : this.comCode.codeMapEx.ITEM_GROUP, exData:["*"] },
				{ target : 'divRoute', id : 'route', title : '<spring:message code="lbl.routing"/>', data : this.comCode.codeMapEx.ROUTING, exData:["*"] },
				{ target : 'divReplaceMaterials', id : 'replaceMaterials', title : '<spring:message code="lbl.replaceMaterialsYn"/>', data : this.comCode.codeMap.FLAG_YN, exData:["*"], type : "S"},
				{ target : 'divRepCustGroup', id : 'reptCustGroup', title : '<spring:message code="lbl.reptCustGroup"/>', data : this.comCode.codeMapEx.REP_CUST_GROUP, exData:["*"] },
			]);
			
			$("#planId").change(function() {
				
				var planId = $("#planId").val();
				var prodPart = $("#prodPart").val();
				var planIdArray = workOrder.comCode.codeMap.PLAN_ID;
				
				$.each(planIdArray, function(i, val){
					
					var codeCd = val.CODE_CD;
					
					if(planId == codeCd){
						var startDay = weekdatecal(val.START_DAY, 1);
						var endDay = weekdatecal(val.END_DAY, 30);
						var closeDay = val.CLOSE_DAY;
						
						var tStartDay = startDay.substring(0, 4) + "-" + startDay.substring(4, 6) + "-" + startDay.substring(6, 8);
						var tCloseDay = closeDay.substring(0, 4) + "-" + closeDay.substring(4, 6) + "-" + closeDay.substring(6, 8);
						
						datePickerOption = DATEPICKET(null, startDay, endDay);
						$("#fromCal").datepicker("option", "minDate", tStartDay);
						$("#startDay").val(startDay);
						
						return false;
					}
				});
			});
		},
		
		/*
		* common Code 
		*/
		comCode : {
			codeMapEx : null,			
			codeMap : null,
			
			initCode : function () {
				
				var grpCd = "PROD_PART,ITEM_TYPE,PROCUR_TYPE,APS_DEMAND_TYPE,FLAG_YN";
				this.codeMap = gfn_getComCode(grpCd, 'Y'); 
				this.codeMapEx = gfn_getComCodeEx(["ROUTING", "ITEM_GROUP", "REP_CUST_GROUP"], null, {});
				this.codeMap.PROD_PART[0].CODE_NM = "";
				
				gfn_service({
					async   : false,
					url     : GV_CONTEXT_PATH + "/biz/obj.do",
					data    : {_mtd : "getList", tranData:[
						{outDs : "planList", _siq : "aps.planResult.planIdWorkOrder"},
					]},
					success : function(data) {
						
						workOrder.comCode.codeMap.PLAN_ID = data.planList;
						
						var startDay = weekdatecal(data.planList[0].START_DAY, 1);
						var endDay = weekdatecal(data.planList[0].END_DAY, 30);
						var closeDay = data.planList[0].CLOSE_DAY;
						
						var tStartDay = startDay.substring(0, 4) + "-" + startDay.substring(4, 6) + "-" + startDay.substring(6, 8);
						var tCloseDay = closeDay.substring(0, 4) + "-" + closeDay.substring(4, 6) + "-" + closeDay.substring(6, 8);

						datePickerOption = DATEPICKET(null, startDay, endDay);
						$("#fromCal").datepicker("option", "minDate", tStartDay);
						$("#startDay").val(startDay);
					}
				}, "obj");
			}
		},
	
		/* 
		* grid  선언
		*/
		workOrderGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				this.gridInstance.custBeforeDimensionFalg = true;
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				
				this.grdMain.onDataCellDblClicked = function (grid, index) {
					
		       		var rowId = index.dataRow;
		       		var field = index.fieldName;
		       		var itemIndex = index.itemIndex;
		       		var data = grid.getValue(itemIndex, field);
		       		
		       		var pCompanyCd = grid.getValue(itemIndex, "COMPANY_CD_HD");
		       		var pBuCd = grid.getValue(itemIndex, "BU_CD_HD");
		       		var pPlanId = grid.getValue(itemIndex, "PLAN_ID_HD");
		       		var pProdPart = grid.getValue(itemIndex, "PROD_PART_HD");
		       		var pProdOrderNo = grid.getValue(itemIndex, "PROD_ORDER_NO");
		       		var pItemCd = grid.getValue(itemIndex, "ITEM_CD_HD");
		       		var pItemNm = grid.getValue(itemIndex, "ITEM_NM_HD");
		       		
		       		if(field == "ALT_YN_NM"){
		       			var params = {
	       					rootUrl : "aps/planResult",
	       					url     : "workOrderReplace",
		       				width : 978,
		       				height : 680,
		       				P_COMPANY_CD : pCompanyCd,
		       				P_BU_CD : pBuCd,
		       				P_PLAN_ID : pPlanId,
		       				P_PROD_PART : pProdPart,
		       				P_PROD_ORDER_NO : pProdOrderNo,
		       				P_ITEM_CD : pItemCd,
		       				P_ITEM_NM : pItemNm,
		       				menuCd  : "APS312"
		       			}
		       			gfn_comPopupOpen("WORK_POP", params);
		       		}
		       	};
		       	
				var imgs = new RealGridJS.ImageList("images1", GV_CONTEXT_PATH + "/statics/images/common/");
			    imgs.addUrls([
			        "ico_srh.png"
			    ]);

			    this.grdMain.registerImageList(imgs);
			},
		},
	
		/*
		* event 정의
		*/
		events : function () {
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
	    	
	    	$("#workDaily").on("click", function() {
	    		fn_workDailyPop();
	    	});
			
			$("#workSummary").on("click", function() {
	    		fn_workSummaryPop();
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
					}else if(id == "divItem"){
						EXCEL_SEARCH_DATA += $("#item_nm").val();
					}else if(id == "divDemandId"){
						EXCEL_SEARCH_DATA += $("#demandId").val();
					}else if(id == "divProdOrderNo"){
						EXCEL_SEARCH_DATA += $("#prodOrderNo").val();
					}else if(id == "divReplaceMaterials"){
						EXCEL_SEARCH_DATA += $("#replaceMaterials option:selected").text();
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
			FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq }];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj.do",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						
						workOrder.workOrderGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						workOrder.workOrderGrid.grdMain.cancel();
						
						workOrder.workOrderGrid.dataProvider.setRows(data.resList);
						workOrder.workOrderGrid.dataProvider.clearSavePoints();
						workOrder.workOrderGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(workOrder.workOrderGrid.dataProvider.getRowCount());
					}
				}
			}
			
			gfn_service(aOption, "obj");
		}
	};
	

	//조회
	var fn_apply = function (sqlFlag) {
		
		// 디멘젼, 메져
		gfn_getMenuInit();
		
		DIMENSION.hidden = [];
		DIMENSION.hidden.push({CD : "COMPANY_CD_HD", dataType : "text"});
		DIMENSION.hidden.push({CD : "BU_CD_HD", dataType : "text"});
		DIMENSION.hidden.push({CD : "PLAN_ID_HD", dataType : "text"});
		DIMENSION.hidden.push({CD : "PROD_PART_HD", dataType : "text"});
		DIMENSION.hidden.push({CD : "ITEM_CD_HD", dataType : "text"});
		DIMENSION.hidden.push({CD : "ITEM_NM_HD", dataType : "text"});
		
    	if(!sqlFlag){
    		workOrder.workOrderGrid.gridInstance.setDraw();
		}
    	
		//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
    	FORM_SEARCH.dimList    = DIMENSION.user;
    	FORM_SEARCH.hiddenList = DIMENSION.hidden;
    	
		if (!sqlFlag) {
			
			var fileds = workOrder.workOrderGrid.dataProvider.getFields();
			
			for (var i = 0; i < fileds.length; i++) {
					
				if(fileds[i].fieldName == 'START_DATE_NM' || fileds[i].fieldName == 'END_DATE_NM' || fileds[i].fieldName == 'DUE_DATE_NM' || fileds[i].fieldName == 'RELEASE_DATE2_NM'){
					
					fileds[i].dataType = "datetime";
					fileds[i].datetimeFormat = "yyyyMMdd";
					workOrder.workOrderGrid.grdMain.setColumnProperty(fileds[i].fieldName, "styles", {"datetimeFormat" : "yyyy-MM-dd"});
					
				}else if(fileds[i].fieldName == 'SALES_PRICE_KRW_NM'){
					fileds[i].dataType = "number";
					workOrder.workOrderGrid.grdMain.setColumnProperty(fileds[i].fieldName, "styles", {"numberFormat" : "#,##0"});	
				}
				
				if(fileds[i].fieldName == "PROD_ORDER_QTY2_NM"){
					workOrder.workOrderGrid.grdMain.setColumnProperty(fileds[i].fieldName, "mergeRule", {criteria:"row div 1"})
				}
				
				workOrder.workOrderGrid.dataProvider.setFields(fileds);
			} 
			
			workOrder.workOrderGrid.grdMain.setColumnProperty("ALT_YN_NM", "imageList", "images1");
			workOrder.workOrderGrid.grdMain.setColumnProperty("ALT_YN_NM", "renderer", {type : "icon"}); 
			
			workOrder.workOrderGrid.grdMain.setColumnProperty("ALT_YN_NM", "styles", {
			    textAlignment: "center",
			    iconIndex: 0,
			    iconLocation: "right",
			    iconAlignment: "center",
			    iconOffset: 4,
			    iconPadding: 2
			}); 
			
			var iconStyles = [{
			    criteria: "value='Y'",
			    styles: "iconIndex=0"
			}, {
			    criteria: "value='N'",
			    styles: "iconIndex=0"
			}];

			workOrder.workOrderGrid.grdMain.setColumnProperty("ALT_YN_NM", "dynamicStyles", iconStyles);
		}
		workOrder.search();
		workOrder.excelSubSearch();
	}
	
	function fn_setNextFieldsBuket() {
		var fields = [
			{fieldName: "PROD_ORDER_NO", dataType : "text"},
			{fieldName: "PARENT_PROD_ORDER_NO", dataType : "text"}
        ];
    	
    	return fields;
	}
	
	function fn_setNextColumnsBuket() {
		var totAr =  ['PROD_ORDER_NO', 'PARENT_PROD_ORDER_NO'];
		var columns = 
		[
			{ 
				name : "PROD_ORDER_NO", fieldName : "PROD_ORDER_NO", editable : false, header: {text: '<spring:message code="lbl.prodOrderNo2" javaScriptEscape="true" />'},
				styles : {textAlignment: "near", background : gfn_getArrDimColor(0)},
				width : 200,
				mergeRule : { criteria: "value" },
				dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
			}, {
				name : "PARENT_PROD_ORDER_NO", fieldName : "PARENT_PROD_ORDER_NO", editable : false, header: {text: '<spring:message code="lbl.parentProdOrderNo" javaScriptEscape="true" />'},
				styles : {textAlignment: "center", background : gfn_getArrDimColor(0)},
				width : 80,
				mergeRule : { criteria: "value" },
				dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
			}
		];
		
		return columns;
	}
    
	function fn_workDailyPop(){
    	
    	var pRoute = $("#route").val();
		var pItemGroup = $("#itemGroup").val();
				
		gfn_comPopupOpen("WORK_POP", {
			rootUrl : "aps/planResult",
			url     : "workOrderDaily",
			width   : 1000,
			height  : 800,
			P_PLAN_ID : $("#planId").val(),
			startDay : $("#startDay").val(),
			P_ROUTE : pRoute,
			P_ITEM_GROUP : pItemGroup,
			menuCd  : "APS312"
		});
	}
	
	function fn_workSummaryPop(){
		
		var pRoute = $("#route").val();
		var pItemGroup = $("#itemGroup").val();
		
		gfn_comPopupOpen("WORK_POP", {
			rootUrl : "aps/planResult",
			url     : "workOrderSummary",
			width   : 1000,
			height  : 800,
			P_PLAN_ID : $("#planId").val(),
			P_ROUTE : pRoute,
			P_ITEM_GROUP : pItemGroup,
			menuCd  : "APS312"
		});
	}
    
  	//week주 뒤 날짜 구함
    function weekdatecal(dt, week){
    	
    	yyyy = dt.substr(0, 4);
    	mm = dt.substr(4, 2);
    	dd = dt.substr(6, 2);
    	
    	var dt_stamp = new Date(yyyy+"-"+mm+"-"+dd).getTime();
    	
    	var days = 7 * week; //2주후
		    toDt = new Date(dt_stamp+(days*24*60*60*1000));
		var rdt = toDt.getFullYear() + '' + (toDt.getMonth() + 1  < 10 ? '0' + (toDt.getMonth() + 1 ) : toDt.getMonth() + 1 ) + (toDt.getDate() < 10 ? '0' + toDt.getDate() : toDt.getDate());
	    
    	return rdt
    	
    }
	
	$(document).ready(function() {
		workOrder.init();
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
					<input type="hidden" id="startDay" name="startDay" class="ipt">
					<div class="view_combo" id="divPlanId"></div>
					<div class="view_combo" id="divProdPart"></div>
					<div class="view_combo" id="divItemType"></div>
					<div class="view_combo" id="divProcurType"></div>
					<div class="view_combo" id="divApsDemandType"></div>
					<div class="view_combo" id="divRoute"></div>
					<div class="view_combo" id="divItemGroup"></div>
					<div class="view_combo" id="divRepCustGroup"></div>
					<div class="view_combo" id="divReptCust">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.reptCust"/></div>
							<input type="text" id="reptCust" name="reptCust" class="ipt">
						</div>
					</div>
					<div class="view_combo" id="divItem"></div>
					<div class="view_combo" id="divMyItem"></div>
					<div class="view_combo" id="divDemandId">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.demandId"/></div>
							<input type="text" id="demandId" name="demandId" class="ipt"/>
						</div>
					</div>
					<div class="view_combo" id="divProdOrderNo">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.prodOrderNo2"/></div>
							<input type="text" id="prodOrderNo" name="prodOrderNo" class="ipt"/>
						</div>
					</div>
					<div class="view_combo" id="divReplaceMaterials"></div>
					<jsp:include page="/WEB-INF/view/common/filterViewHorizon.jsp" flush="false">
						<jsp:param name="radioYn" value="N" />
						<jsp:param name="wType" value="SW" />
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
			<div class="scroll">
				<!-- 그리드영역 -->
				<div id="realgrid" style="width: 100%;" class="realgrid1"></div>
			</div>
			<div class="cbt_btn" style="height:25px">
				<div class="bleft">
				</div>
				<div class="bright">
					<a href="javascript:;" id="workDaily" class="app1"><spring:message code="lbl.woStatus" /></a>
					<a href="javascript:;" id="workSummary" class="app1"><spring:message code="lbl.workSummary" /></a>
					<%-- <a href="javascript:;" id="btnReset" class="app1 roleWrite"><spring:message code="lbl.reset" /></a>
					<a href="javascript:;" id="btnSave" class="app2 roleWrite"><spring:message code="lbl.save" /></a> --%>
				</div>
			</div>
		</div>
    </div>
</body>
</html>
