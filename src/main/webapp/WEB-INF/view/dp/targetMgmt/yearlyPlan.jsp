<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp"%>
<script type="text/javascript" src="${ctx}/statics/js/biz/gridcalc.js"></script>
<script type="text/javascript">
	var enterSearchFlag = "Y";
	//코드데이터
	var codeMap;
	//그리드
	var gridInstance, grdMain, dataProvider; 
	var gridInstanceExcel, grdMainExcel, dataProviderExcel;
	//그리드 자동계산용
	var apMeaCd = "YP_QTY";
	//엑셀그리드데이터 (디멘전,메저,버킷)
	var EXCEL_GRID_DATA = {};

	$(function() {
		gfn_formLoad(); 	//공통 초기화
		fn_initData(); 		//데이터 초기화
		fn_initFilter(); 	//필터 초기화
		fn_initGrid();		//그리드 초기화
		fn_initEvent();		//이벤트 초기화
		fn_setBtnDisplay();
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
			url     : GV_CONTEXT_PATH + "/biz/obj",
			data    : {_mtd:"getList",menuParam:"YP",tranData:[
				{outDs:"yearList",_siq:"dp.targetMgmt.yearlyPlanYear"},
				{outDs:"roleList",_siq:"dp.targetMgmt.yearlyPlanRole"},
			]},
			success : function(data) {
				codeMap.YEAR_INFO = data.yearList;
				codeMap.ROLE_INFO = data.roleList[0];
			}
		}, "obj");
	}

	//필터 초기화
	function fn_initFilter() {

		//키워드팝업
		gfn_keyPopAddEvent([
			{ target : 'divItem', id : 'item', type : 'COM_ITEM_PLAN', title : '<spring:message code="lbl.item"/>' }
		]);
		
		//콤보박스
		gfn_setMsComboAll([
			{ target : 'divYear'     , id : 'year'     , title : '<spring:message code="lbl.year"/>'     , data : codeMap.YEAR_INFO, exData:[  ], type : "S" },
			{ target : 'divConfirmYn', id : 'confirmYn', title : '<spring:message code="lbl.confirmYn"/>', data : codeMap.FLAG_YN  , exData:[  ], type : "S" },
		]);
		
		//숫자만입력
		$("#opRateFrom,#opRateTo,#arRateFrom,#arRateTo").inputmask("numeric");
		
		//당해년도
		$("#year").val(new Date().getFullYear());
		
		//권한정보
		$("#ap1_yn").val(codeMap.ROLE_INFO.AP1_YN);
		$("#ap2_yn").val(codeMap.ROLE_INFO.AP2_YN);
		$("#goc_yn").val(codeMap.ROLE_INFO.GOC_YN);
	}
	
	//그리드를 초기화
	function fn_initGrid() {
		//메저 width 설정
		gv_meaW = 120;
		//메인그리드 초기화
		fn_initGridMain();
		//엑셀그리드 초기화
		fn_initGridExcel();
		
		//GRIDCALC Init
		GRIDCALC.gridInst = gridInstance;
		GRIDCALC.apMeaCd  = apMeaCd;
		GRIDCALC.amtMeaCd = ["YP_AMT_KRW","OP_AMT_KRW","OP_RATE"];
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
		
		//그리드 옵션
		grdMain.setOptions({
			stateBar: { visible      : true  },
			sorting : { enabled      : false },
			display : { columnMovable: false }
		});
		
		//스타일 추가
		grdMain.addCellStyles([
			{ id : "editStyleSub", editable : true },
			{ id : "editStyleRow", editable : true, background : gv_editColor }
		]);
	}
	
	//엑셀그리드 초기화
	function fn_initGridExcel() {
		
		//그리드 설정
		gridInstanceExcel = new GRID();
		gridInstanceExcel.init("realgridExcel");
		grdMainExcel      = gridInstanceExcel.objGrid;
		dataProviderExcel = gridInstanceExcel.objData;
		
		//그리드 옵션
		grdMainExcel.setOptions({
			sorting : { enabled      : false },
			display : { columnMovable: false }
		});
		
		//디멘저,메저정보
		fn_getDimMeaInfo();
	}
	
	//이벤트 정의
	function fn_initEvent() {
		
		// 버튼 이벤트
		$(".fl_app"        ).click ("on", function() { fn_apply(); });
		$("#btnCopy"       ).click ("on", function() { fn_copy(); });
		$("#btnExcelDown"  ).click ("on", function() { fn_excelDown(); });
		$("#btnExcelUpload").click ("on", function() { $("#excelFile").trigger("click"); });
		$("#excelFile"     ).change("on", function() { fn_excelUpload(); });
		$("#btnConfirmY"   ).click ("on", function() { fn_confirm("Y"); });
		$("#btnConfirmN"   ).click ("on", function() { fn_confirm("N"); });
		$("#btnRelease"    ).click ("on", function() { fn_release(); });
		$("#btnReset"      ).click ("on", function() { fn_reset(); });
		$("#btnSave"       ).click ("on", function() { fn_save(); });
		
		//month sum omit0 처리
		gfn_setMonthSum(gridInstance, true, true, true);
		
		//그리드 이벤트
		GRIDCALC.bsc.flag = true;
		GRIDCALC.bsc.callback = function(provider, meaIdx, field, meaCd) {

			if (meaCd == "OP_RATE") {
			
				var amtMeaIdx = gfn_getFindPositionInDs(MEASURE.user, "CD", meaCd);
				var apMeaIdx  = gfn_getFindPositionInDs(MEASURE.user, "CD", "YP_QTY");
				var calcIdx   = meaIdx - (amtMeaIdx - apMeaIdx);
				var calcData  = gfn_setAmtFunc(meaCd, provider, meaIdx, provider.getValue(calcIdx, field));

				provider.setValue(meaIdx, gv_colBucketTotal, calcData);
				if (provider.getValue(meaIdx, gv_grpLvlId) != "0") {
					provider.setValue(meaIdx, field, calcData);
				}
				
			} else {
				//월토탈 처리
				gfn_setMonthTotalVal(provider, meaIdx, field, true);
			}
		};
		
		grdMain.onEditRowChanged = function (grid, itemIndex, dataRow, field, oldValue, newValue) {
			fn_allInOneCalc(grid, itemIndex, dataRow, field, oldValue, newValue);
		};
		
		grdMain.onEditRowPasted = function(grid, itemIndex, dataRow, fields, oldValues, newValues) {
			if (fields.length == newValues.length) {
				fn_allInOneCalc(grid, itemIndex, dataRow, fields, oldValues, newValues);
    	    } else {
    	    	var arrNewVal = [];
	    	    $.each(fields, function(n,v) {
	    	    	arrNewVal.push(newValues[v]);
	    	    });
				fn_allInOneCalc(grid, itemIndex, dataRow, fields, oldValues, arrNewVal);
    	    }
		};
		
		grdMain.onRowsPasted = function (grid, items) {
			GRIDCALC.changeMap = []; //변경된 데이터 초기화
    	};
	}
	
	//버튼처리
	function fn_setBtnDisplay(release_yn) {
		
		var isMain = false;
		var isEdit = false;
		
		if ($("#realgrid").is(":visible")) {
			isMain = true;
			if (fn_gridIsEdit()) {
				isEdit = true;
			}
		}
		
		if (isMain && isEdit && release_yn != "Y") {
			$("#btnCopy").show();
			$("#btnExcelDown,#btnExcelUpload").show();
		} else {
			$("#btnCopy").hide();
			$("#btnExcelDown,#btnExcelUpload").hide();
		}
		
		if (isMain && isEdit && $("#ap2_yn").val() == "Y" && release_yn != "Y") {
			$("#btnConfirmY,#btnConfirmN").show();
		} else {
			$("#btnConfirmY,#btnConfirmN").hide();
		}
		
		if (isMain && isEdit && $("#goc_yn").val() == "Y") {
			if (release_yn != "Y") {
				$("#btnRelease").text('<spring:message code="lbl.release" />');
			} else {
				$("#btnRelease").text('<spring:message code="lbl.releaseCancel" />');
			}
			$("#btnRelease").show();
		} else {
			$("#btnRelease").hide();
		}
		
		if ((isMain && isEdit && release_yn != "Y") || (!isMain)) {
			$("#btnReset,#btnSave").show();
		} else {
			$("#btnReset,#btnSave").hide();
		}
		
		if ($("#saveYn").val() != "Y") {
			$(".roleWrite").hide();
		}
	}
	
	//엑셀다운로드 디멘전,메저 정리
	function fn_getDimMeaInfo() {
		gfn_service({
		    async   : false,
		    url     : GV_CONTEXT_PATH + "/biz/obj",
		    data    : {
		    	_mtd           : "getList",
		    	SEARCH_MENU_CD : "${menuInfo.menuCd}",
		    	tranData       : [
		    		{outDs:"dimList",_siq:"admin.dimMapMenu"},
		    		{outDs:"meaList",_siq:"common.meaConf"},
		    	]
		    },
		    success :function(data) {
		    	//디멘전 정리
		    	DIMENSION.user = [];
		    	$.each(data.dimList, function(idx, dim) {
		    		if (dim.DIM_CD == "CUST_GROUP_CD" ||
		    			dim.DIM_CD == "CUST_GROUP_NM" ||
		    			dim.DIM_CD == "ITEM_CD"       ||
		    			dim.DIM_CD == "ITEM_NM"       ||
		    			dim.DIM_CD == "SPEC"          ) {
		    			DIMENSION.user.push(dim);
		    		}
		    	});
		    	//메저 정리
		    	MEASURE.user = [];
		    	$.each(data.meaList, function(idx, mea) {
		    		if (mea.MEAS_CD == "YP_QTY") {
		    			mea.CD = mea.MEAS_CD;
		    			mea.NM = mea.MEAS_NM;
		    			MEASURE.user.push(mea);
		    		}
		    	});
		    	
		    	EXCEL_GRID_DATA.DIM = DIMENSION.user;
		    	EXCEL_GRID_DATA.MEA = MEASURE.user;
		    }
		}, "obj");
		
		FORM_SEARCH = {};
		FORM_SEARCH._mtd = "getList";
		FORM_SEARCH.year = $("#year").val();
		FORM_SEARCH.tranData = [{outDs:"relsInfo",_siq:"dp.targetMgmt.yearlyPlanRelease"}];
		
		gfn_service({
			url    : GV_CONTEXT_PATH + "/biz/obj",
			data   : FORM_SEARCH,
			async  : false,
			success: function(data) {
				var releaseYn = data.relsInfo[0].RELEASE_YN;
				$("#release_yn").val(releaseYn);
			}
		}, "obj");
	}
	
	//엑셀다운로드
	function fn_excelDown() {
		
		//그리드 그리기
		fn_drawGridExcel();
		
		//조회조건 설정
		FORM_SEARCH.sql        = false;
		FORM_SEARCH.hrcyFlag   = true;
		FORM_SEARCH.dimList	   = EXCEL_GRID_DATA.DIM;
		FORM_SEARCH.meaList	   = EXCEL_GRID_DATA.MEA;
		FORM_SEARCH.bucketList = BUCKET.query;
		FORM_SEARCH._mtd       = "getList";
		FORM_SEARCH.tranData   = [{outDs:"gridList",_siq:"dp.targetMgmt.yearlyPlan"}];
		
		gfn_service({
			url    : GV_CONTEXT_PATH + "/biz/obj",
			data   : FORM_SEARCH,
			success: function(data) {
				//엑셀데이터 정리 (로우 데이터만 추가)
				var gridListExcel = [];
				$.each(data.gridList, function(idx, item) {
					if (item.GRP_LVL_ID == "0" && item.CATEGORY_CD == apMeaCd) {
						gridListExcel.push(item);
					}
				});
				//그리드 데이터 삭제
				dataProviderExcel.clearRows();
				grdMainExcel.cancel();
				//그리드 데이터 생성
				dataProviderExcel.setRows(gridListExcel);
				//그리드 초기화 포인트 저장
				dataProviderExcel.clearSavePoints();
				dataProviderExcel.savePoint();
				
				//엑셀다운로드
				gfn_doExportExcel({
					gridIdx            : 1,
					fileNm             : "${menuInfo.menuNm} ("+FORM_SEARCH.year+")",
					formYn             : "Y",
					indicator          : "hidden",
					conFirmFlag        : false,
					applyDynamicStyles : true
				});
			}
		}, "obj");
	}
	
	//엑셀업로드
	function fn_excelUpload() {
		
		//그리드 그리기
		fn_drawGridExcel();
		
		//엑셀업로드
		gfn_importGrid({
			gridIdx  : 1,
			callback : function() {
				//그리드 초기화 포인트 저장
				dataProviderExcel.clearSavePoints();
				dataProviderExcel.savePoint();
				// 메인그리드 숨기기
				$("#realgrid").hide();
				// 엑셀그리드 보이기
				$("#realgridExcel").show();
				grdMainExcel.resetSize();
				//버튼
				fn_setBtnDisplay();
			}
		});
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
		
		gfn_getMenuInit();		//디멘전 메저 조회
		fn_getBucket();			//버켓정보 조회
		fn_drawGrid(sqlFlag);	//그리드를 그린다.

		//조회조건 설정
		FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
		FORM_SEARCH.sql		   = sqlFlag;
   		FORM_SEARCH.hrcyFlag   = true;
   		FORM_SEARCH.dimList	   = DIMENSION.user;
   		FORM_SEARCH.hiddenList = DIMENSION.hidden;
   		FORM_SEARCH.meaList	   = MEASURE.user;
   		FORM_SEARCH.bucketList = BUCKET.query;
   		FORM_SEARCH.totalFlag  = gridInstance.totalFlag;

		//메인 데이터를 조회
		fn_getGridData();
		fn_getExcelData();
	}
	
	//버켓정보 조회
	function fn_getBucket() {
		var ajaxMap = {
   			fromDate: $("#year").val()+"0101",
	   		toDate  : $("#year").val()+"1231",
	   		month   : {isDown: "N", isUp:"N", upCal:"Q", isMt:"N", isExp:"N", expCnt:999},
	   		sqlId   : ["bucketMonth"]
		}
		gfn_getBucket(ajaxMap);
	}
	
	//그리드를 그린다.
	function fn_drawGridExcel() {
		
		//그리드 그리기
		var mainDim = DIMENSION.user;
		var mainMea = MEASURE.user;
		
		DIMENSION.user = EXCEL_GRID_DATA.DIM;
		MEASURE.user   = EXCEL_GRID_DATA.MEA;
		
		gridInstanceExcel.setDraw();
		
		DIMENSION.user = mainDim;
		MEASURE.user   = mainMea;
		
		// Bucket 수정 가능하도록 변경
		var columns = grdMainExcel.getColumns();
		$.each(columns, function(n,v) {
			if (v.name.charAt(0) == "M") {
				v.styles.background = gv_editColor;
				v.editable = true;
				v.editor   = {
					type         : "number",
					positiveOnly : true,
					integerOnly  : true
				};
			} else {
				v.editable = false;
			}
		});
		grdMainExcel.setColumns(columns);
	}
	
	//그리드를 그린다.
	function fn_drawGrid(sqlFlag) {

		// 데이터셋에만 존재하는 컬럼 추가
    	DIMENSION.hidden = [];
    	DIMENSION.hidden.push({CD:"SALES_PRICE_KRW", dataType:"number"});
    	DIMENSION.hidden.push({CD:"CONFIRM_YN"     , dataType:"text"  });
    	DIMENSION.hidden.push({CD:"COGS_KRW"       , dataType:"number"});
    	DIMENSION.hidden.push({CD:"SGNA_KRW"       , dataType:"number"});
		
		if (sqlFlag) {
			return;
		}

		gridInstance.setDraw();
		
		//BUCKET 수정가능여부 Y/N 필드 추가
		$.each(BUCKET.query, function(n,v) {
			dataProvider.addField({fieldName:v.BUCKET_ID+"_FROZEN_YN"}, false);	
		});
	}
	
	//그리드 데이터 조회
	function fn_getGridData() {
		
		FORM_SEARCH._mtd     = "getList";
		FORM_SEARCH.tranData = [{outDs:"relsInfo",_siq:"dp.targetMgmt.yearlyPlanRelease"}];
		
		gfn_service({
			url    : GV_CONTEXT_PATH + "/biz/obj",
			data   : FORM_SEARCH,
			async  : false,
			success: function(data) {
				$("#release_yn").val(data.relsInfo[0].RELEASE_YN);
			}
		}, "obj");
		
		FORM_SEARCH.release_yn = $("#release_yn").val();
		FORM_SEARCH._mtd       = "getList";
		FORM_SEARCH.tranData   = [{outDs:"gridList",_siq:"dp.targetMgmt.yearlyPlan"}];
		
		gfn_service({
			url    : GV_CONTEXT_PATH + "/biz/obj",
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
				//month sum omit0
				gfn_actionMonthSum(gridInstance);
				//
				fn_setBtnDisplay(FORM_SEARCH.release_yn);
				fn_gridCallback();
				gfn_setRowTotalFixed(grdMain);
			}
		}, "obj");
	}

	//메인그리드 출력
	function fn_gridCallback() {
		
		if ($("#release_yn").val() == "Y") {
			return;
		}
		
		if (!fn_gridIsEdit()) {
			return;
		}
		
		var editRows = [];
		for (var i=0; i<dataProvider.getRowCount(); i++) {
			
			if (dataProvider.getValue(i, gv_grpLvlId) != "0") {
				continue;
			}
			if (dataProvider.getValue(i, "CATEGORY_CD") != apMeaCd) {
				continue;
			}
			if (dataProvider.getValue(i, "CONFIRM_YN") != "N") {
				continue;
			}
			
			editRows.push(i);
		}
		
		var editBuckets = [];
		$.each(BUCKET.query, function() {
			editBuckets.push(this.CD);
		});
		
		grdMain.setCellStyles(editRows, editBuckets, "editStyleRow");
		grdMain.setCellStyles(editRows, ["TOTAL"]  , "editStyleSub");
	}
	
	// Dimension & Measure 존재 유무에따라 수정가능 불가능 판단
	function fn_gridIsEdit() {
		
		if (dataProvider.getRowCount() == 0) {
			return false;
		}
		
		var is_cust_group = false;
		var is_item       = false;
		var is_sales_org  = false;
		
		// Dimension 
		$.each(DIMENSION.user, function(n,v) {
			if(v.DIM_CD == "CUST_GROUP_CD") {
				is_cust_group = true;
			}else if (v.DIM_CD == "ITEM_CD"){
				is_item = true;
			}else if (v.DIM_CD.indexOf("SALES") > -1){
				is_sales_org  = true;
			}
			
			if (is_sales_org) {
				return false;
			}
		});
		
		if (is_sales_org) {
			return false;
		}

		if (is_cust_group && is_item) {
			
			var is_mea_cd = false;
			
			// Measure
			$.each(MEASURE.user, function(n,v) {
				if (v.CD == apMeaCd) is_mea_cd = true;
				
				if (is_mea_cd) {
					return false;
				}
			});
			
			if (is_mea_cd) {
				return true;
			} else {
				return false;
			}
			
		} else {
			return false;
		}
	}
	
	// 복사
	function fn_copy() {
		
		if (dataProvider.getRowCount() == 0) {
			alert('<spring:message code="msg.noDataFound"/>');
			return;
		}

		gfn_comPopupOpen("DP_COPY_BASELINE", {
			rootUrl : "dp",
			url     : "copy",
			width   : 600,
			height  : 200,
			type    : "ST",
			menuCd  : '${menuInfo.menuCd}',
			measure : apMeaCd,
			year    : FORM_SEARCH.year
		});
	}
	
	// 복사 팝업 콜백
	function fn_popupApplyCallback(type, source, target, fromMonth, toMonth) {
		
		var sourceIdx = gfn_getFindPositionInDs(MEASURE.user, "CD", source);
		var targetIdx = gfn_getFindPositionInDs(MEASURE.user, "CD", target);
		if (sourceIdx == -1 || targetIdx == -1) return; //없으면 처리안함
		
		var calcIdx = targetIdx - sourceIdx;
		
		var arrMonth = $.grep(BUCKET.query, function (v,n) {
			return v.BUCKET_VAL >= fromMonth && v.BUCKET_VAL <= toMonth;
		});
		
		var oldValue, newValue;
		for (var i=0; i<dataProvider.getRowCount(); i++) {
			
			if (dataProvider.getValue(i, gv_grpLvlId ) != "0"   ) continue;
			if (dataProvider.getValue(i, gv_measureCd) != target) continue;
			
			$.each(arrMonth, function(n,v) {
			
				oldValue = dataProvider.getValue(i, v.CD);
				newValue = dataProvider.getValue(i-calcIdx, v.CD);
				if (oldValue == newValue) return true;
				
				dataProvider.setValue(i, v.CD, newValue);
				
				fn_allInOneCalc(
					gridInstance.objGrid,
					grdMain.getItemIndex(i),
					i,
					dataProvider.getFieldIndex(v.CD),
					oldValue,
					newValue
				);
			});
		}
	}
	
	//그리드 초기화
	function fn_reset() {
		if ($("#realgrid").is(":visible")) {
			grdMain.cancel();
			dataProvider.rollback(dataProvider.getSavePoints()[0]);
			fn_gridCallback();
		} else {
			grdMainExcel.cancel();
			dataProviderExcel.rollback(dataProviderExcel.getSavePoints()[0]);
		}
	}
	
	//저장
	function fn_save() {

		// 저장할 데이터 확인
		var jsonRows;
		if ($("#realgrid").is(":visible")) {
			jsonRows = gfn_getGrdSavedataAll(grdMain);
			for (var i = jsonRows.length-1; i >= 0; i--) {
				if (jsonRows[i].GRP_LVL_ID != "0" || jsonRows[i].CATEGORY_CD != apMeaCd) {
					jsonRows.splice(i, 1);
				}
			}
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
				{outDs:"saveCnt",_siq:"dp.targetMgmt.yearlyPlan",grdData:jsonRows},
			];
			
			gfn_service({
				url    : GV_CONTEXT_PATH + "/biz/obj",
				data   : FORM_SAVE,
				success: function(data) {
					alert('<spring:message code="msg.saveOk"/>');
					fn_apply();
				}
			}, "obj");
		});
	}
	
	function fn_allInOneCalc(grid, itemIndex, dataRow, field, oldValue, newValue) {
		if ($.isArray(field)) {
			var tmpOldVal = 0;
			$.each(field, function(n,v) {
				tmpOldVal = GRIDCALC.getChangeVal(dataProvider, dataRow, v, oldValue[n]);
				gfn_setAmt(grid, itemIndex, field[n]); //amt
				GRIDCALC.autoCalc(gridInstance, itemIndex, dataRow, field[n], tmpOldVal, newValue[n]);
			});
		} else {
			gfn_setAmt(grid, itemIndex, field); //amt
			GRIDCALC.autoCalc(gridInstance, itemIndex, dataRow, field, oldValue, newValue);
		}
	}
	
	function fn_confirm(confirm_yn) {
		
		if (dataProvider.getRowCount() == 0) {
			alert('<spring:message code="msg.noDataFound"/>');
			return;
		}
		
		// 저장
		confirm('<spring:message code="msg.saveCfm"/>', function() {
			
			var jsonRows = dataProvider.getJsonRows();
			
			// Row Data
			for (var i = jsonRows.length-1; i >= 0; i--) {
				if (jsonRows[i].GRP_LVL_ID != "0") {
					jsonRows.splice(i, 1);
				}
			}
			
			// Measure
			for (var i = jsonRows.length-1; i >= 0; i--) {
				if (i % MEASURE.user.length != 0) {
					jsonRows.splice(i, 1);
				} else {
					jsonRows[i].CONFIRM_YN = confirm_yn;
					jsonRows[i].YEAR       = FORM_SEARCH.year;
				}
			}
			
			// 실제저장
			FORM_SAVE          = {}; //초기화
			FORM_SAVE._mtd     = "saveUpdate";
			FORM_SAVE.tranData = [{outDs:"saveCnt",_siq:"dp.targetMgmt.yearlyPlanConfirm",grdData:jsonRows}];
			
			gfn_service({
				url    : GV_CONTEXT_PATH + "/biz/obj",
				data   : FORM_SAVE,
				success: function(data) {
					alert('<spring:message code="msg.saveOk"/>');
					fn_apply();
				}
			}, "obj");
		});
	}
	
	function fn_release() {
		
		// 저장
		confirm('<spring:message code="msg.saveCfm"/>', function() {
			
			var planInfo = [{
				YEAR         : FORM_SEARCH.year,
				RELEASE_FLAG : $("#release_yn").val() == "Y" ? "N" : "Y",
			}];
			
			// 실제저장
			FORM_SAVE          = {}; //초기화
			FORM_SAVE._mtd     = "saveUpdate";
			FORM_SAVE.tranData = [
				{outDs:"saveCnt",_siq:"dp.targetMgmt.yearlyPlanRelease",grdData:planInfo},
			];
			
			gfn_service({
				url    : GV_CONTEXT_PATH + "/biz/obj",
				data   : FORM_SAVE,
				success: function(data) {
					alert('<spring:message code="msg.saveOk"/>');
					fn_apply();
				}
			}, "obj");
		});
	}
	
	function fn_getExcelData(){
		
		EXCEL_SEARCH_DATA = "";
		EXCEL_SEARCH_DATA += "Product" + " : ";
		EXCEL_SEARCH_DATA += $("#loc_product").html();
		EXCEL_SEARCH_DATA += "\nCustomer" + " : ";
		EXCEL_SEARCH_DATA += $("#loc_customer").html();
		EXCEL_SEARCH_DATA += "\nSales Org" + " : ";
		EXCEL_SEARCH_DATA += $("#loc_salesOrg").html();
		
		$.each($(".view_combo"), function(i, val){
			
			var temp = "";
			var id = gfn_nvl($(this).attr("id"), "");
			
			if(id != ""){
				
				var name = $("#" + id + " .ilist .itit").html();
				
				//타이틀
				EXCEL_SEARCH_DATA += "\n" + name + " : ";	
				
				//데이터
				if(id == "divItem"){
					EXCEL_SEARCH_DATA += $("#item_nm").val();
				}else if(id == "divYear"){
					EXCEL_SEARCH_DATA += $("#year option:selected").text();
				}else if(id == "divOpRate"){
					EXCEL_SEARCH_DATA += $("#opRateFrom").val() + " ~ " + $("#opRateTo").val();
				}else if(id == "divArRate"){
					EXCEL_SEARCH_DATA += $("#arRateFrom").val() + " ~ " + $("#arRateTo").val();
				}else if(id == "divConfirmYn"){
					EXCEL_SEARCH_DATA += $("#confirmYn option:selected").text();
				}
			}
		});
	}
	
