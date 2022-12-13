<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code="lbl.reptCustGroupMgmt"/></title>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
	<jsp:param name="popupYn" value="Y"/>
</jsp:include>

<script type="text/javascript">
var popupWidth, popupHeight;
var gridInstance, grdMain, dataProvider;
var maxSeq = 0;
var codeMap;
var popUpMenuCd = "${param.menuCd}";
var lv_conFirmFlag = true;
$("document").ready(function (){
	gfn_popresize();
	fn_initGrid();
	fn_initEvent();
	fn_apply();
	fn_excelSqlAuth();
	
	$(".viewfnc5").click("on", function() {
        gfn_doExportExcel({fileNm:"${menuInfo.menuNm}", conFirmFlag: lv_conFirmFlag}); 
        $(".pClose").click(function() {
            $("#divTempLayerPopup").hide();
            $(".back").hide();
        });
        $(".popClose").click(function() {
            $("#divTempLayerPopup").hide();
            $(".back").hide();
        });
        $(".back").click(function() {
            $(".popup2").hide();
            $(".back").hide();
        });
    });
    
    $(".viewfnc4").click("on", function() {
        fn_apply(true);
        
        $(document).on("click",".popup2 .popClose, .popup2 .pClose",function() {
            $(".popup2").hide();
            $(".back").hide();
        });
        
        $(".back").click(function() {
            $(".popup2").hide();
            $(".back").hide();
        });
        
    })
	
});

$(window).resize(function() {
	gfn_popresizeSub();
}).resize();

//그리드 초기화
function fn_initGrid() {
	
	var grpCd = "CUST_CATE,PROD_CATE,FLAG_YN";
	codeMap = gfn_getComCode(grpCd, 'Y'); //공통코드 조회
	
	//그리드 설정
	gridInstance = new GRID();
	gridInstance.init("realgrid");
	grdMain      = gridInstance.objGrid;
	dataProvider = gridInstance.objData;
	
	fn_setFields(dataProvider);
	fn_setColumns(grdMain);
	fn_setOptions(grdMain);
	
	grdMain.addCellStyles([{ id: "editFalse", editable: false }]);
}

//그리드필드
function fn_setFields(provider) {
	var fields = [
		{ fieldName : "REP_CUST_GROUP_CD" },
		{ fieldName : "REP_CUST_GROUP_NM" },
		{ fieldName : "CUST_GROUP_CNT" },
		{ fieldName : "CUST_CATE"},
		{ fieldName : "PROD_CATE"},
		{ fieldName : "PRIORITY_TEL", dataType : "number"},
		{ fieldName : "PRIORITY_LAM", dataType : "number"},
		{ fieldName : "PRIORITY_DIF", dataType : "number"},
		{ fieldName : "SGNA_RATE", dataType : "number"},
		{ fieldName : "EXCEPT_YN"},
		{ fieldName : "SORT", dataType : "number"},
		{ fieldName : "USE_FLAG" },
		{ fieldName : "UPDATE_DTTM" },
		{ fieldName : "UPDATE_ID" },
		{ fieldName : "CREATE_DTTM" },
		{ fieldName : "CREATE_ID" },
	];
	dataProvider.setFields(fields);
}

