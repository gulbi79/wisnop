<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp"%>

	<script type="text/javascript">

	var enterSearchFlag = "Y";
	
	var issueMng = {

		init : function () {
			
			gfn_formLoad();
			this.events();
			this.comCode.initCode();
			this.issueGrid.initGrid();
		},
			
		_siq    : "snop.meetingMng.issueMng",
		
		/*
		* common Code 
		*/ 
		comCode : {
			codeMap : null,
			
			initCode : function () {
				var grpCd    = "ISSUE_CD,CLOSE_YN";
				this.codeMap = gfn_getComCode(grpCd, 'Y'); //공통코드 조회
				
				gfn_setMsCombo("ISSUE_CD", this.codeMap.ISSUE_CD, ["*"]); //BU //id,data,제외코드
				gfn_setMsCombo("CLOSE_YN", this.codeMap.CLOSE_YN, ["*"]); //BU //id,data,제외코드
			}
		},
	
		/* 
		* grid  선언
		*/
		issueGrid : {
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
						name: "ISSUE_CD", 
						fieldName : "ISSUE_CD", 
						editable : false, header : {text: '<spring:message code="lbl.issueType" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						dynamicStyles : [{ criteria: ["state<>'c'","state='c'"], styles: ["background="+gv_noneEditColor,"background="+gv_requiredColor] }],
						width  : 100,
						editor : { type: "dropDown", domainOnly : true}, 
						values : gfn_getArrayExceptInDs(issueMng.comCode.codeMap.ISSUE_CD, "CODE_CD", ""),
						labels : gfn_getArrayExceptInDs(issueMng.comCode.codeMap.ISSUE_CD, "CODE_NM", ""),
						lookupDisplay : true,
						nanText : "",
						editButtonVisibility : "visible",
					}, {
						name : "ISSUE_ID", fieldName: "ISSUE_ID", editable: false, header: {text: '<spring:message code="Issue Id" javaScriptEscape="true" />'},
						styles : {textAlignment : "center", background : gv_noneEditColor},
						width : 100,
					}, {
						name : "TITLE", fieldName : "TITLE", header: {text: '<spring:message code="lbl.title" javaScriptEscape="true" />'},
						styles : {textAlignment: "near",background:gv_requiredColor},
						
						width : 250
					}, 
					
					{
						name : "CONTENT", fieldName : "CONTENT", header: {text: '<spring:message code="lbl.content" javaScriptEscape="true" />'},
						styles : {textAlignment: "near",background:gv_requiredColor},
						width : 250
					}, 
					
					
					
					/* {
						name : "CONTENT", fieldName : "CONTENT", header: {text: '<spring:message code="lbl.content" javaScriptEscape="true" />'},
						styles : {textAlignment: "near",background:gv_requiredColor, textWrap:'normal'},
						editor : {type:'multiline'},
						width : 250
						
						
					},  */
					
					
					
					
					
					
					
					
					
					
					{
						name : "REMARK", fieldName : "REMARK", editable: false, header : {text: '<spring:message code="lbl.remark" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						dynamicStyles : [{ criteria: ["state<>'c'","state='c'"], styles: ["background="+gv_noneEditColor,"background="+gv_requiredColor] }],
						width : 250,
						buttonVisibility:"visible" ,cursor: "pointer",button: "action"
					}, {
						name : "USER_NM", fieldName : "USER_NM", header : {text: '<spring:message code="lbl.manager" javaScriptEscape="true" />'},
						styles : {textAlignment : "center", background : gv_requiredColor},
						width : 80,
						buttonVisibility:"visible" ,cursor: "pointer",button: "action"
					}, {
						name : "PART_NM", fieldName : "PART_NM", editable: false, header : {text: '<spring:message code="lbl.partNm" javaScriptEscape="true" />'},
						styles : {textAlignment : "near", background : gv_requiredColor},
						width : 120,
						buttonVisibility:"visible" ,cursor: "pointer",button: "action"
					}, {
						name : "CREATE_DTTM", fieldName: "CREATE_DTTM", editable: false, header: {text: '<spring:message code="lbl.createDttm" javaScriptEscape="true" />'},
						styles: {textAlignment: "center", background : gv_noneEditColor},
						width: 180
					}, {
						name   : "DUE_DATE_1ST", fieldName : "DUE_DATE_1ST", header: {text: '<spring:message code="Due Date" javaScriptEscape="true" />'},
						styles : {textAlignment : "center", background : gv_requiredColor},
						editor : {type : "date", datetimeFormat : "yyyy-MM-dd"},
						width  : 100
					}, {
						name   : "DUE_DATE_2ND", fieldName : "DUE_DATE_2ND", editable: false, header: {text: '<spring:message code="Due Date 2" javaScriptEscape="true" />'},
						styles : {textAlignment : "center", background : gv_noneEditColor},
						width  : 100
					}, {
						name   : "DUE_DATE_3RD", fieldName : "DUE_DATE_3RD", editable: false, header: {text: '<spring:message code="Due Date 3" javaScriptEscape="true" />'},
						styles : {textAlignment : "center", background : gv_noneEditColor},
						width  : 100
					}, {
						name : "CLOSE_DATE", fieldName: "CLOSE_DATE", editable: false, header: {text: '<spring:message code="lbl.endTime" javaScriptEscape="true" />'},
						styles: {textAlignment: "center", background : gv_noneEditColor},
						width: 100
					}, {
						name : "CLOSE_YN", 
						fieldName : "CLOSE_YN", header : {text: '<spring:message code="lbl.status" javaScriptEscape="true" />'},
						styles : {textAlignment: "center", background : gv_noneEditColor},
						dynamicStyles : [{ criteria: ["state<>'c'","state='c'"], styles: ["background="+gv_noneEditColor,"background="+gv_requiredColor] }],
						width  : 80,
						editor : { type: "dropDown", domainOnly : true}, 
						values : gfn_getArrayExceptInDs(issueMng.comCode.codeMap.CLOSE_YN, "CODE_CD", ""),
						labels : gfn_getArrayExceptInDs(issueMng.comCode.codeMap.CLOSE_YN, "CODE_NM", ""),
						lookupDisplay : true,
						nanText : "",
						editButtonVisibility : "visible",
					}, {
						name : "FILE_NM_ORG", fieldName : "FILE_NM_ORG", editable: false, header : {text: '<spring:message code="lbl.file" javaScriptEscape="true" />'},
						styles : {textAlignment : "near", background : gv_noneEditColor},
						width : 250,
						buttonVisibility:"visible" ,cursor: "pointer",button: "action"
					}
				];
				
				this.setFields(columns, ['COMPANY_CD', 'USER_ID', 'FILE_NO', 'BU_CD', 'DIV_CD', 'TEAM_CD', 'PART_CD']);
				
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
					var editable = (newRow < 0 || issueMng.issueGrid.dataProvider.getRowState(newRow) === "created");
					grid.setColumnProperty("ISSUE_CD", "editable", editable);
					grid.setColumnProperty("REMARK",   "editable", editable);
					//grid.setColumnProperty("CLOSE_YN", "editable", editable);
				};
	
			  	//원클릭시 에디트 처리
				this.grdMain.onDataCellClicked = function (grid, index) {
					//grid.showEditor();
				};
			    
			    //멀티라인 하기 1(아래 하나더)
			    this.grdMain.setColumnProperty("CONTENT", "editor", {type : "multiline"});
			    this.grdMain.setColumnProperty("CONTENT", "styles", {textWrap : "normal"});
			    this.grdMain.setDisplayOptions({eachRowResizable : true});
				
				
				
				
				
				this.grdMain.onCellButtonClicked = function (grid, itemIndex, column) {
					
					if (column.name == "FILE_NM_ORG" || column.name == "REMARK") {
						var rowState = issueMng.issueGrid.dataProvider.getRowState(itemIndex);
						if (rowState != "none" && rowState != "updated") {
							alert("저장 후 진행해주세요.");
							return;
						}
					}
					
					//파일첨부
					if (column.name == "FILE_NM_ORG") {
			       		var params = {
			       			COMPANY_CD   : grid.getValue(itemIndex, "COMPANY_CD"),		       				
			       			ISSUE_ID     : grid.getValue(itemIndex, "ISSUE_ID"),		       				
		       				FILE_NO      : grid.getValue(itemIndex, "FILE_NO"),		       				
		       				_siq         : issueMng._siq+"FileNo",		       				
			       			callback     : "fn_popupCallback",
			       		};
			       		gfn_comPopupOpen("FILE",params);

			       	//remark 등록
					} else if (column.name == "REMARK") {
						var params = {
			       			COMPANY_CD   : grid.getValue(itemIndex, "COMPANY_CD"),		       				
			       			ISSUE_ID     : grid.getValue(itemIndex, "ISSUE_ID"),		       				
			       			callback     : "fn_popupCallback",
			       			popupTitle   : "Remark",
			       			rootUrl      : "snop/meetingMng",
			       			url          : "remarkPopup",
			       		};
			       		gfn_comPopupOpen("REMARK",params);
					
			       	//user
					} else if (column.name == "USER_NM") {
						var params = {
							searchCode : grid.getValue(itemIndex, "USER_ID"),		       				
							searchName : grid.getValue(itemIndex, "USER_NM"),		       				
			       			callback   : "fn_popupCallback",
			       			singleYn   : "Y",
			       			rowId      : itemIndex,
			       		};
			       		gfn_comPopupOpen("EMP",params);
			       	
			       	//part nm
					} else if (column.name == "PART_NM") {
						var params = {
							searchCode : grid.getValue(itemIndex, "PART_CD"),		       				
							searchName : grid.getValue(itemIndex, "PART_NM"),		       				

							companyCd  : grid.getValue(itemIndex, "COMPANY_CD"),
							buCd       : grid.getValue(itemIndex, "BU_CD"),
							divCd      : grid.getValue(itemIndex, "DIV_CD"),
							teamCd     : grid.getValue(itemIndex, "TEAM_CD"),
							partCd     : grid.getValue(itemIndex, "PART_CD"),
							
			       			callback   : "fn_popupCallback",
			       			singleYn   : "Y",
			       			rowId      : itemIndex,
			       		};
			       		gfn_comPopupOpen("PART",params);
					}
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
				issueMng.save();
			});
			
			$("#btnAddChild").on('click', function(e) {
				
				issueMng.issueGrid.grdMain.commit();
				
				var current = issueMng.issueGrid.grdMain.getCurrent();
				var row     = current.dataRow;
				var setCols = {CLOSE_YN : "N"};

				setCols.ISSUE_CD = FORM_SEARCH.ISSUE_CD;
				issueMng.issueGrid.dataProvider.insertRow(0, setCols);
			});
			
			$("#btnDeleteRows").on('click', function (e) {
				var rows = issueMng.issueGrid.grdMain.getCheckedRows();
				issueMng.issueGrid.dataProvider.removeRows(rows, false);
			});
			
			$("#btnReset").on('click', function (e) {
				issueMng.issueGrid.grdMain.cancel();
				issueMng.issueGrid.dataProvider.rollback(issueMng.issueGrid.dataProvider.getSavePoints()[0]);
			});
		},
		
		excelSubSearch : function (){
			
			EXCEL_SEARCH_DATA = '<spring:message code="lbl.issueType" />' + " : ";
			EXCEL_SEARCH_DATA += $("#ISSUE_CD option:selected").text();
			EXCEL_SEARCH_DATA += '\n<spring:message code="lbl.content" />' + " : ";
			EXCEL_SEARCH_DATA += $("#CONTENT").val(); 
			EXCEL_SEARCH_DATA += '\n<spring:message code="lbl.status" />' + " : ";
			EXCEL_SEARCH_DATA += $("#CLOSE_YN option:selected").text();
			EXCEL_SEARCH_DATA += '\n<spring:message code="lbl.part" />' + " : ";
			EXCEL_SEARCH_DATA += $("#PART").val(); 
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
						issueMng.issueGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						issueMng.issueGrid.grdMain.cancel();
						
						issueMng.issueGrid.dataProvider.setRows(data.resList);
						issueMng.issueGrid.dataProvider.clearSavePoints();
						issueMng.issueGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(issueMng.issueGrid.dataProvider.getRowCount());
						
						issueMng.issueGrid.gridInstance.setFocusKeys();
						
						//멀티라인 하기 2
						issueMng.issueGrid.grdMain.fitRowHeightAll(0, true);
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		save : function() {
			
			var grdData = gfn_getGrdSavedataAll(this.issueGrid.grdMain);
			if (grdData.length == 0) {
				alert('<spring:message code="msg.noChangeData"/>');
				return;
			}

			//그리드 유효성 검사
			var arrColumn = ["ISSUE_CD", "TITLE", "CONTENT", "USER_NM", "PART_NM", "DUE_DATE_1ST", "CLOSE_YN"];
			
			if (!gfn_getValidation(this.issueGrid.gridInstance, arrColumn)) {
				return;
			}
				
				// PK 중복 체크 
			/* if (gfn_dupCheck(this.issueGrid.grdMain, "TRANS_TYPE|TRANS_ID")) {
				return;
			} */
				
			confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
					
	    		//저장위치 처리
	    		//issueMng.issueGrid.gridInstance.saveTopUpdKeys("TRANS_TYPE|TRANS_ID");
			 
				//저장
				FORM_SEARCH = {}; //초기화
				FORM_SEARCH._mtd   = "saveAll";
				FORM_SEARCH.tranData = [{outDs:"saveCnt",_siq : issueMng._siq, grdData : grdData}];
				
				var ajaxOpt = {
					url     : GV_CONTEXT_PATH + "/biz/obj",
					data    : FORM_SEARCH,
					success : function(data) {
						if (data.errCode == -10) {
							alert(gfn_getDomainMsg("msg.dupData", data.errLine));
							issueMng.issueGrid.grdMain.setCurrent({dataRow : data.errLine - 1, column : "TRANS_ID"});
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
		
		issueMng.search();
		issueMng.excelSubSearch();
	}
	
	//파일팝업 콜백
	var fn_popupCallback = function () {
		if (arguments.length > 0 && arguments[0] == "EMP") {
			issueMng.issueGrid.dataProvider.setValue(arguments[2], "USER_ID", arguments[1][0].USER_ID);
			issueMng.issueGrid.dataProvider.setValue(arguments[2], "USER_NM", arguments[1][0].USER_NM);
			//issueMng.issueGrid.dataProvider.setValue(arguments[2], "DEPT_NM", arguments[1][0].DEPT_NM);
		} else if (arguments.length > 0 && arguments[0] == "PART") {
			issueMng.issueGrid.dataProvider.setValue(arguments[2], "BU_CD"   ,arguments[1][0].BU_CD);
			issueMng.issueGrid.dataProvider.setValue(arguments[2], "DIV_CD"  ,arguments[1][0].DIV_CD);
			issueMng.issueGrid.dataProvider.setValue(arguments[2], "TEAM_CD" ,arguments[1][0].TEAM_CD);
			issueMng.issueGrid.dataProvider.setValue(arguments[2], "PART_CD" ,arguments[1][0].PART_CD);
			issueMng.issueGrid.dataProvider.setValue(arguments[2], "PART_NM" ,arguments[1][0].PART_NM);
		} else {
			fn_apply();
		}
	}

	// onload 
	$(document).ready(function() {
		issueMng.init();
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
			<form id="searchForm" name="searchForm" method="POST"
				onSubmit="return false;">
				<div class="srhcondi">
					<ul>
						<li><strong><spring:message code="lbl.issueType" /></strong>
							<div class="selectBox">
								<select id="ISSUE_CD" name=ISSUE_CD></select>
							</div>
						</li>
						<li><strong><spring:message code="lbl.content" /></strong>
							<div class="selectBox">
								<input type="text" id="CONTENT" name="CONTENT" class="ipt">
							</div>
						</li>
						<li><strong><spring:message code="lbl.status" /></strong>
							<div class="selectBox">
								<select id="CLOSE_YN" name="CLOSE_YN"></select>
							</div>
						</li>
						<li><strong><spring:message code="lbl.part" /></strong>
							<div class="selectBox">
								<input type="text"  id="PART" name="PART" class="ipt">
							</div>
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
