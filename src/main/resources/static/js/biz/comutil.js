// 가로 스크롤바
(function($) {
    $.fn.hasHorizontalScrollBar = function() {
        return this.get(0) ? this.get(0).scrollWidth > this.innerWidth() : false;
    }
})(jQuery);

// 세로 스크롤바
(function($) {
    $.fn.hasVerticalScrollBar = function() {
        return this.get(0) ? this.get(0).scrollHeight > Math.round(this.innerHeight()) : false;
    }
})(jQuery);

jQuery.extend({
	getQueryParameters : function(str) {
		return (str || document.location.search).replace(/(^\?)/,'').split("&").map(function(n){return n = n.split("="),this[n[0]] = n[1],this}.bind({}))[0];
	}
});

/**
 * 두 날짜 비교
 * compareDate: 날짜 비교
 * parameters
 * - date1: 시작일
 * - date2: 종료일
 * - allowEqual: 시작일과 같은 종료일을 허용할 것인지 여부 (*optional)
*/
function gfn_compareDate(date1, date2,allowEqual) {
	var dateVal1 = 0;
	var dateVal2 = 0;
	if (date1.indexOf(".") > 0) {
		dateVal1= Number(gfn_replaceAll(date1,".",""));
	} else {
		dateVal1 = Number(date1);
	}
	if (date2.indexOf(".") > 0) {
		dateVal1= Number(gfn_replaceAll(date2,".",""));
	} else {
		dateVal2 = Number(date2);
	}
	if (allowEqual && allowEqual == true) {
		return (dateVal2 >= dateVal1);
	}
	return (dateVal2 > dateVal1);
}

/*
 * type : 일 -> day, 월 -> month 
 * addVal : +- 값의 데이터
 * gubun : 구분자 
 * val : 날짜 지정
 * */
function gfn_addDate(type, addVal, gubun, val) {
	
	val = gfn_nvl(val, "");
	type = type || "day";
	gubun = gubun || "";
	
	var curDate;
	
	if(val == ""){
		curDate  = new Date();
	}else{
		yyyy = val.substr(0, 4);
    	mm   = val.substr(4, 2);
    	dd   = val.substr(6, 2);
    	
    	curDate = new Date(yyyy + "/" + mm + "/" + dd);
	}
	
	var curYear  = curDate.getFullYear();
	var curMonth = curDate.getMonth();
	var curDay  = curDate.getDate();
	
	if(type == "day"){
		curDate.setMonth(curMonth + 1); 
		curDate.setDate(curDay + addVal);
	}else if(type == "month"){
		curDate.setMonth(curMonth + addVal + 1); 
	}
	
	curYear  = curDate.getFullYear();
	curMonth = curDate.getMonth();
	curDay  = curDate.getDate();
	
	if(curMonth == 0)
	{
		curMonth = 12;
	}
	else if(curMonth < 10){
		curMonth = "0" + curMonth;
	}
	
	if(curDay < 10){
		curDay = "0" + curDay;
	}
	return curYear + gubun + curMonth + gubun + curDay;
}

/**
 * JavaScript replaceAll - 정규식 사용
 * replaceAll: 주어진 문자열에서 특정 모든 문자를 다른 문자로 변경.
 * parameters
 *  - fullStr: 전체 문자열
 *  - str1: 바꾸고자 하는 문자열
 *  - str2: 변경될 문자열
 *  - ignore: case sensitive 고려여부 (true > ignore case sensitive, false > case sensitive)
 *  ex) var numStr = replaceAll("1-2-3-4-5-6-7","-","");
 */
function gfn_replaceAll(fullStr,str1, str2, ignore) {
	if (gfn_isNull(fullStr)) return "";
	return fullStr.replace(new RegExp(str1.replace(/([\/\,\!\\\^\$\{\}\[\]\(\)\.\*\+\?\|\<\>\-\&])/g,"\\$&"),	(ignore?"gi":"g")),(typeof(str2)=="string")?str2.replace(/\$/g,"$$$$"):str2);
}

