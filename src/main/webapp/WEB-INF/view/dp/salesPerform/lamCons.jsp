<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>

	<script type="text/javascript">

	var enterSearchFlag = "Y";
	var lamData, EXCEL_GRID_DATA;
	
	var lamCons = {

		init : function () {
			
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.grid.initGrid();
		},
			
		_siq    : "dp.salesPerform.lamCons",
		
		/*
		* common Code 
		*/
		comCode : {
			codeMap   : null,
			codeMapEx : null,
			
			initCode  : function () {
				var grpCd    = 'LAM_SL_CD';
				this.codeMap = gfn_getComCode(grpCd, "Y"); //공통코드 조회
			}
		},
		
		initFilter : function() {
			
			// 키워드팝업
			gfn_keyPopAddEvent([
				{ target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>' }
			]);
			
			// 콤보박스
			gfn_setMsComboAll([
				{ target : 'divPlanId', id : 'planId', title : '<spring:message code="lbl.planId"/>', data : [], exData:[""], type : "S"},
				{ target : 'divWareHouse', id : 'wareHouse', title : '<spring:message code="lbl.wareHouse"/>', data : this.comCode.codeMap.LAM_SL_CD, exData:["*"], type : "S"},
			]);
			
			lamCons.prodPlanId();
		},
		
		prodPlanId : function() {
			FORM_SEARCH          = $("#searchForm").serializeObject(); //초기화
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "versionList", _siq : lamCons._siq + "Version"}];
			
			// 계획버전 
			gfn_service({
			    async   : false,
			    url     : GV_CONTEXT_PATH + "/biz/obj.do",
			    data    : FORM_SEARCH,
			    success : function(data) {
			    	
			    	var fromDate = data.versionList[0].FROM_DATE;
			    	var toDate = data.versionList[0].TO_DATE;
			    	
			    	DATEPICKET(null, fromDate, toDate);
			    	
			    	gfn_setMsCombo("planId", data.versionList, [""]);
			    	
			    	fn_planId();
			    }
			},"obj");
		},
		
		/* 
		* grid  선언
		*/
		grid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				
				this.gridInstanceExcel = new GRID();
				this.gridInstanceExcel.init("realgridExcel");
				
				this.grdMainExcel      = this.gridInstanceExcel.objGrid;
				this.dataProviderExcel = this.gridInstanceExcel.objData;
				
				this.gridInstance.custBeforeBucketFalg = true;
				this.gridInstanceExcel.custBeforeBucketFalg = true;
				
				this.setOptions();
			},
			
			setOptions : function() {
				
				this.grdMain.setOptions({
					stateBar: { visible : true  }
				});
				
				this.grdMain.addCellStyles([{
					id         : "editStyle",
					editable   : true,
					background : gv_editColor
				}]);
				
				this.grdMain.addCellStyles([{
					id         : "editNoneStyle",
					editable   : false,
					background : gv_totalColor
				}]);
				
				this.grdMain.addCellStyles([{
					id         : "editNoneStyle2",
					editable   : false,
					background : gv_bucketColor
				}]);
				
				this.grdMainExcel.addCellStyles([{
					id         : "editStyleExcel",
					editable   : true,
					background : gv_editColor
				}]);
				
				this.grdMainExcel.setOptions({
					stateBar: { visible : true  },
					sorting : { enabled      : false },
					display : { columnMovable: false }
				});
			}
		},
	
		/*
		* event 정의
		*/
		events : function () {
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("#btnReset").on ("click", function() { 
				fn_reset(); 
			});
			
			$("#btnSave").on ("click", function() { 
				fn_save(); 
			});
			
			$("#btnExcelDown").click ("on", function() { 
				fn_excelDown(false); 
			});
			
			$("#btnExcelUpload").click ("on", function() { 
				$("#excelFile").trigger("click");	
			});
			
			$("#excelFile").change("on", function() { 
				fn_excelUpload();	
			});
			
			$("#btnSummary").on('click', function (e) {
				
				gfn_comPopupOpen("LAM_CONS_SUMMARY", {
					rootUrl : "dp/salesPerform",
					url     : "lamConsSummary",
					width   : 1200,
					height  : 680,
					planId : $("#planId").val(),
					menuCd : "DP313"
				});
			});
			
			$("#planId").change(function() {
				fn_planId();
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
					if(id == "divPlanId"){
						EXCEL_SEARCH_DATA += $("#planId option:selected").text();
					}else if(id == "divItem"){
						EXCEL_SEARCH_DATA += $("#item_nm").val();
					}else if(id == "divSpec"){
						EXCEL_SEARCH_DATA += $("#spec").val();
					}else if(id == "divWareHouse"){
						EXCEL_SEARCH_DATA += $("#wareHouse option:selected").text();
					}
				}
			});
			
			EXCEL_SEARCH_DATA += "\n" + '<spring:message code="lbl.period"/>' + " : ";
			EXCEL_SEARCH_DATA += $("#fromCal").val() + "(" + $("#fromWeek").val() + ") ~ ";
			EXCEL_SEARCH_DATA += $("#toCal").val() + "(" + $("#toWeek").val() + ")";
		},
		
		// 조회
		search : function () {
			
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList", _siq : this._siq }];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj.do",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						lamCons.grid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						lamCons.grid.grdMain.cancel();
						
						lamCons.grid.dataProvider.setRows(data.resList);
						lamCons.grid.dataProvider.clearSavePoints();
						lamCons.grid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_actionMonthSum(lamCons.grid.gridInstance);
						gfn_setRowTotalFixed(lamCons.grid.grdMain);
						
						lamCons.gridCallback(data.resList);
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		getBucket : function (sqlFlag) {
			
			var ajaxMap = {
				fromDate : gfn_replaceAll($("#fromCal").val(), "-", ""),
				toDate   : gfn_replaceAll($("#toCal").val(), "-", ""),
				sqlId    : ["dp.salesPerform.bucketAll", "dp.salesPerform.bucketAll2"]
			}
			gfn_getBucket(ajaxMap);
			
			if (!sqlFlag) {
				
				DIMENSION.hidden = [];
				DIMENSION.hidden.push({CD : "PLAN_ID", dataType : "text"});
				DIMENSION.hidden.push({CD : "WARE_HOUSE_CD", dataType : "text"});
				DIMENSION.hidden.push({CD : "ITEM_AUTH", dataType : "text"});
				
				lamCons.grid.gridInstance.setDraw();
				
				var fileds = lamCons.grid.dataProvider.getFields();
				var filedsLen = fileds.length;
				
				for (var i = 0; i < filedsLen; i++) {
					var fieldName = fileds[i].fieldName;
					if (fieldName == 'SALES_PRICE_KRW_NM'){
						fileds[i].dataType = "number";
						lamCons.grid.grdMain.setColumnProperty(fieldName, "styles", {"numberFormat" : "#,##0"});	
					}
				}
				
				lamCons.grid.dataProvider.setFields(fileds);
			}
		},
		
		getBucketExcel : function (sqlFlag) {
			
			gfn_service({
			    async   : false,
			    url     : GV_CONTEXT_PATH + "/biz/obj.do",
			    data    : {
			    	_mtd           : "getList",
			    	SEARCH_MENU_CD : "${menuInfo.menuCd}",
			    	tranData       : [
			    		{outDs : "dimList", _siq : "admin.dimMapMenu"}
			    	]
			    },
			    success :function(data) {
			    	
			    	DIMENSION.user = [];
			    	DIMENSION.user = data.dimList;
			    	DIMENSION.user.push({DIM_CD : "PLAN_ID", CD : "PLAN_ID", dataType : "text"});
					DIMENSION.user.push({DIM_CD : "WARE_HOUSE_CD", CD : "WARE_HOUSE_CD", dataType : "text"});
					DIMENSION.user.push({DIM_CD : "ITEM_AUTH", CD : "ITEM_AUTH", dataType : "text"});
			    	
					var ajaxMap = {
						fromDate  : gfn_replaceAll($("#fromCal").val(), "-", ""),
						toDate    : gfn_replaceAll($("#toCal").val(), "-", ""),
						excelFlag : "Y",
						sqlId     : ["dp.salesPerform.bucketAll", "dp.salesPerform.bucketAll2"]
					}
					gfn_getBucket(ajaxMap);
					
					if (!sqlFlag) {
						
						EXCEL_GRID_DATA = {
							DIM : DIMENSION.user,
							DIM_H : DIMENSION.hidden,
							BUC : BUCKET.query
						};	
						
						lamCons.grid.gridInstanceExcel.setDraw();
					}
			    }
			}, "obj");
		},
		
		gridCallback : function(resList){
			
			lamData = new Array();
			
			$.each(resList, function(n, v){
				var grpLvlId = v.GRP_LVL_ID;
				var itemAuth = v.ITEM_AUTH;
   				
   				if(grpLvlId == 0 && itemAuth == "Y"){
   					lamData.push(n);
   				}
    		});
			
			lamCons.grid.grdMain.setCellStyles(lamData, "MIN_QTY", "editStyle");
			lamCons.grid.grdMain.setCellStyles(lamData, "MAX_QTY", "editStyle");
			lamCons.grid.grdMain.setCellStyles(lamData, "LAST_USG_QTY", "editStyle");
			lamCons.grid.grdMain.setCellStyles(lamData, "INV_QTY", "editStyle");
			
			$.each(BUCKET.query, function(n, v) {
				
				var cd = v.CD;
				
				if(cd.indexOf("M") == -1){
					lamCons.grid.grdMain.setCellStyles(lamData, cd, "editStyle");
				}
			});
			
			lamCons.getBucketExcel(false); //2. 버켓정보 조회 */
		}
	};
	
	//조회
	var fn_apply = function (sqlFlag) {
		 		
		$("#realgrid").show();
		$("#realgridExcel").hide();
		 
		// 디멘젼, 메져
		gfn_getMenuInit();
		
		lamCons.getBucket(sqlFlag); //2. 버켓정보 조회
    	
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
   		FORM_SEARCH.dimList    = DIMENSION.user;
   		FORM_SEARCH.bucketList = BUCKET.query;
   		
		lamCons.search();
		lamCons.excelSubSearch();
	}
	
	function fn_excelDown(sqlFlag){
			
		lamCons.getBucketExcel(sqlFlag); //2. 버켓정보 조회
		
		var EXCEL_FORM = $("#searchForm").serializeObject();
		
		EXCEL_FORM.dimList	  = EXCEL_GRID_DATA.DIM;
		EXCEL_FORM.bucketList = EXCEL_GRID_DATA.BUC;
   		EXCEL_FORM._mtd       = "getList";
   		EXCEL_FORM.excelFlag  = "Y";
   		EXCEL_FORM.tranData   = [{outDs : "gridList", _siq : "dp.salesPerform.lamCons"}];
   		
   		gfn_service({
			url    : GV_CONTEXT_PATH + "/biz/obj.do",
			data   : EXCEL_FORM,
			success: function(data) {
				
				var gridListExcel = [];
				$.each(data.gridList, function(idx, item) {
					if (item.GRP_LVL_ID == "0" && item.ITEM_AUTH_NM == "Y") {
						gridListExcel.push(item);
					}
				});
				
				lamCons.grid.dataProviderExcel.clearRows();
				lamCons.grid.grdMainExcel.cancel();
				lamCons.grid.dataProviderExcel.setRows(gridListExcel);
				lamCons.grid.dataProviderExcel.clearSavePoints();
				lamCons.grid.dataProviderExcel.savePoint();
				
				var lamData = new Array();
				
				$.each(gridListExcel, function(n, v){
					
					var grpLvlId = v.GRP_LVL_ID;
					var itemAuth = v.ITEM_AUTH;
	   				
	   				if(grpLvlId == 0 && itemAuth == "Y"){
	   					lamData.push(n);
	   				}
	    		});
				
				lamCons.grid.grdMainExcel.setCellStyles(lamData, "MIN_QTY", "editStyleExcel");
				lamCons.grid.grdMainExcel.setCellStyles(lamData, "MAX_QTY", "editStyleExcel");
				lamCons.grid.grdMainExcel.setCellStyles(lamData, "LAST_USG_QTY", "editStyleExcel");
				lamCons.grid.grdMainExcel.setCellStyles(lamData, "INV_QTY", "editStyleExcel");
				
				$.each(BUCKET.query, function(n, v) {
					
					var cd = v.CD;
					
					if(cd.indexOf("M") == -1){
						lamCons.grid.grdMainExcel.setCellStyles(lamData, cd, "editStyleExcel");
					}
				});
				
				gfn_doExportExcel({
					gridIdx            : 1,
					fileNm             : "${menuInfo.menuNm} ("+$("#planId").val()+")",
					formYn             : "Y",
					indicator          : "hidden",
					conFirmFlag        : false,
					applyDynamicStyles : true
				});
			}
		}, "obj"); 
	}
	
	function fn_excelUpload(){
		
		gfn_importGrid({
			gridIdx  : 1,
			callback : function() {
				
				lamCons.grid.dataProviderExcel.clearSavePoints(); //그리드 초기화 포인트 저장
				lamCons.grid.dataProviderExcel.savePoint();
				
				$("#realgrid").hide(); // 메인그리드 숨기기
				$("#realgridExcel").show(); // 엑셀그리드 보이기
				
				lamCons.grid.grdMainExcel.resetSize();
			}
		});
	}
	
	
	function fn_save() {
		
		var jsonRows;
		var excelFlag = $("#realgrid").is(":visible");
		
		if(excelFlag){
			jsonRows = gfn_getGrdSavedataAll(lamCons.grid.grdMain);	
		}else{
			jsonRows = lamCons.grid.dataProviderExcel.getJsonRows();
		}
		
		if(jsonRows.length == 0){
			alert('<spring:message code="msg.noChangeData"/>');
			return;
		}
		
		confirm('<spring:message code="msg.saveCfm"/>', function() {
			
			var lamDataArr = [];
			
			$.each(jsonRows, function(i, row) {
				
				if(excelFlag){
					var lamData = {
						WARE_HOUSE_CD : row.WARE_HOUSE_CD
					  , ITEM_CD : row.ITEM_CD
					  , PLAN_ID : row.PLAN_ID
					  , BUCKET_LIST : []
					}	
				}else{
					var lamData = {
						WARE_HOUSE_CD : row.WARE_HOUSE_CD_NM
					  , ITEM_CD : row.ITEM_CD_NM
					  , PLAN_ID : row.PLAN_ID_NM
					  , BUCKET_LIST : []
					}
				}
				
				$.each(row, function(attr, value) {
					
					if(attr.indexOf("MIN_QTY") == 0 || attr.indexOf("MAX_QTY") == 0 || attr.indexOf("INV_QTY") == 0){
						var measCd = gfn_replaceAll(attr, "_QTY", "");
						
						lamData.BUCKET_LIST.push({
							YEARWEEK   : 'NULL',
							QTY        : value == undefined ? 'NULL' : value,
							MEAS_CD    : measCd,
							FLAG       : 1
						});
					}else if(attr.indexOf("LAST_USG_QTY") == 0){
						
						lamData.BUCKET_LIST.push({
							YEARWEEK   : 'NULL',
							QTY        : value == undefined ? 'NULL' : value,
							MEAS_CD    : "USG",
							FLAG       : 2
						});
					}else if(attr.indexOf("PW") == 0){
						
						var yearWeek = gfn_replaceAll(attr, "PW", "");
						
						lamData.BUCKET_LIST.push({
							YEARWEEK   : yearWeek,
							QTY        : value == undefined ? 'NULL' : value,
							MEAS_CD    : "FCST",
							FLAG       : 3
						});
					}
				});
				lamDataArr.push(lamData);
			});
			
			FORM_SAVE              = {};
			FORM_SAVE._mtd         = "saveUpdate";
			FORM_SAVE.tranData     = [
				{outDs : "saveCnt1", _siq : "dp.salesPerform.lamCons", grdData : lamDataArr},
			];
			
			gfn_service({
				url    : GV_CONTEXT_PATH + "/biz/obj.do",
				data   : FORM_SAVE,
				success: function(data) {
					
					alert('<spring:message code="msg.saveOk"/>');
					fn_apply();
				}
			}, "obj");
		});
	}
	
	function fn_reset() {
		
		lamCons.grid.grdMain.cancel();
		lamCons.grid.dataProvider.rollback(lamCons.grid.dataProvider.getSavePoints()[0]);
		
		lamCons.grid.grdMain.setCellStyles(lamData, "MIN_QTY", "editStyle");
		lamCons.grid.grdMain.setCellStyles(lamData, "MAX_QTY", "editStyle");
		lamCons.grid.grdMain.setCellStyles(lamData, "LAST_USG_QTY", "editStyle");
		lamCons.grid.grdMain.setCellStyles(lamData, "INV_QTY", "editStyle");
		
		$.each(BUCKET.query, function(n, v) {
			
			var cd = v.CD;
			
			if(cd.indexOf("M") == -1){
				lamCons.grid.grdMain.setCellStyles(lamData, cd, "editStyle");
			}
		});
	}
	
	function fn_setBeforeFieldsBuket() {
		var fields = [
			{fieldName: "MIN_QTY", dataType : "number"},
			{fieldName: "MAX_QTY", dataType : "number"},
			{fieldName: "LAST_USG_QTY", dataType : "number"},
			{fieldName: "INV_QTY", dataType : "number"}
        ];
    	
    	return fields;
	}
	
	function fn_setBeforeColumnsBuket() {
		var columns = [	
			{
				name : "MIN_QTY", fieldName: "MIN_QTY", editable: false, header: {text: '<spring:message code="lbl.min2" javaScriptEscape="true" />'},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dataType : "number",
				nanText : "",
				width: 100
			}, {
				name : "MAX_QTY", fieldName: "MAX_QTY", editable: false, header: {text: '<spring:message code="lbl.max2" javaScriptEscape="true" />'},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dataType : "number",
				nanText : "",
				width: 100
			}, {
				name : "LAST_USG_QTY", fieldName: "LAST_USG_QTY", editable: false, header: {text: '<spring:message code="lbl.usage" javaScriptEscape="true" />'},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dataType : "number",
				nanText : "",
				width: 100
			}, {
				name : "INV_QTY", fieldName: "INV_QTY", editable: false, header: {text: '<spring:message code="lbl.inventory" javaScriptEscape="true" />'},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dataType : "number",
				nanText : "",
				width: 100
			}
		];
		return columns;
	}
	
	function fn_planId(){
		var params  = {};
		params.planId = $("#planId").val();
		params._mtd = "getList";
		params.tranData = [{outDs : "resList", _siq : "dp.salesPerform.lamConsPlanId"}];
		
		var opt = {
			url     : GV_CONTEXT_PATH + "/biz/obj.do",
			data    : params,
			async   : false,
			success : function(data) {
				
				var fromDate = data.resList[0].FROM_DATE;
		    	var toDate = data.resList[0].TO_DATE;
		    	
		    	DATEPICKET(null, fromDate, toDate);
			}
		};
		gfn_service(opt, "obj");
	}

	// onload 
	$(document).ready(function() {
		lamCons.init();
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
					<div class="view_combo" id="divPlanId"></div>
					<div class="view_combo" id="divItem"></div>
					<div class="view_combo" id="divSpec">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.spec"/></div>
							<input type="text" id="spec" name="spec" class="ipt"/>
						</div>
					</div>
					<div class="view_combo" id="divWareHouse"></div>
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
				<div id="realgrid" class="realgrid1"></div>
				<div id="realgridExcel" class="realgrid1" style="display:none;"></div>
			</div>
			<div class="cbt_btn" style="height:25px">
				<div class="bleft">
					<form id="excelForm" method="post" enctype="multipart/form-data">
						<input type="file" name="excelFile" id="excelFile" style="display: none;" />
						<input type="hidden" id="headerLine" name="headerLine" value="2" />
						<input type="hidden" id="columnNames" name="columnNames" />
					</form>
					<a href="javascript:;" id="btnExcelDown" class="app1 roleWrite"><spring:message code="lbl.excelDownload" /></a>
					<a href="javascript:;" id="btnExcelUpload" class="app1 roleWrite"><spring:message code="lbl.excelUpload" /></a>
				</div>
				<div class="bright">
					<a href="javascript:;" id="btnSummary" class="app1"><spring:message code="lbl.summary" /></a>
					<a href="javascript:;" id="btnReset" class="app1 roleWrite"><spring:message code="lbl.reset" /></a>
					<a href="javascript:;" id="btnSave" class="app1 roleWrite"><spring:message code="lbl.save" /></a>
				</div>
			</div>
		</div>
    </div>
</body>
</html>
