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
	var trend2 = {

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
			$(':radio[name=sales]').on('change', function () {
				trend2.salesSearch(false);
			});
			$(':radio[name=salesInv]').on('change', function () {
				trend2.salesSearch(false);
			});
			
			$(':radio[name=salesFcst]').on('change', function () {
				trend2.salesFcstSearch(false);
			});
			
			$(':radio[name=achivRt]').on('change', function () {
				trend2.achivRtSearch(false);
			});
			
			$(':radio[name=prodRate]').on('change', function () {
				trend2.prodRateSearch(false);
			});
			
			$(':radio[name=prodRateWeek]').on('change', function () {
				trend2.prodRateSearch(false);
			});
			
			$(':radio[name=trend19]').on('change', function () {
				trend2.trend19Search(false);
			});
			
			$(':radio[name=trend20]').on('change', function () {
				trend2.trend20Search(false);
			});
			
			$(':radio[name=prepAvail]').on('change', function () {
				trend2.trend17Search(false);
			});
			$(':radio[name=proTypeTotal]').on('change', function () {
				trend2.trend17Search(false);
			});
			
			$(':radio[name=chart18WeekMonth]').on('change', function () {
				trend2.trend18Search(false);
			});
			$(':radio[name=chart18ProTypeTotal]').on('change', function () {
				trend2.trend18Search(false);
			});
			
			// 타이틀 클릭시 메뉴 이동
			var arrTitle = $("h4");
	    	
			$.each(arrTitle, function(n,v) {
	    		$(v).css("cursor", "pointer");
	    		$(v).on("click", function() { 
	    			if (n == 0) gfn_newTab("SNOP301");
	    			else if (n == 1) gfn_newTab("SNOP302");
	    			else if (n == 2) gfn_newTab("SNOP303");
	    			else if (n == 3) gfn_newTab("SNOP304");
	    			else if (n == 4) gfn_newTab("MP110");
	    			else if (n == 5) gfn_newTab("MP110");
	    			else if (n == 6) gfn_newTab("MP205");
	    			else if (n == 7) gfn_newTab("SNOP305");
	    			else if (n == 8) gfn_newTab("MP201");
	    		});
	    	});
		},
		
		
		bucket : null,
		
		initSearch : function (sqlFlag) {
			FORM_SEARCH = {}
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.tranData = [{ outDs : "week"  , _siq : trend2._siq + "trendBucketWeek" }
								  , { outDs : "month" , _siq : trend2._siq + "trendBucketMonth" }];
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					trend2.bucket = {};
					trend2.bucket.week  = data.week;
					trend2.bucket.month = data.month;
					
					trend2.search();
				}
			}
			gfn_service(sMap, "obj");
		},
		
		search : function (sqlFlag) {
			
			FORM_SEARCH            = {};
			FORM_SEARCH            = this.bucket;
			FORM_SEARCH.sales      = $(':radio[name=sales]:checked').val();
			FORM_SEARCH.salesInv = $(':radio[name=salesInv]:checked').val();
			FORM_SEARCH.salesFcst  = $(':radio[name=salesFcst]:checked').val();
			FORM_SEARCH.achivRt    = $(':radio[name=achivRt]:checked').val();
			FORM_SEARCH.prodRate   = $(':radio[name=prodRate]:checked').val();
			FORM_SEARCH.prodRateWeek   = $(':radio[name=prodRateWeek]:checked').val();
			FORM_SEARCH.trend19    = $(':radio[name=trend19]:checked').val();
			FORM_SEARCH.trend20    = $(':radio[name=trend20]:checked').val();
			FORM_SEARCH.prepAvail  = $(':radio[name=prepAvail]:checked').val();
			FORM_SEARCH.proTypeTotal = $(':radio[name=proTypeTotal]:checked').val();
			FORM_SEARCH.chart18WeekMonth  = $(':radio[name=chart18WeekMonth]:checked').val();
			FORM_SEARCH.chart18ProTypeTotal = $(':radio[name=chart18ProTypeTotal]:checked').val();
			FORM_SEARCH._mtd       = "getList";
			FORM_SEARCH.sql        = sqlFlag;
			FORM_SEARCH.unit       = unit;
			FORM_SEARCH.tranData   = 
				[
					{ outDs : "chart10" , _siq : trend2._siq + "chart10" },
					{ outDs : "chart11" , _siq : trend2._siq + "chart11" },
					{ outDs : "chart12" , _siq : trend2._siq + "chart12" },
					{ outDs : "chart13" , _siq : trend2._siq + "chart13" },
					{ outDs : "chart14" , _siq : trend2._siq + "chart14" },
					{ outDs : "chart15" , _siq : trend2._siq + "chart15" },
					{ outDs : "chart16" , _siq : trend2._siq + "chart16" },
					{ outDs : "chart17" , _siq : trend2._siq + "chart17" },
					{ outDs : "chart18" , _siq : trend2._siq + "chart18" }
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					trend2.drawChart(data);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		salesSearch : function(sqlFlag) {
			FORM_SEARCH          = {}
			FORM_SEARCH          = trend2.bucket;
			FORM_SEARCH.sales    = $(':radio[name=sales]:checked').val();
			FORM_SEARCH.salesInv = $(':radio[name=salesInv]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = 
				[
					{ outDs : "chart10" , _siq : trend2._siq + "chart10" } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arPreWeek = new Array();
			
					$.each (trend2.bucket.week, function (i, el) {
						arPreWeek.push(el.PRE_DISWEEK);
					});
					
					var chart10 = JSON.parse(data.chart10[0].SALES_CML);
					
					trend2.chartGen('chart10', 'line', arPreWeek, chart10);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		salesFcstSearch : function(sqlFlag) {
			FORM_SEARCH           = {}
			FORM_SEARCH           = trend2.bucket;
			FORM_SEARCH.salesFcst = $(':radio[name=salesFcst]:checked').val();
			FORM_SEARCH._mtd      = "getList";
			FORM_SEARCH.sql       = sqlFlag;
			FORM_SEARCH.tranData  = 
				[
					{ outDs : "chart11" , _siq : trend2._siq + "chart11" } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arPreMonth = new Array();
					
					$.each (trend2.bucket.month, function (i, el) {
						arPreMonth.push(el.PRE_DISMONTH);
					});
					
					var chart11   = JSON.parse(data.chart11[0].SALES_FCST);

					trend2.chartGen('chart11', 'line', arPreMonth, chart11);
				}
			}
			gfn_service(sMap,"obj");
		}, 
		
		achivRtSearch : function(sqlFlag) {
			FORM_SEARCH          = {}
			FORM_SEARCH          = trend2.bucket;
			FORM_SEARCH.achivRt  = $(':radio[name=achivRt]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = 
				[
					{ outDs : "chart12" , _siq : trend2._siq + "chart12" } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arPreMonth = new Array();
					
					$.each (trend2.bucket.month, function (i, el) {
						arPreMonth.push(el.PRE_DISMONTH);
					});
					
					var chart12     = JSON.parse(data.chart12[0].ACHIV_RT);

					trend2.chartGen('chart12', 'line', arPreMonth, chart12);
				}
			}
			gfn_service(sMap,"obj");
		}, 
		
		prodRateSearch : function(sqlFlag) {
			FORM_SEARCH          = {}
			FORM_SEARCH          = trend2.bucket;
			FORM_SEARCH.prodRate = $(':radio[name=prodRate]:checked').val();
			FORM_SEARCH.prodRateWeek = $(':radio[name=prodRateWeek]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = 
				[
					{ outDs : "chart13" , _siq : trend2._siq + "chart13" } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arWeek = new Array();
			
					$.each (trend2.bucket.week, function (i, el) {
						arWeek.push(el.DISWEEK);
					});
					
					var chart13     = JSON.parse(data.chart13[0].PROD_CML);

					trend2.chartGen('chart13', 'line', arWeek, chart13);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		trend19Search : function(sqlFlag) {
			FORM_SEARCH          = {}
			FORM_SEARCH          = trend2.bucket;
			FORM_SEARCH.trend19  = $(':radio[name=trend19]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = 
				[
					{ outDs : "chart14" , _siq : trend2._siq + "chart14" } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arPreMonth = new Array();
					
					$.each (trend2.bucket.month, function (i, el) {
						arPreMonth.push(el.PRE_DISMONTH);
					});
					
					var chart14     = JSON.parse(data.chart14[0].TREND19);

					trend2.chartGen('chart14', 'line', arPreMonth, chart14);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		trend20Search : function(sqlFlag) {
			FORM_SEARCH          = {}
			FORM_SEARCH          = trend2.bucket;
			FORM_SEARCH.trend20  = $(':radio[name=trend20]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = 
				[
					{ outDs : "chart15" , _siq : trend2._siq + "chart15" } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arPreMonth = new Array();
					
					$.each (trend2.bucket.month, function (i, el) {
						arPreMonth.push(el.PRE_DISMONTH);
					});
					
					var chart15     = JSON.parse(data.chart15[0].TREND20);

					trend2.chartGen('chart15', 'line', arPreMonth, chart15);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		trend17Search : function(sqlFlag) {
			FORM_SEARCH          = {}
			FORM_SEARCH          = trend2.bucket;
			FORM_SEARCH.prepAvail  = $(':radio[name=prepAvail]:checked').val();
			FORM_SEARCH.proTypeTotal = $(':radio[name=proTypeTotal]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = 
				[
					{ outDs : "chart17" , _siq : trend2._siq + "chart17" } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arPreWeek = new Array();
			
					$.each (trend2.bucket.week, function (i, el) {
						arPreWeek.push(el.PRE_DISWEEK);
					});
					
					var chart17 = JSON.parse(data.chart17[0].ITEM);

					trend2.chartGen('chart17', 'line', arPreWeek, chart17);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		
		trend18Search : function(sqlFlag) {
			FORM_SEARCH          = {}
			FORM_SEARCH          = trend2.bucket;
			FORM_SEARCH.chart18WeekMonth  = $(':radio[name=chart18WeekMonth]:checked').val();
			FORM_SEARCH.chart18ProTypeTotal = $(':radio[name=chart18ProTypeTotal]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "chart18" , _siq : trend2._siq + "chart18" }
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					var arPreWeek = new Array();
					var arPreMonth = new Array();
			
					$.each (trend2.bucket.week, function (i, el) {
						arPreWeek.push(el.PRE_DISWEEK);
					});
					
					$.each (trend2.bucket.month, function (i, el) {
						arPreMonth.push(el.PRE_DISMONTH);
					});
					
					var chart18 = JSON.parse(data.chart18[0].CAPA);
					
					if(FORM_SEARCH.chart18WeekMonth == "week"){
						trend2.chartGen('chart18', 'line', arPreWeek, chart18);
					}else{
						trend2.chartGen('chart18', 'line', arPreMonth, chart18);
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
			
			$.each (trend2.bucket.month, function (i, el) {
				arMonth.push(el.DISMONTH);
				arPreMonth.push(el.PRE_DISMONTH);
			});
			
			$.each (trend2.bucket.week, function (i, el) {
				arWeek.push(el.DISWEEK);
				arPreWeek.push(el.PRE_DISWEEK);
			});
			
			var chart10 = JSON.parse(res.chart10[0].SALES_CML);
			var chart11 = JSON.parse(res.chart11[0].SALES_FCST);
			var chart12 = JSON.parse(res.chart12[0].ACHIV_RT);
			var chart13 = JSON.parse(res.chart13[0].PROD_CML);
			var chart14 = JSON.parse(res.chart14[0].TREND19);
			var chart15 = JSON.parse(res.chart15[0].TREND20);
			var chart16 = JSON.parse(res.chart16[0].TREND21);
			var chart17 = JSON.parse(res.chart17[0].ITEM);
			var chart18 = JSON.parse(res.chart18[0].CAPA);
			
			
			this.tagetStyle(chart17);
			
			this.chartGen('chart10', 'line', arPreWeek  , chart10);
			this.chartGen('chart11', 'line', arPreMonth , chart11);
			this.chartGen('chart12', 'line', arPreMonth , chart12);
			this.chartGen('chart13', 'line', arWeek  , chart13);
			this.chartGen('chart14', 'line', arPreMonth , chart14);
			this.chartGen('chart15', 'line', arPreMonth , chart15);
			this.chartGen('chart16', 'line', arPreWeek  , chart16);
			this.chartGen('chart17', 'line', arPreWeek , chart17);
			this.chartGen('chart18', 'line', arPreWeek , chart18); 
			
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
		
		
		chartGen : function (chartId, type, arCarte, arData) {
			
			var chart = {
				chart  : { type : type },
				xAxis  : { categories : arCarte },
				series : arData,
				plotOptions: {
					series: {
						cursor: 'pointer',
						point: {
							events: {
								click: function() {
									if(chartId == "chart10") {
										gfn_comPopupOpen("POPUP_CHART", {
											rootUrl   : "dashboard",
											url       : "popup_chart",
											width     : 1920,
											height    : 1060,
											menuCd    : "SNOP100",
											chartId   : "chart10",
											title     : "<spring:message code='lbl.salesCmplRateChart2' /> (%)"
										});
									} else if(chartId == "chart11") {
										gfn_comPopupOpen("POPUP_CHART", {
											rootUrl   : "dashboard",
											url       : "popup_chart",
											width     : 1920,
											height    : 1060,
											menuCd    : "SNOP100",
											chartId   : "chart11",
											title     : "<spring:message code='lbl.salesHittingRation' /> (%)"
										});
									} else if(chartId == "chart12") {
										gfn_comPopupOpen("POPUP_CHART", {
											rootUrl   : "dashboard",
											url       : "popup_chart",
											width     : 1920,
											height    : 1060,
											menuCd    : "SNOP100",
											chartId   : "chart12",
											title     : "<spring:message code='lbl.achieRateChart4'/> (M+3) (%)"
										});	
									} else if(chartId == "chart13") {
										gfn_comPopupOpen("POPUP_CHART", {
											rootUrl   : "dashboard",
											url       : "popup_chart",
											width     : 1920,
											height    : 1060,
											menuCd    : "SNOP100",
											chartId   : "chart13",
											title     : "<spring:message code='lbl.prodCmplRateChart2' /> (%)"
										});	
									} else if(chartId == "chart14") {
										gfn_comPopupOpen("POPUP_CHART", {
											rootUrl   : "dashboard",
											url       : "popup_chart",
											width     : 1920,
											height    : 1060,
											menuCd    : "SNOP100",
											chartId   : "chart14",
											title     : "<spring:message code='lbl.timeProd' /> (<spring:message code='lbl.thousand' />)"
										});	
									} else if(chartId == "chart15") {
										gfn_comPopupOpen("POPUP_CHART", {
											rootUrl   : "dashboard",
											url       : "popup_chart",
											width     : 1920,
											height    : 1060,
											menuCd    : "SNOP100",
											chartId   : "chart15",
											title     : "<spring:message code='lbl.peopleProd' /> (<spring:message code='lbl.hMillion' />)"
										});
									} else if(chartId == "chart16") {
										gfn_comPopupOpen("POPUP_CHART", {
											rootUrl   : "dashboard",
											url       : "popup_chart",
											width     : 1920,
											height    : 1060,
											menuCd    : "SNOP100",
											chartId   : "chart16",
											title     : "<spring:message code='lbl.trend21Chart' /> (%)"
										});	
									} else if(chartId == "chart17") {
										gfn_comPopupOpen("POPUP_CHART", {
											rootUrl   : "dashboard",
											url       : "popup_chart",
											width     : 1920,
											height    : 1060,
											menuCd    : "SNOP100",
											chartId   : "chart17",
											title     : "<spring:message code='lbl.mprChart' /> (%)"
										});	
									} else if(chartId == "chart18") {
										gfn_comPopupOpen("POPUP_CHART", {
											rootUrl   : "dashboard",
											url       : "popup_chart",
											width     : 1920,
											height    : 1060,
											menuCd    : "SNOP100",
											chartId   : "chart18",
											title     : "<spring:message code='lbl.trend17Chart' /> (%)"
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
		
		trend2.search(sqlFlag);
	}
	
 	// onload 
	$(document).ready(function() {
		trend2.init();
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
					<div class="col_3" >
						<h4><spring:message code="lbl.salesCmplRateChart2" /> (%)</h4>
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="salesInv1" name="salesInv" value="inv" checked="checked"/><label for="salesInv1"><spring:message code="lbl.salesInvY" /></label></li>
								<li><input type="radio" id="salesInv2" name="salesInv" value="noInv"/> <label for="salesInv2"><spring:message code="lbl.salesInvN" /> </label></li>
								<li><input type="radio" id="sales1" name="sales" value="cust"/> <label for="sales1"><spring:message code="lbl.reptCust" /></label></li>
								<li><input type="radio" id="sales2" name="sales" value="total" checked="checked"/> <label for="sales2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart10" ></div>
					</div>
					
					<div class="col_3">
						<h4><spring:message code="lbl.salesHittingRation" /> (%)</h4>
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="salesFcst1" name="salesFcst" value="cust"/> <label for="salesFcst1"><spring:message code="lbl.reptCust" /></label></li>
								<li><input type="radio" id="salesFcst2" name="salesFcst" value="total" checked="checked"/> <label for="salesFcst2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart11"></div>
					</div>
					
					<div class="col_3">
						<h4><spring:message code="lbl.achieRateChart4"/> (M+3) (%)</h4>
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="achivRt1" name="achivRt" value="cust"/> <label for="achivRt1"><spring:message code="lbl.reptCust" /></label></li>
								<li><input type="radio" id="achivRt2" name="achivRt" value="total" checked="checked"/> <label for="achivRt2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart12"></div>
					</div>
					
					<div class="col_3">
						<h4><spring:message code="lbl.prodCmplRateChart2" /> (%)</h4>
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="prodRateWeek1" name="prodRateWeek" value="std" checked="checked"/> <label for="prodRateWeek1"><spring:message code="lbl.stdWeek" /></label></li>
								<li><input type="radio" id="prodRateWeek2" name="prodRateWeek" value="sales"/> <label for="prodRateWeek2"><spring:message code="lbl.salesWeek" /> </label></li>
								<li><input type="radio" id="prodRate1" name="prodRate" value="item"/> <label for="prodRate1"><spring:message code="lbl.part" /></label></li>
								<li><input type="radio" id="prodRate2" name="prodRate" value="total" checked="checked"/> <label for="prodRate2"><spring:message code="lbl.itemTotal" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart13" ></div>
					</div>
					
					<div class="col_3">
						<h4><spring:message code="lbl.timeProd" /> (<spring:message code="lbl.thousand" />)</h4>
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="trend19_part" name="trend19" value="part"/> <label for="trend19_part"><spring:message code="lbl.part" /></label></li>
								<li><input type="radio" id="trend19_total" name="trend19" value="total" checked="checked"/> <label for="trend19_total"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart14"></div>
					</div>
					
					<div class="col_3">
						<h4><spring:message code="lbl.peopleProd" /> (<spring:message code="lbl.hMillion" />)</h4>
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="trend20_part" name="trend20" value="part"/> <label for="trend20_part"><spring:message code="lbl.part" /></label></li>
								<li><input type="radio" id="trend20_total" name="trend20" value="total" checked="checked"/> <label for="trend20_total"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart15"></div>
					</div>
					
					<div class="col_3">
						<h4><spring:message code="lbl.trend21Chart" /> (%)</h4>
						<div style="height: 100%" id="chart16"></div>
					</div>
					
					<div class="col_3">
						<h4><spring:message code="lbl.mprChart" /> (%)</h4>
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="prepAvail1" name="prepAvail" value="prep" checked="checked"/><label for="prepAvail1"><spring:message code="lbl.mprChart" /></label></li>
								<li><input type="radio" id="prepAvail2" name="prepAvail" value="avail"/><label for="prepAvail2"><spring:message code="lbl.availableRate" /> </label></li>
								<li><input type="radio" id="proTypeTotal1" name="proTypeTotal" value="proType"/><label for="proTypeTotal1"><spring:message code="lbl.procureType" /></label></li>
								<li><input type="radio" id="proTypeTotal2" name="proTypeTotal" value="total" checked="checked"/><label for="proTypeTotal2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart17" ></div>
					</div>
					
					<div class="col_3">
						<h4><spring:message code="lbl.trend17Chart" /> (%)</h4>
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="chart18WeekMonth1" name="chart18WeekMonth" value="week" checked="checked"/><label for="chart18WeekMonth1"><spring:message code="lbl.weekly" /></label></li>
								<li><input type="radio" id="chart18WeekMonth2" name="chart18WeekMonth" value="month"/><label for="chart18WeekMonth2"><spring:message code="lbl.month2" /> </label></li>
								<li><input type="radio" id="chart18ProTypeTotal1" name="chart18ProTypeTotal" value="proType"/><label for="chart18ProTypeTotal1"><spring:message code="lbl.procureType" /></label></li>
								<li><input type="radio" id="chart18ProTypeTotal2" name="chart18ProTypeTotal" value="total" checked="checked"/><label for="chart18ProTypeTotal2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart18"></div>
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
