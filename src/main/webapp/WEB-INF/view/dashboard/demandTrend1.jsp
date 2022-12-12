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
	
	#cont_chart .col_3 .textwrap { padding : 5px 0 0 0; }
	
	#cont_chart .col_3 > .titleContainer > h4{
		float:left;
	}
	
	#cont_chart .col_3 > .titleContainer > div{
		float:right;
	}
	
	
	#cont_chart .col_3_tmp h4 { margin-bottom: 10px; }
	
	
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
		font-size:12px;
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
	var quill_1,quill_2,quill_3,quill_4,quill_5,quill_6,quill_7,quill_8,quill_9;
	var unit = 0;
	var demendTrend1 = {

		init : function () {
			gfn_formLoad();
			fn_siteMap();


            fn_quilljsInit();
            
			
			this.initSearch();
			this.events();
			
			var userLang = "${sessionScope.GV_LANG}";
			
			if(userLang == "ko"){
	    		unit = 100000000;
	    	}else if(userLang == "en" || userLang == "cn"){
	    		unit = 1000000000;
	    	}
			
		},
	
		_siq	: "dashboard.demendTrend.",
		
		events : function () {
			$(':radio[name=sales]').on('change', function () {
				demendTrend1.salesSearch(false);
			});
			$(':radio[name=salesInv]').on('change', function () {
				demendTrend1.salesSearch(false);
			});
			
			$(':radio[name=salesFcst]').on('change', function () {
				demendTrend1.salesFcstSearch(false);
			});
			
			$(':radio[name=achivRt]').on('change', function () {
				demendTrend1.achivRtSearch(false);
			});
			
			$(':radio[name=chart24_type]').on('change', function () {
				demendTrend1.chart24Search(false);
			});
			
			$(':radio[name=chart24_weekMonth_type]').on('change', function () {
				demendTrend1.chart24Search(false);
			});
			
			$(':radio[name=chart23Radio]').on('change', function () {
				demendTrend1.chart23RadioSearch(false);
			});
			
			$(':radio[name=chart2_type]').on('change', function () {
				demendTrend1.chart2Search(false);
			});
			
			$(':radio[name=chart2_weekMonth_type]').on('change', function () {
				demendTrend1.chart2Search(false);
			});
			
			$(':radio[name=operProfitType]').on('change', function () {
				demendTrend1.operProfitSearch(false);
			});
			
			// 타이틀 클릭시 메뉴 이동
			var arrTitle = $("h4");
	    	
			$.each(arrTitle, function(n, v) {
	    		$(v).css("cursor", "pointer");
	    		$(v).on("click", function() {
	    			if (n == 0) gfn_newTab("SNOP301");
	    			else if (n == 1) gfn_newTab("SNOP302");
	    			else if (n == 2) gfn_newTab("SNOP303");
	    			else if (n == 3) gfn_newTab("DP219");
	    			else if (n == 4) gfn_newTab("DP219");
	    			else if (n == 5) gfn_newTab("DP304");
	    			else if (n == 6) gfn_newTab("SNOP301");
	    			else if (n == 7) gfn_newTab("SNOP207");
	    			else if (n == 8) gfn_newTab("SNOP207");
	    		});
	    	});
			
			$(".manuel > a").dblclick("on", function() {
	            
	            var chartId  = this.id;
	        
	            fn_popUpAuthorityHasOrNot();
	            
	            var isSCMTeam = SCM_SEARCH.isSCMTeam;
	            
	            if(isSCMTeam>=1)
	            {
	            	//출하 준수율
	            	if(chartId == "shipmentComplianceRate")
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
	            	//출하 적중률
	            	else if(chartId == "shipmentHitRate")
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
	            	//출하 달성률
	            	else if(chartId == "shipmentAchievementRate")
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
	            	//CPFR 출하계획 TREND
	            	else if(chartId == "cpfrShipmentPlanTrend")
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
	            	//CPFR 출하계획 & 실적
	            	else if(chartId == "cpfrShipmentPlanNPerformance")
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
	            	//수주 잔량 (S/O)
	            	else if(chartId == "remainingOrderAmountSO")
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
	            	//출하 TREND
	            	else if(chartId == "shipmentTrend")
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
	            	//매출 TREND
	            	else if(chartId == "salesTrend")
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
	            	//영업이익
	            	else if(chartId == "operatingProfit")
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
		            

                    //출하 준수율
                    if(chartId == "shipmentComplianceRate")
                    {
                    	$('#chart10').toggle();
                    	$('#shipmentComplianceRateContent').toggle();
                    }
                    //출하 적중률
                    else if(chartId == "shipmentHitRate")
                    {
                        $('#chart11').toggle();
                        $('#shipmentHitRateContent').toggle();
                    }
                    //출하 달성률
                    else if(chartId == "shipmentAchievementRate")
                    {
                        $('#chart12').toggle();
                        $('#shipmentAchievementRateContent').toggle();
                    }
                    //CPFR 출하계획 TREND
                    else if(chartId == "cpfrShipmentPlanTrend")
                    {
                        $('#cpfrShipmentPlanTrendTable').toggle();
                        $('#cpfrShipmentPlanTrendContent').toggle();
                    }
                    //CPFR 출하계획 & 실적
                    else if(chartId == "cpfrShipmentPlanNPerformance")
                    {
                        $('#cpfrShipPlanResultChart').toggle();
                        $('#cpfrShipmentPlanNPerformanceContent').toggle();
                    }
                    //수주 잔량 (S/O)
                    else if(chartId == "remainingOrderAmountSO")
                    {
                        $('#chart23').toggle();
                        $('#remainingOrderAmountSOContent').toggle();
                    }
                    //출하 TREND
                    else if(chartId == "shipmentTrend")
                    {
                        $('#chart24').toggle();
                        $('#shipmentTrendContent').toggle();
                    }
                    //매출 TREND
                    else if(chartId == "salesTrend")
                    {
                        $('#chart2').toggle();
                        $('#salesTrendContent').toggle();
                    }
                    //영업이익
                    else if(chartId == "operatingProfit")
                    {
                        $('#operProfit').toggle();
                        $('#operatingProfitContent').toggle();
                    }
		            
		     });
			
		     $(".titleContainer > h4").hover(function() {
		            
		            var chartId  = this.id;
		            

                    //출하 준수율
                    if(chartId == "shipmentComplianceRateH4")
                    {
                        $('#chart10').toggle();
                        $('#shipmentComplianceRateContent').toggle();
                    }
                    //출하 적중률
                    else if(chartId == "shipmentHitRateH4")
                    {
                        $('#chart11').toggle();
                        $('#shipmentHitRateContent').toggle();
                    }
                    //출하 달성률
                    else if(chartId == "shipmentAchievementRateH4")
                    {
                        $('#chart12').toggle();
                        $('#shipmentAchievementRateContent').toggle();
                    }
                    //CPFR 출하계획 TREND
                    else if(chartId == "cpfrShipmentPlanTrendH4")
                    {
                        $('#cpfrShipmentPlanTrendTable').toggle();
                        $('#cpfrShipmentPlanTrendContent').toggle();
                    }
                    //CPFR 출하계획 & 실적
                    else if(chartId == "cpfrShipmentPlanNPerformanceH4")
                    {
                        $('#cpfrShipPlanResultChart').toggle();
                        $('#cpfrShipmentPlanNPerformanceContent').toggle();
                    }
                    //수주 잔량 (S/O)
                    else if(chartId == "remainingOrderAmountSOH4")
                    {
                        $('#chart23').toggle();
                        $('#remainingOrderAmountSOContent').toggle();
                    }
                    //출하 TREND
                    else if(chartId == "shipmentTrendH4")
                    {
                        $('#chart24').toggle();
                        $('#shipmentTrendContent').toggle();
                    }
                    //매출 TREND
                    else if(chartId == "salesTrendH4")
                    {
                        $('#chart2').toggle();
                        $('#salesTrendContent').toggle();
                    }
                    //영업이익
                    else if(chartId == "operatingProfitH4")
                    {
                        $('#operProfit').toggle();
                        $('#operatingProfitContent').toggle();
                    }
		            
		     });
		     
		     /*
		     $('.titleContainer > .action').hover(function(){
		    	
		    	 var chartId = this.id;
	                
	                
	                if(chartId == 'shipmentTrendAction')
	                {
	                	shipmentTrendActionToggle();
	                    
	                }
	                
	                else if(chartId == 'salesTrendAction')
	                {
	                	salesTrendActionToggle();  
	                
	                }
		    	 
		    	 
		     });
		     */
		     
		},
		
		bucket : null,
		
		initSearch : function (sqlFlag) {
			FORM_SEARCH = {}
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.tranData = [{ outDs : "week"  , _siq : demendTrend1._siq + "trendBucketWeek" }
								  , { outDs : "month" , _siq : demendTrend1._siq + "trendBucketMonth" }
								  , { outDs : "month2" , _siq : demendTrend1._siq + "trendBucketMonth2" }
								  , { outDs : "chartList" , _siq : "dashboard.chartInfo.demandTrend1" }
								  ];
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					demendTrend1.bucket = {};
					demendTrend1.bucket.week  = data.week;
					demendTrend1.bucket.month = data.month;
					demendTrend1.bucket.month2 = data.month2;
					demendTrend1.bucket.monthChart11 = data.month.slice(0,data.month.length-1);
					FORM_SEARCH.chartList = data.chartList;
					fn_chartContentInit();
					demendTrend1.search();
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
			FORM_SEARCH.chart24_type   = $(':radio[name=chart24_type]:checked').val();
			FORM_SEARCH.chart24_weekMonth_type   = $(':radio[name=chart24_weekMonth_type]:checked').val();
			FORM_SEARCH.chart23Radio   = $(':radio[name=chart23Radio]:checked').val();
			FORM_SEARCH.chart2_type = $(':radio[name=chart2_type]:checked').val();
			FORM_SEARCH.chart2_weekMonth_type = $(':radio[name=chart2_weekMonth_type]:checked').val();
			FORM_SEARCH.operProfitType = $(':radio[name=operProfitType]:checked').val();
			
			FORM_SEARCH._mtd       = "getList";
			FORM_SEARCH.sql        = sqlFlag;
			FORM_SEARCH.unit       = unit;
			FORM_SEARCH.tranData   = [
				{ outDs : "chart10", _siq : demendTrend1._siq + "chart10" },
				{ outDs : "chart11", _siq : demendTrend1._siq + "chart11" },
				{ outDs : "chart12", _siq : demendTrend1._siq + "chart12" },
				{ outDs : "cpfrTrend", _siq : demendTrend1._siq + "cpfrTrend" },
				{ outDs : "chart23", _siq : demendTrend1._siq + "chart23" },
				{ outDs : "chart24", _siq : demendTrend1._siq + "chart24" },
				{ outDs : "chart2", _siq : demendTrend1._siq + "chart2" },
				{ outDs : "cpfrShipPlanResultChart", _siq : demendTrend1._siq + "cpfrShipPlanResultChart" },
				<c:if test="${sessionScope.userInfo.dashboardYn == 'Y'}">
				{ outDs : "operProfit", _siq : demendTrend1._siq + "operProfit" },
				</c:if>
				
			];
			
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					demendTrend1.drawChart(data);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		salesSearch : function(sqlFlag) {
			FORM_SEARCH          = {}
			FORM_SEARCH          = demendTrend1.bucket;
			FORM_SEARCH.sales    = $(':radio[name=sales]:checked').val();
			FORM_SEARCH.salesInv = $(':radio[name=salesInv]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "chart10" , _siq : demendTrend1._siq + "chart10" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					
					var arPreWeek = new Array();
			
					$.each (demendTrend1.bucket.week, function (i, el) {
						arPreWeek.push(el.PRE_DISWEEK);
					});
					
					var chart10 = JSON.parse(data.chart10[0].SALES_CML);
					demendTrend1.chartGen('chart10', 'line', arPreWeek, chart10);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		salesFcstSearch : function(sqlFlag) {
			FORM_SEARCH           = {}
			FORM_SEARCH           = demendTrend1.bucket;
			FORM_SEARCH.salesFcst = $(':radio[name=salesFcst]:checked').val();
			FORM_SEARCH._mtd      = "getList";
			FORM_SEARCH.sql       = sqlFlag;
			FORM_SEARCH.tranData  = [
				{ outDs : "chart11" , _siq : demendTrend1._siq + "chart11" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					var arMonth = new Array();
					
					$.each (demendTrend1.bucket.monthChart11, function (i, el) {
						arMonth.push(el.DISMONTH);
					});
					
					var chart11 = JSON.parse(data.chart11[0].SALES_FCST);
					demendTrend1.chartGen('chart11', 'line', arMonth, chart11);
				}
			}
			gfn_service(sMap,"obj");
		}, 
		
		achivRtSearch : function(sqlFlag) {
			FORM_SEARCH          = {}
			FORM_SEARCH          = demendTrend1.bucket;
			FORM_SEARCH.achivRt  = $(':radio[name=achivRt]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "chart12" , _siq : demendTrend1._siq + "chart12" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					var arMonth = new Array();
					
					$.each (demendTrend1.bucket.month, function (i, el) {
						arMonth.push(el.DISMONTH);
					});
					
					var chart12 = JSON.parse(data.chart12[0].ACHIV_RT);
					demendTrend1.chartGen('chart12', 'line', arMonth, chart12);
				}
			}
			gfn_service(sMap,"obj");
		}, 
		
		chart24Search : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = demendTrend1.bucket;
			FORM_SEARCH.chart24_type = $(':radio[name=chart24_type]:checked').val();
			FORM_SEARCH.chart24_weekMonth_type = $(':radio[name=chart24_weekMonth_type]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "chart24" , _siq : demendTrend1._siq + "chart24" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					
					var weekMonth = $(':radio[name=chart24_weekMonth_type]:checked').val();
					
					if(weekMonth == "WEEK"){
						var arWeek = new Array();
						
						$.each (demendTrend1.bucket.week, function (i, el) {
							arWeek.push(el.DISWEEK);
						});
						
						var chart24 = JSON.parse(data.chart24[0].SALES);
						demendTrend1.chartGen('chart24', 'line', arWeek, chart24);
						
					}else{
						var arMonth = new Array();
						
						$.each (demendTrend1.bucket.month, function (i, el) {
							arMonth.push(el.DISMONTH);
						});
						var chart24 = JSON.parse(data.chart24[0].SALES);
						demendTrend1.chartGen('chart24', 'line', arMonth, chart24);	
					}
				}
			}
			gfn_service(sMap,"obj");
		},
		
		chart23RadioSearch : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = demendTrend1.bucket;
			FORM_SEARCH.chart23Radio   = $(':radio[name=chart23Radio]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "chart23" , _siq : demendTrend1._siq + "chart23" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					
					var arMonth = new Array();
			
					$.each (demendTrend1.bucket.month, function (i, el) {
						arMonth.push(el.DISMONTH);
					});
					var chart23 = JSON.parse(data.chart23[0].TREND23);
					demendTrend1.chartGen('chart23', 'line', arMonth, chart23);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		chart2Search : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = demendTrend1.bucket;
			FORM_SEARCH.chart2_type   = $(':radio[name=chart2_type]:checked').val();
			FORM_SEARCH.chart2_weekMonth_type   = $(':radio[name=chart2_weekMonth_type]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "chart2" , _siq : demendTrend1._siq + "chart2" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					
					var weekMonth = $(':radio[name=chart2_weekMonth_type]:checked').val();
					
					if(weekMonth == "WEEK"){
						var arWeek = new Array();
						
						$.each (demendTrend1.bucket.week, function (i, el) {
							arWeek.push(el.DISWEEK);
						});
						
						var chart2 = JSON.parse(data.chart2[0].CUST);

						demendTrend1.chartGen('chart2', 'line', arWeek, chart2);
					}else{
						var arMonth = new Array();
						
						$.each (demendTrend1.bucket.month, function (i, el) {
							arMonth.push(el.DISMONTH);
						});
						var chart2 = JSON.parse(data.chart2[0].CUST);
						demendTrend1.chartGen('chart2', 'line', arMonth, chart2);						
					}
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
			var arMonthChart11 = new Array();
			
			$.each (demendTrend1.bucket.month, function (i, el) {
				arMonth.push(el.DISMONTH);
				arPreMonth.push(el.PRE_DISMONTH);
			});
			
			$.each (demendTrend1.bucket.monthChart11, function (i, el) {
				arMonthChart11.push(el.DISMONTH);
            });
           
			$.each (demendTrend1.bucket.week, function (i, el) {
				arWeek.push(el.DISWEEK);
				arPreWeek.push(el.PRE_DISWEEK);
			});
			
			var chart10 = JSON.parse(res.chart10[0].SALES_CML);
			var chart11 = JSON.parse(res.chart11[0].SALES_FCST);
			var chart12 = JSON.parse(res.chart12[0].ACHIV_RT);
			var chart23 = JSON.parse(res.chart23[0].TREND23);
			var chart24 = JSON.parse(res.chart24[0].SALES);
			var chart2 = JSON.parse(res.chart2[0].CUST);
			
			var cpfrShipPlanResultChart = JSON.parse(res.cpfrShipPlanResultChart[0].CPFR_PLAN_RESULT);
			
			this.chartGen('chart10', 'line', arPreWeek, chart10);
			this.chartGen('chart11', 'line', arMonthChart11, chart11);
			this.chartGen('chart12', 'line', arMonth, chart12);
			this.chartGen('chart23', 'line', arMonth, chart23);
			this.chartGen('chart24', 'line', arMonth , chart24);
			
			this.chartGen('chart2', 'line', arMonth, chart2);
			
			this.chartGen('cpfrShipPlanResultChart', 'line', arMonth, cpfrShipPlanResultChart);
			<c:if test="${sessionScope.userInfo.dashboardYn == 'Y'}">
			var operProfit = JSON.parse(res.operProfit[0].OPER_PROFIT);
			this.chartGen('operProfit', 'line', arPreMonth, operProfit);
			</c:if>
			
			
			//CPFR 출하계획 TREND html 그리기
			
			var cpfrData = res.cpfrTrend;
			var tmp = "<tr><td style=\"background-color: #bbdefb;width: 16%; \"></td>";
			$.each (demendTrend1.bucket.month2, function (i, el) {
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
				
				$.each (demendTrend1.bucket.month2, function (i, el) {
					
					var disMonth = el.DISMONTH;
					var cpData = gfn_getNumberFmt(eval("v." + disMonth) / unit, 1, "R", "Y");
					tmp += "<td onclick=\"cpfrTrendPop()\" style=\"cursor:pointer;\">";
					tmp += cpData;
					tmp += "</td>";
				});
				tmp += "</tr>";
			});
			$("#cpfrTbody").html(tmp);
			
		},
		
		operProfitSearch : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = demendTrend1.bucket;
			FORM_SEARCH.operProfitType   = $(':radio[name=operProfitType]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "operProfit" , _siq : demendTrend1._siq + "operProfit" },
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					
					var arPreMonth = new Array();
					
					$.each (demendTrend1.bucket.month, function (i, el) {
						arPreMonth.push(el.PRE_DISMONTH);
					});
					
					var operProfit = JSON.parse(data.operProfit[0].OPER_PROFIT);
					demendTrend1.chartGen('operProfit', 'line', arPreMonth, operProfit);
					
				}
			}
			gfn_service(sMap,"obj");
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
			        			if(chartId == "chart23" && chart23RadioData == "cust") {
		        					for(var i = 0; i < chartLen; i++){
			        					
			        					var chartCode = this.chart.series[i].userOptions.code;
			        					
			        					if(chartCode != "RCG001"){
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
				
				
						},							
						cursor: 'pointer',
						point: {
							events: {
								click: function() {
									if(chartId == "chart10") {
										gfn_comPopupOpen("POPUP_CHART_DEMEND", {
											rootUrl   : "dashboard",
											url       : "popupChartDemend",
											width     : 1920,
											height    : 1060,
											menuCd    : "SNOP100",
											chartId   : "chart10",
											title     : "<spring:message code='lbl.salesCmplRateChart2' /> (%)"
										});
									} else if(chartId == "chart11") {
										gfn_comPopupOpen("POPUP_CHART_DEMEND", {
											rootUrl   : "dashboard",
											url       : "popupChartDemend",
											width     : 1920,
											height    : 1060,
											menuCd    : "SNOP100",
											chartId   : "chart11",
											title     : "<spring:message code='lbl.salesHittingRation' /> (%)"
										});
									} else if(chartId == "chart12") {
										gfn_comPopupOpen("POPUP_CHART_DEMEND", {
											rootUrl   : "dashboard",
											url       : "popupChartDemend",
											width     : 1920,
											height    : 1060,
											menuCd    : "SNOP100",
											chartId   : "chart12",
											title     : "<spring:message code='lbl.achieRateChart4'/> (M+3) (%)"
										});	
									} else if(chartId == "chart23") {
										gfn_comPopupOpen("POPUP_CHART_DEMEND", {
											rootUrl   : "dashboard",
											url       : "popupChartDemend",
											width     : 1920,
											height    : 1060,
											menuCd    : "SNOP100",
											chartId   : "chart23",
											title     : "<spring:message code='lbl.trend23Chart' /> (<spring:message code='lbl.hMillion' />)"
										});	
									} else if(chartId == "chart24") {
										gfn_comPopupOpen("POPUP_CHART_DEMEND", {
											rootUrl   : "dashboard",
											url       : "popupChartDemend",
											width     : 1920,
											height    : 1060,
											menuCd    : "SNOP100",
											chartId   : "chart24",
											title     : "<spring:message code='lbl.chart24' /> (<spring:message code='lbl.hMillion' />)"
										});	
									} else if(chartId == "chart2")	{
				                		gfn_comPopupOpen("POPUP_CHART_DEMEND", {
				        					rootUrl   : "dashboard",
				        					url       : "popupChartDemend",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : "chart2",
				        					title     : "<spring:message code='lbl.custSalesTrend' /> (<spring:message code='lbl.hMillion' />)"
				        				});
				                	} else if(chartId == "operProfit")	{
				                		gfn_comPopupOpen("POPUP_CHART_DEMEND", {
				        					rootUrl   : "dashboard",
				        					url       : "popupChartDemend",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : "operProfit",
				        					title     : "<spring:message code='lbl.operationProfit' /> (<spring:message code='lbl.hMillion' />)"
				        				});
				                	} else if(chartId == "cpfrShipPlanResultChart"){
				                		gfn_comPopupOpen("POPUP_CHART_DEMEND", {
				        					rootUrl   : "dashboard",
				        					url       : "popupChartDemend",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : "cpfrShipPlanResultChart",
				        					title     : "<spring:message code='lbl.cpfrShipPlanResult' />"
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
				minRange: 1,
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
						menuItems: ['printChart','downloadJPEG', 'downloadPDF'],
						/* menuItems : [
						{
							text : 'printChart',
							onclick : function(){
								
								var cId = this.xAxis[0].chart.renderTo.id;
								this.print();
								
								setTimeout(function(){
									$("#" + cId).css("overflow", "");	
								}, 1000);
							}
							
						}, {
							text : 'downloadJPEG',
							onclick : function(){
								var cId = this.xAxis[0].chart.renderTo.id;
								this.exportChart({
									type: 'image/jpeg'
								});
								
								setTimeout(function(){
									$("#" + cId).css("overflow", "");	
								}, 1000);
							}
							
						}, {
							text : 'downloadJPEG',
							onclick : function(){
								var cId = this.xAxis[0].chart.renderTo.id;
								this.exportChart({
									type: 'application/pdf'
								});
								
								setTimeout(function(){
									$("#" + cId).css("overflow", "");	
								}, 1000);
							}
							
						}]  */
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
		demendTrend1.search(sqlFlag);
	}
	
 	// onload 
	$(document).ready(function() {
		demendTrend1.init();
	});
	
 	
 	
function fn_popUpAuthorityHasOrNot(){
        
        SCM_SEARCH = {}; // 초기화
        
        SCM_SEARCH.USER_ID = "${sessionScope.userInfo.userId}" ;
        
        
        SCM_SEARCH._mtd     = "getList";
        SCM_SEARCH.tranData = [
                               { outDs : "isSCMTeam",_siq : "dashboard.chartInfo.isSCMTeam"}
                            ];
        
        
        
        var aOption = {
            async   : false,
            url     : GV_CONTEXT_PATH + "/biz/obj.do",
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

 	
 	
function fn_chartContentInit(){
    
    
    /*
    
    0. shipmentComplianceRate
    1. shipmentHitRate
	2. shipmentAchievementRate
	3. cpfrShipmentPlanTrend
	4. cpfrShipmentPlanNPerformance
	5. remainingOrderAmountSO
	6. shipmentTrend
	7. salesTrend
	8. operatingProfit

    
    */
    
    
    for(i=0;i<9;i++)
    {
        if(FORM_SEARCH.chartList[i].ID=="shipmentComplianceRate")             FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_1.setContents([{ insert: '\n' }]):quill_1.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
        else if(FORM_SEARCH.chartList[i].ID=="shipmentHitRate")               FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_2.setContents([{ insert: '\n' }]):quill_2.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
        else if(FORM_SEARCH.chartList[i].ID=="shipmentAchievementRate")       FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_3.setContents([{ insert: '\n' }]):quill_3.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
        else if(FORM_SEARCH.chartList[i].ID=="cpfrShipmentPlanTrend")         FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_4.setContents([{ insert: '\n' }]):quill_4.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
        else if(FORM_SEARCH.chartList[i].ID=="cpfrShipmentPlanNPerformance")  FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_5.setContents([{ insert: '\n' }]):quill_5.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
        else if(FORM_SEARCH.chartList[i].ID=="remainingOrderAmountSO")        FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_6.setContents([{ insert: '\n' }]):quill_6.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));
        else if(FORM_SEARCH.chartList[i].ID=="shipmentTrend")                 FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_7.setContents([{ insert: '\n' }]):quill_7.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));
        else if(FORM_SEARCH.chartList[i].ID=="salesTrend")                    FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_8.setContents([{ insert: '\n' }]):quill_8.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));
        else if(FORM_SEARCH.chartList[i].ID=="operatingProfit")               FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_9.setContents([{ insert: '\n' }]):quill_9.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));
                                    
    }
    
    
    
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
    
    
    
    quill_7 =  new Quill('#editor-7', {
        
        modules: {
            "toolbar": false
        } ,            
        theme: 'snow'  // or 'bubble'
      })
    quill_7.enable(false);
    
    
    
    quill_8 =  new Quill('#editor-8', {
        
        modules: {
            "toolbar": false
        } ,            
        theme: 'snow'  // or 'bubble'
      })
    quill_8.enable(false);
    
    
    
    quill_9 =  new Quill('#editor-9', {
        
        modules: {
            "toolbar": false
        } ,            
        theme: 'snow'  // or 'bubble'
      })
    quill_9.enable(false);

    
}

    function shipmentTrendActionToggle()
    {
    	 const action = $('#shipmentTrendAction');
         
         action.toggleClass('active')
    }

    function salesTrendActionToggle()
    {
    	
    	 const action = $('#salesTrendAction');
         
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
					<!-- 출하 준수율 1-->
					<div class="col_3" >
						<div class="titleContainer">
							<h4 id="shipmentComplianceRateH4"><spring:message code="lbl.salesCmplRateChart2" /> (%)</h4>
							<div class="view_combo" >
								<ul class="rdofl">
									<li><input type="radio" id="salesInv1" name="salesInv" value="inv" checked="checked"/><label for="salesInv1"><spring:message code="lbl.salesInvY" /></label></li>
									<li><input type="radio" id="salesInv2" name="salesInv" value="noInv"/> <label for="salesInv2"><spring:message code="lbl.salesInvN" /> </label></li>
									<li><input type="radio" id="sales1" name="sales" value="cust"/> <label for="sales1"><spring:message code="lbl.reptCust" /></label></li>
									<li><input type="radio" id="sales2" name="sales" value="total" checked="checked"/> <label for="sales2"><spring:message code="lbl.total" /> </label></li>
								    <li class="manuel">
                                        <a href="#" id="shipmentComplianceRate"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                    </li>
								</ul>
							</div>
						</div>
						<div style="height: 100%;clear:both;" id="chart10" ></div>
						<div class="modal" id="shipmentComplianceRateContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-1"></div>
                           </div>
                       </div>
						
						<!-- <div style="height: 88%;margin-top:25px;" id="chart10" ></div> -->
					</div>
					
					<!-- 출하 적중률 2-->
					<div class="col_3">
						<div class="titleContainer">
							<h4 id="shipmentHitRateH4"><spring:message code="lbl.salesHittingRation" /> (%)</h4>
							<div class="view_combo" >
								<ul class="rdofl">
									<li><input type="radio" id="salesFcst1" name="salesFcst" value="cust"/> <label for="salesFcst1"><spring:message code="lbl.reptCust" /></label></li>
									<li><input type="radio" id="salesFcst2" name="salesFcst" value="total" checked="checked"/> <label for="salesFcst2"><spring:message code="lbl.total" /> </label></li>
								    <li class="manuel">
                                        <a href="#" id="shipmentHitRate"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                    </li>
								</ul>
							</div>
						</div>
						<div style="height: 100%;clear:both;" id="chart11"></div>
					    <div class="modal" id="shipmentHitRateContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-2"></div>
                           </div>
                       </div>
					</div>
					
					<!-- 출하 달성률 3-->
					<div class="col_3">
						<div class="titleContainer">
							<h4 id="shipmentAchievementRateH4"><spring:message code="lbl.achieRateChart4"/> (M+3) (%)</h4>
							<div class="view_combo" >
								<ul class="rdofl">
									<li><input type="radio" id="achivRt1" name="achivRt" value="cust"/> <label for="achivRt1"><spring:message code="lbl.reptCust" /></label></li>
									<li><input type="radio" id="achivRt2" name="achivRt" value="total" checked="checked"/> <label for="achivRt2"><spring:message code="lbl.total" /> </label></li>
								    <li class="manuel">
                                        <a href="#" id="shipmentAchievementRate"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                    </li>
								</ul>
							</div>
						</div>
						<div style="height: 100%;clear:both;" id="chart12"></div>
					    <div class="modal" id="shipmentAchievementRateContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-3"></div>
                           </div>
                       </div>
					</div>
					
					<!-- CPFR 출하계획 TREND 4-->
					<div class="col_3">
					   <div class="titleContainer">
							<h4 id="cpfrShipmentPlanTrendH4" style="padding-bottom:10px;"><spring:message code="lbl.cpfrTrend" /> (<spring:message code="lbl.hMillion" />)</h4>
							<div class="view_combo" style="float: right;">
							     <ul class="rdofl">
							         <li class="manuel">
                                        <a href="#" id="cpfrShipmentPlanTrend"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                    </li>
							     </ul>
							</div>
						</div>
						<table id="cpfrShipmentPlanTrendTable">
							<tbody id="cpfrTbody">
							</tbody>
						</table>
						<div class="modal" id="cpfrShipmentPlanTrendContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-4"></div>
                           </div>
                       </div>
					</div>
					
					<!-- CPFR 출하계획 & 실적 5-->
					<div class="col_3">
					   <div class="titleContainer">
							<h4 id="cpfrShipmentPlanNPerformanceH4"><spring:message code="lbl.cpfrShipPlanResult" /></h4>
							<div class="view_combo" style="float: right;">
								<ul class="rdofl">
								    <li class="manuel">
                                        <a href="#" id="cpfrShipmentPlanNPerformance"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                    </li>
								</ul>
							</div>
						</div>
						<div style="height: 100%" id="cpfrShipPlanResultChart"></div>
					    <div class="modal" id="cpfrShipmentPlanNPerformanceContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-5"></div>
                           </div>
                       </div>
					</div>
					
					<!-- 수주 잔량 (S/O) 6-->
					<div class="col_3">
						<div class="titleContainer">
							<h4 id="remainingOrderAmountSOH4"><spring:message code="lbl.trend23Chart" /> (<spring:message code="lbl.hMillion" />)</h4>
							<div class="view_combo">
								<ul class="rdofl">
									<li><input type="radio" id="chart23Cust" name="chart23Radio" value="cust" checked="checked"/> <label for="chart23Cust"><spring:message code="lbl.reptCust" /></label></li>
									<li><input type="radio" id="chart23Prod" name="chart23Radio" value="prod" /> <label for="chart23Prod"><spring:message code="lbl.prodCate" /></label></li>
									<li><input type="radio" id="chart23Tot" name="chart23Radio" value="total"/> <label for="chart23Tot"><spring:message code="lbl.total" /> </label></li>
								    <li class="manuel">
                                        <a href="#" id="remainingOrderAmountSO"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                    </li>
								</ul>
							</div>
						</div>
						<div style="height: 100%;clear:both;" id="chart23"></div>
					    <div class="modal" id="remainingOrderAmountSOContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-6"></div>
                           </div>
                       </div>
					</div>
					
					<!-- 출하 TREND 7-->
					<div class="col_3">
						<div class="titleContainer">
							<h4 id="shipmentTrendH4"><spring:message code="lbl.chart24" /> (<spring:message code="lbl.hMillion" />)</h4>
							<div  class="view_combo">                   <!--  class="action"  id="shipmentTrendAction" -->
								<!--  <span>+</span>-->
								<ul class="rdofl"> <!-- style="height:155px;" -->
									<li><input type="radio" id="chart24_weekMonth_type1" name="chart24_weekMonth_type" value="WEEK"/> <label for="chart24_weekMonth_type1"><spring:message code="lbl.weekly" /></label></li>
									<li><input type="radio" id="chart24_weekMonth_type2" name="chart24_weekMonth_type" value="MONTH" checked="checked"/> <label for="chart24_weekMonth_type2"><spring:message code="lbl.month2" /></label></li>
									<li><input type="radio" id="chart24_type1" name="chart24_type" value="cust"/> <label for="chart24_type1"><spring:message code="lbl.reptCust" /></label></li>
									<li><input type="radio" id="chart24_type3" name="chart24_type" value="prod" /> <label for="chart24_type3"><spring:message code="lbl.prodCate" /></label></li>
									<li><input type="radio" id="chart24_type2" name="chart24_type" value="total" checked="checked"/> <label for="chart24_type2"><spring:message code="lbl.total" /> </label></li>
								    <li class="manuel">
                                        <a href="#" id="shipmentTrend"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                    </li>
								</ul>
							</div>
						</div>
						<div style="height: 100%;clear:both;" id="chart24"></div>
						<div class="modal" id="shipmentTrendContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-7"></div>
                           </div>
                       </div>
					</div>
					
					<!-- 매출 TREND 8-->
					<div class="col_3">
						<div class="titleContainer">
							<h4 id="salesTrendH4"><spring:message code="lbl.custSalesTrend" /> (<spring:message code="lbl.hMillion" />)</h4>
							<div class="view_combo" > <!-- class="action" id="salesTrendAction" -->
							    <!--  <span>+</span> -->
								<ul class="rdofl"> <!--  style="height:155px;" -->
									<li><input type="radio" id="chart2_weekMonth_type1" name="chart2_weekMonth_type" value="WEEK"/> <label for="chart2_weekMonth_type1"><spring:message code="lbl.weekly" /></label></li>
									<li><input type="radio" id="chart2_weekMonth_type2" name="chart2_weekMonth_type" value="MONTH" checked="checked"/> <label for="chart2_weekMonth_type2"><spring:message code="lbl.month2" /></label></li>
									<li><input type="radio" id="chart2_type1" name="chart2_type" value="cust"/> <label for="chart2_type1"><spring:message code="lbl.reptCust" /></label></li>
									<li><input type="radio" id="chart2_type3" name="chart2_type" value="prod" /> <label for="chart2_type3"><spring:message code="lbl.prodCate" /></label></li>
									<li><input type="radio" id="chart2_type2" name="chart2_type" value="total" checked="checked"/> <label for="chart2_type2"><spring:message code="lbl.total" /> </label></li>
								    <li class="manuel">
                                        <a href="#" id="salesTrend"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                    </li>
								</ul>
							</div>
						</div>
						<div style="height: 100%;clear:both;" id="chart2"></div>
						<div class="modal" id="salesTrendContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-8"></div>
                           </div>
                       </div>
					</div>
					
					<!-- 영업 이익 9-->
					
					<div class="col_3">
						<c:if test="${sessionScope.userInfo.dashboardYn == 'Y'}">
						<div class="titleContainer">	
							<h4 id="operatingProfitH4"><spring:message code="lbl.operationProfit" /> (<spring:message code="lbl.hMillion" />)</h4>
							<div class="view_combo">
								<ul class="rdofl">
									<li><input type="radio" id="operProfitCust" name="operProfitType" value="cust" /> <label for="operProfitCust"><spring:message code="lbl.reptCust" /></label></li>
									<li><input type="radio" id="operProfitProd" name="operProfitType" value="prod" /> <label for="operProfitProd"><spring:message code="lbl.prodCate" /></label></li>
									<li><input type="radio" id="operProfitTotal" name="operProfitType" value="total" checked="checked"/> <label for="operProfitTotal"><spring:message code="lbl.total" /> </label></li>
								    <li class="manuel">
                                        <a href="#" id="operatingProfit"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                    </li>
								</ul>
							</div>
						</div>
						<div style="height: 100%;clear:both;" id="operProfit"></div>
						<div class="modal" id="operatingProfitContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-9"></div>
                           </div>
                       </div>
						</c:if>
						<c:if test="${sessionScope.userInfo.dashboardYn != 'Y'}">
						<h4></h4>
						<div style="height: 88%;display:none;" id="operProfit"></div>
						<div class="modal" id="operatingProfitContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-9"></div>
                           </div>
                       </div>
						</c:if>
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
