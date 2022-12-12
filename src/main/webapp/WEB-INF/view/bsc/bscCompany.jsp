<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp"%>
<!-- BSC 품질 -->
	<script type="text/javascript">

	var enterSearchFlag = "Y";
	var rowsPasteObj = [], changeMap = [];
	
	var bscCompany = {

		init : function () {
			
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.comCode.initCode();
			this.events();
			this.bscGrid.initGrid();
			
			MONTHPICKER(null, 0, 0);
			var baseDt = new Date();
			$("#fromMon").monthpicker("option", "maxDate", new Date(baseDt.getFullYear(), baseDt.getMonth(), '01'));
		},
		
		
		comCode : {
			codeMap : null,
			
			initCode  : function () {
				this.codeMap = gfn_getComCode("BSC_GRADE_CD", 'N');
			}
		},
			
		_siq    : "bsc.bscCompany",
		
		initFilter : function() {
			gfn_setMsComboAll([
				{target : 'divMonthAcc', id : 'rdoAqType', title : '<spring:message code="lbl.monthAccFlag"/>', data : this.comCode.codeMap.MONTH_ACC_TYPE, exData:[""], type : "R"},
			]);
			
			$(':radio[name=rdoAqType]:input[value="MON"]').attr("checked", true);
		},
		
		comCode : {
			codeMap : null,
			codeReptMap : null,
			
			initCode : function () {
				var grpCd = 'MONTH_ACC_TYPE';
				this.codeMap = gfn_getComCode(grpCd, 'N'); //공통코드 조회
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
				
				this.events();
			},
			
			setColumn     : function () {
				var totAr =  ['BU_NM', 'DIV_NM', 'TEAM_NM', 'PART_NM'];
				var columns = 
				[
					{ 
						type      : "group",
						name      : "DIV", 
						header    : { fixedHeight : 20, text : "<spring:message code='lbl.division'/>" },
						width     : 460, 
						columns   : [
							{
								name      : "BU_NM", 
								fieldName : "BU_NM", 
								header    : { text : "<spring:message code='BU_CD'/>" }, 
								styles    : { textAlignment : "near", background : gfn_getArrDimColor(0)},
								mergeRule : { criteria : "values['BU_CD'] + value" },
								dynamicStyles:[gfn_getDynamicStyle(0, totAr)],
								width     : 100, 
								editable  : false 
							}, {
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
							}
						]
					}, { 
						type      : "group",
						name      : "ALL", 
						header    : { fixedHeight : 20, text : "<spring:message code='lbl.total'/>" },
						width     : 270, 
						columns   : [
							{
								name      : "HDR_WEIGHT_RATE", 
								fieldName : "HDR_WEIGHT_RATE", 
								header    : { text : "<spring:message code='lbl.weighted'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.00"}, 
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 100, 
								editable  : false 
							}, {
								name      : "TOT_BSC_VAL", 
								fieldName : "TOT_BSC_VAL", 
								header    : { text : "<spring:message code='lbl.bscScore'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"},
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 100, 
								editable  : false 
							}, {
								name      : "TOT_BSC_GRADE", 
								fieldName : "TOT_BSC_GRADE", 
								header    : { text : "<spring:message code='lbl.class'/>" }, 
								styles    : { textAlignment : "center", background : gv_noneEditColor},
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 70, 
								editable  : false 
							}
						]
					}, { 
						type      : "group",
						name      : "QC_ALL", 
						header    : { fixedHeight : 20, text : "<spring:message code='lbl.qualityTotal'/>" },
						width     : 160, 
						columns   : [
							{
								name      : "QC_WEIGHT_RATE", 
								fieldName : "QC_WEIGHT_RATE", 
								header    : { text : "<spring:message code='lbl.weighted'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.00"}, 
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "QC_BSC_VAL", 
								fieldName : "QC_BSC_VAL", 
								header    : { text : "<spring:message code='lbl.bscScore'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"},
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}
						]
					}, { 
						type      : "group",
						name      : "SALES_ALL", 
						header    : { fixedHeight : 20, text : "<spring:message code='lbl.salesProfitTotal'/>" },
						width     : 160, 
						columns   : [
							{
								name      : "SALES_WEIGHT_RATE", 
								fieldName : "SALES_WEIGHT_RATE", 
								header    : { text : "<spring:message code='lbl.weighted'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.00"}, 
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "SALES_BSC_VAL", 
								fieldName : "SALES_BSC_VAL", 
								header    : { text : "<spring:message code='lbl.bscScore'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"},
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}
						]
					}, { 
						type      : "group",
						name      : "INV_ALL", 
						header    : { fixedHeight : 20, text : "<spring:message code='lbl.ibt'/>" },
						width     : 160, 
						columns   : [
							{
								name      : "INV_WEIGHT_RATE", 
								fieldName : "INV_WEIGHT_RATE", 
								header    : { text : "<spring:message code='lbl.weighted'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.00"}, 
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "INV_BSC_VAL", 
								fieldName : "INV_BSC_VAL", 
								header    : { text : "<spring:message code='lbl.bscScore'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"},
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}
						]
					
					}, { 
						type      : "group",
						name      : "SNOP_ALL", 
						header    : { fixedHeight : 20, text : "<spring:message code='lbl.snopTotal'/>" },
						width     : 160, 
						columns   : [
							{
								name      : "SNOP_WEIGHT_RATE", 
								fieldName : "SNOP_WEIGHT_RATE", 
								header    : { text : "<spring:message code='lbl.weighted'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.00"}, 
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "SNOP_BSC_VAL", 
								fieldName : "SNOP_BSC_VAL", 
								header    : { text : "<spring:message code='lbl.bscScore'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"},
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}
						]
					}, { 
						type      : "group",
						name      : "INOVATION_ALL", 
						header    : { fixedHeight : 20, text : "<spring:message code='lbl.inovationTotal'/>" },
						width     : 160, 
						columns   : [
							{
								name      : "INVT_WEIGHT_RATE", 
								fieldName : "INVT_WEIGHT_RATE", 
								header    : { text : "<spring:message code='lbl.weighted'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.00"}, 
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "INVT_BSC_VAL", 
								fieldName : "INVT_BSC_VAL", 
								header    : { text : "<spring:message code='lbl.bscScore'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"},
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}
						]
					}, { 
						type      : "group",
						name      : "GWP_ALL", 
						header    : { fixedHeight : 20, text : "<spring:message code='lbl.gwpTotal'/>" },
						width     : 160, 
						columns   : [
							{
								name      : "GWP_WEIGHT_RATE", 
								fieldName : "GWP_WEIGHT_RATE", 
								header    : { text : "<spring:message code='lbl.weighted'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.00"}, 
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "GWP_BSC_VAL", 
								fieldName : "GWP_BSC_VAL", 
								header    : { text : "<spring:message code='lbl.bscScore'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"},
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}
						]
					}
				];
				
				this.grdMain.setColumns(columns); 
			},
			
			setFields : function(cols) {
				
				var fields = new Array();
				
				fields = [
					{ fieldName : "YEARMONTH"    , dataType : "text" },
					{ fieldName : "GRP_LVL_ID"   , dataType : "text" },
					{ fieldName : "BU_CD"        , dataType : "text" },
					{ fieldName : "BU_NM"        , dataType : "text" },
					{ fieldName : "DIV_CD"       , dataType : "text" },
					{ fieldName : "DIV_NM"       , dataType : "text" },
					{ fieldName : "TEAM_CD"      , dataType : "text" },
					{ fieldName : "TEAM_NM"      , dataType : "text" },
					{ fieldName : "PART_CD"      , dataType : "text" },
					{ fieldName : "PART_NM"      , dataType : "text" },
					
					{ fieldName : "HDR_WEIGHT_RATE"   , dataType : "number" },
					{ fieldName : "TOT_BSC_VAL"       , dataType : "number" },
					{ fieldName : "TOT_BSC_GRADE"     , dataType : "text"  },
					
					{ fieldName : "QC_WEIGHT_RATE"    , dataType : "number" },
					{ fieldName : "QC_BSC_VAL"        , dataType : "number" },

					{ fieldName : "SALES_WEIGHT_RATE" , dataType : "number" },
					{ fieldName : "SALES_BSC_VAL"     , dataType : "number" },

					{ fieldName : "INV_WEIGHT_RATE"   , dataType : "number" },
					{ fieldName : "INV_BSC_VAL"       , dataType : "number" },
					
					{ fieldName : "SNOP_WEIGHT_RATE"  , dataType : "number" },
					{ fieldName : "SNOP_BSC_VAL"      , dataType : "number" },
					
					{ fieldName : "INVT_WEIGHT_RATE"  , dataType : "number" },
					{ fieldName : "INVT_BSC_VAL"      , dataType : "number" },
					
					{ fieldName : "GWP_WEIGHT_RATE"   , dataType : "number" },
					{ fieldName : "GWP_BSC_VAL"       , dataType : "number" },
					{ fieldName : "TOT_WEIGHT_RATE"   , dataType : "number" },
					
					
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
				
				var valArray = ["ALL", "HDR_WEIGHT_RATE", "TOT_BSC_VAL", "TOT_BSC_GRADE", "SALES_ALL", "SALES_WEIGHT_RATE", "SALES_BSC_VAL", "SNOP_ALL", "SNOP_WEIGHT_RATE", "SNOP_BSC_VAL", "GWP_ALL", "GWP_WEIGHT_RATE", "GWP_BSC_VAL"];
				var valArrayLen = valArray.length;
				
				for(var i = 0; i < valArrayLen; i++){
					var val = valArray[i];
					
					var setHeader = this.grdMain.getColumnProperty(val, "header");
					setHeader.styles = {background: gv_headerColor};
					this.grdMain.setColumnProperty(val, "header", setHeader);
				}
			},
			
			gridCallback : function () {
				
				var baseDt = new Date();
				var yymm = baseDt.getFullYear() + '' + (baseDt.getMonth() + 1 < 10 ? '0' + (baseDt.getMonth() + 1) : baseDt.getMonth() + 1);
				var yymmBefore = baseDt.getFullYear() + '' + (baseDt.getMonth() + 1 < 10 ? '0' + (baseDt.getMonth()) : baseDt.getMonth());
				var tFromMon = FORM_SEARCH.fromMon;
				var tRdoAqType = $('input:radio[name="rdoAqType"]:checked').val();
				var rowCnt = this.dataProvider.getRowCount();
				
				if(rowCnt > 0){
					bscCompany.bscGrid.setTotal(tFromMon);
				}
				
				if (!(yymm == tFromMon || yymmBefore == tFromMon) || tRdoAqType == "ACC") {
					return false;
				}
				
				var cols     = this.grdMain.getColumnNames();
				var targetAr1 = new Array();
				var arrIdx1   = new Array();
				
				for (var i = 0; i < rowCnt; i++) {
					// 조건
					if (this.dataProvider.getValue(i, "GRP_LVL_ID") == '3') {
						arrIdx1.push(i);
					}
				}
				
				for (var j = 0; j < cols.length; j++) {
					
					if (cols[j].indexOf("HDR_WEIGHT_RATE") > -1) {
						targetAr1.push(cols[j])
					}
				}
			
				this.grdMain.setCellStyles(arrIdx1, targetAr1 , "editStyle");
			},
			
			setTotal : function (yymm) {
				this.grdMain.commit();
				
				var current = this.grdMain.getCurrent();
				var row     = current.dataRow;
				var setCols = {
					YEARMONTH     : yymm,
					GRP_LVL_ID    : 15,
					BU_CD         : null,
					BU_NM         : 'Total',
					TOT_BSC_VAL   : null,
					TOT_BSC_GRADE : null
				};
				
				this.dataProvider.insertRow(0, setCols);
				var json = this.dataProvider.getJsonRow(2);
				gridCalc(2, 10, json.HDR_WEIGHT_RATE, json.HDR_WEIGHT_RATE);

				this.dataProvider.setRowState(0, 'none');
			},
			
			events   : function () {
				this.grdMain.onEditRowChanged = function (grid, itemIndex, dataRow, field, oldValue, newValue) {
					gridCalc(dataRow, field, oldValue, newValue);
				};

				this.grdMain.onEditRowPasted = function(grid, itemIndex, dataRow, fields, oldValues, newValues) {
					
					if (fields.length == newValues.length) {
						gridCalc(dataRow, field, oldValues, newValues);
					} else {
						var arrNewVal = [];
						$.each(fields, function(n,v) {
							arrNewVal.push(newValues[v]);
						});
						gridCalc(dataRow, oldValues, arrNewVal);
					}
					
				};
			},
		},
	
		/*
		* event 정의
		*/
		events : function () {
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("#btnSave").on('click', function (e) {
				bscCompany.save();
			});
			
			$("#btnReset").on('click', function (e) {
				bscCompany.bscGrid.grdMain.cancel();
				bscCompany.bscGrid.dataProvider.rollback(bscCompany.bscGrid.dataProvider.getSavePoints()[0]);
				bscCompany.bscGrid.gridCallback();
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
					if(id == "divMonthAcc"){
						var monthAcc = $('input[name="rdoAqType"]:checked').val();
						
						if(monthAcc == "MON"){
							EXCEL_SEARCH_DATA += '<spring:message code="lbl.thisMonth"/>';
						}else if(monthAcc == "ACC"){
							EXCEL_SEARCH_DATA += '<spring:message code="lbl.cumulative"/>';
						}
					}else if(id == "divMonth"){
						EXCEL_SEARCH_DATA += $("#fromMon").val();			
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
						bscCompany.bscGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						bscCompany.bscGrid.grdMain.cancel();
						
						bscCompany.bscGrid.dataProvider.setRows(data.resList);
						bscCompany.bscGrid.dataProvider.clearSavePoints();
						bscCompany.bscGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(bscCompany.bscGrid.dataProvider.getRowCount());
						
						bscCompany.bscGrid.gridInstance.setFocusKeys();
						bscCompany.bscGrid.gridCallback();
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		save : function() {
			
			var grdData = gfn_getGrdSavedataAll(this.bscGrid.grdMain);
			if (grdData.length == 0) {
				alert('<spring:message code="msg.noChangeData"/>');
				return;
			}

				
			confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
				//var data = bscCompany.bscGrid.dataProvider.getJsonRows();
				var data = gfn_getGrdSavedataAll(bscCompany.bscGrid.grdMain);
				var jsonData = [];
				$.each(data, function (i, jd) {
					if (jd.GRP_LVL_ID == '3') {
						jsonData.push(jd);
					}
				});
				
				FORM_SAVE = {}; //초기화
				FORM_SAVE._mtd   = "saveAll";
				FORM_SAVE.tranData = [{outDs:"saveCnt",_siq : bscCompany._siq, grdData : jsonData, mergeFlag : "Y"}];
				
				gfn_service({
					url    : GV_CONTEXT_PATH + "/biz/obj.do",
					data   : FORM_SAVE,
					success: function(data) {
						alert('<spring:message code="msg.saveOk"/>');
						fn_apply();
					}
				}, "obj");
				
			});
		},
	};
	
	
	//조회
	var fn_apply = function (sqlFlag) {
		
		FORM_SEARCH     = $("#searchForm").serializeObject(); //초기화
		FORM_SEARCH.sql = sqlFlag;
		
		bscCompany.search();
		bscCompany.excelSubSearch();
	}

	var gridCalc = function (dataRow, field, oldValues, newVal) {

		var provider   = bscCompany.bscGrid.dataProvider;
		provider.beginUpdate();
		
		provider.setValue(dataRow, "HDR_WEIGHT_RATE", newVal);
		try {
			if ($.isArray(field)) {
				var tmpOldVal;
				$.each(field, function(n,v) {
					var bsc = getDivCalcVal (dataRow);
					
					provider.setValue(0, "TOT_BSC_VAL", bsc);
				});
			} else {
				var bsc = getDivCalcVal (dataRow);
				
				provider.setValue(0, "TOT_BSC_VAL", bsc);
				
				var code = getClaz (bsc);
				
				provider.setValue(0, "TOT_BSC_GRADE", code);
			}
		} finally {
			provider.endUpdate();
		}
	};
	
	var getDivCalcVal = function (idx) {
		var provider = bscCompany.bscGrid.dataProvider;
		var rtnVal   = 0;
		var startIdx = provider.getRowCount()-1;
		
		for (var i = startIdx; i >= 0; i--) {
			if (provider.getValue(i, gv_grpLvlId) == '3') {
				rtnVal += ( ( Number(gfn_nvl(provider.getValue(i, "HDR_WEIGHT_RATE"),0))/ 100) * Number(gfn_nvl(provider.getValue(i, "TOT_BSC_VAL"),0)));
			}
		}
		
		return rtnVal;
	};
	
	var getClaz = function (val) {
		var code = '';
		$.each (bscCompany.comCode.codeMap.BSC_GRADE_CD, function(i, v) {
			if (Number(val) >= Number(v.ATTB_1_CD) && Number(val) < Number(v.ATTB_2_CD)) {
				code = v.CODE_CD;
				return false;
			}
		});
		
		return code;
	};
	
	function fn_checkClose() {
		return gfn_getGrdSaveCount(bscCompany.bscGrid.grdMain) == 0;
	}
	

	// onload 
	$(document).ready(function() {
		bscCompany.init();
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
				<%-- <%@ include file="/WEB-INF/view/common/filterMonthSum.jsp"%> --%>
				<div class="tabMargin"></div>
				<div class="scroll">
					<div class="view_combo" id="divMonthAcc"></div>
					<div class="view_combo" id="divMonth">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.month" />  </div>
							<input type="text" id="fromMon" name="fromMon" class="iptdate datepicker2 monthpicker" value="">
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
				<div class="bright">
					<a id="btnReset"       href="#" class="app1"><spring:message code="lbl.reset" /></a>  
					<a id="btnSave"        href="#" class="app2"><spring:message code="lbl.save" /></a>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
