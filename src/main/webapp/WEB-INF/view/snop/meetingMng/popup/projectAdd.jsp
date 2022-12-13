<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code="lbl.pjtAdd"/></title>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
	<jsp:param name="popupYn" value="Y"/>
</jsp:include>

<script type="text/javascript">
var PROJECT_NO_inVALID_CNT = 0;
var SCM_SEARCH ={};
var BREAKING_LIMIT_SEARCH = {};
var searchData;
var Mem_RegMem_SEARCH = {};   // TB_KPI_PJT_MEM 테이블에 속해있는지, TB_KPI_PJT_REG_MEM 테이블에 속해 있는지? 확인하기위한 객체 
 
var popupWidth, popupHeight;
var codeMap = null, codeMapEx = null;
var gridInstance, grdMain, dataProvider;

var userId = "${sessionScope.userInfo.userId}";

$("document").ready(function (){
	gfn_popresize();
	fn_initData();
	fn_initFilter();
	
	fn_initGrid();
	fn_initEvent();
	fn_apply();
	
});

$(window).resize(function() {
	gfn_popresizeSub();
}).resize();

//데이터 초기화
function fn_initData() {
	
 	
 	$("#fromCal").val(fn_getDate_12mBefore());
 	$("#toCal").val(fn_getDate_12mAfter());
 	
	DATEPICKET("#fromCal", null, null);
	DATEPICKET("#toCal", null, null);
		
	
	var curDate  = new Date();
	var curYear  = curDate.getFullYear();
	
	$('#fromCal').datepicker('option','yearRange',(curYear-10) + ':' + (curYear));
	$('#toCal').datepicker('option','yearRange',(curYear) + ':' + (curYear+10));
	
	//    본부명,     진행상태,           프로젝트 분류,  공개여부              
	//  DIV_CD,   PJT_STATUS_CD,      PJT_TYPE,    OPEN_YN
	var grpCd = "PJT_STATUS_CD,PJT_TYPE,OPEN_YN,DIV_CD";
	
	
	
	// 공통코드 조회 
	codeMap = gfn_getComCode(grpCd, "N");
	codeMapEx =  gfn_getComCodeEx(["TEAM_CD"],null,{});
	

}



//필터 초기화
function fn_initFilter() {
	// 콤보박스
	gfn_setMsCombo("divName", codeMap.DIV_CD, [], {});  //본부명
	gfn_setMsCombo("teamNm", codeMapEx.TEAM_CD , [], {});   //팀명
	gfn_setMsCombo("progressStatus", codeMap.PJT_STATUS_CD, [], {});   //진행상태
	
}

//그리드 초기화
function fn_initGrid() {
	//그리드 설정
	gridInstance = new GRID();
	gridInstance.init("realgrid");
	grdMain      = gridInstance.objGrid;
	dataProvider = gridInstance.objData;
	
	
	fn_setColumns(grdMain);
	fn_setOptions(grdMain,dataProvider);
	//fn_setValidation(grdMain);
	fn_gridEvent(grdMain);
		
   	
}


//dataProvider에 hidden cols 추가하는 함수
function fn_dataProvider_setFields(cols, hiddenCols){
	
	var fields = new Array();
	
	$.each(cols, function(i, v) {
		fields.push({fieldName : v.fieldName});
	});
	
	if (hiddenCols !== undefined && hiddenCols.length > 0) {
		for (hid in hiddenCols) {
			fields.push({fieldName : hiddenCols[hid]});
		}
	}
	
	dataProvider.setFields(fields);
	
}


