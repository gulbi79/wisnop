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
	var meetingNote = {
      
		init : function () {
			
			gfn_formLoad();
			fn_initDate();
			this.comCode.initCode();
			this.initFilter();
			this.meetingNoteGrid.initGrid();
			this.events();
			
		},
			
		_siq : "meetingNote.meetingNoteList",
		
		initFilter : function() {
			
			
			// 키워드팝업
			gfn_keyPopAddEvent([
				{target : 'divManager', id : 'manager', type : 'EMP', title : '<spring:message code="lbl.manager"/>'}
			]);
			
			
	    	// 콤보박스
			gfn_setMsComboAll([
				{target : 'divTeam',   id : 'team',    title : '<spring:message code="lbl.team"/>', data : this.comCode.codeMapEx.TEAM_CD, exData:['*'],},
						
				]);
	    	
		
		},
		
		/*
		* common Code 
		*/
		comCode : {
			
			codeMap : null,
			codeMapEx: null,
			initCode  : function () {
				
				this.codeMapEx = gfn_getComCodeEx(['TEAM_CD'], null, {}); //공통코드 조회
				
			
			}
		},
	
		/* 
		* grid  선언
		*/
		meetingNoteGrid : {
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
						name : "MINUTES_ID", fieldName: "MINUTES_ID", editable: false, header: {text: '<spring:message code="lbl.meetingNoteId" javaScriptEscape="true" />'},
						styles : {textAlignment : "center", background : gv_noneEditColor},
						width : 100,
					}, 
					
					{ 
						name: "TEAM_CD", 
						fieldName : "TEAM_CD", 
						editable : true, header : {text: '<spring:message code="lbl.team" javaScriptEscape="true" />'},
						styles : {textAlignment: "center"},
						dynamicStyles : [{ criteria: ["state<>'c'","state='c'"], styles: ["background="+gv_noneEditColor,"background="+gv_requiredColor] }],
						width  : 100,
						editor : { type: "dropDown", domainOnly : true, textReadOnly: true}, 
						values : gfn_getArrayExceptInDs(meetingNote.comCode.codeMapEx.TEAM_CD, "CODE_CD", ""),
						labels : gfn_getArrayExceptInDs(meetingNote.comCode.codeMapEx.TEAM_CD, "CODE_NM", ""),
						lookupDisplay : true,
						nanText : "",
						editButtonVisibility : "visible"
					},
					
					{
						name : "USER_ID", fieldName : "USER_ID", editable: true, header : {text: '<spring:message code="lbl.manager" javaScriptEscape="true" />'},
						styles : {textAlignment : "center"},
						dynamicStyles : [{ criteria: ["state<>'c'","state='c'"], styles: ["background="+gv_noneEditColor,"background="+gv_requiredColor] }],
						width : 80,
						buttonVisibility:"visible" ,cursor: "pointer",button: "action"
						
						
						
						/*
						dynamicStyles :[{ 
							criteria: [ "values['IS_CREATER']='false'", "values['IS_CREATER']='true'"],
							styles: ["renderer=button2","renderer=button1"]
							
						}]
						*/
					},
					
					{
						name : "TITLE", fieldName : "TITLE", editable: true, header: {text: '<spring:message code="lbl.meetingTitle" javaScriptEscape="true" />'},
						styles : {textAlignment: "near",textWrap: 'explicit'},
						dynamicStyles : [{ criteria: ["state<>'c'","state='c'"], styles: ["background="+gv_noneEditColor,"background="+gv_requiredColor] }],
						width : 100
						
					}, {
						name : "CONTENT", fieldName : "CONTENT", editable: true, header: {text: '<spring:message code="lbl.content" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", textWrap: 'explicit'},
						dynamicStyles : [{ criteria: ["state<>'c'","state='c'"], styles: ["background="+gv_noneEditColor,"background="+gv_requiredColor] }],
						width : 250
					}, 
					
					{
						name   : "MINUTES_DATE", fieldName : "MINUTES_DATE", header: {text: '<spring:message code="lbl.meetDate" javaScriptEscape="true" />'},
						styles : {textAlignment : "center"},
						editor : {type : "date", datetimeFormat : "yyyy-MM-dd"},
						dynamicStyles : [{ criteria: ["state<>'c'","state='c'"], styles: ["background="+gv_noneEditColor,"background="+gv_requiredColor] }],
						width  : 100
					},{
						name : "REMARK", fieldName : "REMARK", editable: true, header : {text: '<spring:message code="lbl.remark2" javaScriptEscape="true" />'},
						editor       : { type: "multiline", textCase: "upper" },
						styles : {textAlignment: "near"},
						width : 250,
					
					},{
						name : "FILE_NM_ORG", fieldName : "FILE_NM_ORG", editable: false, header : {text: '<spring:message code="lbl.file" javaScriptEscape="true" />'},
						styles : {textAlignment : "near",background:gv_noneEditColor},
						width : 250,
						buttonVisibility:"visible" ,cursor: "pointer",button: "action"
					}, {
						name : "UPDATE_ID", fieldName : "UPDATE_ID",editable: false, header : {text: '<spring:message code="lbl.regUserNm" javaScriptEscape="true" />'},
						styles : {textAlignment : "center", background : gv_noneEditColor},
						width : 80
					}
				];
				// CREATE_ID
				// TB_KPI_MINUTES 테이블 저장시에 필요 필드 값: COMPANY_CD, BU_CD, MINUTES_ID, TEAM_CD, USER_ID, TITLE, CONTENT, MINUTES_DATE
				// REMARK, FILE_NM_ORG, CREATE_ID, CREATE_DTTM, UPDATE_ID, UPDATE_DTTM
				// 회의록 화면
				// show data: MINUTES_ID, TEAM_CD, USER_ID, TITLE, CONTENT, MINUTES_DATE, REMARK, FILE_NO, CREATE_ID
				// hide data: COMPANY_CD, BU_CD, CREATE_DTTM, UPDATE_ID, UPDATE_DTTM
				this.setFields(columns, ['COMPANY_CD', 'BU_CD', 'CREATE_DTTM', 'CREATE_ID', 'UPDATE_DTTM','FILE_NO','USER_ID_TEMP','UPDATE_ID_TEMP']);
				
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
				
				
				
				/*
				this.grdMain.addCellRenderers([{
					id 		   : "button1",
					
					buttonVisibility: "visible",
					cursor: "pointer",
					button: "action"
				}]);
				
				this.grdMain.addCellRenderers([{
					id 		   : "button2",
					
					buttonVisibility: "hidden",
					cursor: "default",
					button: "hidden"
				}]);
				
				*/
				
			},
			
			gridEvents : function() {
				
				/*
				this.grdMain.onCurrentRowChanged = function (grid, oldRow, newRow) {
					//var editable = (newRow < 0 || meetingNote.meetingNoteGrid.dataProvider.getRowState(newRow) === "created");
					grid.setColumnProperty("TEAM_CD", "editable", true);
				//	grid.setColumnProperty("REMARK",   "editable", editable);
				//  grid.setColumnProperty()의 경우, 이 이벤트에서는 필요없고, 페이지 접속 사용자에 따른 수정 권한 유무에 만 필요
				};
				*/
			  	//원클릭시 에디트 처리
				this.grdMain.onDataCellClicked = function (grid, index) {
					//grid.showEditor();
				};
				
				//조회시 멀티라인 모두 보여주기 옵션
				
				this.grdMain.setColumnProperty("TITLE", "editor", {type : "multiline"});
			    this.grdMain.setColumnProperty("TITLE", "styles", {textWrap : "normal"});
			    
				
				this.grdMain.setColumnProperty("CONTENT", "editor", {type : "multiline"});
			    this.grdMain.setColumnProperty("CONTENT", "styles", {textWrap : "normal"});
			    
			    
			    this.grdMain.setDisplayOptions({eachRowResizable : true});
				
				
				this.grdMain.onCellButtonClicked = function (grid, itemIndex, column) {
					
					
					var userID =  "${sessionScope.userInfo.userId}";
					fn_delAuthorityHasOrNot(); 
					var isADMIN = SCM_SEARCH.isADMIN;
					var isSCM = SCM_SEARCH.isSCM;
					
					
					
					
					if (column.name == "FILE_NM_ORG" || column.name == "REMARK") {
						var rowState = meetingNote.meetingNoteGrid.dataProvider.getRowState(itemIndex);
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
				       			MINUTES_ID    : grid.getValue(itemIndex, "MINUTES_ID"),		       				
			       				FILE_NO      : grid.getValue(itemIndex, "FILE_NO"),		       				
			       				_siq         : meetingNote._siq+"FileNo",		       				
				       			callback     : "fn_popupCallback",
				       		};
				       
				       		gfn_comPopupOpen("FILE",params);
						}
						else
						{
							var params = {
					       			COMPANY_CD   : grid.getValue(itemIndex, "COMPANY_CD"),		 // 여기가 문제  <=    getValue를 통해 해당 값을 가져오려면 dataProvider에 모든 데이터가 query 문을 통해 불러져 와 있어야 한다.				
					       			MINUTES_ID    : grid.getValue(itemIndex, "MINUTES_ID"),		       				
				       				FILE_NO      : grid.getValue(itemIndex, "FILE_NO"),		       				
				       				AUTHORITY_YN : "N",
				       				_siq         : meetingNote._siq+"FileNo",		       				
					       			callback     : "fn_popupCallback",
					       		};
					       
					       		gfn_comPopupOpen("FILE",params);	
						}
			     
			       	//user
					// 로그인사람과 등록자가 같을 경우, 담당자 수정 가능
					// 로그인사람이 SCM 권한 일 경우, 담당자 수정 가능
					// 로그인사람이 ADMIN 권한 일 경우, 담당자 수정 가능
						
					} else if (column.name == "USER_ID") {
						
						
						
						if(userID == grid.getValue(itemIndex,"CREATE_ID")||isADMIN==1||isSCM==1){
							
							var params = {
								searchCode : grid.getValue(itemIndex, "USER_ID_TEMP"),		       				
								searchName : grid.getValue(itemIndex, "USER_ID_TEMP"),		       				
			       				callback   : "fn_popupCallback",
			       				singleYn   : "Y",
			       				rowId      : itemIndex,
			       			};
			       			gfn_comPopupOpen("EMP",params);
			       	
						}
						else{
							
						}
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
				meetingNote.save();
			});
			
			$("#btnAddChild").on('click', function(e) {
				
				meetingNote.meetingNoteGrid.grdMain.commit();
				var userNM = "${sessionScope.userInfo.userNm}";
				var userId = "${sessionScope.userInfo.userId}";
				var setCols = {UPDATE_ID : userNM};//보여주기 위함
				
				setCols.USER_ID = userNM;//담당자 이름을 보여주기 위함
				setCols.USER_ID_TEMP = userId;//담당자 INSERT 위함
				setCols.UPDATE_ID_TEMP = "${sessionScope.userInfo.userId}"; //등록자 INSERT 위함
				setCols.CREATE_ID = "${sessionScope.userInfo.userId}"; //CREATE_ID INSERT 위함
				
				
				var TODAY = new Date();
				setCols.MINUTES_DATE = TODAY.format('yyyy-mm-dd');
				meetingNote.meetingNoteGrid.dataProvider.insertRow(0, setCols);
				
			});
			
			$("#btnDeleteRows").on('click', function (e) {
				//*삭제는 등록한 사람 + SCM팀 권한자 + 담당자
				
				// FEED BACK
				// 1. 한개도 체크 안했을 시 팝업문구 변경
				// 2. 두개이상 어떤게 삭제 권한이 있는지 모름
				// 3. 삭제 대상 NUMBER를 ALERT와 같이 표출요청
				
				var deleteValidationFalseCnt = 0;
				
				var deleteValadationFalseList = "";
				
				var deleteValidationArray = [];
				
				
				var deleteRequesterNm = "${sessionScope.userInfo.userNm}";   // 삭제 요청자  name
				var deleteRequesterID =  "${sessionScope.userInfo.userId}";  // 삭제 요청자 id
				var rows = meetingNote.meetingNoteGrid.grdMain.getCheckedRows();
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
					// 삭제 권한이 있는 것:removeRows(rows, false) 처리    meetingNote.meetingNoteGrid.dataProvider.removeRows(rows, false);
					// 삭제 권한이 없는 것:checkItem(v, false)처리 및 배열에 담아 alert을 통해 권한 없는 정보 알림
					
					$.each(rows,function (n,v) {
						//삭제 권한 있음// 등록한 사람, SCM, 담당자
						//deleteRequesterNm==dataManager||deleteRequesterID==dataCreater||isSCM==1
						var Manager = meetingNote.meetingNoteGrid.grdMain.getValue(v,"USER_ID_TEMP"); // 담당자 id
						var Creater = meetingNote.meetingNoteGrid.grdMain.getValue(v,"CREATE_ID");
						
						if(deleteRequesterID==Manager||deleteRequesterID==Creater||isSCM==1||isADMIN==1)
						{
							//meetingNote.meetingNoteGrid.dataProvider.removeRows(v, false);
							deleteValidationArray.push(v);
							
						}
						//삭제 권한 없음
						else
						{
						
							deleteValidationFalseCnt++;
							deleteValadationFalseList += meetingNote.meetingNoteGrid.grdMain.getValue(v,"MINUTES_ID")+' ';	
							
							meetingNote.meetingNoteGrid.grdMain.checkItem(v, false);
						}
					});
					
					meetingNote.meetingNoteGrid.dataProvider.removeRows(deleteValidationArray, false);
				    /*
				    
				    ============    removeRows(rows,false);에서 rows는 배열이어야 한다.    ================
				    
					*/
					//1.삭제할 대상 선택,권한이 있는 것과 없는 것이 섞여 있을 경우, alert_1: '삭제권한 없음:'+'\n'+deleteValadationFalseList+'\n'+'삭제권한이 없는 게시글은 체크가 해제 됩니다.'
					//2.권한이 있는 것만 선택했을 경우, alert_2: ""  => alert 불필요
					//3.권한이 없는 것만 선택했을 경우, alert_3: ""  => 삭제 권한 없는 게시물 id list로 보여줌
					
					if(deleteValidationFalseCnt>0)
					{
						alert('<spring:message code="msg.deleteValidationFalse"/>'+'\n'+deleteValadationFalseList+'\n'+'<spring:message code="msg.deleteValidationDescription"/>');	
					}
					else{
						//alert 불필요
					}
					
					
					
				}
				
				
				
				// end of $(#btnDeleteRows).on('click',function(e))	
			});
			
			$("#btnReset").on('click', function (e) {
				meetingNote.meetingNoteGrid.grdMain.cancel();
				meetingNote.meetingNoteGrid.dataProvider.rollback(meetingNote.meetingNoteGrid.dataProvider.getSavePoints()[0]);
				
				if(searchData!=null)
				{
					meetingNote.gridCallback(searchData);
					meetingNote.meetingNoteGrid.grdMain.fitRowHeightAll(0, true);
				}
				
			});
			
	
		},
		
		//엑셀 다운로드
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
					//ID	
					if(id == "divMeetingNoteId"){
						EXCEL_SEARCH_DATA += $("#txtMeetingNoteId").val();
					}
					//회의 제목
					else if(id == "divTitle"){
						EXCEL_SEARCH_DATA += $("#txtMeetingTitle").val();
					}
					//내용
					else if(id == "divContent"){
						EXCEL_SEARCH_DATA += $("#txtContent").val();
					}
					//팀
					else if( id == "divTeam"){
						$.each($("#team option:selected"), function(i2, val2){
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					
					}
					//담당자
					else if( id == "divManager"){
						EXCEL_SEARCH_DATA += $("#manager_nm").val();
					}
					//검색조건
					else if(id == "divSearchReqmt"){
						EXCEL_SEARCH_DATA += $("#txtSearchReqmt").val();
					}
					
				}
			});
			//일자
		EXCEL_SEARCH_DATA += "\n" + '<spring:message code="lbl.date"/>' + " : ";
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
						meetingNote.meetingNoteGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						meetingNote.meetingNoteGrid.grdMain.cancel();
												
						
						meetingNote.meetingNoteGrid.dataProvider.setRows(data.resList);
						meetingNote.meetingNoteGrid.dataProvider.clearSavePoints();
						meetingNote.meetingNoteGrid.dataProvider.savePoint(); //초기화 포인트 저장
						
						searchData = data.resList;
						meetingNote.gridCallback(data.resList);
						
						gfn_setSearchRow(meetingNote.meetingNoteGrid.dataProvider.getRowCount());
						meetingNote.meetingNoteGrid.gridInstance.setFocusKeys();
						
						meetingNote.meetingNoteGrid.grdMain.fitRowHeightAll(0, true);
						
											
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
	
		
	

	save : function() {
		var userID = "${sessionScope.userInfo.userId}";
		var grdData = gfn_getGrdSavedataAll(this.meetingNoteGrid.grdMain);
		
		for(i=0;i<grdData.length;i++)
		{
			grdData[i].UPDATE_ID_TEMP = "${sessionScope.userInfo.userId}";	
		}
		
		
		if (grdData.length == 0) {
			alert('<spring:message code="msg.noChangeData"/>');
			return;
		}
		
		//그리드 유효성 검사
		var arrColumn = ["USER_ID", "TITLE","TEAM_CD", "CONTENT", "MINUTES_DATE","UPDATE_ID"];
		
		if (!gfn_getValidation(this.meetingNoteGrid.gridInstance, arrColumn)) {
			return;
		}
			
		
		confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
				
    		//저장위치 처리
    		//issueMng.issueGrid.gridInstance.saveTopUpdKeys("TRANS_TYPE|TRANS_ID");
		 
			//저장
			FORM_SEARCH = {}; //초기화
			FORM_SEARCH._mtd   = "saveAll";
			FORM_SEARCH.tranData = [{outDs:"saveCnt",_siq : meetingNote._siq, grdData : grdData}];
			
			var ajaxOpt = {
				url     : GV_CONTEXT_PATH + "/biz/obj.do",
				data    : FORM_SEARCH,
				success : function(data) {
					if (data.errCode == -10) {
						alert(gfn_getDomainMsg("msg.dupData", data.errLine));
						meetingNote.meetingNoteGrid.grdMain.setCurrent({dataRow : data.errLine - 1, column : "TRANS_ID"});
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
			if(resList[i].CREATE_ID == "${sessionScope.userInfo.userId}"||isADMIN==1||isSCM==1)
			{
				this.meetingNoteGrid.grdMain.setCellStyles(i,"TEAM_CD","editStyle");
				this.meetingNoteGrid.grdMain.setCellStyles(i,"USER_ID","editStyle");
				this.meetingNoteGrid.grdMain.setCellStyles(i,"TITLE","editStyle");
				this.meetingNoteGrid.grdMain.setCellStyles(i,"CONTENT","editStyle");
				this.meetingNoteGrid.grdMain.setCellStyles(i,"MINUTES_DATE","editStyle");
				this.meetingNoteGrid.grdMain.setCellStyles(i,"REMARK","editStyle");
				this.meetingNoteGrid.grdMain.setCellStyles(i,"FILE_NM_ORG","notEditStyle");
				
			}
			//로그인사람과 등록자가 다를 경우, not editable 
			// 로그인사람이 SCM 권한이 없을 경우, editable
			// 로그인사람이 ADMIN 권한이 없을 경우, editable
			else{
				
				this.meetingNoteGrid.grdMain.setCellStyles(i,"TEAM_CD","notEditStyle");
				this.meetingNoteGrid.grdMain.setCellStyles(i,"USER_ID","notEditStyle");
				this.meetingNoteGrid.grdMain.setCellStyles(i,"TITLE","notEditStyle");
				this.meetingNoteGrid.grdMain.setCellStyles(i,"CONTENT","notEditStyle");
				this.meetingNoteGrid.grdMain.setCellStyles(i,"MINUTES_DATE","notEditStyle");
				this.meetingNoteGrid.grdMain.setCellStyles(i,"REMARK","notEditStyle");
				this.meetingNoteGrid.grdMain.setCellStyles(i,"FILE_NM_ORG","notEditStyle");
				
			}
			
			
		}
		
		
	}
	
	
};

	
	
	
	
	//조회
	var fn_apply = function (sqlFlag) {
		
		
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql = sqlFlag;
   	
   		meetingNote.search();
   		meetingNote.excelSubSearch();
   		
	}
			
	
	var fn_popupCallback = function () {
		if (arguments.length > 0 && arguments[0] == "EMP") {
			
			meetingNote.meetingNoteGrid.dataProvider.setValue(arguments[2], "USER_ID", arguments[1][0].USER_NM);
			meetingNote.meetingNoteGrid.dataProvider.setValue(arguments[2], "USER_ID_TEMP", arguments[1][0].USER_ID);
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
							   { outDs : "isAdmin",_siq : "meetingNote.isAdmin"},{ outDs : "isSCMTeam",_siq : "meetingNote.isSCMTeam"}					
			];
		
		
		
		var aOption = {
			async   : false,
			url     : GV_CONTEXT_PATH + "/biz/obj.do",
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
    
	/*
	//로그인 ID와 조회한 게시물의 CREATE_ID를 비교하여 동일ID 이면 TRUE, 다르면 FALSE 
    function fn_checkCreateIDandIsCreaterAdd(data){
    	
    	var logInID="${sessionScope.userInfo.userId}";
    	
    	for(i=0 ;data.length>i; i++)
    	{
    		if(data[i].CREATE_ID == logInID)
    		{
    			data[i].IS_CREATER = true;
    		}
    		else
    		{
    			data[i].IS_CREATER = false;
    		}
    	}
    	
    	
        console.log("data:",data);
    	
    	
    	return data;
    }
    */
	// onload 
	$(document).ready(function() {
		meetingNote.init();
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
					<div class="view_combo" id="divMeetingNoteId">
						<div class="ilist">
							<div class="itit" ><spring:message code="lbl.meetingNoteId"/></div>
							<input type="text" id="txtMeetingNoteId" name="txtMeetingNoteId" class="ipt">
						</div>
					</div>
					<div class="view_combo" id="divTitle">
						<div class="ilist">
							<div class="itit" ><spring:message code="lbl.meetingTitle"/></div>
							<input type="text" id="txtMeetingTitle" name="txtMeetingTitle" class="ipt" >
						</div>
					</div>
					<div class="view_combo" id="divContent">
						<div class="ilist">
							<div class="itit" ><spring:message code="lbl.content"/></div>
							<input type="text" id="txtContent" name="txtContent" class="ipt" >
						</div>
					</div>
					<div class="view_combo" id="divTeam"></div>
					<div class="view_combo" id="divManager"></div>
					<div class="view_combo" id="divSearchReqmt">
						<div class="ilist">
							<div class="itit" ><spring:message code="lbl.searchReqmt"/></div>
							<input type="text" id="txtSearchReqmt" name="txtSearchReqmt" class="ipt" >
						</div>
					</div>
					
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
