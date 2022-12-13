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
	
	#cont_chart .col_3 {margin:0; width:calc((100% - 4px) / 3) ; height:calc((100% - 4px) / 3 ); position:relative;}
	#cont_chart .col_3:nth-child(1) {margin:0 2px 2px 0;}
	#cont_chart .col_3:nth-child(2) {margin:0 2px 2px 0;}
	#cont_chart .col_3:nth-child(3) {margin:0 0 2px 0;}
	#cont_chart .col_3:nth-child(4) {margin:0 2px 2px 0;}
	#cont_chart .col_3:nth-child(5) {margin:0 2px 2px 0;}
	#cont_chart .col_3:nth-child(6) {margin:0 0 2px 0;}
	#cont_chart .col_3:nth-child(7) {margin:0 2px 0 0;}
	#cont_chart .col_3:nth-child(8) {margin:0 2px 0 0;}
	
	
	#cont_chart .col_3 > .titleContainer{
	
	
	}
	
	#cont_chart .col_3 > .titleContainer > .view_combo{
	 
	}
	
	#cont_chart .col_3 > .titleContainer > .view_combo > .ilist > .iptdv{
       width:50px;
    }
	
	#cont_chart .col_3 > .titleContainer > .view_combo > .ilist > .iptdv > #gubunProdAmtChart{
       width:80px;
    }
    
    #cont_chart .col_3 > .titleContainer > .view_combo > .ilist > .iptdv > #gubunProdAmtChartMonth{
       width:50px;
    }
    
    
    #cont_chart .col_3 > .titleContainer > .view_combo > .ilist > .iptdv > #gubunShipmentAmtChart{
       width:75px;
    }
    #cont_chart .col_3 > .titleContainer > .view_combo > .ilist > .iptdv > #gubunShipmentAmtChartMonth{
       width:50px;
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
	  top: 0px;
	  right:33px;
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
    }
	
	#cont_chart .col_3 > .titleContainer > .action.active ul {
	
	  top: 5px;
	  right:33px;
	  opacity: 1;
	  visibility: visible;
	  transition: .3s;
      background: white;
      z-index:999;
      display:block;
      box-shadow: 0 5px 5px rgba(0,0,0,0.1);
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
	
	
	
	
	
	
	#cont_chart .col_3 > .titleContainer > h4
	{
	       display:inline-block;
	       
	}

