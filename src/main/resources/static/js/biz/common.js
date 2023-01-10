(function($) {
	$.ajaxSetup({
		type: 'post', // POST 로 전송
		dataType: 'json',
		beforeSend: function(xhr) {
			gfn_blockUI();
			xhr.setRequestHeader("AJAX",true);
			gfn_setAjaxCsrf(xhr);
		}
	});
})(jQuery);

//공통 서비스 함수
function gfn_service(ajaxMap, appType) {
	var tmpSuccess 	= ajaxMap.success; //성공시 처리로직
	var tmpError	= ajaxMap.error; //실패시 처리로직

	//sql flag 설정
	ajaxMap.data.sql = (ajaxMap.data.sql == true || ajaxMap.data.sql == "Y") ? 'Y' : 'N';
	if (ajaxMap.data.sql == "Y") {
		ajaxMap.success = function(data) {
			gfn_unblockUI();
            errMsg = data.errMsg;
            gfn_getSqlLayer(errMsg);
        };
        ajaxMap.error = function() {
        	gfn_unblockUI();
        };
	} else {
		//공통 callback
		ajaxMap.success = function(data) {
			gfn_unblockUI();

            if (data.errCode < 0) {
            	//세션만료처리
            	if (data.errMsg == "msg.sessionFire") {
            		
            		var tmpPath = "/login";
            		if (gfn_getCurWindow()) {
            			gfn_getCurWindow().location.href = GV_CONTEXT_PATH + tmpPath + "/sessionFire";
            			self.close();
            		} else {
            			location.href = GV_CONTEXT_PATH + tmpPath + "/sessionFire";
            		}
            	
            	// Validate 결과일때는 success 호출.
            	} else if (data.errCode == -10 || data.errCode == -20 || data.errCode == -30) {
            		tmpSuccess(data);
            	} else {
            		gfn_unblockUI();
            		if (data.errMsg.indexOf("msg.") > -1) {
            			alert(gfn_getDomainMsg(data.errMsg,data.errParams));
            		}
            	}
            	
            } else {
            	tmpSuccess(data);
            }
        };
        
        ajaxMap.error = function() {
        	gfn_unblockUI();
        	//세션만료
	        if (err.status === 403) {
	        	console.log("세션이 만료되었습니다");
	          	top.location.replace(GV_CONTEXT_PATH + "/th/auth/login"); //여기서 최상위 프레임을 로그인 창으로 이동시킴
	        } else {
	        	tmpError;
			}
        };
	}

	if (appType == "obj") {
		//전역변수 설정
		ajaxMap.data.gvTotal = gv_total;
		ajaxMap.data.gvSubTotal = gv_subTotal;

		//하이라키처리
		if (ajaxMap.data.hrcyFlag) {
			gfn_setHrcy();
			if (HRCY.product   ) ajaxMap.data.productList    = HRCY.product;
			if (HRCY.customer  ) ajaxMap.data.customerList   = HRCY.customer;
			if (HRCY.salesOrg  ) ajaxMap.data.salesOrgList   = HRCY.salesOrg;
		}
		ajaxMap.data = JSON.stringify(ajaxMap.data);
		ajaxMap.headers = {
			"Accept" : "application/json",
			"Content-Type" : "application/json",
			"AJAX" : true
		}
	} else {
		ajaxMap.headers = {
			"AJAX" : true
		}
	}

    $.ajax(ajaxMap);
}

//메세지 다국어처리
function gfn_getDomainMsg(msgKey,msgParams) {
	var params = {msgKey:msgKey,msgParams:msgParams};
	var rtnMsg = msgKey;
	$.ajax({
	    type: 'post', // POST 로 전송
	    async: false,
	    url: GV_CONTEXT_PATH + "/common/getDomainMsg",
	    dataType: 'json',
	    data:params,
	    success:function(data) {
	    	gfn_unblockUI();
	    	rtnMsg = data.rtnMsg;
	    },
	    error:function() {
	    	gfn_unblockUI();
	    }
	});
	return rtnMsg;
}

//공통 폼로드
function gfn_formLoad() {
	//권한처리
	gfn_setRoleBtn();
	gfn_setLoadParams(); //파라미터 설정
	gfn_setSearchRow(""); //초기화
	gfn_formResize(); //폼 리사이즈
	gfn_getHrcy(); //하이라키 데이터 조회
}

function gfn_setRoleBtn() {
	//저장권한
	if($("#saveYn").val() != "Y") {
		$(".roleWrite").hide();
	}

	//등록된 팝업권한
	if(Number($("#subMenuCnt").val()) > 0) {
		$(".cbt_btn > div > .authClass").hide();

		//sub menu list 조회
		gfn_service({
			async: false,
			url: GV_CONTEXT_PATH + "/common/subMenuList",
			data:{menuCd: $("#menuCd").val()},
			success:function(data) {
				var subMenuList = data.rtnList;
				$.each(subMenuList, function(n,v) {
					var targetEle = $(".cbt_btn > div > ."+v.MENU_CD);
					$(targetEle).attr("alt",v.MENU_CD);
					$(targetEle).show();
				});
			}
		});
	}
}

//메뉴 파라미터 설정
function gfn_setLoadParams() {
	var paramString = $("#menuParam").val();
	if (!gfn_isNull(paramString)) {
		var arrParam = paramString.split("&");
		$.each(arrParam, function(n,v) {
			$("#commonForm").append('<input type="hidden" id="'+v.split("=")[0]+'" name="'+v.split("=")[0]+'" value="'+v.split("=")[1]+'" />');
		});
	}
}

//planid 조회
function gfn_getPlanId(pOption) {
	
	try {
		
		if ($("#planId").length == 0) {
			return;
		}
		
		if (pOption && pOption.planTypeCd == "DP_W") {
			var lblPlanId = $("#planId").parent().parent().children(".itit");
			lblPlanId.text(lblPlanId.text()+" (W)");
		} else if (pOption && pOption.planTypeCd == "DP_M") {
			var lblPlanId = $("#planId").parent().parent().children(".itit");
			lblPlanId.text(lblPlanId.text()+" (M)");
		}
		
		var params = $.extend({
			_mtd     : "getList",
			tranData : [{outDs:"rtnList",_siq:"common.planId"}]
		}, pOption);
		
		gfn_service({
			url     : GV_CONTEXT_PATH + "/biz/obj",
			data    : params,
			async   : false,
			success : function(data) {
				
				gfn_setMsCombo("planId",data.rtnList,[""]);
				
				$("#planId").on("change", function(e) {
					
					var fDs = gfn_getFindDataDsInDs(data.rtnList, {CODE_CD : {VALUE : $(this).val(), CONDI : "="}});
					if (params.picketType == "M") {
						if (fDs.length > 0) {
							MONTHPICKER(null,fDs[0].START_MONTH,fDs[0].END_MONTH);
							//max set
							var dt = gfn_getStringToDate(fDs[0].END_MONTH+"01");
							$("#toMon").monthpicker("option", "maxDate", dt);
							//
							$("#startMonth" ).val(fDs[0].START_MONTH);
							$("#endMonth"   ).val(fDs[0].END_MONTH);
							$("#startWeek" ).val(fDs[0].START_WEEK);
							$("#endWeek"   ).val(fDs[0].END_WEEK);
							$("#cutOffFlag" ).val(fDs[0].CUT_OFF_FLAG);
							$("#releaseFlag").val(fDs[0].RELEASE_FLAG);
						} else {
							MONTHPICKER();
						}
					} else {
						if (fDs.length > 0) {
							DATEPICKET(null,fDs[0].SW_START_DATE,fDs[0].SW_END_DATE);
							//max set
							var dt = gfn_getStringToDate(fDs[0].SW_END_DATE);
							$("#toCal").datepicker("option", "maxDate", dt);
						} else {
							DATEPICKET();
						}
					}
				});
				
				$("#planId").trigger("change");
			}
		},"obj");
		
	} catch(e) {console.log(e);}
}

//하이라키 정보 조회
function gfn_getHrcy() {
	//트리설정
	var setting = {
		data: {simpleData: {enable: true}},
		check: {enable: true},
		callback : {
			onCheck : gfn_setCheckView,
			onClick : null,
		},
		view: {
			expandSpeed: "" //slow,normal,fast
		}
	};

	$.each(HRCY.mapHrcy, function(n,v) {
		if ($("#"+v.id+"hrcyYn").val() == "Y") {
			//db 조회
			if (gfn_getGlobal("DS_HRCY_"+v.gds) == null) {
				var params = {};
				params[v.id+"hrcyYn"] = "Y";
				gfn_getTranHrcy(params, v.strFlag,setting);
			//메모리조회
			} else {
				setting.treeId = v.id;
				gfn_setTreeMaster(v.strFlag,setting);
			}
		}
	});
}

