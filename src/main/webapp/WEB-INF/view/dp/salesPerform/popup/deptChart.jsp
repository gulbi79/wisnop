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
	
	
	#cont_chart .col_3:nth-child(1) {margin:0 10px 10px 0;}
	#cont_chart .col_3:nth-child(2) {margin:0 0 10px 0;}
</style>

<script type="text/javascript">
	var deptChart = {
			init : function() {
				//this.comCode.initCode();
				this.initSearch();
				this.events();
			},
			
			_siq	: "dp.salesPerformNew.",
			
			events : function() {
				$("#btnClose").on("click", function(){
					window.close(); 
				});
				
				$(':radio[name=type1]').on('change', function () {
					deptChart.search(false);
				});
			},
			
			bucket : null,
			
			initSearch : function() {
				FORM_SEARCH          = {};
				FORM_SEARCH._mtd     = "getList";
				FORM_SEARCH.fromWeek = "${param.fromWeek}";
				FORM_SEARCH.toWeek   = "${param.toWeek}";
				FORM_SEARCH.grpCd    = "PTSP_DEPT";
				
				FORM_SEARCH.tranData = [
					{ outDs : "week"      , _siq : deptChart._siq + "chartBucket" },
					{ outDs : "ptspDept"  , _siq : "common.comCode" }
				];
				
				var sMap = {
					url	 : "${ctx}/biz/obj",
					data	: FORM_SEARCH,
					success : function(data) {
						
						deptChart.bucket = {};
						deptChart.bucket = data.week;
						
						var deptSelect = {
								callback  : function() {
									deptChart.search();
								}
						};
						
						// 콤보박스
						gfn_setMsComboAll([
							{target : 'divDept', id : 'dept', title : '', event: deptSelect, data : data.ptspDept, exData:[''], option: {allFlag:"Y", width:"200px"}}
						]);
						
						
						deptChart.search();
					}
				}
				gfn_service(sMap, "obj");
			},
			
			search : function(sqlFlag) {
				var type1    = $(':radio[name=type1]:checked').val();
				
				FORM_SEARCH              = {};
				FORM_SEARCH              = $("#searchForm").serializeObject();
				FORM_SEARCH.bucketList   = this.bucket;
				FORM_SEARCH._mtd         = "getList";
				FORM_SEARCH.sql          = sqlFlag;
				FORM_SEARCH.fromWeek     = "${param.fromWeek}";
				FORM_SEARCH.toWeek       = "${param.toWeek}";
				FORM_SEARCH.type1        = type1;
				FORM_SEARCH.tranData     = [
					{ outDs : "chart5" , _siq : deptChart._siq + "chart5" },
					{ outDs : "chart6" , _siq : deptChart._siq + "chart6" }
				]; 
				
				var sMap = {
					url	 : "${ctx}/biz/obj",
					data	: FORM_SEARCH,
					success : function(data) {
						deptChart.drawChart(data);
					}
				};
				gfn_service(sMap,"obj");
			},
			
			drawChart : function(res) {
				//테마적용 공통함수
		    	fn_setHighchartTheme();
				
		    	// cartegory
				var arWeek = new Array();
				
				$.each (deptChart.bucket, function (i, el) {
					arWeek.push(el.DISWEEK);
				});
				
				var chart5 = JSON.parse(res.chart5[0].STATUS_CHART);
				var chart6 = JSON.parse(res.chart6[0].STATUS_CHART);
				
				this.chartPie('chart5', chart5);
				this.chartGen('chart6', 'line', arWeek, chart6);
			},
			
			chartGen : function (chartId, type, arCarte, arData, isStack) {
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
						}
					},
				};
				
				if (!isStack) {
					delete chart.plotOptions.column.stacking;
				}
				
				Highcharts.chart(chartId, chart);
			},
			
			chartPie : function(chartId, arData) {
				
				var chartPie = Highcharts.chart(chartId, {
		    	    chart: {
		    	        plotBackgroundColor: null,
		    	        plotBorderWidth: null,
		    	        plotShadow: false,
		    	        type: 'pie'
		    	    },
		    	    tooltip: {
		    	        pointFormat: '<b>{point.percentage:.1f}%</b>'
		    	    },
		    	    plotOptions: {
		    	        pie: {
		    	            allowPointSelect: true,
		    	            cursor: 'pointer',
		    	            dataLabels: {
		    	                /*
		    	            	enabled: true,
		    	                format: '<b>{point.name}</b>: {point.percentage:.1f} %',
		    	                distance: -50,
		    	                filter: {
		    	                    property: 'percentage',
		    	                    operator: '>',
		    	                    value: 4
		    	                }
		    	                */
		    	                enabled : false
		    	            },
		    	            showInLegend: true
		    	        }
		    	    },
		    	    legend: {
		    	        align: 'right',
		    	        layout: 'vertical',
		    	        verticalAlign: 'top',
		    	        x: -200,
		    	        y: 30
		    	    },
		    	    series: [{name:"",data: arData}]
		    	    
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
				enabled: true,
				itemStyle : {
					color      : '#000',
					fontSize   : '11px',
					fontWeight : 'normal'
				}
			},
			tooltip : {
				enabled : true
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
					dataLabels: { enabled: true },
					enableMouseTracking: true,
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
	
	$(document).ready(function() {
		deptChart.init();
	});
	

</script>

</head>
<body>
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="keywordpop" class="popupDv">
		<div class="popCont">
			<!-- chart -->
			<div id="cont_chart">
				<div class="col_3" style="height: 300px;">
		           	<h4><spring:message code='lbl.dept'/>&nbsp;&nbsp;<spring:message code='lbl.pieChart'/></h4>
		           	<form id="searchForm" name="searchForm">
		        	<div class="view_combo" id="divDept" style="float: right; margin-right:88px;"></div>
		        	</form>
		            <div id="chart5" style="height:88%;"></div>
				</div>
		        <div class="col_3" style="height: 300px;">
		        	<h4><spring:message code='lbl.dept'/>&nbsp;&nbsp;<spring:message code='lbl.trendChart'/></h4>
		        	
		        	<div class="view_combo" style="float:right;">
           				<ul class="rdofl">
           					<li><input type="radio" id="type1_cnt" name="type1" value="cnt" checked="checked"> <label for="type1_cnt"><spring:message code="lbl.cnt"/></label></li>
                			<li><input type="radio" id="type1_rate" name="type1" value="rate" > <label for="type1_rate"><spring:message code="lbl.rate"/></label></li>
           				</ul>
           			</div>
		        	
		            <div id="chart6" style="height:88%;"></div>
		        </div>
			</div>
			<div class="pop_btn">
				<a href="javascript:;" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
			</div>
		</div>
	</div>
</body>
</html>