/**
 * Input 및 select  value 제거 (checkbox, radio, text,  textarea 포함)
 * clearAllChildrenValue: clear values of children of given parent, also possible to clear selected, checked attributes
 * Parameters
 *  - parentId: parentId containing elements to be cleared.
 *  - doHiddenClear: if true, then clear hidden fields also, otherwise skip hidden fields.
 *  - defaultSelector: if defaultSelector is given, then only matched elements with defaultSelector is being cleared.
 */
function gfn_clearAllChildrenValue(parentId, doHiddenClear, defaultSelector) {
	var parentEm = $("#"+parentId);
	var selector = (defaultSelector) ? defaultSelector:"input:checkbox, input:radio,input:text,select,textarea";
	if (doHiddenClear) {
		selector +=",input:hidden";
	}
	parentEm.find(selector).each(function() {
		$(this).val("");
		var typeName = $(this)[0].type;
		if (typeName == "select-one") {
			$(this).children().removeAttr("selected");
		} else if ((typeName == "radio") || (typeName == "checkbox")) {
			$(this).removeAttr("checked");
		}
	});
}

/**
 * HTML 문서내의 모든 selectbox, radio, checkbox, text를 disable 혹은 readonly로 변경
	 * disableElements: select,radio,checkbox, input:text에 한하여 해당 elements를 disable
	 * parameters
	 *  - arrObj: jQuery로 select하여 반환된 elements
	 * Usage (문서내의 모든 selectbox, radio,checkbox,text를 disable 시킴)
	 *  >> disableElements($("select,input:radio,input:text,input:checkbox"));
*/
function gfn_disableElements(arrObj) {
	for (var index=0;index<arrObj.length;index++) {
		var typeName = arrObj[index].type;
		var obj = $(arrObj[index]);
		if ((typeName == "select-one") || (typeName == "radio") || (typeName == "checkbox")) {
			obj.attr("disabled","disabled");
		} else if (typeName =="text") {
			obj.attr("readonly","readonly");
		}
	}
}

/**
 * 7번 경우와 달리 해당 elements를 활성화 시킴
 * disableElements과는 반대로 elements를 enable 시킴
 */
function gfn_enableElements(arrObj) {
	for(var index=0;index<arrObj.length;index++){
		var typeName = arrObj[index].type;
		var obj = $(arrObj[index]);
		if((typeName == "select-one") || (typeName == "radio") || (typeName == "checkbox")){
			obj.removeAttr("disabled");
		}else if(typeName =="text"){
			obj.removeAttr("readonly");
		}
	}
}

$.fn.serializeObject = function() {
    var o = {};
    //var a = this.serializeArray();
    $(this).find('input[type="hidden"], input[type="text"], input[type="password"], input[type="checkbox"]:checked, input[type="radio"]:checked, select').each(function() {
        if ($(this).attr('type') == 'hidden') { //If checkbox is checked do not take the hidden field
            var $parent = $(this).parent();
            var $chb = $parent.find('input[type="checkbox"][name="' + this.name.replace(/\[/g, '\[').replace(/\]/g, '\]') + '"]');
            if ($chb != null) {
                if ($chb.prop('checked')) return;
            }
        }
        if (this.name === null || this.name === undefined || this.name === '')
            return;
        var elemValue = null;
        if ($(this).is('select')) {
        	if(!gfn_isNull($(this).attr("multiple"))) {
        		elemValue = $(this).multipleSelect('getSelects').join();
        	} else {
        		elemValue = $(this).find('option:selected').val();
        	}
        } else {
        	//datepicker 처리
            if ($(this).hasClass("iptdate")) {
            	elemValue = this.value.replace(/-/g, '');
            } else {
            	elemValue = this.value;
            }
        }
        if (o[this.name] !== undefined) {
            if (!o[this.name].push) {
                o[this.name] = [o[this.name]];
            }
            o[this.name].push(elemValue || '');
        }
        else {
            o[this.name] = elemValue || '';
        }
    });
    return o;
}

