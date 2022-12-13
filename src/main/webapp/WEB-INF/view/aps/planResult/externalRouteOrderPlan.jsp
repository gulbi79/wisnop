<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	
	<script type="text/javascript">

	var enterSearchFlag = "Y";
	var dip = {

		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.dipGrid.initGrid();
			this.events();
		},
			
		_siq    : "aps.planResult.externalRouteOrderPlan",
		/*
		* common Code 
		*/
		comCode : {
			codeMapEx : null,			
			codeMap : null,
			
			initCode : function () {
				var grpCd = 'PROD_PART,PROCUR_TYPE,ORDER_STATUS,URGENT_STATUS_CD,FLAG_YN,OS_PLAN_TYPE';
				this.codeMap = gfn_getComCode(grpCd, 'Y'); 
				this.codeMapEx = gfn_getComCodeEx(["ROUTING"], null, {itemType : "10,50"});
				this.codeMap.PROD_PART[0].CODE_NM = "";
			}
		},
		
		initFilter : function() {
			
			var planTypeCdOption = [{CODE_CD : "MP", CODE_NM : "<spring:message code="lbl.weekly"/>"},{CODE_CD : "FP", CODE_NM : "<spring:message code="lbl.daily"/>"}];
			gfn_setMsCombo("planTypeCd", planTypeCdOption, [""]);
			
			var pTypeCd = $("#planTypeCd").val(); 
			
			gfn_getPlanIdwc({picketType : "W", planTypeCd : pTypeCd});
			
			gfn_keyPopAddEvent([
				{ target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>' }
			]);
			
			gfn_setMsComboAll([
				{ target : 'divProdPart', id : 'prodPart', title : '<spring:message code="lbl.prodPart"/>', data : this.comCode.codeMap.PROD_PART, exData:["*"], type : "S"},
				{ target : 'divRoute', id : 'route', title : '<spring:message code="lbl.routing"/>', data : this.comCode.codeMapEx.ROUTING, exData:["*"] },
				{ target : 'divProcurType', id : 'procurType', title : '<spring:message code="lbl.procureType"/>', data : this.comCode.codeMap.PROCUR_TYPE, exData:[""]},
				{ target : 'divWoStatus', id : 'woStatus', title : '<spring:message code="lbl.woStatus"/>', data : this.comCode.codeMap.ORDER_STATUS, exData:[""]},
				{ target : 'divUrgentFlag', id : 'urgentFlag', title : '<spring:message code="lbl.urgentFlag"/>', data : this.comCode.codeMap.FLAG_YN, exData:[""] },
				{ target : 'divOsPlanType', id : 'osPlanType', title : '<spring:message code="lbl.division"/>', data : this.comCode.codeMap.OS_PLAN_TYPE, exData:[""] },
				{ target : 'divPlanVersion' , id : 'planVersion', title : '<spring:message code="lbl.planVersion2"/>', data : "", exData:["*"], type : "S"},
			]);
		},
		 
		/* grid  선언
		*/
		dipGrid : {
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
			
			$("#prodPart,#planId").change(function() {
				fn_planVersionChg();
			}); 
			
			$("#divPlanVersion .itit").click("on", function() { 
	    		fn_planVersionChg();
	    	});
	    	
	    	$("#divPlanVersion .itit").css("cursor", "pointer");
	    	
	    	$("#btnPlanComplianceRate").on('click', function (e) {
	    		
	    		
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
	    		
	    		
                gfn_comPopupOpen("EXTERNAL_ROUTE_ORDER_PLAN", {
                    rootUrl : "aps/planResult",
                    url     : "externalRouteOrderPlanCmpRate",
                    width   : 700,
                    height  : 600,
                    popupTitle : '업체별 계획 준수율',
                    planId     : $('#planId').val(),
                    prodPart   : $('#prodPart').val(),
                    planVersion: $('#planVersion').val(),
                    fromCal:     $('#fromCal').val(),
                    toCal:       $('#toCal').val()
               
                    
                });
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
					
					if(id == "divPlanTypeCd"){
						EXCEL_SEARCH_DATA += $("#planTypeCd option:selected").text();
					}else if(id == "divPlanId"){
						EXCEL_SEARCH_DATA += $("#planId option:selected").text();
					}else if(id == "divProdPart"){
						EXCEL_SEARCH_DATA += $("#prodPart option:selected").text();
					}else if(id == "divPlanVersion"){
						EXCEL_SEARCH_DATA += $("#planVersion option:selected").text();
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
					}else if(id == "divWoNo"){
						EXCEL_SEARCH_DATA += $("#woNo").val();
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
					}else if(id == "divCustomer"){
						EXCEL_SEARCH_DATA += $("#customer").val();
					}else if(id == "divUrgentFlag"){
						$.each($("#urgentFlag option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divOsPlanType"){
						$.each($("#osPlanType option:selected"), function(i2, val2){
							
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
		
		// 조회
		search : function () {
			
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq }];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						dip.dipGrid.dataProvider.clearRows(); //데이터 초기화
						
						//그리드 데이터 생성
						dip.dipGrid.grdMain.cancel();
						
						dip.dipGrid.dataProvider.setRows(data.resList);
						dip.dipGrid.dataProvider.clearSavePoints();
						dip.dipGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(dip.dipGrid.dataProvider.getRowCount());
						gfn_setRowTotalFixed(dip.dipGrid.grdMain);
					}
				}
			}
			gfn_service(aOption, "obj");
		},
	};

	//조회
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
		
		gfn_getMenuInit();
    	
    	if(!sqlFlag){
    		dip.dipGrid.gridInstance.setDraw();
		}		
		//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
    	FORM_SEARCH.dimList    = DIMENSION.user;
    	FORM_SEARCH.hiddenList = DIMENSION.hidden;
    	FORM_SEARCH.meaList	   = MEASURE.next;
    	
		if (!sqlFlag) {
			
			var fileds = dip.dipGrid.dataProvider.getFields();
			for (var i = 0; i < fileds.length; i++) {
				
				if(fileds[i].fieldName == 'PLAN_PO_START_DATE_NM' || fileds[i].fieldName == 'BP_RETURN_DATE_NM'|| fileds[i].fieldName == 'PROD_END_DATE_NM'|| fileds[i].fieldName == 'BUFFER_GR_DATE_NM' || fileds[i].fieldName == 'QNC_REQ_DATE_NM' || fileds[i].fieldName == 'EXTERN_INPUT_DATE_NM'){
					fileds[i].dataType = "datetime";
					fileds[i].datetimeFormat = "yyyyMMdd";
					
					dip.dipGrid.grdMain.setColumnProperty(fileds[i].fieldName, "styles", {"datetimeFormat" : "yyyy-MM-dd"});
				}
				
				if (fileds[i].fieldName == 'SS_QTY_NM' || fileds[i].fieldName == 'MFG_LT_NM'|| fileds[i].fieldName == 'SALES_PRICE_KRW_NM') {
					fileds[i].dataType = "number";
					fileds[i].numberFormat = "#,##0";
					
					dip.dipGrid.grdMain.setColumnProperty(fileds[i].fieldName, "styles", {"numberFormat" : "#,##0"});	
				}
			}
			dip.dipGrid.dataProvider.setFields(fileds);
			
		}
		dip.search();
		dip.excelSubSearch();
	}

	// onload 
	$(document).ready(function() {
		dip.init();
		
		$("#planTypeCd").on("change", function(e) {
			 var pTypeCd = $("#planTypeCd").val();
			 gfn_getPlanIdwc({picketType : "W", planTypeCd : pTypeCd});
		});
	});
	
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
								startDay = weekdatecal(fDs[0].FP_START_DATE, -12);
								endDay = weekdatecal(fDs[0].FP_END_DATE, 53);
							}else{
								startDay = weekdatecal(fDs[0].APS_START_DATE, -12);
								endDay = weekdatecal(fDs[0].APS_START_DATE, 53);
							}
						    DATEPICKET(null, startDay, endDay);
						    
						    /* var tStartDay = weekdatecal(startDay, -41);
						    tStartDay = tStartDay.substring(0, 4) + "-" + tStartDay.substring(4, 6) + "-" + tStartDay.substring(6, 8);
						    var tEndDay = weekdatecal(endDay, 29);
						    tEndDay = tEndDay.substring(0, 4) + "-" + tEndDay.substring(4, 6) + "-" + tEndDay.substring(6, 8); */
						    
							//$("#fromCal").datepicker("option", "minDate", tStartDay);
							//$("#toCal").datepicker("option", "maxDate", tEndDay);
						    
							$("#releaseflag").val(fDs[0].RELEASE_FLAG);
						} 
					});
					$("#planId").trigger("change");
				}
			},"obj");
			
		} catch(e) {console.log(e);}
	}
	
	//2주 뒤 날짜 구함
    function weekdatecal(dt, num){
    	
    	var yyyy = dt.substr(0, 4);
    	var mm = dt.substr(4, 2);
    	var dd = dt.substr(6, 2);
    	
    	var dt_stamp = new Date(yyyy + "-" + mm + "-" + dd).getTime();
    	
    	var days = "";
    	
    	if(num > 0){
    		days = ((7 * num) -1);	
    	}else{
    		days = (7 * num);
    	}
    	
		var toDt = new Date(dt_stamp+(days * 24 * 60 * 60 * 1000));
		var rdt = toDt.getFullYear() + '' + (toDt.getMonth() + 1  < 10 ? '0' + (toDt.getMonth() + 1 ) : toDt.getMonth() + 1 ) + (toDt.getDate() < 10 ? '0' + toDt.getDate() : toDt.getDate());
	    
    	return rdt
    	
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
	
	</script>

</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="a" class="split content split-horizontal">
		<form id="searchForm" name="searchForm">
		<input type='hidden' id='releaseflag' name='releaseflag'>
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
					<div class="view_combo" id="divPlanId">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.planId2"/></div>
							<div class="iptdv borNone">
								<select id="planId" name="planId" class="iptcombo"></select>
							</div>
						</div>
                    </div>
					<div class="view_combo" id="divProdPart"></div>
					<div class="view_combo" id="divPlanVersion"></div>
                    <div class="view_combo" id="divRoute"></div>
					<div class="view_combo" id="divItem"></div>
					<div class="view_combo" id="divProcurType"></div>
					<div class="view_combo" id="divWoNo">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.woNo" /></div>
							<input type="text" id="woNo" name="woNo" class="ipt">
						</div>
					</div>
					<div class="view_combo" id="divWoStatus"></div>
					<div class="view_combo" id="divCustomer">
					   <div class="ilist" id="divCustomer">
							<div class="itit"><spring:message code="lbl.customer2"/></div>
							<input type="text" id="customer" name="customer" class="ipt">
						</div>
					</div>
					<div class="view_combo" id="divUrgentFlag"></div>
					<div class="view_combo" id="divOsPlanType"></div>
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
		    <div class="cbt_btn" style="height:25px">
			      <div class="bright">
	                    <a  href="javascript:;" id="btnPlanComplianceRate" class="app1">업체별 계획 준수율</a>
	                    
	                </div>
		    </div>
		</div>
    </div>
</body>
</html>
