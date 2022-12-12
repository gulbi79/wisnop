<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp"%>

	<script type="text/javascript">

	var enterSearchFlag = "Y";
	var meetingLogMng = {
		init : function () {
			gfn_formLoad();
			this.events();
			this.comCode.initCode();
			this.logGrid.initGrid();
			DATEPICKET(null,-4,0)
		},
			
		_siq    : "snop.meetingMng.meetingLogMng",
		
		/*
		* common Code 
		*/
		comCode : {
			codeMap : null,
			
			initCode : function () {
				var grpCd    = "DP_PLAN_TYPE";
				this.codeMap = gfn_getComCode(grpCd, 'Y'); //공통코드 조회
				gfn_setMsCombo("PLAN_TYPE_CD", this.codeMap.DP_PLAN_TYPE, ["*"]); //BU //id,data,제외코드
			}
		},
	
		/* 
		* grid  선언
		*/
		logGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;

				this.setColumn();
				this.setOptions();
				this.gridEvents();
			},
			
			setColumn     : function () {
				var columns = 
				[
					{ 
						name: "PLAN_TYPE_CD", 
						fieldName : "PLAN_TYPE_CD", 
						editable : false, header : {text: '<spring:message code="lbl.planType" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						dynamicStyles : [{ criteria: ["state<>'c'","state='c'"], styles: ["background="+gv_noneEditColor,"background="+gv_requiredColor] }],
						width  : 180,
						editor : { type: "dropDown", domainOnly : true}, 
						values : gfn_getArrayExceptInDs(meetingLogMng.comCode.codeMap.DP_PLAN_TYPE, "CODE_CD", ""),
						labels : gfn_getArrayExceptInDs(meetingLogMng.comCode.codeMap.DP_PLAN_TYPE, "CODE_NM", ""),
						lookupDisplay : true,
						nanText : "",
						editButtonVisibility : "visible",
					}, {
						name : "PLAN_ID", fieldName: "PLAN_ID", editable: false, header: {text: '<spring:message code="lbl.planId" javaScriptEscape="true" />'},
						styles : {textAlignment: "near"},
						dynamicStyles : [{ criteria: ["state<>'c'","state='c'"], styles: ["background="+gv_noneEditColor,"background="+gv_requiredColor] }],
						width : 130,
					}, {
						name   : "SNOP_DATE", fieldName : "SNOP_DATE", header: {text: '<spring:message code="lbl.meetDate" javaScriptEscape="true" />'},
						styles : {textAlignment : "center", background : gv_requiredColor},
						editor : {type : "date", datetimeFormat : "yyyy-MM-dd"},
						width  : 180
					}, {
						name : "CREATE_DTTM", fieldName: "CREATE_DTTM", editable: false, header: {text: '<spring:message code="lbl.createDttm" javaScriptEscape="true" />'},
						styles: {textAlignment: "center", background : gv_noneEditColor},
						width: 180
					}, {
						name : "FILE_NM_ORG", fieldName : "FILE_NM_ORG", editable: false, header : {text: '<spring:message code="lbl.file" javaScriptEscape="true" />'},
						styles : {textAlignment : "near", background : gv_noneEditColor},
						width : 250,
						buttonVisibility:"visible" ,cursor: "pointer",button: "action"
					}
				];
				
				this.setFields(columns, ['COMPANY_CD', 'BU_CD', 'FILE_NO']);
				
				this.grdMain.setColumns(columns); 
			},
			
			setFields : function(cols, hiddenCols) {
				
				var fields = new Array();
				
				$.each(cols, function(i, v) {
					fields.push({fieldName : v.fieldName});
				});
				
				if (hiddenCols !== undefined && hiddenCols.length > 0) {
					for (hid in hiddenCols) {
						fields.push({fieldName : hiddenCols[hid]});
					}
				}
				
				this.dataProvider.setFields(fields);
			},
			
			setOptions : function () {
				this.grdMain.setOptions({
					checkBar: { visible : true },
					stateBar: { visible : true },
					sorting : { enabled : false},
				});

				this.dataProvider.setOptions({
					softDeleting : true
				});
			},
			
			gridEvents : function() {
				this.grdMain.onCurrentRowChanged = function (grid, oldRow, newRow) {
					var editable = (newRow < 0 || meetingLogMng.logGrid.dataProvider.getRowState(newRow) === "created");
					grid.setColumnProperty("PLAN_TYPE_CD", "editable", editable);
					grid.setColumnProperty("PLAN_ID",   "editable", editable);
				};
	
			  	/*
			  	//원클릭시 에디트 처리
				this.grdMain.onDataCellClicked = function (grid, index) {
					grid.showEditor();
				};
				*/
				
				//파일첨부
				this.grdMain.onCellButtonClicked = function (grid, itemIndex, column) {
					var rowState = meetingLogMng.logGrid.dataProvider.getRowState(itemIndex);
					if (rowState != "none" && rowState != "updated") {
						alert("저장 후 진행해주세요.");
						return;
					}
					
		       		var params = {
		       			COMPANY_CD   : grid.getValue(itemIndex, "COMPANY_CD"),		       				
		       			BU_CD        : grid.getValue(itemIndex, "BU_CD"),		       				
		       			PLAN_TYPE_CD : grid.getValue(itemIndex, "PLAN_TYPE_CD"),		       				
		       			PLAN_ID      : grid.getValue(itemIndex, "PLAN_ID"),		       				
	       				FILE_NO      : grid.getValue(itemIndex, "FILE_NO"),		       				
	       				_siq         : meetingLogMng._siq+"FileNo",		       				
		       			callback     : "fn_fileCallback",
		       		};
		       		gfn_comPopupOpen("FILE",params);
		       	}
			}
		},
	
		/*
		* event 정의
		*/
		events : function () {
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("#btnSave").on('click', function (e) {
				meetingLogMng.save();
			});
			
			$("#btnAddChild").on('click', function(e) {
				
				meetingLogMng.logGrid.grdMain.commit();
				
				var current = meetingLogMng.logGrid.grdMain.getCurrent();
				var row     = current.dataRow;
				var setCols = {};

				setCols.PLAN_TYPE_CD = FORM_SEARCH.PLAN_TYPE_CD;
				meetingLogMng.logGrid.dataProvider.insertRow(0, setCols);
			});
			
			$("#btnDeleteRows").on('click', function (e) {
				var rows = meetingLogMng.logGrid.grdMain.getCheckedRows();
				meetingLogMng.logGrid.dataProvider.removeRows(rows, false);
			});
			
			$("#btnReset").on('click', function (e) {
				meetingLogMng.logGrid.grdMain.cancel();
				meetingLogMng.logGrid.dataProvider.rollback(meetingLogMng.logGrid.dataProvider.getSavePoints()[0]);
			});
		},
		
		excelSubSearch : function (){
			
			EXCEL_SEARCH_DATA = '<spring:message code="lbl.planType" />' + " : ";
			EXCEL_SEARCH_DATA += $("#PLAN_TYPE_CD option:selected").text();
			EXCEL_SEARCH_DATA += '\n<spring:message code="lbl.meetDate" />' + " : ";
			EXCEL_SEARCH_DATA += $("#fromCal").val() + " ~ " + $("#toCal").val(); 
			
		},
		
		// 조회
		search : function () {
			
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq }];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj.do",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						meetingLogMng.logGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						meetingLogMng.logGrid.grdMain.cancel();
						
						meetingLogMng.logGrid.dataProvider.setRows(data.resList);
						meetingLogMng.logGrid.dataProvider.clearSavePoints();
						meetingLogMng.logGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(meetingLogMng.logGrid.dataProvider.getRowCount());
						
						meetingLogMng.logGrid.gridInstance.setFocusKeys();
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		save : function() {
			
			var grdData = gfn_getGrdSavedataAll(this.logGrid.grdMain);
			if (grdData.length == 0) {
				alert('<spring:message code="msg.noChangeData"/>');
				return;
			}

			//그리드 유효성 검사
			var arrColumn = ["PLAN_TYPE_CD", "PLAN_ID", "SNOP_DATE"];
			if (!gfn_getValidation(this.logGrid.gridInstance, arrColumn)) {
				return;
			}
				
			// PK 중복 체크 
			if (gfn_dupCheck(this.logGrid.grdMain, "PLAN_TYPE_CD|PLAN_ID")) {
				return;
			}
				
			confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
					
	    		//저장위치 처리
	    		meetingLogMng.logGrid.gridInstance.saveTopUpdKeys("COMPANY_CD|BU_CD|PLAN_TYPE_CD|PLAN_ID");
			 
				//저장
				FORM_SEARCH = {}; //초기화
				FORM_SEARCH._mtd   = "saveAll";
				FORM_SEARCH.tranData = [{outDs:"saveCnt",_siq : meetingLogMng._siq, grdData : grdData, custDupChkYn : {"insert":"Y"}}];
				
				var ajaxOpt = {
					url     : GV_CONTEXT_PATH + "/biz/obj.do",
					data    : FORM_SEARCH,
					success : function(data) {
						if (data.errCode == -10) {
							alert(gfn_getDomainMsg("msg.dupData", data.errLine));
							meetingLogMng.logGrid.grdMain.setCurrent({dataRow : data.errLine - 1, column : "TRANS_ID"});
						} else {
							alert('<spring:message code="msg.saveOk"/>');
							fn_apply(false);
						}
					},
				};
				
				gfn_service(ajaxOpt, "obj");
			});
		},
	};

	//조회
	var fn_apply = function (sqlFlag) {
		
		FORM_SEARCH     = $("#searchForm").serializeObject(); //초기화
		FORM_SEARCH.sql = sqlFlag;
		
		meetingLogMng.search();
		meetingLogMng.excelSubSearch();
	}
	
	//파일팝업 콜백
	var fn_fileCallback = function (fileNo, fileNm) {
		//console.log(fileNo+", "+fileNm);
		fn_apply();
	}

	// onload 
	$(document).ready(function() {
		meetingLogMng.init();
	});

	</script>

