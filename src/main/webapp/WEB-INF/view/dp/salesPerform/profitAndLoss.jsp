<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp"%>
	<!-- 손익 데이터 업로드-->
	<script type="text/javascript">
	var enterSearchFlag = "Y";
	var profitAndLoss = {

		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.profitAndLossGrid.initGrid();
		},
		
		_siq : "dp.salesPerform.profitAndLossList",
		
		initFilter : function() {
			
			// 키워드팝업
			gfn_keyPopAddEvent([
				//{ target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>' }
			]);
			
			// 콤보박스
			gfn_setMsComboAll([
				{target : 'divBuCd', id : 'buCd', title : '<spring:message code="lbl.bu"/>', data : this.comCode.codeMap.BU_CD, exData:["*"], type : "S"}
			]);
			
			MONTHPICKER("#fromMonth");
		},
		
		/********************************************************************************************************
		** common Code  
		********************************************************************************************************/
		comCode : {
			codeMap : null,
			
			initCode : function () {
				var grpCd = "BU_CD";
		    	this.codeMap = gfn_getComCode(grpCd, "N"); //공통코드 조회
			}
		},
		
		/********************************************************************************************************
		** grid  선언  
		********************************************************************************************************/
		profitAndLossGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;

				this.setColumn();
				this.setOptions();
			},
			
			setColumn : function () {
				var columns = 
				[
					{
						name : "BU_CD", fieldName : "BU_CD", editable: false, header: {text: '<spring:message code="lbl.bu" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						width : 60,
						mergeRule : { criteria: "value" }
					}, {
						name : "CUST_GROUP_CD", fieldName: "CUST_GROUP_CD", editable: false, header: {text: '<spring:message code="lbl.custGroup" javaScriptEscape="true" />'},
						styles: {textAlignment: "center", background : gv_noneEditColor},
						width: 50,
						mergeRule : { criteria: "value" }
					}, {
						name : "CUST_GROUP_NM", fieldName : "CUST_GROUP_NM", editable: false, header: {text: '<spring:message code="lbl.custGroupName" javaScriptEscape="true" />'},
						styles : {textAlignment: "near",background : gv_noneEditColor},
						width : 120,
						mergeRule : { criteria: "value" }
					}, {
						name : "ITEM_CD", fieldName : "ITEM_CD", editable: false, header: {text: '<spring:message code="lbl.item" javaScriptEscape="true" />'},
						styles : {textAlignment: "center", background : gv_noneEditColor},
						width : 80
					}, {
						name : "ITEM_NM", fieldName : "ITEM_NM", editable: false, header : {text: '<spring:message code="lbl.itemName" javaScriptEscape="true" />'},
						styles : {textAlignment : "near", background : gv_noneEditColor},
						width : 120
					}, {
						name : "MAT_KRW", fieldName : "MAT_KRW", header : {text: '<spring:message code="lbl.materialCost" javaScriptEscape="true" />'},
						styles : {textAlignment : "far", background : gv_editColor, numberFormat : "#,##0"},
						dataType : "number",
						width : 100
					}, {
						name : "LABOR_KRW", fieldName: "LABOR_KRW",  header: {text: '<spring:message code="lbl.labor" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_editColor, numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "EXP_KRW", fieldName : "EXP_KRW", header: {text: '<spring:message code="lbl.cost" javaScriptEscape="true" />'},
						styles : {textAlignment: "far", background : gv_editColor, numberFormat : "#,##0"},
						dataType : "number",
						width : 100
					}, {
						name : "OUT_SRC_KRW", fieldName : "OUT_SRC_KRW", header : {text: '<spring:message code="lbl.outsideOrderCost" javaScriptEscape="true" />'},
						styles : {textAlignment : "far", background : gv_editColor, numberFormat : "#,##0"},
						dataType : "number",
						width : 100
					}, {
						name : "PUR_PRICE_KRW", fieldName: "PUR_PRICE_KRW",  header: {text: '<spring:message code="lbl.goodsCost" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_editColor, numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}, {
						name : "SGNA_KRW", fieldName: "SGNA_KRW",  header: {text: '<spring:message code="lbl.sellingAndAdminist" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_editColor, numberFormat : "#,##0"},
						dataType : "number",
						width: 100
					}
				];
				
				//[""] hidden 할 컬럼 넣는다.
				//this.setFields(columns, ["COMPANY_CD", "BU_CD", "YEARMONTH"]);
				this.setFields(columns, ["COMPANY_CD", "BU_CD"]);
				
				this.grdMain.setColumns(columns); 
			},
			
			setFields : function(cols, hiddenCols) {
				
				var fields = new Array();
				
				$.each(cols, function(i, v) {
					fields.push({fieldName : v.fieldName, dataType : v.dataType});							
				});
				
				if (hiddenCols !== undefined && hiddenCols.length > 0) {
					for (hid in hiddenCols) {
						fields.push({fieldName : hiddenCols[hid]});
					}
				}
				
				this.dataProvider.setFields(fields);
			},
			
			setOptions : function () {
				this.grdMain.setOptions({
					checkBar: { visible : true },
					stateBar: { visible : true },
				});

				this.dataProvider.setOptions({
					softDeleting : true
				});
			},
		},
	
		events : function () {
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("#btnSave").on('click', function (e) {
				profitAndLoss.save();
			});
			
			$("#btnDeleteRows").on('click', function (e) {
				profitAndLoss.delRow();
			});

			$("#btnReset").on('click', function (e) {
				profitAndLoss.profitAndLossGrid.grdMain.cancel();
				profitAndLoss.profitAndLossGrid.dataProvider.rollback(profitAndLoss.profitAndLossGrid.dataProvider.getSavePoints()[0]);
			});
			
			$('#excelFile').on('change', function(){gfn_importGrid({noYn : "N", fieldFlag: "N"});});
	  		
	    	$("#btnExcelDownload").click("on", function() {gfn_doExportExcel({fileNm : "${menuInfo.menuNm}", formYn : "Y", lookupDisplay : false, indicator : "hidden", conFirmFlag : false}); });
	    	$("#btnExcelUpload").click("on", function(){
	    		$("#excelFile").trigger("click");
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
					
					//데이터
					if(id == "divBuCd"){
						EXCEL_SEARCH_DATA += $("#buCd option:selected").text();
					}else if(id == "divFromMonth"){
						EXCEL_SEARCH_DATA += $("#fromMonth").val();
					}
				}
			});
		},
		
		search : function () {
			
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{outDs : "resList", _siq : profitAndLoss._siq}];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						profitAndLoss.profitAndLossGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						profitAndLoss.profitAndLossGrid.grdMain.cancel();
						profitAndLoss.profitAndLossGrid.dataProvider.setRows(data.resList);
						profitAndLoss.profitAndLossGrid.dataProvider.clearSavePoints();
						profitAndLoss.profitAndLossGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(profitAndLoss.profitAndLossGrid.dataProvider.getRowCount());
						
						profitAndLoss.profitAndLossGrid.gridInstance.setFocusKeys();
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		delRow : function() {
			var rows = this.profitAndLossGrid.grdMain.getCheckedRows();
	    	this.profitAndLossGrid.dataProvider.removeRows(rows, false);
		},
		
		save : function() {
			
			var paramFromMonth = $("#fromMonth").val().replace("-", ""); 
			var grdData = gfn_getGrdSavedataAll(this.profitAndLossGrid.grdMain);
			var grdDataLen = grdData.length;
			if (grdDataLen == 0) {
				alert('<spring:message code="msg.noChangeData"/>');
				return;
			}
			
			var buCdArry = new Array();
			var buCdTemp = "";
			for(var i = 0; i < grdDataLen; i++){
				
				var temp = grdData[i].BU_CD;
				if(buCdTemp.indexOf(temp) == -1){
					buCdTemp += temp;
					buCdArry.push(temp);
				}
			}
			
			confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
 				FORM_SAVE = {};
	    		FORM_SAVE._mtd = "saveUpdate";
	    		FORM_SAVE.yearMonth = paramFromMonth;
	    		FORM_SAVE.buCdArry = buCdArry;
	    		FORM_SAVE.tranData   = [
					{outDs : "saveCnt", _siq : profitAndLoss._siq, grdData : [{rowList : grdData}]},
				];
	    		
		    	var sMap = {
		            url: GV_CONTEXT_PATH + "/biz/obj",
		            data: FORM_SAVE,
		            success:function(data) {
		            	alert('<spring:message code="msg.saveOk"/>');
			            fn_apply();
		            }
		        }
		        gfn_service(sMap, "obj");
	    	});
			
		},
	};
	
	function fn_checkClose() {
    	return gfn_getGrdSaveCount(profitAndLoss.profitAndLossGrid.grdMain) == 0; 
    }
	
	/********************************************************************************************************
	** 조회 
	********************************************************************************************************/
	function fn_apply(sqlFlag) {
		
		FORM_SEARCH = $("#searchForm").serializeObject(); 
		FORM_SEARCH.sql = sqlFlag;
		
		profitAndLoss.search();
		profitAndLoss.excelSubSearch();
	}


	/********************************************************************************************************
	** onload  
	********************************************************************************************************/
	$(document).ready(function() {
		profitAndLoss.init();
	});

	</script>

