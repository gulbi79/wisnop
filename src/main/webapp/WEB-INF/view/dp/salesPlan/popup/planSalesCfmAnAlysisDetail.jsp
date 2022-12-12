<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code="lbl.planSummaryDetail"/></title>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
	<jsp:param name="popupYn" value="Y"/>
</jsp:include>
<style type="text/css">
.locationext .fnc a {display:inline-block;overflow:hidden;height:27px;margin-left:4px;}
.li_none {list-style-type:none;background:white}
</style>
<script type="text/javascript">
	var lv_conFirmFlag = true;
	var popupWidth, popupHeight, arrExtCol;
	var popUpMenuCd = "${param.menuCd}";
	var planSalesCfmAnAlysisDetail = {
		init : function() {
			
			gfn_popresize();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.grid.initGrid();
			fn_apply();
		},
		
		_siq    : "dp.salesPlan.planSalesCfmAnAlysisList",
		
		comCode : {
			codeMapEx : null,
			codeMap   : null,
			initCode  : function() {
			}
		},
		
		initFilter : function() {
			
		},
		
		grid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid : function() {
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				
				this.setOptions();
				
				this.grdMain.onShowHeaderTooltip = function (grid, column, value) {
					
					var result = value;
		    		var fname = gfn_nvl(column.fieldName, column.name);
		    		
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
		    		
		    		return result;
				}	
				
			},
			
			setOptions : function() {
				this.grdMain.setOptions({
					//stateBar: { visible : true }
				});

				this.dataProvider.setOptions({
					softDeleting : true
				});
			}
		},
		
		events : function() {
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("#sQty,#sAmt").on("click", function(e) {
				fn_gridCtrl(this, arrExtCol);
			});
			
			$(".viewfnc2").click("on", function() { 
				
				var params = {P_MENU_CD : $("#menuCd").val()};
				gfn_comPopupOpen("MEASURE", params); 
			});
			$(".viewfnc5").click("on", function() {
				gfn_doExportExcel({fileNm:"${menuInfo.menuNm}", conFirmFlag: lv_conFirmFlag}); 
				$(".pClose").click(function() {
					$("#divTempLayerPopup").hide();
					$(".back").hide();
				});
			    $(".popClose").click(function() {
			    	$("#divTempLayerPopup").hide();
					$(".back").hide();
				});
			    $(".back").click(function() {
					$(".popup2").hide();
					$(".back").hide();
				});
			});
			
			$(".viewfnc4").click("on", function() {
				fn_apply(true);
				
				$(document).on("click",".popup2 .popClose, .popup2 .pClose",function() {
					$(".popup2").hide();
					$(".back").hide();
				});
				
				$(".back").click(function() {
					$(".popup2").hide();
					$(".back").hide();
				});
			    
			})
			
			$("#btnClose" ).on("click", function() { window.close(); });
		},
		
		getBucket : function(sqlFlag) {
			
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
			gfn_setCustBucket(subBucket);
			
			if(!sqlFlag){
				planSalesCfmAnAlysisDetail.grid.gridInstance.setDraw();
			}
		},
		
		search : function() {
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList", _siq : this._siq + "Detail"}];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj.do",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						planSalesCfmAnAlysisDetail.grid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						planSalesCfmAnAlysisDetail.grid.grdMain.cancel();
						
						planSalesCfmAnAlysisDetail.grid.dataProvider.setRows(data.resList);
						planSalesCfmAnAlysisDetail.grid.dataProvider.clearSavePoints();
						planSalesCfmAnAlysisDetail.grid.dataProvider.savePoint(); //초기화 포인트 저장
						//gfn_setSearchRow(planSalesCfmAnAlysisDetail.grid.dataProvider.getRowCount());
						gfn_setRowTotalFixed(planSalesCfmAnAlysisDetail.grid.grdMain);
						
						arrExtCol = [];
						
						$.each(BUCKET.all[0], function(i, val){
							arrExtCol.push(val.CD);
						});
						
						$.each($("#sQty,#sAmt"), function(n, v) {
							if ($(v).is(":checked")) return true;
							fn_gridCtrl(v, arrExtCol);
						});
					}
				}
			}
			
			gfn_service(aOption, "obj");
		}
	};
	
	var fn_apply = function (sqlFlag) {
		
		// 디멘전 정리
		DIMENSION.user = [];
		DIMENSION.user.push({DIM_CD:"PROD_CATE_NM", DIM_NM:'<spring:message code="lbl.prodCate"/>', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100, SQL_TOTAL_FLAG:"Y"});
		DIMENSION.user.push({DIM_CD:"REP_CUST_GROUP_NM", DIM_NM:'<spring:message code="lbl.salesGroupNm" />', LVL:20, DIM_ALIGN_CD:"L", WIDTH:100});
		
    	planSalesCfmAnAlysisDetail.getBucket(sqlFlag);
    	//조회조건 설정
    	FORM_SEARCH            = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
    	FORM_SEARCH.dimList    = DIMENSION.user;
    	FORM_SEARCH.bucketList = BUCKET.query;
    	
    	planSalesCfmAnAlysisDetail.search();
	}
	
	function fn_gridCtrl(obj, arrExt) {
    	var tObjColNm = $(obj).attr("val");
		var grid = planSalesCfmAnAlysisDetail.grid.grdMain;
		var columnNames = grid.getColumnNames(true);
		var visi = $(obj).is(":checked");
		columnNames = $.grep(columnNames, function(v, n) {
			return v.indexOf(tObjColNm) > -1 && $.inArray(v, arrExt) == -1;
		});
		gfn_gridCtrl(grid, columnNames, visi);
		
		var headerHeight = planSalesCfmAnAlysisDetail.grid.grdMain.getHeader().height  // 헤더 높이
		if(headerHeight < 50){
			planSalesCfmAnAlysisDetail.grid.grdMain.setHeader(
				{height : headerHeight + 35} // 헤더 높이 +10
			);
		}
    }
	
	// onload 
	$(document).ready(function() {
		
		planSalesCfmAnAlysisDetail.init();
		fn_excelSqlAuth();
	});
	
	$(window).resize(function() {
		gfn_popresizeSub();
	}).resize();
	
	//엑셀, 쿼리 다운로드 권한 확인
	function fn_excelSqlAuth() {
		
		gfn_service({
		    async   : false,
		    url     : GV_CONTEXT_PATH + "/biz/obj.do",
		    data    : {
	   			_mtd : "getList",
	   			popUpMenuCd : popUpMenuCd,
	   			tranData : [
	   				{outDs : "authorityList", _siq : "dp.salesPlan.planSalesCfmAnAlysisListDetailExcelSql"}
	   			]
		    },
		    success :function(data) {
		    	
		    	for(i=0;i<data.authorityList.length;i++)
		    	{
		    		if(data.authorityList[i].USE_FLAG == "Y"&&data.authorityList[i].ACTION_CD=="EXCEL")
		    		{
		    			$("#excel").show();
		    		}
		    		else if(data.authorityList[i].USE_FLAG == "Y"&&data.authorityList[i].ACTION_CD=="SQL")
		    		{
		    			$("#sql").show();
		    		}
		    	}
		    		
		    }
		}, "obj");
	}
