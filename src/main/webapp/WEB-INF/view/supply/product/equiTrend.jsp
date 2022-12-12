<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	
	<script type="text/javascript">
	var enterSearchFlag = "Y";
	var equiTrend = {

		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.equiTrendGrid.initGrid();
		},
			
		_siq    : "supply.product.equiTrendList",
		
		initFilter : function() {
			
			// 키워드팝업
			gfn_keyPopAddEvent([
				//{ target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>'}
			]);
			
			// 콤보박스
			gfn_setMsComboAll([
				{target : 'divProdPart', id : 'prodPart', title : '<spring:message code="lbl.prodPart2"/>', data : this.comCode.codeMap.PROD_PART, exData:[""]},
				{target : 'divWorkplaces', id : 'workplaces', title : '<spring:message code="lbl.workplaces"/>', data : this.comCode.codeMapEx.WORK_PLACES_CD, exData:[""]},
				{target : 'divStdWorkHour', id : 'stdWorkHour', title : '<spring:message code="lbl.stdWorkHour"/>', data : this.comCode.codeMap.STD_WORK_HOUR, exData:["*"], type : "S"},
				{target : 'divOperRate', id : 'operRate', title : '<spring:message code="lbl.operRate"/>', data : this.comCode.codeMap.OPER_RATIO, exData:["*"], type : "S"}
			]);
			
			DATEPICKET(null, -11, 0);
			$("#fromCal").datepicker("option", "minDate", new Date().getWeekDay(-53));
			$("#toCal").datepicker("option", "maxDate", new Date().getWeekDay(0));
		},
		
		/*
		* common Code 
		*/
		comCode : {
			codeMap : null,
			codeMapEx : null,
			
			initCode : function () {
				var grpCd    = 'PROD_PART,STD_WORK_HOUR,OPER_RATIO';
				this.codeMap = gfn_getComCode(grpCd, 'Y'); //공통코드 조회
				this.codeMapEx = gfn_getComCodeEx(["WORK_PLACES_CD"], null, {itemType : "" });
				
				this.codeMap.STD_WORK_HOUR[0].CODE_NM = "";
				this.codeMap.OPER_RATIO[0].CODE_NM = "";
				
				$.each(this.codeMap.OPER_RATIO, function(i, val){
					
					var attb1Cd = gfn_nvl(val.ATTB_1_CD, "");
					
					if(attb1Cd != ""){
						val.CODE_CD = attb1Cd;
					}
				});
			}
		},
	
		/* 
		* grid  선언
		*/
		equiTrendGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				this.gridInstance.custBeforeBucketFalg = true;
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
			}
		},
	
		/*
		* event 정의
		*/
		events : function () {
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("#operRate").on("change", function(e){
				
				var operVal = gfn_nvl(this.value, "");
				
				if(operVal == ""){
					$("#operRatio").val(operVal);
				}else{
					$.each(equiTrend.comCode.codeMap.OPER_RATIO, function(i, val){
						
						var attb1Cd = gfn_nvl(val.ATTB_1_CD);
						var attb2Cd = gfn_nvl(val.ATTB_2_CD);
						
						if(operVal == attb1Cd){
							
							$("#operRatio").val(attb2Cd);
							return false;
						}
					});
				}
			});
			
			$("#btnDetail").on('click', function (e) {
				
				gfn_comPopupOpen("EQUI_TREND_DETAIL", {
					rootUrl : "supply/product",
					url     : "equiTrendDetail",
					width   : 800,
					height  : 680,
					prodPart : $("#prodPart").val(),
					workplaces : $("#workplaces").val(),
					fromDate : gfn_replaceAll($("#swFromDate").val(), "-", ""),
					toDate : gfn_replaceAll($("#swToDate").val(), "-", ""),
					menuCd: "MP112"
				});
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
					if(id == "divProdPart"){
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
						$.each($("#workplaces option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divStdWorkHour"){
						EXCEL_SEARCH_DATA += $("#stdWorkHour option:selected").text();
					}else if(id == "divOperRate"){
						EXCEL_SEARCH_DATA += $("#operRate option:selected").text();
					}
				}
			});
			
			EXCEL_SEARCH_DATA += "\n" + '<spring:message code="lbl.period"/>' + " : ";
			EXCEL_SEARCH_DATA += $("#fromCal").val() + "(" + $("#fromPWeek").val() + ") ~ ";
			EXCEL_SEARCH_DATA += $("#toCal").val() + "(" + $("#toPWeek").val() + ")";
			
		},
		
		// 조회
		search : function () {
			
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{outDs : "resList", _siq : this._siq }];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj.do",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						equiTrend.equiTrendGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						equiTrend.equiTrendGrid.grdMain.cancel();
						
						equiTrend.equiTrendGrid.dataProvider.setRows(data.resList);
						equiTrend.equiTrendGrid.dataProvider.clearSavePoints();
						equiTrend.equiTrendGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_actionMonthSum(equiTrend.equiTrendGrid.gridInstance);
						gfn_setRowTotalFixed(equiTrend.equiTrendGrid.grdMain);
						
						equiTrend.gridCallback();
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		getBucket : function (sqlFlag) {
			var ajaxMap = {
				fromDate : gfn_replaceAll($("#fromCal").val(), "-", ""),
				toDate   : gfn_replaceAll($("#toCal").val(), "-", ""),
	       		week     : {isDown: "N", isUp:"N", upCal:"M", isMt:"N", isExp:"N", expCnt:1, isUpDown : "UP"},
				sqlId    : ["bucketFullWeek"]
			};
			
			gfn_getBucket(ajaxMap);
			
			if (!sqlFlag) {
				
				DIMENSION.hidden = [];
				DIMENSION.hidden.push({CD : "AVG_VALUE_DIM", dataType : "text"});
				
				$.each(BUCKET.query, function(i, val){
					var orgName = val.CD;
					var name = orgName + "_DIM";
					DIMENSION.hidden.push({CD : name, BUCKET_ID : orgName, dataType : "text"});	
				});
				equiTrend.equiTrendGrid.gridInstance.setDraw();
			}
		},
		
		gridCallback : function () {
			
			var operRatio = gfn_nvl($("#operRatio").val(), "");
			
			if(operRatio != ""){
				
				$.each(DIMENSION.hidden, function(i, val){
					
					var orgCd = val.CD;
					var cd = gfn_replaceAll(orgCd, "_DIM", "");
					var editStyle = {};
					var val = gfn_getDynamicStyle(-2);
					
					editStyle.background = gv_editColor;
					editStyle.editable = false;
					
					val.criteria.push("(values['"+ orgCd +"'] = 'Y')");
					val.styles.push(editStyle);
					
					equiTrend.equiTrendGrid.grdMain.setColumnProperty(equiTrend.equiTrendGrid.grdMain.columnByField(cd), "dynamicStyles", [val]);
				});
			}
			
			

			var fileds = equiTrend.equiTrendGrid.dataProvider.getFields();
			var filedsLen = fileds.length;
			
			for (var i = 0; i < filedsLen; i++) {
				
				var fieldName = fileds[i].fieldName;
				var param = fieldName + "_NM";
				
				if(fieldName == "RESOURCE_CD3" || fieldName == "RESOURCE_NM3"){
					equiTrend.equiTrendGrid.grdMain.setColumnProperty(param, "mergeRule", {criteria:"row div 1"})
				}
			}
		}
	};
	
	//조회
	var fn_apply = function (sqlFlag) {
		
		var stdWorkHour = gfn_nvl($("#stdWorkHour").val(), "");
		
		if(stdWorkHour == ""){
			alert('<spring:message code="msg.stdWorkHourMsg" javaScriptEscape="true" />');
			return;
		}
		
		gfn_getMenuInit();
		
		equiTrend.getBucket(sqlFlag); 
    	
    	FORM_SEARCH = $("#searchForm").serializeObject(); 
    	FORM_SEARCH.sql        = sqlFlag;
   		FORM_SEARCH.dimList    = DIMENSION.user;
   		FORM_SEARCH.hiddenList = DIMENSION.hidden;
   		FORM_SEARCH.bucketList = BUCKET.query;
   		FORM_SEARCH.bucketSize = BUCKET.query.length;
   		
		equiTrend.search();
		equiTrend.excelSubSearch();
	}
	
	function fn_setBeforeFieldsBuket() {
		var fields = [
			{fieldName: "AVG_VALUE", dataType : "number"},
			{fieldName: "MIN_VALUE", dataType : "number"},
			{fieldName: "MAX_VALUE", dataType : "number"}
        ];
    	return fields;
	}
	
	function fn_setBeforeColumnsBuket() {
		var columns = [	
			{
				name : "AVG_VALUE", fieldName: "AVG_VALUE", editable: false, header: {text: '<spring:message code="lbl.average" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 80
			}, {
				name : "MIN_VALUE", fieldName: "MIN_VALUE", editable: false, header: {text: '<spring:message code="lbl.mixPlQty" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 80
			}, {
				name : "MAX_VALUE", fieldName: "MAX_VALUE", editable: false, header: {text: '<spring:message code="lbl.maxPlQty" javaScriptEscape="true" />'},
				styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
				dynamicStyles : [gfn_getDynamicStyle(-2)],
				dataType : "number",
				width: 80
			}
		];
		return columns;
	}
	

	// onload 
	$(document).ready(function() {
		equiTrend.init();
	});
	
	</script>

</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="a" class="split content split-horizontal">
		<form id="searchForm" name="searchForm">
		<input type="hidden" id="operRatio" name ="operRatio"/>
		<div id="filterDv">
			<div class="inner">
				<h3>Filter</h3>
				<div class="tabMargin"></div>
				<div class="scroll">
					<div class="view_combo" id="divProdPart"></div>
					<div class="view_combo" id="divWorkplaces"></div>
					<div class="view_combo" id="divStdWorkHour"></div>
					<div class="view_combo" id="divOperRate"></div>
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
				<div id="realgrid" style="width: 100%;" class="realgrid1"></div>
			</div>
			<div class="cbt_btn" style="height:25px">
				<div class="bleft">
				</div>
				<div class="bright">
					<a href="javascript:;" id="btnDetail" class="app1"><spring:message code="lbl.detail2" /></a> 
				</div>
			</div>
		</div>
    </div>
</body>
</html>