/**
 excel condition
 */
function gfn_getExcelCondition($form, callFn) {
	var rtnO = [];
    $($form).find('input[type="text"], input[type="password"], input[type="checkbox"]:checked, input[type="radio"]:checked, select').each(function() {
    	var oName = this.name;
    	var o = {};
        if (oName === null || oName === undefined || oName === '') return;
        
        var elemValue = null;
        if ($(this).is('select')) {
        	if(!gfn_isNull($(this).attr("multiple"))) {
        		elemValue = $(this).multipleSelect('getSelects','text').join();
        	} else {
        		elemValue = $(this).find('option:selected').text();
        	}
        } else if ($(this).prop('type') === 'radio') {
        	oName     = this.id;
        	elemValue = $(this).next().text();
        } else {
        	elemValue = this.value;
        }
        if (o[oName] !== undefined) {
            if (!o[oName].push) {
                o[oName] = [o[oName]];
            }
            o[oName].push(elemValue || '');
        } else {
            o[oName] = elemValue || '';
        }
        rtnO.push(o);
    });
    
    var rtnStr = "";
    Array.from($(".srhTab").find("li")).forEach(function(v) {
	    rtnStr += (gfn_isNull(rtnStr) ? "" : "\n") + $(v).find("strong").text() + " " + $(v).find("span").text();
	});
	
    let preTitle = "";
    rtnO.forEach(function(v) {
		for(key in v) {
			let exTitle = ""; 
			
			//예외 case 처리
			if ($.isFunction(callFn)) {
				exTitle = callFn.call(this,key);
			}
			
			if (gfn_isNull(exTitle)) {
				if ($("#"+key).prop("type") === "radio") {
					exTitle = $("#"+key).parent().parent().siblings(".filter_tit").text();
				} else {
					exTitle = $("#"+key).siblings(".itit").length > 0 ? $("#"+key).siblings(".itit").text() : $("#"+key).parent().siblings(".itit, .filter_tit").text();
				}
			}
			
			let exValue = v[key];
			let dateB = $("#"+key).hasClass("iptdate");
			let dateweekB = $("#"+key).hasClass("iptdateweek");
			
			if (preTitle !== exTitle) {
				rtnStr += (gfn_isNull(rtnStr) ? "" : "\n") + exTitle + " : " + exValue;
			} else {
				rtnStr += (dateB ? " ~ " : " ") + (dateweekB ? "(" + exValue + ")" : exValue);
			}
			preTitle = exTitle;
		}
	});
    return rtnStr;
}

/**
 * Javascript 배열 초기화
 * Initialize array object
 * parameter
 *  - array object
 */
function gfn_clearArrayObject(arrObj) {
	arrObj.length = 0;
}

/**
 * Javascript 배열에서 배열이 가진 요소의 값을 가지고 해당 요소를 배열에서 제거
 * removeItemFromArrayWithValue
 * parameter
 *  - pValue: value to search
 *  - arrObj: array object
*/
function gfn_removeItemFromArrayWithValue(pValue,arrObj){
	if(typeof(arrObj)!='object'){
		return;
	}
	var idx = jQuery.inArray(Number(pValue),arrObj);
	if(idx > -1){
		arrObj.splice(idx,1);
	}
}

/**
 * Javascript lpad, rpad ( oracle lpad, rpad 와 동일)
 * originalstr: lpad 할 text
 * length: lpad할 길이
 * strToPad: lpad 시킬 text
 */
function gfn_lpad(originalstr, length, strToPad) {
    while (originalstr.length < length)
        originalstr = strToPad + originalstr;
    return originalstr;
}

/**
 *  originalstr: rpad 할 text
 * length: rpad할 길이
 * strToPad: rpad 시킬 text
 */
function gfn_rpad(originalstr, length, strToPad) {
    while (originalstr.length < length)
        originalstr = originalstr + strToPad;
    return originalstr;
}

/**
 * 3자리씩 끊어 콤마(,)추가
 * @param strValue
 * @returns
 */
