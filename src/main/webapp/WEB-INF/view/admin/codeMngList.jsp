<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	
	<script type="text/javascript">
  	//전역변수 설정
  	var gridInstance, grdMain, dataProvider;
  	var codeMap;
  	var enterSearchFlag = "Y";
    //초기설정
    $(function() {
    	gfn_formLoad(); //공통 폼 초기 정보 설정
    	fn_initCode(); //공통코드 조회
    	fn_initGrid(); //그리드를 그린다.
    	fn_initEvent(); //이벤트 정의
    });
    
    function fn_checkClose() {
    	return gfn_getGrdSaveCount(grdMain) == 0; 
    }
    
    //이벤트 정의
    function fn_initEvent() {
    	$("#btnSearch").click("on", function() { fn_apply(); });
    	$("#btnSave").click(fn_save);
    	$("#btnAddChild").click(fn_add);
    	$("#btnDeleteRows").click(fn_del);
    	$("#btnReset").click(fn_reset);
    	
    	$("#chkColVisible").change(fn_setExpand);
    }
    
    //공통코드 조회
    function fn_initCode() {
    	var grpCd = "BU_CD";
    	codeMap = gfn_getComCode(grpCd); //공통코드 조회
    	gfn_setMsCombo("SEARCH_BU",codeMap.BU_CD,["*"]); //BU //id,data,제외코드
    }
    
    //조회
    function fn_apply(sqlFlag) {
    	
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql = sqlFlag;
    	
    	//메인 데이터를 조회
    	fn_getGridData();
    	fn_getExcelData();
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
        fn_setOptions(grdMain); // set options
        
        fn_setExpand(); //컬럼 숨기기 처리
        
        //row 상태에따른 컬럼 속성정의
        grdMain.onCurrentRowChanged = function (grid, oldRow, newRow) {
       		var editable = (newRow < 0 || dataProvider.getRowState(newRow) === "created");
       		grid.setColumnProperty("BU_CD"     ,"editable",editable);
       		grid.setColumnProperty("GROUP_CD"  ,"editable",editable);
       		grid.setColumnProperty("CODE_CD"   ,"editable",editable);
       	};
       	
      	//원클릭시 에디트 처리
        grdMain.onDataCellClicked = function (grid, index) {
        	//grid.showEditor();
        }
      	
        dataProvider.onLoadCompleted = function (provider) {
        }
	}
	
	//provider 필드 설정
    function fn_setFields(provider) {
    	//필드 배열 객체를  생성합니다.
        var fields = [
            {fieldName: "BU_CD"},
            {fieldName: "GROUP_CD"},
            {fieldName: "GROUP_DESC"},
            {fieldName: "CODE_CD"},
            {fieldName: "CODE_NM"},
            {fieldName: "CODE_NM_KR"},
            {fieldName: "CODE_NM_CN"},
            {fieldName: "SORT"},
            {fieldName: "USE_FLAG"},
            {fieldName: "ATTB_1_CD"},{fieldName: "ATTB_1_NM"},{fieldName: "ATTB_2_CD"},{fieldName: "ATTB_2_NM"},
            {fieldName: "ATTB_3_CD"},{fieldName: "ATTB_3_NM"},{fieldName: "ATTB_4_CD"},{fieldName: "ATTB_4_NM"},
            {fieldName: "ATTB_5_CD"},{fieldName: "ATTB_5_NM"},{fieldName: "ATTB_6_CD"},{fieldName: "ATTB_6_NM"},
            {fieldName: "ATTB_7_CD"},{fieldName: "ATTB_7_NM"},{fieldName: "ATTB_8_CD"},{fieldName: "ATTB_8_NM"},
            {fieldName: "ATTB_9_CD"},{fieldName: "ATTB_9_NM"},{fieldName: "ATTB_10_CD"},{fieldName: "ATTB_10_NM"},
            
            {fieldName: "ATTB_11_CD"},{fieldName: "ATTB_11_NM"},{fieldName: "ATTB_12_CD"},{fieldName: "ATTB_12_NM"},
            {fieldName: "ATTB_13_CD"},{fieldName: "ATTB_13_NM"},{fieldName: "ATTB_14_CD"},{fieldName: "ATTB_14_NM"},
            {fieldName: "ATTB_15_CD"},{fieldName: "ATTB_15_NM"},
            
            {fieldName: "CREATE_ID"},
            {fieldName: "CREATE_DTTM"},
            {fieldName: "UPDATE_ID"},
            {fieldName: "UPDATE_DTTM"},
        ];
        dataProvider.setFields(fields); //DataProvider의 setFields함수로 필드를 입력합니다.
    }
    
	
	//그리드 컬럼설정
    function fn_setColumns(grd) {
    	//필드와 연결된 컬럼 배열 객체를 생성합니다.
        var columns = [
            {
                name: "BU_CD",
                fieldName: "BU_CD",
                editable: false,
                header: {text: '<spring:message code="lbl.buName"/>'},
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
                values: gfn_getArrayExceptInDs(codeMap.BU_CD, "CODE_CD", ""),
                labels: gfn_getArrayExceptInDs(codeMap.BU_CD, "CODE_NM", ""),
                lookupDisplay: true,
                nanText : "",
                editButtonVisibility: "visible",
                //mergeRule : { criteria: "value" },
            },
            {
                name: "GROUP_CD",
                fieldName: "GROUP_CD",
                editable: false,
                header: {text: '<spring:message code="lbl.groupCode"/>'},
                styles: {textAlignment: "near", lineAlignment: "near", paddingTop:4},
                dynamicStyles: [{
                    criteria: ["state<>'c'","state='c'"],
                    styles: ["background="+gv_noneEditColor,"background="+gv_requiredColor]
                }],
                width: 150,
                //mergeRule : { criteria: "values['BU_CD'] + value" },
            },
            {
                name: "GROUP_DESC",
                fieldName: "GROUP_DESC",
                header: {text: '<spring:message code="lbl.groupName"/>'},
                styles: {textAlignment: "near", background:gv_requiredColor, lineAlignment: "near", paddingTop:4},
                width: 150,
                //mergeRule : { criteria: "values['BU_CD'] + value" },
            },
            {
                name: "CODE_CD",
                fieldName: "CODE_CD",
                editable: false,
                header: {text: '<spring:message code="lbl.code"/>'},
                styles: {textAlignment: "near"},
                dynamicStyles: [{
                    criteria: ["state<>'c'","state='c'"],
                    styles: ["background="+gv_noneEditColor,"background="+gv_requiredColor]
                }],
                width: 100
            },
            {
                name: "CODE_NM",
                fieldName: "CODE_NM",
                header: {text: '<spring:message code="english"/>'},
                styles: {textAlignment: "near",background:gv_requiredColor},
                width: 150
            },
            {
                name: "CODE_NM_KR",
                fieldName: "CODE_NM_KR",
                header: {text: '<spring:message code="korean"/>'},
                styles: {textAlignment: "near",background:gv_requiredColor},
                width: 150
            },
            {
                name: "CODE_NM_CN",
                fieldName: "CODE_NM_CN",
                header: {text: '<spring:message code="chinese"/>'},
                styles: {textAlignment: "near",background:gv_requiredColor},
                width: 150
            },
            {
                name: "SORT",
                fieldName: "SORT",
                editor: {
                    type: "number",
                    maxLength: 5,
                },
                header: {text: '<spring:message code="lbl.sort"/>'},
                styles: {textAlignment: "far",background:gv_requiredColor},
                width: 40
            },
            {
                name: "USE_FLAG",
                fieldName: "USE_FLAG",
                lookupDisplay: true,
                values: ["Y", "N"],
                labels: ["사용", "미사용"],
                editor: {
                    type: "dropDown",
                    domainOnly: true,
                }, 
                header: {text: '<spring:message code="lbl.useYn"/>'},
                styles: {textAlignment: "center",background:gv_requiredColor},
                width: 60,
                editButtonVisibility: "visible",
            },
            { name: "ATTB_1_CD" ,fieldName: "ATTB_1_CD" ,header: {text: "Attr1"     } ,styles: {textAlignment: "near" ,background:gv_editColor},width: 80 ,editor: {maxLength: 20 }},
            { name: "ATTB_1_NM" ,fieldName: "ATTB_1_NM" ,header: {text: "Attr1 Nm." } ,styles: {textAlignment: "near" ,background:gv_editColor},width: 80 ,editor: {maxLength: 100}},
            { name: "ATTB_2_CD" ,fieldName: "ATTB_2_CD" ,header: {text: "Attr2"     } ,styles: {textAlignment: "near" ,background:gv_editColor},width: 80 ,editor: {maxLength: 20 }},
            { name: "ATTB_2_NM" ,fieldName: "ATTB_2_NM" ,header: {text: "Attr2 Nm." } ,styles: {textAlignment: "near" ,background:gv_editColor},width: 80 ,editor: {maxLength: 100}},
            { name: "ATTB_3_CD" ,fieldName: "ATTB_3_CD" ,header: {text: "Attr3"     } ,styles: {textAlignment: "near" ,background:gv_editColor},width: 80 ,editor: {maxLength: 20 }},
            { name: "ATTB_3_NM" ,fieldName: "ATTB_3_NM" ,header: {text: "Attr3 Nm." } ,styles: {textAlignment: "near" ,background:gv_editColor},width: 80 ,editor: {maxLength: 100}},
            { name: "ATTB_4_CD" ,fieldName: "ATTB_4_CD" ,header: {text: "Attr4"     } ,styles: {textAlignment: "near" ,background:gv_editColor},width: 80 ,editor: {maxLength: 20 }},
            { name: "ATTB_4_NM" ,fieldName: "ATTB_4_NM" ,header: {text: "Attr4 Nm." } ,styles: {textAlignment: "near" ,background:gv_editColor},width: 80 ,editor: {maxLength: 100}},
            { name: "ATTB_5_CD" ,fieldName: "ATTB_5_CD" ,header: {text: "Attr5"     } ,styles: {textAlignment: "near" ,background:gv_editColor},width: 80 ,editor: {maxLength: 20 }},
            { name: "ATTB_5_NM" ,fieldName: "ATTB_5_NM" ,header: {text: "Attr5 Nm." } ,styles: {textAlignment: "near" ,background:gv_editColor},width: 80 ,editor: {maxLength: 100}},
            { name: "ATTB_6_CD" ,fieldName: "ATTB_6_CD" ,header: {text: "Attr6"     } ,styles: {textAlignment: "near" ,background:gv_editColor},width: 80 ,editor: {maxLength: 20 }},
            { name: "ATTB_6_NM" ,fieldName: "ATTB_6_NM" ,header: {text: "Attr6 Nm." } ,styles: {textAlignment: "near" ,background:gv_editColor},width: 80 ,editor: {maxLength: 100}},
            { name: "ATTB_7_CD" ,fieldName: "ATTB_7_CD" ,header: {text: "Attr7"     } ,styles: {textAlignment: "near" ,background:gv_editColor},width: 80 ,editor: {maxLength: 20 }},
            { name: "ATTB_7_NM" ,fieldName: "ATTB_7_NM" ,header: {text: "Attr7 Nm." } ,styles: {textAlignment: "near" ,background:gv_editColor},width: 80 ,editor: {maxLength: 100}},
            { name: "ATTB_8_CD" ,fieldName: "ATTB_8_CD" ,header: {text: "Attr8"     } ,styles: {textAlignment: "near" ,background:gv_editColor},width: 80 ,editor: {maxLength: 20 }},
            { name: "ATTB_8_NM" ,fieldName: "ATTB_8_NM" ,header: {text: "Attr8 Nm." } ,styles: {textAlignment: "near" ,background:gv_editColor},width: 80 ,editor: {maxLength: 100}},
            { name: "ATTB_9_CD" ,fieldName: "ATTB_9_CD" ,header: {text: "Attr9"     } ,styles: {textAlignment: "near" ,background:gv_editColor},width: 80 ,editor: {maxLength: 20 }},
            { name: "ATTB_9_NM" ,fieldName: "ATTB_9_NM" ,header: {text: "Attr9 Nm." } ,styles: {textAlignment: "near" ,background:gv_editColor},width: 80 ,editor: {maxLength: 100}},
            { name: "ATTB_10_CD",fieldName: "ATTB_10_CD",header: {text: "Attr10"    } ,styles: {textAlignment: "near" ,background:gv_editColor},width: 80 ,editor: {maxLength: 20 }},
            { name: "ATTB_10_NM",fieldName: "ATTB_10_NM",header: {text: "Attr10 Nm."} ,styles: {textAlignment: "near" ,background:gv_editColor},width: 80 ,editor: {maxLength: 100}},
            
            { name: "ATTB_11_CD",fieldName: "ATTB_11_CD",header: {text: "Attr11"    } ,styles: {textAlignment: "near" ,background:gv_editColor},width: 80 ,editor: {maxLength: 20 }},
            { name: "ATTB_11_NM",fieldName: "ATTB_11_NM",header: {text: "Attr11 Nm."} ,styles: {textAlignment: "near" ,background:gv_editColor},width: 80 ,editor: {maxLength: 100}},
            { name: "ATTB_12_CD",fieldName: "ATTB_12_CD",header: {text: "Attr12"    } ,styles: {textAlignment: "near" ,background:gv_editColor},width: 80 ,editor: {maxLength: 20 }},
            { name: "ATTB_12_NM",fieldName: "ATTB_12_NM",header: {text: "Attr12 Nm."} ,styles: {textAlignment: "near" ,background:gv_editColor},width: 80 ,editor: {maxLength: 100}},
            { name: "ATTB_13_CD",fieldName: "ATTB_13_CD",header: {text: "Attr13"    } ,styles: {textAlignment: "near" ,background:gv_editColor},width: 80 ,editor: {maxLength: 20 }},
            { name: "ATTB_13_NM",fieldName: "ATTB_13_NM",header: {text: "Attr13 Nm."} ,styles: {textAlignment: "near" ,background:gv_editColor},width: 80 ,editor: {maxLength: 100}},
            { name: "ATTB_14_CD",fieldName: "ATTB_14_CD",header: {text: "Attr14"    } ,styles: {textAlignment: "near" ,background:gv_editColor},width: 80 ,editor: {maxLength: 20 }},
            { name: "ATTB_14_NM",fieldName: "ATTB_14_NM",header: {text: "Attr14 Nm."} ,styles: {textAlignment: "near" ,background:gv_editColor},width: 80 ,editor: {maxLength: 100}},
            { name: "ATTB_15_CD",fieldName: "ATTB_15_CD",header: {text: "Attr15"    } ,styles: {textAlignment: "near" ,background:gv_editColor},width: 80 ,editor: {maxLength: 20 }},
            { name: "ATTB_15_NM",fieldName: "ATTB_15_NM",header: {text: "Attr15 Nm."} ,styles: {textAlignment: "near" ,background:gv_editColor},width: 80 ,editor: {maxLength: 100}},
            
            
            {
                name: "CREATE_ID",
                fieldName: "CREATE_ID",
                editable: false,
                header: {text: '<spring:message code="lbl.createBy"/>'},
                styles: {textAlignment: "near",background:gv_noneEditColor},
                width: 80
            },
            {
                name: "CREATE_DTTM",
                fieldName: "CREATE_DTTM",
                editable: false,
                header: {text: '<spring:message code="lbl.createDttm"/>'},
                styles: {textAlignment: "center",background:gv_noneEditColor},
                width: 120
            },
            {
                name: "UPDATE_ID",
                fieldName: "UPDATE_ID",
                editable: false,
                header: {text: '<spring:message code="lbl.updateBy"/>'},
                styles: {textAlignment: "near",background:gv_noneEditColor},
                width: 80
            },
            {
                name: "UPDATE_DTTM",
                fieldName: "UPDATE_DTTM",
                editable: false,
                header: {text: '<spring:message code="lbl.updateDttm"/>'},
                styles: {textAlignment: "center",background:gv_noneEditColor},
                width: 120
            },
        ];
        grdMain.setColumns(columns); //컬럼을 GridView에 입력 합니다.
    }
	
    //그리드 옵션
    function fn_setOptions(grd) {
        grd.setOptions({
            checkBar: { visible: true },
	        stateBar: { visible: true },
	        //edit    : { insertable: true, appendable: true, updatable: true, editable: true, deletable: true},
	        //body    : { rowStylesFirst: true }
	        //hideDeletedRows : true
        });
        
        grd.setDisplayOptions({
    		editItemMerging : false,
    	});
        
        dataProvider.setOptions({
        	softDeleting:true //삭제시 상태값만 바꾼다.
        });
    }
    
    //행추가
    function fn_add() {
    	grdMain.commit();
    	var current = grdMain.getCurrent();
        var row = current.dataRow;
        var setCols = {USE_FLAG:"Y"}
        
       	setCols.BU_CD = FORM_SEARCH.SEARCH_BU;
       	dataProvider.insertRow(++row,setCols);
       	
      	//포커스 이동
        grdMain.setCurrent({dataRow : row, column : "BU_CD" });
    }

    //삭제
    function fn_del() {
    	var rows = grdMain.getCheckedRows();
    	dataProvider.removeRows(rows, false);
    }
    
    //그리드 데이터 조회
    function fn_getGridData() {
    	
    	FORM_SEARCH._mtd = "getList";
    	FORM_SEARCH.tranData = [{outDs:"rtnList",_siq:"admin.codeMng"}];
    	var sMap = {
            url: "${ctx}/biz/obj.do",
            data: FORM_SEARCH,
            success:function(data) {
            	dataProvider.clearRows(); //데이터 초기화
            	
		    	//그리드 데이터 생성
		    	grdMain.cancel();
				var grdData = data.rtnList;
				
				dataProvider.setRows(grdData);
				dataProvider.clearSavePoints();
				dataProvider.savePoint(); //초기화 포인트 저장
				gfn_setSearchRow(dataProvider.getRowCount());
				
				//저장위치 처리
				//setTimeout(function() {grdMain.setCurrent({itemIndex : 12, column : "SORT" })},100);
				gridInstance.setFocusKeys();
				gridCallback(data.rtnList);
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
        
    	for(i=0; i<grdData.length; i++ )
        {
    		if(grdData[i].GROUP_CD === "VALIDATION_CHECK_CD")
    		{
    			var today = new Date();
                var year = today.getFullYear();
                var month = today.getMonth();
                var date = today.getDate();
                
                //GROUP_CD === "VALIDATION_CHECK_CD"일 때, 그리드 유효성 검사
                var arrColumn = ["ATTB_1_CD","ATTB_2_CD"];
                if (!gfn_getValidation(gridInstance,arrColumn)) return;
                
                
                
                var dateStartFrom = new Date(year, month, date, grdData[i].ATTB_1_CD.split(':')[0], grdData[i].ATTB_1_CD.split(':')[1], 00);
                var dateEndTo     = new Date(year, month, date, grdData[i].ATTB_2_CD.split(':')[0], grdData[i].ATTB_2_CD.split(':')[1], 00);
                
                var datetime_pattern = /^(0[0-9]|1[0-9]|2[0-3]):([0-5][0-9])$/; 

                if(!datetime_pattern.test(grdData[i].ATTB_1_CD))
                {
                	alert('예외처리 시작시간과 종료시간을 확인해 주세요. HH:MM');
                	return;

                }

                if(!datetime_pattern.test(grdData[i].ATTB_2_CD))
                {
                    alert('예외처리 시작시간과 종료시간을 확인해 주세요. HH:MM');
                    return;

                }
                
                
                if(0 > grdData[i].ATTB_1_CD.split(':')[0] || grdData[i].ATTB_1_CD.split(':')[0] > 23)
                {
                	alert('예외처리 시작시간과 종료시간을 확인해 주세요. 00 <= 시간 < 24');
                    return;
                }
                
                if(0 > grdData[i].ATTB_1_CD.split(':')[1] || grdData[i].ATTB_1_CD.split(':')[1] > 59)
                {
                    alert('예외처리 시작시간과 종료시간을 확인해 주세요. 00 <= 분  < 60');
                    return;
                }
                
                if(0 > grdData[i].ATTB_2_CD.split(':')[0] || grdData[i].ATTB_2_CD.split(':')[0] > 23)
                {
                    alert('예외처리 시작시간과 종료시간을 확인해 주세요. 00 <= 시간 < 24');
                    return;
                }
                
                if(0 > grdData[i].ATTB_2_CD.split(':')[1] || grdData[i].ATTB_2_CD.split(':')[1] > 59)
                {
                    alert('예외처리 시작시간과 종료시간을 확인해 주세요. 00 <= 분  < 60');
                    return;
                }
                
                
                
                if(dateStartFrom > dateEndTo)
                {
                    alert('예외처리 시작시간과 종료시간을 확인해 주세요.');
                    return;
                }
                
                
                
    		}
    		
        }
    	
    	
    	
    	//그리드 유효성 검사
    	var arrColumn = ["BU_CD","GROUP_CD","GROUP_DESC","CODE_CD","CODE_NM","CODE_NM_KR","CODE_NM_CN","SORT","USE_FLAG"];
    	if (!gfn_getValidation(gridInstance,arrColumn)) return;
    	
    	// PK 중복 체크 
        if (gfn_dupCheck(grdMain, "BU_CD|GROUP_CD|CODE_CD")) return;

    	confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
    			
    		//저장위치 처리
    		gridInstance.saveTopUpdKeys("BU_CD|GROUP_CD|CODE_CD");
    			
    		//저장
    		FORM_SAVE = {}; //초기화
    		FORM_SAVE._mtd   = "saveAll";
    		FORM_SAVE.tranData = [{outDs:"saveCnt",_siq:"admin.codeMng", grdData : grdData, custDupChkYn : {"insert":"Y"}}];
	    	var sMap = {
	            url: "${ctx}/biz/obj.do",
	            data: FORM_SAVE,
	            success:function(data) {
	            	if ( data.errCode == -10 ) {
	            		alert(gfn_getDomainMsg("msg.dupData",data.errLine));
	            		grdMain.setCurrent({dataRow : data.errLine - 1, column : "CODE_CD"});
	            	} else {
		            	alert('<spring:message code="msg.saveOk"/>');
		            	fn_apply();
	            	}
	            }
	        }
	        gfn_service(sMap,"obj");
    	});
    }
    
    //그리드 초기화
    function fn_reset() {
    	grdMain.cancel();
        dataProvider.rollback(dataProvider.getSavePoints()[0]);
    }
    
    function fn_setExpand() {
    	var visible = $('#chkColVisible').is(':checked');
    	var arrVisibleCol = [];
   		for (var i=1; i<11; i++) {
   			arrVisibleCol.push({id : "ATTB_"+i+"_CD", visible : visible});
   			arrVisibleCol.push({id : "ATTB_"+i+"_NM", visible : visible});
      	}
		fn_setColVisible(grdMain,arrVisibleCol);
    }
    
    function fn_setColVisible(objGrd,arrCol) {
    	$.each(arrCol, function(n,v) {
			objGrd.setColumnProperty(v.id, "visible", v.visible);
    	});
    }
    
	function fn_getExcelData(){
		
		EXCEL_SEARCH_DATA = "";
		EXCEL_SEARCH_DATA += '<spring:message code="lbl.bu"/> : ';
		EXCEL_SEARCH_DATA += $("#SEARCH_BU option:selected").text();
		
		EXCEL_SEARCH_DATA += '\n<spring:message code="lbl.groupCode"/> : ';
		EXCEL_SEARCH_DATA += $("#SEARCH_GROUP_CD").val();
		
		EXCEL_SEARCH_DATA += '\n<spring:message code="lbl.code"/> : ';
		EXCEL_SEARCH_DATA += $("#SEARCH_CODE_CD").val();
		
	}
	
	
	/*
    gridView.setColumnProperty("column6","dynamicStyles",function(grid, index, value) {
       var kind = grid.getValue(index.itemIndex, "field5");
       var ret = {};
       switch (kind) {
         case '법인번호' :  // 법인번호.
           ret.editor = {
             type:"text", 
             mask:{
               editMask:"000000-000000", allowEmpty:true, includedFormat:false   
             }
           };
           break;
         case '사업자번호' :  // 사업자번호
           ret.editor = {
             type:"text",
             mask:{
               editMask:"000-00-00000", allowEmpty:true, includedFormat:false
             }
           }
       }
       return ret;
    });
    */
	
	
	function gridCallback(resList){
	 
		
		for(var i = resList.length-1; i >= 0; i--){
			
			if(resList[i].GROUP_CD == 'VALIDATION_CHECK_CD')
			{
					grdMain.setColumnProperty("ATTB_1_CD","dynamicStyles",function(grid, index, value) {
					       var kind = dataProvider.getValue(index.itemIndex, "GROUP_CD");
					       var ret = {};
					       
					       switch (kind) {
					         case 'VALIDATION_CHECK_CD' :  // APS > 계획실행 > 기준정보Validation, Validation Check 버튼 실행조건
					           ret.editor = {
					             type:"text", 
					             mask:{
					               editMask:"00:00", 
					               allowEmpty:false, 
					               restrictNull:true,
					               includedFormat:true   
					             }
					           };
					           break;
					           
					         default :  // 사업자번호
					           ret.editor = {
					             type:"text"
					             
					           }
					       }
					       return ret;
					    });
					
					grdMain.setColumnProperty("ATTB_2_CD","dynamicStyles",function(grid, index, value) {
		                var kind = grdMain.getValue(index.itemIndex, "GROUP_CD");
		                var ret = {};
		                switch (kind) {
		                  case 'VALIDATION_CHECK_CD' :  // APS > 계획실행 > 기준정보Validation, Validation Check 버튼 실행조건
		                    ret.editor = {
		                      type:"text", 
		                      mask:{
		                    	   editMask:"00:00", 
                                   allowEmpty:false, 
                                   restrictNull:true,
                                   includedFormat:true   
                                   
		                      }
		                     
		                    };
		                    break;
		                  
		                  default :  // 사업자번호
                              ret.editor = {
                                type:"text"
                                
                              }
		                }
		                return ret;
		             });
		         
					
			}
			
			
		}
		
		
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
					<strong><spring:message code="lbl.bu"/></strong>
					<div class="selectBox">
						<select id="SEARCH_BU" name="SEARCH_BU"></select>
					</div>
					</li>
					<li>
					<strong><spring:message code="lbl.groupCode"/></strong>
					<div class="selectBox">
					<input type="text"  id="SEARCH_GROUP_CD" name="SEARCH_GROUP_CD" class="ipt">
					</div>
					</li>
					<li>
					<strong><spring:message code="lbl.code"/></strong>
					<div class="selectBox">
					<input type="text" id="SEARCH_CODE_CD" name="SEARCH_CODE_CD" class="ipt">
					</div>
					</li>
					<li>
						<strong><spring:message code="lbl.attr"/></strong>
						<ul class="rdofl" style="min-width:120px">
							<li><input type="checkbox" id="chkColVisible" name="chkColVisible" checked> <label for="chkColVisible"></label></li>
						</ul>
					</li>
				</ul>
			</div>
			</form>

			<div class="bt_btn">
				<a id="btnSearch" href="#" class="fl_app"><spring:message code="lbl.search"/></a>
			</div>
		</div>
		<div class="scroll">
			<!-- 그리드영역 -->
			<div id="realgrid" class="realgrid1"></div>
		</div>
		<!-- 하단버튼 영역 -->
		<div class="cbt_btn roleWrite">
			<div class="bright">
			<a id="btnReset" href="#" class="app1"><spring:message code="lbl.reset"/></a>
			<a id="btnAddChild" href="#" class="app1"><spring:message code="lbl.add"/></a>
			<a id="btnDeleteRows" href="#" class="app1"><spring:message code="lbl.delete"/></a>
			<a id="btnSave" href="#" class="app2"><spring:message code="lbl.save"/></a>
			</div>
		</div>
	</div>
</body>
</html>
