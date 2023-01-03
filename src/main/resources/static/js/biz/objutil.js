var gv_datetimeFormat = "yyyy-MM-dd";
var gv_zTreeObj = {}; //treeMap
var gv_zTreeFilter = {}

//chart color
var gv_cFormat = "y:,.0f";
var gv_cColor1 = "#CB99FF";
var gv_cColor2 = "#90C7FE";
var gv_cColor3 = "#B4D9FE";
var gv_cColor4 = "#D6EAFE";
var gv_cColor5 = "#9EAD59";
var gv_cColor6 = "#D1B2FF";
var gv_cColors = [gv_cColor1, gv_cColor2, '#f7848d', '#82d8b5', '#f0a482', '#f1e584', '#9ead59', '#5d9980', '#b986c2', '#d1afdd'];

var FORM_SEARCH = {sql: false};
var FORM_SAVE   = {sql: false};
var EXCEL_SEARCH_DATA;
/*var EXCEL_HYC_PRODUCT_DATA;
var EXCEL_HYC_CUSTOMER_DATA;
var EXCEL_HYC_SALES_ORG_DATA;*/

var DIMENSION = {
	all  : [],
	user : [],
	hidden : [],
};

var MEASURE = {
	all  : [],
	user : [],
    pre : [],
    fix : [],
    next : []
};

var HRCY = {
	mapHrcy  : [{strFlag: "P"  ,id: "product"    ,treeId: "treeProduct"    ,treeTabId: "treeTab1" ,gds: "PRODUCT"    },
	    	    {strFlag: "C"  ,id: "customer"   ,treeId: "treeCustomer"   ,treeTabId: "treeTab2" ,gds: "CUSTOMER"   },
	    	    {strFlag: "SO" ,id: "salesOrg"   ,treeId: "treeSalesOrg"   ,treeTabId: "treeTab3" ,gds: "SALES_ORG"  }],
	all      : [],
	product  : [],
	customer : [],
	salesOrg : [],
	init : function() {
		this.all      = [];
		this.product  = [];
		this.customer = [];
		this.salesOrg = [];
	}
};

var BUCKET = {
	init : function() {
		this.query = [],
		this.last = [];
		this.all = [];
		this.sql = [];
		this.hidden = [];
	},
	query   : [],
	last    : [],
	all     : [],
	sql     : [],
	hidden  : [],
	push : function (list) {
		this.all.push(list);
		this.last = list; //마지막 row
	}
};


/**
 *  1. 공통 viewhorizon 사용시 DATEPICKET(); 만호출 - form, to , min, max 자동설정
 *  2. 개별적인 calendar 사용시 DATEPICKET(".datepicker1"); or DATEPICKET("#datepicker1"); - form, to , min, max 개별설정해야함
 */
//max, min 처리
function gfn_setSubdatepicker(params, selected) {
	if (!gfn_isNull(params.validId) && !gfn_isNull(params.validType)) {
		var mGubun = params.validType == "from" ? "minDate" : "maxDate";
		var dt = new Date(selected);
		dt.setDate(dt.getDate() + (mGubun=="minDate" ? 0 : 0));
		$("#"+params.validId).datepicker("option", mGubun, dt);
	}
}

function gfn_setVhSEDate(params,tmpSelDate) {
	if (params.calId == "fromCal") {
		$.each($("#fromCal").siblings(), function(n,v) {
			if (v.id == "swFromDate") {
				$(v).val(tmpSelDate.SW_START_DATE);
			} else if (v.id == "pwFromDate") {
				$(v).val(tmpSelDate.PW_START_DATE);
			} else if (v.id == "swToDate") {
				$(v).val(tmpSelDate.SW_END_DATE);
			}
		});
	} else if (params.calId == "toCal") {
		$.each($("#toCal").siblings(), function(n,v) {
			if (v.id == "swToDate") {
				$(v).val(tmpSelDate.SW_END_DATE);
			} else if (v.id == "pwToDate") {
				$(v).val(tmpSelDate.PW_END_DATE);
			} 
		});
	}
}