function gfn_getTranHrcy(params, gubun, setting) {
	gfn_service({
		url: GV_CONTEXT_PATH + "/common/hrcy",
		data:params,
		success:function(data) {
			$.each(HRCY.mapHrcy, function(n,v) {
				if (v.strFlag == gubun) {
					gfn_setGlobal("DS_HRCY_"+v.gds ,data[v.id+"hrcyList"]);
					gfn_setTreeMaster(v.strFlag,setting);
				}
			});
		},
		beforeSend: function(xhr) {
			xhr.setRequestHeader("AJAX",true);
			gfn_setAjaxCsrf(xhr);
		}
	});
}

function gfn_setTreeMaster(type,setting) {
	$.each(HRCY.mapHrcy, function(n,v) {
		if (v.strFlag == type) {

			var filterHrcy = gfn_getGlobal("DS_HRCY_"+v.gds);
			var filterKey = Object.keys(gv_zTreeFilter);
			$.each(filterKey, function(n1,v1) {
				if (type == v1) {
					var filterObj = gv_zTreeFilter[v1];
					$.each(filterObj, function(n2,v2) {
						
						filterHrcy = $.grep(filterHrcy, function (n3,v3) {
							if (n3.id === "-1" || n3.pId === "-1") return true;
							else {
								if ($.isArray(v2)) {
									var chkB = false;
									$.each(v2, function(n4,v4) {
										if (n3[n2] == v4) {
											chkB = true;
											return false;
										}
									});
									if (chkB) return true
								} else if (n3[n2] == v2) return true;
							} 
							
							return false;
						});
					});
				}
			});
			
			gv_zTreeObj[v.id] = $.fn.zTree.init($("#"+v.treeId), setting, filterHrcy);
		}
	});
}

// 트리 체크시 각화면 텍스트 처리
function gfn_setCheckView(event,treeId) {
	$.each(HRCY.mapHrcy, function(n,v) {
		if (v.treeId == treeId) {
			var tmpTreeArr = [];
			gfn_getHrcyChecked(gv_zTreeObj[v.id],v.id,tmpTreeArr);

			if (v.strFlag == "P") {
				// 하이라키 변경시 관련 키워드 팝업 초기화
				$.each($(".pHrcy_cd"), function (nn,vv) {
					if (!gfn_isNull(vv.value)) {
						$("#"+vv.id).val("");
						if (vv.id.substr(-3) == "_cd") {
							$("#"+vv.id.substr(0,vv.id.length-3)+"_nm").val("");
						} else {
							$("#"+vv.id.substr(0,vv.id.length-3)+"_NM").val("");
						}
					}
				});
			}

			$("#loc_"+v.id).text(gfn_nvl(tmpTreeArr.toString(),"All"));
		}
	});
}

//디멘전 메저 정보 조회
function gfn_getMenuInit(dimYn, meaYn) {
	
	var dimYnFlag = gfn_nvl(dimYn, "");
	var meaYnFlag = gfn_nvl(meaYn, "");
	
	var params = $("#commonForm").serializeObject();
	params._mtd = "getList";
	params.tranData = [{outDs : "dimList", _siq : "common.dimension"}
	                 , {outDs : "meaList", _siq : "common.measure"}];
	gfn_service({
	    async: false,
	    url: GV_CONTEXT_PATH + "/biz/obj",
	    data: params,
	    success:function(data) {
	    	
	    	if(dimYnFlag == "" && meaYnFlag == ""){
	    		DIMENSION.user = data.dimList;
		    	MEASURE.user   = data.meaList;
	    	}else if(dimYnFlag == "Y"){
	    		DIMENSION.user = data.dimList;
	    	}else if(meaYnFlag == "Y"){
	    		MEASURE.user   = data.meaList;
	    	}
	    }
	},"obj");
}

//버켓 정보 조회
function gfn_getBucket(ajaxMap,meaFlag,callback) {
	var bucketLen = ajaxMap.sqlId.length;
	gfn_service({
		async: false,
		url: GV_CONTEXT_PATH + "/common/bucketInit",
		data:ajaxMap,
		success:function(data) {
			
			var bucketLen = ajaxMap.sqlId.length;
			BUCKET.init(); //초기화
			var tmpId = "";
			var bucketList;
			for (var i=1; i<=bucketLen; i++) {
				bucketList = eval("data.bucket"+i+"List");
				tmpId = ajaxMap.sqlId[i-1].replace("bucketFull","").replace("bucket","").toLowerCase();
				if (!gfn_isNull(ajaxMap[tmpId]) && !gfn_isNull(ajaxMap[tmpId].preBucket)) {
					bucketList = $.merge(ajaxMap[tmpId].preBucket, bucketList);
				}
				if (!gfn_isNull(ajaxMap[tmpId]) && !gfn_isNull(ajaxMap[tmpId].nextBucket)) {
					bucketList = $.merge(bucketList, ajaxMap[tmpId].nextBucket);
				}
				BUCKET.push(bucketList);
				
				
			}
			
			if ($.isFunction(callback)) {
				callback.call();
			}
			
			gfn_bucketCallback(meaFlag,"N");
		}
	}, "obj");
}

//사용자가 직접 버켓쿼리 작성후 호출함수 - BUCKET.push(bucketList); 후 호출
function gfn_bucketCallback(meaFlag, initFlag) {
	if (initFlag != "N") BUCKET.init(); //초기화
	
	//query에 사용되는 버켓정보를 만든다.
	$.each(BUCKET.all, function(idx) {
		//최하단 버켓
		if (BUCKET.all.length-1 == idx) {
			$.each(this, function() {
				BUCKET.query.push(this);
			});
		} else {
			$.each(this, function() {
				if (this.TOT_TYPE == "MT") {
					BUCKET.query.push(this);
				}
			});
		}
	});

	//measure horizon
	if (meaFlag == true) {
		gfn_setCustBucket(MEASURE.user);
	}
}

//버켓에 사용자 버켓을 추가한다.
function gfn_setCustBucket(pBucketObj) {
	var custBucket = BUCKET.last;
	var userBucket = pBucketObj;
	var objLastBucket = [];
	gfn_clearArrayObject(BUCKET.query);
	var tmpObj;
	$.each(custBucket, function(n,v) {
		if (v.TYPE == "group") {
			$.each(userBucket, function(nn,vv) {
				tmpObj = {ROOT_CD: v.CD, CD: v.CD+"_"+vv.CD, NM: vv.NM, BUCKET_ID: v.CD+"_"+vv.CD, BUCKET_VAL: v.BUCKET_VAL, TYPE: vv.TYPE, numberFormat: vv.numberFormat};
				objLastBucket.push(tmpObj);
				BUCKET.query.push(tmpObj);
			});
		}
	});
	BUCKET.push(objLastBucket);
}

//공통코드 조회
function gfn_getComCode(grpCds,allYn,buAllYn) {
	
	var rtnMap = {};
	if (!grpCds) return rtnMap;
	
	var arrGrpCd = grpCds.split(",");
	var params = {grpCd : grpCds, buAllYn: buAllYn || "N"};
	params._mtd = "getList";
	params.tranData = [{outDs:"rtnList",_siq:"common.comCode"}];
	gfn_service({
	    async: false,
	    url: GV_CONTEXT_PATH + "/biz/obj",
	    data: params,
	    success:function(data) {
	    	$.each(arrGrpCd, function (i,o) {

	    		if(allYn=="Y") {
	    			var allObj = {};
		    		allObj.GROUP_CD = o.toString();
		    		allObj.CODE_CD = "";
		    		allObj.CODE_NM = "All";
		    		data.rtnList.unshift(allObj);
	    		}

	    		rtnMap[o.toString()] = $.grep(data.rtnList, function (n,k) {
								    			return n.GROUP_CD===o.toString();
								    		 });
	    	});
	    }
	}, "obj");
	
	return rtnMap;
}

