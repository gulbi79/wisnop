<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
<script type="text/javascript">
	var enterSearchFlag = "Y";
	var planVersionCnt = 0;
	var planResult = {
		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.grid.initGrid();
		},
		
		_siq    : "aps.planResult.planResult",
		
		comCode : {
			codeMapEx : null,
			codeMap   : null,
			initCode  : function() {
				var grpCd      = 'PROD_PART,APS_PLAN_RESULT_CATEGORY,PLAN_SUMMARY_CD';
				this.codeMap   = gfn_getComCode(grpCd, 'Y'); 
				this.codeMapEx = gfn_getComCodeEx(["REP_CUST_GROUP"], null, {itemType : ""});
			}
		},
		
		initFilter : function() {
			//Plan ID
	    	fn_getPlanId({picketType:"W",planTypeCd:"MP"});
			
	    	gfn_setMsComboAll([
				{target : 'divProdPart'   , id : 'prodPart' , title : '<spring:message code="lbl.prodPart2"/>'  , data : this.comCode.codeMap.PROD_PART, exData:[""], option: {allFlag:"Y"}},
				{target : 'divPlanVersion', id : 'versionId', title : '<spring:message code="lbl.planVersion"/>'  , data : [], exData:[""], option: {allFlag:"Y"} },
				{target : 'divCategory'   , id : 'category' , title : '<spring:message code="lbl.category"/>'  , data : this.comCode.codeMap.APS_PLAN_RESULT_CATEGORY, exData:[""], option: {allFlag:"Y"}},
				{target : 'divPlanSummary', id : 'planSummary', title : '<spring:message code="lbl.planRept"/>' , data : this.comCode.codeMap.PLAN_SUMMARY_CD, exData:[""], type : "R"},
				{target : 'divRepCustGroup', id : 'reptCustGroup', title : '<spring:message code="lbl.reptCustGroup"/>', data : this.comCode.codeMapEx.REP_CUST_GROUP, exData:["*"], option: {allFlag:"Y"}},
			]);
	    	
	    	$(':radio[name=planSummary]:input[value="PROD_PART_CD"]').attr("checked", true);
	    	$("#divRepCustGroup").hide();
			$("#realgrid2").hide();
	    	
	    	planResult.prodPartChange();
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
				
				this.gridInstance2 = new GRID();
				this.gridInstance2.init("realgrid2");
				
				this.grdMain2      = this.gridInstance2.objGrid;
				this.dataProvider2 = this.gridInstance2.objData;
				
			},
			
			setOptions : function() {
				/* this.grdMain.setOptions({
					stateBar: { visible : true }
				}); */

				/* this.dataProvider.setOptions({
					softDeleting : true
				}); */
			}
		},
		
		events : function () {
			
			$("input:radio[name=monthlyWeekly]").click(function(){
				
				var selectVal = $(':radio[name="monthlyWeekly"]:checked').val();
				
				if(selectVal == "MONTH"){
					$("#filterViewWeek").hide();
					$("#filterViewMonth").show();
					categoryChangeTo_M();
					gfn_setMsComboAll([{target : 'divCategory'   , id : 'category' , title : '<spring:message code="lbl.category"/>'  , data : planResult.comCode.codeMap.APS_PLAN_RESULT_CATEGORY, exData:[""], option: {allFlag:"Y"}}]);
					
				}
				else if(selectVal == "WEEK"){
					$("#filterViewMonth").hide();
					$("#filterViewWeek").show();
					categoryChangeTo_ORIGIN();
					gfn_setMsComboAll([{target : 'divCategory'   , id : 'category' , title : '<spring:message code="lbl.category"/>'  , data : planResult.comCode.codeMap.APS_PLAN_RESULT_CATEGORY, exData:[""], option: {allFlag:"Y"}}]);
					
				}
				
			});
		
			
			
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("#prodPart,#planId").change(function() {
				planResult.prodPartChange();
			});
			
			$("#planSummary0,#planSummary1").change(function() {
				planResult.planSummaryChange();
			});
			
			$("#btnDetail").on("click", function() {
				planResult.popup();
			});
			
			$("#divPlanVersion .itit").click("on", function() { 
				planResult.prodPartChange();
			});
			
	    	$("#divPlanVersion .itit").css("cursor", "pointer");
		},
		
		getBucket : function(sqlFlag) {
			
			var ajaxMap = null;
			
			//주간 체크된 경우
			if($('#monthlyWeekly2').is(':checked'))
			{
				ajaxMap = {
					fromDate : $("#fromCal").val().replace(/-/g, ''),
					toDate   : $("#toCal"  ).val().replace(/-/g, ''),
					week     : {isDown: "Y", isUp : "N", upCal : "M", isMt : "N", isExp : "N", expCnt : 999},
					sqlId    : ["bucketFullWeek"]
				};
			}
			//월간 체크된 경우	
			else if($('#monthlyWeekly1').is(':checked'))
			{
				ajaxMap = {
						fromDate : gfn_replaceAll($("#fromMon").val(),"-","") + "01",
						toDate   : gfn_replaceAll($("#toMon").val(),"-","") + "31",
						month    : {isDown: "Y", isUp : "N", upCal : "Y", isMt : "N", isExp : "N", expCnt : 999},
						sqlId    : ["bucketMonth"]
					}
			}
			
			
			gfn_getBucket(ajaxMap);
			
			if (!sqlFlag) {
				
				var vPlan = $('input[name="planSummary"]:checked').val();
				
				if(vPlan == "PROD_PART_CD"){
					planResult.grid.gridInstance.setDraw();
					
					var fileds = planResult.grid.dataProvider.getFields();
					var filedsLen = fileds.length;
					
					for (var i = 0; i < filedsLen; i++) {
						var fieldName = fileds[i].fieldName;
						if (fieldName == 'TA_NM_NM'){
							fileds[i].dataType = "number";
							planResult.grid.grdMain.setColumnProperty(fieldName, "styles", {"numberFormat" : "#,##0"});	
						}
					}
					
					planResult.grid.dataProvider.setFields(fileds);
					
					$.each(BUCKET.query, function(n, v) {
						
		    			planResult.grid.grdMain.setColumnProperty(v.CD, "dynamicStyles", [
		    				{//가동율
			    				criteria : "(values['MEAS_CD'] = 'RESULT01')",
			    				styles   : {numberFormat : "#,##0"}
			    			}, {//누적 수요 충족률(수량)
			    				criteria : "(values['MEAS_CD'] = 'RESULT02')",
			    				styles   : {numberFormat : "#,##0"}
			    			}, {//누적 수요 충족률(금액)
			    				criteria : "(values['MEAS_CD'] = 'RESULT03')",
			    				styles   : {numberFormat : "#,##0.0"}
			    			}, {//예상 출하 금액
			    				criteria : "(values['MEAS_CD'] = 'RESULT04')",
			    				styles   : {numberFormat : "#,##0.0"}
			    			}, {//생산 계획 금액
			    				criteria : "(values['MEAS_CD'] = 'RESULT05')",
			    				styles   : {numberFormat : "#,##0.0"}
			    			}, {//작업 교체 횟수 (week)
			    				criteria : "(values['MEAS_CD'] = 'RESULT06')",
			    				styles   : {numberFormat : "#,##0.0"}
			    			}, {//작업 교체 시간 (week)
			    				criteria : "(values['MEAS_CD'] = 'RESULT07')",
			    				styles   : {numberFormat : "#,##0"}
			    			}, {//계획 TAT
			    				criteria : "(values['MEAS_CD'] = 'RESULT08')",
			    				styles   : {numberFormat : "#,##0"}
			    			}, {//AP2 출하계획 수량
			    				criteria : "(values['MEAS_CD'] = 'RESULT09')",
			    				styles   : {numberFormat : "#,##0"}
			    			}, {//재고 사용 수량
			    				criteria : "(values['MEAS_CD'] = 'RESULT10')",
			    				styles   : {numberFormat : "#,##0"}
			    			}, {//생산 필요 수량
			    				criteria : "(values['MEAS_CD'] = 'RESULT11')",
			    				styles   : {numberFormat : "#,##0"}
			    			}, {//예상 출하 수량
			    				criteria : "(values['MEAS_CD'] = 'RESULT12')",
			    				styles   : {numberFormat : "#,##0"}
			    			}, {//AP2 출하계획 금액
			    				criteria : "(values['MEAS_CD'] = 'RESULT13')",
			    				styles   : {numberFormat : "#,##0.0"}
			    			}, {//재고 사용 금액
			    				criteria : "(values['MEAS_CD'] = 'RESULT14')",
			    				styles   : {numberFormat : "#,##0.0"}
			    			}, {//생산 필요 금액
			    				criteria : "(values['MEAS_CD'] = 'RESULT15')",
			    				styles   : {numberFormat : "#,##0.0"}
			    			}, {//생산 계획 수량
			    				criteria : "(values['MEAS_CD'] = 'RESULT16')",
			    				styles   : {numberFormat : "#,##0"}
			    			}, {//안전재고 수량
			    				criteria : "(values['MEAS_CD'] = 'RESULT17')",
			    				styles   : {numberFormat : "#,##0"}
			    			}, {//안전재고 금액
			    				criteria : "(values['MEAS_CD'] = 'RESULT18')",
			    				styles   : {numberFormat : "#,##0.0"}
			    			}, {//AP2 출하계획 금액 (계획반영주차)
			    				criteria : "(values['MEAS_CD'] = 'RESULT19')",
			    				styles   : {numberFormat : "#,##0.0"}
			    			}
		    			]);
		    		});
					
					
					planResult.grid.grdMain.setColumnProperty("TA_NM_NM", "dynamicStyles", [
	    				{//가동율
		    				criteria : "(values['MEAS_CD'] = 'RESULT01')",
		    				styles   : {numberFormat : "#,##0"}
		    			}, {//누적 수요 충족률(수량)
		    				criteria : "(values['MEAS_CD'] = 'RESULT02')",
		    				styles   : {numberFormat : "#,##0"}
		    			}, {//누적 수요 충족률(금액)
		    				criteria : "(values['MEAS_CD'] = 'RESULT03')",
		    				styles   : {numberFormat : "#,##0.0"}
		    			}, {//예상 출하 금액
		    				criteria : "(values['MEAS_CD'] = 'RESULT04')",
		    				styles   : {numberFormat : "#,##0.0"}
		    			}, {//생산 계획 금액
		    				criteria : "(values['MEAS_CD'] = 'RESULT05')",
		    				styles   : {numberFormat : "#,##0.0"}
		    			}, {//작업 교체 횟수 (week)
		    				criteria : "(values['MEAS_CD'] = 'RESULT06')",
		    				styles   : {numberFormat : "#,##0.0"}
		    			}, {//작업 교체 시간 (week)
		    				criteria : "(values['MEAS_CD'] = 'RESULT07')",
		    				styles   : {numberFormat : "#,##0"}
		    			}, {//계획 TAT
		    				criteria : "(values['MEAS_CD'] = 'RESULT08')",
		    				styles   : {numberFormat : "#,##0"}
		    			}, {//AP2 출하계획 수량
		    				criteria : "(values['MEAS_CD'] = 'RESULT09')",
		    				styles   : {numberFormat : "#,##0"}
		    			}, {//재고 사용 수량
		    				criteria : "(values['MEAS_CD'] = 'RESULT10')",
		    				styles   : {numberFormat : "#,##0"}
		    			}, {//생산 필요 수량
		    				criteria : "(values['MEAS_CD'] = 'RESULT11')",
		    				styles   : {numberFormat : "#,##0"}
		    			}, {//예상 출하 수량
		    				criteria : "(values['MEAS_CD'] = 'RESULT12')",
		    				styles   : {numberFormat : "#,##0"}
		    			}, {//AP2 출하계획 금액
		    				criteria : "(values['MEAS_CD'] = 'RESULT13')",
		    				styles   : {numberFormat : "#,##0.0"}
		    			}, {//재고 사용 금액
		    				criteria : "(values['MEAS_CD'] = 'RESULT14')",
		    				styles   : {numberFormat : "#,##0.0"}
		    			}, {//생산 필요 금액
		    				criteria : "(values['MEAS_CD'] = 'RESULT15')",
		    				styles   : {numberFormat : "#,##0.0"}
		    			}, {//생산 계획 수량
		    				criteria : "(values['MEAS_CD'] = 'RESULT16')",
		    				styles   : {numberFormat : "#,##0"}
		    			}, {//안전재고 수량
		    				criteria : "(values['MEAS_CD'] = 'RESULT17')",
		    				styles   : {numberFormat : "#,##0"}
		    			}, {//안전재고 금액
		    				criteria : "(values['MEAS_CD'] = 'RESULT18')",
		    				styles   : {numberFormat : "#,##0.0"}
		    			}, {//AP2 출하계획 금액 (계획반영주차)
		    				criteria : "(values['MEAS_CD'] = 'RESULT19')",
		    				styles   : {numberFormat : "#,##0.0"}
		    			}
	    			]);
				}else if(vPlan == "REP_CUST_GROUP_CD"){
					planResult.grid.gridInstance2.setDraw();
					
					var fileds = planResult.grid.dataProvider2.getFields();
					var filedsLen = fileds.length;
					
					for (var i = 0; i < filedsLen; i++) {
						var fieldName = fileds[i].fieldName;
						if (fieldName == 'TA_NM_NM'){
							fileds[i].dataType = "number";
							planResult.grid.grdMain2.setColumnProperty(fieldName, "styles", {"numberFormat" : "#,##0"});	
						}
					}
					
					planResult.grid.dataProvider2.setFields(fileds);
					
					$.each(BUCKET.query, function(n, v) {
						
		    			planResult.grid.grdMain2.setColumnProperty(v.CD, "dynamicStyles", [
		    				{//가동율
			    				criteria : "(values['MEAS_CD'] = 'RESULT01')",
			    				styles   : {numberFormat : "#,##0"}
			    			}, {//누적 수요 충족률(수량)
			    				criteria : "(values['MEAS_CD'] = 'RESULT02')",
			    				styles   : {numberFormat : "#,##0"}
			    			}, {//누적 수요 충족률(금액)
			    				criteria : "(values['MEAS_CD'] = 'RESULT03')",
			    				styles   : {numberFormat : "#,##0.0"}
			    			}, {//예상 출하 금액
			    				criteria : "(values['MEAS_CD'] = 'RESULT04')",
			    				styles   : {numberFormat : "#,##0.0"}
			    			}, {//생산 계획 금액
			    				criteria : "(values['MEAS_CD'] = 'RESULT05')",
			    				styles   : {numberFormat : "#,##0.0"}
			    			}, {//작업 교체 횟수 (week)
			    				criteria : "(values['MEAS_CD'] = 'RESULT06')",
			    				styles   : {numberFormat : "#,##0.0"}
			    			}, {//작업 교체 시간 (week)
			    				criteria : "(values['MEAS_CD'] = 'RESULT07')",
			    				styles   : {numberFormat : "#,##0"}
			    			}, {//계획 TAT
			    				criteria : "(values['MEAS_CD'] = 'RESULT08')",
			    				styles   : {numberFormat : "#,##0"}
			    			}, {//AP2 출하계획 수량
			    				criteria : "(values['MEAS_CD'] = 'RESULT09')",
			    				styles   : {numberFormat : "#,##0"}
			    			}, {//재고 사용 수량
			    				criteria : "(values['MEAS_CD'] = 'RESULT10')",
			    				styles   : {numberFormat : "#,##0"}
			    			}, {//생산 필요 수량
			    				criteria : "(values['MEAS_CD'] = 'RESULT11')",
			    				styles   : {numberFormat : "#,##0"}
			    			}, {//예상 출하 수량
			    				criteria : "(values['MEAS_CD'] = 'RESULT12')",
			    				styles   : {numberFormat : "#,##0"}
			    			}, {//AP2 출하계획 금액
			    				criteria : "(values['MEAS_CD'] = 'RESULT13')",
			    				styles   : {numberFormat : "#,##0.0"}
			    			}, {//재고 사용 금액
			    				criteria : "(values['MEAS_CD'] = 'RESULT14')",
			    				styles   : {numberFormat : "#,##0.0"}
			    			}, {//생산 필요 금액
			    				criteria : "(values['MEAS_CD'] = 'RESULT15')",
			    				styles   : {numberFormat : "#,##0.0"}
			    			}, {//생산 계획 수량
			    				criteria : "(values['MEAS_CD'] = 'RESULT16')",
			    				styles   : {numberFormat : "#,##0"}
			    			}, {//안전재고 수량
			    				criteria : "(values['MEAS_CD'] = 'RESULT17')",
			    				styles   : {numberFormat : "#,##0"}
			    			}, {//안전재고 금액
			    				criteria : "(values['MEAS_CD'] = 'RESULT18')",
			    				styles   : {numberFormat : "#,##0.0"}
			    			}, {//AP2 출하계획 금액 (계획반영주차)
			    				criteria : "(values['MEAS_CD'] = 'RESULT19')",
			    				styles   : {numberFormat : "#,##0.0"}
			    			}
		    			]);
		    		});
					
					
					planResult.grid.grdMain2.setColumnProperty("TA_NM_NM", "dynamicStyles", [
	    				{//가동율
		    				criteria : "(values['MEAS_CD'] = 'RESULT01')",
		    				styles   : {numberFormat : "#,##0"}
		    			}, {//누적 수요 충족률(수량)
		    				criteria : "(values['MEAS_CD'] = 'RESULT02')",
		    				styles   : {numberFormat : "#,##0"}
		    			}, {//누적 수요 충족률(금액)
		    				criteria : "(values['MEAS_CD'] = 'RESULT03')",
		    				styles   : {numberFormat : "#,##0.0"}
		    			}, {//예상 출하 금액
		    				criteria : "(values['MEAS_CD'] = 'RESULT04')",
		    				styles   : {numberFormat : "#,##0.0"}
		    			}, {//생산 계획 금액
		    				criteria : "(values['MEAS_CD'] = 'RESULT05')",
		    				styles   : {numberFormat : "#,##0.0"}
		    			}, {//작업 교체 횟수 (week)
		    				criteria : "(values['MEAS_CD'] = 'RESULT06')",
		    				styles   : {numberFormat : "#,##0.0"}
		    			}, {//작업 교체 시간 (week)
		    				criteria : "(values['MEAS_CD'] = 'RESULT07')",
		    				styles   : {numberFormat : "#,##0"}
		    			}, {//계획 TAT
		    				criteria : "(values['MEAS_CD'] = 'RESULT08')",
		    				styles   : {numberFormat : "#,##0"}
		    			}, {//AP2 출하계획 수량
		    				criteria : "(values['MEAS_CD'] = 'RESULT09')",
		    				styles   : {numberFormat : "#,##0"}
		    			}, {//재고 사용 수량
		    				criteria : "(values['MEAS_CD'] = 'RESULT10')",
		    				styles   : {numberFormat : "#,##0"}
		    			}, {//생산 필요 수량
		    				criteria : "(values['MEAS_CD'] = 'RESULT11')",
		    				styles   : {numberFormat : "#,##0"}
		    			}, {//예상 출하 수량
		    				criteria : "(values['MEAS_CD'] = 'RESULT12')",
		    				styles   : {numberFormat : "#,##0"}
		    			}, {//AP2 출하계획 금액
		    				criteria : "(values['MEAS_CD'] = 'RESULT13')",
		    				styles   : {numberFormat : "#,##0.0"}
		    			}, {//재고 사용 금액
		    				criteria : "(values['MEAS_CD'] = 'RESULT14')",
		    				styles   : {numberFormat : "#,##0.0"}
		    			}, {//생산 필요 금액
		    				criteria : "(values['MEAS_CD'] = 'RESULT15')",
		    				styles   : {numberFormat : "#,##0.0"}
		    			}, {//생산 계획 수량
		    				criteria : "(values['MEAS_CD'] = 'RESULT16')",
		    				styles   : {numberFormat : "#,##0"}
		    			}, {//안전재고 수량
		    				criteria : "(values['MEAS_CD'] = 'RESULT17')",
		    				styles   : {numberFormat : "#,##0"}
		    			}, {//안전재고 금액
		    				criteria : "(values['MEAS_CD'] = 'RESULT18')",
		    				styles   : {numberFormat : "#,##0.0"}
		    			}, {//AP2 출하계획 금액 (계획반영주차)
		    				criteria : "(values['MEAS_CD'] = 'RESULT19')",
		    				styles   : {numberFormat : "#,##0.0"}
		    			}
	    			]);
				}
			}
		},
		
		excelSubSearch : function (){
			
			$.each($(".view_combo"), function(i, val){
				
				var temp = "";
				var id = gfn_nvl($(this).attr("id"), "");
				var vPlan = $('input[name="planSummary"]:checked').val();
				
				if(id == "divRepCustGroup" && vPlan == "PROD_PART_CD"){
					return true;
				}else if(id == "divProdPart" && vPlan == "REP_CUST_GROUP_CD"){
					return true;
				}
				
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
					
					if(id == "divPlanSummary"){
						
						if(vPlan == "PROD_PART_CD"){
							EXCEL_SEARCH_DATA += '<spring:message code="lbl.prodPart2"/>';
						}else if(vPlan == "REP_CUST_GROUP_CD"){
							EXCEL_SEARCH_DATA += '<spring:message code="lbl.reptCustGroup"/>';
						}
						
					}else if(id == "divPlanId"){
						EXCEL_SEARCH_DATA += $("#planId option:selected").text();
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
					}else if(id == "divPlanVersion"){
						$.each($("#versionId option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divCategory"){
						$.each($("#category option:selected"), function(i2, val2){
							
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
		},
		
		search : function () {
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList", _siq : this._siq}];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						
						var vPlan = $('input[name="planSummary"]:checked').val();
						
						if(vPlan == "PROD_PART_CD"){
							planResult.grid.dataProvider.clearRows(); //데이터 초기화
							
							//그리드 데이터 생성
							planResult.grid.grdMain.cancel();
							
							planResult.grid.dataProvider.setRows(data.resList);
							planResult.grid.dataProvider.clearSavePoints();
							planResult.grid.dataProvider.savePoint(); //초기화 포인트 저장
							gfn_setSearchRow(planResult.grid.dataProvider.getRowCount());
						}else if(vPlan == "REP_CUST_GROUP_CD"){
							planResult.grid.dataProvider2.clearRows(); //데이터 초기화
							
							//그리드 데이터 생성
							planResult.grid.grdMain2.cancel();
							
							planResult.grid.dataProvider2.setRows(data.resList);
							planResult.grid.dataProvider2.clearSavePoints();
							planResult.grid.dataProvider2.savePoint(); //초기화 포인트 저장
							gfn_setSearchRow(planResult.grid.dataProvider2.getRowCount());
						}
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		prodPartChange : function() {
			FORM_SEARCH          = $("#searchForm").serializeObject(); //초기화
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "versionList", _siq : planResult._siq + "Version"}];
			
			gfn_service({
			    async   : false,
			    url     : GV_CONTEXT_PATH + "/biz/obj",
			    data    : FORM_SEARCH,
			    success : function(data) {
			    	
			    	var vPlan = $('input[name="planSummary"]:checked').val();
			    	
			    	if(vPlan == "REP_CUST_GROUP_CD"){
			    		data.versionList = $.grep(data.versionList, function(v,n) {
							return v.VERSION_TYPE_CD == 'P' || v.VERSION_TYPE_CD == 'F'; 
						});
			    	}
			    	
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
		
		planSummaryChange : function (){
			
			var vPlan = $('input[name="planSummary"]:checked').val();
			
			if(vPlan == "PROD_PART_CD"){
				$("#divProdPart").show();
				$("#divRepCustGroup").hide();
				$("#realgrid").show();
				$("#realgrid2").hide();
				planResult.grid.grdMain.resetSize();
				planResult.grid.dataProvider.clearRows(); //데이터 초기화
			}else if(vPlan == "REP_CUST_GROUP_CD"){
				$("#divProdPart").hide();
				$("#divRepCustGroup").show();
				$("#realgrid").hide();
				$("#realgrid2").show();
				planResult.grid.grdMain2.resetSize();
				planResult.grid.dataProvider2.clearRows(); //데이터 초기화
			}
			
			planResult.prodPartChange();
		},
		
		popup : function() {
			
			FORM_SEARCH = $("#searchForm").serializeObject();
			
			gfn_comPopupOpen("PLAN_RESULT_DETAIL", {
				rootUrl : "aps/planResult",
				url     : "planResultDetail",
				width   : 1200,
				height  : 680,
				planId  : FORM_SEARCH.planId,
				prodPart : FORM_SEARCH.prodPart,
				versionId : FORM_SEARCH.versionId,
				category : FORM_SEARCH.category,
				menuCd  : "APS30401"
			});
		}
	};
	
	//조회
	var fn_apply = function (sqlFlag) {
		
		var vPlan = $('input[name="planSummary"]:checked').val();
		
		// 디멘전 정리
		DIMENSION.user = [];
		
		if(vPlan == "PROD_PART_CD"){
			DIMENSION.user.push({DIM_CD:"PROD_PART_NM", DIM_NM:'<spring:message code="lbl.prodPart2"/>', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
			DIMENSION.user.push({DIM_CD:"VERSION_ID"  , DIM_NM:'<spring:message code="lbl.planVersion" />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
			DIMENSION.user.push({DIM_CD:"PRIORITY_OPTION"  , DIM_NM:'<spring:message code="lbl.priorityOption" />', LVL:10, DIM_ALIGN_CD:"C", WIDTH:100});
			DIMENSION.user.push({DIM_CD:"PLAN_OPTION"  , DIM_NM:'<spring:message code="lbl.planOption" />', LVL:10, DIM_ALIGN_CD:"C", WIDTH:100});
			DIMENSION.user.push({DIM_CD:"BAL_WEEK"  , DIM_NM:'<spring:message code="lbl.precedProdLimit" />', LVL:10, DIM_ALIGN_CD:"C", WIDTH:100});
			DIMENSION.user.push({DIM_CD:"WO_RELEASE_WEEK"  , DIM_NM:'<spring:message code="lbl.woReleaseWeek" />', LVL:10, DIM_ALIGN_CD:"C", WIDTH:100});
		}else if(vPlan == "REP_CUST_GROUP_CD"){
			DIMENSION.user.push({DIM_CD:"REP_CUST_GROUP_NM", DIM_NM:'<spring:message code="lbl.reptCustGroup"/>', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
			DIMENSION.user.push({DIM_CD:"VERSION_ID"  , DIM_NM:'<spring:message code="lbl.planVersion" />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		}
		
		DIMENSION.user.push({DIM_CD:"MEAS_NM"     , DIM_NM:'<spring:message code="lbl.category"    />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"UOM_NM"      , DIM_NM:'<spring:message code="lbl.unit"        />', LVL:10, DIM_ALIGN_CD:"C", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"DES_NM"      , DIM_NM:'<spring:message code="lbl.description2"/>', LVL:10, DIM_ALIGN_CD:"C", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"TA_NM"       , DIM_NM:'<spring:message code="lbl.totalAver"   />', LVL:10, DIM_ALIGN_CD:"R", WIDTH:100});
		
		DIMENSION.hidden = [];
    	DIMENSION.hidden.push({CD:"COMPANY_CD"  , dataType:"text"});
    	DIMENSION.hidden.push({CD:"BU_CD"       , dataType:"text"});
    	DIMENSION.hidden.push({CD:"PLAN_ID"     , dataType:"text"});
    	DIMENSION.hidden.push({CD:"PROD_PART"   , dataType:"text"});
    	DIMENSION.hidden.push({CD:"MEAS_CD"     , dataType:"text"});
    	DIMENSION.hidden.push({CD:"UOM_CD"      , dataType:"text"});
		
		planResult.getBucket(sqlFlag);
		
		//조회조건 설정
    	FORM_SEARCH            = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
    	FORM_SEARCH.bucketList = BUCKET.query;
    	
    	planResult.search();
    	planResult.excelSubSearch();
	}
	
	function fn_getPlanId(pOption) {
		
		try {
			
			if ($("#planId").length == 0) {
				return;
			}
			
			var params = $.extend({
				_mtd     : "getList",
				tranData : [{outDs:"rtnList",_siq:"common.planId"}]
			}, pOption);
			
			gfn_service({
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : params,
				async   : false,
				success : function(data) {
					
					gfn_setMsCombo("planId",data.rtnList,[""]);
					
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
	
	function categoryChangeTo_M()
	{
		
		//planResult.comCode.codeMap.APS_PLAN_RESULT_CATEGORY
			
		
		for(i=0; i<planResult.comCode.codeMap.APS_PLAN_RESULT_CATEGORY.length;i++)
		{
			if(planResult.comCode.codeMap.APS_PLAN_RESULT_CATEGORY[i].RNUM != 'undefined')
			{
				
				if(planResult.comCode.codeMap.APS_PLAN_RESULT_CATEGORY[i].CODE_CD == 'RESULT01')
				{
					planResult.comCode.codeMap.APS_PLAN_RESULT_CATEGORY[i].CODE_CD = 'RESULT01_M';
				}
				else if(planResult.comCode.codeMap.APS_PLAN_RESULT_CATEGORY[i].CODE_CD == 'RESULT02')	
				{
					planResult.comCode.codeMap.APS_PLAN_RESULT_CATEGORY[i].CODE_CD = 'RESULT02_M';
				}
				else if(planResult.comCode.codeMap.APS_PLAN_RESULT_CATEGORY[i].CODE_CD == 'RESULT03')	
				{
					planResult.comCode.codeMap.APS_PLAN_RESULT_CATEGORY[i].CODE_CD = 'RESULT03_M';
				}
				else if(planResult.comCode.codeMap.APS_PLAN_RESULT_CATEGORY[i].CODE_CD == 'RESULT06')	
				{
					planResult.comCode.codeMap.APS_PLAN_RESULT_CATEGORY[i].CODE_CD = 'RESULT06_M';
				}
				else if(planResult.comCode.codeMap.APS_PLAN_RESULT_CATEGORY[i].CODE_CD == 'RESULT07')	
				{
					planResult.comCode.codeMap.APS_PLAN_RESULT_CATEGORY[i].CODE_CD = 'RESULT07_M';
				}
				else if(planResult.comCode.codeMap.APS_PLAN_RESULT_CATEGORY[i].CODE_CD == 'RESULT08')	
				{
					planResult.comCode.codeMap.APS_PLAN_RESULT_CATEGORY[i].CODE_CD = 'RESULT08_M';
				}
				
			}
		}
	
		
	}
	
	function categoryChangeTo_ORIGIN()
	{
		for(i=0; i<planResult.comCode.codeMap.APS_PLAN_RESULT_CATEGORY.length;i++)
		{
			if(planResult.comCode.codeMap.APS_PLAN_RESULT_CATEGORY[i].RNUM != 'undefined')
			{
				
				if(planResult.comCode.codeMap.APS_PLAN_RESULT_CATEGORY[i].CODE_CD == 'RESULT01_M')
				{
					planResult.comCode.codeMap.APS_PLAN_RESULT_CATEGORY[i].CODE_CD = 'RESULT01';
				}
				else if(planResult.comCode.codeMap.APS_PLAN_RESULT_CATEGORY[i].CODE_CD == 'RESULT02_M')	
				{
					planResult.comCode.codeMap.APS_PLAN_RESULT_CATEGORY[i].CODE_CD = 'RESULT02';
				}
				else if(planResult.comCode.codeMap.APS_PLAN_RESULT_CATEGORY[i].CODE_CD == 'RESULT03_M')	
				{
					planResult.comCode.codeMap.APS_PLAN_RESULT_CATEGORY[i].CODE_CD = 'RESULT03';
				}
				else if(planResult.comCode.codeMap.APS_PLAN_RESULT_CATEGORY[i].CODE_CD == 'RESULT06_M')	
				{
					planResult.comCode.codeMap.APS_PLAN_RESULT_CATEGORY[i].CODE_CD = 'RESULT06';
				}
				else if(planResult.comCode.codeMap.APS_PLAN_RESULT_CATEGORY[i].CODE_CD == 'RESULT07_M')	
				{
					planResult.comCode.codeMap.APS_PLAN_RESULT_CATEGORY[i].CODE_CD = 'RESULT07';
				}
				else if(planResult.comCode.codeMap.APS_PLAN_RESULT_CATEGORY[i].CODE_CD == 'RESULT08_M')	
				{
					planResult.comCode.codeMap.APS_PLAN_RESULT_CATEGORY[i].CODE_CD = 'RESULT08';
				}
				
			}
		}
		
	}
	
	// onload 
	$(document).ready(function() {
		planResult.init();
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
				<div class="tabMargin"></div>
				<div class="scroll">
									
					<div class="view_combo" id="divPlanSummary"></div>
					<div class="view_combo" id="divPlanId">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.planId"/></div>
							<div class="iptdv borNone">
								<select id="planId" name="planId" class="iptcombo"></select>
							</div>
						</div>
					</div>
					<input type="hidden" id="cutOffFlag" name="cutOffFlag"/>
					<input type="hidden" id="total" name="total" value='<spring:message code="lbl.total"/>'>
					<input type="hidden" id="average" name="average" value='<spring:message code="lbl.average"/>'>
					<div class="view_combo" id="divProdPart"></div>
					<div class="view_combo" id="divRepCustGroup"></div>
					<div class="view_combo" id="divPlanVersion"></div>
					<div class="view_combo" id="divCategory"></div>
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
				<div id="realgrid" class="realgrid1"></div>
				<div id="realgrid2"class="realgrid1" style="display: none"></div>
			</div>
			<div class="cbt_btn">
				<div class="bleft">
					<a href="javascript:;" id="btnDetail" class="app1 roleWrite APS30401"><spring:message code="lbl.planSummaryDetail"/></a>
				</div>
			</div>
		</div>
    </div>
</body>
</html>