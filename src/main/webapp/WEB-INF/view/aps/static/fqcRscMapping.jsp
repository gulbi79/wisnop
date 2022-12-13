<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	<!-- Aging 재고 Trend -->
	<script type="text/javascript">

	var enterSearchFlag = "Y";
	var searchData = null;
	var subField = [];
	var subPartField = {};
	var fqcRscMapping = {

		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.fqcRscMappingGrid.initGrid();
		},
		
		_siq    : "aps.static.fqcRscMapping",
		
		initFilter : function() {
		   
			var upperWorkPlaces = {
				childId   : ["workplaces"],
				childData : [this.comCode.codeMapEx.WORK_PLACES_CD]
			};
			
			// 콤보박스
			gfn_setMsComboAll([
				{target : 'divProdPart', id : 'prodPart', title : '<spring:message code="lbl.prodPart2"/>', data : this.comCode.codeMap.PROD_PART, exData:["*"],event : upperWorkPlaces}
			   ,{target : 'divWorkplaces', id : 'workplaces', title : '<spring:message code="lbl.workplaces"/>', data : this.comCode.codeMapEx.WORK_PLACES_QC_CD, exData:["*"]}
			   ,{target : 'divCampus', id : 'campus', title : '<spring:message code="lbl.campus"/>', data : this.comCode.codeMap.CAMPUS_CD, exData:["*"]}
			   
			]);
		},
		
		/*
		* common Code 
		*/
		comCode : {
			codeMap : null,
			codeMapEx : null,
			codeMapRx : null,
			codeReptMap : null,
			
			initCode : function () {
				var grpCd = 'PROD_PART,CAMPUS_CD,FLAG_YN';
				this.codeMap = gfn_getComCode(grpCd, 'N'); //공통코드 조회
				this.codeMapEx = gfn_getComCodeEx(["WORK_PLACES_QC_CD"]);
				this.codeMapRx = gfn_getComCodeEx(["FQC_ROUTE_TYPE"]);
			}
		},
	
		/* 
		* grid  선언
		*/
		fqcRscMappingGrid : {
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
				
				this.grdMain.addCellStyles([{
					id         : "displayEditStyle",
					editable   : true,
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
					throwValidationError: true,
					numberChars: ","
				});
				
				var fields = [
					{ fieldName : "BU_CD" , dataType : 'text' },
					{ fieldName : "PART_CD" , dataType : 'text' },
					{ fieldName : "PART_NM" , dataType : 'text' },
					{ fieldName : "WC_CD" , dataType : 'text' },
					{ fieldName : "WC_NM" , dataType : 'text' },
					{ fieldName : "RESOURCE_CD" , dataType : 'text' },
					{ fieldName : "RESOURCE_NM" , dataType : 'text' },
					{ fieldName : "CAMPUS_CD" , dataType : 'text' },
					{ fieldName : "CAMPUS_NM" , dataType : 'text' }
				];
				
				var route_len = fqcRscMapping.comCode.codeMapRx.FQC_ROUTE_TYPE.length;
				subField = [];
				subPartField = {};
				for (var z=0;z< route_len;z++){
					
					var t_arr = { fieldName : fqcRscMapping.comCode.codeMapRx.FQC_ROUTE_TYPE[z].CODE_CD , dataType : 'text' }
				    fields.push(t_arr);
					
					
					subField.push({"CD" : fqcRscMapping.comCode.codeMapRx.FQC_ROUTE_TYPE[z].CODE_CD});
					subPartField[fqcRscMapping.comCode.codeMapRx.FQC_ROUTE_TYPE[z].CODE_CD] = fqcRscMapping.comCode.codeMapRx.FQC_ROUTE_TYPE[z].CODE_NM;
			     }  
				
				this.dataProvider.setFields(fields);
				
				var columns = [
					{
						name         : "PROD_PART",
						fieldName    : "PART_NM",
						editable     : false,
						header       : { text: '<spring:message code="lbl.prodPart2"/>' },
						styles       : { textAlignment: "near", background : "rgba(237, 247, 253, 1)" },
						width        : 80,
						mergeRule    : {
			                criteria: "value"
			             }
					},
					{
						name         : "WC_CD",
						fieldName    : "WC_CD",
						editable     : false,
						header       : { text: '<spring:message code="lbl.workplacesCode"/>' },
						styles       : { background : "rgba(237, 247, 253, 1)", textAlignment: "near" },
						mergeRule    : {
			                criteria: "prevvalues + value"
			             },
						width        : 100,
					},
					{
						name         : "WC_NM",
						fieldName    : "WC_NM",
						editable     : false,
						header       : { text: '<spring:message code="lbl.workplacesName"/>' },
						styles       : { background : "rgba(237, 247, 253, 1)", textAlignment: "near" },
						mergeRule    : {
			                criteria: "prevvalues + value"
			             },
						width        : 140,
					},
					{
						name         : "RESOURCE_CD",
						fieldName    : "RESOURCE_CD",
						editable     : false,
						header       : { text: '<spring:message code="lbl.facilityCode"/>' },
						styles       : { background : "rgba(237, 247, 253, 1)", textAlignment: "near" },
						width        : 100,
					},
					{
						name         : "RESOURCE_NM",
						fieldName    : "RESOURCE_NM",
						editable     : false,
						header       : { text: '<spring:message code="lbl.facilityName"/>' },
						styles       : { background : "rgba(237, 247, 253, 1)", textAlignment: "near" },
						width        : 140,
					},
					{
						name         : "CAMPUS_CD",
						fieldName    : "CAMPUS_NM",
						editable     : false,
						header       : { text: '<spring:message code="lbl.campus"/>' },
						styles       : { background : "rgba(237, 247, 253, 1)", textAlignment: "center" },
						width        : 100,
					}
					 
				];
				
				for (var z=0;z< route_len;z++){
					
					var c_arr = {
									name         : fqcRscMapping.comCode.codeMapRx.FQC_ROUTE_TYPE[z].CODE_CD+"_MES",
									fieldName    : fqcRscMapping.comCode.codeMapRx.FQC_ROUTE_TYPE[z].CODE_CD,
									type         : "data",
									editable     : true,
									header       : { text: fqcRscMapping.comCode.codeMapRx.FQC_ROUTE_TYPE[z].CODE_CD },
									styles       : { background : gv_noneEditColor, textAlignment: "center" },
									width        : 100,
									lookupDisplay : true,
							        editor  : {"type": "dropDown", "textAlignment": "center" },
							        values: [
							            	"Y",
							                "N"
							            ],
							        labels: [
							            	"Y",
							                "N"
							            ]
							        
								};
					columns.push(c_arr);
				}  
				this.grdMain.setColumns(columns);
				
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
				fqcRscMapping.save();
			});
			
			$("#btnReset").on('click', function (e) {
				fqcRscMapping.fqcRscMappingGrid.grdMain.cancel();
				fqcRscMapping.fqcRscMappingGrid.dataProvider.rollback(fqcRscMapping.fqcRscMappingGrid.dataProvider.getSavePoints()[0]);
				fqcRscMapping.gridCallback(searchData);
			});
		},
		
		// 조회
		search : function () {
			
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.bucketList = subField;
			FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq}];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						
						fqcRscMapping.fqcRscMappingGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						fqcRscMapping.fqcRscMappingGrid.grdMain.cancel();
						fqcRscMapping.fqcRscMappingGrid.dataProvider.setRows(data.resList);
						
						fqcRscMapping.fqcRscMappingGrid.dataProvider.clearSavePoints();
						fqcRscMapping.fqcRscMappingGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(fqcRscMapping.fqcRscMappingGrid.dataProvider.getRowCount());
						
						searchData = data.resList;
						fqcRscMapping.gridCallback(data.resList);
					}
				}
			}
			gfn_service(aOption, "obj");
		},
		save : function(){
			
			try {
				fqcRscMapping.fqcRscMappingGrid.grdMain.commit(true);
			} catch (e) {
				alert('<spring:message code="msg.saveErrorCheck"/>\n'+e.message);
			}
			
			// 저장할 데이터 확인
			var jsonRows;
			
			jsonRows = gfn_getGrdSavedataAll(fqcRscMapping.fqcRscMappingGrid.grdMain);
			
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
						
						if ( attr != 'BU_CD' &&  
							 attr != 'CAMPUS_CD' &&
							 attr != 'CAMPUS_NM' &&
							 attr != 'PART_CD' &&
							 attr != 'PART_NM' &&
							 attr != 'RESOURCE_CD' &&
							 attr != 'RESOURCE_NM' &&
							 attr != 'WC_CD' &&
							 attr != 'WC_NM' &&
							 attr != '_ROWNUM' &&
							 attr != 'state'
						   ){
								if (typeof value !=  "undefined" ){
								
								if(value == null ) value ='';
								
									var planData = {
										RESOURCE_CD : row.RESOURCE_CD,
										FQC_ROUTING_TYPE : attr,
										VALID_FLAG  : value
									};
									
								 	salesPlanDatas.push(planData);	 
								}
						}	
						
					});
					
					
				});
				
				FORM_SAVE              = {}; //초기화
				FORM_SAVE._mtd         = "saveUpdate";
				FORM_SAVE.tranData     = [
					{outDs : "saveCnt1", _siq : "aps.static.fqcRscMapping", grdData : salesPlanDatas}
				];
				
				gfn_service({
					url    : GV_CONTEXT_PATH + "/biz/obj",
					data   : FORM_SAVE,
					success: function(data) {
						alert('<spring:message code="msg.saveOk"/>');
                        fqcRscMapping.fqcRscMappingGrid.grdMain.cancel();
						
						$.each(jsonRows, function(i, row) {
							fqcRscMapping.fqcRscMappingGrid.dataProvider.setRowState(row._ROWNUM-1, 'none',true);
						});
					   
						fqcRscMapping.fqcRscMappingGrid.dataProvider.clearSavePoints();
						fqcRscMapping.fqcRscMappingGrid.dataProvider.savePoint(); //초기화 포인트 저장
					}
				}, "obj");
			});
			
			
			
			
		},
		gridCallback : function (resList) {
			
			gfn_service({
			    async   : false,
			    url     : GV_CONTEXT_PATH + "/biz/obj",
			    data    : {
	    			_mtd : "getList",
	    			tranData : [
	    				{outDs : "authorityList", _siq : "aps.static.fqcRscMappingAuthority"}
	    			]
			    },
			    success :function(data) {
			    	
			    	var dataLen = data.authorityList.length;
			    	var fileds = fqcRscMapping.fqcRscMappingGrid.dataProvider.getFields();
			    	
			    	for(var i = 0; i < dataLen; i++){
			    		
			    		var menuCd = data.authorityList[i].MENU_CD;
			    		
			    		$.each(resList, function(n, v){
			    			
			    			var prodPart = v.PART_CD;
			    			var poqCd = v.POQ_CD;
			    			
							for (var j = 2; j < fileds.length; j++) {
								
								var fieldName = fileds[j].fieldName;
								var fields_len = fileds[j];
								var field_two = subPartField[fieldName];
								
								
								if (fieldName != 'PART_NM'  && fieldName != 'WC_CD' && fieldName != 'WC_NM'  && fieldName != 'RESOURCE_NM'  && fieldName != 'RESOURCE_CD' && fieldName != 'CAMPUS_NM'){
									
						        	if((menuCd == "APS20002" && prodPart == "LAM"       && field_two == prodPart)
							              || (menuCd == "APS20001" && prodPart == "TEL"       && field_two == prodPart) 
							        	  || (menuCd == "APS20003" && prodPart == "DIFFUSION" && field_two == prodPart)
							        	  || (menuCd == "APS20004" && prodPart == "MATERIAL"  && field_two == prodPart)
					        			){ //LAM 생산
						        		
						        		fqcRscMapping.fqcRscMappingGrid.grdMain.setCellStyles(n, fieldName, "editStyle");
					    			}
								}
							}
			    		});
			    	}
		    	}
			}, "obj");
		}
	};
	
	var fn_apply = function (sqlFlag) {
		
		// 디멘젼, 메져
		gfn_getMenuInit();
		
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
   		FORM_SEARCH.dimList    = DIMENSION.user;
   		FORM_SEARCH.meaList    = MEASURE.user;
		
		fqcRscMapping.search();
	}

	// onload 
	$(document).ready(function() {
		fqcRscMapping.init();
		fqcRscMapping.fqcRscMappingGrid.grdMain.onKeyUp = function (grid, key, ctrl, shift, alt) {
		   if(key == 46){  //Delete Key
			  gfn_selBlockDelete(grid,fqcRscMapping.fqcRscMappingGrid.dataProvider,'cols');  
		   }
		};
		colx = fqcRscMapping.fqcRscMappingGrid.grdMain.getColumns();
		var colsArray = ["TO01_MES","TO02_MES","LO01_MES","LO02_MES","DO01_MES","DO02_MES"]; 
		gfn_pasteValueToLabel(fqcRscMapping.fqcRscMappingGrid.grdMain,fqcRscMapping.fqcRscMappingGrid.dataProvider,colsArray);
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
					<div class="view_combo">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.facility"/></div>
							<input type="text" id="facility" name="facility" class="ipt">
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
			<!-- <div class="use_tit">
				<h3>My Opportunities</h3> <h4>- recently created</h4>
			</div> -->
			<div class="scroll">
				<!-- 그리드영역 -->
				<div id="realgrid" style="width: 100%;" class="realgrid1"></div>
			</div>
			<div class="cbt_btn" style="height:25px">
				<div class="bleft">
					<a href="javascript:;" style='display:none'  id="btnPopBasic" class="app1 roleWrite"><spring:message code="lbl.btnWcCalendar" /></a>
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