</script>
</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp"%>
	<!-- left -->
	<div id="a" class="split split-horizontal">
		<!-- tree -->
		<div id="c" class="split content">
			<%@ include file="/WEB-INF/view/common/leftTree.jsp"%>
		</div>
		<!-- filter -->
		<div id="d" class="split content">
			<form id="searchForm" name="searchForm">
				<input type="hidden" id="ap1_yn" name="ap1_yn" />
				<input type="hidden" id="ap2_yn" name="ap2_yn" />
				<input type="hidden" id="goc_yn" name="goc_yn" />
				<input type="hidden" id="release_yn" name="release_yn" />
				<%-- <input type="hidden" id="menuParam" name="menuParam" value="${menuInfo.menuParam}" /> --%>
				<div id="filterDv">
					<div class="inner">
						<h3>Filter</h3>
						<%@ include file="/WEB-INF/view/common/filterMonthSum.jsp"%>
						<div class="tabMargin"></div>
						<div class="scroll">
							<div class="view_combo" id="divItem"></div>
							<div class="view_combo" id="divYear"></div>
							<div class="view_combo" id="divOpRate">
								<div class="ilist">
									<div class="itit"><spring:message code="lbl.opRate" /></div>
									<input type="text" id="opRateFrom" name="opRateFrom" class="ipt" style="width:55px"> <span class="ihpen">~</span>
									<input type="text" id="opRateTo" name="opRateTo" class="ipt" style="width:55px">
								</div> 
							</div>
							<div class="view_combo" id="divArRate">
								<div class="ilist">
									<div class="itit"><spring:message code="lbl.arRate" /></div>
									<input type="text" id="arRateFrom" name="arRateFrom" class="ipt" style="width:55px"> <span class="ihpen">~</span>
									<input type="text" id="arRateTo" name="arRateTo" class="ipt" style="width:55px">
								</div> 
							</div>
							<div class="view_combo" id="divConfirmYn"></div>
						</div>
						<div class="bt_btn">
							<a href="javascript:;" class="fl_app"><spring:message code="lbl.search" /></a>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
	<!-- contents -->
	<div id="b" class="split split-horizontal">
		<div id="grid1" class="fconbox">
			<%@ include file="/WEB-INF/view/common/commonLocation.jsp"%>
			<div class="scroll">
				<!-- 그리드영역 -->
				<div id="realgrid" class="realgrid1"></div>
				<div id="realgridExcel" class="realgrid1" style="display: none"></div>
			</div>
			<div class="cbt_btn" style="height:25px">
				<div class="bleft">
					<form id="excelForm" method="post" enctype="multipart/form-data">
						<input type="file" name="excelFile" id="excelFile" style="display: none;" />
						<input type="hidden" id="headerLine" name="headerLine" value="1" />
						<input type="hidden" id="columnNames" name="columnNames" />
					</form>
					<a style="display:none" href="javascript:;" id="btnCopy" class="app1 roleWrite"><spring:message code="lbl.copyST" /></a>
					<a style="display:none" href="javascript:;" id="btnExcelDown" class="app1 roleWrite"><spring:message code="lbl.excelDownload" /></a>
					<a style="display:none" href="javascript:;" id="btnExcelUpload" class="app1 roleWrite"><spring:message code="lbl.excelUpload" /></a>
					<a style="display:none" href="javascript:;" id="btnConfirmY" class="app1 roleWrite"><spring:message code="lbl.confirm" /></a>
					<a style="display:none" href="javascript:;" id="btnConfirmN" class="app1 roleWrite"><spring:message code="lbl.confirmCancel" /></a>
					<a style="display:none" href="javascript:;" id="btnRelease" class="app1 roleWrite"><spring:message code="lbl.release" /></a>
				</div>
				<div class="bright">
					<a style="display:none" href="javascript:;" id="btnReset" class="app1"><spring:message code="lbl.reset" /></a>
					<a style="display:none" href="javascript:;" id="btnSave" class="app2 roleWrite"><spring:message code="lbl.save" /></a>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
