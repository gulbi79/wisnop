<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
<script type="text/javascript">
	var enterSearchFlag = "Y";
	
	var resource = {
		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.grid.initGrid();
			this.events();
		},
		
		_siq    : "aps.static.resource",
		
		comCode : {
			codeMapEx : null,
			codeMap   : null,
			initCode  : function() {
				var grpCd      = 'PROD_PART,CAMPUS_CD,FLAG_YN,WORKER_GROUP,WC_SHIFT,RESOURCE_EFF_RATE';
				this.codeMap   = gfn_getComCode(grpCd, 'Y'); 
				this.codeMapEx = gfn_getComCodeEx(["WORK_PLACES_CD","APS_ROUTING_ID"],null,{tableNm:"TB_MST_RESOURCE", resourceType : "L"});
			}
		},
		
		initFilter : function() {
			var upperWorkPlaces = {
				childId   : ["workplaces"],
				childData : [this.comCode.codeMapEx.WORK_PLACES_CD],
			};
			
			gfn_setMsComboAll([
				{target : 'divProdPart'   , id : 'prodPart'   , title : '<spring:message code="lbl.prodPart2"/>'  , data : this.comCode.codeMap.PROD_PART       , exData:[""], event: upperWorkPlaces },
				{target : 'divWorkplaces' , id : 'workplaces' , title : '<spring:message code="lbl.workplaces"/>' , data : this.comCode.codeMapEx.WORK_PLACES_CD, exData:[""]},
				{target : 'divRoutingId'  , id : 'routingId'  , title : '<spring:message code="lbl.routing"/>' , data : this.comCode.codeMapEx.APS_ROUTING_ID, exData:[""]},
				{target : 'divCampus'     , id : 'campus'     , title : '<spring:message code="lbl.campus"/>'     , data : this.comCode.codeMap.CAMPUS_CD       , exData:[""]},
				{target : 'divFireWorkYn' , id : 'fireworkYn' , title : '<spring:message code="lbl.fireworkYn"/>' , data : this.comCode.codeMap.FLAG_YN         , exData:[  ], type : "S" },
				{target : 'divWorkerGroup', id : 'workerGroup', title : '<spring:message code="lbl.workerGroup"/>', data : this.comCode.codeMap.WORKER_GROUP    , exData:[""]}
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
				
				this.gridInstance.custBeforeBucketFalg = true;
				this.gridInstance.measureHFlag = true;		// 메저 행모드 안보이게..
				this.gridInstance.measureCFlag = true;
				
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
				
				this.grdMain.addCellStyles([{
					id         : "editNoneStyle",
					editable   : false,
					background : gv_noneEditColor
				}]);
				
				this.grdMain.setPasteOptions({
					applyNumberFormat: false,
					checkDomainOnly: false,
					checkReadOnly: true,
					commitEdit: true,
					enableAppend: true,
					enabled: true,
					eventEachRow: true,
					fillColumnDefaults: false,
					fillFieldDefaults: false,
					forceColumnValidation: false,
					forceRowValidation: false,
					noDataEvent: false,
					noEditEvent: false,
					selectBlockPaste: true,
					selectionBase: false,
					singleMode: false,
					startEdit: true,
					stopOnError: true,
					throwValidationError: true
				});
			}
		},
		
		events : function () {
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("#btnReset").on('click', function (e) {
				resource.grid.grdMain.cancel();
				resource.grid.dataProvider.rollback(resource.grid.dataProvider.getSavePoints()[0]);
				
				$.each(MEASURE.user, function() {
		    		resource.grid.grdMain.setCellStyles(resource.getReset.otherCol, this.CD, "editStyle");
		    	});
		    	
				resource.grid.grdMain.setCellStyles(resource.getReset.fireworkYn, "USE_FLAG", "editStyle");
		    	resource.grid.grdMain.setCellStyles(resource.getReset.fireworkYn, "FIREWORK_YN", "editStyle");
		    	resource.grid.grdMain.setCellStyles(resource.getReset.otherCol, "WC_SHIFT", "editStyle");
		    	resource.grid.grdMain.setCellStyles(resource.getReset.otherCol, "RESOURCE_EFF_RATE", "editStyle");
		    	resource.grid.grdMain.setCellStyles(resource.getReset.otherCol, "WORKER_GROUP", "editStyle");
			});
			
			$("#btnSave").on('click', function (e) {
				resource.save();
			});
			
			this.grid.grdMain.onEditRowChanged = function (grid, itemIndex, dataRow, field, oldValue, newValue) {
				var provider = resource.grid.dataProvider;
				var filedNm  = provider.getFieldName(field);
				
				if(filedNm == "FIREWORK_YN") {
					
					if(newValue == "Y") {
						$.each(MEASURE.user, function() {
				    		resource.grid.grdMain.setCellStyles(dataRow, this.CD, "editStyle");
				    	});
				    	
				    	resource.grid.grdMain.setCellStyles(dataRow, "WC_SHIFT", "editStyle");
				    	resource.grid.grdMain.setCellStyles(dataRow, "RESOURCE_EFF_RATE", "editStyle");
				    	resource.grid.grdMain.setCellStyles(dataRow, "WORKER_GROUP", "editStyle");
					} else {
						$.each(MEASURE.user, function() {
				    		resource.grid.grdMain.setCellStyles(dataRow, this.CD, "editNoneStyle");
				    		resource.grid.grdMain.setValue(dataRow, this.CD, "");
				    	});
				    	
						resource.grid.grdMain.setCellStyles(dataRow, "WC_SHIFT", "editNoneStyle");
				    	resource.grid.grdMain.setValue(dataRow, "WC_SHIFT", "");
				    	
				    	resource.grid.grdMain.setCellStyles(dataRow, "RESOURCE_EFF_RATE", "editNoneStyle");
				    	resource.grid.grdMain.setValue(dataRow, "RESOURCE_EFF_RATE", "");
						
				    	resource.grid.grdMain.setCellStyles(dataRow, "WORKER_GROUP", "editNoneStyle");
				    	resource.grid.grdMain.setValue(dataRow, "WORKER_GROUP", "");
					}
				}
			};
			
			this.grid.grdMain.onKeyUp = function (grid, key, ctrl, shift, alt) {
				if(key == 46){  //Delete Key
					gfn_selBlockDelete(grid, resource.grid.dataProvider);  
				}
			};
		},
		
		
		getBucket : function(sqlFlag) {
			if (!sqlFlag) {
		    	
		    	DIMENSION.hidden = [];
		    	DIMENSION.hidden.push({CD : "COMPANY_CD"  , dataType : "text"});
		    	DIMENSION.hidden.push({CD : "BU_CD"       , dataType : "text"});
		    	DIMENSION.hidden.push({CD : "PLANT_CD"    , dataType : "text"});
		    	DIMENSION.hidden.push({CD : "PROD_PART_CD", dataType : "text"});

		    	resource.grid.gridInstance.setDraw();
		    	
		    	$.each(MEASURE.user, function() {
		    		var col = resource.grid.grdMain.columnByName(this.CD);
		    		resource.grid.grdMain.setColumnProperty(this.CD, "editor", { type: "dropDown", domainOnly : true });
		    		col.values = gfn_getArrayExceptInDs(resource.comCode.codeMap.FLAG_YN, "CODE_CD", "");
					col.labels = gfn_getArrayExceptInDs(resource.comCode.codeMap.FLAG_YN, "CODE_NM", "");
					resource.grid.grdMain.setColumn(col);
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
					}else if(id == "divFireWorkYn"){
						EXCEL_SEARCH_DATA += $("#fireworkYn option:selected").text();
					}else if(id == "divRoutingId"){
						$.each($("#routingId option:selected"), function(i2, val2){
							
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
		},
		
		search : function () {
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq }];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						resource.grid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						resource.grid.grdMain.cancel();
						
						resource.grid.dataProvider.setRows(data.resList);
						resource.grid.dataProvider.clearSavePoints();
						resource.grid.dataProvider.savePoint(); 
						gfn_setSearchRow(resource.grid.dataProvider.getRowCount());
						gfn_setRowTotalFixed(resource.grid.grdMain);
						
						resource.gridCallback(data.resList);
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		getReset : {
			fireworkYn : [],
			otherCol   : []
		},
		
		gridCallback : function(resList) {
			gfn_service({
			    async   : false,
			    url     : GV_CONTEXT_PATH + "/biz/obj",
			    data    : {
	    			_mtd : "getList",
	    			tranData : [
	    				{outDs : "authorityList", _siq : this._siq + "Authority"},
	                    {outDs : "routingList", _siq : this._siq + "Routing"}
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
			    	
			    	
			    	resource.getReset.fireworkYn = [];
			    	resource.getReset.otherCol   = [];
			    	
			    	var dataLen = data.routingList.length;
			    	
			    	for(var i = 0; i < dataLen; i++){
			    		
			    		var codeCd = data.routingList[i].CODE_CD;
			    		
			    		$.each(resList, function(n, v){
			    			
			    			var routingId   = v.ROUTING_ID_NM;
			    			var fireworkYn = v.FIREWORK_YN;
			    			
			    			if(codeCd == routingId ){
			    				if(fireworkYn == "Y") {
			    					resource.getReset.otherCol.push(n);
			    				}
			    				resource.getReset.fireworkYn.push(n);
			    			}
			    		});
			    	}
			    	
			    	$.each(MEASURE.user, function() {
			    		resource.grid.grdMain.setCellStyles(resource.getReset.otherCol, this.CD, "editStyle");
			    	});
			    	
			    	resource.grid.grdMain.setCellStyles(resource.getReset.otherCol, "WC_SHIFT", "editStyle");
			    	resource.grid.grdMain.setCellStyles(resource.getReset.otherCol, "RESOURCE_EFF_RATE", "editStyle");
			    	resource.grid.grdMain.setCellStyles(resource.getReset.otherCol, "WORKER_GROUP", "editStyle");
			    	resource.grid.grdMain.setCellStyles(resource.getReset.fireworkYn, "FIREWORK_YN", "editStyle");
			    	resource.grid.grdMain.setCellStyles(resource.getReset.fireworkYn, "USE_FLAG", "editStyle");
		    	}
			}, "obj");
		},
		
		save : function() {
			var grdData = gfn_getGrdSavedataAll(this.grid.grdMain);
			
			var grdDataLen = grdData.length;
			if (grdDataLen == 0) {
				alert('<spring:message code="msg.noChangeData"/>');
				return;
			}
			
			confirm('<spring:message code="msg.confirmSave"/>', function() {
				
				var data1 = [];
				var data2 = [];
				
				$.each(grdData, function(idx, row) {
					var resourceData = {
						COMPANY_CD        : row.COMPANY_CD,
						BU_CD             : row.BU_CD,
						PLANT_CD          : row.PLANT_CD,
						RESOURCE_CD       : row.RESOURCE_CD2_NM,
						FIREWORK_YN       : row.FIREWORK_YN,
						WC_SHIFT          : row.WC_SHIFT,
						RESOURCE_EFF_RATE : row.RESOURCE_EFF_RATE,
						WORKER_GROUP      : row.WORKER_GROUP,
						USE_FLAG          : row.USE_FLAG,
						state             : row.state
					};
					
					data1.push(resourceData);
					
					$.each(MEASURE.user, function() {
						var mesCd   = this.CD;
						var mesData = eval("row." + mesCd);
						
						var resourceJobData = {
							COMPANY_CD   : row.COMPANY_CD,
							BU_CD        : row.BU_CD,
							PLANT_CD     : row.PLANT_CD,
							RESOURCE_CD  : row.RESOURCE_CD2_NM,
							JOB_CD       : this.CD,
							VALID_FLAG   : mesData,
							state        : row.state
						};
						
						if(mesData != undefined) {
							data2.push(resourceJobData);
						}
					});
				});
				
				FORM_SAVE = {}; //초기화
				FORM_SAVE._mtd   = "saveAll";
				FORM_SAVE.tranData = [
					{outDs : "saveCnt1", _siq : resource._siq, grdData : data1},
					{outDs : "saveCnt2", _siq : resource._siq + "Job", grdData : data2, mergeFlag : "Y"}
				];
				
	    		var serviceMap = {
	   				url: "${ctx}/biz/obj",
	                data: FORM_SAVE,
	                success:function(data) {
	                	alert('<spring:message code="msg.saveOk"/>');
	                	fn_apply();
	                }
	            }
	    		gfn_service(serviceMap, "obj");	
			});
		}
	};
	
	//조회
	var fn_apply = function (sqlFlag) {
		
		// 메져 조회
		gfn_getMenuInit();
		fn_getMenuInit();
		resource.getBucket(sqlFlag);
		
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
   		FORM_SEARCH.meaList    = MEASURE.user;
   		FORM_SEARCH.bucketList = BUCKET.query;
   		FORM_SEARCH.dimList    = DIMENSION.user;
    	FORM_SEARCH.hiddenList = DIMENSION.hidden;
    	
		resource.search();
		resource.excelSubSearch();
	}
	
	function fn_getMenuInit() {
		var params = $("#commonForm").serializeObject();
		params._mtd = "getList";
		params.tranData = [{outDs : "meaList", _siq : resource._siq + "Mes"}];
		gfn_service({
		    async : false,
		    url : GV_CONTEXT_PATH + "/biz/obj",
		    data : params,
		    success : function(data) {
		    	MEASURE.user = data.meaList;
		    }
		},"obj");
	}
	
	function fn_setBeforeFieldsBuket() {
		var fields = [
			{fieldName: "FIREWORK_YN"      , dataType : "text"},
			{fieldName: "WC_SHIFT"         , dataType : "text"},
			{fieldName: "RESOURCE_EFF_RATE", dataType : "text"},
			{fieldName: "WORKER_GROUP"     , dataType : "text"},
			{fieldName: "VALID_TO_DATE"    , dataType : "text"},
			{fieldName: "USE_FLAG"         , dataType : "text"}
        ];
    	
    	return fields;
	}
	
	function fn_setBeforeColumnsBuket() {
		var columns = [	
			{
				name : "FIREWORK_YN", fieldName: "FIREWORK_YN", editable: false, header: {text: '<spring:message code="lbl.fireworkYn" javaScriptEscape="true" />'},
				styles: {textAlignment: "center", background : gv_noneEditColor},
				dataType : "text",
				width: 80,
				editable : false,
				editor   : { type: "dropDown", domainOnly: true },
				values   : gfn_getArrayExceptInDs(resource.comCode.codeMap.FLAG_YN, "CODE_CD", ""),
				labels   : gfn_getArrayExceptInDs(resource.comCode.codeMap.FLAG_YN, "CODE_NM", ""),
				lookupDisplay: true
			}, {
				name : "WC_SHIFT", fieldName: "WC_SHIFT", editable: false, header: {text: '<spring:message code="lbl.wcShift" javaScriptEscape="true" />'},
				styles: {textAlignment: "center", background : gv_noneEditColor},
				dataType : "text",
				width: 80,
				editable : false,
				editor   : { type: "dropDown", domainOnly: true },
				values   : gfn_getArrayExceptInDs(resource.comCode.codeMap.WC_SHIFT, "CODE_CD", ""),
				labels   : gfn_getArrayExceptInDs(resource.comCode.codeMap.WC_SHIFT, "CODE_NM", ""),
				lookupDisplay: true
			},  {
				name : "RESOURCE_EFF_RATE", fieldName: "RESOURCE_EFF_RATE", editable: false, header: {text: '<spring:message code="lbl.resourceEffRate" javaScriptEscape="true" />'},
				styles: {textAlignment: "center", background : gv_noneEditColor},
				dataType : "text",
				width: 80,
				editable : false,
				editor   : { type: "number", domainOnly: true },
				values   : gfn_getArrayExceptInDs(resource.comCode.codeMap.RESOURCE_EFF_RATE, "CODE_CD", ""),
				labels   : gfn_getArrayExceptInDs(resource.comCode.codeMap.RESOURCE_EFF_RATE, "CODE_NM", ""),
				lookupDisplay: true
			},  {
				name : "WORKER_GROUP", fieldName: "WORKER_GROUP", editable: false, header: {text: '<spring:message code="lbl.workerGroup" javaScriptEscape="true" />'},
				styles: {textAlignment: "center", background : gv_noneEditColor},
				dataType : "text",
				width: 80,
				editable : false,
				editor   : { type: "dropDown", domainOnly: true },
				values   : gfn_getArrayExceptInDs(resource.comCode.codeMap.WORKER_GROUP, "CODE_CD", ""),
				labels   : gfn_getArrayExceptInDs(resource.comCode.codeMap.WORKER_GROUP, "CODE_NM", ""),
				lookupDisplay: true
			}, {
				name : "VALID_TO_DATE", fieldName : "VALID_TO_DATE", editable : false, header: {text: '<spring:message code="lbl.validToDate" javaScriptEscape="true" />'},
				styles : {textAlignment: "center", background : gv_noneEditColor},
				width : 70
			}, {
				name: "USE_FLAG",
                fieldName: "USE_FLAG",
                editable: false,
                lookupDisplay: true,
                values: gfn_getArrayExceptInDs(resource.comCode.codeMap.FLAG_YN, "CODE_CD", ""),
                labels: gfn_getArrayExceptInDs(resource.comCode.codeMap.FLAG_YN, "CODE_NM", ""),
                editor: {
                    type: "dropDown",
                    domainOnly: true,
                    textReadOnly: true,
                }, 
                header: {text: '<spring:message code="lbl.useYn"/>'},
                styles: {textAlignment: "center", background : gv_noneEditColor},
                width: 80,
                editButtonVisibility: "visible"
			}
		];
		
		return columns;
	}

	// onload 
	$(document).ready(function() {
		resource.init();
		
		//WORKER_GROUP
		var colsArray = ["WC_SHIFT", "WORKER_GROUP"];
		gfn_pasteValueToLabel(resource.grid.grdMain, resource.grid.dataProvider, colsArray);
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
					<div class="view_combo" id="divWorkplaces"></div>
					<div class="view_combo" id="divCampus"></div>
					<div class="view_combo" id="divFireWorkYn"></div>
					<div class="view_combo" id="divRoutingId"></div>
					<div class="view_combo" id="divWorkerGroup"></div>
					<div class="view_combo" id="divResource">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.resource"/></div>
							<input type="text" id="resource" name="resource" class="ipt">
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
			<div class="cbt_btn roleWrite">
				<div class="bright">
					<a href="javascript:;" id="btnReset" class="app1"><spring:message code="lbl.reset" /></a>
					<a href="javascript:;" id="btnSave"  class="app2"><spring:message code="lbl.save" /></a>
				</div>
			</div>
		</div>
    </div>
</body>
</html>