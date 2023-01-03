function gfn_getMeaCalcIndex2(grid, field, idx, fieldNm) {
	
	var val = "";
	var val2 = "";
	
	if(fieldNm.indexOf("CFM_CPFR_SP") != -1){
		val = "CFM_AP2_SP";
		val2 = "CFM_CPFR_SP";
	}else if(fieldNm.indexOf("CFM_AP2_SP") != -1){
		val = "CFM_CPFR_SP";
		val2 = "CFM_AP2_SP";
	}
	
	var amtMeaIdx = gfn_getFindPositionInDs(MEASURE.user, "CD", val);
	var apMeaIdx  = gfn_getFindPositionInDs(MEASURE.user, "CD", val2);
	var resultIdx = gfn_getFindPositionInDs(MEASURE.user, "CD", GRIDCALC.apMeaCd);
	
	
	var provider = grid.getDataSource();
	if (provider.getValue(idx, gv_grpLvlId) != 0) return -1;
	var fieldIdx = amtMeaIdx - apMeaIdx + field;
	var fieldResultIdx = resultIdx - apMeaIdx + field;
	var result = dataProvider.getValue(idx, field);
	var result2 = dataProvider.getValue(idx, fieldIdx);
	
	if (result == undefined) result = 0;
	if (result2 == undefined) result2 = 0;
	
	var resVal = result + result2
	
	dataProvider.setValue(idx, fieldResultIdx, resVal);
	gfn_setRollupTotal(provider, idx, fieldResultIdx, GRIDCALC.apMeaCd);
	gfn_setAmt(grid, idx, fieldResultIdx); 
}


