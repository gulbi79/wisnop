<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	<!-- 채권회전율 -->
	<script type="text/javascript">

	var enterSearchFlag = "Y";
	var bondRotateDay = {

		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.bondRotateDayGrid.initGrid();
		},
			
		_siq    : "snop.bizKpi.bondRotateDayList",
		
		 
		initFilter : function() {
			
			// 키워드팝업
			gfn_keyPopAddEvent([
				//{ target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>' }
			]);
			
			// 콤보박스
			gfn_setMsComboAll([
				{target : 'divOverDay', id : 'overDay', title : '<spring:message code="lbl.bcd"/>', data : this.comCode.codeMap.OVER_DAY, exData:[""]},
				{target : 'divRepCustGroup', id : 'reptCustGroup', title : '<spring:message code="lbl.reptCustGroup"/>', data : this.comCode.codeMapEx.REP_CUST_GROUP,exData:["*"]},
				{target : 'divCustGroup', id : 'custGroup', title : '<spring:message code="lbl.custGroup"/>', data : this.comCode.codeMapEx.CUST_GROUP,exData:["*"]},
			]);
	       	 
			MONTHPICKER("#fromMonth"); 
		},
		
		/*
		* common Code 
		*/
		comCode : {
			codeMapEx : null,			
			codeMap : null,
			
			initCode : function () {
				var grpCd = 'OVER_DAY';
				this.codeMap = gfn_getComCode(grpCd, 'Y'); //공통코드 조회
				this.codeMapEx = gfn_getComCodeEx(["REP_CUST_GROUP", "CUST_GROUP"]);
			}
		},
	
		/* 
		* grid  선언
		*/
		bondRotateDayGrid : {
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
						name : "OMIT_FLAG", fieldName: "OMIT_FLAG", editable: false, header: {text: '<spring:message code="lbl.omit0" javaScriptEscape="true" />'},
						styles: {textAlignment: "near", background : gv_noneEditColor},
						width: 120,
						visible: false
					}, { 
						name : "CATEGORY_NM_NM", fieldName : "CATEGORY_NM_NM", editable : false, header: {text: '<spring:message code="lbl.category" javaScriptEscape="true" />'},
						styles : {textAlignment: "center", background : gv_noneEditColor},
						width : 120,
						mergeRule : { criteria: "value" }
					}, {
						name : "BU_CD_NM", fieldName : "BU_CD_NM", editable : false, header: {text: '<spring:message code="lbl.bu" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						width : 120,
						mergeRule : { criteria: "value" }
					}, {
						name : "REP_CUST_GROUP_CD", fieldName : "REP_CUST_GROUP_CD", editable : false, header: {text: '<spring:message code="lbl.reptCustGroup" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						width : 120,
						mergeRule : { criteria: "values['CATEGORY_NM_NM'] + values['BU_CD_NM'] + value" }
					}, {
						name : "REP_CUST_GROUP_NM", fieldName : "REP_CUST_GROUP_NM", editable : false, header: {text: '<spring:message code="lbl.reptCustGroupName" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						width : 120,
						mergeRule : { criteria: "values['CATEGORY_NM_NM'] + values['BU_CD_NM'] + value" }
					}, {
						name : "CUST_GROUP_CD", fieldName : "CUST_GROUP_CD", editable : false, header: {text: '<spring:message code="lbl.custGroup" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						width : 120,
						mergeRule : { criteria: "values['CATEGORY_NM_NM'] + values['BU_CD_NM'] + value" }
					}, {
						name : "CUST_GROUP_NM", fieldName : "CUST_GROUP_NM", editable : false, header: {text: '<spring:message code="lbl.custGroupName" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						width : 120,
						mergeRule : { criteria: "values['CATEGORY_NM_NM'] + values['BU_CD_NM'] + value" }
					}, {
						name : "REP_CUST_CD", fieldName : "REP_CUST_CD", editable : false, header: {text: '<spring:message code="lbl.billCollection" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						width : 120,
						mergeRule : { criteria: "values['CATEGORY_NM_NM'] + values['BU_CD_NM'] + value" }
					}, {
						name : "REP_CUST_NM", fieldName : "REP_CUST_NM", editable : false, header: {text: '<spring:message code="lbl.billCollectionName" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						width : 120,
						mergeRule : { criteria: "values['CATEGORY_NM_NM'] + values['BU_CD_NM'] + value" }
					}, {
						name : "BONDS_CREATION_DATE", fieldName : "BONDS_CREATION_DATE", editable : false, header : {text: '<spring:message code="lbl.bcd" javaScriptEscape="true" />'},
						styles : {textAlignment : "center", background : gv_noneEditColor},
						width : 100
					}, {
						name : "REF_NO", fieldName: "REF_NO", editable : false, header: {text: '<spring:message code="lbl.refNo" javaScriptEscape="true" />'},
						styles: {textAlignment: "center", background : gv_noneEditColor},
						width: 120
					}, {
						name : "BAL_AMT", fieldName: "BAL_AMT", editable : false, header: {text: '<spring:message code="lbl.amountLocal" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dataType : "number",
						width: 200
					}, {
						name : "BAL_AMT_KRW", fieldName: "BAL_AMT_KRW", editable : false, header: {text: '<spring:message code="lbl.amountKrw" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dataType : "number",
						width: 200
					}, {
						name : "SUSPENSION_REASON", fieldName : "SUSPENSION_REASON", editable : false, header: {text: '<spring:message code="lbl.suspensionReason" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						width : 120
					}, {
						name : "TREATMENT_PLAN", fieldName : "TREATMENT_PLAN", editable : false, header: {text: '<spring:message code="lbl.treatmentPlan" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						width : 120
					}
				];
				
				//[""] hidden 할 컬럼 넣는다.
				this.setFields(columns, ["GRP_LVL_ID", "OMIT_FLAG", "AR_NO", "FROM_MONTH"]);
				
				this.grdMain.setColumns(columns); 
			},
			
			setFields : function(cols, hiddenCols) {
				var newDynamicStyles = [
					{
					    criteria : "values['CATEGORY_NM_NM'] = '"+ gv_total +"'",
					    styles : "background=" + gv_totalColor
					},{
					     criteria: "values['BU_CD_NM'] = '"+ gv_subTotal +"'",
					     styles : "background=" + gv_arrDimColor[0]
					}
				];
				 
				bondRotateDay.bondRotateDayGrid.grdMain.setStyles({
				    body: {
				        dynamicStyles: newDynamicStyles
				    }
				});
				 
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
					//checkBar: { visible : true },
					stateBar: { visible : true },
				});

				this.dataProvider.setOptions({
					softDeleting : true
				});
				
				this.grdMain.addCellStyles([{
					id         : "editStyle",
					editable   : true,
					background : gv_editColor
				}]);
			},
		},
	
		/*
		* event 정의
		*/
		events : function () {
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("#btnReset").on('click', function (e) {
				bondRotateDay.bondRotateDayGrid.grdMain.cancel();
				bondRotateDay.bondRotateDayGrid.dataProvider.rollback(bondRotateDay.bondRotateDayGrid.dataProvider.getSavePoints()[0]);
			});
			
			$("#btnSave").on('click', function (e) {
				bondRotateDay.save();
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
					if(id == "divOverDay"){
						$.each($("#overDay option:selected"), function(i2, val2){
							
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
					}else if(id == "divFromMonth"){
						EXCEL_SEARCH_DATA += $("#fromMonth").val();
					}
				}
			});
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
						bondRotateDay.bondRotateDayGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						bondRotateDay.bondRotateDayGrid.grdMain.cancel();
						
						bondRotateDay.bondRotateDayGrid.dataProvider.setRows(data.resList);
						bondRotateDay.bondRotateDayGrid.dataProvider.clearSavePoints();
						bondRotateDay.bondRotateDayGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(bondRotateDay.bondRotateDayGrid.dataProvider.getRowCount());
						gfn_setRowTotalFixed(bondRotateDay.bondRotateDayGrid.grdMain);
						
						bondRotateDay.gridCallback(data.resList);
						
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		gridCallback : function (resList) {
			
			for (var i = resList.length-1; i >= 0; i--) {
				if (resList[i].GRP_LVL_ID == "0") {
					this.bondRotateDayGrid.grdMain.setCellStyles(i, "SUSPENSION_REASON", "editStyle");
					this.bondRotateDayGrid.grdMain.setCellStyles(i, "TREATMENT_PLAN", "editStyle");
				}
			}
		},
		
		
		save : function (){
			
			var grdData = gfn_getGrdSavedataAll(this.bondRotateDayGrid.grdMain);
			
			for (var i = grdData.length-1; i >= 0; i--) {
				if (grdData[i].GRP_LVL_ID != "0") {
					grdData.splice(i, 1);
				}
			}
			if (grdData.length == 0) {
				alert('<spring:message code="msg.noChangeData"/>');
				return;
			}
			
			confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
					
				FORM_SAVE            = {}; //초기화
				FORM_SAVE._mtd       = "saveUpdate";
				FORM_SAVE.tranData   = [
					{outDs : "saveCnt", _siq : bondRotateDay._siq, grdData : [{rowList : grdData}]},
				];
				
				var ajaxOpt = {
					url     : GV_CONTEXT_PATH + "/biz/obj",
					data    : FORM_SAVE,
					success : function(data) {
						
						alert('<spring:message code="msg.saveOk"/>');
						fn_apply(false);
					},
				};
				
				gfn_service(ajaxOpt, "obj");
			});
		}
	};
	

	//조회
	var fn_apply = function (sqlFlag) {
		
		// 디멘젼, 메져
		gfn_getMenuInit();
		
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
   		FORM_SEARCH.meaList    = MEASURE.user;
   		FORM_SEARCH.bucketList = BUCKET.query;
   		
		bondRotateDay.search();
		bondRotateDay.excelSubSearch();
	}

	// onload 
	$(document).ready(function() {
		bondRotateDay.init();
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
					<div class="view_combo" id="divOverDay"></div>
					<div class="view_combo" id="divRepCustGroup"></div>
					<div class="view_combo" id="divCustGroup"></div>
					<div class="view_combo" id="divFromMonth">
						<div class="ilist">
							<div class="itit">Month</div>
							<input type="text" id="fromMonth" name="fromMonth" class="iptdate datepicker2 monthpicker" value="">
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
			<div class="cbt_btn" style="height:25px">
				<div class="bright">
					<a href="javascript:;" id="btnReset" class="app1 roleWrite"><spring:message code="lbl.reset" /></a>
					<a href="javascript:;" id="btnSave" class="app2 roleWrite"><spring:message code="lbl.save" /></a>
				</div>
			</div>
		</div>
    </div>
</body>
</html>
