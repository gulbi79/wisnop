<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
	<jsp:param name="popupYn" value="Y"/>
</jsp:include>

<script type="text/javascript">
	var popupWidth, popupHeight;
	//var codeMap, codeMapEx;
	var lv_conFirmFlag = true;
	var popUpMenuCd = "${param.menuCd}";
	var workOrderDaily = {
			
		init : function() {
			gfn_popresize();
			this.comCode.initCode();
			this.grid.initGrid();
			this.events();
		}, 
		
		_siq    : "aps.planResult.workOrderDaily",
		
		comCode : {
			codeMapEx : null,			
			codeMap : null,
			
			initCode : function () {
				
				var pRoute = "${param.P_ROUTE}";
				var pRouteSplit = pRoute.split(",");
				var pRouteArray = new Array();
				
				var pItemGroup = "${param.P_ITEM_GROUP}";
				var pItemGroupSplit = pItemGroup.split(",");
				var pItemGroupArray = new Array();
				
				$.each(pRouteSplit, function(i, val){
					pRouteArray.push(val);
				});
				
				$.each(pItemGroupSplit, function(i, val){
					pItemGroupArray.push(val);
				});
				
				var grpCd = "PROD_PART";
				this.codeMap = gfn_getComCode(grpCd, 'Y'); 
				this.codeMapEx = gfn_getComCodeEx(["ROUTING", "ITEM_GROUP"], null, {});
				this.codeMap.PROD_PART[0].CODE_NM = "";
				
				gfn_setMsCombo("route", this.codeMapEx.ROUTING, ["*"], {width:"122px"});
				gfn_setMsCombo("itemGroup", this.codeMapEx.ITEM_GROUP, ["*"], {width:"122px"});
				gfn_setMsCombo("prodPart", this.codeMap.PROD_PART, ["*"], {width:"122px"});
				
				$("#route").multipleSelect("open");
				$("#route").multipleSelect("setSelects", pRouteArray);
				$("#route").multipleSelect("close");
				
				$("#itemGroup").multipleSelect("open");
				$("#itemGroup").multipleSelect("setSelects", pItemGroupArray);
				$("#itemGroup").multipleSelect("close");
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
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			}); 
		},
		
		getBucket : function(sqlFlag) {
			
			var dataList = {};
			dataList = $("#searchForm").serializeObject(); //초기화
			dataList._mtd = "getList";
			dataList.tranData = [{ outDs : "resList", _siq : "aps.planResult.workOrderDailyBucket"}];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj.do",
				data    : dataList,
				success : function (data) {
					
					var ajaxMap = {
						fromDate : data.resList[0].START_DATE,
						toDate   : data.resList[0].END_DATE,
						day      : {isDown: "Y", isUp:"N", upCal:"N", isMt:"N", isExp:"N", expCnt:1},
						sqlId    : ["bucketDay"]
					}
					
					gfn_getBucket(ajaxMap);
					
					if (!sqlFlag) {
						workOrderDaily.grid.gridInstance.setDraw();
						
						//조회조건 설정
						FORM_SEARCH = $("#searchForm").serializeObject();
						FORM_SEARCH.sql        = sqlFlag;
						FORM_SEARCH.bucketList = BUCKET.query;
						FORM_SEARCH.dimList    = DIMENSION.user;
						
						workOrderDaily.search();
					}
					//SQL 조회 버튼처리
					else
					{
						//조회조건 설정
						FORM_SEARCH = $("#searchForm").serializeObject();
						FORM_SEARCH.sql        = sqlFlag;
						FORM_SEARCH.bucketList = BUCKET.query;
						FORM_SEARCH.dimList    = DIMENSION.user;
						
						workOrderDaily.search();
					}
				}
			}
			gfn_service(aOption, "obj");
		},
		
		search : function () {
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq}];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj.do",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						workOrderDaily.grid.dataProvider.clearRows(); //데이터 초기화
						
						//그리드 데이터 생성
						workOrderDaily.grid.grdMain.cancel();
						
						workOrderDaily.grid.dataProvider.setRows(data.resList);
						workOrderDaily.grid.dataProvider.clearSavePoints();
						workOrderDaily.grid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(workOrderDaily.grid.dataProvider.getRowCount());
						//gfn_actionMonthSum(workOrderDaily.grid.gridInstance);
						gfn_setRowTotalFixed(workOrderDaily.grid.grdMain);
					}
				}
			}
			
			gfn_service(aOption, "obj");
		}
		
	};
	
	var fn_apply = function(sqlFlag) {
		
		var prodPart = gfn_nvl($("#prodPart").val(), "");
		
		if(prodPart == ""){
			alert('<spring:message code="msg.prodPartMsg"/>');
			return;
		}
		
		// 디멘전 정리
		DIMENSION.user = [];
		DIMENSION.user.push({DIM_CD:"ITEM_CD", DIM_NM:'<spring:message code="lbl.item"/>', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"SPEC", DIM_NM:'<spring:message code="lbl.spec"/>', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		
		workOrderDaily.getBucket(sqlFlag);
	}
	
	$(document).ready(function() {
		workOrderDaily.init();
		fn_excelSqlAuth();
		$(".viewfnc5").click("on", function() {
			gfn_doExportExcel({fileNm:"${menuInfo.menuNm}", conFirmFlag: lv_conFirmFlag}); 
			$(".pClose").click(function() {
				console.log(".pClose clicked");
				$("#divTempLayerPopup").hide();
				$(".back").hide();
			});
		    $(".popClose").click(function() {
		    	console.log(".popClose clicked");
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
	   				{outDs : "authorityList", _siq : "aps.planResult.workOrderReplaceExcelSql"}//APS > 계획결과 > 작업지시 조회 페이지의 SQL, 엑셀 권한을 참조하므로 공통쿼리 사용 
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
				<input type="hidden" id="plan_id" name="plan_id" value="${param.P_PLAN_ID }"/>
				
				<div class="srhcondi">
				<c:set var="lvWidth" value="115px" />
				<ul>
					<li>
						<strong class="srhcondipop"><spring:message code="lbl.prodPart"/></strong>
						<div class="selectBox">
							<select id="prodPart" name="prodPart"></select>
						</div>
					</li>
					<li>
						<strong class="srhcondipop"><spring:message code="lbl.routing"/></strong>
						<div class="selectBox">
							<select id="route" name="route" multiple="multiple"></select>
						</div>
					</li>
					<li id="excelSqlContainer" style="display:none;">
								<div class="locationext">
									<div class="fnc">
										<a href="#" id='excel' style="display:none" class="viewfnc5"><img src="${ctx}/statics/images/common/btn_gun5.gif" title="Excel Download"></a>
							    		<a href="#" id='sql' style="display:none"class="viewfnc4"><img src="${ctx}/statics/images/common/btn_gun4.gif" title="SQL View"></a>
							    	</div>
								</div>
					</li>
				</ul>
				<ul>
					<li>
						<strong class="srhcondipop"><spring:message code="lbl.itemGroup"/></strong>
						<div class="selectBox">
							<select id="itemGroup" name="itemGroup" multiple="multiple"></select>
						</div>
					</li>
					<li>
						<strong class="srhcondipop"><spring:message code="lbl.reptCust"/></strong>
						<div class="selectBox">
							<input type="text" id="reptCust" name="reptCust" value="" class="ipt" style="width:${lvWidth};">
						</div>
					</li>
				</ul>
				<ul>
					<li>
						<strong class="srhcondipop"><spring:message code="lbl.item"/></strong>
						<div class="selectBox">
							<input type="text" id="item" name="item" value="" class="ipt" style="width:${lvWidth};">
						</div>
					</li>
				</ul>
				</div>
				</form>
 				<div class="bt_btn">
					<a href="javascript:;" id="btnSearch" class="fl_app"><spring:message code="lbl.search"/></a>
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