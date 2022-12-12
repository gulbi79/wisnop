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
	
	</style>	
	
	<script type="text/javascript">

	var bsc = {

		init : function () {
			gfn_formLoad();
			fn_siteMap();
			this.search();
		},
	
		_siq	: "dashboard.bsc.",
		
		search : function (sqlFlag) {
			FORM_SEARCH = {};
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.sql = sqlFlag;
			FORM_SEARCH.tranData = 
				[
					{ outDs : "chart1" , _siq : bsc._siq + "chartBsc"} ,
					{ outDs : "chart2" , _siq : bsc._siq + "chart", lvl : 3 } ,
					{ outDs : "chart3" , _siq : bsc._siq + "chart", lvl : 7 } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					bsc.drawChart(data);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		drawChart : function (res) {
			
			gfn_setHighchartTheme();
			

			/**********************************
			* column chart Data 
			**********************************/
			
			
			var bscQt = [], bscCr = [], bscCl = [];
			var tQt, tCr, tCl;
			$.each(res.chart1, function(i, el) {
				if (el.BU_CD == 'QT') {
					bscQt.push(el.LAST_SCORE);
					bscQt.push(el.CUR_SCORE);
					tQt = el.TAGET_SCORE;
				} else if (el.BU_CD == 'CR') {
					bscCr.push(el.LAST_SCORE);
					bscCr.push(el.CUR_SCORE);
					tCr = el.TAGET_SCORE;
				} else if (el.BU_CD == 'CL') {
					bscCl.push(el.LAST_SCORE);
					bscCl.push(el.CUR_SCORE);
					tCl = el.TAGET_SCORE;
				}
			});
			this.bscChartGen('chart1', bscQt, tQt);
			this.bscChartGen('chart2', bscCr, tCr);
			this.bscChartGen('chart3', bscCl, tCl);
			
			var chartQt = [], chartCr = [], chartCl = [];
			var cateQt = [], cateCr = [], cateCl = [];
			
			var arQt = $.grep(res.chart2, function(v,n) {
				return v.BU_CD == 'QT';
			});
			
			var arCr = $.grep(res.chart2, function(v,n) {
				return v.BU_CD == 'CR';
			});
			
			var arCl = $.grep(res.chart2, function(v,n) {
				return v.BU_CD == 'CL';
			});
			
			$.each(arQt, function (i, el) {
				chartQt.push((el.TOT_BSC_VAL === undefined ? 0 : el.TOT_BSC_VAL));
				cateQt.push(el.DIV_NM);
			});
			$.each(arCr, function (i, el) {
				chartCr.push((el.TOT_BSC_VAL === undefined ? 0 : el.TOT_BSC_VAL));
				cateCr.push(el.DIV_NM);
			});
			$.each(arCl, function (i, el) {
				chartCl.push( (el.TOT_BSC_VAL === undefined ? 0 : el.TOT_BSC_VAL) );
				cateCl.push(el.DIV_NM);
			});
			
			var arSpiderCate = [
				"<spring:message code='lbl.quality'/>",
				"<spring:message code='lbl.salesProfit'/>",
				"<spring:message code='lbl.invRec'/>",
				"<spring:message code='lbl.snop'/>",
				"<spring:message code='lbl.inovation'/>",
				"<spring:message code='lbl.gwp'/>"
			];

			var spiQt = [], spiCr = [], spiCl = [];
			
			spiQt.push(Number(bsc.RD(res.chart3[0].QC_BSC_VAL, 0)));
			spiQt.push(Number(bsc.RD(res.chart3[0].SALES_BSC_VAL, 0)));
			spiQt.push(Number(bsc.RD(res.chart3[0].INV_BSC_VAL, 0)));
			spiQt.push(Number(bsc.RD(res.chart3[0].SNOP_BSC_VAL, 0)));
			spiQt.push(Number(bsc.RD(res.chart3[0].INVT_BSC_VAL, 0)));
			spiQt.push(Number(bsc.RD(res.chart3[0].GWP_BSC_VAL, 0)));
			
			spiCr.push(Number(bsc.RD(res.chart3[1].QC_BSC_VAL, 0)));
			spiCr.push(Number(bsc.RD(res.chart3[1].SALES_BSC_VAL, 0)));
			spiCr.push(Number(bsc.RD(res.chart3[1].INV_BSC_VAL, 0)));
			spiCr.push(Number(bsc.RD(res.chart3[1].SNOP_BSC_VAL, 0)));
			spiCr.push(Number(bsc.RD(res.chart3[1].INVT_BSC_VAL, 0)));
			spiCr.push(Number(bsc.RD(res.chart3[1].GWP_BSC_VAL, 0)));
			
			spiCl.push(Number(bsc.RD(res.chart3[2].QC_BSC_VAL, 0)));
			spiCl.push(Number(bsc.RD(res.chart3[2].SALES_BSC_VAL, 0)));
			spiCl.push(Number(bsc.RD(res.chart3[2].INV_BSC_VAL, 0)));
			spiCl.push(Number(bsc.RD(res.chart3[2].SNOP_BSC_VAL, 0)));
			spiCl.push(Number(bsc.RD(res.chart3[2].INVT_BSC_VAL, 0)));
			spiCl.push(Number(bsc.RD(res.chart3[2].GWP_BSC_VAL, 0)));
			
			this.chartGen('chart4', 'column', cateQt, chartQt);
			
			this.chartGen('chart5', 'column', cateCr, chartCr);
			
			this.chartGen('chart6', 'column', cateCl, chartCl);
			
			this.chartGen('chart7', 'line', arSpiderCate, spiQt, true);
			
			this.chartGen('chart8', 'line', arSpiderCate, spiCr, true);
			
			this.chartGen('chart9', 'line', arSpiderCate, spiCl, true);
			
		},
		
		RD : function (n, pos) {
			var digits = Math.pow(10, pos);

			var sign = 1;
			if (n < 0) {
				sign = -1;
			}
			n = n * sign;
			var num = Math.round(n * digits) / digits;
			num = num * sign;
			return num.toFixed(pos);
		},
		
		chartGen : function (chartId, type, arCarte, arData, isSpider) {

			Highcharts.theme.colors[0] = gv_cColor1; //초기화
			
			isSpider = isSpider || false;
			var chart = null;
			if (!isSpider) {
				chart = {
					chart  : { type : type},
					xAxis  : { categories : arCarte },
					tooltip : { enabled: true },
					series : [{
						colorByPoint: true,
						data : arData
					}],
				};
			} else {
				
				chart = {
					chart  : { polar : true, type : type/* , backgroundColor : '#FCFFC5' */ },
					pane   : { size : '90%' },
					xAxis  : { categories : arCarte, tickmarkPlacement : 'on', lineWidth : 0 },
					yAxis  : { gridLineInterpolation : 'polygon', lineWidth : 0, tickInterval: 50, min : 0 },
					series : [{
						data : arData,
						pointPlacement : 'on'
					}],
				};
			}
			
			Highcharts.chart(chartId, chart);
		},
		
		bscChartGen : function (chartId, arData, target) {

			Highcharts.theme.colors[0] = '#133485'; //line 적용
			
			var arCate = ['<spring:message code="lbl.lastMonth" />', '<spring:message code="lbl.thisMonth" />'];
			var chartTxt = $("#"+chartId).next();
			chartTxt.append('<p class="per_txt green_f"><strong>'+target+'</strong></p>');
			Highcharts.chart(chartId, {
				chart: { type: 'line' },
				xAxis: { categories: arCate },
				plotOptions: {
					line: {
						dataLabels: { 
							format: '{'+gv_cFormat+'}',
							style: {
								fontSize : "12px",
								fontWeight: ''
							}
						},
					}
				},
				series: [{
					data : arData
				}]
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
			/* yAxis: {
				min    : 0,
				labels : { enabled : false}, 
				title: { text: null },
				stackLabels: { enabled: false },
			}, */
			legend: {
				enabled : false
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
		
		//조회조건 설정
		/* FORM_SEARCH = {}
		FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
		FORM_SEARCH.sql = sqlFlag; */
		
		//메인 데이터를 조회
		bsc.search(sqlFlag);
	}
	
 	// onload 
	$(document).ready(function() {
		bsc.init();
	});
	

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
					<div class="col_3">
						<h4> <spring:message code="lbl.bscSummary" /> (<spring:message code="lbl.quartz"/>)</h4>
						<div class="graphwrap" id="chart1"></div>
						<div class="textwrap">
							<p><spring:message code="lbl.score" /></p>
						</div>
					</div>
					<div class="col_3" >
						<h4><spring:message code="lbl.bscSummary" /> (<spring:message code="lbl.ceramics"/>)</h4>
						<div class="graphwrap"  id="chart2" ></div>
						<div class="textwrap">
							<p><spring:message code="lbl.score" /></p>
						</div>
					</div>
					<div class="col_3">
						<h4><spring:message code="lbl.bscSummary" /> (<spring:message code="lbl.cleaning"/>)</h4>
						<div class="graphwrap"  id="chart3" ></div>
						<div class="textwrap">
							<p><spring:message code="lbl.score" /></p>
						</div>
					</div>
					<div class="col_3">
						<h4><spring:message code="lbl.quartz"/></h4>
						<div style="height: 100%" id="chart4"></div>
					</div>
					<div class="col_3">
						<h4><spring:message code="lbl.ceramics"/></h4>
						<div style="height: 100%" id="chart5"></div>
					</div>
					<div class="col_3">
						<h4><spring:message code="lbl.cleaning"/></h4>
						<div style="height: 100%" id="chart6"></div>
					</div>
					<div class="col_3">
						<!-- <h4>Aging Status</h4> -->
						<div style="height: 100%" id="chart7"></div>
					</div>
					<div class="col_3">
						<!-- <h4>달성률 (M+3)</h4> -->
						<div style="height: 100%" id="chart8"></div>
					</div>
					<div class="col_3">
						<!-- <h4>판매 적중률 (M)</h4> -->
						<div style="height: 100%" id="chart9"></div>
					</div>
				</div>
			</div>
			<div id="cont_chart3">
				<div id="cont_chart">
					<div class="col_3" style="height:100%;width:100%;margin: 0;padding:0">
						<div id="sitemappop" style="margin: 0; display:block; height:calc(100% - 30px);width:100%;">
							<div class="drag">
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
