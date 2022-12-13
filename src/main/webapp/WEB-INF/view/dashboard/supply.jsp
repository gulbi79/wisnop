<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
	<jsp:param name="chartYn" value="Y"/>
</jsp:include>
	
	<style type="text/css">
	#container { margin: 0;width: calc(100% - 250px);height: 100%;padding: 0; }
	#cont_chart { width: 100%;height: 100%;}
	
	#cont_chart .col_3 { margin:0; width:calc((100% - 4px) / 3) ; height:calc((100% - 4px) / 3);position:relative;}
	#cont_chart .col_3:nth-child(1) {margin:0 2px 2px 0;}
	#cont_chart .col_3:nth-child(2) {margin:0 2px 2px 0;}
	#cont_chart .col_3:nth-child(3) {margin:0 0 2px 0;}
	#cont_chart .col_3:nth-child(4) {margin:0 2px 2px 0;}
	#cont_chart .col_3:nth-child(5) {margin:0 2px 2px 0;}
	#cont_chart .col_3:nth-child(6) {margin:0 0 2px 0;}
	#cont_chart .col_3:nth-child(7) {margin:0 2px 0 0;}
	#cont_chart .col_3:nth-child(8) {margin:0 2px 0 0;}
	
	#cont_chart .col_3 > .titleContainer > h4
	{
		float:left;
		
	}
	#cont_chart .col_3 > .titleContainer > div
    {
        float:right;
    }
	
	#cont_chart .col_3 .textwrap { padding : 10px 0 0 0; }
	
	#cont_chart .col_3_tmp h4 { margin-bottom: 10px; }
	
	#cont_chart3 {
		height: 100%;
		width: 240px;
		float: left;
		margin-left: 10px;
	}
	
	table {
		width: 100%;
		height: 88%;
	    border: 1px solid #444444;
	}
	
	td {
		border: 1px solid #444444;
		padding-right: 5px;
		text-align: right;
		font-size: 12px;
	}
	
	#cont_chart .col_3 > .modal
    {
        height: 100%;
        left: 0;
        position: relative;
        top: 0;
        width: 100%;
        display:flex;
        flex-direction:column;
        overflow:auto;
    }
    
    #cont_chart .col_3 > .modal_header
    {
        height:25px;
        
    }
    
    #cont_chart .col_3 > .modal_content
    {
       
        height:auto;
        overflow-y:scroll;
        padding: 10px 15px 10px 15px;
        flex:1;
        display:flex;
        flex-direction:column
        
    }
	
	</style>	
	
	<script type="text/javascript">
	var quill_1,quill_2,quill_3,quill_4,quill_5,quill_6,quill_7,quill_8;
	var colorWhite = "#FFFFFF";
	var colorRed = "#FF0000";
	var colorBlue = "#368AFF";
	var cWeek;
	var unit = 0;
	var supply = {

		init : function () {
			gfn_formLoad();
			fn_siteMap();
			fn_quilljsInit();
			this.initSearch();
			this.events();
			
			var userLang = "${sessionScope.GV_LANG}";
			var cDate = gfn_getCurrentDate();
			cWeek = "W" + cDate.WEEKOFYEAR;
			
			$.each($(".cweekTxt"), function(n,v) {
	    		$(v).text(' ('+cWeek+')');
	    	});
			
			if(userLang == "ko"){
	    		unit = 100000000;
	    	}else if(userLang == "en" || userLang == "cn"){
	    		unit = 1000000000;
	    	}
		},
	
		_siq	: "dashboard.supply.",
		
		events : function () {
			
			$(':radio[name=weekSupplyPlanBodyType]').on('change', function () {
				supply.weekSupplyPlanBodySearch(false);
			});
			
			$(':radio[name=mainItemWeekRadio]').on('change', function () {
				supply.mainItemWeekSearch(false);
			});
			
			
			// 타이틀 클릭시 메뉴 이동
			var arrTitle = $("h4");
	    	
			$.each(arrTitle, function(n, v) {
	    		$(v).css("cursor", "pointer");
	    		$(v).on("click", function() {
	    			if (n == 0) gfn_newTab("APS304");
	    			else if (n == 1) gfn_newTab("APS403");
	    			else if (n == 2) gfn_newTab("MP111");
	    			else if (n == 3) gfn_newTab("MP104");
	    			else if (n == 4) gfn_newTab("DP219");
	    			else if (n == 5) gfn_newTab("APS409");
	    			else if (n == 6) gfn_newTab("QT101");
	    			else if (n == 7) gfn_newTab("MP104");
	    			else if (n == 8) return;
	    		});
	    	});
			
			

	        $(".manuel > a").dblclick("on", function() {
	        	   
	        	var chartId  = this.id;
	            
	        	fn_popUpAuthorityHasOrNot();
	            
	            var isSCMTeam = SCM_SEARCH.isSCMTeam;
	            
	            if(isSCMTeam>=1)
	            {
	            	
	            	//주간 공급 계획
	            	if(chartId == "weeklySupplyPlan"){
	            		gfn_comPopupOpen("DASHBOARD_CHART_INFO", {
	                        rootUrl   : "dashboard",
	                        url       : "dashBoardChartInfoPopup",
	                        width     : 600,
	                        height    : 600,
	                        chartId   : chartId,
	                        title     : "Dashboard Chart Info"
	                    });
	            	}
	            	//주요 작업장 예상부하율
	            	else if(chartId == "expectedLoadRateAtMajorWorkplaces")
	            	{
	            		gfn_comPopupOpen("DASHBOARD_CHART_INFO", {
	                        rootUrl   : "dashboard",
	                        url       : "dashBoardChartInfoPopup",
	                        width     : 600,
	                        height    : 600,
	                        chartId   : chartId,
	                        title     : "Dashboard Chart Info"
	                    });
	            	}
	            	//주요품목그룹 제조 Lead Time
	            	else if(chartId == "leadTimeForManufacturingMajorProductGroups")
                    {
	            		gfn_comPopupOpen("DASHBOARD_CHART_INFO", {
	                        rootUrl   : "dashboard",
	                        url       : "dashBoardChartInfoPopup",
	                        width     : 600,
	                        height    : 600,
	                        chartId   : chartId,
	                        title     : "Dashboard Chart Info"
	                    });
                    }
	            	//당주 진척률
	            	else if(chartId == "progressRateOfTheCurrentWeek")
                    {
	            		gfn_comPopupOpen("DASHBOARD_CHART_INFO", {
	                        rootUrl   : "dashboard",
	                        url       : "dashBoardChartInfoPopup",
	                        width     : 600,
	                        height    : 600,
	                        chartId   : chartId,
	                        title     : "Dashboard Chart Info"
	                    });
                    }
	            	//삼성전자 CPFR 품목 PSI
	            	else if(chartId == "samsungElectronicsCPFRItemPSI")
                    {
	            		gfn_comPopupOpen("DASHBOARD_CHART_INFO", {
	                        rootUrl   : "dashboard",
	                        url       : "dashBoardChartInfoPopup",
	                        width     : 600,
	                        height    : 600,
	                        chartId   : chartId,
	                        title     : "Dashboard Chart Info"
	                    });
                    }
	            	//주요 작업장 계획 준수율
	            	else if(chartId == "majorWorkplacePlanComplianceRate")
                    {
	            		gfn_comPopupOpen("DASHBOARD_CHART_INFO", {
	                        rootUrl   : "dashboard",
	                        url       : "dashBoardChartInfoPopup",
	                        width     : 600,
	                        height    : 600,
	                        chartId   : chartId,
	                        title     : "Dashboard Chart Info"
	                    });
                    }
	            	//주요품목그룹 FQC 불량수량
	            	else if(chartId == "majorItemGroupFQCDefectiveQuantity")
                    {
	            		gfn_comPopupOpen("DASHBOARD_CHART_INFO", {
	                        rootUrl   : "dashboard",
	                        url       : "dashBoardChartInfoPopup",
	                        width     : 600,
	                        height    : 600,
	                        chartId   : chartId,
	                        title     : "Dashboard Chart Info"
	                    });
                    }
	            	//주요 품목그룹 생산 실적/계획
	            	else if(chartId == "majorProductGroupProductionPerformancePlan")
                    {
	            		gfn_comPopupOpen("DASHBOARD_CHART_INFO", {
	                        rootUrl   : "dashboard",
	                        url       : "dashBoardChartInfoPopup",
	                        width     : 600,
	                        height    : 600,
	                        chartId   : chartId,
	                        title     : "Dashboard Chart Info"
	                    });
                    }
	            	
	            
	            }
	        });
			
	        $(".manuel > a").click("on", function() {
	        	            
	            var chartId  = this.id;
	            
	          //주간 공급 계획
                if(chartId == "weeklySupplyPlan"){
                	
                	$('#weeklySupplyPlanTable').toggle();
                	$('#weeklySupplyPlanContent').toggle();
                }
                //주요 작업장 예상부하율
                else if(chartId == "expectedLoadRateAtMajorWorkplaces")
                {
                	$('#mainEqu').toggle();
                    $('#expectedLoadRateAtMajorWorkplacesContent').toggle();
                }
                //주요품목그룹 제조 Lead Time
                else if(chartId == "leadTimeForManufacturingMajorProductGroups")
                {
                	$('#manufLeadTime').toggle();
                    $('#leadTimeForManufacturingMajorProductGroupsContent').toggle();
                }
                //당주 진척률
                else if(chartId == "progressRateOfTheCurrentWeek")
                {
                	$('#weekProgress').toggle();
                    $('#progressRateOfTheCurrentWeekContent').toggle();
                }
                //삼성전자 CPFR 품목 PSI
                else if(chartId == "samsungElectronicsCPFRItemPSI")
                {
                	$('#samsungElectronicsCPFRItemPSITable').toggle();
                    $('#samsungElectronicsCPFRItemPSIContent').toggle();
                }
                //주요 작업장 계획 준수율
                else if(chartId == "majorWorkplacePlanComplianceRate")
                {
                	$('#mainWorkRateChart').toggle();
                    $('#majorWorkplacePlanComplianceRateContent').toggle();
                }
                //주요품목그룹 FQC 불량수량
                else if(chartId == "majorItemGroupFQCDefectiveQuantity")
                {
                	$('#fqcFaultyRate').toggle();
                    $('#majorItemGroupFQCDefectiveQuantityContent').toggle();
                }
                //주요 품목그룹 생산 실적/계획
                else if(chartId == "majorProductGroupProductionPerformancePlan")
                {
                	$('#majorProductGroupProductionPerformancePlanTable').toggle();
                    $('#majorProductGroupProductionPerformancePlanContent').toggle();
                }
	            
	            
	        });
	        

	        $(".titleContainer > h4").hover(function() {
                
                var chartId  = this.id;
                
              //주간 공급 계획
                if(chartId == "weeklySupplyPlanH4"){
                    
                    $('#weeklySupplyPlanTable').toggle();
                    $('#weeklySupplyPlanContent').toggle();
                }
                //주요 작업장 예상부하율
                else if(chartId == "expectedLoadRateAtMajorWorkplacesH4")
                {
                    $('#mainEqu').toggle();
                    $('#expectedLoadRateAtMajorWorkplacesContent').toggle();
                }
                //주요품목그룹 제조 Lead Time
                else if(chartId == "leadTimeForManufacturingMajorProductGroupsH4")
                {
                    $('#manufLeadTime').toggle();
                    $('#leadTimeForManufacturingMajorProductGroupsContent').toggle();
                }
                //당주 진척률
                else if(chartId == "progressRateOfTheCurrentWeekH4")
                {
                    $('#weekProgress').toggle();
                    $('#progressRateOfTheCurrentWeekContent').toggle();
                }
                //삼성전자 CPFR 품목 PSI
                else if(chartId == "samsungElectronicsCPFRItemPSIH4")
                {
                    $('#samsungElectronicsCPFRItemPSITable').toggle();
                    $('#samsungElectronicsCPFRItemPSIContent').toggle();
                }
                //주요 작업장 계획 준수율
                else if(chartId == "majorWorkplacePlanComplianceRateH4")
                {
                    $('#mainWorkRateChart').toggle();
                    $('#majorWorkplacePlanComplianceRateContent').toggle();
                }
                //주요품목그룹 FQC 불량수량
                else if(chartId == "fqcH4")
                {
                    $('#fqcFaultyRate').toggle();
                    $('#majorItemGroupFQCDefectiveQuantityContent').toggle();
                }
                //주요 품목그룹 생산 실적/계획
                else if(chartId == "majorProductGroupProductionPerformancePlanH4")
                {
                    $('#majorProductGroupProductionPerformancePlanTable').toggle();
                    $('#majorProductGroupProductionPerformancePlanContent').toggle();
                }
                
                
            });
	        
	        
			
		},
		
		bucket : null,
		
		initSearch : function (sqlFlag) {
			
			FORM_SEARCH = {}
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.tranData = [{ outDs : "week"  , _siq : supply._siq + "trendBucketWeek" }
								 , { outDs : "week2"  , _siq : supply._siq + "trendBucketWeek2" }
								 , { outDs : "day" , _siq : supply._siq + "trendBucketDay" }
								 , { outDs : "apsStartWeek" , _siq : supply._siq + "trendWeek" }
								 , { outDs : "chartList" , _siq : "dashboard.chartInfo.supply" }
			];
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					
					supply.bucket = {};
					supply.bucket.week  = data.week;
					supply.bucket.week2 = data.week2;
					supply.bucket.day  = data.day;
					supply.bucket.apsStartWeek = data.apsStartWeek[0];
			        FORM_SEARCH.chartList = data.chartList;
					fn_chartContentInit();
			        supply.search();
				}
			}
			gfn_service(sMap, "obj");
		},
		
		search : function (sqlFlag) {
			
			FORM_SEARCH            = {};
			FORM_SEARCH            = this.bucket;
			FORM_SEARCH.weekSupplyPlanBodyType = $(':radio[name=weekSupplyPlanBodyType]:checked').val();
			FORM_SEARCH.mainItemWeekRadio = $(':radio[name=mainItemWeekRadio]:checked').val();
			
			FORM_SEARCH._mtd       = "getList";
			FORM_SEARCH.sql        = sqlFlag;
			FORM_SEARCH.unit       = unit;
			FORM_SEARCH.tranData   = [
				{ outDs : "weekSupplyPlan", _siq : supply._siq + "weekSupplyPlan" },
				{ outDs : "mainEqu", _siq : supply._siq + "mainEqu" },
				{ outDs : "weekProgress", _siq : supply._siq + "weekProgress" },
				{ outDs : "fqcFaultyRate", _siq : supply._siq + "fqcFaultyRate" },
				{ outDs : "mainItemWeekProd", _siq : supply._siq + "mainItemWeekProd" },
				<c:if test="${sessionScope.isSalesTeam[0].isSalesTeam =='F'}">
				{ outDs : "manufLeadTime", _siq : supply._siq + "manufLeadTime" },
				</c:if>
				//{ outDs : "cpfrInvInfo", _siq : supply._siq + "cpfrInvInfo" },
				/* { outDs : "cpfrInvInfo1", _siq : supply._siq + "cpfrInvInfo1" },
				{ outDs : "cpfrInvInfo2", _siq : supply._siq + "cpfrInvInfo2" }, */
				{ outDs : "mainWorkRateChart", _siq : supply._siq + "mainWorkRateChart" },
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					supply.drawChart(data);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		mainItemWeekSearch : function(sqlFlag) {
			
			FORM_SEARCH          = {};
			FORM_SEARCH          = this.bucket;
			FORM_SEARCH.mainItemWeekRadio = $(':radio[name=mainItemWeekRadio]:checked').val();
			
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "mainItemWeekProd", _siq : supply._siq + "mainItemWeekProd" },
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					
					//주요 품목그룹 생산 실적/계획 html 그리기
					var totRstQty = 0;
					var totPlanQty = 0;
					var mainItemWeekProdData = data.mainItemWeekProd;
					tmp = "<tr><td style=\"background-color: #bbdefb;width: 12%;text-align: center; \"><spring:message code='lbl.mainItem2' /></td>";
					
					$.each(mainItemWeekProdData, function(n, v){
					
						var rn = v.RN;
						var disDay = v.DIS_DAY.substring(0,v.DIS_DAY.length-5);
						
						var disYearWeek = v.DIS_YEARWEEK;
						
						tmp += "<td style=\"text-align: center;background-color: #bbdefb;width: 11%; \">";
						tmp += disDay;
						tmp += "</td>";
						
						if(rn == 7){
							tmp += "<td style=\"text-align: center;background-color: #bbdefb;width: 11%; \">";
							tmp += disYearWeek;
							tmp += "</td>"
							return false;
						}
						
					});
					tmp += "</tr>";
					
					$.each(mainItemWeekProdData, function(n, v){
						
						var rn = v.RN;				
						var majorGroupNm = v.MAJOR_GROUP_NM;
						var rstQty = v.RST_QTY;
						var planQty = v.PLAN_QTY;
						var qty = rstQty + " / " + planQty;
						
						totRstQty = Number(totRstQty) + Number(rstQty);
						totPlanQty = Number(totPlanQty) + Number(planQty);
						
						
						if(rn == 1){
							tmp += "<tr><td style=\"text-align: center;background-color: #bbdefb;\">"+ majorGroupNm +"</td>";
						}
						
						tmp += "<td onclick=\"mainItemWeekProdPop()\" style=\"cursor:pointer;text-align: center;\">";
						tmp += qty;
						tmp += "</td>";
						
						
						if(rn == 7){
							
							var totQty = totRstQty + " / " + totPlanQty;
							tmp += "<td onclick=\"mainItemWeekProdPop()\" style=\"cursor:pointer;text-align: center;\">";
							tmp += totQty;
							tmp += "</td>";
							tmp += "</tr>";
							
							totRstQty = 0;
							totPlanQty = 0;
						}
					});
					$("#mainItemWeekProdBody").html(tmp);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		weekSupplyPlanBodySearch : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = this.bucket;
			FORM_SEARCH.weekSupplyPlanBodyType = $(':radio[name=weekSupplyPlanBodyType]:checked').val();
			
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "weekSupplyPlan", _siq : supply._siq + "weekSupplyPlan" },
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					
					//주간 공급 계획 html 그리기
					var weekSupplyPlanData = data.weekSupplyPlan;
					var tmp = "<tr height='10'><td colspan=\"2\" style=\"background-color: #bbdefb;width: 36%; \"></td>";
					
					$.each (supply.bucket.week, function (i, el) {
						tmp += "<td style=\"text-align: center;background-color: #bbdefb;width: 12%; \">";
						tmp += el.DISYEARWEEK;
						tmp += "</td>";
					});
					tmp += "</tr>";
					
					$.each(weekSupplyPlanData, function(n, v){
						
						tmp += "<tr>";
						//if(n == 0 || n == 5 || n == 10){
						if(n == 0){
							tmp += "<td rowspan=\"5\" style=\"text-align: center;background-color: #bbdefb;\">";
							tmp += v.FIRST_CODE_NM;	
						}
						tmp += "<td style=\"text-align: center;background-color: #bbdefb;width:25%;\">";
						tmp += v.SECOND_CODE_NM;
						tmp += "</td>";
						
						$.each (supply.bucket.week, function (i, el) {
							
							var disWeek = el.DISWEEK;
							var flagYearWeek = el.FLAGYEARWEEK;
							var supplyData = eval("v." + disWeek);
							var flagData = eval("v." + flagYearWeek);
							
							if(flagData == "Y"){
								tmp += "<td onclick=\"weekSupplyPlanPop()\" style=\"cursor:pointer;background-color:"+ colorRed +";\">";						
							}else{
								tmp += "<td onclick=\"weekSupplyPlanPop()\" style=\"cursor:pointer;\">";	
							}
								
							tmp += supplyData;
							tmp += "</td>";
						});
						tmp += "</tr>";
					});
					
					$("#weekSupplyPlanBody").html(tmp);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		drawChart : function (res) {
			
			fn_setHighchartTheme();
			
			var arWeek = new Array();
			
			$.each (supply.bucket.week2, function (i, el) {
				arWeek.push(el.DISYEARWEEK);
			});
			
			//주요 작업장 예상부하율 
			var codeNmArray = new Array();
			var dataArray = new Array();
			var firstCnt = 0;
			var secondCnt = 0;
			
			$.each(res.mainEqu, function(i, val){
				
				var tmpData = {};
				var codeNm = val.CODE_NM;
				var loadFactor = val.LOAD_FACTOR;
				var partCnt = val.PART_CNT - 1;
				var minVal = val.ATTB_3_CD;
				var maxVal = val.ATTB_4_CD;
				var colorFlag = colorWhite;
				
				if(loadFactor <= minVal){
					colorFlag = colorBlue;
				}else if(loadFactor >= maxVal){
					colorFlag = colorRed;
				}
				
				if(i == 0){
					tmpData = {x : firstCnt, y : secondCnt, value : loadFactor, color : colorFlag};
					codeNmArray.push(codeNm);
				}else{
					if(secondCnt == partCnt){
						firstCnt++;
						secondCnt = 0;
						codeNmArray.push(codeNm);
					}else{
						secondCnt++;	
					}	
					tmpData = {x : firstCnt, y : secondCnt, value : loadFactor, color : colorFlag};
				}
				dataArray.push(tmpData);
			});
			
			this.chartHeatMapGen('mainEqu', arWeek, codeNmArray, dataArray)
			
			
			//주요 작업장 계획 준수율
			var arDay = new Array();
			codeNmArray = new Array();
			dataArray = new Array();
			firstCnt = 0;
			secondCnt = 0;
			
			$.each (res.mainWorkRateChart, function (i, el) {
				
				var tmpData = {};
				var sort = el.SORT;
				var trendDate = el.TREND_DATE;
				
				if(sort == 0){
					arDay.push(trendDate);	
				}
				var wcCd = el.WC_CD;
				var codeNm = el.CODE_NM;
				var resultValue = el.RESULT_VALUE;
				var targetValue = el.TARGET_VALUE;
				var partCnt = el.PART_CNT - 1;
				var colorFlag = colorWhite;
				
				if(targetValue > resultValue){
					colorFlag = colorRed;
				}
				
				if(i == 0){
					tmpData = {x : firstCnt, y : secondCnt, value : resultValue, color : colorFlag};
					codeNmArray.push(codeNm);
				}else{
					if(secondCnt == partCnt){
						firstCnt++;
						secondCnt = 0;
						codeNmArray.push(codeNm);
					}else{
						secondCnt++;	
					}	
					tmpData = {x : firstCnt, y : secondCnt, value : resultValue, color : colorFlag};
				}
				dataArray.push(tmpData);
			});
			
			this.chartHeatMapGen('mainWorkRateChart', arDay, codeNmArray, dataArray);
			
			//FQC 불량률
			var tmpWeek = 0, tmpDisWeek;
			arDay = new Array();
			
			$.each (supply.bucket.day, function (i, el) {
				
				var elDisDay = el.DISDAY;
				var elYearWeek = el.YEARWEEK
				var elDisYearWeek = el.DISYEARWEEK;
				
				if(elYearWeek > tmpWeek){
					tmpWeek = elYearWeek;
					tmpDisWeek = elDisYearWeek;
				}
				arDay.push(elDisDay);
			});
			
			codeNmArray = new Array();
			dataArray = new Array();
			firstCnt = 0;
			secondCnt = 0;
			$("#fqcH4").append(" (" + tmpDisWeek + ")");
			
			$.each(res.fqcFaultyRate, function(i, val){
				
				var tmpData = {};
				
				var majorGroupNm = val.MAJOR_GROUP_NM;
				var defRate = val.DEF_RATE;
				var defRateTarget = val.DEF_RATE_TARGET;
				var partCnt = val.PART_CNT - 1;
				var colorFlag = colorWhite;
				
				/* if(gfn_nvl(defRate, 0) > gfn_nvl(defRateTarget, 0)){
					colorFlag = colorRed;
				} */
				
				if(i == 0){
					tmpData = {x : firstCnt, y : secondCnt, value : defRate, color : colorFlag};
					codeNmArray.push(majorGroupNm);
				}else{
					if(secondCnt == partCnt){
						firstCnt++;
						secondCnt = 0;
						codeNmArray.push(majorGroupNm);
					}else{
						secondCnt++;	
					}	
					tmpData = {x : firstCnt, y : secondCnt, value : defRate, color : colorFlag};
				}
				dataArray.push(tmpData);
			});
			
			this.chartHeatMapGen('fqcFaultyRate', arDay, codeNmArray, dataArray);
			
			//주간 진척률
			var columnData = [];
	    	$.each(res.weekProgress, function(n, v) {
	    		columnData.push({name: v.ROUTING_ID, y: v.CHART_T});
	    	});
	    
	    	chartId = "weekProgress";
	    	Highcharts.chart(chartId, {
	    	    xAxis: { type: 'category' },
	    	    yAxis: [{ // left yAxis
	    	    	//max: 101,
	    	    	plotLines: [{
	    	            value: 100,
	    	            color: 'red',
	    	            width: 2,
	    	            dashStyle: 'dot',
	    	            label : {
	    	            	text: '100%',
	    	                align: 'center',
	    	            }
	    	        }]
	    	    }],
	    	    plotOptions: {
	    	        column: {
	    	            dataLabels: {
	    	            	enabled: true,
	    	            	//verticalAlign: "top",
	    	                format: '{'+gv_cFormat+'}%'
	    	            }
	    	        },
	    	        series: {
			    		point: {
			    			events: {
			    				click: function() {
			    					if(chartId == "weekProgress") {
										gfn_comPopupOpen("POPUP_CHART_SUPPLY", {
											rootUrl   : "dashboard",
											url       : "popupChartSupply",
											width     : 1920,
											height    : 1060,
											menuCd    : "SNOP100",
											chartId   : "weekProgress",
											title     : "<spring:message code='lbl.weekProgress' />(%, <spring:message code='lbl.amtStandard' />)"
										});
									} 
			    				}
			    			}
			    		}
			    	}
	    	    },
	    	    legend: {
			    	enabled : false
			    },
			    tooltip: {
			    	pointFormat: '<b>{point.y}</b> ({point.percentage:.0f}%)<br/>',
			        shared: true
			    },
			    
	    	    series: [{
	    	    	type: 'column',
	    	        data: columnData
	    	    }]
	    	});
			
			//주간 공급 계획 html 그리기
			var weekSupplyPlanData = res.weekSupplyPlan;
			var tmp = "<tr height='10'><td colspan=\"2\" style=\"background-color: #bbdefb;width: 36%; \"></td>";
			
			$.each (supply.bucket.week, function (i, el) {
				tmp += "<td style=\"text-align: center;background-color: #bbdefb;width: 13%; \">";
				tmp += el.DISYEARWEEK;
				tmp += "</td>";
			});
			tmp += "</tr>";
			
			$.each(weekSupplyPlanData, function(n, v){
				
				tmp += "<tr>";
				if(n == 0 || n == 5 || n == 10){
					tmp += "<td rowspan=\"5\" style=\"text-align: center;background-color: #bbdefb;\">";
					tmp += v.FIRST_CODE_NM;	
				}
				tmp += "<td style=\"text-align: center;background-color: #bbdefb;width:25%;\">";
				tmp += v.SECOND_CODE_NM;
				tmp += "</td>";
				
				$.each (supply.bucket.week, function (i, el) {
					
					var disWeek = el.DISWEEK;
					var flagYearWeek = el.FLAGYEARWEEK;
					var supplyData = eval("v." + disWeek);
					var flagData = eval("v." + flagYearWeek);
					
					if(flagData == "Y"){
						tmp += "<td onclick=\"weekSupplyPlanPop()\" style=\"cursor:pointer;background-color:"+ colorRed +";\">";						
					}else{
						tmp += "<td onclick=\"weekSupplyPlanPop()\" style=\"cursor:pointer;\">";	
					}
						
					tmp += supplyData;
					tmp += "</td>";
				});
				tmp += "</tr>";
			});
			
			$("#weekSupplyPlanBody").html(tmp);
			
			//주요 품목그룹 생산 실적/계획 html 그리기
			var totRstQty = 0;
			var totPlanQty = 0;
			var mainItemWeekProdData = res.mainItemWeekProd;
			tmp = "<tr><td style=\"background-color: #bbdefb;width: 12%;text-align: center; \"><spring:message code='lbl.mainItem2' /></td>";
			
			$.each(mainItemWeekProdData, function(n, v){
			
				var rn = v.RN;
				var disDay = v.DIS_DAY.substring(0,v.DIS_DAY.length-5);
				var disYearWeek = v.DIS_YEARWEEK;
				
				tmp += "<td style=\"text-align: center;background-color: #bbdefb;width: 11%; \">";
				tmp += disDay;
				tmp += "</td>";
				
				if(rn == 7){
					tmp += "<td style=\"text-align: center;background-color: #bbdefb;width: 11%; \">";
					tmp += disYearWeek;
					tmp += "</td>"
					return false;
				}
				
			});
			tmp += "</tr>";
			
			$.each(mainItemWeekProdData, function(n, v){
				
				var rn = v.RN;				
				var majorGroupNm = v.MAJOR_GROUP_NM;
				var rstQty = v.RST_QTY;
				var planQty = v.PLAN_QTY;
				var qty = rstQty + " / " + planQty;
				
				totRstQty = Number(totRstQty) + Number(rstQty);
				totPlanQty = Number(totPlanQty) + Number(planQty);
				
				
				if(rn == 1){
					tmp += "<tr><td style=\"text-align: center;background-color: #bbdefb;\">"+ majorGroupNm +"</td>";
				}
				
				tmp += "<td onclick=\"mainItemWeekProdPop()\" style=\"cursor:pointer;text-align: center;\">";
				tmp += qty;
				tmp += "</td>";
				
				
				if(rn == 7){
					
					var totQty = totRstQty + " / " + totPlanQty;
					tmp += "<td onclick=\"mainItemWeekProdPop()\" style=\"cursor:pointer;text-align: center;\">";
					tmp += totQty;
					tmp += "</td>";
					tmp += "</tr>";
					
					totRstQty = 0;
					totPlanQty = 0;
				}
			});
			$("#mainItemWeekProdBody").html(tmp);
			
			
			<c:if test="${sessionScope.isSalesTeam[0].isSalesTeam =='F'}">
			//제조 Lead Time (최근 4주)
			var targetArr = new Array();
			var qtyArr = new Array();
			var groupNmArr = new Array();
			
			$.each(res.manufLeadTime, function(n, v){
				
				var majorGroupNm = v.MAJOR_GROUP_NM;
				var mfgLtTarget = gfn_nvl(v.MFG_LT_TARGET, 0);
				var qty = gfn_nvl(v.QTY, 0);
				
				groupNmArr.push(majorGroupNm);
				targetArr.push(mfgLtTarget);
				qtyArr.push(qty);
			});
			
			Highcharts.chart('manufLeadTime', {
			    chart: {
			        type: 'bar'
			    },
			    title: {
			        text: null
			    },
			    xAxis: {
			        categories: groupNmArr,
			        title: {
			            text: null
			        }
			    },
			    yAxis: {
			        min: 0,
			        title: {
			            text: null,
			            align: 'high'
			        },
			        labels: {
			            overflow: 'justify'
			        }
			    },
			    plotOptions: {
			    	series: {
			    		
			    		events:{
			    			
			    			legendItemClick: function() {
								
			                    var seriesIndex = this.index;
			                    var series = this.chart.series;
			                   	
			                	if(this.chart.isFirstClick!= true)
			                	{
						        	for (var i = 0; i < series.length; i++) {
			                    	   
						                if(series[i].index != seriesIndex) {
						                    series[i].hide();
					                    }
						                else if(series[i].index == seriesIndex)
						                {
						                	series[i].show();
						                }
					                   
			                    	}
			                    	this.show()
			                    	this.chart.isFirstClick = true;
			                		
			                    	
				            		return false;
			                	}
			                			    	
			            	},// end of legendItemClick
			    		},
		    			point: {
		    				events: {
		    					click: function() {
									gfn_comPopupOpen("POPUP_CHART_SUPPLY", {
										rootUrl   : "dashboard",
										url       : "popupChartSupply",
										width     : 1920,
										height    : 1060,
										menuCd    : "SNOP100",
										chartId   : "manufLeadTime",
										title     : "<spring:message code='lbl.manufLeadTime' />"
									});
		    					}
		    				}
		    			}
		    		},
			        bar: {
			            dataLabels: {
			                enabled: true,
			                style : {
			                	fontSize : "12px",
			                	fontWeight: ''
							}
			            }
			        }
			    },
			    legend: {
			        layout: 'vertical',
			        align: 'right',
			        verticalAlign: 'top',
			        x: -40,
			        y: 80,
			        floating: true,
			        borderWidth: 1,
			        backgroundColor: Highcharts.defaultOptions.legend.backgroundColor || '#FFFFFF',
			        shadow: true
			    },
			    credits: {
			        enabled: false
			    },
			    series: [{
			        name: "<spring:message code='lbl.target' />",
			        data: targetArr
			    }, {
			        name: "<spring:message code='lbl.performance' />",
			        data: qtyArr
			    }]
			});			
			</c:if>
			
			//삼성전자 CPFR 품목 PSI
			/*
			tmp = "<tr height='10'><td style=\"background-color: #bbdefb;width: 40%; \"></td>";
			
			$.each(res.cpfrInvInfo, function(n, v){
				var rn = v.RN;
				var disWeek = v.DIS_WEEK;
				
				tmp += "<td style=\"text-align: center;background-color: #bbdefb;width: 10%; \">";
				tmp += disWeek;
				tmp += "</td>";
				
				if(rn == 6){
					return false;
				}
			});
			
			tmp += "</tr>";
			
			$.each(res.cpfrInvInfo, function(n, v){
				
				var rn = v.RN;
				var disName = v.DIS_NAME;
				var resultValue = v.RESULT_VALUE;
				var colorFlag = colorWhite;
				
				
				if(resultValue < 0){
					colorFlag = colorRed;
				}
				
				if(rn == 1){
					tmp += "<tr><td style=\"text-align: center;background-color: #bbdefb;\">";
					tmp += disName;
					tmp += "</td>";
				}
				
				tmp += "<td onclick=\"cpfrInvInfoPop()\" style=\"cursor:pointer;text-align: center;background-color:"+ colorFlag +";\">";
				tmp += resultValue;
				tmp += "</td>";
				
				if(rn == 6){
					tmp += "</tr>";
				}
			});
			
			$.each($(".planWeekTxt"), function(n,v) {
	    		$(v).text(' ('+supply.bucket.apsStartWeek.APS_START_WEEK+')');
	    	});
			
			$("#cpfrInvInfoBody").html(tmp);
			*/
		},
		
		tagetStyle : function (arData) {
			$.each(arData, function(i, val) {
				if (val.name.indexOf('Target') > -1) {
					val.dashStyle = 'ShortDash';
					val.marker  = { enabled: false }; 
				} 
			});
			return arData;
		},
		
		chartHeatMapGen : function (chartId, arYCate, arCarte, arData){
			
			var fontSizeVal = 11;
			
			if(chartId == "mainWorkRateChart"){
				fontSizeVal = 9;
			}
			
			Highcharts.chart(chartId, {

			    chart: {
			        type: 'heatmap',
			        marginTop: 40,
			        marginBottom: 80,
			        plotBorderWidth: 1
			    },

			    xAxis: {
			        categories: arCarte,
			        labels : {
			        	style : {
			        		fontSize: fontSizeVal
			        	}
			        }
			    },
			    
			    yAxis: {
			        categories: arYCate,
			        labels : { 
			        	enabled : true,
			        	style : {
			        		fontSize: fontSizeVal
			        	}
			        },
			        title: { text: null },
			    },

			   accessibility: {
			        point: {
			            descriptionFormatter: function (point) {
			                var ix = point.index + 1,
			                    xName = getPointCategoryName(point, 'x'),
			                    yName = getPointCategoryName(point, 'y'),
			                    val = point.value;
			                return ix + '. ' + xName + ' sales ' + yName + ', ' + val + '.';
			            }
			        }
			    },

			    colorAxis: {
			        min: 0,
			        minColor: '#FFFFFF',
			        maxColor: Highcharts.getOptions().colors[0]
			    },

			    legend: {
			    	enabled : false			    	
			        /* align: 'right',
			        layout: 'vertical',
			        margin: 0,
			        verticalAlign: 'top',
			        y: 25,
			        symbolHeight: 210 */
			    },

			    tooltip: {
			        formatter: function () {
			            return '<b>' + getPointCategoryName(this.point, 'x') + '</b><br><b>' +
			                gfn_nvl(this.point.value, "") + '</b><br><b>' + getPointCategoryName(this.point, 'y') + '</b>';
			        }
			    },

			    series: [{
			        borderWidth: 1,
			        data: arData,
			        dataLabels: {
			            enabled: true,
			            color: '#000000',
			            style : {
			            	fontSize : "12px",
			            	fontWeight: ''
						}
			        }
			    }],

			    responsive: {
			        rules: [{
			            condition: {
			                maxWidth: 500
			            },
			            chartOptions: {
			                yAxis: {
			                    labels: {
			                        formatter: function () {
			                           // return this.value.charAt(0);
			                        }
			                    }
			                }
			            }
			        }]
			    },
			    
			    plotOptions: {
			    	series: {
			    		point: {
			    			events: {
			    				click: function() {
			    					if(chartId == "mainEqu") {
										gfn_comPopupOpen("POPUP_CHART_SUPPLY", {
											rootUrl   : "dashboard",
											url       : "popupChartSupply",
											width     : 1920,
											height    : 1060,
											menuCd    : "SNOP100",
											chartId   : "mainEqu",
											title     : "<spring:message code='lbl.mainEqu' />"
										});
									} else if(chartId == "fqcFaultyRate") {
										gfn_comPopupOpen("POPUP_CHART_SUPPLY", {
											rootUrl   : "dashboard",
											url       : "popupChartSupply",
											width     : 1920,
											height    : 1060,
											menuCd    : "SNOP100",
											chartId   : "fqcFaultyRate",
											title     : $("#fqcH4").html()
										});
									} else if(chartId == "mainWorkRateChart") {
										gfn_comPopupOpen("POPUP_CHART_SUPPLY", {
											rootUrl   : "dashboard",
											url       : "popupChartSupply",
											width     : 1920,
											height    : 1060,
											menuCd    : "SNOP100",
											chartId   : "mainWorkRateChart",
											title     : "<spring:message code='lbl.mainWorkRate' />"
										});
									} 
			    				}
			    			}
			    		}
			    	}
			    }
			});
		}
	};
	
	function getPointCategoryName(point, dimension) {
	    var series = point.series,
	        isY = dimension === 'y',
	        axis = series[isY ? 'yAxis' : 'xAxis'];
	    return axis.categories[point[isY ? 'y' : 'x']];
	}
	
	function weekSupplyPlanPop(){
		gfn_comPopupOpen("POPUP_CHART_SUPPLY", {
			rootUrl   : "dashboard",
			url       : "popupChartSupply",
			width     : 1920,
			height    : 1060,
			menuCd    : "SNOP100",
			chartId   : "weekSupplyPlan",
			title     : "<spring:message code='lbl.weekSupplyPlan' /> (<spring:message code='lbl.hMillion' />)"
		});
	}
	
	
	function mainItemWeekProdPop(){
		gfn_comPopupOpen("POPUP_CHART_SUPPLY", {
			rootUrl   : "dashboard",
			url       : "popupChartSupply",
			width     : 1920,
			height    : 1060,
			menuCd    : "SNOP100",
			chartId   : "mainItemWeekProd",
			title     : "<spring:message code='lbl.mainItemWeekProd' />"
		});
	}
	
	
	function cpfrInvInfoPop(){
		gfn_comPopupOpen("POPUP_CHART_SUPPLY", {
			rootUrl   : "dashboard",
			url       : "popupChartSupply",
			width     : 1920,
			height    : 1060,
			menuCd    : "SNOP100",
			chartId   : "cpfrInvInfo",
			title     : "<spring:message code='lbl.cpfrInvInfo' />"
		});
	}
	
	
	
	function fn_setHighchartTheme(isStack) {
		var theme = {
			colors: gv_cColors,
			chart: {
				backgroundColor: {
					linearGradient: [0, 0, 500, 500],
					stops: [
						[0, 'rgb(255, 255, 255)'],
					]
				},
				style: {
					fontFamily: 'Arial'
				}
			},
			title: {
				text: null ,
				style: {
					color: '#000',
					font: 'bold 16px "Arial", Verdana, sans-serif'
				}
			},
			subtitle: {
				style: {
					color: '#666666',
					font: 'bold 12px "Arial", Verdana, sans-serif'
				}
			},
			yAxis: {
				min    : 0,
				labels : { enabled : false}, 
				title: { text: null },
				stackLabels: { enabled: false },
			},
			legend: {
				enabled: true,
				itemStyle : {
					color      : '#000',
					fontSize   : '11px',
					fontWeight : 'normal'
				}
			},
			tooltip : {
				enabled : false
			},
			credits: {
				enabled: false
			},
			exporting : {
				enabled: true,
				buttons: {
					contextButton: {
		            	align: 'right',
						menuItems: ['printChart','downloadJPEG', 'downloadPDF']
					}
				}
			},
			plotOptions: {
				series: {
					maxPointWidth: 50
				},
				line: {
					dataLabels: {
						enabled: true,
						style : {
							fontSize : "12px",
							fontWeight: ''
						}
					},
					enableMouseTracking: true,
				},
				column: {
					dataLabels: {
						enabled: true,
						style : {
							fontSize : "12px",
							fontWeight: ''
						}
					},
				},
				area: {
					stacking: 'normal',
					lineColor: '#666666',
					lineWidth: 1,
					marker: {
						lineWidth: 1,
						lineColor: '#666666'
					}
				}
			},
			lang: {
				thousandsSep: ','
			}
		};
		
		//테마변수 set
		Highcharts.theme = theme;
		
		// Apply the theme
		Highcharts.setOptions(Highcharts.theme);
	}
	
	//조회
	function fn_apply(sqlFlag) {
		supply.search(sqlFlag);
	}
	
 	// onload 
	$(document).ready(function() {
		supply.init();
	});
	
 	
