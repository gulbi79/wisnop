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
	var trend1 = {

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
			$(':radio[name=profit]').on('change', function () {
				trend1.profitSearch(false);
			});
			
			$(':radio[name=chart2_type]').on('change', function () {
				trend1.chart2Search(false);
			});
			
			$(':radio[name=prod]').on('change', function () {
				trend1.prodSearch(false);
			});
			
			$(':radio[name=agingTrend]').on('change', function () {
				trend1.agingTrendSearch(false);
			});
			
			$(':radio[name=key]').on('change', function () {
				trend1.defactSearch(false);
			});
			
			$(':radio[name=inv]').on('change', function () {
				trend1.invSearch(false);
			});
			
			$(':radio[name=inv_type]').on('change', function () {
				trend1.invSearch(false);
			});
			
			$(':radio[name=inv_weekMonth_type]').on('change', function () {
				trend1.invSearch(false);
			});
			
			$(':radio[name=trend5]').on('change', function () {
				var str = '<spring:message code="lbl.pitChart" /> (<spring:message code="lbl.hMillion" />, <spring:message code="lbl.dayChart" />)';
				
				if($(this).val() == "amt") {
					str = '<spring:message code="lbl.pitChart" /> (<spring:message code="lbl.hMillion" />)';
				}
				
				$("#chart8_title").html(str);
				
				trend1.trend5Search(false);
			});
			
			$(':radio[name=trend5_type]').on('change', function () {
				var str = '<spring:message code="lbl.pitChart" /> (<spring:message code="lbl.hMillion" />, <spring:message code="lbl.dayChart" />)';
				
				if($(this).val() == "amt") {
					str = '<spring:message code="lbl.pitChart" /> (<spring:message code="lbl.hMillion" />)';
				}
				
				$("#chart8_title").html(str);
				
				trend1.trend5Search(false);
			});
			
			$(':radio[name=companyCons]').on('change', function () {
				var str = '<spring:message code="lbl.pitChart" /> (<spring:message code="lbl.hMillion" />, <spring:message code="lbl.dayChart" />)';
				
				if($(this).val() == "amt") {
					str = '<spring:message code="lbl.pitChart" /> (<spring:message code="lbl.hMillion" />)';
				}
				
				$("#chart8_title").html(str);
				
				trend1.trend5Search(false);
			});
			
			$(':radio[name=trend5_weekMonth_type]').on('change', function () {
				var str = '<spring:message code="lbl.pitChart" /> (<spring:message code="lbl.hMillion" />, <spring:message code="lbl.dayChart" />)';
				
				if($(this).val() == "amt") {
					str = '<spring:message code="lbl.pitChart" /> (<spring:message code="lbl.hMillion" />)';
				}
				
				$("#chart8_title").html(str);
				
				trend1.trend5Search(false);
			});
			
			// 타이틀 클릭시 메뉴 이동
			var arrTitle = $("h4");
	    	
			$.each(arrTitle, function(n,v) {
	    		$(v).css("cursor", "pointer");
	    		$(v).on("click", function() { 
	    			if (n == 0) gfn_newTab("SNOP207");
	    			else if (n == 1) gfn_newTab("SNOP207");
	    			else if (n == 2) gfn_newTab("QT102");
	    			else if (n == 3) gfn_newTab("MP101");
	    			else if (n == 4) gfn_newTab("MP102");
	    			else if (n == 5) gfn_newTab("QT101");
	    			else if (n == 6) gfn_newTab("SNOP205");
	    			else if (n == 7) gfn_newTab("SNOP205");
	    			else if (n == 8) gfn_newTab("MP101");
	    		});
	    	});
			
		},
		
		bucket : null,
		
		initSearch : function () {
			FORM_SEARCH = {}
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.tranData = [{ outDs : "week"  , _siq : trend1._siq + "trendBucketWeek" }
								  , { outDs : "month" , _siq : trend1._siq + "trendBucketMonth" }];
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					trend1.bucket = {};
					trend1.bucket.week  = data.week;
					trend1.bucket.month = data.month;
					
					trend1.search();
				}
			}
			gfn_service(sMap, "obj");
		},
		
		search : function (sqlFlag) {
			
			FORM_SEARCH            = {};
			FORM_SEARCH            = this.bucket;
			FORM_SEARCH.profit     = $(':radio[name=profit]:checked').val();
			FORM_SEARCH.chart2_type = $(':radio[name=chart2_type]:checked').val();
			FORM_SEARCH.prod       = $(':radio[name=prod]:checked').val();
			FORM_SEARCH.agingTrend = $(':radio[name=agingTrend]:checked').val();
			FORM_SEARCH.key        = $(':radio[name=key]:checked').val();
			FORM_SEARCH.inv        = $(':radio[name=inv]:checked').val();
			FORM_SEARCH.inv_type = $(':radio[name=inv_type]:checked').val();
			FORM_SEARCH.inv_weekMonth_type = $(':radio[name=inv_weekMonth_type]:checked').val();
			FORM_SEARCH.trend5     = $(':radio[name=trend5]:checked').val();
			FORM_SEARCH.trend5_type = $(':radio[name=trend5_type]:checked').val();
			FORM_SEARCH.companyCons = $(':radio[name=companyCons]:checked').val();
			FORM_SEARCH.trend5_weekMonth_type = $(':radio[name=trend5_weekMonth_type]:checked').val();
			FORM_SEARCH._mtd       = "getList";
			FORM_SEARCH.sql        = sqlFlag;
			FORM_SEARCH.unit       = unit;
			
			FORM_SEARCH.tranData   = 
				[
					{ outDs : "chart1" , _siq : trend1._siq + "chart1" } ,
					{ outDs : "chart2" , _siq : trend1._siq + "chart2" } ,
					{ outDs : "chart3" , _siq : trend1._siq + "chart3" } ,
					{ outDs : "chart4" , _siq : trend1._siq + "chart4" } ,
					{ outDs : "chart5" , _siq : trend1._siq + "chart5" } ,
					{ outDs : "chart6" , _siq : trend1._siq + "chart6" } ,
					{ outDs : "chart7" , _siq : trend1._siq + "chart7" } ,
					{ outDs : "chart8" , _siq : trend1._siq + "chart8" } ,
					{ outDs : "chart9" , _siq : trend1._siq + "chart9" } ,
			
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					trend1.drawChart(data);
				}
			};
			gfn_service(sMap,"obj");
		},
		
		profitSearch : function (sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = trend1.bucket;
			FORM_SEARCH.profit   = $(':radio[name=profit]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = 
				[
					{ outDs : "chart1" , _siq : trend1._siq + "chart1" } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arMonth = new Array();
			
					$.each (trend1.bucket.month, function (i, el) {
						arMonth.push(el.DISMONTH);
					});
					var chart1 = JSON.parse(data.chart1[0].PROFIT_TREND);

					trend1.chartGen('chart1', 'line', arMonth, chart1);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		chart2Search : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = trend1.bucket;
			FORM_SEARCH.chart2_type   = $(':radio[name=chart2_type]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = 
				[
					{ outDs : "chart2" , _siq : trend1._siq + "chart2" } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arPreMonth = new Array();
					var arMonth = new Array();
			
					$.each (trend1.bucket.month, function (i, el) {
						arMonth.push(el.DISMONTH);
						arPreMonth.push(el.PRE_DISMONTH);
					});
					var chart2 = JSON.parse(data.chart2[0].CUST);

					trend1.chartGen('chart2', 'line', arMonth, chart2);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		prodSearch : function (sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = trend1.bucket;
			FORM_SEARCH.prod     = $(':radio[name=prod]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = 
				[
					{ outDs : "chart4" , _siq : trend1._siq + "chart4" } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arPreMonth = new Array();
					var arMonth = new Array();
			
					$.each (trend1.bucket.month, function (i, el) {
						arPreMonth.push(el.PRE_DISMONTH);
						arMonth.push(el.DISMONTH);
					});
					var chart4 = JSON.parse(data.chart4[0].PROD_TREND);

					trend1.chartGen('chart4', 'line', arMonth, chart4);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		agingTrendSearch : function(sqlFlag) {
			FORM_SEARCH            = {};
			FORM_SEARCH            = trend1.bucket;
			FORM_SEARCH.agingTrend = $(':radio[name=agingTrend]:checked').val();
			FORM_SEARCH._mtd       = "getList";
			FORM_SEARCH.sql        = sqlFlag;
			FORM_SEARCH.tranData   = 
				[
					{ outDs : "chart5" , _siq : trend1._siq + "chart5" } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arPreMonth = new Array();
					var arMonth = new Array();
			
					$.each (trend1.bucket.month, function (i, el) {
						arPreMonth.push(el.PRE_DISMONTH);
						arMonth.push(el.DISMONTH);
					});
					
					var chart5 = JSON.parse(data.chart5[0].CAPA);

					trend1.chartGen('chart5', 'line', arMonth, chart5); 
				}
			}
			gfn_service(sMap,"obj");
		},
		
		defactSearch : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = trend1.bucket;
			FORM_SEARCH.key      = $(':radio[name=key]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = 
				[
					{ outDs : "chart6" , _siq : trend1._siq + "chart6" } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arPreMonth = new Array();
					var arMonth = new Array();
			
					$.each (trend1.bucket.month, function (i, el) {
						arPreMonth.push(el.PRE_DISMONTH);
						arMonth.push(el.DISMONTH);
					});
					
					var chart6 = JSON.parse(data.chart6[0].DEFECT);
					trend1.tagetStyle(chart6);
					trend1.chartGen('chart6', 'line', arMonth, chart6);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		invSearch : function (sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = trend1.bucket;
			FORM_SEARCH.inv      = $(':radio[name=inv]:checked').val();
			FORM_SEARCH.inv_type = $(':radio[name=inv_type]:checked').val();
			FORM_SEARCH.inv_weekMonth_type = $(':radio[name=inv_weekMonth_type]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = 
				[
					{ outDs : "chart7" , _siq : trend1._siq + "chart7" } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					
					var arPreCate = new Array();
					var chart7 = JSON.parse(data.chart7[0].INVENTORY);
					
					if(FORM_SEARCH.inv_weekMonth_type == "WEEK"){
						$.each (trend1.bucket.week, function (i, el) {
							arPreCate.push(el.DISWEEK);
						});
					}else{
						$.each (trend1.bucket.month, function (i, el) {
							arPreCate.push(el.DISMONTH);
						});
					}
					trend1.chartGen('chart7', 'line', arPreCate, chart7);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		trend5Search : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = trend1.bucket;
			FORM_SEARCH.trend5   = $(':radio[name=trend5]:checked').val();
			FORM_SEARCH.trend5_type = $(':radio[name=trend5_type]:checked').val();
			FORM_SEARCH.companyCons = $(':radio[name=companyCons]:checked').val();
			FORM_SEARCH.trend5_weekMonth_type = $(':radio[name=trend5_weekMonth_type]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = 
				[
					{ outDs : "chart8" , _siq : trend1._siq + "chart8" } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arPreCate = new Array();
					var chart8 = JSON.parse(data.chart8[0].ITEM_INV);

					if(FORM_SEARCH.trend5_weekMonth_type == "WEEK"){
						$.each (trend1.bucket.week, function (i, el) {
							arPreCate.push(el.DISWEEK);
						});
					}else{
						$.each (trend1.bucket.month, function (i, el) {
							arPreCate.push(el.DISMONTH);
						});
					}

					trend1.chartGen('chart8', 'line', arPreCate, chart8);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		
		drawChart : function (res) {
			
			fn_setHighchartTheme();
			
			// cartegory
			var arPreWeek = new Array();
			var arWeek = new Array();
			var arPreMonth = new Array();
			var arMonth = new Array();
			
			$.each (trend1.bucket.month, function (i, el) {
				arMonth.push(el.DISMONTH);
				arPreMonth.push(el.PRE_DISMONTH);
			});
			
			$.each (trend1.bucket.week, function (i, el) {
				arWeek.push(el.DISWEEK);
				arPreWeek.push(el.PRE_DISWEEK);
			});
			
			var chart1 = JSON.parse(res.chart1[0].PROFIT_TREND);
			var chart2 = JSON.parse(res.chart2[0].CUST);
			var chart3 = JSON.parse(res.chart3[0].CLAIM);
			var chart4 = JSON.parse(res.chart4[0].PROD_TREND);
			var chart5 = JSON.parse(res.chart5[0].CAPA);
			var chart6 = JSON.parse(res.chart6[0].DEFECT);
			var chart7 = JSON.parse(res.chart7[0].INVENTORY);
			var chart8 = JSON.parse(res.chart8[0].ITEM_INV);
			var chart9 = JSON.parse(res.chart9[0].CAPA);
			
			this.tagetStyle(chart3);
			this.tagetStyle(chart6);
			
			this.chartGen('chart1', 'line', arMonth, chart1);
			this.chartGen('chart2', 'line', arMonth, chart2);
			this.chartGen('chart3', 'line', arMonth, chart3);
			this.chartGen('chart4', 'line', arMonth, chart4);
			this.chartGen('chart5', 'line', arMonth, chart5);
			this.chartGen('chart6', 'line', arMonth, chart6);
			this.chartGen('chart7', 'line', arWeek, chart7);
			this.chartGen('chart8', 'line', arWeek, chart8);
			this.chartGen('chart9', 'line', arMonth, chart9);
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
							style : {
								fontSize : "12px",
								fontWeight: ''
							}
						},
					},
					series: {
						events: {
							afterAnimate : function(e){
			        			var chartLen = this.chart.series.length;
			        			
			        			if(chartId == "chart8")	{
			        				for(var i = 0; i < chartLen; i++){
			        					
			        					var chartCode = this.chart.series[i].userOptions.code;
			        					
			        					if(chartCode != "RCG001"){
			        						this.chart.series[i].hide();	
			        					}
			        				}
			        			}else if(chartId == "chart9") {
									for(var i = 0; i < chartLen; i++){
			        					
			        					var chartCode = this.chart.series[i].userOptions.code;
			        					
			        					if(chartCode != "1BLB"){
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
				                	if(chartId == "chart1")	{
				        				gfn_comPopupOpen("POPUP_CHART", {
				        					rootUrl   : "dashboard",
				        					url       : "popup_chart",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : "chart1",
				        					title     : "<spring:message code='lbl.salesTrend' /> (<spring:message code='lbl.hMillion' />)"
				        				});
				                	} else if(chartId == "chart2")	{
				                		gfn_comPopupOpen("POPUP_CHART", {
				        					rootUrl   : "dashboard",
				        					url       : "popup_chart",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : "chart2",
				        					title     : "<spring:message code='lbl.custSalesTrend' /> (<spring:message code='lbl.hMillion' />)"
				        				});
				                	} else if(chartId == "chart3")	{
				                		gfn_comPopupOpen("POPUP_CHART", {
				        					rootUrl   : "dashboard",
				        					url       : "popup_chart",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : "chart3",
				        					title     : "<spring:message code='lbl.claimChart2' />"
				        				});
				                	} else if(chartId == "chart4")	{
				                		gfn_comPopupOpen("POPUP_CHART", {
				        					rootUrl   : "dashboard",
				        					url       : "popup_chart",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : "chart4",
				        					title     : "<spring:message code='lbl.prodTend' /> (<spring:message code='lbl.hMillion' />)"
				        				});
				                	} else if(chartId == "chart5")	{
				                		gfn_comPopupOpen("POPUP_CHART", {
				        					rootUrl   : "dashboard",
				        					url       : "popup_chart",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : "chart5",
				        					title     : "<spring:message code='lbl.supplyCapacityRate' /> (%)"
				        				});
				                	} else if(chartId == "chart6")	{
				                		gfn_comPopupOpen("POPUP_CHART", {
				        					rootUrl   : "dashboard",
				        					url       : "popup_chart",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : "chart6",
				        					title     : "<spring:message code='lbl.defectRateChart' />"
				        				});
				                	} else if(chartId == "chart7")	{
				                		gfn_comPopupOpen("POPUP_CHART", {
				        					rootUrl   : "dashboard",
				        					url       : "popup_chart",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : "chart7",
				        					title     : "<spring:message code='lbl.prodInvStatusChart2' /> (<spring:message code='lbl.hMillion' />)"
				        				});
				                	} else if(chartId == "chart8")	{
				                		gfn_comPopupOpen("POPUP_CHART", {
				        					rootUrl   : "dashboard",
				        					url       : "popup_chart",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : "chart8",
				        					title     : "<spring:message code='lbl.pitChart' /> (<spring:message code='lbl.hMillion' />, <spring:message code='lbl.dayChart' />)"
				        				});
				                	} else if(chartId == "chart9")	{
				                		gfn_comPopupOpen("POPUP_CHART", {
				        					rootUrl   : "dashboard",
				        					url       : "popup_chart",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : "chart9",
				        					title     : "<spring:message code='lbl.itemGroupChart2' /> (EA)"
				        				});
				                	}
				                }
				            }
				        }
				    }
				},
			};
			
			if (!isStack) {
				delete chart.plotOptions.column.stacking;
			}
			
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
		trend1.search(sqlFlag);
	}
	
	function fn_openPopup(type) {
		
	}
	
 	// onload 
	$(document).ready(function() {
		trend1.init();
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
						<h4><spring:message code="lbl.salesTrend" /> (<spring:message code="lbl.hMillion" />)</h4>
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="profit1" name="profit" value="item"/> <label for="profit1"><spring:message code="lbl.type2" /></label></li>
								<li><input type="radio" id="profit2" name="profit" value="total" checked="checked"/><label for="profit2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart1"></div>
					</div>
					
					<div class="col_3">
						<h4><spring:message code="lbl.custSalesTrend" /> (<spring:message code="lbl.hMillion" />)</h4>
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="chart2_type1" name="chart2_type" value="cust"/> <label for="chart2_type1"><spring:message code="lbl.reptCust" /></label></li>
								<li><input type="radio" id="chart2_type2" name="chart2_type" value="total" checked="checked"/> <label for="chart2_type2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart2"></div>
					</div>
					
					<div class="col_3" >
						<h4><spring:message code="lbl.claimChart2" /></h4>
						<div style="height: 100%" id="chart3" ></div>
					</div>
					
					<div class="col_3">
						<h4><spring:message code="lbl.prodTend" /> (<spring:message code="lbl.hMillion" />)</h4>
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="prod1" name="prod" value="item"/> <label for="prod1"><spring:message code="lbl.part" /></label></li>
								<li><input type="radio" id="prod2" name="prod" value="total" checked="checked"/> <label for="prod2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart4"></div>
					</div>
					
					<div class="col_3">
						<h4><spring:message code="lbl.supplyCapacityRate" /> (%)</h4>
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="agingTrend1" name="agingTrend" value="cust"/> <label for="agingTrend1"><spring:message code="lbl.reptCust" /></label></li>
								<li><input type="radio" id="agingTrend2" name="agingTrend" value="total" checked="checked"/> <label for="agingTrend2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart5"></div>
					</div>
					
					<div class="col_3">
						<h4><spring:message code="lbl.defectRateChart" /></h4>
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="key3" name="key" value="part"/> <label for="key3"><spring:message code="lbl.part" /></label></li>
								<li><input type="radio" id="key2" name="key" value="key"/> <label for="key2"><spring:message code="lbl.reptItemGroup" /></label></li>
								<li><input type="radio" id="key4" name="key" value="mainItem"/> <label for="key4"><spring:message code="lbl.kpdr2" /></label></li>
								<li><input type="radio" id="key1" name="key" value="total" checked="checked"/> <label for="key1"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart6" ></div>
					</div>
					
					<div class="col_3">
						<h4><spring:message code="lbl.prodInvStatusChart2" /> (<spring:message code="lbl.hMillion" />)</h4>
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="inv_weekMonth_type1" name="inv_weekMonth_type" value="WEEK" checked="checked"> <label for="inv_weekMonth_type1"><spring:message code="lbl.thisWeek2" /></label></li>
								<li><input type="radio" id="inv_weekMonth_type2" name="inv_weekMonth_type" value="MONTH" > <label for="inv_weekMonth_type2"><spring:message code="lbl.thisMonth" /></label></li>
								<li><input type="radio" id="inv_type1" name="inv_type" value="COST" checked="checked"> <label for="inv_type1"><spring:message code="lbl.costChart" /></label></li>
								<li><input type="radio" id="inv_type2" name="inv_type" value="PRICE" > <label for="inv_type2"><spring:message code="lbl.amtChart" /></label></li>
								<li><input type="radio" id="inv1" name="inv" value="item" > <label for="inv1"><spring:message code="lbl.itemType" /></label></li>
								<li><input type="radio" id="inv2" name="inv" value="total" checked="checked"> <label for="inv2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart7"></div>
					</div>
					<div class="col_3">
						<h4 id="chart8_title"><spring:message code="lbl.pitChart" /> (<spring:message code="lbl.hMillion" />, <spring:message code="lbl.dayChart" />)</h4>
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="companyCons1" name="companyCons" value="companyCons"/> <label for="companyCons1"><spring:message code="lbl.companyCons" /></label></li>
								<li><input type="radio" id="companyCons2" name="companyCons" value="company" checked="checked"/> <label for="companyCons2"><spring:message code="lbl.company2" /> </label></li>
								<li><input type="radio" id="trend5_weekMonth_type1" name="trend5_weekMonth_type" value="WEEK" checked="checked"/> <label for="trend5_weekMonth_type1"><spring:message code="lbl.thisWeek2" /></label></li>
								<li><input type="radio" id="trend5_weekMonth_type2" name="trend5_weekMonth_type" value="MONTH"/> <label for="trend5_weekMonth_type2"><spring:message code="lbl.thisMonth" /></label></li>
								<li><input type="radio" id="trend5_type1" name="trend5_type" value="COST"> <label for="trend5_type1"><spring:message code="lbl.costChart" /></label></li>
								<li><input type="radio" id="trend5_type2" name="trend5_type" value="PRICE" checked="checked"/><label for="trend5_type2"><spring:message code="lbl.amtChart" /></label></li>
								<li><input type="radio" id="trend5_amt" name="trend5" value="amt" checked="checked"/><label for="trend5_amt"><spring:message code="lbl.amt" /></label></li>
								<li><input type="radio" id="trend5_day" name="trend5" value="day"/><label for="trend5_day"><spring:message code="lbl.days" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart8"></div>
					</div>
					<div class="col_3">
						<h4><spring:message code="lbl.itemGroupChart2" /> (EA)</h4>
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
