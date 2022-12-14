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
	
	#cont_chart .col_3 { margin:0; width:calc((100% - 4px) / 3) ; height:calc((100% - 4px) / 3); position:relative;}
	#cont_chart .col_3:nth-child(1) {margin:0 2px 2px 0;}
	#cont_chart .col_3:nth-child(2) {margin:0 2px 2px 0;}
	#cont_chart .col_3:nth-child(3) {margin:0 0 2px 0;}
	#cont_chart .col_3:nth-child(4) {margin:0 2px 2px 0;}
	#cont_chart .col_3:nth-child(5) {margin:0 2px 2px 0;}
	#cont_chart .col_3:nth-child(6) {margin:0 0 2px 0;}
	#cont_chart .col_3:nth-child(7) {margin:0 2px 0 0;}
	#cont_chart .col_3:nth-child(8) {margin:0 2px 0 0;}
	
	#cont_chart .col_3 .textwrap { padding : 10px 0 0 0; }
	
	#cont_chart .col_3_tmp h4 { margin-bottom: 10px; }
	
	
	#cont_chart .col_3 > .titleContainer > h4
	{
		float:left;

	}
	#cont_chart .col_3 > .titleContainer > h4 > p
    {
        display:inline-block;
        padding-left:5px;
		font-weight:bold;
		position:relative;
		left:50%;
		
    }
    
    #cont_chart .col_3 > .titleContainer > h4 > p.green
    {
        color: green;
        
    }
    #cont_chart .col_3 > .titleContainer > h4 > p.red
    {
        color:red;
    }
    
    
	
	#cont_chart .col_3 > .titleContainer > div
	{
		float:right;
	}
	
	
	#cont_chart3 {
		height: 100%;
		width: 240px;
		float: left;
		margin-left: 10px;
	}
	
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
	
	
	#cont_chart .col_3 > .modal
    {
        height: 100%;
        left: 0;
        position: relative;
        top: 0;
        width: 100%;
        display:flex;
        flex-direction:column;
        overflow:auto;
    }
    
    #cont_chart .col_3 > .modal_header
    {
        height:25px;
        
    }
    
    #cont_chart .col_3 > .modal_content
    {
       
        height:auto;
        overflow-y:scroll;
        padding: 10px 15px 10px 15px;
        flex:1;
        display:flex;
        flex-direction:column
        
    }
	
	
    #cont_chart .col_3 > .titleContainer > .action {
    
      position: absolute;
      top: 5px;
      right: 5px;
      width: 30px;
      height: 30px;
      background: #fff;
      border-radius: 50%;
      cursor: pointer;
      box-shadow: 0 5px 5px rgba(0,0,0,0.1);
      z-index:999;
   }
    
    #cont_chart .col_3 > .titleContainer > .action span {
      
      position: absolute;
      width: 100%;
      height: 100%;
      display: flex;
      justify-content: center;
      align-items: center;
      color: #1f5bb6;
      font-size: 2em;
      transition: .3s ease-in-out;
     
    }
    
    #cont_chart .col_3 > .titleContainer > .action.active span  {
  
     transform: rotate(-135deg);
     position: absolute;
    }
    
    
    #cont_chart .col_3 > .titleContainer > .action ul {
    
      position: relative;
      top: -5px;
      right:125px;
      background: #fff;
      width: 100px;
      height:140px;
      padding: 10px;
      border-radius: 20px;
      opacity: 0;
      visibility: hidden;
      transition: .3s;
      z-index:999;
      display:block;
      box-shadow: 0 5px 5px rgba(0,0,0,0.1);
      overflow-y:scroll;
      overflow-x:hidden;
    }
    
    #cont_chart .col_3 > .titleContainer > .action.active ul {
    
      top: 0px;
      right:125px;
      width: 100px;
      padding: 10px;
      opacity: 1;
      visibility: visible;
      transition: .3s;
      background: white;
      z-index:999;
      display:block;
      box-shadow: 0 5px 5px rgba(0,0,0,0.1);
      overflow-y:scroll;
      overflow-x:hidden;
    }
    
    
      #cont_chart .col_3 > .titleContainer > .action ul::-webkit-scrollbar-track
     {
        background-color: white;
       border-radius: 10px;
     }
    
    #cont_chart .col_3 > .titleContainer > .action ul::-webkit-scrollbar
     {
     width: 10px;
     background-color: white;
     }
     
     #cont_chart .col_3 > .titleContainer > .action ul::-webkit-scrollbar-thumb
     {
      border-radius: 10px;
    background-color: white;
    
   
     }
    
    
    
    
    
    
     #cont_chart .col_3 > .titleContainer > .action.active ul::-webkit-scrollbar-track
     {
        background-color: transparent;
     
     }
    
    #cont_chart .col_3 > .titleContainer > .action.active ul::-webkit-scrollbar
     {
     width: 10px;
    background-color: transparent;
     
     }
     
     #cont_chart .col_3 > .titleContainer > .action.active ul::-webkit-scrollbar-thumb
     {
    background-color: #0ae;
    
    background-image: -webkit-gradient(linear, 0 0, 0 100%,
                       color-stop(.5, rgba(255, 255, 255, .2)),
                       color-stop(.5, transparent), to(transparent));
     
     }
    
    
    #cont_chart .col_3 > .titleContainer > .action ul > li {
    
      list-style:none;
       text-decoration: none;
      display: block;
      justify-content: flex-start;
      align-items: center;
      padding: 0;
      position:relative;
    }
    
    #cont_chart .col_3 > .titleContainer > .action ul > li.manuel {
    
      display: block;
    }
    
    
    #cont_chart .col_3 > .titleContainer > .action ul > li:hover {
    
     font-weight: 600;
    
    }
    
    #cont_chart .col_3 > .titleContainer > .action ul > li:not(:last-child) {
    
    /* 
     border-bottom: 1px solid rgba(0,0,0,0.1);
    */
    }
    
	
	</style>	
	
	<script type="text/javascript">
	var quill_1,quill_2,quill_3,quill_4,quill_5,quill_6;
	var unit = 0;
	var unit2 = 0;
	var demendTrend2 = {

		init : function () {
			gfn_formLoad();
			fn_siteMap();
		    
			fn_quilljsInit();
			
			this.initSearch();
			this.events();
			
			var userLang = "${sessionScope.GV_LANG}";
			
			if(userLang == "ko"){
	    		unit = 100000000;
	    		unit2 = 10000;
	    	}else if(userLang == "en" || userLang == "cn"){
	    		unit = 1000000000;
	    		unit2 = 1000;
	    	}
		},
	
		_siq	: "dashboard.demendTrend.",
		
		events : function () {
			
			$(':radio[name=trend5]').on('change', function () {
				var str = '<spring:message code="lbl.pitChart" />(<spring:message code="lbl.hMillion" />, <spring:message code="lbl.dayChart" />)';
				
				if($(this).val() == "amt") {
					str = '<spring:message code="lbl.pitChart" />(<spring:message code="lbl.hMillion" />)';
				}
				
				$("#chart8_title").html(str);
				
				demendTrend2.trend5Search(false);
			});
			
			$(':radio[name=trend5_type]').on('change', function () {
				demendTrend2.trend5Search(false);
			});
			
			$(':radio[name=companyCons]').on('change', function () {
				demendTrend2.trend5Search(false);
			});
			
			$(':radio[name=trend5_weekMonth_type]').on('change', function () {
				demendTrend2.trend5Search(false);
			});
			
			$(':radio[name=demandForecastWeekMonth]').on('change', function () {
				demendTrend2.demandForecastSearch(false);
			});
			
			$(':radio[name=dmdSeries]').on('change', function () {
				demendTrend2.demandForecastSearch(false);
			});
			
			$(':radio[name=demandForecastType]').on('change', function () {
				demendTrend2.demandForecastSearch(false);
			});
			
			$(':radio[name=demandForecastAmtQty]').on('change', function () {
				
				var str = '<spring:message code="lbl.demandForecast" />';
				
				if($(this).val() == "AMT") {
					str = '<spring:message code="lbl.demandForecast" />(<spring:message code="lbl.hMillion" />)';
				}
				
				$("#demandForecastH4").html(str);
				
				demendTrend2.demandForecastSearch(false);
			});
			
			$(':radio[name=onTimeDeliveryType]').on('change', function () {
				demendTrend2.onTimeDeliverySearch(false);
			});
			
			
			// ????????? ????????? ?????? ??????
			var arrTitle = $("h4");
	    	
			$.each(arrTitle, function(n, v) {
	    		$(v).css("cursor", "pointer");
	    		$(v).on("click", function() {
	    			if (n == 0) gfn_newTab("SNOP205");
	    			else if (n == 1) gfn_newTab("DP304");
	    			else if (n == 2) gfn_newTab("DP313");
	    			else if (n == 3) gfn_newTab("SNOP205");
	    			else if (n == 4) gfn_newTab("DP216");
	    			else if (n == 5) gfn_newTab("DP101");
	    			else if (n == 6) return;
	    			else if (n == 7) return;
	    			else if (n == 8) return;
	    		});
	    	});
			
		     
	        $(".manuel > a").dblclick("on", function() {
	            
	            var chartId  = this.id;
	    
	            fn_popUpAuthorityHasOrNot();
	            
	            var isSCMTeam = SCM_SEARCH.isSCMTeam;
	            
	            if(isSCMTeam>=1)
	            {
	            	//???????????? ??????
	            	if(chartId == "inventoryRatioStatus")
	            	{
	            		gfn_comPopupOpen("DASHBOARD_CHART_INFO", {
	                        rootUrl   : "dashboard",
	                        url       : "dashBoardChartInfoPopup",
	                        width     : 600,
	                        height    : 600,
	                        chartId   : chartId,
	                        title     : "Dashboard Chart Info"
	                    });
	            	}
	            	//On-Time Delivery Rate
	            	else if(chartId == "onTimeDeliveryRate")
	            	{
	            		gfn_comPopupOpen("DASHBOARD_CHART_INFO", {
	                        rootUrl   : "dashboard",
	                        url       : "dashBoardChartInfoPopup",
	                        width     : 600,
	                        height    : 600,
	                        chartId   : chartId,
	                        title     : "Dashboard Chart Info"
	                    });
	            	}
	            	//LAM Consignment TREND
	            	else if(chartId == "lamConsignmentTREND")
                    {
	            		gfn_comPopupOpen("DASHBOARD_CHART_INFO", {
	                        rootUrl   : "dashboard",
	                        url       : "dashBoardChartInfoPopup",
	                        width     : 600,
	                        height    : 600,
	                        chartId   : chartId,
	                        title     : "Dashboard Chart Info"
	                    });
                    }
	            	//?????? ??????
	            	else if(chartId == "productInventory")
                    {
	            		gfn_comPopupOpen("DASHBOARD_CHART_INFO", {
	                        rootUrl   : "dashboard",
	                        url       : "dashBoardChartInfoPopup",
	                        width     : 600,
	                        height    : 600,
	                        chartId   : chartId,
	                        title     : "Dashboard Chart Info"
	                    });
                    }
	            	//AP2 ???????????? TREND
	            	else if(chartId == "ap2ShipmentPlanTREND")
                    {
	            		gfn_comPopupOpen("DASHBOARD_CHART_INFO", {
	                        rootUrl   : "dashboard",
	                        url       : "dashBoardChartInfoPopup",
	                        width     : 600,
	                        height    : 600,
	                        chartId   : chartId,
	                        title     : "Dashboard Chart Info"
	                    });
                    }
	            	
	            	//???????????? ?????? ??????(??????)
                    else if(chartId == "salesResultAgainstBizPlan")
                    {
                        gfn_comPopupOpen("DASHBOARD_CHART_INFO", {
                            rootUrl   : "dashboard",
                            url       : "dashBoardChartInfoPopup",
                            width     : 600,
                            height    : 600,
                            chartId   : chartId,
                            title     : "Dashboard Chart Info"
                        });
                    }
                    
	            	
	            	
	            }
	            
	        });
			
	        
	        
	        $(".manuel > a").click("on", function() {
	           	            
	            var chartId  = this.id;
	            
	            
	          //???????????? ??????
                if(chartId == "inventoryRatioStatus")
                {
                	$('#invRateInfoChart').toggle();
                	$('#inventoryRatioStatusContent').toggle();
                }
                //On-Time Delivery Rate
                else if(chartId == "onTimeDeliveryRate")
                {
                	$('#onTimeDeliveryChart').toggle();
                    $('#onTimeDeliveryRateContent').toggle();
                }
                //LAM Consignment TREND
                else if(chartId == "lamConsignmentTREND")
                {
                	$('#lamConTrendChart').toggle();
                    $('#lamConsignmentTRENDContent').toggle();
                }
                //?????? ??????
                else if(chartId == "productInventory")
                {
                	$('#chart8').toggle();
                    $('#productInventoryContent').toggle();
                }
                //AP2 ???????????? TREND
                else if(chartId == "ap2ShipmentPlanTREND")
                {
                	$('#demandForecastChart').toggle();
                    $('#ap2ShipmentPlanTRENDContent').toggle();
                }
                //???????????? ?????? ??????(??????)
                else if(chartId == "salesResultAgainstBizPlan")
                {
                    $('#salesResultAgainstBizPlanChart').toggle();
                    $('#salesResultAgainstBizPlanContent').toggle();
                }

	          
	            
	            
	        });
	        
	        $(".titleContainer > h4").hover(function() {
	            
	            var chartId  = this.id;
	            
	            
	              //???????????? ??????
	                if(chartId == "inventoryRatioStatusH4")
	                {
	                    $('#invRateInfoChart').toggle();
	                    $('#inventoryRatioStatusContent').toggle();
	                }
	                //On-Time Delivery Rate
	                else if(chartId == "onTimeDeliveryRateH4")
	                {
	                    $('#onTimeDeliveryChart').toggle();
	                    $('#onTimeDeliveryRateContent').toggle();
	                }
	                //LAM Consignment TREND
	                else if(chartId == "lamConsignmentTRENDH4")
	                {
	                    $('#lamConTrendChart').toggle();
	                    $('#lamConsignmentTRENDContent').toggle();
	                }
	                //?????? ??????
	                else if(chartId == "chart8_title")
	                {
	                    $('#chart8').toggle();
	                    $('#productInventoryContent').toggle();
	                }
	                //AP2 ???????????? TREND
	                else if(chartId == "demandForecastH4")
	                {
	                    $('#demandForecastChart').toggle();
	                    $('#ap2ShipmentPlanTRENDContent').toggle();
	                }
	                //???????????? ?????? ??????(??????)
                    else if(chartId == "salesResultAgainstBizPlanH4")
                    {
                        $('#salesResultAgainstBizPlanChart').toggle();
                        $('#salesResultAgainstBizPlanContent').toggle();
                    }
                  
	              
	        });
	        
	        
	        $('.titleContainer > .action').hover(function(){
                
                var chartId = this.id;
                
                
                if(chartId == 'productInventoryAction')
                {
                	productInventoryActionToggle();
                    
                }
                
                else if(chartId == 'ap2ShipmentPlanTRENDAction')
                {
                	ap2ShipmentPlanTRENDActionToggle();  
                
                }
                
            });
	        
			
		},
		
		bucket : null,
		
		initSearch : function (sqlFlag) {
			FORM_SEARCH = {}
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.tranData = [{ outDs : "week"  , _siq : demendTrend2._siq + "trendBucketWeek" }
								  , { outDs : "week2"  , _siq : demendTrend2._siq + "trendBucketWeek2" }
								  , { outDs : "month" , _siq : demendTrend2._siq + "trendBucketMonth" }
								  , { outDs : "month2" , _siq : demendTrend2._siq + "trendBucketMonth2" }
								  , { outDs : "month3" , _siq : demendTrend2._siq + "trendBucketMonth3" }
								  , { outDs : "chartList" , _siq : "dashboard.chartInfo.demandTrend2" }  
								  ];
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					demendTrend2.bucket = {};
					demendTrend2.bucket.week  = data.week;
					demendTrend2.bucket.week2  = data.week2;
					demendTrend2.bucket.month = data.month;
					demendTrend2.bucket.month2 = data.month2;
					demendTrend2.bucket.month3 = data.month3;
					FORM_SEARCH.chartList = data.chartList;
					
					fn_chartContentInit();
					demendTrend2.search();
				}
			}
			gfn_service(sMap, "obj");
		},
		
		search : function (sqlFlag) {
			
			FORM_SEARCH            = {};
			FORM_SEARCH            = this.bucket;
			FORM_SEARCH.trend5     = $(':radio[name=trend5]:checked').val();
			FORM_SEARCH.trend5_type = $(':radio[name=trend5_type]:checked').val();
			FORM_SEARCH.companyCons = $(':radio[name=companyCons]:checked').val();
			FORM_SEARCH.trend5_weekMonth_type = $(':radio[name=trend5_weekMonth_type]:checked').val();
			FORM_SEARCH.demandForecastWeekMonth = $(':radio[name=demandForecastWeekMonth]:checked').val();
			FORM_SEARCH.dmdSeries = $(':radio[name=dmdSeries]:checked').val();
			FORM_SEARCH.demandForecastType = $(':radio[name=demandForecastType]:checked').val();
			FORM_SEARCH.demandForecastAmtQty = $(':radio[name=demandForecastAmtQty]:checked').val();
			FORM_SEARCH.onTimeDeliveryType = $(':radio[name=onTimeDeliveryType]:checked').val();
			
			FORM_SEARCH._mtd       = "getList";
			FORM_SEARCH.sql        = sqlFlag;
			FORM_SEARCH.unit       = unit;
			FORM_SEARCH.unit2      = unit2;
			FORM_SEARCH.tranData   = [
				/* { outDs : "avgShipPriceChart", _siq : demendTrend2._siq + "avgShipPriceChart" }, */
				{ outDs : "lamConTrendChart", _siq : demendTrend2._siq + "lamConTrendChart" },
				{ outDs : "chart8", _siq : demendTrend2._siq + "chart8" },
				{ outDs : "demandForecastChart", _siq : demendTrend2._siq + "demandForecastChart" },
				{ outDs : "invRateInfoChart", _siq : demendTrend2._siq + "invRateInfoChart" },
				{ outDs : "salesResultAgainstBizPlan" , _siq : demendTrend2._siq + "salesResultAgainstBizPlan"  },
				<c:if test="${sessionScope.userInfo.dashboardYn == 'Y'}">
				{ outDs : "onTimeDeliveryChart", _siq : demendTrend2._siq + "onTimeDeliveryChart" },
				</c:if>
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					demendTrend2.drawChart(data);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		trend5Search : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = demendTrend2.bucket;
			FORM_SEARCH.trend5   = $(':radio[name=trend5]:checked').val();
			FORM_SEARCH.trend5_type = $(':radio[name=trend5_type]:checked').val();
			FORM_SEARCH.companyCons = $(':radio[name=companyCons]:checked').val();
			FORM_SEARCH.trend5_weekMonth_type = $(':radio[name=trend5_weekMonth_type]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = 
				[
					{ outDs : "chart8" , _siq : demendTrend2._siq + "chart8" } ,
				];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					// cartegory
					var arPreCate = new Array();
					var chart8 = JSON.parse(data.chart8[0].ITEM_INV);

					if(FORM_SEARCH.trend5_weekMonth_type == "WEEK"){
						$.each (demendTrend2.bucket.week, function (i, el) {
							arPreCate.push(el.DISWEEK);
						});
					}else{
						$.each (demendTrend2.bucket.month, function (i, el) {
							arPreCate.push(el.DISMONTH);
						});
					}

					demendTrend2.chartGen('chart8', 'line', arPreCate, chart8);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		demandForecastSearch : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = demendTrend2.bucket;
			FORM_SEARCH.demandForecastWeekMonth   = $(':radio[name=demandForecastWeekMonth]:checked').val();
			FORM_SEARCH.dmdSeries = $(':radio[name=dmdSeries]:checked').val();
			FORM_SEARCH.demandForecastType = $(':radio[name=demandForecastType]:checked').val();
			FORM_SEARCH.demandForecastAmtQty = $(':radio[name=demandForecastAmtQty]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "demandForecastChart" , _siq : demendTrend2._siq + "demandForecastChart" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					var arPreCate = new Array();
					var demandForecastChart = JSON.parse(data.demandForecastChart[0].DEMAND_FORECAST);

					if(FORM_SEARCH.demandForecastWeekMonth == "WEEK"){
						$.each (demendTrend2.bucket.week2, function (i, el) {
							arPreCate.push(el.DISWEEK);
						});
					}else{
						$.each (demendTrend2.bucket.month3, function (i, el) {
							arPreCate.push(el.DISMONTH);
						});
					}

					demendTrend2.chartGen('demandForecastChart', 'line', arPreCate, demandForecastChart);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		onTimeDeliverySearch : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = demendTrend2.bucket;
			FORM_SEARCH.onTimeDeliveryType = $(':radio[name=onTimeDeliveryType]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "onTimeDeliveryChart" , _siq : demendTrend2._siq + "onTimeDeliveryChart" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					
					var arPreWeek = new Array();
					
					$.each (demendTrend2.bucket.week, function (i, el) {
						arPreWeek.push(el.PRE_DISWEEK);
					});
					
					var onTimeDeliveryChart = JSON.parse(data.onTimeDeliveryChart[0].ON_TIME);
					demendTrend2.chartGen('onTimeDeliveryChart', 'line', arPreWeek, onTimeDeliveryChart);
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
			
			$.each (demendTrend2.bucket.month, function (i, el) {
				arMonth.push(el.DISMONTH);
				arPreMonth.push(el.PRE_DISMONTH);
			});
			
			$.each (demendTrend2.bucket.week, function (i, el) {
				arWeek.push(el.DISWEEK);
				arPreWeek.push(el.PRE_DISWEEK);
			});
			
			$.each (demendTrend2.bucket.month3, function (i, el) {
				arMonth3.push(el.DISMONTH);
				arPreMonth3.push(el.PRE_DISMONTH);
			});
			
			/* var avgShipPriceChart = JSON.parse(res.avgShipPriceChart[0].AVG_SHIP); */
			var chart8 = JSON.parse(res.chart8[0].ITEM_INV);
			var demandForecastChart = JSON.parse(res.demandForecastChart[0].DEMAND_FORECAST);
			
			
			/* this.chartGen('avgShipPriceChart', 'line', arPreMonth, avgShipPriceChart); */
			this.chartGen('chart8', 'line', arWeek, chart8);
			this.chartGen('demandForecastChart', 'line', arMonth3, demandForecastChart);
			
			
			<c:if test="${sessionScope.userInfo.dashboardYn == 'Y'}">
			var onTimeDeliveryChart = JSON.parse(res.onTimeDeliveryChart[0].ON_TIME);
			this.chartGen('onTimeDeliveryChart', 'line', arPreWeek, onTimeDeliveryChart);
			</c:if>
			
			
			
			//LAM CON TREND
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
			
			var chartIdLam = "lamConTrendChart";
			Highcharts.chart(chartIdLam, {
			    
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
						point: {
							events: {
								click: function() {
									
									if(chartIdLam == "lamConTrendChart") {
										gfn_comPopupOpen("POPUP_CHART_DEMEND", {
				        					rootUrl   : "dashboard",
				        					url       : "popupChartDemend",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : chartIdLam,
				        					title     : "<spring:message code='lbl.lamConTrend' /> (%)"
				        				});	
									} 
								}
							}
							
						},
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
			    		//allowOverlap : true, //total ???????????? ?????? ?????????
			    		//enabled: true
					}
	    	    }, { // right yAxis
	    	    	stackLabels: {
			    		//allowOverlap : true, //total ???????????? ?????? ?????????
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
			
            //???????????? ?????? ??????(??????)
            var codeNmArrSalesResultAgainstBizPlan = new Array();
            var lineData1SalesResultAgainstBizPlan = [], lineData2SalesResultAgainstBizPlan = [],lineData3SalesResultAgainstBizPlan = [];
            
            var latest_SALES_RESULT =  null;
            var latest_BIZ_PLAN     =  null;
            var latest_BILL_ORDER_RESULT = null;
            var today = new Date()
            var month = today.getMonth() + 1;  // ???
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
                    lineNm = trendMonth+'???';
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
                        codeNmArrSalesResultAgainstBizPlan.push("????????????");
                    }
                    else if(codeNm=='SALES_RESULT')
                    {
                        codeNmArrSalesResultAgainstBizPlan.push("????????????");
                    }
                    else if(codeNm=='BILL_ORDER_RESULT'){
                    	codeNmArrSalesResultAgainstBizPlan.push("????????????");
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
            
            // GAP1 ??????: ???????????? - ????????????
            // GAP2 ??????: ???????????? - ????????????
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
                        point: {
                            events: {
                                click: function() {
                                    
                                    if(chartIdSalesResultAgainstBizPlan == "salesResultAgainstBizPlanChart") {
                                        gfn_comPopupOpen("POPUP_CHART_DEMEND", {
                                            rootUrl   : "dashboard",
                                            url       : "popupChartDemend",
                                            width     : 1920,
                                            height    : 1060,
                                            menuCd    : "SNOP100",
                                            chartId   : "salesResultAgainstBizPlan",
                                            title     : "<spring:message code='lbl.salesResultAgainstBizPlan' />",
                                            
                                        }); 
                                    } 
                                }
                            }
                            
                        },
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
                        //allowOverlap : true, //total ???????????? ?????? ?????????
                        //enabled: true
                    }
                }, { // right yAxis
                    stackLabels: {
                        //allowOverlap : true, //total ???????????? ?????? ?????????
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
	                }, 
	                {
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
            	

                // 							            ??? ????????? label??? ???????????? ??????
                var point = chart.series[0].points[5];
                
             	var pxX = chart.xAxis[0].toPixels(point.x, true);
                var pxY = chart.yAxis[0].toPixels(point.y, true);
                
                chart.renderer.label('???????????? '+GAP1+'<br/>'+'???????????? '+GAP2, pxX, pxY, 'callout', point.plotX + chart.plotLeft, point.plotY + chart.plotTop)
                    .css({
                        color: '#FFFFFF'
                    })
                    .attr({
                        fill: 'rgba(140,190,214,0.75)',
                        padding: 8,
                        r: 5,
                        zIndex: 6
                    })
                    .add();
                
                
            	
            });
            
			//???????????? ??????
			columnData1 = [], columnData2 = [], lineData1 = [];
			
			
			$.each(res.invRateInfoChart, function(i, val){
				
				var repCustGroupNm = val.REP_CUST_GROUP_NM;
				var salesAmt = gfn_nvl(val.SALES_AMT, 0);
				var invAmt = gfn_nvl(val.INV_AMT, 0);
				var rate = gfn_nvl(val.RATE, 0);
				
				
				columnData1.push({name: repCustGroupNm, y: salesAmt, color: gv_cColor1});
				columnData2.push({name: repCustGroupNm, y: invAmt, color: gv_cColor2});
				lineData1.push({name: repCustGroupNm, y: rate, color: gv_cColor3});
			});
			
			var chartIdInv = "invRateInfoChart";
			Highcharts.chart(chartIdInv, {
			    
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
							afterAnimate : function(e){
								
								/* var chartLen = this.chart.series.length;
								
								if(chartIdInv == "invRateInfoChart") {
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
			                			    	
			            	},// end of legendItemClick
						},
						
						point: {
							events: {
								click: function() {
									if(chartIdInv == "invRateInfoChart") {
										gfn_comPopupOpen("POPUP_CHART_DEMEND", {
				        					rootUrl   : "dashboard",
				        					url       : "popupChartDemend",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : chartIdInv,
				        					title     : "<spring:message code='lbl.invRateInfo' /> "
				        				});	
									} 
								}
								
							}
						}
			        }
			    },
			    
			    yAxis: [{ // left yAxis
			    	stackLabels: {
			    		//allowOverlap : true, //total ???????????? ?????? ?????????
			    		//enabled: true
					}
	    	    }, { // right yAxis
	    	    	stackLabels: {
			    		//allowOverlap : true, //total ???????????? ?????? ?????????
			    		//enabled: false
					}
	    	    }],
			    series: [
			        {
			            data: columnData1,
			            stack: 0,
			            type: 'column',
			            name: '<spring:message code="lbl.preMonthSales" /> (<spring:message code="lbl.hMillion" />)'
			            
			        }, {
			            data: columnData2,
			            stack: 1,
			            type: 'column',
			            name: '<spring:message code="lbl.curCompanyInv" /> (<spring:message code="lbl.hMillion" />)'
			        }, {
			            data: lineData1,
			            type: 'line',
			            name: '<spring:message code="lbl.invRate" /> (%)',
			            yAxis: 1
			        }
			    ]
			});
			
			
 			
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
						events: {
							afterAnimate : function(e){
			        			var chartLen = this.chart.series.length;
			        			var chart23RadioData = $(':radio[name=chart23Radio]:checked').val();
			        			
			        			if(chartId == "chart23") {
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
						},							
						cursor: 'pointer',
						point: {
							events: {
								click: function() {
									/* if(chartId == "avgShipPriceChart") {
										gfn_comPopupOpen("POPUP_CHART_DEMEND", {
											rootUrl   : "dashboard",
											url       : "popupChartDemend",
											width     : 1920,
											height    : 1060,
											menuCd    : "SNOP100",
											chartId   : chartId,
											title     : "<spring:message code='lbl.avgShipPrice' /> "
										});
									} else */ if(chartId == "chart8") {
										gfn_comPopupOpen("POPUP_CHART_DEMEND", {
				        					rootUrl   : "dashboard",
				        					url       : "popupChartDemend",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : chartId,
				        					title     : '<spring:message code="lbl.pitChart" /> (<spring:message code="lbl.hMillion" />)'
				        				});	
									} else if(chartId == "demandForecastChart") {
										gfn_comPopupOpen("POPUP_CHART_DEMEND", {
				        					rootUrl   : "dashboard",
				        					url       : "popupChartDemend",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : chartId,
				        					title     : '<spring:message code="lbl.demandForecast" />(<spring:message code="lbl.hMillion" />)'
				        				});	
									} else if(chartId == "onTimeDeliveryChart") {
										gfn_comPopupOpen("POPUP_CHART_DEMEND", {
				        					rootUrl   : "dashboard",
				        					url       : "popupChartDemend",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : chartId,
				        					title     : '<spring:message code="lbl.onTimeDelivery" />'
				        				});	
									} 
								}
							}
						}
					}
				}
			};
			
			Highcharts.chart(chartId, chart);
			
			//???????????? ?????? ??? ??? ???????????? ?????? 
			$("#" + chartId).css("overflow", "");
		}
	};
	
	function cpfrTrendPop(){
		gfn_comPopupOpen("POPUP_CHART_DEMEND", {
			rootUrl   : "dashboard",
			url       : "popupChartDemend",
			width     : 1920,
			height    : 1060,
			menuCd    : "SNOP100",
			chartId   : "cpfrTrend",
			title     : "<spring:message code='lbl.cpfrTrend' /> (<spring:message code='lbl.hMillion' />)"
		});
	}
	
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
					fontFamily: 'NotoSansB'
				}
			},
			title: {
				text: null ,
				style: {
					color: '#000',
					font: 'bold 16px "NotoSansB", Verdana, sans-serif'
				}
			},
			subtitle: {
				style: {
					color: '#666666',
					font: 'bold 12px "NotoSansB", Verdana, sans-serif'
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
		
		//???????????? set
		Highcharts.theme = theme;
		
		// Apply the theme
		Highcharts.setOptions(Highcharts.theme);
	}
	
	//??????
	function fn_apply(sqlFlag) {
		demendTrend2.search(sqlFlag);
	}
	
 	// onload 
	$(document).ready(function() {
		demendTrend2.init();
	});
	


	  function fn_popUpAuthorityHasOrNot(){
	        
	        SCM_SEARCH = {}; // ?????????
	        
	        SCM_SEARCH.USER_ID = "${sessionScope.userInfo.userId}" ;
	        
	        
	        SCM_SEARCH._mtd     = "getList";
	        SCM_SEARCH.tranData = [
	                               { outDs : "isSCMTeam",_siq : "dashboard.chartInfo.isSCMTeam"}
	                            ];
	        
	        
	        
	        var aOption = {
	            async   : false,
	            url     : GV_CONTEXT_PATH + "/biz/obj",
	            data    : SCM_SEARCH,
	            success : function (data) {
	            
	                if (SCM_SEARCH.sql == 'N') {
	                    
	                    SCM_SEARCH.isSCMTeam = data.isSCMTeam[0].isSCMTeam;
	                
	                }
	            }
	        }
	        
	        gfn_service(aOption, "obj");
	        
	        
	        
	        
	    }
 	
	  var fn_popupCallback = function () {
	         location.reload();
	    }
	  
 	
	  function fn_quilljsInit(){
		  

          quill_1 =  new Quill('#editor-1', {
                        
                        modules: {
                            "toolbar": false
                        } ,            
                        theme: 'snow'  // or 'bubble'
                      })
          quill_1.enable(false);
          
          
          quill_2 =  new Quill('#editor-2', {
              
              modules: {
                  "toolbar": false
              } ,            
              theme: 'snow'  // or 'bubble'
            })
          quill_2.enable(false);
          
          
          quill_3 =  new Quill('#editor-3', {
              
              modules: {
                  "toolbar": false
              } ,            
              theme: 'snow'  // or 'bubble'
            })
          quill_3.enable(false);
          
          
          
          quill_4 =  new Quill('#editor-4', {
              
              modules: {
                  "toolbar": false
              } ,            
              theme: 'snow'  // or 'bubble'
            })
          quill_4.enable(false);
          
          
          
          quill_5 =  new Quill('#editor-5', {
              
              modules: {
                  "toolbar": false
              } ,            
              theme: 'snow'  // or 'bubble'
            })
          quill_5.enable(false);
          
          
          
          quill_6 =  new Quill('#editor-6', {
              
              modules: {
                  "toolbar": false
              } ,            
              theme: 'snow'  // or 'bubble'
            })
          quill_6.enable(false);
          
          
          
      
  }
	  
	  function fn_chartContentInit(){
	      
	    
		  /*
		    0. inventoryRatioStatus
			1. onTimeDeliveryRate
			2. lamConsignmentTREND
			3. productInventory
			4. ap2ShipmentPlanTREND
		  */
		  
		  
	      
	      for(i=0;i<FORM_SEARCH.chartList.length;i++)
	      {
	          if(FORM_SEARCH.chartList[i].ID=="inventoryRatioStatus")                FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_1.setContents([{ insert: '\n' }]):quill_1.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
	          else if(FORM_SEARCH.chartList[i].ID=="onTimeDeliveryRate")             FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_2.setContents([{ insert: '\n' }]):quill_2.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
	          else if(FORM_SEARCH.chartList[i].ID=="lamConsignmentTREND")            FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_3.setContents([{ insert: '\n' }]):quill_3.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
	          else if(FORM_SEARCH.chartList[i].ID=="productInventory")               FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_4.setContents([{ insert: '\n' }]):quill_4.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
	          else if(FORM_SEARCH.chartList[i].ID=="ap2ShipmentPlanTREND")           FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_5.setContents([{ insert: '\n' }]):quill_5.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
	          else if(FORM_SEARCH.chartList[i].ID=="salesResultAgainstBizPlan")      FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_6.setContents([{ insert: '\n' }]):quill_6.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));                            
	      }
	      
	      
	      
	  }
 	
	  
	  function productInventoryActionToggle()
	  {
		  const action = $('#productInventoryAction');
	         
	         action.toggleClass('active')
	  }
      
  
      function ap2ShipmentPlanTRENDActionToggle()  
      {
    	  const action = $('#ap2ShipmentPlanTRENDAction');
          
          action.toggleClass('active')
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
					<!-- ???????????? ?????? -->
					<div class="col_3" >
					    <div class="titleContainer">
							<h4 id="inventoryRatioStatusH4"><spring:message code="lbl.invRateInfo" /></h4>
							<div class="view_combo">
							     <ul class="rdofl">
                                     <li class="manuel">
	                                    <a href="#" id="inventoryRatioStatus"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
	                                 </li>
	                            </ul>
							</div>
						</div>
						<div style="height: 100%;clear:both;" id="invRateInfoChart" ></div>
						<div class="modal" id="inventoryRatioStatusContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-1"></div>
                           </div>
                       </div>
					</div>
					<%-- <div class="col_3" >
						<h4><spring:message code="lbl.avgShipPrice" /></h4>
						<div class="view_combo" style="float: right;">
						</div>
						<div style="height: 88%" id="avgShipPriceChart" ></div>
					</div> --%>
					
					<!-- On-Time Delivery ????????? -->
					<c:if test="${sessionScope.userInfo.dashboardYn == 'Y'}">
					<div class="col_3" >
						 <div class="titleContainer">
                        
						      <h4 id="onTimeDeliveryRateH4"><spring:message code="lbl.onTimeDelivery" /></h4>
							  <div class="view_combo" >
								<ul class="rdofl">
									<li><input type="radio" id="onTimeDeliveryType1" name="onTimeDeliveryType" value="repCust" checked="checked"/><label for="onTimeDeliveryType1"><spring:message code="lbl.reptCust" /> </label></li>
									<li><input type="radio" id="onTimeDeliveryType2" name="onTimeDeliveryType" value="total"/><label for="onTimeDeliveryType2"><spring:message code="lbl.total" /></label></li>
								    <li class="manuel">
                                        <a href="#" id="onTimeDeliveryRate"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                     </li>
								</ul>
							  </div>
						</div>
						<div style="height: 100%;clear:both;" id="onTimeDeliveryChart" ></div>
						<div class="modal" id="onTimeDeliveryRateContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-2"></div>
                           </div>
                       </div>
					</div>
					</c:if>
					<c:if test="${sessionScope.userInfo.dashboardYn != 'Y'}">
					<div class="col_3" >
						<h4></h4>
						<div class="view_combo" >
						</div>
						<div style="height: 88%" id="onTimeDeliveryChart" ></div>
						<div class="modal" id="onTimeDeliveryRateContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-2"></div>
                           </div>
                       </div>
					</div>
					</c:if>
					
					<!-- LAM Consignment TREND -->
					<div class="col_3" >
					    <div class="titleContainer">
							<h4 id="lamConsignmentTRENDH4"><spring:message code="lbl.lamConTrend" /></h4>
							<div class="view_combo" >
							     <ul class="rdofl">
                                    <li class="manuel">
                                        <a href="#" id="lamConsignmentTREND"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                     </li>
                                </ul>
							</div>
						</div>
						<div style="height: 100%;clear:both;" id="lamConTrendChart" ></div>
						<div class="modal" id="lamConsignmentTRENDContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-3"></div>
                           </div>
                       </div>
					</div>
					
					<!-- ?????? ?????? -->
					<div class="col_3">
						<div class="titleContainer">
                            
						    <h4 id="chart8_title"><spring:message code="lbl.pitChart" />(<spring:message code="lbl.hMillion" />)</h4>
						
							<div class="view_combo"> <!-- class= "action" id="productInventoryAction"  -->
								<!--  <span>+</span> -->
								<ul class="rdofl">
									<li><input type="radio" id="companyCons1" name="companyCons" value="companyCons"/> <label for="companyCons1"><spring:message code="lbl.companyCons" /></label></li>
									<li><input type="radio" id="companyCons2" name="companyCons" value="company" checked="checked"/> <label for="companyCons2"><spring:message code="lbl.company2" /> </label></li>
									<li><input type="radio" id="trend5_weekMonth_type1" name="trend5_weekMonth_type" value="WEEK" checked="checked"/> <label for="trend5_weekMonth_type1"><spring:message code="lbl.weekly" /></label></li>
									<li><input type="radio" id="trend5_weekMonth_type2" name="trend5_weekMonth_type" value="MONTH"/> <label for="trend5_weekMonth_type2"><spring:message code="lbl.month2" /></label></li>
									<li><input type="radio" id="trend5_type1" name="trend5_type" value="COST"> <label for="trend5_type1"><spring:message code="lbl.costChart" /></label></li>
									<li><input type="radio" id="trend5_type2" name="trend5_type" value="PRICE" checked="checked"/><label for="trend5_type2"><spring:message code="lbl.amtChart" /></label></li>
									<li><input type="radio" id="trend5_amt" name="trend5" value="amt" checked="checked"/><label for="trend5_amt"><spring:message code="lbl.amt" /></label></li>
									<li><input type="radio" id="trend5_day" name="trend5" value="day"/><label for="trend5_day"><spring:message code="lbl.days" /> </label></li>
								    <li class="manuel">
                                        <a href="#" id="productInventory"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                     </li>
								</ul>
							</div>
						</div>
						<div style="height: 80%;clear:both;" id="chart8"></div>
						<div class="modal" id="productInventoryContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-4"></div>
                           </div>
                       </div>
					</div>
					<!-- AP2 ???????????? TREND -->
					<div class="col_3" >
						<div class= "titleContainer">
                        
						    <h4 id="demandForecastH4"><spring:message code="lbl.demandForecast" />(<spring:message code="lbl.hMillion" />)</h4>
							
							<div class="view_combo"> <!--class="action" id="ap2ShipmentPlanTRENDAction"  -->
								<!--<span>+</span>-->
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
								    <li class="manuel">
                                        <a href="#" id="ap2ShipmentPlanTREND"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                    </li>
								</ul>
							</div>
						</div>
						<div style="height: 80%;clear:both;" id="demandForecastChart" ></div>
						<div class="modal" id="ap2ShipmentPlanTRENDContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-5"></div>
                           </div>
                       </div>
					</div>
					
					<!-- ???????????? ?????? ??????(??????)  -->
					<div class="col_3">
					
					    <div class="titleContainer">
                            <h4 id="salesResultAgainstBizPlanH4"><spring:message code="lbl.salesResultAgainstBizPlan" /></h4>
                            <div class="view_combo" >
                                 <ul class="rdofl">
                                    <li class="manuel">
                                        <a href="#" id="salesResultAgainstBizPlan"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <div style="height: 100%;clear:both;" id="salesResultAgainstBizPlanChart" ></div>
                        <div class="modal" id="salesResultAgainstBizPlanContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-6"></div>
                           </div>
                       </div>
					
					
					</div>
				
					
					<div class="col_3" >
						<h4></h4>
						<div class="view_combo" style="float: right;">
						</div>
						<div style="height: 88%" id="asdasd2222" ></div>
					</div>
					
					
					<div class="col_3" >
						<h4></h4>
						<div class="view_combo" style="float: right;">
						</div>
						<div style="height: 88%" id="qweqwe" ></div>
					</div>
					
					<div class="col_3" >
						<h4></h4>
						<div class="view_combo" style="float: right;">
						</div>
						<div style="height: 88%" id="sad" ></div>
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