//그리드컬럼
function fn_setColumns(grd) {
	var columns = [
		{
			
			//프로젝트 분류
			name         : "PJT_TYPE",
			fieldName    : "PJT_TYPE",
			editable     : true,
			header       : { text: '<spring:message code="lbl.pjtType"/>' },
			styles       : { textAlignment: "center"},
			dynamicStyles : [{ criteria: ["state<>'c'","state='c'"], styles: ["background="+gv_noneEditColor,"background="+gv_requiredColor] }],
			width  : 100,
			editor : { type: "dropDown", domainOnly : true, textReadOnly: true}, 
			values : gfn_getArrayExceptInDs(codeMap.PJT_TYPE, "CODE_CD", ""),
			labels : gfn_getArrayExceptInDs(codeMap.PJT_TYPE, "CODE_NM", ""),
			lookupDisplay : true,
			nanText : "",
			editButtonVisibility : "visible",
		},
		{
			
			//프로젝트 NO
			name         : "PROJECT_NO",
			fieldName    : "PROJECT_NO",
			editable     : false,
			header       : { text: '<spring:message code="lbl.pjtNo"/>' },
			//styles       : { textAlignment: "center", background :gv_noneEditColor },
			width        : 100,
			dynamicStyles: function(grid, index, value){
			    var rowState = dataProvider.getRowState(index.itemIndex); 
			    
			    if(grid.getValue(index.itemIndex,"PJT_TYPE_ID")=="PROH" && rowState=="created" )
                {
			    	return{
			    		background:gv_requiredColor,
		                editable: true  //편집가능
			    	}
                }
			    else
			    {
			    	if(rowState=="created")
			    	{
			    		grid.setValue(index.itemIndex,"PROJECT_NO","");	
			    	}
			    	return{
			    		background:gv_noneEditColor,
		                editable: false  //편집불가
			    	}
			    }
			},
			editor:{
				type:"text",
				mask:{
					editMask: "P0000-C-00",
					allowEmpty:false,
					restrictNull:true,
					definitions: {"P":"P","C":"A|P"},
					includedFormat:true
				}
				
			}
		},
		{
			//본부명
			name         : "DIV_CD",
			fieldName    : "DIV_CD",
			editable     : false,
			header       : { text: '<spring:message code="lbl.salesOrgL3Name"/>' },
			styles       : { textAlignment: "center", background :gv_noneEditColor },
			width  : 100,
			
		},
		{
			//팀명
			name         : "TEAM_CD",
			fieldName    : "TEAM_CD",
			editable     : true,
			header       : { text: '<spring:message code="lbl.teamName"/>' },
			styles       : { textAlignment: "center"},
			dynamicStyles : [{ criteria: ["state<>'c'","state='c'"], styles: ["background="+gv_arrDimColor[0],"background="+gv_requiredColor] }],
			width  : 100,
			editor : { type: "dropDown", domainOnly : true, textReadOnly: true}, 
			values : fn_reGenTeamCd(codeMapEx.TEAM_CD,"BU_CD","CODE_CD"),
			labels : gfn_getArrayExceptInDs(codeMapEx.TEAM_CD, "CODE_NM", ""),
			lookupDisplay : true,
			nanText : "",
			editButtonVisibility : "visible"
		},
		{
			//프로젝트 Manger
			name         : "PJT_MNGER",
			fieldName    : "PJT_MNGER",
			editable     : false,
			header       : { text: '<spring:message code="lbl.pjtMnger"/>' },
			styles       : { textAlignment: "center"},
			dynamicStyles : [{ criteria: ["state<>'c'","state='c'"], styles: ["background="+gv_arrDimColor[0],"background="+gv_requiredColor] }],
			width        : 100,
			buttonVisibility:"visible" ,cursor: "pointer",button: "action"
		},
		{
			//프로젝트 참가자, 여러명(N)
			name         : "PJT_MEM",
			fieldName    : "PJT_MEM",
			editable     : false,
			header       : { text: '<spring:message code="lbl.pjtMem"/>' },
			styles       : { textAlignment: "center"},
			dynamicStyles : [{ criteria: ["state<>'c'","state='c'"], styles: ["background="+gv_arrDimColor[0],"background="+gv_requiredColor] }],
			width        : 170,
			buttonVisibility:"visible" ,cursor: "pointer",button: "action"
		},
		{  
			//등록권한 담당자, 여려명(N)
			//REGISTER_MNGER
			//REGISTER_MNGER
			name         : "REGISTER_MNGER",
			fieldName    : "REGISTER_MNGER",
			editable     : false,
			header       : { text: '<spring:message code="lbl.regAuthMnger"/>' },
			styles       : { textAlignment: "center"},
			dynamicStyles : [{ criteria: ["state<>'c'","state='c'"], styles: ["background="+gv_arrDimColor[0],"background="+gv_requiredColor] }],
			width        : 170,
			buttonVisibility:"visible" ,cursor: "pointer",button: "action"
		},
		{
			//프로젝트명
			name         : "PJT_NM",
			fieldName    : "PJT_NM",
			editable     : true,
			header       : { text: '<spring:message code="lbl.pjtNm"/>' },
			styles       : { textAlignment: "center"},
			dynamicStyles : [{ criteria: ["state<>'c'","state='c'"], styles: ["background="+gv_arrDimColor[0],"background="+gv_requiredColor] }],
			width        : 200,
		},
		{
			//등록일
			name         : "REG_DATE",
			fieldName    : "REG_DATE",
			editable     : true,
			header       : { text: '<spring:message code="lbl.regDttm"/>' },
			styles       : { textAlignment: "center"},
			dynamicStyles : [{ criteria: ["state<>'c'","state='c'"], styles: ["background="+gv_arrDimColor[0],"background="+gv_requiredColor] }],
			editor : {type : "date", datetimeFormat : "yyyy-MM-dd"},
			width        : 100
		},
		{
			//시작일
			name         : "START_DATE",
			fieldName    : "START_DATE",
			editable     : true,
			header       : { text: '<spring:message code="lbl.startDate"/>' },
			styles       : { textAlignment: "center"},
			dynamicStyles : [{ criteria: ["state<>'c'","state='c'"], styles: ["background="+gv_arrDimColor[0],"background="+gv_requiredColor] }],
			editor 		 : {type : "date", datetimeFormat : "yyyy-MM-dd"},
			width        : 100		
		},
		{
			//완료예상일
			name         : "CLOSE_DATE",
			fieldName    : "CLOSE_DATE",
			editable     : true,
			header       : { text: '<spring:message code="lbl.exptCompDay"/>' },
			styles       : { textAlignment: "center"},
			dynamicStyles : [{ criteria: ["state<>'c'","state='c'"], styles: ["background="+gv_arrDimColor[0],"background="+gv_requiredColor] }],
			editor 		 : {type : "date", datetimeFormat : "yyyy-MM-dd"},
			width        : 100
		},
		{
			//진행상태
			name         : "PJT_STATUS_CD",
			fieldName    : "PJT_STATUS_CD",
			editable : true, header : {text: '<spring:message code="lbl.progressStatus" javaScriptEscape="true" />'},
			styles : {textAlignment: "center"},
			dynamicStyles : [{ criteria: ["state<>'c'","state='c'"], styles: ["background="+gv_arrDimColor[8],"background="+gv_requiredColor] }],
			width  : 100,
			editor : { type: "dropDown", domainOnly : true, textReadOnly: true}, 
			values : gfn_getArrayExceptInDs(codeMap.PJT_STATUS_CD, "CODE_CD", ""),
			labels : gfn_getArrayExceptInDs(codeMap.PJT_STATUS_CD, "CODE_NM", ""),
			lookupDisplay : true,
			nanText : "",
			editButtonVisibility : "visible"
		},
		{
			//과정관리 등록
			name         : "PROCESS_MNG_REG",
			fieldName    : "PROCESS_MNG_REG",
			editable     : false,
			header       : { text: '<spring:message code="lbl.processMngReg"/>' },
			styles: {textAlignment: "center",background : gv_headerColor },
            width: 130,
            cursor: "pointer"
		},
		{
			//파일
			name         : "FILE_NM_ORG",
			fieldName    : "FILE_NM_ORG",
			editable     : false,
			header       : { text: '<spring:message code="lbl.file"/>' },
			styles       : { textAlignment: "near", background:gv_arrDimColor[0]},
			width        : 100,
			width : 250,
			buttonVisibility:"visible" ,cursor: "pointer",button: "action"
		},
		{
			//목적
			name         : "PURPOSE",
			fieldName    : "PURPOSE",
			editable     : true,
			header       : { text: '<spring:message code="lbl.purpose"/>' },
			editor       : { type: "multiline", textCase: "upper" },
			styles : {textAlignment: "near", textWrap: 'explicit'},
			dynamicStyles : [{ criteria: ["state<>'c'","state='c'"], styles: ["background="+gv_arrDimColor[0],"background="+gv_requiredColor] }],
			width : 250
		},
		{
			//목표
			name         : "GOAL",
			fieldName    : "GOAL",
			editable     : true,
			header       : { text: '<spring:message code="lbl.goal"/>' },
			editor       : { type: "multiline", textCase: "upper" },
			styles : {textAlignment: "near", textWrap: 'explicit'},
			dynamicStyles : [{ criteria: ["state<>'c'","state='c'"], styles: ["background="+gv_arrDimColor[0],"background="+gv_requiredColor] }],
			width : 250
		},
		{
			//업무 진행 내역
			name         : "PROGRESS",
			fieldName    : "PROGRESS",
			editable     : true,
			header       : { text: '<spring:message code="lbl.businProgress"/>' },
			editor       : { type: "multiline", textCase: "upper" },
			styles : {textAlignment: "near", textWrap: 'explicit', background :gv_arrDimColor[0]},
			width : 250
		},
		{
			//실적
			name         : "PERFORMANCE",
			fieldName    : "PERFORMANCE",
			editable     : true,
			header       : { text: '<spring:message code="lbl.actual"/>' },
			editor       : { type: "multiline", textCase: "upper" },
			styles : {textAlignment: "near", textWrap: 'explicit', background :gv_arrDimColor[0]},
			width : 250
		},
		{
			//비고
			name         : "REMARK",
			fieldName    : "REMARK",
			editable     : true,
			header       : { text: '<spring:message code="lbl.remark2"/>' },
			editor       : { type: "multiline", textCase: "upper" },
			styles : {textAlignment: "near", textWrap: 'explicit', background :gv_arrDimColor[0]},
			width : 250
		},
		{
			//공개여부
			name         : "OPEN_YN",
			fieldName    : "OPEN_YN",
			editable : true, header : {text: '<spring:message code="lbl.openStatus" javaScriptEscape="true" />'},
			styles : {textAlignment: "center"},
			dynamicStyles : [{ criteria: ["state<>'c'","state='c'"], styles: ["background="+gv_arrDimColor[9],"background="+gv_requiredColor] }],
			width  : 100,
			editor : { type: "dropDown", domainOnly : true, textReadOnly: true}, 
			values : gfn_getArrayExceptInDs(codeMap.OPEN_YN, "CODE_CD", ""),
			labels : gfn_getArrayExceptInDs(codeMap.OPEN_YN, "CODE_NM", ""),
			lookupDisplay : true,
			nanText : "",
			editButtonVisibility : "visible"
		}
	];
	
	fn_dataProvider_setFields(columns,['COMPANY_CD','BU_CD','BU_CD_ID','PJT_CATE','PRT_PJT_NO','CREATE_ID','UPDATE_ID','FILE_NO','PJT_TYPE_ID','PJT_TYPE_ID_TEMP','TEAM_CD_ID','TEAM_CD_ID_TEMP','PJT_MNGER_ID','PJT_MNGER_ID_TEMP', 'PJT_MEM_ID','PJT_MEM_ID_TEMP','PJT_MEM_ID_COMM','REGISTER_MNGER_ID','REGISTER_MNGER_ID_TEMP','REGISTER_MNGER_ID_COMM','PJT_STATUS_CD_ID','PJT_STATUS_CD_ID_TEMP','OPEN_YN_ID','PJT_STATUS_CD_ID','DIV_CD_ID_TEMP']);
	grdMain.setColumns(columns);
}

//그리드 옵션
function fn_setOptions(grdMain,dataProvider) {
	grdMain.setOptions({

		checkBar: { visible : true },
		stateBar: { visible : true },
		sorting : { enabled : false}
	
	});
	
	dataProvider.setOptions({
		
		softDeleting : true
	});
	
	grdMain.addCellStyles([{
		
		id         : "CLOSE",
		editable   : false,
	}]);
	
	grdMain.addCellStyles([{
		
		id         : "OPEN",
		editable   : true,
		background : gv_editColor
	}]);
	
	
}

//이벤트 초기화
function fn_initEvent() {
	
	//버튼 이벤트
	
	$("#btnSearch").click("on", function(){  fn_apply()	});
	
	$("#btnReset").click("on", function(){ fn_reset()	});
	
	$("#btnAdd").click("on", function(){  fn_add()});
	
	$("#btnDelete").click("on", function(){	fn_del()	});
	
	$("#btnSave").click("on", function(){ fn_save()	});
	

}




//조회
function fn_apply(sqlFlag) {
	
	//조회조건 설정
	FORM_SEARCH = $("#searchForm").serializeObject();
	
	//그리드 데이터 조회
	fn_getGridData(sqlFlag);
}

//그리드 데이터 조회
function fn_getGridData(sqlFlag) {
	
	fn_popUpAuthorityHasOrNot();
	
	FORM_SEARCH.USER_ID = "${sessionScope.userInfo.userId}";


	var searchCriteria = "";
	
	//권한담당자(OPEN_YN:Y,N 모두 조회가능): ADMIN, SCM, QC  => 0
	if(SCM_SEARCH.isSCMTeamAdminQC>=1)
	{
		searchCriteria = 0;
	}
	else
	{
		searchCriteria = 1;
	}
	
	
	
	FORM_SEARCH.searchCriteria = searchCriteria;
	FORM_SEARCH.sql	     = sqlFlag;
	FORM_SEARCH._mtd     = "getList";
	FORM_SEARCH.tranData = [{outDs:"rtnList",_siq:"snop.meetingMng.projectAdd"}];
	
	gfn_service({
		url    : GV_CONTEXT_PATH + "/biz/obj",
		data   : FORM_SEARCH,
		success: function(data) {
			//그리드 데이터 삭제
			dataProvider.clearRows();
			grdMain.cancel();
			//그리드 데이터 생성
			dataProvider.setRows(data.rtnList);
			//그리드 초기화 포인트 저장
			dataProvider.clearSavePoints();
			dataProvider.savePoint();
			
			searchData = data.rtnList;
			
			gfn_setSearchRow(dataProvider.getRowCount());
			
			grdMain.fitRowHeightAll(0, true);
			gridCallback(data.rtnList);
		}
	}, "obj");
}


