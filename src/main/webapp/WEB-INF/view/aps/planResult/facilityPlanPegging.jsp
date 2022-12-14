<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	
	<script type="text/javascript">
	var enterSearchFlag = "Y";
	var dataPlanVersion;
	var facilityPlanPegging = {

		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.facilityPlanPeggingGrid.initGrid();
			this.events();
		},
			
		_siq    : "aps.planResult.facilityPlanPeggingList",
		 
		initFilter : function() {
			
			var planTypeCdOption = [{CODE_CD : "MP", CODE_NM : "<spring:message code="lbl.weekly"/>"},{CODE_CD : "FP", CODE_NM : "<spring:message code="lbl.daily"/>"}];
			gfn_setMsCombo("planTypeCd", planTypeCdOption,[""]);
			
			var pTypeCd = $("#planTypeCd").val(); 
			
			$("#planTypeCd").on("change", function(e) {
				 var pTypeCd = $("#planTypeCd").val();
				 gfn_getPlanIdwc({picketType : "W", planTypeCd : pTypeCd});
			});
			
			gfn_keyPopAddEvent([
				{ target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>' }
			]);
			
			gfn_setMsComboAll([
				{ target : 'divPlanId'      , id : 'planId', title : '<spring:message code="lbl.planId2"/>', data : this.comCode.codeMap.PLAN_ID, exData:[''], type : "S" },  
				{ target : 'divProdPart'    , id : 'prodPart', title : '<spring:message code="lbl.prodPart"/>', data : this.comCode.codeMap.PROD_PART, exData:["*"], type : "S"},
				{ target : 'divPlanVersion' , id : 'planVersion', title : '<spring:message code="lbl.planVersion2"/>', data : "", exData:["*"], type : "S"},
				{ target : 'divItemGroup'   , id : 'itemGroup'  , title : '<spring:message code="lbl.itemGroup"/>'   , data : this.comCode.codeMapEx.ITEM_GROUP, exData:["*"] },
				{ target : 'divRoute'       , id : 'route'      , title : '<spring:message code="lbl.routing"/>'     , data : "",    exData:["*"] },
			]);
			
			$("#planId").change(function() {
				
				var planId = $("#planId").val();
				var prodPart = $("#prodPart").val();
				var planIdArray = facilityPlanPegging.comCode.codeMap.PLAN_ID;
				
				$.each(planIdArray, function(i, val){
					
					var codeCd = val.CODE_CD;
					
					if(planId == codeCd){
						var startDay = val.START_DAY;
						var endDay = val.END_DAY;
						var closeDay = val.CLOSE_DAY;
						
						var tStartDay = startDay.substring(0, 4) + "-" + startDay.substring(4, 6) + "-" + startDay.substring(6, 8);
						var tCloseDay = closeDay.substring(0, 4) + "-" + closeDay.substring(4, 6) + "-" + closeDay.substring(6, 8);
						
						datePickerOption = DATEPICKET(null, startDay, endDay);
						$("#fromCal").datepicker("option", "minDate", tStartDay);
						
						return false;
					}
				});
			});
			
			$("#prodPart,#planId").change(function() {
				fn_planVersionChg();
			});  
			
			$("#prodPart,#planId,#planVersion").change(function() {
				
				var planId = $("#planId").val();
				var prodPart = gfn_nvl($("#prodPart").val(), "");
				var planVersion = gfn_nvl($("#planVersion").val(), "");
				
				if(planVersion != ""){
					gfn_service({
						async   : false,
						url     : GV_CONTEXT_PATH + "/biz/obj",
						data    : {_mtd : "getList", planId : planId, prodPart : prodPart, planVersion : planVersion, tranData:[
							{outDs : "routingId", _siq : "aps.planResult.routingIdPegging"},
						]},
						success : function(data) {
							gfn_setMsCombo("route", data.routingId, [""]);
						}
					}, "obj");
					
					$.each(dataPlanVersion, function(i, val){
						
						var codeCd = val.CODE_CD;
						var versionTypeCd = val.VERSION_TYPE_CD;
						
						if(planVersion == codeCd){
							$("#versionTypeCd").val(versionTypeCd);
							return false;
						}
					});
				}
			});
		},
		
		/*
		* common Code 
		*/
		comCode : {
			codeMapEx : null,			
			codeMap : null,
			
			initCode : function () {
				
				var grpCd = "PROD_PART";
				this.codeMap = gfn_getComCode(grpCd, 'Y'); 
				this.codeMapEx = gfn_getComCodeEx(["ITEM_GROUP"], null, {});
				this.codeMap.PROD_PART[0].CODE_NM = "";
				
				gfn_service({
					async   : false,
					url     : GV_CONTEXT_PATH + "/biz/obj",
					data    : {_mtd : "getList", tranData:[
						{outDs : "planList", _siq : "aps.planResult.planIdPegging"},
					]},
					success : function(data) {
						
						facilityPlanPegging.comCode.codeMap.PLAN_ID = data.planList;
						
						var startDay = data.planList[0].START_DAY;
						var endDay = data.planList[0].END_DAY;
						var closeDay = data.planList[0].CLOSE_DAY;
						
						var tStartDay = startDay.substring(0, 4) + "-" + startDay.substring(4, 6) + "-" + startDay.substring(6, 8);
						var tCloseDay = closeDay.substring(0, 4) + "-" + closeDay.substring(4, 6) + "-" + closeDay.substring(6, 8);
						
						datePickerOption = DATEPICKET(null, startDay, endDay);
						$("#fromCal").datepicker("option", "minDate", tStartDay);
					}
				}, "obj");
			}
		},
	
		/* 
		* grid  ??????
		*/
		facilityPlanPeggingGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
			},
		},
	
		/*
		* event ??????
		*/
		events : function () {
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("#divPlanVersion .itit").click("on", function() { 
	    		fn_planVersionChg();
	    	});
	    	
	    	$("#divPlanVersion .itit").css("cursor", "pointer");
		},
		
		excelSubSearch : function (){
			
			$.each($(".view_combo"), function(i, val){
				
				var temp = "";
				var id = gfn_nvl($(this).attr("id"), "");
				
				if(id != ""){
					
					var name = $("#" + id + " .ilist .itit").html();
					
					//?????????
					if(i == 0){
						EXCEL_SEARCH_DATA = name + " : ";	
					}else{
						EXCEL_SEARCH_DATA += "\n" + name + " : ";	
					}
					
					if(id == "divPlanTypeCd"){
						EXCEL_SEARCH_DATA += $("#planTypeCd option:selected").text();
					}else if(id == "divPlanId"){
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
					}else if(id == "divPlanVersion"){
						EXCEL_SEARCH_DATA += $("#planVersion option:selected").text();
					}else if(id == "divPriorityPe"){
						EXCEL_SEARCH_DATA += $("#priority").val();
					}else if(id == "divDemandId"){
						EXCEL_SEARCH_DATA += $("#demandId").val();
					}else if(id == "divProdOrderNo"){
						EXCEL_SEARCH_DATA += $("#prodOrderNo").val();
					}else if(id == "divJobCd"){
						EXCEL_SEARCH_DATA += $("#jobCd").val();
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
					}else if(id == "divItem"){
						EXCEL_SEARCH_DATA += $("#item_nm").val();
					}else if(id == "divWcNm"){
						EXCEL_SEARCH_DATA += $("#wcNm").val();
					}else if(id == "divResourceNm"){
						EXCEL_SEARCH_DATA += $("#resourceNm").val();
					}else if(id == "divWorkerGroupNm"){
						EXCEL_SEARCH_DATA += $("#workerGroupNm").val();
					}
				}
			});
			
			EXCEL_SEARCH_DATA += "\n" + '<spring:message code="lbl.period"/>' + " : ";
			EXCEL_SEARCH_DATA += $("#fromCal").val() + "(" + $("#fromWeek").val() + ") ~ ";
			EXCEL_SEARCH_DATA += $("#toCal").val() + "(" + $("#toWeek").val() + ")";
			
		},
		
		// ??????
		search : function () {
			
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq }];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						
						
						facilityPlanPegging.facilityPlanPeggingGrid.dataProvider.clearRows(); //????????? ?????????
						
						//????????? ????????? ??????
						facilityPlanPegging.facilityPlanPeggingGrid.grdMain.cancel();
						
						facilityPlanPegging.facilityPlanPeggingGrid.dataProvider.setRows(data.resList);
						facilityPlanPegging.facilityPlanPeggingGrid.dataProvider.clearSavePoints();
						facilityPlanPegging.facilityPlanPeggingGrid.dataProvider.savePoint(); //????????? ????????? ??????
						gfn_setSearchRow(facilityPlanPegging.facilityPlanPeggingGrid.dataProvider.getRowCount());
						gfn_setRowTotalFixed(facilityPlanPegging.facilityPlanPeggingGrid.grdMain);
						
						fn_setHeaderColor();
					}
				}
			}
			gfn_service(aOption, "obj");
		}
	};
	

	//??????
	var fn_apply = function (sqlFlag) {
		
		var tmpProd = gfn_nvl($("#prodPart").val(), "");
		var tmpPlanVersion = gfn_nvl($("#planVersion").val(), "");
		
		if(tmpProd == ""){
			alert('<spring:message code="msg.prodPartMsg"/>');
			return;
		} 
		
		if(tmpPlanVersion == ""){
			alert('<spring:message code="msg.planVersionMsg"/>');
			return;
		} 
		
		// ?????????, ??????
		gfn_getMenuInit();
		
    	if(!sqlFlag){
    		facilityPlanPegging.facilityPlanPeggingGrid.gridInstance.setDraw();
    		fn_setNumberFields();
		}
    	
		//???????????? ??????
    	FORM_SEARCH = $("#searchForm").serializeObject(); //?????????
    	FORM_SEARCH.sql        = sqlFlag;
    	FORM_SEARCH.dimList    = DIMENSION.user;
    	//FORM_SEARCH.hiddenList = DIMENSION.hidden;
    	
		if (!sqlFlag) {
			
			var fileds = facilityPlanPegging.facilityPlanPeggingGrid.dataProvider.getFields();
			
			for (var i = 0; i < fileds.length; i++) {
					
				if (fileds[i].fieldName == 'START_DTTM_NM' || fileds[i].fieldName == 'END_DTTM_NM' || fileds[i].fieldName == 'PRE_COMPLETION_DTTM_NM') {
					
					fileds[i].dataType = "datetime";
					fileds[i].datetimeFormat = "yyyy-MM-dd HH:mm:ss";
					
					facilityPlanPegging.facilityPlanPeggingGrid.grdMain.setColumnProperty(fileds[i].fieldName, "styles", {"datetimeFormat" : "yyyy-MM-dd HH:mm:ss"});
				}
				
				facilityPlanPegging.facilityPlanPeggingGrid.dataProvider.setFields(fileds);
			}
		}
		facilityPlanPegging.search();
		facilityPlanPegging.excelSubSearch();
	}
	
	function fn_setHeaderColor(){
		
		var fileds = facilityPlanPegging.facilityPlanPeggingGrid.dataProvider.getFields();
		var filedsLen = fileds.length;
		
		for (var i = 0; i < filedsLen; i++) {
			
			var fieldName = fileds[i].fieldName;
			var param = fieldName + "_NM";
			
			if(fieldName == "WC_MGR" || fieldName == "FIXED_MRP_QTY" || fieldName == "PROD_GROUP_DET" || fieldName == "WAIT_TIME" || fieldName == "WORK_TIME" || fieldName == "MOVE_TIME" || fieldName == "MAIN_WORKER" ||
			   fieldName == "LOT_SIZE" || fieldName == "KEY_MAT_YN" || fieldName == "KEY_MAT_LT" || fieldName == "OVEN_AREA" || fieldName == "RESOURCE_EFF_RATE" || fieldName == "OFFSET_TIME" || fieldName == "TOTAL_WORKER"){
				
				var setHeader = facilityPlanPegging.facilityPlanPeggingGrid.grdMain.getColumnProperty(param, "header");
				setHeader.styles = {background: "#FAED7D"};
				facilityPlanPegging.facilityPlanPeggingGrid.grdMain.setColumnProperty(param, "header", setHeader);
			}
			
			if(fieldName == "PROD_QTY"){
				facilityPlanPegging.facilityPlanPeggingGrid.grdMain.setColumnProperty(param, "mergeRule", {criteria:"row div 1"})
			}
			if(fieldName == "AP_PRIORITY_NM"){
				facilityPlanPegging.facilityPlanPeggingGrid.grdMain.setColumnProperty(param, "mergeRule", {criteria:"value"})
			}
		}
	}
	
	function fn_setNumberFields(){
		
		var fileds = facilityPlanPegging.facilityPlanPeggingGrid.dataProvider.getFields();
		var filedsLen = fileds.length;
		
		for (var i = 0; i < filedsLen; i++) {
			
			var fieldName = fileds[i].fieldName;
			
			if(fieldName == "AP_PRIORITY_NM" || fieldName == "ADJ_PRIORITY2_NM" || fieldName == "WIP_PRIORITY_NM"){
				
				fileds[i].dataType = "number";
				facilityPlanPegging.facilityPlanPeggingGrid.grdMain.setColumnProperty(fieldName, "styles", {"numberFormat" : "#,##0"});
				facilityPlanPegging.facilityPlanPeggingGrid.grdMain.setColumnProperty(fieldName, "mergeRule", {criteria:"value"})
			}
		}
		
		facilityPlanPegging.facilityPlanPeggingGrid.dataProvider.setFields(fileds);
	}
	
	function fn_planVersionChg(){
		var planId = $("#planId").val();
		var prodPart = gfn_nvl($("#prodPart").val(), "");
		
		if(prodPart != ""){
			gfn_service({
				async   : false,
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : {_mtd : "getList", planId : planId, prodPart : prodPart, tranData:[
					{outDs : "planVersion", _siq : "aps.planResult.planVersionPegging"},
				]},
				success : function(data) {
					
					dataPlanVersion = data.planVersion;
					
					gfn_setMsCombo("planVersion", data.planVersion, [""]);
					
					$.each(data.planVersion, function(i, val){
						
						var codeCd = val.CODE_CD;
						var cutOffFlag = val.CUT_OFF_FLAG;
						var versionTypeCd = val.VERSION_TYPE_CD;
						
						if(cutOffFlag == "Y" && versionTypeCd == "M"){
							$("#planVersion option:eq("+ i +")").css("color", gv_redColor);
							return false;
						}
					});
				}
			}, "obj");
		}	
	}
	
	function gfn_getPlanIdwc(pOption) {
		
		try {
			
			if ($("#planId").length == 0) {
				return;
			}
			
			var params = $.extend({
				_mtd     : "getList",
				tranData : [{outDs:"rtnList",_siq:"common.planId"}, {outDs : "defaultList", _siq : "common.planIdFp"}]
			}, pOption);
			
			gfn_service({
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : params,
				async   : false,
				success : function(data) {
					
					var planTypeCd = $("#planTypeCd").val();
					
					gfn_setMsCombo("planId", data.rtnList, [""]);
					
					if(planTypeCd == "FP"){
						var defaultPlanId = data.defaultList[0].PLAN_ID;
						$("#planId").val(defaultPlanId);	
					}
					
					$("#planId").on("change", function(e) {
						
						var nowDate;
						var fDs = gfn_getFindDataDsInDs(data.rtnList, {CODE_CD : {VALUE : $(this).val(), CONDI : "="}});
						
						if (fDs.length > 0) {
							
							if(fDs[0].PLAN_TYPE_CD == "FP"){
								startDay = fDs[0].FP_START_DATE;
								endDay = fDs[0].FP_END_DATE;
							}else{
								startDay = fDs[0].APS_START_DATE;
								endDay = weekdatecal(fDs[0].APS_START_DATE);
							}
						    DATEPICKET(null, startDay, endDay);
						    
						    var tStartDay = startDay.substring(0, 4) + "-" + startDay.substring(4, 6) + "-" + startDay.substring(6, 8);
							$("#fromCal").datepicker("option", "minDate", tStartDay);
						    
							$("#releaseflag").val(fDs[0].RELEASE_FLAG);
						} 
					});
					$("#planId").trigger("change");
				}
			},"obj");
			
		} catch(e) {console.log(e);}
	}
	
	//2??? ??? ?????? ??????
    function weekdatecal(dt){
    	
    	yyyy = dt.substr(0, 4);
    	mm = dt.substr(4, 2);
    	dd = dt.substr(6, 2);
    	
    	var dt_stamp = new Date(yyyy+"-"+mm+"-"+dd).getTime();
    	
    	var days = ((7 * 3) -1); //2??????
		    toDt = new Date(dt_stamp+(days*24*60*60*1000));
		var rdt = toDt.getFullYear() + '' + (toDt.getMonth() + 1  < 10 ? '0' + (toDt.getMonth() + 1 ) : toDt.getMonth() + 1 ) + (toDt.getDate() < 10 ? '0' + toDt.getDate() : toDt.getDate());
	    
    	return rdt
    	
    }
	
	$(document).ready(function() {
		facilityPlanPegging.init();
	});
	
	
	</script>