function gfn_addCommas( val ) {
	strValue = val.toString();
	var objRegExp = new RegExp('(-?[0-9]+)([0-9]{3})');
	while(objRegExp.test(strValue)) {
		strValue = strValue.replace(objRegExp, '$1,$2');
	}
	return strValue;
}


function parseFloatWithCommas(val, n) {

	if (typeof val === 'number') {
		val = val.toString();
	}
	
	var numberWithCommas = function(x) {
		return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	};

	return numberWithCommas(parseFloat(val.replace(',', '')).toFixed(n));
}

//소수점 포멧정의
//mType : F,C,R
function gfn_getNumberFmt(val, n, mType, commaYn) {
	val = val || 0;
	var rtnVal;
	try {
		if (mType == "R") {
			rtnVal = Number(val.toFixed(n));
		} else if (mType == "F") {
			rtnVal = Math.floor(val * Math.pow(10,n)) / Math.pow(10,n);
		} else {
			rtnVal = Math.ceil(val * Math.pow(10,n)) / Math.pow(10,n);
		}
		if (commaYn == "Y") {
			rtnVal = gfn_addCommas( rtnVal );
		}
	} catch(e) {
		return val;
	}
	
	return rtnVal;
}

/**
 * 입력값의 바이트 길이를 리턴
 * 입력값의 바이트 길이를 리턴
 * ex) if (getByteLength(form.title) > 100) {
 *         alert("제목은 한글 50자(영문 100자) 이상 입력할 수 없습니다.");
 *     }
 */
function gfn_getByteLength(input) {
	var byteLength = 0;
	if ( input == null ) return 0;
	for (var inx = 0; inx < input.length; inx++) {
		var oneChar = escape(input.charAt(inx));
		if ( oneChar.length == 1 ) {
			byteLength ++;
		} else if (oneChar.indexOf("%u") != -1) {
			byteLength += 2;
		} else if (oneChar.indexOf("%") != -1) {
			byteLength += oneChar.length/3;
		}
	} // enf of for loop
	return byteLength;
}

//현재창이 팝업인지 확인하여 부모창을 리턴한다. 팝업이 아니면 null을 리턴
function gfn_getCurWindow() {
	var win = null;
	if (opener) {
		if (opener.opener) {
			win = opener.opener;
		} else {
			win = opener;
		}
	}
	return win;
}

function gfn_getDateToString(oDate) {
	if ( oDate == null || oDate === undefined ) {
		return "";
	}
	var year = oDate.getFullYear();
	var month = oDate.getMonth() + 1;
	var day = oDate.getDate();
	return year + "" +  (month < 10 ? "0" + month : month) + "" + (day < 10 ? "0" + day : day);
}

function gfn_getStringToDate(yyyymmdd) {
	if ( yyyymmdd == "" ) {
		return "";
	}
	var year = parseInt(yyyymmdd.substring(0,4));
	var month = parseInt(yyyymmdd.substring(4,6)) - 1;
	var day = parseInt(yyyymmdd.substring(6,8));
	return new Date(year, month, day);
}

//null check
function gfn_isNull(obj) {
	
	if (obj == undefined || obj == null || obj == "" || obj == 'undefined') return true;
	else return false;
}

//nvl
function gfn_nvl(obj,rObj) {
	if (gfn_isNull(obj)) return rObj;
	else return obj;
}

//"," 로 연결된 문자중에 해당 문자가 있는지를 체크한다.
function gfn_isExistString(str, findStr) {
	if ( (str + ",").indexOf(findStr + ",") > -1 ) {
		return true;
	} else {
		return false;
	}
}

//공백 제거 및 null 일 경우 빈 문자열
function gfn_getString(obj) {
	if ( obj == undefined ) {
		return "";
	} else if ( obj == null ) {
		return "";
	} else {
		return obj.trim();
	}
}

// 일자 유효 체크
function gfn_isValidDate(dt) {
	return !isNaN(new Date(dt));
}

