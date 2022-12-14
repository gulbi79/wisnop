<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	<script type="text/javascript">
  	//전역변수 설정
  	var gridInstance, grdMain, dataProvider;
  	var codeMap;
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
    	$("#btnSave").click("on", function() { fn_save(); });
    	$("#btnAddRoot").click("on", function() {fn_add(-1);});
    	$("#btnAddChild").click("on", function() {fn_add();});
    	$("#btnDeleteRows").click("on", function() {fn_del();});
    	$("#btnReset").click("on", function() {fn_reset();});

    	$("#chkExpandAll").change("on", function() {
    		fn_setExpand();
    	});
    }
    
    //조회
    function fn_apply(sqlFlag) {
    	//조회조건 설정
    	FORM_SEARCH = {}; //초기화
    	FORM_SEARCH.sql = sqlFlag;
    	FORM_SEARCH.SEARCH_COMPANY = $("#company").val();
    	FORM_SEARCH.SEARCH_BU = $("#bu").val();
    	FORM_SEARCH.ACTIVE_USE_FLAG = "N";
    	
    	//메인 데이터를 조회
    	fn_getGridData();
    	fn_getExcelData();
    }
    
	//그리드를 그린다.
    function fn_initGrid() {
    	//변수처리
    	gridInstance = new GRID();
    	gridInstance.treeInit("realgrid");
    	grdMain = gridInstance.objGrid;
    	dataProvider = gridInstance.objData;
    	
        fn_setFields(dataProvider); //set fields
        fn_setColumns(grdMain); // set columns
        fn_setOptions(grdMain); // set options
        
        //하위노드 전체체크
        grdMain.onItemChecked = fn_onItemCheck;
        
       	//row 상태에따른 컬럼 속성정의
        grdMain.onCurrentRowChanged = function (grid, oldRow, newRow) {
       		
       		var editable = (newRow < 0 || dataProvider.getRowState(newRow) === "created");
       		
       		grid.setColumnProperty("COMPANY_CD", "editable", editable);
       		grid.setColumnProperty("BU_CD", "editable", editable);
       		grid.setColumnProperty("MENU_CD", "editable", editable);
       	};
       	
       	//셀 더블클릭
       	grdMain.onDataCellDblClicked = function (grid, index) {
       		
       		var rowId = index.dataRow;
       		var field = index.fieldName;
       		var cState = dataProvider.getRowState(rowId);
       		//if(field == "MENU_CD" && dataProvider.getValue(rowId, "USE_DIM_FLAG") == "Y") {
       			
       		if (field == "MENU_CD" && (cState == "updated" || cState == "none")) {
       			var params = {
       				rootUrl : "admin",
       				url : "dimensionMapping",
       				width : 978,
       				height : 560,
       				P_COMPANY_CD:dataProvider.getValue(rowId, "COMPANY_CD"),
       				P_BU_CD:dataProvider.getValue(rowId, "BU_CD"),
       				P_MENU_CD:dataProvider.getValue(rowId, "MENU_CD"),
       				P_MENU_NM:dataProvider.getValue(rowId, "MENU_NM"),
       			}
       			gfn_comPopupOpen("DIMENSION_CONF",params);
       		}
       	};
    }
	
    function fn_setFields(provider) {
    	//필드 배열 객체를  생성합니다.
        var fields = [
            {fieldName: "TREE_PATH"},
            {fieldName: "MENU_NM"},
            {fieldName: "MENU_NM_KR"},
            {fieldName: "MENU_NM_CN"},
            {fieldName: "COMPANY_CD"},
            {fieldName: "BU_CD"},
            {fieldName: "UPPER_MENU_CD"},
            {fieldName: "MENU_LVL"},
            {fieldName: "MENU_CD"},
            {fieldName: "MENU_TYPE"},
            {fieldName: "MENU_PARAM"},
            {fieldName: "URL"},
            {fieldName: "SORT"},
            {fieldName: "USE_FLAG"},
            {fieldName: "USE_DIM_FLAG"},
            {fieldName: "USE_MEAS_FLAG"},
            {fieldName: "USE_DECIMAL_FLAG"},
            {fieldName: "USE_ITEM_HIER_FLAG"},
            {fieldName: "USE_CUSTOMER_HIER_FLAG"},
            {fieldName: "USE_SALES_ORG_HIER_FLAG"},
            {fieldName: "USE_DIM_FIX_FLAG"},
        ];
        //DataProvider의 setFields함수로 필드를 입력합니다.
        dataProvider.setFields(fields);
    }
     
    function fn_setColumns(tree) {
    	//필드와 연결된 컬럼 배열 객체를 생성합니다.
        var columns = [
            {
                name: "MENU_NM",
                fieldName: "MENU_NM",
                header: {text: '<spring:message code="lbl.menuName"/>'},
                styles: {textAlignment: "near",background:gv_requiredColor},
                width: 220
            },
            {
                name: "MENU_NM_KR",
                fieldName: "MENU_NM_KR",
                header: {text: '<spring:message code="lbl.koreaMenuName"/>'},
                styles: {textAlignment: "near" ,background:gv_editColor},
                width: 200
            },
            {
                name: "MENU_NM_CN",
                fieldName: "MENU_NM_CN",
                header: {text: '<spring:message code="lbl.chineseMenuName"/>'},
                styles: {textAlignment: "near" ,background:gv_editColor},
                width: 200
            },
            {
                name: "MENU_LVL",
                fieldName: "MENU_LVL",
                editor: {
                    type: "number",
                    maxLength: 1,
                },
                header: {text: '<spring:message code="lbl.level"/>'},
                styles: {textAlignment: "far",background:gv_requiredColor},
                width: 40
            },
            {
                name: "MENU_CD",
                fieldName: "MENU_CD",
                editable: false,
                header: {text: '<spring:message code="lbl.menu"/>'},
                styles: {textAlignment: "near"},
                dynamicStyles: [{
                    criteria: ["state<>'c'","state='c'"],
                    styles: ["background="+gv_noneEditColor,"background="+gv_requiredColor]
                }],
                width: 100,
                cursor: "pointer",
            },
            /*
            {
                name: "MENU_TYPE",
                fieldName: "MENU_TYPE",
                header: {text: '<spring:message code="lbl.type"/>'},
                styles: {textAlignment: "near"},
                width: 70,
                editor: {type: "dropDown" ,domainOnly: true} ,lookupDisplay : true,
                values: gfn_getArrayExceptInDs(codeMap.MENU_TYPE, "CODE_CD"),
                labels: gfn_getArrayExceptInDs(codeMap.MENU_TYPE, "CODE_NM")
            },
            */
            {
                name: "MENU_PARAM",
                fieldName: "MENU_PARAM",
                header: {text: '<spring:message code="lbl.parameter"/>'},
                styles: {textAlignment: "near" ,background:gv_editColor},
                width: 80,
            },
            {
                name: "SORT",
                fieldName: "SORT",
                editor: {
                    type: "number",
                    maxLength: 3,
                    //integerOnly: true //정수만 입력
                },
                header: {text: '<spring:message code="lbl.sort"/>'},
                styles: {textAlignment: "far",background:gv_requiredColor},
                width: 30
            },
            {
                name: "UPPER_MENU_CD",
                fieldName: "UPPER_MENU_CD",
                header: {text: '<spring:message code="lbl.upperMenu"/>'},
                styles: {textAlignment: "near" ,background:gv_editColor},
                width: 90
            },
            {
                name: "URL",
                fieldName: "URL",
                header: {text: '<spring:message code="lbl.url"/>'},
                styles: {textAlignment: "near" ,background:gv_editColor},
                width: 150
            },
            {
                name: "USE_FLAG",
                fieldName: "USE_FLAG",
                header: {text: '<spring:message code="lbl.useYn"/>'},
                styles: {textAlignment: "near" ,background:gv_editColor},
                width: 50,
                editable: false,
                renderer : gfn_getRenderer("CHECK")
            },
            {
                name: "USE_DIM_FLAG",
                fieldName: "USE_DIM_FLAG",
                editable: false,
                header: {text: '<spring:message code="lbl.dimension"/>'},
                dynamicStyles: [{
                    criteria: ["len(values['URL'])>0","len(values['URL'])=0"],
                    styles: ["renderer=check1","renderer=check2"]
                }],
                styles: {textAlignment: "center" ,background:gv_editColor},
                width: 60
            },
            {
                name: "USE_MEAS_FLAG",
                fieldName: "USE_MEAS_FLAG",
                editable: false,
                header: {text: '<spring:message code="lbl.measure"/>'},
                dynamicStyles: [{
                    criteria: ["len(values['URL'])>0","len(values['URL'])=0"],
                    styles: ["renderer=check1","renderer=check2"]
                }],
                styles: {textAlignment: "center" ,background:gv_editColor},
                width: 50
            },
            /*
            {
                name: "USE_DECIMAL_FLAG",
                fieldName: "USE_DECIMAL_FLAG",
                editable: false,
                header: {text: '<spring:message code="lbl.decimal"/>'},
                dynamicStyles: [{
                    criteria: ["len(values['URL'])>0","len(values['URL'])=0"],
                    styles: ["renderer=check1","renderer=check2"]
                }],
                styles: {textAlignment: "center"},
                width: 50
            },
            */
            {
                name: "USE_ITEM_HIER_FLAG",
                fieldName: "USE_ITEM_HIER_FLAG",
                editable: false,
                header: {text: '<spring:message code="lbl.item"/>'},
                dynamicStyles: [{
                    criteria: ["len(values['URL'])>0","len(values['URL'])=0"],
                    styles: ["renderer=check1","renderer=check2"]
                }],
                styles: {textAlignment: "center" ,background:gv_editColor},
                width: 50
            },
            {
                name: "USE_CUSTOMER_HIER_FLAG",
                fieldName: "USE_CUSTOMER_HIER_FLAG",
                editable: false,
                header: {text: '<spring:message code="lbl.customer"/>'},
                dynamicStyles: [{
                    criteria: ["len(values['URL'])>0","len(values['URL'])=0"],
                    styles: ["renderer=check1","renderer=check2"]
                }],
                styles: {textAlignment: "center" ,background:gv_editColor},
                width: 50
            },
            {
                name: "USE_SALES_ORG_HIER_FLAG",
                fieldName: "USE_SALES_ORG_HIER_FLAG",
                editable: false,
                header: {text: '<spring:message code="lbl.salesOrg"/>'},
                dynamicStyles: [{
                    criteria: ["len(values['URL'])>0","len(values['URL'])=0"],
                    styles: ["renderer=check1","renderer=check2"]
                }],
                styles: {textAlignment: "center" ,background:gv_editColor},
                width: 60
            },
            {
                name: "USE_DIM_FIX_FLAG",
                fieldName: "USE_DIM_FIX_FLAG",
                editable: false,
                header: {text: '<spring:message code="lbl.dimFixed"/>'},
                dynamicStyles: [{
                    criteria: ["len(values['URL'])>0","len(values['URL'])=0"],
                    styles: ["renderer=check1","renderer=check2"]
                }],
                styles: {textAlignment: "center" ,background:gv_editColor},
                width: 85
            },
        ];
        //컬럼을 GridView에 입력 합니다.김
        grdMain.setColumns(columns);
    }
	
    //그리드 옵션
    function fn_setOptions(tree) {
        tree.setOptions({
            summaryMode: "aggregate",
            checkBar: { visible: true },
	        stateBar: { visible: true },
	        edit    : { insertable: true, appendable: true, updatable: true, editable: true, deletable: true},
	        //hideDeletedRows : true
        });
        
        dataProvider.setOptions({
        	softDeleting:true //삭제시 상태값만 바꾼다.
        });
         
       	//트리라인제거
        tree.setTreeOptions({lineVisible: true});
        tree.addCellStyle("style01", {
            background: "#cc6600",
            foreground: "#ffffff"
        });
        
        //renderer 처리
        fn_setRenderers(tree);
    }
    
    //행추가
    function fn_add(type) {
    	var current = grdMain.getCurrent();
        var row = current.dataRow;
        var addVal = {
			COMPANY_CD : FORM_SEARCH.SEARCH_COMPANY,
			BU_CD : FORM_SEARCH.SEARCH_BU
        };
        
        if (type == -1) {
        	var rows = dataProvider.getJsonRows(-1, true, "child", "icon");
        	
        	addVal.MENU_LVL = 1;
        	addVal.SORT = rows.length+1;
        	
        	dataProvider.addChildRow(-1, addVal, 0);
        } else {
        	addVal.UPPER_MENU_CD = dataProvider.getValue(row,"MENU_CD");
        	addVal.MENU_LVL = dataProvider.getLevel(row)+1;
        	addVal.SORT = dataProvider.getChildCount(row)+1;
        	
	        var child = dataProvider.addChildRow(row, addVal, 0);
	        grdMain.expand(grdMain.getItemIndex(row));
        }
    }

    //삭제
    function fn_del() {
    	var rows = grdMain.getCheckedRows();
		//dataProvider.removeRows(rows, false);
		for (var i=rows.length-1; i>=0; i--) {
			dataProvider.removeRow(rows[i]);
		}
    }
    
    //그리드 데이터 조회
    function fn_getGridData() {
    	
    	FORM_SEARCH._mtd   = "getList";
    	FORM_SEARCH.tranData = [{outDs:"rtnList",_siq:"admin.menuMng"}];
    	var sMap = {
   			url: "${ctx}/biz/obj",
            data: FORM_SEARCH,
            success:function(data) {
		    	//그리드 데이터 생성
				var grdData = data.rtnList;
				dataProvider.setRows(grdData, "TREE_PATH", false);
				dataProvider.clearSavePoints();
				dataProvider.savePoint(); //초기화 포인트 저장
				
				gfn_setSearchRow(dataProvider.getRowCount());
				
				fn_setExpand();
            }
        }
        gfn_service(sMap,"obj");
    }
    
    //저장
    function fn_save() {
    	//그기드 유효성 검사
    	var arrColumn = ["MENU_NM","COMPANY_CD","BU_CD","MENU_CD","MENU_LVL","SORT"];
    	if (!gfn_getValidation(gridInstance,arrColumn)) return;
    	
    	//수정된 그리드 데이터만 가져온다.
		var grdData = gfn_getGrdSavedataAll(grdMain);
    	if (grdData.length == 0) {
    		alert('<spring:message code="msg.noChangeData"/>');  //변경된 데이터가 없습니다.
			return;
    	}
    	
    	confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
    		//저장
    		FORM_SEARCH = {}; //초기화
    		FORM_SEARCH._mtd   = "saveAll";
	    	FORM_SEARCH.tranData = [{outDs:"saveCnt",_siq:"admin.menuMng", grdData : grdData}];
    		
    		var serviceMap = {
   				url: "${ctx}/biz/obj",
                data: FORM_SEARCH,
                success:function(data) {
                	alert('<spring:message code="msg.saveOk"/>');
                	//dataProvider.clearRowStates(true);
                	fn_apply();
                }
            }
    		gfn_service(serviceMap, "obj");
    	}); 
    }

    //체크이벤트시 부모/자식노드 체크/해제
    function fn_onItemCheck(grid, itemIndex, checked) {
    	//하위노드까지 체크
    	if (checked) {
	        var recursive = true;
	        var displayOnly = false;
	        grdMain.checkChildren(itemIndex, checked, recursive, displayOnly);
	        grdMain.expand(itemIndex, recursive && !displayOnly);
    	
	    //부모노드 해제    
    	} else {
    		var pItem = grdMain.getParent(itemIndex);
    		grdMain.checkItem(pItem, checked, false);  
    	}
    }
    
    //그리드 초기화
    function fn_reset() {
    	grdMain.cancel();
    	grdMain.orderBy([],[]);
        dataProvider.rollback(dataProvider.getSavePoints()[0]);
        fn_setExpand();
    }
    
    //공통코드 조회
    function fn_initCode() {
    	var grpCd = "BU_CD,COMPANY_CD,MENU_TYPE";
    	codeMap = gfn_getComCode(grpCd); //공통코드 조회
    	gfn_setMsCombo("company",codeMap.COMPANY_CD,["*"]); //COMPANY //id,data,제외코드
    	gfn_setMsCombo("bu",codeMap.BU_CD,["ALL"]); //BU //id,data,제외코드
    }
    
    function fn_setRenderers(grid) {
        grid.addCellRenderers([{
            id: "check1",
           	type: "check",
            shape: "box",
            editable: true,
            startEditOnClick: true,
            trueValues: "Y",
            falseValues: "N"
        },{
            id: "check2",
           	type: "check",
            shape: "box",
            editable: false,
            startEditOnClick: true,
            trueValues: "Y",
            falseValues: "N"
        }]);
    }
    
    function fn_setExpand() {
    	//if(this.checked) {
    	if($('#chkExpandAll').is(':checked')) {
			grdMain.expandAll(); //전체펼침
		} else {
			grdMain.collapseAll();
		}
    }
    	
	function fn_getExcelData(){
		
		EXCEL_SEARCH_DATA = "";
		EXCEL_SEARCH_DATA += '<spring:message code="lbl.company"/> : ';
		EXCEL_SEARCH_DATA += $("#company option:selected").text();
		
		EXCEL_SEARCH_DATA += '\n<spring:message code="lbl.bu"/> : ';
		EXCEL_SEARCH_DATA += $("#bu option:selected").text();
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
					<strong><spring:message code="lbl.company"/></strong>
					<div class="selectBox">
						<select id="company" name="company"></select>
					</div>
					</li>
					<li>
					<strong><spring:message code="lbl.bu"/></strong>
					<div class="selectBox">
						<select id="bu" name="bu"></select>
					</div>
					</li>
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

		<div class="scroll">
			<!-- 그리드영역 -->
			<div id="realgrid" class="realgrid1"></div>
		</div>
		
		<!-- 하단버튼 영역 -->
		<div class="cbt_btn roleWrite">
			<div class="bright">
			<a id="btnReset" href="#" class="app1"><spring:message code="lbl.reset"/></a>
			<a id="btnAddRoot" href="#" class="app1"><spring:message code="lbl.rootAdd"/></a>
			<a id="btnAddChild" href="#" class="app1"><spring:message code="lbl.add"/></a>
			<a id="btnDeleteRows" href="#" class="app1"><spring:message code="lbl.delete"/></a>
			<a id="btnSave" href="#" class="app2"><spring:message code="lbl.save"/></a>
			</div>
		</div>
	</div>
</body>
</html>
