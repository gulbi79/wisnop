<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
	<jsp:param name="popupYn" value="Y"/>
</jsp:include>

<script type="text/javascript">
	var popupWidth, popupHeight;
	var popUpMenuCd = "${param.menuCd}";
	var lv_conFirmFlag = true;
	var lamSalesTrendMonthlySummary = {
			
		init : function() {
			gfn_popresize();
			this.comCode.initCode();
			this.grid.initGrid();
			this.events();
			fn_apply();
		}, 
		
		_siq : "dp.salesPerform.lamSalesTrendMonthlySummary",
		
		comCode : {
			codeMapEx : null,			
			codeMap : null,
			
			initCode : function () {
			}
		},
		
		grid : {
			
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid : function() {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				this.gridInstance.totalFlag = true;
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
			}
		},
		
		events : function () {
			$("#btnClose").on("click", function() { 
				window.close(); 
			});
			
			$("#qty,#amt").on("click", function(e) {
				fn_apply(false);
			});
			
			
		},
		
		getBucket : function(sqlFlag) {
			
			var ajaxMap = {
				fromDate : $("#year").val() + "0101",
				toDate   : $("#year").val() + "1231",
				sqlId    : ["dp.salesPerform.bucketLamMonthSummary1", "dp.salesPerform.bucketLamMonthSummary2"]
			}
			
			gfn_getBucket(ajaxMap);
			
			if (!sqlFlag) {
				lamSalesTrendMonthlySummary.grid.gridInstance.setDraw();
				
				//조회조건 설정
				FORM_SEARCH = $("#searchForm").serializeObject();
				FORM_SEARCH.sql        = sqlFlag;
				FORM_SEARCH.bucketList = BUCKET.query;
				FORM_SEARCH.dimList    = DIMENSION.user;
				
				lamSalesTrendMonthlySummary.search();
			}
			else
			{
				//조회조건 설정
				FORM_SEARCH = $("#searchForm").serializeObject();
				FORM_SEARCH.sql        = sqlFlag;
				FORM_SEARCH.bucketList = BUCKET.query;
				FORM_SEARCH.dimList    = DIMENSION.user;
				
				lamSalesTrendMonthlySummary.search();
			}
		},
		
		search : function () {
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq}];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						lamSalesTrendMonthlySummary.grid.dataProvider.clearRows(); //데이터 초기화
						
						//그리드 데이터 생성
						lamSalesTrendMonthlySummary.grid.grdMain.cancel();
						
						lamSalesTrendMonthlySummary.grid.dataProvider.setRows(data.resList);
						lamSalesTrendMonthlySummary.grid.dataProvider.clearSavePoints();
						lamSalesTrendMonthlySummary.grid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(lamSalesTrendMonthlySummary.grid.dataProvider.getRowCount());
						gfn_actionMonthSum(lamSalesTrendMonthlySummary.grid.gridInstance);
						//gfn_setRowTotalFixed(lamSalesTrendMonthlySummary.grid.grdMain);
					}
				}
			}
			
			gfn_service(aOption, "obj");
		}
		
	};
	
	var fn_apply = function(sqlFlag) {
		
		// 디멘전 정리
		DIMENSION.user = [];
		DIMENSION.user.push({DIM_CD:"YEAR", DIM_NM:'<spring:message code="lbl.year"/>', LVL:10, DIM_ALIGN_CD:"C", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"CUST_CD", DIM_NM:'<spring:message code="lbl.custcd"/>', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"BP_NM", DIM_NM:'<spring:message code="lbl.customerName"/>', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		
		lamSalesTrendMonthlySummary.getBucket(sqlFlag);
	}
	
	$(document).ready(function() {
		lamSalesTrendMonthlySummary.init();
		fn_excelSqlAuth();
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
	});

	$(window).resize(function() {
		gfn_popresizeSub();
	}).resize();

	//엑셀, 쿼리 다운로드 권한 확인
	function fn_excelSqlAuth() {
		
		gfn_service({
		    async   : false,
		    url     : GV_CONTEXT_PATH + "/biz/obj",
		    data    : {
	   			_mtd : "getList",
	   			popUpMenuCd : popUpMenuCd,
	   			tranData : [
	   				{outDs : "authorityList", _siq : "dp.salesPerform.lamSalesTrendMonthlySummaryExcelSql"}
	   			]
		    },
		    success :function(data) {
		    	
		    	for(i=0;i<data.authorityList.length;i++)
		    	{
		    		if(data.authorityList[i].USE_FLAG == "Y"&&data.authorityList[i].ACTION_CD=="EXCEL")
		    		{
		    			$('#excelSqlContainer').show();
		    			$("#excel").show();
		    		}
		    		else if(data.authorityList[i].USE_FLAG == "Y"&&data.authorityList[i].ACTION_CD=="SQL")
		    		{
		    			$('#excelSqlContainer').show();
		    			$("#sql").show();
		    		}
		    	}
		    		
		    }
		}, "obj");
	}

	
</script>
<style type="text/css">
.locationext .fnc a {display:inline-block;overflow:hidden;height:27px;margin-left:4px;}
.li_none {list-style-type:none;background:white}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="keywordpop" class="popupDv">
		<div class="pop_tit">${param.popupTitle}</div>
		<div class="popCont">
			<div class="srhwrap">
				<form id="searchForm" name="searchForm" method="POST" onSubmit="return false;">
				<input type="hidden" id="year" name="year" value="${param.year }"/>
				
				<div class="srhcondi">
				<c:set var="lvWidth" value="115px" />
				<ul class="rdofl">
					<li><input type="radio" id="qty" name="qtyAmt" value="qty" checked="checked"/><label for="qty"><spring:message code="lbl.qty" /></label></li>
					<li><input type="radio" id="amt" name="qtyAmt" value="amt"/><label for="amt"><spring:message code="lbl.amt" /> </label></li>
				</ul>
				</div>
				</form>
 				<div class="bt_btn">
					<%-- <a href="javascript:;" id="btnSearch" class="fl_app"><spring:message code="lbl.search"/></a> --%>
					<div id="excelSqlContainer" style="display:none;">
						<div class="locationext">
							<div class="fnc">
								<a href="#" id='excel' style="display:none" class="viewfnc5"><img src="${ctx}/statics/images/common/btn_gun5.gif" title="Excel Download"></a>
					    		<a href="#" id='sql' style="display:none"class="viewfnc4"><img src="${ctx}/statics/images/common/btn_gun4.gif" title="SQL View"></a>
					    		
					    	</div>
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
				<%-- <a href="#" id="btnApply" class="pbtn pApply"><spring:message code="lbl.apply"/></a> --%>
				<a href="javascript:;" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
			</div>
		</div>
	</div>
</body>
</html>