var GRIDCALC = {
	
	gridInst      : null,	
	disagRule     : "",
	apMeaCd       : "",
	amtMeaCd      : [],
	changeMap     : [],
	bsc           : {flag: false, totCol: "", exCol: [], callback: null},
		
	//1. auto calc ------------------------------------------------------------------------------------------------------------------------
	autoCalc : function(gridInst, itemIndex, dataRow, field, oldVal, newVal) {
		
		//console.log("autoCalc ==========");
		
		if (oldVal == undefined) oldVal = 0;
		if (newVal == undefined) newVal = 0;
		
		GRIDCALC.gridInst = gridInst;
		
		var grid      = gridInst.objGrid;
		var provider  = gridInst.objData;
		var fieldNm   = provider.getFieldName(field);
		var grpLvlId  = provider.getValue(dataRow ,gv_grpLvlId);
		var meaCd     = provider.getFieldIndex(gv_measureCd) != -1 ? provider.getValue(dataRow ,gv_measureCd) : "";
		var findDs    = gfn_getFindDataDsInDs(BUCKET.query, {CD : {VALUE : fieldNm, CONDI : "="}, TOT_TYPE : {VALUE : "MT", CONDI : "="}});
		
		//4-1. month Total이 아닌경우
		if (findDs.length == 0) {
			
			if (grpLvlId == "0") { //4-1-1. grpLvlId가 0인 경우
				
				gfn_setRollupTotal(provider, dataRow, field, meaCd);
				gfn_getMeaCalcIndex2(grid, field, dataRow, fieldNm);
				
			} else { //4-1-2. grpLvlId가 0이 아닌 경우
				
				if (newVal == 0) provider.setValue(dataRow, field, newVal);
				GRIDCALC.disaggreVer(grid, provider, itemIndex, dataRow, field, oldVal, newVal);
			}
			
		//4-2. month total인 경우
		} else {
			
			GRIDCALC.disaggreHor(grid, provider, itemIndex, dataRow, field, oldVal, newVal);
		}
	},
	
	//2. disaggregation horizon ----------------------------------------------------------------------------------------------------------
	disaggreHor : function(grid, provider, itemIndex, dataRow, field, oldVal, newVal) {
		
		//console.log("disaggreHor ==========");
		
		var rtnArrChn = [];
		var fieldNm   = provider.getFieldName(field);
		var grpLvlId  = provider.getValue(dataRow ,gv_grpLvlId);
		var meaCd     = provider.getFieldIndex(gv_measureCd) != -1 ? provider.getValue(dataRow, gv_measureCd) : "";
		//console.log("itemIndex: "+itemIndex+", dataRow: "+dataRow+", field: "+field+", oldVal: "+oldVal+", newVal: "+newVal);
		
		// logic start -------------------------------------------
		
		var findDs, findDsI, arrChildField;
		var workCnt = 0;
		
		findDs = gfn_getFindDataDsInDs(BUCKET.query, {CD : {VALUE : fieldNm, CONDI : "="}, TOT_TYPE : {VALUE : "MT", CONDI : "="}});
		
		//month total의 work cnt를 set	
		workCnt = Number(findDs[0].WORK_CNT);
		workCnt = $.isNumeric(workCnt) ? workCnt : 0;
		
		//month total이면 월에 해당하는 주차에 할당 후 처리
		//findDsI = gfn_getFindDataDsInDs(BUCKET.query, {ROOT_CD : {VALUE : findDs[0].ROOT_CD, CONDI : "="}, TOT_TYPE : {VALUE : "MT", CONDI : "!="}});
		findDsI = gfn_getFindDataDsInDs(BUCKET.query, {ROOT_CD : {VALUE : findDs[0].ROOT_CD.replace("MT_", "M"), CONDI : "="}, TOT_TYPE : {VALUE : "MT", CONDI : "!="}});
		arrChildField = gfn_getArrayInDs(findDsI, "CD");
		
		//전체데이터가 0인지 판단
		var chkAllZero = gfn_chkAllZero(provider, dataRow, dataRow, arrChildField, fieldNm);
		
		//1. 입력값이 frozen 구간의 값보다 작은경우
		var frozenNewVal = newVal - chkAllZero.frozenSum;
		if(frozenNewVal < 0) {
			frozenNewVal = 0;
		}
		
		try {
			
			provider.beginUpdate();	
			
			var accCalcVal = 0
			var adjustField = "";
			var mWorkCnt = 0;
			var qtyCnt = - + MEASURE.user.length;
			var firstCnt = 0;
			var hiddenCnt = 0;
			
			$.each(findDsI, function(n, v) {
				if(v.CD.indexOf("_HIDDEN") != -1){
					hiddenCnt++;
				}
			});
			
			$.each(findDsI, function(n, v) {
				
				var vFlag = v.FLAG;
				var vBucketId = v.BUCKET_ID;
				
				if((vBucketId.indexOf("CFM_CPFR_SP") != -1 && fieldNm.indexOf("CFM_CPFR_SP") != -1) || (vBucketId.indexOf("CFM_AP2_SP") != -1 && fieldNm.indexOf("CFM_AP2_SP") != -1)){
					
					if(firstCnt == 0){
						qtyCnt = qtyCnt + n - hiddenCnt;
						firstCnt++;
					}
					
					if (provider.getValue(dataRow, v.CD+"_FROZEN_YN") == "Y") {
						mWorkCnt += Number(v.WORK_CNT);
						return true;
					}
					
					var tmpField  = provider.getFieldIndex(v.CD);
					var calcOldVal = Number(provider.getValue(dataRow, v.CD));
					
					var tmpMap = {};
					tmpMap.calcOrgOldVal = calcOldVal;
					
					//전체데이터가 0이면 해당주차의 working day로 계산 
					if (chkAllZero.chkAll) {
						oldVal  = workCnt - mWorkCnt;
						calcOldVal = $.isNumeric(Number(v.WORK_CNT)) ? Number(v.WORK_CNT) : 0;
					}
					
					var calcNewVal = Math.floor(frozenNewVal * calcOldVal / oldVal);
					calcNewVal = $.isNumeric(calcNewVal) ? calcNewVal : 0;
					
					accCalcVal += calcNewVal;
					adjustField = v.CD;
					
					gfn_setProvider(provider, dataRow, v.CD, calcNewVal);
					gfn_setRollupTotal(provider, dataRow, tmpField, meaCd);
					gfn_getMeaCalcIndex2(grid, tmpField, dataRow, v.CD);
					
					//총량 보정
					if(n == findDsI.length + qtyCnt) {
						
						var adjustOldVal = provider.getValue(dataRow, adjustField);
						calcNewVal = adjustOldVal + frozenNewVal - accCalcVal;
						gfn_setProvider(provider, dataRow, adjustField, calcNewVal);
						gfn_setRollupTotal(provider, dataRow, tmpField, meaCd);
						gfn_getMeaCalcIndex2(grid, tmpField, dataRow, v.CD);
					}
					
					//데이터 맵설정
					tmpMap.field      = tmpField;
					tmpMap.calcOldVal = calcOldVal;
					tmpMap.calcNewVal = calcNewVal;
					rtnArrChn.push(tmpMap);	
				}
				
			});
		} finally {
			provider.endUpdate();
		}
		
		//자신의 필드 입력값으로 원복처리
		var tmpChkVal = newVal;
		if(frozenNewVal <= 0) tmpChkVal = chkAllZero.frozenSum;
		
		gfn_setProvider(provider, dataRow, field, tmpChkVal);
	},
	
	//3. disaggregation vertical ----------------------------------------------------------------------------------------------------------
	disaggreVer : function(grid, provider, itemIndex, dataRow, field, oldVal, newVal) {
		//console.log("disaggreVer ==========");
		
		var fieldNm   = provider.getFieldName(field);
		var grpLvlId  = provider.getValue(dataRow ,gv_grpLvlId);
		var meaCd     = provider.getFieldIndex(gv_measureCd) != -1 ? provider.getValue(dataRow ,gv_measureCd) : "";
		////console.log("itemIndex: "+itemIndex+", dataRow: "+dataRow+", field: "+field+", oldVal: "+oldVal+", newVal: "+newVal);
		
		//params set
		var params = {
			gridInst  : GRIDCALC.gridInst, 
			grid      : grid, 
			provider  : provider,
			itemIndex : itemIndex,
			dataRow   : dataRow,
			field     : field,
			oldVal    : oldVal,
			newVal    : newVal,		
			fieldNm   : fieldNm,		
			meaCd     : meaCd,
		};
		
		if (grpLvlId != "0") { //서브토달 입력시
			//row data 처리
			GRIDCALC.disaggreRow(params);
		}
		
		//상위 subTotal, Total set
		gfn_setRollupTotal(provider, dataRow, field, meaCd);
		gfn_getMeaCalcIndex2(grid, field, dataRow, fieldNm);
	},
	
	//row data 처리
	disaggreRow : function(params) {
		//console.log("disaggreRow ==========");
		
		//수정될 영역 검색
		var fIdx  = gfn_getTotalEndIdx(params.provider, params.dataRow);
		var grpLvlId,rowVal;
		var calcVal = 0, totAccVal = 0, adjustVal = 0, adjustIdx = -1, maxVal = 0, diffVal = 0;
		var arrSubTotalIdx = [];
		
		//월토탈 필드
		var arrChnField = gfn_getChnArrField(params.gridInst, params.provider, params.field);
		
		$.each(arrChnField, function(n,v) {
			
			if (v == params.fieldNm) return true;
			
			GRIDCALC.monthField = v;
			return false;
		});
		
		try {
			
			params.provider.beginUpdate();
			
			//전체데이터가 0인지 판단
			var chkAllZero = gfn_chkAllZero(params.provider, params.dataRow+1, fIdx, [params.fieldNm], params.fieldNm);
			
			//1. 입력값이 frozen 구간의 값보다 작은경우
			var frozenNewVal = params.newVal - chkAllZero.frozenSum;
			if(frozenNewVal < 0) frozenNewVal = 0;
			
			var rowValAct = 0;
			var rowMonthVal = 0;
			var tmpMeaCd = "";
			
			for (var i = fIdx; i >= params.dataRow; i--) {
				
				tmpMeaCd = params.provider.getFieldIndex(gv_measureCd) != -1 ? params.provider.getValue(i ,gv_measureCd) : "";
				if (params.meaCd != tmpMeaCd || params.provider.getValue(i, params.fieldNm+"_FROZEN_YN") == "Y") continue;
				
				grpLvlId = params.provider.getValue(i, gv_grpLvlId);
				rowVal   = params.provider.getValue(i, params.field);
				
				if (grpLvlId == "0") {
					
					//전체데이터가 0이면 item & cust group의 실적으로 처리
					if (chkAllZero.chkAll && !gfn_isNull(GRIDCALC.disagRule)) {
						rowValAct = Number(params.provider.getValue(i, GRIDCALC.disagRule));
						calcVal = Math.floor(frozenNewVal * rowValAct / chkAllZero.actSum);
						
					} else {
						calcVal = Math.floor(frozenNewVal * rowVal / params.oldVal);
					}
					calcVal = $.isNumeric(calcVal) ? calcVal : 0;
					
					//max 값 판단
					if (maxVal < calcVal) {
						maxVal = calcVal;
						adjustIdx = i;
					}
					
					//데이터 설정
					gfn_setProvider(params.provider, i, params.field, calcVal);
					
					var filedName = dataProvider.getFieldName(params.field);
					gfn_cellColorDecide(filedName, i, calcVal, true)
					
					gfn_setRollupTotal(params.provider, params.dataRow, params.field, params.meaCd);
					gfn_getMeaCalcIndex2(params.grid, params.field, params.dataRow, params.fieldNm);
					
					//월토탈 처리
					rowMonthVal = gfn_setMonthTotalVal(params.provider, i, params.field);
					
					//누계
					totAccVal += calcVal;
					
					adjustIdx = adjustIdx == -1 ? i : adjustIdx;
							
				} else {
					arrSubTotalIdx.push(i);
				}
			} //end for
			
			//보정 -------------
			//1.값
			adjustVal = frozenNewVal - totAccVal;

			//변수설정
			GRIDCALC.adjustIdx = adjustIdx; 
			GRIDCALC.adjustVal = adjustVal; 
			
			if (adjustIdx != -1 && adjustVal != 0) {
				
				//2.보정값 처리
				gfn_setProvider(params.provider, adjustIdx, params.field, maxVal + adjustVal);
				
				gfn_getMeaCalcIndex2(params.grid, params.field, fIdx, params.fieldNm);
				
				//3.보정값 월토탈처리
				rowMonthVal = gfn_setMonthTotalVal(params.provider, adjustIdx, params.field);
				
				var filedName = dataProvider.getFieldName(params.field);
				gfn_cellColorDecide(filedName, i, calcVal, true)
			}
			
		} finally {
			params.provider.endUpdate();
		}
		
		GRIDCALC.arrSubTotalIdx = arrSubTotalIdx;
    },
    getChangeVal : function(provider, dataRow, field, oldValue) {
		var fieldNm = provider.getFieldName(field);
		for(var i=GRIDCALC.changeMap.length-1; i>=0; i--) {
			if (dataRow == GRIDCALC.changeMap[i].dataRow && (field == GRIDCALC.changeMap[i].field || fieldNm == GRIDCALC.changeMap[i].field)) {
				return GRIDCALC.changeMap[i].value;
			}
		}
		return oldValue;
	}
}