function fn_popUpAuthorityHasOrNot(){
        
        SCM_SEARCH = {}; // 초기화
        
        SCM_SEARCH.USER_ID = "${sessionScope.userInfo.userId}" ;
        
        
        SCM_SEARCH._mtd     = "getList";
        SCM_SEARCH.tranData = [
                               { outDs : "isSCMTeam",_siq : "dashboard.chartInfo.isSCMTeam"}
                            ];
        
        
        
        var aOption = {
            async   : false,
            url     : GV_CONTEXT_PATH + "/biz/obj",
            data    : SCM_SEARCH,
            success : function (data) {
            
                if (SCM_SEARCH.sql == 'N') {
                    
                    SCM_SEARCH.isSCMTeam = data.isSCMTeam[0].isSCMTeam;
                
                }
            }
        }
        
        gfn_service(aOption, "obj");
        
        
        
    }
  
var fn_popupCallback = function () {
    location.reload();
}

function fn_quilljsInit(){
	  

    quill_1 =  new Quill('#editor-1', {
                  
                  modules: {
                      "toolbar": false
                  } ,            
                  theme: 'snow'  // or 'bubble'
                })
    quill_1.enable(false);
    
    
    quill_2 =  new Quill('#editor-2', {
        
        modules: {
            "toolbar": false
        } ,            
        theme: 'snow'  // or 'bubble'
      })
    quill_2.enable(false);
    
    
    quill_3 =  new Quill('#editor-3', {
        
        modules: {
            "toolbar": false
        } ,            
        theme: 'snow'  // or 'bubble'
      })
    quill_3.enable(false);
    
    
    
    quill_4 =  new Quill('#editor-4', {
        
        modules: {
            "toolbar": false
        } ,            
        theme: 'snow'  // or 'bubble'
      })
    quill_4.enable(false);
    
    
    
    quill_5 =  new Quill('#editor-5', {
        
        modules: {
            "toolbar": false
        } ,            
        theme: 'snow'  // or 'bubble'
      })
    quill_5.enable(false);
    
    
    
    quill_6 =  new Quill('#editor-6', {
        
        modules: {
            "toolbar": false
        } ,            
        theme: 'snow'  // or 'bubble'
      })
    quill_6.enable(false);
    
    
    
    quill_7 =  new Quill('#editor-7', {
        
        modules: {
            "toolbar": false
        } ,            
        theme: 'snow'  // or 'bubble'
      })
    quill_7.enable(false);
    
    
    
    quill_8 =  new Quill('#editor-8', {
        
        modules: {
            "toolbar": false
        } ,            
        theme: 'snow'  // or 'bubble'
      })
    quill_8.enable(false);
    
    


}


