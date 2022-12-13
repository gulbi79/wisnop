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
	}
</style>

<script type="text/javascript">

	
	var unit = 0;
	var unit2 = 0;
	
	var popupChart = {

		init : function () {
			
			this.comCode.initCode();
			this.initFilter();
			this.initSearch();
			this.events();
			
			var userLang = "${sessionScope.GV_LANG}";
			
			if(userLang == "ko") {
	    		unit = 100000000;
	    		unit2 = 1000000;
	    	} else if(userLang == "en" || userLang == "cn") {
	    		unit = 1000000000;
	    		unit2 = 1000000;
	    	}
		},
		
		initFilter : function() {
			
			// 콤보박스
			gfn_setMsComboAll([
				{target : 'divEquipRate', id : 'equipRate', title : '', data : this.comCode.codeMap.STD_WORK_HOUR, exData:[""], type : "R"},
			]);
			
			$.each(this.comCode.codeMap.STD_WORK_HOUR, function(i, val){
				var codeCd = val.CODE_CD;
				var attb2Cd = val.ATTB_2_CD;
				
				if(attb2Cd == "Y"){
					$(':radio[name=equipRate]:input[value="'+ codeCd +'"]').attr("checked", true);
					return false;
				}
			});
		},
		
		comCode : {
			
			codeMap : null,
			
			initCode  : function () {
				var grpCd = 'STD_WORK_HOUR';
				this.codeMap = gfn_getComCode(grpCd, 'N'); //공통코드 조회
			}
		},
	
		_siq	: "dashboard.supplyTrend.",
		chart_id : "${popupChartSupplyTrend.chartId}",
		
		events : function () {
			
			$("#btnClose").on("click", function(){
				window.close(); 
			});
			
			$(':radio[name=key]').on('change', function () {
				popupChart.defactSearch(false);
			});
			
			$(':radio[name=firstAs]').on('change', function () {
				popupChart.defactSearch(false);
			});
			
			//SCRP
			$(':radio[name=chart22_type]').on('change', function () {
				popupChart.chart22Search(false);
			});
			
			//SCRAP
			$(':radio[name=chart22_weekMonth_type]').on('change', function () {
				popupChart.chart22Search(false);
			});
			
			
			$(':radio[name=prod]').on('change', function () {
				popupChart.prodSearch(false);
			});
			
			$(':radio[name=prodRate]').on('change', function () {
				popupChart.prodRateSearch(false);
			});
			
			$(':radio[name=prodRateWeek]').on('change', function () {
				popupChart.prodRateSearch(false);
			});
			
			$(':radio[name=agingTrend]').on('change', function () {
				popupChart.agingTrendSearch(false);
			});
			
			$(':radio[name=wip]').on('change', function () {
				popupChart.wipSearch(false);
			});
			
			$(':radio[name=amtRate]').on('change', function () {
				popupChart.wipSearch(false);
			});
			
			$(':radio[name=trend22]').on('change', function () {
				popupChart.trend22Search(false);
			});
			
			$(':radio[name=timePeople]').on('change', function () {
				popupChart.productChartSearch(false);
			});
			
			$(':radio[name=productPartTotal]').on('change', function () {
				popupChart.productChartSearch(false);
			});
			
			$(':radio[name=equipRate]').on('change', function () {
				popupChart.equipRateChartSearch(false);
			});
			
			$(':radio[name=urgentCntQtyAmt]').on('change', function () {
				popupChart.urgentInsertInfoChartSearch(false);
			});
			
			$(':radio[name=urgentRepCustTotal]').on('change', function () {
				popupChart.urgentInsertInfoChartSearch(false);
			});
			
			$(':radio[name=workRepCustTotal]').on('change', function () {
				popupChart.workInfoChartSearch(false);
			});
			
			$(':radio[name=inSemiItemCntQty]').on('change', function () {
				popupChart.inSemiItemChartSearch(false);
			});
			
			$(':radio[name=inSemiItemOhMh]').on('change', function () {
				popupChart.inSemiItemChartSearch(false);
            });
            
			$(':radio[name=weekMonthChart9]').on('change', function () {
				popupChart.chart9Search(false);
			});
			
			//urgentDemandCompRateChartSearch
            $(':radio[name=urgentDemandCompRateMonthWeek]').on('change', function () {
            	popupChart.urgentDemandCompRateChartSearch(false);
            });
            $(':radio[name=urgentDemandCompRateQtyAmt]').on('change', function () {
            	popupChart.urgentDemandCompRateChartSearch(false);
            });
            $(':radio[name=urgentDemandCompRatePart]').on('change', function () {
            	popupChart.urgentDemandCompRateChartSearch(false);
            });
            
          //연간 생산계획 대비 실적
            $(':radio[name=salesResultAgainstProdPlanTotal]').on('change', function () {
            	popupChart.salesResultAgainstProdPlanChartSearch(false);
            });
		},
		
		bucket : null,
		
		initSearch : function () {
			FORM_SEARCH = {}
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.tranData = [{ outDs : "week"  , _siq : popupChart._siq + "trendBucketWeek" }
								  , { outDs : "week2"  , _siq : popupChart._siq + "trendBucketWeek2" }
                                  , { outDs : "week3"  , _siq : popupChart._siq + "trendBucketWeek3" }
								  , { outDs : "month" , _siq : popupChart._siq + "trendBucketMonth" }
                                  , { outDs : "month2" , _siq : popupChart._siq + "trendBucketMonth2" }
			];
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					popupChart.bucket = {};
					popupChart.bucket.week  = data.week;
					popupChart.bucket.week2 = data.week2;
					popupChart.bucket.week3 = data.week3;
					popupChart.bucket.month = data.month;
					popupChart.bucket.month2 = data.month2;
					popupChart.search();

				}
			}
			gfn_service(sMap, "obj");
		},
		
		search : function (sqlFlag) {
			FORM_SEARCH            = {};
			FORM_SEARCH            = this.bucket;
			//불량률 
			if(popupChart.chart_id == "chart6") {
				FORM_SEARCH.key = $(':radio[name=key]:checked').val();	
				FORM_SEARCH.firstAs = $(':radio[name=firstAs]:checked').val();	
			} 
			//SCRP
			else if(popupChart.chart_id == "chart22"){
				FORM_SEARCH.chart22_type = $(':radio[name=chart22_type]:checked').val();//SCRAP
				FORM_SEARCH.chart22_weekMonth_type = $(':radio[name=chart22_weekMonth_type]:checked').val();//SCRAP
			}
			//생산 Trend(억)
			else if(popupChart.chart_id == "chart4") {
				FORM_SEARCH.prod = $(':radio[name=prod]:checked').val();
			}
			//생산 준수율
			else if(popupChart.chart_id == "chart13") {
				FORM_SEARCH.prodRate   = $(':radio[name=prodRate]:checked').val();
				FORM_SEARCH.prodRateWeek   = $(':radio[name=prodRateWeek]:checked').val();
			} 
			//공급능력지수
			else if(popupChart.chart_id == "chart5") {
				FORM_SEARCH.agingTrend = $(':radio[name=agingTrend]:checked').val();
			}
			//재공
			else if(popupChart.chart_id == "chart19") {
				FORM_SEARCH.amtRate    = $(':radio[name=amtRate]:checked').val();
				FORM_SEARCH.wip        = $(':radio[name=wip]:checked').val();
			} 
			//재공 Aging
			else if(popupChart.chart_id == "chart21") {
				FORM_SEARCH.trend22    = $(':radio[name=trend22]:checked').val();
			}
			
			//주요 품목 그룹별 생산 실적 
			else if(popupChart.chart_id == "chart9") {
				FORM_SEARCH.weekMonthChart9 = $(':radio[name=weekMonthChart9]:checked').val();
			}
			//사내 반제품 재고 확보율
			else if(popupChart.chart_id == "inSemiItemChart"){
				FORM_SEARCH.inSemiItemCntQty =	$(':radio[name=inSemiItemCntQty]:checked').val();
				FORM_SEARCH.inSemiItemOhMh = $(':radio[name=inSemiItemOhMh]:checked').val();
			}
			
			//장비 가동률
			else if(popupChart.chart_id == "equipRateChart"){
				FORM_SEARCH.equipRate =	$(':radio[name=equipRate]:checked').val();
			}
			
			//긴급건 등록현황
			else if(popupChart.chart_id == "urgentInsertInfoChart"){
				FORM_SEARCH.urgentCntQtyAmt = $(':radio[name=urgentCntQtyAmt]:checked').val();
			}
			
			//긴급 수요 준수율
			else if(popupChart.chart_id == "urgentDemandCompRateChart"){
				FORM_SEARCH.urgentDemandCompRateMonthWeek = $(':radio[name=urgentDemandCompRateMonthWeek]:checked').val();
	            FORM_SEARCH.urgentDemandCompRateQtyAmt = $(':radio[name=urgentDemandCompRateQtyAmt]:checked').val();
	            FORM_SEARCH.urgentDemandCompRatePart = $(':radio[name=urgentDemandCompRatePart]:checked').val();
	        }
			
			//연간 생산계획 대비실적
			else if(popupChart.chart_id == "salesResultAgainstProdPlan"){
				FORM_SEARCH.salesResultAgainstProdPlanTotal = $(':radio[name=salesResultAgainstProdPlanTotal]:checked').val();
				
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
		
		defactSearch : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = popupChart.bucket;
			FORM_SEARCH.key      = $(':radio[name=key]:checked').val();
			FORM_SEARCH.firstAs  = $(':radio[name=firstAs]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "chart6" , _siq : popupChart._siq + "chart6" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arPreMonth = new Array();
					var arMonth = new Array();
			
					$.each (popupChart.bucket.month, function (i, el) {
						arPreMonth.push(el.PRE_DISMONTH);
						arMonth.push(el.DISMONTH);
					});
					
					var chart6 = JSON.parse(data.chart6[0].DEFECT);
					//popupChart.tagetStyle(chart6);
					popupChart.chartGen('chart6', 'line', arMonth, chart6);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		//SCRAP
		chart22Search : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = popupChart.bucket;
			FORM_SEARCH.chart22_type   = $(':radio[name=chart22_type]:checked').val();
			FORM_SEARCH.chart22_weekMonth_type   = $(':radio[name=chart22_weekMonth_type]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "chart22" , _siq : popupChart._siq + "chart22" } ,
			];
			
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					
					
					
					
					
					var weekMonth = $(':radio[name=chart22_weekMonth_type]:checked').val();
					
					if(weekMonth == "WEEK"){
						
						
						
						var arWeek = new Array();
						
						$.each (popupChart.bucket.week, function (i, el) {
							arWeek.push(el.DISWEEK);
						});
						
						var chart22 = JSON.parse(data.chart22[0].SCRAP);

						popupChart.chartGen('chart22', 'line', arWeek, chart22);
					}else{
						
						
						
						var arMonth = new Array();
						
						$.each (popupChart.bucket.month, function (i, el) {
							arMonth.push(el.DISMONTH);
						});
						
						
						
						var chart22 = JSON.parse(data.chart22[0].SCRAP);
						
						
						
						popupChart.chartGen('chart22', 'line', arMonth, chart22);						
					}
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
					var arPreMonth = new Array();
					var arMonth = new Array();
			
					$.each (popupChart.bucket.month, function (i, el) {
						arPreMonth.push(el.PRE_DISMONTH);
						arMonth.push(el.DISMONTH);
					});
					var chart4 = JSON.parse(data.chart4[0].PROD_TREND);

					popupChart.chartGen('chart4', 'line', arMonth, chart4);
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
			FORM_SEARCH.tranData = [
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
					
					var chart13 = JSON.parse(data.chart13[0].PROD_CML);

					popupChart.chartGen('chart13', 'line', arWeek, chart13);
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
					var arPreMonth = new Array();
					var arMonth = new Array();
			
					$.each (popupChart.bucket.month, function (i, el) {
						arPreMonth.push(el.PRE_DISMONTH);
						arMonth.push(el.DISMONTH);
					});
					
					var chart5 = JSON.parse(data.chart5[0].CAPA);

					popupChart.chartGen('chart5', 'line', arMonth, chart5); 
				}
			}
			gfn_service(sMap,"obj");
		},
		
		wipSearch : function(sqlFlag) {
			FORM_SEARCH = {};
			FORM_SEARCH = popupChart.bucket;
			FORM_SEARCH.amtRate    = $(':radio[name=amtRate]:checked').val();
			FORM_SEARCH.wip  = $(':radio[name=wip]:checked').val();
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.sql  = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "chart19" , _siq : popupChart._siq + "chart19" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					
					var arMonth = new Array();
					var arPreMonth = new Array();
					
					$.each (popupChart.bucket.month, function (i, el) {
						arMonth.push(el.DISMONTH);
						arPreMonth.push(el.PRE_DISMONTH);
					});
					var chart19 = JSON.parse(data.chart19[0].WIP);
					
					if(FORM_SEARCH.amtRate == "amt"){
						popupChart.chartGen('chart19', 'line', arMonth, chart19);	
					}else{
						popupChart.chartGen('chart19', 'line', arPreMonth, chart19);
					}
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
			FORM_SEARCH.tranData = [
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
					
					var chart21 = JSON.parse(data.chart21[0].TREND22);

					popupChart.chartGen('chart21', 'line', arMonth, chart21);
				}
			}
			gfn_service(sMap,"obj");
		},
		

		productChartSearch : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = popupChart.bucket;
			FORM_SEARCH.timePeople = $(':radio[name=timePeople]:checked').val();
			FORM_SEARCH.productPartTotal = $(':radio[name=productPartTotal]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "productChart" , _siq : popupChart._siq + "productChart" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					
					var arPreMonth = new Array();
					var arMonth = new Array();
			
					$.each (popupChart.bucket.month, function (i, el) {
						arPreMonth.push(el.PRE_DISMONTH);
						arMonth.push(el.DISMONTH);
					});
					
					var productChart = JSON.parse(data.productChart[0].PRODUCT_CHART);
					popupChart.chartGen('productChart', 'line', arPreMonth, productChart);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		equipRateChartSearch : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = popupChart.bucket;
			FORM_SEARCH.equipRate = $(':radio[name=equipRate]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "equipRateChart" , _siq : popupChart._siq + "equipRateChart" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					
					var arPreWeek  = new Array();
					var arWeek     = new Array();
			
					$.each (popupChart.bucket.week, function (i, el) {
						arWeek.push(el.DISWEEK);
						arPreWeek.push(el.PRE_DISWEEK);
					});
					
					var equipRateChart = JSON.parse(data.equipRateChart[0].EQUIP_RATE);
					popupChart.chartGen('equipRateChart', 'line', arWeek, equipRateChart);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		urgentInsertInfoChartSearch : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = popupChart.bucket;
			FORM_SEARCH.urgentCntQtyAmt = $(':radio[name=urgentCntQtyAmt]:checked').val();
			FORM_SEARCH.urgentRepCustTotal = $(':radio[name=urgentRepCustTotal]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "urgentInsertInfoChart" , _siq : popupChart._siq + "urgentInsertInfoChart" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					
					var arPreWeek  = new Array();
					var arWeek     = new Array();
			
					$.each (popupChart.bucket.week, function (i, el) {
						arWeek.push(el.DISWEEK);
						arPreWeek.push(el.PRE_DISWEEK);
					});
					
					var urgentInsertInfoChart = JSON.parse(data.urgentInsertInfoChart[0].URGENT_INSERT_INFO);
					popupChart.chartGen('urgentInsertInfoChart', 'line', arWeek, urgentInsertInfoChart);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		workInfoChartSearch : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = popupChart.bucket;
			FORM_SEARCH.workRepCustTotal = $(':radio[name=workRepCustTotal]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "workInfoChart" , _siq : popupChart._siq + "workInfoChart" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					
					var arPreWeek  = new Array();
					var arWeek     = new Array();
			
					$.each (popupChart.bucket.week2, function (i, el) {
						arWeek.push(el.DISWEEK);
						arPreWeek.push(el.PRE_DISWEEK);
					});
					
					var workInfoChart = JSON.parse(data.workInfoChart[0].WORK_INFO);
					popupChart.chartGen('workInfoChart', 'line', arWeek, workInfoChart);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		inSemiItemChartSearch : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = popupChart.bucket;
			FORM_SEARCH.inSemiItemCntQty = $(':radio[name=inSemiItemCntQty]:checked').val();
			FORM_SEARCH.inSemiItemOhMh = $(':radio[name=inSemiItemOhMh]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "inSemiItemChart" , _siq : popupChart._siq + "inSemiItemChart" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					
					var columnData = [], lineData = [], xCate = [];
					
					$.each(data.inSemiItemChart, function(n, v){
						
		
						var trendWeek = v.TREND_WEEK;
						var measCd = v.MEAS_CD;
						var measNm = v.MEAS_NM;
						var resultValue = gfn_nvl(v.RESULT_VALUE, 0);
						
						
						if(measCd.indexOf("UNSECURE") != -1){
							columnData.push({name : trendWeek, y : resultValue, color: gv_cColor1});
							xCate.push(measNm);
						}else if(measCd.indexOf("SECURE_RATE") != -1){
							lineData.push({name : trendWeek, y : resultValue, color: gv_cColor2});
							xCate.push(measNm);
						}
					});
					
					const set = new Set(xCate);
		            const uniqueXCate =[...set];
		            
					var chartId = "inSemiItemChart";
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
					            },
					            cursor: 'pointer',
								point: {
									events: {
										click: function() {
										}
									}
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
					            data: columnData,
					            stack: 0,
					            type: 'column',
					            name: uniqueXCate[1]
					            
					        }, {
					            data: lineData,
					            type: 'line',
					            name: uniqueXCate[0]
					            //yAxis: 1
					        }
					    ]
					});
					$("#" + chartId).css("overflow", "");
				}
			}
			gfn_service(sMap,"obj");
		},
		
		chart9Search : function(sqlFlag) {
			FORM_SEARCH = {};
			FORM_SEARCH = popupChart.bucket;
			FORM_SEARCH.weekMonthChart9    = $(':radio[name=weekMonthChart9]:checked').val();
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.sql  = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "chart9" , _siq : popupChart._siq + "chart9" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					
					var arWeek = new Array();
					var arMonth = new Array();
					
					$.each (popupChart.bucket.month, function (i, el) {
						arMonth.push(el.DISMONTH);
					});
					
					$.each (popupChart.bucket.week, function (i, el) {
						arWeek.push(el.DISWEEK);
					});
					
					
					var chart9 = JSON.parse(data.chart9[0].CAPA);
					
					if(FORM_SEARCH.weekMonthChart9 == "month"){
						popupChart.chartGen('chart9', 'line', arMonth, chart9);	
					}else{
						popupChart.chartGen('chart9', 'line', arWeek, chart9);
					}
				}
			}
			gfn_service(sMap,"obj");
		},
		
		//긴급 수요 준수율
        urgentDemandCompRateChartSearch : function(sqlFlag) {
            FORM_SEARCH          = {};
            FORM_SEARCH          = popupChart.bucket;
           
            FORM_SEARCH.urgentDemandCompRateMonthWeek = $(':radio[name=urgentDemandCompRateMonthWeek]:checked').val();
            FORM_SEARCH.urgentDemandCompRateQtyAmt = $(':radio[name=urgentDemandCompRateQtyAmt]:checked').val();
            FORM_SEARCH.urgentDemandCompRatePart = $(':radio[name=urgentDemandCompRatePart]:checked').val();
            
            FORM_SEARCH._mtd     = "getList";
            FORM_SEARCH.sql      = sqlFlag;
            FORM_SEARCH.tranData = [
                { outDs : "urgentDemandCompRateChart" , _siq : popupChart._siq + "urgentDemandCompRateChart" } ,
            ];
            
            var sMap = {
                url  : "${ctx}/biz/obj",
                data    : FORM_SEARCH,
                success : function(data) {
                    
                    var arWeek3    = [];
                    var arMonth2   = [];
                    var urgentDemandCompRateMonthWeek = $(':radio[name=urgentDemandCompRateMonthWeek]:checked').val();
                    $.each (popupChart.bucket.week3, function (i, el) {
                        arWeek3.push(el.DISWEEK);
                    });
                    
                    $.each (popupChart.bucket.month2, function (i, el) {
                        arMonth2.push(el.DISMONTH)  
                    });
                    
                    var urgentDemandCompRateChart = JSON.parse(data.urgentDemandCompRateChart[0].URGENT_DEMAND_COMP_RATE)
                    //(urgentDemandCompRateMonthWeek=='MONTH')?supplyTrend2.chartGen('urgentDemandCompRateChart', 'column', arMonth2, urgentDemandCompRateChart):supplyTrend2.chartGen('urgentDemandCompRateChart', 'column', arWeek3, urgentDemandCompRateChart);
                    if(urgentDemandCompRateMonthWeek=='MONTH')
                    {
                    	popupChart.chartGen('urgentDemandCompRateChart', 'column', arMonth2, urgentDemandCompRateChart);
                    }
                    else
                    {
                    	popupChart.chartGen('urgentDemandCompRateChart', 'column', arWeek3, urgentDemandCompRateChart);
                    }
                }
            }
            gfn_service(sMap,"obj");
        },
        
        //연간 생산계획 대비실적
        salesResultAgainstProdPlanChartSearch: function(sqlFlag) {
            FORM_SEARCH          = {};
            FORM_SEARCH.unit 	 = unit;
			FORM_SEARCH.unit2 	 = unit2;
			
            FORM_SEARCH.salesResultAgainstProdPlanTotal = $(':radio[name=salesResultAgainstProdPlanTotal]:checked').val();
            
            FORM_SEARCH._mtd     = "getList";
            FORM_SEARCH.sql      = sqlFlag;
            FORM_SEARCH.tranData = [
                { outDs : "salesResultAgainstProdPlanChart" , _siq : popupChart._siq + "salesResultAgainstProdPlan" } ,
            ];
            
            var sMap = {
                url  : "${ctx}/biz/obj",
                data    : FORM_SEARCH,
                success : function(data) {
                    salesResultAgainstProdPlanChartGenChart(false, data.salesResultAgainstProdPlanChart)
                    
                }
            }
            gfn_service(sMap,"obj");
        },
        
        
		
		drawChart : function (res) {
			fn_setHighchartTheme();
			
			var amtRateFlag = $(':radio[name=amtRate]:checked').val();
			var arPreWeek  = new Array();
			var arWeek     = new Array();
			var arPreWeek2 = new Array();
			var arWeek2    = new Array();
			var arMonth    = new Array();
			var arPreMonth = new Array();
			var arWeek3    = [];
            var arMonth2   = [];
            
			$.each (popupChart.bucket.month, function (i, el) {
				arMonth.push(el.DISMONTH);
				arPreMonth.push(el.PRE_DISMONTH);
			});
			
			$.each (popupChart.bucket.week, function (i, el) {
				arWeek.push(el.DISWEEK);
				arPreWeek.push(el.PRE_DISWEEK);
			});
			
			$.each (popupChart.bucket.week2, function (i, el) {
				arWeek2.push(el.DISWEEK);
				arPreWeek2.push(el.PRE_DISWEEK);
			});
			
			$.each (popupChart.bucket.week3, function (i, el) {
                arWeek3.push(el.DISWEEK);
            });
            
            $.each (popupChart.bucket.month2, function (i, el) {
                arMonth2.push(el.DISMONTH)  
            });
			
			if(popupChart.chart_id == "chart3") {
				var chart3 = JSON.parse(res.chart3[0].CLAIM);
				this.tagetStyle(chart3);
				this.chartGen('chart3', 'line', arMonth, chart3);
			}else if(popupChart.chart_id == "chart6") {
				var chart6 = JSON.parse(res.chart6[0].DEFECT);
				this.tagetStyle(chart6);
				this.chartGen('chart6', 'line', arMonth, chart6);
			}
			//SCRAP
			else if(popupChart.chart_id == "chart22"){
				var chart22 =JSON.parse(res.chart22[0].SCRAP);
				this.chartGen('chart22', 'line', arMonth, chart22);//SCRAP
			}
			else if(popupChart.chart_id == "chart4") {
				var chart4 = JSON.parse(res.chart4[0].PROD_TREND);
				this.chartGen('chart4', 'line', arMonth, chart4);
			}else if(popupChart.chart_id == "chart9") {
				var chart9 = JSON.parse(res.chart9[0].CAPA);
				this.chartGen('chart9', 'line', arMonth, chart9);
			}else if(popupChart.chart_id == "chart13") {
				var chart13 = JSON.parse(res.chart13[0].PROD_CML);
				this.chartGen('chart13', 'line', arWeek, chart13);
			}else if(popupChart.chart_id == "chart5") {
				var chart5 = JSON.parse(res.chart5[0].CAPA);
				this.chartGen('chart5', 'line', arMonth, chart5);
			}else if(popupChart.chart_id == "chart19") {
				var chart19 = JSON.parse(res.chart19[0].WIP);
				if(amtRateFlag == "amt"){
					this.chartGen('chart19', 'line', arMonth, chart19);	
				}else{
					this.chartGen('chart19', 'line', arPreMonth, chart19);
				}
			}else if(popupChart.chart_id == "chart21") {
				var chart21 = JSON.parse(res.chart21[0].TREND22);
				this.chartGen('chart21', 'line', arMonth, chart21);
			}else if(popupChart.chart_id == "productChart") {
				var productChart = JSON.parse(res.productChart[0].PRODUCT_CHART);
				this.chartGen('productChart', 'line', arPreMonth, productChart);
			}else if(popupChart.chart_id == "mainItemTypeLtChart") {
				var mainItemTypeLtChart = JSON.parse(res.mainItemTypeLtChart[0].MAIN_ITEM_TYPE_LT);
				this.chartGen('mainItemTypeLtChart', 'line', arMonth, mainItemTypeLtChart);
			}else if(popupChart.chart_id == "equipRateChart") {
				var equipRateChart = JSON.parse(res.equipRateChart[0].EQUIP_RATE);
				this.chartGen('equipRateChart', 'line', arWeek, equipRateChart);
			}else if(popupChart.chart_id == "urgentInsertInfoChart") {
				var urgentInsertInfoChart = JSON.parse(res.urgentInsertInfoChart[0].URGENT_INSERT_INFO);
				this.chartGen('urgentInsertInfoChart', 'line', arWeek, urgentInsertInfoChart);
			}else if(popupChart.chart_id == "workInfoChart") {
				var workInfoChart = JSON.parse(res.workInfoChart[0].WORK_INFO);
				this.chartGen('workInfoChart', 'line', arWeek2, workInfoChart);
			}else if(popupChart.chart_id == "inSemiItemChart") {
				
				var columnData = [], lineData = [], xCate = [];
				
				$.each(res.inSemiItemChart, function(n, v){
					
		
					var trendWeek = v.TREND_WEEK;
					var measCd = v.MEAS_CD;
					var measNm = v.MEAS_NM;
					var resultValue = gfn_nvl(v.RESULT_VALUE, 0);
					
					
					if(measCd.indexOf("UNSECURE") != -1){
						columnData.push({name : trendWeek, y : resultValue, color: gv_cColor1});
					    xCate.push(measNm);
					}else if(measCd.indexOf("SECURE_RATE") != -1){
						lineData.push({name : trendWeek, y : resultValue, color: gv_cColor2});
					    xCate.push(measNm);   					
					}
				});
				
				const set = new Set(xCate);
	            const uniqueXCate =[...set];
	            
				
				var chartId = "inSemiItemChart";
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
				            },
				            cursor: 'pointer',
							point: {
								events: {
									click: function() {
										
									}
								}
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
				            data: columnData,
				            stack: 0,
				            type: 'column',
				            name: uniqueXCate[1]
				            
				        }, {
				            data: lineData,
				            type: 'line',
				            name: uniqueXCate[0]
				            //yAxis: 1
				        }
				    ]
				});
				$("#" + chartId).css("overflow", "");
			}else if(popupChart.chart_id == "urgentDemandCompRateChart") {
                var urgentDemandCompRateChart = JSON.parse(res.urgentDemandCompRateChart[0].URGENT_DEMAND_COMP_RATE);
                this.chartGen('urgentDemandCompRateChart', 'column', arWeek3, urgentDemandCompRateChart);
            }
			
			else if(popupChart.chart_id == "salesResultAgainstProdPlan") {
			//연간 생산계획 대비 실적
	
			
			var codeNmArrSalesResultAgainstProdPlan = [];
	        var lineData1SalesResultAgainstProdPlan = [];
	        var lineData2SalesResultAgainstProdPlan = [];
	        var lineData3SalesResultAgainstProdPlan = [];
	        
	        var latest_SALES_RESULT =  null;
	        var latest_PROD_PLAN     =  null;  
	        var latest_PROD_RESULT     =  null;  
	        
	        var today = new Date()
	        var month = today.getMonth() + 1;  // 월
			
			$.each(res.salesResultAgainstProdPlan, function(i, val){
                
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
                    if(codeNm=='PRODUCT_PLAN'){
	                	latest_PROD_PLAN     = val.RESULT_VALUE
	                }
	                
	                if(codeNm=='SALES_RESULT'){
	                    latest_SALES_RESULT = val.RESULT_VALUE
	                }
	                
	                if(codeNm=='PROD_RESULT'){
	                    latest_PROD_RESULT = val.RESULT_VALUE
	                }
                }
                
                if(rn == 0){
                    if(codeNm=='PRODUCT_PLAN')
                    {
                        codeNmArrSalesResultAgainstProdPlan.push("연간 생산 계획");
                    }
                    else if(codeNm=='SALES_RESULT')
                    {
                        codeNmArrSalesResultAgainstProdPlan.push("출하 실적");
                    }
                    else if(codeNm=='PROD_RESULT')
                    {
                        codeNmArrSalesResultAgainstProdPlan.push("생산 실적");
                    }
                }
                
                
                if(flagSort == 1){
                	lineData1SalesResultAgainstProdPlan.push({name: lineNm, y: resultValue, color: "#6495ED"});
                }else if(flagSort == 2){
                	lineData2SalesResultAgainstProdPlan.push({name: lineNm, y: resultValue, color: "#DC143C"});
                }else if(flagSort == 3){
                	lineData3SalesResultAgainstProdPlan.push({name: lineNm, y: resultValue, color: "#9B59B6"});
                }
            });
	        
			  // GAP 계산: 출하실적 - 사업계획
            var GAP = '';
            var GAP_temp = Math.round(latest_SALES_RESULT - latest_PROD_PLAN);
            if((latest_SALES_RESULT - latest_PROD_PLAN) > 0)
            {
            	GAP  = 'GAP +'+''+String(GAP_temp);
            	$('#title > p').remove();
                $('#title').append('<p class="green">'+ GAP +'</p>');
                
            }
            else if((latest_SALES_RESULT - latest_PROD_PLAN) == 0)
            {
                GAP  = 'GAP '+''+String(GAP_temp);
            	$('#title > p').remove();
                $('#title').append('<p>'+ GAP +'</p>');
            }
            else
            {
                GAP  = 'GAP '+''+String(GAP_temp);
            	$('#title > p').remove();
                $('#title').append('<p class="red">'+ GAP +'</p>');
                
            }
            
            
            var chartIdSalesResultAgainstProdPlan = "salesResultAgainstProdPlanChart";
            Highcharts.chart(chartIdSalesResultAgainstProdPlan, {
                
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
                        data: lineData1SalesResultAgainstProdPlan,
                        type: 'line',
                        name: codeNmArrSalesResultAgainstProdPlan[0],
                        yAxis: 1,
                        color: "#6495ED"
                    }, {
                        data: lineData2SalesResultAgainstProdPlan,
                        type: 'line',
                        name: codeNmArrSalesResultAgainstProdPlan[1],
                        yAxis: 1,
                        color: "#DC143C"
                    }, {
                        data: lineData3SalesResultAgainstProdPlan,
                        type: 'line',
                        name: codeNmArrSalesResultAgainstProdPlan[2],
                        yAxis: 1,
                        color: "#9B59B6"
                    }
                ]
            });
            
            
		
		
			}//end of  else if(popupChart.chart_id == "salesResultAgainstProdPlan")
					
			
			
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
			
			if (arData.length == 0) {
				return false;
			}
			
			isStack = isStack || false;
			
			var chart = {
				
				xAxis  : { categories : arCarte },
				series : arData,
				plotOptions: {
					column: {
						stacking: 'normal',
						dataLabels: {
							enabled: true
						},
					},
					series: {
						events: {
							afterAnimate : function(e){
								
								var chartLen = this.chart.series.length;
								
								if(chartId == "chart9") {
									for(var i = 0; i < chartLen; i++){
			        					
			        					var chartCode = this.chart.series[i].userOptions.code;
			        					
			        					if(chartCode != "1BLB"){
			        						this.chart.series[i].hide();	
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
			
			if(chartId == "chart6" && FORM_SEARCH.key == "prodPart"){
				chart.colors = [gv_cColor1, gv_cColor2, '#009933', '#82d8b5', '#f0a482', '#f1e584', '#9ead59', '#5d9980', '#b986c2', '#d1afdd'];	
			}else if(chartId == "chart4" && FORM_SEARCH.prod == "item"){
				chart.colors = [gv_cColor1, gv_cColor2, '#f7848d', '#82d8b5', '#009933', '#f1e584', '#9ead59', '#5d9980', '#b986c2', '#d1afdd'];
			}else if(chartId == "chart5" && FORM_SEARCH.agingTrend == "cust"){
				chart.colors = [gv_cColor1, gv_cColor2, '#f7848d', '#82d8b5', '#663300', '#f1e584', '#9ead59', '#5d9980', '#b986c2', '#d1afdd'];
			}else if(chartId == "chart9"){
				chart.colors = [gv_cColor1, gv_cColor2, '#f7848d', '#82d8b5', '#663300', '#f1e584', '#9ead59', '#5d9980', '#b986c2', '#d1afdd'];
			}else if(chartId == "chart13" && FORM_SEARCH.prodRate == "item"){
				chart.colors = [gv_cColor1, gv_cColor2, '#f7848d', '#663300', '#f0a482', '#f1e584', '#9ead59', '#5d9980', '#666666', '#d1afdd'];
			}else if(chartId == "mainItemTypeLtChart"){
				chart.colors = [gv_cColor1, gv_cColor2, '#f7848d', '#666666', '#f0a482', '#f1e584', '#9ead59', '#5d9980', '#b986c2', '#d1afdd'];	
			}else if(chartId == "urgentInsertInfoChart" && FORM_SEARCH.urgentRepCustTotal == "repCust"){
				chart.colors = [gv_cColor1, gv_cColor2, '#f7848d', '#666666', '#f0a482', '#f1e584', '#9ead59', '#5d9980', '#b986c2', '#d1afdd'];
			}else if(chartId == "workInfoChart" && FORM_SEARCH.workRepCustTotal == "repCust"){
				chart.colors = [gv_cColor1, gv_cColor2, '#f7848d', '#666666', '#f0a482', '#f1e584', '#9ead59', '#5d9980', '#b986c2', '#d1afdd'];
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
	
	function getPointCategoryName(point, dimension) {
	    var series = point.series,
	        isY = dimension === 'y',
	        axis = series[isY ? 'yAxis' : 'xAxis'];
	    return axis.categories[point[isY ? 'y' : 'x']];
	}
	
	//조회
	function fn_apply(sqlFlag) {
	
	}
	
 	// onload 
	$(document).ready(function() {
		popupChart.init();
	});
	
 	function salesResultAgainstProdPlanChartGenChart(sqlFlag,res){
 		

    	
    	
    	//연간 생산계획 대비 실적
		var codeNmArrSalesResultAgainstProdPlan = [];
        var lineData1SalesResultAgainstProdPlan = [];
        var lineData2SalesResultAgainstProdPlan = [];
        var lineData3SalesResultAgainstProdPlan = [];
        
        
        var latest_SALES_RESULT =  null;
        var latest_PROD_PLAN     =  null;            
        var latest_PROD_RESULT     =  null;            
        
        var today = new Date()
        var month = today.getMonth() + 1;  // 월
		
		$.each(res, function(i, val){
            
            var rn = val.RN;
            var codeNm = val.CODE_NM;
            var prodPart = val.PROD_PART;
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
                if(codeNm=='PRODUCT_PLAN'){
                	latest_PROD_PLAN     = val.RESULT_VALUE
                }
                
                if(codeNm=='SALES_RESULT'){
                    latest_SALES_RESULT = val.RESULT_VALUE
                }
                
                if(codeNm=='PROD_RESULT'){
                    latest_PROD_RESULT = val.RESULT_VALUE
                }
            }
            
            if(rn == 0){
                if(codeNm=='PRODUCT_PLAN')
                {
                    codeNmArrSalesResultAgainstProdPlan.push("연간 생산 계획");
                }
                else if(codeNm=='SALES_RESULT')
                {
                    codeNmArrSalesResultAgainstProdPlan.push("출하 실적");
                }
                else if(codeNm=='PROD_RESULT')
                {
                    codeNmArrSalesResultAgainstProdPlan.push("생산 실적");
                }
            }
            
            if(flagSort == 1){
            	lineData1SalesResultAgainstProdPlan.push({name: lineNm, y: resultValue, color: "#6495ED"});
            }else if(flagSort == 2){
            	lineData2SalesResultAgainstProdPlan.push({name: lineNm, y: resultValue, color: "#DC143C"});
            }else if(flagSort == 3){
            	lineData3SalesResultAgainstProdPlan.push({name: lineNm, y: resultValue, color: "#9B59B6"});
            }
            
        });
        
		  // GAP 계산: 출하실적 - 사업계획
        var GAP = '';
        var GAP_temp = Math.round(latest_SALES_RESULT - latest_PROD_PLAN);
        if((latest_SALES_RESULT - latest_PROD_PLAN) > 0)
        {
        	GAP  = 'GAP +'+''+String(GAP_temp);
        	$('#title > p').remove();
        	$('#title').append('<p class="green">'+ GAP +'</p>');
            
        }
        else if((latest_SALES_RESULT - latest_PROD_PLAN) == 0)
        {
            GAP  = 'GAP '+''+String(GAP_temp);
        	$('#title > p').remove();
            $('#title').append('<p>'+ GAP +'</p>');
        }
        else
        {
            GAP  = 'GAP '+''+String(GAP_temp);
        	$('#title > p').remove();
            $('#title').append('<p class="red">'+ GAP +'</p>');
            
        }
        
        
        var chartIdSalesResultAgainstProdPlan = "salesResultAgainstProdPlanChart";
        Highcharts.chart(chartIdSalesResultAgainstProdPlan, {
            
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
                    data: lineData1SalesResultAgainstProdPlan,
                    type: 'line',
                    name: codeNmArrSalesResultAgainstProdPlan[0],
                    yAxis: 1,
                    color: "#6495ED"
                }, {
                    data: lineData2SalesResultAgainstProdPlan,
                    type: 'line',
                    name: codeNmArrSalesResultAgainstProdPlan[1],
                    yAxis: 1,
                    color: "#DC143C"
                }, {
                    data: lineData3SalesResultAgainstProdPlan,
                    type: 'line',
                    name: codeNmArrSalesResultAgainstProdPlan[2],
                    yAxis: 1,
                    color: "#9B59B6"
                }
            ]
        });
    	
 	}

</script>

</head>
<body>
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="keywordpop" class="popupDv" style="height:1000px;">
		<div class="popCont">
			<!-- chart -->
			<div id="cont_chart">
				<div class="col_3">
						<h4 id="title" style="font-size: 30px;">${popupChartSupplyTrend.title} </h4>
						<c:choose>
						<c:when test="${popupChartSupplyTrend.chartId == 'chart3'}">
						<div class="view_combo" style="float: right;">
						</div>
						<div style="height: 88%" id="chart3"></div>
						</c:when>
						
						<c:when test="${popupChartSupplyTrend.chartId == 'chart6'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="firstAs1" name="firstAs" value="all" checked="checked"/> <label for="firstAs1"><spring:message code="lbl.firstAsInclude" /></label></li>
								<li><input type="radio" id="firstAs2" name="firstAs" value="exc"/> <label for="firstAs2"><spring:message code="lbl.firstAsExc" /></label></li>
								<li><input type="radio" id="key3" name="key" value="part"/> <label for="key3"><spring:message code="lbl.part" /></label></li>
								<li><input type="radio" id="key2" name="key" value="key"/> <label for="key2"><spring:message code="lbl.reptItemGroup" /></label></li>
								<li><input type="radio" id="key4" name="key" value="mainItem"/> <label for="key4"><spring:message code="lbl.kpdr2" /></label></li>
								<li><input type="radio" id="key1" name="key" value="prodPart" checked="checked"/> <label for="key1"><spring:message code="lbl.prodPart3" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart6" ></div>
						</c:when>
						
						
						<c:when test="${popupChartSupplyTrend.chartId == 'chart22'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="chart22_weekMonth_type1" name="chart22_weekMonth_type" value="WEEK"/> <label for="chart22_weekMonth_type1"><spring:message code="lbl.weekly" /></label></li>
								<li><input type="radio" id="chart22_weekMonth_type2" name="chart22_weekMonth_type" value="MONTH" checked="checked"/> <label for="chart22_weekMonth_type2"><spring:message code="lbl.month2" /></label></li>
								<li><input type="radio" id="chart22_type1" name="chart22_type" value="part" /> <label for="chart22_type1"><spring:message code="lbl.part" /></label></li>
								<li><input type="radio" id="chart22_type2" name="chart22_type" value="total" checked="checked"/> <label for="chart22_type2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart22" ></div>
						</c:when>
						
						
						<c:when test="${popupChartSupplyTrend.chartId == 'chart4'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="prod1" name="prod" value="item"/> <label for="prod1"><spring:message code="lbl.part" /></label></li>
								<li><input type="radio" id="prod2" name="prod" value="total" checked="checked"/> <label for="prod2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart4"></div>
						</c:when>
						
						<c:when test="${popupChartSupplyTrend.chartId == 'chart9'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="weekMonthChart1" name="weekMonthChart9" value="week"/><label for="weekMonthChart1"><spring:message code="lbl.weekly" /></label></li>
								<li><input type="radio" id="weekMonthChart2" name="weekMonthChart9" value="month" checked="checked"/><label for="weekMonthChart2"><spring:message code="lbl.month2" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart9"></div>
						</c:when>
						
						<c:when test="${popupChartSupplyTrend.chartId == 'chart13'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="prodRateWeek1" name="prodRateWeek" value="std" checked="checked"/> <label for="prodRateWeek1"><spring:message code="lbl.stdWeek" /></label></li>
								<li><input type="radio" id="prodRateWeek2" name="prodRateWeek" value="sales"/> <label for="prodRateWeek2"><spring:message code="lbl.salesWeek" /> </label></li>
								<li><input type="radio" id="prodRate1" name="prodRate" value="item"/> <label for="prodRate1"><spring:message code="lbl.part" /></label></li>
								<li><input type="radio" id="prodRate2" name="prodRate" value="total" checked="checked"/> <label for="prodRate2"><spring:message code="lbl.itemTotal" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart13" ></div>
						</c:when>
						
						<c:when test="${popupChartSupplyTrend.chartId == 'chart5'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="agingTrend1" name="agingTrend" value="cust"/> <label for="agingTrend1"><spring:message code="lbl.reptCust" /></label></li>
								<li><input type="radio" id="agingTrend2" name="agingTrend" value="total" checked="checked"/> <label for="agingTrend2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart5"></div>
						</c:when>
						
						<c:when test="${popupChartSupplyTrend.chartId == 'chart19'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="amtRate1" name="amtRate" value="amt" checked="checked"/> <label for="amtRate1"><spring:message code="lbl.amount" />(<spring:message code="lbl.hMillion" />)</label></li>
								<li><input type="radio" id="amtRate2" name="amtRate" value="rate"/> <label for="amtRate2"><spring:message code="lbl.wipRt" /> (%)</label></li>
								<li><input type="radio" id="wip1" name="wip" value="item"/> <label for="wip1"><spring:message code="lbl.part" /></label></li>
								<li><input type="radio" id="wip2" name="wip" value="total" checked="checked"/> <label for="wip2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart19" ></div>
						</c:when>
						
						<c:when test="${popupChartSupplyTrend.chartId == 'chart21'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="trend22_m2" name="trend22" value="M2" checked="checked"/> <label for="trend22_m2"><spring:message code="lbl.2mMore" /></label></li>
								<li><input type="radio" id="trend22_m6" name="trend22" value="M6"/> <label for="trend22_m6"><spring:message code="lbl.6mMore" /></label></li>
								<li><input type="radio" id="trend22_y1" name="trend22" value="Y1"/> <label for="trend22_y1"><spring:message code="lbl.yearOneMore" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="chart21"></div>
						</c:when>
						
						<c:when test="${popupChartSupplyTrend.chartId == 'productChart'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="timePeople1" name="timePeople" value="time"/> <label for="timePeople1"><spring:message code="lbl.timeProd2" /></label></li>
								<li><input type="radio" id="timePeople2" name="timePeople" value="people" checked="checked"/> <label for="timePeople2"><spring:message code="lbl.peopleProd2" /> </label></li>
								<li><input type="radio" id="productPart" name="productPartTotal" value="part"/> <label for="productPart"><spring:message code="lbl.part" /></label></li>
								<li><input type="radio" id="productTotal" name="productPartTotal" value="total" checked="checked"/> <label for="productTotal"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="productChart" ></div>
						</c:when>
						
						<c:when test="${popupChartSupplyTrend.chartId == 'mainItemTypeLtChart'}">
						<div class="view_combo" style="float: right;">
						</div>
						<div style="height: 88%" id="mainItemTypeLtChart" ></div>
						</c:when>
						
						<c:when test="${popupChartSupplyTrend.chartId == 'equipRateChart'}">
						<div class="view_combo" id="divEquipRate" style="float: right;"></div>
						<div style="height: 88%" id="equipRateChart" ></div>
						</c:when>
						
						<c:when test="${popupChartSupplyTrend.chartId == 'urgentInsertInfoChart'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="urgentCntQtyAmt1" name="urgentCntQtyAmt" value="CNT"/> <label for="urgentCntQtyAmt1"><spring:message code="lbl.cnt" /></label></li>
								<li><input type="radio" id="urgentCntQtyAmt2" name="urgentCntQtyAmt" value="QTY"/> <label for="urgentCntQtyAmt2"><spring:message code="lbl.qty" /></label></li>
								<li><input type="radio" id="urgentCntQtyAmt3" name="urgentCntQtyAmt" value="AMT" checked="checked"/> <label for="urgentCntQtyAmt3"><spring:message code="lbl.amt" />(<spring:message code="lbl.billion" />) </label></li>
								<li><input type="radio" id="urgentRepCustTotal1" name="urgentRepCustTotal" value="repCust" checked="checked"/> <label for="urgentRepCustTotal1"><spring:message code="lbl.reptCust" /></label></li>
								<li><input type="radio" id="urgentRepCustTotal2" name="urgentRepCustTotal" value="total"/> <label for="urgentRepCustTotal2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="urgentInsertInfoChart" ></div>
						</c:when>
						
						<c:when test="${popupChartSupplyTrend.chartId == 'workInfoChart'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="workRepCustTotal1" name="workRepCustTotal" value="repCust" checked="checked"/> <label for="workRepCustTotal1"><spring:message code="lbl.reptCust" /></label></li>
								<li><input type="radio" id="workRepCustTotal2" name="workRepCustTotal" value="total"/> <label for="workRepCustTotal2"><spring:message code="lbl.total" /> </label></li>
							</ul>
						</div>
						<div style="height: 88%" id="workInfoChart" ></div>
						</c:when>
						
						<c:when test="${popupChartSupplyTrend.chartId == 'inSemiItemChart'}">
						<div class="view_combo" style="float: right;">
							<ul class="rdofl">
								<li><input type="radio" id="inSemiItemOH" name="inSemiItemOhMh" value="OH" checked="checked"/> <label for="inSemiItemOH">외주반제품 </label></li>
                                <li><input type="radio" id="inSemiItemMH" name="inSemiItemOhMh" value="MH" /> <label for="inSemiItemMH">사내반제품</label></li>
								<li><input type="radio" id="inSemiItemCntQty2" name="inSemiItemCntQty" value="CNT" checked="checked"/> <label for="inSemiItemCntQty2"><spring:message code="lbl.itemQty" /> </label></li>
								<li><input type="radio" id="inSemiItemCntQty1" name="inSemiItemCntQty" value="QTY" /> <label for="inSemiItemCntQty1"><spring:message code="lbl.qty" /></label></li>
							</ul>
						</div>
						<div style="height: 88%" id="inSemiItemChart" ></div>
						</c:when>
						
						<c:when test="${popupChartSupplyTrend.chartId == 'urgentDemandCompRateChart'}">
                        <div class="view_combo" style="float: right;">
                            <ul class="rdofl">
	                             <!-- 월, 주간 -->
	                             <li><input type="radio" id="urgentDemandCompRateMonthWeek1" name="urgentDemandCompRateMonthWeek" value="MONTH"/> <label for="urgentDemandCompRateMonthWeek1"><spring:message code="lbl.month" /></label></li>
	                             <li><input type="radio" id="urgentDemandCompRateMonthWeek2" name="urgentDemandCompRateMonthWeek" value="WEEK" checked="checked"/> <label for="urgentDemandCompRateMonthWeek2"><spring:message code="lbl.weekly" /></label></li>
	                             <!-- 수량, 금액 -->
	                             <li><input type="radio" id="urgentDemandCompRateQtyAmt1" name="urgentDemandCompRateQtyAmt" value="QTY"/> <label for="urgentDemandCompRateQtyAmt1"><spring:message code="lbl.qty" /></label></li>
	                             <li><input type="radio" id="urgentDemandCompRateQtyAmt2" name="urgentDemandCompRateQtyAmt" value="AMT" checked="checked"/> <label for="urgentDemandCompRateQtyAmt2"><spring:message code="lbl.amt" />(<spring:message code="lbl.billion" />) </label></li>
	                             <!-- 파트전체, DIFF, TEL, LAM -->
	                             <li><input type="radio" id="urgentDemandCompRateAllPart" name="urgentDemandCompRatePart" value="ALL" checked="checked"/> <label for="urgentDemandCompRateAllPart"><spring:message code="lbl.partAll" /></label></li>
	                             <li><input type="radio" id="urgentDemandCompRateDiffPart" name="urgentDemandCompRatePart" value="DIFFUSION"/> <label for="urgentDemandCompRateDiffPart"><spring:message code="lbl.diff2" /> </label></li>
	                             <li><input type="radio" id="urgentDemandCompRateTELPart" name="urgentDemandCompRatePart" value="TEL"/> <label for="urgentDemandCompRateTELPart"><spring:message code="lbl.rcg004" /> </label></li>
	                             <li><input type="radio" id="urgentDemandCompRateLAMPart" name="urgentDemandCompRatePart" value="LAM"/> <label for="urgentDemandCompRateLAMPart"><spring:message code="lbl.rcg003" /> </label></li>
	                             
                            </ul>
                        </div>
                        <div style="height: 88%" id="urgentDemandCompRateChart" ></div>
                        </c:when>
                       
                        <c:when test="${popupChartSupplyTrend.chartId == 'salesResultAgainstProdPlan'}"> 
                        <div class="view_combo" style="float: right;cler:both;">
                            <ul class="rdofl">
                            	   <li><input type="radio" id="salesResultAgainstProdPlanTotal4" name="salesResultAgainstProdPlanTotal" value="DIFFUSION"/> 			 <label for="salesResultAgainstProdPlanTotal4"><spring:message code="lbl.diff2" /> </label></li>
                                    <li><input type="radio" id="salesResultAgainstProdPlanTotal3" name="salesResultAgainstProdPlanTotal" value="TEL"/> 					 <label for="salesResultAgainstProdPlanTotal3"><spring:message code="lbl.rcg004" /> </label></li>
                                    <li><input type="radio" id="salesResultAgainstProdPlanTotal2" name="salesResultAgainstProdPlanTotal" value="LAM"/> 					 <label for="salesResultAgainstProdPlanTotal2"><spring:message code="lbl.rcg003" /> </label></li>
                                    <li><input type="radio" id="salesResultAgainstProdPlanTotal1" name="salesResultAgainstProdPlanTotal" value="ALL" checked="checked"/> <label for="salesResultAgainstProdPlanTotal1"><spring:message code="lbl.total" /> </label></li>
                            </ul>
                        </div>
                        <div style="height: 88%;width:100%;" id="salesResultAgainstProdPlanChart" ></div>
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