<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	<!-- 프로젝트관리 -->
	<script type="text/javascript">
	var SCM_SEARCH = {};
	var PJT_REGI_SEARCH ={};
	
	var searchData = null;
	var enterSearchFlag = "Y";
	var projectMng = {
      
		init : function () {
			
			gfn_formLoad();
			fn_initDate();
			this.comCode.initCode();
			this.initFilter();
			this.projectMngGrid.initGrid();
			this.events();
			
		},
			
		_siq : "snop.meetingMng.projectMng",
		
		initFilter : function() {
			
			
			
			
	    	// 콤보박스
			gfn_setMsComboAll([
				{target : 'divSalesOrgL3Name',   id : 'salesOrgL3Name',    title : '<spring:message code="lbl.salesOrgL3Name"/>', data : this.comCode.codeMap.DIV_CD, exData:[""]}, //본부명
				{target : 'divTeam',   id : 'team',    title : '<spring:message code="lbl.teamName"/>', data : this.comCode.codeMapEx.TEAM_CD, exData:['*']},   // 팀
				{target : 'divProjectType',   id : 'projectType',    title : '<spring:message code="lbl.pjtType"/>', data : this.comCode.codeMap.PJT_TYPE, exData:['*']}, //프로젝트 분류
				{target : 'divProcessStatus',   id : 'processStatus',    title : '<spring:message code="lbl.progressStatus"/>', data : this.comCode.codeMap.PJT_STATUS_CD, exData:['*']}, //진행상태
				 
				]);
	    	
		
		},
		
		/*
		* common Code 
		*/
		comCode : {
			
			codeMap : null,
			codeMapEx: null,
			initCode  : function () {
						//PJT_TYPE,FLAG_YN,  DIV_CD,TEAM_CD,PJT_STATUS_CD,OPEN_YN
				//프로젝트 분류, 과정관리포함여부, 본부명,   팀          , 진행상태,      , 공개여부
				var grpCd = 'PJT_TYPE,FLAG_YN,PJT_STATUS_CD,OPEN_YN,DIV_CD';
				// **********************      코드넣을때, 콤마 뒤에 뛰어쓰기 하면 에러 발생함      **********************
				this.codeMap = gfn_getComCode(grpCd,'N');  // 공통코드 조회
				this.codeMapEx = gfn_getComCodeEx(["TEAM_CD"],null,{});
						
				
				//gfn_setMsCombo("OPEN_YN", this.codeMap.OPEN_YN, ["*"]);
			}
		},
	
		/* 
		* grid  선언
		*/
		projectMngGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.treeInit("realgrid");
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				
				this.setColumn();
				this.setOptions();
				this.gridEvents();
				
			},
			
			// 조회할 때, 로그인한 사용자의 id를 기준으로 글입력한 등록자정보와 로그인한 사용자 정보가 동일할 경우, 해당 개시글에 대한 editable true;
			
			setColumn     : function () {
				
				var newDynamicStyles = [
					{
					    criteria : "values['PJT_CATE_CD'] = 'PJT'",
					    styles : "background=" + gv_arrDimColor[0]
					}
				];
				this.grdMain.setStyles({
				    body: {
				        dynamicStyles: newDynamicStyles
				    }
				});
				
				var columns = 
				[
					{name : "TREE_PATH", fieldName: "TREE_PATH", editable: false, header: {text: 'TREE PATH'},
						styles : {textAlignment : "near"},
						width : 80, visible : false},
					
					{name : "PJT_CATE_CD", fieldName: "PJT_CATE_CD", editable: false, header: {text: 'PJT_CATE_CD'},
							styles : {textAlignment : "near"},
							width : 80, visible : false},
					//구분
					{
						name : "PJT_CATE", fieldName: "PJT_CATE", editable: false, header: {text: '<spring:message code="lbl.division" javaScriptEscape="true" />'},
						styles : {textAlignment : "near"},
						width : 100
					}, 
					//프로젝트 분류
					{ 
						name: "PJT_TYPE", 
						fieldName : "PJT_TYPE", 
						editable : false, header : {text: '<spring:message code="lbl.pjtType" javaScriptEscape="true" />'},
						styles : {textAlignment: "center"},
						width  : 80,
					},
					//프로젝트 NO.
					{
						name : "PROJECT_NO", fieldName : "PROJECT_NO", editable: false, header : {text: '<spring:message code="lbl.pjtNo" javaScriptEscape="true" />'},
						styles : {textAlignment : "near"},
						width : 90,
	
					},
					//본부명
					{
						name : "DIV_CD", fieldName : "DIV_CD", editable: false, header: {text: '<spring:message code="lbl.salesOrgL3Name" javaScriptEscape="true" />'},
						styles : {textAlignment: "center"},
						width : 80
						
					}, 
					//팀명
					{
						name : "TEAM_CD", fieldName : "TEAM_CD", editable: false, header: {text: '<spring:message code="lbl.teamName" javaScriptEscape="true" />'},
						styles : {textAlignment: "center"},
						width : 80
					}, 
					// 프로젝트 Manager
					{
						name   : "PJT_MNGER", fieldName : "PJT_MNGER", editable: false, header: {text: '<spring:message code="lbl.pjtMnger" javaScriptEscape="true" />'},
						styles : {textAlignment : "center"},
						width  : 100
					},
					//프로젝트 참가자
					{
						name : "PJT_MEM", fieldName : "PJT_MEM", editable: false, header : {text: '<spring:message code="lbl.pjtMem" javaScriptEscape="true" />'},
						styles : {textAlignment: "center"},
						width : 170,
					
					},
					//등록권한 담당자
					{
						name : "REGISTER_MNGER", fieldName : "REGISTER_MNGER", editable: false, header : {text: '<spring:message code="lbl.regAuthMnger" javaScriptEscape="true" />'},
						styles : {textAlignment : "center"},
						width : 170,
					}, 
					//프로젝트명
					{
						name : "PJT_NM", fieldName : "PJT_NM",editable: false, header : {text: '<spring:message code="lbl.pjtNm" javaScriptEscape="true" />'},
						styles : {textAlignment : "center"},
						width : 200
					},
					
					//등록자
					{
						name : "CREATE_ID", fieldName : "CREATE_ID", editable: false, header : {text: '<spring:message code="lbl.regUserNm" javaScriptEscape="true" />'},
						styles : {textAlignment : "center"},
						width : 85,
					},
					
					//등록일
					{
						name   : "REG_DATE", fieldName : "REG_DATE",editable: false, header: {text: '<spring:message code="lbl.regDttm" javaScriptEscape="true" />'},
						styles : {textAlignment : "center"},
						editor : {type : "date", datetimeFormat : "yyyy-MM-dd"},
						width  : 80
					},
					//시작일
					{
						name   : "START_DATE", fieldName : "START_DATE",editable: false, header: {text: '<spring:message code="lbl.startDate" javaScriptEscape="true" />'},
						styles : {textAlignment : "center"},
						editor : {type : "date", datetimeFormat : "yyyy-MM-dd"},
						width  : 80
					},
					//완료예상일
					{
						name   : "CLOSE_DATE", fieldName : "CLOSE_DATE",editable: false, header: {text: '<spring:message code="lbl.exptCompDay" javaScriptEscape="true" />'},
						styles : {textAlignment : "center"},
						editor : {type : "date", datetimeFormat : "yyyy-MM-dd"},
						width  : 80
					},
					//진행상태
					{
						name : "PJT_STATUS_CD", 
						fieldName : "PJT_STATUS_CD",editable: false, header : {text: '<spring:message code="lbl.progressStatus" javaScriptEscape="true" />'},
						styles : {textAlignment: "center"},
						width  : 80,
					},
					//목적
					{
						name : "PURPOSE", fieldName : "PURPOSE", editable: false, header : {text: '<spring:message code="lbl.purpose" javaScriptEscape="true" />'},
						editor       : { type: "multiline", textCase: "upper" },
						styles : {textAlignment: "near"},
						width : 240,
					
					},
					//목표
					{
						name : "GOAL", fieldName : "GOAL", editable: false, header : {text: '<spring:message code="lbl.goal" javaScriptEscape="true" />'},
						editor       : { type: "multiline", textCase: "upper" },
						styles : {textAlignment: "near"},
						width : 240,
					
					},
					//과정관리
					{
						name : "PROCESS", fieldName : "PROCESS", editable: false, header : {text: '<spring:message code="lbl.processMng" javaScriptEscape="true" />'},
						editor       : { type: "multiline", textCase: "upper" },
						styles : {textAlignment: "near"},
						width : 240,
					
					},
					//업무진행내역
					{
						name : "PROGRESS", fieldName : "PROGRESS", editable: false, header : {text: '<spring:message code="lbl.businProgress" javaScriptEscape="true" />'},
						editor       : { type: "multiline", textCase: "upper" },
						styles : {textAlignment: "near"},
						width : 240,
					
					},
					//실적
					{
						name : "PERFORMANCE", fieldName : "PERFORMANCE", editable: false, header : {text: '<spring:message code="lbl.actual" javaScriptEscape="true" />'},
						editor       : { type: "multiline", textCase: "upper" },
						styles : {textAlignment: "near"},
						width : 240,
					
					},
					//비고
					{
						name : "REMARK", fieldName : "REMARK", editable: false, header : {text: '<spring:message code="lbl.remark2" javaScriptEscape="true" />'},
						editor       : { type: "multiline", textCase: "upper" },
						styles : {textAlignment: "near"},
						width : 240,
					
					},
					//파일
					{
						name : "FILE_NM_ORG", fieldName : "FILE_NM_ORG", editable: false, header : {text: '<spring:message code="lbl.file" javaScriptEscape="true" />'},
						styles : {textAlignment : "near"},
						width : 240,
						buttonVisibility:"visible" ,cursor: "pointer",button: "action"
					},
					//공개여부
					{
						name : "OPEN_YN", 
						fieldName : "OPEN_YN",editable: false, header : {text: '<spring:message code="lbl.openStatus" javaScriptEscape="true" />'},
						styles : {textAlignment: "center"},
						width  : 80,
					}
					
				];
				
				
				
				// query에서 받아온 추가적인 field 값을 표현해야 할 경우, this.setFields(columns, ['필드명1','필드명2','필드명3','필드명4','필드명5', .....])	와 같이 추가한다. 			
				this.grdMain.setColumns(columns);  //,'TREE_PATH','SORT','ROOT_SORT','UPPER_MENU_CD','MENU_CD'
				
				this.setFields(columns,['COMPANY_CD','BU_CD','PRT_PJT_NO','CREATE_ID','CREATE_DTTM','FILE_NO']);
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
					//summaryMode: "aggregate",
					checkBar: { visible : true },
					stateBar: { visible : true },
					sorting : { enabled : false},
				});

				this.dataProvider.setOptions({
					softDeleting : true
				});
				
				
				//트리라인제거
		        this.grdMain.setTreeOptions({lineVisible: true});
		        
				/*
				this.grdMain.addCellStyle("style01", {
		            background: "#cc6600",
		            foreground: "#ffffff"
		        });
		        */
				
		        
				this.grdMain.addCellStyle("PJT",{
					background: gv_arrDimColor[0],
				}, true);
						
			
				this.grdMain.addCellStyle("PRC",{
					background: gv_editColor,
				}, true);
						
				
	
				
				
				
				
				/*
				this.grdMain.addCellStyles([{
					id         : "PRC",
					editable   : false,
					background : gv_editColor
				}]);
				*/
				
				/*
				this.grdMain.addCellRenderers([{
					id 		   : "PJT",
					background : gv_arrDimColor[0]
					
				}]);
				
				this.grdMain.addCellRenderers([{
					id 		   : "PRC",
					background : gv_editColor
				
				}]);
				*/
				
			},
			
			gridEvents : function() {
			
				
				//조회시 멀티라인 모두 보여주기 옵션
				
			    this.grdMain.setColumnProperty("PURPOSE", "editor", {type : "multiline"});
			    this.grdMain.setColumnProperty("PURPOSE", "styles", {textWrap : "normal"});
			    
			    this.grdMain.setColumnProperty("GOAL", "editor", {type : "multiline"});
			    this.grdMain.setColumnProperty("GOAL", "styles", {textWrap : "normal"});
			    
			    this.grdMain.setColumnProperty("PROCESS", "editor", {type : "multiline"});
			    this.grdMain.setColumnProperty("PROCESS", "styles", {textWrap : "normal"});
			    
			    this.grdMain.setColumnProperty("PROGRESS", "editor", {type : "multiline"});
			    this.grdMain.setColumnProperty("PROGRESS", "styles", {textWrap : "normal"});
			    
			    this.grdMain.setColumnProperty("PERFORMANCE", "editor", {type : "multiline"});
			    this.grdMain.setColumnProperty("PERFORMANCE", "styles", {textWrap : "normal"});
			    
			    this.grdMain.setColumnProperty("REMARK", "editor", {type : "multiline"});
			    this.grdMain.setColumnProperty("REMARK", "styles", {textWrap : "normal"});
			    
			    
			    
			    
			    this.grdMain.setDisplayOptions({eachRowResizable : true});
				
				
				this.grdMain.onCellButtonClicked = function (grid, itemIndex, column) {
			   		
			   		if (column.name == "FILE_NM_ORG") {
						var rowState = projectMng.projectMngGrid.dataProvider.getRowState(itemIndex);
						if (rowState != "none" && rowState != "updated") {
							alert('<spring:message code="msg.dataSave"/>');
							return;
						}
					}
			   		
			   		
			   		
			   		if (column.name == "FILE_NM_ORG") {
						
			   			var treeGridIndex = itemIndex+1;
						
						var params = {
			       
							COMPANY_CD   : projectMng.projectMngGrid.dataProvider.getValue(treeGridIndex, "COMPANY_CD"),		 // 여기가 문제  <=    getValue를 통해 해당 값을 가져오려면 dataProvider에 모든 데이터가 query 문을 통해 불러져 와 있어야 한다.				
			       			PJT_NO   	 : projectMng.projectMngGrid.dataProvider.getValue(treeGridIndex, "PROJECT_NO"),		       				
			   				BU_CD        : projectMng.projectMngGrid.dataProvider.getValue(treeGridIndex, "BU_CD"),
			       			FILE_NO      : projectMng.projectMngGrid.dataProvider.getValue(treeGridIndex, "FILE_NO"),		       				
			   				AUTHORITY_YN : "N",
			       			_siq         : "snop.meetingMng.projectAdd"+"FileNo", // 페이지는 과정관리페이지지만, 실제 데이터가 저장되는 테이블이 같으므로 동일한 update xml 호출		       				
			       			callback     : "fn_popupCallback",
			       	  
						};
			       		
						gfn_comPopupOpen("FILE",params);
			  
					}
				
			   		
				}//end of onCellButtonClicked
				
			}
			
		},
		
		
		
		
		
		/*
		* event 정의
		*/
		events : function () {
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("#btnProjectAdd").on("click", function(e) {
				fn_openPopup();
			});
			
			$("#chkExpandAll").change("on", function() {
	    		fn_setExpand();
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
					//프로젝트명
					if(id == "divProjectNM"){
						EXCEL_SEARCH_DATA += $("#projectNM").val();
					}
					//프로젝트 NO
					else if(id == "divProjectNO"){
						EXCEL_SEARCH_DATA += $("#projectNO").val();
					}
					//본부명
					else if( id == "divSalesOrgL3Name"){
						$.each($("#salesOrgL3Name option:selected"), function(i2, val2){
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					
					}
					//팀명
					else if( id == "divTeam"){
						$.each($("#team option:selected"), function(i3, val3){
							var txt = gfn_nvl($(this).text(), "");
							
							if(i3 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					
					}
					//프로젝트 분류
					else if( id == "divProjectType"){
						$.each($("#projectType option:selected"), function(i4, val4){
							var txt = gfn_nvl($(this).text(), "");
							
							if(i4 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					
					}
					//진행상태
					else if( id == "divProcessStatus"){
						$.each($("#processStatus option:selected"), function(i5, val5){
							var txt = gfn_nvl($(this).text(), "");
							
							if(i5 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					
					}
					
					
				}
			});
			//일자
		EXCEL_SEARCH_DATA += "\n" + '<spring:message code="lbl.date"/>' + " : ";
		EXCEL_SEARCH_DATA += $("#fromCal").val() + " ~ " + $("#toCal").val();

			
		},
		
		
		
		
		// 조회
		search : function () {
			
			fn_readAuthorityHasOrNot();
			
			FORM_SEARCH.USER_ID = "${sessionScope.userInfo.userId}";
			
			var searchCriteria = "";
			
			//권한담당자(OPEN_YN:Y,N 모두 조회가능): ADMIN, SCM, QC  => 0
			if(SCM_SEARCH.isSCMTeamAdminQC >= 1)
			{
				searchCriteria = 0;
			}
			else
			{
				searchCriteria = 1;
			}
			FORM_SEARCH.searchCriteria = searchCriteria;
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq }];
			
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						
						
						projectMng.projectMngGrid.dataProvider.clearRows(); //데이터 초기화
						
						//그리드 데이터 생성
						projectMng.projectMngGrid.grdMain.cancel();
												
						
						projectMng.projectMngGrid.dataProvider.setRows(data.resList,"TREE_PATH",false);
						projectMng.projectMngGrid.dataProvider.clearSavePoints();
						projectMng.projectMngGrid.dataProvider.savePoint(); //초기화 포인트 저장
						
		
						
						gfn_setSearchRow(projectMng.projectMngGrid.dataProvider.getRowCount());
						projectMng.projectMngGrid.gridInstance.setFocusKeys();
						
						projectMng.projectMngGrid.grdMain.fitRowHeightAll(0, true);
						
						fn_setExpand();			
					}
				}
			}
			
			gfn_service(aOption, "obj");
		}
	
	
	
};

	
	//조회
	var fn_apply = function (sqlFlag) {
		
		FORM_SEARCH = {};
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	
    	FORM_SEARCH.sql = sqlFlag;
   		
    	projectMng.search();
    	//projectMng.excelSubSearch();
   		
	}
			
	
	var fn_popupCallback = function () {
		if (arguments.length > 0 && arguments[0] == "EMP") {
			
			projectMng.projectMngGrid.dataProvider.setValue(arguments[2], "USER_ID", arguments[1][0].USER_NM);
			projectMng.projectMngGrid.dataProvider.setValue(arguments[2], "USER_NM", arguments[1][0].USER_ID);
			//issueMng.issueGrid.dataProvider.setValue(arguments[2], "DEPT_NM", arguments[1][0].DEPT_NM);
		} else {
			fn_apply();
		}
	}
	
	
	
	
	 //달력 설정
    function fn_initDate() {
	
		 	
		 	$("#fromCal").val(fn_getDate_12mBefore());
		 	$("#toCal").val(fn_getDate_12mAfter());
		 	
    		DATEPICKET("#fromCal", null, null);
    		DATEPICKET("#toCal", null, null);
				
    		
			var curDate  = new Date();
	    	var curYear  = curDate.getFullYear();
	    	
			$('#fromCal').datepicker('option','yearRange',(curYear-10) + ':' + (curYear));
			$('#toCal').datepicker('option','yearRange',(curYear) + ':' + (curYear+10));
			
	 }
	
	 
	
    function getDateStr(myDate){
    	return (myDate.getFullYear() + ((myDate.getMonth() + 1)<10?'0':'') + (myDate.getMonth() + 1) + ((myDate.getDate())<10?'0':'') + myDate.getDate())
    }
	
    
    // 현재날짜 기준 12개월 전
    function fn_getDate_12mBefore() {
		
    	var curDate  = new Date();
    	var curYear  = curDate.getFullYear()-1;
    	var curMonth = curDate.getMonth()+1;
    	var curDate  = curDate.getDate();
    	
    	return curYear +"-"+ (curMonth<10?'0':'') + curMonth +"-"+(curDate<10?'0':'') + curDate;
	}

    
    // 현재날짜 기준 12개월 후
    function fn_getDate_12mAfter() {
		var curDate  = new Date();
		var curYear  = curDate.getFullYear()+1;
		var curMonth = curDate.getMonth()+1;
		var curDate  = curDate.getDate();
		
		return curYear +"-"+ (curMonth<10?'0':'') + curMonth +"-"+(curDate<10?'0':'') + curDate;
	}
	 
    
    
    
    //읽기 권한 확인: SCM ROLE 이면 1, 아니면 0
    //읽기 권한 확인: ADMIN ROEL 이면 1, 아니면 0
    //읽기 권한 확인: QC(품질혁신) ROLE 이면 1, 아니면 0
    
    function fn_readAuthorityHasOrNot(){
    	
    	SCM_SEARCH = {}; // 초기화
    	
    	SCM_SEARCH.USER_ID = "${sessionScope.userInfo.userId}" ;
    	
    	SCM_SEARCH.fromCal = $("#fromCal").val();
    	SCM_SEARCH.toCal   = $("#toCal").val(); 
    	
    	SCM_SEARCH._mtd     = "getList";
		SCM_SEARCH.tranData = [
							   { outDs : "isSCMTeamAdminQC",_siq : "snop.meetingMng.isSCMTeamAdminQC"}
							  ];
		
		
		var aOption = {
			async   : false,
			url     : GV_CONTEXT_PATH + "/biz/obj",
			data    : SCM_SEARCH,
			success : function (data) {
			
				if (SCM_SEARCH.sql == 'N') {
					
					SCM_SEARCH.isSCMTeamAdminQC = data.isSCMTeamAdminQC[0].isSCMTeamAdminQC;
				}
			}
		}
		
		gfn_service(aOption, "obj");
    	
    }
	

	
   
	// onload 
	$(document).ready(function() {
		projectMng.init();
	});
	
    
    
  //팝업 오픈
	function fn_openPopup() {
		
			gfn_comPopupOpen("projectMng_projectAdd", {
				rootUrl : "snop/meetingMng",
				url     : "projectAdd",
				width   : 1000,
				height  : 600,
				menuCd : "projectAdd"
			});
		 
	}
    
    
    
    
    
  //팝업 콜백 
  //ProjectAdd 팝업페이지에서 저장처리될 경우 실행
	function fn_popupSaveCallback() {
		fn_apply();
	}
    
	//체크이벤트시 부모/자식노드 체크/해제
    function fn_onItemCheck(grid, itemIndex, checked) {
    	//하위노드까지 체크
    	if (checked) {
	        var recursive = true;
	        var displayOnly = false;
	        projectMng.projectMngGrid.grdMain.checkChildren(itemIndex, checked, recursive, displayOnly);
	        projectMng.projectMngGrid.grdMain.expand(itemIndex, recursive && !displayOnly);
    	
	    //부모노드 해제    
    	} else {
    		var pItem = projectMng.projectMngGrid.grdMain.getParent(itemIndex);
    		projectMng.projectMngGrid.grdMain.checkItem(pItem, checked, false);  
    	}
    }
	
    function fn_setExpand() {
    	
    	if($('#chkExpandAll').is(':checked')) {
    		projectMng.projectMngGrid.grdMain.expandAll(); //전체펼침
    		projectMng.projectMngGrid.grdMain.fitRowHeightAll(0,true);
		} else {
			projectMng.projectMngGrid.grdMain.collapseAll();
		}
    }
	
    

	var fn_popupCallback = function () {
		if (arguments.length > 0 && arguments[0] == "EMP") {
			
			meetingNote.meetingNoteGrid.dataProvider.setValue(arguments[2], "USER_ID", arguments[1][0].USER_NM);
			meetingNote.meetingNoteGrid.dataProvider.setValue(arguments[2], "USER_NM", arguments[1][0].USER_ID);
			//issueMng.issueGrid.dataProvider.setValue(arguments[2], "DEPT_NM", arguments[1][0].DEPT_NM);
		} else {
			fn_apply();
		}
	}
	



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
					<div class="view_combo" id="divProjectNM"> 				<!-- 프로젝트명 -->
						<div class="ilist">
							<div class="itit" ><spring:message code="lbl.pjtNm"/></div>
							<input type="text" id="projectNM" name="projectNM" class="ipt">
						</div>
					</div>
					<div class="view_combo" id="divProjectNO">				<!-- 프로젝트 NO -->
						<div class="ilist">
							<div class="itit" ><spring:message code="lbl.pjtNo"/></div>
							<input type="text" id="projectNO" name="projectNO" class="ipt" >
						</div>
					</div>
					<div class="view_combo" id="divSalesOrgL3Name"></div>	<!-- 본부명 -->
					<div class="view_combo" id="divTeam"></div>          	<!-- 팀명 -->
					<div class="view_combo" id="divProjectType"></div>   	<!-- 프로젝트분류 -->
					<div class="view_combo" id="divProcessStatus"></div> 	<!-- 진행상태 -->
					
					<div id="view_Her">
							<strong class="filter_tit">View Horizon</strong>
							<div class="tlist">
								<div class="tit"><spring:message code="lbl.regDttm"/></div>
								<input type="text" id="fromCal" name="fromCal" class="iptdate datepicker2" > <span class="ihpen">~</span>
								<input type="text" id="toCal" name="toCal" class="iptdate datepicker2" >
							</div>
					</div>
					<div class="view_combo" >
						<div class="ilist">
							<div class="itit" ><spring:message code="lbl.processMngIncYn"/></div>
							<ul class="rdofl" style="min-width:120px;text-align:center;padding:4px 0 0 0;">
								<li><input type="checkbox" id="chkExpandAll" name="chkExpandAll" checked> <label for="chkExpandAll"></label></li>
							</ul>
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
		<div class="cbt_btn"> <!--  roleWrite가 있음으로해서 안보이게 처리할 수 있음 -->
			<div class="bright">
				
				<a id="btnProjectAdd"  href="#" class="app2"><spring:message code="lbl.pjtAdd" /></a>
		
			</div>
		</div>
			
		</div>
    </div>
</body>
</html>