//금액처리
function gfn_setAmt(grid, idx, field, rollupYn) {
	//console.log("gfn_setAmt ==========");
	
	rollupYn = rollupYn || "Y";
	$.each(GRIDCALC.amtMeaCd, function(n, v) {
		
		var provider = grid.getDataSource();
		
		var fieldIdx = gfn_getMeaCalcIndex(grid, field, idx, v);
		
		if (fieldIdx == -1) return true;
		
		var salesQty = grid.getValue(idx, field);
		var salesAmt = gfn_setAmtFunc(v, provider, idx, salesQty, fieldIdx);
		
		gfn_setProvider(provider, idx, fieldIdx, salesAmt, "N");
		
		//rollup total 처리
		if (rollupYn == "Y") {
			gfn_setRollupTotal(provider, idx, fieldIdx, v);
		}
	});
}

function gfn_getMeaCalcIndex(grid, field, idx, amtMeaCd) {
	
	var amtMeaIdx = gfn_getFindPositionInDs(MEASURE.user, "CD", amtMeaCd);
	var apMeaIdx  = gfn_getFindPositionInDs(MEASURE.user, "CD", GRIDCALC.apMeaCd);
	if (amtMeaIdx == -1) return -1; //없으면 처리안함
	
	var provider = grid.getDataSource();
	if (provider.getValue(idx, gv_grpLvlId) != 0) return -1;

	var fieldIdx = amtMeaIdx - apMeaIdx + field;
	return fieldIdx;
}

