<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
<script type="text/javascript">
	var enterSearchFlag = "Y";
	
	var commFacilityOpRate = {
		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.grid.initGrid();
			this.events();
		},
		
		_siq    : "aps.planResult.commFacilityOpRate",
		
		headerMeaList : [],
		
		comCode : {
			codeMapEx : null,
			codeMap   : null,
			initCode  : function() {
				this.codeMapEx = gfn_getComCodeEx(["WORK_PLACES_CD"], null, {commFlag : "Y"});
			}
		},
		
		initFilter : function() {
			//Plan ID
	    	fn_getPlanId({picketType:"W",planTypeCd:"MP"});
			
	    	// 콤보박스
			gfn_setMsComboAll([
				{target : 'divWorkplaces' , id : 'workplaces' , title : '<spring:message code="lbl.workplaces"/>' , data : this.comCode.codeMapEx.WORK_PLACES_CD, exData:[""], option: {allFlag:"Y"}}
			]);
	    	
			fn_getVersionType();
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
			},
			
			setOptions : function() {
				this.grdMain.setOptions({
					stateBar: { visible : true }
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
		
		events : function () {
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
		},
		
		getBucket : function(sqlFlag) {
			var ajaxMap = {
				fromDate : $("#fromCal").val().replace(/-/g, ''),
				toDate   : $("#toCal"  ).val().replace(/-/g, ''),
				week     : {isDown: "Y", isUp : "N", upCal : "M", isMt : "N", isExp : "N", expCnt : 999},
				sqlId    : ["bucketFullWeek"]
			};
			
			gfn_getBucket(ajaxMap);
			
			
			BUCKET.all[0].push({ROOT_CD : "MTOTAL", CD : "WTOTAL", NM : "TOTAL", BUCKET_VAL : "TOTAL", BUCKET_ID : "TOTAL", BUCKET_TYPE : "FWEEK", TYPE : "group"});
			
			gfn_setCustBucket(this.headerMeaList);
			
			if (!sqlFlag) {
				commFacilityOpRate.grid.gridInstance.setDraw();
				
				$.each(BUCKET.query, function(n, v) {
					var bucketVal = v.BUCKET_VAL;
					
					if(bucketVal == "TOTAL") {
						commFacilityOpRate.grid.grdMain.setColumnProperty(v.CD, "styles", {background : "#ffe6a5"});
					}
					
					commFacilityOpRate.grid.grdMain.setColumnProperty(v.CD, "dynamicStyles", [
						{
		    				criteria : "(values['CATEGORY_CD'] = 'NEED_TIME')",
		    				styles   : {numberFormat : "#,##0"}
		    			},
		    			{
		    				criteria : "(values['CATEGORY_CD'] = 'AVAIL_TIME')",
		    				styles   : {numberFormat : "#,##0"}
		    			},
		    			{
		    				criteria : "(values['CATEGORY_CD'] = 'LOAD_FACTOR') and (value > 0)",
		    				styles   : {numberFormat : "#,##0", suffix: " %"}
		    			},
		    			{
		    				criteria : "(values['CATEGORY_CD'] = 'NEED_CNT')",
		    				styles   : {numberFormat : "#,##0.0"}
		    			},
		    			{
		    				criteria : "(values['CATEGORY_CD'] = 'ALLOC_CNT')",
		    				styles   : {numberFormat : "#,##0.0"}
		    			},
		    			
		    			{
                            criteria : "(values['CATEGORY_CD'] = 'NEED_TIME_DMD1')",
                            styles   : {numberFormat : "#,##0"}
                        },
                        {
                            criteria : "(values['CATEGORY_CD'] = 'NEED_TIME_DMD2')",
                            styles   : {numberFormat : "#,##0"}
                        },
                        {
                            criteria : "(values['CATEGORY_CD'] = 'NEED_TIME_DMD3')",
                            styles   : {numberFormat : "#,##0"}
                        },
		    			
		    			
		    			
					]);
				});
			}
		},
		
		excelSubSearch : function (){
			
			$.each($(".view_combo"), function(i, val){
				
				var temp = "";
				var id = gfn_nvl($(this).attr("id"), "");
				
				if(id != ""){
					
					var name = $("#" + id + " .ilist .itit").html();
					
					//타이틀
					if(i == 0){
						EXCEL_SEARCH_DATA = name + " : ";	
					}else{
						EXCEL_SEARCH_DATA += "\n" + name + " : ";	
					}
					
					if(id == "divPlanId"){
						EXCEL_SEARCH_DATA += $("#planId option:selected").text();
					}else if(id == "divWorkplaces"){
						$.each($("#workplaces option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divVersionType"){
						EXCEL_SEARCH_DATA += $("#versionType option:selected").text();
					}
				}
			});
			
			EXCEL_SEARCH_DATA += "\n" + '<spring:message code="lbl.period"/>' + " : ";
			EXCEL_SEARCH_DATA += $("#fromCal").val() + "(" + $("#fromPWeek").val() + ") ~ ";
			EXCEL_SEARCH_DATA += $("#toCal").val() + "(" + $("#toPWeek").val() + ")";
			
		},
		
		
		search : function () {
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq}];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						commFacilityOpRate.grid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						commFacilityOpRate.grid.grdMain.cancel();
						
						commFacilityOpRate.grid.dataProvider.setRows(data.resList);
						commFacilityOpRate.grid.dataProvider.clearSavePoints();
						commFacilityOpRate.grid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(commFacilityOpRate.grid.dataProvider.getRowCount());
						gfn_setRowTotalFixed(commFacilityOpRate.grid.grdMain);
						
					}
				}
			}
			gfn_service(aOption, "obj");
		}
	};
	
	//조회
	var fn_apply = function (sqlFlag) {
		
		var versionType = $("#versionType").val()
		
		if(versionType == "null"){
			alert('<spring:message code="msg.versionTypeMsg"/>');
			return;
		}
		
		// 메져 조회
		gfn_getMenuInit();
		
		// 헤더 메져 조회
		fn_getHeaderMenuInit();
		
		// 디멘전 정리
		DIMENSION.user = [];
		DIMENSION.user.push({DIM_CD:"WC_CD"        , DIM_NM:'<spring:message code="lbl.workplacesCode" />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"WC_NM"        , DIM_NM:'<spring:message code="lbl.workplacesName" />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"RESOURCE_CNT" , DIM_NM:'<spring:message code="lbl.resourceCnt"    />', LVL:10, DIM_ALIGN_CD:"R", WIDTH:100});
		
		DIMENSION.hidden = [];
    	DIMENSION.hidden.push({CD:"CATEGORY_CD"  , dataType:"text"});
		
		commFacilityOpRate.getBucket(sqlFlag);
		
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql           = sqlFlag;
   		FORM_SEARCH.bucketList    = BUCKET.query;
   		FORM_SEARCH.meaList       = MEASURE.user;
   		FORM_SEARCH.headerMeaList = commFacilityOpRate.headerMeaList;
   		FORM_SEARCH.dimList       = DIMENSION.user;
   		
   		commFacilityOpRate.search();
   		commFacilityOpRate.excelSubSearch();
	}
	
	function fn_getVersionType() {
		
		var params  = {};
		params._mtd = "getList";
		params.tranData = [{outDs : "resList", _siq : "aps.planResult.versionTypeCd"}];
		
		var opt = {
			url     : GV_CONTEXT_PATH + "/biz/obj",
			data    : params,
			async   : false,
			success : function(data) {
				
				data.resList.unshift({CODE_CD: null, CODE_NM: ""});
				gfn_setMsCombo("versionType", data.resList, [""]);
			}
		};
		gfn_service(opt, "obj");
	}
	
	function fn_getHeaderMenuInit() {
		var params = {};
		params._mtd   = "getList";
		params.tranData = [{outDs:"meaList",_siq : commFacilityOpRate._siq + "Mea"}];
		gfn_service({
		    async: false,
		    url: GV_CONTEXT_PATH + "/biz/obj",
		    data:params,
		    success:function(data) {
		    	commFacilityOpRate.headerMeaList   = data.meaList;
		    }
		},"obj");
	}
	
	function fn_getPlanId(pOption) {
		
		try {
			
			if ($("#planId").length == 0) {
				return;
			}
			
			var params = $.extend({
				_mtd     : "getList",
				tranData : [{outDs : "rtnList", _siq : "common.planId"}]
			}, pOption);
			
			gfn_service({
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : params,
				async   : false,
				success : function(data) {
					
					gfn_setMsCombo("planId",data.rtnList,[""]);
					
					$("#planId").on("change", function(e) {
						var nowDate = null;
						var fDs = gfn_getFindDataDsInDs(data.rtnList, {CODE_CD : {VALUE : $(this).val(), CONDI : "="}});
						
						if (fDs.length > 0) {
							
							nowDate = fDs[0].SW_START_DATE;						    
							
					        SW_END_DATE = weekdatecal(fDs[0].SW_START_DATE, 12);
						    DATEPICKET(null, nowDate, SW_END_DATE);
							
							var sdt = gfn_getStringToDate(fDs[0].SW_START_DATE);
							var edt = gfn_getStringToDate(fDs[0].SW_END_DATE);
							
							$("#fromCal").datepicker("option", "minDate", sdt);
							$("#fromCal").datepicker("option", "maxDate", edt);
							$("#toCal").datepicker("option", "maxDate", edt);
							$("#cutOffFlag" ).val(fDs[0].CUT_OFF_FLAG);
						} 
						
					});
					
					$("#planId").trigger("change");
				}
			},"obj");
			
		} catch(e) {console.log(e);}
	}
	
	function weekdatecal(dt, days){
    	
    	yyyy = dt.substr(0, 4);
    	mm   = dt.substr(4, 2);
    	dd   = dt.substr(6, 2);
    	
    	var date = new Date(yyyy + "/" + mm + "/" + dd);
    	
    	date.setDate(date.getDate() + days);
    	
    	var rdt = date.getFullYear() + '' + ((date.getMonth() + 1)  < 10 ? '0' + (date.getMonth() + 1) : (date.getMonth() + 1) ) + (date.getDate() < 10 ? '0' + date.getDate() : date.getDate());
    	
    	return rdt;
    }
	
 	// onload 
	$(document).ready(function() {
		commFacilityOpRate.init();
	});