/*
    #cont_chart .col_3 > .rdoContainer
    {
        display:block;
    }
*/

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
	
	
	</style>
	
	<script type="text/javascript">
	var CODE_SEARCH = {};
	var quill_1,quill_2,quill_3,quill_4,quill_5,quill_6,quill_7,quill_8,quill_9;
	var pastFlag = "Y";
	var claimChart,companyConsChart,chart3List,shipmentAmtChart,shipmentAmtTotalChart,prodAmtChart,prodAmtTotalChart,agingWipChart,defectivesChart;
	var userLang = "${sessionScope.GV_LANG}";
	var unit = 0;
	var format = "y:,.0f";
	var roundNum = 0;
	var shipmentAmtChartSelectBoxCode = null;
	var shipmentAmtChartSelectBoxCodeMonth = null;
	var comCode = {
			
	            codeMap : null,
	            
	            initCode : function () {
	                var grpCd = 'PROD_PART_10';
	                this.codeMap = gfn_getComCode(grpCd, 'N'); //공통코드 조회
	                this.codeMap.PROD_PART_10.unshift(
			                	{
			                	 
			                	        ATTB_1_CD: "ALL",
			                			BU_CD: "QT",
			                			CODE_CD: "ALL",
			                			CODE_NM: "ALL",
			                			GROUP_CD: "PROD_PART_10",
			                			GROUP_DESC: "Production Part(Product)",
			                			RNUM: 1,
			                			ROW_KEY: "PROD_PART_10ALL",
			                			SORT: 4,
			                			USE_FLAG: "Y"
			                		
			                    }
	                	   );
	                 
	            }
	      
	};
    $(function() {
    	
    	
    	gfn_formLoad(); //공통 폼 초기 정보 설정
    	fn_siteMap();
    	fn_init();
    	

    	
    });
    
   async function fn_init() {
	    fn_quilljsInit();
	    
    	comCode.initCode();
    	
    	var selectDate = "";
    	var cDate = gfn_getCurrentDate();
    	var pDate = gfn_getAddDate(cDate.YYYYMMDD, -7);
    	var nDate = gfn_getAddDate(cDate.YYYYMMDD, 7);
    	var dayNm = cDate.DAY_NM;
    	cWeek = "W" + cDate.WEEKOFYEAR;
    	pWeek = "W" + pDate.WEEKOFYEAR;
    	nWeek = "W" + nDate.WEEKOFYEAR;
    	
    	if(dayNm == "MON" || dayNm == "TUE" || dayNm == "WED" || dayNm == "SUN"){//일월화수
    		selectDate = pWeek;
    	}else{
    		selectDate = cWeek;
    		pastFlag = "N";
    	} 
    	
    	
    	//supplyCapacityIndexPweekTxt
    	$.each($(".supplyCapacityIndexPweekTxt"), function(n,v) {
            $(v).text(' ('+cWeek+')');
        });
    	
        $.each($(".pweekTxt"), function(n,v) {
    		$(v).text(' ('+pWeek+')');
    	});
    	
    	$.each($(".selectWeekTxt"), function(n,v) {
    		$(v).text(' ('+selectDate+')');
    	});
    	
    	
    	
        await fn_get_shipmentAmtChartSelectBoxCode();
        CODE_SEARCH.shipmentAmtChartSelectBoxCode.unshift(
        		    
        		    {
	        		    CODE_CD: "ALL",
	        		    CODE_NM: "ALL"
	        		}
                )
        
        
        $.each($(".cweekTxt"), function(n,v) {
            $(v).text(' ('+CODE_SEARCH.shipmentAmtChartSelectBoxCodeMonth[0].CODE_CD+'M'+')');
        });
        
                
                
       // 콤보박스
        gfn_setMsComboAll([
        	
        	{
                target : 'divGubunProdAmtChart'     , id : 'gubunProdAmtChart'     , title : ''
                , data : comCode.codeMap.PROD_PART_10
                , exData:[  ]
                , type : "S" 
            },
            {
                target : 'divGubunShipmentAmtChart'     , id : 'gubunShipmentAmtChart'     , title : ''
                , data : CODE_SEARCH.shipmentAmtChartSelectBoxCode
                , exData:[  ]
                , type : "S" 
            },
            {
                target : 'divGubunProdAmtChartMonth'     , id : 'gubunProdAmtChartMonth'     , title : ''
                , data : CODE_SEARCH.shipmentAmtChartSelectBoxCodeMonth
                , exData:[  ]
                , type : "S" 
            },
            {
                target : 'divGubunShipmentAmtChartMonth'     , id : 'gubunShipmentAmtChartMonth'     , title : ''
                , data : CODE_SEARCH.shipmentAmtChartSelectBoxCodeMonth
                , exData:[  ]
                , type : "S" 
            }
            
        ])
        
        
        fn_initEvent();
        fn_apply();
    }
    
    function fn_initEvent() {
    	/*
    	//		자재 가용룰				scmDash222 
		$(':radio[name=weekMaterialsAvail]').on('change', function () {
			materialChartSearch(false);
		});
    	*/
    	/*
		// 		자재입고 준수율 			scmDash222 
		$(':radio[name=materialRate]').on('change', function () {
			materialRateChartSearch(false);
		});
		*/
		//		제품 재고 				scmDash111 
		$(':radio[name=companyCons]').on('change', function () {
			companyConsChartSearch(false);
		});
		
		//		재공 Again 			scmDash111 
		$(':radio[name=periodDate]').on('change', function () {
			agingWipChartSearch(false);
		});
		
		$('.titleContainer > .action').hover(function(){
			
			var chartId = this.id;
			
			
			if(chartId == 'stockInWorkAgingScmAction')
			{
			    stockInWorkAgingScmActionToggle();
	        	
			}
			
			else if(chartId == 'productInventoryScmAction')
			{
				productInventoryScmActionToggle();	
			
			}
			
			
			
			
		});
		
    	var arrTitle = $("h4");
    	$.each(arrTitle, function(n,v) {
    		$(v).css("cursor", "pointer");
    		$(v).on("click", function() { 
    			if (n == 0) gfn_newTab("QT102");           //<!-- Claim Rate(연간) -->    <!-- scmDash111  -->
    			else if (n == 1) gfn_newTab("QT101");	   //<!-- 불량률 -->				<!-- scmDash111  -->	
    			else if (n == 2) gfn_newTab("MP102");	   //<!-- 공급능력지수 -->			<!-- scmDash111  -->
    			else if (n == 3) gfn_newTab("MP106");	   //<!-- 생산 금액 -->				<!-- scmDash111  -->
    			else if (n == 4) gfn_newTab("SNOP304");	   //<!-- 생산 준수율 -->			<!-- scmDash111  -->
    			else if (n == 5) gfn_newTab("MP105");	   //<!-- 재공 Again -->			<!-- scmDash111  -->
    			else if (n == 6) gfn_newTab("DP309");	   //<!-- 출하 금액  -->				<!-- scmDash111  -->
    			else if (n == 7) gfn_newTab("SNOP205");	   //<!-- 제품 재고 -->				<!-- scmDash111  -->
    			else if (n == 8) gfn_newTab("MP105");	   //<!-- 재공 금액 -->				<!-- scmDash111  -->
    		});
    	});
    	
    	
    	$(".manuel > a").dblclick("on", function() {
    		
    		var chartId  = this.id;
            
            fn_popUpAuthorityHasOrNot();
            
            var isSCMTeam = SCM_SEARCH.isSCMTeam;
            
            if(isSCMTeam>=1)
            {
            	//Claim Rate
            	if(chartId == "claimRateScm")
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
            	//불량률
            	else if(chartId == "defectiveRateScm")
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
            	//공급능력지수
            	else if(chartId == "supplyCapacityIndexScm")
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
            	//생산 금액
            	else if(chartId == "productionAmount")
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
            	//생산 준수율
            	else if(chartId == "productionComplianceRateScm")
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
            	//재공 Aging
            	else if(chartId == "stockInWorkAgingScm")
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
            	//출하 금액
            	else if(chartId == "shipmentAmount")
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
            	//제품 재고
            	else if(chartId == "productInventoryScm")
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
            	//재공 금액
            	else if(chartId == "stockInWorkAmount")
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
              
    		//Claim Rate
              if(chartId == "claimRateScm")
              {
            	  $('#claimRateScmDatawrap').toggle();
            	  $('#claimRateScmContent').toggle();
              }
              //불량률
              else if(chartId == "defectiveRateScm")
              {
                  $('#defectivesChart').toggle();
                  $('#defectiveRateScmContent').toggle();
              }
              //공급능력지수
              else if(chartId == "supplyCapacityIndexScm")
              {
                  $('#supplyCapacityIndexScmDatawrap').toggle();
                  $('#supplyCapacityIndexScmContent').toggle();
              }
              //생산 금액
              else if(chartId == "productionAmount")
              {
                  $('#prodAmtChart').toggle();
                  $('#productionAmountContent').toggle();
              }
              //생산 준수율
              else if(chartId == "productionComplianceRateScm")
              {
                  $('#productionComplianceRateScmDatawrap').toggle();
                  $('#productionComplianceRateScmContent').toggle();
              }
              //재공 Aging
              else if(chartId == "stockInWorkAgingScm")
              {
                  $('#stockInWorkAgingScmDatawrap').toggle();
                  $('#stockInWorkAgingScmContent').toggle();
              }
              //출하 금액
              else if(chartId == "shipmentAmount")
              {
                  $('#shipmentAmtChart').toggle();
                  $('#shipmentAmountContent').toggle();
              }
              //제품 재고
              else if(chartId == "productInventoryScm")
              {
                  $('#productInventoryScmDatawrap').toggle();
                  $('#productInventoryScmContent').toggle();
              }
              //재공 금액
              else if(chartId == "stockInWorkAmount")
              {
                  $('#stockInWorkAmountDatawrap').toggle();
                  $('#stockInWorkAmountContent').toggle();
              }
    		
    	});
    	
    	
    	
    	
    	
        $(".titleContainer > h4").hover(function() {
            
            var chartId  = this.id;
            
          //Claim Rate
            if(chartId == "claimRateScmH4")
            {
                $('#claimRateScmDatawrap').toggle();
                $('#claimRateScmContent').toggle();
            }
            //불량률
            else if(chartId == "defectiveRateScmH4")
            {
                $('#defectivesChart').toggle();
                $('#defectiveRateScmContent').toggle();
            }
            //공급능력지수
            else if(chartId == "supplyCapacityIndexScmH4")
            {
                $('#supplyCapacityIndexScmDatawrap').toggle();
                $('#supplyCapacityIndexScmContent').toggle();
            }
            //생산 금액
            else if(chartId == "productionAmountH4")
            {
                $('#prodAmtChart').toggle();
                $('#productionAmountContent').toggle();
            }
            //생산 준수율
            else if(chartId == "productionComplianceRateScmH4")
            {
                $('#productionComplianceRateScmDatawrap').toggle();
                $('#productionComplianceRateScmContent').toggle();
            }
            //재공 Aging
            else if(chartId == "stockInWorkAgingScmH4")
            {
                $('#stockInWorkAgingScmDatawrap').toggle();
                $('#stockInWorkAgingScmContent').toggle();
            }
            //출하 금액
            else if(chartId == "shipmentAmountH4")
            {
                $('#shipmentAmtChart').toggle();
                $('#shipmentAmountContent').toggle();
            }
            //제품 재고
            else if(chartId == "productInventoryScmH4")
            {
                $('#productInventoryScmDatawrap').toggle();
                $('#productInventoryScmContent').toggle();
            }
            //재공 금액
            else if(chartId == "stockInWorkAmountH4")
            {
                $('#stockInWorkAmountDatawrap').toggle();
                $('#stockInWorkAmountContent').toggle();
            }
          
      });
    	
        
        
        $("#gubunProdAmtChart").change("on",function(){
            
        	
            prodAmtChartSEARCH(false);
        	
        });
        
        $("#gubunShipmentAmtChart").change("on",function(){
            
            
        	shipmentAmtChartSEARCH(false);
            
        })
        
        $("#gubunProdAmtChartMonth").change("on",function(){
            
        	 $.each($("#cweekTxtProd"), function(n,v) {
                 $(v).text(' ('+$('#gubunProdAmtChartMonth option:selected').val()+'M'+')');
             });
            
        	
            //$('#cweekTxtProd').val('10월') //= $('#gubunProdAmtChartMonth option:selected').val()
            prodAmtChartSEARCH(false);
            
        });
        
        $("#gubunShipmentAmtChartMonth").change("on",function(){
            
        	 $.each($("#cweekTxtSales"), function(n,v) {
                 $(v).text(' ('+$('#gubunShipmentAmtChartMonth option:selected').val()+'M'+')');
             });
            
        	
            //$('#cweekTxtSales').val('10월') //= $('#gubunShipmentAmtChartMonth option:selected').val()            
            shipmentAmtChartSEARCH(false);
            
        })
        
        
        
    }
    
    //조회
    function fn_apply(sqlFlag) {
    	
    	if(userLang == "ko"){
    		unit = 100000000;
    		roundNum = 0;
    		format = "y:,.0f";
    	}else if(userLang == "en" || userLang == "cn"){
    		unit = 1000000000;
    		roundNum = 1;
    		format = "y:,.1f";
    	}
    	
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql = sqlFlag;
    	
    	//메인 데이터를 조회
    	fn_getChartData();
    }
    
    function fn_getChartData() {
    	
    	FORM_SEARCH.weekMaterialsAvail = $(':radio[name=weekMaterialsAvail]:checked').val();
    	FORM_SEARCH.materialRate = $(':radio[name=materialRate]:checked').val();
    	FORM_SEARCH.companyCons = $(':radio[name=companyCons]:checked').val();
    	FORM_SEARCH.periodDate = $(':radio[name=periodDate]:checked').val();
    	FORM_SEARCH.pastFlag = pastFlag;
    	FORM_SEARCH._mtd = "getList";
    	FORM_SEARCH.unit = unit;
    	FORM_SEARCH.prodPart = 'ALL'//$('#gubunProdAmtChart > option:selected').val();
    	FORM_SEARCH.month    = CODE_SEARCH.shipmentAmtChartSelectBoxCodeMonth[0].CODE_CD
    	FORM_SEARCH.tranData = [{outDs:"claimChart", _siq:"dashboard.scmDash.claimChart"}						//<!-- Claim Rate(연간) -->    <!-- scmDash111  -->
    						 //, {outDs:"materialChart", _siq:"dashboard.scmDash.materialChart"}					//<!-- 자재 가용룰-->				<!-- scmDash222  -->
    						 //, {outDs:"materialsRateChart", _siq:"dashboard.scmDash.materialsRateChart"}		//<!-- 자재입고 준수율 -->			<!-- scmDash222  -->
    						 , {outDs:"companyConsChart", _siq:"dashboard.scmDash.companyConsChart"}			//<!-- 제품 재고 -->				<!-- scmDash111  -->
    						 , {outDs:"chart3List", _siq:"dashboard.scmDash.chart3"}							// 공급능력지수, 생산 준수율, 재공 금액
    						 //, {outDs:"basicReqChart", _siq:"dashboard.scmDash.basicReqChart"}					//<!-- 기준정보 등록률 -->			<!-- scmDash222  -->
    						 , {outDs:"shipmentAmtChart", _siq:"dashboard.scmDash.shipmentAmtChart"}			//<!-- 출하 금액  -->				<!-- scmDash111  -->
    						 , {outDs:"shipmentAmtTotalChart", _siq:"dashboard.scmDash.shipmentAmtTotalChart"}	//<!-- 출하 금액  -->				<!-- scmDash111  -->
    						 , {outDs:"prodAmtChart", _siq:"dashboard.scmDash.prodAmtChart"}					//<!-- 생산 금액 -->				<!-- scmDash111  -->
    						 , {outDs:"prodAmtTotalChart", _siq:"dashboard.scmDash.prodAmtTotalChart"}			//<!-- 생산 금액 -->				<!-- scmDash111  -->
    						 , {outDs:"agingWipChart", _siq:"dashboard.scmDash.agingWipChart"}					//<!-- 재공 Again -->			<!-- scmDash111  -->
    						 , {outDs:"defectivesChart", _siq:"dashboard.scmDash.defectivesChart"}				//<!-- 불량률 -->				<!-- scmDash111  -->
    				         , { outDs : "chartList" , _siq : "dashboard.chartInfo.scmDash" }
    						 ];    
		
    	var sMap = {
            url: "${ctx}/biz/obj",
            data: FORM_SEARCH,
            success:function(data) {
            	
            	claimChart      = data.claimChart;			 		//<!-- Claim Rate(연간) -->    <!-- scmDash111  -->
            	//materialChart   = data.materialChart;		 		//<!-- 자재 가용룰-->				<!-- scmDash222  -->
            	//materialsRateChart = data.materialsRateChart;		//<!-- 자재입고 준수율 -->			<!-- scmDash222  -->
            	companyConsChart = data.companyConsChart;	 		//<!-- 제품 재고 -->				<!-- scmDash111  -->
            	chart3List = data.chart3List;						//>!-- 공급능력지수, 생산 준수율, 재공금액 -->
            	//basicReqChart = data.basicReqChart;					//<!-- 기준정보 등록률 -->			<!-- scmDash222  -->
            	shipmentAmtChart = data.shipmentAmtChart;	 		//<!-- 출하 금액  -->				<!-- scmDash111  -->
            	shipmentAmtTotalChart = data.shipmentAmtTotalChart; //<!-- 출하 금액  -->				<!-- scmDash111  -->
            	prodAmtChart = data.prodAmtChart;					//<!-- 생산 금액 -->				<!-- scmDash111  -->
            	prodAmtTotalChart = data.prodAmtTotalChart;			//<!-- 생산 금액 -->				<!-- scmDash111  -->	
            	agingWipChart = data.agingWipChart;					//<!-- 재공 Again -->			<!-- scmDash111  -->
            	defectivesChart = data.defectivesChart;				//<!-- 불량률 -->				<!-- scmDash111  -->
            	FORM_SEARCH.chartList = data.chartList;
            	fn_chartContentInit();
            	
            	fn_initChart();
            }
        }
        gfn_service(sMap,"obj");
    }

    //차트 초기화
    function fn_initChart() {
    	
    	//테마적용 공통함수
    	gfn_setHighchartTheme();
    	
    	//1.Claim     <!-- Claim Rate(연간) -->    <!-- scmDash111  -->
    	if (claimChart.length > 0) {
    		//thisMonth
    		$("#claimChart_1").html("<strong>"+ gfn_addCommas(claimChart[0].CLAIM_RATE) +"</strong>");
    		$("#claimChart_2").text(claimChart[0].CLAIM_QTY_M + "<spring:message code='lbl.count'/>");
    		$("#claimChart_3").text(" / "+claimChart[0].CLAIM_QTY_Y + "<spring:message code='lbl.count'/>");
    		/*
    		$("#claimChart_2_2").text(claimChart[0].CLAIM_QTY_Y+"<spring:message code='lbl.count'/>");
    		$("#claimChart_3_2").text("<spring:message code='lbl.thisyear'/>");				
    		*/
    		cDataC = claimChart[0].CHART_C;
    		
    		$("#claimChart_1").parent().attr("class","per_txt "+cDataC);
    	}
    	
    	//2. 불량률		<!-- 불량률 -->				<!-- scmDash111  -->
    	var defectArr = new Array();
    	$.each(defectivesChart, function(i, val){
    		
    		var prodPart = val.PROD_PART;
    		var defRate = val.DEF_RATE;
    		
    		defectArr.push({name : prodPart, y : defRate});
    	})
    	
    	Highcharts.chart('defectivesChart', {
    	    chart: { type: 'column' },
    	    xAxis: { type: 'category' },
    	    yAxis: {
    	    },
    	    plotOptions: {
    	        column: {
    	            dataLabels: {
    	                format: '{y:,.2f}%',
    	                style : {
    	                	fontSize : "12px",
    	                	fontWeight: ''
						}
    	            }
    	        }
    	    },
    	    exporting : {
    	    	enabled: false,
    	    },
    	    series: [{
    	    	colorByPoint: true,
    	        data: defectArr
    	    }]
    	});
    	
    	/*
    	//3. 자재가용률     		<!-- 자재 가용룰-->				<!-- scmDash222  -->
    	$.each(materialChart, function(i, val){
    		
    		var cDataP = "";
    		var chart1 = val.CHART_1;
    		var chart2 = val.CHART_2;
    		var chartC = val.CHART_C;
    		var chartCSub = val.CHART_C_SUB;
    		
    		if(userLang == "ko"){
    			chart1    = gfn_getNumberFmt(chart1, 0, 'R', 'Y');       
    			chart2    = gfn_getNumberFmt(chart2, 0, 'R', 'Y');
        	}else if(userLang == "en" || userLang == "cn"){
        		chart1    = gfn_getNumberFmt(chart1, 1, 'R', 'Y');       
    			chart2    = gfn_getNumberFmt(chart2, 1, 'R', 'Y');
        	}
    		
    		if (chart2 > 0){
    			cDataP = "+";
    		}

    		$("#materialChart_1").text(chart1);
    		$("#materialChart_1").parent().attr("class", "per_txt " + chartC);
    		$("#materialChart_2").text(cDataP + chart2);
    		$("#materialChart_2").parent().attr("class", "per_txt1 " + chartCSub);
    	});
    	*/
    	
    	/*
    	//자재입고 준수율	<!-- 자재입고 준수율 -->			<!-- scmDash222  -->
    	var beforeResultValue = 0;
    	$.each(materialsRateChart, function(i, val){
    		
    		var cnt = i + 1;
    		var cDataP = "";
    		var trendWeek = val.TREND_WEEK;
    		var resultValue = val.RESULT_VALUE;
    		var chartC = val.CHART_C;
    		
    		if(userLang == "ko"){
    			resultValue    = gfn_getNumberFmt(resultValue, 0, 'R', 'Y');       
        	}else if(userLang == "en" || userLang == "cn"){
        		resultValue    = gfn_getNumberFmt(resultValue, 1, 'R', 'Y');       
        	}
    		
    		if(i == 0){
    			$("#materialsRateH4").html("(W" + trendWeek + ")");
    		}
    		
    		if (i == 1 || i == 3){
    			
    			var tmpValue = beforeResultValue - resultValue; 
    			
    			if(tmpValue > 0){
    				cDataP = "+";	
    			}
    			$("#materialsRateChart_" + cnt).text(cDataP + tmpValue);
        		$("#materialsRateChart_" + cnt).parent().attr("class","per_txt1 " + chartC);	
    		}else{
        		$("#materialsRateChart_" + cnt).text(resultValue);
        		$("#materialsRateChart_" + cnt).parent().attr("class","per_txt " + chartC);	
    		}
    		
    		beforeResultValue = resultValue;
    	});
    	*/
    	
    	//제품 재고	 <!-- 제품 재고 -->				<!-- scmDash111  -->
    	$.each(companyConsChart, function(i, val){
    		
    		var cDataP = "";
    		var chart1 = val.CHART_1;
    		var chart2 = val.CHART_2;
    		var chartC = val.CHART_C;
    		var chartCSub = val.CHART_C_SUB;
    		
    		if(userLang == "ko"){
    			chart1    = gfn_getNumberFmt(chart1 / unit, 0, 'R', 'Y');       
    			chart2    = gfn_getNumberFmt(chart2 / unit, 0, 'R', 'Y');
        	}else if(userLang == "en" || userLang == "cn"){
        		chart1    = gfn_getNumberFmt(chart1 / unit, 1, 'R', 'Y');       
    			chart2    = gfn_getNumberFmt(chart2 / unit, 1, 'R', 'Y');
        	}
    		
    		if (chart2 > 0){
    			cDataP = "+";
    		}
    		
   			$("#companyConsChart_1").text(chart1);
       		$("#companyConsChart_1").parent().attr("class","per_txt " + chartC);
       		$("#companyConsChart_2").text(cDataP + chart2);
       		$("#companyConsChart_2").parent().attr("class","per_txt1 " + chartCSub);
    	});
    	
    	/*
    	//기준정보 등록률		<!-- 기준정보 등록률 -->			<!-- scmDash222  -->
    	$.each(basicReqChart, function(i, val){
    		
    		var rate = val.RATE;
    		var cnt = val.CNT;
    		var chartC = val.CHART_C;
    		
    		$("#basicReqChart_1").text(rate);
    		$("#basicReqChart_1").parent().attr("class","per_txt " + chartC);
    		$("#basicReqChart_2").text(cnt);
    		$("#basicReqChart_2").parent().attr("class","per_txt1 red_f");
    	});
    	*/
    	
    	//Again 재공			//<!-- 재공 Again -->			<!-- scmDash111  -->
    	$.each(agingWipChart, function(i, val){
    		
    		var cDataP = "";
    		var chart1 = val.CHART_1;
    		var chart2 = val.CHART_2;
    		var chartC = val.CHART_C;
    		var chartCSub = val.CHART_C_SUB;
    		
    		if(userLang == "ko"){
    			chart1    = gfn_getNumberFmt(chart1 / unit, 0, 'R', 'Y');       
    			chart2    = gfn_getNumberFmt(chart2 / unit, 0, 'R', 'Y');
        	}else if(userLang == "en" || userLang == "cn"){
        		chart1    = gfn_getNumberFmt(chart1 / unit, 1, 'R', 'Y');       
    			chart2    = gfn_getNumberFmt(chart2 / unit, 1, 'R', 'Y');
        	}
    		
    		if (chart2 > 0){
    			cDataP = "+";
    		}
    		
   			$("#agingWipChart_1").text(chart1);
       		$("#agingWipChart_1").parent().attr("class","per_txt " + chartC);
       		$("#agingWipChart_2").text(cDataP + chart2);
       		$("#agingWipChart_2").parent().attr("class","per_txt1 " + chartCSub);
    	});
    	
    	//출하 금액				//<!-- 출하 금액  -->				<!-- scmDash111  -->		
    	var preWeek = "";
    	var xCategory = [], yCategory = [], cData = [];
    	var cIdx = -1, amt, tmpCdata = [];
    	var arrColor = ['#4F81BC', '#8DADD3', '#C0504E'];
    	var y = 0;
    	
    	$.each(shipmentAmtChart, function(n,v) {
    		
    		if (!gfn_isNull(v.AMT)) {
	    		amt = v.AMT / unit;

	    		if(userLang == "ko"){
	    			amt = gfn_getNumberFmt(amt, 0, 'R');
	    			y = -55;
	        	}else if(userLang == "en" || userLang == "cn"){
	        		amt = gfn_getNumberFmt(amt, 1, 'R');
	        		y = -115;
	        	}
    		} else {
    			amt = null;
    		}
    		tmpCdata.push({y:amt, color: arrColor[n%3]});
    		
    		//3의 배수
    		if (Math.ceil((n+1) % 3) == 0) {
    			cData.push({name: v.YEARWEEK, data: tmpCdata}); 
    			tmpCdata = [];
    		}
    		
    		if (n < 3) {
    			yCategory.push(v.MEAS_NM);
    		}
    	});
    	
    	Highcharts.chart('shipmentAmtChart', {
		    chart: {
		        type: 'bar'
		    },
		    xAxis: {
		        categories: yCategory
		    },
		    yAxis: {
		        labels : { enabled : true}, 
		        min: 0,
		        stackLabels : {
		        	enabled : true,
    	    		style   : {
    	    			fontWeight:'bold',
    	    			fontSize:"15px"
    	    		},
		        	formatter : function() {
		        		var x = this.x;
		        		
		        		var sum = shipmentAmtTotalChart[x].TOTAL_AMT / unit;

			    		if(userLang == "ko"){
			    			sum = gfn_getNumberFmt(sum, 0, 'R');
			        	}else if(userLang == "en" || userLang == "cn"){
			        		sum = gfn_getNumberFmt(sum, 1, 'R');
			        	}
		        		
		        		return sum;
		        	}
		        }
		    },
		    legend: {
		        reversed: true
		    },
		    exporting : {
    	    	enabled: false,
    	    },
		    tooltip : {
		    	enabled : false
		    },
		    plotOptions: {
    	        bar: {
    	            dataLabels: {
    	                format: '{'+format+'}<spring:message code="lbl.billion"/>',
    	                style : {
    	                	fontSize : "12px",
    	                	fontWeight: ''
						}
    	            }
    	        }
		    },
		    series: cData
		});
    		
    	//생산 금액			//<!-- 생산 금액 -->				<!-- scmDash111  -->	
    	var xCategory = [], yCategory = [], cData = [];
    	var preWeek = "";
    	var cIdx = -1, amt, tmpCdata = [];
    	var y = 0;
    	$.each(prodAmtChart, function(n,v) {
    		if (!gfn_isNull(v.AMT)) {
	    		amt = v.AMT / unit;
	    		
	    		if(userLang == "ko"){
	    			amt = gfn_getNumberFmt(amt, 0, 'R');
	    			y = -55;
	        	}else if(userLang == "en" || userLang == "cn"){
	        		amt = gfn_getNumberFmt(amt, 1, 'R');
	        		y = -115;
	        	}
	    		
    		} else {
    			amt = null;
    		}
    		tmpCdata.push({y:amt, color: arrColor[n%3]});
    		
    		//3의 배수
    		if (Math.ceil((n+1) % 3) == 0) {
    			cData.push({name: v.YEARWEEK, data: tmpCdata}); 
    			tmpCdata = [];
    		}
    		
    		if (n < 3) {
    			yCategory.push(v.MEAS_NM);
    		}
    	});
    	
    	Highcharts.chart('prodAmtChart', {
		    chart: {
		        type: 'bar'
		    },
		    xAxis: {
		        categories: yCategory
		    },
		    yAxis: {
		        labels : { enabled : true}, 
		        min: 0,
		        stackLabels : {
		        	enabled : true,
    	    		style   : {
    	    			fontWeight:'bold',
    	    			fontSize:"15px"
    	    		},
    	    		//y : y,
		        	formatter : function() {
						var x = this.x;
		        		
		        		var sum = prodAmtTotalChart[x].TOTAL_AMT / unit;

			    		if(userLang == "ko"){
			    			sum = gfn_getNumberFmt(sum, 0,'R');
			        	}else if(userLang == "en" || userLang == "cn"){
			        		sum = gfn_getNumberFmt(sum, 1,'R');
			        	}
		        		
		        		return sum;
		        	}
		        }
		    },
		    legend: {
		        reversed: true
		    },
		    exporting : {
    	    	enabled: false,
    	    },
		    tooltip : {
		    	enabled : false
		    },
		    plotOptions: {
    	        bar: {
    	            dataLabels: {
    	                format: '{'+format+'}<spring:message code="lbl.billion"/>',
    	                style : {
    	                	fontSize : "12px",
    	                	fontWeight: ''
						}
    	            }
    	        }
		    },
		    series: cData
		});
    	
    	//공급 능력지수, 생산 준수율, 재공 금액
    	var chart3; 
    	var chart3ListLen = chart3List.length + 1;
    	
    	for (var i = 1; i <= chart3ListLen; i++) {
    		
	    	
    		cData1 = 0, cData2 = 0, cDataC = "", cDataP = "green_f", cDataCSub = "gray_f";
	    	chart3 = gfn_getFindDataDsInDs(chart3List, {MEAS_CD : {VALUE : "CHART" + i, CONDI : "="}});
	    	
	    	if (chart3.length > 0) {
	    		
	    		if ($("#chart3_"+ i +"_1").parent().text().indexOf('<spring:message code="lbl.billion"/>') > -1) {
	    			cData1 = chart3[0].CHART_1 / unit;
	    			cData2 = chart3[0].CHART_2 / unit;
	    		} else {
	    			cData1 = chart3[0].CHART_1;
	    			cData2 = chart3[0].CHART_2;
	    		}
	    		
	    		if(userLang == "ko"){
	    			cData1    = gfn_getNumberFmt(cData1, 0, 'R','Y');       
		    		cData2    = gfn_getNumberFmt(cData2, 0, 'R','Y');
	        	}else if(userLang == "en" || userLang == "cn"){
	        		
	        		if(i == 3 || i == 4 || i == 5 || i == 6){
	        			cData1 = gfn_getNumberFmt(cData1, 0, 'R','Y');       
			    		cData2 = gfn_getNumberFmt(cData2, 0, 'R','Y');	        			
	        		}else{
	        			cData1 = gfn_getNumberFmt(cData1, 1, 'R','Y');       
			    		cData2= gfn_getNumberFmt(cData2, 1, 'R','Y');
	        		}
	        	}
	    		
	    		cDataC    = chart3[0].CHART_C;
	    		cDataP    = chart3[0].CHART_P;
	    		cDataCSub = chart3[0].CHART_C_SUB;
	    		
	    		if (cData2 > 0) {
	    			cDataP = "+";
	    		}
	    		
	    		$("#chart3_"+ i +"_1").text(cData1);
	    		$("#chart3_"+ i +"_1").parent().attr("class","per_txt "+cDataC);
	    		$("#chart3_"+ i +"_2").text(cDataP+cData2);
	    		$("#chart3_"+ i +"_2").parent().attr("class","per_txt1 "+cDataCSub);
	    	}
    	}
    	
    }
    
    function companyConsChartSearch(){
    	
    	FORM_SEARCH = {};
    	FORM_SEARCH.companyCons = $(':radio[name=companyCons]:checked').val();
    	FORM_SEARCH._mtd = "getList";
    	FORM_SEARCH.tranData = [{outDs:"companyConsChart", _siq:"dashboard.scmDash.companyConsChart"}];
    	
    	var sMap = {
            url: "${ctx}/biz/obj",
            data: FORM_SEARCH,
            success:function(data) {
            	
            	$.each(data.companyConsChart, function(i, val){
            		
            		var cDataP = "";
            		var chart1 = val.CHART_1;
            		var chart2 = val.CHART_2;
            		var chartC = val.CHART_C;
            		var chartCSub = val.CHART_C_SUB;
            		
            		if(userLang == "ko"){
            			chart1    = gfn_getNumberFmt(chart1 / unit, 0, 'R', 'Y');       
            			chart2    = gfn_getNumberFmt(chart2 / unit, 0, 'R', 'Y');
                	}else if(userLang == "en" || userLang == "cn"){
                		chart1    = gfn_getNumberFmt(chart1 / unit, 1, 'R', 'Y');       
            			chart2    = gfn_getNumberFmt(chart2 / unit, 1, 'R', 'Y');
                	}
            		
            		if (chart2 > 0){
            			cDataP = "+";
            		}
            		
           			$("#companyConsChart_1").text(chart1);
               		$("#companyConsChart_1").parent().attr("class","per_txt " + chartC);
               		$("#companyConsChart_2").text(cDataP + chart2);
               		$("#companyConsChart_2").parent().attr("class","per_txt1 " + chartCSub);
            	});
            }
        }
        gfn_service(sMap,"obj");
    }
    
    /*
    function materialChartSearch(){
    	
    	FORM_SEARCH = {};
    	FORM_SEARCH.weekMaterialsAvail = $(':radio[name=weekMaterialsAvail]:checked').val();
    	FORM_SEARCH.pastFlag = pastFlag;
    	FORM_SEARCH._mtd = "getList";
    	FORM_SEARCH.tranData = [{outDs:"materialChart", _siq:"dashboard.scmDash.materialChart"}];
    	
    	var sMap = {
            url: "${ctx}/biz/obj",
            data: FORM_SEARCH,
            success:function(data) {
            	
            	$.each(data.materialChart, function(i, val){
            		
            		var cDataP = "";
            		var chart1 = val.CHART_1;
            		var chart2 = val.CHART_2;
            		var chartC = val.CHART_C;
            		var chartCSub = val.CHART_C_SUB;
            		
            		
            		if(userLang == "ko"){
            			chart1    = gfn_getNumberFmt(chart1, 0, 'R', 'Y');       
            			chart2    = gfn_getNumberFmt(chart2, 0, 'R', 'Y');
                	}else if(userLang == "en" || userLang == "cn"){
                		chart1    = gfn_getNumberFmt(chart1, 1, 'R', 'Y');       
            			chart2    = gfn_getNumberFmt(chart2, 1, 'R', 'Y');
                	}
            		
            		if (chart2 > 0){
            			cDataP = "+";
            		}
            		
            		$("#materialChart_1").text(chart1);
            		$("#materialChart_1").parent().attr("class","per_txt " + chartC);
            		$("#materialChart_2").text(cDataP + chart2);
            		$("#materialChart_2").parent().attr("class","per_txt1 " + chartCSub);
            	});
            }
        }
        gfn_service(sMap,"obj");
    }
    */
    
    /*
    function materialRateChartSearch(){
    	
    	FORM_SEARCH = {};
    	FORM_SEARCH.materialRate = $(':radio[name=materialRate]:checked').val();
    	FORM_SEARCH._mtd = "getList";
    	FORM_SEARCH.tranData = [{outDs:"materialsRateChart", _siq:"dashboard.scmDash.materialsRateChart"}];
    	
    	var sMap = {
            url: "${ctx}/biz/obj",
            data: FORM_SEARCH,
            success:function(data) {
            	
            	var beforeResultValue = 0;
            	$.each(data.materialsRateChart, function(i, val){
            		
            		var cnt = i + 1;
            		var cDataP = "";
            		var trendWeek = val.TREND_WEEK;
            		var resultValue = val.RESULT_VALUE;
            		var chartC = val.CHART_C;
            		
            		if(userLang == "ko"){
            			resultValue    = gfn_getNumberFmt(resultValue, 0, 'R', 'Y');       
                	}else if(userLang == "en" || userLang == "cn"){
                		resultValue    = gfn_getNumberFmt(resultValue, 1, 'R', 'Y');       
                	}
            		
            		if(i == 0){
            			$("#materialsRateH4").html("(W" + trendWeek + ")");
            		}
            		
            		if (i == 1 || i == 3){
            			
            			var tmpValue = beforeResultValue - resultValue; 
            			
            			if(tmpValue > 0){
            				cDataP = "+";	
            			}
            			$("#materialsRateChart_" + cnt).text(cDataP + tmpValue);
                		$("#materialsRateChart_" + cnt).parent().attr("class", "per_txt " + chartC);	
            		}else{
                		$("#materialsRateChart_" + cnt).text(resultValue);
                		$("#materialsRateChart_" + cnt).parent().attr("class", "per_txt " + chartC);	
            		}
            		
            		beforeResultValue = resultValue;
            	});
            }
        }
        gfn_service(sMap,"obj");
    }
    */
    
    function agingWipChartSearch(){
    	
    	FORM_SEARCH = {};
    	FORM_SEARCH.periodDate = $(':radio[name=periodDate]:checked').val();
    	FORM_SEARCH._mtd = "getList";
    	FORM_SEARCH.tranData = [{outDs:"agingWipChart", _siq:"dashboard.scmDash.agingWipChart"}];
    	
    	var sMap = {
            url: "${ctx}/biz/obj",
            data: FORM_SEARCH,
            success:function(data) {
            	
            	$.each(data.agingWipChart, function(i, val){
            		
            		var cDataP = "";
            		var chart1 = val.CHART_1;
            		var chart2 = val.CHART_2;
            		var chartC = val.CHART_C;
            		var chartCSub = val.CHART_C_SUB;
            		
            		if(userLang == "ko"){
            			chart1    = gfn_getNumberFmt(chart1 / unit, 0, 'R', 'Y');       
            			chart2    = gfn_getNumberFmt(chart2 / unit, 0, 'R', 'Y');
                	}else if(userLang == "en" || userLang == "cn"){
                		chart1    = gfn_getNumberFmt(chart1 / unit, 1, 'R', 'Y');       
            			chart2    = gfn_getNumberFmt(chart2 / unit, 1, 'R', 'Y');
                	}
            		
            		if (chart2 > 0){
            			cDataP = "+";
            		}
            		
           			$("#agingWipChart_1").text(chart1);
               		$("#agingWipChart_1").parent().attr("class","per_txt " + chartC);
               		$("#agingWipChart_2").text(cDataP + chart2);
               		$("#agingWipChart_2").parent().attr("class","per_txt1 " + chartCSub);
            	});
            }
        }
        gfn_service(sMap,"obj");
    	
    }
    
    
    function stockInWorkAgingScmActionToggle() {
    	  const action = $('#stockInWorkAgingScmAction');
    	  
    	  action.toggleClass('active')
   }
    
    

    function productInventoryScmActionToggle() {
          const action = $('#productInventoryScmAction');
          
          action.toggleClass('active')
   }
    
    
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
 
	function fn_chartContentInit(){
	      
        
	      /*
		0.  claimRateScm
		1.	defectiveRateScm
		2.	supplyCapacityIndexScm
		3.  productionAmount
		4.	productionComplianceRateScm
		5.	stockInWorkAgingScm
		6.	shipmentAmount
		7.	productInventoryScm
		8.	stockInWorkAmount

	      */
	      
	      
	      for(i=0;i<9;i++)
	      {
	          if(FORM_SEARCH.chartList[i].ID=="claimRateScm")                      FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_1.setContents([{ insert: '\n' }]):quill_1.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
	          else if(FORM_SEARCH.chartList[i].ID=="defectiveRateScm")             FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_2.setContents([{ insert: '\n' }]):quill_2.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
	          else if(FORM_SEARCH.chartList[i].ID=="supplyCapacityIndexScm")       FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_3.setContents([{ insert: '\n' }]):quill_3.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
	          else if(FORM_SEARCH.chartList[i].ID=="productionAmount")             FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_4.setContents([{ insert: '\n' }]):quill_4.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
	          else if(FORM_SEARCH.chartList[i].ID=="productionComplianceRateScm")  FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_5.setContents([{ insert: '\n' }]):quill_5.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));       
	          else if(FORM_SEARCH.chartList[i].ID=="stockInWorkAgingScm")          FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_6.setContents([{ insert: '\n' }]):quill_6.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));
	          else if(FORM_SEARCH.chartList[i].ID=="shipmentAmount")               FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_7.setContents([{ insert: '\n' }]):quill_7.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));
	          else if(FORM_SEARCH.chartList[i].ID=="productInventoryScm")          FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_8.setContents([{ insert: '\n' }]):quill_8.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));
	          else if(FORM_SEARCH.chartList[i].ID=="stockInWorkAmount")            FORM_SEARCH.chartList[i].CONTENT== undefined ? quill_9.setContents([{ insert: '\n' }]):quill_9.setContents(JSON.parse(FORM_SEARCH.chartList[i].CONTENT));
	                                      
	      }
	      
	      
	      
	  }
	
	
	function fn_get_shipmentAmtChartSelectBoxCode(){
		
        
        CODE_SEARCH = {};
        
        
        CODE_SEARCH.sql      = 'N';
        CODE_SEARCH._mtd     = "getList";
        CODE_SEARCH.tranData = [{outDs:"rtnList",_siq:"dashboard.scmDash.scmDashShipmentAmtChartSelectBoxCode"}
                                ,{outDs:"rtnListMonth",_siq:"dashboard.scmDash.scmDashShipmentAmtChartSelectBoxCodeMonth"}
           ];
       
        return new Promise(function(resolve,reject){    gfn_service({
            
            
            url    : GV_CONTEXT_PATH + "/biz/obj",
            data   : CODE_SEARCH,
            success: function(data) {
                 
                
            	   	   CODE_SEARCH.shipmentAmtChartSelectBoxCode = data.rtnList;
            	   	   CODE_SEARCH.shipmentAmtChartSelectBoxCodeMonth = data.rtnListMonth;
            	   	   
            	       resolve(CODE_SEARCH);
                           
            }  
            
        }, "obj")
     });
        
        
		
	}
	
	function prodAmtChartSEARCH()
	{
		   FORM_SEARCH = {};
	       
		   FORM_SEARCH.prodPart = $('#gubunProdAmtChart option:selected').val();
		   FORM_SEARCH.month    = $('#gubunProdAmtChartMonth option:selected').val();
		   FORM_SEARCH._mtd = "getList";
	        FORM_SEARCH.tranData = [
	        	 {outDs:"prodAmtChart", _siq:"dashboard.scmDash.prodAmtChart"}
	            ,{outDs:"prodAmtTotalChart", _siq:"dashboard.scmDash.prodAmtTotalChart"}
	        	];
	        var sMap = {
	            url: "${ctx}/biz/obj",
	            data: FORM_SEARCH,
	            success:function(data) {
	            	prodAmtChart = null;
	            	prodAmtTotalChart = null;
	            	prodAmtChart = data.prodAmtChart;                  //<!-- 생산 금액 -->                <!-- scmDash111  -->
	                prodAmtTotalChart = data.prodAmtTotalChart;         //<!-- 생산 금액 -->                <!-- scmDash111  -->    
		
	                
	                

	                //생산 금액           //<!-- 생산 금액 -->                <!-- scmDash111  -->    
	                var arrColor = ['#4F81BC', '#8DADD3', '#C0504E'];
	                var xCategory = [], yCategory = [], cData = [];
	                var preWeek = "";
	                var cIdx = -1, amt, tmpCdata = [];
	                var y = 0;
	                $.each(prodAmtChart, function(n,v) {
	                    if (!gfn_isNull(v.AMT)) {
	                        amt = v.AMT / unit;
	                        
	                        if(userLang == "ko"){
	                            amt = gfn_getNumberFmt(amt, 0, 'R');
	                            y = -55;
	                        }else if(userLang == "en" || userLang == "cn"){
	                            amt = gfn_getNumberFmt(amt, 1, 'R');
	                            y = -115;
	                        }
	                        
	                    } else {
	                        amt = null;
	                    }
	                    tmpCdata.push({y:amt, color: arrColor[n%3]});
	                    
	                    //3의 배수
	                    if (Math.ceil((n+1) % 3) == 0) {
	                        cData.push({name: v.YEARWEEK, data: tmpCdata}); 
	                        tmpCdata = [];
	                    }
	                    
	                    if (n < 3) {
	                        yCategory.push(v.MEAS_NM);
	                    }
	                });
	                
	                Highcharts.chart('prodAmtChart', {
	                    chart: {
	                        type: 'bar'
	                    },
	                    xAxis: {
	                        categories: yCategory
	                    },
	                    yAxis: {
	                        labels : { enabled : true}, 
	                        min: 0,
	                        stackLabels : {
	                            enabled : true,
	                            style   : {
	                                fontWeight:'bold',
	                                fontSize:"15px"
	                            },
	                            //y : y,
	                            formatter : function() {
	                                var x = this.x;
	                                
	                                var sum = prodAmtTotalChart[x].TOTAL_AMT / unit;

	                                if(userLang == "ko"){
	                                    sum = gfn_getNumberFmt(sum, 0,'R');
	                                }else if(userLang == "en" || userLang == "cn"){
	                                    sum = gfn_getNumberFmt(sum, 1,'R');
	                                }
	                                
	                                return sum;
	                            }
	                        }
	                    },
	                    legend: {
	                        reversed: true
	                    },
	                    exporting : {
	                        enabled: false,
	                    },
	                    tooltip : {
	                        enabled : false
	                    },
	                    plotOptions: {
	                        bar: {
	                            dataLabels: {
	                                format: '{'+format+'}<spring:message code="lbl.billion"/>',
	                                style : {
	                                    fontSize : "12px",
	                                    fontWeight: ''
	                                }
	                            }
	                        }
	                    },
	                    series: cData
	                });
	                
	                
	            }
	        }
	       
	        
	        
	        gfn_service(sMap,"obj");
		
        
	}
	
	function shipmentAmtChartSEARCH(){
		
		  FORM_SEARCH = {};
          
          FORM_SEARCH.prodPart = $('#gubunShipmentAmtChart option:selected').val();
          FORM_SEARCH.month = $('#gubunShipmentAmtChartMonth option:selected').val();
           FORM_SEARCH._mtd = "getList";
           FORM_SEARCH.tranData = [
                {outDs:"shipmentAmtChart", _siq:"dashboard.scmDash.shipmentAmtChart"}
               ,{outDs:"shipmentAmtTotalChart", _siq:"dashboard.scmDash.shipmentAmtTotalChart"}
               ];
           
           var sMap = {
               url: "${ctx}/biz/obj",
               data: FORM_SEARCH,
               success:function(data) {
                   shipmentAmtChart = null;
            	   shipmentAmtTotalChart = null;
                   shipmentAmtChart = data.shipmentAmtChart;                  //<!-- 생산 금액 -->                <!-- scmDash111  -->
                   shipmentAmtTotalChart = data.shipmentAmtTotalChart;         //<!-- 생산 금액 -->                <!-- scmDash111  -->    
       
                   

                   var preWeek = "";
                   var xCategory = [], yCategory = [], cData = [];
                   var cIdx = -1, amt, tmpCdata = [];
                   var arrColor = ['#4F81BC', '#8DADD3', '#C0504E'];
                   var y = 0;
                   
                   $.each(shipmentAmtChart, function(n,v) {
                       
                       if (!gfn_isNull(v.AMT)) {
                           amt = v.AMT / unit;

                           if(userLang == "ko"){
                               amt = gfn_getNumberFmt(amt, 0, 'R');
                               y = -55;
                           }else if(userLang == "en" || userLang == "cn"){
                               amt = gfn_getNumberFmt(amt, 1, 'R');
                               y = -115;
                           }
                       } else {
                           amt = null;
                       }
                       tmpCdata.push({y:amt, color: arrColor[n%3]});
                       
                       //3의 배수
                       if (Math.ceil((n+1) % 3) == 0) {
                           cData.push({name: v.YEARWEEK, data: tmpCdata}); 
                           tmpCdata = [];
                       }
                       
                       if (n < 3) {
                           yCategory.push(v.MEAS_NM);
                       }
                   });
                   
                   Highcharts.chart('shipmentAmtChart', {
                       chart: {
                           type: 'bar'
                       },
                       xAxis: {
                           categories: yCategory
                       },
                       yAxis: {
                           labels : { enabled : true}, 
                           min: 0,
                           stackLabels : {
                               enabled : true,
                               style   : {
                                   fontWeight:'bold',
                                   fontSize:"15px"
                               },
                               formatter : function() {
                                   var x = this.x;
                                   
                                   var sum = shipmentAmtTotalChart[x].TOTAL_AMT / unit;

                                   if(userLang == "ko"){
                                       sum = gfn_getNumberFmt(sum, 0, 'R');
                                   }else if(userLang == "en" || userLang == "cn"){
                                       sum = gfn_getNumberFmt(sum, 1, 'R');
                                   }
                                   
                                   return sum;
                               }
                           }
                       },
                       legend: {
                           reversed: true
                       },
                       exporting : {
                           enabled: false,
                       },
                       tooltip : {
                           enabled : false
                       },
                       plotOptions: {
                           bar: {
                               dataLabels: {
                                   format: '{'+format+'}<spring:message code="lbl.billion"/>',
                                   style : {
                                       fontSize : "12px",
                                       fontWeight: ''
                                   }
                               }
                           }
                       },
                       series: cData
                   });
                   
                   
                   
                   
               }
           }
           
           gfn_service(sMap,"obj");
		
    
           
           
		
	}
	
	
	
    </script>

