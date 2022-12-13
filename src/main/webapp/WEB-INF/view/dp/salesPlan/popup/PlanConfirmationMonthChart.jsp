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

</style>

<script type="text/javascript">
	var monthChart = {
			init : function () {
				this.events();
				this.search(false);
				//this.drawChart();
			},
			
			events : function () {
				
				$("#btnClose").on("click", function(){
					window.close(); 
				});;
			},
			
			
			search : function (sqlFlag) {
				FORM_SEARCH.sql      = sqlFlag;
				FORM_SEARCH._mtd	 = "getList";
				FORM_SEARCH.startMonth	 = "${param.startMonth}";
				FORM_SEARCH.pastPlanId	 = "${param.pastPlanId}";
				FORM_SEARCH.tranData = [];
				FORM_SEARCH.tranData.push( { "outDs" : "rtnList", "_siq" : "dp.planMonth.planConfirmationChart"} );

				gfn_service({
					url    : GV_CONTEXT_PATH + "/biz/obj",
					data   : FORM_SEARCH,
					success: function(data) {
						monthChart.drawChart(data.rtnList);
					}
				}, "obj");
			},
			
			drawChart : function(list) {
				var prodNotAmt   = 0;
				var invenAmt     = 0;
				var prodPossAmt  = 0;
				var salesPlanAmt = 0;
				
				var unit     = 0;
				var userLang = "${sessionScope.GV_LANG}";
				var format   = "y:,.0f";

				if(userLang == "ko") {
					unit     = 100000000;
					roundNum = 0;
					format   = "y:,.0f";
				} else if(userLang == "en" || userLang == "cn") {
					unit     = 1000000000;
					roundNum = 1;
					format   = "y:,.1f";
				}
				
				if(list.length > 0) {
					prodNotAmt   = gfn_getNumberFmt(list[0].PROD_NOT_AMT / unit, roundNum,'R');
					invenAmt     = gfn_getNumberFmt(list[0].INVEN_AMT / unit, roundNum,'R');
					prodPossAmt  = gfn_getNumberFmt(list[0].PROD_POSS_AMT / unit, roundNum,'R');
					salesPlanAmt = gfn_getNumberFmt(list[0].SALES_PLAN_AMT / unit, roundNum,'R');
				}
				
				//테마적용 공통함수
		    	fn_setHighchartTheme();
				
		    	Highcharts.theme.colors[0] = '#BDBDBD';		// 생산불능
				Highcharts.theme.colors[1] = '#FF0000';		// 재고판매
				Highcharts.theme.colors[2] = '#6799FF';		// 생산요청
				Highcharts.theme.colors[3] = '#6799FF';		// 생산계획반영
				Highcharts.theme.colors[4] = '#FFE400';		// 선행생산
				
				var chartId = "chart1";
				
				var chart = Highcharts.chart(chartId, {
					chart: { type: 'column' },
					xAxis: { categories: ['<spring:message code="lbl.salesPlan"/>', '<spring:message code="lbl.prodPlan"/>'] },
					yAxis: {
						stackLabels:{
							enabled : true,
							style   : {
								fontWeight:'bold'
							},
							
							formatter : function() {
		    	    			
		    	    			var tot = 0;
		    	    			var x = this.x;
		    	    			
		    	    			if(list.length > 0) {
		    	    				if(x == 0) {
			    	    				tot = gfn_getNumberFmt((list[0].PROD_NOT_AMT + list[0].INVEN_AMT + list[0].PROD_POSS_AMT) / unit, roundNum, 'R');
			    	    			} else if(x == 1) {
			    	    				tot = gfn_getNumberFmt((list[0].PROD_POSS_AMT + list[0].SALES_PLAN_AMT) / unit, roundNum, 'R');
			    	    			}
		    	    			}
		    	    			
		    	    			return tot;
		    	    		}
						}
					},
					plotOptions: {
						column: {
							stacking: 'normal',
							dataLabels: {
								enabled: true,
								formatter : function() {
									
									var serie = this.series;
									var result = "";
									
									if(serie.options.name != ""){
										result = this.y;
									}
									return result;
								}
							}
						},
						series: {
				            events: {
				                mouseOver: function () {
				                	
				                	$.each(chart.series[5].data, function(i, point) {
				    					point.graphic.attr({opacity: 0, 'stroke-width': 0});
				    				});
				                },
				                mouseOut: function () {
				                	
				                	$.each(chart.series[5].data, function(i, point) {
				    					point.graphic.attr({opacity: 0, 'stroke-width': 0});
				    				});
				                }
				            }
				        }
					},
					
					tooltip : {
						formatter: function() {
							
							var serie = this.series;
							var index = this.series.data.indexOf(this.point);
							
							var s = '<b>' + this.x + '</b><br>';
			                s += '<span>' + serie.options.name + '</span>: <b>' + this.y + '</b><br/>';
			                
			                if(serie.options.name != "") {
			                	return s;
			                } else {
			                	$.each(chart.series[5].data, function(i, point) {
			    					point.graphic.attr({opacity: 0, 'stroke-width': 0});
			    				});
			                	return false;
			                }
						}
					},
					series : [
						{name : '<spring:message code="lbl.salesNot"/>'    , data : [prodNotAmt, '']},
						{name : '<spring:message code="lbl.invSales"/>'    , data : [invenAmt, '']},
						{name : '<spring:message code="lbl.salesReq"/>'    , data : [prodPossAmt, '']},
						{name : '<spring:message code="lbl.salesPlanRef"/>', data : ['', prodPossAmt]},
						{name : '<spring:message code="lbl.precedProd2"/>' , data : ['', salesPlanAmt]},
						{name : '', data : [salesPlanAmt, ''], showInLegend: false}
					]
				});
				
				
				$.each(chart.series[5].data, function(i, point) {
					point.graphic.attr({opacity: 0, 'stroke-width': 0});
				});
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
				enabled: true
			},
			tooltip : {
				enabled : true
			},
			credits: {
				enabled: false
			},
			exporting : {
				enabled: false,
				buttons: {
					contextButton: {
		            	align: 'left',
						menuItems: ['printChart','downloadJPEG', 'downloadPDF']
					}
				}
			},
			plotOptions: {
				series: {
					maxPointWidth: 80
				},
				line: {
					dataLabels: { enabled: true },
					enableMouseTracking: true,
					/* marker: { enabled: false }, */
				},
				/* column: {
					stacking: 'normal',
					dataLabels: {
						enabled: true,
					},
				}, */
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
	
	// onload 
	$(document).ready(function() {
		monthChart.init();
	});

</script>

</head>
<body>
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="keywordpop" class="popupDv">
		<div class="popCont">
			<!-- chart -->
			<div id="cont_chart">
				<div class="col_3">
					<h4><spring:message code="lbl.chart" /> (<spring:message code="lbl.hMillion" />)</h4>
					<div style="height: 100%;width:100%" id="chart1" ></div>
				</div>
			</div>
			<div class="pop_btn">
				<a href="javascript:;" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
			</div>
		</div>
	</div>
</body>
</html>