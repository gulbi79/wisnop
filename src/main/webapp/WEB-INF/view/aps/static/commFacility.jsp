<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
<script type="text/javascript">
	var enterSearchFlag = "Y";
	
	var commFacility = {
		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.grid.initGrid();
			this.events();
		},
		
		_siq    : "aps.static.commFacility",
		
		meaList : [],
		
		paramMap : {
			cutOffFlag : "N"
		},
		
		comCode : {
			codeMapEx : null,
			codeMap   : null,
			initCode  : function() {
				var grpCd      = 'PROD_PART,CAMPUS_CD';
				this.codeMap   = gfn_getComCode(grpCd, 'Y'); 
				this.codeMapEx = gfn_getComCodeEx(["WORK_PLACES_CD"], null, {commFlag : "Y"});
			}
		},
		
		initFilter : function() {
			var upperWorkPlaces = {
				childId   : ["workplaces"],
				childData : [this.comCode.codeMapEx.WORK_PLACES_CD],
			};
			
			//Plan ID
	    	fn_getPlanId({picketType:"W",planTypeCd:"MP"});
			
			// 콤보박스
			gfn_setMsComboAll([
				{target : 'divProdPart'   , id : 'prodPart'   , title : '<spring:message code="lbl.prodPart2"/>'  , data : this.comCode.codeMap.PROD_PART, exData:[""], event: upperWorkPlaces},
				{target : 'divWorkplaces' , id : 'workplaces' , title : '<spring:message code="lbl.workplaces"/>' , data : this.comCode.codeMapEx.WORK_PLACES_CD, exData:[""]},
				{target : 'divCampus'     , id : 'campus'     , title : '<spring:message code="lbl.campus"/>'     , data : this.comCode.codeMap.CAMPUS_CD       , exData:[""]}
			]);
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
					//checkBar: { visible : true },
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
			
			$("#btnReset").on('click', function (e) {
				commFacility.grid.grdMain.cancel();
				commFacility.grid.dataProvider.rollback(commFacility.grid.dataProvider.getSavePoints()[0]);
			});
			
			$("#btnSave").on('click', function (e) {
				commFacility.save();
			});
			
			$("#btnBaseFac").on("click", function() {
				fn_openPopup();
			});
			
			this.grid.grdMain.onKeyUp = function (grid, key, ctrl, shift, alt) {
				if(key == 46){  //Delete Key
					gfn_selBlockDelete(grid, commFacility.grid.dataProvider, "cols");  
				}
			};
		},
		
		
		getBucket : function(sqlFlag) {
			var ajaxMap = {
				fromDate : gfn_replaceAll($("#fromCal").val(), "-", ""),
				toDate   : gfn_replaceAll($("#toCal").val(), "-", ""),
				day      : {isDown: "Y", isUp:"N", upCal:"N", isMt:"N", isExp:"N", expCnt:1},
				sqlId    : ["bucketDay"]
			}
			
			gfn_getBucket(ajaxMap);
			gfn_setCustBucket(this.meaList);
			
			if (!sqlFlag) {
				commFacility.grid.gridInstance.setDraw();
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
					
					//데이터
					if(id == "divPlanId"){
						EXCEL_SEARCH_DATA += $("#planId option:selected").text();
					}else if(id == "divProdPart"){
						$.each($("#prodPart option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
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
					}else if(id == "divCampus"){
						$.each($("#campus option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
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
				url     : GV_CONTEXT_PATH + "/biz/obj.do",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						commFacility.grid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						commFacility.grid.grdMain.cancel();
						
						commFacility.grid.dataProvider.setRows(data.resList);
						commFacility.grid.dataProvider.clearSavePoints();
						commFacility.grid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(commFacility.grid.dataProvider.getRowCount());
						//gfn_actionMonthSum(commFacility.grid.gridInstance);
						gfn_setRowTotalFixed(commFacility.grid.grdMain);
						
						commFacility.gridCallback(data.resList);
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		gridCallback : function(resList) {
			var saveYn = $("#saveYn").val();
			
			if(saveYn == "Y") {
				if(commFacility.paramMap.cutOffFlag == "N") {
					$.each(BUCKET.query, function(n, v) {
						commFacility.grid.grdMain.setColumnProperty(v.CD, "editable", true);
						commFacility.grid.grdMain.setColumnProperty(v.CD, "styles", {"background" : gv_editColor});
					});
				}
			}
		},
		
		save : function() {
			var grdData = gfn_getGrdSavedataAll(this.grid.grdMain);
			
			var grdDataLen = grdData.length;
			if (grdDataLen == 0) {
				alert('<spring:message code="msg.noChangeData"/>');
				return;
			}
			
			var rowData = [];
			var delData = [];
			
			$.each(grdData, function(i, row) {
				var delMap = {
					COMPANY_CD  : row.COMPANY_CD,
					BU_CD       : row.BU_CD,
					PLANT_CD    : row.PLANT_CD,
					RESOURCE_CD : row.RESOURCE_CD,
					state       : "deleted"
				};
				
				delData.push(delMap);
				
				$.each(BUCKET.query, function(n, v) {
					var bucketId     = v.BUCKET_ID;
					var yyyymmdd     = v.BUCKET_VAL;
					var prodPart     = gfn_replaceAll(bucketId, "D" + yyyymmdd + "_", "");
					var portion      = eval("row." + bucketId);
					
					if(portion != undefined) {
						var dataMap = {
							COMPANY_CD  : row.COMPANY_CD,
							BU_CD       : row.BU_CD,
							PLANT_CD    : row.PLANT_CD,
							RESOURCE_CD : row.RESOURCE_CD,
							YYYYMMDD    : yyyymmdd,
							PROD_PART   : prodPart,
							PORTION     : portion,
							state       : row.state
						};
						
						rowData.push(dataMap);
					}
				});
			});
			
			confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
				
				FORM_SAVE            = {}; //초기화
				FORM_SAVE._mtd       = "saveAll";
				FORM_SAVE.tranData   = [
					{outDs : "saveCnt1", _siq : commFacility._siq, grdData : delData},
					{outDs : "saveCnt2", _siq : commFacility._siq, grdData : rowData, mergeFlag : "Y"}
				];
				
				var ajaxOpt = {
					url     : GV_CONTEXT_PATH + "/biz/obj.do",
					data    : FORM_SAVE,
					success : function(data) {
						
						alert('<spring:message code="msg.saveOk"/>');
						fn_apply(false);
					},
				};
				
				gfn_service(ajaxOpt, "obj");
			});
			
		}
	};
	
	//조회
	var fn_apply = function (sqlFlag) {
		// 메져 조회
		fn_getMenuInit();
		
		// 디멘전 정리
		DIMENSION.user = [];
		DIMENSION.user.push({DIM_CD:"PROD_PART_NM", DIM_NM:'<spring:message code="lbl.prodPart2"      />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"WC_CD"       , DIM_NM:'<spring:message code="lbl.workplacesCode" />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"WC_NM"       , DIM_NM:'<spring:message code="lbl.workplacesName" />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"RESOURCE_CD" , DIM_NM:'<spring:message code="lbl.facilityCode"   />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"RESOURCE_NM" , DIM_NM:'<spring:message code="lbl.facilityName"   />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"CAMPUS_NM"   , DIM_NM:'<spring:message code="lbl.campus"         />', LVL:10, DIM_ALIGN_CD:"C", WIDTH:100});
		
		DIMENSION.hidden = [];
    	DIMENSION.hidden.push({CD:"COMPANY_CD"  , dataType:"text"});
    	DIMENSION.hidden.push({CD:"BU_CD"       , dataType:"text"});
    	DIMENSION.hidden.push({CD:"PLANT_CD"    , dataType:"text"});
		
		commFacility.getBucket(sqlFlag);
		
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
   		FORM_SEARCH.bucketList = BUCKET.query;
   		FORM_SEARCH.dimList    = DIMENSION.user;
   		
   		commFacility.paramMap.cutOffFlag = $("#searchForm #cutOffFlag").val();
   		commFacility.search();
   		commFacility.excelSubSearch();
	}
	
	function fn_getMenuInit() {
		var params = {};
		params._mtd   = "getList";
		params.tranData = [{outDs:"meaList",_siq:commFacility._siq + "Mea"}];
		gfn_service({
		    async: false,
		    url: GV_CONTEXT_PATH + "/biz/obj.do",
		    data:params,
		    success:function(data) {
		    	commFacility.meaList   = data.meaList;
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
							
							if(fDs[0].CUT_OFF_FLAG == 'N') {
							
							    var fromDt = new Date();
							    nowDate = fromDt.getFullYear() + '' + (fromDt.getMonth() + 1 < 10 ? '0' + (fromDt.getMonth() + 1) : fromDt.getMonth() + 1) + (fromDt.getDate() < 10 ? '0' + fromDt.getDate() : fromDt.getDate());
							} else {
								nowDate = fDs[0].APS_START_DATE;
							}									    
							
					        SW_END_DATE = weekdatecal(fDs[0].APS_START_DATE, 12);
						    DATEPICKET(null,nowDate,SW_END_DATE);
							
							var sdt = gfn_getStringToDate(fDs[0].APS_START_DATE);
							var edt = gfn_getStringToDate(fDs[0].APS_END_DATE);
							
							$("#fromCal").datepicker("option", "minDate",sdt);
							$("#fromCal").datepicker("option", "maxDate",edt);
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
    	
    	yyyy = dt.substr(0,4);
    	mm   = dt.substr(4,2);
    	dd   = dt.substr(6,2);
    	
    	var date = new Date(yyyy + "/" + mm + "/" + dd);
    	
    	date.setDate(date.getDate() + days);
    	
    	var rdt = date.getFullYear() + '' + ((date.getMonth() + 1)  < 10 ? '0' + (date.getMonth() + 1) : (date.getMonth() + 1) ) + (date.getDate() < 10 ? '0' + date.getDate() : date.getDate());
    	
    	return rdt;
    }
	
	function fn_openPopup() {
		gfn_comPopupOpen("BASE_PORTION", {
			rootUrl : "aps/static",
			url     : "basePortion",
			width   : 1036,
			height  : 680,
			menuCd  : "APS10901"
		});
	}
	

	// onload 
	$(document).ready(function() {
		commFacility.init();
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
					<input type='hidden' id='cutOffFlag' name='cutOffFlag'>
					<div class="view_combo" id="divProdPart"></div>
					<div class="view_combo" id="divWorkplaces"></div>
					<div class="view_combo" id="divCampus"></div>
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
				<div class="bleft">
					<a href="javascript:;" id="btnBaseFac" class="app1 roleWrite APS10901"><spring:message code="lbl.comPortion"/></a>
				</div>
				<div class="bright">
					<a href="javascript:;" id="btnReset" class="app1 roleWrite"><spring:message code="lbl.reset" /></a>
					<a href="javascript:;" id="btnSave"  class="app2 roleWrite"><spring:message code="lbl.save" /></a>
				</div>
			</div>
		</div>
    </div>
</body>
</html>