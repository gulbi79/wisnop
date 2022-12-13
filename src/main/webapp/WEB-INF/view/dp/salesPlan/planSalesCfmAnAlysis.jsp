<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	<!-- 실행계획달성율 -->
	<script type="text/javascript">

	var arrExtCol;
	var enterSearchFlag = "Y";
	var planSalesCfmAnAlysis = {

		init : function () {
			
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.grid.initGrid();
		},
			
		_siq : "dp.salesPlan.planSalesCfmAnAlysisList",
		
		initFilter : function() {
			
	    	//품목대그룹
			var upperItemEvent = {
				childId   : ["itemGroup"],
				childData : [this.comCode.codeMapEx.ITEM_GROUP],
			};
			
			// 키워드팝업
			gfn_keyPopAddEvent([
				{target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>'}
			]);
			
			// 콤보박스
			gfn_setMsComboAll([
				{ target : 'divPlanId', id : 'planId', title : '<spring:message code="lbl.planId2"/>', data : this.comCode.codeMap.PLAN_ID, exData:[''], type : "S" },
				{target : 'divProcurType',   id : 'procurType',    title : '<spring:message code="lbl.procure"/>',        data : this.comCode.codeMap.PROCUR_TYPE, exData:[""]},
				{target : 'divUpItemGroup',  id : 'upItemGroup',   title : '<spring:message code="lbl.upperItemGroup"/>', data : this.comCode.codeMapEx.UPPER_ITEM_GROUP, exData:["*"], event: upperItemEvent },
				{target : 'divItemGroup', id : 'itemGroup', title : '<spring:message code="lbl.itemGroup"/>', data : this.comCode.codeMapEx.ITEM_GROUP, exData:["*"]},
				{target : 'divRoute', id : 'route', title : '<spring:message code="lbl.routing"/>', data : this.comCode.codeMapEx.ROUTING, exData:["*"]},
				{target : 'divRepCustGroup', id : 'reptCustGroup', title : '<spring:message code="lbl.reptCustGroup"/>', data : this.comCode.codeMapEx.REP_CUST_GROUP, exData:["*"]},
				{target : 'divCustGroup', id : 'custGroup', title : '<spring:message code="lbl.custGroup"/>', data : this.comCode.codeMapEx.CUST_GROUP, exData:["*"]},
			]);
		},
		
		/*
		* common Code 
		*/
		comCode : {
			codeMapEx : null,
			codeMap : null,
			
			initCode  : function () {
				var grpCd = 'SALE_QA_TYPE,PROCUR_TYPE';
				this.codeMap = gfn_getComCode(grpCd, 'Y'); //공통코드 조회
				this.codeMapEx = gfn_getComCodeEx(["REP_CUST_GROUP", "CUST_GROUP", "UPPER_ITEM_GROUP", "ITEM_GROUP", "ROUTING"], null, {itemType : "10,50"});
				
				gfn_service({
					async   : false,
					url     : GV_CONTEXT_PATH + "/biz/obj",
					data    : {_mtd : "getList", tranData:[
						{outDs : "planList", _siq : planSalesCfmAnAlysis._siq + "PlanId"},
					]},
					success : function(data) {
						planSalesCfmAnAlysis.comCode.codeMap.PLAN_ID = data.planList;
					}
				}, "obj");
			}
		},
	
		/* 
		* grid  선언
		*/
		grid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				
				gfn_setMonthSum(planSalesCfmAnAlysis.grid.gridInstance, false, false, true);
				
				this.grdMain.onShowHeaderTooltip = function (grid, column, value) {
					
					var result = value;
		    		var fname = gfn_nvl(column.fieldName, column.name);
		    		var arrWeek = $("#planId").val().split("_");
		    		
		    		var nextWeek = parseInt(arrWeek[0].substring(4,6))+1;
		    		var week = nextWeek>9? String(nextWeek)+'W':'0'+String(nextWeek)+'W';
		    		
		    		if(fname.indexOf("INV_QTY") == 0){
		    			result = '<spring:message code="lbl.invQty3"/>';
		    		}else if(fname.indexOf("SALES_REMAIN_QTY") == 0){
		    			result = '<spring:message code="lbl.salesRemainQty"/>';	
		    		}else if(fname.indexOf("PROD_REMAIN_QTY") == 0){
		    			result = '<spring:message code="lbl.prodRemainQty"/>';
		    		}else if(fname.indexOf("AP2_SP") == 0){
		    			result = '<spring:message code="lbl.ap2Sp3"/>';	
		    		}else if(fname.indexOf("CFM_SP") == 0){
		    			result = '<spring:message code="lbl.cfmSp2"/>';
		    		}else if(fname.indexOf("CALC_BOH_QTY") == 0){
		    			result = '<spring:message code="lbl.calcBohQty"/>';	
		    		}else if(fname.indexOf("INV_SALES_QTY") == 0){
		    			result = '<spring:message code="lbl.invSalesQty2"/>';
		    		}else if(fname.indexOf("PROD_NEED_QTY") == 0){
		    			result = '<spring:message code="lbl.prodNeedQty2"/>';
		    		}else if(fname.indexOf("PROD_QTY2") == 0){
		    			result = '<spring:message code="lbl.prodQty2"/>';
		    		}else if(fname.indexOf("AVAIL_QTY") == 0){
		    			result = '<spring:message code="lbl.availQty3"/>';
		    		}else if(fname.indexOf("AVAIL_CFM_SP") == 0){
		    			result = '<spring:message code="lbl.AvailCfmSp"/>';
		    		}else if(fname.indexOf("PROD_PLAN_QTY2") == 0){
		    			result = '<spring:message code="lbl.prodPlanQty4"/>';		
		    		}else if(fname.indexOf("NO_PROD_QTY") == 0){
		    			result = '<spring:message code="lbl.noProdQty"/>';	
		    		}else if(fname.indexOf("PRE_PROD_QTY_CPFR") == 0){
		    			result = '<spring:message code="lbl.preProdQty2"/>';
		    		}else if(fname.indexOf("PRE_PROD_QTY") == 0){
		    			result = '<spring:message code="lbl.preProdQty2"/>';
		    		}else if(fname.indexOf("NO_AVA_QTY_ADD_CONFIRM") == 0){
		    			result = '<spring:message code="lbl.noAvaQtyAddConfirm"/>';	
		    		}else if(fname.indexOf("AVA_QTY_ADD_CONFIRM") == 0){
		    			result = '<spring:message code="lbl.avaQtyAddConfirm"/>';
		    		}
		    		if(fname.indexOf("INV_QTY_SUN_QTY")==0){
                        result = week+' 일요일 새벽 당사 재고';
                    }
		    		if(fname.indexOf("INV_QTY_SUN_QTY_MINUS_CALC_BOH_QTY")==0){
                        result = week+' 주초재고 - 예상주초재고';
                    }
		    		return result;
				}	
			}
		},
	
		/*
		* event 정의
		*/
		events : function () {
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("#sQty,#sAmt").on("click", function(e) {
				fn_gridCtrl(this, arrExtCol);
			});
			
			$("#btnSummary").on("click", function() {
				FORM_SEARCH = $("#searchForm").serializeObject();
				
				gfn_comPopupOpen("ANALYSIS_DETAIL", {
					rootUrl : "dp/salesPlan",
					url     : "planSalesCfmAnAlysisDetail",
					width   : 1200,
					height  : 680,
					planId  : $("#planId").val(),
					menuCd  : "DP22001",
					popupTitle : '<spring:message code="lbl.anaylsisSummary"/>'
				});
			});
			
			$("#btnChart").on("click", function() {
				
				gfn_comPopupOpen("POPUP_CHART", {
					rootUrl   : "dp/salesPlan",
					url       : "planSalesCfmAnAlysisChart",
					width     : 1600,
					height    : 1000,
					planId    : $("#planId").val(),
					popupTitle : '<spring:message code="lbl.analysisChart"/>'
				});	
			});
		},
		
		excelSubSearch : function (){
			
			EXCEL_SEARCH_DATA = "";
			EXCEL_SEARCH_DATA += "Product" + " : ";
			EXCEL_SEARCH_DATA += $("#loc_product").html();
			EXCEL_SEARCH_DATA += "\nSalesOrg" + " : ";
			EXCEL_SEARCH_DATA += $("#loc_salesOrg").html();
			
			$.each($(".view_combo"), function(i, val){
				
				var temp = "";
				var id = gfn_nvl($(this).attr("id"), "");
				
				if(id != ""){
					
					var name = gfn_nvl($("#" + id + " .ilist .itit").html(), "");
					
					if(name == ""){
						name = $("#" + id + " .filter_tit").html();
					}
					
					EXCEL_SEARCH_DATA += "\n" + name + " : ";	
					
					//데이터
					if(id == "divItem"){
						EXCEL_SEARCH_DATA += $("#item_nm").val();
					}else if(id == "divProcurType"){
						$.each($("#procurType option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divUpItemGroup"){
						$.each($("#upItemGroup option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divItemGroup"){
						$.each($("#itemGroup option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divRoute"){
						$.each($("#route option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divRepCustGroup"){
						$.each($("#reptCustGroup option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divCustGroup"){
						$.each($("#custGroup option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divPlanId"){
						EXCEL_SEARCH_DATA += $("#planId option:selected").text();
					}else if(id == "divQtyAmtGubun"){
						
						var sQty = $('input[name="sQty"]:checked').val();
						var sAmt = $('input[name="sAmt"]:checked').val();
						
						if(sQty == "on" && sAmt == "on"){
							EXCEL_SEARCH_DATA += '<spring:message code="lbl.qty"/>' + ", " + '<spring:message code="lbl.amt"/>';
						}else if(sQty == "on"){
							EXCEL_SEARCH_DATA += '<spring:message code="lbl.qty"/>';
						}else if(sAmt == "on"){
							EXCEL_SEARCH_DATA += '<spring:message code="lbl.amt"/>';
						}
					}
				}
			});
		},
		
		// 조회
		search : function () {
			
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq }];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						planSalesCfmAnAlysis.grid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						planSalesCfmAnAlysis.grid.grdMain.cancel();
						
						planSalesCfmAnAlysis.grid.dataProvider.setRows(data.resList);
						planSalesCfmAnAlysis.grid.dataProvider.clearSavePoints();
						planSalesCfmAnAlysis.grid.dataProvider.savePoint(); //초기화 포인트 저장
						//gfn_setSearchRow(planSalesCfmAnAlysis.grid.dataProvider.getRowCount());
						gfn_actionMonthSum(planSalesCfmAnAlysis.grid.gridInstance);
						gfn_setRowTotalFixed(planSalesCfmAnAlysis.grid.grdMain);
						
						arrExtCol = [];
						
						$.each(BUCKET.all[0], function(i, val){
							arrExtCol.push(val.CD);
						});
						
						var headerHeight = planSalesCfmAnAlysis.grid.grdMain.getHeader().height  // 헤더 높이
				        
				        if(headerHeight < 50){
				            planSalesCfmAnAlysis.grid.grdMain.setHeader(
				                {height : headerHeight + 35} // 헤더 높이 +10
				            );  
				        }
						
						$.each($("#sQty,#sAmt"), function(n, v) {
							if ($(v).is(":checked")) return true;
							fn_gridCtrl(v, arrExtCol);
						});
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		getBucket : function (sqlFlag) {
			
			var ajaxMap = {
				menuCd : $("#menuCd").val(),
				sqlId : ["dp.salesPlan.planSalesCfmAnAlysisListBucket"]
			}
			
			gfn_getBucket(ajaxMap);
			
		 	var subBucket = new Array();
			
			subBucket = [
				{CD : "SQTY", NM : '<spring:message code="lbl.qty"/>'},
				{CD : "SAMT", NM : '<spring:message code="lbl.amt"/>'},
			];
			gfn_setCustBucket_customized(subBucket);
			
			if(!sqlFlag){
				
				planSalesCfmAnAlysis.grid.gridInstance.setDraw();
				
				var fileds = planSalesCfmAnAlysis.grid.dataProvider.getFields();
				var filedsLen = fileds.length;
				
				for (var i = 0; i < filedsLen; i++) {
					
					var fieldName = fileds[i].fieldName;
					
					if(fieldName == "SALES_PRICE_KRW_NM"){
						fileds[i].dataType = "number";
						planSalesCfmAnAlysis.grid.grdMain.setColumnProperty(fieldName, "styles", {"numberFormat" : "#,##0"});
					}
					
					if(fieldName == "INV_QTY_SQTY" || fieldName == "SALES_REMAIN_QTY_SQTY" || fieldName == "PROD_REMAIN_QTY_SQTY"){
						
						var weekName = gfn_replaceAll(fieldName, "_SQTY", "");
						var headerName = gfn_nvl(planSalesCfmAnAlysis.grid.grdMain.getColumnProperty(weekName, "header"), "")
						var tText = headerName.text;
						var week = gfn_replaceAll($("#planId").val(), "_", "").substring(4, 7);
						
						planSalesCfmAnAlysis.grid.grdMain.setColumnProperty(weekName, "header", week + " " + tText);
					}
					
					
				    if(fieldName =="INV_QTY_SUN_QTY_SQTY"|| fieldName =="INV_QTY_SUN_QTY_MINUS_CALC_BOH_QTY_SQTY"){
                        
                        var weekName = gfn_replaceAll(fieldName, "_SQTY", "");
                        var headerName = gfn_nvl(planSalesCfmAnAlysis.grid.grdMain.getColumnProperty(weekName, "header"), "")
                        var tText = headerName.text;
                        var arrWeek = $("#planId").val().split("_");
                    
                        var nextWeek = parseInt(arrWeek[0].substring(4,6))+1;
                        var week = nextWeek>9? String(nextWeek)+'W':'0'+String(nextWeek)+'W';
                        planSalesCfmAnAlysis.grid.grdMain.setColumnProperty(weekName, "header", week + " " + tText);
                    }
					
					/*
					if(fieldName="INV_QTY_SUN_QTY_MINUS_CALC_BOH_QTY_SQTY")
                    {
                        var weekName = gfn_replaceAll(fieldName, "_SQTY", ""); 
                        planSalesCfmAnAlysis.grid.grdMain.setColumnProperty(weekName, "width",85);
                    }
					*/
				}
				planSalesCfmAnAlysis.grid.dataProvider.setFields(fileds);
			}
		}
	};

	//조회
	var fn_apply = function (sqlFlag) {
		// 디멘젼, 메져
		gfn_getMenuInit("Y", "");
		
		planSalesCfmAnAlysis.getBucket(sqlFlag); //2. 버켓정보 조회
    	
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
    	FORM_SEARCH.hrcyFlag   = true;
   		FORM_SEARCH.dimList    = DIMENSION.user;
   		FORM_SEARCH.bucketList = BUCKET.query;
   		
		planSalesCfmAnAlysis.search();
		
	}
	
	//그리드 컨트롤
    function fn_gridCtrl(obj, arrExt) {
    	var tObjColNm = $(obj).attr("val");
    	
    	
		
    	var grid = planSalesCfmAnAlysis.grid.grdMain;
		
    	var columnNames = grid.getColumnNames(true);
		
    	
		
    	var visi = $(obj).is(":checked");
		
    	columnNames = $.grep(columnNames, function(v, n) {
			return v.indexOf(tObjColNm) > -1 && $.inArray(v, arrExt) == -1;
		});
		
    	gfn_gridCtrl_customized(grid, columnNames, visi);
		
    	planSalesCfmAnAlysis.excelSubSearch();
		
		var headerHeight = planSalesCfmAnAlysis.grid.grdMain.getHeader().height  // 헤더 높이
		
		if(headerHeight < 50){
			planSalesCfmAnAlysis.grid.grdMain.setHeader(
				{height : headerHeight + 35} // 헤더 높이 +10
			);	
		}
    }

  //그리드 컬럼중 배열로 받은 컬럼을 visible 처리
    function gfn_gridCtrl_customized(grid,arrColumn,visi) {
        var orgW,pColW,chnW;
        var arrParent = [];
        $.each(arrColumn, function(n,v) {
            
            arrParent = gfn_getArrParent(grid,v);
            
            orgW      = grid.getColumnProperty(v, "width"); //자식 컬럼 길이 call
            
            grid.setColumnProperty(v, "visible", visi);     //자식 컬럼 visible 세팅
            
            $.each(arrParent, function(nn,vv) {
            
            	pColW = grid.getColumnProperty(vv, "width");//부모 컬럼 길이 call
        		chnW  = pColW + (orgW * (visi ? 1 : -1));
                grid.setColumnProperty(vv, "width", chnW);  //부모 컬럼 길이 세팅      
             
            });
        });
        
    }
	
	
	
    //버켓에 사용자 버켓을 추가한다.
    function gfn_setCustBucket_customized(pBucketObj) {
        var custBucket = BUCKET.last;
        
        var userBucket = pBucketObj;
        var objLastBucket = [];
        gfn_clearArrayObject(BUCKET.query);
        var tmpObj;
        $.each(custBucket, function(n,v) {
            if (v.TYPE == "group") {
                $.each(userBucket, function(nn,vv) {
                		tmpObj = {ROOT_CD: v.CD, CD: v.CD+"_"+vv.CD, NM: vv.NM, BUCKET_ID: v.CD+"_"+vv.CD, BUCKET_VAL: v.BUCKET_VAL, TYPE: vv.TYPE, numberFormat: vv.numberFormat};
                        objLastBucket.push(tmpObj);
                        BUCKET.query.push(tmpObj);
                });
            }
        });
        BUCKET.push(objLastBucket);
    }
	
	// onload 
	$(document).ready(function() {
		planSalesCfmAnAlysis.init();
	});
	
	</script>

</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp"%>
	<!-- left -->
	<div id="a" class="split split-horizontal">
		<!-- tree -->
		<div id="c" class="split content">
			<%@ include file="/WEB-INF/view/common/leftTree.jsp"%>
		</div>
		<!-- filter -->
		<div id="d" class="split content">
			<form id="searchForm" name="searchForm">
				<div id="filterDv">
					<div class="inner">
						<h3>Filter</h3>
						<%-- <%@ include file="/WEB-INF/view/common/filterMonthSum.jsp"%> --%>
						<div class="tabMargin"></div>
						<div class="scroll">
							<div class="view_combo" id="divItem"></div>
							<div class="view_combo" id="divProcurType"></div>
							<div class="view_combo" id="divUpItemGroup"></div>
							<div class="view_combo" id="divItemGroup"></div>
							<div class="view_combo" id="divRoute"></div>
							<div class="view_combo" id="divRepCustGroup"></div>
							<div class="view_combo" id="divCustGroup"></div>
							<div class="view_combo" id="divPlanId"></div>
							<div class="view_combo" id="divQtyAmtGubun">
								<strong class="filter_tit"><spring:message code="lbl.qtyAmtGubun"/></strong>
								<ul class="rdofl">
									<li><input type="checkbox" id="sQty" name="sQty" val="_SQTY"/><label for="sQty"><spring:message code="lbl.qty"/></label></li>
									<li><input type="checkbox" id="sAmt" name="sAmt" val="_SAMT" checked="checked"/><label for="sAmt"><spring:message code="lbl.amt"/></label></li>
								</ul>
							</div>
						</div>
						<div class="bt_btn">
							<a href="javascript:;" class="fl_app" id="btnSearch"><spring:message code="lbl.search" /></a>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
	<!-- contents -->
	<div id="b" class="split split-horizontal">
		<div id="grid1" class="fconbox">
			<%@ include file="/WEB-INF/view/common/commonLocation.jsp"%>
			<div class="scroll">
				<!-- 그리드영역 -->
				<div id="realgrid" class="realgrid1"></div>
				<div id="realgridExcel" class="realgrid1" style="display: none"></div>
			</div>
			<div class="cbt_btn" style="height:25px">
				<div class="bleft">
				</div>
				<div class="bright">
					<a href="javascript:;" id="btnChart" class="app1"><spring:message code="lbl.chart" /></a>
					<a href="javascript:;" id="btnSummary" class="app1"><spring:message code="lbl.summary" /></a>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
