<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	
	<script type="text/javascript">
	var searchData = null;
	var enterSearchFlag = "Y";
	var dailyPlanVsActual = {

		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.dailyPlanVsActualGrid.initGrid();
			this.events();
		},
			
		_siq    : "aps.planResult.dailyPlanVsActual",
		/*
		* common Code 
		*/
		comCode : {
			codeMapEx : null,			
			codeMap : null,
			
			initCode : function () {
				var grpCd = 'PROD_PART,WORKER_GROUP';
				this.codeMap = gfn_getComCode(grpCd, 'N'); 
				this.codeMapEx = gfn_getComCodeEx(["ITEM_GROUP"], null, {itemType : ""});
			}
		},
		
		initFilter : function() {
			
			gfn_keyPopAddEvent([
				{ target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>' }
			]);
			
			fn_getJobCd();
			
			gfn_setMsComboAll([
				{ target : 'divProdPart', id : 'prodPart', title : '<spring:message code="lbl.prodPart2"/>', data : this.comCode.codeMap.PROD_PART, exData:["*"]},
				{ target : 'divWorkerGroup', id : 'workerGroup', title : '<spring:message code="lbl.workerGroup"/>', data : this.comCode.codeMap.WORKER_GROUP, exData:[""]},
				{ target : 'divItemGroup', id : 'itemGroup', title : '<spring:message code="lbl.itemGroup"/>', data : this.comCode.codeMapEx.ITEM_GROUP, exData:["*"], option: {allFlag:"Y"} }
			]);
			
			var dateParam = {
				arrTarget : [
					{calId : "fromCal", weekId : "fromWeek", defVal : 0},
					{calId : "toCal", weekId : "toWeek", defVal : 1}
				]
			};
			DATEPICKET(dateParam);
			
			dayDate();
			
		},
		 
		/* grid  선언
		*/
		dailyPlanVsActualGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				this.gridInstance.custBucketFalg = true;
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
					
				

				this.grdMain.setColumnProperty("REMARKS_PP", "editor", {type : "multiline"});
				this.grdMain.setColumnProperty("REMARKS_PP", "styles", {textWrap : "normal"});
				this.grdMain.setDisplayOptions({eachRowResizable : true})
				
				this.grdMain.setOptions({
					stateBar: { visible : true },
				});
				
				this.grdMain.addCellStyles([{
					id         : "editStyle",
					editable   : true,
					background : gv_editColor
				}]);
				
				this.grdMain.addCellStyles([{
					id         : "noneEditStyle",
					editable   : false,
					background : gv_totalColor
				}]);
				
				this.grdMain.addCellStyles([{
					id         : "noneEditStyleSubTotal",
					editable   : false,
					background : gv_noneEditColor
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
			
			$("#btnSave").on("click", function(e) {
				
				dailyPlanVsActual.save();
				
			});
			
			
			$("#btnReset").on('click', function (e) {
				
				dailyPlanVsActual.dailyPlanVsActualGrid.grdMain.cancel();
				dailyPlanVsActual.dailyPlanVsActualGrid.dataProvider.rollback(dailyPlanVsActual.dailyPlanVsActualGrid.dataProvider.getSavePoints()[0]);
				
				if(searchData!=null)
				{
					dailyPlanVsActual.gridCallback(searchData);
					dailyPlanVsActual.dailyPlanVsActualGrid.grdMain.fitRowHeightAll(0, true);
				}
				
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
					
					if(id == "divStandDate"){
						EXCEL_SEARCH_DATA += $("#fromCal").val() + "(" + $("#fromWeek").val() + ")";
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
					}else if(id == "divWorkplaces"){
						EXCEL_SEARCH_DATA += $("#workplaces").val();
					}else if(id == "divResource2"){
						EXCEL_SEARCH_DATA += $("#resource2").val();
					}else if(id == "divWorkerGroup"){
						$.each($("#workerGroup option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divJobCd"){
						$.each($("#jobCd option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divWoNo"){
						EXCEL_SEARCH_DATA += $("#woNo").val();
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
					}else if(id == "divItem"){
						EXCEL_SEARCH_DATA += $("#item_nm").val();
					}
				}
			});
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
						dailyPlanVsActual.dailyPlanVsActualGrid.dataProvider.clearRows(); //데이터 초기화
						
						//그리드 데이터 생성
						dailyPlanVsActual.dailyPlanVsActualGrid.grdMain.cancel();
						
						dailyPlanVsActual.dailyPlanVsActualGrid.dataProvider.setRows(data.resList);
						dailyPlanVsActual.dailyPlanVsActualGrid.dataProvider.clearSavePoints();
						dailyPlanVsActual.dailyPlanVsActualGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(dailyPlanVsActual.dailyPlanVsActualGrid.dataProvider.getRowCount());
						//gfn_actionMonthSum(dailyPlanVsActual.dailyPlanVsActualGrid.gridInstance);
						gfn_setRowTotalFixed(dailyPlanVsActual.dailyPlanVsActualGrid.grdMain);
						dailyPlanVsActual.gridCallback(data.resList);
						dailyPlanVsActual.dailyPlanVsActualGrid.grdMain.fitRowHeightAll(0, true);
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		gridCallback : function(resList){
			
			for (var i = resList.length-1; i >= 0; i--) 
			{
				if(resList[i].GRP_LVL_ID!= 0 )
				{
					if(i==0)
					{
						//TOTAL 수정 못하게 막기
						dailyPlanVsActual.dailyPlanVsActualGrid.grdMain.setCellStyles(i,"REMARKS_PP","noneEditStyle");
					}
					else
					{	
						//SUB TOTAL 수정 못하게 막기
						dailyPlanVsActual.dailyPlanVsActualGrid.grdMain.setCellStyles(i,"REMARKS_PP","noneEditStyleSubTotal");
					}
				}
			}
		},
		
		save : function(){
			
			//var dateChk = 0;
			var grdData = gfn_getGrdSavedataAll(this.dailyPlanVsActualGrid.grdMain);
			var grdDataLen = grdData.length;
			
			for(i=0;i<grdData.length;i++)
			{
				grdData[i].UPDATE_ID = "${sessionScope.userInfo.userId}";	
			}
			
			
			if (grdDataLen == 0) {
				alert('<spring:message code="msg.noChangeData"/>');
				return;
			}
			
			/*
			if(dateChk > 0){
				alert(dateChk + '<spring:message code="msg.dueDateChk"/>')
				return;
			}
			*/
			confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
				
				FORM_SAVE            = {}; //초기화
				FORM_SAVE._mtd       = "saveUpdate";
				FORM_SAVE.tranData   = [
					{outDs : "saveCnt", _siq : "aps.planResult.dailyPlanVsActual", grdData : grdData}
				];
				
				var ajaxOpt = {
					url     : GV_CONTEXT_PATH + "/biz/obj.do",
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
		
		gfn_getMenuInit();
		
    	if(!sqlFlag){
    		dailyPlanVsActual.dailyPlanVsActualGrid.gridInstance.setDraw();
		}		
		//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
    	FORM_SEARCH.dimList    = DIMENSION.user;
    	FORM_SEARCH.hiddenList = DIMENSION.hidden;
    	FORM_SEARCH.meaList	   = MEASURE.next;
    			
		dailyPlanVsActual.search();
		dailyPlanVsActual.excelSubSearch();
	}
	
	function fn_getJobCd() {
		
		var params  = {};
		params._mtd = "getList";
		params.tranData = [{outDs : "resList", _siq : "aps.planResult.jobCd"}];
		
		
		var opt = {
			url     : GV_CONTEXT_PATH + "/biz/obj.do",
			data    : params,
			async   : false,
			success : function(data) {
				
				gfn_setMsComboAll([
					{target : 'divJobCd', id : 'jobCd', title : '<spring:message code="lbl.jobCd"/>', data : data.resList, exData:[""]}
				]);
				
			}
		};
		gfn_service(opt, "obj");
		
	}
	
	function dayDate(){
		
		var params  = {};
		params._mtd = "getList";
		params.tranData = [{outDs : "resList", _siq : "aps.planResult.commonDay"}];
		
		var opt = {
			url     : GV_CONTEXT_PATH + "/biz/obj.do",
			data    : params,
			async   : false,
			success : function(data) {
				var list = data.resList;
				var listLen = list.length;
				
			    var d = new Date();
			    d.setDate(d.getDate() - 30);
			    var d1 = new Date();
			    d1.setDate(d1.getDate() - 1); //default 어제
			  
			    $("#fromCal").datepicker("option", "minDate", d);
			    $("#fromCal").datepicker("option", "maxDate", d1);
			}
		};
		gfn_service(opt, "obj");
	}

	$(document).ready(function() {
		dailyPlanVsActual.init();
	});
	
	function fn_setFieldsBuket() {
    	//필드 배열 객체를  생성합니다.
        var fields = [
        	{fieldName : "PROD_ORDER_QTY", dataType : "number"},
            {fieldName : "PLAN_QTY", dataType : "number"},
            {fieldName : "GOODS_QTY", dataType : "number"},
            {fieldName : "PRE_PROD_QTY", dataType : "number"},
            {fieldName : "EXECUTION_RATE", dataType : "number"},
            {fieldName : "PLAN_DATE"},
            {fieldName : "START_DTTM", dataType : "datetime"},
            {fieldName : "END_DTTM", dataType : "datetime"},
            {fieldName : "REMARKS_PP"}
        ];
    	
    	return fields;
    }

    function fn_setColumnsBuket() {
    	//필드와 연결된 컬럼 배열 객체를 생성합니다.
        var columns = 
		[	
			
			{	//오더수량
				name : "PROD_ORDER_QTY", fieldName: "PROD_ORDER_QTY", editable: false, header: {text: '<spring:message code="lbl.prodOrderQty3" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", numberFormat : "#,##0", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 100
			},
			{	//계획 수량
				name : "PLAN_QTY", fieldName: "PLAN_QTY", editable: false, header: {text: '<spring:message code="lbl.planQty2nd" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", numberFormat : "#,##0", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 100
			}, 
			{ //실적 수량
				name : "GOODS_QTY", fieldName: "GOODS_QTY", editable: false, header: {text: '<spring:message code="lbl.resultQty" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", numberFormat : "#,##0", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 100
			}, { //선생 생산
				name : "PRE_PROD_QTY", fieldName: "PRE_PROD_QTY", editable: false, header: {text: '<spring:message code="lbl.precedProd2" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", numberFormat : "#,##0", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 100
			}, { //실행률
				name : "EXECUTION_RATE", fieldName: "EXECUTION_RATE", editable: false, header: {text: '<spring:message code="lbl.cmplRateChart" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", numberFormat : "#,##0", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 100 
			}, { //계획 일자
				name : "PLAN_DATE", fieldName : "PLAN_DATE", editable: false, header : {text: '<spring:message code="lbl.planDate2nd" javaScriptEscape="true" />'},
				styles : {textAlignment : "center", datetimeFormat : "yyyy-MM-dd", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				width : 100
				
			}, { //작업시작 계획
				name : "START_DTTM", fieldName : "START_DTTM", editable: false, header : {text: '<spring:message code="lbl.startDttm" javaScriptEscape="true" />'},
				styles : {textAlignment : "center", datetimeFormat : "yyyy-MM-dd", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				nanText : "",
				width : 100
			}, { //작업종료 계획
				name : "END_DTTM", fieldName : "END_DTTM", editable: false, header : {text: '<spring:message code="lbl.endDttm" javaScriptEscape="true" />'},
				styles : {textAlignment : "center", datetimeFormat : "yyyy-MM-dd", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				nanText : "",
				width : 100
				
			},
			{ //비고
				name : "REMARKS_PP", 
				fieldName : "REMARKS_PP", 
				editable: true, 
				header : {text: '<spring:message code="lbl.remark2" javaScriptEscape="true" />'},
				editor : { type: "multiline", textCase: "upper" },
				styles : {textAlignment: "near",textWrap: 'explicit',background : gv_editColor},
				width : 100
				
			},
		];
    	return columns;
    }
	
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
					
					<div class="view_combo" id="divStandDate">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.standDate"/></div>
							<input type="text" id="fromCal" name="fromCal" class="iptdate datepicker2" onchange="javascript:dayDate();"/>
							<input type="text" id="fromWeek" name="fromWeek" class="iptdateweek" disabled="disabled" value=""/>
							<input type="hidden" id="toCal" name="toCal"/>
							<input type="hidden" id="toWeek" name="toWeek"/>
							<input type="hidden" id="swFromDate" name="swFromDate"/>
							<input type="hidden" id="swToDate" name="swToDate"/>
							<input type="hidden" id="prodFromDate" name="prodFromDate"/>
							<input type="hidden" id="prodToDate" name="prodToDate"/>
							<input type="hidden" id="prodFromDate2" name="prodFromDate2"/>
							<input type="hidden" id="prodToDate2" name="prodToDate2"/>
							<input type="hidden" id="salesFromDate" name="salesFromDate"/>
							<input type="hidden" id="salesToDate" name="salesToDate"/>
						</div>
					</div>
					<div class="view_combo" id="divProdPart"></div>
					<div class="view_combo" id="divWorkplaces">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.workplaces" /></div>
							<input type="text" id="workplaces" name="workplaces" class="ipt"/>
						</div>
					</div>
					<div class="view_combo" id="divResource2">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.resource2" /></div>
							<input type="text" id="resource2" name="resource2" class="ipt"/>
						</div>
					</div>
					<div class="view_combo" id="divWorkerGroup"></div>
					<div class="view_combo" id="divJobCd"></div>
					<div class="view_combo" id="divWoNo">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.woNo" /></div>
							<input type="text" id="woNo" name="woNo" class="ipt"/>
						</div>
					</div>
					<div class="view_combo" id="divItemGroup"></div>
					<div class="view_combo" id="divItem"></div>
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
			
			<!-- 하단버튼 영역 -->
			<div class="cbt_btn roleWrite">
				<div class="bright">
					<a id="btnReset"href="#" class="app1"><spring:message code="lbl.reset" /></a>
					<a id="btnSave" href="#" class="app2"><spring:message code="lbl.save" /></a>
				</div>
			</div>
			
		</div>
    </div>
</body>
</html>
