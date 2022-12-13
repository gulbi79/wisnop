<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp"%>

	<script type="text/javascript">
	var enterSearchFlag = "Y";
	var preMonthPerform = {

		init : function () {
			gfn_formLoad();
			
			this.events();
			this.comCode.initCode();
			this.bizGrid.initGrid();

			// 콤보박스
			gfn_setMsComboAll([
				{target : 'divBuCd', id : 'buCd', title : '<spring:message code="lbl.bu"/>', data : this.comCode.codeMap.BU_CD, exData:["*"], type : "S"}
			]);
			
			MONTHPICKER(null, 0, 0);
			
			var baseDt = new Date();
			baseDt.setMonth(14);
			$("#fromMon").monthpicker("option", "maxDate", new Date(baseDt.getFullYear(), baseDt.getMonth() + 1, '01'));
		},
		
		_siq : "snop.bizKpi.preMonthPerform",

		/*
		* common Code 
		*/
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
		bizGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			excluAr      : [ 'COSTG_KRW', 'GP_KRW', 'OP_AMT_KRW'],
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;

				this.setFields();
				this.setColumn();
				
				this.setOptions();
				this.gridEvents();
			},
			
			setColumn : function () {
				var columns = 
				[	
					{
						name      : "BU_NM",
						fieldName : "BU_NM",
						header    : {text : '<spring:message code="lbl.bu"/>'},
						styles    : {textAlignment : "near"},
						editable  : false,
						mergeRule : { criteria: "value" },
						width     : 120
					}, {
						name      : "CODE_NM",
						fieldName : "CODE_NM",
						header    : {text : '<spring:message code="lbl.category"/>'},
						styles    : {textAlignment : "near"},
						editable  : false,
						width     : 120
					}, {
						name      : "PRE_PERFORM_AMT", 
						fieldName : "PRE_PERFORM_AMT", 
						header    : {text: '<spring:message code="lbl.lyActual" javaScriptEscape="true" />'},
						styles    : {textAlignment: "far", numberFormat : "#,##0"},
						dataType  : "number",
						editable  : false,
						width     : 100
					}, {
		                type      : "group",
						name      : "DUMMY1", 
						header    : { fixedHeight : 20, text : "MONTH" },
						width     : 390, 
						columns   : [
							{
								name      : "CUR_PLAN_AMT", 
								fieldName : "CUR_PLAN_AMT", 
								header    : { text : "<spring:message code='lbl.bizPlan'/>" }, 
								editor    : { type : "number", textAlignment : "far", editFormat : "#,##0", integerOnly: true}, 
								styles    : { textAlignment : "far", numberFormat : "#,##0"}, 
								dynamicStyles: [{
									criteria : ["(values['CODE_CD'] <> 'COSTG_KRW') and (values['CODE_CD'] <> 'GP_KRW') and (values['CODE_CD'] <> 'OP_AMT_KRW')"],
									styles   : ["background="+gv_requiredColor]
									}],
								width     : 110, 
								editable  : false 
							}, {
								name      : "CUR_PERFORM_AMT", 
								fieldName : "CUR_PERFORM_AMT", 
								header    : { text : "<spring:message code='lbl.performance'/>" }, 
								editor    : { type : "number", textAlignment : "far", editFormat : "#,##0", integerOnly: true}, 
								styles    : { textAlignment : "far", numberFormat : "#,##0"}, 
								dynamicStyles: [{
									criteria : ["(values['CODE_CD'] <> 'COSTG_KRW') and (values['CODE_CD'] <> 'GP_KRW') and (values['CODE_CD'] <> 'OP_AMT_KRW')"],
									styles   : ["background="+gv_requiredColor]
									}],
								width     : 110, 
								editable  : false 
							}, {
								name      : "CUR_DIFF_AMT", 
								fieldName : "CUR_DIFF_AMT", 
								header    : { text : "<spring:message code='lbl.difference'/>" }, 
								styles    : { textAlignment : "far", numberFormat : "#,##0"}, 
								width     : 110, 
								editable  : false 
							}, {
								name      : "CUR_BIZ_DAL", 
								fieldName : "CUR_BIZ_DAL",
								header    : {text: '<spring:message code="lbl.achieRate" javaScriptEscape="true" />'},
								styles    : {textAlignment: "far", numberFormat : "#,##0.0"},
								dataType  : "number",
								editable  : false,
								width     : 60
							}
						]
					}, {
						name      : "PRE_PERFORM_ACML_AMT", 
						fieldName : "PRE_PERFORM_ACML_AMT",
						header    : {text: '<spring:message code="lbl.lyCumActual" />'},
						styles    : {textAlignment: "far", numberFormat : "#,##0"},
						dataType  : "number",
						editable  : false,
						width     : 120
					}, {
						
						type      : "group",
						name      : "DUMMY2", 
						header    : { fixedHeight : 20, text : "MONTH" },
						width     : 420, 
						columns   : [
							{
								name      : "CUR_PLAN_ACML_AMT", 
								fieldName : "CUR_PLAN_ACML_AMT", 
								header    : { text : "<spring:message code='lbl.bizPlan'/>" }, 
								styles    : { textAlignment : "far", numberFormat : "#,##0"}, 
								editable  : false, 
								width     : 120
							}, {
								name      : "CUR_PERFORM_ACML_AMT", 
								fieldName : "CUR_PERFORM_ACML_AMT", 
								header    : { text : "<spring:message code='lbl.performance'/>" }, 
								styles    : { textAlignment : "far", numberFormat : "#,##0"}, 
								editable  : false,
								width     : 120 
							}, {
								name      : "CUR_DIFF_ACML_AMT", 
								fieldName : "CUR_DIFF_ACML_AMT", 
								header    : { text : "<spring:message code='lbl.difference'/>" }, 
								styles    : { textAlignment : "far", numberFormat : "#,##0"}, 
								editable  : false, 
								width     : 120
							}, {
								name      : "CUR_BIZ_ACML_DAL", 
								fieldName : "CUR_BIZ_ACML_DAL",
								header    : {text: '<spring:message code="lbl.achieRate" javaScriptEscape="true" />'},
								styles    : {textAlignment: "far", numberFormat : "#,##0.0"},
								dataType  : "number",
								editable  : false,
								width     : 60
							}
						]
					}
				];
				
				this.grdMain.setColumns(columns); 
			},
			
			setFields : function(cols, hiddenCols) {
				
				var fields = new Array();
				
				fields = [
					{ fieldName : "BU_CD"},
					{ fieldName : "BU_NM"},
					{ fieldName : "CODE_CD"},
					{ fieldName : "CODE_NM"},
					{ fieldName : "YEARMONTH"},
					{ fieldName : "PRE_PERFORM_AMT"      , dataType : "number"},
					{ fieldName : "CUR_PLAN_AMT"         , dataType : "number"},
					{ fieldName : "CUR_PERFORM_AMT"      , dataType : "number"},
					{ fieldName : "CUR_DIFF_AMT"         , dataType : "number"},
					{ fieldName : "CUR_BIZ_DAL"          , dataType : "number"},
					{ fieldName : "PRE_PERFORM_ACML_AMT"  , dataType : "number"},
					{ fieldName : "CUR_PLAN_ACML_AMT"     , dataType : "number"},
					{ fieldName : "CUR_PERFORM_ACML_AMT"  , dataType : "number"},
					{ fieldName : "CUR_DIFF_ACML_AMT"     , dataType : "number"},
					{ fieldName : "CUR_BIZ_ACML_DAL"      , dataType : "number"},
		        ];
				
				this.dataProvider.setFields(fields);
			},
			
			setOptions : function () {
				this.grdMain.setOptions({
					stateBar: { visible       : true  },
					sorting : { enabled       : false },
					display : { columnMovable : false }
				});

				this.grdMain.addCellStyles([{
					id       : "editStyle",
					editable : true,
					background : gv_editColor
				}]);
				
				this.dataProvider.setOptions({
					softDeleting : true
				});
			},
			
			gridEvents : function() {
				this.grdMain.onEditRowChanged = function (grid, itemIndex, dataRow, field, oldValue, newValue) {
					//calc.change(grid, itemIndex, dataRow, field, oldValue, newValue);
				};

				this.grdMain.onEditRowPasted = function(grid, itemIndex, dataRow, fields, oldValues, newValues) {
					
					if (fields.length == newValues.length) {
						calc.change(grid, itemIndex, dataRow, fields, oldValues, newValues);
					} else {
						var arrNewVal = [];
						$.each(fields, function(n,v) {
							arrNewVal.push(newValues[v]);
						});
					}
				};
			},
			
			gridCallback : function () {
				
				var arEdit = ["CUR_PLAN_AMT", "CUR_PERFORM_AMT"];
				
				var category;
				var arrIdx = [];
				for (var i = 0; i < this.dataProvider.getRowCount(); i++) {
					category = this.dataProvider.getValue(i, "CODE_CD");
					
					if ($.inArray(category, this.excluAr) == -1) {
						arrIdx.push(i);
					}
				}
				
				this.grdMain.setCellStyles(arrIdx, arEdit, "editStyle");
			}
		},
	
		events : function () {
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("#btnSave").on('click', function (e) {
				preMonthPerform.save();
			});

			$("#btnReset").on('click', function (e) {
				preMonthPerform.bizGrid.grdMain.cancel();
				preMonthPerform.bizGrid.dataProvider.rollback(preMonthPerform.bizGrid.dataProvider.getSavePoints()[0]);
				preMonthPerform.bizGrid.gridCallback();
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
					}else if(id == "divMonth"){
						EXCEL_SEARCH_DATA += $("#fromMon").val();			
					}
				}
			});
		},
		
		search : function () {
			
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{outDs : "resList", _siq : preMonthPerform._siq}];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						
						var col1 = preMonthPerform.bizGrid.grdMain.columnByName("DUMMY1");
						var col2 = preMonthPerform.bizGrid.grdMain.columnByName("DUMMY2");
						
						preMonthPerform.bizGrid.grdMain.setColumnProperty(col1, "header", {text : $("#fromMon").val()})
						preMonthPerform.bizGrid.grdMain.setColumnProperty(col2, "header", {text : '<spring:message code="lbl.accum" />' + " ("+$("#fromMon").val()+")" })
						
						preMonthPerform.bizGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						preMonthPerform.bizGrid.grdMain.cancel();
						preMonthPerform.bizGrid.dataProvider.setRows(data.resList);
						preMonthPerform.bizGrid.dataProvider.clearSavePoints();
						preMonthPerform.bizGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(preMonthPerform.bizGrid.dataProvider.getRowCount());
						
						preMonthPerform.bizGrid.gridCallback();
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		save : function() {
			confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?

				var grdData = preMonthPerform.bizGrid.dataProvider.getJsonRows();
			 
				FORM_SAVE = {}; //초기화
				FORM_SAVE._mtd       = "saveUpdate";
				FORM_SAVE.tranData = [{outDs:"saveCnt",_siq : preMonthPerform._siq, grdData : [{rowList : grdData}]}];
				
				var ajaxOpt = {
					url     : GV_CONTEXT_PATH + "/biz/obj",
					data    : FORM_SAVE,
					success : function(data) {
						if (data.errCode == -10) {
							alert(gfn_getDomainMsg("msg.dupData", data.errLine));
						} else {
							alert('<spring:message code="msg.saveOk"/>');
							
							fn_apply(false);
						}
					},
				};
				
				gfn_service(ajaxOpt, "obj");
			});
			
		},
	};
	
	/********************************************************************************************************
	** 조회 
	********************************************************************************************************/
	var fn_apply = function (sqlFlag) {
		
		FORM_SEARCH     = $("#searchForm").serializeObject(); //초기화
		FORM_SEARCH.sql = sqlFlag;
		
		preMonthPerform.search();
		preMonthPerform.excelSubSearch();
	}
	
	/*
	* 계산시 필요  util
	*/
	var util = {
		F : function (n, pos) {
			var digits = Math.pow(10, pos); 
			var num = Math.floor(n * digits) / digits; 
			return num.toFixed(pos);
		},
		
		R : function (n, pos) {
			var digits = Math.pow(10, pos);

			var sign = 1;
			if (n < 0) {
				sign = -1;
			}		
			n = n * sign;
			var num = Math.round(n * digits) / digits;
			num = num * sign;

			return num.toFixed(pos);
		},
		
		Z : function (n) {
			return !$.isNumeric(n) ? 0 : n;
		},
		
		D : function (x, y) {
			return this.Z(this.F (this.Z(x) / this.Z(y) * 100, 6));
		},
		
		M : function (x, y) {
			return this.Z(x) - this.Z(y);
		},

		P : function (x, y) {
			return this.Z(x) + this.Z(y);
		},
	};
	
	
	var calc = {
		
		DIFF    : null,
		GRDPRVD : null,
		change  : function(gridInst, itemIndex, dataRow, field, oldVal, newVal) {
			
			if ($.isArray(field)) {
				var tmpOldVal;
				$.each(field, function(n,v) {
					calc.calcl(gridInst, itemIndex, dataRow, v, oldVal, newVal);
				});
			} else {
				calc.calcl(gridInst, itemIndex, dataRow, field, oldVal, newVal)
			}
		},
		
		
		calcl  : function(gridInst, itemIndex, dataRow, field, oldVal, newVal) {
			
			this.GRDPRVD = preMonthPerform.bizGrid.dataProvider;
			var code     = this.GRDPRVD.getValue(dataRow, "CODE_CD");
			
			var fieldNm  = this.GRDPRVD.getFieldName(field);
			
			var isPlan      = (fieldNm == "CUR_PLAN_AMT");
			var rvFld       = !isPlan ? 'CUR_PLAN_AMT'       : 'CUR_PERFORM_AMT';
			
			var tgFld       = isPlan ? 'CUR_PLAN_AMT'       : 'CUR_PERFORM_AMT';
			
			var tgFldAcml   = isPlan ? 'CUR_PLAN_ACML_AMT'  : 'CUR_PERFORM_ACML_AMT';
			
			var tgFldDiff       = 'CUR_DIFF_AMT';
			var tgFldDiffAcml   = 'CUR_DIFF_ACML_AMT';
			
			var a,b,c,d,e,f,g,h;
			
			var um = 1;
			if (isPlan) {
				um = -1;
			}
			
			this.DIFF = util.M(newVal, oldVal);
			
			this.setValForCd(this.DIFF * um, tgFldDiff,     code);
			this.setValForCd(this.DIFF,      tgFldAcml,     code);
			this.setValForCd(this.DIFF * um, tgFldDiffAcml, code);
			
			switch (code) {
				case "SALES_AMT_KRW" :
	
						a = this.setValForCd(this.DIFF,      tgFld,         'GP_KRW');
						b = this.setValForCd(this.DIFF * um, tgFldDiff,     'GP_KRW');
						c = this.setValForCd(this.DIFF,      tgFldAcml,     'GP_KRW');
						d = this.setValForCd(this.DIFF * um, tgFldDiffAcml, 'GP_KRW');
						
						e = this.getValForCd(tgFld,         'SGNA_KRW');
						f = this.getValForCd(tgFldDiff,     'SGNA_KRW');
						g = this.getValForCd(tgFldAcml,     'SGNA_KRW');
						h = this.getValForCd(tgFldDiffAcml, 'SGNA_KRW');

						this.setValForCd(util.M(a, e), tgFld,         'OP_AMT_KRW', "N");
						this.setValForCd(util.M(b, f), tgFldDiff,     'OP_AMT_KRW', "N");
						this.setValForCd(util.M(c, g), tgFldAcml,     'OP_AMT_KRW', "N");
						this.setValForCd(util.M(d, h), tgFldDiffAcml, 'OP_AMT_KRW', "N");
					break;
				case "PROD" :
					break;
					
				case "MAT" : 
				case "LABOR" : 
				case "EXP" : 
				case "SUB" : 
				case "INV" : 
					// 값  
					this.setValForCd(this.DIFF,      tgFld,         'COSTG_KRW');
					this.setValForCd(this.DIFF * um, tgFldDiff,     'COSTG_KRW');
					this.setValForCd(this.DIFF,      tgFldAcml,     'COSTG_KRW');
					this.setValForCd(this.DIFF * um, tgFldDiffAcml, 'COSTG_KRW');

					if (isPlan) {
						a = this.setValForCd(this.DIFF * um, tgFld,         'GP_KRW');
						b = this.setValForCd(this.DIFF,      tgFldDiff,     'GP_KRW');
						c = this.setValForCd(this.DIFF * um, tgFldAcml,     'GP_KRW');
						d = this.setValForCd(this.DIFF,      tgFldDiffAcml, 'GP_KRW');
					} else {
						a = this.setValForCd(this.DIFF * -1, tgFld,         'GP_KRW');
						b = this.setValForCd(this.DIFF * -1, tgFldDiff,     'GP_KRW');
						c = this.setValForCd(this.DIFF * -1, tgFldAcml,     'GP_KRW');
						d = this.setValForCd(this.DIFF * -1, tgFldDiffAcml, 'GP_KRW');
					}
					
					
					e = this.getValForCd(tgFld,         'SGNA_KRW');
					f = this.getValForCd(tgFldDiff,     'SGNA_KRW');
					g = this.getValForCd(tgFldAcml,     'SGNA_KRW');
					h = this.getValForCd(tgFldDiffAcml, 'SGNA_KRW');

					this.setValForCd(util.M(a, e), tgFld,         'OP_AMT_KRW', "N");
					this.setValForCd(util.M(b, f), tgFldDiff,     'OP_AMT_KRW', "N");
					this.setValForCd(util.M(c, g), tgFldAcml,     'OP_AMT_KRW', "N");
					this.setValForCd(util.M(d, h), tgFldDiffAcml, 'OP_AMT_KRW', "N");
					
					break;
				
				case "SGNA_KRW" : 30
				

					a = this.getValForCd(tgFld,         'GP_KRW');
					b = this.getValForCd(tgFldDiff,     'GP_KRW');
					c = this.getValForCd(tgFldAcml,     'GP_KRW');
					d = this.getValForCd(tgFldDiffAcml, 'GP_KRW');
					
					e = this.getValForCd(tgFld,         'SGNA_KRW');
					f = this.getValForCd(tgFldDiff,     'SGNA_KRW');
					g = this.getValForCd(tgFldAcml,     'SGNA_KRW');
					h = this.getValForCd(tgFldDiffAcml, 'SGNA_KRW');
					
					this.setValForCd(util.M(a, e), tgFld,         'OP_AMT_KRW', "N");
					this.setValForCd(util.M(b, f), tgFldDiff,     'OP_AMT_KRW', "N");
					this.setValForCd(util.M(c, g), tgFldAcml,     'OP_AMT_KRW', "N");
					this.setValForCd(util.M(d, h), tgFldDiffAcml, 'OP_AMT_KRW', "N");
					break;1
				
			}
			
			this.reCalRate();
		},

		// 비율
		reCalRate :  function () {
			
			var plan   = this.getSaleVal("CUR_PLAN_AMT");
			var prFrm  = this.getSaleVal("CUR_PERFORM_AMT");
			var planA  = this.getSaleVal("CUR_PLAN_ACML_AMT");
			var prFrmA = this.getSaleVal("CUR_PERFORM_ACML_AMT");
			var diff   = this.getSaleVal("CUR_DIFF_AMT");
			var diffA  = this.getSaleVal("CUR_DIFF_ACML_AMT");
			
			var a, b, c, d, e, f, code;
			
			for (var i = 0; i < this.GRDPRVD.getRowCount(); i++) {
				
				a = this.GRDPRVD.getValue(i, "CUR_PLAN_AMT");
				b = this.GRDPRVD.getValue(i, "CUR_PERFORM_AMT");
				c = this.GRDPRVD.getValue(i, "CUR_PLAN_ACML_AMT"); 
				d = this.GRDPRVD.getValue(i, "CUR_PERFORM_ACML_AMT");
				e = this.GRDPRVD.getValue(i, "CUR_DIFF_AMT");
				f = this.GRDPRVD.getValue(i, "CUR_DIFF_ACML_AMT"); 
				
				code   = this.GRDPRVD.getValue(i, "CODE_CD");
				
				if (code == 'SALES_AMT_KRW' || code == 'PROD' || code == 'OP_AMT_KRW') {
					this.setVal(i, 'CUR_BIZ_DAL',           util.D(b, a));
					this.setVal(i, 'CUR_BIZ_ACML_DAL',      util.D(d, c));
				} else {
					this.setVal(i, 'CUR_BIZ_DAL',           util.D(a, b));
					this.setVal(i, 'CUR_BIZ_ACML_DAL',      util.D(c, d));
				}
			}
		},
		
		setVal : function (idx, field, val) {
			this.GRDPRVD.beginUpdate();
			try {
				this.GRDPRVD.setValue(idx, field, val);
			} catch (e) {
				console.log(e);
			} finally {
				this.GRDPRVD.endUpdate();
			}
		},
		
		getSaleVal : function (field) {
			return this.getValForCd (field, "SALES");
		},
		
		getValForCd : function (field, cd) {
			var code = ''
			var retVal = null;
			for (var i = 0; i < this.GRDPRVD.getRowCount(); i++) {
				code = this.GRDPRVD.getValue(i, "CODE_CD");
				if (code == cd) {
					retVal = this.GRDPRVD.getValue(i, field);
					break;
				}
			}
			return retVal;
		},
		
		
		setValForCd : function (val, field, cd, sType) {
			
			sType = sType || "Y";
			
			var code   = ''
			var curVal = null;
			var retVal = null;
			this.GRDPRVD.beginUpdate();
			try {
				for (var i = 0; i < this.GRDPRVD.getRowCount(); i++) {
					code   = this.GRDPRVD.getValue(i, "CODE_CD");
					curVal = this.GRDPRVD.getValue(i, field);
					if (code == cd) {
						retVal = (sType == "Y" ? util.P(curVal, val) : util.Z(val));
						this.GRDPRVD.setValue(i, field,  retVal);
						break;
					}
				}
			} catch (e) {
				console.log(e);
			} finally {
				this.GRDPRVD.endUpdate();
			}
			return retVal;
		}
	};
	
	function fn_checkClose() {
		return gfn_getGrdSaveCount(preMonthPerform.bizGrid.grdMain) == 0;
	}

	/********************************************************************************************************
	** onload  
	********************************************************************************************************/
	$(document).ready(function() {
		preMonthPerform.init();
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
				<div class="tabMargin"></div>
				<div class="scroll">
					<div class="view_combo" id="divBuCd"></div>
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
