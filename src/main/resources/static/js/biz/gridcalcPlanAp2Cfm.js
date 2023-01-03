var AMT_MEA_CD = "_AMT_KRW";

var GRIDCALC = {
	
	gridInst      : null,	
	apMeaCd       : "",
	amtMeaCd      : [],
	changeMap     : [],
		
	autoCalc : function(gridInst, itemIndex, dataRow, field, oldVal, newVal) {
		
		if (oldVal == undefined) oldVal = 0;
		if (newVal == undefined) newVal = 0;
		
		GRIDCALC.gridInst = gridInst;
		
		var grid      = gridInst.objGrid;
		var provider  = gridInst.objData;
		var fieldNm   = provider.getFieldName(field);
		
		gfn_getMeaCalcIndex2(grid, field, dataRow, fieldNm, itemIndex);
		
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

/******************************************************************************************
** Rollup Total 처리
******************************************************************************************/
function gfn_setRollupTotal(provider, idx, field, meaCd) {
	
	var grpLvlId = provider.getValue(idx, gv_grpLvlId);
	var curGrpLvlId = "0", preGrpLvlId = "0";
	var startIdx = provider.getRowCount() - 1;
	var setpAccMap = {};
	
	try {
		provider.beginUpdate();
		
		//월토탈 처리
		gfn_setMonthTotalVal(provider, idx, field);
		
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
					gfn_setMonthTotalVal(provider, i, field);
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

/******************************************************************************************
** 금액처리
******************************************************************************************/
function gfn_setAmt(grid, idx, field, editVal, itemIndex) {
	
	if(editVal != undefined){
		
		var provider = grid.getDataSource();
		var editValAmt = editVal + AMT_MEA_CD;
		
		var fieldIdx = gfn_getMeaCalcIndex(grid, field, itemIndex, editVal, editValAmt);
		
		if (fieldIdx != -1){
			var salesQty = grid.getValue(itemIndex, field);
			var salesAmt = gfn_setAmtFunc(editValAmt, provider, idx, salesQty, fieldIdx, itemIndex);
			
			gfn_setProvider(provider, idx, fieldIdx, salesAmt);
			gfn_setRollupTotal(provider, idx, fieldIdx, editValAmt);
		}
	}
	
	/*if(editVal != undefined){
		
		var provider = grid.getDataSource();
		var editValAmt = editVal + AMT_MEA_CD;
		
		var fieldIdx = gfn_getMeaCalcIndex(grid, field, idx, editVal, editValAmt);
		
		if (fieldIdx != -1){
			var salesQty = grid.getValue(idx, field);
			var salesAmt = gfn_setAmtFunc(editValAmt, provider, idx, salesQty, fieldIdx);
			
			gfn_setProvider(provider, idx, fieldIdx, salesAmt);
			gfn_setRollupTotal(provider, idx, fieldIdx, editValAmt);
		}
	}*/
}

/******************************************************************************************
** 데이터 세팅하기
******************************************************************************************/
function gfn_getMeaCalcIndex2(grid, fieldIdx, idx, fieldNm, itemIndex) {
	
	var keyHd = "";
	var key2Hd = "";
	var keyEdit = "";
	var keyEditHd = "";
	var keyTotal = "";
	var keyTotalHd = "";
	var keyTotalW1Hd = "";
	var fileNmSpilt = fieldNm.split("_");
	var fileNmSpilt1 = fileNmSpilt[0]; 
	var fileNmSpilt2 = fileNmSpilt[1]; 
	var colunmNm = fileNmSpilt1 + "_" + fileNmSpilt2;
	
	if(fileNmSpilt2 == "AP2" || fileNmSpilt2 == "CFM"){
		if(fieldNm.indexOf("DMD1") != -1){
			keyEdit = fileNmSpilt2 + "_DMD1_SP";
			keyEditHd = colunmNm + "_DMD1_SP_HD"; 
			keyHd = colunmNm + "_DMD2_SP_HD";
			key2Hd = colunmNm + "_DMD3_SP_HD";
		}else if(fieldNm.indexOf("DMD2") != -1){
			keyEdit = fileNmSpilt2 + "_DMD2_SP";
			keyEditHd = colunmNm + "_DMD2_SP_HD";
			keyHd = colunmNm + "_DMD1_SP_HD";
			key2Hd = colunmNm + "_DMD3_SP_HD";
		}else if(fieldNm.indexOf("DMD3") != -1){
			keyEdit = fileNmSpilt2 + "_DMD3_SP";
			keyEditHd = colunmNm + "_DMD3_SP_HD";
			keyHd = colunmNm + "_DMD1_SP_HD";
			key2Hd = colunmNm + "_DMD2_SP_HD";
		}
		
		keyTotal = colunmNm + "_SP";
		keyTotalHd = colunmNm + "_SP_HD";
		
		if(fileNmSpilt2 == "AP2"){
			keyTotalW1Hd = colunmNm + "_SP_W1_HD";	
		}else if(fileNmSpilt2 == "CFM"){
			keyTotalW1Hd = fileNmSpilt1 + "_AP2_SP_HD";
		}
		
		/*var keyEditData = gfn_nvl(grid.getValue(idx, fieldNm), 0);
		var keyHdData = gfn_nvl(grid.getValue(idx, keyHd), 0);
		var key2HdData = gfn_nvl(grid.getValue(idx, key2Hd), 0);
		var keyTotalData = keyEditData + keyHdData + key2HdData;*/
		
		var keyEditData = gfn_nvl(grid.getValue(itemIndex, fieldNm), 0);
		var keyHdData = gfn_nvl(grid.getValue(itemIndex, keyHd), 0);
		var key2HdData = gfn_nvl(grid.getValue(itemIndex, key2Hd), 0);
		var keyTotalData = keyEditData + keyHdData + key2HdData;
		
		var keyEditIdx = gfn_getFindPositionInDs(MEASURE.user, "CD", keyEdit);
		var keyTotalIdx = gfn_getFindPositionInDs(MEASURE.user, "CD", apMeaCd);
		
		dataProvider.setValue(idx, keyEditHd, keyEditData); //edit한 데이터 Hidden값 세팅
		dataProvider.setValue(idx, keyTotalHd, keyTotalData); //합계 데이터 Hidden값 세팅
		
		gfn_setRollupTotal(dataProvider, idx, fieldIdx, fieldNm); //edit 된 값 rollup
		gfn_setAmt(grid, idx, fieldIdx, keyEdit, itemIndex); //edit한 금액
		
		if(keyTotalIdx != -1){ //합계가 존재하면 세팅
			
			var keyTotalIdx = dataProvider.getFieldIndex(keyTotal);
			dataProvider.setValue(idx, keyTotal, keyTotalData);
			gfn_setRollupTotal(dataProvider, idx, keyTotalIdx, apMeaCd); //합계의 값 rollup
			gfn_setAmt(grid, idx, keyTotalIdx, apMeaCd, itemIndex); //합계의 금액
			
		}else{
			var spHd = fileNmSpilt2 + "_SP_HD";
			var spAmtKrw = fileNmSpilt2 + "_SP_AMT_KRW";
			var spAmtKrwSub = colunmNm + "_SP_AMT_KRW";
			
			var spAmtMeasureIdx = gfn_getFindPositionInDs(MEASURE.user, "CD", spAmtKrw);
			
			if(spAmtMeasureIdx == -1) return;
			
			var spAmtIdx = dataProvider.getFieldIndex(spAmtKrwSub);
			var salesAmt = gfn_setAmtFunc(spAmtKrw, dataProvider, idx, keyTotalData, fieldIdx, itemIndex);
			
			gfn_setProvider(dataProvider, idx, spAmtIdx, salesAmt);
			gfn_setRollupTotal(dataProvider, idx, spAmtIdx, spHd);
		}
		
		//AP2, CFM 화면 일 경우 후속 처리(조정수량)
		if(fileNmSpilt2 == "AP2" || fileNmSpilt2 == "CFM"){
			
			var adjQtyColunm = "ADJ_QTY";
			var calAdjQtyIdx = gfn_getFindPositionInDs(MEASURE.user, "CD", adjQtyColunm); //조정수량
			
			if(calAdjQtyIdx == -1) return true;
			
			var calAdjQtyFieldIdx = fieldIdx + calAdjQtyIdx - keyEditIdx;
			var keyTotalW1HdData = grid.getValue(idx, keyTotalW1Hd);
			var calAdjQtyData = keyTotalData - keyTotalW1HdData;
			
			dataProvider.setValue(idx, calAdjQtyFieldIdx, calAdjQtyData); //조정수량 변경
			gfn_setRollupTotal(dataProvider, idx, calAdjQtyFieldIdx, adjQtyColunm);
		}
	}
}

/******************************************************************************************
** 
******************************************************************************************/
function gfn_getMeaCalcIndex(grid, field, idx, editVal, editValAmt) {
	
	var amtMeaIdx = gfn_getFindPositionInDs(MEASURE.user, "CD", editValAmt);
	var apMeaIdx  = gfn_getFindPositionInDs(MEASURE.user, "CD", editVal);
	if (amtMeaIdx == -1) return -1; //없으면 처리안함
	
	var provider = grid.getDataSource();
	if (provider.getValue(idx, gv_grpLvlId) != 0) return -1;

	var fieldIdx = amtMeaIdx - apMeaIdx + field;
	return fieldIdx;
}

/******************************************************************************************
** 금액 계산
******************************************************************************************/
function gfn_setAmtFunc(type, provider, idx, salesQty, fieldIdx, itemIndex) {
	
	switch(type) {
	
		case "AP2_DMD1_SP_AMT_KRW" : 
		case "AP2_DMD2_SP_AMT_KRW" : 
		case "AP2_DMD3_SP_AMT_KRW" :
		case "CFM_DMD1_SP_AMT_KRW" :
		case "CFM_DMD2_SP_AMT_KRW" :
		case "CFM_DMD3_SP_AMT_KRW" :
		case "AP2_SP_AMT_KRW" :
		case "CFM_SP_AMT_KRW" :
		case "YP_AMT_KRW"     :
			var salesAmt = salesQty * provider.getValue(idx, "SALES_PRICE_KRW_HIDDEN");
			salesAmt = $.isNumeric(salesAmt) ? salesAmt : 0;
			return salesAmt;
		
		case "OP_AMT_KRW":
			var opAmt = (salesQty * provider.getValue(idx, "SALES_PRICE_KRW_HIDDEN"))
			          - (salesQty * provider.getValue(idx, "COGS_KRW"))
			          - (salesQty * provider.getValue(idx, "SGNA_KRW"));
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



/******************************************************************************************
** 행 토탈 arrField
******************************************************************************************/
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

/******************************************************************************************
** 월 합계 구하기
******************************************************************************************/
function gfn_setMonthTotalVal(provider, idx, field) {
	
	var fieldNm = provider.getFieldName(field);
	var monthField = gfn_getMonthField(provider, field);
	var rtnVal = gfn_getMonthTotalVal(provider, idx, monthField, "Y", fieldNm);
	
	gfn_setProvider(provider, idx, monthField, rtnVal);
	
	return rtnVal;
}

/******************************************************************************************
** 월 합계 데이터 계산
******************************************************************************************/
function gfn_getMonthTotalVal(provider, dataRow, monthField, totYn, fieldNm) {
	
	var rtnVal = 0;
	var matchingRootCd = "";
	var cdArray = new Array();
	var fieldNmSplit = fieldNm.split("_");
	var matchingCd = fieldNmSplit[0];
	var totalMeaCd = fieldNmSplit[1] + "_SP";
	var fliedFlag = fieldNm.indexOf(AMT_MEA_CD); //금액 Measure
	var fileNmMatching = gfn_replaceAll(fieldNm, matchingCd, "");
	
	//1.매칭되는 주차 확인
	$.each(BUCKET.all[1], function(i, val) {
		
		var valCd = val.CD;
		var valRootCd = val.ROOT_CD;
		
		if(valCd == matchingCd){
			matchingRootCd = valRootCd;
			return false;
		}
	});
	
	//2.매칭된 주차 배열에 담기
	$.each(BUCKET.all[1], function(i, val) {
		
		var valCd = val.CD;
		var valRootCd = val.ROOT_CD;
		var valCdFlag = valCd.indexOf("MT_");
		
		if(matchingRootCd == valRootCd && valCdFlag == -1){
			cdArray.push(valCd);
		}
	});
	
	//3.배열에 담은 주차에 값을 가져와 합계 구하기
	$.each(cdArray, function(i, val) {
		
		var getId = val + fileNmMatching;
		rtnVal += Number(gfn_nvl(provider.getValue(dataRow, getId), 0));
	});
	
	return rtnVal;
}

/******************************************************************************************
** 데이터 세팅하기
******************************************************************************************/
function gfn_setProvider(provider, dataRow, field, val, changeMapYn) {
	
	changeMapYn = changeMapYn || "Y"; 
	provider.setValue(dataRow, field, val);
	
	if (changeMapYn == "Y") {
		GRIDCALC.changeMap.push({dataRow: dataRow, field: field, value: val});
	}
	
	//omit flag set
	/*if (provider.getFieldIndex(gv_omitFlag) != -1) {
		var orgOmit = Number(gfn_nvl(provider.getValue(dataRow, gv_omitFlag),0));
		if (provider.getFieldIndex(gv_colBucketTotal) != -1) {
			var newOmit = provider.getValue(dataRow, gv_colBucketTotal);
			if (newOmit == undefined) {
				provider.setValue(dataRow, gv_omitFlag, "0");
			} else {
				provider.setValue(dataRow, gv_omitFlag, newOmit.toString());
			}
		}
	}*/
}
