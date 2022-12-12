<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp"%>

<script type="text/javascript">
	var enterSearchFlag = "Y";
	//코드데이터
	var codeMap;
	//그리드
	var gridInstance, grdMain, dataProvider; 
	var annualProdPlanInputBlockYn = null;

	$(function() {
		gfn_formLoad(); 	//공통 초기화
		fn_initData(); 		//데이터 초기화
		fn_initFilter(); 	//필터 초기화
		fn_initGrid();		//그리드 초기화
		fn_initEvent();		//이벤트 초기화
		fn_annualProdPlanInputBlockYn()   // 연간 생산계획 입력제한 여부(당월 이후만 입력가능 함)
		
	});
	
	//데이터 초기화
	function fn_initData() {
		//공통코드 조회 
		codeMap = gfn_getComCode('FLAG_YN', "Y");
		//기초정보 조회
		fn_getInitData();
	}

	//기초정보 조회
	function fn_getInitData() {
		gfn_service({
			async   : false,
			url     : GV_CONTEXT_PATH + "/biz/obj.do",
			data    : {_mtd:"getList",menuParam:"YP",tranData:[
				{outDs:"yearList",_siq:"dp.targetMgmt.yearlyPlanYear"},

			]},
			success : function(data) {
				codeMap.YEAR_INFO = data.yearList;

			}
		}, "obj");
	}

	//필터 초기화
	function fn_initFilter() {

		
		//콤보박스
		gfn_setMsComboAll([
			{ target : 'divYear'     , id : 'year'     , title : '<spring:message code="lbl.year"/>'     , data : codeMap.YEAR_INFO, exData:[  ], type : "S" }
		]);
		
		
		//당해년도
		$("#year").val(new Date().getFullYear());
		
	
	}
	
	//그리드를 초기화
	function fn_initGrid() {
		//메저 width 설정
		gv_meaW = 120;
		//메인그리드 초기화
		fn_initGridMain();
		
	}
	
	//메인그리드 초기화
	function fn_initGridMain() {
		
		//그리드 설정
		gridInstance = new GRID();
		gridInstance.init("realgrid");
		grdMain      = gridInstance.objGrid;
		dataProvider = gridInstance.objData;
		
		// Total
		gridInstance.totalFlag = true;
		gridInstance.custAfterTotalFlag = true;
		
		//그리드 옵션
		grdMain.setOptions({
			stateBar: { visible      : true  },
			sorting : { enabled      : false },
			display : { columnMovable: false }
		});
		
		//스타일 추가
		grdMain.addCellStyles([
			{ id : "editStyleSub", editable : false },
			{ id : "editStyleRow", editable : true, background : gv_editColor }
		]);
	}
	
	//이벤트 정의
	function fn_initEvent() {
		
		// 버튼 이벤트
		$(".fl_app"        ).click ("on", function() { fn_apply(); });
		$("#btnReset"      ).click ("on", function() { fn_reset(); });
		$("#btnSave"       ).click ("on", function() { fn_save(); });
		
		//month sum omit0 처리
		gfn_setMonthSum(gridInstance, true, true, true);

		
	}
	
	
	//조회
	function fn_apply(sqlFlag) {
		
		if (sqlFlag != true) {
			//메인그리드 보이기
			if (!$("#realgrid").is(":visible")) {
				$("#realgridExcel").hide();
				$("#realgrid").show();
			}
		}
		
		// 디멘전 정리
        DIMENSION.user = [];
        DIMENSION.user.push({DIM_CD:"PROD_PART_CD"        , DIM_NM:'파트', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
        DIMENSION.user.push({DIM_CD:"PROD_PART_NM"        , DIM_NM:'파트명', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
        
		
		
		fn_getBucket();			//버켓정보 조회
		fn_drawGrid(sqlFlag);	//그리드를 그린다.

		//조회조건 설정
		FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
		FORM_SEARCH.sql		   = sqlFlag;
   		FORM_SEARCH.dimList	   = DIMENSION.user;
   		FORM_SEARCH.meaList	   = MEASURE.user;
   		FORM_SEARCH.bucketList = BUCKET.query;
   		FORM_SEARCH.totalFlag  = gridInstance.totalFlag;

		//메인 데이터를 조회
		fn_getGridData();
		//fn_getExcelData();
	}
	
	//버켓정보 조회
	function fn_getBucket() {
		
		MEASURE.user = [];
	    MEASURE.user.push({CD : "YP_AMT_KRW", NM : '출하계획' , numberFormat : "#,##0"})
        MEASURE.user.push({CD : "PP_AMT_KRW",    NM : '생산계획' , numberFormat : "#,##0"})
        MEASURE.user.push({CD : "PROD_AMT_KRW",  NM : '생산실적', numberFormat : "#,##0"} )
        MEASURE.user.push({CD : "SALES_AMT_KRW",  NM : '출하실적', numberFormat : "#,##0"} )
        
    
		
		
		var ajaxMap = {
   			fromDate: $("#year").val()+"0101",
	   		toDate  : $("#year").val()+"1231",
	   		month   : {isDown: "N", isUp:"N", upCal:"Q", isMt:"N", isExp:"N", expCnt:999},
	   		sqlId   : ["bucketMonth"]
		}
		gfn_getBucket(ajaxMap);
	}
	
	
	
	//그리드를 그린다.
	function fn_drawGrid(sqlFlag) {

		
		if (sqlFlag) {
			return;
		}

		gridInstance.setDraw();
		
	}
	
	//그리드 데이터 조회
	function fn_getGridData() {
		
		
		FORM_SEARCH._mtd       = "getList";
		FORM_SEARCH.tranData   = [{outDs:"gridList",_siq:"dp.targetMgmt.annualProductionPlan"}];
		
		
		gfn_service({
			url    : GV_CONTEXT_PATH + "/biz/obj.do",
			data   : FORM_SEARCH,
			success: function(data) {
				//그리드 데이터 삭제
				dataProvider.clearRows();
				grdMain.cancel();
				//그리드 데이터 생성
				dataProvider.setRows(data.gridList);
				//그리드 초기화 포인트 저장
				dataProvider.clearSavePoints();
				dataProvider.savePoint();
				fn_annualProdPlanInputBlockYn();
				fn_gridCallback();
				gfn_setRowTotalFixed(grdMain);
			}
		}, "obj");
	}

	//메인그리드 출력
	function fn_gridCallback() {
		
		
		var editRows = [];
		for (var i=0; i<dataProvider.getRowCount(); i++) {
			
			if (dataProvider.getValue(i, gv_grpLvlId) != "0") {
				continue;
			}
			
			if (dataProvider.getValue(i, "CATEGORY_CD") == "YP_AMT_KRW") {
				continue;
			}
			if (dataProvider.getValue(i, "CATEGORY_CD") == "SALES_AMT_KRW") {
				continue;
			}
			if (dataProvider.getValue(i, "CATEGORY_CD") == "PROD_AMT_KRW") {
				continue;
			}
			
			editRows.push(i);
		}
		
		var editBuckets = [];
	
		var nowMonth = fn_getTodayMonth();
		
		$.each(BUCKET.query, function(n,v) {
            var pBucketId = v.BUCKET_ID;
            var pBucketVal = v.BUCKET_VAL;
			grdMain.setColumnProperty(pBucketId, "editor", {type : "number", positiveOnly : true, integerOnly : true});
			
			
			if(annualProdPlanInputBlockYn == 'Y')
			{
				if(pBucketVal >= nowMonth) editBuckets.push(v.CD);
			}
			else
			{
				editBuckets.push(v.CD);
			}
				
		});
		
		grdMain.setColumnProperty("TOTAL", "width",120);
		grdMain.setColumnProperty("CATEGORY_NM", "width",60);
		grdMain.setColumnProperty("CATEGORY_NM", "styles",{textAlignment: "center"});
		
		
		grdMain.setCellStyles(editRows, editBuckets, "editStyleRow");
		grdMain.setCellStyles(editRows, ["TOTAL"]  , "editStyleSub");
	}
	
	
	
	
	//그리드 초기화
	function fn_reset() {
			grdMain.cancel();
			dataProvider.rollback(dataProvider.getSavePoints()[0]);
			fn_gridCallback();
		
	}
	
	//저장
	function fn_save() {

		// 저장할 데이터 확인
		var jsonRows;
		if ($("#realgrid").is(":visible")) {
			
			jsonRows = fn_getGrdSavedataAll(grdMain);

		} else {
			grdMainExcel.commit();
			jsonRows = dataProviderExcel.getJsonRows();
		}

		if (jsonRows.length == 0) {
			alert('<spring:message code="msg.noChangeData"/>');
			return;
		}
		// 저장
		confirm('<spring:message code="msg.saveCfm"/>', function() {
			
			
			// 실제저장
			FORM_SAVE              = {}; //초기화
			FORM_SAVE._mtd         = "saveUpdate";
			FORM_SAVE.year         = FORM_SEARCH.year;
			FORM_SAVE.tranData     = [
				{outDs:"saveCnt",_siq:"dp.targetMgmt.annualProductionPlan",grdData:jsonRows}
			];
			gfn_service({
				url    : GV_CONTEXT_PATH + "/biz/obj.do",
				data   : FORM_SAVE,
				success: function(data) {
					
					var data = [{call : "call"}];
	                 
					FORM_SAVE              = {}; //초기화
					FORM_SAVE._mtd         = "saveUpdate";
					FORM_SAVE.tranData     = [
						{outDs:"saveSuccessYn",_siq:"dp.targetMgmt.annualProductionPlanChart", grdData : data}
					];
					gfn_service({
						url    : GV_CONTEXT_PATH + "/biz/obj.do",
						data   : FORM_SAVE,
						success: function(data) {
							alert('<spring:message code="msg.saveOk"/>');
							fn_apply();							
						}
					}, "obj");
					

				}
			}, "obj");
		});
	}
	
function fn_getGrdSavedataAll(objGrid) {
		
		objGrid.commit();
		var objData = objGrid.getDataProvider();
	    var state;
	    var jData;
	    var jRowsData = [];
	    var rows = objData.getAllStateRows();

	    if (rows.deleted.length > 0) {
	        $.each(rows.deleted, function(k, v) {
	            jData = objData.getJsonRow(v);
	            jData.state = "deleted";
	            jData._ROWNUM = (v + 1) + "";
	            jRowsData.push(jData);
	        });
	    }

	    if (rows.updated.length > 0) {
	        $.each(rows.updated, function(k, v) {
	            jData = objData.getJsonRow(v);
	            jData.state = "updated";
	            jData._ROWNUM = (v + 1) + "";
	            jRowsData.push(jData);
	        });
	    }

	    if (rows.created.length > 0) {
	        $.each(rows.created, function(k, v) {
	            jData = objData.getJsonRow(v);
	            jData.state = "inserted";
	            jData._ROWNUM = (v + 1) + "";
	            jRowsData.push(jData);
	        });
	    }

	    if (jRowsData.length == 0) {
	        objData.clearRowStates(true);
	        return jRowsData;
	    }

	    return jRowsData;
}

function fn_getTodayMonth() {
    var curDate  = new Date();
    var curYear  = curDate.getFullYear();
    var curMonth = curDate.getMonth()+1;
    
    return curYear + (curMonth<10?'0':'') + curMonth
}

function fn_annualProdPlanInputBlockYn()
{
	
	
	FORM_SEARCH._mtd       = "getList";
	FORM_SEARCH.tranData   = [{outDs:"resList",_siq:"dp.targetMgmt.annualProductionPlanInputBlockYn"}];
	
	
	gfn_service({
		url    : GV_CONTEXT_PATH + "/biz/obj.do",
		data   : FORM_SEARCH,
		success: function(data) {
			annualProdPlanInputBlockYn = data.resList[0].INPUT_BLOCK_YN;
		}
	}, "obj");
	
	
	
}
	
</script>
</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp"%>
	<!-- left -->
	<div id="a" class="split split-horizontal">
		
			<form id="searchForm" name="searchForm">
				<input type="hidden" id="ap1_yn" name="ap1_yn" />
				<input type="hidden" id="ap2_yn" name="ap2_yn" />
				<input type="hidden" id="goc_yn" name="goc_yn" />
				<input type="hidden" id="release_yn" name="release_yn" />
				<%-- <input type="hidden" id="menuParam" name="menuParam" value="${menuInfo.menuParam}" /> --%>
				<div id="filterDv">
					<div class="inner">
						<h3>Filter</h3>

						<div class="tabMargin"></div>
						<div class="scroll">

							<div class="view_combo" id="divYear"></div>
						</div>
						<div class="bt_btn">
							<a href="javascript:;" class="fl_app"><spring:message code="lbl.search" /></a>
						</div>
					</div>
				</div>
			</form>
		
	</div>
	<!-- contents -->
	<div id="b" class="split split-horizontal">
		<div id="grid1" class="fconbox">
			<%@ include file="/WEB-INF/view/common/commonLocation.jsp"%>
			<div class="scroll">
				<!-- 그리드영역 -->
				<div id="realgrid" class="realgrid1"></div>

			</div>
			<div class="cbt_btn" style="height:25px">
				<div class="bright">
					<a  href="javascript:;" id="btnReset" class="app1"><spring:message code="lbl.reset" /></a>
					<a  href="javascript:;" id="btnSave" class="app2 roleWrite"><spring:message code="lbl.save" /></a>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
