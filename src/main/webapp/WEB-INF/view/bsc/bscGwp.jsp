<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp"%>
<script type="text/javascript" src="${ctx}/statics/js/biz/gridcalc.js" ></script>
<!-- BSC 품질 -->
	<script type="text/javascript">

	var enterSearchFlag = "Y";
	var bscGwp = {
		init : function () {
			gfn_formLoad();
			
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.bscGrid.initGrid();
			
			MONTHPICKER(null, 0, 0);
			var baseDt = new Date();
			$("#fromMon").monthpicker("option", "maxDate", new Date(baseDt.getFullYear(), baseDt.getMonth(), '01'));
			
		},
			
		_siq    : "bsc.bscGwp",
		
		initFilter : function() {
			gfn_setMsComboAll([
				{target : 'divMonthAcc', id : 'rdoAqType', title : '<spring:message code="lbl.monthAccFlag"/>', data : this.comCode.codeMap.MONTH_ACC_TYPE, exData:[""], type : "R"},
				{target : 'divHiddenFlag', id : 'hiddenFlag', title : '<spring:message code="lbl.hiddenFlag"/>', data : this.comCode.codeMap.HIDDEN_CD, exData:[""], type : "R"}
			]);
			
			$(':radio[name=rdoAqType]:input[value="MON"]').attr("checked", true);
			$(':radio[name=hiddenFlag]:input[value="Y"]').attr("checked", true);
		},
		
		comCode : {
			codeMap : null,
			codeReptMap : null,
			
			initCode : function () {
				var grpCd = 'MONTH_ACC_TYPE,HIDDEN_CD';
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
				//this.gridEvents();
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
						name      : "EQUALIZATION", 
						header    : { fixedHeight : 20, text : "<spring:message code='lbl.bhs'/>" },
						width     : 320, 
						columns   : [
							{
								name      : "KPI16_WEIGHT_RATE", 
								fieldName : "KPI16_WEIGHT_RATE", 
								header    : { text : "<spring:message code='lbl.weighted'/>" }, 
								editor    : { type : "number", textAlignment : "far", editFormat : "#,##0.0", positiveOnly : true},
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.0"}, 
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "KPI16_TARGET_VALUE", 
								fieldName : "KPI16_TARGET_VALUE", 
								header    : { text : "<spring:message code='lbl.target'/>" }, 
								editor    : { type : "number", textAlignment : "far", editFormat : "#,##0.0", positiveOnly : true},
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.0"}, 
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "KPI16_TARGET_VALUE_02", 
								fieldName : "KPI16_TARGET_VALUE_02", 
								header    : { text : "<spring:message code='lbl.avgTime'/>" }, 
								editor    : { type : "number", textAlignment : "far", editFormat : "#,##0.0", positiveOnly : true},
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.0"}, 
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "KPI16_RESULT_RATE", 
								fieldName : "KPI16_RESULT_RATE", 
								header    : { text : "<spring:message code='lbl.actual'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.0"},
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "KPI16_BSC_VAL", 
								fieldName : "KPI16_BSC_VAL", 
								header    : { text : "<spring:message code='lbl.bscScore'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"},
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}
						]
					}, { 
						type      : "group",
						name      : "JOB", 
						header    : { fixedHeight : 20, text : "<spring:message code='lbl.tor'/>" },
						width     : 320, 
						columns   : [
							{
								name      : "KPI17_WEIGHT_RATE", 
								fieldName : "KPI17_WEIGHT_RATE", 
								header    : { text : "<spring:message code='lbl.weighted'/>" }, 
								editor    : { type : "number", textAlignment : "far", editFormat : "#,##0.0", positiveOnly : true},
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.0"}, 
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "KPI17_TARGET_VALUE", 
								fieldName : "KPI17_TARGET_VALUE", 
								header    : { text : "<spring:message code='lbl.target'/>" }, 
								editor    : { type : "number", textAlignment : "far", editFormat : "#,##0.0", positiveOnly : true},
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.0"}, 
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "KPI17_RESULT_RATE", 
								fieldName : "KPI17_RESULT_RATE", 
								header    : { text : "<spring:message code='lbl.actual'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.0"},
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "KPI17_BSC_VAL", 
								fieldName : "KPI17_BSC_VAL", 
								header    : { text : "<spring:message code='lbl.bscScore'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"},
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}
						]
					}, { 
						type      : "group",
						name      : "DISASTER", 
						header    : { fixedHeight : 20, text : "<spring:message code='lbl.ar'/>" },
						width     : 320, 
						columns   : [
							{
								name      : "KPI18_WEIGHT_RATE", 
								fieldName : "KPI18_WEIGHT_RATE", 
								header    : { text : "<spring:message code='lbl.weighted'/>" }, 
								editor    : { type : "number", textAlignment : "far", editFormat : "#,##0.0", positiveOnly : true},
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.0"}, 
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "KPI18_TARGET_VALUE", 
								fieldName : "KPI18_TARGET_VALUE", 
								header    : { text : "<spring:message code='lbl.target'/>" }, 
								editor    : { type : "number", textAlignment : "far", editFormat : "#,##0.0", positiveOnly : true},
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.0"}, 
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "KPI18_RESULT_RATE", 
								fieldName : "KPI18_RESULT_RATE", 
								header    : { text : "<spring:message code='lbl.actual'/>" }, 
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.0"},
								dynamicStyles:[gfn_getDynamicStyle(-1, totAr)],
								width     : 80, 
								editable  : false 
							}, {
								name      : "KPI18_BSC_VAL", 
								fieldName : "KPI18_BSC_VAL", 
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
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.0"}, 
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
					{ fieldName : "YEARMONTH"    , dataType : "text"},
					{ fieldName : "GRP_LVL_ID"   , dataType : "text"},
					{ fieldName : "BU_CD"        , dataType : "text"},
					{ fieldName : "BU_NM"        , dataType : "text"},
					{ fieldName : "DIV_CD"       , dataType : "text"},
					{ fieldName : "DIV_NM"       , dataType : "text"},
					{ fieldName : "TEAM_CD"      , dataType : "text"},
					{ fieldName : "TEAM_NM"      , dataType : "text"},
					{ fieldName : "PART_CD"      , dataType : "text"},
					{ fieldName : "PART_NM"      , dataType : "text"},
					{ fieldName : "KPI16_EDIT_YN" , dataType : "text"},
					{ fieldName : "KPI17_EDIT_YN" , dataType : "text"},
					{ fieldName : "KPI18_EDIT_YN" , dataType : "text"},
					
					{ fieldName : "KPI16_WEIGHT_RATE"     , dataType : "number"},
					{ fieldName : "KPI16_TARGET_VALUE"    , dataType : "number"},
					{ fieldName : "KPI16_TARGET_VALUE_02" , dataType : "number"},
					{ fieldName : "KPI16_RESULT_RATE"     , dataType : "number"},
					{ fieldName : "KPI16_BSC_VAL"         , dataType : "number"},
					
					{ fieldName : "KPI17_WEIGHT_RATE"     , dataType : "number"},
					{ fieldName : "KPI17_TARGET_VALUE"    , dataType : "number"},
					{ fieldName : "KPI17_RESULT_RATE"     , dataType : "number"},
					{ fieldName : "KPI17_BSC_VAL"         , dataType : "number"},
					{ fieldName : "KPI17_BILL_RESULT"     , dataType : "number" },
					
					{ fieldName : "KPI18_WEIGHT_RATE"     , dataType : "number"},
					{ fieldName : "KPI18_TARGET_VALUE"    , dataType : "number"},
					{ fieldName : "KPI18_RESULT_RATE"     , dataType : "number"},
					{ fieldName : "KPI18_BSC_VAL"         , dataType : "number"},
					{ fieldName : "KPI18_BILL_RESULT"     , dataType : "number" },
					
					{ fieldName : "GWP_WEIGHT_RATE"       , dataType : "number"},
					{ fieldName : "GWP_BSC_VAL"           , dataType : "number"},
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
				
				var valArray = ["EQUALIZATION", "KPI16_WEIGHT_RATE", "KPI16_TARGET_VALUE", "KPI16_TARGET_VALUE_02", "KPI16_RESULT_RATE", "KPI16_BSC_VAL", "DISASTER", "KPI18_WEIGHT_RATE", "KPI18_TARGET_VALUE", "KPI18_RESULT_RATE", "KPI18_BSC_VAL"];
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
				var tHiddenFlag = $('input:radio[name="hiddenFlag"]:checked').val();
				
				if (!(yymm == tFromMon || yymmBefore == tFromMon) || tRdoAqType == "ACC") {
					return false;
				}
				
				var cols     = this.grdMain.getColumnNames();
				var targetAr1 = new Array();
				var targetAr2 = new Array();
				var targetAr3 = new Array();
				var targetAr4 = new Array();
				var arrIdx1   = new Array();
				var arrIdx2   = new Array();
				var arrIdx3   = new Array();
				var arrIdx4   = new Array();
				
				var subTotalFlag = "N";
				var hiddenRow = new Array();
				
				for (var i = 0; i < this.dataProvider.getRowCount(); i++) {
					
					var tGrpLvlId = this.dataProvider.getValue(i, "GRP_LVL_ID");
					var tBuCd = this.dataProvider.getValue(i, "BU_CD");
					var tQcBscVal = isNaN(Number(this.dataProvider.getValue(i, "GWP_BSC_VAL")));
					
					// 조건
					if (tGrpLvlId == '0') {
						arrIdx1.push(i);
						
						if (this.dataProvider.getValue(i, "KPI16_EDIT_YN") != 'N') {
							arrIdx2.push(i);
						}
						if (this.dataProvider.getValue(i, "KPI17_EDIT_YN") != 'N') {
							arrIdx3.push(i);
						}
						if (this.dataProvider.getValue(i, "KPI18_EDIT_YN") != 'N') {
							arrIdx4.push(i);
						}
					}
					
					if(tHiddenFlag == "Y"){
						//본부 로우 hidden 하기
						if(tBuCd == "QT"){ //사업부가 1개이상인 경우
							if(tGrpLvlId != "7"){
								if(tGrpLvlId == "3"){
									
									subTotalFlag = "N";
									
									if(tQcBscVal == true){
										subTotalFlag = "Y";
										hiddenRow.push(i);
									}
								}else{
									if(subTotalFlag == "Y"){
										hiddenRow.push(i);
									}
								}
							}	
						}else{ //사업부가 1개인 경우
							if(tGrpLvlId == "7"){
								
								subTotalFlag = "N";
								
								if(tQcBscVal == true){
									subTotalFlag = "Y";
									hiddenRow.push(i);
								}
							}else{
								if(subTotalFlag == "Y"){
									hiddenRow.push(i);
								}
							}
						}						
					}
				} 
				
				for (var j = 0; j < cols.length; j++) {
					
					if (cols[j].indexOf("_WEIGHT_RATE") > -1 && cols[j] != "GWP_WEIGHT_RATE") {
						targetAr1.push(cols[j])
					}
					if (cols[j].indexOf("KPI16_TARGET_VALUE") > -1) {
						targetAr2.push(cols[j])
					}
					if (cols[j].indexOf("KPI17_TARGET_VALUE") > -1) {
						targetAr3.push(cols[j])
					}
					if (cols[j].indexOf("KPI18_TARGET_VALUE") > -1) {
						targetAr4.push(cols[j])
					}
					
					
					if (cols[j].indexOf("KPI16_RESULT_RATE") > -1) {
						targetAr2.push(cols[j])
					}
					if (cols[j].indexOf("KPI17_RESULT_RATE") > -1) {
						targetAr3.push(cols[j])
					}
					if (cols[j].indexOf("KPI18_RESULT_RATE") > -1) {
						targetAr4.push(cols[j])
					}
				}
				
				this.grdMain.setCellStyles(arrIdx1, targetAr1 , "editStyle");
				
				if (arrIdx2.length > 0) {
					this.grdMain.setCellStyles(arrIdx2, targetAr2 , "editStyle");
				}
				if (arrIdx3.length > 0) {
					this.grdMain.setCellStyles(arrIdx3, targetAr3 , "editStyle");
				}
				if (arrIdx4.length > 0) {
					this.grdMain.setCellStyles(arrIdx4, targetAr4 , "editStyle");
				}
				
				if(tHiddenFlag == "Y"){
					this.dataProvider.hideRows(hiddenRow);					
				}
			}
		},
	
		/*
		* event 정의
		*/
		events : function () {
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("#btnSave").on('click', function (e) {
				bscGwp.save();
			});
			
			$("#btnFilePopup").on('click', function (e) {
				
				var params = {
					rootUrl : "bsc",
					url     : "bscGwpUpDownPopup",
					width   : 630,
					height  : 400,
					_siq    : bscGwp._siq + "FileNo",
				};
				
				gfn_comPopupOpen("BSC_GWP_FILE", params);
				
			});
			
			$("#btnReset").on('click', function (e) {
				bscGwp.bscGrid.grdMain.cancel();
				bscGwp.bscGrid.dataProvider.rollback(bscGwp.bscGrid.dataProvider.getSavePoints()[0]);
				bscGwp.bscGrid.gridCallback();
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
					}else if(id == "divHiddenFlag"){
						var hiddenFlag = $('input[name="hiddenFlag"]:checked').val();
						
						if(hiddenFlag == "Y"){
							EXCEL_SEARCH_DATA += '<spring:message code="lbl.unMarked"/>';
						}else if(hiddenFlag == "N"){
							EXCEL_SEARCH_DATA += '<spring:message code="lbl.marked"/>';
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
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						bscGwp.bscGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						bscGwp.bscGrid.grdMain.cancel();
						
						bscGwp.bscGrid.dataProvider.setRows(data.resList);
						bscGwp.bscGrid.dataProvider.clearSavePoints();
						bscGwp.bscGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(bscGwp.bscGrid.dataProvider.getRowCount());
						
						bscGwp.bscGrid.gridInstance.setFocusKeys();
						bscGwp.bscGrid.gridCallback();
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
					
				var data = gfn_getGrdSavedataAll(bscGwp.bscGrid.grdMain);
				var jsonData = [];
				$.each(data, function (i, jd) {
					if (jd.GRP_LVL_ID == '0') {
						jsonData.push(jd);
					}
				});
				
				FORM_SAVE = {}; //초기화
				FORM_SAVE._mtd   = "saveUpdate";
				FORM_SAVE.tranData = [{outDs:"saveCnt",_siq : bscGwp._siq, grdData : [{rowList : jsonData}]}];
				
				/* FORM_SAVE._mtd   = "saveAll";
				FORM_SAVE.tranData = [{outDs:"saveCnt",_siq : bscGwp._siq, grdData : jsonData, mergeFlag : "Y"}]; */
				
				//console.log("FORM_SAVE : ", FORM_SAVE);
				
				gfn_service({
					url    : GV_CONTEXT_PATH + "/biz/obj",
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
		
		bscGwp.search();
		bscGwp.excelSubSearch();
	}
	
	function fn_checkClose() {
		return gfn_getGrdSaveCount(bscGwp.bscGrid.grdMain) == 0;
	}

	// onload 
	$(document).ready(function() {
		bscGwp.init();
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
					<div class="view_combo" id="divHiddenFlag"></div>
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
					<a id="btnFilePopup"   href="#" class="app1"><spring:message code="filePopup" /></a> 
					<a id="btnSave"        href="#" class="app2"><spring:message code="lbl.save" /></a>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
