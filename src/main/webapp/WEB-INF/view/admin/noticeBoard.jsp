<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
	<jsp:param name="chartYn" value="Y"/>
</jsp:include>

	<script type="text/javascript">
	
	//공지사항의 경우, GRID 1ROW당 하나의 공지사항이 추가되어야 하므로 GRID 추가 가능 MAX ROW가 1개가 되도록 해야함 
	var addRowCnt = 0;
	var rowUpdatedYn = false;
	var pastRowSelectedIndex = null;
	var tempQuillUpdatedArray = [];
	// row 추가시, content div에 input을 처리하기 위해 quill.setContents([]), quill.enable(true), quill.focus()처리를 위해
	// rowState_created = true인 경우에는 다른 row 클릭 시, "공지사항 작성을 취소하겠습니까?" confirm 후에  yes => row 추가 취소 및 재설정, no => row 추가로 인한 다른 row 클릭 해제(작성중인 row로 회귀) 
	var rowState_created = false; 
	
	
	var SCM_SEARCH = {};
	var searchData = null;
	var enterSearchFlag = "Y";
	var noticeBoard= {
      
		init : function () {
			
			gfn_formLoad();
			fn_initDate();
			this.comCode.initCode();
			this.initFilter();
			this.noticeBoardGrid.initGrid();
			this.events();
			
		},
			
		_siq : "admin.noticeBoard",
		
		initFilter : function() {
			
			
			// 키워드팝업
			gfn_keyPopAddEvent([
				{target : 'divManager', id : 'manager', type : 'EMP', title : '<spring:message code="lbl.writer"/>'}
			]);
			
			
	    	// 콤보박스
	    	// 공지여부:divShowYn
	    	//noticeBoard.comCode.codeMap.PJT_STATUS_CD
			gfn_setMsComboAll([
				{target : 'divTeam',   id : 'team',    title : '<spring:message code="lbl.team"/>', data : this.comCode.codeMapEx.TEAM_CD, exData:['*'],},
				{target : 'divShowYn',   id : 'showYn',    title : '<spring:message code="lbl.showYn"/>', data : this.comCode.codeMap.PJT_STATUS_CD, exData:['ST'],}
				]);
	    	
		
		},
		
		/*
		* common Code 
		*/
		comCode : {
			
			codeMap : null,
			codeMapEx: null,
			initCode  : function () {
				
				var grpCd = 'PJT_STATUS_CD';
				
				this.codeMap = gfn_getComCode(grpCd,'N'); //공통코드 조회
				
				this.codeMapEx = gfn_getComCodeEx(["TEAM_CD"],null,{});
			
			}
		},
	
		/* 
		* grid  선언
		*/
		noticeBoardGrid : {
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
						name : "NOTICE_ID", fieldName: "NOTICE_ID", editable: false, header: {text: 'NOTICE ID'},
						styles : {textAlignment : "center", background : gv_noneEditColor},
						width : 100,
					}, 
					
					{
						name : "TITLE", fieldName : "TITLE", editable: true, header: {text: '<spring:message code="lbl.title" javaScriptEscape="true" />'},
						styles : {textAlignment: "near",textWrap: 'explicit'},
						dynamicStyles : [{ criteria: ["state<>'c'","state='c'"], styles: ["background="+gv_editColor,"background="+gv_requiredColor] }],
						width : 200, cursor: "pointer"
						
					},
					{
						name : "USER_ID", fieldName : "USER_ID", editable: true, header : {text: '<spring:message code="lbl.writer" javaScriptEscape="true" />'},
						styles : {textAlignment : "center"},
						dynamicStyles : [{ criteria: ["state<>'c'","state='c'"], styles: ["background="+gv_editColor,"background="+gv_requiredColor] }],
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
						name: "TEAM_CD", 
						fieldName : "TEAM_CD", 
						editable : true, header : {text: '<spring:message code="lbl.team" javaScriptEscape="true" />'},
						styles : {textAlignment: "center"},
						dynamicStyles : [{ criteria: ["state<>'c'","state='c'"], styles: ["background="+gv_editColor,"background="+gv_requiredColor] }],
						width  : 100,
						editor : { type: "dropDown", domainOnly : true, textReadOnly: true}, 
						values : gfn_getArrayExceptInDs(noticeBoard.comCode.codeMapEx.TEAM_CD, "CODE_CD", ""),
						labels : gfn_getArrayExceptInDs(noticeBoard.comCode.codeMapEx.TEAM_CD, "CODE_NM", ""),
						lookupDisplay : true,
						nanText : "",
						editButtonVisibility : "visible"
					},
				
					{
						name   : "REG_DATE", fieldName : "REG_DATE", header: {text: '<spring:message code="lbl.regDttm" javaScriptEscape="true" />'},
						styles : {textAlignment : "center"},
						editor : {type : "date", datetimeFormat : "yyyy-MM-dd"},
						dynamicStyles : [{ criteria: ["state<>'c'","state='c'"], styles: ["background="+gv_editColor,"background="+gv_requiredColor] }],
						width  : 100
					},
					{
						name   : "START_DATE", fieldName : "START_DATE", header: {text: '<spring:message code="lbl.postingPeriod" javaScriptEscape="true" />(<spring:message code="lbl.startDate" javaScriptEscape="true" />)'},
						styles : {textAlignment : "center"},
						editor : {type : "date", datetimeFormat : "yyyy-MM-dd"},
						dynamicStyles : [{ criteria: ["state<>'c'","state='c'"], styles: ["background="+gv_editColor,"background="+gv_requiredColor] }],
						width  : 120
					},
					
					{
						name   : "CLOSE_DATE", fieldName : "CLOSE_DATE", header: {text:'<spring:message code="lbl.postingPeriod" javaScriptEscape="true" />(<spring:message code="lbl.endTime" javaScriptEscape="true" />)' },
						styles : {textAlignment : "center"},
						editor : {type : "date", datetimeFormat : "yyyy-MM-dd"},
						dynamicStyles : [{ criteria: ["state<>'c'","state='c'"], styles: ["background="+gv_editColor,"background="+gv_requiredColor] }],
						width  : 120
					},
					{
						name : "FILE_NM_ORG", fieldName : "FILE_NM_ORG", editable: false, header : {text: '<spring:message code="lbl.file" javaScriptEscape="true" />'},
						styles : {textAlignment : "near",background:gv_editColor},
						width : 250,
						buttonVisibility:"visible" ,cursor: "pointer",button: "action"
					},
					{
						//진행상태
						name         : "NOTICE_STATUS_CD",
						fieldName    : "NOTICE_STATUS_CD",
						editable : true, header : {text: '<spring:message code="lbl.showYn" javaScriptEscape="true" />'},
						styles : {textAlignment: "center"},
						dynamicStyles : [{ criteria: ["state<>'c'","state='c'"], styles: ["background="+gv_arrDimColor[8],"background="+gv_requiredColor] }],
						width  : 100,
						editor : { type: "dropDown", domainOnly : true, textReadOnly: true}, 
						values : gfn_getArrayExceptInDs(noticeBoard.comCode.codeMap.PJT_STATUS_CD, "CODE_CD", "ST"),
						labels : gfn_getArrayExceptInDs(noticeBoard.comCode.codeMap.PJT_STATUS_CD, "CODE_NM", "ST"),
						lookupDisplay : true,
						nanText : "",
						editButtonVisibility : "visible"
					}
					
					
				];
				// CREATE_ID
				// TB_KPI_MINUTES 테이블 저장시에 필요 필드 값: COMPANY_CD, BU_CD, MINUTES_ID, TEAM_CD, USER_ID, TITLE, CONTENT, MINUTES_DATE
				// REMARK, FILE_NM_ORG, CREATE_ID, CREATE_DTTM, UPDATE_ID, UPDATE_DTTM
				// 회의록 화면
				// show data: MINUTES_ID, TEAM_CD, USER_ID, TITLE, CONTENT, MINUTES_DATE, REMARK, FILE_NO, CREATE_ID
				// hide data: COMPANY_CD, BU_CD, CREATE_DTTM, UPDATE_ID, UPDATE_DTTM
				this.setFields(columns, ['COMPANY_CD','CREATE_ID', 'CREATE_DTTM','FILE_NO','USER_ID_TEMP','UPDATE_ID_TEMP','CONTENT','BU_CD','USER_NM']);
				
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
				
				//this.grdMain.setSelectOptions({style:"rows"})
				
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
					
					
					
					// created, updated, deleted, none, createAndDeleted
					var row = index.itemIndex
					
					
					var rowState = noticeBoard.noticeBoardGrid.dataProvider.getRowState(row);
					
					
					
					fn_allRowCheck_ifUpdated();
					
					
					if(rowUpdatedYn&&(row!=pastRowSelectedIndex))
					{
							
							noticeBoard.noticeBoardGrid.grdMain.setCurrent({itemIndex:pastRowSelectedIndex});
							alert('현재 공지사항을 수정중입니다. 저장 후 진행주세요.');
							
					}
					else
					{
											
					
							if(rowState=="created")
							{

							}
							//false:row 상태 변화 없음, 저장 불필요
							
							
							//더블크릭이벤트를 통해 Content 수정이 발생하였거나, GRID ROW 값이 수정되었을 때,
							else if(rowState=="updated")
							{
								if(addRowCnt<1)
								{
									quill.setContents(JSON.parse(grid.getValue(row,"CONTENT")).ops);
									quill.enable(false);
									$('#toolbar').hide();
								}
								else
								{
									noticeBoard.noticeBoardGrid.grdMain.resetCurrent();
									alert('현재 공지사항을 작성중입니다. 저장 후 진행주세요.');	
								}
								
							}
							else if(rowState=="deleted")
							{
								//row 추가하지 않았을 때
								if(addRowCnt<1)
								{
									quill.setContents(JSON.parse(grid.getValue(row,"CONTENT")).ops);
									quill.enable(false);
									$('#toolbar').hide();	
								}
								//row 추가되었을 때
								else
								{
									noticeBoard.noticeBoardGrid.grdMain.resetCurrent();
									alert('현재 공지사항을 작성중입니다. 저장 후 진행주세요.');			
								}
							}
							else if(rowState=="createAndDeleted")
							{
								//row 추가하지 않았을 때
								if(addRowCnt<1)
								{
									quill.setContents(JSON.parse(grid.getValue(row,"CONTENT")).ops);
									quill.enable(false);
									$('#toolbar').hide();	
								}
								//row 추가되었을 때
								else
								{
									noticeBoard.noticeBoardGrid.grdMain.resetCurrent();
									alert('현재 공지사항을 작성중입니다. 저장 후 진행주세요.');			
								}
							}
							else if(rowState=="none")
							{
								//row 추가하지 않았을 때
								if(addRowCnt<1)
								{
									quill.setContents(JSON.parse(grid.getValue(row,"CONTENT")).ops);
									quill.enable(false);
									$('#toolbar').hide();	
								}
								//row 추가되었을 때
								else
								{
									noticeBoard.noticeBoardGrid.grdMain.resetCurrent();
									alert('현재 공지사항을 작성중입니다. 저장 후 진행주세요.');	
								}
							}
							pastRowSelectedIndex = row;
					}//end of if
					
					
					
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
			  	
			    //셀 더블클릭
			   	this.grdMain.onDataCellDblClicked = function (grid, index) {
			    	
			   		var row = index.itemIndex;
			   		quill.enable(true);
			   		quill.focus();
			   		$('#toolbar').show();
			    	
			   		quill.on('text-change', function(delta, oldDelta, source) {
			   		  if (source == 'api') {
			   		  } else if (source == 'user') {
			   		 	//noticeBoard.noticeBoardGrid.dataProvider.setRowState(row, "updated", false);
			   		 	
			   		  }
			   		});
				
			    }
			   	
				this.grdMain.onCellButtonClicked = function (grid, itemIndex, column) {
					
					
					
					
					if (column.name == "FILE_NM_ORG") {
						var rowState = noticeBoard.noticeBoardGrid.dataProvider.getRowState(itemIndex);
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
						
							
							var params = {
				       			COMPANY_CD   : grid.getValue(itemIndex, "COMPANY_CD"),		 // 여기가 문제  <=    getValue를 통해 해당 값을 가져오려면 dataProvider에 모든 데이터가 query 문을 통해 불러져 와 있어야 한다.				
				       			NOTICE_ID    : grid.getValue(itemIndex, "NOTICE_ID"),		       				
			       				FILE_NO      : grid.getValue(itemIndex, "FILE_NO"),		       				
			       				_siq         : noticeBoard._siq+"FileNo",		       				
				       			callback     : "fn_popupCallback",
				       		};
				       
				       		gfn_comPopupOpen("FILE",params);
					
			       	
						
					}
					else if(column.name =="USER_ID"){
						
						var params = {
								searchCode : grid.getValue(itemIndex, "USER_ID_TEMP"),		       				
								searchName : grid.getValue(itemIndex, "USER_ID_TEMP"),		       				
			       				callback   : "fn_popupCallback",
			       				singleYn   : "Y",
			       				rowId      : itemIndex,
			       			};
			       			gfn_comPopupOpen("EMP",params);
						
						
					}
					 
					
		       	}// END OF onCellButtonClicked
			}
			
		},
		
		
		
		
		
		/*
		* event 정의
		*/
		events : function () {
			
			
			
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
				quill.setContents([]);
				$('#toolbar').hide();
			});
			
			
			$("#btnSave").on('click', function (e) {
				noticeBoard.save();
			});
			
			$("#btnAddChild").on('click', function(e) {
				noticeBoard.noticeBoardGrid.grdMain.commit(true);
				// 일반 grid와 달리 공지사항에서는 row 추가할 경우,1개의 row만 추가되도록 처리해야 함.
				
				//noticeBoard.noticeBoardGrid.grdMain
				//noticeBoard.noticeBoardGrid.dataProvider
				
				fn_allRowCheck_ifUpdated();
				
				
				if(rowUpdatedYn)
				{
					alert('현재 공지사항을 수정중입니다. 저장 후 진행주세요.');
				
				}
				else
				{
					if(addRowCnt<1)
					{
						noticeBoard.noticeBoardGrid.grdMain.commit();
						var userNM = "${sessionScope.userInfo.userNm}";
						var userId = "${sessionScope.userInfo.userId}";
						var setCols = {UPDATE_ID : userNM};//보여주기 위함
						
						setCols.USER_ID = userNM;//담당자 이름을 보여주기 위함
						setCols.USER_ID_TEMP = userId;//담당자 INSERT 위함
						setCols.UPDATE_ID_TEMP = "${sessionScope.userInfo.userId}"; //등록자 INSERT 위함
						setCols.CREATE_ID = "${sessionScope.userInfo.userId}"; //CREATE_ID INSERT 위함
						
						var TODAY = new Date();
						setCols.REG_DATE = TODAY.format('yyyy-mm-dd');
						noticeBoard.noticeBoardGrid.dataProvider.insertRow(0, setCols);
						
						quill.setContents([]);
						$('#toolbar').show();
						quill.enable(true);
				   		quill.focus();
				   		addRowCnt++;
						
				   		setTimeout(function () {  
				   			noticeBoard.noticeBoardGrid.grdMain.setCurrent({dataRow:0})
				   		}, 100);
					}
					else
					{
						alert('현재 공지사항을 작성중입니다.');
					}
				}//end of else
			});
			
			$("#btnDeleteRows").on('click', function (e) {
				
				var rows = noticeBoard.noticeBoardGrid.grdMain.getCheckedRows();
				//삭제할 대상을 선택하지 않은체, 삭제버튼을 누른 경우,
				if(rows.length==0){
					alert('<spring:message code="msg.deleteTargetNotSelected"/>');
					return false;
					
				}
				else{
					
					noticeBoard.noticeBoardGrid.dataProvider.removeRows(rows,false);
				}
				
				
		
			});
			
			$("#btnReset").on('click', function (e) {
				fn_apply(false);
				quill.setContents([]);
				$('#toolbar').hide();
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
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SEARCH,
				success : function (data) {
					
					
					if (FORM_SEARCH.sql == 'N') {
						noticeBoard.noticeBoardGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						noticeBoard.noticeBoardGrid.grdMain.cancel();
												
						
						noticeBoard.noticeBoardGrid.dataProvider.setRows(data.resList);
						noticeBoard.noticeBoardGrid.dataProvider.clearSavePoints();
						noticeBoard.noticeBoardGrid.dataProvider.savePoint(); //초기화 포인트 저장
						
						searchData = data.resList;
						//noticeBoard.gridCallback(data.resList);
						
						gfn_setSearchRow(noticeBoard.noticeBoardGrid.dataProvider.getRowCount());
						noticeBoard.noticeBoardGrid.gridInstance.setFocusKeys();
						
						noticeBoard.noticeBoardGrid.grdMain.fitRowHeightAll(0, true);
						
						addRowCnt=0;
											
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
	
		
	

	save : function() {
		var userID = "${sessionScope.userInfo.userId}";
		var grdData = gfn_getGrdSavedataAll(this.noticeBoardGrid.grdMain);
		
		for(i=0;i<grdData.length;i++)
		{
			grdData[i].UPDATE_ID_TEMP = "${sessionScope.userInfo.userId}";	
			//여기가 문제 지점
			//변경사항이 있는 모든 row 들의 ONTENT 값이 모두 현재 보여지고 있는 QUILL EDITOR 상의 데이터가 들어가게 저장되게 된다
			// ROW에 대해 수정이 발견했으 경우(STATE: UDPATE) 다른 ROW 선택안되게 강제하기
			grdData[i].CONTENT = JSON.stringify(quill.getContents());
		}
		
		
		
		if (grdData.length == 0) {
			alert('<spring:message code="msg.noChangeData"/>');
			return;
		}
		
		//그리드 유효성 검사
		var arrColumn = ["USER_ID", "TITLE","TEAM_CD", "REG_DATE","START_DATE","CLOSE_DATE","NOTICE_STATUS_CD"];
		
		if (!gfn_getValidation(this.noticeBoardGrid.gridInstance, arrColumn)) {
			return;
		}
			
		
		confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
				
    		//저장위치 처리
    		//issueMng.issueGrid.gridInstance.saveTopUpdKeys("TRANS_TYPE|TRANS_ID");
		 
			//저장
			FORM_SEARCH = {}; //초기화
			
			FORM_SEARCH._mtd   = "saveAll";
			FORM_SEARCH.tranData = [{outDs:"saveCnt",_siq : noticeBoard._siq, grdData : grdData}];
			
			var ajaxOpt = {
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SEARCH,
				success : function(data) {
					if (data.errCode == -10) {
						alert(gfn_getDomainMsg("msg.dupData", data.errLine));
						noticeBoard.noticeBoardGrid.grdMain.setCurrent({dataRow : data.errLine - 1, column : "NOTICE_ID"});
					} else {
						alert('<spring:message code="msg.saveOk"/>');
						
						fn_apply(false);
						addRowCnt=0;
						rowUpdatedYn = false;
					}
				},
			};
			
			gfn_service(ajaxOpt, "obj");
		});
	},
	
	
	
	gridCallback : function(resList){
		
		
		fn_delAuthorityHasOrNot(); 
		var isSCMTeamAdmin = SCM_SEARCH.isSCMTeamAdmin;
		
		
		
		for (var i = resList.length-1; i >= 0; i--) 
		{
			
			// 로그인사람과 등록자가 같을 경우, editable
			// 로그인사람이 SCM 권한 일 경우, editable
			// 로그인사람이 ADMIN 권한 일 경우, editable
			if(resList[i].CREATE_ID == "${sessionScope.userInfo.userId}"||isSCMTeamAdmin==1)
			{
				this.noticeBoardGrid.grdMain.setCellStyles(i,"TEAM_CD","editStyle");
				this.noticeBoardGrid.grdMain.setCellStyles(i,"USER_ID","editStyle");
				this.noticeBoardGrid.grdMain.setCellStyles(i,"TITLE","editStyle");
				this.noticeBoardGrid.grdMain.setCellStyles(i,"REG_DATE","editStyle");
				this.noticeBoardGrid.grdMain.setCellStyles(i,"FILE_NM_ORG","notEditStyle");
				
			}
			//로그인사람과 등록자가 다를 경우, not editable 
			// 로그인사람이 SCM 권한이 없을 경우, editable
			// 로그인사람이 ADMIN 권한이 없을 경우, editable
			else{
				
				this.noticeBoardGrid.grdMain.setCellStyles(i,"TEAM_CD","notEditStyle");
				this.noticeBoardGrid.grdMain.setCellStyles(i,"USER_ID","notEditStyle");
				this.noticeBoardGrid.grdMain.setCellStyles(i,"TITLE","notEditStyle");
				this.noticeBoardGrid.grdMain.setCellStyles(i,"REG_DATE","notEditStyle");
				this.noticeBoardGrid.grdMain.setCellStyles(i,"FILE_NM_ORG","notEditStyle");
				
			}
			
			
		}
		
		
	}
	
	
};

	
	
	
	
	//조회
	var fn_apply = function (sqlFlag) {
		
		
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql = sqlFlag;
   	
    	noticeBoard.search();
    	noticeBoard.excelSubSearch();
    	pastRowSelectedIndex = null;
	}
			
	
	var fn_popupCallback = function () {
		if (arguments.length > 0 && arguments[0] == "EMP") {
			
			noticeBoard.noticeBoardGrid.dataProvider.setValue(arguments[2], "USER_ID", arguments[1][0].USER_NM);
			noticeBoard.noticeBoardGrid.dataProvider.setValue(arguments[2], "USER_ID_TEMP", arguments[1][0].USER_ID);
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
							   { outDs : "isSCMTeamAdmin",_siq : "admin.noticeBoard"+"IsAdmin"}					
			];
		
		
		
		var aOption = {
			async   : false,
			url     : GV_CONTEXT_PATH + "/biz/obj",
			data    : SCM_SEARCH,
			success : function (data) {
			
				if (SCM_SEARCH.sql == 'N') {
					
					SCM_SEARCH.isSCMTeamAdmin = data.isSCMTeamAdmin[0].isSCMTeamAdmin;
			
					
				}
			}
		}
		
		gfn_service(aOption, "obj");
    	
    }
    
	
	// onload
	var quill;
	
	$(document).ready(function() {
		noticeBoard.init();
			
		
	 quill = new Quill('#quill', {
			  modules:{
				  toolbar: '#toolbar'
			  },
			  theme: 'snow'  // or 'bubble'
			}); // end of quill defition
	 
			quill.enable(false);
	 $('#toolbar').hide();
	 	
	 
	 	});//end of document. ready
	
	function checkGridState(objGrid){
		objGrid.commit();
	 		
		var objData = objGrid.getDataProvider();
	    var rows = objData.getAllStateRows();
	 		
	    var result = null;

	    if (rows.updated.length > 0) {
	    	result = true;
	    }
	    else{
	    	result = false;
	    }

	    
	    // result == true  => row 상태 변화 있음, 저장해야 함
	    // result == false => row 상태 변화 없음, 저장 불필요
	 	return result;
	}
	 	
	 	
	 //row들에 대해 수정이 발생할 경우, 다른 row들을 선택하지 못하게 강제하는 함수	
	function fn_allRowCheck_ifUpdated(){
		
		// dataProvider들을 순회하며 RowState가 update 인지 확인하여 update인 항목이 있으면
		// 다른 row로 이동하지 못하도록 강제하기위함
		for(i=0;i<noticeBoard.noticeBoardGrid.dataProvider.getRowCount();i++)	 
		{
			if(noticeBoard.noticeBoardGrid.dataProvider.getRowState(i) == "updated")
			{
				rowUpdatedYn = true;
			}
				
		}
		
		
						
	}
	 	
    </script>
</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<!-- left -->
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
							<div class="itit" ><spring:message code="lbl.title"/></div>
							<input type="text" id="txtMeetingTitle" name="txtMeetingTitle" class="ipt" >
						</div>
					</div>
					<div class="view_combo" id="divShowYn"></div><!-- 공지여부 -->
					<div class="view_combo" id="divTeam"></div>
					<div class="view_combo" id="divManager"></div>
					<div class="view_combo" id="divSearchReqmt">
						<div class="ilist">
							<div class="itit" ><spring:message code="lbl.content"/></div>
							<input type="text" id="txtSearchReqmt" name="txtSearchReqmt" class="ipt" >
						</div>
					</div>
					
					<div id="view_Her">
							<strong class="filter_tit">View Horizon</strong>
							<div class="tlist">
								<div class="tit"><spring:message code="lbl.regDttm"/></div>
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
		<!-- contents 상 -->
		<div id="e" class="split content" style="border:0;background:transparent;">
			<div id="grid1" class="fconbox">
				<%@ include file="/WEB-INF/view/common/commonLocation.jsp" %>
				<div class="use_tit">
					<h3>List</h3>
				</div>
				<div class="scroll">
					<!-- 그리드영역 -->
					<div id="realgrid" class="realgrid1"></div>
					<div class="cbt_btn roleWrite">
						<div class="bleft">
							<%-- <a id="btnLocalApply"  href="#" class="app1"><spring:message code="lbl.apply"  /></a> --%> 
							
							<a id="btnReset"       href="#" class="app1"><spring:message code="lbl.reset" /></a>
							<a id="btnAddChild"    href="#" class="app1"><spring:message code="lbl.add" /></a> 
							<a id="btnDeleteRows"  href="#" class="app1"><spring:message code="lbl.delete" /></a>
							<a id="btnSave"        href="#" class="app2"><spring:message code="lbl.save" /></a>
						</div>
					</div>	
				</div>
			</div>
		</div>
		<!-- contents 하 -->
		 
			<div id="f" class="split content" style="border:0;">
				<div id="grid2" class="fconbox">
					<div class="use_tit">
						<h3>Content</h3> 
					</div>
					<div class="scroll" style="height:calc(100% - 20px);flex:1;display:flex;flex-direction:column">
						<div id="toolbar">
							<span class="ql-formats">
						      <select class="ql-font"></select>
						      <select class="ql-size"></select>
						    </span>
						    <span class="ql-formats">
						      <button class="ql-bold"></button>
						      <button class="ql-italic"></button>
						      <button class="ql-underline"></button>
						      <button class="ql-strike"></button>
						    </span>
						    <span class="ql-formats">
						      <select class="ql-color"></select>
						      <select class="ql-background"></select>
						    </span>
						    <span class="ql-formats">
						      <button class="ql-script" value="sub"></button>
						      <button class="ql-script" value="super"></button>
						    </span>
						    <span class="ql-formats">
						      <button class="ql-header" value="1"></button>
						      <button class="ql-header" value="2"></button>
						      <button class="ql-blockquote"></button>
						      <button class="ql-code-block"></button>
						    </span>
						    <span class="ql-formats">
						      <button class="ql-list" value="ordered"></button>
						      <button class="ql-list" value="bullet"></button>
						      <button class="ql-indent" value="-1"></button>
						      <button class="ql-indent" value="+1"></button>
						    </span>
						    <span class="ql-formats">
						      <button class="ql-direction" value="rtl"></button>
						      <select class="ql-align"></select>
						    </span>
						    <span class="ql-formats">
						      <button class="ql-link"></button>
						      <button class="ql-image"></button>

						    </span>
						    <span class="ql-formats">
						      <button class="ql-clean"></button>
						    </span>							 
						</div><!-- end of toolbar div --> 
						<div id="quill" style="height:100%;flex1:1;overflow-y:auto;width:100%;">  <!--  quill은 content 보여주는 용도로만 사용, read only처리해야함 -->
						</div>
					</div>
					
					
					
				</div>
			</div>
		
		
	</div>
</body>
</html>
