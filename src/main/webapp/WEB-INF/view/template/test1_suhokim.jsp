<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	<!-- 실행계획적중율 -->
	<script type="text/javascript">

	var enterSearchFlag = "Y";
	var criteriaValidation = {
      
		init : function () {
			
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.criteriaValidationGrid.initGrid();
			this.events();
		},
			
		_siq : "nbalive21.criteriaValidationList",
		
		initFilter : function() {
			
	    	// 콤보박스
			gfn_setMsComboAll([
				{target : 'divPlanId',   id : 'planId',    title : '<spring:message code="lbl.planId2"/>', data : this.comCode.codeMap.PLAN_ID, exData:[''], type: "S"},
						
				]);
	    	
			// 달력
			MONTHPICKER(null, -3, -1);
			
			$('#toMon').monthpicker("option", "maxDate", -1);
		},
		
		/*
		* common Code 
		*/
		comCode : {
			
			codeMap : null,
			
			initCode  : function () {
				
				this.codeMap = gfn_getComCode('FLAG_YN', 'Y'); //공통코드 조회
				gfn_service({
					async	: false,
					url 	: GV_CONTEXT_PATH+"/biz/obj",
					data	: {_mtd	: "getList", tranData:[
						{ outDs: "planList", _siq: "aps.planExecute.planIdBasic"},	
					]},
					
					success: function(data){
						
						criteriaValidation.comCode.codeMap.PLAN_ID = data.planList
						
					}
				},"obj");
			
			}
		},
	
		/* 
		* grid  선언
		*/
		criteriaValidationGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				this.gridInstance.custBeforeBucketFalg = true;
				this.gridInstance.measureHFlag = true;
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				
				this.setOptions();
			},
			setOptions : function(){
			
				this.grdMain.addCellStyles([{
					id         : "editStyle",
					editable   : true,
					background : gv_editColor
				}]);
				
				this.grdMain.addCellStyles([{
					id         : "subTotalStyle",
					editable   : false,
					background : "#edf7fd"
				}]);
				
				this.grdMain.addCellStyles([{
					id         : "totalStyle",
					editable   : false,
					background : "#FDEFB3"
				}]);
				
				
				
				
			}
			
		},
		/*
		* event 정의
		*/
		events : function () {
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			//Omit Sum,  Omit 0 처리
			gfn_setMonthSum(this.criteriaValidationGrid.gridInstance, false, true, true);
			
			$("#btnSave").click("on", function() { fn_save(); });
		},
		
		//엑셀 다운로드
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
					}
					
					EXCEL_SEARCH_DATA += "\n" + '<spring:message code="lbl.period"/>' + " : ";
					EXCEL_SEARCH_DATA += $("#fromMon").val() + " ~ " + $("#toMon").val();
					
				}
			});
		},
		
		
		
		
		// 조회
		search : function () {
			
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq }];
			FORM_SEARCH.hrcyFlag   = true;
			
			console.log("FORM_SEARCH:",FORM_SEARCH);
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SEARCH,
				success : function (data) {
					
					
					if (FORM_SEARCH.sql == 'N') {
						criteriaValidation.criteriaValidationGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						criteriaValidation.criteriaValidationGrid.grdMain.cancel();
						
						criteriaValidation.criteriaValidationGrid.dataProvider.setRows(data.resList);
						criteriaValidation.criteriaValidationGrid.dataProvider.clearSavePoints();
						criteriaValidation.criteriaValidationGrid.dataProvider.savePoint(); //초기화 포인트 저장
						
						//Omit sum Omit0
						gfn_actionMonthSum(criteriaValidation.criteriaValidationGrid.gridInstance);
						gfn_setRowTotalFixed(criteriaValidation.criteriaValidationGrid.grdMain);
						
						criteriaValidation.gridCallback(data.resList);
											
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		
		getBucket: function(sqlFlag){
			
			
			var ajaxMap = {
					
					fromDate: gfn_replaceAll($("#fromMon").val(),"-","")+"01",
					toDate : gfn_replaceAll($("#toMon").val(), "-", "") + "31",
					month : {isDown : "Y", isUp : "N", upCal : "Q", isMt : "N", isExp : "N", expCnt : 999},
					sqlId : ["bucketMonth"]
			}
			
			gfn_getBucket(ajaxMap, true);	
			
			if (!sqlFlag) {
				
				criteriaValidation.criteriaValidationGrid.gridInstance.setDraw();
				
				
				
			}
			
			
		},
		
		gridCallback : function(resList){
			
			
			for (var i = resList.length-1; i >= 0; i--) {
				if (resList[i].GRP_LVL_ID == "0") {
					this.criteriaValidationGrid.grdMain.setCellStyles(i, "INVALID_CNT", "editStyle");
					this.criteriaValidationGrid.grdMain.setCellStyles(i, "SALES_PLAN_YN", "editStyle");
				}
				else if(resList[i].PLAN_ID_NM == "Total")
				{
					this.criteriaValidationGrid.grdMain.setCellStyles(i, "INVALID_CNT", "totalStyle");
					this.criteriaValidationGrid.grdMain.setCellStyles(i, "SALES_PLAN_YN", "totalStyle");
					this.criteriaValidationGrid.grdMain.setCellStyles(i, "SP_QTY", "totalStyle");
					this.criteriaValidationGrid.grdMain.setCellStyles(i, "WIP_QTY", "totalStyle");
					this.criteriaValidationGrid.grdMain.setCellStyles(i, "PROD_ORDER_YN", "totalStyle");
					
				}
				else if(resList[i].ITEM_CD_NM == "Sub Total")
				{
					this.criteriaValidationGrid.grdMain.setCellStyles(i, "INVALID_CNT", "subTotalStyle");
					this.criteriaValidationGrid.grdMain.setCellStyles(i, "SALES_PLAN_YN", "subTotalStyle");
					this.criteriaValidationGrid.grdMain.setCellStyles(i, "SP_QTY", "subTotalStyle");
					this.criteriaValidationGrid.grdMain.setCellStyles(i, "WIP_QTY", "subTotalStyle");
					this.criteriaValidationGrid.grdMain.setCellStyles(i, "PROD_ORDER_YN", "subTotalStyle");
				}
			}
			
			
			
		}
		
	};

	
	//조회
	var fn_apply = function (sqlFlag) {
		
		// 디멘젼, 메져
		gfn_getMenuInit();
		
		criteriaValidation.getBucket(sqlFlag);
		
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
   		FORM_SEARCH.dimList    = DIMENSION.user;
   		FORM_SEARCH.bucketList = BUCKET.query;
   			
   		criteriaValidation.search();
   		criteriaValidation.excelSubSearch();
   		
	}
	
	function fn_setBeforeFieldsBuket() {
		var fields = [
			{ fieldName : "COMPANY_CD" },
			{ fieldName : "BU_CD" },
			{fieldName: "INVALID_CNT", dataType : "number"},
			{fieldName: "SALES_PLAN_YN", dataType : "text"},
			{fieldName: "SP_QTY", dataType : "number"},
			{fieldName: "WIP_QTY", dataType : "number"},
			{fieldName: "PROD_ORDER_YN", dataType : "text"}
        ];
    	return fields;
	}
	
	function fn_setBeforeColumnsBuket() {
		var columns = [	
			{
				name : "INVALID_CNT", fieldName: "INVALID_CNT", editable: true, header: {text: "Invalid Cnt."},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0.0"},
				editor       : { type: "number", positiveOnly: true, editFormat: "#,###.0" },
				dataType : "number",
				width: 80
			}, {
				name : "SALES_PLAN_YN", fieldName: "SALES_PLAN_YN", editable: true, header: {text: "수요 유무"},
				editor       : { type: "dropDown", domainOnly: true },
				values       : gfn_getArrayExceptInDs(criteriaValidation.comCode.codeMap.FLAG_YN, "CODE_CD", ""),
				labels       : gfn_getArrayExceptInDs(criteriaValidation.comCode.codeMap.FLAG_YN, "CODE_NM", ""),
				styles: {textAlignment: "center", background : gv_noneEditColor},
				nanText      : "",
				lookupDisplay: true,
				width: 80
			}, {
				name : "SP_QTY", fieldName: "SP_QTY", editable: false, header: {text: "수요수량"},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0.0"},
				dataType : "number",
				width: 80
			}, {
				name : "WIP_QTY", fieldName: "WIP_QTY", editable: false, header: {text: "WIP 수량"},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0.0"},
				dataType : "number",
				width: 80
			}, {
				name : "PROD_ORDER_YN", fieldName: "PROD_ORDER_YN", editable: false, header: {text: "제조 오더 생성"},
				styles: {textAlignment: "center", background : gv_noneEditColor},
				dataType : "number",
				width: 80
			}
			
			
		];
		return columns;
	}
	
	//그리드 저장
	function fn_save() {
		
		//수정된 그리드 데이터
		var grdData = gfn_getGrdSavedataAll(criteriaValidation.criteriaValidationGrid.grdMain);
		
		if (grdData.length == 0) {
			alert('<spring:message code="msg.noChangeData"/>');
			return;
		}
		
		confirm('<spring:message code="msg.saveCfm"/>', function() {
			//저장
			FORM_SAVE          = {}; //초기화
			FORM_SAVE._mtd     = "saveUpdate";
			FORM_SAVE.tranData = [{outDs:"saveCnt",_siq:"nbalive21.criteriaValidationList",grdData:grdData}];
			
			gfn_service({
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SAVE,
				success : function(data) {
					alert('<spring:message code="msg.saveOk"/>');
					fn_apply();
				}
			}, "obj");
		
		});
	}

	// onload 
	$(document).ready(function() {
		criteriaValidation.init();
	});
	
	</script>

</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="a" class="split content split-horizontal">
	
		<!-- tree -->
		<div id="c" class="split content">
			<%@ include file="/WEB-INF/view/common/leftTree.jsp"%>
		</div>
		<!-- filter -->
		<div id="d" class="split content">
			<form id="searchForm" name="searchForm">
			<div id="filterDv">
				<div class="inner">
					<h3>Filter</h3>
					<%@ include file="/WEB-INF/view/common/filterMonthSum.jsp"%>
					<div class="tabMargin"></div>
					<div class="scroll">
						<div class="view_combo" id="divPlanId"></div>
						<jsp:include page="/WEB-INF/view/common/filterViewHorizonMonth.jsp" flush="false" />
					</div>
					<div class="bt_btn">
						<a href="#" class="fl_app" id="btnSearch"><spring:message code="lbl.search"/></a>
					</div>
				</div>
			</div>
			</form>
		</div>
	</div>
	
	<!-- contents -->
	<div id="b" class="split split-horizontal">
		<div id="grid1" class="fconbox">
			<%@ include file="/WEB-INF/view/common/commonLocation.jsp" %>
		
			<div class="scroll">
				<!-- 그리드영역 -->
				<div id="realgrid" style="width: 100%;" class="realgrid1"></div>
			</div>
			<div class="cbt_btn">
				<div class="bright">
					<a href="javascript:;" id="btnSave" class="app2 roleWrite"><spring:message code="lbl.save"/></a>
				</div>
			</div>
			
			
		</div>
    </div>
</body>
</html>