//데이터셋 필트값중 max 값을 가져온다.
function gfn_getDsMaxData(objDs,fieldNm) {
	var rtnData = 0;
	for (var i=0; i<objDs.getRowCount(); i++) {
		if (objDs.getRowState(i) == "deleted" || objDs.getRowState(i) == "createAndDeleted") continue;

		if (gfn_isNull(rtnData) || rtnData < Number(objDs.getValue(i, fieldNm))) rtnData = Number(objDs.getValue(i, fieldNm));
	}
	return rtnData;
}

function gfn_addAllCode(codeList) {

	if(codeList.length>0) {
		var allObj = {};
		allObj.GROUP_CD = codeList[0].GROUP_CD;
		allObj.CODE_CD = "";
		allObj.CODE_NM = "All";

		codeList.unshift(allObj);
		return codeList;
	} else {
		return codeList;
	}
}

function gfn_removeAllCode(codeList) {
	return $.grep(codeList,function (o,i) { return o.CODE_CD !=  ""; });
}

//DS에서 필드 데이타를 배열로 가져온다.
function gfn_getArrayInDs(ds, field, topBlack) {
    var rtnArray = new Array();
    ds = ds || [];
    if ( topBlack != undefined && topBlack == true ) {
   		rtnArray.push("");
    }

    var forI;
    for ( forI = 0; forI < ds.length; forI++ ) {
   		rtnArray.push(ds[forI][field]);
    }
    return rtnArray;
}

//코드 DS에서 필드 데이타를 배열로 가져온다.
function gfn_getArrayExceptInDs(ds, field, exceptCodes) {
    var rtnArray = new Array();
    ds = ds || [];
    exceptCodes = exceptCodes || "";
    var forI;
    for ( forI = 0; forI < ds.length; forI++ ) {
    	if ( (exceptCodes + ",").indexOf(ds[forI].CODE_CD + ",") < 0 ) {
   			rtnArray.push(ds[forI][field]);
    	}
    }
    return rtnArray;
}

//그리드의 컬럼 데이타를 check(Y), uncheck(N) 한다.
function gfn_gridAllCheck(grd, field, checkFlag) {

	var flag = ( checkFlag ? "Y" : "N");

	var prod = grd.getDataProvider();

	prod.beginUpdate();
	try {
		for ( var i = 0; i < prod.getRowCount(); i++ ) {
			prod.setValue(i, field, flag);
		}
	} finally {
		prod.endUpdate();
	}
}

// 헤더의 체크를 초기화 한다.
function gfn_headerCheckboxReset(grd, checkboxFields) {
	var fields = checkboxFields.split(",");
	for ( var i = 0; i < fields.length; i++ ) {
    	var column = grd.columnByName(fields[i]);
    	column.checked = false;
    	grd.setColumn(column);
	}
}

function gfn_dupCheck(grid, datafields, focusField) {
	var provider = grid.getDataProvider();
	var data, datafield, pkStr, dupStr;

	datafield = datafields.split("|");

	var pkStrArr = [];
	for (var i = 0; i < provider.getRowCount(); i++) {

		//createAndDeleted 상태 row는 제외
		if (provider.getRowState(i) == "createAndDeleted") continue;

		//pk 필드 생성
		pkStr = "";
		for (var j = 0; j < datafield.length; j++) {
			pkStr += provider.getJsonRow(i)[datafield[j]] + "|";
		}

		pkStrArr[pkStrArr.length] = pkStr;
	}
	for (var i = 0; i < pkStrArr.length - 1; i++) {
		for (var k = i + 1; k < pkStrArr.length; k++) {
			if ( pkStrArr[i] == pkStrArr[k] ) {
				grid.setCurrent({dataRow : k, column : ( focusField != undefined ? focusField : 1 )});
				alert(gfn_getDomainMsg("msg.dupData", (k + 1)));

				return true;
			}
		}
	}

	return false;
}

