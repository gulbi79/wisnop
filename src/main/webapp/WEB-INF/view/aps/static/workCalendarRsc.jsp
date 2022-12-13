<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	<!-- Aging 재고 Trend -->
	<script type="text/javascript">

	var enterSearchFlag = "Y";
	var searchData = null;
	var weekArray = [];
	var workCalendar = {

		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.workCalendarGrid.initGrid();
		},
		
		_siq    : "aps.static.workCalendarRsc",
		
		initFilter : function() {
		   
			gfn_getPlanIdwc({picketType:"W",planTypeCd:"MP"});
			// 콤보박스
			var upperWorkPlaces = {
				childId   : ["workplaces"],
				childData : [this.comCode.codeMapEx.WORK_PLACES_CD]
			};
			
			gfn_setMsComboAll([
				{target : 'divProdPart', id : 'prodPart', title : '<spring:message code="lbl.prodPart2"/>', data : this.comCode.codeMap.PROD_PART, exData:["*"], event: upperWorkPlaces},
				{target : 'divWcType', id : 'workType', title : '<spring:message code="lbl.wcMgrNm"/>', data : this.comCode.codeMap.RESOURCE_TYPE, exData:[""]},
				{target : 'divWorkplaces', id : 'workplaces', title : '<spring:message code="lbl.resourceGroup"/>', data : this.comCode.codeMapEx.WORK_PLACES_CD, exData:[""]},
				{target : 'divProdOrQc', id : 'prodOrQc', title : '<spring:message code="lbl.prodOrQc"/>', data : this.comCode.codeMap.PROD_OR_QC, exData:[""]},
				{target : 'divWorkerGroup', id : 'workerGroup', title : '<spring:message code="lbl.workerGroup"/>', data : this.comCode.codeMap.WORKER_GROUP    , exData:[""]}
			]);
				
			gfn_getPlanIdwc({picketType:"W",planTypeCd:"MP"});
			
			this.popup_auth();
		},
		
		/*
		* common Code 
		*/
		comCode : {
			codeMap : null,
			codeMapEx : null,
			codeReptMap : null,
			
			initCode : function () {
				var grpCd = 'PROD_PART,PLAN_INFO,RESOURCE_TYPE,WC_SHIFT,PROD_OR_QC,WORKER_GROUP';
				this.codeMap = gfn_getComCode(grpCd, 'N'); //공통코드 조회
				this.codeMapEx = gfn_getComCodeEx(["PLAN_ID","PLAN_LIST","WORK_PLACES_CD"]);
			}
		},
	
		/* 
		* grid  선언
		*/
		workCalendarGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				
				this.grdMain.setOptions({
			        indicator: {visible: true},        
			        checkBar: {visible: false},
			        stateBar: {visible: true},
			        edit: {insertable: false, appendable: false, updatable: true, editable: true},
			        commitLevel: "info"
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
				
				this.grdMain.onEditRowChanged = function (grid, itemIndex, dataRow, field, oldValue, newValue) {
					if(newValue == 0){
						grid.setValue(dataRow, field, '');
					}
				};
				
			   	this.grdMain.onValidateColumn = function(grid, column, inserting, value) {
				    var error = {};
				    if(column.name.indexOf("_WORK") > -1 || column.name.indexOf("_OVERTIME") > -1 ){
						if(value != '' && value != null){
			        		if (value >  24.00) {
					            error.level = RealGridJS.ValidationLevel.ERROR;
					            error.message = "최대 시간은 24시입니다.";
					        }else if(!$.isNumeric(value)){
					        	error.level = RealGridJS.ValidationLevel.ERROR;
					            error.message = "숫자만 입력 가능합니다.";
					        }
			        	}
					}
				    return error;
				};
			},
		},
	
		/*
		* event 정의
		*/
		events : function () {
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("#btnSave").on('click', function (e) {
				workCalendar.save();
			});
			
			$("#btnReset").on('click', function (e) {
				workCalendar.workCalendarGrid.grdMain.cancel();
				workCalendar.workCalendarGrid.dataProvider.rollback(workCalendar.workCalendarGrid.dataProvider.getSavePoints()[0]);
				
				workCalendar.gridCallback(searchData);
			});
			
			$("#btnPopBasic").on('click',function(e){
				gfn_comPopupOpen("BASIC_WORK_CALENDAR_RSC", {
					rootUrl : "aps/static",
					url     : "basicWorkCalendarRsc",
					width   : 1150,
					height  : 680,
					menuCd : "APS10401"
				});
			});
			
			$("#btnPopShift").on('click',function(e){
				gfn_comPopupOpen("WORK_CALENDAR_SHIFT", {
					rootUrl : "aps/static",
					url     : "workCalendarShift",
					width   : 490,
					height  : 310,
					menuCd : "APS10405"
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
					
					//데이터
					if(id == "divProdPart"){
						$.each($("#prodPart option:selected"), function(i2, val2){
							
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
					}else if(id == "divWcType"){
						$.each($("#workType option:selected"), function(i2, val2){
							
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
			FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq }, { outDs : "calDay", _siq : "aps.static.workCalDay" }];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						
						workCalendar.workCalendarGrid.dataProvider.clearRows(); //데이터 초기화
						//그리드 데이터 생성
						workCalendar.workCalendarGrid.grdMain.cancel();
						workCalendar.workCalendarGrid.dataProvider.setRows(data.resList);
						workCalendar.workCalendarGrid.dataProvider.clearSavePoints();
						workCalendar.workCalendarGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(workCalendar.workCalendarGrid.dataProvider.getRowCount());
						gfn_setRowTotalFixed(workCalendar.workCalendarGrid.grdMain);
						searchData = data.resList;
					
						
						workCalendar.gridCallback(data.resList, data.calDay);
						workCalendar.getWeekArray();
					}
				}
			}
			
			gfn_service(aOption, "obj");
			
			if (FORM_SEARCH.sql == 'N') {
				
				var fileds = workCalendar.workCalendarGrid.dataProvider.getFields();
				
				for (var i = 2; i < fileds.length; i++) {
					
					var fieldName = fileds[i].fieldName;
					var fields_len = fileds[i];
					
					if (fieldName != 'PART_CD_NM' && fieldName != 'POQ_CD' && fieldName != 'POQ_CD_NM' && fieldName != 'WC_MGR_NM_NM' && fieldName != 'WC_MGR_NM' && fieldName != 'WC_CD_NM' && fieldName != 'WC_NM_NM' 
						&& fieldName != 'RESOURCE_CD_NM' && fieldName != 'RESOURCE_NM_NM' && fieldName != 'WORKER_GROUP_NM' && fieldName != "ROUTING_ID_NM"){
						        		
						        fileds[i].dataType = "text";
						        workCalendar.workCalendarGrid.grdMain.setColumnProperty(fieldName, "displayRegExp","([0-9]{2})([0-9]{2})");
						        workCalendar.workCalendarGrid.grdMain.setColumnProperty(fieldName, "styles", {textAlignment: "center",background:gv_noneEditColor});
						        workCalendar.workCalendarGrid.grdMain.setColumnProperty(fieldName, "displayReplace","$1.$2");
						        workCalendar.workCalendarGrid.grdMain.setColumnProperty(fieldName, "width",40);
						        //
						        workCalendar.workCalendarGrid.grdMain.setColumnProperty(fieldName, "zeroText",'');
						        workCalendar.workCalendarGrid.grdMain.setColumnProperty(fieldName, "defaultValue",null);
						        
						        workCalendar.workCalendarGrid.grdMain.setColumnProperty(fieldName, "datatype", 'text');
						        workCalendar.workCalendarGrid.grdMain.setColumnProperty(fieldName, "nulltoText", null);
								workCalendar.workCalendarGrid.grdMain.setColumnProperty(fieldName, "editor", {
																						   						type         : "text",
																						   						editFormat   : "00.00",
																						   						allowEmpty   :  true,
																							 				    positiveOnly : true,
																						   						textAlignment: "center",
																						   						maxLength : 5
																						   					});
					}else{
						
						workCalendar.workCalendarGrid.grdMain.setColumnProperty(fieldName, "styles", {background:"rgba(237, 247, 253, 1)"});
						workCalendar.workCalendarGrid.grdMain.setColumnProperty(fieldName, "editable", false);
					}
				}
				workCalendar.workCalendarGrid.dataProvider.setFields(fileds);   
			}
		},
		
		getBucket : function (sqlFlag) {
			
			var ajaxMap = {
				fromDate : gfn_replaceAll($("#fromCal").val(), "-", ""),
				toDate   : gfn_replaceAll($("#toCal").val(), "-", ""),
				day    : {isDown: "Y", isUp:"N", upCal:"N", isMt:"N", isExp:"N", expCnt:1},
				sqlId    : ["bucketDay"]
			}
			
			gfn_getBucket(ajaxMap);
			
			var subBucket = [
				{TYPE:"group" ,CD : "A", NM : workCalendar.comCode.codeMap.WC_SHIFT[0].CODE_NM,WIDTH:80},
				{TYPE:"group" ,CD : "B", NM : workCalendar.comCode.codeMap.WC_SHIFT[1].CODE_NM,WIDTH:80},
			];
			gfn_setCustBucket(subBucket);
			
			var subBucket = [
				{CD : "WORK", NM : '<spring:message code="lbl.work"/>',datatype : 'number'},
				{CD : "OVERTIME", NM : '<spring:message code="lbl.overtime"/>',datatype : 'number'},
			];
			gfn_setCustBucket(subBucket);
			
			var cutoff_flag = $("#cutOffFlag").val();
			if(cutoff_flag == "N"){
				for(var i = 0; i < BUCKET.all[1].length; i++){
					BUCKET.hidden.push({CD : BUCKET.all[1][i].CD + "_EDIT_FLAG", BUCKET_VAL : BUCKET.all[1][i].BUCKET_VAL, dataType : "text"});
				} 
			}
			
			if (!sqlFlag) {
				try{
				   workCalendar.workCalendarGrid.grdMain.cancel();	
				   workCalendar.workCalendarGrid.gridInstance.setDraw();
				} catch (e) {
			        alert('<spring:message code="msg.errorCheck"/>\n'+e.message);
			    }
			}
		},
		save : function(){
			
			try {
				workCalendar.workCalendarGrid.grdMain.commit(true);
			} catch (e) {
				alert('<spring:message code="msg.saveErrorCheck"/>\n'+e.message);
			}
			
			var jsonRows;
			
			jsonRows = gfn_getGrdSavedataAll(workCalendar.workCalendarGrid.grdMain);
			
			if (jsonRows.length == 0) {
				alert('<spring:message code="msg.noChangeData"/>');
				return;
			}
			
			// 저장
			confirm('<spring:message code="msg.saveCfm"/>', function() {
			
				// 저장할 데이터 정리
				var salesPlanDatas = [];
				
				$.each(jsonRows, function(i, row) {
					
					$.each(row, function(attr, value) {
						
						if (attr.indexOf("_WORK") > -1 || attr.indexOf("_OVERTIME") > -1 ){
							
							var tmp = attr.split("_")[0];
							var wtype = attr.split("_")[2];
							var spType = attr.split("_")[1];
							var yyyymmdd = tmp.replace("D", "");
							
							if (typeof value !=  "undefined"){
								
								if(value == null ) value = '';	
								var planData = {
									PROD_PART : row.PART_CD_NM,
									RESOURCE_CD : row.RESOURCE_CD_NM,
									WC_SHIFT  : null,
									YYYYMMDD  : null,
									WORKING_TIME : 'undefined', 
									OVER_TIME  : 'undefined'
								};
								
							    planData.WC_SHIFT  = spType;
								planData.YYYYMMDD  = yyyymmdd;
								 
								var find_idx = null;
								for(i = 0; i < salesPlanDatas.length; i++){
									 
									 if( salesPlanDatas[i].PROD_PART == row.PART_CD_NM 
										 && salesPlanDatas[i].RESOURCE_CD == row.RESOURCE_CD_NM
										 && salesPlanDatas[i].WC_SHIFT == spType
										 && salesPlanDatas[i].YYYYMMDD == yyyymmdd
									   ){
										   find_idx = i;
										   break;
									   }
								}
								 
								if(find_idx != null){
									if(wtype == 'WORK' ){
										salesPlanDatas[i].WORKING_TIME = value;
									}else if(wtype == 'OVERTIME' ){ 
										salesPlanDatas[i].OVER_TIME = value;
									}
									 
								}else{
									if(wtype == 'WORK' ){
										planData.WORKING_TIME = value;
									}else if(wtype == 'OVERTIME' ){ 
										planData.OVER_TIME   = value;
								    }
									 
									salesPlanDatas.push(planData);
								}
							}
						} 
					});
				});
				
				// 실제저장
				FORM_SAVE              = {}; //초기화
				FORM_SAVE._mtd         = "saveUpdate";
				FORM_SAVE.tranData     = [
					{outDs : "saveCnt", _siq : "aps.static.workCalendarRsc", grdData : salesPlanDatas}
				];
				
				gfn_service({
					url    : GV_CONTEXT_PATH + "/biz/obj",
					data   : FORM_SAVE,
					success: function(data) {
						alert('<spring:message code="msg.saveOk"/>');
						workCalendar.workCalendarGrid.grdMain.cancel();
						
						$.each(jsonRows, function(i, row) {
							workCalendar.workCalendarGrid.dataProvider.setRowState(row._ROWNUM-1, 'none', true);
						});
					   
						workCalendar.workCalendarGrid.dataProvider.clearSavePoints();
						workCalendar.workCalendarGrid.dataProvider.savePoint(); //초기화 포인트 저장
					}
				}, "obj");
			});
			
		},
		
		getWeekArray : function (){
			gfn_service({
			    async   : false,
			    url     : GV_CONTEXT_PATH + "/biz/obj",
			    data    : {
	    			_mtd : "getList",
	    			fromCal : $("#fromCal").val().replace("-","").replace("-",""), 
	    			toCal : $("#toCal").val().replace("-","").replace("-",""),
	    			tranData : [
	    				{outDs : "weekList", _siq : "aps.static.workCalendarRscWeek"}
	    			]
			    },
			    success :function(data) {
			    	
			    	weekArray = [];
			    	var dataLen = data.weekList.length;
			    	
			    	for(var i = 0; i < dataLen; i++){
			    		
			    		var temps = { 
			    			cd : data.weekList[i].CD,
			    			nm : data.weekList[i].NM 
			    		};
			    		weekArray.push(temps);
			    	}
			    }
			}, "obj");
		},
		
		gridCallback : function (resList, calDay) {
			  
			gfn_service({
			    async   : false,
			    url     : GV_CONTEXT_PATH + "/biz/obj",
			    data    : {
	    			_mtd : "getList",
	    			tranData : [
	    				{outDs : "authorityList", _siq : "aps.static.workCalendarRscAuthority"},
	    				{outDs : "routingList", _siq : "aps.static.workCalendarRsRouting"}
	    			]
			    },
			    success :function(data) {
			    	
			    	if(data.authorityList.length != 0)
                    {
                        
                        for(i = 0; i < data.authorityList.length; i++ )
                        {
                            // 곹통권한 소유할 경우 Material routing editable 처리
                            if(data.authorityList[i].ROLE_CD == "PRO0009"||data.authorityList[i].ROLE_CD == "PRO0010"||data.authorityList[i].ROLE_CD == "PRO0011" )
                            {
                                data.routingList.push({CODE_CD:"3-R"});
                                data.routingList.push({CODE_CD:"3-W"});
                            }   
                        }
                        
                        
                    }
			    	
			    	var dataLen = data.routingList.length;
			    	var fileds = workCalendar.workCalendarGrid.dataProvider.getFields();
					var cutoff_flag = $("#cutOffFlag").val();
					
			    	
			    	for(var i = 0; i < dataLen; i++){
			    		
			    		var codeCd = data.routingList[i].CODE_CD;
			    		$.each(resList, function(n, v){
			    			
			    			                  
			    			var routingCd = v.ROUTING_ID;
							for (var j = 2; j < fileds.length; j++) {
								
								var fieldName = fileds[j].fieldName;
								var fields_len = fileds[j];
								
								if (fieldName != 'PART_CD_NM' && fieldName != 'POQ_CD' && fieldName != 'POQ_CD_NM' && fieldName != 'WC_MGR_NM_NM' && fieldName != 'WC_MGR_NM' && fieldName != 'WC_CD_NM' && fieldName != 'WC_NM_NM' 
									&& fieldName != 'WORKER_GROUP_NM' && fieldName != 'RESOURCE_CD_NM' && fieldName != 'RESOURCE_NM_NM' && fieldName != "ROUTING_ID_NM"){
									        
							        if(cutoff_flag =='N'){
							        	
							        	if(codeCd == routingCd){ 
							        	  workCalendar.workCalendarGrid.grdMain.setCellStyles(n, fieldName, "editStyle");
						    			}
								        	
							        	
							        }
								}
							}
							
							// EDIT_FLAG
							$.each(v, function(attr, value){
								if (attr.indexOf("EDIT_FLAG") > -1){
									if(value == "N"){
										var workCd = attr.substring(0, 11) + "_WORK";
										var overtimeCd = attr.substring(0, 11) + "_OVERTIME";
										workCalendar.workCalendarGrid.grdMain.setCellStyles(n, workCd, "noneEditStyle");
										workCalendar.workCalendarGrid.grdMain.setCellStyles(n, overtimeCd, "noneEditStyle");
									}
								}
							}); 
							
			    		});
			    	}
			    	
			    	
			    	//쉬는날, 반나절 일하는날 색깔 변겨
			    	if (FORM_SEARCH.sql == 'N') {
			    		var cols = workCalendar.workCalendarGrid.grdMain.getColumns();
						var wcType = $("#workType").val() == '' ? 'ALL' : $("#workType").val() ;
						
						for (var i = 2; i < cols.length; i++) {
							
							var colName = cols[i].name;
							
							if (colName != 'PART_CD_NM' && colName != 'POQ_CD_NM' && colName != 'WC_MGR_NM_NM' && colName != 'WC_CD_NM' && colName != 'WC_NM_NM' 
								&& colName != 'RESOURCE_CD_NM' && colName != 'RESOURCE_NM_NM' && colName != 'WORKER_GROUP_NM'&& colName != "ROUTING_ID_NM"){
								
								
								var header = workCalendar.workCalendarGrid.grdMain.getColumnProperty(colName, "header" );
								workCalendar.workCalendarGrid.grdMain.setColumnProperty(colName, "header", header);
								workCalendar.workCalendarGrid.grdMain.setColumnProperty(colName, "width", 160);
								
								$.each(calDay, function(n, v){
									
									var yyyymmdd = v.YYYYMMDD;
									var dayOffFlag = v.DAY_OFF_FLAG;
									
									if(colName == yyyymmdd){
										if(dayOffFlag == 0){
											workCalendar.workCalendarGrid.grdMain.setColumnProperty(cols[i].columns[0].columns[0].name,"styles",{foreground :"#f44242"});
											workCalendar.workCalendarGrid.grdMain.setColumnProperty(cols[i].columns[0].columns[1].name,"styles",{foreground :"#f44242"});
											workCalendar.workCalendarGrid.grdMain.setColumnProperty(cols[i].columns[1].columns[0].name,"styles",{foreground :"#f44242"});
											workCalendar.workCalendarGrid.grdMain.setColumnProperty(cols[i].columns[1].columns[1].name,"styles",{foreground :"#f44242"});
											
											workCalendar.workCalendarGrid.grdMain.setColumnProperty(colName, "header", {"styles" :{"foreground":"#f44242"}});
											workCalendar.workCalendarGrid.grdMain.setColumnProperty(cols[i].columns[0].name,"header", {"styles" :{"foreground":"#f44242"}});
											workCalendar.workCalendarGrid.grdMain.setColumnProperty(cols[i].columns[1].name,"header", {"styles" :{"foreground":"#f44242"}});
											
											workCalendar.workCalendarGrid.grdMain.setColumnProperty(cols[i].columns[0].columns[0].name,"header", {"styles" :{"foreground":"#f44242"}});
											workCalendar.workCalendarGrid.grdMain.setColumnProperty(cols[i].columns[0].columns[1].name,"header", {"styles" :{"foreground":"#f44242"}});
											workCalendar.workCalendarGrid.grdMain.setColumnProperty(cols[i].columns[1].columns[0].name,"header", {"styles" :{"foreground":"#f44242"}});
											workCalendar.workCalendarGrid.grdMain.setColumnProperty(cols[i].columns[1].columns[1].name,"header", {"styles" :{"foreground":"#f44242"}});
										}else if(dayOffFlag == 0.5){
											workCalendar.workCalendarGrid.grdMain.setColumnProperty(cols[i].columns[1].columns[1].name,"styles",{borderRight:"#8C8C8C,1"});
											workCalendar.workCalendarGrid.grdMain.setColumnProperty(cols[i].columns[0].columns[0].name,"styles",{foreground :"#1828db"});
											workCalendar.workCalendarGrid.grdMain.setColumnProperty(cols[i].columns[0].columns[1].name,"styles",{foreground :"#1828db"});
											workCalendar.workCalendarGrid.grdMain.setColumnProperty(cols[i].columns[1].columns[0].name,"styles",{foreground :"#1828db"});
											workCalendar.workCalendarGrid.grdMain.setColumnProperty(cols[i].columns[1].columns[1].name,"styles",{foreground :"#1828db"});
											
											workCalendar.workCalendarGrid.grdMain.setColumnProperty(colName, "header", {"styles" :{"foreground":"#1828db"}});
											workCalendar.workCalendarGrid.grdMain.setColumnProperty(colName, "header", {"styles" :{"borderRight":"#8C8C8C,1"}});
											workCalendar.workCalendarGrid.grdMain.setColumnProperty(cols[i].columns[1].name, "header", {"styles" :{"borderRight":"#8C8C8C,1"}});
											workCalendar.workCalendarGrid.grdMain.setColumnProperty(cols[i].columns[1].columns[1].name, "header", {"styles" :{"borderRight":"#8C8C8C,1"}});
											
											workCalendar.workCalendarGrid.grdMain.setColumnProperty(cols[i].columns[0].name,"header", {"styles" :{"foreground":"#1828db"}});
											workCalendar.workCalendarGrid.grdMain.setColumnProperty(cols[i].columns[1].name,"header", {"styles" :{"foreground":"#1828db"}});
											
											workCalendar.workCalendarGrid.grdMain.setColumnProperty(cols[i].columns[0].columns[0].name,"header", {"styles" :{"foreground":"#1828db"}});
											workCalendar.workCalendarGrid.grdMain.setColumnProperty(cols[i].columns[0].columns[1].name,"header", {"styles" :{"foreground":"#1828db"}});
											workCalendar.workCalendarGrid.grdMain.setColumnProperty(cols[i].columns[1].columns[0].name,"header", {"styles" :{"foreground":"#1828db"}});
											workCalendar.workCalendarGrid.grdMain.setColumnProperty(cols[i].columns[1].columns[1].name,"header", {"styles" :{"foreground":"#1828db"}});
										}
										return false;
									}
								});
							}else{
								if(colName == 'WC_CD_NM' || colName == 'WC_NM_NM' || colName == 'RESOURCE_CD_NM' || colName == 'RESOURCE_NM_NM'  ){
									headerTextChange(wcType, colName);
								}
							}
						}
			    		
			    	}
		    	}
			}, "obj");			
			gfn_setFixed(workCalendar.workCalendarGrid.grdMain, DIMENSION.user.length, 0, null);
			
		},
		popup_auth : function () {
			
			gfn_service({
			    async   : false,
			    url     : GV_CONTEXT_PATH + "/biz/obj",
			    data    : {
	    			_mtd : "getList",
	    			tranData : [
	    				{outDs : "authorityList", _siq : "aps.static.workCalendarRscPopup"}
	    			]
			    },
			    success :function(data) {
			    	
			    	var dataLen = data.authorityList.length;
			    	
			    	for(var i = 0; i < dataLen; i++){
			    		
			    		var menuCd = data.authorityList[i].MENU_CD;
			    		
			    		if( menuCd == "APS10401" ){
			    			$("#btnPopBasic").show();	 
			    		}
			    	}
			    }
			}, "obj");
		}
		
      
	};
	
	//리소스 타입 별로 헤더의 TEXT를 변경 처리
	function headerTextChange(wcType,columnName){
		
		var header = workCalendar.workCalendarGrid.grdMain.getColumnProperty(columnName, "header" );
		var txt = null;
		
		if(wcType == 'M' ){
			
			switch (columnName) {
		        case "WC_CD_NM"       : txt = '<spring:message code="lbl.wcCd_MACHINE" />';       break;
				case "WC_NM_NM"       : txt = '<spring:message code="lbl.wcNm_MACHINE" />';       break;
				case "RESOURCE_CD_NM" : txt = '<spring:message code="lbl.resourceCd_MACHINE" />'; break;
				case "RESOURCE_NM_NM" : txt = '<spring:message code="lbl.resourceNm_MACHINE" />'; break;	
	        }	
			
			
		}else if(wcType == "L" ){
			
			switch (columnName) {
		        case "WC_CD_NM"       : txt = '<spring:message code="lbl.wcCd_LABOR" />';       break;
				case "WC_NM_NM"       : txt = '<spring:message code="lbl.wcNm_LABOR" />';       break;
				case "RESOURCE_CD_NM" : txt = '<spring:message code="lbl.resourceCd_LABOR" />'; break;
				case "RESOURCE_NM_NM" : txt = '<spring:message code="lbl.resourceNm_LABOR" />'; break;	
	        }	
			
		}else{
			
			switch (columnName) {
		        case "WC_CD_NM"       : txt = '<spring:message code="lbl.wcCd_ALL" />';       break;
				case "WC_NM_NM"       : txt = '<spring:message code="lbl.wcNm_ALL" />';       break;
				case "RESOURCE_CD_NM" : txt = '<spring:message code="lbl.resourceCd_ALL" />'; break;
				case "RESOURCE_NM_NM" : txt = '<spring:message code="lbl.resourceNm_ALL" />'; break;	
			}	
			
		}
		
		header.text = txt;
		workCalendar.workCalendarGrid.grdMain.setColumnProperty(columnName, "header", header);
	}
	
	function gfn_getPlanIdwc(pOption) {
		
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
					
					$("#planId").on("change", function(e) {
						
						var fDs = gfn_getFindDataDsInDs(data.rtnList, {CODE_CD : {VALUE : $(this).val(), CONDI : "="}});
						
						if (fDs.length > 0) {
							
							var nowDate = fDs[0].APS_START_DATE;
								    
					        SW_END_DATE = weekdatecal(fDs[0].APS_START_DATE);
						    DATEPICKET(null,nowDate,SW_END_DATE);
							
							var sdt = gfn_getStringToDate(fDs[0].APS_START_DATE);
							var edt = gfn_getStringToDate(fDs[0].APS_END_DATE);
							
							$("#fromCal").datepicker("option", "minDate",sdt);
							$("#fromCal").datepicker("option", "maxDate",edt);
							$("#toCal").datepicker("option", "maxDate", edt);
							$("#cutOffFlag").val(fDs[0].CUT_OFF_FLAG);
						} 
						
					});
					
					$("#planId").trigger("change");
				}
			},"obj");
			
		} catch(e) {console.log(e);}
	}
	
    function dayReplace(headerName){
		
		headerName = gfn_replaceAll(headerName, "(SUN)", "(일)");
		headerName = gfn_replaceAll(headerName, "(MON)", "(월)");
		headerName = gfn_replaceAll(headerName, "(TUE)", "(화)");
		headerName = gfn_replaceAll(headerName, "(WED)", "(수)");
		headerName = gfn_replaceAll(headerName, "(THU)", "(목)");
		headerName = gfn_replaceAll(headerName, "(FRI)", "(금)");
		headerName = gfn_replaceAll(headerName, "(SAT)", "(토)");
		
		return headerName;
	}
    
    //2주 뒤 날짜 구함
    function weekdatecal(dt){
    	
    	if(dt != null ){
    		
    		yyyy = dt.substr(0,4);
        	mm = dt.substr(4,2);
        	dd = dt.substr(6,2);
        	
        	var dt_stamp = new Date(yyyy+"-"+mm+"-"+dd).getTime();
        	
        	var days = (( 7*2 ) -1); //2주후
    		    toDt = new Date(dt_stamp+(days*24*60*60*1000));
    		var rdt = toDt.getFullYear() + '' + (toDt.getMonth() + 1  < 10 ? '0' + (toDt.getMonth() + 1 ) : toDt.getMonth() + 1 ) + (toDt.getDate() < 10 ? '0' + toDt.getDate() : toDt.getDate());
				
    	}else{
    		rdt = weekdatecal;
    	}
    	
    	return rdt
    	
    }
	
	//조회
	var fn_apply = function (sqlFlag) {
		
		// 디멘젼, 메져
		gfn_getMenuInit();
		
		workCalendar.getBucket(sqlFlag); //2. 버켓정보 조회
    	
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
   		FORM_SEARCH.dimList    = DIMENSION.user;
   		FORM_SEARCH.meaList    = MEASURE.user;
   		FORM_SEARCH.bucketList = BUCKET.query;
   		FORM_SEARCH.hiddenList = BUCKET.hidden;
   		
		workCalendar.search();
		workCalendar.excelSubSearch();
	}

	// onload 
	$(document).ready(function() {
		workCalendar.init();
		workCalendar.workCalendarGrid.grdMain.onKeyUp = function (grid, key, ctrl, shift, alt) {
		   if(key == 46){  //Delete Key
			  gfn_selBlockDelete(grid,workCalendar.workCalendarGrid.dataProvider);  
		   }
		};
		workCalendar.workCalendarGrid.grdMain.onShowHeaderTooltip = function (grid, column, value) {
				   
			if(column.columns != undefined && column.columns){
				
				var addText = "";
				
				$.each(weekArray,function(cd,Obj){
				   if(Obj.cd == value) addText = Obj.nm+" ";
				});
		    	return addText + value;
		    }else{
		       return value;	
		    }
		}			
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
					<div class="view_combo" id="divProdPart"></div>
					<div class="view_combo" id="divPlanId">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.planId"/></div>
							<div class="iptdv borNone">
								<select id="planId" name="planId" class="iptcombo"></select>
							</div>
						</div>
					</div>
					
					<input type="hidden" id="cutOffFlag" name="cutOffFlag"/>
					<div class="view_combo" id="divProdOrQc"></div>
					<div class="view_combo" id="divWcType"></div>
					<div class="view_combo" id="divWorkplaces"></div>
					<div class="view_combo" id="divWorkerGroup"></div>
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
			<!-- <div class="use_tit">
				<h3>My Opportunities</h3> <h4>- recently created</h4>
			</div> -->
			<div class="scroll">
				<!-- 그리드영역 -->
				<div id="realgrid" style="width: 100%;" class="realgrid1"></div>
			</div>
			<div class="cbt_btn" style="height:25px">
				<div class="bleft">
					<a href="javascript:;" style='display:none' id="btnPopBasic" class="app1 roleWrite"><spring:message code="lbl.btnWcCalendarRsc" /></a>
				</div>
				<div class="bright">
					<a href="javascript:;" id="btnReset" class="app1"><spring:message code="lbl.reset" /></a>
					<a href="javascript:;" id="btnSave" class="app2 roleWrite"><spring:message code="lbl.save" /></a>
				</div>
			</div>
		</div>
    </div>
</body>
</html>
