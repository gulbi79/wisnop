//GRIDCALC
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
			
			//전체토탈
			if (fieldNm == gv_colBucketTotal) {
				GRIDCALC.disaggreHor(grid, provider, itemIndex, dataRow, field, oldVal, newVal);
				
			//전체토탈이 아닌경우
			} else {
				//4-1-1. grpLvlId가 0인 경우
				if (grpLvlId == "0") {
					
					gfn_setRollupTotal(provider, dataRow, field, meaCd);
					
					$.each(GRIDCALC.amtMeaCd, function(n,v) {
						var calcIdx = gfn_getMeaCalcIndex(grid, field, dataRow, v);
						if (calcIdx == -1) return true;
						gfn_setRollupTotal(provider, calcIdx, field, v);
					});
					
					//4-1-2. grpLvlId가 0이 아닌 경우
				} else {
					if (newVal == 0) provider.setValue(dataRow, field, newVal);
					GRIDCALC.disaggreVer(grid, provider, itemIndex, dataRow, field, oldVal, newVal);
				}
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
		var meaCd     = provider.getFieldIndex(gv_measureCd) != -1 ? provider.getValue(dataRow ,gv_measureCd) : "";
		////console.log("itemIndex: "+itemIndex+", dataRow: "+dataRow+", field: "+field+", oldVal: "+oldVal+", newVal: "+newVal);
		
		// logic start -------------------------------------------
		
		var findDs, findDsI, arrChildField;
		var workCnt = 0;
		
		//전체토탈인 경우
		if (fieldNm == gv_colBucketTotal) {
			workCnt = 0;
			$.each(BUCKET.query, function(n,v) {
				workCnt += Number(v.WORK_CNT);
			});
			workCnt = $.isNumeric(workCnt) ? workCnt : 0;
			
			findDsI = BUCKET.query;
			arrChildField = gfn_getArrayInDs(findDsI, "CD");
		
		//전체토탈이 아닌경우
		} else {
			findDs = gfn_getFindDataDsInDs(BUCKET.query, {CD : {VALUE : fieldNm, CONDI : "="}, TOT_TYPE : {VALUE : "MT", CONDI : "="}});
			
			//month total의 work cnt를 set	
			workCnt = Number(findDs[0].WORK_CNT);
			workCnt = $.isNumeric(workCnt) ? workCnt : 0;
			
			//month total이면 월에 해당하는 주차에 할당 후 처리
			findDsI = gfn_getFindDataDsInDs(BUCKET.query, {ROOT_CD : {VALUE : findDs[0].ROOT_CD, CONDI : "="}, TOT_TYPE : {VALUE : "MT", CONDI : "!="}});
			arrChildField = gfn_getArrayInDs(findDsI, "CD");
		}
		
		//전체데이터가 0인지 판단
		var chkAllZero = gfn_chkAllZero(provider, dataRow, dataRow, arrChildField, meaCd);
		
		//1. 입력값이 frozen 구간의 값보다 작은경우
		var frozenNewVal = newVal - chkAllZero.frozenSum;
		if(frozenNewVal < 0) frozenNewVal = 0;
		
		try {
			
			provider.beginUpdate();	
			
			var accCalcVal = 0
			var adjustField = "";
			var mWorkCnt = 0;
			$.each(findDsI, function(n,v) {
				
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
				//console.log(calcNewVal+" = Math.floor("+frozenNewVal+" * "+calcOldVal+" / "+oldVal+")");
				
				accCalcVal += calcNewVal;
				adjustField = v.CD;
				
				//set Data
				gfn_setProvider(provider, dataRow, v.CD, calcNewVal);
				
				gfn_cellColorDecide(provider, v.CD, itemIndex, true)
				
				//총량 보정
				if(n == findDsI.length-1) {
					var adjustOldVal = provider.getValue(dataRow, adjustField);
					calcNewVal = adjustOldVal + frozenNewVal - accCalcVal;
					//console.log("총량보정: "+calcNewVal+" = "+adjustOldVal+" + "+frozenNewVal+" - "+accCalcVal);
					gfn_setProvider(provider, dataRow, adjustField, calcNewVal);
				}
				
				//gfn_setAmt(grid, dataRow, tmpField); //amt

				//데이터 맵설정
				tmpMap.field      = tmpField;
				tmpMap.calcOldVal = calcOldVal;
				tmpMap.calcNewVal = calcNewVal;
				rtnArrChn.push(tmpMap);
				
			});
			
		} finally {
			provider.endUpdate();
		}
		
		// subTotal, Total set
		$.each(rtnArrChn, function(n,v) {
			//4-1-1. grpLvlId가 0인 경우
			if (grpLvlId == "0") {
				gfn_setRollupTotal(provider, dataRow, v.field, meaCd);
				
				gfn_setAmt(grid, dataRow, v.field); //amt
				
			//4-1-2. grpLvlId가 0이 아닌 경우
			} else {
				GRIDCALC.disaggreVer(grid, provider, itemIndex, dataRow, v.field, v.calcOrgOldVal, v.calcNewVal);
			}
		});

		//자신의 필드 입력값으로 원복처리
		var tmpChkVal = newVal;
		if(frozenNewVal <= 0) tmpChkVal = chkAllZero.frozenSum;
		
		gfn_setProvider(provider, dataRow, field, tmpChkVal);
		
		//gfn_setAmt(grid, dataRow, field); //amt
		
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
		
		if (grpLvlId != "0") {
			//row data 처리
			GRIDCALC.disaggreRow(params);
		}
		
		//상위 subTotal, Total set
		gfn_setRollupTotal(provider, dataRow, field, meaCd);
		
		$.each(GRIDCALC.amtMeaCd, function(n,v) {
			var calcIdx = gfn_getMeaCalcIndex(grid, field, dataRow, v);
			if (calcIdx == -1) return true;
			gfn_setRollupTotal(provider, dataRow, field, v);
		});
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
			////console.log(params.dataRow+1+", "+fIdx+", ["+params.fieldNm+"]");
			var chkAllZero = gfn_chkAllZero(params.provider, params.dataRow+1, fIdx, [params.fieldNm], params.meaCd);
			
			//1. 입력값이 frozen 구간의 값보다 작은경우
			var frozenNewVal = params.newVal - chkAllZero.frozenSum;
			if(frozenNewVal < 0) frozenNewVal = 0;
			
			var rowValAct = 0;
			var rowMonthVal = 0;
			var tmpMeaCd = "";
			for (var i=fIdx; i>=params.dataRow; i--) {
				
				tmpMeaCd = params.provider.getFieldIndex(gv_measureCd) != -1 ? params.provider.getValue(i ,gv_measureCd) : "";
				if (params.meaCd != tmpMeaCd || params.provider.getValue(i, params.fieldNm+"_FROZEN_YN") == "Y") continue;
				
				grpLvlId = params.provider.getValue(i, gv_grpLvlId);
				rowVal   = params.provider.getValue(i, params.field);
				if (grpLvlId == "0") {

					//전체데이터가 0이면 item & cust group의 실적으로 처리
					if (chkAllZero.chkAll && !gfn_isNull(GRIDCALC.disagRule)) {
						rowValAct = Number(params.provider.getValue(i, GRIDCALC.disagRule));
						calcVal = Math.floor(frozenNewVal * rowValAct / chkAllZero.actSum);
						//console.log(i+". chkAllZero == true, "+calcVal+" = Math.floor("+frozenNewVal+" * "+rowValAct+" / "+chkAllZero.actSum+")");
					} else {
						calcVal = Math.floor(frozenNewVal * rowVal / params.oldVal);
						//console.log(i+". chkAllZero == false, "+calcVal+" = Math.floor("+frozenNewVal+" * "+rowVal+" / "+params.oldVal+")");
					}
					calcVal = $.isNumeric(calcVal) ? calcVal : 0;
					
					//max 값 판단
					if (maxVal < calcVal) {
						maxVal = calcVal;
						adjustIdx = i;
					}
					
					//데이터 설정
					gfn_setProvider(params.provider, i, params.field, calcVal);

					gfn_setAmt(params.grid, i, params.field, "N"); //amt - rollup은 하지 않는다.
					
					var filedName = params.provider.getFieldName(params.field);
					gfn_cellColorDecide(params.provider, filedName, i, true)
					
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
				
				gfn_setAmt(params.grid, adjustIdx, params.field, "N"); //amt
				
				//3.보정값 월토탈처리
				rowMonthVal = gfn_setMonthTotalVal(params.provider, adjustIdx, params.field);
				
				var filedName = params.provider.getFieldName(params.field);
				gfn_cellColorDecide(params.provider, filedName, i, true)
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
	$.each(GRIDCALC.amtMeaCd, function(n,v) {
		
		var provider = grid.getDataSource();
		
		var calcIdx = gfn_getMeaCalcIndex(grid, field, idx, v);
		if (calcIdx == -1) return true;
		
		var salesQty = grid.getValue(idx, field);
		var salesAmt = gfn_setAmtFunc(v, provider, idx, salesQty, field);
		
		gfn_setProvider(provider, calcIdx, field, salesAmt, "N");
		
		//월토탈 처리
		if (rollupYn == "N") {
			//gfn_setMonthTotalVal(provider, calcIdx, field);
		}
		
		//rollup total 처리
		if (rollupYn == "Y") {
			gfn_setRollupTotal(provider, calcIdx, field, v);
		}
	});
}

function gfn_getMeaCalcIndex(grid, field, idx, amtMeaCd) {
	
	var amtMeaIdx = gfn_getFindPositionInDs(MEASURE.user, "CD", amtMeaCd);
	var apMeaIdx  = gfn_getFindPositionInDs(MEASURE.user, "CD", GRIDCALC.apMeaCd);
	
	if (amtMeaIdx == -1) return -1; //없으면 처리안함
	
	var provider = grid.getDataSource();
	if (provider.getValue(idx, gv_grpLvlId) != 0) return -1;

	//month total인경우 처리안함
	if (provider.getFieldName(field).indexOf("MT_") > -1) return -1;
	
	var calcIdx = amtMeaIdx - apMeaIdx + idx;;
	
	return calcIdx;
}

function gfn_setAmtFunc(type, provider, idx, salesQty, field) {
	
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
		/*
		case "ALLOC_QTY_W":
			
			var result = 0;
			var newFieldName = provider.getFieldName(field) + "_" + apWeekCd + "_HIDDEN";
			var newVal = gfn_nvl(provider.getValue(idx, newFieldName), 0);
			
			if(newVal != 0){
				result = newVal - salesQty;
			}
			
			return result;
		*/	
		default:
			return 0;
	}
}

//rollup total 처리
function gfn_setRollupTotal(provider, idx, field, meaCd) {
	
	if ($.inArray(provider.getFieldName(field),GRIDCALC.bsc.exCol) > -1) return;
	
	if (!gfn_isNull(GRIDCALC.gridInst.measureHFlag) && GRIDCALC.gridInst.measureHFlag != true) {
		var meaCdIdx = gfn_getFindPositionInDs(MEASURE.user, "CD", meaCd);
		if (meaCdIdx == -1) return;
	}

	//console.log("gfn_setRollupTotal ==========");
	
	var grpLvlId = provider.getValue(idx, gv_grpLvlId);
	var curGrpLvlId = "0", preGrpLvlId = "0";
	//var startIdx = gfn_getTotalEndIdx(provider, idx, "B");
	var startIdx = provider.getRowCount()-1;
	var setpAccMap = {};
	
	try {
		provider.beginUpdate();
		
		//callback function call
		if (GRIDCALC.bsc.flag) {
			GRIDCALC.bsc.callback(provider, idx, field, meaCd);
		} else {
			//월토탈 처리
			gfn_setMonthTotalVal(provider, idx, field);
		}
		
		var tmpMeaCd = "";
		for (var i=startIdx; i>=0; i--) {
		
			tmpMeaCd = provider.getFieldIndex(gv_measureCd) != -1 ? provider.getValue(i ,gv_measureCd) : "";
			if (tmpMeaCd != meaCd) continue;
			
			curGrpLvlId = provider.getValue(i, gv_grpLvlId);
			
			//같으면
			if (Number(curGrpLvlId) == Number(preGrpLvlId)) {
				////console.log(i+",  case 1 : "+Number(provider.getValue(i, field)));
			
			//작으면
			} else if (Number(curGrpLvlId) < Number(preGrpLvlId)) {
				////console.log(i+",  case 2 : "+Number(provider.getValue(i, field)));
				$.each(setpAccMap,function(n,v) {
					if (Number(n) < Number(preGrpLvlId)) {
						setpAccMap[n] = 0;
					}
				});
				
			//커지면 누적된 데이터 대입
			} else if (Number(curGrpLvlId) > Number(preGrpLvlId)) {
				////console.log(i+",  case 3-1 : "+setpAccMap[preGrpLvlId]);
				if (Number(gfn_nvl(provider.getValue(i, field),0)) != setpAccMap[preGrpLvlId]) {
					gfn_setProvider(provider, i, field, setpAccMap[preGrpLvlId]);
					
					//callback function call
					if (GRIDCALC.bsc.flag) {
						GRIDCALC.bsc.callback(provider, i, field, meaCd);
					} else {
						//월토탈 처리
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
	$.each(BUCKET.query, function(n,v) {
		if (v.CD == fieldNm) {
			rtnVal = v.ROOT_CD.replace("M","MT_");
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
		
		//gfn_cellColorDecide(provider, monthField, idx);
		
		//callback function call
		if (GRIDCALC.bsc.flag && bscFlag == false) {
			GRIDCALC.bsc.callback(provider, idx, monthField);
		}
	}
	
	return rtnVal;
}

//월토탈 데이터를 가져온다.
function gfn_getMonthTotalVal(provider, dataRow, monthField, totYn) {
	
	var rtnVal = 0;
	//if (provider.getFieldIndex(monthField) == -1) return rtnVal;
	
	totYn = totYn || "N";
	$.each(BUCKET.query, function(n,v) {
		if (totYn == "N" && v.TOT_TYPE != "MT" && v.ROOT_CD == monthField.replace("MT_","M")) {
			rtnVal += Number(gfn_nvl(provider.getValue(dataRow, v.CD),0));
		} else if (totYn == "Y" && v.TOT_TYPE != "MT") {
			rtnVal += Number(gfn_nvl(provider.getValue(dataRow, v.CD),0));
		} 
	});
	return rtnVal;
}

//범위의 데이터 전체가 0인지 체크
function gfn_chkAllZero(provider, startIdx, endIdx, fields, meaCd) {
	var rtnMap = {
		chkAll: true, 
		actSum: 0,
		frozenSum: 0,
	};
	
	var tmpMeaCd = "";
	for (var i=startIdx; i<=endIdx; i++) {
		
		tmpMeaCd = provider.getFieldIndex(gv_measureCd) != -1 ? provider.getValue(i ,gv_measureCd) : "";
		if (meaCd != tmpMeaCd) continue; //같은 카테고리만 처리
		
		for (var k=0; k<fields.length; k++) {
			if (Number(provider.getValue(i, fields[k])) > 0) {
				rtnMap.chkAll = false;
			}

			//frozen 구간 sum
			if (provider.getValue(i, fields[k]+"_FROZEN_YN") == "Y") {
				var value = Number(gfn_nvl(provider.getValue(i, fields[k]), 0));
				rtnMap.frozenSum += value;
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
		} else {
			//var newOmit = orgOmit + Math.abs(Number(gfn_nvl(val,0)));
			//provider.setValue(dataRow, gv_omitFlag, newOmit.toString());
		}
	}
}

function gfn_cellColorDecide(provider, filedName, frozenInfoRowIdx, flag){
	
	var redName = "";
	var blackName = "";
	var rowIdx = frozenInfoRowIdx - gfn_getFindPositionInDs(MEASURE.user, "CD", apMeaCd);
	var apMeaCompareIdx = gfn_getFindPositionInDs(MEASURE.user, "CD", apMeaCompare);
	var apMeaCompareRowIdx =  rowIdx + apMeaCompareIdx;
	
	var frozenInfoVal = provider.getValue(frozenInfoRowIdx, filedName);
	var apMeaCompareVal = provider.getValue(apMeaCompareRowIdx, filedName);
	
	if(flag){
		redName = "cellAp1StyleRed";
		blackName = "cellAp1StyleBlack";
	}else{
		redName = "cellAp1StyleRedFlase";
		blackName = "cellAp1StyleBlackFlase";
	}
	
	if(frozenInfoVal == apMeaCompareVal || apMeaCompareIdx == -1){
		grdMain.setCellStyles(frozenInfoRowIdx, filedName , blackName);
	}else{
		grdMain.setCellStyles(frozenInfoRowIdx, filedName , redName);
	}
	
	var columns = grdMain.columnByName(filedName);
	columns.editor = {
						 type : "number"
					   , positiveOnly : true
					   , integerOnly : true 
					 };
	grdMain.setColumn(columns);
	
}



/***************************
 * BSC GRID CALC
 * 
 * ex) bsc 계산.
 *	var bsc = new BSC_CALC();
 * 	var bscArgs =  {
				totCol  : "QC",   // 전체 field 앞
				kpiCol  : ["KPI1", "KPI2"], 
				exCol   : ["KPI1_TARGET_VALUE", "KPI2_TARGET_VALUE"],
				cols    : {
					BSC_COL    : "_BSC_VAL",
					WEIGHT_COL : "_WEIGHT_RATE",
					TARGET_COL : "_TARGET_VALUE",
					RESULT_COL : "_RESULT_RATE",
					BILL_COL   : "_BILL_RESULT",
				},
				gridInstance : this.bscGrid.gridInstance,
				calcFunc     : function (kpiId, weight, target, result) {
					return bsc.util.R( bsc.util.D ( (bsc.util.M (1, bsc.util.D (bsc.util.M (result, target), target)) * 100) * bsc.util.Z(weight),  bsc.util.Z(weight)), 0);
				},
			};
 * 
 *   bsc.init();
 ***************************/
var BSC_CALC = function () {
	
	this.util = null; 
	
	var util = {
		F : function (n, pos) {
			var digits = Math.pow(10, pos); 
			var num = Math.floor(n * digits) / digits; 
			return num.toFixed(pos);
		},
		
		R : function (n, pos) {
			var digits = Math.pow(10, pos);

			var sign = 1;
			if (n < 0) {
				sign = -1;
			}
			n = n * sign;
			var num = Math.round(n * digits) / digits;
			num = num * sign;

			return num.toFixed(pos);
		},
		
		Z : function (n) {
			return !$.isNumeric(n) ? 0 : n;
		},
		
		D : function (x, y) {
			return this.Z(this.F (this.Z(x) / this.Z(y), 6));
		},
		
		M : function (x, y) {
			return this.Z(x) - this.Z(y);
		},

		P : function (x, y) {
			return this.Z(x) + this.Z(y);
		},
		
		MZ : function (x) {
			return (0 > this.Z(x) ? 0 : this.Z(x));
		}
	};
	
	
	var BSC_GRID = {
		tagetEx  : ['KPI16', 'KPI17', 'KPI18'],
		tagetSum : ['KPI6'],
		provider : null,
		grdMain  : null,
		events   : function () {
			this.grdMain.onEditRowChanged = function (grid, itemIndex, dataRow, field, oldValue, newValue) {
				gridCalc(grid, itemIndex, dataRow, field, oldValue, newValue);
			};

			this.grdMain.onEditRowPasted = function(grid, itemIndex, dataRow, fields, oldValues, newValues) {
				
				if (fields.length == newValues.length) {
					gridCalc(grid, itemIndex, dataRow, fields, oldValues, newValues);
				} else {
					var arrNewVal = [];
					$.each(fields, function(n,v) {
						arrNewVal.push(newValues[v]);
					});
					gridCalc(grid, itemIndex, dataRow, fields, oldValues, arrNewVal);
				}
				
			};
		},
	};
	
	this.init = function(bscArgs) {
		
		this.util = util;
		
		$.each(bscArgs, function (i, v) {
			BSC_GRID[i] = v;
		});
		
		BSC_GRID.provider = bscArgs.gridInstance.objData
		BSC_GRID.grdMain  = bscArgs.gridInstance.objGrid
		
		//그리드 옵션
		BSC_GRID.grdMain.setOptions({
			stateBar: { visible      : true  },
			sorting : { enabled      : false },
			display : { columnMovable: false }
		});
		
		BSC_GRID.events();
	};
	
	var gridCalc = function (grid, itemIndex, dataRow, field, oldValue, newValue) {
		if ($.isArray(field)) {
			var tmpOldVal;
			$.each(field, function(n,v) {
				
				setBscScore (dataRow, field[n], newValue[n]);
				setRollUpTotal (dataRow, field[n]);
				setTotalWeight (dataRow);
			});
		} else {
			
			setBscScore (dataRow, field, newValue);
			setRollUpTotal (dataRow, field);
			setTotalWeight (dataRow);
		}
	};
	
	// rollup
	var setRollUpTotal = function (idx, field) {
		// 목표 값이 rollup이 아닐경우
		var provider = BSC_GRID.provider;
		
		var grpLvlId    = provider.getValue(idx, gv_grpLvlId);
		var curGrpLvlId = "0", preGrpLvlId = "0";
		var startIdx    = provider.getRowCount()-1;
		var setpAccMap  = {};
		
		try {
			provider.beginUpdate();
			
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
					if (idx >= i && Number(gfn_nvl(provider.getValue(i, field),0)) != setpAccMap[preGrpLvlId]) {
						setBscScore(i, field, setpAccMap[preGrpLvlId]);
						setTotalWeight(i);
					}
				} 
				
				setpAccMap[curGrpLvlId] = gfn_nvl(setpAccMap[curGrpLvlId],0) + Number(gfn_nvl(provider.getValue(i, field),0));		
		
				//마지막에 현지점 grpLvlId set
				preGrpLvlId = curGrpLvlId;
			}
		} finally {
			provider.endUpdate();
		}
	};
	
	
	var setBscScore = function (idx, field, val) {
		
		var provider = BSC_GRID.provider;
		var levelId  = provider.getValue(idx, gv_grpLvlId);

		if (BSC_GRID.exCol.length > 0) {
			if ($.inArray(provider.getFieldName(field), BSC_GRID.exCol) == -1 ) {
				provider.setValue(idx, field, val);
			} else {
				if (levelId == '0') {
					provider.setValue(idx, field, val);
				}
			}
		} else {
			provider.setValue(idx, field, val);
		}
		
		var FIELD_NM     = provider.getFieldName(field);
		var KPI_FIELD    = FIELD_NM.substring(0, FIELD_NM.indexOf("_"));
		var BSC_FIELD    = KPI_FIELD + BSC_GRID.cols.BSC_COL;
		var WEIGHT_FIELD = KPI_FIELD + BSC_GRID.cols.WEIGHT_COL;
		var TARGET_FIELD = KPI_FIELD + BSC_GRID.cols.TARGET_COL;
		var RESULT_FIELD = KPI_FIELD + BSC_GRID.cols.RESULT_COL;
		var BILL_FIELD   = KPI_FIELD + BSC_GRID.cols.BILL_COL;
		
		var weight, target, result, bscVal = 0;
		var preResult, billResult, tgVal = 0;
		
		if (levelId == '0') {
			weight = provider.getValue(idx, WEIGHT_FIELD);
			target = provider.getValue(idx, TARGET_FIELD);
			result = provider.getValue(idx, RESULT_FIELD);
			
			if ($.isFunction (BSC_GRID.calcFunc)) {
				bscVal  = BSC_GRID.calcFunc(KPI_FIELD, weight, target, result);
			}
			provider.setValue(idx, BSC_FIELD, bscVal);
			
		} else {
			
			// target
			if (FIELD_NM.indexOf(BSC_GRID.cols.TARGET_COL) > -1 && 
					$.inArray(KPI_FIELD, BSC_GRID.tagetEx) == -1 &&
					$.inArray(KPI_FIELD, BSC_GRID.tagetSum) == -1 ) {
				billResult = getRowTotal(idx, BILL_FIELD);
				preResult  = getRowTotal2(idx, TARGET_FIELD, BILL_FIELD)
				tgVal      =  util.D (preResult, billResult);
				provider.setValue(idx, TARGET_FIELD, tgVal);
			}
			
			// 가중치
			weight = getRowTotal(idx, WEIGHT_FIELD);
			target = getRowTotal2(idx, BSC_FIELD, WEIGHT_FIELD);
			
			bscVal = util.D(target, weight);
			
			provider.setValue(idx, BSC_FIELD, bscVal);
			//
		}
		
		// total BSC Score
		var tWeight, tTarget, tBscVal = 0;
		tWeight = getColTotal (idx, BSC_GRID.cols.WEIGHT_COL);
		tTarget = getColTotal2 (idx, BSC_GRID.cols.BSC_COL, BSC_GRID.cols.WEIGHT_COL);

		tBscVal = util.D(tTarget, tWeight);
		
		provider.setValue(idx, BSC_GRID.totCol + BSC_GRID.cols.BSC_COL, tBscVal);
	};
	
	var setTotalWeight = function (idx) {
		var col      = BSC_GRID.cols.WEIGHT_COL;
		var rtnVal   = getColTotal(idx, col);
		var provider = BSC_GRID.provider;
		
		provider.setValue(idx, BSC_GRID.totCol + col, rtnVal);
	};
	
	var getColTotal = function (idx, col) {
		var filedId;
		var provider = BSC_GRID.provider;
		var rtnVal   = 0;
		
		for (var i = 0; i < BSC_GRID.kpiCol.length; i++) {
			filedId = BSC_GRID.kpiCol[i] + col;
			rtnVal += getRowTotal(idx, filedId);
		}

		return rtnVal;
	};
	
	var getColTotal2 = function (idx, col1, col2) {
		var filedId1, filedId2;
		var provider = BSC_GRID.provider;
		var rtnVal   = 0;
		
		for (var i = 0; i < BSC_GRID.kpiCol.length; i++) {
			filedId1 = BSC_GRID.kpiCol[i] + col1;
			filedId2 = BSC_GRID.kpiCol[i] + col2;
			rtnVal += getRowTotal2 (idx, filedId1, filedId2);
		}

		return rtnVal;
	};
	
	// row data level 0인 total
	var getRowTotal = function (idx, fieldNm) {
		var provider   = BSC_GRID.provider;
		var rtnVal     = 0;
		var startIdx   = provider.getRowCount()-1;
		var levelId    = provider.getValue(idx, gv_grpLvlId)
		var tmpField1, fieldVal;
		
		if (levelId == '0') {
			tmpField = "PART_CD";
		} else if (levelId == '1') {
			tmpField = "TEAM_CD";
		} else if (levelId == '3') {
			tmpField = "DIV_CD";
		} else {
			tmpField = "BU_CD";
		} 

		var fieldVal  = provider.getValue(idx, tmpField);
	
		for (var i = startIdx; i >= 0; i--) {
			if (provider.getValue(i, tmpField) == fieldVal && provider.getValue(i, gv_grpLvlId) == '0') {
				rtnVal += Number(gfn_nvl(provider.getValue(i, fieldNm),0));
			}
		}
		
		return rtnVal;
	};
	
	
	var getRowTotal2 = function (idx, field1, field2) {
		var provider   = BSC_GRID.provider;
		var rtnVal     = 0;
		var startIdx   = provider.getRowCount()-1;
		var levelId    = provider.getValue(idx, gv_grpLvlId)
		var tmpField1, fieldVal;
		
		if (levelId == '0') {
			tmpField = "PART_CD";
		} else if (levelId == '1') {
			tmpField = "TEAM_CD";
		} else if (levelId == '3') {
			tmpField = "DIV_CD";
		} else {
			tmpField = "BU_CD";
		} 

		var fieldVal  = provider.getValue(idx, tmpField);
		
		for (var i = startIdx; i >= 0; i--) {
			if (provider.getValue(i, tmpField) == fieldVal && provider.getValue(i, gv_grpLvlId) == '0') {
				rtnVal += Number(gfn_nvl(provider.getValue(i, field1),0)) * Number(gfn_nvl(provider.getValue(i, field2),0));
			}
		}
		
		return rtnVal;
	}
};