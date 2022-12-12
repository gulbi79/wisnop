<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp"%>
<script type="text/javascript" src="${ctx}/statics/js/biz/gridcalc.js"></script>
<script type="text/javascript">
	//코드데이터
	var codeMap;
	//그리드
	var gridInstance, grdMain, dataProvider; 

	$(function() {
		
		//tree filter set 
    	gv_zTreeFilter.P = {lvl: ["L2","L3"]};
		
		gfn_formLoad(); 	//공통 초기화
		fn_initData(); 		//데이터 초기화
		fn_initFilter(); 	//필터 초기화
		fn_initGrid();		//그리드 초기화
		fn_initEvent();		//이벤트 초기화
	});

	//데이터 초기화
	function fn_initData() {
		codeMap = gfn_getComCodeEx(["ROUTING"], null, {itemType : "10"});
		//Role조회
		fn_getInitData();
	}
	
	//Role조회
	function fn_getInitData() {
		gfn_service({
			async   : false,
			url     : GV_CONTEXT_PATH + "/biz/obj.do",
			data    : {_mtd:"getList",tranData:[
				{outDs:"roleList",_siq:"dp.salesPlan.prodCapaAllocMfgRole"},
			]},
			success : function(data) {
				codeMap.CONFIRM_ROLE_YN = data.roleList[0].CONFIRM_ROLE_YN;
				codeMap.RELEASE_ROLE_YN = data.roleList[0].RELEASE_ROLE_YN;
			}
		}, "obj");
	}
	
	//필터 초기화
	function fn_initFilter() {
		//Plan ID
    	gfn_getPlanId({picketType:"M",planTypeCd:"DP_M"});
		//콤보박스
		gfn_setMsComboAll([
			{ target : 'divRouting', id : 'routing', title : '<spring:message code="lbl.routing"/>', data : codeMap.ROUTING, exData:[]},
		]);
	}
	
	//그리드를 초기화
	function fn_initGrid() {
		
		gv_bucketW = 120;
		
		//그리드 설정
		gridInstance = new GRID();
		gridInstance.init("realgrid");
		grdMain      = gridInstance.objGrid;
		dataProvider = gridInstance.objData;
		gridInstance.measureHFlag = true;
		
		//그리드 옵션
		grdMain.setOptions({
			stateBar: { visible      : true  },
			sorting : { enabled      : false },
			display : { columnMovable: false }
		});
		
		//스타일 추가
		grdMain.addCellStyles([
			{ id : "editStyleRow", editable : true, background : gv_editColor }
		]);
	}
	
	//이벤트 정의
	function fn_initEvent() {
		
		//버튼 이벤트
		$(".fl_app"     ).click ("on", function() { fn_apply(); });
		$("#btnConfirmY").click ("on", function() { fn_confirm("Y"); });
		$("#btnConfirmN").click ("on", function() { fn_confirm("N"); });
		$("#btnReleaseY").click ("on", function() { fn_release("Y"); });
		$("#btnReleaseN").click ("on", function() { fn_release("N"); });
		$("#btnReset"   ).click ("on", function() { fn_reset(); });
		$("#btnSave"    ).click ("on", function() { fn_save(); });
		
		//그리드 이벤트
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
			GRIDCALC.changeMap = [];
    	};
	}
	
	function fn_allInOneCalc(grid, itemIndex, dataRow, field, oldValue, newValue) {
		if ($.isArray(field)) {
			var tmpOldVal;
			$.each(field, function(n,v) {
				tmpOldVal = GRIDCALC.getChangeVal(dataProvider, dataRow, v, oldValue[n]);
				GRIDCALC.autoCalc(gridInstance, itemIndex, dataRow, field[n], tmpOldVal, newValue[n]);
			});
		} else {
			GRIDCALC.autoCalc(gridInstance, itemIndex, dataRow, field, oldValue, newValue);
		}
	}
	
	//조회
	function fn_apply(sqlFlag) {

		gfn_getMenuInit();		//디멘전 메저 조회
		fn_getBucket();			//버켓정보 조회
		fn_drawGrid(sqlFlag);	//그리드를 그린다.

		//조회조건 설정
		FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
		FORM_SEARCH.sql		   = sqlFlag;
		FORM_SEARCH.hrcyFlag   = true;
		FORM_SEARCH.dimList	   = DIMENSION.user;
		FORM_SEARCH.meaList	   = MEASURE.user;
		FORM_SEARCH.bucketList = BUCKET.query;

		//메인 데이터를 조회
		fn_getGridData();
		fn_getExcelData();
	}
	
	//버켓정보 조회
	function fn_getBucket() {
		var ajaxMap = {
			fromDate : $("#fromMon").val().replace(/-/g, '')+"01",
			toDate   : $("#toMon"  ).val().replace(/-/g, '')+"01",
			month    : {isDown: "Y", isUp:"N", upCal:"Q", isMt:"N", isExp:"N", expCnt:999},
			sqlId    : ["bucketMonth"]
		}
		gfn_getBucket(ajaxMap,true);
	}
	
	//그리드를 그린다.
	function fn_drawGrid(sqlFlag) {
		
		if (sqlFlag) {
			return;
		}
		
		// 데이터셋에만 존재하는 컬럼 추가
    	DIMENSION.hidden = [];
    	DIMENSION.hidden.push({CD:"CONFIRM_YN", dataType:"text"});

    	//버킷명 재구성
    	$.each(BUCKET.query, function(idx, item) {
    		//numberFormat
    		if (item.CD.indexOf("WORKING_DAYS") != -1) { item.numberFormat = "#,###.0"; }
		});
    	
		gridInstance.setDraw();
	}
	
	//그리드 데이터 조회
	function fn_getGridData(sqlFlag) {
		
		FORM_SEARCH._mtd     = "getList";
		FORM_SEARCH.tranData = [{outDs:"gridList",_siq:"dp.salesPlan.prodCapaAllocMfg"}];
		
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
				// 그리드 데이터 건수 출력
				gfn_setSearchRow(dataProvider.getRowCount());
				fn_setBtnDisplay();
				fn_gridCallback();
				gfn_setRowTotalFixed(grdMain);
			}
		}, "obj");
	}
	
	function fn_gridCallback() {
		
		if (!fn_gridIsEdit()) {
			return;
		}
		
		var startBucket = $("#startMonth").val();
		var endBucket   = $("#endMonth"  ).val();
		for (var i=0; i<dataProvider.getRowCount(); i++) {
			
			if (dataProvider.getValue(i, "GRP_LVL_ID") != "0") {
				continue;
			}
			
			if (dataProvider.getValue(i, "CONFIRM_YN") != "N") {
				continue;
			}
			
			$.each(BUCKET.query, function(idx, item) {
				if (item.CD.indexOf("PROD_CAPA_QTY") != -1) {
					if (item.BUCKET_VAL >= startBucket && item.BUCKET_VAL <= endBucket) {
						grdMain.setCellStyles([i], [item.CD], "editStyleRow");
					}
				}
			});
		}
	}
	
	// Dimension & Measure 존재 유무에따라 수정가능 불가능 판단
	function fn_gridIsEdit() {
		
		if (dataProvider.getRowCount() == 0) {
			return false;
		}
		
		var is_routing_id   = false;
		var is_prod_lvl3_cd = false;
		
		// Dimension 
		$.each(DIMENSION.user, function(n,v) {
			if      (v.DIM_CD == "ROUTING_ID"  ) is_routing_id   = true;
			else if (v.DIM_CD == "PROD_LVL3_CD") is_prod_lvl3_cd = true;
			
			if (is_routing_id && is_prod_lvl3_cd) {
				return false;
			}
		});

		if (is_routing_id && is_prod_lvl3_cd) {
			
			var is_mea_cd = false;
			
			// Measure
			$.each(MEASURE.user, function(n,v) {
				if (v.CD == "PROD_CAPA_QTY") is_mea_cd = true;
				
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
	
	//버튼처리
	function fn_setBtnDisplay() {
		
		var isEdit = false;
		var isFlag = false;
		
		if (fn_gridIsEdit()) {
			isEdit = true;
		}
		
		if ($("#cutOffFlag").val() != "Y") {
			isFlag = true;
		}
		
		if (isEdit && isFlag) {
			$("#btnReset,#btnSave").show();
		} else {
			$("#btnReset,#btnSave").hide();
		}
		
		if (isEdit && isFlag && codeMap.CONFIRM_ROLE_YN == "Y") {
			$("#btnConfirmY,#btnConfirmN").show();
		} else {
			$("#btnConfirmY,#btnConfirmN").hide();
		}
		
		if (isEdit && isFlag && codeMap.RELEASE_ROLE_YN == "Y") {
			$("#btnReleaseY,#btnReleaseN").show();
		} else {
			$("#btnReleaseY,#btnReleaseN").hide();
		}
		
		if ($("#saveYn").val() != "Y") {
			$(".roleWrite").hide();
		}
	}
	
	//그리드 초기화
	function fn_reset() {
		grdMain.cancel();
		dataProvider.rollback(dataProvider.getSavePoints()[0]);
		fn_gridCallback();
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
				} else {
					jsonRows[i].CONFIRM_YN = confirm_yn;
				}
			}
			
			// 저장할 데이터 정리
			var monthBucket        = fn_getMonthBucket(FORM_SEARCH.startMonth, FORM_SEARCH.endMonth);
			var capaAllocProdDatas = [];
			$.each(jsonRows, function(i, row) {

				var capaData = {
					ROUTING_ID   : row.ROUTING_ID,
					PROD_LVL3_CD : row.PROD_LVL3_CD,
					BUCKET_LIST  : []
				};
				
				var monthMes;
				$.each(monthBucket, function(idx, item) {
					monthMes = "M"+item+"_PROD_CAPA_QTY";
					capaData.BUCKET_LIST.push({
						YEARMONTH : item,
						CAPA_QTY  : -1
					});
				});
				
				capaAllocProdDatas.push(capaData);
			});
			
			// 실제저장
			FORM_SAVE            = {}; //초기화
			FORM_SAVE._mtd       = "saveUpdate";
			FORM_SAVE.planId     = FORM_SEARCH.planId;
			FORM_SAVE.startMonth = FORM_SEARCH.startMonth; 
			FORM_SAVE.endMonth   = FORM_SEARCH.endMonth;
			FORM_SAVE.tranData   = [
				{outDs:"saveCnt1",_siq:"dp.salesPlan.prodCapaAllocMfg"       ,grdData:capaAllocProdDatas},
				{outDs:"saveCnt2",_siq:"dp.salesPlan.prodCapaAllocMfgConfirm",grdData:jsonRows}
			];
			
			gfn_service({
				url    : GV_CONTEXT_PATH + "/biz/obj.do",
				data   : FORM_SAVE,
				success: function(data) {
					alert('<spring:message code="msg.saveOk"/>');
					fn_apply();
				}
			}, "obj");
		});
	}
	
	function fn_release(release_flag) {
		
		if (dataProvider.getRowCount() == 0) {
			alert('<spring:message code="msg.noDataFound"/>');
			return;
		}
		
		// 저장
		confirm('<spring:message code="msg.saveCfm"/>', function() {
			
			var planInfo = [{
				PLAN_ID      : FORM_SEARCH.planId,
				RELEASE_FLAG : release_flag
			}];
			
			// 실제저장
			FORM_SAVE          = {}; //초기화
			FORM_SAVE._mtd     = "saveUpdate";
			FORM_SAVE.tranData = [
				{outDs:"saveCnt",_siq:"dp.salesPlan.prodCapaAllocMfgRelease",grdData:planInfo},
			];
			
			gfn_service({
				url    : GV_CONTEXT_PATH + "/biz/obj.do",
				data   : FORM_SAVE,
				success: function(data) {
					alert('<spring:message code="msg.saveOk"/>');
					fn_apply();
				}
			}, "obj");
		});
	}
	
	function fn_getMonthBucket(startMonth, endMonth) {
		
		var startDate  = new Date(startMonth.substring(0,4)+"-"+startMonth.substring(4,6)+"-01");
		var endDate    = new Date(endMonth  .substring(0,4)+"-"+endMonth  .substring(4,6)+"-01");
		
		//월수차이
		var diff = (endDate.getFullYear()-startDate.getFullYear())*12 + (endDate.getMonth()-startDate.getMonth());
		if (diff < 0) {
			return [];
		} else if (diff == 0) {
			return [startMonth];
		} else {
			var month;
			var monthBucket = [startMonth];
			for (var i = 1; i <= diff; i++) {
				month = startDate.getMonth()+1;
				startDate.setMonth(month);
				month = startDate.getMonth()+1;
				monthBucket.push(startDate.getFullYear()+(month>9?"":"0")+month);
			}
			return monthBucket;
		}
	}
	
	//저장
	function fn_save() {

		var jsonRows = gfn_getGrdSavedataAll(grdMain);
		for (var i = jsonRows.length-1; i >= 0; i--) {
			if (jsonRows[i].GRP_LVL_ID != "0") {
				jsonRows.splice(i, 1);
			}
		}
		
		if (jsonRows.length == 0) {
			alert('<spring:message code="msg.noChangeData"/>');
			return;
		}
		
		// 저장
		confirm('<spring:message code="msg.saveCfm"/>', function() {
		
			// 저장할 데이터 정리
			var monthBucket        = fn_getMonthBucket(FORM_SEARCH.startMonth, FORM_SEARCH.endMonth);
			var capaAllocProdDatas = [];
			$.each(jsonRows, function(i, row) {

				var capaData = {
					ROUTING_ID   : row.ROUTING_ID,
					PROD_LVL3_CD : row.PROD_LVL3_CD,
					BUCKET_LIST  : []
				};
				
				var monthMes;
				$.each(monthBucket, function(idx, item) {
					monthMes = "M"+item+"_PROD_CAPA_QTY";
					capaData.BUCKET_LIST.push({
						YEARMONTH : item,
						CAPA_QTY  : row[monthMes] == undefined ? 'NULL' : row[monthMes]
					});
				});
				
				capaAllocProdDatas.push(capaData);
			});
			
			// 실제저장
			FORM_SAVE            = {}; //초기화
			FORM_SAVE._mtd       = "saveUpdate";
			FORM_SAVE.planId     = FORM_SEARCH.planId;
			FORM_SAVE.startMonth = FORM_SEARCH.startMonth; 
			FORM_SAVE.endMonth   = FORM_SEARCH.endMonth;
			FORM_SAVE.tranData   = [
				{outDs:"saveCnt",_siq:"dp.salesPlan.prodCapaAllocMfg",grdData:capaAllocProdDatas},
			];
			
			gfn_service({
				url    : GV_CONTEXT_PATH + "/biz/obj.do",
				data   : FORM_SAVE,
				success: function(data) {
					alert('<spring:message code="msg.saveOk"/>');
					fn_apply();
				}
			}, "obj");
		});
	}
	
	function fn_checkClose() {
		return gfn_getGrdSaveCount(grdMain) == 0;
	}
	
	function fn_getExcelData(){
		
		EXCEL_SEARCH_DATA = "";
		EXCEL_SEARCH_DATA += "Product" + " : ";
		EXCEL_SEARCH_DATA += $("#loc_product").html();
		
		$.each($(".view_combo"), function(i, val){
			
			var temp = "";
			var id = gfn_nvl($(this).attr("id"), "");
			
			if(id != ""){
				
				var name = $("#" + id + " .ilist .itit").html();
				
				//타이틀
				EXCEL_SEARCH_DATA += "\n" + name + " : ";	
				
				//데이터
				if(id == "divRouting"){
					$.each($("#routing option:selected"), function(i2, val2){
						
						var txt = gfn_nvl($(this).text(), "");
						
						if(i2 == 0){
							temp = txt;								
						}else{
							temp += ", " + txt;
						}
					});		
					EXCEL_SEARCH_DATA += temp;
				}else if(id == "divPlanId"){
					EXCEL_SEARCH_DATA += $("#planId option:selected").text();
				}
			}
		});
		
		EXCEL_SEARCH_DATA += "\n" + $("#view_Her .tlist .tit").html() + " : ";
		EXCEL_SEARCH_DATA += $("#fromMon").val() + " ~ " + $("#toMon").val();
		
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
				<div id="filterDv">
					<div class="inner">
						<h3>Filter</h3>
						<div class="tabMargin"></div>
						<div class="scroll">
							<div class="view_combo" id="divRouting"></div>
							<jsp:include page="/WEB-INF/view/common/filterPlanViewHorizon.jsp" flush="false">
								<jsp:param name="wType" value="M"/>
							</jsp:include>
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
			</div>
			<div class="cbt_btn" style="height:25px">
				<div class="bleft">
					<a style="display:none" href="javascript:;" id="btnConfirmY" class="app1 roleWrite"><spring:message code="lbl.confirm" /></a>
					<a style="display:none" href="javascript:;" id="btnConfirmN" class="app1 roleWrite"><spring:message code="lbl.confirmCancel" /></a>
					<a style="display:none" href="javascript:;" id="btnReleaseY" class="app1 roleWrite"><spring:message code="lbl.release" /></a>
					<a style="display:none" href="javascript:;" id="btnReleaseN" class="app1 roleWrite"><spring:message code="lbl.releaseCancel" /></a>
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
