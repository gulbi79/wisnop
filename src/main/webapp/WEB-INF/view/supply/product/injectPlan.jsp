<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	<!-- Production Input Plan, 생산투입계획 -->
	<script type="text/javascript">

	var enterSearchFlag = "Y";
	var datePickerOption;
	var injectPlan = {

		init : function () {
			
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.salesGrid.initGrid();
		},
			
		_siq    : "supply.product.injectPlan",
		 
		initFilter : function() {
			//품목대그룹
			var upperItemEvent = {
				childId   : ["itemGroup"],
				childData : [this.comCode.codeMapEx.ITEM_GROUP],
			};
			// 키워드팝업
			gfn_keyPopAddEvent([
				{ target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>' }
			]);
			
			// 콤보박스
			gfn_setMsComboAll([
				{ target : 'divProcurType'   , id : 'procurType'   , title : '<spring:message code="lbl.procure"/>'         , data : this.comCode.codeMap.PROCUR_TYPE        , exData:[""]},
				{ target : 'divUpItemGroup'  , id : 'upItemGroup'  , title : '<spring:message code="lbl.upperItemGroup"/>'  , data : this.comCode.codeMapEx.UPPER_ITEM_GROUP , exData:["*"], event: upperItemEvent },
				{ target : 'divItemGroup'    , id : 'itemGroup'    , title : '<spring:message code="lbl.itemGroup"/>'       , data : this.comCode.codeMapEx.ITEM_GROUP       , exData:["*"] },
				{ target : 'divRoute'        , id : 'route'        , title : '<spring:message code="lbl.routing"/>'         , data : this.comCode.codeMapEx.ROUTING          , exData:["*"] },
				{ target : 'divRepCustGroup' , id : 'reptCustGroup', title : '<spring:message code="lbl.reptCustGroup"/>'   , data : this.comCode.codeMapEx.REP_CUST_GROUP   , exData:["*"] },
				{ target : 'divCustGroup'    , id : 'custGroup'    , title : '<spring:message code="lbl.custGroup"/>'       , data : this.comCode.codeMapEx.CUST_GROUP       , exData:["*"] },
				{ target : 'divInput'        , id : 'inputYn'      , title : '<spring:message code="lbl.inputAcceptance"/>' , data : this.comCode.codeMap.FLAG_YN            , exData:["*"], type : "S" },
				{ target : 'divInjectionNeed', id : 'injectionNeed', title : '<spring:message code="lbl.reqInputQty"/>'     , data : this.comCode.codeMap.INJECTION_NEED_CD  , exData:["*"], type : "S" },
			]);
			
			injectPlan.getPlanWeek();
		},
		
		/*
		* common Code 
		*/
		comCode : {
			codeMap   : null,
			codeMapEx : null,
			
			initCode  : function () {
				var grpCd = 'FLAG_YN,PROCUR_TYPE,INJECTION_NEED_CD';
				this.codeMap = gfn_getComCode(grpCd, 'Y'); //공통코드 조회
				
				this.codeMapEx = gfn_getComCodeEx(["REP_CUST_GROUP", "CUST_GROUP", "ITEM_GROUP", "ROUTING", "UPPER_ITEM_GROUP"], null, {itemType : "10,50"});
			}
		},
	
		/* 
		* grid  선언
		*/
		salesGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				this.gridInstance.custNextBucketFalg = true;
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
			},
		},
	
		/*
		* event 정의
		*/
		events : function () {
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("#planWeek").on("change", function(e){
				var params  = {};
				params._mtd = "getList";
				params.planWeek = $("#planWeek").val();
				params.tranData = [{outDs : "resList", _siq : "supply.product.planWeekCombo"}];
				
				var opt = {
					url     : GV_CONTEXT_PATH + "/biz/obj.do",
					data    : params,
					async   : false,
					success : function(data) {
						planWeekChange(data);
					}
				};
				gfn_service(opt, "obj");
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
						injectPlan.salesGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						injectPlan.salesGrid.grdMain.cancel();
						
						injectPlan.salesGrid.dataProvider.setRows(data.resList);
						injectPlan.salesGrid.dataProvider.clearSavePoints();
						injectPlan.salesGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(injectPlan.salesGrid.dataProvider.getRowCount());
						gfn_setRowTotalFixed(injectPlan.salesGrid.grdMain);
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		

		getPlanWeek : function() {
			var params  = {};
			params._mtd = "getList";
			params.tranData = [{outDs : "resList", _siq : "supply.product.planWeekCombo"}];
			
			var opt = {
				url     : GV_CONTEXT_PATH + "/biz/obj.do",
				data    : params,
				async   : false,
				success : function(data) {
					
					planWeekChange(data);
					
					gfn_setMsCombo("planWeek", data.resList, [""]);
				}
			};
			gfn_service(opt, "obj");
		},
	};
	
	//조회
	var fn_apply = function (sqlFlag) {
		
		gfn_getMenuInit();
		
		for (var i in DIMENSION.user) {
			if (DIMENSION.user[i].DIM_CD.indexOf("SALES_PRICE_KRW") > -1) {
				DIMENSION.user[i].numberFormat = "#,##0";
			}
		}
		
		injectPlan.salesGrid.gridInstance.setDraw();
		
		var fileds = injectPlan.salesGrid.dataProvider.getFields();
		
		for (var i in fileds) {
			if (fileds[i].fieldName.indexOf("SALES_PRICE_KRW") > -1) {
				fileds[i].dataType = "number";
			}
		}
		injectPlan.salesGrid.dataProvider.setFields(fileds);
    	
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
    	FORM_SEARCH.dimList    = DIMENSION.user;
		
		injectPlan.search();
	}
	
	function planWeekChange(data){
		
		var fromMaxYyyymmdd = data.resList[0].FROM_MAX_YYYYMMDD;
		var toMaxYyyymmdd = data.resList[0].TO_MAX_YYYYMMDD;
		
		datePickerOption = DATEPICKET(null, fromMaxYyyymmdd, toMaxYyyymmdd);
	}
	
	function fn_setNextFieldsBuket() {
		var fields = [
			  { fieldName : "SP_WEEK"}
			, { fieldName : "SP_QTY", dataType : "number"}
			, { fieldName : "PI_WEEK"}
			, { fieldName : "INV_QTY", dataType : "number"}
			, { fieldName : "PI_QTY", dataType : "number"}
			, { fieldName : "SP_AMT", dataType : "number"}
			, { fieldName : "AVAIL_PI_QTY", dataType : "number"}
			, { fieldName : "ADJ_PI_QTY", dataType : "number"}
			, { fieldName : "ADJ_SP_QTY", dataType : "number"}
			, { fieldName : "PROD_IN_DATE"}
			, { fieldName : "PROD_OUT_DATE"}
			, { fieldName : "PROD_MEMO"}
			, { fieldName : "SALES_MEMO"}
			, { fieldName : "PI_FLAG"}
			, { fieldName : "REMARK"}
        ];
    	
    	return fields;
	}
	
	function fn_setNextColumnsBuket() {
		var columns = [
			
			{
				name      : "SP_WEEK", fieldName : "SP_WEEK", header : {text : '<spring:message code="lbl.salesPlan"/>'},
				styles    : {textAlignment : "center", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				editable  : false,
				width     : 60
			}, {
				name      : "SP_QTY", fieldName : "SP_QTY", header : {text : '<spring:message code="lbl.salesPlanQty"/>'},
				styles    : {textAlignment : "far", numberFormat : "#,##0", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				editable  : false,
				width     : 120
			}, {
				name      : "PI_WEEK", fieldName : "PI_WEEK", header : {text : '<spring:message code="lbl.inputWeek"/>'},
				styles    : {textAlignment : "center", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				editable  : false,
				width     : 80
			}, {
				name      : "INV_QTY", fieldName : "INV_QTY", header : {text: '<spring:message code="lbl.inventoryOW"/>'},
				styles    : {textAlignment: "far", numberFormat : "#,##0", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType  : "number",
				editable  : false,
				width     : 100
			}, {
				name      : "PI_QTY", fieldName : "PI_QTY", header : {text: '<spring:message code="lbl.reqInputQty"/>'},
				styles    : {textAlignment: "far", numberFormat : "#,##0", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType  : "number",
				editable  : false,
				width     : 100
			}, {
				name      : "SP_AMT", fieldName : "SP_AMT", header : {text: '<spring:message code="lbl.reqInputAmount"/>'},
				styles    : {textAlignment: "far", numberFormat : "#,##0", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType  : "number",
				editable  : false,
				width     : 100
			}, {
				name      : "AVAIL_PI_QTY", fieldName : "AVAIL_PI_QTY", header : {text: '<spring:message code="lbl.possibleQty"/>'},
				styles    : {textAlignment: "far", numberFormat : "#,##0", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType  : "number",
				editable  : false,
				width     : 100
			}, {
				name      : "ADJ_PI_QTY", fieldName : "ADJ_PI_QTY", header : {text: '<spring:message code="lbl.adjustedProdQty"/>'},
				styles    : {textAlignment: "far", numberFormat : "#,##0", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType  : "number",
				editable  : false,
				width     : 100
			}, {
				name      : "ADJ_SP_QTY", fieldName : "ADJ_SP_QTY", header : {text: '<spring:message code="lbl.adjustedSalesQty"/>'},
				styles    : {textAlignment: "far", numberFormat : "#,##0", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType  : "number",
				editable  : false,
				width     : 100
			}, {
				name      : "PROD_IN_DATE", fieldName : "PROD_IN_DATE", header : {text: '<spring:message code="lbl.prodStartDate"/>'},
				styles    : {textAlignment: "center", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				editable  : false,
				width     : 100
			}, {
				name      : "PROD_OUT_DATE", fieldName : "PROD_OUT_DATE", header : {text: '<spring:message code="lbl.prodEndDate"/>'},
				styles    : {textAlignment: "center", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				editable  : false,
				width     : 100
			}, {
				name      : "PROD_MEMO", fieldName : "PROD_MEMO", header : {text: '<spring:message code="lbl.memoP"/>'},
				styles    : {textAlignment: "near", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				editable  : false,
				width     : 100
			}, {
				name      : "SALES_MEMO", fieldName : "SALES_MEMO", header : {text: '<spring:message code="lbl.memoS"/>'},
				styles    : {textAlignment: "near", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				editable  : false,
				width     : 100
			}, {
				name      : "PI_FLAG", fieldName : "PI_FLAG", header : {text: '<spring:message code="lbl.inputAcceptance"/>'},
				styles    : {textAlignment: "center", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				editable  : false,
				width     : 100
			}, {
				name      : "REMARK", fieldName : "REMARK", header : {text: '<spring:message code="lbl.reason"/>'},
				styles    : {textAlignment: "near", background : gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				editable  : false,
				width     : 100
			}
		];
		return columns;
	}

	// onload 
	$(document).ready(function() {
		injectPlan.init();
	});
	
	</script>

</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="a" class="split content split-horizontal">
		<form id="searchForm" name="searchForm">
		<input type="hidden" id="itemType" name="itemType" value="10,50"/>
		<div id="filterDv">
			<div class="inner">
				<h3>Filter</h3>
				<div class="tabMargin"></div>
				<div class="scroll">
					<div class="view_combo" id="divItem"></div>
					<div class="view_combo" id="divProcurType"></div>
					<div class="view_combo" id="divUpItemGroup"></div>
					<div class="view_combo" id="divItemGroup"></div>
					<div class="view_combo" id="divRoute"></div>
					<div class="view_combo" id="divRepCustGroup"></div>
					<div class="view_combo" id="divCustGroup"></div>
					<div class="view_combo" id="divInput"></div>
					<div class="view_combo" id="divInjectionNeed"></div>
					
					<div class="view_combo">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.planWeek"/></div>
							<div class="iptdv borNone">
								<select id="planWeek" name="planWeek" class="iptcombo"></select>
							</div>
						</div>
					</div>
					<jsp:include page="/WEB-INF/view/common/filterViewHorizon.jsp" flush="false">
						<jsp:param name="radioYn" value="N"/>
						<jsp:param name="wType" value="SW"/>
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
				<div id="realgrid" style="width: 100%;" class="realgrid1"></div>
			</div>
		</div>
    </div>
</body>
</html>