//그리드 초기화
function fn_reset() {
	
	fn_apply();
	
}


/*
	
	PROCESS_MNG_REG 컬럼을 제외하고 더블클릭 이벤트 불필요
	
	
	(PJT_TYPE, PROJECT_NO, DIV_CD, TEAM_CD, PJT_MNGER, PJT_MEM, REGISTER_MNGER, PJT_NM, REG_DATE, START_DATE, CLOSE_DATE, PJT_STATUS_CD, 
	
	FILE_NM_ORG, PURPOSE, GOAL, PROGRESS, PERFORMANCE, REMARK, OPEN_YN)
	
	
	*/


//그리드 저장
async function fn_save() {
	
	PROJECT_NO_inVALID_CNT = 0;
    
	//사용자가 입력한 PROJECT_NO 간의 중복검사를 위함
	var arrPROJECT_NO = [];
	
	//수정된 그리드 데이터
	var grdData = gfn_getGrdSavedataAll(grdMain);
	
	if (grdData.length == 0) {
        alert('<spring:message code="msg.noChangeData"/>');
        return;
    }
	
	//필수 입력 체크
    var arrColumn = ["PJT_TYPE","DIV_CD","TEAM_CD","PJT_MNGER","PJT_MEM","REGISTER_MNGER","PJT_NM","REG_DATE","START_DATE","CLOSE_DATE","PJT_STATUS_CD","PURPOSE","GOAL","OPEN_YN"];
    
    if (!gfn_getValidation(gridInstance, arrColumn)) {
        return;
    }
	
	
	for(i=0; i<grdData.length; i++ )
	{
	    grdData[i].UPDATE_ID = userId;
        grdData[i].CREATE_ID = userId;
	
		
		//한계돌파 PROJECT_NO VALID CHECK 
		//BREAKING_LIMIT_SEARCH.PROJECT_NO_VALID
		//새롭게 추가한 row가 아니라, 기존의 row를 수정할 경우에는 예외처리해야함
		if(grdData[i].PJT_TYPE_ID === "PROH"&&grdData[i].state=="inserted")
		{
			//사용자가입력한 PROJECT_NO간의 중복검사
            arrPROJECT_NO.push(grdData[i].PROJECT_NO);
            
						
            grdData[i].PROJECT_NO_EXIST_CNT = await fn_PROJECT_NO_VALIDATION(grdData[i].PROJECT_NO, function(){
                return BREAKING_LIMIT_SEARCH.PROJECT_NO_EXIST_CNT
            });
            
            if(grdData[i].PROJECT_NO_EXIST_CNT>=1)
            {
                PROJECT_NO_inVALID_CNT++;
            }
			
		}
		
		
	}
	
	
	
	 for(i=0;i<grdData.length;i++)
	 {
	        
	        if(grdData[i].PJT_TYPE === "PROH" && grdData[i].state=="inserted")
	        {
	            
	            //한계돌파 과정관리 PROJECT_NO 공백여부검사
	            if(grdData[i].PROJECT_NO == "" ||grdData[i].PROJECT_NO == null)
	            {
	                alert("한계돌파  프로젝트 No 미입력");
	                grdMain.setCurrent({itemIndex: (i-1), column : "PROJECT_NO"});
	                return;
	            }
	            
	            
	            if(isDuplicate(arrPROJECT_NO))
	            {
	                alert("중복된 한계돌파 과정관리 프로젝트 No를 입력하였습니다. 고유한 값으로 입력해 주세요. ");
	                grdMain.setCurrent({itemIndex: (i-1), column : "PROJECT_NO"});
	                return;
	            }
	            
	            if(grdData[i].PROJECT_NO_EXIST_CNT>=1)
	            {
	                alert("입력한 한계돌파 과정관리 프로젝트 No가 존재합니다. 고유한 값으로 입력해 주세요.");
	                grdMain.setCurrent({itemIndex: (i-1), column : "PROJECT_NO"});
	                return;
	            }
	            
	            if(grdData[i].START_DATE > grdData[i].CLOSE_DATE )
	            {
	                alert('<spring:message code="msg.closeDateValid"/>');
	                return;
	            }
	        }
	        
	}
	
	

      if(PROJECT_NO_inVALID_CNT >= 1)
      {

          alert( '중복된 PROJECT_NO가 존재합니다.');
          return;
      }
      else
      {  
          confirm('<spring:message code="msg.saveCfm"/>', function() {
                 
                 fn_projectRegMem_projectMem_reGen(grdData).then(
                
                      function(){
                		    
                	      fn_pjtMemList_pjtRegMemList_UorI(grdData);
                	  }  
                 		 
                 );
                 
                 
                 FORM_SAVE          = {}; //초기화
                 FORM_SAVE._mtd     = "saveAll";
                 FORM_SAVE.tranData = [{outDs:"saveCnt",_siq:"snop.meetingMng.projectAdd",grdData:grdData}];
                   
                 
                    gfn_service({
                         url    : GV_CONTEXT_PATH + "/biz/obj",
                         data   : FORM_SAVE,
                         success: function(data) {
                             
                             
                             if(data.errCode == -10){
                                 alert(gfn_getDomainMsg("msg.dupData", data.errLine));
                                 grdMain.setCurrent({dataRow : data.errLine - 1, column : "PROJECT_NO"});
                             }
                             else{
                                 alert('<spring:message code="msg.saveOk"/>');
                                 fn_apply();
                                 if (opener && opener.fn_popupCallback) {
                                     opener.fn_popupCallback();
                                 }
                             }
                             
                             
                             
                         }
                     }, "obj");
                 
             })
      }
            
   
}


