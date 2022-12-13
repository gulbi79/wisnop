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
</style>

<script type="text/javascript">

	var popupChart = {

		init : function () {
			
			this.initSearch();
			this.events();
			
			var userLang = "${sessionScope.GV_LANG}";
			
			if(userLang == "ko") {
	    		unit = 100000000;
	    	} else if(userLang == "en" || userLang == "cn") {
	    		unit = 1000000000;
	    	}
		},
	
		_siq	: "dashboard.snopTrend.",
		chart_id : "${popup_chart.chartId}",
		
		events : function () {
			
			$("#btnClose").on("click", function(){
				window.close(); 
			});
			
			$(':radio[name=profit]').on('change', function () {
				popupChart.profitSearch(false);
			});
			
			$(':radio[name=chart2_type]').on('change', function () {
				popupChart.chart2Search(false);
			});
			
			$(':radio[name=prod]').on('change', function () {
				popupChart.prodSearch(false);
			});
			
			$(':radio[name=agingTrend]').on('change', function () {
				popupChart.agingTrendSearch(false);
			});
			
			$(':radio[name=key]').on('change', function () {
				popupChart.defactSearch(false);
			});
			
			$(':radio[name=inv]').on('change', function () {
				popupChart.invSearch(false);
			});
			
			$(':radio[name=inv_type]').on('change', function () {
				popupChart.invSearch(false);
			});
			
			$(':radio[name=inv_weekMonth_type]').on('change', function () {
				popupChart.invSearch(false);
			});
			
			$(':radio[name=trend5]').on('change', function () {
				var str = '<spring:message code="lbl.pitChart" /> (<spring:message code="lbl.hMillion" />, <spring:message code="lbl.dayChart" />)';
				
				if($(this).val() == "amt") {
					str = '<spring:message code="lbl.pitChart" /> (<spring:message code="lbl.hMillion" />)';
				}
				
				$("#title").html(str);
				
				popupChart.trend5Search(false);
			});
			
			$(':radio[name=trend5_type]').on('change', function () {
				var str = '<spring:message code="lbl.pitChart" /> (<spring:message code="lbl.hMillion" />, <spring:message code="lbl.dayChart" />)';
				
				if($(this).val() == "amt") {
					str = '<spring:message code="lbl.pitChart" /> (<spring:message code="lbl.hMillion" />)';
				}
				
				$("#title").html(str);
				
				popupChart.trend5Search(false);
			});
			
			$(':radio[name=companyCons]').on('change', function () {
				var str = '<spring:message code="lbl.pitChart" /> (<spring:message code="lbl.hMillion" />, <spring:message code="lbl.dayChart" />)';
				
				if($(this).val() == "amt") {
					str = '<spring:message code="lbl.pitChart" /> (<spring:message code="lbl.hMillion" />)';
				}
				
				$("#title").html(str);
				
				popupChart.trend5Search(false);
			});
			
			$(':radio[name=trend5_weekMonth_type]').on('change', function () {
				var str = '<spring:message code="lbl.pitChart" /> (<spring:message code="lbl.hMillion" />, <spring:message code="lbl.dayChart" />)';
				
				if($(this).val() == "amt") {
					str = '<spring:message code="lbl.pitChart" /> (<spring:message code="lbl.hMillion" />)';
				}
				
				$("#title").html(str);
				
				popupChart.trend5Search(false);
			});
			
			$(':radio[name=sales]').on('change', function () {
				popupChart.salesSearch(false);
			});
			
			$(':radio[name=salesInv]').on('change', function () {
				popupChart.salesSearch(false);
			});
			
			$(':radio[name=salesFcst]').on('change', function () {
				popupChart.salesFcstSearch(false);
			});
			
			$(':radio[name=achivRt]').on('change', function () {
				popupChart.achivRtSearch(false);
			});
			
			$(':radio[name=prodRate]').on('change', function () {
				popupChart.prodRateSearch(false);
			});
			
			$(':radio[name=prodRateWeek]').on('change', function () {
				popupChart.prodRateSearch(false);
			});
			
			$(':radio[name=trend19]').on('change', function () {
				popupChart.trend19Search(false);
			});
			
			$(':radio[name=trend20]').on('change', function () {
				popupChart.trend20Search(false);
			});
			
			$(':radio[name=wip]').on('change', function () {
				popupChart.wipSearch(false);
			});
			
			$(':radio[name=wipRt]').on('change', function () {
				popupChart.wipRtSearch(false);
			});
			
			$(':radio[name=agingTrend]').on('change', function () {
				popupChart.aTrendSearch(false);
			});
			$(':radio[name=agingTrendCostSale]').on('change', function () {
				popupChart.aTrendSearch(false);
			});
			$(':radio[name=agingTrendInv]').on('change', function () {
				popupChart.aTrendSearch(false);
			});
			
			$(':radio[name=trend22]').on('change', function () {
				popupChart.trend22Search(false);
			});
			
			$(':radio[name=chart24_type]').on('change', function () {
				popupChart.chart24Search(false);
			});
			
			$(':radio[name=prepAvail]').on('change', function () {
				popupChart.trend17Search(false);
			});
			$(':radio[name=proTypeTotal]').on('change', function () {
				popupChart.trend17Search(false);
			});
			
			$(':radio[name=chart18WeekMonth]').on('change', function () {
				popupChart.trend18Search(false);
			});
			$(':radio[name=chart18ProTypeTotal]').on('change', function () {
				popupChart.trend18Search(false);
			});
			$(':radio[name=chart23Radio]').on('change', function () {
				popupChart.chart23RadioSearch(false);
			});
		},
		
		bucket : null,
		
		initSearch : function () {
			FORM_SEARCH = {}
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.tranData = [{ outDs : "week"  , _siq : popupChart._siq + "trendBucketWeek" }
								  , { outDs : "month" , _siq : popupChart._siq + "trendBucketMonth" }];
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					popupChart.bucket = {};
					popupChart.bucket.week  = data.week;
					popupChart.bucket.month = data.month;
					
					popupChart.search();
				}
			}
			gfn_service(sMap, "obj");
		},
		
		search : function (sqlFlag) {
			FORM_SEARCH            = {};
			FORM_SEARCH            = this.bucket;
			
			if(popupChart.chart_id == "chart1") {
				FORM_SEARCH.profit     = $(':radio[name=profit]:checked').val();
			} else if(popupChart.chart_id == "chart2") {
				FORM_SEARCH.chart2_type = $(':radio[name=chart2_type]:checked').val();
			} else if(popupChart.chart_id == "chart4") {
				FORM_SEARCH.prod       = $(':radio[name=prod]:checked').val();
			} else if(popupChart.chart_id == "chart5") {
				FORM_SEARCH.agingTrend = $(':radio[name=agingTrend]:checked').val();
			} else if(popupChart.chart_id == "chart6") {
				FORM_SEARCH.key        = $(':radio[name=key]:checked').val();
			} else if(popupChart.chart_id == "chart7") {
				FORM_SEARCH.inv        = $(':radio[name=inv]:checked').val();
				FORM_SEARCH.inv_type = $(':radio[name=inv_type]:checked').val();
				FORM_SEARCH.inv_weekMonth_type = $(':radio[name=inv_weekMonth_type]:checked').val();
			} else if(popupChart.chart_id == "chart8") {
				FORM_SEARCH.trend5     = $(':radio[name=trend5]:checked').val();
				FORM_SEARCH.trend5_type = $(':radio[name=trend5_type]:checked').val();
				FORM_SEARCH.companyCons = $(':radio[name=companyCons]:checked').val();
				FORM_SEARCH.trend5_weekMonth_type = $(':radio[name=trend5_weekMonth_type]:checked').val();
			} else if(popupChart.chart_id == "chart10") {
				FORM_SEARCH.sales      = $(':radio[name=sales]:checked').val();
				FORM_SEARCH.salesInv   = $(':radio[name=salesInv]:checked').val();
			} else if(popupChart.chart_id == "chart11") {
				FORM_SEARCH.salesFcst  = $(':radio[name=salesFcst]:checked').val();
			} else if(popupChart.chart_id == "chart12") {
				FORM_SEARCH.achivRt    = $(':radio[name=achivRt]:checked').val();
			} else if(popupChart.chart_id == "chart13") {
				FORM_SEARCH.prodRate   = $(':radio[name=prodRate]:checked').val();
				FORM_SEARCH.prodRateWeek   = $(':radio[name=prodRateWeek]:checked').val();
			} else if(popupChart.chart_id == "chart14") {
				FORM_SEARCH.trend19    = $(':radio[name=trend19]:checked').val();
			} else if(popupChart.chart_id == "chart15") {
				FORM_SEARCH.trend20    = $(':radio[name=trend20]:checked').val();
			} else if(popupChart.chart_id == "chart19") {
				FORM_SEARCH.wip        = $(':radio[name=wip]:checked').val();
			} else if(popupChart.chart_id == "chart20") {
				FORM_SEARCH.wipRt      = $(':radio[name=wipRt]:checked').val();
			} else if(popupChart.chart_id == "chart21") {
				FORM_SEARCH.trend22    = $(':radio[name=trend22]:checked').val();
			} else if(popupChart.chart_id == "chart22") {
				var agingTrendMeasCd = agingTrendCombo();
				FORM_SEARCH.agingTrendInv = $(':radio[name=agingTrendInv]:checked').val();
				FORM_SEARCH.agingTrendMeasCd = agingTrendMeasCd;
			} else if(popupChart.chart_id == "chart24") {
				FORM_SEARCH.chart24_type   = $(':radio[name=chart24_type]:checked').val();
			} else if(popupChart.chart_id == "chart17") {
				FORM_SEARCH.prepAvail  = $(':radio[name=prepAvail]:checked').val();
				FORM_SEARCH.proTypeTotal = $(':radio[name=proTypeTotal]:checked').val();
			} else if(popupChart.chart_id == "chart23") {
				FORM_SEARCH.chart23Radio   = $(':radio[name=chart23Radio]:checked').val();
			}
			
			FORM_SEARCH._mtd       = "getList";
			FORM_SEARCH.sql        = sqlFlag;
			FORM_SEARCH.unit       = unit;
			
			FORM_SEARCH.tranData   = 
				[
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
		
		chart23RadioSearch : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = popupChart.bucket;
			FORM_SEARCH.chart23Radio   = $(':radio[name=chart23Radio]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "chart23" , _siq : popupChart._siq + "chart23" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					
					var arMonth = new Array();
			
					$.each (popupChart.bucket.month, function (i, el) {
						arMonth.push(el.DISMONTH);
					});
					var chart23 = JSON.parse(data.chart23[0].TREND23);
					popupChart.chartGen('chart23', 'line', arMonth, chart23);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		profitSearch : function (sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = popupChart.bucket;
			FORM_SEARCH.profit   = $(':radio[name=profit]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = 
				[
					{ outDs : "chart1" , _siq : popupChart._siq + "chart1" } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arMonth = new Array();
			
					$.each (popupChart.bucket.month, function (i, el) {
						arMonth.push(el.DISMONTH);
					});
					var chart1 = JSON.parse(data.chart1[0].PROFIT_TREND);

					popupChart.chartGen('chart1', 'line', arMonth, chart1);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		chart2Search : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = popupChart.bucket;
			FORM_SEARCH.chart2_type   = $(':radio[name=chart2_type]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = 
				[
					{ outDs : "chart2" , _siq : popupChart._siq + "chart2" } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arMonth = new Array();
			
					$.each (popupChart.bucket.month, function (i, el) {
						arMonth.push(el.DISMONTH);
					});
					var chart2 = JSON.parse(data.chart2[0].CUST);

					popupChart.chartGen('chart2', 'line', arMonth, chart2);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		prodSearch : function (sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = popupChart.bucket;
			FORM_SEARCH.prod     = $(':radio[name=prod]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = 
				[
					{ outDs : "chart4" , _siq : popupChart._siq + "chart4" } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arMonth = new Array();
			
					$.each (popupChart.bucket.month, function (i, el) {
						arMonth.push(el.DISMONTH);
					});
					var chart4     = JSON.parse(data.chart4[0].PROD_TREND);

					popupChart.chartGen('chart4', 'line', arMonth, chart4);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		agingTrendSearch : function(sqlFlag) {
			FORM_SEARCH            = {};
			FORM_SEARCH            = popupChart.bucket;
			FORM_SEARCH.agingTrend = $(':radio[name=agingTrend]:checked').val();
			FORM_SEARCH._mtd       = "getList";
			FORM_SEARCH.sql        = sqlFlag;
			FORM_SEARCH.tranData   = 
				[
					{ outDs : "chart5" , _siq : popupChart._siq + "chart5" } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arMonth = new Array();
			
					$.each (popupChart.bucket.month, function (i, el) {
						arMonth.push(el.DISMONTH);
					});
					
					var chart5  = JSON.parse(data.chart5[0].CAPA);

					popupChart.chartGen('chart5', 'line', arMonth, chart5); 
				}
			}
			gfn_service(sMap,"obj");
		},
		
		defactSearch : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = popupChart.bucket;
			FORM_SEARCH.key      = $(':radio[name=key]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = 
				[
					{ outDs : "chart6" , _siq : popupChart._siq + "chart6" } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arMonth = new Array();
			
					$.each (popupChart.bucket.month, function (i, el) {
						arMonth.push(el.DISMONTH);
					});
					
					var chart6      = JSON.parse(data.chart6[0].DEFECT);
					popupChart.tagetStyle(chart6);

					popupChart.chartGen('chart6', 'line', arMonth, chart6);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		invSearch : function (sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = popupChart.bucket;
			FORM_SEARCH.inv      = $(':radio[name=inv]:checked').val();
			FORM_SEARCH.inv_type = $(':radio[name=inv_type]:checked').val();
			FORM_SEARCH.inv_weekMonth_type = $(':radio[name=inv_weekMonth_type]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = 
				[
					{ outDs : "chart7" , _siq : popupChart._siq + "chart7" } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					
					var arPreCate = new Array();
					var chart7 = JSON.parse(data.chart7[0].INVENTORY);
					
					if(FORM_SEARCH.inv_weekMonth_type == "WEEK"){
						$.each (popupChart.bucket.week, function (i, el) {
							arPreCate.push(el.DISWEEK);
						});
					}else{
						$.each (popupChart.bucket.month, function (i, el) {
							arPreCate.push(el.DISMONTH);
						});
					}
					popupChart.chartGen('chart7', 'line', arPreCate, chart7);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		trend5Search : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = popupChart.bucket;
			FORM_SEARCH.trend5   = $(':radio[name=trend5]:checked').val();
			FORM_SEARCH.trend5_type = $(':radio[name=trend5_type]:checked').val();
			FORM_SEARCH.companyCons = $(':radio[name=companyCons]:checked').val();
			FORM_SEARCH.trend5_weekMonth_type = $(':radio[name=trend5_weekMonth_type]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = 
				[
					{ outDs : "chart8" , _siq : popupChart._siq + "chart8" } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					
					var arPreCate = new Array();
					var chart8 = JSON.parse(data.chart8[0].ITEM_INV);

					if(FORM_SEARCH.trend5_weekMonth_type == "WEEK"){
						$.each (popupChart.bucket.week, function (i, el) {
							arPreCate.push(el.DISWEEK);
						});
					}else{
						$.each (popupChart.bucket.month, function (i, el) {
							arPreCate.push(el.DISMONTH);
						});
					}

					popupChart.chartGen('chart8', 'line', arPreCate, chart8);
					
					/* var arPreWeek = new Array();

					$.each (popupChart.bucket.week, function (i, el) {
						arPreWeek.push(el.PRE_DISWEEK);
					});
					var chart8  = JSON.parse(data.chart8[0].ITEM_INV);

					popupChart.chartGen('chart8', 'line', arPreWeek, chart8); */
				}
			}
			gfn_service(sMap,"obj");
		},
		
		salesSearch : function(sqlFlag) {
			FORM_SEARCH          = {}
			FORM_SEARCH          = popupChart.bucket;
			FORM_SEARCH.sales    = $(':radio[name=sales]:checked').val();
			FORM_SEARCH.salesInv = $(':radio[name=salesInv]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = 
				[
					{ outDs : "chart10" , _siq : popupChart._siq + "chart10" } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arPreWeek = new Array();
			
					$.each (popupChart.bucket.week, function (i, el) {
						arPreWeek.push(el.PRE_DISWEEK);
					});
					
					var chart10    = JSON.parse(data.chart10[0].SALES_CML);

					popupChart.chartGen('chart10', 'line', arPreWeek, chart10);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		salesFcstSearch : function(sqlFlag) {
			FORM_SEARCH           = {}
			FORM_SEARCH           = popupChart.bucket;
			FORM_SEARCH.salesFcst = $(':radio[name=salesFcst]:checked').val();
			FORM_SEARCH._mtd      = "getList";
			FORM_SEARCH.sql       = sqlFlag;
			FORM_SEARCH.tranData  = 
				[
					{ outDs : "chart11" , _siq : popupChart._siq + "chart11" } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arPreMonth = new Array();
					
					$.each (popupChart.bucket.month, function (i, el) {
						arPreMonth.push(el.PRE_DISMONTH);
					});
					
					var chart11   = JSON.parse(data.chart11[0].SALES_FCST);

					popupChart.chartGen('chart11', 'line', arPreMonth, chart11);
				}
			}
			gfn_service(sMap,"obj");
		}, 
		
		achivRtSearch : function(sqlFlag) {
			FORM_SEARCH          = {}
			FORM_SEARCH          = popupChart.bucket;
			FORM_SEARCH.achivRt  = $(':radio[name=achivRt]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = 
				[
					{ outDs : "chart12" , _siq : popupChart._siq + "chart12" } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arPreMonth = new Array();
					
					$.each (popupChart.bucket.month, function (i, el) {
						arPreMonth.push(el.PRE_DISMONTH);
					});
					
					var chart12     = JSON.parse(data.chart12[0].ACHIV_RT);

					popupChart.chartGen('chart12', 'line', arPreMonth, chart12);
				}
			}
			gfn_service(sMap,"obj");
		}, 
		
		prodRateSearch : function(sqlFlag) {
			FORM_SEARCH          = {}
			FORM_SEARCH          = popupChart.bucket;
			FORM_SEARCH.prodRate = $(':radio[name=prodRate]:checked').val();
			FORM_SEARCH.prodRateWeek = $(':radio[name=prodRateWeek]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = 
				[
					{ outDs : "chart13" , _siq : popupChart._siq + "chart13" } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arWeek = new Array();
			
					$.each (popupChart.bucket.week, function (i, el) {
						arWeek.push(el.DISWEEK);
					});
					
					var chart13     = JSON.parse(data.chart13[0].PROD_CML);

					popupChart.chartGen('chart13', 'line', arWeek, chart13);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		trend19Search : function(sqlFlag) {
			FORM_SEARCH          = {}
			FORM_SEARCH          = popupChart.bucket;
			FORM_SEARCH.trend19  = $(':radio[name=trend19]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = 
				[
					{ outDs : "chart14" , _siq : popupChart._siq + "chart14" } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arPreMonth = new Array();
					
					$.each (popupChart.bucket.month, function (i, el) {
						arPreMonth.push(el.PRE_DISMONTH);
					});
					
					var chart14     = JSON.parse(data.chart14[0].TREND19);

					popupChart.chartGen('chart14', 'line', arPreMonth, chart14);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		trend20Search : function(sqlFlag) {
			FORM_SEARCH          = {}
			FORM_SEARCH          = popupChart.bucket;
			FORM_SEARCH.trend20  = $(':radio[name=trend20]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = 
				[
					{ outDs : "chart15" , _siq : popupChart._siq + "chart15" } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arPreMonth = new Array();
					
					$.each (popupChart.bucket.month, function (i, el) {
						arPreMonth.push(el.PRE_DISMONTH);
					});
					
					var chart15     = JSON.parse(data.chart15[0].TREND20);

					popupChart.chartGen('chart15', 'line', arPreMonth, chart15);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		wipSearch : function(sqlFlag) {
			FORM_SEARCH = {};
			FORM_SEARCH = popupChart.bucket;
			FORM_SEARCH.wip  = $(':radio[name=wip]:checked').val();
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.sql  = sqlFlag;
			FORM_SEARCH.tranData = 
				[
					{ outDs : "chart19" , _siq : popupChart._siq + "chart19" } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arMonth = new Array();
					$.each (popupChart.bucket.month, function (i, el) {
						arMonth.push(el.DISMONTH);
					});
					var chart19 = JSON.parse(data.chart19[0].WIP);

					popupChart.chartGen('chart19', 'line', arMonth, chart19);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		wipRtSearch : function(sqlFlag) {
			FORM_SEARCH        = {};
			FORM_SEARCH        = popupChart.bucket;
			FORM_SEARCH.wipRt  = $(':radio[name=wipRt]:checked').val();
			FORM_SEARCH._mtd   = "getList";
			FORM_SEARCH.sql    = sqlFlag;
			FORM_SEARCH.tranData = 
				[
					{ outDs : "chart20" , _siq : popupChart._siq + "chart20" } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arPreMonth = new Array();
					$.each (popupChart.bucket.month, function (i, el) {
						arPreMonth.push(el.PRE_DISMONTH);
					});
					var chart20 = JSON.parse(data.chart20[0].WIP_RT);

					popupChart.chartGen('chart20', 'line', arPreMonth, chart20);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		
		trend22Search : function(sqlFlag) {
			FORM_SEARCH = {}
			FORM_SEARCH = popupChart.bucket;
			FORM_SEARCH.trend22 = $(':radio[name=trend22]:checked').val();
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.sql  = sqlFlag;
			FORM_SEARCH.tranData = 
				[
					{ outDs : "chart21" , _siq : popupChart._siq + "chart21" } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arMonth = new Array();
					$.each (popupChart.bucket.month, function (i, el) {
						arMonth.push(el.DISMONTH);
					});
					
					var chart21  = JSON.parse(data.chart21[0].TREND22);

					popupChart.chartGen('chart21', 'line', arMonth, chart21);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		
		aTrendSearch : function(sqlFlag) {
			
			var agingTrendMeasCd = agingTrendCombo();

			FORM_SEARCH = {}
			FORM_SEARCH = popupChart.bucket;
			FORM_SEARCH.agingTrendInv = $(':radio[name=agingTrendInv]:checked').val();
			FORM_SEARCH.agingTrendMeasCd = agingTrendMeasCd;
			
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.sql  = sqlFlag;
			FORM_SEARCH.tranData = 
				[
					{ outDs : "chart22" , _siq : popupChart._siq + "chart22" } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arPreMonth = new Array();
					$.each (popupChart.bucket.month, function (i, el) {
						arPreMonth.push(el.PRE_DISMONTH);
					});
					
					var chart22  = JSON.parse(data.chart22[0].AGING_TREND);

					popupChart.chartGen('chart22', 'line', arPreMonth, chart22);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		chart24Search : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = popupChart.bucket;
			FORM_SEARCH.chart24_type   = $(':radio[name=chart24_type]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = 
				[
					{ outDs : "chart24" , _siq : popupChart._siq + "chart24" } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arMonth = new Array();
			
					$.each (popupChart.bucket.month, function (i, el) {
						arMonth.push(el.DISMONTH);
					});
					var chart24 = JSON.parse(data.chart24[0].SALES);

					popupChart.chartGen('chart24', 'line', arMonth, chart24);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		trend17Search : function(sqlFlag) {
			FORM_SEARCH          = {}
			FORM_SEARCH          = popupChart.bucket;
			FORM_SEARCH.prepAvail  = $(':radio[name=prepAvail]:checked').val();
			FORM_SEARCH.proTypeTotal = $(':radio[name=proTypeTotal]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = 
				[
					{ outDs : "chart17" , _siq : popupChart._siq + "chart17" } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arPreWeek = new Array();
			
					$.each (popupChart.bucket.week, function (i, el) {
						arPreWeek.push(el.PRE_DISWEEK);
					});
					
					var chart17 = JSON.parse(data.chart17[0].ITEM);

					popupChart.chartGen('chart17', 'line', arPreWeek, chart17);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		trend18Search : function(sqlFlag) {
			FORM_SEARCH          = {}
			FORM_SEARCH          = popupChart.bucket;
			FORM_SEARCH.chart18WeekMonth  = $(':radio[name=chart18WeekMonth]:checked').val();
			FORM_SEARCH.chart18ProTypeTotal = $(':radio[name=chart18ProTypeTotal]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "chart18" , _siq : popupChart._siq + "chart18" }
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					var arPreWeek = new Array();
					var arPreMonth = new Array();
			
					$.each (popupChart.bucket.week, function (i, el) {
						arPreWeek.push(el.PRE_DISWEEK);
					});
					
					$.each (popupChart.bucket.month, function (i, el) {
						arPreMonth.push(el.PRE_DISMONTH);
					});
					
					var chart18 = JSON.parse(data.chart18[0].CAPA);
					
					if(FORM_SEARCH.chart18WeekMonth == "week"){
						popupChart.chartGen('chart18', 'line', arPreWeek, chart18);
					}else{
						popupChart.chartGen('chart18', 'line', arPreMonth, chart18);
					}
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
			
			$.each (popupChart.bucket.month, function (i, el) {
				arMonth.push(el.DISMONTH);
				arPreMonth.push(el.PRE_DISMONTH);
			});
			
			$.each (popupChart.bucket.week, function (i, el) {
				arWeek.push(el.DISWEEK);
				arPreWeek.push(el.PRE_DISWEEK);
			});
			
			if(popupChart.chart_id == "chart1") {
				var chart1 = JSON.parse(res.chart1[0].PROFIT_TREND);
				this.chartGen('chart1', 'line', arMonth , chart1);
			} else if(popupChart.chart_id == "chart2") {
				var chart2 = JSON.parse(res.chart2[0].CUST);
				this.chartGen('chart2', 'line', arMonth , chart2);
			} else if(popupChart.chart_id == "chart3") {
				var chart3 = JSON.parse(res.chart3[0].CLAIM);
				
				this.tagetStyle(chart3);
				this.chartGen('chart3', 'line', arMonth , chart3);
			} else if(popupChart.chart_id == "chart4") {
				var chart4 = JSON.parse(res.chart4[0].PROD_TREND);
				this.chartGen('chart4', 'line', arMonth , chart4);
				
			} else if(popupChart.chart_id == "chart5") {
				var chart5 = JSON.parse(res.chart5[0].CAPA);
				this.chartGen('chart5', 'line', arMonth , chart5);
			} else if(popupChart.chart_id == "chart6") {
				var chart6 = JSON.parse(res.chart6[0].DEFECT);
				this.tagetStyle(chart6);
				this.chartGen('chart6', 'line', arMonth , chart6);
			} else if(popupChart.chart_id == "chart7") {
				var chart7 = JSON.parse(res.chart7[0].INVENTORY);
				this.chartGen('chart7', 'line', arWeek  , chart7);
			} else if(popupChart.chart_id == "chart8") {
				var chart8 = JSON.parse(res.chart8[0].ITEM_INV);
				this.chartGen('chart8', 'line', arWeek  , chart8);
			} else if(popupChart.chart_id == "chart9") {
				var chart9 = JSON.parse(res.chart9[0].CAPA);
				this.chartGen('chart9', 'line', arMonth , chart9);
			} else if(popupChart.chart_id == "chart10") {
				var chart10 = JSON.parse(res.chart10[0].SALES_CML);
				this.chartGen('chart10', 'line', arPreWeek  , chart10);
			} else if(popupChart.chart_id == "chart11") {
				var chart11 = JSON.parse(res.chart11[0].SALES_FCST);
				this.chartGen('chart11', 'line', arPreMonth , chart11);
			} else if(popupChart.chart_id == "chart12") {
				var chart12 = JSON.parse(res.chart12[0].ACHIV_RT);
				this.chartGen('chart12', 'line', arPreMonth , chart12);
			} else if(popupChart.chart_id == "chart13") {
				var chart13 = JSON.parse(res.chart13[0].PROD_CML);
				this.chartGen('chart13', 'line', arWeek  , chart13);
			} else if(popupChart.chart_id == "chart14") {
				var chart14 = JSON.parse(res.chart14[0].TREND19);
				this.chartGen('chart14', 'line', arPreMonth , chart14);
			} else if(popupChart.chart_id == "chart15") {
				var chart15 = JSON.parse(res.chart15[0].TREND20);
				this.chartGen('chart15', 'line', arPreMonth , chart15);
			} else if(popupChart.chart_id == "chart16") {
				var chart16 = JSON.parse(res.chart16[0].TREND21);
				this.chartGen('chart16', 'line', arPreWeek  , chart16);
			} else if(popupChart.chart_id == "chart17") {
				var chart17 = JSON.parse(res.chart17[0].ITEM);
				this.tagetStyle(chart17);
				this.chartGen('chart17', 'line', arPreWeek , chart17);
			} else if(popupChart.chart_id == "chart18") {
				
				var weekMonth = $(':radio[name=chart18WeekMonth]:checked').val();
				var chart18 = JSON.parse(res.chart18[0].CAPA);
				
				if(weekMonth == "week"){
					this.chartGen('chart18', 'line', arPreWeek, chart18);
				}else{
					this.chartGen('chart18', 'line', arPreMonth, chart18);
				}
				
				/* 
				var chart18 = JSON.parse(res.chart18[0].CAPA);
				this.chartGen('chart18', 'line', arPreWeek , chart18);
				 */
				
				
			} else if(popupChart.chart_id == "chart19") {
				var chart19 = JSON.parse(res.chart19[0].WIP);
				this.chartGen('chart19', 'line', arMonth, chart19);
			} else if(popupChart.chart_id == "chart20") {
				var chart20 = JSON.parse(res.chart20[0].WIP_RT);
				this.chartGen('chart20', 'line', arPreMonth, chart20);
			} else if(popupChart.chart_id == "chart21") {
				var chart21 = JSON.parse(res.chart21[0].TREND22);
				this.chartGen('chart21', 'line', arMonth, chart21);
			} else if(popupChart.chart_id == "chart22") {
				var chart22 = JSON.parse(res.chart22[0].AGING_TREND);
				this.chartGen('chart22', 'line', arPreMonth, chart22);
			} else if(popupChart.chart_id == "chart23") {
				var chart23 = JSON.parse(res.chart23[0].TREND23);
				this.chartGen('chart23', 'line', arMonth, chart23);
			} else if(popupChart.chart_id == "chart24") {
				var chart24 = JSON.parse(res.chart24[0].SALES);
				this.chartGen('chart24', 'line', arMonth , chart24);
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
			        					
			        					if(chartCode != "Long Boat"){
			        						this.chart.series[i].hide();	
			        					}
			        				}
			        			}else if(chartId == "chart23" && chart23RadioData == "cust")	{
			        				for(var i = 0; i < chartLen; i++){
			        					
			        					var chartCode = this.chart.series[i].userOptions.code;
			        					
			        					if(chartCode != "RCG001"){
			        						this.chart.series[i].hide();	
			        					}
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
				enabled : true,
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
					<h4 id="title" style="font-size: 30px;">${popup_chart.title} </h4>
					<c:choose>
						<c:when test="${popup_chart.chartId == 'chart1'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="profit1" name="profit" value="item" > <label for="profit1"><spring:message code="lbl.type2" /></label></li>
								<li><input type="radio" id="profit2" name="profit" value="total" checked="checked"> <label for="profit2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart1"></div>
						</c:when>
						<c:when test="${popup_chart.chartId == 'chart2'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="chart2_type1" name="chart2_type" value="cust" > <label for="chart2_type1"><spring:message code="lbl.reptCust" /></label></li>
								<li><input type="radio" id="chart2_type2" name="chart2_type" value="total" checked="checked"> <label for="chart2_type2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart2"></div>
						</c:when>
						<c:when test="${popup_chart.chartId == 'chart3'}">
						<div style="height: 95%" id="chart3" ></div>
						</c:when>
						<c:when test="${popup_chart.chartId == 'chart4'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="prod1" name="prod" value="item" > <label for="prod1"><spring:message code="lbl.part" /></label></li>
								<li><input type="radio" id="prod2" name="prod" value="total" checked="checked"> <label for="prod2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart4"></div>
						</c:when>
						<c:when test="${popup_chart.chartId == 'chart5'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="agingTrend1" name="agingTrend" value="cust" > <label for="agingTrend1"><spring:message code="lbl.reptCust" /></label></li>
								<li><input type="radio" id="agingTrend2" name="agingTrend" value="total" checked="checked"> <label for="agingTrend2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart5"></div>
						</c:when>
						<c:when test="${popup_chart.chartId == 'chart6'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="key3" name="key" value="part" > <label for="key3"><spring:message code="lbl.part" /></label></li>
								<li><input type="radio" id="key2" name="key" value="key" > <label for="key2"><spring:message code="lbl.reptItemGroup" /></label></li>
								<li><input type="radio" id="key4" name="key" value="mainItem" > <label for="key4"><spring:message code="lbl.kpdr2" /></label></li>
								<li><input type="radio" id="key1" name="key" value="total" checked="checked"> <label for="key1"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart6" ></div>
						</c:when>
						<c:when test="${popup_chart.chartId == 'chart7'}">
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
						</c:when>
						<c:when test="${popup_chart.chartId == 'chart8'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="companyCons1" name="companyCons" value="companyCons"/> <label for="companyCons1"><spring:message code="lbl.companyCons" /></label></li>
								<li><input type="radio" id="companyCons2" name="companyCons" value="company" checked="checked"/> <label for="companyCons2"><spring:message code="lbl.company2" /> </label></li>
								<li><input type="radio" id="trend5_weekMonth_type1" name="trend5_weekMonth_type" value="WEEK" checked="checked"> <label for="trend5_weekMonth_type1"><spring:message code="lbl.thisWeek2" /></label></li>
								<li><input type="radio" id="trend5_weekMonth_type2" name="trend5_weekMonth_type" value="MONTH" > <label for="trend5_weekMonth_type2"><spring:message code="lbl.thisMonth" /></label></li>
								<li><input type="radio" id="trend5_type1" name="trend5_type" value="COST"><label for="trend5_type1"><spring:message code="lbl.costChart" /></label></li>
								<li><input type="radio" id="trend5_type2" name="trend5_type" value="PRICE" checked="checked"> <label for="trend5_type2"><spring:message code="lbl.amtChart" /></label></li>
								<li><input type="radio" id="trend5_amt" name="trend5" value="amt" checked="checked"> <label for="trend5_amt"><spring:message code="lbl.amt" /></label></li>
								<li><input type="radio" id="trend5_day" name="trend5" value="day"> <label for="trend5_day"><spring:message code="lbl.days" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart8"></div>
						</c:when>
						<c:when test="${popup_chart.chartId == 'chart9'}">
						<div style="height: 95%" id="chart9"></div>
						</c:when>
						<c:when test="${popup_chart.chartId == 'chart10'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="salesInv1" name="salesInv" value="inv" checked="checked"> <label for="salesInv1"><spring:message code="lbl.salesInvY" /></label></li>
								<li><input type="radio" id="salesInv2" name="salesInv" value="noInv"> <label for="salesInv2"><spring:message code="lbl.salesInvN" /> </label></li>
								<li><input type="radio" id="sales1" name="sales" value="cust" > <label for="sales1"><spring:message code="lbl.reptCust" /></label></li>
								<li><input type="radio" id="sales2" name="sales" value="total" checked="checked"> <label for="sales2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart10" ></div>
						</c:when>
						<c:when test="${popup_chart.chartId == 'chart11'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="salesFcst1" name="salesFcst" value="cust" > <label for="salesFcst1"><spring:message code="lbl.reptCust" /></label></li>
								<li><input type="radio" id="salesFcst2" name="salesFcst" value="total" checked="checked"> <label for="salesFcst2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart11"></div>
						</c:when>
						<c:when test="${popup_chart.chartId == 'chart12'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="achivRt1" name="achivRt" value="cust" > <label for="achivRt1"><spring:message code="lbl.reptCust" /></label></li>
								<li><input type="radio" id="achivRt2" name="achivRt" value="total" checked="checked"> <label for="achivRt2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart12"></div>
						</c:when>
						<c:when test="${popup_chart.chartId == 'chart13'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="prodRateWeek1" name="prodRateWeek" value="std" checked="checked"/> <label for="prodRateWeek1"><spring:message code="lbl.stdWeek" /></label></li>
								<li><input type="radio" id="prodRateWeek2" name="prodRateWeek" value="sales"/> <label for="prodRateWeek2"><spring:message code="lbl.salesWeek" /> </label></li>
								<li><input type="radio" id="prodRate1" name="prodRate" value="item" > <label for="prodRate1"><spring:message code="lbl.part" /></label></li>
								<li><input type="radio" id="prodRate2" name="prodRate" value="total" checked="checked"> <label for="prodRate2"><spring:message code="lbl.itemTotal" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart13" ></div>
						</c:when>
						<c:when test="${popup_chart.chartId == 'chart14'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="trend19_part" name="trend19" value="part" > <label for="trend19_part"><spring:message code="lbl.part" /></label></li>
								<li><input type="radio" id="trend19_total" name="trend19" value="total" checked="checked"> <label for="trend19_total"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart14"></div>
						</c:when>
						<c:when test="${popup_chart.chartId == 'chart15'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="trend20_part" name="trend20" value="part" > <label for="trend20_part"><spring:message code="lbl.part" /></label></li>
								<li><input type="radio" id="trend20_total" name="trend20" value="total" checked="checked"> <label for="trend20_total"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart15"></div>
						</c:when>
						<c:when test="${popup_chart.chartId == 'chart16'}">
						<div style="height: 95%" id="chart16"></div>
						</c:when>
						<c:when test="${popup_chart.chartId == 'chart17'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="prepAvail1" name="prepAvail" value="prep" checked="checked"><label for="prepAvail1"><spring:message code="lbl.mprChart" /></label></li>
								<li><input type="radio" id="prepAvail2" name="prepAvail" value="avail"><label for="prepAvail2"><spring:message code="lbl.availableRate" /> </label></li>
								<li><input type="radio" id="proTypeTotal1" name="proTypeTotal" value="proType"><label for="proTypeTotal1"><spring:message code="lbl.procureType" /></label></li>
								<li><input type="radio" id="proTypeTotal2" name="proTypeTotal" value="total" checked="checked"><label for="proTypeTotal2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart17" ></div>
						</c:when>
						<c:when test="${popup_chart.chartId == 'chart18'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="chart18WeekMonth1" name="chart18WeekMonth" value="week" checked="checked"/><label for="chart18WeekMonth1"><spring:message code="lbl.weekly" /></label></li>
								<li><input type="radio" id="chart18WeekMonth2" name="chart18WeekMonth" value="month"/><label for="chart18WeekMonth2"><spring:message code="lbl.month2" /> </label></li>
								<li><input type="radio" id="chart18ProTypeTotal1" name="chart18ProTypeTotal" value="proType"/><label for="chart18ProTypeTotal1"><spring:message code="lbl.procureType" /></label></li>
								<li><input type="radio" id="chart18ProTypeTotal2" name="chart18ProTypeTotal" value="total" checked="checked"/><label for="chart18ProTypeTotal2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart18"></div>
						</c:when>
						<c:when test="${popup_chart.chartId == 'chart19'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="wip1" name="wip" value="item" > <label for="wip1"><spring:message code="lbl.part" /></label></li>
								<li><input type="radio" id="wip2" name="wip" value="total" checked="checked"> <label for="wip2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart19" ></div>
						</c:when>
						<c:when test="${popup_chart.chartId == 'chart20'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="wipRt1" name="wipRt" value="item" > <label for="wipRt1"><spring:message code="lbl.part" /></label></li>
								<li><input type="radio" id="wipRt2" name="wipRt" value="total" checked="checked"> <label for="wipRt2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart20"></div>
						</c:when>
						<c:when test="${popup_chart.chartId == 'chart21'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="trend22_m2" name="trend22" value="M2" checked="checked"> <label for="trend22_m2"><spring:message code="lbl.2mMore" /></label></li>
								<li><input type="radio" id="trend22_m6" name="trend22" value="M6"> <label for="trend22_m6"><spring:message code="lbl.6mMore" /></label></li>
								<li><input type="radio" id="trend22_y1" name="trend22" value="Y1"> <label for="trend22_y1"><spring:message code="lbl.yearOneMore" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart21"></div>
						</c:when>
						<c:when test="${popup_chart.chartId == 'chart22'}">
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
						<div style="height: 88%" id="chart22"></div>
						</c:when>
						<c:when test="${popup_chart.chartId == 'chart23'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="chart23Cust" name="chart23Radio" value="cust" checked="checked"/> <label for="chart23Cust"><spring:message code="lbl.reptCust" /></label></li>
								<li><input type="radio" id="chart23Prod" name="chart23Radio" value="prod" /> <label for="chart23Prod"><spring:message code="lbl.prodCate" /></label></li>
								<li><input type="radio" id="chart23Tot" name="chart23Radio" value="total"/> <label for="chart23Tot"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart23"></div>
						</c:when>
						<c:when test="${popup_chart.chartId == 'chart24'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="chart24_type1" name="chart24_type" value="cust" > <label for="chart24_type1"><spring:message code="lbl.reptCust" /></label></li>
								<li><input type="radio" id="chart24_type2" name="chart24_type" value="total" checked="checked"> <label for="chart24_type2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart24"></div>
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