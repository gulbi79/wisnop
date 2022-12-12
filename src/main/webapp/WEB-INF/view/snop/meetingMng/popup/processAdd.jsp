<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code="lbl.processMngReg"/></title>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
	<jsp:param name="popupYn" value="Y"/>
</jsp:include>

<script type="text/javascript">
var RegMem_SEARCH ={};
var BREAKING_LIMIT_SEARCH = {};
var PROJECT_NO_inVALID_CNT = 0;
//전역변수 설정
var popupWidth, popupHeight;
var codeMap = null, codeMapEx = null;
var gridInstance, grdMain, dataProvider;


var selectedCompanyCd = "${param.COMPANY_CD}";			 //프로젝트 등록 페이지에서 받아오는 COMPANY_CD
var selectedBU_CD = "${param.BU_CD}";         		 	 //프로젝트 등록 페이지에서 받아오는 BU_CD
var selectedPJT_NO = "${param.PROJECT_NO}";         		 //프로젝트 등록 페이지에서 받아오는 PJT_NO
var selectedREGISTER_MNGER = "${param.REGISTER_MNGER}";  //프로젝트 등록 페이지에서 받아오는 REGISTER_MNGER
var selectedPJT_NM = "${param.PJT_NM}";                  //프로젝트 등록 페이지에서 받아오는 PJT_NM
var selectedPJT_TYPE = "${param.PJT_TYPE}";
var selectedPRT_PJT_NO = "${param.PRT_PJT_NO}";
var selectedOPEN_YN    = "${param.OPEN_YN}";
var selectedSTART_DATE = "${param.START_DATE}";
var selectedCLOSE_DATE = "${param.CLOSE_DATE}";
var selectedPJT_MNGER  = "${param.PJT_MNGER}";
var userId = "${sessionScope.userInfo.userId}";
var selectedDIV_CD = "${param.DIV_CD}";
var selectedTEAM_CD = "${param.TEAM_CD}";
var selectedPJT_STATUS_CD = "${param.PJT_STATUS_CD}"; 


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
	
	DATEPICKET(null, fn_getDate_6mBefore(),fn_getDate_12mAfter());
	
	//    본부명,     진행상태,           프로젝트 분류,  공개여부              
	//  DIV_CD,   PJT_STATUS_CD,      PJT_TYPE,    OPEN_YN
	var grpCd = "DIV_CD,PJT_STATUS_CD,PJT_TYPE,OPEN_YN";
	
	
	
	// 공통코드 조회 
	codeMap = gfn_getComCode(grpCd, "Y");
	codeMapEx = gfn_getComCodeEx(["TEAM_CD"],null,{});
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
			//프로젝트 NO
			name         : "PROJECT_NO",
			fieldName    : "PROJECT_NO",
			editable     : false,
			header       : { text: '<spring:message code="lbl.pjtNo"/>' },
			styles       : { textAlignment: "center", background : gv_noneEditColor },
			width        : 100,
		},
		{
			//등록권한 담당자
			name         : "REGISTER_MNGER",
			fieldName    : "REGISTER_MNGER",
			editable     : false,
			header       : { text: '<spring:message code="lbl.regAuthMnger"/>' },
			styles       : { textAlignment: "center", background : gv_noneEditColor},
			width        : 170,
		
		},
		{
			//프로젝트명
			name         : "PJT_NM",
			fieldName    : "PJT_NM",
			editable     : false,
			header       : { text: '<spring:message code="lbl.pjtNm"/>' },
			styles       : { textAlignment: "center", background : gv_noneEditColor },
			width        : 200,
		},
		{
			//프로젝트 Sub No.
			name         : "PROJECT_SUB_NO",
			fieldName    : "PROJECT_SUB_NO",
			editable     : false,
			header       : { text: '<spring:message code="lbl.projectSubNo"/>' },
			//styles       : { textAlignment: "near", background : gv_noneEditColor },
			width        : 100,
			dynamicStyles: function(grid, index, value){
                var rowState = dataProvider.getRowState(index.itemIndex); 
                
                if(dataProvider.getValue(index.itemIndex,"PJT_TYPE")=="PROH" && rowState=="created" )
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
                        grid.setValue(index.itemIndex,"PROJECT_SUB_NO",""); 
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
                    editMask: "P0000-C-00-00",
                    allowEmpty:false,
                    restrictNull:true,
                    definitions: {"P":"P","C":"A|P"},
                    includedFormat:true
                }
                
            }
			
			
		},
		{
			//과정관리
			name         : "PROCESS",
			fieldName    : "PROCESS",
			editable     : true,
			header       : { text: '<spring:message code="lbl.processMng"/>' },
			styles       : { textAlignment: "near"},
			dynamicStyles : [{ criteria: ["state<>'c'","state='c'"], styles: ["background="+gv_editColor,"background="+gv_requiredColor] }],
			width        : 100,
		},
		{
			//등록일
			name         : "REG_DATE",
			fieldName    : "REG_DATE",
			editable     : true,
			header       : { text: '<spring:message code="lbl.regDttm"/>' },
			styles       : { textAlignment: "center"},
			dynamicStyles : [{ criteria: ["state<>'c'","state='c'"], styles: ["background="+gv_editColor,"background="+gv_requiredColor] }],
			editor : {type : "date", datetimeFormat : "yyyy-MM-dd"},
			width        : 100
		},
		{
			//파일
			name         : "FILE_NM_ORG",
			fieldName    : "FILE_NM_ORG",
			editable     : false,
			header       : { text: '<spring:message code="lbl.file"/>' },
			styles       : { textAlignment: "near",background:gv_editColor},
			width        : 100,
			width : 250,
			buttonVisibility:"visible" ,cursor: "pointer",button: "action"
		},
		{
			//업무 진행 내역
			name         : "PROGRESS",
			fieldName    : "PROGRESS",
			editable     : true,
			header       : { text: '<spring:message code="lbl.businProgress"/>' },
			styles : {textAlignment: "near", textWrap: 'explicit',background:gv_editColor},
			dynamicStyles : [{ criteria: ["state<>'c'","state='c'"], styles: ["background="+gv_editColor,"background="+gv_requiredColor] }],
			width : 250
		},
		{
			//실적
			name         : "PERFORMANCE",
			fieldName    : "PERFORMANCE",
			editable     : true,
			header       : { text: '<spring:message code="lbl.actual"/>' },
			styles : {textAlignment: "near", textWrap: 'explicit',background:gv_editColor},
			width : 250
		},
		{
			//비고
			name         : "REMARK",
			fieldName    : "REMARK",
			editable     : true,
			header       : { text: '<spring:message code="lbl.remark2"/>' },
			styles : {textAlignment: "near", textWrap: 'explicit',background:gv_editColor},
			width : 250
		}
	];
	//    아래 필드값 중 X 표시는 프로젝트 등록 화면에서 넘겨 받아야 함.
	//    프로젝트등록화면에서 받아오는 필드 값:      O       ,  O    ,    X     ,      X     ,    세션       ,   함수,      ,   NULL       X,          X     ,      X       ,     X   
	fn_dataProvider_setFields(columns,['COMPANY_CD','BU_CD','PJT_TYPE','PRT_PJT_NO','CREATE_ID','CREATE_DTTM','FILE_NO','OPEN_YN', 'UPDATE_ID', 'UPDATE_DTTM', 'DEL_FLAG','REGISTER_MNGER_ID', 'PJT_CATE','PJT_MNGER','START_DATE','CLOSE_DATE','DIV_CD','TEAM_CD','PJT_STATUS_CD']);
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
		
		id         : "PJT",
		
		background : gv_arrDimColor[0]
		
	}]);
	
	grdMain.addCellStyles([{
		
		id         : "PRC",
		
		background : gv_editColor
		
	}]);
	
	
}

