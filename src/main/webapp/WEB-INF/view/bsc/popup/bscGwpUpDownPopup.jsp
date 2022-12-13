<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
	<jsp:param name="popupYn" value="Y"/>
</jsp:include>

<script type="text/javascript">
var popupWidth, popupHeight;
var gridInstance, grdMain, dataProvider;
var fileNo;
var codeMap = {};

$(window).resize(function() {
	gfn_popresizeSub();
}).resize();

$("document").ready(function () {
	gfn_popresize();
	getCode();
	fn_init();
	fn_initGrid();
	fn_getFileNo();
	fn_getGridData();
	fn_initEvent(); //이벤트 정의
});

//FILE_NO 가져오기
function fn_getFileNo(){
	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
	FORM_SEARCH._mtd = "getList";
	FORM_SEARCH.tranData = [{outDs:"rtnList",_siq:"bsc.popup.gwpFileNo"}];
	
	var sMap = {
        url: "${ctx}/biz/obj",
        data: FORM_SEARCH,
        success:function(data) {
        	$("#FILE_NO").val(data.rtnList);
        }
    }
    gfn_service(sMap,"obj");
}

function getCode(){
	gfn_service({
	    async   : false,
	    url     : GV_CONTEXT_PATH + "/biz/obj",
	    data    : {
	    	_mtd     :"getList",
	    	tranData : [
	    		{outDs:"codeList",_siq:"bsc.popup.code"}
	    	]
	    },
	    success :function(data) {
	    	
	    	for(var i = 0; i < 2; i++){
	    		var temp = [];
	    		$.each(data.codeList, function(n, v) {
	    			if(i == 0 && n == 0){
	    				temp.push({CODE_CD : "", CODE_NM : "ALL"});
	    				temp.push({CODE_CD : v.CD, CODE_NM : v.NM});
	    			}else{
	    				temp.push({CODE_CD : v.CD, CODE_NM : v.NM});	
	    			}
				});
	    		
	    		if(i == 0){
	    			codeMap.CODE = temp;	
	    		}else{
	    			codeMap.CODE_SELECT = temp;
	    		}
	    	}
	    }
	}, "obj");
	gfn_setMsCombo("kpiIdCode", codeMap.CODE, [], {width:"130px"} );
}

function fn_init() {
	var dateParam = {
   		arrTarget : [
 				{calId : "fromDate", validType : "from", validId : "toDate", defVal : 0},
 				{calId : "toDate", validType : "to", validId : "fromDate", defVal : 0},
 			]
   	};
    DATEPICKET(dateParam);
}

//이벤트 정의
function fn_initEvent() {
	$("#btnClose").on("click", function() { window.close(); });
	$("#btnSave").click(fn_save);
	$("#btnAdd").click(fn_add);
	$("#btnDel").click(fn_del);
	$("#btnSearch").click(fn_getGridData);
	$("#btnDown").on("click", function() {fn_fileDown();});
	
}

function fn_add() {
	
	//생성전 파일이 선택되지 않은 input 태그 삭제 처리
	$("#fileFrm").find('input[type="file"]').each(function(n,v) {
		if (gfn_isNull($(v).val())) $(v).remove();
	});
	
	//파일 input 생성
	var inputId = "file"+dataProvider.getRowCount();
	$("#fileFrm").append('<input type="file" name="file" id="'+inputId+'" style="display:none;" onChange="fn_fileChange(this);"/>');
	
   	$("#"+inputId).trigger("click");
}

function fn_fileChange(_this) {
	var fileValue = $(_this).val().split("\\");
	var tmpFileNm = fileValue[fileValue.length-1]; // 파일명
	var extension = tmpFileNm.substring(tmpFileNm.lastIndexOf(".")+1,tmpFileNm.length);
	if(extension.toLowerCase().search("exe") > -1) {
		alert("exe 파일은 업로드 불가능합니다.");
		//삭제
		$(_this).remove();
		return false;
	}
	
	grdMain.commit();
    var values = {INPUT_ID : _this.id, FILE_NM_ORG : tmpFileNm, KPI_ID : codeMap.CODE_SELECT[0].CODE_CD, ROW_BIZ_YN : "Y"};
   	dataProvider.addRow(values);
}

function fn_del() {
	var rows = grdMain.getCheckedRows();
	fn_removeRow(rows);
}

function fn_removeRow(rows) {
	//input file 제거
	var inputId;
	$.each(rows, function(n,v) {
		inputId = dataProvider.getValue(v,"INPUT_ID");
		$("#"+inputId).remove();
	});
	
	//실데이터 삭제
	dataProvider.removeRows(rows);
}

