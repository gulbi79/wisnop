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
    #cont_chart .col_3 > h4 > p
    {
        display:inline-block;
        padding-left:5px;
        font-weight:bold;
        position:relative;
        left:50%;
        
    }
    #cont_chart .col_3 >  h4 > p.green
    {
        color: green;
        
    }
    #cont_chart .col_3 >  h4 > p.red
    {
        color:red;
    }
    
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
	
		_siq	: "dashboard.demendTrend.",
		chart_id : "${popupChartDemend.chartId}",
		
		events : function () {
			
			$("#btnClose").on("click", function(){
				window.close(); 
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
			
			$(':radio[name=chart23Radio]').on('change', function () {
				popupChart.chart23RadioSearch(false);
			});
			
			$(':radio[name=chart24_type]').on('change', function () {
				popupChart.chart24Search(false);
			});
			
			$(':radio[name=chart24_weekMonth_type]').on('change', function () {
				popupChart.chart24Search(false);
			});
			
			$(':radio[name=chart2_type]').on('change', function () {
				popupChart.chart2Search(false);
			});
			
			$(':radio[name=chart2_weekMonth_type]').on('change', function () {
				popupChart.chart2Search(false);
			});
			
			$(':radio[name=operProfitType]').on('change', function () {
				popupChart.operProfitSearch(false);
			});
			
			$(':radio[name=trend5]').on('change', function () {
				var str = '<spring:message code="lbl.pitChart" /> (<spring:message code="lbl.hMillion" />, <spring:message code="lbl.dayChart" />)';
				
				if($(this).val() == "amt") {
					str = '<spring:message code="lbl.pitChart" /> (<spring:message code="lbl.hMillion" />)';
				}
				
				$("#chart8_title").html(str);
				popupChart.trend5Search(false);
			});
			
			$(':radio[name=trend5_type]').on('change', function () {
				popupChart.trend5Search(false);
			});
			
			$(':radio[name=companyCons]').on('change', function () {
				popupChart.trend5Search(false);
			});
			
			$(':radio[name=trend5_weekMonth_type]').on('change', function () {
				popupChart.trend5Search(false);
			});
			
			$(':radio[name=demandForecastWeekMonth]').on('change', function () {
				popupChart.demandForecastSearch(false);
			});
			
			$(':radio[name=dmdSeries]').on('change', function () {
				popupChart.demandForecastSearch(false);
			});
			
			$(':radio[name=demandForecastType]').on('change', function () {
				popupChart.demandForecastSearch(false);
			});
			
			$(':radio[name=demandForecastAmtQty]').on('change', function () {
				
				var str = '<spring:message code="lbl.demandForecast" />';
				
				if($(this).val() == "AMT") {
					str = '<spring:message code="lbl.demandForecast" />(<spring:message code="lbl.hMillion" />)';
				}
				
				$("#demandForecastH4").html(str);
				
				popupChart.demandForecastSearch(false);
			});
			
			$(':radio[name=onTimeDeliveryType]').on('change', function () {
				popupChart.onTimeDeliverySearch(false);
			});
		},
		
		bucket : null,
		
		initSearch : function () {
			FORM_SEARCH = {}
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.tranData = [{ outDs : "week"  , _siq : popupChart._siq + "trendBucketWeek" }
								  , { outDs : "week2"  , _siq : popupChart._siq + "trendBucketWeek2" }
								  , { outDs : "month" , _siq : popupChart._siq + "trendBucketMonth" }
								  , { outDs : "month2" , _siq : popupChart._siq + "trendBucketMonth2" }
								  , { outDs : "month3" , _siq : popupChart._siq + "trendBucketMonth3" }];
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					popupChart.bucket = {};
					popupChart.bucket.week  = data.week;
					popupChart.bucket.week2  = data.week2;
					popupChart.bucket.month = data.month;
					popupChart.bucket.month2 = data.month2;
					popupChart.bucket.month3 = data.month3;
					popupChart.bucket.monthChart11 = data.month.slice(0,data.month.length-1);
					popupChart.search();
				}
			}
			gfn_service(sMap, "obj");
		},
		
		search : function (sqlFlag) {
			FORM_SEARCH            = {};
			FORM_SEARCH            = this.bucket;
			
			if(popupChart.chart_id == "chart10") {
				FORM_SEARCH.sales      = $(':radio[name=sales]:checked').val();
				FORM_SEARCH.salesInv   = $(':radio[name=salesInv]:checked').val();
			} else if(popupChart.chart_id == "chart11") {
				FORM_SEARCH.salesFcst  = $(':radio[name=salesFcst]:checked').val();
			} else if(popupChart.chart_id == "chart12") {
				FORM_SEARCH.achivRt    = $(':radio[name=achivRt]:checked').val();
			} else if(popupChart.chart_id == "chart23") {
				FORM_SEARCH.chart23Radio    = $(':radio[name=chart23Radio]:checked').val();
			} else if(popupChart.chart_id == "chart24") {
				FORM_SEARCH.chart24_type   = $(':radio[name=chart24_type]:checked').val();
				FORM_SEARCH.chart24_weekMonth_type   = $(':radio[name=chart24_weekMonth_type]:checked').val();
			} else if(popupChart.chart_id == "chart2") {
				FORM_SEARCH.chart2_type = $(':radio[name=chart2_type]:checked').val();
				FORM_SEARCH.chart2_weekMonth_type   = $(':radio[name=chart2_weekMonth_type]:checked').val();
			} else if(popupChart.chart_id == "operProfit") {
				FORM_SEARCH.operProfitType    = $(':radio[name=operProfitType]:checked').val();
			} else if(popupChart.chart_id == "chart8") {
				FORM_SEARCH.trend5     = $(':radio[name=trend5]:checked').val();
				FORM_SEARCH.trend5_type = $(':radio[name=trend5_type]:checked').val();
				FORM_SEARCH.companyCons = $(':radio[name=companyCons]:checked').val();
				FORM_SEARCH.trend5_weekMonth_type = $(':radio[name=trend5_weekMonth_type]:checked').val();
			} else if(popupChart.chart_id == "demandForecastChart") {
				FORM_SEARCH.demandForecastWeekMonth = $(':radio[name=demandForecastWeekMonth]:checked').val();
				FORM_SEARCH.demandForecastType = $(':radio[name=demandForecastType]:checked').val();
				FORM_SEARCH.demandForecastAmtQty = $(':radio[name=demandForecastAmtQty]:checked').val();
				FORM_SEARCH.dmdSeries = $(':radio[name=dmdSeries]:checked').val();
				
				
			} else if(popupChart.chart_id == "onTimeDeliveryChart") {
				FORM_SEARCH.onTimeDeliveryType = $(':radio[name=onTimeDeliveryType]:checked').val();
			}
			
			
			
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.sql  = sqlFlag;
			FORM_SEARCH.unit = unit;
			FORM_SEARCH.unit2 = unit2;
			
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
					var arPreWeek = new Array();
			
					$.each (popupChart.bucket.week, function (i, el) {
						arPreWeek.push(el.PRE_DISWEEK);
					});
					
					var chart10 = JSON.parse(data.chart10[0].SALES_CML);
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
			FORM_SEARCH.tranData  = [
				{ outDs : "chart11" , _siq : popupChart._siq + "chart11" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					var arMonth = new Array();
					
					$.each (popupChart.bucket.monthChart11, function (i, el) {
						arMonth.push(el.DISMONTH);
					});
					
					var chart11   = JSON.parse(data.chart11[0].SALES_FCST);
					popupChart.chartGen('chart11', 'line', arMonth, chart11);
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
			FORM_SEARCH.tranData = [
				{ outDs : "chart12" , _siq : popupChart._siq + "chart12" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					var arMonth = new Array();
					
					$.each (popupChart.bucket.month, function (i, el) {
						arMonth.push(el.DISMONTH);
					});
					
					var chart12 = JSON.parse(data.chart12[0].ACHIV_RT);
					popupChart.chartGen('chart12', 'line', arMonth, chart12);
				}
			}
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
		
		chart24Search : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = popupChart.bucket;
			FORM_SEARCH.chart24_type   = $(':radio[name=chart24_type]:checked').val();
			FORM_SEARCH.chart24_weekMonth_type   = $(':radio[name=chart24_weekMonth_type]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "chart24" , _siq : popupChart._siq + "chart24" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					
					var weekMonth = $(':radio[name=chart24_weekMonth_type]:checked').val();
					
					if(weekMonth == "WEEK"){
						
						var arWeek = new Array();
						
						$.each (popupChart.bucket.week, function (i, el) {
							arWeek.push(el.DISWEEK);
						});
						
						var chart24 = JSON.parse(data.chart24[0].SALES);
						popupChart.chartGen('chart24', 'line', arWeek, chart24);
						
						
					}else{
						var arMonth = new Array();
						
						$.each (popupChart.bucket.month, function (i, el) {
							arMonth.push(el.DISMONTH);
						});
						var chart24 = JSON.parse(data.chart24[0].SALES);
						popupChart.chartGen('chart24', 'line', arMonth, chart24);	
					}
				}
			}
			gfn_service(sMap,"obj");
		},
		
		chart2Search : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = popupChart.bucket;
			FORM_SEARCH.chart2_type   = $(':radio[name=chart2_type]:checked').val();
			FORM_SEARCH.chart2_weekMonth_type   = $(':radio[name=chart2_weekMonth_type]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "chart2" , _siq : popupChart._siq + "chart2" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					
					var weekMonth = $(':radio[name=chart2_weekMonth_type]:checked').val();
					
					if(weekMonth == "WEEK"){
						var arWeek = new Array();
						
						$.each (popupChart.bucket.week, function (i, el) {
							arWeek.push(el.DISWEEK);
						});
						
						var chart2 = JSON.parse(data.chart2[0].CUST);
						popupChart.chartGen('chart2', 'line', arWeek, chart2);
					}else{
						var arMonth = new Array();
						
						$.each (popupChart.bucket.month, function (i, el) {
							arMonth.push(el.DISMONTH);
						});
						var chart2 = JSON.parse(data.chart2[0].CUST);
						popupChart.chartGen('chart2', 'line', arMonth, chart2);	
					}
				}
			}
			gfn_service(sMap,"obj");
		},
		
		operProfitSearch : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = popupChart.bucket;
			FORM_SEARCH.operProfitType   = $(':radio[name=operProfitType]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "operProfit" , _siq : popupChart._siq + "operProfit" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					
					var arPreMonth = new Array();
			
					$.each (popupChart.bucket.month, function (i, el) {
						arPreMonth.push(el.PRE_DISMONTH);
					});
					
					var operProfit = JSON.parse(data.operProfit[0].OPER_PROFIT);
					popupChart.chartGen('operProfit', 'line', arPreMonth, operProfit);
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
					// cartegory
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
				}
			}
			gfn_service(sMap,"obj");
		},
		
		demandForecastSearch : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = popupChart.bucket;
			FORM_SEARCH.demandForecastWeekMonth   = $(':radio[name=demandForecastWeekMonth]:checked').val();
			FORM_SEARCH.demandForecastType = $(':radio[name=demandForecastType]:checked').val();
			FORM_SEARCH.demandForecastAmtQty = $(':radio[name=demandForecastAmtQty]:checked').val();
			FORM_SEARCH.dmdSeries = $(':radio[name=dmdSeries]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "demandForecastChart" , _siq : popupChart._siq + "demandForecastChart" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					var arPreCate = new Array();
					var demandForecastChart = JSON.parse(data.demandForecastChart[0].DEMAND_FORECAST);

					if(FORM_SEARCH.demandForecastWeekMonth == "WEEK"){
						$.each (popupChart.bucket.week2, function (i, el) {
							arPreCate.push(el.DISWEEK);
						});
					}else{
						$.each (popupChart.bucket.month3, function (i, el) {
							arPreCate.push(el.DISMONTH);
						});
					}

					popupChart.chartGen('demandForecastChart', 'line', arPreCate, demandForecastChart);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		onTimeDeliverySearch : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = popupChart.bucket;
			FORM_SEARCH.onTimeDeliveryType = $(':radio[name=onTimeDeliveryType]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "onTimeDeliveryChart" , _siq : popupChart._siq + "onTimeDeliveryChart" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					
					var arPreWeek = new Array();
					
					$.each (popupChart.bucket.week, function (i, el) {
						arPreWeek.push(el.PRE_DISWEEK);
					});
					
					var onTimeDeliveryChart = JSON.parse(data.onTimeDeliveryChart[0].ON_TIME);
					popupChart.chartGen('onTimeDeliveryChart', 'line', arPreWeek, onTimeDeliveryChart);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		drawChart : function (res) {
			fn_setHighchartTheme();
			
			var arPreWeek  = new Array();
			var arWeek     = new Array();
			var arMonth    = new Array();
			var arPreMonth = new Array();
			var arMonth3    = new Array();
			var arPreMonth3 = new Array(); 
	        var arMonthChart11 = new Array();
			
			$.each (popupChart.bucket.week, function (i, el) {
				arWeek.push(el.DISWEEK);
				arPreWeek.push(el.PRE_DISWEEK);
			});
			
			$.each (popupChart.bucket.month, function (i, el) {
				arMonth.push(el.DISMONTH);
				arPreMonth.push(el.PRE_DISMONTH);
			});
			
			$.each (popupChart.bucket.month3, function (i, el) {
				arMonth3.push(el.DISMONTH);
				arPreMonth3.push(el.PRE_DISMONTH);
			});
			
	        $.each (popupChart.bucket.monthChart11, function (i, el) {
	                arMonthChart11.push(el.DISMONTH);
	        });
			
			if(popupChart.chart_id == "chart10") {
				var chart10 = JSON.parse(res.chart10[0].SALES_CML);
				this.chartGen('chart10', 'line', arPreWeek, chart10);
			} else if(popupChart.chart_id == "chart11") {
				var chart11 = JSON.parse(res.chart11[0].SALES_FCST);
				this.chartGen('chart11', 'line', arMonthChart11, chart11);
			} else if(popupChart.chart_id == "chart12") {
				var chart12 = JSON.parse(res.chart12[0].ACHIV_RT);
				this.chartGen('chart12', 'line', arMonth, chart12);
			} else if(popupChart.chart_id == "chart23") {
				var chart23 = JSON.parse(res.chart23[0].TREND23);
				this.chartGen('chart23', 'line', arMonth, chart23);
			} else if(popupChart.chart_id == "chart24") {
				var chart24 = JSON.parse(res.chart24[0].SALES);
				this.chartGen('chart24', 'line', arMonth, chart24);
			} else if(popupChart.chart_id == "chart2") {
				var chart2 = JSON.parse(res.chart2[0].CUST);
				this.chartGen('chart2', 'line', arMonth, chart2);
			} else if(popupChart.chart_id == "operProfit") {
				var operProfit = JSON.parse(res.operProfit[0].OPER_PROFIT);
				this.chartGen('operProfit', 'line', arPreMonth, operProfit);
			} else if(popupChart.chart_id == "cpfrTrend") {
				
				var cpfrData = res.cpfrTrend;
				var tmp = "<tr><td style=\"background-color: #bbdefb;width: 16%; \"></td>";
				$.each (popupChart.bucket.month2, function (i, el) {
					tmp += "<td style=\"text-align: center;background-color: #bbdefb;width: 14%; \">";
					tmp += el.DISMONTH;
					tmp += "</td>";
				});
				tmp += "</tr>";
				
				$.each(cpfrData, function(n, v){
					
					tmp += "<tr>";
					tmp += "<td style=\"text-align: center;background-color: #bbdefb;\">";
					tmp += v.NM;
					tmp += "</td>";
					
					$.each (popupChart.bucket.month2, function (i, el) {
						
						var disMonth = el.DISMONTH;
						var cpData = gfn_getNumberFmt(eval("v." + disMonth) / unit, 1, "R", "Y");
						tmp += "<td>";
						tmp += cpData;
						tmp += "</td>";
					});
					tmp += "</tr>";
				});
				$("#cpfrTbody").html(tmp);
			} else if(popupChart.chart_id == "avgShipPriceChart") {
				var avgShipPriceChart = JSON.parse(res.avgShipPriceChart[0].AVG_SHIP);
				this.chartGen('avgShipPriceChart', 'line', arPreMonth, avgShipPriceChart);
			} else if(popupChart.chart_id == "lamConTrendChart") {
				
				var codeNmArr = new Array();
				var columnData1 = [], columnData2 = [], lineData1 = [], lineData2 = [], lineData3 = [];
				
				$.each(res.lamConTrendChart, function(i, val){
					
					var rn = val.RN;
					var codeNm = val.CODE_NM;
					var trendWeek = val.TREND_WEEK;
					var flagSort = val.FLAG_SORT;
					var resultValue = gfn_nvl(val.RESULT_VALUE, 0);
					
					if(rn == 0){
						codeNmArr.push(codeNm);
					}
					
					if(flagSort == 1){
						columnData1.push({name: trendWeek, y: resultValue, color: gv_cColor1});
					}else if(flagSort == 2){
						columnData2.push({name: trendWeek, y: resultValue, color: gv_cColor2});
					}else if(flagSort == 3){
						lineData1.push({name: trendWeek, y: resultValue, color: gv_cColor3});
					}else if(flagSort == 4){
						lineData2.push({name: trendWeek, y: resultValue, color: gv_cColor4});
					}else if(flagSort == 5){
						lineData3.push({name: trendWeek, y: resultValue, color: gv_cColor5});
					}
				});
				
				var chartId = popupChart.chart_id;
				Highcharts.chart(chartId, {
				    
					xAxis: { type: 'category' },
				    plotOptions: {
				    	column: {
				    		stacking: 'normal'
				    	},
				        series: {
				            dataLabels: {
				            	allowOverlap : true,
				                enabled: true
				            },
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
				                			    	
				            	}// end of legendItemClick
				            }
				        }
				    },
				    
				    yAxis: [{ // left yAxis
				    	stackLabels: {
				    		//allowOverlap : true, //total 안나올때 옵션 주는거
				    		//enabled: true
						}
		    	    }, { // right yAxis
		    	    	stackLabels: {
				    		//allowOverlap : true, //total 안나올때 옵션 주는거
				    		//enabled: false
						}
		    	    }],
				    series: [
				        {
				            data: columnData1,
				            stack: 0,
				            type: 'column',
				            name: codeNmArr[0]
				        }, {
				            data: columnData2,
				            stack: 1,
				            type: 'column',
				            name: codeNmArr[1]
				        }, {
				            data: lineData1,
				            type: 'line',
				            name: codeNmArr[2],
				            yAxis: 1
				        }, {
				            data: lineData2,
				            type: 'line',
				            name: codeNmArr[3],
				            yAxis: 1
				        }, {
				            data: lineData3,
				            type: 'line',
				            name: codeNmArr[4],
				            yAxis: 1
				        }
				    ]
				});
			}else if(popupChart.chart_id == "chart8") {
				var chart8 = JSON.parse(res.chart8[0].ITEM_INV);
				this.chartGen('chart8', 'line', arWeek, chart8);
			}else if(popupChart.chart_id == "demandForecastChart") {
				var demandForecastChart = JSON.parse(res.demandForecastChart[0].DEMAND_FORECAST);
				this.chartGen('demandForecastChart', 'line', arMonth3, demandForecastChart);
			}else if(popupChart.chart_id == "invRateInfoChart") {
				var columnData1 = [], columnData2 = [], lineData1 = [];
				
				$.each(res.invRateInfoChart, function(i, val){
					
					var repCustGroupNm = val.REP_CUST_GROUP_NM;
					var salesAmt = gfn_nvl(val.SALES_AMT, 0);
					var invAmt = gfn_nvl(val.INV_AMT, 0);
					var rate = gfn_nvl(val.RATE, 0);
					
					
					columnData1.push({name: repCustGroupNm, y: salesAmt, color: gv_cColor1});
					columnData2.push({name: repCustGroupNm, y: invAmt, color: gv_cColor2});
					lineData1.push({name: repCustGroupNm, y: rate, color: gv_cColor3});
				});
				
				var chartId = popupChart.chart_id;;
				Highcharts.chart(chartId, {
				    
					xAxis: { type: 'category' },
				    plotOptions: {
				    	column: {
				    		stacking: 'normal'
				    	},
				        series: {
				            dataLabels: {
				            	allowOverlap : true,
				                enabled: true
				            },
				            events: {
								afterAnimate : function(e){
									
									/* var chartLen = this.chart.series.length;
									
									if(chartId == "invRateInfoChart") {
										for(var i = 0; i < chartLen; i++){
				        					
				        					var typeCode = this.chart.series[i].userOptions.type;
				        					
				        					if(typeCode == "column"){
				        						this.chart.series[i].hide();	
				        					}
				        				}
									} */
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
				    
				    yAxis: [{ // left yAxis
				    	stackLabels: {
				    		//allowOverlap : true, //total 안나올때 옵션 주는거
				    		//enabled: true
						}
		    	    }, { // right yAxis
		    	    	stackLabels: {
				    		//allowOverlap : true, //total 안나올때 옵션 주는거
				    		//enabled: false
						}
		    	    }],
				    series: [
				        {
				            data: columnData1,
				            stack: 0,
				            type: 'column',
				            name: '<spring:message code="lbl.sales2" /> (<spring:message code="lbl.hMillion" />)'
				            
				        }, {
				            data: columnData2,
				            stack: 1,
				            type: 'column',
				            name: '<spring:message code="lbl.prodInvStatus" /> (<spring:message code="lbl.hMillion" />)'
				        }, {
				            data: lineData1,
				            type: 'line',
				            name: '<spring:message code="lbl.invRate" /> (%)',
				            yAxis: 1
				        }
				    ]
				});
			}else if(popupChart.chart_id == "onTimeDeliveryChart") {
				var onTimeDeliveryChart = JSON.parse(res.onTimeDeliveryChart[0].ON_TIME);
				this.chartGen('onTimeDeliveryChart', 'line', arPreWeek, onTimeDeliveryChart);
			}else if(popupChart.chart_id == "cpfrShipPlanResultChart"){
				var cpfrShipPlanResultChart = JSON.parse(res.cpfrShipPlanResultChart[0].CPFR_PLAN_RESULT);
				this.chartGen('cpfrShipPlanResultChart','line', arMonth, cpfrShipPlanResultChart)
				
			}else if(popupChart.chart_id =="salesResultAgainstBizPlan"){
				
				   //경영계획 대비 실적(누적)
	            var codeNmArrSalesResultAgainstBizPlan = new Array();
	            var lineData1SalesResultAgainstBizPlan = [], lineData2SalesResultAgainstBizPlan = [],lineData3SalesResultAgainstBizPlan = [];
	            
	            var latest_SALES_RESULT =  null;
	            var latest_BIZ_PLAN     =  null;
	            var latest_BILL_ORDER_RESULT = null;
	            var today = new Date()
	            var month = today.getMonth() + 1;  // 월
	            $.each(res.salesResultAgainstBizPlan, function(i, val){
	                
	                var rn = val.RN;
	                var codeNm = val.CODE_NM;
	                var trendMonth = val.MONTH;
	                var date  = val.DATE
	                var flagSort = val.FLAG_SORT;
	                var resultValue = gfn_nvl(val.RESULT_VALUE, 0);
	                var lineNm =  null;
	                
	                if(date == '')
	                {
	                    lineNm = trendMonth+'월';
	                }
	                else
	                {
	                    lineNm = date;     
	                }
	                
	                if((month-1) == rn)
	                {
	                    if(codeNm=='BIZ_PLAN'){
	                        latest_BIZ_PLAN     = val.RESULT_VALUE
	                    }
	                    
	                    if(codeNm=='SALES_RESULT'){
	                        latest_SALES_RESULT = val.RESULT_VALUE
	                    }
	                    if(codeNm=='BILL_ORDER_RESULT'){
		                	latest_BILL_ORDER_RESULT = val.RESULT_VALUE
		                }
	                }
	                
	                
	                if(rn == 0){
	                    if(codeNm=='BIZ_PLAN')
	                    {
	                        codeNmArrSalesResultAgainstBizPlan.push("사업계획");
	                    }
	                    else if(codeNm=='SALES_RESULT')
	                    {
	                        codeNmArrSalesResultAgainstBizPlan.push("출하실적");
	                    }
	                    else if(codeNm=='BILL_ORDER_RESULT'){
	                    	codeNmArrSalesResultAgainstBizPlan.push("매출실적");
	                    }
	                }
	                
	                if(flagSort == 1){
	                    lineData1SalesResultAgainstBizPlan.push({name: lineNm, y: resultValue, color: "#6495ED"});
	                }else if(flagSort == 2){
	                    lineData2SalesResultAgainstBizPlan.push({name: lineNm, y: resultValue, color: "#DC143C"});
	                }else if(flagSort == 3){
	                	lineData3SalesResultAgainstBizPlan.push({name: lineNm, y: resultValue, color: "#ce9ffc"});
	                }
	            });
	            
	            // GAP1 계산: 출하실적 - 사업계획
	            // GAP2 계산: 매출실적 - 사업계획
	            var GAP1 = '';
	            var GAP1_temp = Math.round(latest_SALES_RESULT - latest_BIZ_PLAN);
	            if((latest_SALES_RESULT - latest_BIZ_PLAN) > 0)
	            {
	            	GAP1  = 'GAP: +'+''+String(GAP1_temp);
	            }
	            else if((latest_SALES_RESULT - latest_BIZ_PLAN) == 0)
	            {
	                GAP1  = 'GAP: '+''+String(GAP1_temp);
	            }
	            else
	            {
	                GAP1  = 'GAP: '+''+String(GAP1_temp);
	            }
	            var GAP2 = '';
	            var GAP2_temp = Math.round(latest_BILL_ORDER_RESULT - latest_BIZ_PLAN);
	            if((latest_BILL_ORDER_RESULT - latest_BIZ_PLAN) > 0)
	            {
	            	GAP2  = 'GAP: +'+''+String(GAP2_temp);
	            }
	            else if((latest_BILL_ORDER_RESULT - latest_BIZ_PLAN) == 0)
	            {
	                GAP2  = 'GAP: '+''+String(GAP2_temp);
	            }
	            else
	            {
	                GAP2  = 'GAP: '+''+String(GAP2_temp);
	            }
	            
	            
	            var chartIdSalesResultAgainstBizPlan = "salesResultAgainstBizPlanChart";
	            Highcharts.chart(chartIdSalesResultAgainstBizPlan, {
	                
	                xAxis: { type: 'category' },
	                plotOptions: {
	                    column: {
	                        stacking: 'normal'
	                    },
	                    series: {
	                        dataLabels: {
	                            allowOverlap : true,
	                            enabled: true
	                        },
	                        cursor: 'pointer',
	                        events: {
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
	                
	                yAxis: [{ // left yAxis
	                    stackLabels: {
	                        //allowOverlap : true, //total 안나올때 옵션 주는거
	                        //enabled: true
	                    }
	                }, { // right yAxis
	                    stackLabels: {
	                        //allowOverlap : true, //total 안나올때 옵션 주는거
	                        //enabled: false
	                    }
	                }],
	                series: [
	                {
	                        data: lineData1SalesResultAgainstBizPlan,
	                        type: 'line',
	                        name: codeNmArrSalesResultAgainstBizPlan[0],
	                        yAxis: 1,
	                        color: "#6495ED"
	                    }, {
	                        data: lineData2SalesResultAgainstBizPlan,
	                        type: 'line',
	                        name: codeNmArrSalesResultAgainstBizPlan[1],
	                        yAxis: 1,
	                        color: "#DC143C"
	                    },
	                {
	                        data: lineData3SalesResultAgainstBizPlan,
	                        type: 'line',
	                        name: codeNmArrSalesResultAgainstBizPlan[2],
	                        yAxis: 1,
	                        color: "#ce9ffc"
                	}
	                ]
	            },function(chart){
	            	

	                // 							            이 위치가 label이 들어가는 위치
	                var point = chart.series[0].points[6];
	                
	             	var pxX = chart.xAxis[0].toPixels(point.x, true);
	                var pxY = chart.yAxis[0].toPixels(point.y, true);
	                
	                chart.renderer.label('출하실적 '+GAP1+'<br/>'+'매출실적 '+GAP2, pxX, pxY, 'callout', point.plotX + chart.plotLeft, point.plotY + chart.plotTop)
	                    .css({
	                        color: '#FFFFFF',
	                        fontSize:'40px'
	                    })
	                    .attr({
	                        fill: 'rgba(140,190,214,0.75)',
	                        padding: 8,
	                        r: 5,
	                        zIndex: 6
	                    })
	                    .add();
	                
	                
	            	
	            });
	            
				
				
				
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
						}// end of events
					}//end of series
				},//end of plotOptions
			};//end of chart
			
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
				minRange: 1,
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
					<c:when test="${popupChartDemend.chartId == 'cpfrTrend'}">
					<h4 id="title" style="font-size: 30px;padding-bottom:10px;">${popupChartDemend.title} </h4>
					</c:when>
					<c:when test="${popupChartDemend.chartId == 'chart8'}">
					<h4 id="chart8_title" style="font-size: 30px;padding-bottom:10px;">${popupChartDemend.title}</h4>
					</c:when>
					
					<c:when test="${popupChartDemend.chartId == 'demandForecastChart'}">
					<h4 id="demandForecastH4" style="font-size: 30px;padding-bottom:10px;">${popupChartDemend.title}</h4>
					</c:when>
					<c:when test="${popupChartDemend.chartId == 'salesResultAgainstBizPlan'}">
                    <h4 id="title" style="font-size: 30px;">${popupChartDemend.title}</h4>
                    </c:when>
                    
					
					<c:otherwise>
					<h4 id="title" style="font-size: 30px;">${popupChartDemend.title} </h4>
					</c:otherwise>
					</c:choose>
					<c:choose>
						<c:when test="${popupChartDemend.chartId == 'chart10'}">
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
						<c:when test="${popupChartDemend.chartId == 'chart11'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="salesFcst1" name="salesFcst" value="cust" > <label for="salesFcst1"><spring:message code="lbl.reptCust" /></label></li>
								<li><input type="radio" id="salesFcst2" name="salesFcst" value="total" checked="checked"> <label for="salesFcst2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart11"></div>
						</c:when>
						<c:when test="${popupChartDemend.chartId == 'chart12'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="achivRt1" name="achivRt" value="cust" > <label for="achivRt1"><spring:message code="lbl.reptCust" /></label></li>
								<li><input type="radio" id="achivRt2" name="achivRt" value="total" checked="checked"> <label for="achivRt2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart12"></div>
						</c:when>
						<c:when test="${popupChartDemend.chartId == 'chart23'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="chart23Cust" name="chart23Radio" value="cust" checked="checked"/> <label for="chart23Cust"><spring:message code="lbl.reptCust" /></label></li>
								<li><input type="radio" id="chart23Prod" name="chart23Radio" value="prod" /> <label for="chart23Prod"><spring:message code="lbl.prodCate" /></label></li>
								<li><input type="radio" id="chart23Tot" name="chart23Radio" value="total"/> <label for="chart23Tot"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart23"></div>
						</c:when>
						<c:when test="${popupChartDemend.chartId == 'chart24'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="chart24_weekMonth_type1" name="chart24_weekMonth_type" value="WEEK"/> <label for="chart24_weekMonth_type1"><spring:message code="lbl.weekly" /></label></li>
								<li><input type="radio" id="chart24_weekMonth_type2" name="chart24_weekMonth_type" value="MONTH" checked="checked"/> <label for="chart24_weekMonth_type2"><spring:message code="lbl.month2" /></label></li>
							
								<li><input type="radio" id="chart24_type1" name="chart24_type" value="cust" > <label for="chart24_type1"><spring:message code="lbl.reptCust" /></label></li>
								<li><input type="radio" id="chart24_type3" name="chart24_type" value="prod" /> <label for="chart24_type3"><spring:message code="lbl.prodCate" /></label></li>
								<li><input type="radio" id="chart24_type2" name="chart24_type" value="total" checked="checked"> <label for="chart24_type2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart24"></div>
						</c:when>
						<c:when test="${popupChartDemend.chartId == 'chart2'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="chart2_weekMonth_type1" name="chart2_weekMonth_type" value="WEEK"/> <label for="chart2_weekMonth_type1"><spring:message code="lbl.weekly" /></label></li>
								<li><input type="radio" id="chart2_weekMonth_type2" name="chart2_weekMonth_type" value="MONTH" checked="checked"/> <label for="chart2_weekMonth_type2"><spring:message code="lbl.month2" /></label></li>
							
								<li><input type="radio" id="chart2_type1" name="chart2_type" value="cust" > <label for="chart2_type1"><spring:message code="lbl.reptCust" /></label></li>
								<li><input type="radio" id="chart2_type3" name="chart2_type" value="prod" /> <label for="chart2_type3"><spring:message code="lbl.prodCate" /></label></li>
								<li><input type="radio" id="chart2_type2" name="chart2_type" value="total" checked="checked"> <label for="chart2_type2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart2"></div>
						</c:when>
						<c:when test="${popupChartDemend.chartId == 'operProfit'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="operProfitCust" name="operProfitType" value="cust" /> <label for="operProfitCust"><spring:message code="lbl.reptCust" /></label></li>
								<li><input type="radio" id="operProfitProd" name="operProfitType" value="prod" /> <label for="operProfitProd"><spring:message code="lbl.prodCate" /></label></li>
								<li><input type="radio" id="operProfitTotal" name="operProfitType" value="total" checked="checked"/> <label for="operProfitTotal"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="operProfit"></div>
						</c:when>
						<c:when test="${popupChartDemend.chartId == 'cpfrTrend'}">
						<div class="view_combo" style="float: right;">
						</div>
						<table>
							<tbody id="cpfrTbody">
							</tbody>
						</table>
						</c:when>
						
						<c:when test="${popupChartDemend.chartId == 'avgShipPriceChart'}">
						<div class="view_combo" style="float: right;">
						</div>
						<div style="height: 88%" id="avgShipPriceChart" ></div>
						</c:when>
						
						
						<c:when test="${popupChartDemend.chartId == 'lamConTrendChart'}">
						<div class="view_combo" style="float: right;">
						</div>
						<div style="height: 88%" id="lamConTrendChart" ></div>
						</c:when>
						
						
						<c:when test="${popupChartDemend.chartId == 'salesResultAgainstBizPlan'}">
                        <div class="view_combo" style="float: right;">
                        </div>
                        <div style="height: 88%" id="salesResultAgainstBizPlanChart" ></div>
                        </c:when>
                        
						
						<c:when test="${popupChartDemend.chartId == 'chart8'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="companyCons1" name="companyCons" value="companyCons"/> <label for="companyCons1"><spring:message code="lbl.companyCons" /></label></li>
								<li><input type="radio" id="companyCons2" name="companyCons" value="company" checked="checked"/> <label for="companyCons2"><spring:message code="lbl.company2" /> </label></li>
								<li><input type="radio" id="trend5_weekMonth_type1" name="trend5_weekMonth_type" value="WEEK" checked="checked"/> <label for="trend5_weekMonth_type1"><spring:message code="lbl.weekly" /></label></li>
								<li><input type="radio" id="trend5_weekMonth_type2" name="trend5_weekMonth_type" value="MONTH"/> <label for="trend5_weekMonth_type2"><spring:message code="lbl.month2" /></label></li>
								<li><input type="radio" id="trend5_type1" name="trend5_type" value="COST"> <label for="trend5_type1"><spring:message code="lbl.costChart" /></label></li>
								<li><input type="radio" id="trend5_type2" name="trend5_type" value="PRICE" checked="checked"/><label for="trend5_type2"><spring:message code="lbl.amtChart" /></label></li>
								<li><input type="radio" id="trend5_amt" name="trend5" value="amt" checked="checked"/><label for="trend5_amt"><spring:message code="lbl.amt" /></label></li>
								<li><input type="radio" id="trend5_day" name="trend5" value="day"/><label for="trend5_day"><spring:message code="lbl.days" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart8"></div>
						</c:when>
						
						<c:when test="${popupChartDemend.chartId == 'demandForecastChart'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="demandForecastWeekMonth1" name="demandForecastWeekMonth" value="WEEK"/> <label for="demandForecastWeekMonth1"><spring:message code="lbl.weekly" /></label></li>
								<li><input type="radio" id="demandForecastWeekMonth2" name="demandForecastWeekMonth" value="MONTH" checked="checked"/> <label for="demandForecastWeekMonth2"><spring:message code="lbl.month2" /></label></li>
								<li><input type="radio" id="demandForecastType1" name="demandForecastType" value="salesTeam"/><label for="demandForecastType1"><spring:message code="lbl.prodCate" /></label></li>
								<li><input type="radio" id="demandForecastType2" name="demandForecastType" value="repCust" checked="checked"/><label for="demandForecastType2"><spring:message code="lbl.reptCust" /> </label></li>
								<li><input type="radio" id="demandForecastType3" name="demandForecastType" value="total"/><label for="demandForecastType3"><spring:message code="lbl.total" /></label></li>
								<li><input type="radio" id="demandForecastAmtQty1" name="demandForecastAmtQty" value="AMT" checked="checked"/><label for="demandForecastAmtQty1"><spring:message code="lbl.amt" /></label></li>
								<li><input type="radio" id="demandForecastAmtQty2" name="demandForecastAmtQty" value="QTY"/><label for="demandForecastAmtQty2"><spring:message code="lbl.qty" /> </label></li>
								
								<li><input type="radio" id="dmdSeries1" name="dmdSeries" value="DMD1"/><label for="dmdSeries1"><spring:message code="lbl.dmd1" /> </label></li>
								<li><input type="radio" id="dmdSeries2" name="dmdSeries" value="DMD2"/><label for="dmdSeries2"><spring:message code="lbl.dmd2" /> </label></li>
								<li><input type="radio" id="dmdSeries3" name="dmdSeries" value="DMD3"/><label for="dmdSeries3"><spring:message code="lbl.dmd3" /> </label></li>
								<li><input type="radio" id="dmdSeries4" name="dmdSeries" value="DMD_TOTAL" checked="checked"/><label for="dmdSeries4"><spring:message code="lbl.dmdTotal" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="demandForecastChart" ></div>
						</c:when>
						
						<c:when test="${popupChartDemend.chartId == 'invRateInfoChart'}">
						<div class="view_combo" style="float: right;">
						</div>
						<div style="height: 88%" id="invRateInfoChart" ></div>
						</c:when>
						
						<c:when test="${popupChartDemend.chartId == 'onTimeDeliveryChart'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="onTimeDeliveryType1" name="onTimeDeliveryType" value="repCust" checked="checked"/><label for="onTimeDeliveryType1"><spring:message code="lbl.reptCust" /> </label></li>
								<li><input type="radio" id="onTimeDeliveryType2" name="onTimeDeliveryType" value="total"/><label for="onTimeDeliveryType2"><spring:message code="lbl.total" /></label></li>
							</ul>
						</div>
						<div style="height: 88%" id="onTimeDeliveryChart" ></div>
						</c:when>
						<c:when test="${popupChartDemend.chartId == 'cpfrShipPlanResultChart'}">
						
					
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
							</ul>
						</div>
						<div style="height: 88%" id="cpfrShipPlanResultChart"></div>
						
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