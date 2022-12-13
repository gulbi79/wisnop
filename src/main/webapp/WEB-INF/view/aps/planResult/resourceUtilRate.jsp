<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
<script type="text/javascript">
	var weekOut = '<spring:message code="msg.filterWeekOut" />';
	var dayOut = '<spring:message code="msg.filterDayOut" />';
	var bucketGroupDetailList = null;
	var enterSearchFlag = "Y";
	
	var resourceUtilRate = {
		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.grid.initGrid();
		},
		
		_siq    : "aps.planResult.resourceUtilRate",
		
		comCode : {
			codeMapEx : null,
			codeMap   : null,
			initCode  : function() {
				var grpCd      = 'PROD_PART,PROD_OR_QC,WORKER_GROUP';
				this.codeMap   = gfn_getComCode(grpCd, 'Y'); 
				this.codeMapEx = gfn_getComCodeEx(["WORK_PLACES_CD_RESOURE","PROD_ITEM_GROUP_DETAIL"]);
				this.codeMap.PROD_PART[0].CODE_NM = "";
				
			}

		},
		
		initFilter : function() {
			resourceUtilRate.comCode.codeMap.PROD_PART.shift();
			
			//Plan ID
	    	fn_getPlanId({picketType:"W",planTypeCd:"MP"});
			
	    	gfn_setMsComboAll([
				{target : 'divProdPart'   , id : 'prodPart' , title : '<spring:message code="lbl.prodPart2"/>'  , data : this.comCode.codeMap.PROD_PART, exData:["*"], type : "S"},
				{target : 'divPlanVersion', id : 'versionId', title : '<spring:message code="lbl.planVersion"/>', data : [], exData:[""], type : "S"},
				{target : 'divProdOrQc'   , id : 'prodOrQc', title : '<spring:message code="lbl.prodOrQc"/>', data : this.comCode.codeMap.PROD_OR_QC, exData:[""], option: {allFlag:"Y"} },
				{target : 'divWorkplaces' , id : 'workplaces' , title : '<spring:message code="lbl.workplaces"/>' , data : this.comCode.codeMapEx.WORK_PLACES_CD_RESOURE, exData:[""], option: {allFlag:"Y"}},
				{target : 'divWorkerGroup', id : 'workerGroup', title : '<spring:message code="lbl.workerGroup"/>', data : this.comCode.codeMap.WORKER_GROUP    , exData:[""]},
				{target : 'divProdItemGroupDet', id : 'prodItemGroupDet', title : '<spring:message code="lbl.prodItemGroupDet"/>', data : [], exData:[""]}
			]);
	    	
	    	resourceUtilRate.prodPartChange();
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
				
				fn_setMonthSum(resourceUtilRate.grid.gridInstance, true, true)
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
		
		events : function () {
			
			$("input:radio[name=monthlyWeeklyDaily]").click(function(){
				
				var selectVal = $(':radio[name="monthlyWeeklyDaily"]:checked').val();
				
				if(selectVal == "MONTH"){
					$("#filterViewWeek").hide();
					$("#filterViewMonth").show();
				}
				else if(selectVal == "WEEK"){
					$("#filterViewMonth").hide();
					$("#filterViewWeek").show();
				}
				else if(selectVal == "DAY"){
					$("#filterViewMonth").hide();
					$("#filterViewWeek").show();
				}
				
				
			});
			
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("#prodPart,#planId").change(function() {
				resourceUtilRate.prodPartChange();
			});
			
			$("#divPlanVersion .itit").click("on", function() { 
				resourceUtilRate.prodPartChange();
	    	});
	    	
	    	$("#divPlanVersion .itit").css("cursor", "pointer");
	    	
	    	//주간,일간
	    	//일간일 경우, html class treeNav display:none 처리하기
	    	$("#weeklyDaily1,#weeklyDaily2,#weeklyDaily3").change(function() {
	    	
	    		
	    		//주간 planId 검색 {picketType:"W",planTypeCd:"MP"}
	    		// W: 주간(week)  
	    		
	    		//일간 planId 검색 {picketType:"D",planTypeCd:"FP"}
				// D: 일간(day)
	    		try {
						
						if ($("#planId").length == 0) {
							return;
						}
						var pOption = {};
						
						if($('#weeklyDaily1').is(':checked')){
						
							pOption = {picketType:"W",planTypeCd:"MP"};
							
						}
						else if($('#weeklyDaily2').is(':checked')){
						
							pOption = {picketType:"D",planTypeCd:"FP"}		
						}
						else if($('#weeklyDaily3').is(':checked')){
							
							pOption = {picketType:"M",planTypeCd:"MP"};
							
						}
						
						
						var params = $.extend({
							_mtd     : "getList",
							tranData : [{outDs:"rtnList",_siq:"common.planId"}]
						}, pOption);
						
						gfn_service({
							url     : GV_CONTEXT_PATH + "/biz/obj",
							data    : params,
							async   : false,
							success : function(data) {
								
								
								gfn_setMsCombo("planId",data.rtnList,[""]);
								
								
								// 현재는 주간 기준으로 작성됨
								// 일간 기준일 때, START날짜, END 날짜에 대한 change 이벤트 추가 필요
								// 일간 기준일 때, START날짜와 END 날짜 동일하게 셋팅필요 -> BUCKET의 범위에 적용됨
								$("#planId").on("change", function(e) {
									
									//주간 체크된 경우
									if($('#weeklyDaily1').is(':checked')){
									
											
										var nowDate = null;
										var fDs = gfn_getFindDataDsInDs(data.rtnList, {CODE_CD : {VALUE : $(this).val(), CONDI : "="}});
										
										if (fDs.length > 0) {
								
											nowDate = fDs[0].SW_START_DATE;
											var DATE_plus_42 = weekdatecal(nowDate,42);
										    var DATE_plus_180 = weekdatecal(nowDate,132);
										    
									        DATEPICKET(null, nowDate, DATE_plus_42);
											
											var sdt = gfn_getStringToDate(nowDate);
											
											var edt = gfn_getStringToDate(DATE_plus_180);
											
											$("#fromCal").datepicker("option", "minDate", sdt);
											$("#fromCal").datepicker("option", "maxDate", edt);
											$("#toCal").datepicker("option", "maxDate", edt);
											$("#cutOffFlag").val(fDs[0].CUT_OFF_FLAG);
											
											
											var tStartMon = nowDate.substring(0, 4) + nowDate.substring(4, 6);
											var tCloseMon = gfn_addDate("month", 5, "", tStartMon + "01").substring(0, 6);
											var ttCloseMon = gfn_addDate("month", 11, "", tStartMon + "01").substring(0, 6);
											
											var minMonthStart = gfn_getStringToDate(tStartMon + "01");
											var maxMonthClose = gfn_getStringToDate(tCloseMon + "01");
											var maxMonthEdt =  gfn_getStringToDate(ttCloseMon + "01");
											
											MONTHPICKER(null, tStartMon, tCloseMon);
											$("#fromMon").monthpicker("option", "minDate", minMonthStart);
											$("#toMon").monthpicker("option", "maxDate", maxMonthEdt);
											
											$("#filterViewMonth").hide();
											$("#filterViewWeek").show();
										}
										
									}
									//일간 체크된 경우
									else if($('#weeklyDaily2').is(':checked'))
									{
										
										var nowDate = null;
										var fDs = gfn_getFindDataDsInDs(data.rtnList, {CODE_CD : {VALUE : $(this).val(), CONDI : "="}});
										
										if (fDs.length > 0) {
											nowDate = fDs[0].FP_START_DATE;
											var DATE_plus_42 = weekdatecal(nowDate,42);
										    var DATE_plus_180 = weekdatecal(nowDate,132);
										    
									        DATEPICKET(null, nowDate, DATE_plus_42);
											
											var sdt = gfn_getStringToDate(nowDate);
											
											var edt = gfn_getStringToDate(DATE_plus_180);
											
											$("#fromCal").datepicker("option", "minDate", sdt);
											$("#fromCal").datepicker("option", "maxDate", edt);
											$("#toCal").datepicker("option", "maxDate", edt);
											$("#cutOffFlag").val(fDs[0].CUT_OFF_FLAG);
											
											
											var tStartMon = nowDate.substring(0, 4) + nowDate.substring(4, 6);
											var tCloseMon = gfn_addDate("month", 5, "", tStartMon + "01").substring(0, 6);
											var ttCloseMon = gfn_addDate("month", 11, "", tStartMon + "01").substring(0, 6);
											
											var minMonthStart = gfn_getStringToDate(tStartMon + "01");
											var maxMonthClose = gfn_getStringToDate(tCloseMon + "01");
											var maxMonthEdt =  gfn_getStringToDate(ttCloseMon + "01");
											
											MONTHPICKER(null, tStartMon, tCloseMon);
											$("#fromMon").monthpicker("option", "minDate", minMonthStart);
											$("#toMon").monthpicker("option", "maxDate", maxMonthEdt);
											
											$("#filterViewMonth").hide();
											$("#filterViewWeek").show();
										}
										
									}
									//월간 체크된 경우
									else if($('#weeklyDaily3').is(':checked'))
									{
										
										var nowDate = null;
										var fDs = gfn_getFindDataDsInDs(data.rtnList, {CODE_CD : {VALUE : $(this).val(), CONDI : "="}});
										
										if (fDs.length > 0) {
											
											nowDate = fDs[0].SW_START_DATE;
											var DATE_plus_42 = weekdatecal(nowDate,42);
										    var DATE_plus_180 = weekdatecal(nowDate,132);
										    
									        DATEPICKET(null, nowDate, DATE_plus_42);
											
											var sdt = gfn_getStringToDate(nowDate);
											
											var edt = gfn_getStringToDate(DATE_plus_180);
											
											$("#fromCal").datepicker("option", "minDate", sdt);
											$("#fromCal").datepicker("option", "maxDate", edt);
											$("#toCal").datepicker("option", "maxDate", edt);
											$("#cutOffFlag").val(fDs[0].CUT_OFF_FLAG);
											
											
											var tStartMon = nowDate.substring(0, 4) + nowDate.substring(4, 6);
											var tCloseMon = gfn_addDate("month", 5, "", tStartMon + "01").substring(0, 6);
											var ttCloseMon = gfn_addDate("month", 11, "", tStartMon + "01").substring(0, 6);
											
											var minMonthStart = gfn_getStringToDate(tStartMon + "01");
											var maxMonthClose = gfn_getStringToDate(tCloseMon + "01");
											var maxMonthEdt =  gfn_getStringToDate(ttCloseMon + "01");
											
											MONTHPICKER(null, tStartMon, tCloseMon);
											$("#fromMon").monthpicker("option", "minDate", minMonthStart);
											$("#toMon").monthpicker("option", "maxDate", maxMonthEdt);
										
											$("#filterViewMonth").show();
											$("#filterViewWeek").hide();
										}
									}
								});
								
								$("#planId").trigger("change");
							}
						},"obj");
			
		} catch(e) {console.log(e);}
	    		
	    		
	    		
	    		/*
	    		var weeklyDaily = $('input[name="weeklyDaily"]:checked').val();
	        	
	        	gfn_service({
	    			async   : false,
	    			url     : GV_CONTEXT_PATH + "/biz/obj",
	    			data    : {_mtd : "getList", weekly_daily : weeklyDaily,  
	    				tranData : [
							{outDs : "planList", _siq : "aps.planExecute.planIdControl"}
	    				  , {outDs : "defaultList", _siq : "common.planIdFp"}
	    			]},
	    			success : function(data) {
	    				gfn_setMsCombo("planId", data.planList, [""]);
	    				
	    				
	    				console.log("defaultPlanId:",defaultPlanId);
	    				
	    				if(weeklyDaily == "FP"){
	    					var defaultPlanId = data.defaultList[0].PLAN_ID;
	    					$("#planId").val(defaultPlanId);
	    				}
	    			}
	    		}, "obj");
	        	
	        	*/
	        	
	    	});
	    	
	    	
	    	
	    	
	    	
		},
		
		gv_WeekOut : "",
		gv_weekSumFlag : "",
		
		prodPartChange : function() {
			FORM_SEARCH          = $("#searchForm").serializeObject(); //초기화
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "versionList",_siq : resourceUtilRate._siq + "Version"}];
			
			// 계획버전 
			gfn_service({
			    async   : false,
			    url     : GV_CONTEXT_PATH + "/biz/obj",
			    data    : FORM_SEARCH,
			    success : function(data) {
			    	
			    	gfn_setMsCombo("versionId", data.versionList, [""]);
			    	
					$.each(data.versionList, function(i, val){
						
						var codeCd = val.CODE_CD;
						var cutOffFlag = val.CUT_OFF_FLAG;
						var versionTypeCd = val.VERSION_TYPE_CD;
						
						if(cutOffFlag == "Y" && versionTypeCd == "M"){
							$("#versionId option:eq("+ i +")").css("color", gv_redColor);
							return false;
						}
					});
			    }
			},"obj");
			
			// 작업장 멀티 셀렉트 박스 셋팅
			var prodPart = $("#searchForm #prodPart").val();
			
			if(prodPart != "") {
				var newData = [];
				
				$.each(resourceUtilRate.comCode.codeMapEx.WORK_PLACES_CD_RESOURE, function(n, v) {
					if(v.UPPER_CD == prodPart) {
						newData.push(v);
					}
				});
				
				gfn_setMsCombo("workplaces",newData,[""], {allFlag:"Y"});
			} else {
				gfn_setMsCombo("workplaces",resourceUtilRate.comCode.codeMapEx.WORK_PLACES_CD_RESOURE, [""], {allFlag:"Y"});
			}
			
			
			//20221028 김수호 수정, 변경관리 #158, 자원별 가동계획 Column 추가요청 건 FROM 김지혜
			var groupDet = [];
			
			var changedProdPart = null;
			if(prodPart =="LAM")changedProdPart = 'LAM';
			else if(prodPart =="TEL")changedProdPart = 'TEL';
			else if(prodPart =="DIFFUSION")changedProdPart = 'DIFF';
			else if(prodPart =="MATERIAL")changedProdPart = 'MAT';
			$('#prodPartShort').val(changedProdPart);		
			$.each(resourceUtilRate.comCode.codeMapEx.PROD_ITEM_GROUP_DETAIL, function(idx, item) {
				
				if(item.UPPER_CD.indexOf(changedProdPart) != -1 ) {
					groupDet.push(item);
				}
				
			});
			gfn_setMsCombo("prodItemGroupDet", groupDet, ["*"]);
			/////////////////////////////////////////////////////////////////////////
		},
		
		getBucket : function(sqlFlag) {
			
			var ajaxMap = null;
			//주간 체크된 경우
			if($('#weeklyDaily1').is(':checked'))
			{
				 ajaxMap = {
					fromDate : $("#swFromDate").val().replace(/-/g, ''),
					toDate   : $("#swToDate").val().replace(/-/g, ''),
		       		week     : {isDown: "Y", isUp:"N", upCal:"M", isMt:"Y", isExp:"Y", expCnt:1},
		       		day      : {isDown: "N", isUp:"Y", upCal:"W", isMt:"Y", isExp:"N", expCnt:999},
					sqlId    : ["bucketFullWeek", "bucketDay"]
				};
			}
			//일간 체크된 경우
			else if($('#weeklyDaily2').is(':checked'))
			{
				 ajaxMap = {
						fromDate : $("#fromCal").val().replace(/-/g, ''),
						toDate   : $("#toCal").val().replace(/-/g, ''),
						week     : {isDown: "Y", isUp:"N", upCal:"M", isMt:"Y", isExp:"Y", expCnt:1},
			       		day      : {isDown: "N", isUp:"Y", upCal:"W", isMt:"Y", isExp:"Y", expCnt:999},
						sqlId    : ["bucketFullWeek","bucketDay"]
					};
			}
			//월간 체크된 경우
			else if($('#weeklyDaily3').is(':checked'))
			{
			
				ajaxMap = {
						fromDate : gfn_replaceAll($("#fromMon").val(),"-","") + "01",
						toDate   : gfn_replaceAll($("#toMon").val(),"-","") + "31",
						month    : {isDown: "N", isUp : "Y", upCal : "Y", isMt : "Y", isExp : "N", expCnt : 999},
						sqlId    : ["bucketMonth"]
					}
			}
			
			gfn_getBucket(ajaxMap);
			
			if (!sqlFlag) {
				resourceUtilRate.grid.gridInstance.setDraw();
				
				$.each(BUCKET.query, function(n, v) {
					resourceUtilRate.grid.grdMain.setColumnProperty(v.CD, "dynamicStyles", [
		    			{
		    				criteria : "(values['CATEGORY_CD'] = 'AVAIL_TIME')",
		    				styles   : {numberFormat : "#,##0.0"}
		    			}, {
		    				criteria : "(values['CATEGORY_CD'] = 'PLAN_TIME')",
		    				styles   : {numberFormat : "#,##0.0"}
		    			}, {
		    				criteria : "(values['CATEGORY_CD'] = 'UTIL') and (value > 0)",
		    				styles   : {numberFormat : "#,##0"}
		    			}, {
		    				criteria : "(values['CATEGORY_CD'] = 'UTIL_24') and (value > 0)",
		    				styles   : {numberFormat : "#,##0"}
		    			}
		    			,  {
		    				criteria : "(values['CATEGORY_CD'] = 'WAIT_DAYS') and (value > 0)",
		    				styles   : {numberFormat : "#,##0.00"}
		    			}
		    			,  {
		    				criteria : "(values['CATEGORY_CD'] = 'WAIT_DAYS_AVG') and (value > 0)",
		    				styles   : {numberFormat : "#,##0.00"}
		    			}, {
                            criteria : "(values['CATEGORY_CD'] = 'JC_CNT')",
                            styles   : {numberFormat : "#,##0.0"}
                        }, {
                            criteria : "(values['CATEGORY_CD'] = 'JC_TIME')",
                            styles   : {numberFormat : "#,##0.0"}
                        }
		    			
		    			
		    			
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
					}else if(id == "divProdPart"){
						EXCEL_SEARCH_DATA += $("#prodPart option:selected").text();
					}else if(id == "divPlanVersion"){
						EXCEL_SEARCH_DATA += $("#versionId option:selected").text();
					}else if(id == "divProdOrQc"){
						$.each($("#prodOrQc option:selected"), function(i2, val2){
							
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
					}else if(id == "divResource"){
						EXCEL_SEARCH_DATA += $("#resource").val();
					}
				}
			});
			
			EXCEL_SEARCH_DATA += "\n" + '<spring:message code="lbl.period"/>' + " : ";
			EXCEL_SEARCH_DATA += $("#fromCal").val() + "(" + $("#fromPWeek").val() + ") ~ ";
			EXCEL_SEARCH_DATA += $("#toCal").val() + "(" + $("#toPWeek").val() + ")";
			
		},
		
		search : function () {
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList",_siq : resourceUtilRate._siq }];
			FORM_SEARCH.bucketGroupDetailList = bucketGroupDetailList;
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						resourceUtilRate.grid.dataProvider.clearRows(); //데이터 초기화
						
						//그리드 데이터 생성
						resourceUtilRate.grid.grdMain.cancel();
						
						resourceUtilRate.grid.dataProvider.setRows(data.resList);
						resourceUtilRate.grid.dataProvider.clearSavePoints();
						resourceUtilRate.grid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(resourceUtilRate.grid.dataProvider.getRowCount());
						//gfn_actionMonthSum(commFacility.grid.gridInstance);
						gfn_setRowTotalFixed(resourceUtilRate.grid.grdMain);
					}
				}
			}
			gfn_service(aOption, "obj");
		}
	};
	
	//조회
	var fn_apply = function (sqlFlag) {
		bucketGroupDetail();
		gfn_getMenuInit();
		resourceUtilRate.getBucket(sqlFlag);
		
		//조회조건 설정
    	FORM_SEARCH            = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
    	FORM_SEARCH.dimList    = DIMENSION.user;
   		FORM_SEARCH.meaList	   = MEASURE.user;
    	FORM_SEARCH.bucketList = BUCKET.query;
   		
    	resourceUtilRate.search();
    	resourceUtilRate.excelSubSearch();
	}
	
	function bucketGroupDetail(){
		
		FORM_SEARCH = {};
		FORM_SEARCH.prodPartShort = $('#prodPartShort').val();
		FORM_SEARCH.prodPart	  = $('#prodPart').val();
		FORM_SEARCH._mtd     = "getList";
		FORM_SEARCH.tranData = [{ outDs : "resList",_siq :"aps.planResult.bucketGroupDetail" }];
		
		var aOption = {
			async: false,
			url     : GV_CONTEXT_PATH + "/biz/obj",
			data    : FORM_SEARCH,
			success : function (data) {
					bucketGroupDetailList = null;
					bucketGroupDetailList = data.resList;
			}
		}
		gfn_service(aOption, "obj");
		
		
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
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : params,
				async   : false,
				success : function(data) {
					
					gfn_setMsCombo("planId",data.rtnList,[""]);
					
					
					// 현재는 주간 기준으로 작성됨
					// 일간 기준일 때, START날짜, END 날짜에 대한 change 이벤트 추가 필요
					// 일간 기준일 때, START날짜와 END 날짜 동일하게 셋팅필요 -> BUCKET의 범위에 적용됨
					$("#planId").on("change", function(e) {
						
							var nowDate = null;
							var fDs = gfn_getFindDataDsInDs(data.rtnList, {CODE_CD : {VALUE : $(this).val(), CONDI : "="}});
							if (fDs.length > 0) {
								
								nowDate = fDs[0].SW_START_DATE;
								
								var DATE_plus_42 = weekdatecal(nowDate,42);
							    var DATE_plus_180 = weekdatecal(nowDate,132);
							    
						        DATEPICKET(null, nowDate, DATE_plus_42);
								
								var sdt = gfn_getStringToDate(nowDate);
								
								var edt = gfn_getStringToDate(DATE_plus_180);
								
								$("#fromCal").datepicker("option", "minDate", sdt);
								$("#fromCal").datepicker("option", "maxDate", edt);
								$("#toCal").datepicker("option", "maxDate", edt);
								$("#cutOffFlag").val(fDs[0].CUT_OFF_FLAG);
								
								
								var tStartMon = nowDate.substring(0, 4) + nowDate.substring(4, 6);
								var tCloseMon = gfn_addDate("month", 5, "", tStartMon + "01").substring(0, 6);
								var ttCloseMon = gfn_addDate("month", 11, "", tStartMon + "01").substring(0, 6);
								
								var minMonthStart = gfn_getStringToDate(tStartMon + "01");
								var maxMonthClose = gfn_getStringToDate(tCloseMon + "01");
								var maxMonthEdt =  gfn_getStringToDate(ttCloseMon + "01");
								
								MONTHPICKER(null, tStartMon, tCloseMon);
								$("#fromMon").monthpicker("option", "minDate", minMonthStart);
								$("#toMon").monthpicker("option", "maxDate", maxMonthEdt);
								
								$("#filterViewMonth").hide();
								
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
	
  	//month, sum, omit zero
    function fn_setMonthSum(objInstance, monthFlag, monthOutFlag) {
    	
    	if (!monthOutFlag) {
    		$("#btnMonthOut").addClass("disable");
    		$("#btnMonthOut").text("");
    	} else {
    		$("#btnMonthOut").click("on", function() {
    			gv_monthSumOut = "Y";
    			fn_weekOut(objInstance); 
    		});
    	}
    	
    	if (!monthFlag) {
    		$("#btnMonth").addClass("disable");
    		$("#btnMonth").text("");
    	} else {
    		$("#btnMonth").click("on", function() {
    			gv_monthSumFlag = "Y";
    			fn_dayOut(objInstance); 
    		});
    	}
    }
  	
    function fn_weekOut(objInstance){
    	
    	if (gv_monthSumOut != "Y") return; //한번도 처리한적이 없는경우
    	
    	var btnMonthClass = $("#btnMonth").attr("class");
    	var classNm = $("#btnMonthOut").attr("class");
    	var columnNames = objInstance.objGrid.getColumnNames(false);
    	var header, visible;
    	var tmpChk = true;
    	
    	if(btnMonthClass == "on"){
    		$("#btnMonthOut").removeClass("on");
    		alert(weekOut);
    		return;
    	}
    	
    	// 접힘
    	if (classNm == "on") {
    		for (var i = columnNames.length - 1;  i >= 0; i--) {
    			header = objInstance.objGrid.getColumnProperty(columnNames[i], "header");
    			visible = objInstance.objGrid.getColumnProperty(columnNames[i], "visible");
    			
    			if (header.text == undefined) continue;

    			if (header.text.indexOf(gv_expand) != -1) {
    				if (!visible) continue;
    				gfn_setChildColumnResizeMonthOut(objInstance, objInstance.objGrid, columnNames[i]);
    			}
    		}

    	// 펼침
    	} else {
    		for (var i=0; i<columnNames.length; i++) {
    			header = objInstance.objGrid.getColumnProperty(columnNames[i], "header");
    			if (header.text == undefined) continue;

    			if (header.text.indexOf(gv_expand) != -1) {
    				
    				gfn_setChildColumnResizeMonthOut(objInstance, objInstance.objGrid, columnNames[i]);
    			}
    		}
    	}
    }
    
    function fn_dayOut(objInstance) {
    	
    	if (gv_monthSumFlag != "Y") return; //한번도 처리한적이 없는경우
    	var btnMonthOutClass = $("#btnMonthOut").attr("class");
    	var classNm = $("#btnMonth").attr("class");
    	var columnNames = objInstance.objGrid.getColumnNames(false);
    	var header, visible;
    	var tmpChk = true;
    	
    	if(btnMonthOutClass == "on"){
    		$("#btnMonth").removeClass("on");
    		alert(dayOut);
    		return;
    	}
    	
    	// 접힘
    	if (classNm == "on") {
    		for (var i=columnNames.length-1; i>=0; i--) {
    			header = objInstance.objGrid.getColumnProperty(columnNames[i], "header");
    			visible = objInstance.objGrid.getColumnProperty(columnNames[i], "visible");
    			
    			if (header.text == undefined) continue;

    			if (header.text.indexOf(gv_expand) != -1) {
    				if (!visible) continue;
    				
    				gfn_setChildColumnResize(objInstance, objInstance.objGrid, columnNames[i]);
    			}
    		}

    	// 펼침
    	} else {
    		for (var i=0; i<columnNames.length; i++) {
    			header = objInstance.objGrid.getColumnProperty(columnNames[i], "header");
    			if (header.text == undefined) continue;

    			if (header.text.indexOf(gv_folding) != -1) {
    				
    				gfn_setChildColumnResize(objInstance, objInstance.objGrid, columnNames[i]);
    			}
    		}
    	}
    }
	
 	// onload 
	$(document).ready(function() {
		resourceUtilRate.init();
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
				<ul class="treeNav"><!-- 일간 선택일 경우 display:none 처리하기  -->
					<li><a id="btnMonthOut" href="#">WeekOut</a></li>
					<li><a id="btnMonth" href="#">DayOut</a></li>
					<li><a id="btnBlank" href="#" class="disable"></a></li>
				</ul>
				
				<div class="tabMargin"></div>
				<div class="scroll">
					
					<div class="view_combo" id="divPlanId">
					<div class="view_combo" id="divWeeklyDaily">
							<strong class="filter_tit"><spring:message code="lbl.horizon"/></strong>
							<ul class="rdofl">
								<li><input type="radio" id="weeklyDaily3" name="monthlyWeeklyDaily" value="MONTH" ><label for="weeklyDaily3"><spring:message code="lbl.month"/></label></li>
								<li><input type="radio" id="weeklyDaily1" name="monthlyWeeklyDaily" value="WEEK" checked="checked"><label for="weeklyDaily1"><spring:message code="lbl.week"/></label></li>
								<li><input type="radio" id="weeklyDaily2" name="monthlyWeeklyDaily" value="DAY"><label for="weeklyDaily2"><spring:message code="lbl.dayChart"/></label></li>
								
							</ul>
					</div>
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.planId"/></div>
							<div class="iptdv borNone">
								<select id="planId" name="planId" class="iptcombo"></select>
							</div>
						</div>
					</div>
					<input type='hidden' id='cutOffFlag' name='cutOffFlag'>
					<div class="view_combo" id="divProdPart"></div>
					<div class="view_combo" id="divPlanVersion"></div>
					<div class="view_combo" id="divProdOrQc"></div>
					<div class="view_combo" id="divWorkplaces"></div>
					<div class="view_combo" id="divWorkerGroup"></div>
					<div class="view_combo" id="divResource">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.resource2"/></div>
							<input type="text" id="resource" name="resource" class="ipt">
						</div>
					</div>
					<div class="view_combo" id="divProdItemGroupDet" style="display:none;"></div>  
					<input type='hidden' id='prodPartShort' name='prodPartShort'>
					<div id="filterViewWeek"><jsp:include page="/WEB-INF/view/common/filterViewHorizon.jsp" flush="false" /></div>
					<div id="filterViewMonth"><jsp:include page="/WEB-INF/view/common/filterViewHorizonMonth.jsp" flush="false" /></div>
					
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