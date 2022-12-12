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
	var unit = 0;
	var unit2 = 0;
	var colorWhite = "#FFFFFF";
	var colorRed = "#FF0000";
	var colorBlue = "#368AFF";
	var popupChart = {

		init : function () {
			
			this.initSearch();
			this.events();
			
			var userLang = "${sessionScope.GV_LANG}";
			
			if(userLang == "ko") {
	    		unit = 100000000;
	    		unit2 = 10000;
	    	} else if(userLang == "en" || userLang == "cn") {
	    		unit = 1000000000;
	    		unit2 = 1000;
	    	}
		},
	
		_siq	: "dashboard.scmDash.",
		chart_id : "${popupChartScmDash.chartId}",
		
		events : function () {
			
			$("#btnClose").on("click", function(){
				window.close(); 
			});
			
			/* $(':radio[name=sales]').on('change', function () {
				popupChart.salesSearch(false);
			}); */
		},
		
		bucket : null,
		
		initSearch : function () {
			FORM_SEARCH = {}
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.tranData = [{ outDs : "month" , _siq : popupChart._siq + "trendBucketMonth" }
								  , { outDs : "apsStartWeek" , _siq : popupChart._siq + "trendWeek" }
			];
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					popupChart.bucket = {};
					popupChart.bucket.month = data.month;
					popupChart.bucket.apsStartWeek = data.apsStartWeek[0];;
					
					popupChart.search();
				}
			}
			gfn_service(sMap, "obj");
		},
		
		search : function (sqlFlag) {
			FORM_SEARCH            = {};
			FORM_SEARCH            = this.bucket;
			
			/* if(popupChart.chart_id == "chart10") {
				FORM_SEARCH.sales      = $(':radio[name=sales]:checked').val();
				FORM_SEARCH.salesInv   = $(':radio[name=salesInv]:checked').val();
			}  */
			
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.sql  = sqlFlag;
			FORM_SEARCH.unit = unit;
			FORM_SEARCH.unit2 = unit2;
			
			FORM_SEARCH.tranData   = [
				{ outDs : popupChart.chart_id , _siq : popupChart._siq + popupChart.chart_id }
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					popupChart.drawChart(data);
				}
			};
			gfn_service(sMap,"obj");
		},
		
		drawChart : function (res) {
			fn_setHighchartTheme();
			
			var arMonth    = new Array();
			var arPreMonth = new Array();
			
			$.each (popupChart.bucket.month, function (i, el) {
				arMonth.push(el.DISMONTH);
				arPreMonth.push(el.PRE_DISMONTH);
			});
			
			if(popupChart.chart_id == "avgShipPriceChart") {
				var avgShipPriceChart = JSON.parse(res.avgShipPriceChart[0].AVG_SHIP);
				this.chartGen('avgShipPriceChart', 'line', arPreMonth, avgShipPriceChart);
			}else if(popupChart.chart_id == "cpfrInvInfo") {
				
				var tmp = "<tr><td style=\"background-color: #bbdefb;width: 40%; \"></td>";
				
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
								
								var chartLen = this.chart.series.length;
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
			        			}
			        		},
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
			                			    	
			            	}// end of legendItemClick
						}
					}
				},
			};
			
			if (!isStack) {
				delete chart.plotOptions.column.stacking;
			}
			Highcharts.chart(chartId, chart);
			
			$("#" + chartId).css("overflow", "");
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
						<c:when test="${popupChartScmDash.chartId == 'cpfrInvInfo'}">
						<h4 id="title" style="font-size: 30px;">${popupChartScmDash.title} <span class="planWeekTxt"></span> </h4>
						</c:when>
						<c:otherwise>
						<h4 id="title" style="font-size: 30px;">${popupChartScmDash.title} </h4>
						</c:otherwise>
					</c:choose>
					<c:choose>
						<c:when test="${popupChartScmDash.chartId == 'avgShipPriceChart'}">
						<div class="view_combo" style="float: right;">
						</div>
						<div style="height: 88%" id="avgShipPriceChart" ></div>
						</c:when>
						<c:when test="${popupChartScmDash.chartId == 'cpfrInvInfo'}">
						<div class="view_combo" style="float: right;">
						</div>
						<table>
							<tbody id="cpfrInvInfoBody">
							</tbody>
						</table>
						</c:when>
						
						
						
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