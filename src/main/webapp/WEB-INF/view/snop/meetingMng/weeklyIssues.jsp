<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	<!-- 회의록 -->
	<script type="text/javascript">

	var SCM_SEARCH = {};
	var searchData = null;
	var enterSearchFlag = "Y";
	var weeklyIssues = {
      
		init : function () {
			
			gfn_formLoad();
			fn_initDate();
			this.weeklyIssuesGrid.initGrid();
			this.events();
			
		},
			
		_siq : "weeklyIssues.weeklyIssuesList",
		
		/* 
		* grid  선언
		*/
		weeklyIssuesGrid : {
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
			
			// 조회할 때, 로그인한 사용자의 id를 기준으로 글입력한 등록자정보와 로그인한 사용자 정보가 동일할 경우, 해당 개시글에 대한 editable true;
			
			setColumn     : function () {
				var columns = 
				[
					{
						name : "ISSUES_ID", fieldName: "ISSUES_ID", editable: false, header: {text: "ISSUE_ID"},
						styles : {textAlignment : "center", background : gv_noneEditColor},
						width : 100,
						visible : false
					}, 
					
					{
						name : "ISSUES_WEEK", fieldName: "ISSUES_WEEK", editable: false, header: {text: "이슈발생 주차"},
						styles : {textAlignment : "center", background : gv_noneEditColor},
						width : 100,
					},
					
					{
						name : "TITLE", fieldName : "TITLE", editable: true, header: {text: '제목'},
						styles : {textAlignment: "near",textWrap: 'explicit'},
						dynamicStyles : [{ criteria: ["state<>'c'","state='c'"], styles: ["background="+gv_noneEditColor,"background="+gv_requiredColor] }],
						width : 250
						
					}, {
						name : "CONTENT", fieldName : "CONTENT", editable: true, header: {text: '<spring:message code="lbl.content" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", textWrap: 'explicit'},
						dynamicStyles : [{ criteria: ["state<>'c'","state='c'"], styles: ["background="+gv_noneEditColor,"background="+gv_requiredColor] }],
						width : 700
					}, {
						name : "FILE_NM_ORG", fieldName : "FILE_NM_ORG", editable: false, header : {text: '<spring:message code="lbl.file" javaScriptEscape="true" />'},
						styles : {textAlignment : "near",background:gv_noneEditColor},
						width : 250,
						buttonVisibility:"visible" ,cursor: "pointer",button: "action"
					}, {
						name   : "ISSUES_DATE", fieldName : "ISSUES_DATE", header: {text: '이슈 발생일'},
						styles : {textAlignment : "center"},
						editor : {type : "date", datetimeFormat : "yyyy-MM-dd"},
						dynamicStyles : [{ criteria: ["state<>'c'","state='c'"], styles: ["background="+gv_noneEditColor,"background="+gv_requiredColor] }],
						width  : 100
					}, {
						name : "UPDATE_ID", fieldName : "UPDATE_ID",editable: false, header: {text: '<spring:message code="lbl.regUserNm" javaScriptEscape="true" />'},
						styles : {textAlignment : "center", background : gv_noneEditColor},
						width : 80
					}
				];
				this.setFields(columns, ['COMPANY_CD', 'BU_CD', 'CREATE_DTTM', 'CREATE_ID', 'UPDATE_DTTM','FILE_NO','UPDATE_ID','UPDATE_ID_TEMP']);
				
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
					sorting : { enabled : false}
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
					id         : "notEditStyle",
					editable   : false,
					background : gv_noneEditColor
				}]);
		
				
			},
			
			gridEvents : function() {
		
				//원클릭시 에디트 처리
				this.grdMain.onDataCellClicked = function (grid, index) {
					//grid.showEditor();
				};
				
				//조회시 멀티라인 모두 보여주기 옵션
				
				this.grdMain.setColumnProperty("TITLE", "editor", {type : "multiline"});
			    this.grdMain.setColumnProperty("TITLE", "styles", {textWrap : "normal"});
			    
				
				this.grdMain.setColumnProperty("CONTENT", "editor", {type : "multiline"});
			    this.grdMain.setColumnProperty("CONTENT", "styles", {textWrap : "normal"});
			    
			    
			    this.grdMain.setDisplayOptions(
			     {
			    			   eachRowResizable : true,
			    			   fitStyle: "evenFill"
			     }
			    );
				
				
				this.grdMain.onCellButtonClicked = function (grid, itemIndex, column) {
					
					
					var userID =  "${sessionScope.userInfo.userId}";
					fn_delAuthorityHasOrNot(); 
					var isADMIN = SCM_SEARCH.isADMIN;
					var isSCM = SCM_SEARCH.isSCM;
					
					
					
					
					if (column.name == "FILE_NM_ORG") {
						var rowState = weeklyIssues.weeklyIssuesGrid.dataProvider.getRowState(itemIndex);
						if (rowState != "none" && rowState != "updated") {
							alert('<spring:message code="msg.dataSave"/>');
							return;
						}
					}
					
					//파일첨부
					// 로그인사람과 등록자가 같을 경우, 파일첨부 가능
					// 로그인사람이 SCM 권한 일 경우, 파일첨부 가능
					// 로그인사람이 ADMIN 권한 일 경우, 파일첨부 가능
					if (column.name == "FILE_NM_ORG") {
						
						if(userID == grid.getValue(itemIndex,"CREATE_ID")||isADMIN==1||isSCM==1){							
							
							var params = {
				       			COMPANY_CD   : grid.getValue(itemIndex, "COMPANY_CD"),		 // 여기가 문제  <=    getValue를 통해 해당 값을 가져오려면 dataProvider에 모든 데이터가 query 문을 통해 불러져 와 있어야 한다.				
				       			ISSUES_ID    : grid.getValue(itemIndex, "ISSUES_ID"),		       				
			       				FILE_NO      : grid.getValue(itemIndex, "FILE_NO"),		       				
			       				_siq         : weeklyIssues._siq+"FileNo",		       				
				       			callback     : "fn_popupCallback",
				       		};
				       
				       		gfn_comPopupOpen("FILE",params);
						}
						else
						{
							var params = {
					       			COMPANY_CD   : grid.getValue(itemIndex, "COMPANY_CD"),		 // 여기가 문제  <=    getValue를 통해 해당 값을 가져오려면 dataProvider에 모든 데이터가 query 문을 통해 불러져 와 있어야 한다.				
					       			ISSUES_ID    : grid.getValue(itemIndex, "ISSUES_ID"),		       				
				       				FILE_NO      : grid.getValue(itemIndex, "FILE_NO"),		       				
				       				AUTHORITY_YN : "N",
				       				_siq         : weeklyIssues._siq+"FileNo",		       				
					       			callback     : "fn_popupCallback",
					       		};
					       
					       		gfn_comPopupOpen("FILE",params);	
						}
			     
			       	//user
					// 로그인사람과 등록자가 같을 경우, 담당자 수정 가능
					// 로그인사람이 SCM 권한 일 경우, 담당자 수정 가능
					// 로그인사람이 ADMIN 권한 일 경우, 담당자 수정 가능
						
					} 
					
					 
					// END OF onCellButtonClicked
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
				weeklyIssues.save();
			});
			
			$("#btnAddChild").on('click', function(e) {
				var userNM = "${sessionScope.userInfo.userNm}";
				weeklyIssues.weeklyIssuesGrid.grdMain.commit();
				var setCols = {UPDATE_ID : userNM};//보여주기 위함
				var TODAY = new Date();
				setCols.ISSUES_DATE = TODAY.format('yyyy-mm-dd');
				weeklyIssues.weeklyIssuesGrid.dataProvider.insertRow(0, setCols);
			});
			
			$("#btnDeleteRows").on('click', function (e) {
				//*삭제는 등록한 사람 + SCM팀 권한자
				
				// FEED BACK
				// 1. 한개도 체크 안했을 시 팝업문구 변경
				// 2. 두개이상 어떤게 삭제 권한이 있는지 모름
				// 3. 삭제 대상 NUMBER를 ALERT와 같이 표출요청
				
				var deleteValidationFalseCnt = 0;
				
				
				
				var deleteValidationArray = [];
				
				
				var deleteRequesterNm = "${sessionScope.userInfo.userNm}";   // 삭제 요청자  name
				var deleteRequesterID =  "${sessionScope.userInfo.userId}";  // 삭제 요청자 id
				var rows = weeklyIssues.weeklyIssuesGrid.grdMain.getCheckedRows();
				// 1: ADMIN, 0: NOT ADMIN
				// 1: SCM,  0: NOT SCM
				fn_delAuthorityHasOrNot(); 
				var isADMIN = SCM_SEARCH.isADMIN;
				var isSCM = SCM_SEARCH.isSCM;
				

				//삭제할 대상을 선택하지 않은체, 삭제버튼을 누른 경우,
				if(rows.length==0){
					alert('<spring:message code="msg.deleteTargetNotSelected"/>');
					return false;
					
				}
				//1.삭제할 대상을 선택하였지만, 권한이 있는 것과 없는 것이 섞여 있을 경우,
				//2.권한이 있는 것만 선택했을 경우,
				//3.권한이 없는 것만 선택했을 경우,
				else
				{
					// 삭제 권한이 있는 것:removeRows(rows, false) 처리    weeklyIssues.weeklyIssuesGrid.dataProvider.removeRows(rows, false);
					// 삭제 권한이 없는 것:checkItem(v, false)처리 및 배열에 담아 alert을 통해 권한 없는 정보 알림
					
					$.each(rows,function (n,v) {
						//삭제 권한 있음// 등록한 사람, SCM
						//deleteRequesterNm==dataManager||deleteRequesterID==dataCreater||isSCM==1
						var Creater = weeklyIssues.weeklyIssuesGrid.grdMain.getValue(v,"UPDATE_ID_TEMP");
						
						if(deleteRequesterID==Creater||isSCM==1||isADMIN==1)
						{
							//weeklyIssues.weeklyIssuesGrid.dataProvider.removeRows(v, false);
							deleteValidationArray.push(v);
							
						}
						//삭제 권한 없음
						else
						{
						
							deleteValidationFalseCnt++;
														
							weeklyIssues.weeklyIssuesGrid.grdMain.checkItem(v, false);
						}
					});
					
					weeklyIssues.weeklyIssuesGrid.dataProvider.removeRows(deleteValidationArray, false);
				    /*
				    
				    ============    removeRows(rows,false);에서 rows는 배열이어야 한다.    ================
				    
					*/
					//1.삭제할 대상 선택,권한이 있는 것과 없는 것이 섞여 있을 경우, alert_1: '삭제권한 없음:'+'\n'+deleteValadationFalseList+'\n'+'삭제권한이 없는 게시글은 체크가 해제 됩니다.'
					//2.권한이 있는 것만 선택했을 경우, alert_2: ""  => alert 불필요
					//3.권한이 없는 것만 선택했을 경우, alert_3: ""  => 삭제 권한 없는 게시물 id list로 보여줌
					
					if(deleteValidationFalseCnt>0)
					{
						alert('<spring:message code="msg.deleteValidationFalse"/>'+'\n'+'<spring:message code="msg.deleteValidationDescription"/>');	
					}
					else{
						//alert 불필요
					}
					
					
					
				}
				
				
				
				// end of $(#btnDeleteRows).on('click',function(e))	
			});
			
			$("#btnReset").on('click', function (e) {
				weeklyIssues.weeklyIssuesGrid.grdMain.cancel();
				weeklyIssues.weeklyIssuesGrid.dataProvider.rollback(weeklyIssues.weeklyIssuesGrid.dataProvider.getSavePoints()[0]);
				
				if(searchData!=null)
				{
					weeklyIssues.gridCallback(searchData);
					weeklyIssues.weeklyIssuesGrid.grdMain.fitRowHeightAll(0, true);
				}
				
			});
			
	
		},
		
		//엑셀 다운로드
		excelSubSearch : function (){
	
			//일자
		EXCEL_SEARCH_DATA += "\n" + '<spring:message code="lbl.date"/>' + " : ";
		EXCEL_SEARCH_DATA += $("#fromCal").val() + " ~ " + $("#toCal").val();

			
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
						weeklyIssues.weeklyIssuesGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						weeklyIssues.weeklyIssuesGrid.grdMain.cancel();
												
						
						weeklyIssues.weeklyIssuesGrid.dataProvider.setRows(data.resList);
						weeklyIssues.weeklyIssuesGrid.dataProvider.clearSavePoints();
						weeklyIssues.weeklyIssuesGrid.dataProvider.savePoint(); //초기화 포인트 저장
						
						searchData = data.resList;
						weeklyIssues.gridCallback(data.resList);
						
						gfn_setSearchRow(weeklyIssues.weeklyIssuesGrid.dataProvider.getRowCount());
						weeklyIssues.weeklyIssuesGrid.gridInstance.setFocusKeys();
						
						weeklyIssues.weeklyIssuesGrid.grdMain.fitRowHeightAll(0, true);
						
											
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
	
		
	

	save : function() {
		
		var userID = "${sessionScope.userInfo.userId}";
		var grdData = gfn_getGrdSavedataAll(this.weeklyIssuesGrid.grdMain);
		
		for(i=0;i<grdData.length;i++)
		{
			grdData[i].UPDATE_ID_TEMP = userID;
		}
		
		if (grdData.length == 0) {
			alert('<spring:message code="msg.noChangeData"/>');
			return;
		}
		
		//그리드 유효성 검사
		var arrColumn = ["TITLE", "CONTENT", "ISSUES_DATE"];
		
		if (!gfn_getValidation(this.weeklyIssuesGrid.gridInstance, arrColumn)) {
			return;
		}
			
		
		confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
				
    	
			//저장
			FORM_SEARCH = {}; //초기화
			FORM_SEARCH._mtd   = "saveAll";
			FORM_SEARCH.tranData = [{outDs:"saveCnt",_siq : weeklyIssues._siq, grdData : grdData}];
			
			var ajaxOpt = {
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SEARCH,
				success : function(data) {
					if (data.errCode == -10) {
						alert(gfn_getDomainMsg("msg.dupData", data.errLine));
						weeklyIssues.weeklyIssuesGrid.grdMain.setCurrent({dataRow : data.errLine - 1, column : "TITLE"});
					} else {
						alert('<spring:message code="msg.saveOk"/>');
						
						fn_apply(false);
					}
				},
			};
			
			gfn_service(ajaxOpt, "obj");
		});
	},
	
	
	
	gridCallback : function(resList){
		
		
		fn_delAuthorityHasOrNot(); 
		var isADMIN = SCM_SEARCH.isADMIN;
		var isSCM = SCM_SEARCH.isSCM;
		
		
		
		for (var i = resList.length-1; i >= 0; i--) 
		{
			
			// 로그인사람과 등록자가 같을 경우, editable
			// 로그인사람이 SCM 권한 일 경우, editable
			// 로그인사람이 ADMIN 권한 일 경우, editable
			if(resList[i].UPDATE_ID_TEMP == "${sessionScope.userInfo.userId}"||isADMIN==1||isSCM==1)
			{
				this.weeklyIssuesGrid.grdMain.setCellStyles(i,"TITLE","editStyle");
				this.weeklyIssuesGrid.grdMain.setCellStyles(i,"CONTENT","editStyle");
				this.weeklyIssuesGrid.grdMain.setCellStyles(i,"ISSUES_DATE","editStyle");
				this.weeklyIssuesGrid.grdMain.setCellStyles(i,"FILE_NM_ORG","notEditStyle");
				
			}
			//로그인사람과 등록자가 다를 경우, not editable 
			// 로그인사람이 SCM 권한이 없을 경우, editable
			// 로그인사람이 ADMIN 권한이 없을 경우, editable
			else{
				
				this.weeklyIssuesGrid.grdMain.setCellStyles(i,"TITLE","notEditStyle");
				this.weeklyIssuesGrid.grdMain.setCellStyles(i,"CONTENT","notEditStyle");
				this.weeklyIssuesGrid.grdMain.setCellStyles(i,"ISSUES_DATE","notEditStyle");
				this.weeklyIssuesGrid.grdMain.setCellStyles(i,"FILE_NM_ORG","notEditStyle");
				
			}
			
			
		}
		
		
	}
	
	
};

	
	
	
	
	//조회
	var fn_apply = function (sqlFlag) {
		
		
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql = sqlFlag;
   	
   		weeklyIssues.search();
   		weeklyIssues.excelSubSearch();
   		
	}
			
	
	var fn_popupCallback = function () {
		if (arguments.length > 0 && arguments[0] == "EMP") {
			
			weeklyIssues.weeklyIssuesGrid.dataProvider.setValue(arguments[2], "USER_ID", arguments[1][0].USER_NM);
			weeklyIssues.weeklyIssuesGrid.dataProvider.setValue(arguments[2], "USER_ID_TEMP", arguments[1][0].USER_ID);
			//issueMng.issueGrid.dataProvider.setValue(arguments[2], "DEPT_NM", arguments[1][0].DEPT_NM);
		} else {
			fn_apply();
		}
	}
	
	
	
	
	 //달력 설정
    function fn_initDate() {
	
			DATEPICKET(null,fn_getDate(),fn_getTodayDate());
			
	 }
	
	 
	 // 현재날짜 기준 6개월전
    function getDateStr(myDate){
    	return (myDate.getFullYear() + ((myDate.getMonth() + 1)<10?'0':'') + (myDate.getMonth() + 1) + ((myDate.getDate())<10?'0':'') + myDate.getDate())
    }
	
    function fn_getDate() {
		
    	var d = new Date()
    	  var monthOfYear = d.getMonth()
    	  d.setMonth(monthOfYear - 6)   // 6개월전 
    	
		
		return getDateStr(d);
	}

    //현재날짜
    function fn_getTodayDate() {
		var curDate  = new Date();
		var curYear  = curDate.getFullYear();
		var curMonth = curDate.getMonth()+1;
		var curDate  = curDate.getDate();
		
		return curYear + (curMonth<10?'0':'') + curMonth + (curDate<10?'0':'') + curDate;
	}
	 
    
    //삭제 권한 확인: SCM ROLE 이면 1, 아니면 0
    //삭제 권한 확인: ADMIN ROEL 이면 1, 아니면 0
    function fn_delAuthorityHasOrNot(){
    	
    	SCM_SEARCH = {}; // 초기화
    	
    	SCM_SEARCH.USER_ID = "${sessionScope.userInfo.userId}" ;
    	SCM_SEARCH._mtd     = "getList";
		SCM_SEARCH.tranData = [
							   { outDs : "isAdmin",_siq : "weeklyIssues.isAdmin"},{ outDs : "isSCMTeam",_siq : "weeklyIssues.isSCMTeam"}					
			];
		
		
		
		var aOption = {
			async   : false,
			url     : GV_CONTEXT_PATH + "/biz/obj",
			data    : SCM_SEARCH,
			success : function (data) {
			
				if (SCM_SEARCH.sql == 'N') {
					
					SCM_SEARCH.isADMIN = data.isAdmin[0].isADMIN;
					SCM_SEARCH.isSCM = data.isSCMTeam[0].isSCM;	

					
				}
			}
		}
		
		gfn_service(aOption, "obj");
    	
    }
    
	
	// onload 
	$(document).ready(function() {
		weeklyIssues.init();
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
					<div id="view_Her">
							<strong class="filter_tit">View Horizon</strong>
							<div class="tlist">
								<div class="tit"><spring:message code="lbl.date"/></div>
								<input type="text" id="fromCal" name="fromCal" class="iptdate datepicker2" > <span class="ihpen">~</span>
								<input type="text" id="toCal" name="toCal" class="iptdate datepicker2" >
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
    </div>
</body>
</html>
