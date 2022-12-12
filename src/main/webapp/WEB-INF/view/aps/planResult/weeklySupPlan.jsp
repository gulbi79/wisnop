<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
<script type="text/javascript">
	var enterSearchFlag = "Y";
	
	var weeklySupPlan = {
		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.grid.initGrid();
		},
		
		_siq    : "aps.planResult.weeklySupPlan",
		
		comCode : {
			codeMapEx : null,
			codeMap   : null,
			initCode  : function() {
				var grpCd      = 'PROD_PART,VERSION_TYPE_CD,ITEM_TYPE';
				this.codeMap   = gfn_getComCode(grpCd, 'Y'); 
				this.codeMapEx = gfn_getComCodeEx(["ROUTING", "ITEM_GROUP", "REP_CUST_GROUP"], null, {});
				
				this.codeMap.VERSION_TYPE_CD = $.grep(this.codeMap.VERSION_TYPE_CD, function(v,n) {
		           	return $.inArray(v.ATTB_1_CD, ["Y"]) > -1;
		        });
			}
		},
		
		initFilter : function() {
			// 키워드팝업
			gfn_keyPopAddEvent([
				{ target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>' }
			]);
			
			//Plan ID
	    	fn_getPlanId({picketType:"W",planTypeCd:"MP"});
			
	    	// 콤보박스
			gfn_setMsComboAll([
				{target : 'divProdPart', id : 'prodPart', title : '<spring:message code="lbl.prodPart2"/>', data : this.comCode.codeMap.PROD_PART, exData:[""]},
				{target : 'divPlanVersion', id : 'versionId', title : '<spring:message code="lbl.planVersion"/>', data : [], exData:[""]},
				{target : 'divRepCustGroup', id : 'reptCustGroup', title : '<spring:message code="lbl.reptCust"/>', data : this.comCode.codeMapEx.REP_CUST_GROUP, exData:["*"] },
				{target : 'divRoute', id : 'route', title : '<spring:message code="lbl.routing"/>', data : this.comCode.codeMapEx.ROUTING, exData:[""]},
				{target : 'divItemGroup', id : 'itemGroup', title : '<spring:message code="lbl.itemGroup"/>', data : this.comCode.codeMapEx.ITEM_GROUP, exData:[""]},
				{target : 'divItemType', id : 'itemType', title : '<spring:message code="lbl.itemType"/>', data : this.comCode.codeMap.ITEM_TYPE, exData:[""]},
			]);
	    	
			$("#itemType").multipleSelect("setSelects", ["10"]);
	    	
			weeklySupPlan.prodPartChange();
		},
		
		prodPartChange : function() {
			FORM_SEARCH          = $("#searchForm").serializeObject(); //초기화
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "versionList", _siq : weeklySupPlan._siq + "Version"}];
			
			// 계획버전 
			gfn_service({
			    async   : false,
			    url     : GV_CONTEXT_PATH + "/biz/obj.do",
			    data    : FORM_SEARCH,
			    success : function(data) {
			    	
					gfn_setMsCombo("versionId", data.versionList, [""], {allFlag:"Y"});
			    	
					$.each(data.versionList, function(i, val){
						
						var codeCd = val.CODE_CD;
						var cutOffFlag = val.CUT_OFF_FLAG;
						var versionTypeCd = val.VERSION_TYPE_CD;
						
						if(cutOffFlag == "Y" && versionTypeCd == "M"){
							$(".selected").each(function(){
								var text = $(this).text();
								
								if(codeCd == text){
									$(this).css("color", gv_redColor);
									return false;
								}
							});
							return false;
						}
					});
			    }
			},"obj");
		},
		
		grid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid : function() {
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				
				this.setOptions();
				gfn_setMonthSum(weeklySupPlan.grid.gridInstance, false, false, true);  // omit 0 추가
			},
			
			setOptions : function() {
				this.grdMain.setOptions({
					//stateBar: { visible : true }
				});

				this.dataProvider.setOptions({
					softDeleting : true
				});
				
				this.grdMain.addCellStyles([{
					id         : "editStyle",
					editable   : true,
					background : gv_editColor
				}]);
			}
		},
		
		events : function () {
			
			$("input:radio[name=monthlyWeekly]").click(function(){
				
				var selectVal = $(':radio[name="monthlyWeekly"]:checked').val();
				
				if(selectVal == "MONTH"){
					$("#filterViewWeek").hide();
					$("#filterViewMonth").show();
				}
				else if(selectVal == "WEEK"){
					$("#filterViewMonth").hide();
					$("#filterViewWeek").show();
				}
				
			});
			
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("#prodPart,#planId").change(function() {
				weeklySupPlan.prodPartChange();
			});
			
			$("#divPlanVersion .itit").click("on", function() { 
				weeklySupPlan.prodPartChange();
	    	});
	    	
	    	$("#divPlanVersion .itit").css("cursor", "pointer");
		},
		
		getBucket : function(sqlFlag) {
			var ajaxMap = null;
			
			
			//주간 체크된 경우
			if($('#monthlyWeekly2').is(':checked'))
			{	ajaxMap ={
							fromDate : $("#fromCal").val().replace(/-/g, ''),
							toDate   : $("#toCal"  ).val().replace(/-/g, ''),
				       		week     : {isDown: "N", isUp:"Y", upCal:"M", isMt:"Y", isExp:"N", expCnt:1},
							sqlId    : ["bucketFullWeek"]
						}
			}
			//월간 체크된 경우	
			else if($('#monthlyWeekly1').is(':checked'))
			{
				
				ajaxMap = {
						fromDate : gfn_replaceAll($("#fromMon").val(),"-","") + "01",
						toDate   : gfn_replaceAll($("#toMon").val(),"-","") + "31",
						month    : {isDown: "N", isUp : "Y", upCal : "Y", isMt : "Y", isExp : "N", expCnt : 1},
						sqlId    : ["bucketMonth"]
					}
				
				
			}
			
			
			gfn_getBucket(ajaxMap);
			
			if (!sqlFlag) {
				for (var i in DIMENSION.user) {
					if (DIMENSION.user[i].DIM_CD.indexOf("SALES_PRICE_KRW") > -1) {
						DIMENSION.user[i].numberFormat = "#,##0";
					}
					
					if (DIMENSION.user[i].DIM_CD.indexOf("SS_QTY") > -1) {
						DIMENSION.user[i].numberFormat = "#,##0";
					}
				}
				
				weeklySupPlan.grid.gridInstance.setDraw();
				
				var fileds = weeklySupPlan.grid.dataProvider.getFields();
				
				for (var i in fileds) {
					if (fileds[i].fieldName.indexOf("SALES_PRICE_KRW") > -1) {
						fileds[i].dataType = "number";
					}
					
					if (fileds[i].fieldName.indexOf("SS_QTY") > -1) {
						fileds[i].dataType = "number";
					}
				}
				
				weeklySupPlan.grid.dataProvider.setFields(fileds);
				
				$.each(BUCKET.query, function(n, v) {
					
					weeklySupPlan.grid.grdMain.setColumnProperty(v.CD, "dynamicStyles", [
	    				{//충족률(누적)
		    				criteria : "(values['CATEGORY_CD'] = 'FILL_RATE')",
		    				styles   : {numberFormat : "#,##0.0"}
		    			}
	    			]);
	    		});
			}
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
					
					if(id == "divPlanId"){
						EXCEL_SEARCH_DATA += $("#planId option:selected").text();
					}else if(id == "divProdPart"){
						EXCEL_SEARCH_DATA += $("#prodPart option:selected").text();
					}else if(id == "divPlanVersion"){
						EXCEL_SEARCH_DATA += $("#versionId option:selected").text();
					}else if(id == "divRepCustGroup"){
						$.each($("#reptCustGroup option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divRoute"){
						$.each($("#route option:selected"), function(i2, val2){
							
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
					}else if(id == "divItemType"){
						$.each($("#itemType option:selected"), function(i2, val2){
							
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
			
			EXCEL_SEARCH_DATA += "\n" + '<spring:message code="lbl.period"/>' + " : ";
			EXCEL_SEARCH_DATA += $("#fromCal").val() + "(" + $("#fromPWeek").val() + ") ~ ";
			EXCEL_SEARCH_DATA += $("#toCal").val() + "(" + $("#toPWeek").val() + ")";
			
		},
		
		search : function () {
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList",_siq : weeklySupPlan._siq }];
			
			var aOption = {	
				url     : GV_CONTEXT_PATH + "/biz/obj.do",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						weeklySupPlan.grid.dataProvider.clearRows(); //데이터 초기화
						
						//그리드 데이터 생성
						weeklySupPlan.grid.grdMain.cancel();
						
						weeklySupPlan.grid.dataProvider.setRows(data.resList);
						weeklySupPlan.grid.dataProvider.clearSavePoints();
						weeklySupPlan.grid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(weeklySupPlan.grid.dataProvider.getRowCount());
						gfn_actionMonthSum(weeklySupPlan.grid.gridInstance); // omit 0 추가
						gfn_setRowTotalFixed(weeklySupPlan.grid.grdMain);
					}
				}
			}
			gfn_service(aOption, "obj");
		}
	};
	
	//조회
	var fn_apply = function (sqlFlag) {
		gfn_getMenuInit();
		weeklySupPlan.getBucket(sqlFlag);
		
		//조회조건 설정
    	FORM_SEARCH            = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
    	FORM_SEARCH.dimList    = DIMENSION.user;
   		FORM_SEARCH.meaList	   = MEASURE.user;
    	FORM_SEARCH.bucketList = BUCKET.query;
   		
    	weeklySupPlan.search();
    	weeklySupPlan.excelSubSearch();
	}
	
	function fn_getPlanId(pOption) {
		
		try {
			
			if ($("#planId").length == 0) {
				return;
			}
			
			var params = $.extend({
				_mtd     : "getList",
				tranData : [{outDs : "rtnList", _siq : "common.planId"}]
			}, pOption);
			
			gfn_service({
				url     : GV_CONTEXT_PATH + "/biz/obj.do",
				data    : params,
				async   : false,
				success : function(data) {
					
					gfn_setMsCombo("planId", data.rtnList, [""]);
					
					$("#planId").on("change", function(e) {
						
						//주간 체크된 경우
						if($('#monthlyWeekly2').is(':checked')){
						
							var nowDate = null;
							var fDs = gfn_getFindDataDsInDs(data.rtnList, {CODE_CD : {VALUE : $(this).val(), CONDI : "="}});
							
							if (fDs.length > 0) {
								
								nowDate = fDs[0].SW_START_DATE;
								var DATE_plus_42 = weekdatecal(nowDate,42);
							    var DATE_plus_180 = weekdatecal(nowDate,364);
							    
						        DATEPICKET(null, nowDate, DATE_plus_42);
								
								var sdt = gfn_getStringToDate(nowDate);
								
								var edt = gfn_getStringToDate(DATE_plus_180);
								
								$("#fromCal").datepicker("option", "minDate", sdt);
								$("#fromCal").datepicker("option", "maxDate", edt);
								$("#toCal").datepicker("option", "maxDate", edt);
								$("#cutOffFlag").val(fDs[0].CUT_OFF_FLAG);
								
								
								var tStartMon = nowDate.substring(0, 4) + nowDate.substring(4, 6);
								var tCloseMon = gfn_addDate("month", 5, "", tStartMon + "01").substring(0, 6);
								var ttCloseMon = gfn_addDate("month", 11, "", tStartMon + "01").substring(0, 6);
								
								var minMonthStart = gfn_getStringToDate(tStartMon + "01");
								var maxMonthClose = gfn_getStringToDate(tCloseMon + "01");
								var maxMonthEdt =  gfn_getStringToDate(ttCloseMon + "01");
								
								MONTHPICKER(null, tStartMon, tCloseMon);
								$("#fromMon").monthpicker("option", "minDate", minMonthStart);
								$("#toMon").monthpicker("option", "maxDate", maxMonthEdt);
								
								$("#filterViewMonth").hide();
								$("#filterViewWeek").show();
								
							} 
						}
							
						//월간 체크된 경우
						else if($('#monthlyWeekly1').is(':checked'))
						{
							
							var nowDate = null;
							var fDs = gfn_getFindDataDsInDs(data.rtnList, {CODE_CD : {VALUE : $(this).val(), CONDI : "="}});
							
							if (fDs.length > 0) {
								
								nowDate = fDs[0].SW_START_DATE;
								var DATE_plus_42 = weekdatecal(nowDate,42);
							    var DATE_plus_180 = weekdatecal(nowDate,364);
							    
						        DATEPICKET(null, nowDate, DATE_plus_42);
								
								var sdt = gfn_getStringToDate(nowDate);
								
								var edt = gfn_getStringToDate(DATE_plus_180);
								
								$("#fromCal").datepicker("option", "minDate", sdt);
								$("#fromCal").datepicker("option", "maxDate", edt);
								$("#toCal").datepicker("option", "maxDate", edt);
								$("#cutOffFlag").val(fDs[0].CUT_OFF_FLAG);
								
								
								var tStartMon = nowDate.substring(0, 4) + nowDate.substring(4, 6);
								var tCloseMon = gfn_addDate("month", 5, "", tStartMon + "01").substring(0, 6);
								var ttCloseMon = gfn_addDate("month", 11, "", tStartMon + "01").substring(0, 6);
								
								var minMonthStart = gfn_getStringToDate(tStartMon + "01");
								var maxMonthClose = gfn_getStringToDate(tCloseMon + "01");
								var maxMonthEdt =  gfn_getStringToDate(ttCloseMon + "01");
								
								MONTHPICKER(null, tStartMon, tCloseMon);
								$("#fromMon").monthpicker("option", "minDate", minMonthStart);
								$("#toMon").monthpicker("option", "maxDate", maxMonthEdt);
							
								$("#filterViewMonth").show();
								$("#filterViewWeek").hide();
							}
							
						}
						
					});
					
					$("#planId").trigger("change");
				}
			},"obj");
			
		} catch(e) {console.log(e);}
	}
	
    function weekdatecal(dt, days){
    	
    	yyyy = dt.substr(0, 4);
    	mm   = dt.substr(4, 2);
    	dd   = dt.substr(6, 2);
    	
    	var date = new Date(yyyy + "/" + mm + "/" + dd);
    	
    	date.setDate(date.getDate() + days);
    	
    	var rdt = date.getFullYear() + '' + ((date.getMonth() + 1)  < 10 ? '0' + (date.getMonth() + 1) : (date.getMonth() + 1) ) + (date.getDate() < 10 ? '0' + date.getDate() : date.getDate());
    	
    	return rdt;
    }
	
	// onload 
	$(document).ready(function() {
		weeklySupPlan.init();
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
				<%@ include file="/WEB-INF/view/common/filterMonthSum.jsp" %>
				<div class="tabMargin"></div>
				<div class="scroll">
					<div class="view_combo" id="divPlanId">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.planId"/></div>
							<div class="iptdv borNone">
								<select id="planId" name="planId" class="iptcombo"></select>
							</div>
						</div>
					</div>
					<input type='hidden' id='cutOffFlag' name='cutOffFlag'>
					<div class="view_combo" id="divProdPart"></div>
					<div class="view_combo" id="divPlanVersion"></div>
					<div class="view_combo" id="divRepCustGroup"></div>
					<div class="view_combo" id="divRoute"></div>
					<div class="view_combo" id="divItemGroup"></div>
					<div class="view_combo" id="divItemType"></div>
					<div class="view_combo" id="divItem"></div>
					<div class="view_combo" id="divWeeklyDaily">
							<strong class="filter_tit"><spring:message code="lbl.horizon"/></strong>
							<ul class="rdofl">
								<li><input type="radio" id="monthlyWeekly2" name="monthlyWeekly" value="WEEK" checked="checked"><label for="monthlyWeekly2"><spring:message code="lbl.week"/></label></li>
								<li><input type="radio" id="monthlyWeekly1" name="monthlyWeekly" value="MONTH" ><label for="monthlyWeekly1"><spring:message code="lbl.month"/></label></li>
							</ul>
					</div>	
					<div id="filterViewWeek"><jsp:include page="/WEB-INF/view/common/filterViewHorizon.jsp" flush="false" /></div>
					<div id="filterViewMonth"><jsp:include page="/WEB-INF/view/common/filterViewHorizonMonth.jsp" flush="false" /></div>
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