function gfn_setAmtFunc(type, provider, idx, salesQty, fieldIdx) {
	
	switch(type) {
	
		case "AP1_SP_AMT_KRW" :
		case "AP2_SP_AMT_KRW" :
		case "CFM_SP_AMT_KRW" :
		case "YP_AMT_KRW"     :
			var salesAmt = salesQty * provider.getValue(idx, "SALES_PRICE_KRW_HIDDEN");
			salesAmt = $.isNumeric(salesAmt) ? salesAmt : 0;
			return salesAmt;
		
		case "OP_AMT_KRW":
			var opAmt = (salesQty * provider.getValue(idx, "SALES_PRICE_KRW_HIDDEN"))
			          - (salesQty * provider.getValue(idx, "COGS_KRW"       ))
			          - (salesQty * provider.getValue(idx, "SGNA_KRW"       ));
			opAmt = $.isNumeric(opAmt) ? opAmt : 0;
			return opAmt;
			
		case "OP_RATE":
			var salesAmt = salesQty * provider.getValue(idx, "SALES_PRICE_KRW_HIDDEN");
			var opAmt    = (salesAmt)
			             - (salesQty * provider.getValue(idx, "COGS_KRW"))
			             - (salesQty * provider.getValue(idx, "SGNA_KRW"));
			var opRate   = (opAmt / salesAmt * 100).toFixed(1);
			opRate = $.isNumeric(opRate) ? opRate : 0;
			return opRate;
		default:
			return 0;
	}
}