function fn_gridEvent(grdMain){
	
	grdMain.setColumnProperty("PROGRESS", "editor", {type : "multiline"});
   	grdMain.setColumnProperty("PROGRESS", "styles", {textWrap : "normal"});
   	
   	grdMain.setColumnProperty("PERFORMANCE", "editor", {type : "multiline"});
   	grdMain.setColumnProperty("PERFORMANCE", "styles", {textWrap : "normal"});
   	
   	grdMain.setColumnProperty("REMARK", "editor", {type : "multiline"});
   	grdMain.setColumnProperty("REMARK", "styles", {textWrap : "normal"});
   	
   	grdMain.setDisplayOptions({eachRowResizable : true});
	
	
   	
	grdMain.onCellButtonClicked = function (grid, itemIndex, column) {
   		
   		if (column.name == "FILE_NM_ORG"||column.name =="PROCESS_MNG_REG") {
			var rowState = dataProvider.getRowState(itemIndex);
			if (rowState != "none" && rowState != "updated") {
				alert('<spring:message code="msg.dataSave"/>');
				return;
			}
		}
   		
   		
   		
   		if (column.name == "FILE_NM_ORG") {
			
			
			var params = {
       			COMPANY_CD   : grid.getValue(itemIndex, "COMPANY_CD"),		 // 여기가 문제  <=    getValue를 통해 해당 값을 가져오려면 dataProvider에 모든 데이터가 query 문을 통해 불러져 와 있어야 한다.				
       			PJT_NO   	 : grid.getValue(itemIndex, "PROJECT_SUB_NO"),		       				
   				BU_CD        : grid.getValue(itemIndex, "BU_CD"),
       			FILE_NO      : grid.getValue(itemIndex, "FILE_NO"),		       				
   				_siq         : "snop.meetingMng.processAdd"+"FileNo", // 페이지는 과정관리페이지지만, 실제 데이터가 저장되는 테이블이 같으므로 동일한 update xml 호출		       				
       			callback     : "fn_popupCallback",
       		};
       
       		gfn_comPopupOpen("FILE",params);
  
		}
	
   		
	}//end of onCellButtonClicked
   	
	
}