function fn_chartContentInit(){
    
    
    /*
    0.  weeklySupplyPlan
	1. 	expectedLoadRateAtMajorWorkplaces
	2.	leadTimeForManufacturingMajorProductGroups
	3.	progressRateOfTheCurrentWeek
	4.	samsungElectronicsCPFRItemPSI
	5.	majorWorkplacePlanComplianceRate
	6.	majorItemGroupFQCDefectiveQuantity
	7.	majorProductGroupProductionPerformancePlan
    
    */
    
    
    for(i=0;i<8;i++)
    {
        if(FORM_SEARCH.chartList[i].ID=="weeklySupplyPlan")                                     FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_1.setContents([{ insert: '\n' }]):quill_1.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
        else if(FORM_SEARCH.chartList[i].ID=="expectedLoadRateAtMajorWorkplaces")               FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_2.setContents([{ insert: '\n' }]):quill_2.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
        else if(FORM_SEARCH.chartList[i].ID=="leadTimeForManufacturingMajorProductGroups")      FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_3.setContents([{ insert: '\n' }]):quill_3.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
        else if(FORM_SEARCH.chartList[i].ID=="progressRateOfTheCurrentWeek")                    FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_4.setContents([{ insert: '\n' }]):quill_4.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
        else if(FORM_SEARCH.chartList[i].ID=="samsungElectronicsCPFRItemPSI")                   FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_5.setContents([{ insert: '\n' }]):quill_5.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
        else if(FORM_SEARCH.chartList[i].ID=="majorWorkplacePlanComplianceRate")                FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_6.setContents([{ insert: '\n' }]):quill_6.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));
        else if(FORM_SEARCH.chartList[i].ID=="majorItemGroupFQCDefectiveQuantity")              FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_7.setContents([{ insert: '\n' }]):quill_7.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));
        else if(FORM_SEARCH.chartList[i].ID=="majorProductGroupProductionPerformancePlan")      FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_8.setContents([{ insert: '\n' }]):quill_8.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));
                                    
    }
    
    
    
}


	</script>