function gfn_getComCodeEx(arVal, allYn, param) {
	
	var _sIq     = ''
	var _sIqNmSp = 'common.';
	var rtnMap   = {};
	
	FORM_SEARCH  = {};
	if (param !== undefined) FORM_SEARCH = param;
	FORM_SEARCH._mtd = "getList";
	FORM_SEARCH.tranData = new Array();
	
	for (var a in arVal) {
		switch (arVal[a]) {
		
			case "REP_CUST_GROUP" :
				_sIq = 'repCustGroup';
				break;
			case "CUST_GROUP" : 
				_sIq = 'custGroup';
				break;
			case "UPPER_ITEM_GROUP" : 
				_sIq = 'upperItemGroup';
				break;
			case "ITEM_GROUP" : 
				_sIq = 'itemGroup';
				break;
			case "ROUTING" : 
				_sIq = 'routing';
				break;
			case "SUB_ROUTING" : 
				_sIq = 'SubRouting';
				break;
					
			case "REP_ITEM_GROUP" : 
				_sIq = 'repItemGroup';
				break;
			case "SALES_ORG_LVL4_CD" : 
				_sIq = 'salesOrgLvl4Cd';
				break;
			case "SALES_ORG_LVL5_CD" : 
				_sIq = 'salesOrgLvl5Cd';
				break;
			case "BU_CD" :
				_sIq = 'buCd';
				break;
			case "DIV_CD" :
				_sIq = 'divCd';
				break;
			case "TEAM_CD" :
				_sIq = 'teamCd';
				break;
			case "FQC_ROUTE_TYPE" :
				_sIq = "fqcRscMappingRoute";
				break;		
			case "WORK_PLACES_CD":
				_sIq = 'workPlacesCd';
				break;
			case "RESOURCE_CD":
				_sIq = 'resourceCd';
				break;	
			case "RESOURCE_GROUP_CD":
				_sIq = 'resourceGroupCd';
				break;	
			case "PROD_ITEM_GROUP" :
				_sIq = "prodItemGroup";
				break;	
			case "WORK_PLACES_QC_CD":
				_sIq = 'workPlacesQcCd';
				break;	
			case "PROD_ITEM_GROUP_MST" :
				_sIq = "prodItemGroupMst";
				break;
			case "PROD_ITEM_GROUP_DETAIL" :
				_sIq = "prodItemGroupDetail";
				break;
			case "APS_ROUTING_ID" :
				_sIq = "apsRoutingId";
				break;
			case 'ORDER_ROUTING' :
			    _sIq = "orderRoutingId";
			    break;
			case "ROUTING_FACILITY" :
				_sIq = "routingFacility";
				break;
			case "APS_OVEN_ROUTING_ID" :
				_sIq = "apsOvenRoutingId";
				break;
			case "WORK_PLACES_CD_RESOURE" :
				_sIq = "workPlacesCdResoure";
				break;
			case "SL_CD" :
				_sIq = "slCd";
				break;
			
		}
		
		
		if (_sIq != '') {
			FORM_SEARCH.tranData.push({outDs : arVal[a], _siq : _sIqNmSp + _sIq});
		} 
	}
	
	gfn_service({
		async   : false,
		url     : GV_CONTEXT_PATH + "/biz/obj",
		data    : FORM_SEARCH,
		success : function (data) {
			if (allYn == "Y") {
				var allObj = {};
				allObj.CODE_CD = "";
				allObj.CODE_NM = "All";
				data.rtnList.unshift(allObj);
			}else if(allYn == "N") {
				var allObj = {};
				allObj.CODE_CD = "";
				allObj.CODE_NM = "";
				data.BU_CD.unshift(allObj);
				data.DIV_CD.unshift(allObj);
				data.TEAM_CD.unshift(allObj);
			}
			
			rtnMap = data;
		}
	}, "obj");
	
	return rtnMap;
}

//체크된 하이라키 데이터 정보를 설정한다.
function gfn_setHrcy() {
	HRCY.init(); //체크된 하이라키 데이터 초기화
	if (!gfn_isNull(gv_zTreeObj.product )) gfn_getHrcyChecked(gv_zTreeObj.product, "product" );
	if (!gfn_isNull(gv_zTreeObj.customer)) gfn_getHrcyChecked(gv_zTreeObj.customer, "customer");
	if (!gfn_isNull(gv_zTreeObj.salesOrg)) gfn_getHrcyChecked(gv_zTreeObj.salesOrg, "salesOrg");
}

//
function gfn_getGlobal(key) {
	if (!key) return;
	if (!parent.global) {
		parent.global = {
			DS_HRCY_PRODUCT   : null,
			DS_HRCY_CUSTOMER  : null,
			DS_HRCY_SALES_ORG : null,
			exInstance        : null,
			exGrdMain         : null,
			exDataProvider    : null,
			DS_MENU           : []
		};
	}
	return parent.global[key];
}

//
function gfn_setGlobal(key,val) {
	if (!key) return;
	if (!parent.global) {
		parent.global = {
			DS_HRCY_PRODUCT   : null,
			DS_HRCY_CUSTOMER  : null,
			DS_HRCY_SALES_ORG : null,
			exInstance        : null,
			exGrdMain         : null,
			exDataProvider    : null,
			DS_MENU           : []
		};
	}
	return parent.global[key] = val;
}

//메뉴탭 생성
function gfn_newTab(menuCd, title, args) {
	var callMenu = parent.subAddTab(title,menuCd,null,args);
	if (callMenu == false) alert(gfn_getDomainMsg("msg.unauthorized"));
}

//현재탭 닫기
function gfn_closeTab() {
	parent.closeTab();
}

//조회조건 처리
function gfn_setSearchRow(searhRowTxt,alertFalg) {
	if(searhRowTxt!=undefined) {
		if((String(searhRowTxt) == "0" || String(searhRowTxt) == "0 / 0") && alertFalg==undefined) {
			alert(gfn_getDomainMsg("msg.noDataFound"));
		}
	}

	gv_searchRow = searhRowTxt == 0 ? "0" : searhRowTxt || gv_searchRow;
	//숫자면 3자리마다 콤마처리
	if ($.isNumeric(gv_searchRow)) gv_searchRow = gfn_addCommas(gv_searchRow);
	parent.$("#bottom_searchRow").text(gv_searchRow);
	parent.$("#bottom_userSum").text(gv_sumRow);
	parent.$("#bottom_userAvg").text(gv_avg)
}

//엑셀 불러오기
function gfn_importGrid(imParam) {

	try {
		var imParam = imParam || {};
		var gridIdx = imParam.gridIdx || 0;

		//기본설정
		var imOpt = {
				grid        : GV_ARR_GRID[gridIdx].objGrid, //첫번째 그리드
				formId      : "excelForm",
				inputId     : "excelFile",
				columnNames : "columnNames",
				fieldFlag   : "N",
				callback    : null,
				clearFlag   : "Y",
				noYn        : "N",
		};

		//파라미터가 있을경우 처리
		if (imParam != undefined) {
			$.extend(imOpt,imParam);
		}

		var objGrid     = imOpt.grid;
		var formId      = imOpt.formId;
		var inputId     = imOpt.inputId;
		var columnNames = imOpt.columnNames;
		var fieldFlag   = imOpt.fieldFlag;
		var callback    = imOpt.callback;
		var clearFlag   = imOpt.clearFlag;
		var noYn        = imOpt.noYn;
		var input = $('#'+inputId)[0];

		if (!input.value) {
			gfn_unblockUI();
			//alert("Um, couldn't find the Excel InputFile element.");
		} else {
			var provider = objGrid.getDataProvider();

			if($("#"+columnNames).length>0) {
				if(noYn=="N") {
					$("#"+columnNames).val(objGrid.getColumnNames(true, true).toString());
				} else {
					$("#"+columnNames).val("NO,"+objGrid.getColumnNames(true, true).toString());
				}
			}

			$("#"+formId).ajaxSubmit({
				type : "post",
				dataType : "json",
				data : $("#"+formId).serialize(),
				url : GV_CONTEXT_PATH + "/excel/load",
				beforeSubmit : gfn_blockUI,
				success : function(data) {
					gfn_unblockUI();
					if (clearFlag == "Y") {
						provider.clearRows();
					}

					if (provider.getRowCount() == 0 && fieldFlag == "Y") {
						var fieldNames = Object.keys(data.results[0]);
						provider.setFields(fieldNames);
						objGrid.setColumns(provider.getFields());
					}

					provider.addRows(data.results, 0, -1);

					//초기화
					input.value = "";
					if ($.isFunction(callback)) {
						callback.call();
					}
					
					alert(gfn_getDomainMsg("msg.excelUp"));
				},
				error : function(error) {
					gfn_unblockUI();
					alert(error);
				}
			});
		}
		return false;
	} catch(e) {
		console.log(e);
		gfn_unblockUI();
	} finally {
		//gfn_unblockUI();
	}
}

function gfn_getSqlLayer(msg) {
	var inHtml = '';
	inHtml += '<div class="popup2" style="width:600px;">';
	inHtml += '	<div class="pop_tit">SQL View</div>';
	inHtml += '	<div class="popCont">';
	inHtml += '		<textarea readonly="readonly" wrap="off" style="font-family:Courier New;font-size:13px;width:100%;height:500px;border:1px solid #e6e6e6;overflow:auto;">'+msg+'</textarea>';
	inHtml += '		<div class="pop_btn">';
	inHtml += '			<a href="#" class="pbtn pClose">Cancel</a>';
	inHtml += '		</div>';
	inHtml += '	</div>';
	inHtml += '	<a href="#" class="popClose"><img src="'+ GV_CONTEXT_PATH +'/statics/images/common/pop_close.png" alt=""></a>';
	inHtml += '</div>';

	$("#divTempLayerPopup").html(""); //초기화
	$("#divTempLayerPopup").html(inHtml);
	$("#divTempLayerPopup").show();
	$(".back").show();

	var w = $("#divTempLayerPopup").height() / 2; // 레이어 팝업의 가로 길이의 절반
	var h = $("#divTempLayerPopup").width() / 2; // 레이어 팝업의 세로 길이의 절반
	$("#divTempLayerPopup").css("left", "calc(50% - "+w+"px)");
	$("#divTempLayerPopup").css("top", "calc(50% - "+h+"px)");
	
	return false;
}

