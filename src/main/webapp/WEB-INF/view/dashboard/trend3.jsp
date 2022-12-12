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
	
	var unit = 0;
	var trend3 = {

		init : function () {
			gfn_formLoad();
			fn_siteMap();
			
			this.initSearch();
			this.events();
			
			var userLang = "${sessionScope.GV_LANG}";
			
			if(userLang == "ko"){
	    		unit = 100000000;
	    	}else if(userLang == "en" || userLang == "cn"){
	    		unit = 1000000000;
	    	}
		},
	
		_siq	: "dashboard.snopTrend.",
		
		events : function () {
			$(':radio[name=wip]').on('change', function () {
				trend3.wipSearch(false);
			});
			
			$(':radio[name=wipRt]').on('change', function () {
				trend3.wipRtSearch(false);
			});
			
			$(':radio[name=agingTrend]').on('change', function () {
				trend3.aTrendSearch(false);
			});
			$(':radio[name=agingTrendCostSale]').on('change', function () {
				trend3.aTrendSearch(false);
			});
			$(':radio[name=agingTrendInv]').on('change', function () {
				trend3.aTrendSearch(false);
			});
			
			$(':radio[name=trend22]').on('change', function () {
				trend3.trend22Search(false);
			});
			
			$(':radio[name=chart24_type]').on('change', function () {
				trend3.chart24Search(false);
			});
			
			$(':radio[name=chart23Radio]').on('change', function () {
				trend3.chart23RadioSearch(false);
			});
			
			
			// 타이틀 클릭시 메뉴 이동
			var arrTitle = $("h4");
	    	
			$.each(arrTitle, function(n,v) {
	    		$(v).css("cursor", "pointer");
	    		$(v).on("click", function() { 
	    			if (n == 0) gfn_newTab("MP105");
	    			else if (n == 1) gfn_newTab("MP105");
	    			else if (n == 2) gfn_newTab("MP105");
	    			else if (n == 3) gfn_newTab("SNOP206");
	    			else if (n == 4) gfn_newTab("DP304");
	    			else if (n == 5) gfn_newTab("SNOP301");
	    		});
	    	});
		},
		
		bucket : null,
		
		initSearch : function (sqlFlag) {
			FORM_SEARCH = {}
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.tranData = [{ outDs : "week"  , _siq : trend3._siq + "trendBucketWeek" }
								  , { outDs : "month" , _siq : trend3._siq + "trendBucketMonth" }];
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					trend3.bucket = {};
					trend3.bucket.week  = data.week;
					trend3.bucket.month = data.month;
					
					trend3.search();
				}
			}
			gfn_service(sMap, "obj");
		},
		
		search : function (sqlFlag) {
			
			var agingTrendMeasCd = agingTrendCombo();
			
			FORM_SEARCH            = {};
			FORM_SEARCH            = this.bucket;
			FORM_SEARCH.wip        = $(':radio[name=wip]:checked').val();
			FORM_SEARCH.wipRt      = $(':radio[name=wipRt]:checked').val();
			FORM_SEARCH.agingTrendInv = $(':radio[name=agingTrendInv]:checked').val();
			FORM_SEARCH.agingTrendMeasCd = agingTrendMeasCd;
			FORM_SEARCH.chart24_type   = $(':radio[name=chart24_type]:checked').val();
			FORM_SEARCH.trend22    = $(':radio[name=trend22]:checked').val();
			FORM_SEARCH.chart23Radio   = $(':radio[name=chart23Radio]:checked').val();
			FORM_SEARCH._mtd       = "getList";
			FORM_SEARCH.sql        = sqlFlag;
			FORM_SEARCH.unit       = unit;
			FORM_SEARCH.tranData   = 
				[
					{ outDs : "chart19" , _siq : trend3._siq + "chart19" },
					{ outDs : "chart20" , _siq : trend3._siq + "chart20" },
					{ outDs : "chart21" , _siq : trend3._siq + "chart21" },
					{ outDs : "chart22" , _siq : trend3._siq + "chart22" }, 
					{ outDs : "chart23" , _siq : trend3._siq + "chart23" },
					{ outDs : "chart24" , _siq : trend3._siq + "chart24" }
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					trend3.drawChart(data);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		wipSearch : function(sqlFlag) {
			FORM_SEARCH = {};
			FORM_SEARCH = trend3.bucket;
			FORM_SEARCH.wip  = $(':radio[name=wip]:checked').val();
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.sql  = sqlFlag;
			FORM_SEARCH.tranData = 
				[
					{ outDs : "chart19" , _siq : trend3._siq + "chart19" } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arMonth = new Array();
					$.each (trend3.bucket.month, function (i, el) {
						arMonth.push(el.DISMONTH);
					});
					var chart19 = JSON.parse(data.chart19[0].WIP);

					trend3.chartGen('chart19', 'line', arMonth, chart19);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		wipRtSearch : function(sqlFlag) {
			FORM_SEARCH        = {};
			FORM_SEARCH        = trend3.bucket;
			FORM_SEARCH.wipRt  = $(':radio[name=wipRt]:checked').val();
			FORM_SEARCH._mtd   = "getList";
			FORM_SEARCH.sql    = sqlFlag;
			FORM_SEARCH.tranData = 
				[
					{ outDs : "chart20" , _siq : trend3._siq + "chart20" } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arPreMonth = new Array();
					$.each (trend3.bucket.month, function (i, el) {
						arPreMonth.push(el.PRE_DISMONTH);
					});
					var chart20 = JSON.parse(data.chart20[0].WIP_RT);

					trend3.chartGen('chart20', 'line', arPreMonth, chart20);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		
		trend22Search : function(sqlFlag) {
			FORM_SEARCH = {}
			FORM_SEARCH = trend3.bucket;
			FORM_SEARCH.trend22 = $(':radio[name=trend22]:checked').val();
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.sql  = sqlFlag;
			FORM_SEARCH.tranData = 
				[
					{ outDs : "chart21" , _siq : trend3._siq + "chart21" } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arMonth = new Array();
					$.each (trend3.bucket.month, function (i, el) {
						arMonth.push(el.DISMONTH);
					});
					
					var chart21  = JSON.parse(data.chart21[0].TREND22);

					trend3.chartGen('chart21', 'line', arMonth, chart21);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		aTrendSearch : function(sqlFlag) {
			
			var agingTrendMeasCd = agingTrendCombo();

			FORM_SEARCH = {}
			FORM_SEARCH = trend3.bucket;
			//FORM_SEARCH.agingTrend = $(':radio[name=agingTrend]:checked').val();
			FORM_SEARCH.agingTrendInv = $(':radio[name=agingTrendInv]:checked').val();
			FORM_SEARCH.agingTrendMeasCd = agingTrendMeasCd;
			
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.sql  = sqlFlag;
			FORM_SEARCH.tranData = 
				[
					{ outDs : "chart22" , _siq : trend3._siq + "chart22" } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					
					// cartegory
					var arPreMonth = new Array();
					$.each (trend3.bucket.month, function (i, el) {
						arPreMonth.push(el.PRE_DISMONTH);
					});
					
					var chart22  = JSON.parse(data.chart22[0].AGING_TREND);

					trend3.chartGen('chart22', 'line', arPreMonth, chart22);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		chart24Search : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = trend3.bucket;
			FORM_SEARCH.chart24_type   = $(':radio[name=chart24_type]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = 
				[
					{ outDs : "chart24" , _siq : trend3._siq + "chart24" } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arMonth = new Array();
			
					$.each (trend3.bucket.month, function (i, el) {
						arMonth.push(el.DISMONTH);
					});
					var chart24 = JSON.parse(data.chart24[0].SALES);

					trend3.chartGen('chart24', 'line', arMonth, chart24);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		chart23RadioSearch : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = trend3.bucket;
			FORM_SEARCH.chart23Radio   = $(':radio[name=chart23Radio]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "chart23" , _siq : trend3._siq + "chart23" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					
					var arMonth = new Array();
			
					$.each (trend3.bucket.month, function (i, el) {
						arMonth.push(el.DISMONTH);
					});
					var chart23 = JSON.parse(data.chart23[0].TREND23);
					trend3.chartGen('chart23', 'line', arMonth, chart23);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		drawChart : function (res) {
			
			fn_setHighchartTheme();
			
			// cartegory
			var arPreWeek  = new Array();
			var arWeek     = new Array();
			var arMonth    = new Array();
			var arPreMonth = new Array();
			
			$.each (trend3.bucket.month, function (i, el) {
				arMonth.push(el.DISMONTH);
				arPreMonth.push(el.PRE_DISMONTH);
			});
			
			$.each (trend3.bucket.week, function (i, el) {
				arWeek.push(el.DISWEEK);
				arPreWeek.push(el.PRE_DISWEEK);
			});
			
			var chart19 = JSON.parse(res.chart19[0].WIP);
			var chart20 = JSON.parse(res.chart20[0].WIP_RT);
			var chart21 = JSON.parse(res.chart21[0].TREND22);
			var chart22 = JSON.parse(res.chart22[0].AGING_TREND);
			var chart23 = JSON.parse(res.chart23[0].TREND23);
			var chart24 = JSON.parse(res.chart24[0].SALES);
			
			this.chartGen('chart19', 'line', arMonth, chart19);
			this.chartGen('chart20', 'line', arPreMonth, chart20);
			this.chartGen('chart21', 'line', arMonth, chart21);
			this.chartGen('chart22', 'line', arPreMonth, chart22);
			this.chartGen('chart23', 'line', arMonth, chart23);
			this.chartGen('chart24', 'line', arMonth , chart24);
		},
		
		chartGen : function (chartId, type, arCarte, arData) {
			
			var chart = {
				chart  : { type : type },
				xAxis  : { categories : arCarte },
				series : arData,
				plotOptions: {
					series: {
						events: {
							afterAnimate : function(e){
			        			var chartLen = this.chart.series.length;
			        			var chart23RadioData = $(':radio[name=chart23Radio]:checked').val();
			        			
			        			if(chartId == "chart23" && chart23RadioData == "cust")	{
			        				for(var i = 0; i < chartLen; i++){
			        					
			        					var chartCode = this.chart.series[i].userOptions.code;
			        					
			        					if(chartCode != "RCG001"){
			        						this.chart.series[i].hide();	
			        					}
			        				}
			        			}
			        		}
						},
						
						cursor: 'pointer',
						point: {
							events: {
								click: function() {
									if(chartId == "chart19") {
										gfn_comPopupOpen("POPUP_CHART", {
											rootUrl   : "dashboard",
											url       : "popup_chart",
											width     : 1920,
											height    : 1060,
											menuCd    : "SNOP100",
											chartId   : "chart19",
											title     : "<spring:message code='lbl.wipTrend' /> (<spring:message code='lbl.hMillion' />)"
										});		
									} else if(chartId == "chart20") {
										gfn_comPopupOpen("POPUP_CHART", {
											rootUrl   : "dashboard",
											url       : "popup_chart",
											width     : 1920,
											height    : 1060,
											menuCd    : "SNOP100",
											chartId   : "chart20",
											title     : "<spring:message code='lbl.wipRt' /> (%)"
										});		
									} else if(chartId == "chart21") {
										gfn_comPopupOpen("POPUP_CHART", {
											rootUrl   : "dashboard",
											url       : "popup_chart",
											width     : 1920,
											height    : 1060,
											menuCd    : "SNOP100",
											chartId   : "chart21",
											title     : "<spring:message code='lbl.trend22Chart' /> (<spring:message code='lbl.hMillion' />)"
										});	
									} else if(chartId == "chart22") {
										gfn_comPopupOpen("POPUP_CHART", {
											rootUrl   : "dashboard",
											url       : "popup_chart",
											width     : 1920,
											height    : 1060,
											menuCd    : "SNOP100",
											chartId   : "chart22",
											title     : "<spring:message code='lbl.agingTrend' /> (<spring:message code='lbl.hMillion' />)"
										});	
									} else if(chartId == "chart23") {
										gfn_comPopupOpen("POPUP_CHART", {
											rootUrl   : "dashboard",
											url       : "popup_chart",
											width     : 1920,
											height    : 1060,
											menuCd    : "SNOP100",
											chartId   : "chart23",
											title     : "<spring:message code='lbl.trend23Chart' /> (<spring:message code='lbl.hMillion' />)"
										});	
									} else if(chartId == "chart24") {
										gfn_comPopupOpen("POPUP_CHART", {
											rootUrl   : "dashboard",
											url       : "popup_chart",
											width     : 1920,
											height    : 1060,
											menuCd    : "SNOP100",
											chartId   : "chart24",
											title     : "<spring:message code='lbl.chart24' /> (<spring:message code='lbl.hMillion' />)"
										});	
									}
								}
							}
						}
					}
				}
			};
			Highcharts.chart(chartId, chart);
			
			//하이차트 버전 업 후 가려지는 현상 
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
		//FORM_SEARCH = {}
		//FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
		//FORM_SEARCH.sql = sqlFlag;
		
		//메인 데이터를 조회
		//fn_getChartData();
		
		trend3.search(sqlFlag);
	}
	
 	// onload 
	$(document).ready(function() {
		trend3.init();
	});
 	
	function agingTrendCombo(){
		
		var agingTrend = $(':radio[name=agingTrend]:checked').val();  //개월 
		var agingTrendCostSale = $(':radio[name=agingTrendCostSale]:checked').val(); //원가,판가
		var agingTrendmeasCd = "";
		
		if(agingTrendCostSale == "cost" && agingTrend == "M3"){ //원가,3개월 :MEAS_CD = 'OVER_M3_AMT_COST' AND ITEM_TYPE별
			agingTrendmeasCd = "OVER_M3_AMT_COST";
		}
		if(agingTrendCostSale == "cost" && agingTrend == "M6"){ //원가,6개월 :MEAS_CD = 'OVER_M6_AMT_COST' AND ITEM_TYPE별
			agingTrendmeasCd = "OVER_M6_AMT_COST";
		}
		if(agingTrendCostSale == "cost" && agingTrend == "Y1"){ //원가,1년 :MEAS_CD = 'OVER_Y1_AMT_COST' AND ITEM_TYPE별
			agingTrendmeasCd = "OVER_Y1_AMT_COST";
		}
		if(agingTrendCostSale == "cost_sale" && agingTrend == "M3"){ //판가,3개월 :MEAS_CD = 'OVER_M3_AMT_PRICE' AND ITEM_TYPE별
			agingTrendmeasCd = "OVER_M3_AMT_PRICE";
		}
		if(agingTrendCostSale == "cost_sale" && agingTrend == "M6"){ //판가,6개월 :MEAS_CD = 'OVER_M6_AMT_PRICE' AND ITEM_TYPE별
			agingTrendmeasCd = "OVER_M6_AMT_PRICE";
		}
		if(agingTrendCostSale == "cost_sale" && agingTrend == "Y1"){ //판가,1년 :MEAS_CD = 'OVER_Y1_AMT_PRICE' AND ITEM_TYPE별
			agingTrendmeasCd = "OVER_Y1_AMT_PRICE";
		}
		
		return agingTrendmeasCd;
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
					<div class="col_3">
						<h4><spring:message code="lbl.wipTrend" /> (<spring:message code="lbl.hMillion" />)</h4>
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="wip1" name="wip" value="item"/> <label for="wip1"><spring:message code="lbl.part" /></label></li>
								<li><input type="radio" id="wip2" name="wip" value="total" checked="checked"/> <label for="wip2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart19" ></div>
					</div>
					
					<div class="col_3">
						<h4><spring:message code="lbl.wipRt" /> (%)</h4>
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="wipRt1" name="wipRt" value="item"/> <label for="wipRt1"><spring:message code="lbl.part" /></label></li>
								<li><input type="radio" id="wipRt2" name="wipRt" value="total" checked="checked"/> <label for="wipRt2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart20"></div>
					</div>
					
					<div class="col_3">
						<h4><spring:message code="lbl.trend22Chart" /> (<spring:message code="lbl.hMillion" />)</h4>
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="trend22_m2" name="trend22" value="M2" checked="checked"/> <label for="trend22_m2"><spring:message code="lbl.2mMore" /></label></li>
								<li><input type="radio" id="trend22_m6" name="trend22" value="M6"/> <label for="trend22_m6"><spring:message code="lbl.6mMore" /></label></li>
								<li><input type="radio" id="trend22_y1" name="trend22" value="Y1"/> <label for="trend22_y1"><spring:message code="lbl.yearOneMore" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart21"></div>
					</div>
					
					<div class="col_3">
						<h4><spring:message code="lbl.agingTrend" /> (<spring:message code="lbl.hMillion" />)</h4>
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="agingTrend_cost" name="agingTrendCostSale" value="cost" checked="checked"/> <label for="agingTrend_cost"><spring:message code="lbl.costChart" /></label></li>
								<li><input type="radio" id="agingTrend_sale" name="agingTrendCostSale" value="cost_sale"/> <label for="agingTrend_sale"><spring:message code="lbl.amtChart" /></label></li>
								<li><input type="radio" id="agingTrend_inv1" name="agingTrendInv" value="item"/> <label for="agingTrend_inv1"><spring:message code="lbl.itemType" /></label></li>
								<li><input type="radio" id="agingTrend_inv2" name="agingTrendInv" value="procure"/> <label for="agingTrend_inv2"><spring:message code="lbl.procureType" /></label></li>
								<li><input type="radio" id="agingTrend_inv3" name="agingTrendInv" value="total" checked="checked"/> <label for="agingTrend_inv3"><spring:message code="lbl.total" /> </label></li>
								<li><input type="radio" id="agingTrend1" name="agingTrend" value="M3"/> <label for="agingTrend1"><spring:message code="lbl.3mMore" /></label></li>
								<li><input type="radio" id="agingTrend2" name="agingTrend" value="M6"/> <label for="agingTrend2"><spring:message code="lbl.6mMore" /></label></li>
								<li><input type="radio" id="agingTrend3" name="agingTrend" value="Y1" checked="checked"/> <label for="agingTrend3"><spring:message code="lbl.yearOneMore" /> </label></li>
							</ul>
						</div>
						<div style="height: 80%" id="chart22"></div>
					</div>
					<div class="col_3">
						<h4><spring:message code="lbl.trend23Chart" /> (<spring:message code="lbl.hMillion" />)</h4>
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="chart23Cust" name="chart23Radio" value="cust" checked="checked"/> <label for="chart23Cust"><spring:message code="lbl.reptCust" /></label></li>
								<li><input type="radio" id="chart23Prod" name="chart23Radio" value="prod" /> <label for="chart23Prod"><spring:message code="lbl.prodCate" /></label></li>
								<li><input type="radio" id="chart23Tot" name="chart23Radio" value="total"/> <label for="chart23Tot"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart23"></div>
					</div>
					
					<div class="col_3">
						<h4><spring:message code="lbl.chart24" /> (<spring:message code="lbl.hMillion" />)</h4>
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="chart24_type1" name="chart24_type" value="cust"/> <label for="chart24_type1"><spring:message code="lbl.reptCust" /></label></li>
								<li><input type="radio" id="chart24_type2" name="chart24_type" value="total" checked="checked"/> <label for="chart24_type2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart24"></div>
					</div>
					<div class="col_3" style="display:none;">
						<h4></h4>
						<div style="height: 100%" id="chart25"></div>
					</div>
					<div class="col_3" style="display:none;">
						<h4></h4>
						<div style="height: 100%" id="chart26"></div>
					</div>
					<div class="col_3" style="display:none;">
						<h4></h4>
						<div style="height: 100%" id="chart27"></div>
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