</script>

</head>
<body>
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="keywordpop" class="popupDv">
		<div class="pop_tit">${param.popupTitle}</div>
		<div class="popCont">
			<div class="srhwrap">
				<form id="searchForm" name="searchForm" method="POST" onSubmit="return false;">
				<input type="hidden" id="planId" name="planId" value="${param.planId}"/>
				<input type="hidden" id="menuCd" name="menuCd" value="${param.menuCd}"/>
				<div class="srhcondi">
				<ul>
					<li>
						<strong class="filter_tit"><spring:message code="lbl.qtyAmtGubun"/></strong>
						<ul class="rdofl">
							<li><input type="checkbox" id="sQty" name="sQty" val="_SQTY"/><label for="sQty"><spring:message code="lbl.qty"/></label></li>
							<li><input type="checkbox" id="sAmt" name="sAmt" val="_SAMT" checked="checked"/><label for="sAmt"><spring:message code="lbl.amt"/></label></li>
						</ul>
					</li>
					<!-- 
					<li id="excelSqlContainer" style="display:none;">
						<div class="locationext">
							<div class="fnc">
								<c:if test="${menuInfo.measureYn eq 'Y'}">
								<a href="#" class="viewfnc2"><img src="${ctx}/statics/images/common/btn_gun2.gif" title="Measure Configration"></a>
								</c:if>
								<c:if test="${menuInfo.excelYn eq 'Y'}">
								<a href="#" class="viewfnc5"><img src="${ctx}/statics/images/common/btn_gun5.gif" title="Excel Download"></a>
								</c:if>
								<a href="#" id='excel' style="display:none" class="viewfnc5"><img src="${ctx}/statics/images/common/btn_gun5.gif" title="Excel Download"></a>
								<a href="#" id='sql' style="display:none"class="viewfnc4"><img src="${ctx}/statics/images/common/btn_gun4.gif" title="SQL View"></a>
								
							</div>
						</div>
					</li>
					 -->
					<%-- <li id="excel" style="margin-left: 800px;">
						<div class="locationext">
							<div class="fnc">
								<c:if test="${menuInfo.measureYn eq 'Y'}">
								<a href="#" class="viewfnc2"><img src="${ctx}/statics/images/common/btn_gun2.gif" title="Measure Configration"></a>
								</c:if>
								<c:if test="${menuInfo.excelYn eq 'Y'}">
								<a href="#" class="viewfnc5"><img src="${ctx}/statics/images/common/btn_gun5.gif" title="Excel Download"></a>
								</c:if>
							</div>
						</div>
					</li> --%>
				</ul>
				</div>
				</form>
 				<div class="bt_btn">
						<div class="locationext">
							<div class="fnc">
								<c:if test="${menuInfo.measureYn eq 'Y'}">
								<a href="#" class="viewfnc2"><img src="${ctx}/statics/images/common/btn_gun2.gif" title="Measure Configration"></a>
								</c:if>
								<a href="#" id='excel' style="display:none" class="viewfnc5"><img src="${ctx}/statics/images/common/btn_gun5.gif" title="Excel Download"></a>
								<a href="#" id='sql' style="display:none"class="viewfnc4"><img src="${ctx}/statics/images/common/btn_gun4.gif" title="SQL View"></a>
								
							</div>
						</div>
				</div>
			</div>
			<div id="realgrid" class="realgrid1"></div>

		</div>
		<div class="pop_btm">
			<div class="pop_btn_info">
				<strong >Sum  :</strong> <span id="bottom_userSum"></span>
			</div>
			<div class="pop_btn_info">
				<strong >Avg  :</strong> <span id="bottom_userAvg"></span>
			</div>
			<div class="pop_btn">
				<a href="javascript:;" id="btnClose" class="app1"><spring:message code="lbl.close"/></a>
			</div>
		</div>
	</div>
	
</body>
</html>