function fn_gridEvent(grdMain){
	
	
	grdMain.setColumnProperty("PURPOSE", "editor", {type : "multiline"});
   	grdMain.setColumnProperty("PURPOSE", "styles", {textWrap : "normal"});
   	
   	grdMain.setColumnProperty("GOAL", "editor", {type : "multiline"});
   	grdMain.setColumnProperty("GOAL", "styles", {textWrap : "normal"});
   	
   	grdMain.setColumnProperty("PROGRESS", "editor", {type : "multiline"});
   	grdMain.setColumnProperty("PROGRESS", "styles", {textWrap : "normal"});
   	
   	grdMain.setColumnProperty("PERFORMANCE", "editor", {type : "multiline"});
   	grdMain.setColumnProperty("PERFORMANCE", "styles", {textWrap : "normal"});
   	
   	grdMain.setColumnProperty("REMARK", "editor", {type : "multiline"});
   	grdMain.setColumnProperty("REMARK", "styles", {textWrap : "normal"});
   	
   	
   	
   	
   	grdMain.setDisplayOptions({eachRowResizable : true});
	
	
   	//셀 더블클릭
   	grdMain.onDataCellDblClicked = function (grid, index) {
   	
   	//예외처리 필요	
   
   	/*
   	
   	PROCESS_MNG_REG 컬럼을 제외하고 더블클릭 이벤트 불필요
   	
   	
   	(PJT_TYPE, PROJECT_NO, DIV_CD, TEAM_CD, PJT_MNGER, PJT_MEM, REGISTER_MNGER, PJT_NM, REG_DATE, START_DATE, CLOSE_DATE, PJT_STATUS_CD, 
   	
   	FILE_NM_ORG, PURPOSE, GOAL, PROGRESS, PERFORMANCE, REMARK, OPEN_YN)
   	
   	
   	*/
   	
   	var rowId = index.dataRow;
	var field = index.fieldName;
	var cState = dataProvider.getRowState(rowId);
	
   	
   	if (field == "PJT_TYPE"||field =="PROJECT_NO"||field =="DIV_CD"||field =="TEAM_CD"||field =="PJT_MNGER"
   			||field =="PJT_MEM"||field =="REGISTER_MNGER"||field =="PJT_NM"||field =="REG_DATE"||field =="START_DATE"
   			||field =="CLOSE_DATE"||field =="PJT_STATUS_CD"||field =="FILE_NM_ORG"||field =="PURPOSE"
   			||field =="GOAL"||field =="PROGRESS"||field =="PERFORMANCE"||field =="REMARK"||field =="OPEN_YN") 
   	{
   		// 위 칼럼들을 더블클릭시 아무 이벤트 없음
   	}
   	//PROCESS_MNG_REG 컬럼일 경우만 더블클릭이벤트 실행
   	else{
   		
   		if (field =="PROCESS_MNG_REG") {
   			if (cState != "none" && cState != "updated") {
				alert('<spring:message code="msg.dataSave"/>');
				return false;
			}
		}
   		
   	 	//프로젝트 등록화면에서 EMP, 프로젝트 참가자, 등로권한 참가자 더블 클릭해도 실행됨
	   	
   		// 팝업 권한: 등록권한 담당자, SCM, 품질혁신 팀만 활성화(ADMIN 포함)
	
   	var userId = "${sessionScope.userInfo.userId}";
   	
   	fn_popUpAuthorityHasOrNot();
   	var isSCMTeamAdminQC = SCM_SEARCH.isSCMTeamAdminQC;
   	
   
   	var isRegiAuthorMnger = fn_regiAuthorMngerIsOrNot(dataProvider.getValue(rowId,"REGISTER_MNGER_ID_TEMP"),userId);
   	
   	
   	var OPEN_CLOSE = dataProvider.getValue(rowId,"PJT_STATUS_CD_ID_TEMP");
   
   	//진행상태가 CLOSE가 아니여야 과정관리 등록 버튼 활성화
		if(OPEN_CLOSE!="CL")
		{
		   	if(isSCMTeamAdminQC>=1||isRegiAuthorMnger)
		   	{
		   		
		   			if (field == "PROCESS_MNG_REG" && (cState == "updated" || cState == "none")) {
		   				
		   				
		   				var params = {
			   				rootUrl : "snop/meetingMng",
			   				url : "processAdd",
			   				width : 1000,
			   				height : 500,
			   				
			   				COMPANY_CD:dataProvider.getValue(rowId, "COMPANY_CD"),
			   				
			   			
			   				BU_CD:dataProvider.getValue(rowId, "BU_CD"),
			   				
			   			
			   				PROJECT_NO:dataProvider.getValue(rowId, "PROJECT_NO"),
			   				
			   			
			   				REGISTER_MNGER:dataProvider.getValue(rowId, "REGISTER_MNGER"),
			   				
			   			
			   				PJT_NM:dataProvider.getValue(rowId, "PJT_NM"),
			   				
			   			
			   				PJT_TYPE:dataProvider.getValue(rowId, "PJT_TYPE_ID_TEMP"),
			   				
			   			
			   				PRT_PJT_NO:dataProvider.getValue(rowId, "PRT_PJT_NO"),
			   				
			   			
			   				OPEN_YN:dataProvider.getValue(rowId, "OPEN_YN_ID"),
			   				
			   			
			   				START_DATE:dataProvider.getValue(rowId,"START_DATE"),
			   				
			   			
			   				CLOSE_DATE:dataProvider.getValue(rowId,"CLOSE_DATE"),
			   				
			   			
			   				PJT_MNGER:dataProvider.getValue(rowId,"PJT_MNGER_ID_TEMP"),
			   			
			   			
			   				DIV_CD: dataProvider.getValue(rowId,"DIV_CD_ID_TEMP"),
			   				
			   			
			   				TEAM_CD: dataProvider.getValue(rowId,"TEAM_CD_ID_TEMP"),
			   				
			   			
			   				PJT_STATUS_CD: dataProvider.getValue(rowId,"PJT_STATUS_CD_ID_TEMP") 
			   				
			   			
			   			}
			   			
			   			gfn_comPopupOpen("projectMng_projectAdd_processAdd",params);
			   		}
		   	}
		}
   		
   	}	
   		
   		
	  
   	
   	};
   	
   	grdMain.onCellButtonClicked = function (grid, itemIndex, column) {
   		
   		var State = dataProvider.getRowState(itemIndex); //state 값   created: 생성, updated:수정, deleted:생성 후 삭제
   
   		
   		fn_popUpAuthorityHasOrNot();
   	   	var isSCMTeamAdminQC = SCM_SEARCH.isSCMTeamAdminQC;
   		var OPEN_CLOSE = dataProvider.getValue(itemIndex,"PJT_STATUS_CD_ID_TEMP");
   		var USER_ID = "${sessionScope.userInfo.userId}";
   		
   		if(OPEN_CLOSE!="CL")
		{
   		
   		if (column.name == "FILE_NM_ORG"||column.name =="PROCESS_MNG_REG") {
			var rowState = dataProvider.getRowState(itemIndex);
			if (rowState != "none" && rowState != "updated") {
				alert('<spring:message code="msg.dataSave"/>');
				return;
			}
		}
   		
   		
   		
   		if (column.name == "FILE_NM_ORG") {
			
   			if(isSCMTeamAdminQC>=1||dataProvider.getValue(itemIndex,"PJT_MNGER_ID_TEMP").indexOf(USER_ID)!=-1||dataProvider.getValue(itemIndex,"REGISTER_MNGER_ID_TEMP").indexOf(USER_ID)!=-1)
			{	
				var params = {
	       			COMPANY_CD   : grid.getValue(itemIndex, "COMPANY_CD"),		 // 여기가 문제  <=    getValue를 통해 해당 값을 가져오려면 dataProvider에 모든 데이터가 query 문을 통해 불러져 와 있어야 한다.				
	       			PJT_NO   	 : grid.getValue(itemIndex, "PROJECT_NO"),		       				
       				BU_CD        : grid.getValue(itemIndex, "BU_CD"),
	       			FILE_NO      : grid.getValue(itemIndex, "FILE_NO"),		       				
       				_siq         : "snop.meetingMng.projectAdd"+"FileNo",		       				
	       			callback     : "fn_popupCallback",
	       		};
	       
	       		gfn_comPopupOpen("FILE",params);
			}
   			else
   			{
   				
   				//scm팀, 품질혁신팀, 프로젝트 매니저, 등록권한 담당자가 아닐 경우 내려받기만 가능	
   				var params = {
   		       			COMPANY_CD   : grid.getValue(itemIndex, "COMPANY_CD"),		 // 여기가 문제  <=    getValue를 통해 해당 값을 가져오려면 dataProvider에 모든 데이터가 query 문을 통해 불러져 와 있어야 한다.				
   		       			PJT_NO   	 : grid.getValue(itemIndex, "PROJECT_NO"),		       				
   	       				BU_CD        : grid.getValue(itemIndex, "BU_CD"),
   		       			FILE_NO      : grid.getValue(itemIndex, "FILE_NO"),		       				
   		       			AUTHORITY_YN : "N",	
   		       			_siq         : "snop.meetingMng.projectAdd"+"FileNo",		       				
   		       			callback     : "fn_popupCallback",
   		       		};
   		       
   		       		gfn_comPopupOpen("FILE",params);
   				
   			}
		}
   		//프로젝트 Manager
   		else if (column.name == "PJT_MNGER") {
   			
   			//프로젝트 Manager팝업을 클릭하는 순간, 새로추가된 열인지, 기존작성된 글의 팝업인지 검사하는 logic 필요
   			
   			
   			if(State=='created')
   			{
   				//새로 추가된 row의 프로젝트 Manager팝업 클릭 
   				var params = {
						searchCode : grid.getValue(itemIndex, "PJT_MNGER_ID"),		       				
						searchName : grid.getValue(itemIndex, "PJT_MNGER_ID"),		       				
	       				callback   : "fn_popupCallback_PJT_MNGER",
	       				singleYn   : "Y",
	       				rowId      : itemIndex,
	       			};
	       			gfn_comPopupOpen("EMP",params);
   			}
   			else
   			{
   				//기존작성되어진 row의 프로젝트 Manager팝업 클릭 
				if(isSCMTeamAdminQC>=1||dataProvider.getValue(itemIndex,"PJT_MNGER_ID_TEMP").indexOf(USER_ID)!=-1||dataProvider.getValue(itemIndex,"REGISTER_MNGER_ID_TEMP").indexOf(USER_ID)!=-1)
				{
					var params = {
						searchCode : grid.getValue(itemIndex, "PJT_MNGER_ID"),		       				
						searchName : grid.getValue(itemIndex, "PJT_MNGER_ID"),		       				
	       				callback   : "fn_popupCallback_PJT_MNGER",
	       				singleYn   : "Y",
	       				rowId      : itemIndex,
	       			};
	       			gfn_comPopupOpen("EMP",params);
				}
   			
   			}
   				
   				
   				
   			
   				
   			
		} 
   		//프로젝트 참가자
		else if (column.name == "PJT_MEM") {
			if(State=='created')
   			{
			
				var params = {
						searchCode : grid.getValue(itemIndex, "PJT_MEM_ID"),		       				
						searchName : grid.getValue(itemIndex, "PJT_MEM_ID"),		       				
		   				callback   : "fn_popupCallback_PJT_MEM",
		   				singleYn   : "N",
		   				//rootUrl  : "snop/meetingMng",
		   				//url	   : projectMemAddPopup
		   				popuptitle : "ProjectMemAdd",
		   				rowId      : itemIndex,
		   			};
		   			gfn_comPopupOpen("PJT_MEM",params);
   			}
			else
			{
				if(isSCMTeamAdminQC>=1||dataProvider.getValue(itemIndex,"PJT_MNGER_ID_TEMP").indexOf(USER_ID)!=-1||dataProvider.getValue(itemIndex,"REGISTER_MNGER_ID_TEMP").indexOf(USER_ID)!=-1)
				{
				var params = {
					searchCode : grid.getValue(itemIndex, "PJT_MEM_ID_COMM"),		       				
					searchName : grid.getValue(itemIndex, "PJT_MEM_ID_COMM"),		       				
	   				callback   : "fn_popupCallback_PJT_MEM",
	   				singleYn   : "N",
	   				//rootUrl  : "snop/meetingMng",
	   				//url	   : projectMemAddPopup
	   				popuptitle : "ProjectMemAdd",
	   				rowId      : itemIndex,
	   			};
	   			gfn_comPopupOpen("PJT_MEM",params);
				}
				
			}
			
			
			
		}
   		//등록권한 담당자
		else if (column.name == "REGISTER_MNGER") {
			
			if(State=='created')
   			{
				var params = {
						searchCode : grid.getValue(itemIndex, "REGISTER_MNGER_ID"),		       				
						searchName : grid.getValue(itemIndex, "REGISTER_MNGER_ID"),		       				
		   				callback   : "fn_popupCallback_REGISTER_MNGER",
		   				singleYn   : "N",
		   				//rootUrl  : "snop/meetingMng",
		   				//url	   :projectRegMemAddPopup
		   				popuptitle : "ProjectRegMemAdd",
		   				rowId      : itemIndex,
		   			};
		   			gfn_comPopupOpen("PJT_REG_MEM",params);
				
   			}
			else
			{
				if(isSCMTeamAdminQC>=1||dataProvider.getValue(itemIndex,"PJT_MNGER_ID_TEMP").indexOf(USER_ID)!=-1||dataProvider.getValue(itemIndex,"REGISTER_MNGER_ID_TEMP").indexOf(USER_ID)!=-1)
				{
				var params = {
					searchCode : grid.getValue(itemIndex, "REGISTER_MNGER_ID_COMM"),		       				
					searchName : grid.getValue(itemIndex, "REGISTER_MNGER_ID_COMM"),		       				
	   				callback   : "fn_popupCallback_REGISTER_MNGER",
	   				singleYn   : "N",
	   				//rootUrl  : "snop/meetingMng",
	   				//url	   :projectRegMemAddPopup
	   				popuptitle : "ProjectRegMemAdd",
	   				rowId      : itemIndex,
	   			};
	   			gfn_comPopupOpen("PJT_REG_MEM",params);
				}
				
			}
			
			
		}	
   		
		}//end of open_yn 유무 if 조건
   	}   // END OF onCellButtonClicked
   	
   	
   	/*
   	
   	PROCESS_MNG_REG 컬럼을 제외하고 더블클릭 이벤트 불필요

   	(PJT_TYPE, PROJECT_NO, DIV_CD, TEAM_CD, PJT_MNGER, PJT_MEM, REGISTER_MNGER, PJT_NM, REG_DATE, START_DATE, CLOSE_DATE, PJT_STATUS_CD, 
   	
   	FILE_NM_ORG, PURPOSE, GOAL, PROGRESS, PERFORMANCE, REMARK, OPEN_YN)
   	   	
   	*/
   		grdMain.onCellEdited = function (grid, itemIndex, dataRow, field) {
       		
   			var rowState = dataProvider.getRowState(itemIndex);	
   		
    		//PJT_TYPE
       	    var PJT_TYPE_column = grdMain.columnByField("PJT_TYPE");
       	    var PJT_TYPE_values = PJT_TYPE_column.values;
			
       	    
       	    //TEAM_CD
       	    var TEAM_CD_column = grdMain.columnByField("TEAM_CD");
       	    var TEAM_CD_values = TEAM_CD_column.values;
       	           	    
       	    //PJT_STATUS_CD
       	    var PJT_STATUS_CD_column = grdMain.columnByField("PJT_STATUS_CD");
       	    var PJT_STATUS_CD_values = PJT_STATUS_CD_column.values;
       	    
       	    //OPEN_YN
       	    var OPEN_YN_column = grdMain.columnByField("OPEN_YN");
       	    var OPEN_YN_values = OPEN_YN_column.values;
       	    
       	    //PJT_TYPE
       	    for(var k in PJT_TYPE_values){
       	        if(PJT_TYPE_values[k] == grdMain.getValue(itemIndex, field)) {
       	        	
       	        	dataProvider.setValue(itemIndex, "PJT_TYPE_ID", PJT_TYPE_values[k]);   
       	        }
       	        
       	    }
       	       
       	        		
       	     	    
       		//TEAM_CD
       		//TEAM_CD는 동일한 팀코드가 존재할 수 있다. 따라서, 세라믹/세정, 램프를 선택할 때는 부서까지 구분해줘야 함
       		
       		/*
       		OHL4000010	세라믹	CR
			OHL4000010	환경안전	QT
       		
			OHL4000011	세정	CL
			OHL4000011	재경	QT
			
			OHL4000012	램프	LP
			OHL4000012	SCM	QT
			
			*/
       		
			
       		
       	 	for(var k in TEAM_CD_values){
       	 		
       	 		
       	 		if(TEAM_CD_values[k] == grdMain.getValue(itemIndex,field)) {
    	        	
       	 			
    	        	dataProvider.setValue(itemIndex, "TEAM_CD_ID", codeMapEx.TEAM_CD[k].CODE_CD);
    	        	//TEAM_CD_values[k]
    	        	
    	        	//넘겨줄 때 BU_CD도 같이 넘겨줘야 함.
    	        	
    	        	fn_divNmSet(codeMapEx.TEAM_CD[k].CODE_CD,itemIndex,codeMapEx.TEAM_CD[k].BU_CD);	
    	        	
    	        	
    	        }
    	    }
       		
       		//PJT_STATUS_CD
       	 	for(var k in PJT_STATUS_CD_values){
 	        	if(PJT_STATUS_CD_values[k] == grdMain.getValue(itemIndex, field)) {
 	        		dataProvider.setValue(itemIndex, "PJT_STATUS_CD_ID", PJT_STATUS_CD_values[k]);   
 	        	}
 	    	}
       		
       		
       	    //OPEN_YN
       	 	for(var k in OPEN_YN_values){
	        	if(OPEN_YN_values[k] == grdMain.getValue(itemIndex, field)) {
	        		dataProvider.setValue(itemIndex, "OPEN_YN_ID", OPEN_YN_values[k]);   
	        	}
	    	}
    		
       	    
      }// END OF onCellEdited EVENT
 	
	
	
	
   	
} // end of fn_gridEvent


