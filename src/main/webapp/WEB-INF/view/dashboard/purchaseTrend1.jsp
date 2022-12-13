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
	
	#cont_chart .col_3 > .titleContainer > h4
	{
		float:left;
	}
	
	#cont_chart .col_3 > .titleContainer > div
	{
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
		font-size:10px;
		height:20px;
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
      right:105px;
      background: #fff;
      width: 80px;
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
      right:105px;
      width: 80px;
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
	var quill_1,quill_2,quill_3,quill_4,quill_5,quill_6,quill_7;
	var unit = 0;
	var purchaseTrend1 = {

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
	
		_siq	: "dashboard.purchaseTrend.",
		
		events : function () {
			
			$(':radio[name=materialFlag]').on('change', function () {
				purchaseTrend1.materialTrendSearch(false);
			});
			$(':radio[name=outSideFlag]').on('change', function () {
				purchaseTrend1.outSideTrendSearch(false);
			});
			
			$(':radio[name=inv]').on('change', function () {
				purchaseTrend1.invSearch(false);
			});
			
			$(':radio[name=inv_type]').on('change', function () {
				purchaseTrend1.invSearch(false);
			});
			
			$(':radio[name=inv_weekMonth_type]').on('change', function () {
				purchaseTrend1.invSearch(false);
			});
			
			$(':radio[name=agingTrend]').on('change', function () {
				purchaseTrend1.aTrendSearch(false);
			});
			$(':radio[name=agingTrendCostSale]').on('change', function () {
				purchaseTrend1.aTrendSearch(false);
			});
			$(':radio[name=agingTrendInv]').on('change', function () {
				purchaseTrend1.aTrendSearch(false);
			});
			
			$(':radio[name=weekMonth]').on('change', function () {
				purchaseTrend1.trend17Search(false);
			});
			$(':radio[name=proTypeTotal]').on('change', function () {
				purchaseTrend1.trend17Search(false);
			});
			
			$(':radio[name=chart18WeekMonth]').on('change', function () {
				purchaseTrend1.trend18Search(false);
			});
			$(':radio[name=chart18ProTypeTotal]').on('change', function () {
				purchaseTrend1.trend18Search(false);
			});
			
			// 타이틀 클릭시 메뉴 이동
			var arrTitle = $("h4");
	    	
			$.each(arrTitle, function(n, v) {
	    		$(v).css("cursor", "pointer");
	    		$(v).on("click", function() {
	    			if (n == 0) gfn_newTab("MP208");
	    			else if (n == 1) gfn_newTab("MP208");
	    			else if (n == 2) return;
	    			else if (n == 3) gfn_newTab("SNOP205");
	    			else if (n == 4) gfn_newTab("SNOP206");
	    			else if (n == 5) gfn_newTab("SNOP305");
	    			else if (n == 6) gfn_newTab("MP201");
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
	            	//재료비 TREND
	            	if(chartId == "materialCostTREND")
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
	            	//외주비 TREND
	            	else if(chartId == "outsourcingExpensesTREND")
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
	            	//주요 원자재 제조 L/T
	            	else if(chartId == "majorRawMaterialManufacturingLT")
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
	            	//재고 Trend
	            	else if(chartId == "stockTrend")
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
	            	//Aging Trend
	            	else if(chartId == "agingTrend")
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
	            	//자재 가용률
	            	else if(chartId == "materialAvailability2")
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
	            	//적기 이동률
	            	else if(chartId == "properMovementRate")
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
			
			  //재료비 TREND
                if(chartId == "materialCostTREND")
                {
                	$('#materialTrendChart').toggle();
                	$('#materialCostTRENDContent').toggle();
                }
                //외주비 TREND
                else if(chartId == "outsourcingExpensesTREND")
                {
                    $('#outSideTrendChart').toggle();
                    $('#outsourcingExpensesTRENDContent').toggle();
                
                }
                //주요 원자재 제조 L/T
                else if(chartId == "majorRawMaterialManufacturingLT")
                {
                    $('#majorRawMaterialManufacturingLTTable').toggle();
                    $('#majorRawMaterialManufacturingLTContent').toggle();
                }   
                //재고 Trend
                else if(chartId == "stockTrend")
                {
                    $('#chart7').toggle();
                    $('#stockTrendContent').toggle();
                }   
                //Aging Trend
                else if(chartId == "agingTrend")
                {
                    $('#chart22').toggle();
                    $('#agingTrendContent').toggle();
                }  
                //자재 가용률
                else if(chartId == "materialAvailability2")
                {
                    $('#chart17').toggle();
                    $('#materialAvailability2Content').toggle();
                }   
                //적기 이동률
                else if(chartId == "properMovementRate")
                {
                    $('#chart18').toggle();
                    $('#properMovementRateContent').toggle();
                }   
			
			});
			
			 $(".titleContainer > h4").hover(function() {
		            
		            var chartId  = this.id;
		        
		          //재료비 TREND
	                if(chartId == "materialCostTRENDH4")
	                {
	                    $('#materialTrendChart').toggle();
	                    $('#materialCostTRENDContent').toggle();
	                }
	                //외주비 TREND
	                else if(chartId == "outsourcingExpensesTRENDH4")
	                {
	                    $('#outSideTrendChart').toggle();
	                    $('#outsourcingExpensesTRENDContent').toggle();
	                
	                }
	                //주요 원자재 제조 L/T
	                else if(chartId == "majorRawMaterialManufacturingLTH4")
	                {
	                    $('#majorRawMaterialManufacturingLTTable').toggle();
	                    $('#majorRawMaterialManufacturingLTContent').toggle();
	                }   
	                //재고 Trend
	                else if(chartId == "stockTrendH4")
	                {
	                    $('#chart7').toggle();
	                    $('#stockTrendContent').toggle();
	                }   
	                //Aging Trend
	                else if(chartId == "agingTrendH4")
	                {
	                    $('#chart22').toggle();
	                    $('#agingTrendContent').toggle();
	                }  
	                //자재 가용률
	                else if(chartId == "materialAvailability2H4")
	                {
	                    $('#chart17').toggle();
	                    $('#materialAvailability2Content').toggle();
	                }   
	                //적기 이동률
	                else if(chartId == "properMovementRateH4")
	                {
	                    $('#chart18').toggle();
	                    $('#properMovementRateContent').toggle();
	                } 
		            
			 });
			
			 $('.titleContainer > .action').hover(function(){
		            
		            var chartId = this.id;
		            
		            
		            if(chartId == 'stockTrendAction')
		            {
		            	stockTrendActionToggle();
		                
		            }
		            
		            else if(chartId == 'agingTrendAction')
		            {
		            	agingTrendActionToggle();  
		            
		            }
		            
		        });
			
		},
		
		bucket : null,
		
		initSearch : function (sqlFlag) {
			FORM_SEARCH = {}
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.tranData = [{ outDs : "week"  , _siq : purchaseTrend1._siq + "trendBucketWeek" }
								  , { outDs : "month" , _siq : purchaseTrend1._siq + "trendBucketMonth" }
								  , { outDs : "month2" , _siq : purchaseTrend1._siq + "trendBucketMonth2" }
								  , { outDs : "weekReceiveBucket" , _siq : purchaseTrend1._siq + "weekReceiveBucket" }
								  , { outDs : "chartList" , _siq : "dashboard.chartInfo.purchaseTrend1" }
								  ];
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					purchaseTrend1.bucket = {};
					purchaseTrend1.bucket.week  = data.week;
					purchaseTrend1.bucket.month = data.month;
					purchaseTrend1.bucket.month2 = data.month2;
					purchaseTrend1.bucket.weekReceive = data.weekReceiveBucket;
					
					FORM_SEARCH.chartList = data.chartList;
					fn_chartContentInit();
					purchaseTrend1.search();
				}
			}
			gfn_service(sMap, "obj");
		},
		
		search : function (sqlFlag) {
			
			var agingTrendMeasCd = agingTrendCombo();
			
			FORM_SEARCH            = {};
			FORM_SEARCH            = this.bucket;
			FORM_SEARCH.materialFlag = $(':radio[name=materialFlag]:checked').val();
			FORM_SEARCH.outSideFlag = $(':radio[name=outSideFlag]:checked').val();
			FORM_SEARCH.inv        = $(':radio[name=inv]:checked').val();
			FORM_SEARCH.inv_type = $(':radio[name=inv_type]:checked').val();
			FORM_SEARCH.inv_weekMonth_type = $(':radio[name=inv_weekMonth_type]:checked').val();
			FORM_SEARCH.agingTrendMeasCd = agingTrendMeasCd;
			FORM_SEARCH.agingTrendInv = $(':radio[name=agingTrendInv]:checked').val();
			FORM_SEARCH.weekMonth  = $(':radio[name=weekMonth]:checked').val();
			FORM_SEARCH.proTypeTotal = $(':radio[name=proTypeTotal]:checked').val();
			FORM_SEARCH.chart18WeekMonth  = $(':radio[name=chart18WeekMonth]:checked').val();
			FORM_SEARCH.chart18ProTypeTotal = $(':radio[name=chart18ProTypeTotal]:checked').val();
			
			FORM_SEARCH._mtd       = "getList";
			FORM_SEARCH.sql        = sqlFlag;
			FORM_SEARCH.unit       = unit;
			FORM_SEARCH.tranData   = [
				{ outDs : "materialTrendChart", _siq : purchaseTrend1._siq + "materialTrendChart" },
				{ outDs : "outSideTrendChart", _siq : purchaseTrend1._siq + "outSideTrendChart" },
				{ outDs : "mainRawMaterialChart" , _siq : purchaseTrend1._siq + "mainRawMaterialChart" },
				{ outDs : "chart7" , _siq : purchaseTrend1._siq + "chart7" },
				{ outDs : "chart22" , _siq : purchaseTrend1._siq + "chart22" }, 
				{ outDs : "chart17" , _siq : purchaseTrend1._siq + "chart17" }, 
				{ outDs : "chart18" , _siq : purchaseTrend1._siq + "chart18" }
				/* ,
				{ outDs : "weekDeliRateChart" , _siq : purchaseTrend1._siq + "weekDeliRateChart" } */
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					
					purchaseTrend1.drawMaterialOutSideTrendChart(data.materialTrendChart, "materialTrendChart");
					purchaseTrend1.drawMaterialOutSideTrendChart(data.outSideTrendChart, "outSideTrendChart");
					purchaseTrend1.drawChart(data);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		materialTrendSearch : function(sqlFlag) {
			FORM_SEARCH          = {}
			FORM_SEARCH          = purchaseTrend1.bucket;
			FORM_SEARCH.materialFlag    = $(':radio[name=materialFlag]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.unit       = unit;
			FORM_SEARCH.tranData = [
				{ outDs : "materialTrendChart" , _siq : purchaseTrend1._siq + "materialTrendChart" }
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					purchaseTrend1.drawMaterialOutSideTrendChart(data.materialTrendChart, "materialTrendChart");
				}
			}
			gfn_service(sMap,"obj");
		},
		
		outSideTrendSearch  : function(sqlFlag) {
			FORM_SEARCH          = {}
			FORM_SEARCH          = purchaseTrend1.bucket;
			FORM_SEARCH.outSideFlag    = $(':radio[name=outSideFlag]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.unit     = unit;
			FORM_SEARCH.tranData = [
				{ outDs : "outSideTrendChart" , _siq : purchaseTrend1._siq + "outSideTrendChart" }
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					purchaseTrend1.drawMaterialOutSideTrendChart(data.outSideTrendChart, "outSideTrendChart");
				}
			}
			gfn_service(sMap,"obj");
		},
		
		invSearch : function (sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = purchaseTrend1.bucket;
			FORM_SEARCH.inv      = $(':radio[name=inv]:checked').val();
			FORM_SEARCH.inv_type = $(':radio[name=inv_type]:checked').val();
			FORM_SEARCH.inv_weekMonth_type = $(':radio[name=inv_weekMonth_type]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "chart7" , _siq : purchaseTrend1._siq + "chart7" }
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					
					var arPreCate = new Array();
					var chart7 = JSON.parse(data.chart7[0].INVENTORY);
					
					if(FORM_SEARCH.inv_weekMonth_type == "WEEK"){
						$.each (purchaseTrend1.bucket.week, function (i, el) {
							arPreCate.push(el.DISWEEK);
						});
					}else{
						$.each (purchaseTrend1.bucket.month, function (i, el) {
							arPreCate.push(el.DISMONTH);
						});
					}
					purchaseTrend1.chartGen('chart7', 'line', arPreCate, chart7);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		aTrendSearch : function(sqlFlag) {
			
			var agingTrendMeasCd = agingTrendCombo();

			FORM_SEARCH = {}
			FORM_SEARCH = purchaseTrend1.bucket;
			FORM_SEARCH.agingTrendInv = $(':radio[name=agingTrendInv]:checked').val();
			FORM_SEARCH.agingTrendMeasCd = agingTrendMeasCd;
			
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.sql  = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "chart22" , _siq : purchaseTrend1._siq + "chart22" }
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					
					var arPreMonth = new Array();
					$.each (purchaseTrend1.bucket.month, function (i, el) {
						arPreMonth.push(el.PRE_DISMONTH);
					});
					
					var chart22  = JSON.parse(data.chart22[0].AGING_TREND);

					purchaseTrend1.chartGen('chart22', 'line', arPreMonth, chart22);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		trend17Search : function(sqlFlag) {
			FORM_SEARCH          = {}
			FORM_SEARCH          = purchaseTrend1.bucket;
			FORM_SEARCH.weekMonth  = $(':radio[name=weekMonth]:checked').val();
			FORM_SEARCH.proTypeTotal = $(':radio[name=proTypeTotal]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "chart17" , _siq : purchaseTrend1._siq + "chart17" }
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					var arPreWeek = new Array();
					var arPreMonth = new Array();
			
					$.each (purchaseTrend1.bucket.week, function (i, el) {
						arPreWeek.push(el.PRE_DISWEEK);
					});
					
					$.each (purchaseTrend1.bucket.month, function (i, el) {
						arPreMonth.push(el.PRE_DISMONTH);
					});
					
					var chart17 = JSON.parse(data.chart17[0].ITEM);
					
					if(FORM_SEARCH.weekMonth == "week"){
						purchaseTrend1.chartGen('chart17', 'line', arPreWeek, chart17);
					}else{
						purchaseTrend1.chartGen('chart17', 'line', arPreMonth, chart17);
					}
				}
			}
			gfn_service(sMap,"obj");
		},
		
		trend18Search : function(sqlFlag) {
			FORM_SEARCH          = {}
			FORM_SEARCH          = purchaseTrend1.bucket;
			FORM_SEARCH.chart18WeekMonth  = $(':radio[name=chart18WeekMonth]:checked').val();
			FORM_SEARCH.chart18ProTypeTotal = $(':radio[name=chart18ProTypeTotal]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "chart18" , _siq : purchaseTrend1._siq + "chart18" }
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj",
				data	: FORM_SEARCH,
				success : function(data) {
					var arPreWeek = new Array();
					var arPreMonth = new Array();
			
					$.each (purchaseTrend1.bucket.week, function (i, el) {
						arPreWeek.push(el.PRE_DISWEEK);
					});
					
					$.each (purchaseTrend1.bucket.month, function (i, el) {
						arPreMonth.push(el.PRE_DISMONTH);
					});
					
					var chart18 = JSON.parse(data.chart18[0].CAPA);
					
					if(FORM_SEARCH.chart18WeekMonth == "week"){
						purchaseTrend1.chartGen('chart18', 'line', arPreWeek, chart18);
					}else{
						purchaseTrend1.chartGen('chart18', 'line', arPreMonth, chart18);
					}
				}
			}
			gfn_service(sMap,"obj");
		},
		
		
		drawMaterialOutSideTrendChart : function(res, chartId){
			fn_setHighchartTheme();
			
			var arMonth = new Array();
			var seriesArr = new Array();
			var seriesArrAmt = new Array();
			var seriesArrRate = new Array();
			var checkBoxFlag = "";
			var materialFlag = $(':radio[name=materialFlag]:checked').val();
			var outSideFlag = $(':radio[name=outSideFlag]:checked').val();
			var firstName = "";
			var secondtName = "";
			
			if(chartId == "materialTrendChart"){
				checkBoxFlag = materialFlag;
				firstName = '<spring:message code="lbl.materialCost" />(<spring:message code="lbl.billion" />)'; 
				secondtName = '<spring:message code="lbl.materialRatio" />';
			}else{
				checkBoxFlag = outSideFlag;
				firstName = '<spring:message code="lbl.outSideCost2" />(<spring:message code="lbl.billion" />)';
				secondtName = '<spring:message code="lbl.outsideRate" />';
			}
			
			$.each (purchaseTrend1.bucket.month2, function (i, el) {
				arMonth.push(el.DISMONTH);
			});
			
			$.each(res, function(i, val){
				
				var trendMonth = val.TREND_MONTH;
				var prodPart = val.PROD_PART;
				var measCd = val.MEAS_CD;
				var resultValue = val.RESULT_VALUE;
				var sortFlag = val.SORT_FLAG;
				
				if(checkBoxFlag == "total"){
					
					if(measCd == "AMT"){
						seriesArrAmt.push(resultValue);
						
						if(sortFlag == 7){
							var tmp = {type : "column", name : firstName, data : seriesArrAmt}
							seriesArr.push(tmp);
						}
					}else if(measCd == "RATE"){
						
						seriesArrRate.push(resultValue);
						
						if(sortFlag == 7){
							var tmp = {type : "line", name : secondtName, data : seriesArrRate, marker: {lineWidth: 2, lineColor: Highcharts.getOptions().colors[3], fillColor: 'white'}}
							seriesArr.push(tmp);
						}
					}
					
				}else{
					
					if(measCd == "AMT"){
						seriesArrAmt.push(resultValue);
						
						if(sortFlag == 7){
							var tmp = {type : "column", name : prodPart, data : seriesArrAmt}
							seriesArr.push(tmp);
							seriesArrAmt = new Array();
						}
					}else if(measCd == "RATE"){
						
						seriesArrRate.push(resultValue);
						
						if(sortFlag == 7){
							var tmp = {type : "line", name : prodPart, data : seriesArrRate, marker: {lineWidth: 2, lineColor: Highcharts.getOptions().colors[3], fillColor: 'white'}}
							seriesArr.push(tmp);
							seriesArrRate = new Array();
						}
					}
				}
			});
			
			Highcharts.chart(chartId, {
			    title: {
			        text: ''
			    },
			    xAxis: {
			        categories: arMonth
			    },
			    yAxis: {
					//title: { text: null }
			    	labels : { enabled : false}
				},
				
				plotOptions: {
					series: {
				        cursor: 'pointer',
				        dataLabels: {
			                enabled: true,
			                format: '{point.y:.1f}'
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
						point: {
				        	events: {
			                	click: function() {
			                		if(chartId == "materialTrendChart")	{
			                			gfn_comPopupOpen("POPUP_PURCHASE_TREND_CHART", {
				        					rootUrl   : "dashboard",
				        					url       : "popupChartPurchaseTrend",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : chartId,
				        					title     : "<spring:message code='lbl.materialTrend' />"
				        				});	
			                		}else if(chartId == "outSideTrendChart")	{
			                			gfn_comPopupOpen("POPUP_PURCHASE_TREND_CHART", {
				        					rootUrl   : "dashboard",
				        					url       : "popupChartPurchaseTrend",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : chartId,
				        					title     : "<spring:message code='lbl.outSideTrend' />"
				        				});	
			                		}
				                }
				            }
				        }
				    }
				},
			    series: seriesArr
			});
		
			$("#" + chartId).css("overflow", "");
		},
		
		drawChart : function (res) {
			
			fn_setHighchartTheme();
			
			var arPreWeek  = new Array();
			var arWeek     = new Array();
			var arMonth    = new Array();
			var arPreMonth = new Array();
			var arWeekReceive = new Array();
			
			$.each (purchaseTrend1.bucket.month, function (i, el) {
				arMonth.push(el.DISMONTH);
				arPreMonth.push(el.PRE_DISMONTH);
			});
			
			$.each (purchaseTrend1.bucket.week, function (i, el) {
				arWeek.push(el.DISWEEK);
				arPreWeek.push(el.PRE_DISWEEK);
			});
			
			$.each (purchaseTrend1.bucket.weekReceive, function (i, el) {
				arWeekReceive.push(el.DISWEEK);
			});
			
			var chart7 = JSON.parse(res.chart7[0].INVENTORY);
			var chart22 = JSON.parse(res.chart22[0].AGING_TREND);
			var chart17 = JSON.parse(res.chart17[0].ITEM);
			var chart18 = JSON.parse(res.chart18[0].CAPA);
			/* var weekDeliRateChart = JSON.parse(res.weekDeliRateChart[0].WEEK_DELIVERY); */
			
			this.chartGen('chart7', 'line', arWeek, chart7);
			this.chartGen('chart22', 'line', arPreMonth, chart22);
			this.chartGen('chart17', 'line', arPreWeek , chart17);
			this.chartGen('chart18', 'line', arPreWeek , chart18); 
			/* this.chartGen('weekDeliRateChart', 'line', arWeekReceive , weekDeliRateChart); */ 
			
			var tempChart = "<tr><td style=\"background-color: #bbdefb;width: 23%;text-align: center; \"><spring:message code='lbl.bpNm2' /></td>";
			var rnArray = [];
			var rn_max  = null;
			
			$.each(res.mainRawMaterialChart, function(i, val){
				rnArray.push(val.RN)
			})
			
			rn_max = Math.max.apply(null, rnArray);
			
			$.each(res.mainRawMaterialChart, function(i, val){
				
				var itemGroupNm = val.ITEM_GROUP_NM;
				
				if(i <= rn_max){
					tempChart += "<td style=\"background-color: #bbdefb;width: 11%;text-align: center; \">"+ itemGroupNm +"</td>";
				}
				
				if(i == (rn_max+1)){
					tempChart += "</tr>";
					return false;
				}
			    
			});
			
			$.each(res.mainRawMaterialChart, function(i, val){
				
				var bpNm = val.BP_NM;
				var purLt = gfn_nvl(val.PUR_LT, -999);
				var rn = val.RN;
				
				if(rn == 0){
					
					if(bpNm.length > 7)
					{
						var tempString = bpNm.substr(0,9);
					   tempChart += "<tr ><td style=\"background-color: #bbdefb;width: 11%;text-align: center; \">"+ tempString +"</td>";
					} 
					else
					{
						tempChart += "<tr><td style=\"background-color: #bbdefb;width: 11%;text-align: center; \">"+ bpNm +"</td>";
					}
				
					if(purLt == -999){
						tempChart += "<td style=\"background-color: #BDBDBD; \"></td>";
					}else{
						tempChart += "<td onclick=\"mainRawPop()\" style=\"cursor:pointer;\">"+ purLt +"</td>";	
					}
					
				}else{
					
					if(purLt == -999){
						tempChart += "<td style=\"background-color: #BDBDBD; \"></td>";
					}else{
						tempChart += "<td onclick=\"mainRawPop()\" style=\"cursor:pointer;\">"+ purLt +"</td>";	
					}
					
					if(rn == (rn_max+1)){
						tempChart += "</tr>";	
					}
				}
			});
			
			$("#mainRawMaterialChart").html(tempChart);
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
						point: {
							events: {
								click: function() {
									if(chartId == "chart7") {
										gfn_comPopupOpen("POPUP_PURCHASE_TREND_CHART", {
				        					rootUrl   : "dashboard",
				        					url       : "popupChartPurchaseTrend",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : chartId,
				        					title     : "<spring:message code='lbl.prodInvStatusChart2' /> (<spring:message code='lbl.hMillion' />)"
				        				});	
									} else if(chartId == "chart22") {
										gfn_comPopupOpen("POPUP_PURCHASE_TREND_CHART", {
				        					rootUrl   : "dashboard",
				        					url       : "popupChartPurchaseTrend",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : chartId,
				        					title     : "<spring:message code='lbl.agingTrend' /> (<spring:message code='lbl.hMillion' />)"
				        				});	
									} else if(chartId == "chart17")	{
			                			gfn_comPopupOpen("POPUP_PURCHASE_TREND_CHART", {
				        					rootUrl   : "dashboard",
				        					url       : "popupChartPurchaseTrend",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : chartId,
				        					title     : "<spring:message code='lbl.materialAva2' />"
				        				});	
			                		} else if(chartId == "chart18")	{
			                			gfn_comPopupOpen("POPUP_PURCHASE_TREND_CHART", {
				        					rootUrl   : "dashboard",
				        					url       : "popupChartPurchaseTrend",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : chartId,
				        					title     : "<spring:message code='lbl.trend17Chart' /> (%)"
				        				});	
			                		} else if(chartId == "weekDeliRateChart")	{
			                			gfn_comPopupOpen("POPUP_PURCHASE_TREND_CHART", {
				        					rootUrl   : "dashboard",
				        					url       : "popupChartPurchaseTrend",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : chartId,
				        					title     : "<spring:message code='lbl.weekDeliRate' />"
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
	
	function mainRawPop(){
		gfn_comPopupOpen("POPUP_PURCHASE_CHART", {
			rootUrl   : "dashboard",
			url       : "popupChartPurchaseTrend",
			width     : 1920,
			height    : 1060,
			menuCd    : "SNOP100",
			chartId   : "mainRawMaterialChart",
			title     : "<spring:message code='lbl.mainRawMaterial' />"
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
				minRange    : 1,
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
		            	align: 'right',
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
						allowOverlap: true,
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
						allowOverlap: true,
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
		purchaseTrend1.search(sqlFlag);
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
		purchaseTrend1.init();
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
         
         
         
         quill_7 =  new Quill('#editor-7', {
             
             modules: {
                 "toolbar": false
             } ,            
             theme: 'snow'  // or 'bubble'
           })
         quill_7.enable(false);
         
	 }

	 function fn_chartContentInit(){
	      
         
	      /*
	       1. materialCostTREND
		   2. outsourcingExpensesTREND
		   3. majorRawMaterialManufacturingLT
		   4. stockTrend
		   5. agingTrend
		   6. materialAvailability2
		   7. properMovementRate

	      */
	      
	      
	      for(i=0;i<7;i++)
	      {
	          if(FORM_SEARCH.chartList[i].ID=="materialCostTREND")                       FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_1.setContents([{ insert: '\n' }]):quill_1.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
	          else if(FORM_SEARCH.chartList[i].ID=="outsourcingExpensesTREND")           FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_2.setContents([{ insert: '\n' }]):quill_2.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
	          else if(FORM_SEARCH.chartList[i].ID=="majorRawMaterialManufacturingLT")    FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_3.setContents([{ insert: '\n' }]):quill_3.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
	          else if(FORM_SEARCH.chartList[i].ID=="stockTrend")                         FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_4.setContents([{ insert: '\n' }]):quill_4.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
	          else if(FORM_SEARCH.chartList[i].ID=="agingTrend")                         FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_5.setContents([{ insert: '\n' }]):quill_5.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
	          else if(FORM_SEARCH.chartList[i].ID=="materialAvailability2")              FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_6.setContents([{ insert: '\n' }]):quill_6.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));
	          else if(FORM_SEARCH.chartList[i].ID=="properMovementRate")                 FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_7.setContents([{ insert: '\n' }]):quill_7.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));
	                                      
	      }
	      
	      
	      
	  }
	 
	 
	function stockTrendActionToggle()
	{
		 const action = $('#stockTrendAction');
         
         action.toggleClass('active')
	}
     
 
	 
	function agingTrendActionToggle()
	{
		 const action = $('#agingTrendAction');
         
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
				
					<!-- 재료비 TREND-->
					<div class="col_3" >
						<div class="titleContainer">
							<h4 id="materialCostTRENDH4"><spring:message code="lbl.materialTrend" /> </h4>
							<div class="view_combo" >
								<ul class="rdofl">
									<li><input type="radio" id="materialFlag1" name="materialFlag" value="prodPart"/><label for="materialFlag1"><spring:message code="lbl.prodPart3" /></label></li>
									<li><input type="radio" id="materialFlag2" name="materialFlag" value="total" checked="checked"/> <label for="materialFlag2"><spring:message code="lbl.total" /> </label></li>
								    <li class="manuel">
	                                    <a href="#" id="materialCostTREND"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
	                                </li>
							</div>
						</div>
						<div style="height: 100%;clear:both;" id="materialTrendChart" ></div>
						<div class="modal" id="materialCostTRENDContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-1"></div>
                           </div>
                       </div>
					</div>
					
					<!-- 외주비 TREND -->
					<div class="col_3" >
						<div class="titleContainer">
							<h4 id="outsourcingExpensesTRENDH4"><spring:message code="lbl.outSideTrend" /> </h4>
							<div class="view_combo">
								<ul class="rdofl">
									<li><input type="radio" id="outSideFlag1" name="outSideFlag" value="prodPart"/><label for="outSideFlag1"><spring:message code="lbl.prodPart3" /></label></li>
									<li><input type="radio" id="outSideFlag2" name="outSideFlag" value="total" checked="checked"/> <label for="outSideFlag2"><spring:message code="lbl.total" /> </label></li>
								    <li class="manuel">
                                        <a href="#" id="outsourcingExpensesTREND"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                    </li>
								</ul>
							</div>
						</div>
						<div style="height: 100%;clear:both;" id="outSideTrendChart" ></div>
						<div class="modal" id="outsourcingExpensesTRENDContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-2"></div>
                           </div>
                       </div>
					</div>
					
					<!-- 주요 원자재 제조 L/T -->
					<div class="col_3" >
						<div class="titleContainer">
							<h4 style="padding-bottom:5px;" id="majorRawMaterialManufacturingLTH4"><spring:message code="lbl.mainRawMaterial" /></h4>
							<div class="view_combo" >
							      <ul class="rdofl">
	                                 <li class="manuel">
	                                    <a href="#" id="majorRawMaterialManufacturingLT"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
	                                 </li>
	                             </ul>
							</div>
						</div>
						<table id="majorRawMaterialManufacturingLTTable">
							<tbody id="mainRawMaterialChart">
							</tbody>
						</table>
						<div class="modal" id="majorRawMaterialManufacturingLTContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-3"></div>
                           </div>
                       </div>
					</div>
					
					<!-- 재고 TREND -->
					<div class="col_3">
						<div class="titleContainer">
							<h4 id="stockTrendH4"><spring:message code="lbl.prodInvStatusChart2" /> (<spring:message code="lbl.hMillion" />)</h4>
							<div class="view_combo" > <!-- class="action"  id="stockTrendAction" -->
								<!-- <span>+</span> -->
								<ul class="rdofl">
									<li><input type="radio" id="inv_weekMonth_type1" name="inv_weekMonth_type" value="WEEK" checked="checked"> <label for="inv_weekMonth_type1"><spring:message code="lbl.weekly" /></label></li>
									<li><input type="radio" id="inv_weekMonth_type2" name="inv_weekMonth_type" value="MONTH" > <label for="inv_weekMonth_type2"><spring:message code="lbl.month2" /></label></li>
									<li><input type="radio" id="inv_type1" name="inv_type" value="COST" checked="checked"> <label for="inv_type1"><spring:message code="lbl.costChart" /></label></li>
									<li><input type="radio" id="inv_type2" name="inv_type" value="PRICE" > <label for="inv_type2"><spring:message code="lbl.amtChart" /></label></li>
									<li><input type="radio" id="inv1" name="inv" value="item" > <label for="inv1"><spring:message code="lbl.itemType" /></label></li>
									<li><input type="radio" id="inv2" name="inv" value="total" checked="checked"> <label for="inv2"><spring:message code="lbl.total" /> </label></li>
								    <li class="manuel">
                                        <a href="#" id="stockTrend"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                    </li>
								</ul>
							</div>
						</div>
						<div style="height: 88%;clear:both;" id="chart7"></div>
						<div class="modal" id="stockTrendContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-4"></div>
                           </div>
                       </div>
					</div>
					
					<!-- Aging Trend -->
					<div class="col_3">
						<div class="titleContainer">
							<h4 id="agingTrendH4"><spring:message code="lbl.agingTrend" /> (<spring:message code="lbl.hMillion" />)</h4>
							<div class="view_combo"> <!-- class="action" id="agingTrendAction" -->
							    <!-- <span>+</span> -->
								<ul class="rdofl">
									<li><input type="radio" id="agingTrend_cost" name="agingTrendCostSale" value="cost" checked="checked"/> <label for="agingTrend_cost"><spring:message code="lbl.costChart" /></label></li>
									<li><input type="radio" id="agingTrend_sale" name="agingTrendCostSale" value="cost_sale"/> <label for="agingTrend_sale"><spring:message code="lbl.amtChart" /></label></li>
									<li><input type="radio" id="agingTrend_inv1" name="agingTrendInv" value="item"/> <label for="agingTrend_inv1"><spring:message code="lbl.itemType" /></label></li>
									<li><input type="radio" id="agingTrend_inv2" name="agingTrendInv" value="procure"/> <label for="agingTrend_inv2"><spring:message code="lbl.procureType" /></label></li>
									<li><input type="radio" id="agingTrend_inv3" name="agingTrendInv" value="total" checked="checked"/> <label for="agingTrend_inv3"><spring:message code="lbl.total" /> </label></li>
									<li><input type="radio" id="agingTrend1" name="agingTrend" value="M3"/> <label for="agingTrend1"><spring:message code="lbl.3mMore" /></label></li>
									<li><input type="radio" id="agingTrend2" name="agingTrend" value="M6"/> <label for="agingTrend2"><spring:message code="lbl.6mMore" /></label></li>
									<li><input type="radio" id="agingTrend3" name="agingTrend" value="Y1" checked="checked"/> <label for="agingTrend3"><spring:message code="lbl.yearOneMore" /> </label></li>
								    <li class="manuel">
	                                    <a href="#" id="agingTrend"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
	                                </li>
								</ul>
							</div>
						</div>
						<div style="height: 79%;clear:both;" id="chart22"></div>
						<div class="modal" id="agingTrendContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-5"></div>
                           </div>
                       </div>
					</div>
					
					<!-- 자재 가용률 (%) -->
					<div class="col_3" >
						<div class="titleContainer">
							<h4 id="materialAvailability2H4"><spring:message code="lbl.materialAva2" /></h4>
							<div class="view_combo">
								<ul class="rdofl">
									<li><input type="radio" id="weekMonth1" name="weekMonth" value="week" checked="checked"/><label for="weekMonth1"><spring:message code="lbl.weekly" /></label></li>
									<li><input type="radio" id="weekMonth2" name="weekMonth" value="month"/><label for="weekMonth2"><spring:message code="lbl.month2" /> </label></li>
									<li><input type="radio" id="proTypeTotal1" name="proTypeTotal" value="proType"/><label for="proTypeTotal1"><spring:message code="lbl.type2" /></label></li>
									<li><input type="radio" id="proTypeTotal2" name="proTypeTotal" value="total" checked="checked"/><label for="proTypeTotal2"><spring:message code="lbl.total" /> </label></li>
								    <li class="manuel">
                                        <a href="#" id="materialAvailability2"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                    </li>
								</ul>
							</div>
						</div>
						<div style="height: 100%;clear:both;" id="chart17" ></div>
						<div class="modal" id="materialAvailability2Content" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-6"></div>
                           </div>
                       </div>
					</div>
					
					<!-- 적기 이동률 -->
					<div class="col_3" >
						<div class="titleContainer">
							<h4 id="properMovementRateH4"><spring:message code="lbl.trend17Chart" /> (%)</h4>
							<div class="view_combo">
								<ul class="rdofl">
									<li><input type="radio" id="chart18WeekMonth1" name="chart18WeekMonth" value="week" checked="checked"/><label for="chart18WeekMonth1"><spring:message code="lbl.weekly" /></label></li>
									<li><input type="radio" id="chart18WeekMonth2" name="chart18WeekMonth" value="month"/><label for="chart18WeekMonth2"><spring:message code="lbl.month2" /> </label></li>
									<li><input type="radio" id="chart18ProTypeTotal1" name="chart18ProTypeTotal" value="proType"/><label for="chart18ProTypeTotal1"><spring:message code="lbl.procureType" /></label></li>
									<li><input type="radio" id="chart18ProTypeTotal2" name="chart18ProTypeTotal" value="total" checked="checked"/><label for="chart18ProTypeTotal2"><spring:message code="lbl.total" /> </label></li>
								    <li class="manuel">
                                        <a href="#" id="properMovementRate"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                    </li>
								</ul>
							</div>
						</div>
						<div style="height: 100%;clear:both;" id="chart18"></div>
						<div class="modal" id="properMovementRateContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-7"></div>
                           </div>
                       </div>
						
					</div>
					
					<!-- blank-->
					<div class="col_3">
						<h4></h4>
						<div class="view_combo" style="float: right;">
						</div>
						<div style="height: 88%" id="bbbbbbbbbbb" ></div>
					</div>
					
					<!-- blank -->
					<div class="col_3">
						<h4></h4>
						<div class="view_combo" style="float: right;">
						</div>
						<div style="height: 88%" id="cccccccccccccccc" ></div>
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