</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="a" class="split content split-horizontal">
		<form id="searchForm" name="searchForm">
		<input type="hidden" id="versionTypeCd" name="versionTypeCd" value=""/>
		
		<div id="filterDv">
			<div class="inner">
				<h3>Filter</h3>
				<div class="tabMargin"></div>
				<div class="scroll">
					<div class="view_combo" id="divPlanTypeCd">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.plantypeCd"/></div>
							<div class="iptdv borNone">
								<select id="planTypeCd" name="planTypeCd" class="iptcombo"></select>
							</div>
						</div>
                    </div>
					<div class="view_combo" id="divPlanId"></div>
					<div class="view_combo" id="divProdPart"></div>
					<div class="view_combo" id="divPlanVersion"></div>
					<div class="view_combo" id="divPriorityPe">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.priorityPe"/></div>
							<input type="text" id="priority" name="priority" class="ipt"/>
						</div>
					</div>
					<div class="view_combo" id="divDemandId">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.demandId2"/></div>
							<input type="text" id="demandId" name="demandId" class="ipt"/>
						</div>
					</div>
					<div class="view_combo" id="divProdOrderNo">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.prodOrderNo2"/></div>
							<input type="text" id="prodOrderNo" name="prodOrderNo" class="ipt"/>
						</div>
					</div>
					
					<div class="view_combo" id="divJobCd">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.jobCd"/></div>
							<input type="text" id="jobCd" name="jobCd" class="ipt"/>
						</div>
					</div>
					
					<div class="view_combo" id="divItemGroup"></div>
					<div class="view_combo" id="divRoute"></div>
					<div class="view_combo" id="divItem"></div>
					
					<div class="view_combo" id="divWcNm">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.workplacesName"/></div>
							<input type="text" id="wcNm" name="wcNm" class="ipt"/>
						</div>
					</div>
					
					<div class="view_combo" id="divResourceNm">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.resourceNm_ALL"/></div>
							<input type="text" id="resourceNm" name="resourceNm" class="ipt"/>
						</div>
					</div>
					
					<div class="view_combo" id="divWorkerGroupNm">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.wcNm_LABORL"/></div>
							<input type="text" id="workerGroupNm" name="workerGroupNm" class="ipt"/>
						</div>
					</div>
					<jsp:include page="/WEB-INF/view/common/filterViewHorizon.jsp" flush="false">
						<jsp:param name="radioYn" value="N" />
						<jsp:param name="wType" value="SW" />
					</jsp:include>
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
				<!-- ??????????????? -->
				<div id="realgrid" style="width: 100%;" class="realgrid1"></div>
			</div>
			<div class="cbt_btn" style="height:25px">
				<div class="bright">
				</div>
			</div>
		</div>
    </div>
</body>
</html>