//rollup total 처리
function gfn_setRollupTotal(provider, idx, field, meaCd) {
	
	if ($.inArray(provider.getFieldName(field),GRIDCALC.bsc.exCol) > -1) return;
	
	if (!gfn_isNull(GRIDCALC.gridInst.measureHFlag) && GRIDCALC.gridInst.measureHFlag == true) {
		var meaCdIdx = gfn_getFindPositionInDs(MEASURE.user, "CD", meaCd);
		if (meaCdIdx == -1) return;
	}

	var grpLvlId = provider.getValue(idx, gv_grpLvlId);
	var curGrpLvlId = "0", preGrpLvlId = "0";
	var startIdx = provider.getRowCount() - 1;
	var setpAccMap = {};
	
	
	try {
		provider.beginUpdate();
		
		if (GRIDCALC.bsc.flag) {
			GRIDCALC.bsc.callback(provider, idx, field, meaCd);
		} else {
			//월토탈 처리
			gfn_setMonthTotalVal(provider, idx, field);
		}
		
		for (var i = startIdx; i >= 0; i--) {
		
			curGrpLvlId = provider.getValue(i, gv_grpLvlId);
			
			//같으면
			if (Number(curGrpLvlId) == Number(preGrpLvlId)) {
			
			//작으면
			} else if (Number(curGrpLvlId) < Number(preGrpLvlId)) {
				$.each(setpAccMap,function(n,v) {
					if (Number(n) < Number(preGrpLvlId)) {
						setpAccMap[n] = 0;
					}
				});
				
			//커지면 누적된 데이터 대입
			} else if (Number(curGrpLvlId) > Number(preGrpLvlId)) {
				if (Number(gfn_nvl(provider.getValue(i, field), 0)) != setpAccMap[preGrpLvlId]) {
					gfn_setProvider(provider, i, field, setpAccMap[preGrpLvlId]);
					
					//callback function call
					if (GRIDCALC.bsc.flag) {
						GRIDCALC.bsc.callback(provider, i, field, meaCd);
					} else {
						//월토탈 처리 aaa
						gfn_setMonthTotalVal(provider, i, field);
					}
				}
			} 
			
			setpAccMap[curGrpLvlId] = gfn_nvl(setpAccMap[curGrpLvlId],0) + Number(gfn_nvl(provider.getValue(i, field),0));
			
			//마지막에 현지점 grpLvlId set
			preGrpLvlId = curGrpLvlId;
			
		}
	} finally {
		provider.endUpdate();
	}
}

