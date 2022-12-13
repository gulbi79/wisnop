<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
<script type="text/javascript">
	var enterSearchFlag = "Y";
	
	var ovenSch = {
		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.grid.initGrid();
			this.events();
		},
		
		_siq    : "aps.static.ovenSch",
		
		comCode : {
			codeMapEx : null,
			codeMap   : null,
			initCode  : function() {
				var grpCd      = 'PROD_PART';
				this.codeMap   = gfn_getComCode(grpCd, 'Y'); 
				this.codeMapEx = gfn_getComCodeEx(["WORK_PLACES_CD"], null, {ovenFlag : "Y"});
			}
		},
		
		initFilter : function() {
			var upperWorkPlaces = {
				childId   : ["workplaces"],
				childData : [this.comCode.codeMapEx.WORK_PLACES_CD],
			};
			
			gfn_setMsComboAll([
				{target : 'divProdPart'   , id : 'prodPart'   , title : '<spring:message code="lbl.prodPart2"/>'  , data : this.comCode.codeMap.PROD_PART       , exData:[""], option: {allFlag:"Y"}, event: upperWorkPlaces },
				{target : 'divWorkplaces' , id : 'workplaces' , title : '<spring:message code="lbl.workplaces"/>' , data : this.comCode.codeMapEx.WORK_PLACES_CD, exData:[""], option: {allFlag:"Y"}}
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
				
				this.setOptions();
				
				this.grdMain.onValidateColumn = function(grid, column, inserting, value) {
					var error = {};
					
					if(column.fieldName == "START_TIME" || column.fieldName == "END_TIME") {
						if(value != '' && value != null) {

							if (value > 2400 ) {
								error.level = RealGridJS.ValidationLevel.ERROR;
								error.message = '<spring:message code="msg.time"/>';
							}
							
							return error;
						}
					}
				};
			},
			
			setOptions : function() {
				this.grdMain.setOptions({
					checkBar: { visible : true },
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
				ovenSch.grid.grdMain.cancel();
				ovenSch.grid.dataProvider.rollback(ovenSch.grid.dataProvider.getSavePoints()[0]);
				
				$.each(ovenSch.getReset, function(n, v) {
					ovenSch.grid.dataProvider.setValue(v, "ADD_YN", "Y");
    				ovenSch.grid.dataProvider.setRowState(v, "none");
				});
				
				ovenSch.grid.grdMain.setCellStyles(ovenSch.getReset, "START_TIME", "editStyle");
		    	ovenSch.grid.grdMain.setCellStyles(ovenSch.getReset, "END_TIME", "editStyle");
			});
			
			$("#btnSave").on('click', function (e) {
				ovenSch.save();
			});
			
			$("#btnAddChild").on('click', function (e) {
				ovenSch.addRow();
			});
			
			$("#btnDeleteRows").on('click', function (e) {
				var rows = ovenSch.grid.grdMain.getCheckedRows();
				ovenSch.grid.dataProvider.removeRows(rows, false);
			});
			
			this.grid.grdMain.onKeyUp = function (grid, key, ctrl, shift, alt) {
				if(key == 46){  //Delete Key
					gfn_selBlockDelete(grid, ovenSch.grid.dataProvider, "cols");  
				}
			};
		},
		
		getBucket : function(sqlFlag) {
			if (!sqlFlag) {
				ovenSch.grid.gridInstance.setDraw();
				
				ovenSch.grid.grdMain.setColumnProperty("START_TIME", "displayRegExp","([0-9]{2})([0-9]{2})");
				ovenSch.grid.grdMain.setColumnProperty("START_TIME", "displayReplace","$1:$2");
				
				ovenSch.grid.grdMain.setColumnProperty("END_TIME"  , "displayRegExp","([0-9]{2})([0-9]{2})");
				ovenSch.grid.grdMain.setColumnProperty("END_TIME"  , "displayReplace","$1:$2");
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
					}else if(id == "divFacility"){
						EXCEL_SEARCH_DATA += $("#resource").val();
					}
				}
			});
		},
		
		search : function () {
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq}];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						ovenSch.grid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						ovenSch.grid.grdMain.cancel();
						
						ovenSch.grid.dataProvider.setRows(data.resList);
						ovenSch.grid.dataProvider.clearSavePoints();
						ovenSch.grid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(ovenSch.grid.dataProvider.getRowCount());
						
						ovenSch.gridCallback(data.resList);
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		getReset : [],
		
		gridCallback : function(resList) {
			gfn_service({
			    async   : false,
			    url     : GV_CONTEXT_PATH + "/biz/obj",
			    data    : {
	    			_mtd : "getList",
	    			tranData : [
	    				{outDs : "authorityList", _siq : this._siq + "Authority"}
	    			]
			    },
			    success :function(data) {
			    	
			    	ovenSch.getReset = [];
			    	
			    	var dataLen = data.authorityList.length;
			    	
			    	for(var i = 0; i < dataLen; i++){
			    		
			    		var menuCd = data.authorityList[i].MENU_CD;
			    		
			    		$.each(resList, function(n, v){
			    			
			    			var prodPart = v.PROD_PART_CD;
			    			if((menuCd == "APS11401" && prodPart == "LAM") || (menuCd == "APS11402" && prodPart == "TEL") || (menuCd == "APS11403" && prodPart == "DIFFUSION") || (menuCd == "APS11404" && prodPart == "MATERIAL")){ 
			    				ovenSch.getReset.push(n);
			    				ovenSch.grid.dataProvider.setValue(n, "ADD_YN", "Y");
			    				ovenSch.grid.dataProvider.setRowState(n, "none");
			    			}
			    		});
			    	}
			    	ovenSch.grid.grdMain.setCellStyles(ovenSch.getReset, "START_TIME", "editStyle");
		    	}
			}, "obj");
		},
		
		save : function() {
			//수정된 그리드 데이터만 가져온다.
			var grdData = gfn_getGrdSavedataAll(this.grid.grdMain);
			
	    	if (grdData.length == 0) {
				alert('<spring:message code="msg.noChangeData"/>');
				return;
	    	}
	    	
	    	//그리드 유효성 검사
	    	var arrColumn = ["START_TIME"];
	    	if (!gfn_getValidation(this.grid.gridInstance,arrColumn)) return;
	    	
			confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
				
				FORM_SAVE            = {}; //초기화
				FORM_SAVE._mtd       = "saveAll";
				FORM_SAVE.tranData   = [
					{outDs : "saveCnt", _siq : ovenSch._siq, grdData : grdData, mergeFlag : "Y"}
				];
				
				var ajaxOpt = {
					url     : GV_CONTEXT_PATH + "/biz/obj",
					data    : FORM_SAVE,
					success : function(data) {
						
						alert('<spring:message code="msg.saveOk"/>');
						fn_apply(false);
					},
				};
				
				gfn_service(ajaxOpt, "obj");
			});
		},
		
		addRow : function() {
			var current = this.grid.grdMain.getCurrent();
	        var rowIdx  = current.dataRow;
	        var addYn   = this.grid.dataProvider.getValue(rowIdx, "ADD_YN");
	        
	        if(addYn != "Y") {
	        	alert('<spring:message code="msg.unauthorized"/>');
	        	return;
	        }
	        
	        var companyCd    = this.grid.dataProvider.getValue(rowIdx,"COMPANY_CD");
	        var buCd         = this.grid.dataProvider.getValue(rowIdx,"BU_CD");
	        var plantCd      = this.grid.dataProvider.getValue(rowIdx,"PLANT_CD");
	        var prodPartCd   = this.grid.dataProvider.getValue(rowIdx,"PROD_PART_CD");
	        var campusCd     = this.grid.dataProvider.getValue(rowIdx,"CAMPUS_CD");
	        var seq          = this.grid.dataProvider.getValue(rowIdx,"SEQ");
	        
	        var prodPartNm   = this.grid.dataProvider.getValue(rowIdx,"PROD_PART_NM_NM");
	        var wcCd         = this.grid.dataProvider.getValue(rowIdx,"WC_CD_NM");
	        var wcNm         = this.grid.dataProvider.getValue(rowIdx,"WC_NM_NM");
	        var resourceCd   = this.grid.dataProvider.getValue(rowIdx,"RESOURCE_CD_NM");
	        var resourceNm   = this.grid.dataProvider.getValue(rowIdx,"RESOURCE_NM_NM");
	        var campusNm     = this.grid.dataProvider.getValue(rowIdx,"CAMPUS_NM_NM");
	        var ovenRunTime  = this.grid.dataProvider.getValue(rowIdx, "OVEN_RUN_TIME");
	        
	        var rowAddData = {
        		COMPANY_CD      : companyCd,
        		BU_CD           : buCd,
        		PLANT_CD        : plantCd,
        		PROD_PART_CD    : prodPartCd,
        		CAMPUS_CD       : campusCd,
        		OVEN_RUN_TIME    : ovenRunTime,
        		PROD_PART_NM_NM : prodPartNm,
        		WC_CD_NM        : wcCd,
        		WC_NM_NM        : wcNm,
        		RESOURCE_CD     : resourceCd,
        		RESOURCE_CD_NM  : resourceCd,
        		RESOURCE_NM_NM  : resourceNm,
        		CAMPUS_NM_NM    : campusNm,
        		OVEN_RUN_TIME_NM : ovenRunTime,
        		ADD_YN          : "Y"
	        };
	        
	        var rowCnt    = this.grid.dataProvider.getRowCount();
	        var addRowIdx = 0;
	        var preRn     = 0;
	        
	        for(var i=0; i < rowCnt; i++) {
	        	var prodPartCdStr   = ovenSch.grid.dataProvider.getValue(i,"PROD_PART_CD");
		        var wcCdStr         = ovenSch.grid.dataProvider.getValue(i,"WC_CD_NM");
		        var resourceCdStr   = ovenSch.grid.dataProvider.getValue(i,"RESOURCE_CD_NM");
		        var campusCdStr     = ovenSch.grid.dataProvider.getValue(i,"CAMPUS_CD");
	        	var rnStr           = ovenSch.grid.dataProvider.getValue(i,"RN_NM");
	        	
	        	
	        	if((prodPartCdStr == prodPartCd) && (wcCdStr == wcCd) && (resourceCdStr == resourceCd) && (campusCdStr == campusCd)) {
	        		addRowIdx = i;
	        		preRn     = rnStr;
	        	}
	        }
	        
			this.grid.dataProvider.insertRow(addRowIdx + 1, rowAddData);
	        this.grid.dataProvider.setValue(addRowIdx + 1, "RN_NM", Number(preRn) + 1);
	        
	        ovenSch.grid.grdMain.setCellStyles(addRowIdx + 1, "START_TIME", "editStyle");
		}
	};
	
	//조회
	var fn_apply = function (sqlFlag) {
		
		
		// 디멘전 정리
		DIMENSION.user = [];
		DIMENSION.user.push({DIM_CD:"PROD_PART_NM", DIM_NM:'<spring:message code="lbl.prodPart2"      />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"WC_CD"       , DIM_NM:'<spring:message code="lbl.workplacesCode" />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"WC_NM"       , DIM_NM:'<spring:message code="lbl.workplacesName" />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"RESOURCE_CD" , DIM_NM:'<spring:message code="lbl.facilityCode"   />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"RESOURCE_NM" , DIM_NM:'<spring:message code="lbl.facilityName"   />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"CAMPUS_NM"   , DIM_NM:'<spring:message code="lbl.campus"         />', LVL:10, DIM_ALIGN_CD:"C", WIDTH:100});
		
		DIMENSION.user.push({DIM_CD:"OVEN_RUN_TIME" , DIM_NM:'<spring:message code="lbl.ovenRnuTime"   />', LVL:10, DIM_ALIGN_CD:"R", WIDTH:80});
		DIMENSION.user.push({DIM_CD:"RN"          , DIM_NM:'<spring:message code="lbl.seq"            />', LVL:10, DIM_ALIGN_CD:"R", WIDTH:80});
		
		
		DIMENSION.hidden = [];
    	DIMENSION.hidden.push({CD:"COMPANY_CD"  , dataType:"text"});
    	DIMENSION.hidden.push({CD:"BU_CD"       , dataType:"text"});
    	DIMENSION.hidden.push({CD:"PLANT_CD"    , dataType:"text"});
    	DIMENSION.hidden.push({CD:"PROD_PART_CD", dataType:"text"});
    	DIMENSION.hidden.push({CD:"CAMPUS_CD"   , dataType:"text"});
    	DIMENSION.hidden.push({CD:"SEQ"         , dataType:"text"});
    	DIMENSION.hidden.push({CD:"ADD_YN"      , dataType:"text"});
		
    	ovenSch.getBucket(sqlFlag);
		
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
   		
   		ovenSch.search();
   		ovenSch.excelSubSearch();
	}
	
	function fn_setBeforeFieldsBuket() {
		var fields = [
			{fieldName: "START_TIME" , dataType : "text"},
			{fieldName: "END_TIME"   , dataType : "text"}
        ];
    	
    	return fields;
	}
	
	function fn_setBeforeColumnsBuket() {
		var columns = [	
			{
				name : "START_TIME", fieldName: "START_TIME", editable: false, header: {text: '<spring:message code="lbl.apsStartTime" javaScriptEscape="true" />'},
				styles: {textAlignment: "center", background : gv_noneEditColor},
				dataType : "text",
				width: 150,
				editor : {
					type : "text",
					mask : {
						editMask: "00:00",  
			            allowEmpty:true
			        }, 
					integerOnly  : true,
					textAlignment: "center"
				}
			}, {
				name : "END_TIME", fieldName: "END_TIME", editable: false, header: {text: '<spring:message code="lbl.apsEndTime" javaScriptEscape="true" />'},
				styles: {textAlignment: "center", background : gv_noneEditColor},
				dataType : "text",
				width: 150,
				editor : {
					type : "text",
					mask : {
						editMask: "00:00",  
			            allowEmpty:true
			        }, 
					integerOnly  : true,
					textAlignment: "center"
				}
			}
		];
		
		return columns;
	}
	
	// onload 
	$(document).ready(function() {
		ovenSch.init();
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
					<div class="view_combo" id="divFacility">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.facility"/></div>
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
			<div class="cbt_btn">
				<div class="bright">
					<a id="btnReset" href="#" class="app1 roleWrite"><spring:message code="lbl.reset"/></a>
					<a id="btnAddChild" href="#" class="app1 roleWrite"><spring:message code="lbl.add"/></a>
					<a id="btnDeleteRows" href="#" class="app1 roleWrite"><spring:message code="lbl.delete"/></a>
					<a id="btnSave" href="#" class="app2 roleWrite"><spring:message code="lbl.save"/></a>
				</div>
			</div>
		</div>
    </div>
</body>
</html>