//그리드컬럼
function fn_setColumns(grd) {
	var columns = [
		{
			name         : "REP_CUST_GROUP_CD",
			fieldName    : "REP_CUST_GROUP_CD",
			editable     : false,
			header       : { text: '<spring:message code="lbl.reptCustGroup"/>' },
			styles       : { background : gv_noneEditColor, textAlignment: "near" },
			width        : 100,
		}, {
			name         : "REP_CUST_GROUP_NM",
			fieldName    : "REP_CUST_GROUP_NM",
			editable     : true,
			header       : { text: '<spring:message code="lbl.reptCustGroupName"/>' },
			styles       : { textAlignment: "near" },
			dynamicStyles: [{
                criteria: ["(state='d') or (state='x')","(state<>'d') and (state<>'x')"],
                styles  : ["background="+gv_noneEditColor,"background="+gv_requiredColor]
            }],
			width        : 150,
		}, {
			name         : "CUST_GROUP_CNT",
			fieldName    : "CUST_GROUP_CNT",
			editable     : false,
			header       : { text: '<spring:message code="lbl.custGroupCnt"/>' },
			styles       : { textAlignment: "far", background : gv_noneEditColor },
			width        : 80,
		}, {
			name         : "CUST_CATE",
			fieldName    : "CUST_CATE",
			editable     : true,
			header       : { text: '<spring:message code="lbl.custCate"/>' },
			styles       : { textAlignment: "center" },
			editor       : { type: "dropDown", domainOnly : true}, 
			values       : gfn_getArrayExceptInDs(codeMap.CUST_CATE, "CODE_CD", ""),
			labels       : gfn_getArrayExceptInDs(codeMap.CUST_CATE, "CODE_NM", ""),
			lookupDisplay: true,
			width        : 80,
		}, {
			name         : "PROD_CATE",
			fieldName    : "PROD_CATE",
			editable     : true,
			header       : { text: '<spring:message code="lbl.prodCate"/>' },
			styles       : { textAlignment: "center" },
			editor       : { type: "dropDown", domainOnly : true}, 
			values       : gfn_getArrayExceptInDs(codeMap.PROD_CATE, "CODE_CD", ""),
			labels       : gfn_getArrayExceptInDs(codeMap.PROD_CATE, "CODE_NM", ""),
			lookupDisplay: true,
			width        : 80,
		}, {
			name         : "PRIORITY_TEL",
			fieldName    : "PRIORITY_TEL",
			editable     : true,
			editor       : { type : "number" },
			header       : { text: '<spring:message code="lbl.priorityTel"/>' },
			styles       : { textAlignment: "far" },
			width        : 80,
		}, {
			name         : "PRIORITY_LAM",
			fieldName    : "PRIORITY_LAM",
			editable     : true,
			editor       : { type : "number" },
			header       : { text: '<spring:message code="lbl.priorityLam"/>' },
			styles       : { textAlignment: "far" },
			width        : 80,
		}, {
			name         : "PRIORITY_DIF",
			fieldName    : "PRIORITY_DIF",
			editable     : true,
			editor       : { type : "number" },
			header       : { text: '<spring:message code="lbl.priorityDif"/>' },
			styles       : { textAlignment: "far" },
			width        : 80,
		}, {
			name         : "SGNA_RATE",
			fieldName    : "SGNA_RATE",
			editable     : true,
			editor       : { type : "number" },
			header       : { text: '<spring:message code="SGNA_RATE"/>' },
			styles       : { textAlignment: "far" },
			width        : 80,
		}, 
		{
			name : "EXCEPT_YN", fieldName : "EXCEPT_YN", editable : true, header: {text: '<spring:message code="lbl.dashBoardPerfmncExct" javaScriptEscape="true" />'},
			styles : {textAlignment: "center"},
			width  : 100,
			editor : { type: "dropDown", domainOnly: true },
			values : gfn_getArrayExceptInDs(codeMap.FLAG_YN, "CODE_CD", ""),
			labels : gfn_getArrayExceptInDs(codeMap.FLAG_YN, "CODE_NM", ""),
			lookupDisplay: true
		},
		
		{
			name         : "SORT",
			fieldName    : "SORT",
			editable     : true,
			editor       : { type : "number" },
			header       : { text: '<spring:message code="lbl.sort"/>' },
			styles       : { textAlignment: "far" },
			width        : 50,
		}, {
			name         : "USE_FLAG",
			fieldName    : "USE_FLAG",
			editable     : false,
			header       : { text: '<spring:message code="lbl.useYn"/>' },
			renderer     : gfn_getRenderer("CHECK",{editable:true}),
			dynamicStyles: [{
                criteria: ["values['CUST_GROUP_CNT']=0","values['CUST_GROUP_CNT']<>0"],
                styles  : ["background="+gv_editColor,"background="+gv_noneEditColor]
            }],
			width        : 80,
		}, {
			name         : "UPDATE_DTTM",
			fieldName    : "UPDATE_DTTM",
			editable     : false,
			header       : { text: '<spring:message code="lbl.updateDttm"/>' },
			styles       : { background : gv_noneEditColor },
			width        : 120,
		}, {
			name         : "UPDATE_ID",
			fieldName    : "UPDATE_ID",
			editable     : false,
			header       : { text: '<spring:message code="lbl.updateBy"/>' },
			styles       : { background : gv_noneEditColor, textAlignment: "near" },
			width        : 100,
		}, {
			name         : "CREATE_DTTM",
			fieldName    : "CREATE_DTTM",
			editable     : false,
			header       : { text: '<spring:message code="lbl.createDttm"/>' },
			styles       : { background : gv_noneEditColor },
			width        : 120,
		}, {
			name         : "CREATE_ID",
			fieldName    : "CREATE_ID",
			editable     : false,
			header       : { text: '<spring:message code="lbl.createBy"/>' },
			styles       : { background : gv_noneEditColor, textAlignment: "near" },
			width        : 100,
		},
	];
	grdMain.setColumns(columns);
}