//행 토탈 arrField
function gfn_getMonthField(provider, field) {
	var rtnVal = "";
	var fieldNm = provider.getFieldName(field);
	
	$.each(BUCKET.all[1], function(n, v) {
		
		var cd = v.CD;
		var rootCd = v.ROOT_CD;
		var measureNm = fieldNm.replace(cd + "_", "");
				
		if(fieldNm.indexOf(cd) != -1){
			rtnVal = rootCd.replace("M", "MT_") + "_" + measureNm;
			return false;
		}
	});
	
	return rtnVal;
}

//월토탈 셋
function gfn_setMonthTotalVal(provider, idx, field, bscFlag) {
	
	var rtnVal     = 0;
	var fieldNm    = provider.getFieldName(field);
	var monthField = gfn_getMonthField(provider, field);
	
	//전체토탈처리
	if (provider.getFieldIndex(gv_colBucketTotal) != -1) {
		
		rtnVal = gfn_getMonthTotalVal(provider, idx, monthField, "Y");
		gfn_setProvider(provider, idx, gv_colBucketTotal, rtnVal);
		
		//callback function call
		if (GRIDCALC.bsc.flag && bscFlag == false) {
			GRIDCALC.bsc.callback(provider, idx, gv_colBucketTotal);
		}
	}
	
	
	if (fieldNm == monthField) return;
	
	if (provider.getFieldIndex(monthField) != -1) {
		rtnVal = gfn_getMonthTotalVal(provider, idx, monthField);
		gfn_setProvider(provider, idx, monthField, rtnVal);
	}
	return rtnVal;
}

//월토탈 데이터를 가져온다.
function gfn_getMonthTotalVal(provider, dataRow, monthField, totYn) {
	
	var rtnVal = 0;
	var tmpFlag = "default";
	var monthFieldLen = monthField.length;
	var measure = monthField.substring(9, monthFieldLen);
	
	totYn = totYn || "N";
	
	if(monthField.indexOf("_CFM_SP_AMT_KRW") != -1){
		tmpFlag = "KRW";
	}else{
		if(monthField.indexOf("_CFM_SP") != -1){
			tmpFlag = "QTY";	
		}else if(monthField.indexOf("_CFM_CPFR_SP") != -1){
			tmpFlag = "QTY1";
		}else if(monthField.indexOf("_CFM_AP2_SP") != -1){
			tmpFlag = "QTY2";
		}
	}
	
	$.each(BUCKET.query, function(n,v) {
		
		var vCd = v.CD;
		var vTotType = v.TOT_TYPE;
		var vRootCd = v.ROOT_CD;
		var vFlag = v.FLAG;
		var monthFieldReplace = monthField.replace("MT_", "M").replace(measure, "");
		
		if (totYn == "N" && vTotType != "MT" && vRootCd == monthFieldReplace) {
			if(tmpFlag == vFlag){
				rtnVal += Number(gfn_nvl(provider.getValue(dataRow, vCd), 0));
			}
		} else if (totYn == "Y" && vTotType != "MT") {
			if(tmpFlag == vFlag){
				rtnVal += Number(gfn_nvl(provider.getValue(dataRow, vCd), 0));
			}
		}
	});
	return rtnVal;
}

