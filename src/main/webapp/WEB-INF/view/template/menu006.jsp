<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>

	<script type="text/javascript">
  	//전역변수 설정
  	var gridInstance, grdMain, dataProvider;
  	var zTreeObj;
  	var arrBucket;
  	var enterSearchFlag = "Y";
  	var measureArrray = ["MEASURE1","MEASURE2"];
    $(function() {
    	//공통 폼 초기 정보 설정
    	gfn_formLoad();
    	fn_init(); 
    	fn_initGrid(); //그리드를 그린다.
    	fn_initEvent(); //이벤트 정의
    });
    
    //초기화 함수
    function fn_init() {
    	//달력
    	DATEPICKET(null,-14,0); //option,from,to
    }
    
    //그리드를 그린다.
    function fn_initGrid() {
    	//변수처리
    	gridInstance = new GRID();
    	gridInstance.init("realgrid");
    	grdMain = gridInstance.objGrid;
    	dataProvider = gridInstance.objData;
    	
    	gridInstance.totalFlag = true;
    	
    	//그리드 옵션처리 --------------------
        dataProvider.setOptions({
        	softDeleting:true //삭제시 상태값만 바꾼다.
        });
    	
    	grdMain.setOptions({
    		stateBar: { visible: true }
        });
    	
    	grdMain.addCellStyles([{
    	    id: "editStyle",
    	    editable: true,
    	}]);
    	
    	//renderer 처리
        fn_setRenderers(grdMain);

    	/*
    	grdMain.onRowsPasted =  function (grid, items) {
    		console.log("grid.onRowsPasted" + items);
    	};
    	*/
    	
    	grdMain.onEditRowChanged = function (grid, itemIndex, dataRow, field, oldValue, newValue) {
    	    var v = grid.getValue(itemIndex, field);
    	    //console.log("onEditRowChanged, " + field + ": " + oldValue + " => " + newValue);  
    	};
    	

    	grdMain.onEditRowPasted = function(grid, itemIndex, dataRow, fields, oldValues, newValues){
    	    var text = "grid.onEditRowPasted : itemIndex = "+itemIndex+", fields = "+ fields.toString()+", oldValues = "+ oldValues.toString() +", newValues = "+newValues.toString();
    	   // console.log(text);
    	    
    	    //console.log("@@@:"+grid.getValue(itemIndex+1, fields[0]));
    	    
    	    if (fields.length == newValues.length) {
	    	    $.each(fields, function(n,v) {
	    	    	//console.log("1.newValues["+n+"]:"+newValues[n]);
	    	    });
    	    } else {
	    	    $.each(fields, function(n,v) {
	    	    	//console.log("2.newValues["+v+"]:"+newValues[v]);
	    	    });
    	    }
    	};
    	
    	dataProvider.onRowUpdated = function (provider, row) {
    		//console.log(row + ": onRowUpdated");
    	    //var values = provider.getRow(row);
			//console.log(values);
    	}
    }
    
    function fn_setRenderers(grid) {
        grid.addCellRenderers([{
            id: "check1",
           	type: "check",
            shape: "box",
            editable: true,
            startEditOnClick: true,
            trueValues: "1",
            falseValues: "0",
            //labelPosition: "right"
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
    
  	//이벤트 정의
    function fn_initEvent() {
    	$(".fl_app").click("on", function() { fn_apply(); });
    	$("#btnSqlSearch").click("on", function() { fn_apply(true); });
    	$("#btnSave").click("on", function() { fn_save(); });

    	gfn_setMonthSum(gridInstance, true, true, true); //month sum omit0 처리
    }
  	
  	//조회
    function fn_apply(sqlFlag) {
    	gfn_getMenuInit(); //1. 디멘전 메저 조회
    	fn_getBucket(); //2. 버켓정보 조회
    	fn_drawGrid(sqlFlag); //3. 그리드를 그린다.

		//멀티콤보 데이터 가져오기
    	//console.log($('#msTest').multipleSelect('getSelects'));
		//console.log($('#msTest').multipleSelect('getSelects', 'text'));

    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
   		FORM_SEARCH.hrcyFlag   = true;
   		FORM_SEARCH.dimList    = DIMENSION.user;
   		FORM_SEARCH.meaList    = MEASURE.user;
   		FORM_SEARCH.bucketList = BUCKET.query;

    	//4. 메인 데이터를 조회
    	fn_getGridData();
    }
  
  	//2. 버켓정보 조회
    function fn_getBucket() {
    	var ajaxMap = {
   			fromDate: gfn_replaceAll($("#fromCal").val(),"-",""),
       		toDate  : gfn_replaceAll($("#toCal").val(),"-",""),
       		month   : {isDown: "Y", isUp:"N", upCal:"Q", isMt:"N", isExp:"Y", expCnt:999},
       		week    : {isDown: "N", isUp:"Y", upCal:"M", isMt:"Y", isExp:"N", expCnt:999},
       		sqlId : ["bucketMonth","bucketWeek"]
    	}
    	gfn_getBucket(ajaxMap);
    }

    //그리드를 그린다.
    function fn_drawGrid(sqlFlag) {
		if (sqlFlag) return;

		gridInstance.setDraw();
		
		arrBucket = []; //초기화 
    	//버켓영역 포인터 처리
    	var column, dynamicStyles, styles;
		var tmpIdx = 0;
    	$.each(BUCKET.query, function(n,v) {
    		
    		if (v.TOT_TYPE == "MT") return true;
    		
    		tmpIdx++;
    		
    		//전역변수 버켓정보설정
    		arrBucket.push(v.BUCKET_ID);
    		
    		column = grdMain.columnByName(v.BUCKET_ID);
    		dynamicStyles = grdMain.getColumnProperty(column,"dynamicStyles");
    		dynamicStyles.unshift({criteria: "((values['GRP_LVL_ID'] = 0))" ,styles: "background="+gv_editColor}); //"background=#ffffff" renderer=textEdit  //and (values['CATEGORY_CD'] = 'MEASURE1')
    		
    		//check renderer 처리
    		if (tmpIdx < 3) {
    			dynamicStyles.push({criteria: "(values['CATEGORY_CD'] = 'MEASURE1')" ,styles: "renderer=check1"}); //"background=#ffffff" renderer=textEdit  //and (values['CATEGORY_CD'] = 'MEASURE1')
    			//console.log(v.BUCKET_ID,dynamicStyles);
    		}
    		
    		grdMain.setColumnProperty(column,"dynamicStyles", dynamicStyles);
    		
		});
    }
    
    //그리드 데이터 조회
    function fn_getGridData(sqlFlag) {
    	
    	FORM_SEARCH._mtd   = "getList";
    	FORM_SEARCH.tranData = [{outDs:"gridList",_siq:"common.temp002"}];
    	var sMap = {
            url: "${ctx}/biz/obj.do",
            data: FORM_SEARCH,
            success: function(data){
            	//그리드 데이터 생성
				var grdData = data.gridList;
				dataProvider.setRows(grdData); //LocalDataProvider에 원본 데이터를 입력
				gfn_actionMonthSum(gridInstance); //month sum omit0
				fn_gridCallback();
            }
        }
        gfn_service(sMap, "obj");
    }
    
    function fn_gridCallback() {
    	//edit 처리 -------
    	var grpLvlId,category;
    	var arrIdx = [];
    	for (var i=0; i<dataProvider.getRowCount(); i++) {
	    	grpLvlId = dataProvider.getValue(i,"GRP_LVL_ID");
	    	category = dataProvider.getValue(i,"CATEGORY_CD");
	    	if (grpLvlId == 0 && $.inArray(category, measureArrray) != -1) {
	    		arrIdx.push(i);
	    		
	    	}
    	}
    	grdMain.setCellStyles(arrIdx,arrBucket,"editStyle");
    	
    	//정수입력 처리 -------
    	$.each(BUCKET.query, function(n,v) {
    		var column = grdMain.columnByName(v.CD);
    		grdMain.setColumnProperty(column, "editor", {type: "number",positiveOnly: true,integerOnly: true});
    	});
    }
    
    function fn_save() {
    	
    	//수정된 그리드 데이터만 가져온다.
		var grdData = gfn_getGrdSavedataAll(grdMain);
    	if (grdData.length == 0) {
			alert('<spring:message code="msg.noChangeData"/>');
			return;
    	}

    	//그리드 유효성 검사
    	//var arrColumn = ["BU_CD"];
    	//if (!gfn_getValidation(gridInstance,arrColumn)) return;
    	
    	// PK 중복 체크 
        //if (gfn_dupCheck(grdMain, "BU_CD|GROUP_CD|CODE_CD")) return;

    	confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
    			
    		//저장위치 처리
    		var rowKey = gfn_getArrayInDs(DIMENSION.user, "DIM_CD").join("|") + "|CATEGORY_CD";
    		gridInstance.saveTopUpdKeys(rowKey);
    			
    		//저장
    		FORM_SAVE = {}; //초기화
    		FORM_SAVE.bucketList = BUCKET.query;
    		FORM_SAVE._mtd = "saveAll";
    		FORM_SAVE.tranData = [{outDs:"saveCnt",_siq:"common.temp", grdData : grdData, mergeFlag:"Y"}];
	    	var sMap = {
	            url: "${ctx}/biz/obj.do",
	            data: FORM_SAVE,
	            success:function(data) {
	            	alert('<spring:message code="msg.saveOk"/>');
		            fn_apply();
	            }
	        }
	        gfn_service(sMap,"obj");
    	});
    }
    
    </script>

</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="a" class="split content split-horizontal">
		<div id="filterDv">
			<div class="inner">
				<h3>Filter</h3>
				<%@ include file="/WEB-INF/view/common/filterMonthSum.jsp" %>
				<div class="tabMargin"></div>
				<div class="scroll">
					<%@ include file="/WEB-INF/view/common/filterViewHorizon.jsp" %>
					<div class="view_combo">
						<div class="ilist">
							<div class="itit">SubTitle</div>
							<div class="iptdv borNone">
								<select class="iptcombo">
									<option value="--">Single Combo</option>
									<option value="01">Single Combo</option>
									<option value="02">Single Combo</option>
									<option value="03">Single Combo</option>
									<option value="04">Single Combo</option>
								</select>
							</div>
						</div>
					</div>
				</div>
				<div class="bt_btn">
					<a href="#" class="fl_app"><spring:message code="lbl.search"/></a>
				</div>
			</div>
		</div>
	</div>
	<!-- contents -->
	<div id="b" class="split split-horizontal">
		<div id="grid1" class="fconbox">
			<%@ include file="/WEB-INF/view/common/commonLocation.jsp" %>
			<div class="use_tit">
				<h3>My Opportunities</h3> <h4>- recently created</h4>
			</div>
			<div class="scroll">
				<!-- 그리드영역 -->
				<div id="realgrid" style="width: 100%;" class="realgrid1"></div>
			</div>
			<div class="cbt_btn">
				<div class="bright">
				<a href="#" class="app1">Reset</a>
				<a href="#" id="btnSave" class="app2">Save</a>
				</div>
			</div>
		</div>
    </div>
</body>
</html>