</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp"%>
	<!-- contents -->
	<div id="grid1" class="fconbox">
		<%@ include file="/WEB-INF/view/common/commonLocation.jsp"%>

		<!-- 조회조건 -->
		<div class="srhwrap">
			<form id="searchForm" name="searchForm" method="POST" onSubmit="return false;">
				<div class="srhcondi">
					<ul>
						<li>
							<strong><spring:message code="lbl.planType" /></strong>
							<div class="selectBox">
								<select id="PLAN_TYPE_CD" name=PLAN_TYPE_CD></select>
							</div>
						</li>
						<li>
							<strong><spring:message code="lbl.meetDate"/></strong>
							<input type="text" id="fromCal" name="fromCal" class="iptdate" maxLength="10"> <span class="ihpen">~</span>
							<input type="text" id="toCal" name="toCal" class="iptdate"  maxLength="10">
						</li>
					</ul>
				</div>
			</form>

			<div class="bt_btn">
				<a id="btnSearch" href="#" class="fl_app"> <spring:message code="lbl.search" /></a>
			</div>
		</div>
		<div class="scroll">
			<!-- 그리드영역 -->
			<div id="realgrid" class="realgrid1"></div>
		</div>
		<!-- 하단버튼 영역 -->
		<div class="cbt_btn roleWrite">
			<div class="bright">
				<%-- <a id="btnLocalApply"  href="#" class="app1"><spring:message code="lbl.apply"  /></a> --%> 
				<a id="btnReset"       href="#" class="app1"><spring:message code="lbl.reset" /></a> 
				<a id="btnAddChild"    href="#" class="app1"><spring:message code="lbl.add" /></a> 
				<a id="btnDeleteRows"  href="#" class="app1"><spring:message code="lbl.delete" /></a> 
				<a id="btnSave"        href="#" class="app2"><spring:message code="lbl.save" /></a>
			</div>
		</div>
	</div>
</body>
</html>
