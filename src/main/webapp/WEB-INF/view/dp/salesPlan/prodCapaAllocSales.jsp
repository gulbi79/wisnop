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
    	gv_zTreeFilter.C = {lvl: ["L2"]};
		
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
		
		GRIDCALC.apMeaCd   = "ALLOC_QTY_ADJ";
		GRIDCALC.amtMeaCd = ["ALLOC_QTY_ORIGIN_SUM"];
	}
	
	//Role조회
	function fn_getInitData() {
		gfn_service({
			async   : false,
			url     : GV_CONTEXT_PATH + "/biz/obj.do",
			data    : {_mtd:"getList",tranData:[
				{outDs : "roleList", _siq : "dp.salesPlan.prodCapaAllocSalesRole"},
				{outDs : "totalCnt", _siq : "dp.salesPlan.prodCapaAllocSalesTotal"}
			]},
			success : function(data) {
				
				codeMap.CONFIRM_ROLE_YN = data.roleList[0].CONFIRM_ROLE_YN;
				codeMap.GOC_ROLE_YN     = data.roleList[0].GOC_ROLE_YN;
				codeMap.AP2_ROLE_YN     = data.roleList[0].AP2_ROLE_YN;
				codeMap.TOTAL_CNT       = data.totalCnt[0].TOT_CNT;
				
			}
		}, "obj");
	}
	
	//필터 초기화
	function fn_initFilter() {
		//Plan ID
    	gfn_getPlanId({picketType:"M",planTypeCd:"DP_M",releaseFlag:"Y"});
		//콤보박스
		gfn_setMsComboAll([
			{ target : 'divRouting', id : 'routing', title : '<spring:message code="lbl.routing"/>', data : codeMap.ROUTING, exData:[]},
		]);
	}
	
	//그리드를 초기화
	function fn_initGrid() {
		
		gv_bucketW = 60;
		
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
		$("#btnReset"   ).click ("on", function() { fn_reset(); });
		$("#btnSave"    ).click ("on", function() { fn_save(); });
		
		//그리드 이벤트
		GRIDCALC.bsc.flag = true;
		GRIDCALC.bsc.callback = function(provider, idx, field) {

			var filedName = dataProvider.getFieldName(field);
			var meaPrefix = filedName.substring(0,8);
			
			if (filedName.indexOf("ALLOC_QTY_ORIGIN") != -1) {
				//DELTA
				fn_calcCallbackDELTA(provider, idx, meaPrefix);
				//RATE_M
				fn_calcCallbackRATE_M(provider, idx, meaPrefix, filedName);
			} else if (filedName.indexOf("ALLOC_QTY_ADJ") != -1) {
				//DELTA
				fn_calcCallbackDELTA(provider, idx, meaPrefix);
				//ALLOC_QTY_W
				fn_calcCallbackALLOC_QTY_W(provider, idx, meaPrefix);
				//RATE
				fn_calcCallbackRATE(provider, idx, meaPrefix);
				//RATE_M
				fn_calcCallbackRATE_M(provider, idx, meaPrefix, filedName);
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
			GRIDCALC.changeMap = [];
    	};
	}
	
	function fn_searchAllocQtyOrigin(provider, idx, meaPrefix) {
		
		var info = {
			start : idx,
			end   : idx,
			sum   : 0
		};
		
		var searchRoutingId  = provider.getValue(idx, "ROUTING_ID"  );
		var searchProdLvl3Cd = provider.getValue(idx, "PROD_LVL3_CD");
		
		//Search : Start Index 
		for (var i = idx-1; i >= 0; i--) {
			if (searchRoutingId  != provider.getValue(i, "ROUTING_ID"  ) ||
				searchProdLvl3Cd != provider.getValue(i, "PROD_LVL3_CD")) {
			}
			if (provider.getValue(i, gv_grpLvlId) != "0") {
				break;
			}
			info.start = i;
		}
		
		//Search : End Index 
		for (var i = idx+1; i < provider.getRowCount(); i++) {
			if (searchRoutingId  != provider.getValue(i, "ROUTING_ID"  ) ||
				searchProdLvl3Cd != provider.getValue(i, "PROD_LVL3_CD")) {
			}
			if (provider.getValue(i, gv_grpLvlId) != "0") {
				break;
			}
			info.end = i;
		}
		
		//Sum : ALLOC_QTY_ORIGIN
		for (var i = info.start; i <= info.end; i++) {
			info.sum += provider.getValue(i, meaPrefix+"ALLOC_QTY_ORIGIN");
		}
		
		return info;
	}
	
	function fn_isBucketQuery(bucketCD) {
		var isSearch = false;
		$.each(BUCKET.query, function(idx, item) {
			if (item.CD == bucketCD) {
				isSearch = true;
				return false;
			}
		});
		return isSearch;
	}
	
	//DELTA = ALLOC_QTY_ADJ - ALLOC_QTY_ORIGIN
	function fn_calcCallbackDELTA(provider, idx, meaPrefix) {
		if (fn_isBucketQuery(meaPrefix+"DELTA")) {
			var newDelta = provider.getValue(idx, meaPrefix+"ALLOC_QTY_ADJ")
			             - provider.getValue(idx, meaPrefix+"ALLOC_QTY_ORIGIN");
			provider.setValue(idx, meaPrefix+"DELTA", newDelta);
		}
	}
	
	//ALLOC_QTY_W = ROUND(ALLOC_QTY_ADJ / WORKING_DAYS * 5.5, 1)
	function fn_calcCallbackALLOC_QTY_W(provider, idx, meaPrefix) {
		if (fn_isBucketQuery(meaPrefix+"ALLOC_QTY_W")) {
		
			var allocQtyAdj  = provider.getValue(idx, meaPrefix+"ALLOC_QTY_ADJ");
			var workingDays  = provider.getValue(idx, meaPrefix+"WORKING_DAYS");
			var newAllocQtyW = 0;
			
			if (workingDays != 0) {
				newAllocQtyW = (allocQtyAdj / workingDays * 5.5).toFixed(1);
			}
			
			provider.setValue(idx, meaPrefix+"ALLOC_QTY_W", newAllocQtyW);
		}
	}
	
	//RATE = ROUND((SALES_QTY_CUM + REQ_PROD_QTY) / ALLOC_QTY_ADJ * 100, 1)
	function fn_calcCallbackRATE(provider, idx, meaPrefix) {
		if (fn_isBucketQuery(meaPrefix+"RATE")) {
			
			var salesQtyCum = provider.getValue(idx, meaPrefix+"SALES_QTY_CUM");
			var reqProdQty  = provider.getValue(idx, meaPrefix+"REQ_PROD_QTY");
			var allocQtyAdj = provider.getValue(idx, meaPrefix+"ALLOC_QTY_ADJ");
			var newRate     = 0;
			
			if (allocQtyAdj != 0) {
				newRate = ((salesQtyCum + reqProdQty) / allocQtyAdj * 100).toFixed(1);
			}
			
			provider.setValue(idx, meaPrefix+"RATE", newRate);
		}
	}
	
	//RATE_M = ROUND(ALLOC_QTY_ADJ / ∑(ALLOC_QTY_ORIGIN) * 100), 1)
	function fn_calcCallbackRATE_M(provider, idx, meaPrefix, filedName) {
		if (fn_isBucketQuery(meaPrefix+"RATE_M")) {
		
			if (provider.getValue(idx, gv_grpLvlId) == "0") {
				
				var allocQtyOriginInfo = fn_searchAllocQtyOrigin(provider, idx, meaPrefix);
				
				var startIdx = idx, endIdx = idx;
				if (filedName.indexOf("ALLOC_QTY_ORIGIN") != -1) {
					startIdx = allocQtyOriginInfo.start;
					endIdx   = allocQtyOriginInfo.end;
				}
				
				var allocQtyAdj, newRateM;
				for (var i = startIdx; i <= endIdx; i++) {
					
					if (allocQtyOriginInfo.sum == 0) {
						newRateM = 0;
					} else {
						allocQtyAdj = provider.getValue(i, meaPrefix+"ALLOC_QTY_ADJ");
						newRateM = (allocQtyAdj / allocQtyOriginInfo.sum * 100).toFixed(1); 
					}
		
					provider.setValue(i, meaPrefix+"RATE_M", newRateM);
				}
				
			} else {
				
				var allocQtyAdj    = provider.getValue(i, meaPrefix+"ALLOC_QTY_ADJ");
				var allocQtyOrigin = provider.getValue(i, meaPrefix+"ALLOC_QTY_ORIGIN");
				var newRateM       = (allocQtyAdj / allocQtyOrigin * 100).toFixed(1);
				provider.setValue(i, meaPrefix+"RATE_M", newRateM);
			}
		}
	}
	
	function fn_allInOneCalc(grid, itemIndex, dataRow, field, oldValue, newValue) {
		if ($.isArray(field)) {
			
			var tmpOldVal;
			var jsonRows = dataProvider.getJsonRows();
			
			$.each(field, function(n, v) {
				var fieldName = dataProvider.getFieldName(v);
				var fieldNameSplit = fieldName.split("_")[0];
				var prodCapaQtySumField = fieldNameSplit + "_PROD_CAPA_QTY_SUM";
				var allocQtyAdjSumField = fieldNameSplit + "_ALLOC_QTY_ADJ_SUM";
				var rankNumField = fieldNameSplit + "_RANK_NUM";
				
				var prodCapaQtySum = dataProvider.getValue(dataRow, prodCapaQtySumField);
				var allocQtyAdjSum = dataProvider.getValue(dataRow, allocQtyAdjSumField);
				var rankNum = dataProvider.getValue(dataRow, rankNumField);
				
				var calValCapa = Math.round(prodCapaQtySum * 1.1); //월 생산 Capa
				var calValAdj = Number(allocQtyAdjSum) - Number(oldValue) + Number(newValue); //영업조정
				
				if(calValAdj > calValCapa ){
					alert('<spring:message code="msg.prodMax"/>');
					dataProvider.setValue(dataRow, field, oldValue);
				}else{
					
					tmpOldVal = GRIDCALC.getChangeVal(dataProvider, dataRow, v, oldValue[n]);
					GRIDCALC.autoCalc(gridInstance, itemIndex, dataRow, field[n], tmpOldVal, newValue[n]);
					
					$.each(jsonRows, function(nn, vv){
						
						var tGrpLvlId = vv.GRP_LVL_ID;
						var tRankNum = eval("vv." + fieldNameSplit + "_RANK_NUM");
						
						if(tGrpLvlId == "0" && rankNum == tRankNum){
							dataProvider.setValue(nn, allocQtyAdjSumField, calValAdj);
						}
					});
				}
				
			});
		} else {
			
			var jsonRows = dataProvider.getJsonRows();
			var fieldName = dataProvider.getFieldName(field)
			var fieldNameSplit = fieldName.split("_")[0];
			var prodCapaQtySumField = fieldNameSplit + "_PROD_CAPA_QTY_SUM";
			var allocQtyAdjSumField = fieldNameSplit + "_ALLOC_QTY_ADJ_SUM";
			var rankNumField = fieldNameSplit + "_RANK_NUM";
			
			var prodCapaQtySum = dataProvider.getValue(dataRow, prodCapaQtySumField);
			var allocQtyAdjSum = dataProvider.getValue(dataRow, allocQtyAdjSumField);
			var rankNum = dataProvider.getValue(dataRow, rankNumField);
			
			var calValCapa = Math.round(prodCapaQtySum * 1.1); //월 생산 Capa
			var calValAdj = Number(allocQtyAdjSum) - Number(oldValue) + Number(newValue); //영업조정
			
			if(calValAdj > calValCapa ){
				alert('<spring:message code="msg.prodMax"/>');
				dataProvider.setValue(dataRow, field, oldValue);
			}else{
				GRIDCALC.autoCalc(gridInstance, itemIndex, dataRow, field, oldValue, newValue);
				
				$.each(jsonRows, function(n, v){
					
					var tGrpLvlId = v.GRP_LVL_ID;
					var tRankNum = eval("v." + fieldNameSplit + "_RANK_NUM");
					
					if(tGrpLvlId == "0" && rankNum == tRankNum){
						dataProvider.setValue(n, allocQtyAdjSumField, calValAdj);
					}
				});
			}
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
		FORM_SEARCH.monthList  = BUCKET.all[0];
		
		//console.log("FORM_SEARCH : ", FORM_SEARCH);

		//메인 데이터를 조회
		fn_getGridData();
		fn_getExcelData();
	}
	
	//버켓정보 조회
	function fn_getBucket() {
		
		//전체메저조회
		fn_getMeaInfo();
		
		//버켓정보조회
		var ajaxMap = {
			fromDate : $("#fromMon").val().replace(/-/g, '')+"01",
			toDate   : $("#toMon"  ).val().replace(/-/g, '')+"01",
			month    : {isDown: "Y", isUp:"N", upCal:"Q", isMt:"N", isExp:"N", expCnt:999},
			sqlId    : ["bucketMonth"]
		}
		gfn_getBucket(ajaxMap, true);
		
		//미사용 버킷 삭제
		fn_removeBucket(BUCKET.query);
		fn_removeBucket(BUCKET.all[1]);
		
		//버킷 속성 변경
    	$.each(BUCKET.query, function(idx, item) {
    		
    		//header
    		if      (item.CD.indexOf("ALLOC_QTY_ORIGIN") != -1) { item.NM += " ①"; }
    		else if (item.CD.indexOf("ALLOC_QTY_ADJ"   ) != -1) { item.NM += " ②"; item.CD_SUB = item.ROOT_CD + "_ALLOC_QTY_ADJ_SUM";}
    		else if (item.CD.indexOf("DELTA"           ) != -1) { item.NM += " (② - ①)"; }
    		else if (item.CD.indexOf("RATE_M"          ) != -1) { item.NM += "(%, ②/∑①)"; }
    		else if (item.CD.indexOf("SALES_QTY_CUM"   ) != -1) { item.NM += " ③"; }
    		else if (item.CD.indexOf("REQ_PROD_QTY"    ) != -1) { item.NM += " ④"; }
    		else if (item.CD.indexOf("RATE"            ) != -1) { item.NM += " (%,③+④/②)"; }
    		//nanText
    		if      (item.CD.indexOf("PROD_CAPA_QTY"   ) != -1) { item.nanText = ""; item.CD_SUB = item.ROOT_CD + "_PROD_CAPA_QTY_SUM"; item.CD_SUB2 = item.ROOT_CD + "_RANK_NUM";}
    		else if (item.CD.indexOf("RATE_M"          ) != -1) { item.nanText = ""; }
    		//numberFormat
    		if      (item.CD.indexOf("ALLOC_QTY_W"     ) != -1) { item.numberFormat = "#,###.0"; }
    		else if (item.CD.indexOf("RATE_M"          ) != -1) { item.numberFormat = "#,###.0"; }
    		else if (item.CD.indexOf("RATE"            ) != -1) { item.numberFormat = "#,###.0"; }
    	});
	}
	
	//전체메저조회
	function fn_getMeaInfo() {
		
		gfn_service({
		    async   : false,
		    url     : GV_CONTEXT_PATH + "/biz/obj.do",
		    data    : {
		    	_mtd           : "getList",
		    	SEARCH_MENU_CD : "${menuInfo.menuCd}",
		    	tranData       : [{outDs:"meaList",_siq:"common.meaConf"}]
		    },
		    success :function(data) {
				
		    	MEASURE.bak    = MEASURE.user;
		    	MEASURE.user   = [];
		    	MEASURE.remove = [];
		    	
		    	var isSearch;
		    	$.each(data.meaList, function(i, mea) {
		    		
		    		mea.CD = mea.MEAS_CD;
		    		mea.NM = mea.MEAS_NM;
		    		MEASURE.user.push(mea);
		    		
		    		isSearch = false;
		    		$.each(MEASURE.bak, function(j, bakMea) {
		    			if (mea.CD == bakMea.CD) {
		    				isSearch = true;
		    				return false;
		    			}
		    		});
		    		
		    		if (!isSearch) {
		    			MEASURE.remove.push(mea);
		    		}
		    	});
		    	
		    	MEASURE.user.push({ CD : "WORKING_DAYS", NM : "WORKING_DAYS" });
		    }
		}, "obj");
	}
	
	//미사용 버킷 삭제
	function fn_removeBucket(obj) {
		
		var tempMonth, startMonth = "M"+$("#startMonth").val();
    	for (var i = obj.length-1; i >= 0; i--) {
    		
    		tempMonth = obj[i].CD.substring(0,7);
    		
    		//과거구간
    		if (tempMonth < startMonth) {
				//버켓에서 미사용 메저삭제
    			if (obj[i].CD.indexOf("WORKING_DAYS"    ) == -1 &&
    				obj[i].CD.indexOf("PROD_CAPA_QTY"   ) == -1 &&
    				obj[i].CD.indexOf("ALLOC_QTY_ORIGIN") == -1 &&
    				obj[i].CD.indexOf("ALLOC_QTY_ADJ"   ) == -1 &&
    				obj[i].CD.indexOf("DELTA"           ) == -1) {
    				obj.splice(i, 1);
    				continue;
    			}
			}
    		//미래구간
    		else if (tempMonth > startMonth) {
    			//버켓에서 미사용 메저삭제
				if (obj[i].CD.indexOf("WORKING_DAYS"    ) == -1 &&
					obj[i].CD.indexOf("CFM_SP"          ) == -1 &&
					obj[i].CD.indexOf("PROD_CAPA_QTY"   ) == -1 &&
					obj[i].CD.indexOf("ALLOC_QTY_ORIGIN") == -1 &&
					obj[i].CD.indexOf("ALLOC_QTY_ADJ"   ) == -1 &&
					obj[i].CD.indexOf("DELTA"           ) == -1 &&
					obj[i].CD.indexOf("ALLOC_QTY_W"     ) == -1 &&
					obj[i].CD.indexOf("RATE_M"          ) == -1) {
					obj.splice(i, 1);
    				continue;
				}
    		}
    	}
	}
	
	//그리드를 그린다.
	function fn_drawGrid(sqlFlag) {
		
		if (sqlFlag) {
			return;
		}
		
		// 데이터셋에만 존재하는 컬럼 추가
    	DIMENSION.hidden = [];
    	DIMENSION.hidden.push({CD:"CONFIRM_YN", dataType:"text"});
    	
    	$.each(BUCKET.all[0], function(n, v){
    		DIMENSION.hidden.push({CD : v.CD + "_PROD_CAPA_QTY_SUM", dataType:"text"});
    		DIMENSION.hidden.push({CD : v.CD + "_ALLOC_QTY_ADJ_SUM", dataType:"text"});
    		DIMENSION.hidden.push({CD : v.CD + "_RANK_NUM", dataType:"text"});
    	});
    	
    	//그리드 그리기
		gridInstance.setDraw();
		
		//버킷컬럼 재구성
		var tempMonth, dynamicStyles;
		$.each(BUCKET.query, function(idx, item) {
			
			tempMonth = item.CD.substring(0,7);
			
			//미사용컬럼 삭제
			$.each(MEASURE.remove, function(n, v) {
				if (item.CD.indexOf(v.CD) != -1) {
					grdMain.removeColumn(item.CD, tempMonth);
					grdMain.setColumnProperty(tempMonth, "width", grdMain.getColumnProperty(tempMonth, "width")-gv_bucketW);
				}
			});
			if (item.CD.indexOf("WORKING_DAYS") != -1) {
				grdMain.removeColumn(item.CD, tempMonth);
				grdMain.setColumnProperty(tempMonth, "width", grdMain.getColumnProperty(tempMonth, "width")-gv_bucketW);
			}
			
			//스타일적용
			if (item.CD.indexOf("DELTA") != -1) {
				dynamicStyles = grdMain.getColumnProperty(item.CD, "dynamicStyles");
				if (dynamicStyles != undefined) {
					dynamicStyles.push({
						criteria: "value >= 0",
						styles   : "foreground=#ff0000ff"
					});
					grdMain.setColumnProperty(item.CD, "dynamicStyles", dynamicStyles);
				}
			}
		});
	}
	
	//그리드 데이터 조회
	function fn_getGridData(sqlFlag) {
		
		FORM_SEARCH._mtd     = "getList";
		FORM_SEARCH.tranData = [{outDs:"gridList",_siq:"dp.salesPlan.prodCapaAllocSales"}];
		
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
				//
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
				/* 
				if (item.CD.indexOf("ALLOC_QTY_ORIGIN") != -1) {
					if (codeMap.GOC_ROLE_YN == "Y" || codeMap.AP2_ROLE_YN == "Y") {
						if (item.BUCKET_VAL >= startBucket && item.BUCKET_VAL <= endBucket) {
							grdMain.setCellStyles([i], [item.CD], "editStyleRow");
						}
					}
				}
				 */
				if (item.CD.indexOf("ALLOC_QTY_ADJ") != -1) {
					if ($("#saveYn").val() == "Y") {
						if (item.BUCKET_VAL >= startBucket && item.BUCKET_VAL <= endBucket) {
							grdMain.setCellStyles([i], [item.CD], "editStyleRow");
						}
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
		var is_cust_lvl2_cd = false;
		
		// Dimension 
		$.each(DIMENSION.user, function(n,v) {
			if      (v.DIM_CD == "ROUTING_ID"  ) is_routing_id   = true;
			else if (v.DIM_CD == "PROD_LVL3_CD") is_prod_lvl3_cd = true;
			else if (v.DIM_CD == "CUST_LVL2_CD") is_cust_lvl2_cd = true;

			if (is_routing_id && is_prod_lvl3_cd && is_cust_lvl2_cd) {
				return false;
			}
		});

		if (is_routing_id && is_prod_lvl3_cd && is_cust_lvl2_cd) {
			
			var is_mea_cd = false;
			
			// Measure
			$.each(MEASURE.user, function(n,v) {
				if      (v.CD == "ALLOC_QTY_ORIGIN") is_mea_cd = true;
				else if (v.CD == "ALLOC_QTY_ADJ"   ) is_mea_cd = true;
				
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
		/* 
		if (dataProvider.getRowCount() == 0) {
			alert('<spring:message code="msg.noDataFound"/>');
			return;
		}
		 */
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
					CUST_LVL2_CD : row.CUST_LVL2_CD,
					BUCKET_LIST  : []
				};
				
				$.each(monthBucket, function(idx, item) {
					capaData.BUCKET_LIST.push({
						YEARMONTH    : item,
						CAPA_QTY     : -1,
						ADJ_CAPA_QTY : -1
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
				{outDs : "saveCnt1", _siq : "dp.salesPlan.prodCapaAllocSales", grdData : capaAllocProdDatas},
				{outDs : "saveCnt2", _siq : "dp.salesPlan.prodCapaAllocSalesConfirm", grdData : jsonRows}
			];
			
			//console.log("fn_confirm FORM_SAVE : ", FORM_SAVE);
			
			//return;
			
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
	
	//저장
	function fn_save() {

		//var jsonRows = gfn_getGrdSavedataAll(grdMain);
		var jsonRows = dataProvider.getJsonRows();
		
		for (var i = jsonRows.length-1; i >= 0; i--) {
			if (jsonRows[i].GRP_LVL_ID != "0") {
				jsonRows.splice(i, 1);
			}
		}
		
		if (jsonRows.length == 0) {
			alert('<spring:message code="msg.noChangeData"/>');
			return;
		}
		
		if(codeMap.TOTAL_CNT != jsonRows.length){
			alert('<spring:message code="msg.totCnt"/>');
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
					CUST_LVL2_CD : row.CUST_LVL2_CD,
					BUCKET_LIST  : []
				};
				
				$.each(monthBucket, function(idx, item) {
					capaData.BUCKET_LIST.push({
						YEARMONTH    : item,
						CAPA_QTY     : row["M"+item+"_ALLOC_QTY_ORIGIN"] == undefined ? -1 : row["M"+item+"_ALLOC_QTY_ORIGIN"],
						ADJ_CAPA_QTY : row["M"+item+"_ALLOC_QTY_ADJ"   ] == undefined ? -1 : row["M"+item+"_ALLOC_QTY_ADJ"   ]
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
				{outDs : "saveCnt", _siq : "dp.salesPlan.prodCapaAllocSales", grdData : capaAllocProdDatas},
			];
			
			//console.log("FORM_SAVE : ", FORM_SAVE);
			
			//return;
			
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
	
	function fn_getExcelData(){
		
		EXCEL_SEARCH_DATA = "";
		EXCEL_SEARCH_DATA += "Product" + " : ";
		EXCEL_SEARCH_DATA += $("#loc_product").html();
		EXCEL_SEARCH_DATA += "\nCustomer" + " : ";
		EXCEL_SEARCH_DATA += $("#loc_customer").html();
		
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