function gfn_onSelectFn(params,selected) {
	var tmpSelDate = gfn_getDate(selected);
	
	//week 처리
	if (!gfn_isNull(params.weekId)) $("#"+params.weekId).val(tmpSelDate.YEARWEEK);
	if (!gfn_isNull(params.weekPId)) $("#"+params.weekPId).val(tmpSelDate.YEARPWEEK);
	if (!gfn_isNull(params.dayNm)) $("#"+params.dayNm).val(tmpSelDate.DAY_NM);
	
	gfn_setVhSEDate(params,tmpSelDate);
	
	//max, min 처리
	setTimeout(function() {
		gfn_setSubdatepicker(params, selected);
	},100);
}

var DATEPICKET = function (pOption,fromDate,toDate) {
	$.datepicker.setDefaults(datepicker_resional_kr);
	var option;
	if (pOption == undefined || pOption == null || $.isPlainObject(pOption)) {
		pOption = pOption || {};
		option = {
			format : "yyyy-mm-dd",
			defFlag : true,
			arrTarget : [
			    {calId : "fromCal" ,dayNm : "fromDayNm" ,weekId : "fromWeek" ,weekPId : "fromPWeek" ,validType : "from" ,validId : "toCal"   ,defVal : fromDate || 0},
				{calId : "toCal"   ,dayNm : "toDayNm"   ,weekId : "toWeek"   ,weekPId : "toPWeek"   ,validType : "to"   ,validId : "fromCal" ,defVal : toDate   || 0}
			]
		};
		$.extend(option,pOption);

		var currentDateObj = gfn_getCurrentDate();
		var dateFormat = option.format;
		var setDatepicker = function(params) {
			var tmpDate;
			//일자,주차설정
			if (params.defVal.toString().length == 8) {
				tmpDate = gfn_getDate(params.defVal);
			} else {
				tmpDate = params.defVal == 0 ? currentDateObj : gfn_getAddDate(currentDateObj.YYYYMMDD, params.defVal * 7);
			}
			
			$("#"+params.calId).removeClass("hasDatepicker"); //초기화
			$("#"+params.calId).val(tmpDate.DISP_YYYYMMDD);
			if (!gfn_isNull(params.weekId)) $("#"+params.weekId).val(tmpDate.YEARWEEK);
			if (!gfn_isNull(params.weekPId)) $("#"+params.weekPId).val(tmpDate.YEARPWEEK);
			if (!gfn_isNull(params.dayNm)) $("#"+params.dayNm).val(tmpDate.DAY_NM);
			
			gfn_setVhSEDate(params,tmpDate);
			
			var chkSelect = false;
			$("#"+params.calId).unbind();
			$("#"+params.calId).datepicker({
				onSelect: function(selected) {
					chkSelect = true;
					
					gfn_onSelectFn(params,selected);
					
					$("#"+params.calId).trigger("change");
				},
				onClose: function(selected) {},

			})
			.on( "change", function(event) {
				if (chkSelect) {
					chkSelect = false;
					return false;
				}
				
				if (!gfn_isNull(params.validId) && !gfn_isNull(params.validType)) {
					
					if ( (params.validType == "from" && $(this).val() > $("#"+params.validId).val())
					  || (params.validType == "to"   && $(this).val() < $("#"+params.validId).val()) ) {
						$(this).val($("#"+params.validId).val());
					}
					
					gfn_onSelectFn(params,$("#"+params.calId).val());
				}
	        })
	        .inputmask(dateFormat, {clearIncomplete : true});
		};

		//이벤트 및 값 설정
		$.each(option.arrTarget, function(n,v) {
			setDatepicker(v);
		});

		//max, min 처리
		$.each(option.arrTarget, function(n,v) {
			gfn_setSubdatepicker(v, $("#"+v.calId).val());
		});

	} else {
		$(pOption).datepicker().inputmask(dateFormat, {clearIncomplete : true});
	}
	
	return option;
};

