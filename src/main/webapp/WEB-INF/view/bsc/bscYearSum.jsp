<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp"%>
<script type="text/javascript" src="${ctx}/statics/js/biz/gridcalc.js" ></script>
<!-- BSC 품질 -->
	<script type="text/javascript">
	var yearInfo;
	var enterSearchFlag = "Y";
	var bscYearSum = {
		init : function () {
			gfn_formLoad();
			
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.bscGrid.initGrid();
		},
			
		_siq    : "bsc.bscYearSum",
		
		initFilter : function() {
			gfn_setMsComboAll([
				{target : 'divYear', id : 'year', title : '<spring:message code="lbl.year"/>', data : yearInfo, exData:["*"], type : "S" },
				{target : 'divMonthAcc', id : 'rdoAqType', title : '<spring:message code="lbl.monthAccFlag"/>', data : this.comCode.codeMap.MONTH_ACC_TYPE, exData:[""], type : "R"},
				{target : 'divBuCd', id : 'buCd', title : '<spring:message code="lbl.buName"/>', data : this.comCode.codeMapEx.BU_CD, exData:["*"], type : "S" },
				{target : 'divDivCd', id : 'divCd', title : '<spring:message code="lbl.salesOrgL3Name"/>', data : this.comCode.codeMapEx.DIV_CD, exData:["*"], type : "S" },
				{target : 'divTeamCd', id : 'teamCd', title : '<spring:message code="lbl.teamName"/>', data : this.comCode.codeMapEx.TEAM_CD, exData:[""]}
			]);
			
			$(':radio[name=rdoAqType]:input[value="MON"]').attr("checked", true);
			
			$("#year").val(new Date().getFullYear());
		},
		
		comCode : {
			codeMap : null,
			codeMapEx : null,
			
			initCode : function () {
				var grpCd = 'MONTH_ACC_TYPE';
				this.codeMap = gfn_getComCode(grpCd, 'N'); //공통코드 조회
				this.codeMapEx = gfn_getComCodeEx(["BU_CD", "DIV_CD", "TEAM_CD"], "N");
				
				gfn_service({
					async   : false,
					url     : GV_CONTEXT_PATH + "/biz/obj",
					data    : {_mtd : "getList", menuParam : "YP", tranData : [
						{outDs:"yearList",_siq:"dp.targetMgmt.yearlyPlanYear"}
					]},
					success : function(data) {
						yearInfo = data.yearList;
					}
				}, "obj");
				 
			}
		},
		
		/* 
		* grid  선언
		*/
		bscGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;

				this.setColumn();
				this.setFields();
				this.setOptions();
				//this.gridEvents();
				
				gfn_setMonthSum(bscYearSum.bscGrid.gridInstance, false, false, true);
			},
			
			setColumn     : function () {
				/* var totAr =  ['BU_NM', 'DIV_NM', 'TEAM_NM', 'PART_NM']; */
				var totAr =  ['DIV_NM', 'TEAM_NM', 'PART_NM', 'CATEGORY_NM'];
				var columns = 
				[
					{ 
						type      : "group",
						name      : "DIV", 
						header    : { fixedHeight : 20, text : "<spring:message code='lbl.division'/>" },
						width     : 460, 
						columns   : [
							{
								name      : "DIV_NM", 
								fieldName : "DIV_NM", 
								header    : { text : "<spring:message code='DIV_CD'/>" }, 
								styles    : { textAlignment : "near", background : gfn_getArrDimColor(1)},
								mergeRule : { criteria : "values['DIV_CD'] + value" },
								dynamicStyles:[gfn_getDynamicStyle(1, totAr)],
								width     : 150, 
								editable  : false 
							}, {
								name      : "TEAM_NM", 
								fieldName : "TEAM_NM", 
								header    : { text : "<spring:message code='TEAM_CD'/>" }, 
								styles    : { textAlignment : "near", background : gfn_getArrDimColor(2)},
								mergeRule : { criteria : "values['TEAM_CD'] + value" },
								dynamicStyles:[gfn_getDynamicStyle(2, totAr)],
								width     : 130, 
								editable  : false 
							}, {
								name      : "PART_NM", 
								fieldName : "PART_NM", 
								header    : { text : "<spring:message code='PART_CD'/>" }, 
								styles    : { textAlignment : "near", background : gfn_getArrDimColor(3)},
								dynamicStyles:[gfn_getDynamicStyle(3, totAr)],
								mergeRule : { criteria : "values['PART_CD'] + value" },
								width     : 80, 
								editable  : false 
							}, {
								name      : "CATEGORY_NM", 
								fieldName : "CATEGORY_NM", 
								header    : { text : "<spring:message code='PART_CD'/>" }, 
								styles    : { textAlignment : "near", background : gfn_getArrDimColor(3)},
								dynamicStyles:[gfn_getDynamicStyle(4, totAr)],
								mergeRule : { criteria : "values['CATEGORY_NM'] + value" },
								width     : 100, 
								editable  : false 
							}
						]
					}, { 
						type      : "group",
						name      : "YEAR", 
						header    : { fixedHeight : 20, text : "<spring:message code='lbl.bhs'/>" },
						width     : 906, 
						columns   : [
							{
								name      : "ONE_MONTH", 
								fieldName : "ONE_MONTH", 
								header    : { text : "<spring:message code='lbl.january'/>" }, 
								editor    : { type : "number", textAlignment : "far", editFormat : "#,##0.0", positiveOnly : true},
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.0"}, 
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "TWO_MONTH", 
								fieldName : "TWO_MONTH", 
								header    : { text : "<spring:message code='lbl.february'/>" }, 
								editor    : { type : "number", textAlignment : "far", editFormat : "#,##0.0", positiveOnly : true},
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.0"}, 
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "THREE_MONTH", 
								fieldName : "THREE_MONTH", 
								header    : { text : "<spring:message code='lbl.march'/>" }, 
								editor    : { type : "number", textAlignment : "far", editFormat : "#,##0.0", positiveOnly : true},
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.0"}, 
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "FOUR_MONTH", 
								fieldName : "FOUR_MONTH", 
								header    : { text : "<spring:message code='lbl.april'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.0"},
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "FIVE_MONTH", 
								fieldName : "FIVE_MONTH", 
								header    : { text : "<spring:message code='lbl.may'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"},
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "SIX_MONTH", 
								fieldName : "SIX_MONTH", 
								header    : { text : "<spring:message code='lbl.june'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"},
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "SEVEN_MONTH", 
								fieldName : "SEVEN_MONTH", 
								header    : { text : "<spring:message code='lbl.july'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"},
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "EIGHT_MONTH", 
								fieldName : "EIGHT_MONTH", 
								header    : { text : "<spring:message code='lbl.august'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"},
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "NINE_MONTH", 
								fieldName : "NINE_MONTH", 
								header    : { text : "<spring:message code='lbl.september'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"},
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "TEN_MONTH", 
								fieldName : "TEN_MONTH", 
								header    : { text : "<spring:message code='lbl.october'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"},
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "ELEVEN_MONTH", 
								fieldName : "ELEVEN_MONTH", 
								header    : { text : "<spring:message code='lbl.november'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"},
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "TWELVE_MONTH", 
								fieldName : "TWELVE_MONTH", 
								header    : { text : "<spring:message code='lbl.december'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"},
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "OMIT_FLAG", 
								fieldName : "OMIT_FLAG", 
								header    : { text : "<spring:message code='lbl.december'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"},
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								visible   : false,
								editable  : false 
							}
						]
					}, 
				];
				
				this.grdMain.setColumns(columns); 
			},
			
			setFields : function(cols) {
				
				var fields = new Array();
				
				fields = [
					{ fieldName : "DIV_CD", dataType : "text"},
					{ fieldName : "DIV_NM", dataType : "text"},
					{ fieldName : "TEAM_CD", dataType : "text"},
					{ fieldName : "TEAM_NM", dataType : "text"},
					{ fieldName : "PART_CD", dataType : "text"},
					{ fieldName : "PART_NM", dataType : "text"},
					{ fieldName : "CATEGORY_NM", dataType : "text"},
					{ fieldName : "OMIT_FLAG", dataType : "text"},
					
					{ fieldName : "ONE_MONTH", dataType : "number"},
					{ fieldName : "TWO_MONTH", dataType : "number"},
					{ fieldName : "THREE_MONTH", dataType : "number"},
					{ fieldName : "FOUR_MONTH", dataType : "number"},
					{ fieldName : "FIVE_MONTH", dataType : "number"},
					{ fieldName : "SIX_MONTH", dataType : "number"},
					{ fieldName : "SEVEN_MONTH", dataType : "number"},
					{ fieldName : "EIGHT_MONTH", dataType : "number"},
					{ fieldName : "NINE_MONTH", dataType : "number"},
					{ fieldName : "TEN_MONTH", dataType : "number" },
					{ fieldName : "ELEVEN_MONTH", dataType : "number"},
					{ fieldName : "TWELVE_MONTH", dataType : "number"}
				];
				
				this.dataProvider.setFields(fields);
			},
			
			setOptions : function () {
				this.grdMain.setOptions({
					stateBar: { visible      : true  },
					sorting : { enabled      : false },
					display : { columnMovable: false }
				});

				this.dataProvider.setOptions({
					softDeleting : true
				});
				
				this.grdMain.addCellStyles([{
					id         : "editStyle",
					editable   : true,
					background : gv_editColor
				}]);
				
				
				var group = this.grdMain.columnByName("DIV");
				if (group) {
					var hide = !this.grdMain.getColumnProperty(group, "hideChildHeaders");
					this.grdMain.setColumnProperty(group, "hideChildHeaders", hide);
				}
				
				var valArray = ["YEAR", "ONE_MONTH", "TWO_MONTH", "THREE_MONTH", "FOUR_MONTH", "FIVE_MONTH", "SIX_MONTH", "SEVEN_MONTH", "EIGHT_MONTH", "NINE_MONTH", "TEN_MONTH", "ELEVEN_MONTH", "TWELVE_MONTH"];
				var valArrayLen = valArray.length;
				var year = $("#year").val();
				
				for(var i = 0; i < valArrayLen; i++){
					var val = valArray[i];
					
					var setHeader = this.grdMain.getColumnProperty(val, "header");
					setHeader.styles = {background: gv_headerColor};
					this.grdMain.setColumnProperty(val, "header", setHeader);
					
					if(val == "YEAR"){
						this.grdMain.setColumnProperty(val, "header", year);
					}
				}
			},
			
		},
	
		/*
		* event 정의
		*/
		events : function () {
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("#buCd").on("change", function(e){
				bscYearSum.comCode.codeMapEx = gfn_getComCodeEx(["BU_CD", "DIV_CD", "TEAM_CD"], "N", {buCd : $("#buCd").val()});
				
				gfn_setMsComboAll([
					{target : 'divDivCd', id : 'divCd', title : '<spring:message code="lbl.salesOrgL3Name"/>', data : bscYearSum.comCode.codeMapEx.DIV_CD, exData:["*"], type : "S" },
					{target : 'divTeamCd', id : 'teamCd', title : '<spring:message code="lbl.teamName"/>', data : bscYearSum.comCode.codeMapEx.TEAM_CD, exData:[""]}
				]);
				$("#divCd").on("change", function(e){
					
					bscYearSum.comCode.codeMapEx = gfn_getComCodeEx(["BU_CD", "DIV_CD", "TEAM_CD"], "N", {buCd : $("#buCd").val(), divCd : $("#divCd").val()});
					
					gfn_setMsComboAll([
						{target : 'divTeamCd', id : 'teamCd', title : '<spring:message code="lbl.teamName"/>', data : bscYearSum.comCode.codeMapEx.TEAM_CD, exData:[""]}
					]);
				});
			});
			
			$("#divCd").on("change", function(e){
				
				bscYearSum.comCode.codeMapEx = gfn_getComCodeEx(["BU_CD", "DIV_CD", "TEAM_CD"], "N", {buCd : $("#buCd").val(), divCd : $("#divCd").val()});
				
				gfn_setMsComboAll([
					{target : 'divTeamCd', id : 'teamCd', title : '<spring:message code="lbl.teamName"/>', data : bscYearSum.comCode.codeMapEx.TEAM_CD, exData:[""]}
				]);
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
					if(id == "divYear"){
						EXCEL_SEARCH_DATA += $("#year").val();
					}else if(id == "divMonthAcc"){
						var monthAcc = $('input[name="rdoAqType"]:checked').val();
						
						if(monthAcc == "MON"){
							EXCEL_SEARCH_DATA += '<spring:message code="lbl.thisMonth"/>';
						}else if(monthAcc == "ACC"){
							EXCEL_SEARCH_DATA += '<spring:message code="lbl.cumulative"/>';
						}
					}else if(id == "divBuCd"){
						EXCEL_SEARCH_DATA += $("#buCd option:selected").text();
					}else if(id == "divDivCd"){
						EXCEL_SEARCH_DATA += $("#divCd option:selected").text();
					}else if(id == "divTeamCd"){
						$.each($("#teamCd option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}
					
				}
			});
			
			//console.log(EXCEL_SEARCH_DATA);
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
						bscYearSum.bscGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						bscYearSum.bscGrid.grdMain.cancel();
						
						bscYearSum.bscGrid.dataProvider.setRows(data.resList);
						bscYearSum.bscGrid.dataProvider.clearSavePoints();
						bscYearSum.bscGrid.dataProvider.savePoint(); //초기화 포인트 저장
						
						gfn_actionMonthSum(bscYearSum.bscGrid.gridInstance);
						
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		getBucket : function (sqlFlag) {
			var ajaxMap = {
				fromDate : gfn_replaceAll($("#year").val(), "-", ""),
				/* toDate : gfn_replaceAll($("#year").val(), "-", "") + "1231", */
				month : {isDown : "Y", isUp : "N", upCal : "Q", isMt : "N", isExp : "N", expCnt : 999},
				sqlId : ["bsc.bscYearSumBucket"]
			}
			
			gfn_getBucket(ajaxMap);
			
			var subBucket = new Array();
			
			subBucket = [
				{CD : "WEIGHT_RATE", NM : '<spring:message code="lbl.plan"/>'},
				{CD : "BSC_SCORE", NM : '<spring:message code="lbl.result"/>'},
				{CD : "WEIGHT_SCORE", NM : '<spring:message code="lbl.result"/>'}
			];
			gfn_setCustBucket(subBucket);
			
			if(!sqlFlag){
				//bscYearSum.bscGrid.gridInstance.setDraw();
			} 
		}
		
	};
	
	//조회
	var fn_apply = function (sqlFlag) {
		
		
		var tBuCd = $("#buCd").val();
		var tDivCd = $("#divCd").val();
		
		if(tBuCd == ""){
			alert('<spring:message code="msg.buCdMsg"/>');
			return;
		}
		
		if(tDivCd == ""){
			alert('<spring:message code="msg.divCdMsg"/>');
			return;
		}
		
		gfn_getMenuInit();
		
		bscYearSum.getBucket(sqlFlag); //2. 버켓정보 조회
		
		FORM_SEARCH     = $("#searchForm").serializeObject(); //초기화
		FORM_SEARCH.sql = sqlFlag;
		FORM_SEARCH.meaList    = MEASURE.user;
		FORM_SEARCH.bucketList = BUCKET.query;
		
		bscYearSum.search();
		bscYearSum.excelSubSearch();
	}
	
	function fn_checkClose() {
		return gfn_getGrdSaveCount(bscYearSum.bscGrid.grdMain) == 0;
	}

	// onload 
	$(document).ready(function() {
		bscYearSum.init();
	});

	</script>

</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp"%>
	<!-- contents -->
	<div id="a" class="split content split-horizontal">
		<form id="searchForm" name="searchForm">
		<div id="filterDv">
			<div class="inner">
				<h3>Filter</h3>
				<%@ include file="/WEB-INF/view/common/filterMonthSum.jsp"%>
				<div class="tabMargin"></div>
				<div class="scroll">
					<div class="view_combo" id="divYear"></div>
					<div class="view_combo" id="divMonthAcc"></div>
					<div class="view_combo" id="divBuCd"></div>
					<div class="view_combo" id="divDivCd"></div>
					<div class="view_combo" id="divTeamCd"></div>
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
			<%-- 
			<div class="cbt_btn roleWrite">	
				<div class="bright">
					<a id="btnReset"       href="#" class="app1"><spring:message code="lbl.reset" /></a>  
					<a id="btnSave"        href="#" class="app2"><spring:message code="lbl.save" /></a>
				</div>
			</div> --%>
		</div>
	</div>
</body>
</html>
