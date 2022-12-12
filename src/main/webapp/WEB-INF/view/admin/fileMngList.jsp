<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>

	<script type="text/javascript">
  	//전역변수 설정
  	var gridInstance, grdMain, dataProvider;
  	var gridInstanceFile, grdFile, dataProviderFile;
  	
    //초기설정
    $(function() {
    	gfn_formLoad(); //공통 폼 초기 정보 설정
    	fn_init();
    	fn_initGrid(); //그리드를 그린다.
    	fn_initEvent(); //이벤트 정의
    });
    
    //공통코드 조회
    function fn_init() {}
    
  	//그리드를 그린다.
    function fn_initGrid() {
    	//그리드 1 ------------------------
    	gridInstance = new GRID();
    	gridInstance.treeInit("realgrid");
    	grdMain = gridInstance.objGrid;
    	dataProvider = gridInstance.objData;
    	
        fn_setFields(dataProvider,"L"); //set fields
        fn_setColumns(grdMain,"L"); // set columns
        fn_setOptions(grdMain,"L"); // set options

        //그리드 2 ------------------------
    	gridInstanceFile = new GRID();
    	gridInstanceFile.init("realgridSub");
    	grdFile = gridInstanceFile.objGrid;
    	dataProviderFile = gridInstanceFile.objData;
    	
        fn_setFields(dataProviderFile,"R"); //set fields
        fn_setColumns(grdFile,"R"); // set columns
        fn_setOptions(grdFile,"R"); // set options
        
		//row 상태에따른 컬럼 속성정의
        grdMain.onCurrentRowChanged = function (grid, oldRow, newRow) {
       		var editable = (newRow < 0 || dataProvider.getRowState(newRow) === "created");
       		grid.setColumnProperty("PATH_NM" ,"editable",editable);
       		
       		fn_getFile(newRow); //데이터 체크 처리
       	};
       	
       	grdFile.onDataCellDblClicked =  function (grid, index) {
        	if(index.fieldName == "FILE_NM_ORG") {
        		fn_fileDown(index.itemIndex+"");
       		}
        }
    }
  
  	//이벤트 정의
    function fn_initEvent() {
    	$("#btnSearch").click("on", function() { fn_apply(); });
    	$("#btnSaveFile").click("on", function() { fn_saveFile(); });
    	$("#btnAddFile").on("click", function() { fn_addFile(); });
    	$("#btnDelFile").click(fn_delFile);
    	$("#btnDownFile").on("click", function() {fn_fileDown();});
    	
    	$("#btnAddRootPath").on("click", function() { fn_add(-1); });
    	$("#btnAddPath").on("click", function() { fn_add(); });
    	$("#btnDelPath").click(fn_del);
    	$("#btnSavePath").click(fn_savePath);
    }
    
    //조회
    function fn_apply(sqlFlag) {
    	//조회조건 설정
    	FORM_SEARCH = {}; //초기화
    	FORM_SEARCH.sql = sqlFlag;
    	fn_getGridData(); //메인 데이터를 조회
    }
    
	//provider 필드 설정
    function fn_setFields(provider,grdType) {
    	//필드 배열 객체를  생성합니다.
    	var fields;
    	if (grdType == "L") {
	        fields = [
	            {fieldName: "COMPANY_CD"},
	            {fieldName: "BU_CD"},
	            {fieldName: "TREE_PATH"},
	            {fieldName: "PATH_LVL"},
	            {fieldName: "PATH_ID"},
	            {fieldName: "PATH_NM"},
	            {fieldName: "UPPER_PATH_NM"},
	            {fieldName: "SORT"},
	            {fieldName: "FILE_NO"},
	        ];
    	} else {
    		fields = [
	            {fieldName: "INPUT_ID"},
	            {fieldName: "FILE_NO"},
	            {fieldName: "FILE_SEQ"},
	            {fieldName: "FILE_NM"},
	            {fieldName: "FILE_NM_ORG"},
	            {fieldName: "CREATE_ID"},
	            {fieldName: "CREATE_DTTM"},
	        ];
    	}
        provider.setFields(fields);
    }
    
	//그리드 컬럼설정
    function fn_setColumns(grd,grdType) {
    	//필드와 연결된 컬럼 배열 객체를 생성합니다.
    	var columns;
    	if (grdType == "L") {
	        columns = [
	        	{name: "PATH_NM" ,fieldName: "PATH_NM" ,header: {text: '<spring:message code="lbl.path"/>'} ,styles: {textAlignment: "near",background:gv_requiredColor} ,width: 300,
        		dynamicStyles: [{
                    criteria: ["state<>'c'","state='c'"],
                    styles: ["background="+gv_noneEditColor,"background="+gv_requiredColor]
                }]},
	        	{name: "SORT"    ,fieldName: "SORT"    ,header: {text: '<spring:message code="lbl.sort"/>'  } ,styles: {textAlignment: "far" ,background:gv_requiredColor} ,width: 30  ,editor: {type: "number",maxLength: 3,}},
	        ];
    	} else {
    		columns = [
    			{name: "FILE_NM_ORG" ,fieldName: "FILE_NM_ORG" ,header: {text: '<spring:message code="lbl.file"/>'      }, styles: {textAlignment: "near"}, width: 250 },
    			{name: "CREATE_DTTM" ,fieldName: "CREATE_DTTM" ,header: {text: '<spring:message code="lbl.createDttm"/>'}, styles: {textAlignment: "near"}, width: 120 },
	        ];
    	}
        grd.setColumns(columns);
    }
	
    //그리드 옵션
    function fn_setOptions(grd,grdType) {
    	var options;
    	var options = {
            checkBar: { visible  : true },
	        stateBar: { visible  : true },
	        edit    : { editable : grdType == "L" ? true : false}
        };
		grd.setOptions(options);
    }
    
    //그리드 데이터 조회
    function fn_getGridData() {
    	FORM_SEARCH._mtd   = "getList";
    	FORM_SEARCH.tranData = [{outDs:"rtnList",_siq:"admin.fileMng"}];
    	var sMap = {
   			url: "${ctx}/biz/obj.do",
            data: FORM_SEARCH,
            success:function(data) {
            	dataProvider.clearRows(); //데이터 초기화
				dataProvider.setRows(data.rtnList, "TREE_PATH", false);
				
				dataProvider.clearSavePoints();
				dataProvider.savePoint(); //초기화 포인트 저장
				
				gfn_setSearchRow(dataProvider.getRowCount());
            },
        }
        gfn_service(sMap,"obj");
    }
    
    //행추가
    function fn_add(type) {
    	var current = grdMain.getCurrent();
        var row = current.dataRow;
        var addVal = {};
        if (type == -1) {
        	var rows = dataProvider.getJsonRows(-1, true, "child", "icon");
        	addVal.PATH_LVL = 1;
        	dataProvider.addChildRow(-1, addVal, 0);
        } else {
        	addVal.UPPER_PATH_NM = dataProvider.getValue(row,"PATH_NM");
        	addVal.PATH_LVL = dataProvider.getLevel(row)+1;
	        var child = dataProvider.addChildRow(row, addVal, 0);
	        grdMain.expand(grdMain.getItemIndex(row));
        }
    }

    //삭제
    function fn_del() {
    	var rows = grdMain.getCheckedRows();
    	dataProvider.removeRows(rows, false);
    }
    
    //path 저장
    function fn_savePath() {
    	//그기드 유효성 검사
    	var arrColumn = ["PATH_NM","SORT"];
    	if (!gfn_getValidation(gridInstance,arrColumn)) return;
    	
    	//수정된 그리드 데이터만 가져온다.
		var grdData = gfn_getGrdSavedataAll(grdMain);
    	if (grdData.length == 0) {
    		alert('<spring:message code="msg.noChangeData"/>');  //변경된 데이터가 없습니다.
			return;
    	}
    	
    	//수정된 행에 상위코드를 맵핑한다.
    	var arrAllRowId = dataProvider.getDescendants();
    	var pRowId;
    	$.each(arrAllRowId, function(n,v) {
    		if (dataProvider.getRowState(v) != "created") return true; //skip
    		
    		pRowId = dataProvider.getParent(v);
    		if (!gfn_isNull(pRowId)) {
    			dataProvider.setValue(v, "UPPER_PATH_NM", dataProvider.getValue(pRowId, "PATH_NM"));
    		}
    	});
    	
    	confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
    		//저장
    		var FORM_SAVE = {};
    		FORM_SAVE._mtd   = "saveAll";
    		FORM_SAVE.tranData = [{outDs:"saveCnt",_siq:"admin.fileMng", grdData : grdData}];
    		var serviceMap = {
    			url: "${ctx}/biz/obj.do",
                data: FORM_SAVE,
                success:function(data) {
                	alert('<spring:message code="msg.saveOk"/>');
                	fn_apply();
                }
            }
    		gfn_service(serviceMap, "obj");
    	});
    }
    
  	//행추가
    function fn_addFile() {
  		
    	var dIdx = grdMain.getCurrent().dataRow;
    	if (dIdx < 0) return;
    	
    	//생성전 파일이 선택되지 않은 input 태그 삭제 처리
    	$("#fileFrm").find('input[type="file"]').each(function(n,v) {
    		if (gfn_isNull($(v).val())) $(v).remove();
    	});
    	
    	//파일 input 생성
    	var inputId = "file"+dataProviderFile.getRowCount();
    	$("#fileFrm").append('<input type="file" name="file" id="'+inputId+'" style="display:none;" onChange="fn_fileChange(this);"/>');
    	
       	$("#"+inputId).trigger("click");
    }
  	
    function fn_fileChange(_this) {
    	var fileValue = $(_this).val().split("\\");
    	var tmpFileNm = fileValue[fileValue.length-1]; // 파일명
    	var extension = tmpFileNm.substring(tmpFileNm.lastIndexOf(".")+1,tmpFileNm.length);
    	if (extension.toLowerCase().search("exe") > -1) {
    		alert("exe 파일은 업로드 불가능합니다.");
    		//삭제
    		$(_this).remove();
    		return false;
    	} else  if (gfn_isNull($(_this).val())) {
    		return false;
    	}
    	
    	grdFile.commit();
        var values = {INPUT_ID : _this.id, FILE_NM_ORG : tmpFileNm};
       	dataProviderFile.addRow(values);
    }

    //삭제
    function fn_delFile() {
    	var rows = grdFile.getCheckedRows();
    	fn_removeRow(rows);
    }
    
    function fn_removeRow(rows) {
    	//input file 제거
    	var inputId;
    	$.each(rows, function(n,v) {
    		inputId = dataProviderFile.getValue(v,"INPUT_ID");
    		$("#"+inputId).remove();
    	});
    	
    	//실데이터 삭제
    	dataProviderFile.removeRows(rows);
    }
    
  	//저장
    function fn_saveFile() {
    	//수정된 그리드 데이터만 가져온다.
    	var grdData = gfn_getGrdSavedataAll(grdFile);
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
    					var current = grdMain.getCurrent();
    			        var row = current.dataRow;
    					var rowState = dataProvider.getRowState(row);
    			        dataProvider.setValue(row, "FILE_NO", data.FILE_NO);
    			        dataProvider.setRowState(row, rowState);
    			        
    					fn_getFile(row);
    				});
    			},
    			error : function(a) {
    				gfn_unblockUI();
    			}
    		});
    	});
    }
  	
  	function fn_getFile(idx) {
  		var pathId = dataProvider.getValue(idx, "PATH_ID");
  		var fileNo = dataProvider.getValue(idx, "FILE_NO");
  		
  		//초기화
  		//file grid
  		dataProviderFile.clearRows();
  		
  		//생성전 파일이 선택되지 않은 input 태그 삭제 처리
    	$("#fileFrm").find('input[type="file"]').each(function(n,v) {
    		$(v).remove();
    	});
  		
  		$("#DEL_FILE_SEQ").val("");
  		$("#PATH_ID").val(pathId);
  		$("#FILE_NO").val(fileNo);
  		
  		if (gfn_isNull(fileNo)) return;
  		
  		var params = {};
  		params.FILE_NO = fileNo;
  		params._mtd = "getList";
  		params.tranData = [{outDs:"rtnList",_siq:"common.file"}];
  		var sMap = {
  	        url: "${ctx}/biz/obj.do",
  	        data: params,
  	        success:function(data) {
  	        	//dataProviderFile.clearRows(); //데이터 초기화
  	        	
  		    	//그리드 데이터 생성
  		    	grdFile.cancel();
  				var grdData = data.rtnList;
  				dataProviderFile.setRows(grdData);
  	        }
  	    }
  	    gfn_service(sMap,"obj");
  	}
  	
  	function fn_fileDown(dbRow) {
  		//수정된 그리드 데이터만 가져온다.
		var rows = grdFile.getCheckedRows();
		if (!gfn_isNull(dbRow)) rows = [dbRow];
		
		if (rows.length == 0) {
			alert(gfn_getDomainMsg("msg.noDownData"));
			return;
		}
		
		var rowState = "";
		var chkRow = true;
		var arrFileSeq = [];
		$.each(rows, function(n,v) {
			rowState = dataProviderFile.getRowState(v);
	    	if(rowState == "created" || rowState == "createAndDeleted") {
	    		chkRow = false;
	    		return false;
	   		}
	    	
	    	arrFileSeq.push(dataProviderFile.getValue(v, "FILE_SEQ"));
		});
		
		if (!chkRow) {
			alert(gfn_getDomainMsg("msg.unSavedFile"));
			return;
		} 
		
		gfn_fileDown(dataProviderFile.getValue(rows[0],"FILE_NO"), arrFileSeq);  		
  	}
  	
    </script>

