<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp"%>
<script type="text/javascript" src="${ctx}/statics/js/biz/gridcalc.js"></script>
<script type="text/javascript">

	var enterSearchFlag = "Y";
	var LIST_DATA;
	var salesPlanVs = {
			init : function() {
				gfn_formLoad();					//공통 초기화
				this.comCode.initCode();		//데이터 초기화
				this.initFilter();				//필터 초기화
				this.grid.initGrid();			//그리드 초기화
				this.initEvent();				//이벤트 초기화
			},
			
			comCode : {
				codeMap     : null,
				codeMapEx   : null,
				codeReason1 : [],
				codeReason2 : [],
				codeReason3 : [],
				initCode    : function() {
					var grpCd      = 'PTSP_DEPT,PTSP_TYPE,FLAG_YN';
					this.codeMap   = gfn_getComCode(grpCd, 'Y'); //공통코드 조회
					this.codeMapEx = gfn_getComCodeEx(["REP_CUST_GROUP", "CUST_GROUP", "ITEM_GROUP"]);
					
					gfn_service({
						async   : false,
						url     : GV_CONTEXT_PATH + "/biz/obj.do",
						data    : {_mtd:"getList",tranData:[{outDs:"dateList",_siq:"dp.salesPerformNew.salesPlanVsActualDate"}]},
						success : function(data) {
							salesPlanVs.comCode.codeMap.DATE_INFO = data.dateList[0];
						}
					}, "obj");
					
					gfn_service({
						async   : false,
						url     : GV_CONTEXT_PATH + "/biz/obj.do",
						data    : {_mtd:"getList",tranData:[{outDs:"list",_siq:"dp.salesPerformNew.commonCode"}]},
						success : function(data) {
							salesPlanVs.comCode.codeReason = data.list;
						}
					}, "obj");
				}
			},
			
			grid : {
				gridInstance : null,
				grdMain      : null,
				dataProvider : null,
				
				initGrid     : function() {
					this.gridInstance = new GRID();
					this.gridInstance.init("realgrid");
					this.gridInstance.custNextBucketFalg = true;
					this.gridInstance.measureHFlag = true;
					
					this.grdMain      = this.gridInstance.objGrid;
					this.dataProvider = this.gridInstance.objData;
					
					salesPlanVs.setOptions();
					
					gfn_setMonthSum(salesPlanVs.grid.gridInstance, false, false, true);
				}
			},
			
			setOptions : function () {
				salesPlanVs.grid.grdMain.setOptions({
					stateBar: { visible       : true  },
					sorting : { enabled       : false },
					display : { columnMovable : false }
				});
				
				//스타일 추가
				salesPlanVs.grid.grdMain.addCellStyles([
					{ id : "editStyleRow", editable : true, background : gv_editColor },
					{ id : "nonEditStyleRow", editable : false, background : gv_noneEditColor }
				]);
			},
			
			initFilter : function() {
				
				// 키워드팝업
				gfn_keyPopAddEvent([
					{ target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>' }
				]);
				
				// 콤보박스
				gfn_setMsComboAll([
					{target : 'divReptCustGroup', id : 'reptCustGroup', title : '<spring:message code="lbl.reptCustGroup"/>', data : this.comCode.codeMapEx.REP_CUST_GROUP, exData:["*"]},
					{target : 'divCustGroup', id : 'custGroup', title : '<spring:message code="lbl.custGroup"/>', data : this.comCode.codeMapEx.CUST_GROUP, exData:["*"]},
					{target : 'divItemGroup', id : 'itemGroup', title : '<spring:message code="lbl.itemGroup"/>', data : this.comCode.codeMapEx.ITEM_GROUP, exData:["*"]},
					{target : 'divType', id : 'type', title : '<spring:message code="lbl.type2"/>', data : this.comCode.codeMap.PTSP_TYPE, exData:['*'], type : "S"},
					{target : 'divReason', id : 'reason', title : '<spring:message code="lbl.reason"/>', data : {}, exData:['*'], type : "S" },
					{target : 'divDept', id : 'dept', title : '<spring:message code="lbl.dept"/>', data : this.comCode.codeMap.PTSP_DEPT, exData:['*'], type : "S" },
					{target : 'divAddSalesAvail', id : 'addSalesAvail', title : '<spring:message code="lbl.addSalesAvail"/>', data : this.comCode.codeMap.FLAG_YN, exData:['*'], type : "S" },
					//divAddSalesAvail
					{target : 'divGigan', id : 'gigan', title : '<spring:message code="lbl.period"/>', data : [{CODE_CD:"1", CODE_NM : "1"},{CODE_CD:"3", CODE_NM : "3"}, {CODE_CD:"5", CODE_NM : "5"}, {CODE_CD:"10", CODE_NM : "10"}], exData:[''], type : "S" }
				]);
				
				//숫자만입력
				$("#saleRateFrom,#saleRateTo,#prodRateFrom,#prodRateTo").inputmask("numeric");
				$("#type").val("PTSP_TYPE_3");
				
				//달력
				DATEPICKET(null,this.comCode.codeMap.DATE_INFO.FROM_DATE, this.comCode.codeMap.DATE_INFO.TO_DATE);
				$("#toCal").datepicker("option", "maxDate", this.comCode.codeMap.DATE_INFO.MAX_DATE);
				
				this.typeChange($("#type").val(), "Y");
			},
			
			initEvent : function() {
				// 조회 버튼
				$(".fl_app"            ).click("on", function() { fn_apply(false); });
				$("#btnReset"          ).click("on", function() { fn_reset(); });
				$("#btnSave"           ).click("on", function() { fn_save(); });
				$("#btnOpenPopupType"  ).click("on", function() { fn_openPopup("TYPE");  });
				$("#btnOpenPopupReason").click("on", function() { fn_openPopup("REASON");});
				$("#btnOpenPopupDept"  ).click("on", function() { fn_openPopup("DEPT");  });
				$("#btnOpenPopupCust"  ).click("on", function() { fn_openPopup("CUST");  });
				
				$("#type").on("change", function() {
					var typeCd = $("#type").val();
					salesPlanVs.typeChange(typeCd, "Y");
				});
			},
			
			typeChange : function(typeCd, allYn) {
				
				gfn_service({
					async   : false,
					url     : GV_CONTEXT_PATH + "/biz/obj.do",
					data    : {_mtd:"getList",typeCd:typeCd,tranData:[{outDs:"list",_siq:"dp.salesPerformNew.commonCode"}]},
					success : function(data) {
						var list    = data.list;
						var listCnt = list.length;
						var str     = "";
						
						if(allYn == "Y") {
							str += "<option value=\"\">All</option>";
						}
						
						
						for(var i=0; i < listCnt; i++) {
							str += "<option value=\""+list[i].CODE_CD+"\">"+list[i].CODE_NM+"</option>";
						}
						
						$("#reason").html(str);
					}
				}, "obj");
			},
			
			getBucket : function(sqlFlag) {
				
				
				if (!sqlFlag) {
					
					for (var i in DIMENSION.user) {
						if (DIMENSION.user[i].DIM_CD.indexOf("SALES_PRICE_KRW") > -1) {
							DIMENSION.user[i].numberFormat = "#,##0";
						}
					}
					
					salesPlanVs.grid.gridInstance.setDraw();
					
					
					var lookUptemp   = "";
					var lookUpKeys   = [];
					var lookUpValues = [];
					
					$.each(salesPlanVs.comCode.codeReason, function() {
						if (this.ATTB_1_CD != lookUptemp) {
							lookUpKeys.push([this.ATTB_1_CD," "]);
							lookUpValues.push(" ");
							lookUptemp = this.ATTB_1_CD;
						}
						
						lookUpKeys.push([this.ATTB_1_CD,this.CODE_CD]);
						lookUpValues.push(this.CODE_NM);
					});
					
					salesPlanVs.grid.grdMain.setLookups([{
						id      : "LOOKUP_PTSP_REASON_ID",
						levels  : 2,
						ordered : true,
						keys    : lookUpKeys,
						values  : lookUpValues
					}]);
					
					var fileds = salesPlanVs.grid.dataProvider.getFields();
					
					for (var i in fileds) {
						if (fileds[i].fieldName.indexOf("SALES_PRICE_KRW") > -1) {
							fileds[i].dataType = "number";
						}
					}
					salesPlanVs.grid.dataProvider.setFields(fileds);
					
					// 컬럼 숨김 
					var sQty = $("#sQty").prop("checked");
					var sAmt = $("#sAmt").prop("checked");
					
					$.each(MEASURE.user, function(idx) {
						salesPlanVs.grid.grdMain.setColumnProperty(this.CD, "visible", true);
					});
					
					if(!sQty) {
						salesPlanVs.grid.grdMain.setColumnProperty("QTY_GROUP", "visible", false);
					}
					
					if(!sAmt) {
						salesPlanVs.grid.grdMain.setColumnProperty("AMT_GROUP", "visible", false);
					}
					
				}
			},
			
			excelSubSearch : function (){
				
				EXCEL_SEARCH_DATA = "";
				EXCEL_SEARCH_DATA += "Customer" + " : ";
				EXCEL_SEARCH_DATA += $("#loc_customer").html();
				
				$.each($(".view_combo"), function(i, val){
					
					var temp = "";
					var id = gfn_nvl($(this).attr("id"), "");
					
					if(id != ""){
						
						var name = gfn_nvl($("#" + id + " .ilist .itit").html(), "");
						
						if(name == ""){
							name = $("#" + id + " .filter_tit").html();
						}
						
						//타이틀
						EXCEL_SEARCH_DATA += "\n" + name + " : ";	
						
						//데이터
						if(id == "divReptCustGroup"){
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
						}else if(id == "divQtyAmtGubun"){
							var cnt = 0;
							if($("#sQty").prop("checked")){
								cnt++;
								EXCEL_SEARCH_DATA += '<spring:message code="lbl.qty"/>';
							}
							if($("#sAmt").prop("checked")){
								if(cnt == 1){
									EXCEL_SEARCH_DATA += ", ";
								}
								EXCEL_SEARCH_DATA += '<spring:message code="lbl.amt"/>';
							}
						}else if(id == "divType"){
							EXCEL_SEARCH_DATA += $("#type option:selected").text();
						}else if(id == "divGigan"){
							EXCEL_SEARCH_DATA += $("#gigan option:selected").text();
						}else if(id == "divReason"){
							EXCEL_SEARCH_DATA += $("#reason option:selected").text();
						}
						
						else if(id == "divDept"){
							EXCEL_SEARCH_DATA += $("#dept option:selected").text();
						}else if(id == "divAddSalesAvail"){
							EXCEL_SEARCH_DATA += $("#addSalesAvail option:selected").text();
						}
						else if(id == "divSalesDelta"){
							EXCEL_SEARCH_DATA += $("#saleRateFrom").val() + " ~ " + $("#saleRateTo").val();
						}
					}
				});
				
				EXCEL_SEARCH_DATA += "\n" + '<spring:message code="lbl.period"/>' + " : ";
				EXCEL_SEARCH_DATA += $("#fromCal").val() + "(" + $("#fromPWeek").val() + ") ~ ";
				EXCEL_SEARCH_DATA += $("#toCal").val() + "(" + $("#toPWeek").val() + ")"; 
				
			},
			
			search : function() {
				FORM_SEARCH._mtd     = "getList";
				FORM_SEARCH.tranData = [{ outDs : "resList",_siq : "dp.salesPerformNew.salesPlanVsActual" }];
				
				var aOption = {
					url     : GV_CONTEXT_PATH + "/biz/obj.do",
					data    : FORM_SEARCH,
					success : function (data) {
						
						if (FORM_SEARCH.sql == 'N') {
							//그리드 데이터 삭제
							salesPlanVs.grid.dataProvider.clearRows();
							salesPlanVs.grid.grdMain.cancel();
							//그리드 데이터 생성
							salesPlanVs.grid.dataProvider.setRows(data.resList);
						
							//month sum omit0
							gfn_actionMonthSum(salesPlanVs.grid.gridInstance);
							gfn_setRowTotalFixed(salesPlanVs.grid.grdMain);
							
							$.each(MEASURE.user, function(idx) {
								salesPlanVs.grid.grdMain.setColumnProperty(this.CD, "displayWidth", 80);
							});
							
							
							fn_gridCallback(data.resList);
						}
					}
				}
				
				gfn_service(aOption, "obj");
			}
	};
	
	//조회
	var fn_apply = function (sqlFlag) {
		fn_checkClose();
		
		var sQty = $("#sQty").prop("checked");
		var sAmt = $("#sAmt").prop("checked");
		
		if(!sQty && !sAmt) {
			alert('<spring:message code="msg.qtyAmtCheck"/>');
			return;
		}

		gfn_getMenuInit();
		salesPlanVs.getBucket(sqlFlag); 
		
		FORM_SEARCH            = $("#searchForm").serializeObject(); 
    	FORM_SEARCH.sql        = sqlFlag;
   		FORM_SEARCH.hrcyFlag   = true;
   		FORM_SEARCH.dimList    = DIMENSION.user;
   		FORM_SEARCH.meaList	   = MEASURE.user;
   		
   		salesPlanVs.search();
   		salesPlanVs.excelSubSearch();
	}
	
	function fn_gridCallback(list) {
		
		LIST_DATA = list;
		
		var listCnt = list.length;
		//var editCnt = 0;
		var reasonCol = salesPlanVs.grid.grdMain.columnByName("PTSP_REASON_ID");
		
		salesPlanVs.grid.dataProvider.beginUpdate();
		
		for(var i=0; i < listCnt; i++) {
			if(list[i].GRP_LVL_ID != "0") {
				
				salesPlanVs.grid.grdMain.setCellStyles(i, "PTSP_TYPE_NM"  , "nonEditStyleRow");
				salesPlanVs.grid.grdMain.setCellStyles(i, "PTSP_REASON_ID", "nonEditStyleRow");
				salesPlanVs.grid.grdMain.setCellStyles(i, "PTSP_DEPT"     , "nonEditStyleRow");
				salesPlanVs.grid.grdMain.setCellStyles(i, "REMARK"        , "nonEditStyleRow");
				
				salesPlanVs.grid.dataProvider.setValue(i, "PTSP_TYPE_NM"  , "");
				salesPlanVs.grid.dataProvider.setValue(i, "PTSP_REASON_ID", "");
				salesPlanVs.grid.dataProvider.setValue(i, "PTSP_DEPT"     , "");
				salesPlanVs.grid.dataProvider.setValue(i, "REMARK"        , "");
				
				salesPlanVs.grid.dataProvider.setRowState(i, "none");
				
			} else {
			
				var yearWeek    = list[i].YEARWEEK;
				//var editYearweek    = list[i].EDIT_YEARWEEK;
				var preYearWeek = list[i].PRE_YEARWEEK;
				var type        = list[i].PTSP_TYPE;
				
				if(type == "PTSP_TYPE_1") {// 수정 못하게
					salesPlanVs.grid.grdMain.setCellStyles(i, "PTSP_REASON_ID", "nonEditStyleRow");
				} else if(type == "PTSP_TYPE_2") {
					salesPlanVs.grid.grdMain.setCellStyles(i, "PTSP_REASON_ID", "editStyleRow");
				} else if(type == "PTSP_TYPE_3") {
					salesPlanVs.grid.grdMain.setCellStyles(i, "PTSP_REASON_ID", "editStyleRow");
				}
				
				salesPlanVs.grid.grdMain.setColumn(reasonCol);
				
				if(yearWeek != preYearWeek) {
					salesPlanVs.grid.grdMain.setCellStyles(i, "PTSP_TYPE_NM"  , "nonEditStyleRow");
					salesPlanVs.grid.grdMain.setCellStyles(i, "PTSP_REASON_ID", "nonEditStyleRow");
					salesPlanVs.grid.grdMain.setCellStyles(i, "PTSP_DEPT"     , "nonEditStyleRow");
					salesPlanVs.grid.grdMain.setCellStyles(i, "REMARK"        , "nonEditStyleRow");
				}
			}
		}
		
		salesPlanVs.grid.dataProvider.endUpdate();
	}
	
	//그리드 초기화
	function fn_reset() {
		
		var listCnt = LIST_DATA.length;
		//var editCnt = 0;
		var reasonCol = salesPlanVs.grid.grdMain.columnByName("PTSP_REASON_ID");
		
		salesPlanVs.grid.dataProvider.beginUpdate();
		
		for(var i=0; i < listCnt; i++) {
			
			if(LIST_DATA[i].GRP_LVL_ID != "0") {
				
				salesPlanVs.grid.grdMain.setCellStyles(i, "PTSP_TYPE_NM"  , "nonEditStyleRow");
				salesPlanVs.grid.grdMain.setCellStyles(i, "PTSP_REASON_ID", "nonEditStyleRow");
				salesPlanVs.grid.grdMain.setCellStyles(i, "PTSP_DEPT"     , "nonEditStyleRow");
				salesPlanVs.grid.grdMain.setCellStyles(i, "REMARK"        , "nonEditStyleRow");
				
				salesPlanVs.grid.dataProvider.setValue(i, "PTSP_TYPE_NM"  , "");
				salesPlanVs.grid.dataProvider.setValue(i, "PTSP_REASON_ID", "");
				salesPlanVs.grid.dataProvider.setValue(i, "PTSP_DEPT"     , "");
				salesPlanVs.grid.dataProvider.setValue(i, "REMARK"        , "");
				
				salesPlanVs.grid.dataProvider.setRowState(i, "none");
				
			} else {
			
				var yearWeek    = LIST_DATA[i].YEARWEEK;
				var editYearweek = LIST_DATA[i].EDIT_YEARWEEK;
				var preYearWeek = LIST_DATA[i].PRE_YEARWEEK;
				var type        = LIST_DATA[i].PTSP_TYPE;
				
				if(type == "PTSP_TYPE_1") {// 수정 못하게
					salesPlanVs.grid.grdMain.setCellStyles(i, "PTSP_REASON_ID", "nonEditStyleRow");
				} else if(type == "PTSP_TYPE_2") {
					salesPlanVs.grid.grdMain.setCellStyles(i, "PTSP_REASON_ID", "editStyleRow");
				} else if(type == "PTSP_TYPE_3") {
					salesPlanVs.grid.grdMain.setCellStyles(i, "PTSP_REASON_ID", "editStyleRow");
				}
				
				salesPlanVs.grid.grdMain.setColumn(reasonCol);
				
				
				if(yearWeek != preYearWeek) {
					salesPlanVs.grid.grdMain.setCellStyles(i, "PTSP_TYPE_NM"  , "nonEditStyleRow");
					salesPlanVs.grid.grdMain.setCellStyles(i, "PTSP_REASON_ID", "nonEditStyleRow");
					salesPlanVs.grid.grdMain.setCellStyles(i, "PTSP_DEPT"     , "nonEditStyleRow");
					salesPlanVs.grid.grdMain.setCellStyles(i, "REMARK"        , "nonEditStyleRow");
				}
			}
		}
		
		salesPlanVs.grid.dataProvider.endUpdate();
	}
	
	function fn_checkClose() {
		return gfn_getGrdSaveCount(salesPlanVs.grid.grdMain) == 0;
	}
	
	//그리드 저장
	function fn_save() {
		//수정된 그리드 데이터
		var grdData = gfn_getGrdSavedataAll(salesPlanVs.grid.grdMain);
		if (grdData.length == 0) {
			alert('<spring:message code="msg.noChangeData"/>');
			return;
		}
		
		if(grdData[0].ITEM_CD && grdData[0].CUST_GROUP_CD && grdData[0].YEARWEEK) {
			// 저장
			confirm('<spring:message code="msg.saveCfm"/>', function() {
				FORM_SAVE          = {}; //초기화
				FORM_SAVE._mtd     = "saveUpdate";
				FORM_SAVE.tranData = [{outDs:"saveCnt",_siq:"dp.salesPerformNew.salesPlanVsActual",grdData:grdData}];
				
				gfn_service({
					url    : GV_CONTEXT_PATH + "/biz/obj.do",
					data   : FORM_SAVE,
					success: function(data) {
						alert('<spring:message code="msg.saveOk"/>');
						fn_apply();
					}
				}, "obj");
			});
		} else {
			
			alert(gfn_getDomainMsg("msg.dimConfMsg", "<spring:message code='lbl.weekDim'/>,<spring:message code='lbl.custGroup'/>,<spring:message code='lbl.item'/>"));
			return;
		}
		
	}
	
	//팝업 오픈
	function fn_openPopup(type) {
		if (type == "TYPE") {
			gfn_comPopupOpen("SALES_TYPE_CHART", {
				rootUrl : "dp/salesPerform",
				url     : "typeChart",
				width   : 1024,
				height  : 680,
				menuCd  : "DP30901",
				fromWeek: $("#fromWeek").val(),
		   		toWeek  : $("#toWeek").val(),
		   		type    : $("#type").val()
			});
		} else if (type == "REASON") {
			gfn_comPopupOpen("SALES_REASON_CHART", {
				rootUrl : "dp/salesPerform",
				url     : "reasonChart",
				width   : 1024,
				height  : 680,
				menuCd  : "DP30902",
				fromWeek: $("#fromWeek").val(),
		   		toWeek  : $("#toWeek").val()
			});
		} else if (type == "DEPT") {
			gfn_comPopupOpen("SALES_DEPT_CHART", {
				rootUrl : "dp/salesPerform",
				url     : "deptChart",
				width   : 1024,
				height  : 680,
				menuCd  : "DP30903",
				fromWeek: $("#fromWeek").val(),
		   		toWeek  : $("#toWeek").val()
			});
		} else if(type == "CUST") {
			gfn_comPopupOpen("SALES_CUST_CHART", {
				rootUrl  : "dp/salesPerform",
				url      : "planSalesStatusChart",
				width    : 1060,
				height   : 540,
				menuCd   : "DP30904",
				fromWeek : $("#fromWeek").val(),
		   		toWeek   : $("#toWeek").val()
			});
		}
	}
	
	function fn_setNextFieldsBuket() {
		
		var fields = [
			{fieldName: "QTY_INV"         , dataType : "number" },
			{fieldName: "QTY_SALES_PLAN"  , dataType : "number" },
			{fieldName: "QTY_SALES"       , dataType : "number" },
			{fieldName: "QTY_AVAIL_SALES" , dataType : "number" },
			{fieldName: "QTY_PROD_PLAN"   , dataType : "number" },
			{fieldName: "QTY_PROD"        , dataType : "number" },
			{fieldName: "QTY_SALES_DELTA" , dataType : "number" },
			{fieldName: "QTY_PROD_DELTA"  , dataType : "number" },
			{fieldName: "QTY_AVAIL_ADD_SALES" , dataType : "number" },
			{fieldName: "QTY_EXP_INV" , dataType : "number" },
			{fieldName: "AMT_AVAIL_SALES" , dataType : "number" },
			{fieldName: "AMT_AVAIL_ADD_SALES" , dataType : "number" },
			{fieldName: "QTY_COMP_RATE"   , dataType : "number" },
			{fieldName: "AMT_INV"         , dataType : "number" },
			{fieldName: "AMT_SALES_PLAN"  , dataType : "number" },
			{fieldName: "AMT_SALES"       , dataType : "number" },
			{fieldName: "AMT_PROD_PLAN"   , dataType : "number" },
			{fieldName: "AMT_PROD"        , dataType : "number" },
			{fieldName: "AMT_SALES_DELTA" , dataType : "number" },
			{fieldName: "AMT_EXP_INV" , dataType : "number" },
			{fieldName: "AMT_COMP_RATE"   , dataType : "number" },
			{fieldName: "PTSP_TYPE"       , dataType : "text" },
			{fieldName: "PTSP_TYPE_NM"    , dataType : "text" },
			{fieldName: "PTSP_REASON_ID"  , dataType : "text" },
			{fieldName: "PTSP_DEPT"       , dataType : "text" },
			{fieldName: "REMARK"          , dataType : "text" }
        ];
		
    	return fields;
	}
	
	function fn_setNextColumnsBuket() {
		var columns = [	
			{
				type: "group",
				name: 'QTY_GROUP',
				header: {text : '<spring:message code="lbl.qty"/>' + gv_expand },
				fieldName: "QTY_GROUP",
				width: 640,
				columns : [
					{
						name : "QTY_INV", fieldName: "QTY_INV", editable: false, header: {text: '<spring:message code="lbl.invQty" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						visible : false,
						width: 80
					},
					{
						name : "QTY_EXP_INV", fieldName: "QTY_EXP_INV", editable: false, header: {text: '<spring:message code="lbl.preFirstWeekInv" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						visible : false,
						width: 80
					},
					{
						name : "QTY_SALES_PLAN", fieldName: "QTY_SALES_PLAN", editable: false, header: {text: '<spring:message code="lbl.salesPlan" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						visible : false,
						width: 80
					},
					{
						name : "QTY_SALES", fieldName: "QTY_SALES", editable: false, header: {text: '<spring:message code="lbl.salesPerform" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						visible : false,
						width: 80
					},
					{
						name : "QTY_AVAIL_SALES", fieldName: "QTY_AVAIL_SALES", editable: false, header: {text: '<spring:message code="lbl.salesAvailQty" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						visible : false,
						width: 80
					},
					{
						name : "QTY_PROD_PLAN", fieldName: "QTY_PROD_PLAN", editable: false, header: {text: '<spring:message code="lbl.prodPlanDay" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						visible : false,
						width: 80
					},
					{
						name : "QTY_PROD", fieldName: "QTY_PROD", editable: false, header: {text: '<spring:message code="lbl.prodPerformanceDay" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						visible : false,
						width: 80
					},
					{
						name : "QTY_SALES_DELTA", fieldName: "QTY_SALES_DELTA", editable: false, header: {text: '<spring:message code="lbl.salesDelta" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						visible : false,
						width: 80
					},
					/*
					{
						name : "QTY_PROD_DELTA", fieldName: "QTY_PROD_DELTA", editable: false, header: {text: '<spring:message code="lbl.prodDelta" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						visible : false,
						width: 80
					},
					*/
					{
						name : "QTY_AVAIL_ADD_SALES", fieldName: "QTY_AVAIL_ADD_SALES", editable: false, header: {text: '<spring:message code="lbl.availAddSales" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						visible : false,
						width: 80
					},
					
					
					
					{
						name : "QTY_COMP_RATE", fieldName: "QTY_COMP_RATE", editable: false, header: {text: '<spring:message code="lbl.cmplRate" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0.00"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						visible : false,
						width: 80
					}
				]
			},
			{
				type: "group",
				name: 'AMT_GROUP',
				header: {text : '<spring:message code="lbl.amount"/>' + gv_expand },
				fieldName: "AMT_GROUP",
				width: 640,
				columns : [
					{
						name : "AMT_INV", fieldName: "AMT_INV", editable: false, header: {text: '<spring:message code="lbl.invQty" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						visible : false,
						width: 80
					},
					{
						name : "AMT_EXP_INV", fieldName: "AMT_EXP_INV", editable: false, header: {text: '<spring:message code="lbl.preFirstWeekInv" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						visible : false,
						width: 80
					},
					{
						name : "AMT_SALES_PLAN", fieldName: "AMT_SALES_PLAN", editable: false, header: {text: '<spring:message code="lbl.salesPlan" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						visible : false,
						width: 80
					},
					{
						name : "AMT_SALES", fieldName: "AMT_SALES", editable: false, header: {text: '<spring:message code="lbl.salesPerform" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						visible : false,
						width: 80
					},
					{
						name : "AMT_AVAIL_SALES", fieldName: "AMT_AVAIL_SALES", editable: false, header: {text: '<spring:message code="lbl.salesAvailAmt" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						visible : false,
						width: 80
					},
					{
						name : "AMT_PROD_PLAN", fieldName: "AMT_PROD_PLAN", editable: false, header: {text: '<spring:message code="lbl.prodPlanDay" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						visible : false,
						width: 80
					},
					{
						name : "AMT_PROD", fieldName: "AMT_PROD", editable: false, header: {text: '<spring:message code="lbl.prodPerformanceDay" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						visible : false,
						width: 80
					},
					{
						name : "AMT_SALES_DELTA", fieldName: "AMT_SALES_DELTA", editable: false, header: {text: '<spring:message code="lbl.salesDelta" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						visible : false,
						width: 80
					},
					{
						name : "AMT_AVAIL_ADD_SALES", fieldName: "AMT_AVAIL_ADD_SALES", editable: false, header: {text: '<spring:message code="lbl.availAddSales" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						visible : false,
						width: 80
					},
					/* {
						name : "AMT_PROD_DELTA", fieldName: "AMT_PROD_DELTA", editable: false, header: {text: '<spring:message code="lbl.prodDelta" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						visible : false,
						width: 80
					}, */
					{
						name : "AMT_COMP_RATE", fieldName: "AMT_COMP_RATE", editable: false, header: {text: '<spring:message code="lbl.cmplRate" javaScriptEscape="true" />'},
						styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0.00"},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						dataType : "number",
						visible : false,
						width: 80
					}
				]
			},
			{
				name : "PTSP_TYPE_NM", fieldName: "PTSP_TYPE_NM", editable: false, header: {text: '<spring:message code="lbl.type2" javaScriptEscape="true" />'},
				styles: {textAlignment: "near", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "text",
				width: 100
			}, {
				name : "PTSP_TYPE", fieldName: "PTSP_TYPE", editable: false, header: {text: '<spring:message code="lbl.type2" javaScriptEscape="true" />'},
				dataType : "text",
				width: 0,
				visible : true
			},{
				name : "PTSP_REASON_ID", fieldName: "PTSP_REASON_ID", header: {text: '<spring:message code="lbl.reason" javaScriptEscape="true" />'},
				styles: {textAlignment: "near", background : gv_editColor},
				dataType : "text",
				width    : 120,
				editable : true,
				editor   : { type: "dropDown", domainOnly: true },
				lookupDisplay: true,
				lookupSourceId :"LOOKUP_PTSP_REASON_ID", 
				lookupKeyFields:["PTSP_TYPE","PTSP_REASON_ID"]
			}, {
				name : "PTSP_DEPT", fieldName: "PTSP_DEPT", header: {text: '<spring:message code="lbl.dept" javaScriptEscape="true" />'},
				styles: {textAlignment: "near", background : gv_editColor},
				dataType : "text",
				width: 100,
				editable : true,
				editor   : { type: "dropDown", domainOnly: true },
				values   : gfn_getArrayExceptInDs(salesPlanVs.comCode.codeMap.PTSP_DEPT, "CODE_CD", ""),
				labels   : gfn_getArrayExceptInDs(salesPlanVs.comCode.codeMap.PTSP_DEPT, "CODE_NM", ""),
				lookupDisplay: true
			}, {
				name : "REMARK", fieldName: "REMARK", header: {text: '<spring:message code="lbl.remark" javaScriptEscape="true" />'},
				styles: {textAlignment: "near", background : gv_editColor},
				dataType : "text",
				width: 100,
				editable : true
			}
		];
		
		
		return columns;
	}
	
	$(document).ready(function() {
		salesPlanVs.init();
	});
</script>
</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp"%>
	<!-- left -->
	<div id="a" class="split split-horizontal">
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
							<div class="view_combo" id="divReptCustGroup"></div>
							<div class="view_combo" id="divCustGroup"></div>
							<div class="view_combo" id="divItemGroup"></div>
							<div class="view_combo" id="divItem"></div>
							<div class="view_combo" id="divQtyAmtGubun">
								<strong class="filter_tit"><spring:message code="lbl.qtyAmtGubun"/></strong>
								<ul class="rdofl">
									<li><input type="checkbox" id="sQty" name="sQty" val="QTY" checked/><label for="sQty"><spring:message code="lbl.qty"/></label></li>
									<li><input type="checkbox" id="sAmt" name="sAmt" val="AMT" checked/><label for="sAmt"><spring:message code="lbl.amt"/></label></li>
								</ul>
							</div>
							<div class="view_combo" id="divType"></div>
							<div class="view_combo" id="divGigan"></div>
							<div class="view_combo" id="divReason"></div>
							<div class="view_combo" id="divDept"></div>
							<div class="view_combo" id="divAddSalesAvail"></div>
							<div class="view_combo" id="divSalesDelta">
								<div class="ilist">
									<div class="itit"><spring:message code="lbl.sales" /> <spring:message code="lbl.delta" /></div>
									<input type="text" id="saleRateFrom" name="saleRateFrom" class="ipt" style="width:55px"/> <span class="ihpen">~</span>
									<input type="text" id="saleRateTo" name="saleRateTo" class="ipt" style="width:55px"/>
								</div> 
							</div>
							
							
							<jsp:include page="/WEB-INF/view/common/filterViewHorizon.jsp" flush="false">
								<jsp:param name="radioYn" value="N" />
								<jsp:param name="wType" value="SW" />
							</jsp:include>
						</div>
						<div class="bt_btn">
							<a href="javascript:;" class="fl_app"><spring:message code="lbl.search" /></a>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
	<!-- contents -->
	<div id="b" class="split split-horizontal">
		<div id="grid1" class="fconbox">
			<%@ include file="/WEB-INF/view/common/commonLocation.jsp"%>
			<div class="scroll">
				<!-- 그리드영역 -->
				<div id="realgrid" class="realgrid1"></div>
			</div>
			<div class="cbt_btn">
				<div class="bleft">
					<a href="javascript:;" id="btnOpenPopupType"   class="app authClass DP30901"><spring:message code="lbl.type2"/></a>
					<a href="javascript:;" id="btnOpenPopupReason" class="app authClass DP30902"><spring:message code="lbl.reason"/></a>
					<a href="javascript:;" id="btnOpenPopupDept"   class="app authClass DP30903"><spring:message code="lbl.dept"/></a>
					<a href="javascript:;" id="btnOpenPopupCust"   class="app authClass DP30904"><spring:message code="lbl.reptCustGroup"/></a>
				</div>
				<div class="bright">
					<a href="javascript:;" id="btnReset" class="app1"><spring:message code="lbl.reset"/></a>
					<a href="javascript:;" id="btnSave" class="app2 roleWrite"><spring:message code="lbl.save"/></a>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