function gfn_nullCheck(grid, datafields) {
	var provider = grid.getDataProvider();
	var data, datafield, pkStr, dupStr;

	datafield = datafields.split("|");

	for (var i = 0; i < provider.getRowCount(); i++) {
		for(var j=0; j<datafield.length; j++) {
			if(provider.getJsonRow(i)[datafield[j]]=="" || provider.getJsonRow(i)[datafield[j]]==undefined) {
				grid.setCurrent({itemIndex : provider.getJsonRow(i)["_ROWNUM"]-1, column : datafield[j]});
				alert(gfn_getDomainMsg("msg.{1}isnull.Pleasecheck{1}toset{0}.", grid.getColumnProperty(datafield[j], "header").text+"|"+grid.getColumnProperty(datafield[j], "header").text));
				return true;
			}
		}
	}

	return false;
}

function gfn_nullRowCheck(grid, rowindex, datafields, alertYn) {
	var provider = grid.getDataProvider();
	var data, datafield, pkStr, dupStr;

	datafield = datafields.split("|");

	for(var j=0; j<datafield.length; j++) {
		if(grid.getValue(rowindex,datafield[j])=="" || grid.getValue(rowindex,datafield[j])==undefined) {
			grid.setCurrent({itemIndex : rowindex, column : datafield[j]});
			if(alertYn) {
				alert(gfn_getDomainMsg("msg.{1}isnull.Pleasecheck{1}toset{0}.", grid.getColumnProperty(datafield[j], "header").text+"|"+grid.getColumnProperty(datafield[j], "header").text));
			}
			return true;
		}
	}

	return false;
}

//일자에 delimiter을 넣는다. default = '-'
function gfn_DelimiterDate(yyyymmdd, delimiter) {
	delimiter = delimiter || '-';
	return yyyymmdd.substr(0,4) + delimiter + yyyymmdd.substr(4,2) + delimiter + yyyymmdd.substr(6,2);
}

//ds에 특정 필드의 조건에 맞는 특정 필드 값을 구한다.
function gfn_getFindValueInDs(ds, condiField, condiValue, findField) {
    ds = ds || [];

    var forI;
    for ( i = 0; i < ds.length; i++ ) {
    	if ( ds[i][condiField] == condiValue ) {
   			return ds[i][findField];
    	}
    }

    return "";
}

//ds에 특정 필드의 조건에 맞는 특정 필드 값을 구한다.
function gfn_getFindPositionInDs(ds, condiField, condiValue) {
    ds = ds || [];

    var forI;
    for ( i = 0; i < ds.length; i++ ) {
    	if ( ds[i][condiField] == condiValue ) {
   			return i;
    	}
    }

    return -1;
}

//DS에서 조건에 맞는 DS를 구한다.
//gfn_getFindDataDsInDs(ds, {ATTB_1_CD : {VALUE : "TIME", CONDI : "="}});
function gfn_getFindDataDsInDs(ds, param) {
    var rtnArray = new Array();

    ds = ds || [];
    param = param || {};

    var forI;
    for ( forI = 0; forI < ds.length; forI++ ) {
    	var isCondi = false;
    	for (var field in param) {
    		if ( param[field].CONDI == "=" ) {
	    		if ( ds[forI][field] == param[field].VALUE ) {
	    			isCondi = true;
	    		} else {
	    			isCondi = false;
	    			break;
	    		}
    		} else if ( param[field].CONDI == "!=" ) {
	    		if ( ds[forI][field] != param[field].VALUE ) {
	    			isCondi = true;
	    		} else {
	    			isCondi = false;
	    			break;
	    		}
    		}
    	}
    	if ( isCondi ) {
   			rtnArray.push(ds[forI]);
    	}
    }

    return rtnArray;
}

//그룹컬럼 하위에 포함된 노드 갯수를 가져온다.
function gfn_getSubBucketCnt(groupNm) {
	var rtnMap = {id : groupNm, cnt : 0};
	$.each(BUCKET.all, function(n,v) {
		$.each(v, function(nn,vv) {
			if (vv.TYPE == "group" && vv.ROOT_CD == groupNm) {
				_gfn_getSubBucketCnt(vv.CD, rtnMap);
			} else if (vv.ROOT_CD == groupNm) {
				rtnMap.cnt++;
			}
		});
	});

	return rtnMap.cnt;
}