</script>
</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="a" class="split content split-horizontal">
		<form id="searchForm" name="searchForm">
		<div id="filterDv">
			<div class="inner">
				<h3>Filter</h3>
				<div class="tabMargin"></div>
				<div class="scroll">
					<div class="view_combo" id="divPlanId">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.planId"/></div>
							<div class="iptdv borNone">
								<select id="planId" name="planId" class="iptcombo"></select>
							</div>
						</div>
					</div>
					<div class="view_combo" id="divVersionType">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.versionType2"/></div>
							<div class="iptdv borNone">
								<select id="versionType" name="versionType" class="iptcombo"></select>
							</div>
						</div>
					</div>
					<input type='hidden' id='cutOffFlag' name='cutOffFlag'>
					<div class="view_combo" id="divWorkplaces"></div>
					<jsp:include page="/WEB-INF/view/common/filterViewHorizon.jsp" flush="false" />
				</div>
				<div class="bt_btn">
					<a href="#" class="fl_app" id="btnSearch"><spring:message code="lbl.search"/></a>
				</div>
			</div>
		</div>
		</form>
	</div>
	
	<!-- contents -->
	<div id="b" class="split split-horizontal">
		<div id="grid1" class="fconbox">
			<%@ include file="/WEB-INF/view/common/commonLocation.jsp" %>
			<div class="scroll">
				<!-- 그리드영역 -->
				<div id="realgrid" style="width: 100%;" class="realgrid1"></div>
			</div>
			<div class="cbt_btn">
			</div>
		</div>
    </div>
</body>
</html>