//이벤트 초기화
function fn_initEvent() {
	
	//버튼 이벤트
	$("#btnReset").click("on", function(){  fn_reset()     });
	$("#btnAdd").click("on", function(){ 	fn_add()	});
	$("#btnDelete").click("on", function(){	fn_del()	 });
	$("#btnSave").click("on", function()  { fn_save()    });	
	
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
	
	FORM_SEARCH.sql	     = sqlFlag;
	FORM_SEARCH._mtd     = "getList";
	FORM_SEARCH.projectNO = selectedPJT_NO;
	FORM_SEARCH.tranData = [{outDs:"rtnList",_siq:"snop.meetingMng.processAdd"}];
	
	gfn_service({
		url    : GV_CONTEXT_PATH + "/biz/obj.do",
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
			// 그리드 데이터 건수 출력
			
			grdMain.fitRowHeightAll(0, true);
		}
	}, "obj");
}

//그리드 초기화
function fn_reset() {
	grdMain.cancel();
	dataProvider.rollback(dataProvider.getSavePoints()[0]);
}

//그리드 저장
//check 1.PROJECT_SUB_NO의 공백여부 확인
//check 2.PROJECT_SUB_NO => PROJECT_NO와 같아야함(10자리동일-XX)
//check 3.사용자가 입력한 한계돌파 과정관리  PROJECT_SUB_NO의 valid 여부 => DB PK 값이므로 무조건 검사해줘야 함
async function fn_save(){
	
	PROJECT_NO_inVALID_CNT = 0;
	
	var arrPROJECT_SUB_NO = [];
	
	//수정된 그리드 데이터
    var grdData = gfn_getGrdSavedataAll(grdMain);
        
    if (grdData.length == 0) {
        alert('<spring:message code="msg.noChangeData"/>');
        return;
    }
    
    
    //필수 입력 체크             과정관리,     등록일,     업무진행내역
    var arrColumn = ["PROCESS","REG_DATE","PROGRESS"];
    
    if (!gfn_getValidation(gridInstance, arrColumn)) {
        return;
    }
    
    
    for(i=0;i<grdData.length;i++)
    {
     
    	grdData[i].UPDATE_ID = userId;   
        
    	if(grdData[i].PJT_TYPE === "PROH" && grdData[i].state=="inserted")
        {
        	
            //사용자가입력한 PROJECT_SUB_NO간의 중복검사
            arrPROJECT_SUB_NO.push(grdData[i].PROJECT_SUB_NO);
            
            
            grdData[i].PROJECT_SUB_NO_EXIST_CNT = await fn_PROJECT_SUB_NO_VALIDATION(grdData[i].PROJECT_SUB_NO, function(){
            	return BREAKING_LIMIT_SEARCH.PROJECT_NO_EXIST_CNT
            });
            
            if(grdData[i].PROJECT_SUB_NO_EXIST_CNT>=1)
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
            if(grdData[i].PROJECT_SUB_NO == "" ||grdData[i].PROJECT_SUB_NO == null)
            {
                alert("한계돌파 과정관리 프로젝트 Sub.No 미입력");
                grdMain.setCurrent({itemIndex: (i-1), column : "PROJECT_SUB_NO"});
                return;
            }
            
            //PROJECT_SUB_NO => PROJECT_NO와 같아야함(10자리동일-XX)
            if(grdData[i].PROJECT_NO != grdData[i].PROJECT_SUB_NO.substring(0,10))
            {
                alert("한계돌파 과정관리 프로젝트 Sub.No 앞8자리는 프로젝트 NO와 같아야 합니다.");
                grdMain.setCurrent({itemIndex: (i-1), column : "PROJECT_SUB_NO"});
                return;
            }
            
            if(isDuplicate(arrPROJECT_SUB_NO))
            {
            	alert("중복된 한계돌파 과정관리 프로젝트 Sub.No를 입력하였습니다. 고유한 값으로 입력해 주세요. ");
            	grdMain.setCurrent({itemIndex: (i-1), column : "PROJECT_SUB_NO"});
            	return;
            }
            
            if(grdData[i].PROJECT_SUB_NO_EXIST_CNT>=1)
            {
            	alert("입력한 한계돌파 과정관리 프로젝트 Sub.No가 존재합니다. 고유한 값으로 입력해 주세요.");
            	grdMain.setCurrent({itemIndex: (i-1), column : "PROJECT_SUB_NO"});
            	return;
            }
            
        }
    	
    }
    
    if(PROJECT_NO_inVALID_CNT >= 1)
    {
    	alert( '중복된 PROJECT_SUB_NO가 존재합니다.');
    	return;
    }
    else
    {
    	 confirm('<spring:message code="msg.saveCfm"/>', function() {
             
             
             
             FORM_SAVE          = {}; //초기화
             FORM_SAVE._mtd     = "saveAll";
             FORM_SAVE.tranData = [{outDs:"saveCnt",_siq:"snop.meetingMng.processAdd",grdData:grdData}];
               
             
                gfn_service({
                     url    : GV_CONTEXT_PATH + "/biz/obj.do",
                     data   : FORM_SAVE,
                     success: function(data) {
                         
                         
                         if(data.errCode == -10){
                             alert(gfn_getDomainMsg("msg.dupData", data.errLine));
                             grdMain.setCurrent({dataRow : data.errLine - 1, column : "PROJECT_SUB_NO"});
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


// 현재날짜 기준 6개월 전
function getDateStr(myDate){
	return (myDate.getFullYear() + ((myDate.getMonth() + 1)<10?'0':'') + (myDate.getMonth() + 1) + ((myDate.getDate())<10?'0':'') + myDate.getDate())
}

function fn_getDate_6mBefore() {
	
	var d = new Date()
	  var monthOfYear = d.getMonth()
	  d.setMonth(monthOfYear - 6)   // 6개월전 
	
	
	return getDateStr(d);
}

// 현재날짜 기준 12개월 후
function fn_getDate_12mAfter() {
	var curDate  = new Date();
	var curYear  = curDate.getFullYear()+1;
	var curMonth = curDate.getMonth()+1;
	var curDate  = curDate.getDate();
	
	return curYear + (curMonth<10?'0':'') + curMonth + (curDate<10?'0':'') + curDate;
}


function fn_add(){
	
	
	grdMain.commit();
	var setCols = {
			
			COMPANY_CD : selectedCompanyCd,
			BU_CD: selectedBU_CD,
			PROJECT_NO:selectedPJT_NO,
			REGISTER_MNGER: selectedREGISTER_MNGER,
			PJT_NM: selectedPJT_NM,
			PJT_TYPE:selectedPJT_TYPE,
			PJT_CATE:'PRC',
			PRT_PJT_NO:selectedPRT_PJT_NO,
			OPEN_YN: selectedOPEN_YN,
			CREATE_ID : "${sessionScope.userInfo.userId}",
			UPDATE_ID : "${sessionScope.userInfo.userId}",
			REGISTER_MNGER:selectedREGISTER_MNGER, //INDEX값으로 0을 쓰는 것은 과정관리페이지 특성상, 하나의 프로젝트를 참조하여 열리기 때문에 dataProvider의 0번째 row는 참조하는 프로젝트이므로 0으로 고정해도 됨
			PJT_MNGER:selectedPJT_MNGER,
			START_DATE: selectedSTART_DATE,
			CLOSE_DATE: selectedCLOSE_DATE,
			DIV_CD:selectedDIV_CD,
			TEAM_CD:selectedTEAM_CD,
			PJT_STATUS_CD:selectedPJT_STATUS_CD
			//과정관리 추가  페이지의 경우, 이미 프로젝트를 선택하여 들어온 페이지이므로, 참조하는 프로젝트의 필드값을 바로 불러와 추가하는 것이 나을 것 같다
	};			

			var TODAY = new Date();
			setCols.REG_DATE = TODAY.format('yyyy-mm-dd');
			dataProvider.insertRow(0, setCols);
			
			
}

function fn_reset(){
	
	grdMain.cancel();
	dataProvider.rollback(dataProvider.getSavePoints()[0]);
	
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
		if (opener && opener.fn_popupCallback) {
			opener.fn_popupCallback();
		}
	}
}


function fn_del(){
	

	var rows = grdMain.getCheckedRows();
	var deleteValidationArray = [];
	
	//삭제할 대상을 선택하지 않은체, 삭제버튼을 누른 경우,
	if(rows.length==0){
		alert('<spring:message code="msg.deleteTargetNotSelected"/>');
		return false;
		
	}
	else
	{
		// 삭제 권한이 있는 것:removeRows(rows, false) 처리    meetingNote.meetingNoteGrid.dataProvider.removeRows(rows, false);
		// 삭제 권한이 없는 것:checkItem(v, false)처리 및 배열에 담아 alert을 통해 권한 없는 정보 알림
		
		$.each(rows,function (n,v) {
			
				deleteValidationArray.push(v);
		});
		
		dataProvider.removeRows(deleteValidationArray, false);
	    	
	}
	
	
}

function fn_PROJECT_SUB_NO_VALIDATION(PROJECT_SUB_NO){
	
    BREAKING_LIMIT_SEARCH = {};
    
    
    BREAKING_LIMIT_SEARCH.PROJECT_SUB_NO = PROJECT_SUB_NO;
    BREAKING_LIMIT_SEARCH.sql      = 'N';
    BREAKING_LIMIT_SEARCH._mtd     = "getList";
    BREAKING_LIMIT_SEARCH.tranData = [{outDs:"rtnList",_siq:"snop.meetingMng.breakingLimitPKValidation"}];
   
   
    return new Promise(function(resolve,reject){    gfn_service({
            
            
            url    : GV_CONTEXT_PATH + "/biz/obj.do",
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
		<div class="pop_tit"><spring:message code="lbl.processMngReg"/></div>
		<div class="popCont">
			
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