//공통 버켓영역 numberformat 정의
function gfn_doNumberFormat() {
	var chk1 = $("#comBucketMask").val() == "#,##0"     ? "checked" : "";
	var chk2 = $("#comBucketMask").val() == "#,##0.0"   ? "checked" : "";
	var chk3 = $("#comBucketMask").val() == "#,##0.00"  ? "checked" : "";
	var chk4 = $("#comBucketMask").val() == "#,##0.000" ? "checked" : "";
	var inHtml = '';
	inHtml += '<div class="popup2" style="width:250px;">';
	inHtml += '	<div class="pop_tit">Decimal</div>';
	inHtml += '	<div class="popCont">';
	inHtml += '		<ul class="rdoList">';
	inHtml += '			<li><input type="radio" id="pp_chk1" name="rdoBucketMask" value="#,##0"     '+chk1+'> <label for="pp_chk1">none</label></li>';
	inHtml += '			<li><input type="radio" id="pp_chk2" name="rdoBucketMask" value="#,##0.0"   '+chk2+'> <label for="pp_chk2">.0</label></li>';
	inHtml += '			<li><input type="radio" id="pp_chk3" name="rdoBucketMask" value="#,##0.00"  '+chk3+'> <label for="pp_chk3">.00</label></li>';
	inHtml += '			<li><input type="radio" id="pp_chk4" name="rdoBucketMask" value="#,##0.000" '+chk4+'> <label for="pp_chk4">.000</label></li>';
	inHtml += '		</ul>';
	inHtml += '		<div class="pop_btn">';
	inHtml += '			<a href="#" onClick="javascript:gfn_doSubNumberFormat();" class="pbtn pApply">APPLY</a>';
	inHtml += '			<a href="#" class="pbtn pClose">Cancel</a>';
	inHtml += '		</div>';
	inHtml += '	</div>';
	inHtml += '	<a href="#" class="popClose"><img src="'+ GV_CONTEXT_PATH +'/statics/images/common/pop_close.png" alt=""></a>';
	inHtml += '</div>';

	$("#divTempLayerPopup").html(""); //초기화
	$("#divTempLayerPopup").html(inHtml);
	$("#divTempLayerPopup").show();
	$(".back").show();

	var w = $("#divTempLayerPopup").height() / 2; // 레이어 팝업의 가로 길이의 절반
	var h = $("#divTempLayerPopup").width() / 2; // 레이어 팝업의 세로 길이의 절반
	$("#divTempLayerPopup").css("left", "calc(50% - "+w+"px)");
	$("#divTempLayerPopup").css("top", "calc(50% - "+h+"px)");
}

function gfn_doSubNumberFormat() {
	$("#divTempLayerPopup").hide();
	$(".back").hide();
	var rdoBucketMaskVal = $("input:radio[name=rdoBucketMask]:checked").val();

	//저장
	$("#comBucketMask").val(rdoBucketMaskVal);
	var params = {};
	params._mtd     = "saveUpdate";
	params.tranData = [{outDs:"saveCnt",_siq:"common.userAttb", grdData : [$("#commonForm").serializeObject()] }];
	gfn_service({
	    async: false,
	    url: GV_CONTEXT_PATH + "/biz/obj",
	    data:params,
	    success:function(data) {}
	}, "obj");

	//저장 후처리
	if (typeof fn_doNumberFormat == 'function') {
		fn_doNumberFormat(rdoBucketMaskVal);
	} else {
		gfn_getSetNumberFormat(rdoBucketMaskVal);
	}
}

//실제 mask value 설정
function gfn_getSetNumberFormat(maskVal) {
	maskVal = maskVal || $("#comBucketMask").val();
	var cStyle;
	var objInstance = GV_ARR_GRID[0]; //첫번째 그리드
	var fileds = objInstance.objData.getOrgFieldNames();
	$.each(fileds, function (n,v) {
		cStyle = objInstance.objGrid.getColumnProperty(v,"styles");
		if (cStyle != undefined && cStyle.numberFormat != undefined) {
			cStyle.numberFormat = maskVal;
			objInstance.objGrid.setColumnProperty(v,"styles",cStyle);
		}
	});
}

var gvExcelParam;
function gfn_doExportExcel(exParam) {
	
	exParam = exParam || {};
	if (exParam.conFirmFlag == false) {
		exParam.conFirmFlag = false;
	} else {
		exParam.conFirmFlag = true;
	}
	gvExcelParam = exParam;

	if (exParam.conFirmFlag == true) {
		var inHtml = '';
		inHtml += '<div class="popup2" style="width:250px;">';
		inHtml += '	<div class="pop_tit">Excel Export</div>';
		inHtml += '	<div class="popCont">';
		inHtml += '		<ul class="rdofl">';
		inHtml += '			<li style="width:90px;padding:20px 0 20px 30px;"><input type="radio" id="rdoExportType1" name="rdoExportType" value="ROW" checked> <label for="rdoExportType1" style="font-size:13px;">Row</label></li>';
		inHtml += '			<li style="padding:20px 0 20px 0;"><input type="radio" id="rdoExportType2" name="rdoExportType" value="MERGE"><label for="rdoExportType2" style="font-size:13px;">Merge</label></li>';
		inHtml += '		</ul>';
		inHtml += '		<ul class="rdofl">';
		inHtml += '			<li style="width:90px;padding:0 0 20px 30px;"><input type="radio" id="rdoExportType3" name="rdoExportTypeS" value="N"> <label for="rdoExportType3" style="font-size:13px;">None Style</label></li>';
		inHtml += '			<li style="padding:0 0 20px 0;"><input type="radio" id="rdoExportType4" name="rdoExportTypeS" value="Y" checked><label for="rdoExportType4" style="font-size:13px;">Style</label></li>';
		inHtml += '		</ul>';
		inHtml += '		<div class="pop_btn">';
		inHtml += '			<a href="#" onClick="javascript:gfn_doSubExportExcel();" class="pbtn pApply">APPLY</a>';
		inHtml += '			<a href="#" class="pbtn pClose">Cancel</a>';
		inHtml += '		</div>';
		inHtml += '	</div>';
		inHtml += '	<a href="#" class="popClose"><img src="'+ GV_CONTEXT_PATH +'/statics/images/common/pop_close.png" alt=""></a>';
		inHtml += '</div>';

		$("#divTempLayerPopup").html(""); //초기화
		$("#divTempLayerPopup").html(inHtml);
		$("#divTempLayerPopup").show();
		$(".back").show();

		var w = $("#divTempLayerPopup").height() / 2; // 레이어 팝업의 가로 길이의 절반
		var h = $("#divTempLayerPopup").width() / 2; // 레이어 팝업의 세로 길이의 절반
		$("#divTempLayerPopup").css("left", "calc(50% - "+w+"px)");
		$("#divTempLayerPopup").css("top", "calc(50% - "+h+"px)");

		return false;
	} else {
		gfn_doSubExportExcel();
	}

}

function gfn_doSubExportExcel() {
	
	$("#divTempLayerPopup").hide();
	$(".back").hide();
	var rdoExportTypeVal = $("input:radio[name=rdoExportType]:checked").val();
	var rdoExportTypeSVal = $("input:radio[name=rdoExportTypeS]:checked").val();
	if (!gfn_isNull(rdoExportTypeVal)) {
		gvExcelParam.separateRows       = (rdoExportTypeVal  != "ROW" ? false : true);
		gvExcelParam.applyDynamicStyles = (rdoExportTypeSVal != "Y"   ? false : true);
	}

	if (typeof fn_exportGrid == 'function') {
		if (gvExcelParam.conFirmFlag == true) {
			fn_exportGrid(gvExcelParam);
		} else {
			confirm(gfn_getDomainMsg("msg.doyouWantToDownloadToExcel?") ,function() { fn_exportGrid(gvExcelParam); });
		}
	} else {
		if (gvExcelParam.conFirmFlag == true) {
			gfn_exportGrid(gvExcelParam);
		} else {
			confirm(gfn_getDomainMsg("msg.doyouWantToDownloadToExcel?") ,function() { gfn_exportGrid(gvExcelParam); } ,function() {
				if ($.isFunction(gvExcelParam.nCallback)) {
					gvExcelParam.nCallback.call();
				}
			});
		}
	}
	return false;
}