var MONTHPICKER = function (pOption,fromMon,toMon) {
	$.monthpicker.setDefaults(monthpicker_resional_kr);
	
	if (pOption == null || $.isPlainObject(pOption)) {
		pOption = pOption || {};
		option = {
			format : "yyyy-mm",
			defFlag : true,
			arrTarget : [
			    {calId : "fromMon" ,validType : "from" ,validId : "toMon"   ,defVal : fromMon || 0},
				{calId : "toMon"   ,validType : "to"   ,validId : "fromMon" ,defVal : toMon   || 0}
			]
		};
		$.extend(option,pOption);

		var currentDateObj = gfn_getCurrentDate();
		//max, min 처리
		var setSubmonthpicker = function(params, selected) {
			if (!gfn_isNull(params.validId) && !gfn_isNull(params.validType)) {
				var mGubun = params.validType == "from" ? "minDate" : "maxDate";
				var dt = new Date(selected);
				dt.setDate(dt.getDate() + (mGubun=="minDate" ? 0 : 0));
				$("#"+params.validId).monthpicker("option", mGubun, dt);
			}
		};
		
		var setMonthpicker = function(params) {
			var tmpDate;
			//일자,주차설정
			if (params.defVal.toString().length == 6) {
				tmpDate = gfn_getDate(params.defVal+"01");
			} else {
				tmpDate = params.defVal == 0 ? currentDateObj : gfn_getAddDate(currentDateObj.YYYYMMDD, params.defVal, "M");
			}
			
			$("#"+params.calId).removeClass("hasMonthpicker"); //초기화
			$("#"+params.calId).val(tmpDate.DISP_YYYYMMDD);
			var chkSelect = false;
			$("#"+params.calId).unbind();
			$("#"+params.calId).monthpicker({
				onSelect: function(selected) {
					chkSelect = true;
					var tmpSelDate = gfn_getDate(selected+"01");
					$("#"+params.calId).trigger("change");

					//max, min 처리
					setTimeout(function() {
						setSubmonthpicker(params, selected+"-01");
					},100);
				},
				onClose: function(selected) {},

			})
			.on( "change", function(event) {
				if (chkSelect) {
					chkSelect = false;
					return false;
				}
				
				if (!gfn_isNull(params.validId) && !gfn_isNull(params.validType)) {
					
					if ( (params.validType == "from" && $(this).val() > $("#"+params.validId).val())
					  || (params.validType == "to"   && $(this).val() < $("#"+params.validId).val()) ) {
						$(this).val($("#"+params.validId).val());
					}
					
					setSubmonthpicker(params, $(this).val()+"-01");
				}
	        })
			.inputmask("9999-m", {placeholder: ' ', clearIncomplete : true});
		};

		//이벤트 및 값 설정
		$.each(option.arrTarget, function(n,v) {
			setMonthpicker(v);
		});

		//max, min 처리
		$.each(option.arrTarget, function(n,v) {
			setSubmonthpicker(v, $("#"+v.calId).val());
		});

	} else {
		$(pOption).monthpicker().inputmask("9999-m", {placeholder: ' ', clearIncomplete : true});
		$(pOption).val(new Date().format("isoMonth"));
		$(pOption).trigger("change");
	}
	
	
};

//체크된 하이라키 데이터를 가져온다.
function gfn_getHrcyChecked(objTree, strTree, tmpTreeArr, tmpHrcy) {
	
	if (!objTree) return;
	var nodes = objTree.getCheckedNodes(true);
	var node;
	
	for (var i = 0; i < nodes.length; i++) {
		node = nodes[i];
		
		//하위노드가 없다.
    	if (node.check_Child_State == -1) {
    		gfn_addHrcyPath(node, strTree, tmpTreeArr, tmpHrcy);

    	//하위노드 일부만 체크됐다.
    	} else if (node.check_Child_State == 1) {
    		continue;

    	//하위노드 전체가 체크됐다.
    	} else if (node.check_Child_State == 2) {
    		gfn_addHrcyPath(node, strTree, tmpTreeArr, tmpHrcy);
    		i = i + gfn_subGetHrcyChecked(node, 0); //하위 노드 갯수만큼 건너뛴다.
    	}
	}
}

