<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	
	<script type="text/javascript">

	var enterSearchFlag = "Y";
	var wip = {

		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.wipGrid.initGrid();
			this.events();
		},
			
		_siq    : "aps.dynamic.wip",
		/*
		* common Code 
		*/
		comCode : {
			codeMapEx : null,			
			codeMap : null,
			
			initCode : function () {
				var grpCd = 'ITEM_TYPE,WORKER_GROUP,ORDER_STATUS,FLAG_YN';
				this.codeMap = gfn_getComCode(grpCd, 'Y'); 
				this.codeMapEx = gfn_getComCodeEx(["ROUTING", "ITEM_GROUP","WORK_PLACES_CD" ], null, {itemType : "10,20,50"});
			}
		},
		
		initFilter : function() {
			
			gfn_keyPopAddEvent([
				{ target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>' }
			]);
			
			//Plan ID
	    	fn_getPlanId({picketType : "W", planTypeCd : "MP"});
			//Version Type
			fn_getVersionType();
			
			gfn_setMsComboAll([
				
				{ target : 'divItemGroup', id : 'itemGroup', title : '<spring:message code="lbl.itemGroup"/>', data : this.comCode.codeMapEx.ITEM_GROUP, exData:["*"] },
				{ target : 'divRoute', id : 'route', title : '<spring:message code="lbl.routing"/>', data : this.comCode.codeMapEx.ROUTING, exData:["*"] },
				{ target : 'divItemType', id : 'itemType', title : '<spring:message code="lbl.itemType"/>', data : this.comCode.codeMap.ITEM_TYPE, exData:[""], option: {allFlag:"Y"}},
				{ target : 'divCleanYn', id : 'cleanYn', title : '<spring:message code="lbl.cleanYn"/>', data : this.comCode.codeMap.FLAG_YN, exData:["*"], type : "S"},
				{ target : 'divWorkerGroup', id : 'workerGroup', title : '<spring:message code="lbl.workerGroup"/>', data : this.comCode.codeMap.WORKER_GROUP, exData:[""]},
				{ target : 'divWoStatus', id : 'woStatus', title : '<spring:message code="lbl.woStatus"/>', data : this.comCode.codeMap.ORDER_STATUS, exData:[""]},
				/* { target : 'divWorkplaces', id : 'workplaces', title : '<spring:message code="lbl.workplaces"/>', data : this.comCode.codeMapEx.WORK_PLACES_CD, exData:[""]} */
			]);
			
			var dateParam = {
				arrTarget : [
					{calId : "fromCal", weekId : "fromWeek", defVal : 0},
					{calId : "toCal", weekId : "toWeek", defVal : 1}
				]
			};
			DATEPICKET(dateParam);
			$('#fromCal').datepicker("option", "maxDate", new Date().getWeekDay(0, false));
			
			dayDate();
			
			$("#planId,#versionType").change(function() {
				
				var planId = $("#planId").val();
				var versionType = $("#versionType").val();
				
				if(planId != null && versionType != null && planId != "null" && versionType != "null"){
					var params  = {};
					params.planId = planId;
					params.versionType = versionType;
					params._mtd = "getList";
					params.tranData = [{outDs : "resList", _siq : "aps.dynamic.wipDate"}];
					
					var opt = {
						url     : GV_CONTEXT_PATH + "/biz/obj",
						data    : params,
						async   : false,
						success : function(data) {
							
							if(gfn_isNull(data.resList)){
								return;
							}
							var wipDate = data.resList[0].WIP_DATE;
							
							DATEPICKET(null, wipDate);
							
							var d = new Date();
						    var dayOfMonth = d.getDate();
						    d.setDate(dayOfMonth - 14);
						    
							$("#fromCal").datepicker("option", "minDate", d);
						}
					};
					gfn_service(opt, "obj");
				}
			})
		},
		 
		/* grid  선언
		*/
		wipGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				
				this.grdMain.setOptions({
					stateBar: { visible : true },
				});
				
				this.grdMain.addCellStyles([{
					id         : "editStyle",
					editable   : true,
					background : gv_editColor
				}]);
				
				this.grdMain.addCellStyles([{
					id         : "noneEditStyle",
					editable   : false,
					background : gv_noneEditColor
				}]);
			},
		},
	
		/*
		* event 정의
		*/
		events : function () {
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
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
					
					
					if(id == "divStandDate"){
						EXCEL_SEARCH_DATA += $("#fromCal").val() + "(" + $("#fromWeek").val() + ")";
					}else if(id == "divItem"){
						EXCEL_SEARCH_DATA += $("#item_nm").val();
					}else if(id == "divItemType"){
						$.each($("#itemType option:selected"), function(i2, val2){
							
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
					}else if(id == "divCleanYn"){
						EXCEL_SEARCH_DATA += $("#cleanYn option:selected").text();
					}else if(id == "divWoNo"){
						EXCEL_SEARCH_DATA += $("#woNo").val();
					}else if(id == "divParentWoNo"){
						EXCEL_SEARCH_DATA += $("#parentWoNo").val();
					}else if(id == "divWoStatus"){
						$.each($("#woStatus option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divWorkerGroup"){
						$.each($("#workerGroup option:selected"), function(i2, val2){
							
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
					}else if(id == "divPlanId"){
						EXCEL_SEARCH_DATA += $("#planId option:selected").text();
					}else if(id == "divVersionType"){
						EXCEL_SEARCH_DATA += $("#versionType option:selected").text();
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
						wip.wipGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						wip.wipGrid.grdMain.cancel();
						
						wip.wipGrid.dataProvider.setRows(data.resList);
						wip.wipGrid.dataProvider.clearSavePoints();
						wip.wipGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(wip.wipGrid.dataProvider.getRowCount());
						gfn_setRowTotalFixed(wip.wipGrid.grdMain);
						
						fn_setHeaderColor();
					}
				}
			}
			
			gfn_service(aOption, "obj");
		}
	};

	//조회
	var fn_apply = function (sqlFlag) {
		
		gfn_getMenuInit();
		
    	if(!sqlFlag){
    		wip.wipGrid.gridInstance.setDraw();
		}		
		//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
    	FORM_SEARCH.dimList    = DIMENSION.user;
    	FORM_SEARCH.hiddenList = DIMENSION.hidden;
    	FORM_SEARCH.meaList	   = MEASURE.next;
    	
		if (!sqlFlag) {
			
			var fileds = wip.wipGrid.dataProvider.getFields();
			for (var i = 0; i < fileds.length; i++) {
				if (fileds[i].fieldName == 'SS_QTY_NM' || fileds[i].fieldName == 'MFG_LT_NM'|| fileds[i].fieldName == 'ITEM_COST_KRW_NM') {
					fileds[i].dataType = "number";
					fileds[i].numberFormat = "#,##0";
					
					wip.wipGrid.grdMain.setColumnProperty(fileds[i].fieldName, "styles", {"numberFormat" : "#,##0"});	
				}
			}
			wip.wipGrid.dataProvider.setFields(fileds);
		}
		wip.search();
		wip.excelSubSearch();
	}
	
	function fn_setHeaderColor(){
		
		var fileds = wip.wipGrid.dataProvider.getFields();
		var filedsLen = fileds.length;
		
		for (var i = 0; i < filedsLen; i++) {
			
			var fieldName = fileds[i].fieldName;
			var param = fieldName + "_NM";
			
			if(fieldName == "EXP_ORDER_STATUS" || fieldName == "EXP_JOB_CD" || fieldName == "EXP_JOB_NM" ||
					fieldName == "EXP_JOB_STATUS" || fieldName == "EXP_REMAIN_QTY" || fieldName == "EXP_CAMPUS_NM"){
				
				var setHeader = wip.wipGrid.grdMain.getColumnProperty(param, "header");
				setHeader.styles = {background: "#FAED7D"};
				wip.wipGrid.grdMain.setColumnProperty(param, "header", setHeader);
			}
		}
		
		//재공 가용여부 색깔주기
		var editStyle = {};
		var val = gfn_getDynamicStyle(-2);
		
		editStyle.background = gv_headerColor;
		editStyle.editable = false;
		
		val.criteria.push("(values['AVAIL_FLAG_NM_NM'] = 'N')");
		val.styles.push(editStyle);
		
		wip.wipGrid.grdMain.setColumnProperty(wip.wipGrid.grdMain.columnByField("AVAIL_FLAG_NM_NM"), "dynamicStyles", [val]);
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
					
					data.rtnList.unshift({CODE_CD: null, CODE_NM: ""});
					gfn_setMsCombo("planId", data.rtnList, [""]);
					
				}
			},"obj");
			
		} catch(e) {console.log(e);}
	}
	
	function fn_getVersionType() {
		
		var params  = {};
		params._mtd = "getList";
		params.tranData = [{outDs : "resList", _siq : "aps.dynamic.versionTypeCd"}];
		
		
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
	
	function dayDate(){
		
		var params  = {};
		params._mtd = "getList";
		params.tranData = [{outDs : "resList", _siq : "aps.planResult.commonDay"}];
		
		var opt = {
			url     : GV_CONTEXT_PATH + "/biz/obj",
			data    : params,
			async   : false,
			success : function(data) {
				
				var list = data.resList;
				var listLen = list.length;
				
				for(var i = 0; i < listLen; i++){
					
					var codeCd = list[i].CODE_CD;
					var attb1Cd = list[i].ATTB_1_CD;
					
					setDayDeat(codeCd, attb1Cd);
				}
			    var d = new Date();
			    var dayOfMonth = d.getDate();
			    d.setDate(dayOfMonth - 21);
			    var d1 = new Date();
			  
			    $("#fromCal").datepicker("option", "minDate", d);
			    $("#fromCal").datepicker("option", "maxDate", d1);
			    $("#planId").val(null);
			    $("#versionType").val(null);
			}
		};
		gfn_service(opt, "obj");
	}
	
	function setDayDeat(type, val){
		var paramFrom = $("#swFromDate").val().replace("-", "");
		var paramTo = $("#swToDate").val().replace("-", "");
		
		var dataFrom = paramFrom.substring(0, 4) + "/" + paramFrom.substring(4, 6) + "/" + paramFrom.substring(6, 8);
		var dataTo = paramTo.substring(0, 4) + "/" + paramTo.substring(4, 6) + "/" + paramTo.substring(6, 8);
		
		var date = new Date(dataFrom);
		var date2 = new Date(dataTo);
		
		date.setDate(date.getDate() + Number(val));
	    date2.setDate(date2.getDate() + Number(val));
	    
	    		
		var year = date.getFullYear();
	    var month = date.getMonth() + 1;
	    var day = date.getDate();
	    
	    var year2 = date2.getFullYear();
	    var month2 = date2.getMonth() + 1;
	    var day2 = date2.getDate();
	    
	    if(month < 10){
	    	month = "0" + month;
	    }
	    
	    if(day < 10){
	    	day = "0" + day;
	    }
	    
	    if(month2 < 10){
	    	month2 = "0" + month2;
	    }
	    
	    if(day2 < 10){
	    	day2 = "0" + day2;
	    }
	    
	}

	$(document).ready(function() {
		wip.init();
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
					<div class="view_combo" id="divStandDate">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.standDate"/></div>
							<input type="text" id="fromCal" name="fromCal" class="iptdate datepicker2" onchange="javascript:dayDate();"/>
							<input type="text" id="fromWeek" name="fromWeek" class="iptdateweek" disabled="disabled" value=""/>
							<input type="hidden" id="toCal" name="toCal"/>
							<input type="hidden" id="toWeek" name="toWeek"/>
							<input type="hidden" id="swFromDate" name="swFromDate"/>
							<input type="hidden" id="swToDate" name="swToDate"/>
							<input type="hidden" id="prodFromDate" name="prodFromDate"/>
							<input type="hidden" id="prodToDate" name="prodToDate"/>
							<input type="hidden" id="prodFromDate2" name="prodFromDate2"/>
							<input type="hidden" id="prodToDate2" name="prodToDate2"/>
							<input type="hidden" id="salesFromDate" name="salesFromDate"/>
							<input type="hidden" id="salesToDate" name="salesToDate"/>
						</div>
					</div>
					<div class="view_combo" id="divItem"></div>
					<div class="view_combo" id="divItemType"></div>
					<div class="view_combo" id="divRoute"></div>
					<div class="view_combo" id="divItemGroup"></div>
					<div class="view_combo" id="divCleanYn"></div>
					<div class="view_combo" id="divWoNo">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.woNo" /></div>
							<input type="text" id="woNo" name="woNo" class="ipt">
						</div>
					</div>
					<div class="view_combo" id="divParentWoNo">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.parentWoNo" /></div>
							<input type="text" id="parentWoNo" name="parentWoNo" class="ipt">
						</div>
					</div>
					<div class="view_combo" id="divWoStatus"></div>
					<div class="view_combo" id="divWorkerGroup"></div>
					<!-- <div class="view_combo" id="divWorkplaces"></div> -->
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
							<div class="itit"><spring:message code="lbl.versionType"/></div>
							<div class="iptdv borNone">
								<select id="versionType" name="versionType" class="iptcombo"></select>
							</div>
						</div>
					</div>
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
		</div>
    </div>
</body>
</html>
