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

	/* #container { margin: 0;width: calc(100% - 250px);height: 100%;padding: 0; }
	#cont_chart { width: 100%;height: 100%;}
	
	#cont_chart .col_3 { margin:0; width:calc((100% - 20px) / 3) ; height:calc((100% - 20px) / 3); }
	#cont_chart .col_3:nth-child(1) {margin:0 10px 10px 0;}
	#cont_chart .col_3:nth-child(2) {margin:0 10px 10px 0;}
	#cont_chart .col_3:nth-child(3) {margin:0 0 10px 0;}
	#cont_chart .col_3:nth-child(4) {margin:0 10px 10px 0;}
	#cont_chart .col_3:nth-child(5) {margin:0 10px 10px 0;}
	#cont_chart .col_3:nth-child(6) {margin:0 0 10px 0;}
	#cont_chart .col_3:nth-child(7) {margin:0 10px 0 0;}
	#cont_chart .col_3:nth-child(8) {margin:0 10px 0 0;}
	
	#cont_chart .col_3 .textwrap { padding : 10px 0 0 0; }
	
	#cont_chart .col_3_tmp h4 { margin-bottom: 10px; }
	
	#cont_chart3 {
		height: 100%;
		width: 240px;
		float: left;
		margin-left: 10px;
	}
	  */
</style>

<script type="text/javascript">

var planSalesChart = {

		init : function () {
			
			this.initSearch();
			this.events();
		},
	
		_siq	: "dp.salesPerformNew.",
		
		events : function () {
			
			$("#btnClose").on("click", function(){
				window.close(); 
			});;
		},
		
		bucket : null,
		
		initSearch : function () {
			FORM_SEARCH = {}
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.fromWeek = "${param.fromWeek}";
			FORM_SEARCH.toWeek = "${param.toWeek}";
			//FORM_SEARCH.ptspType = "${param.ptspType}";
			FORM_SEARCH.tranData = [{ outDs : "week", _siq : planSalesChart._siq + "chartBucket" }
			                      , { outDs : "repCustGroup", _siq : planSalesChart._siq + "chartRepCustGroup" }];
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					
					var temp = "";
					var radioChk = "";
					
					planSalesChart.bucket = {};
					planSalesChart.bucket = data.week;
					
					$.each(data.repCustGroup, function(n, v){
						if(n == 0){
							radioChk = v.CD;
						}
						temp += "<li><input type=\"radio\" id=\"key"+ n +"\" name=\"key\" value=\""+ v.CD +"\" > <label for=\"key"+ n +"\">"+ v.NM +"</label></li>";
					});
					$("#radioSelect").html(temp);
					$(':radio[name=key]:input[value="'+ radioChk +'"]').attr("checked", true);
					
					$(':radio[name=key]').on('change', function () {
						planSalesChart.search(false);
					});
					
					$(':radio[name=type1]').on('change', function () {
						planSalesChart.search(false);
					});
					
					planSalesChart.search();
				}
			}
			gfn_service(sMap, "obj");
		},
		
		search : function (sqlFlag) {
			var type1    = $(':radio[name=type1]:checked').val();
			
			FORM_SEARCH = {}
			FORM_SEARCH.bucketList = this.bucket;
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.sql = sqlFlag;
			FORM_SEARCH.fromWeek = "${param.fromWeek}";
			FORM_SEARCH.toWeek = "${param.toWeek}";
			//FORM_SEARCH.ptspType = "${param.ptspType}";
			FORM_SEARCH.repCustGroup = $("input[type=radio][name=key]:checked").val();
			FORM_SEARCH.type1        = type1;

			FORM_SEARCH.tranData = 
				[
					{ outDs : "chart" , _siq : planSalesChart._siq + "chart7" }
			
				];
			
			
			//console.log("FORM_SEARCH : ", FORM_SEARCH);
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					
					planSalesChart.drawChart(data);
				}
			};
			gfn_service(sMap,"obj");
		},
		
		drawChart : function (res) {
			
			fn_setHighchartTheme();
			
			// cartegory
			var arWeek = new Array();
			
			$.each (planSalesChart.bucket, function (i, el) {
				arWeek.push(el.DISWEEK);
			});
			
			var defect = JSON.parse(res.chart[0].STATUS_CHART);
			
			//this.tagetStyle(defect);
			
			this.chartGen('chart0', 'line', arWeek, defect);
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
			
			if (chartId == 'chart0') {
				Highcharts.theme.colors[1] = gv_cColor5;
				Highcharts.theme.colors[2] = gv_cColor3;
				Highcharts.theme.colors[3] = gv_cColor4;
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
	
	//조회
	function fn_apply(sqlFlag) {
		
		//조회조건 설정
		//FORM_SEARCH = {}
		//FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
		//FORM_SEARCH.sql = sqlFlag;
		
		//메인 데이터를 조회
		//fn_getChartData();
		planSalesChart.search(sqlFlag);
	}
	
 	// onload 
	$(document).ready(function() {
		planSalesChart.init();
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
					<h4><spring:message code="lbl.chart" /> </h4>
					<div class="view_combo" style="margin-left: 450px;">
           				<ul class="rdofl">
           					<li><input type="radio" id="type1_cnt" name="type1" value="cnt" checked="checked"> <label for="type1_cnt"><spring:message code="lbl.cnt"/></label></li>
                			<li><input type="radio" id="type1_rate" name="type1" value="rate" > <label for="type1_rate"><spring:message code="lbl.rate"/></label></li>
           				</ul>
           			</div>
					<div class="view_combo" style="float: right;">
						<ul class="rdofl" id="radioSelect">
						</ul>
						<%-- <ul class="rdofl">
							<li><input type="radio" id="key2" name="key" value="key" > <label for="key2"><spring:message code="lbl.keyProd" /></label></li>
							<li><input type="radio" id="key1" name="key" value="total" checked="checked"> <label for="key1"><spring:message code="lbl.total" /> </label></li>
						</ul> --%>
					</div>
					<div style="height: 88%;width:100%" id="chart0" ></div>
				</div>
			</div>
			<div class="pop_btn">
				<a href="javascript:;" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
			</div>
		</div>
	</div>
</body>
</html>