//그리드 옵션
function fn_setOptions(grd) {
	grd.setOptions({
		checkBar: { visible: true, showAll: true },
		stateBar: { visible: true }
	});
}

//이벤트 초기화
function fn_initEvent() {
	
	//버튼 이벤트
	$(".fl_app"   ).click("on", function() { fn_apply(); });
	$("#btnReset" ).click("on", function() { fn_reset(); });
	$("#btnAdd"   ).click("on", function() { fn_add(); });
	$("#btnDelete").click("on", function() { fn_del(); });
	$("#btnSave"  ).click("on", function() { fn_save(); });
	$("#btnClose" ).click("on", function() { window.close(); });
	
	//그리드 이벤트
	grdMain.onCurrentChanging = function(grid, oldIndex, newIndex) {
		if (grid.getValue(newIndex.itemIndex, "CUST_GROUP_CNT") == 0) {
			grid.setColumnProperty("USE_FLAG", "readOnly", false);
		} else {
			grid.setColumnProperty("USE_FLAG", "readOnly", true);
		}
	}
}

//조회
function fn_apply(sqlFlag) {
	
	//조회조건 설정
	FORM_SEARCH = $("#searchForm").serializeObject();
	
	//그리드 데이터 조회
	fn_getGridData(sqlFlag);
}

//그리드 데이터 조회
function fn_getGridData(sqlFlag) {
	
	FORM_SEARCH.sql	     = sqlFlag;
	FORM_SEARCH._mtd     = "getList";
	FORM_SEARCH.tranData = [{outDs:"rtnList",_siq:"master.popup.reptCustGroupMgmt"}];
	
	gfn_service({
		url    : GV_CONTEXT_PATH + "/biz/obj",
		data   : FORM_SEARCH,
		success: function(data) {
			maxSeq = 0;
			//그리드 데이터 삭제
			dataProvider.clearRows();
			grdMain.cancel();
			//그리드 데이터 생성
			dataProvider.setRows(data.rtnList);
			//그리드 초기화 포인트 저장
			dataProvider.clearSavePoints();
			dataProvider.savePoint();
			// 그리드 데이터 건수 출력
			gfn_setSearchRow(dataProvider.getRowCount());
		}
	}, "obj");
}

//그리드 초기화
function fn_reset() {
	grdMain.cancel();
	dataProvider.rollback(dataProvider.getSavePoints()[0]);
	maxSeq = 0;
}

//그리드 행추가
function fn_add() {
	
	// 최대 시컨스값 조회
	if (maxSeq == 0) {
		maxSeq = fn_getReptCustGroupCodeMaxSeq();
	} 
	
	// 로우추가
	grdMain.commit();
	var rowIdx = dataProvider.getRowCount();
	dataProvider.insertRow(rowIdx, { CUST_GROUP_CNT : 0, REP_CUST_GROUP_CD : "RCG" + gfn_lpad(maxSeq+"", 3, "0"), USE_FLAG:"Y" });
	grdMain.setCurrent({dataRow : rowIdx});
	
	//
	maxSeq++;
}

//삭제
function fn_del() {
	var rows = grdMain.getCheckedRows();
	grdMain.setCellStyles(rows,["REP_CUST_GROUP_CD","REP_CUST_GROUP_NM"],"editFalse");
	dataProvider.removeRows(rows, false);
}

//대표 고객그룹코드 MAX 시컨스 조회
function fn_getReptCustGroupCodeMaxSeq() {
	var rtnSeq;
	gfn_service({
	    async   : false,
	    url     : GV_CONTEXT_PATH + "/biz/obj",
	    data    : {_mtd:"getList",tranData:[{outDs:"rtnSeq",_siq:"master.popup.reptCustGroupMgmtMaxSeq"}]},
	    success :function(data) {
	    	rtnSeq = data.rtnSeq[0].MAX_SEQ;
	    }
	}, "obj");
	return rtnSeq
}

