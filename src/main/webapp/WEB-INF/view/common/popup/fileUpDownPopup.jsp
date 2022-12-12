<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
	<jsp:param name="popupYn" value="Y"/>
</jsp:include>
<style type="text/css">

 .popupDv{
 
 	transition: all .15s ease-in-out;
 
 }


</style>
<script type="text/javascript">
var popupWidth, popupHeight;
var gridInstance, grdMain, dataProvider;
var fileNo;
$("document").ready(function () {
	gfn_popresize();
	fn_init();
	fn_initGrid();
	fn_apply();
	fn_initEvent(); //이벤트 정의
	
	$('.popupDv')
	  .on("dragover", dragOver)
	  .on("dragleave", dragOver)
	  .on("drop", uploadFiles);
	
	
});

function dragOver(e){
    e.stopPropagation();
    e.preventDefault();
    if (e.type == "dragover") {
        $(e.target).css({
            "background-color": "white"

        });
    } else {
        $(e.target).css({
            "background-color": "white"

        });
    }
}

function uploadFiles(e) {
    e.stopPropagation();
    e.preventDefault();
    dragOver(e);
  
    e.dataTransfer = e.originalEvent.dataTransfer;
    var files = e.target.files || e.dataTransfer.files;
    
    var inputId = "file"+dataProvider.getRowCount();
    
    $("#fileFrm").append('<input multiple="multiple" type="file" name="file" id="'+inputId+'" style="display:none;" />');
    
    
    for (var i = 0; i < files.length; i++)
	{
		
		var tmpFileNm = files[i].name; // 파일명
		var extension = tmpFileNm.substring(tmpFileNm.lastIndexOf(".")+1,tmpFileNm.length);
		if(extension.toLowerCase().search("exe") > -1) {
			alert('<spring:message code="msg.extFileUploadCheck" arguments="exe"/>');
			//삭제
			$('#'+inputId).remove();
			return false;
		}
		
		grdMain.commit();
	    var values = {INPUT_ID : inputId, FILE_NM_ORG : tmpFileNm};
	   	dataProvider.addRow(values);
	   	
	}
    $('#'+inputId).prop('files',files)
}


$(window).resize(function() {
	gfn_popresizeSub();
}).resize();

function fn_init() {
	fileNo = "${param.FILE_NO}";
	if (gfn_isNull(fileNo)) {
		fileNo = "";
		$("#FILE_NO").val("");
	}
}

//이벤트 정의
function fn_initEvent() {
	$("#btnClose").on("click", function() { window.close(); });
	$("#btnSave").click(fn_save);
	$("#btnAdd").click(fn_add);
	$("#btnDel").click(fn_del);
	$("#btnDown").on("click", function() {fn_fileDown();});
}

function fn_apply() {
	
	if (gfn_isNull(fileNo)) return;
	
	fn_getGridData();
}

function fn_add() {
	
	//생성전 파일이 선택되지 않은 input 태그 삭제 처리
	$("#fileFrm").find('input[type="file"]').each(function(n,v) {
		if (gfn_isNull($(v).val())) $(v).remove();
	});
	
	//파일 input 생성
	var inputId = "file"+dataProvider.getRowCount();
	$("#fileFrm").append('<input multiple="multiple" type="file" name="file" id="'+inputId+'" style="display:none;" onChange="fn_fileChange(this);"/>');
	
   	$("#"+inputId).trigger("click");
   	
	
}


function fn_fileChange(_this) {
	//$("#my-input")[0].files;
	
	
	for (var i = 0; i < $("#"+_this.id)[0].files.length; i++)
	{
	
		var tmpFileNm = $("#"+_this.id)[0].files[i].name; // 파일명
		var extension = tmpFileNm.substring(tmpFileNm.lastIndexOf(".")+1,tmpFileNm.length);
		if(extension.toLowerCase().search("exe") > -1) {
			alert('<spring:message code="msg.extFileUploadCheck" arguments="exe"/>');
			//삭제
			$(_this).remove();
			return false;
		}
		
		grdMain.commit();
	    var values = {INPUT_ID : _this.id, FILE_NM_ORG : tmpFileNm};
	   	dataProvider.addRow(values);
	   	
	}   	
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
        sorting : { enabled: false},
        edit    : { insertable: true, appendable: true, updatable: true, editable: false, deletable: true},
    });
}

function fn_setFields(provider) {
	//필드 배열 객체를  생성합니다.
    var fields = [
        {fieldName: "FILE_NO"},
        {fieldName: "FILE_SEQ"},
        {fieldName: "FILE_NM"},
        {fieldName: "FILE_NM_ORG"},
        {fieldName: "CREATE_DTTM"},
        {fieldName: "INPUT_ID"},
    ];
    dataProvider.setFields(fields);
}

function fn_setColumns(tree) {
	//필드와 연결된 컬럼 배열 객체를 생성합니다.
    var columns = [
        {name: "FILE_NM_ORG" ,fieldName: "FILE_NM_ORG" ,header: {text: '<spring:message code="lbl.file"/>'      }, styles: {textAlignment: "near"}, width: 250 },
		{name: "CREATE_DTTM" ,fieldName: "CREATE_DTTM" ,header: {text: '<spring:message code="lbl.createDttm"/>'}, styles: {textAlignment: "near"}, width: 120 },
    ];
    grdMain.setColumns(columns);
}

//그리드 데이터 조회
function fn_getGridData() {
	FORM_SEARCH.FILE_NO = fileNo;
	FORM_SEARCH._mtd = "getList";
	FORM_SEARCH.tranData = [{outDs:"rtnList",_siq:"common.file"}];
	var sMap = {
        url: "${ctx}/biz/obj.do",
        data: FORM_SEARCH,
        success:function(data) {
        	dataProvider.clearRows(); //데이터 초기화
        	
	    	//그리드 데이터 생성
	    	grdMain.cancel();
			var grdData = data.rtnList;
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
		alert('<spring:message code="msg.noDownData"/>');
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
		alert('<spring:message code="msg.unSavedFile"/>');
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
			<div id="realgrid" class="realgrid1"></div>
			<div class="pop_btn">
				<a href="#" id="btnDown" class="pbtn pApply"><spring:message code="lbl.download"/></a>
				<c:if test="${param.AUTHORITY_YN != 'N' }">
				<a href="#" id="btnDel" class="pbtn pApply"><spring:message code="lbl.delete"/></a>
				<a href="#" id="btnAdd" class="pbtn pApply"><spring:message code="lbl.add"/></a>
				<a href="#" id="btnSave" class="pbtn pApply"><spring:message code="lbl.save"/></a>
				</c:if>
				<a href="#" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
			</div>
		</div>		
	</div>
	<form id="fileFrm" method="post" enctype="multipart/form-data" action="${ctx}/file/upload.do" >
		<input type="hidden" id="DEL_FILE_SEQ" name="DEL_FILE_SEQ" value="" />
		<c:forEach var="item" items="${param}">
		<input type="hidden" id="${item.key}" name="${item.key}" value="${item.value}" />
		</c:forEach>
	</form>
</body>
</html>