//자식 노드 처리
function gfn_subGetHrcyChecked(objNode, childCnt) {
	if (!objNode.children) return childCnt;
	for (var k=0; k<objNode.children.length; k++) {
		childCnt = gfn_subGetHrcyChecked(objNode.children[k], childCnt);
		childCnt++;
	}
	return childCnt;
}

//하이라키에 데이터 설정
function gfn_addHrcyPath(objNode, strTree, tmpTreeArr, tmpHrcy) {
	
	var nodePath = objNode.getPath();
	var lvlTree = {level : objNode.level, id : objNode.id, name : objNode.name};
	
	$.each(nodePath, function() {
		lvlTree["level" + this.level] = this.level;
		lvlTree["id" + this.level]  = (this.id).replace(this.pId + "_", "");
	});

	if (tmpTreeArr == undefined || tmpTreeArr == null) {
		if (tmpHrcy == undefined || tmpHrcy == null) {
			HRCY[strTree].push(lvlTree);
		} else {
			tmpHrcy.push(lvlTree);
		}
	} else {
		tmpTreeArr.push(lvlTree.name);
	}
	
	/*if(strTree == "product"){
		EXCEL_HYC_PRODUCT_DATA = tmpTreeArr; 
	}else if(strTree == "customer"){
		EXCEL_HYC_CUSTOMER_DATA = tmpTreeArr;
	}else if(strTree == "salesOrg"){
		EXCEL_HYC_SALES_ORG_DATA = tmpTreeArr;
	}*/
}

//start alert prototype ------------------------------
(function() {
  nalert = window.alert;
  Type = {
      native: 'native',
      custom: 'custom'
  };
})();

(function(proxy) {

	proxy.alert = function () {
		var message = (!arguments[0]) ? 'null': arguments[0];
		var callback = (!arguments[1]) ? '': arguments[1];
		var type = (!arguments[2]) ? '': arguments[2];

		if(type && type == 'native') {
			nalert(message);
		} else {
			$("<div id='popupDialog'></div>").html(message).dialog({
		        title: "Alert",
		        resizable: false,
		        modal: true,
		        buttons: { "OK": function() {
		        	$( this ).dialog( "close" );
		        	if(callback && callback instanceof Function) {
		        		callback();
		        	}
		        } }
		    });

			$("#popupDialog").css('zIndex',9999);
			$(".selector").dialog( "moveToTop" );
		}
	};
})(this);

(function() {
  nconfirm = window.confirm;
  Type = {
      native: 'native',
      custom: 'custom'
  };
})();

(function(proxy) {

	proxy.confirm = function () {
		var message = (!arguments[0]) ? 'null': arguments[0];
		var callback = (!arguments[1]) ? '': arguments[1];
		var nCallback = (!arguments[2]) ? '': arguments[2];
		var type = (!arguments[3]) ? '': arguments[3];

		if(type && type == 'native') {
			return nconfirm(message);
		} else {
			$("<div></div>").html(message).dialog({
		        title: "Confirm",
		        resizable: false,
		        modal: true,
		        buttons: { "Yes": function() {
		        	if($.isFunction(callback)) {
		        		callback.call();
		        	}
		        	$(this).dialog('close');
		        }, "No": function() {
		        	if($.isFunction(nCallback)) {
		        		nCallback.call();
		        	}
		        	$(this).dialog( "close" );
		        } },
		    });
		}
	};
})(this);
//end alert prototype ------------------------------

//start Date prototype ------------------------------
/*
 * Date Format 1.2.3
 * (c) 2007-2009 Steven Levithan <stevenlevithan.com>
 * MIT license
 *
 * Includes enhancements by Scott Trenda <scott.trenda.net>
 * and Kris Kowal <cixar.com/~kris.kowal/>
 *
 * Accepts a date, a mask, or a date and a mask.
 * Returns a formatted version of the given date.
 * The date defaults to the current date/time.
 * The mask defaults to dateFormat.masks.default.
 */