//엑셀 내보내기
function gfn_exportGrid(exParam) {
	
	var exParam = exParam || {};
	var gridIdx = exParam.gridIdx || 0;
	var topView = exParam.topView || false;
	
	//기본설정
	var exOpt = {
		objInstance   : GV_ARR_GRID[gridIdx], //첫번째 그리드
		fileNm        : "temp",
		formYn        : "N",
		indicator     : "default",
		lookupDisplay : true,
		separateRows  : true,
		fieldArr      : null,
		callback      : null
	};

	//파라미터가 있을경우 처리
	if (exParam != undefined) {
		$.extend(exOpt,exParam);
	}

	var objInstance        = exOpt.objInstance;
	var objGrid            = objInstance.objGrid;
	var provider           = objInstance.objData;
	var fileNm             = exOpt.fileNm;
	var formYn             = exOpt.formYn;
	var indicator          = exOpt.indicator;
	var lookupDisplay      = exOpt.lookupDisplay;
	var separateRows       = exOpt.separateRows;
	var applyDynamicStyles = exOpt.applyDynamicStyles;
	var fieldArr           = exOpt.fieldArr;
	var callback           = exOpt.callback;

	//tree
	if (objInstance.treeFlag) {
		if (provider.getChildCount(-1) == 0) {
			gfn_unblockUI();
			alert(gfn_getDomainMsg("msg.noDataFound"));
			return;
		}
	} else {
		if (provider.getRows() == 0 && formYn!="Y") {
			gfn_unblockUI();
			alert(gfn_getDomainMsg("msg.noDataFound"));
			return;
		}
	}

	//현재 layout 저장
	var curLayout = objGrid.saveColumnLayout();
	var objVisible = [];
	var orgFields = [];
	var date = dateFormat("yyyy mm dd HH MM ss").replace(/ /g, '');
	var columnNames = objGrid.getColumnNames(false);
	
	/*
	$.each(columnNames, function(n,v) {
		orgFields.push({id : v, width : objGrid.getColumnProperty(v, "width")});
		var visible = objGrid.getColumnProperty(v, "visible");
		if(!visible) {
			//제외 컬럼
			if (v != "GRP_LVL_ID" && v != "OMIT_FLAG") {
				objGrid.setColumnProperty(v, "visible", true);
				objGrid.setColumnProperty(v, "width", 0);
			}
		}
	});
	*/

	//출력할 필드를 지정
	var bAllColumns = true;
	if (fieldArr != null && fieldArr != undefined) {
		$.each(columnNames, function(n,v) {
			objGrid.setColumnProperty(v, "visible", false);
		});
		$.each(fieldArr, function(n,v) {
			objGrid.setColumnProperty(v, "visible", true);
		});
		bAllColumns = false;
	}
	
	
	// 엑셀 다운로드 처리
	setTimeout(function () {
		objGrid.exportGrid({
			type: "excel",
			target: "local",
			fileName: fileNm+"_"+date+".xlsx",
			//showProgress: !objInstance.treeFlag,
			showProgress: true,
			progressMessage: gfn_getDomainMsg("msg.excelIsDownloading"),
			indicator: indicator,
			header: "visible",
			//allColumns: bAllColumns,
			//allItems: true,
			//linear: true,
			//footer: "hidden",
			//compatibility: true,
			separateRows: separateRows,   //row 분리
			applyDynamicStyles : applyDynamicStyles,
			lookupDisplay: lookupDisplay, // column의 lookupDisplay에 표시된 값으로 저장
			documentTitle: {  //제목
		        message: EXCEL_SEARCH_DATA,
		        visible: topView,
		        styles: {
		            fontSize: 15,
		            fontBold: true,
		            textAlignment: "near",
		            lineAlignment: "near",
		            background: "#08f90000"
		        },
		        spaceTop: 1,
		        spaceBottom: 0,
		        height: 200
		    },
			done: function() {
				//alert("done excel export");
				gvExcelParam.applyDynamicStyles = false; //초기화
				
				/*
				$.each(orgFields, function (n,v) {
					objGrid.setColumnProperty(v.id, "width", v.width);
				});
				objGrid.setColumnLayout(curLayout);
				*/

				if ($.isFunction(callback)) {
					callback.call();
				}
			}
		});
	}, 100);
}

//공통 조회
function gfn_getCommData(param) {
	var rtnMap;
	param = param || {};
	param._mtd = "getList";
	param.tranData = [{outDs:"rtnList",_siq: param._siq}];
	gfn_service({
	    async: false,
	    url: GV_CONTEXT_PATH + "/biz/obj",
	    data:param,
	    success:function(data) {
	    	rtnMap = data.rtnList;
	    }
	},"obj");
	return rtnMap;
}

//현재 일자의 Calendar 데이타를 가져온다.
function gfn_getCurrentDate() {
	return gfn_getDateConvert(gfn_getCommData({ _siq : "currentDate" })[0]);
}

//해당 일자의 Calendar 데이타를 가져온다.
function gfn_getDate(yyyymmdd) {
	return gfn_getDateConvert(gfn_getCommData({ _siq : "calendarInfo", YYYYMMDD : yyyymmdd.replace(/-/g, '')})[0]);
}

//해당 일자에 일자를 더한  Calendar 데이타를 가져온다.
function gfn_getAddDate(yyyymmdd, addDay, addType) {
	addType = addType || "D";
	return gfn_getDateConvert(gfn_getCommData({ _siq : "addDate", YYYYMMDD : yyyymmdd.replace(/-/g, ''), ADD_DAY : addDay, ADD_TYPE : addType })[0]);
}

//Calendar 데이타중에서 화면에 보여줄 것들에 대한 변환을 한다. 나중에 주도 필요할지 모름
function gfn_getDateConvert(dateObj) {
	if(dateObj != undefined){
		dateObj.DISP_YYYYMMDD = dateObj.YYYYMMDD.substr(0,4) + "-" + dateObj.YYYYMMDD.substr(4,2) + "-" + dateObj.YYYYMMDD.substr(6,2);
	}
	return dateObj;
}

//공통팝업오픈
function gfn_comPopupOpen(popType,params) {
	
	var strTh = "/th";
	
	params = params || {}; //재정의
	params.popupYn = "Y";

	var url = "";
	var popupTitle = params.popupTitle || "Keyword Popup";
	var pWidth = params.width || 500;
	var pHeight = params.height || 560;
	switch(popType) {
		case "CODE" :
			url = "comCodePopup";
			popupTitle = params.popupTitle || "Code Selection";
			break;
		case "COM_ITEM" :
		case "COM_ITEM_PLAN" :
			url = "comItemPopup";
			popupTitle = params.popupTitle || "Item Selection";
			pWidth = 870;
			break;
		case "COM_ITEM_REP" :
			url = "comItemRepPopup";
			popupTitle = params.popupTitle || "Rept. Item Selection";
			pWidth = 580;
			break;
		case "CUSTOMER" :
			url = "customerPopup";
			popupTitle = params.popupTitle || "Customer Selection";
			break;
		case "EMP" :
			url = "empPopup";
			popupTitle = params.popupTitle || "Emp Selection";
			break;
		case "PART" :
			url = "partPopup";
			popupTitle = params.popupTitle || "Part Selection";
			break;
		case "DIMENSION" :
			url = "dimensionConfPopup";
			popupTitle = params.popupTitle || "Dimension Configuration";
			pWidth = 960*1.3;
			pHeight = 560*1.2;
			break;
		case "MEASURE" :
			url = "measureConfPopup";
			popupTitle = params.popupTitle || "Measure Configuration";
			pWidth = 500*1.2;
			pHeight = 530*1.2;
			break;
		case "PROD_ORDER_NO" :
			url = "prodOrderNoPopup";
			popupTitle = params.popupTitle || "PROD ORDER NO. Selection";
			break;
		case "MATERIALS_CODE" :
			url = "materialsCodePopup";
			popupTitle = params.popupTitle || "MATERIALS CODE Selection";
			pWidth = 960;
			pHeight = 560;
			break;
		case "FILE" :
			url = "fileUpDownPopup";
			popupTitle = params.popupTitle || "File Info.";
			pHeight = 300;
			break;
		case "WORK_ORDER_NO" :
			url = "wipHoldingReqPopup";
			popupTitle = params.popupTitle || "Item Selection";
			pWidth = 870;
			break;
		case "PJT_MEM" :
			url = "empPopup";
			popupTitle = params.popupTitle || "ProjectMemAdd";
			break;
		case "PJT_REG_MEM" :
			url = "empPopup";
			popupTitle = params.popupTitle || "ProjectRegMemAdd";
			break;
	}

	if (!gfn_isNull(params.rootUrl) && !gfn_isNull(params.url)) {
		url = GV_CONTEXT_PATH + strTh + "/" + params.rootUrl + "/popup/" + params.url + "";
	} else {
		if (gfn_isNull(url)) return;
		url = GV_CONTEXT_PATH + strTh + "/common/popup/" + url + "";
	}

	var pPos  = gfn_getPopupXY(pWidth,pHeight);
	var pLeft = pPos.left
	var pTop  = pPos.top

	var popOption = "left="+pLeft+", top="+pTop+", width="+pWidth+", height="+pHeight+", scrollbars=yes, status=no, resizable=yes"; //, resizable=no
	window.open('', popType + '_popup', popOption);

	//동적 hidden 데이터 생성
	//$("#commonPopForm").html("");
	var elem = $("#commonPopForm > input[type='hidden']");
	$.each(elem, function(n,v) {
		if (v.name != "_csrf") $(v).remove();
	});

	$("#commonPopForm").append('<input type="hidden" name="popType" value="'+popType+'" />');
	$.each(params, function(n, v) {
	    $("#commonPopForm").append('<input type="hidden" name="'+n+'" value="'+v+'" />');
	});

	$("#commonPopForm").append('<input type="hidden" name="popupTitle" value="'+popupTitle+'" />');
    $("#commonPopForm").attr("onSubmit","return true");
	$("#commonPopForm").attr("action",url);
	$("#commonPopForm").attr("target",popType+"_popup");
	$("#commonPopForm").submit().attr("onSubmit","return false");

	//return false;
}