//그리드 추가
function fn_add(){
	
	
	
	grdMain.commit();
	var setCols = {
			CREATE_ID : "${sessionScope.userInfo.userId}",
			UPDATE_ID : "${sessionScope.userInfo.userId}"
				
	};//userId
	
	
	setCols.PROCESS_MNG_REG = "POPUP BUTTON";

	
	
	var TODAY = new Date();
	setCols.REG_DATE = TODAY.format('yyyy-mm-dd');
	dataProvider.insertRow(0, setCols);
	
	
}

//그리드 리셋
function fn_reset(){
	
	fn_apply();
}

function fn_del(){
	
	
	var deleteValidationFalseCnt = 0;
	
	var deleteValadationFalseList = "";
	
	var deleteValidationArray = [];
	
	
	var deleteRequesterID =  "${sessionScope.userInfo.userId}";  // 삭제 요청자 id
	
	var rows = grdMain.getCheckedRows();
	
	fn_popUpAuthorityHasOrNot();
	var isSCMTeamAdminQC = SCM_SEARCH.isSCMTeamAdminQC;
	
	//삭제할 대상을 선택하지 않은체, 삭제버튼을 누른 경우,
	if(rows.length==0){
		alert('<spring:message code="msg.deleteTargetNotSelected"/>');
		return false;
		
	}
	else
	{
		// 삭제 권한이 있는 것:removeRows(rows, false) 처리    meetingNote.meetingNoteGrid.dataProvider.removeRows(rows, false);
		// 삭제 권한이 없는 것:checkItem(v, false)처리 및 배열에 담아 alert을 통해 권한 없는 정보 알림
		
		confirm('<spring:message code="msg.deletePjtCfm"/>', function() {
		$.each(rows,function (n,v) {
			//삭제 권한 있음//    
			//(SCM, QC, ADMIN), 프로젝트 매니저, 등록권한 담당자 , 등록자
			
			
			if(isSCMTeamAdminQC>=1||dataProvider.getValue(v,"PJT_MNGER_ID_TEMP").indexOf(deleteRequesterID)!=-1||dataProvider.getValue(v,"REGISTER_MNGER_ID_TEMP").indexOf(deleteRequesterID)!=-1||dataProvider.getValue(v,"CREATE_ID").indexOf(deleteRequesterID)!=-1)
			{
				deleteValidationArray.push(v);
			}
			//삭제 권한 없음
			else
			{
				deleteValidationFalseCnt++;
				deleteValadationFalseList += grdMain.getValue(v,"PROJECT_NO")+' ';	
				
				grdMain.checkItem(v, false);
			}
		});
		
		dataProvider.removeRows(deleteValidationArray, false);
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
		
		})
		
	}
	
}