//범위의 데이터 전체가 0인지 체크
function gfn_chkAllZero(provider, startIdx, endIdx, fields, fieldNm) {
	
	var rtnMap = {
		chkAll: true, 
		actSum: 0,
		frozenSum: 0,
	};
	
	var tmpMeaCd = "";
	for (var i = startIdx; i <= endIdx; i++) {
		
		tmpMeaCd = provider.getFieldIndex(gv_measureCd) != -1 ? provider.getValue(i ,gv_measureCd) : "";
		
		if (fieldNm != tmpMeaCd) {
			continue; //같은 카테고리만 처리
		}
		
		for (var k = 0; k < fields.length; k++) {
			
			var tmpFields = fields[k];
			
			if (Number(provider.getValue(i, tmpFields)) > 0) {
				rtnMap.chkAll = false;
			}
			
			
			if((tmpFields.indexOf("CFM_CPFR_SP") != -1 && fieldNm.indexOf("CFM_CPFR_SP") != -1) || (tmpFields.indexOf("CFM_AP2_SP") != -1 && fieldNm.indexOf("CFM_AP2_SP") != -1)){
				//frozen 구간 sum
				if (provider.getValue(i, tmpFields+"_FROZEN_YN") == "Y") {
					var value = Number(gfn_nvl(provider.getValue(i, tmpFields), 0));
					rtnMap.frozenSum += value;
				}
			}
		}

		//실적의 합
		if (!gfn_isNull(GRIDCALC.disagRule)) {
			rtnMap.actSum += Number(provider.getValue(i, GRIDCALC.disagRule));
		}
	}
	return rtnMap;
}

//수정된 행의 row key ---------------------------------------------
function gfn_getArrRowKey() {
	var rtnArr = [];
	
	//디멘전
	$.each(DIMENSION.user, function(n,v){
		rtnArr.push(v.DIM_CD);
	});

	//메저전
	$.each(MEASURE.pre, function(n,v) {
		rtnArr.push(v.CD);
	});

	//메저
	if($.isArray(MEASURE.user) && MEASURE.user.length > 0) {
		rtnArr.push(gv_measureCd);
		meaFlag = true;
	}
	
	return rtnArr;
}

function gfn_setProvider(provider, dataRow, field, val, changeMapYn) {
	changeMapYn = changeMapYn || "Y"; 
	provider.setValue(dataRow, field, val);
	
	if (changeMapYn == "Y") {
		GRIDCALC.changeMap.push({dataRow: dataRow, field: field, value: val});
	}
	
	//omit flag set
	if (provider.getFieldIndex(gv_omitFlag) != -1) {
		var orgOmit = Number(gfn_nvl(provider.getValue(dataRow, gv_omitFlag),0));
		if (provider.getFieldIndex(gv_colBucketTotal) != -1) {
			var newOmit = provider.getValue(dataRow, gv_colBucketTotal);
			if (newOmit == undefined) {
				provider.setValue(dataRow, gv_omitFlag, "0");
			} else {
				provider.setValue(dataRow, gv_omitFlag, newOmit.toString());
			}
		}
	}
}

function gfn_cellColorDecide(filedName, itemIndex, newValue, flag){
	
	var redName = "";
	var blackName = "";
	var ap2SpId, ap2SpData;
	var grpLvlId = dataProvider.getValue(itemIndex, gv_grpLvlId);
	var checkCnt = 0;
	
	if(flag){
		redName = "cellAp1StyleRed";
		blackName = "cellAp1StyleBlack";
	}else{
		redName = "cellAp1StyleRedFlase";
		blackName = "cellAp1StyleBlackFlase";
	}
	
	$.each(MEASURE.user, function(n, v){
		var vCd = v.CD;
		if(vCd == apMeaCompare){
			checkCnt++;	
		}
	});
	
	if(checkCnt > 0 && grpLvlId == 0){
		ap2SpId = filedName.replace(apMeaCd, apMeaCompare);
		ap2SpData = dataProvider.getValue(itemIndex, ap2SpId);
		
		if(newValue == ap2SpData){
			grdMain.setCellStyles(itemIndex, filedName , blackName);
		}else{
			grdMain.setCellStyles(itemIndex, filedName , redName);
		}
	}
	
	var columns = grdMain.columnByName(filedName);
	columns.editor = {
						 type : "number"
					   , positiveOnly : true
					   , integerOnly : true 
					 };
	grdMain.setColumn(columns);
}