//그리드를 그린다.
function fn_initGrid() {
	//변수처리
	gridInstance = new GRID();
	gridInstance.init("realgrid");
	grdMain = gridInstance.objGrid;
	dataProvider = gridInstance.objData;

    fn_setFields(dataProvider); //set fields
    fn_setColumns(grdMain); // set columns
    fn_setOptions(grdMain);
    
  	//row 상태에따른 컬럼 속성정의
    grdMain.onCurrentRowChanged = function (grid, oldRow, newRow) {
   		var editable = (newRow < 0 || dataProvider.getRowState(newRow) === "created");
   		grid.setColumnProperty("KPI_ID", "editable", editable);
   	};
    
    grdMain.onDataCellDblClicked =  function (grid, index) {
    	if(index.fieldName == "FILE_NM_ORG") {
    		fn_fileDown(index.itemIndex+"");
   		}
    }
}

function fn_setOptions(grd) {
    grd.setOptions({
        checkBar: { visible: true, showAll:true },
        stateBar: { visible: true },
        sorting : { enabled: false}
        //edit    : { insertable: true, appendable: true, updatable: true, editable: false, deletable: true},
    });
}

function fn_setFields(provider) {
	//필드 배열 객체를  생성합니다.
    var fields = [
        {fieldName: "KPI_ID"},
        {fieldName: "FILE_NO"},
        {fieldName: "FILE_SEQ"},
        {fieldName: "FILE_NM"},
        {fieldName: "FILE_NM_ORG"},
        {fieldName: "CREATE_DTTM"},
        {fieldName: "INPUT_ID"},
        {fieldName: "ROW_BIZ_YN"},
    ];
    dataProvider.setFields(fields);
}

function fn_setColumns(tree) {
	//필드와 연결된 컬럼 배열 객체를 생성합니다.
    var columns = [
    	{
			 
    		name: "KPI_ID",
            fieldName: "KPI_ID",
            editable: false,
            header: {text: '<spring:message code="Type"/>'},
            styles: {textAlignment: "near", background : gv_noneEditColor, lineAlignment: "near", paddingTop:4},
            dynamicStyles: [{
                criteria: ["state<>'c'","state='c'"],
                styles: ["background="+gv_noneEditColor,"background="+gv_requiredColor]
            }],
            width: 100,
            editor: {
                type: "dropDown",
                domainOnly: true,
            }, 
            values: gfn_getArrayExceptInDs(codeMap.CODE_SELECT, "CODE_CD", ""),
            labels: gfn_getArrayExceptInDs(codeMap.CODE_SELECT, "CODE_NM", ""),
            lookupDisplay: true,
            nanText : "",
            editButtonVisibility: "visible",
    	},
        {name: "FILE_NM_ORG", editable: false, fieldName: "FILE_NM_ORG", header: {text: '<spring:message code="lbl.file"/>'}, styles: {textAlignment: "near"}, width: 250 },
		{name: "CREATE_DTTM", editable: false, fieldName: "CREATE_DTTM", header: {text: '<spring:message code="lbl.createDttm"/>'}, styles: {textAlignment: "near"}, width: 120 }
    ];
    grdMain.setColumns(columns);
}

//그리드 데이터 조회
function fn_getGridData() {
	
	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
	FORM_SEARCH._mtd = "getList";
	FORM_SEARCH.tranData = [{outDs:"rtnList",_siq:"bsc.popup.gwpFileList"}];
	
	var sMap = {
        url: "${ctx}/biz/obj",
        data: FORM_SEARCH,
        success:function(data) {
        	
        	dataProvider.clearRows(); //데이터 초기화
        	
	    	//그리드 데이터 생성
	    	grdMain.cancel();
			var grdData = data.rtnList;
			var grdDataLen = grdData.length;
			dataProvider.setRows(grdData);
        }
    }
    gfn_service(sMap,"obj");
}

