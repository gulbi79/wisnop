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
	var lamConsSummary = {
			
		init : function() {
			gfn_popresize();
			this.comCode.initCode();
			this.grid.initGrid();
			this.events();
		}, 
		
		_siq    : "dp.salesPerform.lamConsSummary",
		
		comCode : {
			codeMapEx : null,			
			codeMap : null,
			
			initCode : function () {
				
				FORM_SEARCH          = $("#searchForm").serializeObject(); //초기화
				FORM_SEARCH._mtd     = "getList";
				FORM_SEARCH.tranData = [{ outDs : "dateList", _siq : lamConsSummary._siq + "Date"}];
				
				// 계획버전 
				gfn_service({
				    async   : false,
				    url     : GV_CONTEXT_PATH + "/biz/obj.do",
				    data    : FORM_SEARCH,
				    success : function(data) {
				    	
				    	var fromDate = data.dateList[0].FROM_DATE;
				    	var toDate = data.dateList[0].TO_DATE;
				    	
				    	DATEPICKET(null, fromDate, toDate);
				    }
				},"obj");
			}
		},
		
		grid : {
			
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid : function() {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				//this.gridInstance.totalFlag = true;
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
			}
		},
		
		events : function () {
			$("#btnClose").on("click", function() { 
				window.close(); 
			});
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			}); 
		},
		
		getBucket : function(sqlFlag) {
			
			var ajaxMap = {
	   			fromDate: gfn_replaceAll($("#fromCal").val(), "-", ""),
		   		toDate  : gfn_replaceAll($("#toCal").val(), "-", ""),
		   		month   : {isDown: "Y", isUp:"N", upCal:"Q", isMt:"N", isExp:"Y", expCnt:999},
		   		week	: {isDown: "N", isUp:"Y", upCal:"M", isMt:"Y", isExp:"N", expCnt:999},
		   		sqlId   : ["bucketMonth", "bucketFullWeek"]
			}
			gfn_getBucket(ajaxMap);
			
			if (!sqlFlag) {
				lamConsSummary.grid.gridInstance.setDraw();
				
				//조회조건 설정
				FORM_SEARCH = $("#searchForm").serializeObject();
				FORM_SEARCH.sql        = sqlFlag;
				FORM_SEARCH.bucketList = BUCKET.query;
				FORM_SEARCH.dimList    = DIMENSION.user;
				
				lamConsSummary.search();
			}
			else
			{
				//조회조건 설정
				FORM_SEARCH = $("#searchForm").serializeObject();
				FORM_SEARCH.sql        = sqlFlag;
				FORM_SEARCH.bucketList = BUCKET.query;
				FORM_SEARCH.dimList    = DIMENSION.user;
				
				lamConsSummary.search();
			}
		},
		
		search : function () {
			FORM_SEARCH._mtd = "getList";
			FORM_SEARCH.cpfrYn = "Y";
			FORM_SEARCH.tranData = [{ outDs : "resList", _siq : this._siq}];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj.do",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						lamConsSummary.grid.dataProvider.clearRows(); //데이터 초기화
						
						//그리드 데이터 생성
						lamConsSummary.grid.grdMain.cancel();
						
						lamConsSummary.grid.dataProvider.setRows(data.resList);
						lamConsSummary.grid.dataProvider.clearSavePoints();
						lamConsSummary.grid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(lamConsSummary.grid.dataProvider.getRowCount());
						//gfn_actionMonthSum(lamConsSummary.grid.gridInstance);
						gfn_setRowTotalFixed(lamConsSummary.grid.grdMain);
					}
				}
			}
			
			gfn_service(aOption, "obj");
		}
	};
	
	var fn_apply = function(sqlFlag) {
		
		// 디멘전 정리
		DIMENSION.user = [];
		DIMENSION.user.push({DIM_CD:"CODE_NM", DIM_NM:'<spring:message code="lbl.division"/>', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		
		lamConsSummary.getBucket(sqlFlag);
	}
	
	$(document).ready(function() {
		lamConsSummary.init();
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
		    url     : GV_CONTEXT_PATH + "/biz/obj.do",
		    data    : {
	   			_mtd : "getList",
	   			popUpMenuCd : popUpMenuCd,
	   			tranData : [
	   				{outDs : "authorityList", _siq : "dp.salesPerform.lamConsSummaryExcelSql"}
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
<style type="text/css">
.locationext .fnc{display:inline-block;}
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
				<input type="hidden" id="planId" name="planId" value="${param.planId }"/>
				<strong class="filter_tit" id="filter_tit">View Horizon</strong>
				<div class="tlist" style="margin-top:10px;">
					<spring:message code="lbl.start" />
					<input type="text" id="fromCal" name="fromCal" class="iptdate datepicker1" readonly value="" style="margin-left: 20px;"/>
					<input type="<c:if test="${param.wType=='SW'}">hidden</c:if><c:if test="${param.wType!='SW'}">text</c:if>" id="fromPWeek" name="fromPWeek" class="iptdateweek" disabled="disabled" value=""/>
					<input type="<c:if test="${param.wType=='SW'}">text</c:if><c:if test="${param.wType!='SW'}">hidden</c:if>" id="fromWeek" name="fromWeek" class="iptdateweek" disabled="disabled" value=""/>
					<input type="hidden" id="swFromDate" name="swFromDate"/>
					<input type="hidden" id="pwFromDate" name="pwFromDate"/>
				</div>	
				<div class="tlist">
					<spring:message code="lbl.end" />
					<input type="text" id="toCal" name="toCal" class="iptdate datepicker2" readonly value="" style="margin-left: 24px;"/>
					<input type="<c:if test="${param.wType=='SW'}">hidden</c:if><c:if test="${param.wType!='SW'}">text</c:if>" id="toPWeek" name="toPWeek" class="iptdateweek" disabled="disabled" value=""/>
					<input type="<c:if test="${param.wType=='SW'}">text</c:if><c:if test="${param.wType!='SW'}">hidden</c:if>" id="toWeek" name="toWeek" class="iptdateweek" disabled="disabled" value=""/>
					<input type="hidden" id="swToDate" name="swToDate"/>
					<input type="hidden" id="pwToDate" name="pwToDate"/>
					<div class="bt_btn">
						<div class="locationext">
							<div class="fnc">
								<a href="#" id='excel' style="display:none" class="viewfnc5"><img src="${ctx}/statics/images/common/btn_gun5.gif" title="Excel Download"></a>
					    		<a href="#" id='sql' style="display:none"class="viewfnc4"><img src="${ctx}/statics/images/common/btn_gun4.gif" title="SQL View"></a>
								<a href="javascript:;" id="btnSearch" class="fl_app"><spring:message code="lbl.search"/></a>	    		
					    	</div>
						</div>
					</div>
				</div>
				</form>
 				
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