//그리드 저장
function fn_save() {
	
	//수정된 그리드 데이터
	var grdData = gfn_getGrdSavedataAll(grdMain);
	if (grdData.length == 0) {
		alert('<spring:message code="msg.noChangeData"/>');
		return;
	}
	
	//그리드 유효성 검사
	var arrColumn = ["REP_CUST_GROUP_CD","REP_CUST_GROUP_NM","CUST_CATE","EXCEPT_YN"];
	if (!gfn_getValidation(gridInstance,arrColumn)) return;
	
	// 저장
	confirm('<spring:message code="msg.saveCfm"/>', function() {
		
		FORM_SAVE          = {}; //초기화
		FORM_SAVE._mtd     = "saveAll";
		FORM_SAVE.tranData = [{outDs:"saveCnt",_siq:"master.popup.reptCustGroupMgmt", grdData : grdData, custDupChkYn : {"insert":"Y", "update":"Y", "delete":"Y"}}];
		
		gfn_service({
			url    : GV_CONTEXT_PATH + "/biz/obj",
			data   : FORM_SAVE,
			success: function(data) {
				
				if ( data.errCode == -10 || data.errCode == -20 ) {
					var cust_group_cd = dataProvider.getValue(data.errLine-1, "REP_CUST_GROUP_CD")
					var cust_group_nm = dataProvider.getValue(data.errLine-1, "REP_CUST_GROUP_NM")
					alert('<spring:message code="msg.duplicateCheck"/> '+cust_group_cd+' '+cust_group_nm);
					grdMain.setCurrent({dataRow : data.errLine-1, column : "REP_CUST_GROUP_CD"});
				} else if ( data.errCode == -30 ) {
					var custGroup = '<spring:message code="lbl.reptCustGroup"/>';
					var reptCust  = '<spring:message code="lbl.custCust"/>';
					alert(gfn_getDomainMsg("msg.activeCheck2",custGroup+"|"+reptCust));
					grdMain.setCurrent({dataRow : data.errLine-1, column : "REP_CUST_GROUP_CD"});
				} else {
					alert('<spring:message code="msg.saveOk"/>');
					fn_apply();
					if (opener && opener.fn_popupSaveCallback) {
						opener.fn_popupSaveCallback();
					}
				}
			}
		}, "obj");
	});
}


//엑셀, 쿼리 다운로드 권한 확인
function fn_excelSqlAuth() {
  
  gfn_service({
      async   : false,
      url     : GV_CONTEXT_PATH + "/biz/obj",
      data    : {
          _mtd : "getList",
          popUpMenuCd : popUpMenuCd,
          tranData : [
              {outDs : "authorityList", _siq : "master.popup.reptCustGroupMgmtExcelSql"}
          ]
      },
      success :function(data) {
          
          for(i=0;i<data.authorityList.length;i++)
          {
              if(data.authorityList[i].USE_FLAG == "Y"&&data.authorityList[i].ACTION_CD=="EXCEL")
              {
                  $('#excelSqlContainer').show();
                  $("#excel").show();
              }
              else if(data.authorityList[i].USE_FLAG == "Y"&&data.authorityList[i].ACTION_CD=="SQL")
              {
                  $('#excelSqlContainer').show();
                  $("#sql").show();
              }
          }
              
      }
  }, "obj");
}


</script>
<style type="text/css">
.locationext .fnc a {display:inline-block;overflow:hidden;height:27px;margin-left:4px;}
.li_none {list-style-type:none;background:white}
</style>
</head>
<body>
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="keywordpop" class="popupDv">
		<div class="pop_tit"><spring:message code="lbl.reptCustGroupMgmt"/></div>
		<div class="popCont">
			<div class="srhwrap">
				<form id="searchForm" name="searchForm" method="POST" onSubmit="return false;">
					<div class="srhcondi">
						<ul>
							<li>
								<strong><spring:message code="lbl.reptCustGroup"/></strong>
								<div class="selectBox">
									<input type="text" id="reptCustGroup" name="reptCustGroup" value="" class="ipt">
								</div>
							</li>
							<li id="excelSqlContainer" style="display:none;">
                                <div class="locationext">
                                    <div class="fnc">
                                        <a href="#" id='excel' style="display:none" class="viewfnc5"><img src="${ctx}/statics/images/common/btn_gun5.gif" title="Excel Download"></a>
                                        <a href="#" id='sql' style="display:none"class="viewfnc4"><img src="${ctx}/statics/images/common/btn_gun4.gif" title="SQL View"></a>
                                        
                                    </div>
                                </div>
                            </li>
						</ul>
					</div>
				</form>
				<div class="bt_btn">
					<a href="javascript:;" class="fl_app"><spring:message code="lbl.search"/></a>
				</div>
			</div>
			<div id="realgrid" class="realgrid1"></div>
			<div class="pop_btn">
				<a href="javascript:;" id="btnAdd" class="app1 roleWrite"><spring:message code="lbl.add"/></a>
				<a href="javascript:;" id="btnDelete" class="app1 roleWrite"><spring:message code="lbl.delete"/></a>
				<a href="javascript:;" id="btnReset" class="app1"><spring:message code="lbl.reset"/></a>
				<a href="javascript:;" id="btnSave" class="app2 roleWrite"><spring:message code="lbl.save"/></a>
				<a href="javascript:;" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
			</div>
		</div>
	</div>
</body>
</html>