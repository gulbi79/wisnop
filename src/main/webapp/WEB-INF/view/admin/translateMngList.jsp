<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp"%>

	<script type="text/javascript">

	var enterSearchFlag = "Y";
	
	function fn_checkClose() {
    	return gfn_getGrdSaveCount(trnaslateMng.transGrid.grdMain) == 0; 
    }
	
	var trnaslateMng = {

		init : function () {
			
			gfn_formLoad();
			
			this.events();
			
			this.comCode.initCode();
			
			this.transGrid.initGrid();
		},
			
		_siq    : "admin.translateMng",
		
		/*
		* common Code 
		*/
		comCode : {
			codeMap : null,
			
			initCode : function () {
				var grpCd    = "TRANS_TYPE";
				this.codeMap = gfn_getComCode(grpCd, 'Y'); //공통코드 조회
				gfn_setMsCombo("TRANS_TYPE", this.codeMap.TRANS_TYPE, ["*"]); //BU //id,data,제외코드
			}
		},
	
		/* 
		* grid  선언
		*/
		transGrid : {
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
						name: "TRANS_TYPE", 
						fieldName : "TRANS_TYPE", 
						editable : false, header : {text: '<spring:message code="lbl.domainType" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						dynamicStyles : [{ criteria: ["state<>'c'","state='c'"], styles: ["background="+gv_noneEditColor,"background="+gv_requiredColor] }],
						width  : 90,
						editor : { type: "dropDown", domainOnly : true}, 
						values : gfn_getArrayExceptInDs(trnaslateMng.comCode.codeMap.TRANS_TYPE, "CODE_CD", ""),
						labels : gfn_getArrayExceptInDs(trnaslateMng.comCode.codeMap.TRANS_TYPE, "CODE_NM", ""),
						lookupDisplay : true,
						nanText : "",
						editButtonVisibility : "visible",
					}, {
						name : "TRANS_ID", fieldName: "TRANS_ID", editable: false, header: {text: '<spring:message code="lbl.domainId" javaScriptEscape="true" />'},
						styles : {textAlignment: "near"},
						dynamicStyles : [{ criteria: ["state<>'c'","state='c'"], styles: ["background="+gv_noneEditColor,"background="+gv_requiredColor] }],
						width : 120,
					}, {
						name : "EN_TEXT", fieldName : "EN_TEXT", header: {text: '<spring:message code="lbl.english" javaScriptEscape="true" />'},
						styles : {textAlignment: "near",background:gv_requiredColor},
						width : 200
					}, {
						name : "KR_TEXT", fieldName : "KR_TEXT", header : {text: '<spring:message code="lbl.korean" javaScriptEscape="true" />'},
						styles : {textAlignment : "near", background : gv_requiredColor},
						width : 200,
					}, {
						name : "CN_TEXT", fieldName: "CN_TEXT",  header: {text: '<spring:message code="lbl.chinese" javaScriptEscape="true" />'},
						styles: {textAlignment: "near", background : gv_requiredColor},
						width: 200
					}, {
		                name: "CREATE_ID", fieldName: "CREATE_ID", editable: false, header: {text: '<spring:message code="lbl.createBy"/>'}, styles: {textAlignment: "near",background:gv_noneEditColor},
		                width: 80
		            }, {
		                name: "CREATE_DTTM", fieldName: "CREATE_DTTM", editable: false, header: {text: '<spring:message code="lbl.createDttm"/>'}, styles: {textAlignment: "center",background:gv_noneEditColor},
		                width: 120
		            }, {
		                name: "UPDATE_ID", fieldName: "UPDATE_ID", editable: false, header: {text: '<spring:message code="lbl.updateBy"/>'}, styles: {textAlignment: "near",background:gv_noneEditColor},
		                width: 80
		            }, {
		                name: "UPDATE_DTTM", fieldName: "UPDATE_DTTM", editable: false, header: {text: '<spring:message code="lbl.updateDttm"/>'}, styles: {textAlignment: "center",background:gv_noneEditColor},
		                width: 120
		            },
				];
				
				this.setFields(columns, ['USE_FLAG']);
				
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
				
				//fields.push({fieldName : "USE_FLAG"});
				
				this.dataProvider.setFields(fields);
			},
			
			setOptions : function () {
				this.grdMain.setOptions({
					checkBar: { visible : true },
					stateBar: { visible : true },
				});

				this.dataProvider.setOptions({
					softDeleting : true
				});
			},
			
			gridEvents : function() {
				this.grdMain.onCurrentRowChanged = function (grid, oldRow, newRow) {
					var editable = (newRow < 0 || trnaslateMng.transGrid.dataProvider.getRowState(newRow) === "created");
					grid.setColumnProperty("TRANS_TYPE", "editable", editable);
					grid.setColumnProperty("TRANS_ID",   "editable", editable);
				};
	
			  	//원클릭시 에디트 처리
				this.grdMain.onDataCellClicked = function (grid, index) {
					grid.showEditor();
				};
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
				trnaslateMng.save();
			});
			
			$("#btnAddChild").on('click', function(e) {
				
				trnaslateMng.transGrid.grdMain.commit();
				
				var current = trnaslateMng.transGrid.grdMain.getCurrent();
				var row     = current.dataRow;
				var setCols = {USE_FLAG : "Y"};

				setCols.TRANS_TYPE = FORM_SEARCH.TRANS_TYPE;
				trnaslateMng.transGrid.dataProvider.insertRow(0, setCols);
			});
			
			$("#btnDeleteRows").on('click', function (e) {
				var rows = trnaslateMng.transGrid.grdMain.getCheckedRows();
				trnaslateMng.transGrid.dataProvider.removeRows(rows, false);
			});
			
			$("#btnReset").on('click', function (e) {
				trnaslateMng.transGrid.grdMain.cancel();
				trnaslateMng.transGrid.dataProvider.rollback(trnaslateMng.transGrid.dataProvider.getSavePoints()[0]);
			});
			
			/* $("#btnLocalApply").on('click', function (e) {
				trnaslateMng.apply();
			}); */
		},
		

		excelSubSearch : function (){
			EXCEL_SEARCH_DATA = "";
			EXCEL_SEARCH_DATA += '<spring:message code="lbl.domainType"/> : ';
			EXCEL_SEARCH_DATA += $("#TRANS_TYPE option:selected").text();
			
			EXCEL_SEARCH_DATA += '\n<spring:message code="lbl.domainId"/> : ';
			EXCEL_SEARCH_DATA += $("#TRANS_ID").val();
			
			EXCEL_SEARCH_DATA += '\n<spring:message code="lbl.language"/> : ';
			EXCEL_SEARCH_DATA += $("#EN_TEXT").val();
			
		},
		
		// 조회
		search : function () {
			
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq }];
			
			var aOption = {
				url     : "${ctx}/biz/obj.do",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						trnaslateMng.transGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						trnaslateMng.transGrid.grdMain.cancel();
						
						trnaslateMng.transGrid.dataProvider.setRows(data.resList);
						trnaslateMng.transGrid.dataProvider.clearSavePoints();
						trnaslateMng.transGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(trnaslateMng.transGrid.dataProvider.getRowCount());
						
						trnaslateMng.transGrid.gridInstance.setFocusKeys();
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		save : function() {
			
			var grdData = gfn_getGrdSavedataAll(this.transGrid.grdMain);
			if (grdData.length == 0) {
				alert('<spring:message code="msg.noChangeData"/>');
				return;
			}

			//그리드 유효성 검사
			var arrColumn = ["TRANS_TYPE", "TRANS_ID", "EN_TEXT", "KR_TEXT", "CN_TEXT"];
			
			if (!gfn_getValidation(this.transGrid.gridInstance, arrColumn)) {
				return;
			}
				
				// PK 중복 체크 
			if (gfn_dupCheck(this.transGrid.grdMain, "TRANS_TYPE|TRANS_ID")) {
				return;
			}
				
			confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
					
	    		//저장위치 처리
	    		trnaslateMng.transGrid.gridInstance.saveTopUpdKeys("TRANS_TYPE|TRANS_ID");
			 
				//저장
				FORM_SEARCH = {}; //초기화
				FORM_SEARCH._mtd   = "saveAll";
				FORM_SEARCH.tranData = [{outDs:"saveCnt",_siq : trnaslateMng._siq, grdData : grdData, custDupChkYn : {"insert":"Y"}}];
				
				var ajaxOpt = {
					url     : "${ctx}/biz/obj.do",
					data    : FORM_SEARCH,
					success : function(data) {
						if (data.errCode == -10) {
							alert(gfn_getDomainMsg("msg.dupData", data.errLine));
							trnaslateMng.transGrid.grdMain.setCurrent({dataRow : data.errLine - 1, column : "TRANS_ID"});
						} else {
							alert('<spring:message code="msg.saveOk"/>');
							trnaslateMng.domainApply();
							fn_apply(false);
						}
					},
				};
				
				gfn_service(ajaxOpt, "obj");
			});
		},
		
		// 적용
		domainApply : function () {
			var ajaxOpt = {
				url     : "${ctx}/locale/applyLocale.do",
				data    : {},
				success : function (data) {
					if (data.errMsg == 'success') {
						//alert('<spring:message code="msg.done" />');
					}
				}
			}
			gfn_service(ajaxOpt);
		},
	};
	

	//조회
	var fn_apply = function (sqlFlag) {
		
		FORM_SEARCH     = $("#searchForm").serializeObject(); //초기화
		FORM_SEARCH.sql = sqlFlag;
		
		trnaslateMng.search();
		trnaslateMng.excelSubSearch();
	}

	// onload 
	$(document).ready(function() {
		trnaslateMng.init();
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
						<li><strong><spring:message code="lbl.domainType" /></strong>
							<div class="selectBox">
								<select id="TRANS_TYPE" name=TRANS_TYPE></select>
							</div>
						</li>
						<li><strong><spring:message code="lbl.domainId" /></strong>
							<div class="selectBox">
								<input type="text" id="TRANS_ID" name="TRANS_ID" class="ipt">
							</div>
						</li>
						<li><strong><spring:message code="lbl.language" /></strong>
							<div class="selectBox">
								<input type="text" id="EN_TEXT" name="EN_TEXT" class="ipt">
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