function getDateStr(myDate){
	return (myDate.getFullYear() + ((myDate.getMonth() + 1)<10?'0':'') + (myDate.getMonth() + 1) + ((myDate.getDate())<10?'0':'') + myDate.getDate())
}

//현재날짜 기준 12개월 전
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


//파일팝업 콜백

var fn_popupCallback = function () {
	if (arguments.length > 0 && arguments[0] == "EMP") {
		issueMng.issueGrid.dataProvider.setValue(arguments[2], "USER_ID", arguments[1][0].USER_ID);
		issueMng.issueGrid.dataProvider.setValue(arguments[2], "USER_NM", arguments[1][0].USER_NM);
		//issueMng.issueGrid.dataProvider.setValue(arguments[2], "DEPT_NM", arguments[1][0].DEPT_NM);
	}
	else{
		fn_apply();
		if (opener && opener.fn_popupSaveCallback) {
			opener.fn_popupSaveCallback();
		}
	}
}





//PJT_MNGER
var fn_popupCallback_PJT_MNGER = function () {
	
	var selctedEmpNmSum = "";
	var selctedEmpIdSum = "";
	if (arguments.length > 0 && arguments[0] == "EMP") {
		
		// arguments[1]에 returnData가 담겨 넘어온다. 여러명을 선택했을 경우에도 returnData 배열에 담김
		
		for(i=0;i<arguments[1].length;i++)
		{
			if(i==0)
			{
				selctedEmpNmSum+=arguments[1][i].USER_NM;
				selctedEmpIdSum+=arguments[1][i].USER_ID;
			}
			else{
				selctedEmpNmSum+= (','+arguments[1][i].USER_NM);		
				selctedEmpIdSum+= (','+arguments[1][i].USER_ID);
			}
		}
		
		dataProvider.setValue(arguments[2], "PJT_MNGER",selctedEmpNmSum);
		dataProvider.setValue(arguments[2], "PJT_MNGER_ID",selctedEmpIdSum);
	} else {
		fn_apply();
	}
}


//PJT_MEM(프로젝트 참가자)
var fn_popupCallback_PJT_MEM = function () {
	
	var selctedEmpNmSum = "";
	var selctedEmpIdSum = "";
	
	
	if (arguments.length > 0 && arguments[0] == "PJT_MEM") {
		
		// arguments[1]에 returnData가 담겨 넘어온다. 여러명을 선택했을 경우에도 returnData 배열에 담김
		
		for(i=0;i<arguments[1].length;i++)
		{
			if(i==0)
			{
				selctedEmpNmSum+=arguments[1][i].USER_NM;
				selctedEmpIdSum+=arguments[1][i].USER_ID;
			}
			else{
				selctedEmpNmSum+= (','+arguments[1][i].USER_NM);
				selctedEmpIdSum+= (','+arguments[1][i].USER_ID);
			}
		}
	
		
		dataProvider.setValue(arguments[2], "PJT_MEM_ID",selctedEmpIdSum);
		dataProvider.setValue(arguments[2], "PJT_MEM",selctedEmpNmSum);
		
	} else {
		fn_apply();
	}
}

//REGISTER_MNGER(등록권한 담당자)
var fn_popupCallback_REGISTER_MNGER = function () {
	
	var selctedEmpNmSum = "";
	var selctedEmpIdSum = "";
	if (arguments.length > 0 && arguments[0] == "PJT_REG_MEM") {
		
		// arguments[1]에 returnData가 담겨 넘어온다. 여러명을 선택했을 경우에도 returnData 배열에 담김
		for(i=0;i<arguments[1].length;i++)
		{
			if(i==0)
			{
				selctedEmpNmSum+=arguments[1][i].USER_NM;
				selctedEmpIdSum+=arguments[1][i].USER_ID;
			}
			else{
				selctedEmpNmSum+= (','+arguments[1][i].USER_NM);
				selctedEmpIdSum+= (','+arguments[1][i].USER_ID);
				
			}
		}
	
		dataProvider.setValue(arguments[2], "REGISTER_MNGER",selctedEmpNmSum);
		//REGISTER_MNGER_ID
		dataProvider.setValue(arguments[2], "REGISTER_MNGER_ID",selctedEmpIdSum);
		//REGISTER_MNGER_ID_TEMP
	} else {
		fn_apply();
	}
}


//팝업 권한 확인: SCM ROLE 이면 1, 아니면 0
//팝업 권한 확인: ADMIN ROEL 이면 1, 아니면 0
//팝업 권한 확인: QC(품질혁신) ROLE 이면 1, 아니면 0