</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<!-- contents -->
	<div id="grid1" class="fconbox">
		<%@ include file="/WEB-INF/view/common/commonLocation.jsp" %>
		
		<!-- 조회조건 -->
		<div class="srhwrap">
			<form id="searchForm" name="searchForm" method="POST" onSubmit="return false;">
			<div class="srhcondi">
				<ul>
					<li>
						<strong>expandAll</strong>
						<ul class="rdofl" style="min-width:120px">
							<li><input type="checkbox" id="chkExpandAll" name="chkExpandAll"> <label for="chkExpandAll"></label></li>
						</ul>
					</li>
				</ul>
			</div>
			</form>

			<div class="bt_btn">
				<a id="btnSearch" href="#" class="fl_app"><spring:message code="lbl.search"/></a>
			</div>
		</div>
		
		<form id="fileFrm" method="post" enctype="multipart/form-data" action="${ctx}/file/upload.do" >
			<input type="hidden" id="DEL_FILE_SEQ" name="DEL_FILE_SEQ" value="" />
			<input type="hidden" id="PATH_ID" name="PATH_ID" value="" />
			<input type="hidden" id="FILE_NO" name="FILE_NO" value="" />
			<input type="hidden" id="_siq" name="_siq" value="admin.fileMngFileNo" />
		</form>
		
		<div class="scroll" style="width:100%">
			<div style="float: left;width:100%;overflow:hidden;">
				<!-- 왼쪽 그리드 -->
				<div style="width:50%;float:left;">
					<div class="use_tit">
						<h3><spring:message code="lbl.filePath"/></h3> <h4></h4>
					</div>
					<div id="realgrid" class="realgrid1" style="width: 100%; float: left;"></div>
					<div class="grid_btn roleWrite">
					<a id="btnAddRootPath" href="#" onclick="return false;" class="app1"><spring:message code="lbl.rootAdd"/></a>
					<a id="btnAddPath" href="#" onclick="return false;" class="app1"><spring:message code="lbl.add"/></a>
					<a id="btnDelPath" href="#" onclick="return false;" class="app1"><spring:message code="lbl.delete"/></a>
					<a id="btnSavePath" href="#" onclick="return false;" class="app2"><spring:message code="lbl.save"/></a>
					</div>
				</div>
				
				<!-- 오른쪽 그리드 -->
				<div style="padding-left:10px;width:calc(50% - 15px);float:left;">
					<div class="use_tit">
						<h3><spring:message code="lbl.file"/></h3> <h4></h4>
					</div>
					<div id="realgridSub" class="realgrid1" style="width:100%; float: left;"></div>
					<div class="grid_btn roleWrite">
					<a id="btnAddFile"  href="#" onclick="return false;" class="app1"><spring:message code="lbl.add"/></a>
					<a id="btnDelFile"  href="#" onclick="return false;" class="app1"><spring:message code="lbl.delete"/></a>
					<a id="btnDownFile" href="#" onclick="return false;" class="app2"><spring:message code="lbl.download"/></a>
					<a id="btnSaveFile" href="#" onclick="return false;" class="app2"><spring:message code="lbl.save"/></a>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