var dateFormat = function () {
	var	token = /d{1,4}|m{1,4}|yy(?:yy)?|([HhMsTt])\1?|[LloSZ]|"[^"]*"|'[^']*'/g,
		timezone = /\b(?:[PMCEA][SDP]T|(?:Pacific|Mountain|Central|Eastern|Atlantic) (?:Standard|Daylight|Prevailing) Time|(?:GMT|UTC)(?:[-+]\d{4})?)\b/g,
		timezoneClip = /[^-+\dA-Z]/g,
		pad = function (val, len) {
			val = String(val);
			len = len || 2;
			while (val.length < len) val = "0" + val;
			return val;
		};

	// Regexes and supporting functions are cached through closure
	return function (date, mask, utc) {
		var dF = dateFormat;

		// You can't provide utc if you skip other args (use the "UTC:" mask prefix)
		if (arguments.length == 1 && Object.prototype.toString.call(date) == "[object String]" && !/\d/.test(date)) {
			mask = date;
			date = undefined;
		}

		// Passing date through Date applies Date.parse, if necessary
		date = date ? new Date(date) : new Date;
		if (isNaN(date)) throw SyntaxError("invalid date");

		mask = String(dF.masks[mask] || mask || dF.masks["default"]);

		// Allow setting the utc argument via the mask
		if (mask.slice(0, 4) == "UTC:") {
			mask = mask.slice(4);
			utc = true;
		}

		var	_ = utc ? "getUTC" : "get",
			d = date[_ + "Date"](),
			D = date[_ + "Day"](),
			m = date[_ + "Month"](),
			y = date[_ + "FullYear"](),
			H = date[_ + "Hours"](),
			M = date[_ + "Minutes"](),
			s = date[_ + "Seconds"](),
			L = date[_ + "Milliseconds"](),
			o = utc ? 0 : date.getTimezoneOffset(),
			flags = {
				d:    d,
				dd:   pad(d),
				ddd:  dF.i18n.dayNames[D],
				dddd: dF.i18n.dayNames[D + 7],
				m:    m + 1,
				mm:   pad(m + 1),
				mmm:  dF.i18n.monthNames[m],
				mmmm: dF.i18n.monthNames[m + 12],
				yy:   String(y).slice(2),
				yyyy: y,
				h:    H % 12 || 12,
				hh:   pad(H % 12 || 12),
				H:    H,
				HH:   pad(H),
				M:    M,
				MM:   pad(M),
				s:    s,
				ss:   pad(s),
				l:    pad(L, 3),
				L:    pad(L > 99 ? Math.round(L / 10) : L),
				t:    H < 12 ? "a"  : "p",
				tt:   H < 12 ? "am" : "pm",
				T:    H < 12 ? "A"  : "P",
				TT:   H < 12 ? "AM" : "PM",
				Z:    utc ? "UTC" : (String(date).match(timezone) || [""]).pop().replace(timezoneClip, ""),
				o:    (o > 0 ? "-" : "+") + pad(Math.floor(Math.abs(o) / 60) * 100 + Math.abs(o) % 60, 4),
				S:    ["th", "st", "nd", "rd"][d % 10 > 3 ? 0 : (d % 100 - d % 10 != 10) * d % 10]
			};

		return mask.replace(token, function ($0) {
			return $0 in flags ? flags[$0] : $0.slice(1, $0.length - 1);
		});
	};
}();

// Some common format strings
dateFormat.masks = {
	//"default":      "ddd mmm dd yyyy HH:MM:ss",
	"default":      "yyyy-mm-dd HH:MM:ss",
	shortDate:      "m/d/yy",
	mediumDate:     "mmm d, yyyy",
	longDate:       "mmmm d, yyyy",
	fullDate:       "dddd, mmmm d, yyyy",
	shortTime:      "h:MM TT",
	mediumTime:     "h:MM:ss TT",
	longTime:       "h:MM:ss TT Z",
	isoDate:        "yyyy-mm-dd",
	isoMonth:       "yyyy-mm",
	isoTime:        "HH:MM:ss",
	isoDateTime:    "yyyy-mm-dd'T'HH:MM:ss",
	isoUtcDateTime: "UTC:yyyy-mm-dd'T'HH:MM:ss'Z'"
};

