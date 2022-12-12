<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>

	<script type="text/javascript">

	var enterSearchFlag = "Y";
	var lamSalesTrendMonthly = {

		init : function () {
			
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.grid.initGrid();
		},
			
		_siq : "dp.salesPerform.lamSalesTrendMonthly",
		
		initFilter : function() {
			
			gfn_keyPopAddEvent([
				{ target : 'divItem', id : 'item', type : 'COM_ITEM_PLAN', title : '<spring:message code="lbl.item"/>' }
			]);
			
			// 콤보박스
			gfn_setMsComboAll([
				/* { target : 'divYear', id : 'year', title : '<spring:message code="lbl.year"/>', data : this.comCode.codeMap.YEAR_INFO, exData:[  ], type : "S" }, */
				/* { target : 'divLamOrdType', id : 'lamOrdType', title : '<spring:message code="lbl.keyProd"/>', data : this.comCode.codeMap.LAM_ORD_TYPE, exData:["*"], type : "S"}, */
			]);
			
			MONTHPICKER(null, 0, 0);
			var baseDt = new Date();
			
			$("#fromMon").monthpicker("option", "maxDate", new Date(baseDt.getFullYear(), baseDt.getMonth(), '01'));
		},
		
		/*
		* common Code 
		*/
		comCode : {
			
			codeMap : null,
			codeMapEx : null,
			
			initCode  : function () {
				var grpCd = 'LAM_ORD_TYPE';
				this.codeMap = gfn_getComCode(grpCd, 'Y'); //공통코드 조회
			}
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
			
			$("#btnSummary").on('click', function (e) {
				
				gfn_comPopupOpen("CPFR_SUMMARY", {
					rootUrl : "dp/salesPerform",
					url     : "lamSalesTrendMonthlySummary",
					width   : 1200,
					height  : 680,
					year : $("#fromMon").val().substring(0, 4),
					menuCd  : "DP312"
				});
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
					
					if(id == "divItem"){
						EXCEL_SEARCH_DATA += $("#item_nm").val();
					}else if(id == "divSpec"){
						EXCEL_SEARCH_DATA += $("#spec").val();
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
						
						lamSalesTrendMonthly.grid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						lamSalesTrendMonthly.grid.grdMain.cancel();
						
						lamSalesTrendMonthly.grid.dataProvider.setRows(data.resList);
						lamSalesTrendMonthly.grid.dataProvider.clearSavePoints();
						lamSalesTrendMonthly.grid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(lamSalesTrendMonthly.grid.dataProvider.getRowCount());
						gfn_setRowTotalFixed(lamSalesTrendMonthly.grid.grdMain);
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		getBucket : function (sqlFlag) {
			
			var ajaxMap = {
				fromMonth : gfn_replaceAll($("#fromMon").val(), "-", ""),
				sqlId    : ["dp.salesPerform.bucketLamMonth1", "dp.salesPerform.bucketLamMonth2"]
			}
			
			gfn_getBucket(ajaxMap);
			
			if(!sqlFlag) {
				lamSalesTrendMonthly.grid.gridInstance.setDraw();
				
				var fileds = lamSalesTrendMonthly.grid.dataProvider.getFields();
				var filedsLen = fileds.length;
				
				for (var i = 0; i < filedsLen; i++) {
					var fieldName = fileds[i].fieldName;
					if (fieldName == 'SALES_PRICE_KRW_NM'){
						fileds[i].dataType = "number";
						lamSalesTrendMonthly.grid.grdMain.setColumnProperty(fieldName, "styles", {"numberFormat" : "#,##0"});	
					}
				}
				lamSalesTrendMonthly.grid.dataProvider.setFields(fileds);
			} 
		}
	};

	//조회
	var fn_apply = function (sqlFlag) {
		
		// 디멘젼, 메져
		gfn_getMenuInit();
		
    	lamSalesTrendMonthly.getBucket(sqlFlag); //2. 버켓정보 조회
    	
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
   		FORM_SEARCH.hrcyFlag   = true;
   		FORM_SEARCH.dimList    = DIMENSION.user;
   		FORM_SEARCH.meaList    = MEASURE.user;
   		FORM_SEARCH.bucketList = BUCKET.query;
   		
		lamSalesTrendMonthly.search();
		lamSalesTrendMonthly.excelSubSearch();
	};
	

	function fn_setNextFieldsBuket() {
    	//필드 배열 객체를  생성합니다.
        var fields = [
            {fieldName : "PAST_3_MONTH", dataType : "number"},
            {fieldName : "FUTURE_3_MONTH", dataType : "number"},
            {fieldName : "PAST_FUTURE_3_MONTH", dataType : "number"},
        ];
    	return fields;
    }

    function fn_setNextColumnsBuket() {
    	//필드와 연결된 컬럼 배열 객체를 생성합니다.
        var columns = 
		[	
			{
				name : "PAST_3_MONTH", fieldName: "PAST_3_MONTH", editable: false, header: {text: '<spring:message code="lbl.past3Avg" javaScriptEscape="true" />'},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				styles: {textAlignment: "far", numberFormat : "#,##0"},
				dataType : "number",
				nanText : "",
				width: 100
			}, {
				name : "FUTURE_3_MONTH", fieldName: "FUTURE_3_MONTH", editable: false, header: {text: '<spring:message code="lbl.future3Avg" javaScriptEscape="true" />'},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				styles: {textAlignment: "far", numberFormat : "#,##0"},
				dataType : "number",
				nanText : "",
				width: 100
			}, {
				name : "PAST_FUTURE_3_MONTH", fieldName: "PAST_FUTURE_3_MONTH", editable: false, header: {text: '<spring:message code="lbl.pastFuture3Avg" javaScriptEscape="true" />'},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				styles: {textAlignment: "far", numberFormat : "#,##0"},
				dataType : "number",
				nanText : "",
				width: 100
			}
		];
    	return columns;
    }


	// onload 
	$(document).ready(function() {
		lamSalesTrendMonthly.init();
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
				<%-- <%@ include file="/WEB-INF/view/common/filterMonthSum.jsp" %>  --%>
				<div class="tabMargin"></div>
				<div class="scroll">
					<div class="view_combo" id="divItem"></div>
					<div class="view_combo" id="divSpec">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.spec"/></div>
							<input type="text" id="spec" name="spec" class="ipt"/>
						</div>
					</div>
					<div class="view_combo" id="divMonth">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.month" /></div>
							<input type="text" id="fromMon" name="fromMon" class="iptdate datepicker2 monthpicker" value="">
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
			<!-- <div class="use_tit">
				<h3>My Opportunities</h3> <h4>- recently created</h4>
			</div> -->
			<div class="scroll">
				<!-- 그리드영역 -->
				<div id="realgrid" style="width: 100%;" class="realgrid1"></div>
			</div>
			<div class="cbt_btn" style="height:25px">
				<div class="bleft">
				</div>
				<div class="bright">
					<a href="javascript:;" id="btnSummary" class="app1"><spring:message code="lbl.summary" /></a>
				</div>
			</div>
		</div>
    </div>
</body>
</html>
