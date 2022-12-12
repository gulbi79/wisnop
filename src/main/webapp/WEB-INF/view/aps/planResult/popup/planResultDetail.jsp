<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code="lbl.planSummaryDetail"/></title>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
	<jsp:param name="popupYn" value="Y"/>
</jsp:include>

<script type="text/javascript">
	var popupWidth, popupHeight;
	var lv_conFirmFlag = true;
	var gPlanId    = "${param.planId}";
	var gProdPart  = "${param.prodPart}";
	var gVersionId = "${param.versionId}";
	var gCategory  = "${param.category}";
	var popUpMenuCd = "${param.menuCd}";
	var planResultDetail = {
		init : function() {
			
			gfn_popresize();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.grid.initGrid();
			fn_apply();
		},
		
		_siq    : "aps.planResult.planResult",
		
		comCode : {
			codeMapEx : null,
			codeMap   : null,
			initCode  : function() {
				var grpCd      = 'PROD_PART,APS_PLAN_RESULT_CATEGORY';
				this.codeMap   = gfn_getComCode(grpCd, 'Y'); 
			}
		},
		
		initFilter : function() {
			//Plan ID
	    	fn_getPlanId({picketType:"W",planTypeCd:"MP"});
			
			gfn_setMsComboAll([
				{target : 'divProdPart', id : 'prodPart', title : '<spring:message code="lbl.prodPart2"/>', data : this.comCode.codeMap.PROD_PART, exData:[""]},
				{target : 'divPlanVersion', id : 'versionId', title : '<spring:message code="lbl.planVersion"/>', data : [], exData:[""]},
				{target : 'divCategory', id : 'category', title : '<spring:message code="lbl.category"/>', data : this.comCode.codeMap.APS_PLAN_RESULT_CATEGORY, exData:[""]}
			]);
			
			$("#planId").val(gPlanId);
			
			planResultDetail.prodPartChange();
			
			if (!gfn_isNull(gProdPart)) {
				var aProdPart = gProdPart.split(",");
				$("#prodPart").multipleSelect("setSelects", aProdPart);
			}
			
			if (!gfn_isNull(gVersionId)) {
				var aVersionId = gVersionId.split(",");
				$("#versionId").multipleSelect("setSelects", aVersionId);
			}
			
			if (!gfn_isNull(gCategory)) {
				var aCategory = gCategory.split(",");
				$("#category").multipleSelect("setSelects", aCategory);
			}
			
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
				
				this.gridInstance.measureHFlag = true;		// 메저 행모드 안보이게..
				this.gridInstance.measureCFlag = true;
				
				this.setOptions();
			},
			
			setOptions : function() {
				this.grdMain.setOptions({
					//stateBar: { visible : true }
				});

				this.dataProvider.setOptions({
					softDeleting : true
				});
				
				this.grdMain.addCellStyles([{
					id         : "editStyle",
					editable   : true,
					background : gv_editColor
				}]);
			}
		},
		
		events : function() {
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("#prodPart,#planId").change(function() {
				planResultDetail.prodPartChange();
			});
			
			$("#btnClose" ).on("click", function() { window.close(); });
		},
		
		getBucket : function(sqlFlag) {
			var search     = $("#searchForm").serializeObject(); //초기화
			search._mtd    = "getList";
			search.tranData = [{ outDs : "dayList",_siq : this._siq + "VersionDay"}];
			
			gfn_service({
			    async   : false,
			    url     : GV_CONTEXT_PATH + "/biz/obj.do",
			    data    : search,
			    success :function(data) {
			    	var startDate = "";
			    	var endDate   = "";
			    	var iCnt = data.dayList[0].CNT;
			    	
			    	if(iCnt > 0) {
			    		startDate = gfn_nvl(data.dayList[0].APS_START_DATE, "");
						endDate   = gfn_nvl(weekdatecal(data.dayList[0].APS_START_DATE), "");
						
						var ajaxMap = {
							fromDate : startDate,
							toDate   : endDate,
							week     : {isDown: "Y", isUp : "N", upCal : "M", isMt : "N", isExp : "N", expCnt : 999},
							sqlId    : ["bucketFullWeek"]
						}
						
						gfn_getBucket(ajaxMap);
			    	}
			    	
			    	if (!sqlFlag) {
						planResultDetail.grid.gridInstance.setDraw();
			    		
			    		$.each(BUCKET.query, function(n, v) {
			    			planResultDetail.grid.grdMain.setColumnProperty(v.CD, "dynamicStyles", [
			    				{//가동율
				    				criteria : "(values['MEAS_CD'] = 'RESULT01')",
				    				styles   : {numberFormat : "#,##0"}
				    			}, {//누적 수요 충족률(수량)
				    				criteria : "(values['MEAS_CD'] = 'RESULT02')",
				    				styles   : {numberFormat : "#,##0"}
				    			}, {//누적 수요 충족률(금액)
				    				criteria : "(values['MEAS_CD'] = 'RESULT03')",
				    				styles   : {numberFormat : "#,##0.0"}
				    			}, {//예상 출하 금액
				    				criteria : "(values['MEAS_CD'] = 'RESULT04')",
				    				styles   : {numberFormat : "#,##0.0"}
				    			}, {//생산 계획 금액
				    				criteria : "(values['MEAS_CD'] = 'RESULT05')",
				    				styles   : {numberFormat : "#,##0.0"}
				    			}, {//작업 교체 횟수 (week)
				    				criteria : "(values['MEAS_CD'] = 'RESULT06')",
				    				styles   : {numberFormat : "#,##0.0"}
				    			}, {//작업 교체 시간 (week)
				    				criteria : "(values['MEAS_CD'] = 'RESULT07')",
				    				styles   : {numberFormat : "#,##0"}
				    			}, {//계획 TAT
				    				criteria : "(values['MEAS_CD'] = 'RESULT08')",
				    				styles   : {numberFormat : "#,##0"}
				    			}, {//AP2 출하계획 수량
				    				criteria : "(values['MEAS_CD'] = 'RESULT09')",
				    				styles   : {numberFormat : "#,##0"}
				    			}, {//재고 사용 수량
				    				criteria : "(values['MEAS_CD'] = 'RESULT10')",
				    				styles   : {numberFormat : "#,##0"}
				    			}, {//생산 필요 수량
				    				criteria : "(values['MEAS_CD'] = 'RESULT11')",
				    				styles   : {numberFormat : "#,##0"}
				    			}, {//예상 출하 수량
				    				criteria : "(values['MEAS_CD'] = 'RESULT12')",
				    				styles   : {numberFormat : "#,##0"}
				    			}, {//AP2 출하계획 금액
				    				criteria : "(values['MEAS_CD'] = 'RESULT13')",
				    				styles   : {numberFormat : "#,##0.0"}
				    			}, {//재고 사용 금액
				    				criteria : "(values['MEAS_CD'] = 'RESULT14')",
				    				styles   : {numberFormat : "#,##0.0"}
				    			}, {//생산 필요 금액
				    				criteria : "(values['MEAS_CD'] = 'RESULT15')",
				    				styles   : {numberFormat : "#,##0.0"}
				    			}, {//생산 계획 수량
				    				criteria : "(values['MEAS_CD'] = 'RESULT16')",
				    				styles   : {numberFormat : "#,##0"}
				    			}, {//안전재고 수량
				    				criteria : "(values['MEAS_CD'] = 'RESULT17')",
				    				styles   : {numberFormat : "#,##0"}
				    			}, {//안전재고 금액
				    				criteria : "(values['MEAS_CD'] = 'RESULT18')",
				    				styles   : {numberFormat : "#,##0.0"}
				    			}, {//AP2 출하계획 금액 (계획반영주차)
				    				criteria : "(values['MEAS_CD'] = 'RESULT19')",
				    				styles   : {numberFormat : "#,##0.0"}
				    			}
			    			]);
			    		});
					}
		    	}
			}, "obj");
		},
		
		search : function() {
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq + "Detail"}];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj.do",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						planResultDetail.grid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						planResultDetail.grid.grdMain.cancel();
						
						planResultDetail.grid.dataProvider.setRows(data.resList);
						planResultDetail.grid.dataProvider.clearSavePoints();
						planResultDetail.grid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(planResultDetail.grid.dataProvider.getRowCount());
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		prodPartChange : function() {
			FORM_SEARCH          = $("#searchForm").serializeObject(); //초기화
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "versionList",_siq : planResultDetail._siq + "Version"}];
			
			gfn_service({
			    async   : false,
			    url     : GV_CONTEXT_PATH + "/biz/obj.do",
			    data    : FORM_SEARCH,
			    success : function(data) {
			    	gfn_setMsCombo("versionId", data.versionList, [""], {allFlag:"Y"});
			    }
			},"obj");
		}
			
	};
	
	var fn_apply = function (sqlFlag) {
		// 디멘전 정리
		DIMENSION.user = [];
		DIMENSION.user.push({DIM_CD:"PROD_PART_NM", DIM_NM:'<spring:message code="lbl.prodPart2"   />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"VERSION_ID"  , DIM_NM:'<spring:message code="lbl.planVersion" />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"PRIORITY_OPTION"  , DIM_NM:'<spring:message code="lbl.priorityOption" />', LVL:10, DIM_ALIGN_CD:"C", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"PLAN_OPTION"  , DIM_NM:'<spring:message code="lbl.planOption" />', LVL:10, DIM_ALIGN_CD:"C", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"BAL_WEEK"  , DIM_NM:'<spring:message code="lbl.precedProdLimit" />', LVL:10, DIM_ALIGN_CD:"C", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"WO_RELEASE_WEEK"  , DIM_NM:'<spring:message code="lbl.woReleaseWeek" />', LVL:10, DIM_ALIGN_CD:"C", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"MEAS_NM"     , DIM_NM:'<spring:message code="lbl.category"    />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"UOM_NM"      , DIM_NM:'<spring:message code="lbl.unit"        />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:50});
		DIMENSION.user.push({DIM_CD:"ROUTING_ID"  , DIM_NM:'<spring:message code="lbl.routing"     />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:80});
		
		DIMENSION.hidden = [];
    	DIMENSION.hidden.push({CD:"COMPANY_CD"  , dataType:"text"});
    	DIMENSION.hidden.push({CD:"BU_CD"       , dataType:"text"});
    	DIMENSION.hidden.push({CD:"PLAN_ID"     , dataType:"text"});
    	DIMENSION.hidden.push({CD:"PROD_PART"   , dataType:"text"});
    	DIMENSION.hidden.push({CD:"MEAS_CD"     , dataType:"text"});
    	DIMENSION.hidden.push({CD:"UOM_CD"      , dataType:"text"});
		
    	planResultDetail.getBucket(sqlFlag);
		
		//조회조건 설정
    	FORM_SEARCH            = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
    	FORM_SEARCH.bucketList = BUCKET.query;
   		
    	planResultDetail.search();
	}
	
	function fn_getPlanId(pOption) {
		
		try {
			
			if ($("#planId").length == 0) {
				return;
			}
			
			var params = $.extend({
				_mtd     : "getList",
				tranData : [{outDs:"rtnList",_siq:"common.planId"}]
			}, pOption);
			
			gfn_service({
				url     : GV_CONTEXT_PATH + "/biz/obj.do",
				data    : params,
				async   : false,
				success : function(data) {
					
					gfn_setMsCombo("planId",data.rtnList,[""]);
					
					$("#planId").on("change", function(e) {
						var nowDate = null;
						var fDs = gfn_getFindDataDsInDs(data.rtnList, {CODE_CD : {VALUE : $(this).val(), CONDI : "="}});
						
						if (fDs.length > 0) {
							$("#cutOffFlag" ).val(fDs[0].CUT_OFF_FLAG);
						} 
						
					});
					
					$("#planId").trigger("change");
				}
			},"obj");
			
		} catch(e) {console.log(e);}
	}
	
	//6주 뒤 날짜 구함
    function weekdatecal(dt){
    	
    	yyyy = dt.substr(0, 4);
    	mm = dt.substr(4, 2);
    	dd = dt.substr(6, 2);
    	
    	var dt_stamp = new Date(yyyy+"-"+mm+"-"+dd).getTime();
    	
    	var days = ((7 * 18) -1); //6주후
		    toDt = new Date(dt_stamp+(days*24*60*60*1000));
		var rdt = toDt.getFullYear() + '' + (toDt.getMonth() + 1  < 10 ? '0' + (toDt.getMonth() + 1 ) : toDt.getMonth() + 1 ) + (toDt.getDate() < 10 ? '0' + toDt.getDate() : toDt.getDate());
	    
    	return rdt
    	
    }
	
	// onload 
	$(document).ready(function() {
		planResultDetail.init();
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
	   				{outDs : "authorityList", _siq : "aps.planResult.planResultDetailExcelSql"}
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
		<div class="pop_tit"><spring:message code="lbl.planSummaryDetail"/></div>
		<div class="popCont">
			<div class="srhwrap">
				<form id="searchForm" name="searchForm" method="POST" onSubmit="return false;">
				<div class="srhcondi">
				<ul>
					<li>
						<strong class="srhcondipop"><spring:message code="lbl.planId"/></strong>
						<div class="selectBox">
							<select id="planId" name="planId" class="iptcombo"></select>
							<input type='hidden' id='cutOffFlag' name='cutOffFlag'>
						</div>
					</li>
					<li>
						<strong class="srhcondipop"><spring:message code="lbl.prodPart2"/></strong>
						<div class="selectBox">
							<select id="prodPart" name="prodPart" multiple="multiple"></select>
						</div>
					</li>
					<li>
						<strong class="srhcondipop"><spring:message code="lbl.planVersion"/></strong>
						<div class="selectBox">
							<select id="versionId" name="versionId" multiple="multiple"></select>
						</div>
					</li>
					<li>
						<strong class="srhcondipop"><spring:message code="lbl.category"/></strong>
						<div class="selectBox">
							<select id="category" name="category" multiple="multiple"></select>
						</div>
					</li>
					
					<li id="excelSqlContainer" style="display:none;">
						<div class="locationext">
							<div class="fnc">
								<a href="#" id="excel" style="display:none" class="viewfnc5"><img src="${ctx}/statics/images/common/btn_gun5.gif" title="Excel Download"></a>
								<a href="#" id='sql' style="display:none"class="viewfnc4"><img src="${ctx}/statics/images/common/btn_gun4.gif" title="SQL View"></a>
							</div>
						</div>
					</li>
					
				</ul>
				</div>
				</form>
 				<div class="bt_btn">
					<a href="#" id="btnSearch" class="fl_app"><spring:message code="lbl.search"/></a>
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
				<a href="javascript:;" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
			</div>
		</div>
	</div>
</body>
</html>