//저장
function fn_save() {
	
	//수정된 그리드 데이터만 가져온다.
	var grdData = gfn_getGrdSavedataAll(grdMain);
	if (grdData.length == 0) {
		alert('<spring:message code="msg.noChangeData"/>');
		return;
	}
	
	var kpiIdSeq = [];
	$.each(grdData, function(n,v) {
		if (v.state != "deleted") {
			kpiIdSeq.push(v.KPI_ID);
		}
	});
	$("#KPI_ID_SEQ").val(kpiIdSeq.join("||"));
	
	//삭제된 파일 처리
	var arrDelSeq = [];
	$.each(grdData, function(n,v) {
		if (v.state == "deleted") {
			arrDelSeq.push(v.FILE_SEQ);
		}
	});
	$("#DEL_FILE_SEQ").val(arrDelSeq.join("||"));
	
	confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
		$("#fileFrm").ajaxSubmit({
			dataType: 'json',
			success : function(data) {
				gfn_unblockUI();
				
				if (data.errCode == -1) {
					alert(data.errMsg);
					return;
				}
				
				alert('<spring:message code="msg.saveOk"/>', function() {
					if("${param.callback}" != "" && "${param.callback}" != null) {
						var fileNm = "";
						for (var i=0; i<dataProvider.getRowCount(); i++) {
							if (dataProvider.getRowState(i) == "deleted" || dataProvider.getRowState(i) == "createAndDeleted") continue;
							fileNm = dataProvider.getValue(i ,"FILE_NM_ORG");
							break;
						}
						eval("opener.${param.callback}")(data.FILE_NO,fileNm);
					}
					window.close();
				});
			},
			error : function(a) {
				gfn_unblockUI();
			}
		});
	});
}

function fn_fileDown(dbRow) {
		//수정된 그리드 데이터만 가져온다.
	var rows = grdMain.getCheckedRows();
	if (!gfn_isNull(dbRow)) rows = [dbRow];
	
	if (rows.length == 0) {
		alert(gfn_getDomainMsg("msg.noDownData"));
		return;
	}
	
	var rowState = "";
	var chkRow = true;
	var arrFileSeq = [];
	$.each(rows, function(n,v) {
		rowState = dataProvider.getRowState(v);
    	if(rowState == "created" || rowState == "createAndDeleted") {
    		chkRow = false;
    		return false;
   		}
    	arrFileSeq.push(dataProvider.getValue(v, "FILE_SEQ"));
	});
	
	if (!chkRow) {
		alert(gfn_getDomainMsg("msg.unSavedFile"));
		return;
	} 
	
	gfn_fileDown(dataProvider.getValue(rows[0],"FILE_NO"), arrFileSeq);  		
}

</script>

</head>
<body>
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="keywordpop" class="popupDv">
		<div class="pop_tit">${param.popupTitle}</div>
		
		<div class="popCont">
			<div class="srhwrap">
				<form id="searchForm" name="searchForm" method="POST" onSubmit="return false;">
					<div class="srhcondi">
						<ul>
							<li>
								<strong><spring:message code="Type Filter"/></strong>
								<div class="selectBox">
									<select id="kpiIdCode" name="kpiIdCode" class="iptcombo"></select>
								</div>	
							</li>
						</ul>
						<ul>
							<li>
								<strong><spring:message code="등록일자"/></strong>
								<div class="ilist" style="width:400px">
									<input type="text" id="fromDate" name="fromDate" class="iptdate datepicker2"> <span class="ihpen">~</span>
									<input type="text" id="toDate" name="toDate" class="iptdate datepicker2">
								</div>
							</li>
						</ul>
					</div>
				</form>
			</div>
			<div id="realgrid" class="realgrid1"></div>
			<div class="pop_btn">
				<a href="#" id="btnSearch" class="pbtn pApply"><spring:message code="lbl.search"/></a>
				<a href="#" id="btnDown" class="pbtn pApply"><spring:message code="lbl.download"/></a>
				<a href="#" id="btnDel" class="pbtn pApply"><spring:message code="lbl.delete"/></a>
				<a href="#" id="btnAdd" class="pbtn pApply"><spring:message code="lbl.add"/></a>
				<a href="#" id="btnSave" class="pbtn pApply"><spring:message code="lbl.save"/></a>
				<a href="#" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
			</div>
		</div>
	</div>
	<form id="fileFrm" method="post" enctype="multipart/form-data" action="${ctx}/file/upload" >
		<input type="hidden" id="DEL_FILE_SEQ" name="DEL_FILE_SEQ" value="" />
		<input type="hidden" id="ROW_BIZ_YN" name="ROW_BIZ_YN" value="Y" />
		<input type="hidden" id="KPI_ID_SEQ" name="KPI_ID_SEQ" value="" />
		<input type="hidden" id="FILE_NO" name="FILE_NO" value="" />
		<c:forEach var="item" items="${param}">
		<input type="hidden" id="${item.key}" name="${item.key}" value="${item.value}" />
		</c:forEach>
	</form>
</body>
</html>