//다건 콤보|멀티콤보구성
function gfn_setMsComboAll(msMap) {
	var inChild = '';
	$.each(msMap,function(n,v) {
		if (v.type == "R") {
			gfn_setRadio(v)
		} else {
			//child 생성
			inChild = '';
			inChild += '<div class="ilist">';
			inChild += '<div class="itit">'+v.title+'</div>';
			inChild += '<div class="iptdv borNone">'; //selectBox
			if (v.type == "S") {
				inChild += '<select class="iptcombo" id="'+v.id+'" name="'+v.id+'"></select>';
			} else {
				inChild += '<select id="'+v.id+'" name="'+v.id+'" multiple="multiple"></select>';
			}
			inChild += '</div>';
			inChild += '</div>';
			
			$("#"+v.target).html(inChild);
			$("#"+v.id).parent().parent().css("overflow","visible");
			
			gfn_setMsCombo(v.id,v.data,v.exData,v.option,v.event);
		}
	});
}

//radio 구성
function gfn_setRadio(v) {
	//예외처리
	var items = $.grep(v.data, function (item) {
		for (var i=0; i<v.exData.length; i++) {
			if(item.CODE_CD == v.exData[i]) return false;
		}
		return true;
	});
	
	//데이터 구성
	var inChild = '';
	inChild += '<strong class="filter_tit">'+v.title+'</strong>';
	inChild += '<ul class="rdofl">';
	$.each(items, function(nn,vv) {
		inChild += '	<li><input type="radio" id="'+v.id+nn+'" name="'+v.id+'" value="'+this.CODE_CD+'"> <label for="'+v.id+nn+'">'+this.CODE_NM+'</label></li>';
	});
	inChild += '</ul>';
	$("#"+v.target).html(inChild);
}

//단건 콤보|멀티콤보구성
function gfn_setMsCombo(objId,data,exData,option,event) {
	$("#"+objId).children().remove(); //초기화

	//예외처리
	var items = $.grep(data, function (item) {
		for (var i=0; i<exData.length; i++) {
			if(item.CODE_CD == exData[i]) return false;
		}
		return true;
	});

	//데이터 구성
	var arrChnGrp = ["ITEM_GROUP"];
	$.each(items, function() {
		if ($.inArray(this.GROUP_CD,arrChnGrp) > -1 || (option != undefined && option.dspChnYn == "Y")) {
			$("#"+objId).append('<option value="'+this.CODE_CD+'">'+this.CODE_CD+'</option>');
		} else {
			$("#"+objId).append('<option value="'+this.CODE_CD+'">'+this.CODE_NM+'</option>');
		}
	});

	//multicombo 구성
	if (!gfn_isNull($("#"+objId).attr("multiple"))) {
		var msOpt = {
			width : '135px',
			//multipleWidth : 80,
			//dropWidth : "110%",
		};
		if (option != undefined) {
			$.extend(msOpt,option);
		}
		
		//이벤트 처리
		if ($.isPlainObject(event)) {
			
			var orgMData, newMData;
			event.onOpen = function() {
				orgMData = $("#"+objId).multipleSelect('getSelects').join();
            },
            event.onClose = function() {
         		var newMData = $("#"+objId).multipleSelect('getSelects');
         		if (orgMData == newMData.join()) return false;
         		
         		$.each(event.childId, function(n,v) {
        			var childData = $.grep(event.childData[n], function(vv,nn) {
        				var chkb = false;
        				//if (gfn_isNull(vv.UPPER_CD)) return false;
        				
        				$.each(newMData, function(nnn,vvv) {
        					if (vv.UPPER_CD.indexOf(vvv) > -1) {
        						chkb = true;
        					}
        				});
        				return chkb;
        				//return $.inArray(v.UPPER_CD,newMData) > -1;
        			});
        			gfn_setMsCombo(v,childData,["*"]);
    			});
         		
         		if(event.callback && event.callback instanceof Function) {
         			event.callback();
	        	}
            },
			
			$.extend(msOpt,event);
		}
		
		$("#"+objId).multipleSelect(msOpt);
		
		//전체체크
		if (msOpt.allFlag == "Y") {
			$("#"+objId).multipleSelect("checkAll");
		}
		
	} else {
		if (!gfn_isNull(option) && !gfn_isNull(option.width)) {
			$("#"+objId).css("width", option.width);
		}
	}
}

function gfn_eventChkAllMsCombo(objId) {
	$("#"+objId).multipleSelect("open");
	$("#"+objId).multipleSelect("checkAll");
	$("#"+objId).multipleSelect("close");
}

//keyword popup
function gfn_keyPopAddEvent(keyMap) {
	var pHrcyList = ["COM_ITEM","COM_ITEM_PLAN","COM_ITEM_REP"];
	$.each(keyMap,function(n,v) {
		var pHrcyClass = "";
		var nmStr = "_nm";
		var cdStr = "_cd";
		var keyStr = "_key";

		if (v.upperYn!=undefined && v.upperYn=="Y") {
			nmStr = "_NM";
			cdStr = "_CD";
			keyStr = "_KEY";
		}

		//하이라키 연동처리
		for (var i=0; i<pHrcyList.length; i++) {
			if (pHrcyList[i] == v.type) {
				pHrcyClass = "pHrcy";
				break;
			}
		}

		//child 생성
		var inChild = '';
		if (v.popupYn == "Y") {
			var tStyle  = v.tStyle || "";
			var inStyle = v.inStyle || "width:100px";
			inChild += '<strong style="'+tStyle+'">'+v.title+'</strong>';
			inChild += '<div class="keySearch">';
			inChild += '	<input type="text" id="'+v.id+nmStr+'" name="'+v.id+nmStr+'" class="ipt '+pHrcyClass+'_nm" style="'+inStyle+'" ><a href="#"><img src="' + GV_CONTEXT_PATH + '/statics/images/common/bl_close.gif" id="'+v.id+'_remove" alt=""></a><a href="#"><img src="' + GV_CONTEXT_PATH + '/statics/images/common/ico_srh.png" id="'+v.id+'_btn" alt=""></a>';
			inChild += '	<input type="hidden" id="'+v.id+cdStr+'" name="'+v.id+cdStr+'" class="ipt '+pHrcyClass+'_cd" >';
			inChild += '	<input type="hidden" id="'+v.id+keyStr+'" name="'+v.id+keyStr+'" class="ipt '+pHrcyClass+'_cd" >';
			inChild += '	<input type="hidden" id="'+v.id+'_upper_flag" name="'+v.id+'_upper_flag" value="'+v.upperYn+'" class="ipt" >';
			inChild += '</div>';
		} else {
			inChild += '<div class="ilist">';
			inChild += '	<div class="itit">'+v.title+'</div>';
			inChild += '	<div class="iptdv">';
			inChild += '		<input type="text" id="'+v.id+nmStr+'" name="'+v.id+nmStr+'" class="ipt '+pHrcyClass+'_nm" ><a href="#"><img src="' + GV_CONTEXT_PATH + '/statics/images/common/bl_close.gif" id="'+v.id+'_remove" alt=""></a><a href="#"><img src="' + GV_CONTEXT_PATH + '/statics/images/common/ico_srh.png" id="'+v.id+'_btn" alt=""></a>';
			inChild += '		<input type="hidden" id="'+v.id+cdStr+'" name="'+v.id+cdStr+'" class="ipt '+pHrcyClass+'_cd" >';
			inChild += '	    <input type="hidden" id="'+v.id+keyStr+'" name="'+v.id+keyStr+'" class="ipt '+pHrcyClass+'_cd" >';
			inChild += '		<input type="hidden" id="'+v.id+'_upper_flag" name="'+v.id+'_upper_flag" value="'+v.upperYn+'" class="ipt" >';
			inChild += '	</div>';
			inChild += '</div>';
		}


		$("#"+v.target).html(inChild);

		//이벤트 생성
		$("#"+v.id+"_remove").click("on", function() {
			$("#"+v.id+nmStr).val("");
			$("#"+v.id+cdStr).val("");
			$("#"+v.id+keyStr).val("");
		});

		$("#"+v.id+"_btn").click("on", function() {
			var params = {
				popupYn : "Y",
				objId : v.id,
				singleYn : "N",
				searchName : $("#"+v.id+nmStr).val(),
				//searchCode : $("#"+v.id+cdStr).val(),
				searchCode : $("#"+v.id+keyStr).val() || $("#"+v.id+cdStr).val(),
				callback : "gfn_comPopupCallback",
			}
			gfn_comPopupOpen(v.type,gfn_mergeProperties(params, v.param));
		});

		$("#"+v.id+nmStr).bind("keyup", function() {
			$("#"+v.id+cdStr).val("");
			$("#"+v.id+keyStr).val("");
		});
	});
}