// Internationalization strings
dateFormat.i18n = {
	dayNames: [
		"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat",
		"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
	],
	monthNames: [
		"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
		"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
	]
};

// For convenience...
Date.prototype.format = function (mask, utc) {
	return dateFormat(this, mask, utc);
};

Date.prototype.getWeek = function() {
	var baseDt = new Date(this.format("isoDate"));
	baseDt.setDate(baseDt.getDate() + 3 - baseDt.getDay());
	var onejan = new Date(baseDt.getFullYear(),0,1);
	return Math.ceil((((baseDt - onejan) / 86400000) + onejan.getDay() + 1) / 7);
};

Date.prototype.getWeekDay = function(nWeek, isStartDay) {
	if (isStartDay === undefined) {
		isStartDay = true;
	}
	var baseDt = new Date(this.format("isoDate"));
	baseDt.setDate(baseDt.getDate() + (7 * (nWeek)));
	var y = baseDt.getDay();
	
	if (isStartDay) {
		// 일요일 이 아닐경우
		if (y > 0) {
			baseDt.setDate(baseDt.getDate() + (y * (-1)));
		}
	} else {
		// 토요일이 아닐경우.
		if (y != 0) {
			y = (6 - y);
			baseDt.setDate(baseDt.getDate() + y);
		}
	}
	
	return new Date(baseDt.getFullYear(), baseDt.getMonth(), baseDt.getDate());
};
//end Date prototype ------------------------------

//start chart --------------------
function gfn_setHighchartTheme(pTheme) {
	pTheme = pTheme || {};
	theme = {
		//colors: ['#c1e2f0', '#99c2de', '#f7848d', '#f0a482', '#f1e584', '#9ead59', '#82d8b5', '#5d9980', '#b986c2', '#d1afdd'],
		colors: gv_cColors,
		chart: {
	        backgroundColor: {
	            linearGradient: [0, 0, 500, 500],
	            stops: [
	                [0, 'rgb(255, 255, 255)'],
	                //[1, 'rgb(240, 240, 255)']
	            ]
	        },
	        style: {
	            fontFamily: 'Arial'
	        }
	    },
	    title: {
	    	text: null ,
	        style: {
	            color: '#000',
	            font: 'bold 16px "Arial", Verdana, sans-serif'
	        }
	    },
	    subtitle: {
	        style: {
	            color: '#666666',
	            font: 'bold 12px "Arial", Verdana, sans-serif'
	        }
	    },
	    yAxis: {
	    	min: 0,
	        labels : { enabled : false}, 
	        title: { text: null },
	        stackLabels: { enabled: false },
	    },
	    legend: {
	    	enabled: false
	    },
	    tooltip : {
	    	enabled : false
	    },
	    credits: {
	        enabled: false
	    },
	    exporting : {
	    	enabled: true,
	    	buttons: {
	            contextButton: {
	            	align: 'left',
	                menuItems: ['printChart','downloadJPEG', 'downloadPDF']
	            }
	        }
	    },
	    /*
	    navigation: {
	        buttonOptions: {
	            verticalAlign: 'top',
	            y: 5
	        }
	    },
	    */
	    plotOptions: {
	    	series: {
	    		maxPointWidth: 50
	    	},
	        line: {
	            dataLabels: { enabled: true },
	            enableMouseTracking: true
	        },
	        column: {
	            stacking: 'normal',
	            dataLabels: {
	                enabled: true,
	            },
	        },
	        bar: {
	        	stacking: 'normal',
	        	dataLabels: {
	        		enabled: true,
	        	}
	        }
	    },
	    lang: {
	        thousandsSep: ','
	    }
	};
	
	//사용자 테마 overwrite
	$.extend(theme,pTheme);

	//테마변수 set
	Highcharts.theme = theme;
	
	// Apply the theme
	Highcharts.setOptions(Highcharts.theme);
}

