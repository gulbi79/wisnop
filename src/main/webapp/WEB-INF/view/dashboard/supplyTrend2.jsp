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
	#cont_chart .col_3 > .titleContainer > h4 > p
    {
        display:inline-block;
        padding-left:5px;
		font-weight:bold;
		position:relative;
		left:10%;
		
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
      width: 85px;
      height:140px;
      padding: 10px;
      border-radius: 20px;
      opacity: 0;
      visibility: hidden;
      transition: .3s;
      z-index:999;
      display:block;
      box-shadow: 0 5px 5px rgba(0,0,0,0.1);
      overflow-y:hidden;
      overflow-x:hidden;
    }
    
    #cont_chart .col_3 > .titleContainer > .action.active ul {
    
      top: 0px;
      right:105px;
      opacity: 1;
      visibility: visible;
      transition: .3s;
      background: white;
      z-index:999;
      display:block;
      box-shadow: 0 5px 5px rgba(0,0,0,0.1);
      overflow-y:hidden;
      overflow-x:hidden;
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
	var quill_1,quill_2,quill_3,quill_4,quill_5,quill_6,quill_7,quill_8;
	var unit = 0;
	var unit2 = 0;
	var supplyTrend2 = {

		init : function () {
			gfn_formLoad();
			fn_siteMap();
		    
			fn_quilljsInit();
			
			this.comCode.initCode();
			this.initFilter();
			this.initSearch();
			this.events();
			
			var userLang = "${sessionScope.GV_LANG}";
			
			if(userLang == "ko"){
	    		unit = 100000000;
	    		unit2 = 1000000;
	    	}else if(userLang == "en" || userLang == "cn"){
	    		unit = 1000000000;
	    		unit2 = 1000000;
	    	}
		},
		
		initFilter : function() {
			
			// 콤보박스
			gfn_setMsComboAll([
				{target : 'divEquipRate', id : 'equipRate', title : '', data : this.comCode.codeMap.STD_WORK_HOUR, exData:[""], type : "R"},
			]);
			
			
			//chart content 이벤트 발생을 위한 아이콘 속성 추가  
			$('#divEquipRate > .rdofl').append('<li class="manuel">'+
                    "<a href='#' id='equipmentUtilizationRate'><img src='${ctx}/statics/images/common/google-docs.png' alt='Menual' title='<spring:message code='lbl.description2'/>'/></a>"+
                    '</li>');
			
			
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
		
		events : function () {
			
			$(':radio[name=timePeople]').on('change', function () {
				supplyTrend2.productChartSearch(false);
			});
			
			$(':radio[name=productPartTotal]').on('change', function () {
				supplyTrend2.productChartSearch(false);
			});
			
			$(':radio[name=equipRate]').on('change', function () {
				supplyTrend2.equipRateChartSearch(false);
			});
			
			$(':radio[name=urgentCntQtyAmt]').on('change', function () {
				supplyTrend2.urgentInsertInfoChartSearch(false);
			});
			
			$(':radio[name=urgentRepCustTotal]').on('change', function () {
				supplyTrend2.urgentInsertInfoChartSearch(false);
			});
			
			$(':radio[name=workRepCustTotal]').on('change', function () {
				supplyTrend2.workInfoChartSearch(false);
			});
			
			$(':radio[name=inSemiItemCntQty]').on('change', function () {
				supplyTrend2.inSemiItemChartSearch(false);
			});
			
			$(':radio[name=inSemiItemOhMhMm]').on('change', function () {
                supplyTrend2.inSemiItemChartSearch(false);
            });
          
			//urgentDemandCompRateChartSearch
            $(':radio[name=urgentDemandCompRateMonthWeek]').on('change', function () {
                supplyTrend2.urgentDemandCompRateChartSearch(false);
            });
            $(':radio[name=urgentDemandCompRateQtyAmt]').on('change', function () {
                supplyTrend2.urgentDemandCompRateChartSearch(false);
            });
            $(':radio[name=urgentDemandCompRatePart]').on('change', function () {
                supplyTrend2.urgentDemandCompRateChartSearch(false);
            });
            
            //연간 생산계획 대비 실적
            $(':radio[name=salesResultAgainstProdPlanTotal]').on('change', function () {
                supplyTrend2.salesResultAgainstProdPlanChartSearch(false);
            });
            
			// 타이틀 클릭시 메뉴 이동
			var arrTitle = $("h4");
	    	
			$.each(arrTitle, function(n, v) {
	    		$(v).css("cursor", "pointer");
	    		$(v).on("click", function() {
	    			if (n == 0) gfn_newTab("MP110");
	    			else if (n == 1) gfn_newTab("MP113");
	    			else if (n == 2) gfn_newTab("MP111");
	    			else if (n == 3) gfn_newTab("MP112");
	    			else if (n == 4) gfn_newTab("SNOP205");
	    			else if (n == 5) gfn_newTab("APS301");
	    			else if (n == 6) gfn_newTab("DP314");
	    			else if (n == 7) gfn_newTab("APS318");
	    			else if (n == 8) return
	    		});
	    	});
			
			
			$(".manuel > a").dblclick("on", function() {
				
				var chartId  = this.id;
	            
	            fn_popUpAuthorityHasOrNot();
				
	            var isSCMTeam = SCM_SEARCH.isSCMTeam;
	            
	            if(isSCMTeam>=1)
	            {
	            	//생산성
	            	if(chartId == "productivity")
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
	            	//과재공 금액 현황
	            	else if(chartId =="overworkedAmountStatus")
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
	            	//주요 품목그룹 LT
	            	else if(chartId =="mainItemGroupLT")
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
	            	//장비 가동률
	            	else if(chartId =="equipmentUtilizationRate")
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
	            	//반제품 재고 확보율
	            	else if(chartId =="semiFinishedProductStockingRate")
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
	            	//긴급건 등록현황
	            	else if(chartId =="emergencyRegistrationStatus")
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
	            	//긴급건 수요 준수율
	            	else if(chartId =="urgentDemandCompRate")
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
	            	//연간 생산 계획
	            	else if(chartId =="salesResultAgainstProdPlan")
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

				//생산성
                if(chartId == "productivity")
                {
                	$('#productChart').toggle();
                	$('#productivityContent').toggle();
                }
                //과재공 금액 현황
                else if(chartId =="overworkedAmountStatus")
                {
                    $('#workInfoChart').toggle();
                    $('#overworkedAmountStatusContent').toggle();
                }
                //주요 품목그룹 LT
                else if(chartId =="mainItemGroupLT")
                {
                    $('#mainItemTypeLtChart').toggle();
                    $('#mainItemGroupLTContent').toggle();
                }
                //장비 가동률
                else if(chartId =="equipmentUtilizationRate")
                {
                    $('#equipRateChart').toggle();
                    $('#equipmentUtilizationRateContent').toggle();
                }
                //반제품 재고 확보율
                else if(chartId =="semiFinishedProductStockingRate")
                {
                    $('#inSemiItemChart').toggle();
                    $('#semiFinishedProductStockingRateContent').toggle();
                }
                //긴급건 등록현황
                else if(chartId =="emergencyRegistrationStatus")
                {
               	    $('#urgentInsertInfoChart').toggle();
                    $('#emergencyRegistrationStatusContent').toggle();
                }
				//긴급 수요 준수율
				else if(chartId =="urgentDemandCompRate")
                {
                    $('#urgentDemandCompRateChart').toggle();
                    $('#urgentDemandCompRateContent').toggle();
                }
	           //연간 생산 계획
				else if(chartId =="salesResultAgainstProdPlan")
                {
                    $('#salesResultAgainstProdPlanChart').toggle();
                    $('#salesResultAgainstProdPlanContent').toggle();
                }
				
			});
			
			
			$(".titleContainer > h4").hover(function() {
	            
	            var chartId  = this.id;
	      
	          //생산성
                if(chartId == "productivityH4")
                {
                    $('#productChart').toggle();
                    $('#productivityContent').toggle();
                }
                //과재공 금액 현황
                else if(chartId =="overworkedAmountStatusH4")
                {
                    $('#workInfoChart').toggle();
                    $('#overworkedAmountStatusContent').toggle();
                }
                //주요 품목그룹 LT
                else if(chartId =="mainItemGroupLTH4")
                {
                    $('#mainItemTypeLtChart').toggle();
                    $('#mainItemGroupLTContent').toggle();
                }
                //장비 가동률
                else if(chartId =="equipmentUtilizationRateH4")
                {
                    $('#equipRateChart').toggle();
                    $('#equipmentUtilizationRateContent').toggle();
                }
                //반제품 재고 확보율
                else if(chartId =="semiFinishedProductStockingRateH4")
                {
                    $('#inSemiItemChart').toggle();
                    $('#semiFinishedProductStockingRateContent').toggle();
                }
                //긴급건 등록현황
                else if(chartId =="emergencyRegistrationStatusH4")
                {
                    $('#urgentInsertInfoChart').toggle();
                    $('#emergencyRegistrationStatusContent').toggle();
                }
                //긴급 수요 준수율  
	            else if(chartId =="urgentDemandCompRateH4")
                {
                    $('#urgentDemandCompRateChart').toggle();
                    $('#urgentDemandCompRateContent').toggle();
                }
	            //연간 생산 계획
	            else if(chartId =="salesResultAgainstProdPlanH4")
                {
	                $('#salesResultAgainstProdPlanChart').toggle();
	                $('#salesResultAgainstProdPlanContent').toggle();
                }
                
			});
			
			
			$('.titleContainer > .action').hover(function(){
	            
	            var chartId = this.id;
	            
	            
	            if(chartId == 'semiFinishedProductStockingRateAction')
	            {
	            	semiFinishedProductStockingRateActionToggle();
	                
	            }
	            
	            else if(chartId == 'emergencyRegistrationStatusAction')
	            {
	            	emergencyRegistrationStatusActionToggle();  
	            
	            }
	            
	            
	            
	            
	        });
			
			
			
		},
		
		bucket : null,
		
		initSearch : function (sqlFlag) {
			FORM_SEARCH = {}
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.tranData = [{ outDs : "week"  , _siq : supplyTrend2._siq + "trendBucketWeek" }
								  , { outDs : "week2"  , _siq : supplyTrend2._siq + "trendBucketWeek2" }
								  , { outDs : "week3"  , _siq : supplyTrend2._siq + "trendBucketWeek3" }
								  , { outDs : "month" , _siq : supplyTrend2._siq + "trendBucketMonth" }
								  , { outDs : "month2" , _siq : supplyTrend2._siq + "trendBucketMonth2" }
								  , { outDs : "chartList" , _siq : "dashboard.chartInfo.supplyTrend2" }
			];
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					supplyTrend2.bucket = {};
					supplyTrend2.bucket.week  = data.week;
					supplyTrend2.bucket.week2 = data.week2;
					supplyTrend2.bucket.week3 = data.week3;
					supplyTrend2.bucket.month = data.month;
					supplyTrend2.bucket.month2 = data.month2;
					FORM_SEARCH.chartList = data.chartList;
					fn_chartContentInit(data.chartList);
					supplyTrend2.search();
				}
			}
			gfn_service(sMap, "obj");
		},
		
		search : function (sqlFlag) {
			
			FORM_SEARCH            = {};
			FORM_SEARCH            = this.bucket;
			FORM_SEARCH.timePeople = $(':radio[name=timePeople]:checked').val();
			FORM_SEARCH.productPartTotal = $(':radio[name=productPartTotal]:checked').val();
			FORM_SEARCH.equipRate = $(':radio[name=equipRate]:checked').val();
			FORM_SEARCH.urgentCntQtyAmt = $(':radio[name=urgentCntQtyAmt]:checked').val();
			FORM_SEARCH.urgentRepCustTotal = $(':radio[name=urgentRepCustTotal]:checked').val();
			FORM_SEARCH.workRepCustTotal = $(':radio[name=workRepCustTotal]:checked').val();
			FORM_SEARCH.inSemiItemCntQty = $(':radio[name=inSemiItemCntQty]:checked').val();
			FORM_SEARCH.inSemiItemOhMhMm = $(':radio[name=inSemiItemOhMhMm]:checked').val();
			
			FORM_SEARCH.urgentDemandCompRateMonthWeek = $(':radio[name=urgentDemandCompRateMonthWeek]:checked').val();
			FORM_SEARCH.urgentDemandCompRateQtyAmt = $(':radio[name=urgentDemandCompRateQtyAmt]:checked').val();
			FORM_SEARCH.urgentDemandCompRatePart = $(':radio[name=urgentDemandCompRatePart]:checked').val();
			
			FORM_SEARCH.salesResultAgainstProdPlanTotal = $(':radio[name=salesResultAgainstProdPlanTotal]:checked').val();
			
			
			FORM_SEARCH.urgentDemandCompRateMonthWeek = $(':radio[name=urgentDemandCompRateMonthWeek]:checked').val();
			FORM_SEARCH.urgentDemandCompRateQtyAmt = $(':radio[name=urgentDemandCompRateQtyAmt]:checked').val();
			FORM_SEARCH.urgentDemandCompRatePart = $(':radio[name=urgentDemandCompRatePart]:checked').val();
			
			FORM_SEARCH.salesResultAgainstProdPlanTotal = $(':radio[name=salesResultAgainstProdPlanTotal]:checked').val();
			
			
			FORM_SEARCH._mtd       = "getList";
			FORM_SEARCH.sql        = sqlFlag;
			FORM_SEARCH.unit       = unit;
			FORM_SEARCH.unit2      = unit2;
			FORM_SEARCH.tranData   = [
				{ outDs : "productChart", _siq : supplyTrend2._siq + "productChart" },
				{ outDs : "mainItemTypeLtChart", _siq : supplyTrend2._siq + "mainItemTypeLtChart" },
				{ outDs : "equipRateChart", _siq : supplyTrend2._siq + "equipRateChart" },
				{ outDs : "urgentInsertInfoChart", _siq : supplyTrend2._siq + "urgentInsertInfoChart" },
				{ outDs : "workInfoChart", _siq : supplyTrend2._siq + "workInfoChart" },
				{ outDs : "inSemiItemChart", _siq : supplyTrend2._siq + "inSemiItemChart" },
				{ outDs : "urgentDemandCompRateChart", _siq : supplyTrend2._siq + "urgentDemandCompRateChart" },
				{ outDs : "salesResultAgainstProdPlan" , _siq : supplyTrend2._siq + "salesResultAgainstProdPlan"  }
			];			   
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					
					supplyTrend2.drawChart(data);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		productChartSearch : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = supplyTrend2.bucket;
			FORM_SEARCH.timePeople = $(':radio[name=timePeople]:checked').val();
			FORM_SEARCH.productPartTotal = $(':radio[name=productPartTotal]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "productChart" , _siq : supplyTrend2._siq + "productChart" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					
					var arPreMonth = new Array();
					var arMonth = new Array();
			
					$.each (supplyTrend2.bucket.month, function (i, el) {
						arPreMonth.push(el.PRE_DISMONTH);
						arMonth.push(el.DISMONTH);
					});
					
					var productChart = JSON.parse(data.productChart[0].PRODUCT_CHART);
					supplyTrend2.chartGen('productChart', 'line', arPreMonth, productChart);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		equipRateChartSearch : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = supplyTrend2.bucket;
			FORM_SEARCH.equipRate = $(':radio[name=equipRate]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "equipRateChart" , _siq : supplyTrend2._siq + "equipRateChart" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					
					var arPreWeek  = new Array();
					var arWeek     = new Array();
			
					$.each (supplyTrend2.bucket.week, function (i, el) {
						arWeek.push(el.DISWEEK);
						arPreWeek.push(el.PRE_DISWEEK);
					});
					
					var equipRateChart = JSON.parse(data.equipRateChart[0].EQUIP_RATE);
					supplyTrend2.chartGen('equipRateChart', 'line', arWeek, equipRateChart);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		urgentInsertInfoChartSearch : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = supplyTrend2.bucket;
			FORM_SEARCH.urgentCntQtyAmt = $(':radio[name=urgentCntQtyAmt]:checked').val();
			FORM_SEARCH.urgentRepCustTotal = $(':radio[name=urgentRepCustTotal]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "urgentInsertInfoChart" , _siq : supplyTrend2._siq + "urgentInsertInfoChart" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					
					var arPreWeek  = new Array();
					var arWeek     = new Array();
			
					$.each (supplyTrend2.bucket.week, function (i, el) {
						arWeek.push(el.DISWEEK);
						arPreWeek.push(el.PRE_DISWEEK);
					});
					
					var urgentInsertInfoChart = JSON.parse(data.urgentInsertInfoChart[0].URGENT_INSERT_INFO);
					supplyTrend2.chartGen('urgentInsertInfoChart', 'line', arWeek, urgentInsertInfoChart);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		workInfoChartSearch : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = supplyTrend2.bucket;
			FORM_SEARCH.workRepCustTotal = $(':radio[name=workRepCustTotal]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "workInfoChart" , _siq : supplyTrend2._siq + "workInfoChart" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
				data	: FORM_SEARCH,
				success : function(data) {
					
					var arPreWeek  = new Array();
					var arWeek     = new Array();
			
					$.each (supplyTrend2.bucket.week2, function (i, el) {
						arWeek.push(el.DISWEEK);
						arPreWeek.push(el.PRE_DISWEEK);
					});
					
					var workInfoChart = JSON.parse(data.workInfoChart[0].WORK_INFO);
					supplyTrend2.chartGen('workInfoChart', 'line', arWeek, workInfoChart);
				}
			}
			gfn_service(sMap,"obj");
		},
		
		inSemiItemChartSearch : function(sqlFlag) {
			FORM_SEARCH          = {};
			FORM_SEARCH          = supplyTrend2.bucket;
			FORM_SEARCH.inSemiItemCntQty = $(':radio[name=inSemiItemCntQty]:checked').val();
			FORM_SEARCH.inSemiItemOhMhMm = $(':radio[name=inSemiItemOhMhMm]:checked').val();
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.sql      = sqlFlag;
			FORM_SEARCH.tranData = [
				{ outDs : "inSemiItemChart" , _siq : supplyTrend2._siq + "inSemiItemChart" } ,
			];
			
			var sMap = {
				url	 : "${ctx}/biz/obj.do",
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
											if(chartId == "inSemiItemChart") {
												gfn_comPopupOpen("POPUP_CHART_SUPPLY", {
						        					rootUrl   : "dashboard",
						        					url       : "popupChartSupplyTrend",
						        					width     : 1920,
						        					height    : 1060,
						        					menuCd    : "SNOP100",
						        					chartId   : chartId,
						        					title     : "<spring:message code='lbl.inSemiItem' /> (%)"
						        				});	
											} 
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
		
		//긴급 수요 준수율
		urgentDemandCompRateChartSearch : function(sqlFlag) {
            FORM_SEARCH          = {};
            FORM_SEARCH          = supplyTrend2.bucket;
           
            FORM_SEARCH.urgentDemandCompRateMonthWeek = $(':radio[name=urgentDemandCompRateMonthWeek]:checked').val();
            FORM_SEARCH.urgentDemandCompRateQtyAmt = $(':radio[name=urgentDemandCompRateQtyAmt]:checked').val();
            FORM_SEARCH.urgentDemandCompRatePart = $(':radio[name=urgentDemandCompRatePart]:checked').val();
            
            FORM_SEARCH._mtd     = "getList";
            FORM_SEARCH.sql      = sqlFlag;
            FORM_SEARCH.tranData = [
                { outDs : "urgentDemandCompRateChart" , _siq : supplyTrend2._siq + "urgentDemandCompRateChart" } ,
            ];
            
            var sMap = {
                url  : "${ctx}/biz/obj.do",
                data    : FORM_SEARCH,
                success : function(data) {
                    
                	var arWeek3    = [];
                    var arMonth2   = [];
                    var urgentDemandCompRateMonthWeek = $(':radio[name=urgentDemandCompRateMonthWeek]:checked').val();
                    $.each (supplyTrend2.bucket.week3, function (i, el) {
                        arWeek3.push(el.DISWEEK);
                    });
                    
                    $.each (supplyTrend2.bucket.month2, function (i, el) {
                        arMonth2.push(el.DISMONTH)  
                    });
                    var urgentDemandCompRateChart = JSON.parse(data.urgentDemandCompRateChart[0].URGENT_DEMAND_COMP_RATE)
                    //(urgentDemandCompRateMonthWeek=='MONTH')?supplyTrend2.chartGen('urgentDemandCompRateChart', 'column', arMonth2, urgentDemandCompRateChart):supplyTrend2.chartGen('urgentDemandCompRateChart', 'column', arWeek3, urgentDemandCompRateChart);
                    if(urgentDemandCompRateMonthWeek=='MONTH')
                    {
                    	supplyTrend2.chartGen('urgentDemandCompRateChart', 'column', arMonth2, urgentDemandCompRateChart);
                    }
                    else
                    {
                    	supplyTrend2.chartGen('urgentDemandCompRateChart', 'column', arWeek3, urgentDemandCompRateChart);
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
                { outDs : "salesResultAgainstProdPlanChart" , _siq : supplyTrend2._siq + "salesResultAgainstProdPlan" } ,
            ];
            
            
            var sMap = {
                url  : "${ctx}/biz/obj.do",
                data    : FORM_SEARCH,
                success : function(data) {
                    salesResultAgainstProdPlanChartGenChart(false, data.salesResultAgainstProdPlanChart)
                    
                }
            }
            gfn_service(sMap,"obj");
        },
        
        
		drawChart : function (res) {
			
			fn_setHighchartTheme();
			
			var arPreWeek  = new Array();
			var arWeek     = new Array();
			var arPreWeek2 = new Array();
			var arWeek2    = new Array();
			var arMonth    = new Array();
			var arPreMonth = new Array();
			var arWeek3    = [];
			var arMonth2   = [];
			
			$.each (supplyTrend2.bucket.month, function (i, el) {
				arMonth.push(el.DISMONTH);
				arPreMonth.push(el.PRE_DISMONTH);
			});
			
			$.each (supplyTrend2.bucket.week, function (i, el) {
				arWeek.push(el.DISWEEK);
				arPreWeek.push(el.PRE_DISWEEK);
			});
			
			$.each (supplyTrend2.bucket.week2, function (i, el) {
				arWeek2.push(el.DISWEEK);
				arPreWeek2.push(el.PRE_DISWEEK);
			});
			
			$.each (supplyTrend2.bucket.week3, function (i, el) {
				arWeek3.push(el.DISWEEK);
			});
			
			$.each (supplyTrend2.bucket.month2, function (i, el) {
				arMonth2.push(el.DISMONTH)  
			});
            
			
			var productChart = JSON.parse(res.productChart[0].PRODUCT_CHART);
			var mainItemTypeLtChart = JSON.parse(res.mainItemTypeLtChart[0].MAIN_ITEM_TYPE_LT);
			var equipRateChart = JSON.parse(res.equipRateChart[0].EQUIP_RATE);
			var urgentInsertInfoChart = JSON.parse(res.urgentInsertInfoChart[0].URGENT_INSERT_INFO);
			var workInfoChart = JSON.parse(res.workInfoChart[0].WORK_INFO);
			var urgentDemandCompRateChart = JSON.parse(res.urgentDemandCompRateChart[0].URGENT_DEMAND_COMP_RATE)
			
			/*
			this.tagetStyle(chart3);
			this.tagetStyle(chart6); */
			
			this.chartGen('productChart', 'line', arPreMonth, productChart);
			this.chartGen('mainItemTypeLtChart', 'line', arMonth, mainItemTypeLtChart);
			this.chartGen('equipRateChart', 'line', arWeek, equipRateChart);
			this.chartGen('urgentInsertInfoChart', 'line', arWeek, urgentInsertInfoChart);
			this.chartGen('workInfoChart', 'line', arWeek2, workInfoChart);
			this.chartGen('urgentDemandCompRateChart', 'column',arWeek3, urgentDemandCompRateChart);
			
			//반제품 재고 확보율
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
									if(chartId == "inSemiItemChart") {
										gfn_comPopupOpen("POPUP_CHART_SUPPLY", {
				        					rootUrl   : "dashboard",
				        					url       : "popupChartSupplyTrend",
				        					width     : 1920,
				        					height    : 1060,
				        					menuCd    : "SNOP100",
				        					chartId   : chartId,
				        					title     : "<spring:message code='lbl.inSemiItem' /> (%)"
				        				});	
									} 
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
			
		
			//연간 생산계획 대비 실적
			var codeNmArrSalesResultAgainstProdPlan = [];
	        var lineData1SalesResultAgainstProdPlan = [];
	        var lineData2SalesResultAgainstProdPlan = [];
	        var lineData3SalesResultAgainstProdPlan = [];
	        
	            
	        var latest_SALES_RESULT  =  null;
	        var latest_PROD_PLAN     =  null;
	        var latest_PROD_RESULT   =  null;
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
            	$('#salesResultAgainstProdPlanH4').append('<p class="green">'+ GAP +'</p>');
                
            }
            else if((latest_SALES_RESULT - latest_PROD_PLAN) == 0)
            {
                GAP  = 'GAP '+''+String(GAP_temp);
                $('#salesResultAgainstProdPlanH4').append('<p>'+ GAP +'</p>');
            }
            else
            {
                GAP  = 'GAP '+''+String(GAP_temp);
                $('#salesResultAgainstProdPlanH4').append('<p class="red">'+ GAP +'</p>');
                
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
                        point: {
                            events: {
                                click: function() {
                                    
                                    if(chartIdSalesResultAgainstProdPlan == "salesResultAgainstProdPlanChart") {
                                        gfn_comPopupOpen("POPUP_CHART_DEMEND", {
                                            rootUrl   : "dashboard",
                                            url       : "popupChartSupplyTrend",
                                            width     : 1920,
                                            height    : 1060,
                                            menuCd    : "SNOP100",
                                            chartId   : "salesResultAgainstProdPlan",
                                            title     : "<spring:message code='lbl.salesResultAgainstProdPlan' />",
                                            GAP       : GAP
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
			
			if (chartId == 'chart6') {
				Highcharts.theme.colors[1] = '#f7848d';
				Highcharts.theme.colors[2] = gv_cColor1;
				Highcharts.theme.colors[3] = '#f7848d';
			} else {
				Highcharts.theme.colors[1] = gv_cColor2;
				Highcharts.theme.colors[2] = '#f7848d';
				Highcharts.theme.colors[3] = '#f0a482';
			}
			
			var chart = {
			    
			    xAxis  : { categories : arCarte },
				series : arData,
				plotOptions: {
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
						},							
						cursor: 'pointer',
						point: {
							events: {
								click: function() {
									if(chartId == "productChart") {
										gfn_comPopupOpen("POPUP_CHART_SUPPLY", {
											rootUrl   : "dashboard",
											url       : "popupChartSupplyTrend",
											width     : 1920,
											height    : 1060,
											menuCd    : "SNOP100",
											chartId   : chartId,
											title     : "<spring:message code='lbl.prod2' />"
										});
									}else if(chartId == "mainItemTypeLtChart") {
										gfn_comPopupOpen("POPUP_CHART_SUPPLY", {
											rootUrl   : "dashboard",
											url       : "popupChartSupplyTrend",
											width     : 1920,
											height    : 1060,
											menuCd    : "SNOP100",
											chartId   : chartId,
											title     : "<spring:message code='lbl.mainItemTypeLt' />"
										});
									}else if(chartId == "equipRateChart") {
										gfn_comPopupOpen("POPUP_CHART_SUPPLY", {
											rootUrl   : "dashboard",
											url       : "popupChartSupplyTrend",
											width     : 1920,
											height    : 1060,
											menuCd    : "SNOP100",
											chartId   : chartId,
											title     : "<spring:message code='lbl.equipRate' />"
										});
									}else if(chartId == "urgentInsertInfoChart") {
										gfn_comPopupOpen("POPUP_CHART_SUPPLY", {
											rootUrl   : "dashboard",
											url       : "popupChartSupplyTrend",
											width     : 1920,
											height    : 1060,
											menuCd    : "SNOP100",
											chartId   : chartId,
											title     : "<spring:message code='lbl.urgentInsertInfo' />"
										});
									}else if(chartId == "workInfoChart") {
										gfn_comPopupOpen("POPUP_CHART_SUPPLY", {
											rootUrl   : "dashboard",
											url       : "popupChartSupplyTrend",
											width     : 1920,
											height    : 1060,
											menuCd    : "SNOP100",
											chartId   : chartId,
											title     : "<spring:message code='lbl.workInfo' /> (<spring:message code='lbl.million' />)"
										});
									}else if(chartId == "urgentDemandCompRateChart") {
                                        gfn_comPopupOpen("POPUP_CHART_SUPPLY", {
                                            rootUrl   : "dashboard",
                                            url       : "popupChartSupplyTrend",
                                            width     : 1920,
                                            height    : 1060,
                                            menuCd    : "SNOP100",
                                            chartId   : chartId,
                                            title     : "<spring:message code='lbl.urgentDemandCompRate' />"
                                        });
                                    }
								}
							}
						}
					}
				}
			};
			
			if(chartId == "mainItemTypeLtChart"){
				chart.colors = [gv_cColor1, gv_cColor2, '#f7848d', '#666666', '#f0a482', '#f1e584', '#9ead59', '#5d9980', '#b986c2', '#d1afdd'];	
			}else if(chartId == "urgentInsertInfoChart" && FORM_SEARCH.urgentRepCustTotal == "repCust"){
				chart.colors = [gv_cColor1, gv_cColor2, '#f7848d', '#666666', '#f0a482', '#f1e584', '#9ead59', '#5d9980', '#b986c2', '#d1afdd'];
			}else if(chartId == "workInfoChart" && FORM_SEARCH.workRepCustTotal == "repCust"){
				chart.colors = [gv_cColor1, gv_cColor2, '#f7848d', '#666666', '#f0a482', '#f1e584', '#9ead59', '#5d9980', '#b986c2', '#d1afdd'];
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
		supplyTrend2.search(sqlFlag);
	}
	
 	// onload 
	$(document).ready(function() {
		supplyTrend2.init();
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
        
        
        
    
    }
    
    function fn_chartContentInit(array){
        
        
        /*
            
       0. productivity
	   1. overworkedAmountStatus
	   2. mainItemGroupLT
	   3. equipmentUtilizationRate
	   4. semiFinishedProductStockingRate
	   5. emergencyRegistrationStatus
	   6. urgentDemandCompRate
	   7. 
        */
        
        
        for(i=0;i<array.length;i++)
        {
            if(FORM_SEARCH.chartList[i].ID=="productivity")                          FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_1.setContents([{ insert: '\n' }]):quill_1.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
            else if(FORM_SEARCH.chartList[i].ID=="overworkedAmountStatus")           FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_2.setContents([{ insert: '\n' }]):quill_2.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
            else if(FORM_SEARCH.chartList[i].ID=="mainItemGroupLT")                  FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_3.setContents([{ insert: '\n' }]):quill_3.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
            else if(FORM_SEARCH.chartList[i].ID=="equipmentUtilizationRate")         FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_4.setContents([{ insert: '\n' }]):quill_4.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
            else if(FORM_SEARCH.chartList[i].ID=="semiFinishedProductStockingRate")  FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_5.setContents([{ insert: '\n' }]):quill_5.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
            else if(FORM_SEARCH.chartList[i].ID=="emergencyRegistrationStatus")      FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_6.setContents([{ insert: '\n' }]):quill_6.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));
            else if(FORM_SEARCH.chartList[i].ID=="urgentDemandCompRate")             FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_7.setContents([{ insert: '\n' }]):quill_7.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));                            
            else if(FORM_SEARCH.chartList[i].ID=="salesResultAgainstProdPlan")       FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_8.setContents([{ insert: '\n' }]):quill_8.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));
           
        }
        
        
        
    }

    function semiFinishedProductStockingRateActionToggle()
    {
        const action = $('#semiFinishedProductStockingRateAction');
        
        action.toggleClass('active')
    	
    }
    

    function emergencyRegistrationStatusActionToggle()
    {
    	
        const action = $('#emergencyRegistrationStatusAction');
        
        action.toggleClass('active')
    }
    
    function salesResultAgainstProdPlanChartGenChart(sqlFlag,res){
    	
    	
    	//연간 생산계획 대비 실적
		var codeNmArrSalesResultAgainstProdPlan = [];
        var lineData1SalesResultAgainstProdPlan = [];
        var lineData2SalesResultAgainstProdPlan = [];
        var lineData3SalesResultAgainstProdPlan = [];
        
        
        var latest_SALES_RESULT  =  null;
        var latest_PROD_PLAN     =  null;
        var latest_PROD_RESULT   =  null;
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
        	$('#salesResultAgainstProdPlanH4 > p').remove();
        	$('#salesResultAgainstProdPlanH4').append('<p class="green">'+ GAP +'</p>');
            
        }
        else if((latest_SALES_RESULT - latest_PROD_PLAN) == 0)
        {
            GAP  = 'GAP '+''+String(GAP_temp);
        	$('#salesResultAgainstProdPlanH4 > p').remove();
            $('#salesResultAgainstProdPlanH4').append('<p>'+ GAP +'</p>');
        }
        else
        {
            GAP  = 'GAP '+''+String(GAP_temp);
        	$('#salesResultAgainstProdPlanH4 > p').remove();
            $('#salesResultAgainstProdPlanH4').append('<p class="red">'+ GAP +'</p>');
            
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
                    point: {
                        events: {
                            click: function() {
                                
                                if(chartIdSalesResultAgainstProdPlan == "salesResultAgainstProdPlanChart") {
                                    gfn_comPopupOpen("POPUP_CHART_DEMEND", {
                                        rootUrl   : "dashboard",
                                        url       : "popupChartSupplyTrend",
                                        width     : 1920,
                                        height    : 1060,
                                        menuCd    : "SNOP100",
                                        chartId   : "salesResultAgainstProdPlan",
                                        title     : "<spring:message code='lbl.salesResultAgainstProdPlan' />",
                                        GAP       : GAP
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
				
					<!-- 생산성 -->
					<div class="col_3" >
						<div class="titleContainer">
							<h4 id="productivityH4"><spring:message code="lbl.prod2" /></h4>
							<div class="view_combo" >
								<ul class="rdofl">
									<li><input type="radio" id="timePeople1" name="timePeople" value="time"/> <label for="timePeople1"><spring:message code="lbl.timeProd2" /></label></li>
									<li><input type="radio" id="timePeople2" name="timePeople" value="people" checked="checked"/> <label for="timePeople2"><spring:message code="lbl.peopleProd2" /> </label></li>
									<li><input type="radio" id="productPart" name="productPartTotal" value="part"/> <label for="productPart"><spring:message code="lbl.part" /></label></li>
									<li><input type="radio" id="productTotal" name="productPartTotal" value="total" checked="checked"/> <label for="productTotal"><spring:message code="lbl.total" /> </label></li>
								    <li class="manuel">
                                        <a href="#" id="productivity"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                    </li>
								</ul>
							</div>
						</div>
						<div style="height: 100%;clear:both;" id="productChart" ></div>
						<div class="modal" id="productivityContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-1"></div>
                           </div>
                       </div>
					</div>
					
					<!-- 과재공 금액 현황 -->
					<div class="col_3" >
						<div class="titleContainer">
							<h4 id="overworkedAmountStatusH4"><spring:message code="lbl.workInfo" /> (<spring:message code="lbl.million" />)</h4>
							<div class="view_combo" >
								<ul class="rdofl">
									<li><input type="radio" id="workRepCustTotal1" name="workRepCustTotal" value="repCust" checked="checked"/> <label for="workRepCustTotal1"><spring:message code="lbl.reptCust" /></label></li>
									<li><input type="radio" id="workRepCustTotal2" name="workRepCustTotal" value="total"/> <label for="workRepCustTotal2"><spring:message code="lbl.total" /> </label></li>
								    <li class="manuel">
                                        <a href="#" id="overworkedAmountStatus"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                    </li>
								</ul>
							</div>
						</div>
						<div style="height: 100%;clear:both;" id="workInfoChart" ></div>
						<div class="modal" id="overworkedAmountStatusContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-2"></div>
                           </div>
                       </div>
					</div>
					
					
					<!-- 주요 품목그룹 LT -->
					<div class="col_3" >
						<div class="titleContainer">
							<h4 id="mainItemGroupLTH4"><spring:message code="lbl.mainItemTypeLt" /></h4>
							<div class="view_combo" >
								<ul class="rdofl">
		                                 <li class="manuel">
		                                    <a href="#" id="mainItemGroupLT"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
		                                 </li>
		                        </ul>
		                    </div>
                        </div>
						<div style="height: 100%" id="mainItemTypeLtChart" ></div>
						<div class="modal" id="mainItemGroupLTContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-3"></div>
                           </div>
                       </div>
					</div>
					
					<!-- 장비 가동률 -->
					<div class="col_3" >
						<div class="titleContainer">
							<h4 id="equipmentUtilizationRateH4"><spring:message code="lbl.equipRate" /></h4>
							<div class="view_combo" id="divEquipRate" >
						          
						    </div>
						</div>
						<div style="height: 100%;clear:both;" id="equipRateChart" ></div>
					    <div class="modal" id="equipmentUtilizationRateContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-4"></div>
                           </div>
                       </div>
					</div>
					
					<!-- 반제품 재고 확보율  -->
					<div class="col_3" >
						<div class="titleContainer">
							<h4 id="semiFinishedProductStockingRateH4"><spring:message code="lbl.inSemiItem" /></h4>
							<div class="view_combo"> <!-- class="action" id="semiFinishedProductStockingRateAction" -->
								<!--  <span>+</span> -->
								<ul class="rdofl" > <!-- style="height:125px;" -->
								    <li><input type="radio" id="inSemiItemOH" name="inSemiItemOhMhMm" value="OH" checked="checked"/> <label for="inSemiItemOH">외주반제품 </label></li>
                                    <li><input type="radio" id="inSemiItemMH" name="inSemiItemOhMhMm" value="MH" /> <label for="inSemiItemMH">사내반제품</label></li>
                                    <li><input type="radio" id="inSemiItemMM" name="inSemiItemOhMhMm" value="MM" /> <label for="inSemiItemMM">원자재생산품</label></li>
                                    
									<li><input type="radio" id="inSemiItemCntQty2" name="inSemiItemCntQty" value="CNT" checked="checked"/> <label for="inSemiItemCntQty2"><spring:message code="lbl.itemQty" /> </label></li>
									<li><input type="radio" id="inSemiItemCntQty1" name="inSemiItemCntQty" value="QTY" /> <label for="inSemiItemCntQty1"><spring:message code="lbl.qty" /></label></li>
								    <li class="manuel">
                                            <a href="#" id="semiFinishedProductStockingRate"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                    </li>
								</ul>
							</div>
						</div>
						<div style="height: 88%;clear:both;" id="inSemiItemChart" ></div>
						<div class="modal" id="semiFinishedProductStockingRateContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-5"></div>
                           </div>
                       </div>
					</div>
					
					<!-- 긴급건 등록 현황 -->
					<div class="col_3" >
						<div class="titleContainer">
							<h4 id="emergencyRegistrationStatusH4"><spring:message code="lbl.urgentInsertInfo" /></h4>
							<div class="view_combo"> <!--class="action" id="emergencyRegistrationStatusAction"  -->
									<!--  <span>+</span> -->
									<ul class="rdofl"> <!-- style="height:150px;"  -->
										<li><input type="radio" id="urgentCntQtyAmt1" name="urgentCntQtyAmt" value="CNT"/> <label for="urgentCntQtyAmt1"><spring:message code="lbl.cnt" /></label></li>
										<li><input type="radio" id="urgentCntQtyAmt2" name="urgentCntQtyAmt" value="QTY"/> <label for="urgentCntQtyAmt2"><spring:message code="lbl.qty" /></label></li>
										<li><input type="radio" id="urgentCntQtyAmt3" name="urgentCntQtyAmt" value="AMT" checked="checked"/> <label for="urgentCntQtyAmt3"><spring:message code="lbl.amt" />(<spring:message code="lbl.billion" />) </label></li>
										<li><input type="radio" id="urgentRepCustTotal1" name="urgentRepCustTotal" value="repCust" checked="checked"/> <label for="urgentRepCustTotal1"><spring:message code="lbl.reptCust" /></label></li>
										<li><input type="radio" id="urgentRepCustTotal2" name="urgentRepCustTotal" value="total"/> <label for="urgentRepCustTotal2"><spring:message code="lbl.total" /> </label></li>
									    <li class="manuel">
                                            <a href="#" id="emergencyRegistrationStatus"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                        </li> 
								    </ul>
						    </div>
						</div>
						<div style="height: 88%;clear:both;" id="urgentInsertInfoChart" ></div>
					    <div class="modal" id="emergencyRegistrationStatusContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-6"></div>
                           </div>
                       </div>
					</div>
					
					<!-- BLANK -->
					<div class="col_3" >
					 
                        
					</div>
					<!-- 연간 생산계획 대비 실적 -->
					<div class="col_3" >
                        
                        <div class="titleContainer">
                            <h4 id="salesResultAgainstProdPlanH4"><spring:message code="lbl.salesResultAgainstProdPlan" /></h4>
                            <div class="view_combo" >
                                 <ul class="rdofl">
  		                            <li><input type="radio" id="salesResultAgainstProdPlanTotal4" name="salesResultAgainstProdPlanTotal" value="DIFFUSION"/> 			 <label for="salesResultAgainstProdPlanTotal4"><spring:message code="lbl.diff2" /> </label></li>
                                    <li><input type="radio" id="salesResultAgainstProdPlanTotal3" name="salesResultAgainstProdPlanTotal" value="TEL"/> 					 <label for="salesResultAgainstProdPlanTotal3"><spring:message code="lbl.rcg004" /> </label></li>
                                    <li><input type="radio" id="salesResultAgainstProdPlanTotal2" name="salesResultAgainstProdPlanTotal" value="LAM"/> 					 <label for="salesResultAgainstProdPlanTotal2"><spring:message code="lbl.rcg003" /> </label></li>
                                    <li><input type="radio" id="salesResultAgainstProdPlanTotal1" name="salesResultAgainstProdPlanTotal" value="ALL" checked="checked"/> <label for="salesResultAgainstProdPlanTotal1"><spring:message code="lbl.total" /> </label></li>
                                    <li class="manuel">
                                        <a href="#" id="salesResultAgainstProdPlan"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <div style="height: 90%;clear:both;" id="salesResultAgainstProdPlanChart" ></div>
                        <div class="modal" id="salesResultAgainstProdPlanContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-8"></div>
                           </div>
                       </div>
                        
                        
					</div>
					
					<!-- 긴급 수요 준수율 -->
					<div class="col_3" >
						  <div class="titleContainer">
                            <h4 id="urgentDemandCompRateH4"><spring:message code="lbl.urgentDemandCompRate" /></h4>
                            <div class="view_combo"> 
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
                                        
                                        <li class="manuel">
                                            <a href="#" id="urgentDemandCompRate"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                        </li>
                                        
                                         
                                    </ul>
                            </div>
                        </div>
                        <div style="height: 78%;clear:both;" id="urgentDemandCompRateChart" ></div>
                        <div class="modal" id="urgentDemandCompRateContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-7"></div>
                           </div>
                       </div>
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