</head>
<body id="framesb" class="portalFrame">
	<jsp:include page="/WEB-INF/view/layout/commonForm.jsp" flush="false">
		<jsp:param name="siteMapYn" value="Y"/>
	</jsp:include>
	
	<!-- contents -->
	<div id="grid1" class="fconbox">
		<%@ include file="/WEB-INF/view/common/commonLocation.jsp"%>

		<div class="scroll" style="height:calc(100% - 35px)">
			<!-- chart -->
			<div id="container" style="float: left">
				<div id="cont_chart">
					<!-- 주간 공급 계획 1-->
					<div class="col_3">
						<div class="titleContainer">
							<h4 id="weeklySupplyPlanH4"><spring:message code="lbl.weekSupplyPlan" /> (<spring:message code="lbl.hMillion" />)</h4>
							<div class="view_combo">
								<ul class="rdofl">
									<li><input type="radio" id="weekSupplyPlanBodyType1" name="weekSupplyPlanBodyType" value="DIFFUSION" checked="checked"/> <label for="weekSupplyPlanBodyType1"><spring:message code="lbl.diff2" /></label></li>
									<li><input type="radio" id="weekSupplyPlanBodyType2" name="weekSupplyPlanBodyType" value="LAM"/> <label for="weekSupplyPlanBodyType2"><spring:message code="lbl.rcg003" /> </label></li>
									<li><input type="radio" id="weekSupplyPlanBodyType3" name="weekSupplyPlanBodyType" value="TEL"/> <label for="weekSupplyPlanBodyType3"><spring:message code="lbl.rcg004" /> </label></li>
								    <li class="manuel">
                                        <a href="#" id="weeklySupplyPlan"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                    </li>
								</ul>
							</div>
						</div>
						<table id="weeklySupplyPlanTable">
							<tbody id="weekSupplyPlanBody">
							</tbody>
						</table>
						<div class="modal" id="weeklySupplyPlanContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-1"></div>
                           </div>
                       </div>
					</div>
					
					<!-- 주요 작업장 예상부하율 2 -->
					<div class="col_3">
						<div class="titleContainer">
							<h4 id="expectedLoadRateAtMajorWorkplacesH4"><spring:message code="lbl.mainEqu" /></h4>
							<div class="view_combo">
							  <ul class="rdofl">
                                 <li class="manuel">
                                    <a href="#" id="expectedLoadRateAtMajorWorkplaces"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                 </li>
                             </ul>
							</div>
						</div>
						<div style="height: 100%;width: 100%;" id="mainEqu"></div>
						<div class="modal" id="expectedLoadRateAtMajorWorkplacesContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-2"></div>
                           </div>
                       </div>
					</div>
					
					<!-- 제조 Lead Time 9--><!-- 영업담당자들은 못보게 처리 -->
					<div class="col_3">
						<c:if test="${sessionScope.isSalesTeam[0].isSalesTeam =='F'}">
						<div class="titleContainer">
							<h4 id="leadTimeForManufacturingMajorProductGroupsH4"><spring:message code="lbl.manufLeadTime" /></h4>
							<div class="view_combo">
							    <ul class="rdofl">
	                                 <li class="manuel">
	                                    <a href="#" id="leadTimeForManufacturingMajorProductGroups"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
	                                 </li>
                                </ul>
							</div>
						</div>
						<div style="height: 100%;width: 100%;" id="manufLeadTime"></div>
						<div class="modal" id="leadTimeForManufacturingMajorProductGroupsContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-3"></div>
                           </div>
                       </div>
						</c:if>
						
						<c:if test="${sessionScope.isSalesTeam[0].isSalesTeam !='F'}">
						<h4></h4>
						<div style="height: 100%;width: 100%;display:none;" id="manufLeadTime"></div>
						<div class="modal" id="leadTimeForManufacturingMajorProductGroupsContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-3"></div>
                           </div>
                       </div>
						</c:if>
						
					</div>
					
					<!-- 당주 진척률 4-->
					<div class="col_3">
					    <div class="titleContainer">
							<h4 id="progressRateOfTheCurrentWeekH4"><spring:message code="lbl.weekProgress" /> (%, <spring:message code="lbl.amtStandard" />)</h4>
							<div class="view_combo">
							     <ul class="rdofl">
                                     <li class="manuel">
                                        <a href="#" id="progressRateOfTheCurrentWeek"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                     </li>
                                </ul>
							</div>
						</div>
						<div style="height: 100%;width: 100%;" id="weekProgress"></div>
						<div class="modal" id="progressRateOfTheCurrentWeekContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-4"></div>
                           </div>
                       </div>
					</div>
					
					<!-- 삼성전자 CPFR 품목 PSI 5-->
					<div class="col_3">
						<div class="titleContainer">
							<h4 id="samsungElectronicsCPFRItemPSIH4"><spring:message code="lbl.cpfrInvInfo" /><span class="planWeekTxt"></span></h4>
							<div class="view_combo">
								 
							     <ul class="rdofl">
								     <li  style="color:red;font-size:12px;padding:0;margin:0"><spring:message code="lbl.subTitle" /></li>                             
	                                 <li class="manuel">
	                                    <a href="#" id="samsungElectronicsCPFRItemPSI"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
	                                 </li>
	                             
                                </ul>
							</div>
						</div>
						<table id="samsungElectronicsCPFRItemPSITable">
							<tbody id="cpfrInvInfoBody">
							</tbody>
						</table>
						<div class="modal" id="samsungElectronicsCPFRItemPSIContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-5"></div>
                           </div>
                       </div>
					</div>
					
					<!-- 주요 작업장 계획 준수율 6-->
					<div class="col_3">
						<div class="titleContainer">
							<h4 id="majorWorkplacePlanComplianceRateH4"><spring:message code="lbl.mainWorkRate" /></h4>
							<div class="view_combo">
							     <ul class="rdofl">
                                     <li class="manuel">
                                        <a href="#" id="majorWorkplacePlanComplianceRate"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                     </li>
                                 
                                </ul>
							</div>
						</div>
						<div style="height: 100%;width:100%;" id="mainWorkRateChart"></div>
						<div class="modal" id="majorWorkplacePlanComplianceRateContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-6"></div>
                           </div>
                       </div>
					</div>
					
					<!-- FQC 불량률 7-->
					<div class="col_3">
						<div class="titleContainer">
							<h4 id="fqcH4"><spring:message code="lbl.fqcFaultyRate" /></h4>
							<div class="view_combo">
								<ul class="rdofl">
                                     <li class="manuel">
                                        <a href="#" id="majorItemGroupFQCDefectiveQuantity"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                     </li>
                                </ul>
							</div>
						</div>
						<div style="height: 100%;width:100%;" id="fqcFaultyRate"></div>
						<div class="modal" id="majorItemGroupFQCDefectiveQuantityContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-7"></div>
                           </div>
                       </div>
					</div>
					
					<!-- 주요 품목그룹 생산 실적/계획  8-->
					<div class="col_3">
						<div class="titleContainer">
							<h4 id="majorProductGroupProductionPerformancePlanH4"><spring:message code="lbl.mainItemWeekProd" /> <span class="cweekTxt"></span> </h4>
							<div class="view_combo" >
							
								<ul class="rdofl">
									<li><input type="radio" id="mainItemWeekRadio1" name="mainItemWeekRadio" value="diff" checked="checked"/> <label for="mainItemWeekRadio1"><spring:message code="lbl.diff2" /></label></li>
									<li><input type="radio" id="mainItemWeekRadio2" name="mainItemWeekRadio" value="etch" /> <label for="mainItemWeekRadio2"><spring:message code="lbl.etch" /></label></li>
								    <li class="manuel">
                                        <a href="#" id="majorProductGroupProductionPerformancePlan"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                     </li>
								</ul>
							
							</div>
						</div>
						<table id="majorProductGroupProductionPerformancePlanTable">
							<tbody id="mainItemWeekProdBody">
							</tbody>
						</table>
						<div class="modal" id="majorProductGroupProductionPerformancePlanContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-8"></div>
                           </div>
                       </div>
					</div>
					
					<!-- BLANK -->
					<div class="col_3">
						
						<h4><%-- <spring:message code="lbl.achieRateChart4"/> (M+3) (%) --%></h4>
						<div class="view_combo" style="float: right;">
							<%-- <ul class="rdofl">
								<li><input type="radio" id="achivRt1" name="achivRt" value="cust"/> <label for="achivRt1"><spring:message code="lbl.reptCust" /></label></li>
								<li><input type="radio" id="achivRt2" name="achivRt" value="total" checked="checked"/> <label for="achivRt2"><spring:message code="lbl.total" /> </label></li>
							</ul> --%>
						</div>
						<div style="height: 88%" id="chart12"></div>
					</div>
					
				</div>
			</div>
			<div id="cont_chart3">
				<div id="cont_chart">
					<div class="col_3" style="height:100%;width:100%;margin: 0;padding:0">
						<div id="sitemappop" style="margin: 0; display:block; height:calc(100% - 30px);width:100%;">
							<div class="drag">
<!-- 								<div class="pop_tit">Site Map</div> -->
								<div style="height: 100%;padding: 15px 0px 15px 10px;">
									<div class="scroll"></div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