//필터 키워드 팝업 콜백처리
function gfn_comPopupCallback() {
	if (arguments.length > 1) {
		var rtnCd = "";
		var rtnNm = "";
		var rtnKey = "";

		var keyCode = arguments[2] || "CODE_CD";
		var keyName = arguments[3] || "CODE_NM";
		var keyRow  = arguments[4] || "ROW_KEY";

		$.each(arguments[0],function(n,v) {
			if (n == 0) {
				rtnCd  += v[keyCode];
				rtnNm  += v[keyName];
				rtnKey += (v[keyRow] || v[keyCode]);
			} else {
				rtnCd += ","+v[keyCode];
				rtnNm += ","+v[keyName];
				rtnKey += ","+(v[keyRow] || v[keyCode]);
			}
		});

		if ($("#"+arguments[1]+"_upper_flag").val() == "Y") {
			$("#"+arguments[1]+"_CD").val(rtnCd);
			$("#"+arguments[1]+"_NM").val(rtnNm);
			$("#"+arguments[1]+"_KEY").val(rtnKey);
		} else {
			$("#"+arguments[1]+"_cd").val(rtnCd);
			$("#"+arguments[1]+"_nm").val(rtnNm);
			$("#"+arguments[1]+"_key").val(rtnKey);
		}
	}
}

//ROLE 조회 및 체크 파라미터 roleCd가 있으면 true / false, 없으면 roleCd 리스트를 반환한다.
function gfn_getRoleCd(roleCd) {
	var rtnMap;
	var param = {};
	param._mtd     = "getList";
	param.tranData = [{outDs:"rtnList",_siq:"common.comUserRole"}];
	gfn_service({
		async: false,
		url: GV_CONTEXT_PATH + "/biz/obj",
		data: param,
		success:function(data) {
			rtnMap = data.rtnList;
		}
	}, "obj");

	if (gfn_isNull(roleCd)) {
		return rtnMap;
	} else {
		for (var i=0; i<rtnMap.length; i++) {
			if (rtnMap[i].ROLE_CD == roleCd) {
				return true;
			}
		}
		return false;
	}
}

//Role 에 해당하는 User 조회
function gfn_roleUserList(userRole,allYn,topAllYn) {
	var rtnMap;
	param = {};
	param._mtd        = "getList";
	param.tranData    = [{outDs:"rtnList",_siq:"common.roleUserList"}];
	param.ROLE_CD     = userRole;
	param.ALL_YN      = allYn;
	param.TOP_ALL_YN  = topAllYn;
	gfn_service({
	    async: false,
	    url: GV_CONTEXT_PATH + "/biz/obj",
	    data:param,
	    success:function(data) {
	    	rtnMap = data.rtnList;
	    }
	}, "obj");
	return rtnMap;
}

function gfn_popresizeSub() {
	var p_height = $("body").height()>popupHeight?$("body").height():popupHeight;
	var p_top = 0;
	var p_bottom = 0;
	var p_grid = 0;
	var p_tmpTop = 0;

	//추가 --------------------------------
	$.each($(".realgrid1"), function() {
		if ($(this).position().top > 0) {
			p_tmpTop = $(this).position().top;
			return false;
		}
	});
	//추가 --------------------------------

	if($(".realgrid1").position() != undefined) {
		p_top = p_tmpTop + 30; // 그리드 위의 여백 14
		p_bottom = $(".pop_btn").length ? ($(".pop_btn").height() + 20 + 1) : 0; // 버튼상단 여백 10px
		
		p_grid = p_height - p_top - p_bottom;

		$(".realgrid1").width("100%");
		$(".realgrid1").height(p_grid);

		$.each(GV_ARR_GRID, function() {
			try{ this.objGrid.resetSize(); }catch (e) { }
		});
	}
}

function gfn_popresize() {

	var queryParams = $.getQueryParameters();

	$("#menuCd").val($("#menuCd").val() || queryParams.menuCd || "");
	//권한처리
	if (gfn_isNull($("#menuCd").val())) {
		if (gfn_getCurWindow() && gfn_getCurWindow().$("#saveYn").val() != "Y") {
			$(".roleWrite").hide();
		}
	} else {
		//sub menu list 조회
		gfn_service({
			async: false,
			url: GV_CONTEXT_PATH + "/common/subMenuList",
			data:{menuCd: $("#menuCd").val(), UPPER_MENU_FLAG: "N"},
			success:function(data) {
				var menuInfo = data.rtnList;
				if (menuInfo.length > 0) {
					$("#saveYn").val(menuInfo[0].SAVE_ACTION || "");
				}
			}
		});

		gfn_setRoleBtn();
	}

	popupWidth = $("body").width();
	popupHeight = $("body").height();

	$(".popupDv").css("min-width", popupWidth+"px");
	$(".popupDv").css("min-height", popupHeight+"px");

	gfn_popresizeSub();
}

//북마크 저장
function gfn_bookMark() {
	var params = {};
	params._mtd     = "saveUpdate";
	params.tranData = [{outDs:"saveCnt",_siq:"common.bookMark", grdData : [$("#commonForm").serializeObject()]}];
	gfn_service({
	    async: false,
	    url: GV_CONTEXT_PATH + "/biz/obj",
	    data:params,
	    success:function(data) {
	    },
	}, "obj");
}

function gfn_setEnterSearch() {
	//input 이벤트 정의
	$("input:not(:hidden)input:not([readonly])input:not([disabled])").each(function(index, item) {
		// INPUT 에서 Enter 시 조회 기능 구현.
		 $(this).bind("keydown", function() {
			if (event.keyCode == 13) {
				$(this).val($(this).val().trim());
				fn_apply(false);
			}
		 });
		 $(this).bind("blur", function() {
			$(this).val($(this).val().trim());
		 });
	});
}

//filterViewHorizon.jsp 에서 호출
function gfn_setViewH() {
	var vhWeekType = $('input:radio[name="vhWeekType"]:checked').val();
	if (vhWeekType == "SW") {
		$("#fromPWeek").attr("type","hidden");
		$("#toPWeek").attr("type","hidden");
		$("#fromWeek").attr("type","text");
		$("#toWeek").attr("type","text");
	} else {
		$("#fromPWeek").attr("type","text");
		$("#toPWeek").attr("type","text");
		$("#fromWeek").attr("type","hidden");
		$("#toWeek").attr("type","hidden");
	}
}

//파일 다운로드
function gfn_fileDown(fileNo, arrFileSeq, params) {
	
	params = params | {};
	
	//변수설정
	var formId = "_fileDownFrm";
	
	//초기화
	$("#"+formId).remove();
	var formHtml = '<form id="'+formId+'"></form>';
	$("body").append(formHtml);
	
	$.each(params, function(n,v) {
		$("#"+formId).append('<input type="hidden" name="'+n+'" value="'+v+'" />');
	});
	
	$("#"+formId).append('<input type="hidden" name="FILE_NO" value="'+fileNo+'" />');
	//체크된 파일만큼 hidden 추가
	$.each(arrFileSeq, function(n,v) {
		$("#"+formId).append('<input type="hidden" name="FILE_SEQ" value="'+v+'" />');
	});
	
	confirm(gfn_getDomainMsg("msg.download"), function() { 
		$("#"+formId).attr("method","post");
		$("#"+formId).attr("action",GV_CONTEXT_PATH+"/file/download");
		$("#"+formId).submit();
	});
}

function gfn_treeTabChange(gubun) {
	var idx = gubun == "S" ? "3" : (gubun == "C" ? "2" : "1");
	$("#treeTab"+idx).trigger("click");
}