function _gfn_getSubBucketCnt(groupNm, rtnMap) {
	$.each(BUCKET.all, function(n,v) {
		$.each(v, function(nn,vv) {
			if (vv.TYPE == "group" && vv.ROOT_CD == groupNm) {
				_gfn_getSubBucketCnt(vv.CD, rtnMap);
			} else if (vv.ROOT_CD == groupNm) {
				rtnMap.cnt++;
			}
		});
	});
	return rtnMap.cnt;
}

function gfn_isValidDate(dateString) {
	var regEx = /^\d{4}-\d{2}-\d{2}$/;
	if(!dateString.match(regEx))
		return false;
	var d;
	if(!((d = new Date(dateString))|0))
		return false;
	return d.toISOString().slice(0,10) == dateString;
}

function gfn_validateDate(input) {

	var dateString = $(input).val();

	if(dateString.length == 8) {
		dateString = dateString.substring(0,4)+"-"+dateString.substring(4,6)+"-"+dateString.substring(6,8);
	}

	if(gfn_isValidDate(dateString)) {
		$(input).val(dateString);
	} else {
		$(input).val("");
	}
}

function gfn_monthDiff(d1, d2) {
    var months;
    months = (d2.getFullYear() - d1.getFullYear()) * 12;
    months += d2.getMonth() - d1.getMonth();
    return months;
}

function gfn_existInStringArray(arr, findValue) {
	var isExist = false;
	for ( var i = 0; i < arr.length; i++ ) {
		if ( arr[i] == findValue ) {
			isExist = true;
			break;
		}
	}
	return isExist;
}

function gfn_getPopupXY(pWidth,pHeight) {
	var rtnPos = {left: 0, top: 0};

	var winWidth  = document.body.clientWidth;  // 현재창의 너비
	var winHeight = document.body.clientHeight; // 현재창의 높이
	var winX      = window.screenX || window.screenLeft || 0;// 현재창의 x좌표
	var winY      = window.screenY || window.screenTop || 0; // 현재창의 y좌표

	rtnPos.left   = winX + (winWidth - pWidth) / 2;
	rtnPos.top    = winY + (winHeight - pHeight) / 2;

	return rtnPos;
}

function gfn_setCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function gfn_mergeProperties(sourceObj, addObj) {
	if ( addObj == undefined || addObj == null ) {
		return sourceObj;
	} else {
	    for (var prop in addObj) {
	    	sourceObj[prop] = addObj[prop];
	    }

	    return sourceObj;
	}
}

//DS에서 필드의 내용을 복사해준다.
function gfn_getCopyDataDsInDs(ds, fromField, toField) {
	var rtnArray = new Array();

	ds = ds || [];

	var forI;
	for ( forI = 0; forI < ds.length; forI++ ) {
		rtnArray.push(ds[forI]);
		rtnArray[forI][toField] = rtnArray[forI][fromField];
	}

	return rtnArray;
}

function gfn_setAjaxCsrf(xhr) {
	var token  = gfn_nvl($("meta[name='_csrf']").attr("content"),"x");
	var header = gfn_nvl($("meta[name='_csrf_header']").attr("content"),"x");
	xhr.setRequestHeader(header, token);
}

function gfn_blockUI() {
	$.blockUI({message : "<img src='" + GV_CONTEXT_PATH + "/statics/img/common/search.png' />",
		css : { backgroundColor: 'rgba(0,0,0,0.0)', color: '#000000', border: '0px solid #000', cursor:'wait' },
		overlayCSS : { backgroundColor: 'rgba(0,0,0,0.0)', color: '#000000', opacity:0.0, cursor:'wait' }
	});
}

function gfn_unblockUI() {
	$.unblockUI();
}