function fn_popUpAuthorityHasOrNot(){
	
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

//등록권한 담당
function fn_regiAuthorMngerIsOrNot(REGISTER_MNGER,userID){
	
	var arrayRegisterMnger = REGISTER_MNGER.split(',');
	

	var result; 
	if(arrayRegisterMnger.indexOf(userID)!=-1)
	{
		result = true;
	}
	else
	{
		result = false;
	}
	
	return result;
}

//프로젝트 참가자, 등록권한 담당자  =<grdData에 배열 속성으로 넣기

async function fn_projectRegMem_projectMem_reGen(grdData)
{
  	//프로젝트 등록에서 처리주어야할 사항: 프로젝트 참가자(여러명), 등록권한 담당자(여러명)
	
	//REAL GRID 각 ROW에 대한 반복문 
	for(i=0 ;i < grdData.length; i++)
	{
		//프로젝트 추가
		if(grdData[i].state=='inserted')
		{
			
			var tempProjectMemArray = [];
			var tempProjectRegMemArray = [];
			var tempMemArray = [];
			var tempRegMemArray = [];
			
			tempProjectMemArray = grdData[i].PJT_MEM_ID.split(',');
			tempProjectRegMemArray = grdData[i].REGISTER_MNGER_ID.split(',');
			
			// arrayMember = ["김수호","이큰산"]   =>    UpperLevelArray.MemberList =[{pjtMem:김수호},{pjtMem:이큰산}];
			
			for(j=0; j<tempProjectMemArray.length; j++ )
			{
				tempMemArray.push({pjtMem:String(tempProjectMemArray[j])});
			}	
			
			for(k = 0; k<tempProjectRegMemArray.length;k++)
			{
				tempRegMemArray.push({pjtRegMem:String(tempProjectRegMemArray[k])});
			}
			
			grdData[i].pjtMemList = tempMemArray;
			grdData[i].pjtRegMemList = tempRegMemArray;
		}
		//프로젝트등록에서  MEMBER 수정(update,insert 발생 가능)
		else if(grdData[i].state=='updated')
		{   
			// 프로젝트 등록 페이지 ROW UPDATE 수행시에 
			// 해당 프로젝트의 OPEN_YN 값을 참조하는 과정관리 ROW들에도 동일하게 반영되어야함
			// 업데이트 발생시, 
			// COMPANY_CD, BU_CD, PJT_NO를 WHERE 조건으로 해당 ROW에 대해 모두 DEL_FLAG:Y처리
			
			
			var tempPJT_MEM_ID_array = grdData[i].PJT_MEM_ID.split(',');
			var tempREGISTER_MNGER_ID_array = grdData[i].REGISTER_MNGER_ID.split(',');
			
			var pjtMemArray = [];
			var pjtRegMemArray = [];
			
		
			//각각의 ROW안에 프로젝트 참가자 LIST에 대한 반복문 
			for(q=0; q<tempPJT_MEM_ID_array.length ; q++)
			{
				pjtMemArray.push({pjtMem:tempPJT_MEM_ID_array[q]});
					
			}
			
			//각각의 ROW안에 프로젝트 등록권한담당자 LIST에 대한 반복문
			for(j=0; j<tempREGISTER_MNGER_ID_array.length ; j++)
			{
				pjtRegMemArray.push({pjtRegMem:tempREGISTER_MNGER_ID_array[j]});
			}
			
			grdData[i].pjtMemList = pjtMemArray;
			grdData[i].pjtRegMemList = pjtRegMemArray;
			
			
		}
		//프로젝트등록에서 MEMBER 삭제(update만 발생)
		else if(grdData[i].state=='deleted')
		{
			
			
			
			//삭제의 경우, 사용자에 의해 프로젝트 참가자 멤버(여러명), 프로젝트 등록권한 담당자(여러명)의 멤버가 변경된 후, 삭제 요청이 있을 수 있으므로
			//PJT_MEM_ID_TEMP, REGISTER_MNGER_ID_TEMP 값을 이용해서 UPDATE: DEL_FLAG:N -> Y 처리
			
			var tempPjtMemArray = [];
		    var tempPjtRegMemArray = [];
		    var tempMemArray = [];
			var tempRegMemArray = [];
			
		    
		    
			tempPjtMemArray = grdData[i].PJT_MEM_ID_TEMP.split(',');
			tempPjtRegMemArray = grdData[i].REGISTER_MNGER_ID_TEMP.split(',');
		    
		    for(q=0; q< tempPjtMemArray.length; q++)
		    {
		    	tempMemArray.push({pjtMem:String(tempPjtMemArray[q])});
		    }
		    
		    for(x=0; x< tempPjtRegMemArray.length; x++)
		    {
		    	tempRegMemArray.push({pjtRegMem:String(tempPjtRegMemArray[x])});
		    }
			
		    
		    grdData[i].pjtMemList = tempMemArray;
			grdData[i].pjtRegMemList = tempRegMemArray;
		    
		}
		
		
		
	}
		
	
	
	
 	
}
	
function fn_pjtMemList_pjtRegMemList_UorI(grdData){
 	//REQUIREMENT
 	//1.   입력된 프로젝트 참가자들, 등록권한 담당자들에 대해 모두 DEL_FLAG:Y 처리
 	//1-1. WHERE 조건에 COMPANY_CD, BU_CD, PJT_NO를 이용하여  
 	//2.   TB_KPI_PJT_MEM, TB_KPI_PJT_REG_MEM 테이블에 값이 존재하면, UPDATE 수행 DEL_FLAG:Y -> N
 	//3.   TB_KPI_PJT_MEM, TB_KPI_PJT_REG_MEM 테이블에 값이 존재안하면, INSERT 수행
 	//4.   필요 인자: COMPANY_CD, BU_CD, PJT_NO, USER_ID
 	//5.
 	
	Mem_RegMem_SEARCH = {};  
	Mem_RegMem_SEARCH._mtd = "saveAll";
	Mem_RegMem_SEARCH.tranData = [
		{outDs:"rtnMemList", _siq:"snop.meetingMng.PjtMem", grdData: grdData, mergeFlag:"Y"}
		,{outDs:"rtnRegMemList", _siq:"snop.meetingMng.PjtRegMem", grdData: grdData, mergeFlag:"Y"}
		];
	
	return new Promise(function(resolve,reject){
	    	resolve(	
						gfn_service({
							async   : false,
							url     : GV_CONTEXT_PATH + "/biz/obj",
							data    : Mem_RegMem_SEARCH,
							success : function (data) {
								//resolve(grdData);
							},
							error:function(request,status,error){
					       }
					
						}, "obj")
		   );
	});
}	
	


function fn_setValidation(grdMain){
	
	
	var validations = [{
	    criteria: "values['CLOSE_DATE'] > values['START_DATE']",
	    message: '<spring:message code="msg.closeDateValid"/>',
	    mode: "always",
	    level: "error"
	}]; 
	
	grdMain.setValidations(validations);
	
}

function fn_closeDateValidation(grdData){
	
	for(i=0; i<grdData.length; i++ )
	{
		
		if(grdData[i].START_DATE >= grdData[i].CLOSE_DATE )
		{
			
			
			alert('<spring:message code="msg.closeDateValid"/>');
			return false;
			
		}
	}
	
	
}

function gridCallback(resList){
	
	fn_popUpAuthorityHasOrNot();
   	var isSCMTeamAdminQC = SCM_SEARCH.isSCMTeamAdminQC;
    var USER_ID = "${sessionScope.userInfo.userId}";
    dataProvider.beginUpdate();
	for(var i = resList.length-1; i >= 0; i--){
		
		if(resList[i].PJT_STATUS_CD_ID == 'CL')
		{
			//scm팀, 품질혁신팀, 프로젝트 매니저, 등록권한 담당자만 수정가능		
			if(isSCMTeamAdminQC>=1||dataProvider.getValue(i,"PJT_MNGER_ID").indexOf(USER_ID)!=-1||dataProvider.getValue(i,"REGISTER_MNGER_ID_TEMP").indexOf(USER_ID)!=-1)
			{
				grdMain.setCellStyles(i,"PJT_TYPE","CLOSE");
				//grdMain.setCellStyles(i,"PROJECT_NO","CLOSE");
				//grdMain.setCellStyles(i,"DIV_CD","CLOSE");
				grdMain.setCellStyles(i,"TEAM_CD","CLOSE");
				grdMain.setCellStyles(i,"PJT_MNGER","CLOSE");
				grdMain.setCellStyles(i,"PJT_MEM","CLOSE");
				grdMain.setCellStyles(i,"REGISTER_MNGER","CLOSE");
				grdMain.setCellStyles(i,"PJT_NM","CLOSE");
				grdMain.setCellStyles(i,"REG_DATE","CLOSE");
				grdMain.setCellStyles(i,"START_DATE","CLOSE");
				grdMain.setCellStyles(i,"CLOSE_DATE","CLOSE");
				
				grdMain.setCellStyles(i,"FILE_NM_ORG","CLOSE");
				grdMain.setCellStyles(i,"PURPOSE","CLOSE");
				grdMain.setCellStyles(i,"GOAL","CLOSE");
				grdMain.setCellStyles(i,"PROGRESS","CLOSE");
				grdMain.setCellStyles(i,"PERFORMANCE","CLOSE");
				grdMain.setCellStyles(i,"REMARK","CLOSE");	
				//PJT_STATUS_CD
			}		
			else
			{
				grdMain.setCellStyles(i,"PJT_TYPE","CLOSE");
				//grdMain.setCellStyles(i,"PROJECT_NO","CLOSE");
				//grdMain.setCellStyles(i,"DIV_CD","CLOSE");
				grdMain.setCellStyles(i,"TEAM_CD","CLOSE");
				grdMain.setCellStyles(i,"PJT_MNGER","CLOSE");
				grdMain.setCellStyles(i,"PJT_MEM","CLOSE");
				grdMain.setCellStyles(i,"REGISTER_MNGER","CLOSE");
				grdMain.setCellStyles(i,"PJT_NM","CLOSE");
				grdMain.setCellStyles(i,"REG_DATE","CLOSE");
				grdMain.setCellStyles(i,"START_DATE","CLOSE");
				grdMain.setCellStyles(i,"CLOSE_DATE","CLOSE");
				grdMain.setCellStyles(i,"PJT_STATUS_CD","CLOSE");
				grdMain.setCellStyles(i,"FILE_NM_ORG","CLOSE");
				grdMain.setCellStyles(i,"PURPOSE","CLOSE");
				grdMain.setCellStyles(i,"GOAL","CLOSE");
				grdMain.setCellStyles(i,"PROGRESS","CLOSE");
				grdMain.setCellStyles(i,"PERFORMANCE","CLOSE");
				grdMain.setCellStyles(i,"REMARK","CLOSE");
				grdMain.setCellStyles(i,"OPEN_YN","CLOSE");
			}
			
			
		}
		else
		{   
			//scm팀, 품질혁신팀, 프로젝트 매니저, 등록권한 담당자만 수정가능		
			if(isSCMTeamAdminQC>=1||dataProvider.getValue(i,"PJT_MNGER_ID").indexOf(USER_ID)!=-1||dataProvider.getValue(i,"REGISTER_MNGER_ID_TEMP").indexOf(USER_ID)!=-1)
			{	grdMain.setCellStyles(i,"PJT_TYPE","CLOSE");
				//grdMain.setCellStyles(i,"PROJECT_NO","OPEN");
				//grdMain.setCellStyles(i,"DIV_CD","OPEN");
				grdMain.setCellStyles(i,"TEAM_CD","OPEN");
				grdMain.setCellStyles(i,"PJT_MNGER","OPEN");
				grdMain.setCellStyles(i,"PJT_MEM","OPEN");
				grdMain.setCellStyles(i,"REGISTER_MNGER","OPEN");
				grdMain.setCellStyles(i,"PJT_NM","OPEN");
				grdMain.setCellStyles(i,"REG_DATE","OPEN");
				grdMain.setCellStyles(i,"START_DATE","OPEN");
				grdMain.setCellStyles(i,"CLOSE_DATE","OPEN");
				
				grdMain.setCellStyles(i,"FILE_NM_ORG","OPEN");
				grdMain.setCellStyles(i,"PURPOSE","OPEN");
				grdMain.setCellStyles(i,"GOAL","OPEN");
				grdMain.setCellStyles(i,"PROGRESS","OPEN");
				grdMain.setCellStyles(i,"PERFORMANCE","OPEN");
				grdMain.setCellStyles(i,"REMARK","OPEN");
				
			}
			//scm팀, 품질혁신팀, 프로젝트 매니저, 등록권한 담당자가 아니면 수정 불가
			else
			{
				grdMain.setCellStyles(i,"PJT_TYPE","CLOSE");
				//grdMain.setCellStyles(i,"PROJECT_NO","CLOSE");
				//grdMain.setCellStyles(i,"DIV_CD","CLOSE");
				grdMain.setCellStyles(i,"TEAM_CD","CLOSE");
				grdMain.setCellStyles(i,"PJT_MNGER","CLOSE");
				grdMain.setCellStyles(i,"PJT_MEM","CLOSE");
				grdMain.setCellStyles(i,"REGISTER_MNGER","CLOSE");
				grdMain.setCellStyles(i,"PJT_NM","CLOSE");
				grdMain.setCellStyles(i,"REG_DATE","CLOSE");
				grdMain.setCellStyles(i,"START_DATE","CLOSE");
				grdMain.setCellStyles(i,"CLOSE_DATE","CLOSE");
				grdMain.setCellStyles(i,"PJT_STATUS_CD","CLOSE");
				grdMain.setCellStyles(i,"FILE_NM_ORG","CLOSE");
				grdMain.setCellStyles(i,"PURPOSE","CLOSE");
				grdMain.setCellStyles(i,"GOAL","CLOSE");
				grdMain.setCellStyles(i,"PROGRESS","CLOSE");
				grdMain.setCellStyles(i,"PERFORMANCE","CLOSE");
				grdMain.setCellStyles(i,"REMARK","CLOSE");
				grdMain.setCellStyles(i,"OPEN_YN","CLOSE");
			}
		}

		//dataProvider.endUpdate();
		
	}// end of loop
	dataProvider.endUpdate();
	
}
	//fn_divNmSet(grdMain.getValue(itemIndex, field),itemIndex);
	function fn_divNmSet(teamCd,itemIndex,bu_cd)
	{
		
		//goal: 입력받은 teamCd에 해당하는 divNm(본부명)을 이벤트가 발생한 itemIndex의 본부명 컬럼에 실시간으로 적용시켜 보여줄 것
		
		FORM_SEARCH = {};
		
		
		FORM_SEARCH.selectedTeamCd = teamCd;
		FORM_SEARCH.bu_cd = bu_cd
		FORM_SEARCH.sql	     = 'N';
		FORM_SEARCH._mtd     = "getList";
		FORM_SEARCH.tranData = [{outDs:"rtnList",_siq:"snop.meetingMng.divNm"}];
		
		gfn_service({
			url    : GV_CONTEXT_PATH + "/biz/obj",
			data   : FORM_SEARCH,
			success: function(data) {
				
				dataProvider.setValue(itemIndex, "DIV_CD", data.rtnList[0].DIV_NM);
				dataProvider.setValue(itemIndex, "BU_CD_ID", data.rtnList[0].BU_CD);
			}
		}, "obj");
		
	}
	
	function fn_reGenTeamCd(ds, field1, field2) {
	    var rtnArray = [];
	    ds = ds || [];
	    var forI;
	    for ( forI = 0; forI < ds.length; forI++ ) {
	    	
	    	rtnArray.push(ds[forI][field1]+ds[forI][field2]);
	    	
	    }
	    return rtnArray;
	}
	
function fn_PROJECT_NO_VALIDATION(PROJECT_SUB_NO){
	    
	    BREAKING_LIMIT_SEARCH = {};
	    
	    
	    BREAKING_LIMIT_SEARCH.PROJECT_SUB_NO = PROJECT_SUB_NO;
	    BREAKING_LIMIT_SEARCH.sql      = 'N';
	    BREAKING_LIMIT_SEARCH._mtd     = "getList";
	    BREAKING_LIMIT_SEARCH.tranData = [{outDs:"rtnList",_siq:"snop.meetingMng.breakingLimitPKValidation"}];
	   
	    return new Promise(function(resolve,reject){    gfn_service({
            
            
            url    : GV_CONTEXT_PATH + "/biz/obj",
            data   : BREAKING_LIMIT_SEARCH,
            success: function(data) {
                
                        
                           if(parseInt(data.rtnList[0].PROJECT_NO_EXIST_CNT) >= 1)
                           {
                               BREAKING_LIMIT_SEARCH.PROJECT_NO_EXIST_CNT = 1;
                              resolve( BREAKING_LIMIT_SEARCH.PROJECT_NO_EXIST_CNT);
                               
                           }
                           else
                           {
                               BREAKING_LIMIT_SEARCH.PROJECT_NO_EXIST_CNT = 0;
                              resolve(BREAKING_LIMIT_SEARCH.PROJECT_NO_EXIST_CNT);
                               
                           }  
                           
            }  
            
        }, "obj")
     });
	      
	        
	        
}	
	
	
function isDuplicate(arr)  {
	      const isDup = arr.some(function(x) {
	        return arr.indexOf(x) !== arr.lastIndexOf(x);
	      });
	                             
	      return isDup;
}
	
	
</script>

</head>
<body>
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="keywordpop" class="popupDv">
		<div class="pop_tit"><spring:message code="lbl.pjtAdd"/></div>
		<div class="popCont">
			<div class="srhwrap">
				<form id="searchForm" name="searchForm" method="POST" onSubmit="return false;">
					<div class="srhcondi">
						
						<!-- 프로젝트명 입력 라인 시작 -->
						<ul>
							<li>
								<strong><spring:message code="lbl.pjtNm"/></strong><!-- 프로젝트명 -->
								<div class="selectBox">
									<input type="text" id="projectNm" name="projectNm" value="" class="ipt"/>
								</div>
							</li>
							<li>
								<strong><spring:message code="lbl.pjtNo"/></strong><!-- 프로젝트NO -->
								<div class="selectBox">
									<input type="text" id="projectNO" name="projectNO" value="" class="ipt"/>
								</div>
							</li>
							<li>
								<strong><spring:message code="lbl.salesOrgL3Name"/></strong><!-- 본부명 -->
								<div class="selectBox">
									<select id="divName" name="divName" multiple="multiple"></select>
								</div>
							</li>
							<li>
								<strong><spring:message code="lbl.teamName"/></strong><!-- 팀명 -->
								<div class="selectBox">
									<select id="teamNm" name="teamNm" multiple="multiple"></select>
								</div>
							</li>
							
						</ul>
						<!-- 프로젝트 매니저 라인 시작 -->
						<ul>
							<li>
								<strong><spring:message code="lbl.pjtMnger"/></strong><!-- 프로젝트 매니저 -->
								<div class="selectBox">
									<input type="text" id="projectManager" name="projectManager" value="" class="ipt"/>
								</div>
							</li>
						
							<li><!--  등록일자 시작  -->
								<strong class="srhcondipop"><spring:message code="lbl.regDttm"/></strong>
								<input type="text" id="fromCal" name="fromCal" class="iptdate datepicker1" readonly value="" />
								<%-- <input type="<c:if test="${param.wType=='SW'}">hidden</c:if><c:if test="${param.wType!='SW'}">text</c:if>" id="fromPWeek" name="fromPWeek" class="iptdateweek" disabled="disabled" value=""/>
								<input type="<c:if test="${param.wType=='SW'}">text</c:if><c:if test="${param.wType!='SW'}">hidden</c:if>" id="fromWeek" name="fromWeek" class="iptdateweek" disabled="disabled" value=""/> --%>
								<input type="hidden" id="swFromDate" name="swFromDate"/>
								<input type="hidden" id="pwFromDate" name="pwFromDate"/>
								~
								<input type="text" id="toCal" name="toCal" class="iptdate datepicker2" readonly value="" />
								<%-- <input type="<c:if test="${param.wType=='SW'}">hidden</c:if><c:if test="${param.wType!='SW'}">text</c:if>" id="toPWeek" name="toPWeek" class="iptdateweek" disabled="disabled" value=""/>
								<input type="<c:if test="${param.wType=='SW'}">text</c:if><c:if test="${param.wType!='SW'}">hidden</c:if>" id="toWeek" name="toWeek" class="iptdateweek" disabled="disabled" value=""/> --%>
								<input type="hidden" id="swToDate" name="swToDate"/>
								<input type="hidden" id="pwToDate" name="pwToDate"/>
							</li>
							<li><!-- 진행상태 -->
								<strong><spring:message code="lbl.progressStatus"/></strong>
								<div class="selectBox">
									<select id="progressStatus" name="progressStatus" multiple="multiple"></select>
								</div>
							</li>
						</ul>
					</div>
				</form>
				<div class="bt_btn">
					<a href="javascript:;" id ="btnSearch" class="fl_app"><spring:message code="lbl.search"/></a>
				</div>
			</div>
			<div id="realgrid" class="realgrid1"></div>
			<div class="pop_btn">
				
				<a href="javascript:;" id="btnReset" class="app1"><spring:message code="lbl.reset"/></a>
				<a href="javascript:;" id="btnAdd" class="app1" ><spring:message code="lbl.add"/></a>
				<a href="javascript:;" id="btnDelete" class="app1"><spring:message code="lbl.delete"/></a>
				<a href="javascript:;" id="btnSave" class="app2"><spring:message code="lbl.save"/></a>
			</div>
		</div>
	</div>
</body>
</html>