//필드명의 인덱스 번호 반환
function gfn_getFieldNum(dataProvider,cNm){
	
	var cols = dataProvider.getFields();
	var rtn = null;
	
	for(var i=0;i<cols.length;i++){
		
		if(cols[i].fieldName == cNm){
			rtn = i;
			break;
		}
		
	}
	return rtn;
}

//컬명명의 인덱스 번호 반환
function gfn_getColsNum(Arr,cNm){
	
	var cols = Arr;
	var rtn = null;
	
	for(var i=0;i<cols.length;i++){
		if(cols[i].name == cNm){
			rtn = i;
			break;
		}
		
	}
	return rtn;
}


function gfn_getColsArr(grid){
	
	var cols = grid.getColumns();
	var colsArr = [];
	
	
	for(var i=0;i<cols.length;i++){
		
		if(cols[i].columns == null || cols[i].columns == undefined){
		    //l level
		    var obj = {
			      	   name : gfn_nvl(cols[i].name,''),
				       fieldName : gfn_nvl(cols[i].fieldName,'')
		               };
		    
		    colsArr.push(obj);
		
		}else{
			
			for(var s=0;s<cols[i].columns.length;s++){
				
				if(cols[i].columns[s].columns == null || cols[i].columns[s].columns == undefined){
				    //2 level	
					var obj = {
						      	   name : gfn_nvl(cols[i].columns[s].name,''),
							       fieldName : gfn_nvl(cols[i].columns[s].fieldName,'')
					               };
					    
					           colsArr.push(obj);
				}else{
					
					for(var v=0;v<cols[i].columns[s].columns.length;v++){
						if(cols[i].columns[s].columns[v].columns == null || cols[i].columns[s].columns[v].columns == undefined){
							//3 level
							var obj = {
							      	   name : gfn_nvl(cols[i].columns[s].columns[s].name,''),
								       fieldName : gfn_nvl(cols[i].columns[s].columns[s].fieldName,'')
						               };
						    
						    colsArr.push(obj);
						}else{
							
							for(var t=0;t<cols[i].columns[s].columns[v].columns.length;v++){
								//4 level
								var obj = {
									      	   name : gfn_nvl(cols[i].columns[s].columns[s].columns[t].name,''),
										       fieldName : gfn_nvl(cols[i].columns[s].columns[s].columns[t].fieldName,'')
								               };
								    
								    colsArr.push(obj);
							
							}	
						}	
					}
						
				}
					
			}
		}
	}
		
	return colsArr;
}




//block 삭제
function gfn_selBlockDelete(grid,dataProvider,cellOrCols,CellStyle ){
	  
	var selection = grid.getSelection();
	var option = grid.getSelectOptions();
	
	if(!cellOrCols) cellOrCols = "cell"; //else cols 컬럼단위 editable 검색
	if(!CellStyle) CellStyle = "editStyle";
	
    if (!selection) return;
    
    if(selection.startColumn != selection.endColumn  || selection.startItem != selection.endItem ){
		
    	if(cellOrCols == 'cell'){
    	
    	   var st_cols = gfn_getFieldNum(dataProvider,selection.startColumn);
           var ed_cols = gfn_getFieldNum(dataProvider,selection.endColumn);
           
           var cols = dataProvider.getFields();
           
           for( var s = selection.startItem; s <= selection.endItem ; s++ ){
		    	  
        	   for( var x = st_cols ; x <= ed_cols ; x++ ){
		    		       
    		       v_column = cols[x].fieldName;
    		       
    		       var arrColStyle = grid.getCellApplyStyles(s, v_column);
    		       var edit_yn = arrColStyle.editable;
    		       
    		       if(edit_yn) {
    		    	   grid.setValue(s, v_column, null);
    		       }
    		       
    		      
        	   }
           }
    	}else if( cellOrCols == 'cols' ){
    		 
			var cols =  gfn_getColsArr(grid);  
			var st_cols = gfn_getColsNum(cols,selection.startColumn);
			var ed_cols = gfn_getColsNum(cols,selection.endColumn);
      
			if(cols.length > 0 && st_cols != null && ed_cols != null){ 
             
				for( var s = selection.startItem; s <= selection.endItem ; s++ ){
	   		    	  
					for( var x = st_cols ; x <= ed_cols ; x++ ){
	   		    		   	  
   		    		   v_column = cols[x].name;
	    		       v_field  = cols[x].fieldName;
	    		       
	    		       edit_yn = grid.getColumnProperty(v_column,'editable');
	    		       if(!edit_yn) edit_yn = (grid.getCellStyle(s,v_field) == CellStyle )? true : false;
	    			   if(edit_yn) grid.setValue(s, v_field, null);
		    			  
					}
				}
    		  
			}
    	}else if(cellOrCols == "dynamic"){
    		
    		var st_cols = gfn_getFieldNum(dataProvider,selection.startColumn);
            var ed_cols = gfn_getFieldNum(dataProvider,selection.endColumn);
            var cols = dataProvider.getFields();
            
            for(var s = selection.startItem; s <= selection.endItem; s++){
 		    	  
         	   for(var x = st_cols; x <= ed_cols; x++){
         		  
     		       v_column = cols[x].fieldName;
     		       
     		       if(CellStyle == "PLAN_SALES"){ //AP1, AP2, 확정 화면에 대한 조건
     		    	   if((v_column.indexOf("_DMD") != -1 && v_column.indexOf("_AMT_KRW") == -1) || v_column.indexOf("_ADJ_REASON") != -1){
        		    	   edit_yn = grid.getValue(s, v_column + "_YN");
        		    	   if(edit_yn == "Y"){
        		    		   grid.setValue(s, v_column, null);
        		    		   fn_allInOneCalc(grid, s, s, x);
        		    	   }
        		       }   
     		       }
         	   }
            }
    	}
    	  
    	event.preventDefault();
    	return false;
	}else{
    	return;
    }
	
}

//엑셀 past시 label값 붙여 넣기시 value값으로 치환시켜 줌
//전제 조건 pasteOptions 값 설정 해야 함
function gfn_pasteValueToLabel(grids, dp, colsArray){
	
	if(colsArray.length > 0 && grids && dp){
	
		grids.onEditRowPasted = function(grid, itemIndex, dataRow, fields, oldValues, newValues){
			
			if(newValues.length > 0){

				var newValuesArr = [];
				
				$.each(newValues, function(i, fd){
					if(fd != null && fd != undefined) newValuesArr.push(fd);
				});
				
				$.each(fields,function(i, fld){
				
					var field = dp.getFieldName(fld);
					var cols = grid.columnsByField(field);
					var colsName = cols[0].name;
					var fieldName = cols[0].fieldName;
					var editorType = cols[0].editor; 
					var values = cols[0].values;
					var labels = cols[0].labels;
					
					if($.inArray(colsName, colsArray) > -1 &&  editorType == "dropDown"){
						if($.inArray(newValuesArr[i], labels) > -1){
							grid.setValue(itemIndex, fieldName, values[$.inArray(newValuesArr[i], labels)]);
						}else if($.inArray(newValuesArr[i], labels) == -1 && $.inArray(newValuesArr[i], values) == -1){
							grid.setValue(itemIndex, fieldName, "");
						}
					}
				});
			}
		};
	}
}

function gfn_siteMap() {
	var menuHtml = '';
	var tmpChk1 = false;
	var tmpChk2 = false;
	var dsMenu = gfn_getGlobal("DS_MENU");
	$.each(dsMenu, function(n,v) {
		
		if (v.MENU_LVL == 1) {
			menuHtml += '<h3>'+v.MENU_NM+'</h3>\n';
			menuHtml += '<ul class="list_site">\n';
		}
			
		tmpChk1 = false;
		$.each(dsMenu, function(n2,v2) {
			if (v.MENU_CD == v2.UPPER_MENU_CD && v2.MENU_LVL == 2) {
				menuHtml += '	<li><a href="#">'+v2.MENU_NM+'</a>\n';
				menuHtml += '		<ul>\n';
				
				tmpChk2 = false;
				$.each(dsMenu, function(n3,v3) {
					if (v2.MENU_CD == v3.UPPER_MENU_CD && v3.MENU_LVL == 3) {
						menuHtml += '			<li><a href="javascript:gfn_newTab(\''+v3.MENU_CD+'\');">'+v3.MENU_NM+'</a></li>\n';
						tmpChk2 = true;
					} else if (tmpChk2 == true) {
						menuHtml += '		</ul>\n';
						menuHtml += '	</li>\n';
						return false;
					}
				});
				
			} else if (tmpChk1 == true) {
				return false;
			}
		});
	});
	if (menuHtml != "") menuHtml += '</ul>\n';
	
	$("#sitemappop .scroll").html(menuHtml);
}

//iframe 로드 완료시 호출되는 공통함수
function gfn_completedFormload() {
	gfn_tabresize();
}