</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp"%>
	
	<div id="a" class="split content split-horizontal">
		<form id="searchForm" name="searchForm">
		<div id="filterDv">
			<div class="inner">
				<h3>Filter</h3>
				<%-- <%@ include file="/WEB-INF/view/common/filterMonthSum.jsp"%> --%>
				<div class="tabMargin"></div>
				<div class="scroll">
					<div class="view_combo" id="divBuCd"></div>
					<div class="view_combo" id="divFromMonth">
						<div class="ilist">
							<div class="itit">Month</div>
							<input type="text" id="fromMonth" name="fromMonth" class="iptdate datepicker2 monthpicker" value="">
						</div>
					</div>
				</div>
				<div class="bt_btn">
					<a href="#" class="fl_app" id="btnSearch"><spring:message code="lbl.search" /></a>
				</div>
			</div>
		</div>
		</form>
	</div>
	
	<div id="b" class="split split-horizontal">
		<!-- contents -->
		<div id="grid1" class="fconbox">
			<%@ include file="/WEB-INF/view/common/commonLocation.jsp"%>
			
			<div class="scroll">
				<!-- 그리드영역 -->
				<div id="realgrid" class="realgrid1"></div>
			</div>
			<!-- 하단버튼 영역 -->
			<div class="cbt_btn roleWrite">
				<div class="bleft">
				<form id="excelForm" method="post" enctype="multipart/form-data">
					<input type="file" name="excelFile" id="excelFile" style="display:none;"/>
					<input type="hidden" name="columnNames" id="columnNames" />
				</form>
				<a href="javascript:void(null)" id="btnExcelDownload" class="app1"><spring:message code="lbl.excelDownload"/></a>
				<a href="javascript:void(null)" id="btnExcelUpload" class="app1"><spring:message code="lbl.excelUpload"/></a>
				</div>
				<div class="bright">
					<a id="btnReset"       href="#" class="app1"><spring:message code="lbl.reset" /></a> 
					<a id="btnDeleteRows"  href="#" class="app1"><spring:message code="lbl.delete" /></a> 
					<a id="btnSave"        href="#" class="app2"><spring:message code="lbl.save" /></a>
				</div>
			</div>
		</div>
	</div>
	
</body>
</html>
