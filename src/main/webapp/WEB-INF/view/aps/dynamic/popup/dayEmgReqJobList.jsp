<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title><spring:message code="lbl.prodOderNo"/></title>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
	<jsp:param name="popupYn" value="Y"/>
</jsp:include>

<script type="text/javascript">
	var popupWidth, popupHeight;
	var popUpMenuCd = "${param.menuCd}";
	var gItemCd     = "${param.itemCd}";
	var gItemNm     = "${param.itemNm}";
	var gItemType   = "${param.itemType}";
	var gItemTypeNm = "${param.itemTypeNm}";
	var gSeq        = "${param.seq}";
	var gPlanId     = "${param.planId}";
	var gEditYn     = "${param.edit_yn}";
	var lv_conFirmFlag = true;
	var dayEmgReqJobList = {
		init : function() {
			gfn_popresize();
			this.comCode.initCode();
			this.initFilter();
			this.grid.initGrid();
			this.events();
			fn_apply();
			
			if(gEditYn == "Y") {
				$("#btnApply").show();
			} else {
				$("#btnApply").hide();
			}
			
		},
		
		_siq    : "aps.dynamic.dayEmgReqJobList",
		
		comCode : {
			codeMapEx : null,
			codeMap   : null,
			initCode  : function() {
				var grpCd      = 'FLAG_YN,ORDER_STATUS';
				this.codeMap   = gfn_getComCode(grpCd, 'Y');
			}
		},
		
		initFilter : function() {
			gfn_setMsComboAll([
				{target : 'divUseFlag'     , id : 'useFlag'     , title : '<spring:message code="lbl.useFlag"/>' , data : this.comCode.codeMap.FLAG_YN, exData:[""], type : "S"},
				{target : 'divOrderStatus' , id : 'orderStatus' , title : '<spring:message code="lbl.orderStatus"/>'  , data : this.comCode.codeMap.ORDER_STATUS, exData:[""]}
			]);
			
			$("#orderStatus").multipleSelect("setSelects", ["OP","RL","ST"]);
			
			$("#useFlag").val("N");
		},
		
		grid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid : function() {
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				
				this.gridInstance.measureHFlag = true;		// 메저 행모드 안보이게..
				this.gridInstance.measureCFlag = true;
				
				this.setColumn();
				this.setOptions();
			},
			
			setColumn : function() {
				var columns = [
					{
						name : "PROD_ORDER_NO", fieldName : "PROD_ORDER_NO", editable : false, header: {text: '<spring:message code="lbl.prodOrderNo3" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						dataType : "text",
						width : 100
					}, {
						name : "ITEM_CD", fieldName : "ITEM_CD", editable : false, header: {text: '<spring:message code="lbl.itemCd" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						dataType : "text",
						width : 120
					}, {
						name : "ITEM_NM", fieldName : "ITEM_NM", editable : false, header: {text: '<spring:message code="lbl.itemName" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						dataType : "text",
						width : 120
					}, {
						name : "SPEC", fieldName : "SPEC", editable : false, header: {text: '<spring:message code="lbl.spec" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						dataType : "text",
						width : 120
					}, {
						name : "ITEM_TYPE", fieldName : "ITEM_TYPE", editable : false, header: {text: '<spring:message code="lbl.itemType" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						dataType : "text",
						width : 80
					}, {
						name : "ITEM_GROUP_NM", fieldName : "ITEM_GROUP_NM", editable : false, header: {text: '<spring:message code="lbl.itemGroupName" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						dataType : "text",
						width : 120
					}, {
						name : "PROD_ORDER_QTY", fieldName : "PROD_ORDER_QTY", editable : false, header: {text: '<spring:message code="lbl.prodOrderQty3" javaScriptEscape="true" />'},
						styles : {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dataType : "number",
						width : 80
					}, {
						name : "REMAIN_QTY", fieldName : "REMAIN_QTY", editable : false, header: {text: '<spring:message code="lbl.remainQty" javaScriptEscape="true" />'},
						styles : {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dataType : "number",
						width : 80
					}, {
						name : "RELEASE_DATE", fieldName : "RELEASE_DATE", editable : false, header: {text: '<spring:message code="lbl.releaseDate2" javaScriptEscape="true" />'},
						styles : {textAlignment: "center", background : gv_noneEditColor},
						dataType : "text",
						width : 80
					}, {
						name : "ORDER_STATUS", fieldName : "ORDER_STATUS", editable : false, header: {text: '<spring:message code="lbl.ordrStatus" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						dataType : "text",
						width : 80
					}, {
						name : "PLAN_DATE_1ST", fieldName : "PLAN_DATE_1ST", editable : false, header: {text: '<spring:message code="lbl.planDate1st" javaScriptEscape="true" />'},
						styles : {textAlignment: "center", background : gv_noneEditColor},
						dataType : "text",
						width : 80
					}, {
						name : "PLAN_QTY_1ST", fieldName : "PLAN_QTY_1ST", editable : false, header: {text: '<spring:message code="lbl.planQty1st" javaScriptEscape="true" />'},
						styles : {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dataType : "number",
						width : 80
					}, {
						name : "PLAN_DATE_2ND", fieldName : "PLAN_DATE_2ND", editable : false, header: {text: '<spring:message code="lbl.planDate2nd" javaScriptEscape="true" />'},
						styles : {textAlignment: "center", background : gv_noneEditColor},
						dataType : "text",
						width : 80
					}, {
						name : "PLAN_QTY_2ND", fieldName : "PLAN_QTY_2ND", editable : false, header: {text: '<spring:message code="lbl.planQty2nd" javaScriptEscape="true" />'},
						styles : {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						dataType : "number",
						width : 80
					}
				];
				
				this.setFields(columns, ["COMPANY_CD", "BU_CD","PLAN_ID","SEQ","CHECK_YN","USE_FLAG"]);
				
				this.grdMain.setColumns(columns); 
			},
			
			setFields : function(cols, hiddenCols) {
				var fields = new Array();
				
				$.each(cols, function(i, v) {
					
					var tFieldName = v.fieldName;
					var tDataType = v.dataType;
					
					fields.push({fieldName : tFieldName, dataType : tDataType});
					
				});
				
				if (hiddenCols !== undefined && hiddenCols.length > 0) {
					for (hid in hiddenCols) {
						fields.push({fieldName : hiddenCols[hid]});
					}
				}
				
				this.dataProvider.setFields(fields);
			},
			
			setOptions : function() {
				this.grdMain.setOptions({
					checkBar: { visible : true },
					stateBar: { visible : true }
				});

				this.dataProvider.setOptions({
					softDeleting : true
				});
				
				this.grdMain.addCellStyles([{
					id         : "editStyle",
					editable   : true,
					background : gv_editColor
				}]);
			}
		},
		
		events : function() {
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("#btnApply").on("click", function(e) {
				dayEmgReqJobList.save();
			});
			
			$("#btnClose" ).on("click", function() { window.close(); });
			
			dayEmgReqJobList.grid.grdMain.onItemChecked = function (grid, itemIndex, checked) {
				grid.setValue(itemIndex, "CHECK_YN", checked ? "Y" : "N");
			};
			
			dayEmgReqJobList.grid.grdMain.onItemAllChecked =  function (grid, checked) {
				
				var data = dayEmgReqJobList.grid.dataProvider.getJsonRows();
				
				$.each(data, function(n, v){
					if(checked){
						grid.setValue(n, "CHECK_YN", checked ? "Y" : "N");
				    }else{
				    	grid.setValue(n, "CHECK_YN", checked ? "Y" : "N");
				    }	
				});
			};
		},
		
		search : function() {
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq}];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						dayEmgReqJobList.grid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						dayEmgReqJobList.grid.grdMain.cancel();
						
						dayEmgReqJobList.grid.dataProvider.setRows(data.resList);
						dayEmgReqJobList.grid.dataProvider.clearSavePoints();
						dayEmgReqJobList.grid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(dayEmgReqJobList.grid.dataProvider.getRowCount());
						//gfn_actionMonthSum(commFacility.grid.gridInstance);
						gfn_setRowTotalFixed(dayEmgReqJobList.grid.grdMain);
						
						dayEmgReqJobList.callback(data.resList);
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		callback : function(resList) {
			$.each(resList, function(n, v){
				var useFlag = v.USE_FLAG;
				
				if(useFlag == "Y") {
					dayEmgReqJobList.grid.grdMain.checkItem(n, true);
				}
			});
		},
		
		save : function() {
			var grdData    = dayEmgReqJobList.grid.dataProvider.getStateRows("updated");
			var grdDataLen = grdData.length;
			
			
			if (grdDataLen == 0) {
				alert('<spring:message code="msg.noChangeData"/>');
				return;
			}
			
			dayEmgReqJobList.saveRowData = [];
			
			$.each(grdData, function(i, row) {
				var rowMap = {
					PLAN_ID       : dayEmgReqJobList.grid.dataProvider.getValue(row, "PLAN_ID"),
					COMPANY_CD    : dayEmgReqJobList.grid.dataProvider.getValue(row, "COMPANY_CD"),
					BU_CD         : dayEmgReqJobList.grid.dataProvider.getValue(row, "BU_CD"),
					ITEM_CD       : dayEmgReqJobList.grid.dataProvider.getValue(row, "ITEM_CD"),
					SEQ           : dayEmgReqJobList.grid.dataProvider.getValue(row, "SEQ"),
					PROD_ORDER_NO : dayEmgReqJobList.grid.dataProvider.getValue(row, "PROD_ORDER_NO"),
					USE_FLAG      : dayEmgReqJobList.grid.dataProvider.getValue(row, "CHECK_YN"),
					state         : "updated"
				};
				
				dayEmgReqJobList.saveRowData.push(rowMap);
			});
			
			
			confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
				
				FORM_SAVE            = {}; //초기화
				FORM_SAVE._mtd       = "saveAll";
				FORM_SAVE.tranData   = [
					{outDs : "saveCnt", _siq : dayEmgReqJobList._siq, grdData : dayEmgReqJobList.saveRowData, mergeFlag : "Y"}
				];
				
				var ajaxOpt = {
					url     : GV_CONTEXT_PATH + "/biz/obj",
					data    : FORM_SAVE,
					success : function(data) {
						
						alert('<spring:message code="msg.saveOk"/>');
						
						if("${param.callback}" != "" && "${param.callback}" != null) {
							//필터 키워드 팝업
							eval("opener.${param.callback}")(dayEmgReqJobList.saveRowData,"${param.rowId}");
						}
						window.close();
					},
				};
				
				gfn_service(ajaxOpt, "obj");
			});
		},
		
		saveRowData : []
	};
	
	var fn_apply = function (sqlFlag) {
		//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
   		
    	dayEmgReqJobList.search();
	}
	
	// onload 
	$(document).ready(function() {
		dayEmgReqJobList.init();
		fn_excelSqlAuth();
		$(".viewfnc5").click("on", function() {
			gfn_doExportExcel({fileNm:"${menuInfo.menuNm}", conFirmFlag: lv_conFirmFlag}); 
			$(".pClose").click(function() {
				console.log(".pClose clicked");
				$("#divTempLayerPopup").hide();
				$(".back").hide();
			});
		    $(".popClose").click(function() {
		    	console.log(".popClose clicked");
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
	
	//엑셀, 쿼리 다운로드 권한 확인
	function fn_excelSqlAuth() {
		
		gfn_service({
		    async   : false,
		    url     : GV_CONTEXT_PATH + "/biz/obj",
		    data    : {
	   			_mtd : "getList",
	   			popUpMenuCd : popUpMenuCd,
	   			tranData : [
	   				{outDs : "authorityList", _siq : "aps.dynamic.dayEmgReqJobListExcelSql"}
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
		<div class="pop_tit"><spring:message code="lbl.baseFacility"/></div>
		<div class="popCont">
			<div class="srhwrap">
				<form id="searchForm" name="searchForm" method="POST" onSubmit="return false;">
				<input type="hidden" id="planId" name="planId" value="${param.planId}" />
				<input type="hidden" id="seq" name="seq" value="${param.seq}" />
				<div class="srhcondi">
				<ul>
					<li>
						<strong class="srhcondipop"><spring:message code="lbl.item"/></strong>
						<div class="selectBox">
							<input type='text' id='itemNm' name='itemNm' class="ipt" style="width:120px;" value="${param.itemNm}" disabled="disabled">
							<input type='hidden' id='itemCd' name='itemCd' class="ipt" style="width:120px;" value="${param.itemCd}">
						</div>
					</li>
					<li>
						<strong class="srhcondipop"><spring:message code="lbl.itemType"/></strong>
						<div class="selectBox">
							<input type='text' id='itemTypeNm' name='itemTypeNm' class="ipt" style="width:120px;" value="${param.itemTypeNm}" disabled="disabled">
							<input type='hidden' id='itemType' name='itemType' class="ipt" style="width:120px;" value="${param.itemType}">
						</div>
					</li>
					<li>
						<strong class="srhcondipop"><spring:message code="lbl.useFlag"/></strong>
						<div class="selectBox">
							<select id="useFlag" name="useFlag"></select>
						</div>
					</li>
					<li>
						<strong class="srhcondipop"><spring:message code="lbl.orderStatus"/></strong>
						<div class="selectBox">
							<select id="orderStatus" name="orderStatus" multiple="multiple"></select>
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
					<a href="#" id="btnSearch" class="fl_app"><spring:message code="lbl.search"/></a>
				</div>
			</div>
			<div id="realgrid" class="realgrid1"></div>
			
		</div>
		<div class="pop_btm">
			<div class="pop_btn_info">
				<strong >Sum  :</strong> <span id="bottom_userSum"></span>
			</div>
			<div class="pop_btn_info">
				<strong >Avg  :</strong> <span id="bottom_userAvg"></span>
			</div>
			<div class="pop_btn" style="display:inline-block;">
				<a href="javascript:;" id="btnApply" class="pbtn pApply"><spring:message code="lbl.save"/></a>
				<a href="javascript:;" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
			</div>
		</div>
	</div>
</body>
</html>