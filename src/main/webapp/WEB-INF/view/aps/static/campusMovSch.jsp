<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
<script type="text/javascript">
	var enterSearchFlag = "Y";
	
	var campusMovSch = {
		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.grid.initGrid();
			this.events();
		},
		
		_siq    : "aps.static.campusMovSch",
		
		comCode : {
			codeMapEx : null,			
			codeMap : null,
			
			initCode : function () {
				var grpCd = 'CAMPUS_CD';
				this.codeMap = gfn_getComCode(grpCd, 'Y'); 
			}
		},
		
		initFilter : function() {
			gfn_setMsComboAll([
				{target : 'divFromCampus', id : 'fromCampus', title : '<spring:message code="lbl.fromCampus"/>', data : this.comCode.codeMap.CAMPUS_CD, exData:["*"], type : "S"},
				{target : 'divToCampus'  , id : 'toCampus'  , title : '<spring:message code="lbl.toCampus"/>', data : this.comCode.codeMap.CAMPUS_CD, exData:["*"], type : "S"}
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
					
					if(column.fieldName == "START_TIME") {
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
				campusMovSch.grid.grdMain.cancel();
				campusMovSch.grid.dataProvider.rollback(campusMovSch.grid.dataProvider.getSavePoints()[0]);
			});
			
			$("#btnSave").on('click', function (e) {
				campusMovSch.save();
			});
			
			$("#btnAddChild").on('click', function (e) {
				campusMovSch.addRow();
			});
			
			$("#btnDeleteRows").on('click', function (e) {
				var rows = campusMovSch.grid.grdMain.getCheckedRows();
				campusMovSch.grid.dataProvider.removeRows(rows, false);
			});
			
			this.grid.grdMain.onKeyUp = function (grid, key, ctrl, shift, alt) {
				if(key == 46){  //Delete Key
					gfn_selBlockDelete(grid, campusMovSch.grid.dataProvider, "cols");  
				}
			};
		},
		
		getBucket : function(sqlFlag) {
			if (!sqlFlag) {
				campusMovSch.grid.gridInstance.setDraw();
				
				campusMovSch.grid.grdMain.setColumnProperty("START_TIME", "displayRegExp","([0-9]{2})([0-9]{2})");
				campusMovSch.grid.grdMain.setColumnProperty("START_TIME", "displayReplace","$1:$2");
				
				campusMovSch.grid.grdMain.setColumnProperty("END_TIME"  , "displayRegExp","([0-9]{2})([0-9]{2})");
				campusMovSch.grid.grdMain.setColumnProperty("END_TIME"  , "displayReplace","$1:$2");
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
					if(id == "divFromCampus"){
						EXCEL_SEARCH_DATA += $("#fromCampus option:selected").text();
					}else if(id == "divToCampus"){
						EXCEL_SEARCH_DATA += $("#toCampus option:selected").text();
					}
				}
			});
		},
		
		search : function () {
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq}];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj.do",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						campusMovSch.grid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						campusMovSch.grid.grdMain.cancel();
						
						campusMovSch.grid.dataProvider.setRows(data.resList);
						campusMovSch.grid.dataProvider.clearSavePoints();
						campusMovSch.grid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(campusMovSch.grid.dataProvider.getRowCount());
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		gridCallback : function(resList) {
		
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
					{outDs : "saveCnt", _siq : campusMovSch._siq, grdData : grdData, mergeFlag : "Y"}
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
		},
		
		addRow : function() {
			var current = this.grid.grdMain.getCurrent();
	        var rowIdx  = current.dataRow;
	        
	        var companyCd    = this.grid.dataProvider.getValue(rowIdx,"COMPANY_CD");
	        var buCd         = this.grid.dataProvider.getValue(rowIdx,"BU_CD");
	        var fromCampusCd = this.grid.dataProvider.getValue(rowIdx,"FROM_CAMPUS_CD");
	        var toCampusCd   = this.grid.dataProvider.getValue(rowIdx,"TO_CAMPUS_CD");
	        var seq          = this.grid.dataProvider.getValue(rowIdx,"SEQ");
	        var fromCampusNm = this.grid.dataProvider.getValue(rowIdx,"FROM_CAMPUS_NM_NM");
	        var toCampusNm   = this.grid.dataProvider.getValue(rowIdx,"TO_CAMPUS_NM_NM");
	        var moveTime     = this.grid.dataProvider.getValue(rowIdx,"MOVE_TIME_NM");
	      
	        var rowAddData = {
        		COMPANY_CD        : companyCd,
        		BU_CD             : buCd,
        		FROM_CAMPUS_CD    : fromCampusCd,
        		TO_CAMPUS_CD      : toCampusCd,
        		FROM_CAMPUS_NM_NM : fromCampusNm,
        		TO_CAMPUS_NM_NM   : toCampusNm,
	        };
	        
	        var rowCnt = this.grid.dataProvider.getRowCount();
	        var addRowIdx = 0;
	        var preRn = 0;
	        
	        for(var i=0; i < rowCnt; i++) {
	        	var data1 = campusMovSch.grid.dataProvider.getValue(i, "FROM_CAMPUS_CD");
	        	var data2 = campusMovSch.grid.dataProvider.getValue(i, "TO_CAMPUS_CD");
	        	var data3 = campusMovSch.grid.dataProvider.getValue(i, "RN_NM");
	        	
	        	if(fromCampusCd + toCampusCd == data1 + data2) {
	        		addRowIdx = i;
	        		preRn = data3;
	        	}
	        }
	        
	        this.grid.dataProvider.insertRow(addRowIdx + 1, rowAddData);
	        this.grid.dataProvider.setValue(addRowIdx + 1, "RN_NM", Number(preRn) + 1);
		}
	};
	
	//조회
	var fn_apply = function (sqlFlag) {
		// 디멘전 정리
		DIMENSION.user = [];
		DIMENSION.user.push({DIM_CD:"FROM_CAMPUS_NM", DIM_NM:'<spring:message code="lbl.fromCampus" />', LVL:10, DIM_ALIGN_CD:"C", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"TO_CAMPUS_NM"  , DIM_NM:'<spring:message code="lbl.toCampus" />'  , LVL:10, DIM_ALIGN_CD:"C", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"MOVE_TIME"     , DIM_NM:'<spring:message code="lbl.moveTime" />'  , LVL:10, DIM_ALIGN_CD:"C", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"RN"            , DIM_NM:'<spring:message code="lbl.seq" />'       , LVL:10, DIM_ALIGN_CD:"C", WIDTH:100});
		
		DIMENSION.hidden = [];
    	DIMENSION.hidden.push({CD:"COMPANY_CD"     , dataType:"text"});
    	DIMENSION.hidden.push({CD:"BU_CD"          , dataType:"text"});
    	DIMENSION.hidden.push({CD:"FROM_CAMPUS_CD" , dataType:"text"});
    	DIMENSION.hidden.push({CD:"TO_CAMPUS_CD"   , dataType:"text"});
    	DIMENSION.hidden.push({CD:"SEQ"            , dataType:"text"});
		
		campusMovSch.getBucket(sqlFlag);
		
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
   		
   		campusMovSch.search();
   		campusMovSch.excelSubSearch();
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
				name : "START_TIME", fieldName: "START_TIME", editable: true, header: {text: '<spring:message code="lbl.apsStartTime" javaScriptEscape="true" />'},
				styles: {textAlignment: "center", background : gv_editColor},
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
		campusMovSch.init();
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
					<div class="view_combo" id="divFromCampus"></div>
					<div class="view_combo" id="divToCampus"></div>
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