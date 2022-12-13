<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code="lbl.chart"/></title>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
	<jsp:param name="popupYn" value="Y"/>
	<jsp:param name="chartYn" value="Y"/>
</jsp:include>

<style type="text/css">
	
	
	#cont_chart { width: 100%; height: 100%;}
	#cont_chart .col_3 { width: 100%; height: 95%; margin:0 10px 10px 0;}

	.view_combo .rdofl li label{font-size:30px}
	
	table {
		width: 100%;
		height: 88%;
	    border: 1px solid #444444;
	}
	
	td {
		border: 1px solid #444444;
		padding-right: 5px;
		text-align: right;
		font-size:30px;
	}
</style>

<script type="text/javascript">
	var colorWhite = "#FFFFFF";
	var colorRed = "#FF0000";
	var colorBlue = "#368AFF";
	var popupChart = {

		init : function () {
			
			this.initSearch();
			this.events();
			
			var userLang = "${sessionScope.GV_LANG}";
			var cDate = gfn_getCurrentDate();
			cWeek = "W" + cDate.WEEKOFYEAR;
			
			$.each($(".cweekTxt"), function(n,v) {
	    		$(v).text(' ('+cWeek+')');
	    	});
			
			
			if(userLang == "ko") {
	    		unit = 100000000;
	    	} else if(userLang == "en" || userLang == "cn") {
	    		unit = 1000000000;
	    	}
		},
	
		_siq	: "dashboard.supply.",
		chart_id : "${popupChartSupply.chartId}",
		
		events : function () {
			
			$("#btnClose").on("click", function(){
				window.close(); 
			});
			
			$(':radio[name=weekSupplyPlanBodyType]').on('change', function () {
				popupChart.weekSupplyPlanBodySearch(false);
			});
			
			$(':radio[name=mainItemWeekRadio]').on('change', function () {
				popupChart.mainItemWeekSearch(false);
			});
		},
		
		bucket : null,
		
		initSearch : function () {
			FORM_SEARCH = {}
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.tranData = [{ outDs : "week"  , _siq : popupChart._siq + "trendBucketWeek" }
								  , { outDs : "week2"  , _siq : popupChart._siq + "trendBucketWeek2" }
								  , { outDs : "day" , _siq : popupChart._siq + "trendBucketDay" }
								  , { outDs : "apsStartWeek" , _siq : popupChart._siq + "trendWeek" }
			];
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					popupChart.bucket = {};
					popupChart.bucket.week  = data.week;
					popupChart.bucket.week2 = data.week2;
					popupChart.bucket.day   = data.day;
					popupChart.bucket.apsStartWeek = data.apsStartWeek[0];
					popupChart.search();
				}
			}
			gfn_service(sMap, "obj");
		},
		
		search : function (sqlFlag) {
			FORM_SEARCH            = {};
			FORM_SEARCH            = this.bucket;
			
			if(popupChart.chart_id == "weekSupplyPlan") {
				FORM_SEARCH.weekSupplyPlanBodyType = $(':radio[name=weekSupplyPlanBodyType]:checked').val();
			}else if(popupChart.chart_id == "mainItemWeekProd"){
				FORM_SEARCH.mainItemWeekRadio = $(':radio[name=mainItemWeekRadio]:checked').val(); 
			}
			
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.sql  = sqlFlag;
			FORM_SEARCH.unit = unit;
			
			FORM_SEARCH.tranData   = [
				{ outDs : popupChart.chart_id , _siq : popupChart._siq + popupChart.chart_id }
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					popupChart.drawChart(data);
				}
			};
			gfn_service(sMap,"obj");
		},
		
		drawChart : function (res) {
			fn_setHighchartTheme();
			
			if(popupChart.chart_id == "mainEqu") {
				
				var arWeek = new Array();
				
				$.each (popupChart.bucket.week2, function (i, el) {
					arWeek.push(el.DISYEARWEEK);
				});
				
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
				
				this.chartHeatMapGen('mainEqu', arWeek, codeNmArray, dataArray);
			}else if(popupChart.chart_id == "fqcFaultyRate") {
				
				var arDay = new Array();
				
				$.each (popupChart.bucket.day, function (i, el) {
					var elDisDay = el.DISDAY;
					arDay.push(elDisDay);
				});
				
				var codeNmArray = new Array();
				var dataArray = new Array();
				var firstCnt = 0;
				var secondCnt = 0;
				
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
				
				
			}else if(popupChart.chart_id == "weekSupplyPlan") {
				
				var weekSupplyPlanData = res.weekSupplyPlan;
				var tmp = "<tr><td colspan=\"2\" style=\"background-color: #bbdefb;width: 14%; \"></td>";
				
				$.each (popupChart.bucket.week, function (i, el) {
					tmp += "<td style=\"text-align: center;background-color: #bbdefb;width: 14%; \">";
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
					tmp += "<td style=\"text-align: center;background-color: #bbdefb;width:14%;\">";
					tmp += v.SECOND_CODE_NM;
					tmp += "</td>";
					
					$.each (popupChart.bucket.week, function (i, el) {
						
						var disWeek = el.DISWEEK;
						var flagYearWeek = el.FLAGYEARWEEK;
						var supplyData = eval("v." + disWeek);
						var flagData = eval("v." + flagYearWeek);
						
						if(flagData == "Y"){
							tmp += "<td style=\"cursor:pointer;background-color:red;\">";						
						}else{
							tmp += "<td>";	
						}
							
						tmp += supplyData;
						tmp += "</td>";
					});
					tmp += "</tr>";
				});
				
				$("#weekSupplyPlanBody").html(tmp);
				
				
			}else if(popupChart.chart_id == "cpfrInvInfo") {
				
				tmp = "<tr><td style=\"background-color: #bbdefb;width: 40%; \"></td>";
				
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
		    		$(v).text(' ('+popupChart.bucket.apsStartWeek.APS_START_WEEK+')');
		    	});
				
				$("#cpfrInvInfoBody").html(tmp);
				
				
			}else if(popupChart.chart_id == "mainItemWeekProd") {
				//주요품목 주간생산수량 html 그리기
				var totRstQty = 0;
				var totPlanQty = 0;
				var mainItemWeekProdData = res.mainItemWeekProd;
				tmp = "<tr><td style=\"background-color: #bbdefb;width: 12%;text-align: center; \"><spring:message code='lbl.mainItem2' /></td>";
				
				$.each(mainItemWeekProdData, function(n, v){
				
					var rn = v.RN;
					var disDay = v.DIS_DAY;
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
					
					tmp += "<td style=\"text-align: center;\">";
					tmp += qty;
					tmp += "</td>";
					
					
					if(rn == 7){
						
						var totQty = totRstQty + " / " + totPlanQty;
						tmp += "<td style=\"text-align: center;\">";
						tmp += totQty;
						tmp += "</td>";
						tmp += "</tr>";
						
						totRstQty = 0;
						totPlanQty = 0;
					}
				});
				$("#mainItemWeekProdBody").html(tmp);
				
			}else if(popupChart.chart_id == "weekProgress") {
				
				var columnData = [];
		    	$.each(res.weekProgress, function(n, v) {
		    		columnData.push({name: v.ROUTING_ID, y: v.CHART_T});
		    	});
		    	
		    	Highcharts.chart(popupChart.chart_id, {
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
		    	                align: 'left',
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
			}else if(popupChart.chart_id == "manufLeadTime"){
				
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
				
				Highcharts.chart(popupChart.chart_id, {
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
				        bar: {
				            dataLabels: {
				                enabled: true
				            }
				        },
				        series:{
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
				
			}else if(popupChart.chart_id == "mainWorkRateChart"){
				var arDay = new Array();
				var codeNmArray = new Array();
				var dataArray = new Array();
				var firstCnt = 0;
				var secondCnt = 0;
				
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
					
					if(gfn_nvl(targetValue, 0) > gfn_nvl(resultValue, 0)){
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
			}
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
		
		mainItemWeekSearch : function(sqlFlag) {
			
			FORM_SEARCH          = {};
			FORM_SEARCH          = this.bucket;
			FORM_SEARCH.mainItemWeekRadio = $(':radio[name=mainItemWeekRadio]:checked').val();
			
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "mainItemWeekProd", _siq : popupChart._siq + "mainItemWeekProd" },
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
						var disDay = v.DIS_DAY;
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
				{ outDs : "weekSupplyPlan", _siq : popupChart._siq + "weekSupplyPlan" },
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					
					//주간 공급 계획 html 그리기
					var weekSupplyPlanData = data.weekSupplyPlan;
					var tmp = "<tr><td colspan=\"2\" style=\"background-color: #bbdefb;width: 36%; \"></td>";
					
					$.each (popupChart.bucket.week, function (i, el) {
						tmp += "<td style=\"text-align: center;background-color: #bbdefb;width: 13%; \">";
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
						
						$.each (popupChart.bucket.week, function (i, el) {
							
							var disWeek = el.DISWEEK;
							var flagYearWeek = el.FLAGYEARWEEK;
							var supplyData = eval("v." + disWeek);
							var flagData = eval("v." + flagYearWeek);
							
							if(flagData == "Y"){
								tmp += "<td style=\"background-color:"+ colorRed +";\">";						
							}else{
								tmp += "<td>";	
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
		
		chartHeatMapGen : function (chartId, arYCate, arCarte, arData){
			
			Highcharts.chart(chartId, {

			    chart: {
			        type: 'heatmap',
			        marginTop: 40,
			        marginBottom: 80,
			        plotBorderWidth: 1
			    },

			    xAxis: {
			        categories: arCarte
			    },
			    
			    yAxis: {
			        categories: arYCate,
			        labels : { 
			        	enabled : true,
			        	style : {
							fontSize : "30px"
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
			                this.point.value + '</b><br><b>' + getPointCategoryName(this.point, 'y') + '</b>';
			        }
			    },

			    series: [{
			        borderWidth: 1,
			        data: arData,
			        dataLabels: {
			            enabled: true,
			            color: '#000000'
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
			                            return this.value.charAt(0);
			                        }
			                    }
			                }
			            }
			        }]
			    }

			});
		},
		
		chartGen : function (chartId, type, arCarte, arData, isStack) {
			
			if (chartId == 'chart6') {
				Highcharts.theme.colors[1] = '#f7848d';
				Highcharts.theme.colors[2] = gv_cColor1;
				Highcharts.theme.colors[3] = '#f7848d';
			} else {
				Highcharts.theme.colors[1] = gv_cColor2;
				Highcharts.theme.colors[2] = '#f7848d';
				Highcharts.theme.colors[3] = '#f0a482';
			}
			
			if (arData.length == 0) {
				return false;
			}
			
			isStack = isStack || false;
			
			var chart = {
				chart  : { type : type },
				xAxis  : { categories : arCarte },
				series : arData,
				plotOptions: {
					column: {
						stacking: 'normal',
						dataLabels: {
							enabled: true,
						},
					},
					series: {
						events: {
							afterAnimate : function(e){
								
								/* var chartLen = this.chart.series.length;
								var chart23RadioData = $(':radio[name=chart23Radio]:checked').val();
								
								if(chartId == "chart23")	{
									if(chart23RadioData == "cust"){
				        				for(var i = 0; i < chartLen; i++){
				        					
				        					var chartCode = this.chart.series[i].userOptions.code;
				        					
				        					if(chartCode != "RCG001"){
				        						this.chart.series[i].hide();	
				        					}
				        				}
									}
			        			} */
			        		}
						}
					}
				},
			};
			
			if (!isStack) {
				delete chart.plotOptions.column.stacking;
			}
			Highcharts.chart(chartId, chart);
		}
	};
	
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
					font: 'bold 30px "Arial", Verdana, sans-serif'
				}
			},
			subtitle: {
				style: {
					color: '#666666',
					font: 'bold 30px "Arial", Verdana, sans-serif'
				}
			},
			xAxis : {
				labels : {
					style : {
						fontSize : "30px"
					}
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
					fontSize   : '30px',
					fontWeight : 'normal'
				}
			},
			tooltip : {
				
				headerFormat: '<span style="font-size: 30px">{point.key}</span><br/>',
				enabled : false,
				style : {
					fontSize : "30px"
				}
			},
			credits: {
				enabled: false
			},
			exporting : {
				enabled: true,
				buttons: {
					contextButton: {
		            	align: 'left',
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
							fontSize : "30px"
						}
					},
					enableMouseTracking: true,
				},
				column: {
					dataLabels: {
						enabled: true,
						style : {
							fontSize : "30px"
						}
					},
				},
				heatmap: {
					dataLabels: {
						enabled: true,
						style : {
							fontSize : "30px"
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
	
	function getPointCategoryName(point, dimension) {
	    var series = point.series,
	        isY = dimension === 'y',
	        axis = series[isY ? 'yAxis' : 'xAxis'];
	    return axis.categories[point[isY ? 'y' : 'x']];
	}
	
	//조회
	function fn_apply(sqlFlag) {
	
	}
	
 	// onload 
	$(document).ready(function() {
		popupChart.init();
	});
	

</script>

</head>
<body>
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="keywordpop" class="popupDv" style="height:1000px;">
		<div class="popCont">
			<!-- chart -->
			<div id="cont_chart">
				<div class="col_3">
					<c:choose>
					<c:when test="${popupChartSupply.chartId == 'mainItemWeekProd'}">
					<h4 id="title" style="font-size: 30px;">${popupChartSupply.title} <span class="cweekTxt"></span> </h4>
					</c:when>
					<c:when test="${popupChartSupply.chartId == 'cpfrInvInfo'}">
					<h4 id="title" style="font-size: 30px;">${popupChartSupply.title} <span class="planWeekTxt"></span><div style="text-align: right;color:red;font-size:12px;"><spring:message code="lbl.subTitle" /></div> </h4>
					</c:when>
					<c:otherwise>
					<h4 id="title" style="font-size: 30px;">${popupChartSupply.title} </h4>
					</c:otherwise>
					</c:choose>
					
					
					
					
					<c:choose>
						<c:when test="${popupChartSupply.chartId == 'weekSupplyPlan'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="weekSupplyPlanBodyType1" name="weekSupplyPlanBodyType" value="DIFFUSION" checked="checked"/> <label for="weekSupplyPlanBodyType1"><spring:message code="lbl.diff2" /></label></li>
								<li><input type="radio" id="weekSupplyPlanBodyType2" name="weekSupplyPlanBodyType" value="LAM"/> <label for="weekSupplyPlanBodyType2"><spring:message code="lbl.rcg003" /> </label></li>
								<li><input type="radio" id="weekSupplyPlanBodyType3" name="weekSupplyPlanBodyType" value="TEL"/> <label for="weekSupplyPlanBodyType3"><spring:message code="lbl.rcg004" /> </label></li>
							</ul>
						</div>
						<table>
							<tbody id="weekSupplyPlanBody">
							</tbody>
						</table>
						</c:when>
						<c:when test="${popupChartSupply.chartId == 'mainEqu'}">
						<div class="view_combo" style="float: right;">
						</div>
						<div style="height: 88%" id="mainEqu"></div>
						</c:when>
						<c:when test="${popupChartSupply.chartId == 'weekProgress'}">
						<div class="view_combo" style="float: right;">
						</div>
						<div style="height: 88%" id="weekProgress"></div>
						</c:when>
						<c:when test="${popupChartSupply.chartId == 'fqcFaultyRate'}">
						<div class="view_combo" style="float: right;">
						</div>
						<div style="height: 88%" id="fqcFaultyRate"></div>
						</c:when>
						
						<c:when test="${popupChartSupply.chartId == 'mainItemWeekProd'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="mainItemWeekRadio1" name="mainItemWeekRadio" value="diff" checked="checked"/> <label for="mainItemWeekRadio1"><spring:message code="lbl.diff2" /></label></li>
								<li><input type="radio" id="mainItemWeekRadio2" name="mainItemWeekRadio" value="etch" /> <label for="mainItemWeekRadio2"><spring:message code="lbl.etch" /></label></li>
							</ul>
						</div>
						<table>
							<tbody id="mainItemWeekProdBody">
							</tbody>
						</table>
						</c:when>
						
						<c:when test="${popupChartSupply.chartId == 'manufLeadTime'}">
						<div class="view_combo" style="float: right;">
						</div>
						<div style="height: 88%" id="manufLeadTime"></div>
						</c:when>
						
						<c:when test="${popupChartSupply.chartId == 'mainWorkRateChart'}">
						<div class="view_combo" style="float: right;">
						</div>
						<div style="height: 88%" id="mainWorkRateChart"></div>
						</c:when>
						
						<c:when test="${popupChartSupply.chartId == 'cpfrInvInfo'}">
						<div class="view_combo" style="float: right;">
						</div>
						<table>
							<tbody id="cpfrInvInfoBody">
							</tbody>
						</table>
						</c:when>
						
						
						<%-- <c:when test="${popupChartSupply.chartId == 'chart11'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="salesFcst1" name="salesFcst" value="cust" > <label for="salesFcst1"><spring:message code="lbl.reptCust" /></label></li>
								<li><input type="radio" id="salesFcst2" name="salesFcst" value="total" checked="checked"> <label for="salesFcst2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart11"></div>
						</c:when> --%>
						
					</c:choose>

				</div>
			</div>
			<div class="pop_btn">
				<a href="javascript:;" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
			</div>
		</div>
	</div>
</body>
</html>