</head>
<body id="framesb" class="portalFrame">
	<jsp:include page="/WEB-INF/view/layout/commonForm.jsp" flush="false">
		<jsp:param name="siteMapYn" value="Y"/>
	</jsp:include>
	
	<!-- contents -->
	<div id="grid1" class="fconbox">
		<%@ include file="/WEB-INF/view/common/commonLocation.jsp" %>
		
		<div class="scroll" style="height:calc(100% - 35px)">
			<!-- 대쉬보드 화면 시작 -->
	        <div id="container" style="float: left">
		  		<div id="cont_chart">
		  		  	<!-- Claim Rate(연간) -->    <!-- scmDash111  -->
		  		  	<div class="col_3">
	        			<div class="titleContainer">
	                		<!-- style="  left: calc(50% - 57px);" -->
	                		<h4 id="claimRateScmH4"><spring:message code="lbl.claimChart"/> (<spring:message code="lbl.yearChart2"/>)</h4>
	                	    <div class="view_combo">
                             <ul class="rdofl">
                                 <li class="manuel">
                                    <a href="#" id="claimRateScm"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                 </li>
                             </ul>
                            </div>
	                	</div>
	                	
	                	<div class="datawrap" id="claimRateScmDatawrap">
	                		<p class="per_txt green_f"><strong id="claimChart_1">0</strong>  ppm</p>
	                    	<p class="per_txt1" id="claimChart_2"></p><p class="per_txt2">(<spring:message code="lbl.thisMonth"/>)</p>
	                    	<p class="per_txt1" id="claimChart_3"></p><p class="per_txt2">(<spring:message code="lbl.thisyear"/>)</p>
	                    </div>
	                    <div class="modal" id="claimRateScmContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-1"></div>
                           </div>
                        </div>
                       
	              	</div>
	              	<!-- 불량률 --><!-- scmDash111  -->
	              	<div class="col_3">
	                	<div class="titleContainer">
	                		<!-- style="  left: calc(50% - 61px);" -->
	                		<h4  id="defectiveRateScmH4"><spring:message code="lbl.defectRateChart2"/> (%, <spring:message code="lbl.prodPart3"/>)</h4>
	                	    <div class="view_combo">
	                             <ul class="rdofl">
	                             
	                                 <li class="manuel">
	                                    <a href="#" id="defectiveRateScm"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
	                                 </li>
	                             
	                             </ul>
                            </div>
	                	</div>
	                	<div id="defectivesChart" style="height:100%;width:100%;"></div>
	           		    <div class="modal" id="defectiveRateScmContent" style="display:none;">
                           <div class="modal_header"></div>
                           <div class="modal_content">
                               <div id="editor-2"></div>
                           </div>
                        </div>
	           		</div>
	             	<!-- 공급능력지수 -->			<!-- scmDash111  -->
	             	<div class="col_3">	
	                		<div class="titleContainer">
	                			<!-- style="  left: calc(50% - 60px);" -->
	                			<h4  id="supplyCapacityIndexScmH4"><spring:message code="lbl.supplyCapacityRate"/><span class="supplyCapacityIndexPweekTxt"></h4>
		                	    <div class="view_combo">
                                 <ul class="rdofl">
                                 
                                     <li class="manuel">
                                        <a href="#" id="supplyCapacityIndexScm"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                     </li>
                                 
                                 </ul>
                                </div>
		                	</div>
	                		
	                		<div class="datawrap" id="supplyCapacityIndexScmDatawrap">
		                		<p class="per_txt green_f"><strong id="chart3_2_1">0</strong> %</p>
			                    <p class="per_txt1"><spring:message code="lbl.lastWeek"/>&nbsp;<span class="per_txt1" id="chart3_2_2">0</span>%</p>
		                	</div>
		                	<div class="modal" id="supplyCapacityIndexScmContent" style="display:none;">
	                           <div class="modal_header"></div>
	                           <div class="modal_content">
	                               <div id="editor-3"></div>
	                           </div>
                            </div>
	              	</div>
	              	<!-- 생산 금액 -->				<!-- scmDash111  -->
	             	<div class="col_3">
	            	 	<div class="titleContainer">
	            	 		<!-- style="  left: calc(50% - 49px);" -->
	            	 		<h4  id="productionAmountH4"><spring:message code="lbl.prodAmt"/><span class="cweekTxt" id="cweekTxtProd"></h4>
	            	 	    
            	 	       
                           
	            	 	    <div class="view_combo" >
                                 
                                 <ul class="rdofl">
                                 
                                     <li class="manuel">
                                        <a href="#" id="productionAmount"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                     </li>
                                 
                                 </ul>
                            </div>
                             <div class="view_combo" id="divGubunProdAmtChart" style="width:70px;padding-right:5px;">
                            </div>
                             <div class="view_combo" id="divGubunProdAmtChartMonth" style="width:50px;padding-right:5px;">
                            </div>
                            
                           
	            	 	</div>
            	 	  	<div id="prodAmtChart" style="height:100%;width:100%;"></div>
            	 	  	<div class="modal" id="productionAmountContent" style="display:none;">
                               <div class="modal_header"></div>
                               <div class="modal_content">
                                   <div id="editor-4"></div>
                               </div>
                        </div>
	          		</div>
		          	<!-- 생산 준수율 -->			<!-- scmDash111  -->
		          	<div class="col_3">
		                	<div class="titleContainer">
		                		<!-- style="  left: calc(50% - 55px);" -->
		                		<h4  id="productionComplianceRateScmH4"><spring:message code="lbl.prodCmplRateChart1"/><span class="pweekTxt"></h4>
		                	    <div class="view_combo">
                                 <ul class="rdofl">
                                 
                                     <li class="manuel">
                                        <a href="#" id="productionComplianceRateScm"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                     </li>
                                 
                                 </ul>
                                </div>
		                	</div>
		                	
		                	<div class="datawrap" id="productionComplianceRateScmDatawrap">
		                		<p class="per_txt green_f"><strong id="chart3_6_1">0</strong> %</p>
		                    	<p class="per_txt1"><spring:message code="lbl.lastWeek"/>&nbsp;<span class="per_txt1" id="chart3_6_2">0</span>%</p>
		                	</div>
		                	<div class="modal" id="productionComplianceRateScmContent" style="display:none;">
                               <div class="modal_header"></div>
                               <div class="modal_content">
                                   <div id="editor-5"></div>
                               </div>
                            </div>
		                	
		        	</div>
		          	<!-- 재공 Again -->			<!-- scmDash111  -->
		          	<div class="col_3">
		                	  <div class="titleContainer">
		                	  <!-- style="  left: calc(50% - 34px);" -->
		                		<h4 id="stockInWorkAgingScmH4"><spring:message code="lbl.trend22Chart"/> </h4>
				                <div class="view_combo"> <!-- class="action" id="stockInWorkAgingScmAction" -->
									  <!--  <span>+</span>-->
									  <ul class="rdofl" ><!-- style="float: right;height:100px;" -->
                                                <li><input type="radio"  id="periodDate1" name="periodDate" value="m2" checked="checked"/> <label for="periodDate1"><spring:message code="lbl.2mMore" /></label></li>
                                                <li><input type="radio" id="periodDate2" name="periodDate" value="m6" /> <label for="periodDate2"><spring:message code="lbl.6mMore" /> </label></li>
                                                <li><input type="radio" id="periodDate3" name="periodDate" value="m12"/> <label for="periodDate3"><spring:message code="lbl.yearOneMore" /> </label></li>
                                                <li class="manuel"><a href="#" id="stockInWorkAgingScm"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a></li>
                                      </ul>
				                </div>
				               
		                	  </div>
		                	  	
                              
			                  <div class="datawrap" id="stockInWorkAgingScmDatawrap">
			                		<p class="per_txt green_f"><strong id="agingWipChart_1">0</strong> <spring:message code="lbl.billion"/></p>
			                    	<p class="per_txt1"><spring:message code="lbl.lastWeek"/>&nbsp;<span class="per_txt1" id="agingWipChart_2">0</span><spring:message code="lbl.billion"/></p>
			                  </div>
			                  <div class="modal" id="stockInWorkAgingScmContent" style="display:none;">
	                               <div class="modal_header"></div>
	                               <div class="modal_content">
	                                   <div id="editor-6"></div>
	                               </div>
                              </div>
		            </div>
		        	<div class="col_3">
	            		<!-- 출하 금액  -->				<!-- scmDash111  -->
	            		<div class="titleContainer">
	            			<!-- style="  left: calc(50% - 49px);" -->
	            			<h4  id="shipmentAmountH4"><spring:message code="lbl.salesAmt"/><span class="cweekTxt" id="cweekTxtSales"></h4>
	            		    <div class="view_combo">
                                 <ul class="rdofl">
                                 
                                     <li class="manuel">
                                        <a href="#" id="shipmentAmount"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                     </li>
                                 
                                 </ul>
                            </div>
                            <div class="view_combo" id="divGubunShipmentAmtChart" style="width:67px;padding-right:5px;">
                            </div>
                            <div class="view_combo" id="divGubunShipmentAmtChartMonth" style="width:50px;padding-right:5px;">
                            </div>
                            
	            		</div>
	            		
		               	<div id="shipmentAmtChart" style="height:100%;width:100%;"></div>
		                <div class="modal" id="shipmentAmountContent" style="display:none;">
                                   <div class="modal_header"></div>
                                   <div class="modal_content">
                                       <div id="editor-7"></div>
                                   </div>
                        </div>
		            </div>
	              	<div class="col_3">
	            		<!-- 제품 재고 -->				<!-- scmDash111  -->
	                	<div class="titleContainer">
	                		<!-- style="  left: calc(50% - 27px);" -->
	                		<h4  id="productInventoryScmH4"><spring:message code="lbl.prodInv"/></h4>
			                <div class="view_combo"> <!-- class="action" id="productInventoryScmAction" -->
                                   <!-- <span>+</span> -->
			                	    <ul class="rdofl" > <!-- style="float: right;height:80px;" -->
		                                    <li><input type="radio" id="companyCons1" name="companyCons" value="companyCons" /> <label for="companyCons1"><spring:message code="lbl.companyCons" /></label></li>
		                                    <li><input type="radio" id="companyCons2" name="companyCons" value="company" checked="checked"/> <label for="companyCons2"><spring:message code="lbl.company2" /> </label></li>
		                                    <li class="manuel">
		                                        <a href="#" id="productInventoryScm"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
		                                    </li>
		                            </ul>
		                    </div>
	                	</div>
	                	
                	 	<div class="datawrap" id="productInventoryScmDatawrap">
	                		<p class="per_txt green_f"><strong id="companyConsChart_1">0</strong> <spring:message code="lbl.billion"/></p>
	                    	<p class="per_txt1"><spring:message code="lbl.lastWeek"/>&nbsp;<span class="per_txt1" id="companyConsChart_2">0</span><spring:message code="lbl.billion"/></p>
                    	</div>
                    	<div class="modal" id="productInventoryScmContent" style="display:none;">
                                   <div class="modal_header"></div>
                                   <div class="modal_content">
                                       <div id="editor-8"></div>
                                   </div>
                        </div>
	              	</div>
	              	<div class="col_3">
		                <!-- 재공 금액 -->				<!-- scmDash111  -->
		                	<div class="titleContainer">
		                	    <!-- style="  left: calc(50% - 47px);" -->
		                		<h4  id="stockInWorkAmountH4"><spring:message code="lbl.wipAmt"/> (<spring:message code="lbl.prevDayChart"/>)</h4>
		                	    <div class="view_combo">
                                 <ul class="rdofl">
                                     <li class="manuel">
                                        <a href="#" id="stockInWorkAmount"><img src="${ctx}/statics/images/common/google-docs.png" alt="Menual" title='<spring:message code="lbl.description2"/>'/></a>
                                     </li>
                                 </ul>
                                </div>
		                	</div>
		                	
		                	<div class="datawrap" id="stockInWorkAmountDatawrap">
		                		
		                		<p class="per_txt green_f"><strong id="chart3_7_1">0</strong> <spring:message code="lbl.billion"/></p>
		                    	<p class="per_txt1"><spring:message code="lbl.lastWeek"/>&nbsp;<span class="per_txt1" id="chart3_7_2">0</span><spring:message code="lbl.billion"/></p>
		                	</div>
		                	<div class="modal" id="stockInWorkAmountContent" style="display:none;">
                                   <div class="modal_header"></div>
                                   <div class="modal_content">
                                       <div id="editor-9"></div>
                                   </div>
                            </div>
		         	</div>
		    	</div>
			</div>
	        <!-- 대쉬보드 화면 끝 -->
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
