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
	var lv_conFirmFlag = true;
	var popUpMenuCd = "${param.menuCd}";
	var planId      = "${param.planId}";
	var prodPart    = "${param.prodPart}";
	var itemType    = "${param.itemType}";
	var itemGroup   = "${param.itemGroup}";
	var startWeek   = "${param.startWeek}";
	
	
	var workerGroupProdPlanJobList = {
		init : function() {
			gfn_popresize();
			this.grid.initGrid();
			this.events();
			fn_apply();
		},
		
		_siq    : "aps.dynamic.workerGroupProdPlanJobList",
				
		grid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid : function() {
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
								
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
						name : "ORDER_STATUS", fieldName : "ORDER_STATUS", editable : false, header: {text: '<spring:message code="lbl.ordrStatus" javaScriptEscape="true" />(전주 목요일 기준,CLOSE 제외)'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						dataType : "text",
						width : 80
					}, {
                        name : "ORDER_STATUS_RECENT", fieldName : "ORDER_STATUS_RECENT", editable : false, header: {text: '<spring:message code="lbl.ordrStatus" javaScriptEscape="true" />(최신)'},
                        styles : {textAlignment: "near", background : gv_noneEditColor},
                        dataType : "text",
                        width : 80
                    }, 
                    
					
					{
                        name : "SALES_PRICE_KRW", fieldName : "SALES_PRICE_KRW", editable : false, header: {text: '<spring:message code="lbl.unitPrice" javaScriptEscape="true" />'},
                        styles : {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
                        dataType : "number",
                        width : 80
                    }, {
                        name : "PLAN_QTY", fieldName : "PLAN_QTY", editable : false, header: {text: '주간 생산 계획'},
                        styles : {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
                        dataType : "number",
                        width : 80
                    }, {
                        name : "PRE_PROD_QTY", fieldName : "PRE_PROD_QTY", editable : false, header: {text: '주간 생산 실적'},
                        styles : {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
                        dataType : "number",
                        width : 80
                    }
					
					
				];
				
				this.setFields(columns, ["COLOR_FLAG"]);
				
				this.grdMain.setColumns(columns); 
			},
			
			setFields : function(cols, hiddenCols) {
				
				var newDynamicStyles = [
					{
					    criteria : "values['COLOR_FLAG'] = 'N'",
					    styles : "background=" + gv_noneEditColor
					},{
					     criteria: "values['COLOR_FLAG'] = 'Y'",
					     styles : "background=" + gv_requiredColor
					}
				];
				 
				workerGroupProdPlanJobList.grid.grdMain.setStyles({
				    body: {
				        dynamicStyles: newDynamicStyles
				    }
				});
				
				
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
			
			$("#btnClose" ).on("click", function(e) {
				window.close(); 
			});
			
		},
		
		search : function() {
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq}];
			FORM_SEARCH.planId   = planId;
			FORM_SEARCH.prodPart = prodPart;
			FORM_SEARCH.itemType = itemType;
			FORM_SEARCH.itemGroup= itemGroup;
			FORM_SEARCH.startWeek= startWeek;
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj.do",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						workerGroupProdPlanJobList.grid.dataProvider.clearRows(); //데이터 초기화
						
						//그리드 데이터 생성
						workerGroupProdPlanJobList.grid.grdMain.cancel();
						
						workerGroupProdPlanJobList.grid.dataProvider.setRows(data.resList);
						workerGroupProdPlanJobList.grid.dataProvider.clearSavePoints();
						workerGroupProdPlanJobList.grid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(workerGroupProdPlanJobList.grid.dataProvider.getRowCount());
						
						//workerGroupProdPlanJobList.gridCallback(data.resList);
					}
				}
			}
			
			gfn_service(aOption, "obj");
		}/* ,
		
		gridCallback : function(resList) {
			

			var fileds = workerGroupProdPlanJobList.grid.dataProvider.getFields();
			var filedsLen = fileds.length;
			var colorFlagArr = new Array(); 
			
			
			
			$.each(resList, function(i, val){
				
				var colorFlag = val.COLOR_FLAG;
				
				if(colorFlag == "Y"){
					colorFlagArr.push(i);
				}
			});
			
			for (var i = 0; i < filedsLen; i++) {
				
				var fieldName = fileds[i].fieldName;
				var param = fieldName;
				
				workerGroupProdPlanJobList.grid.grdMain.setColumnProperty(param, "styles", {background : gv_noneEditColor, criteria:"row div 1"})
				
			}
		} */
	};
	
	var fn_apply = function (sqlFlag) {
		//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
    	
    	workerGroupProdPlanJobList.search();
	}
	
	// onload 
	$(document).ready(function() {
		workerGroupProdPlanJobList.init();
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
		    url     : GV_CONTEXT_PATH + "/biz/obj.do",
		    data    : {
	   			_mtd : "getList",
	   			popUpMenuCd : popUpMenuCd,
	   			tranData : [
	   				{outDs : "authorityList", _siq : "aps.dynamic.workerGroupProdPlanJobListExcelSql"}
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
				<input type="hidden" id="prodPart" name="prodPart" value="${param.prodPart}" />
				<input type="hidden" id="itemType" name="itemType" value="${param.itemType}" />
				<input type="hidden" id="itemGroup" name="itemGroup" value="${param.itemGroup}" />
				<input type="hidden" id="fromCal" name="fromCal" value="${param.fromCal}" />
				<input type="hidden" id="toCal" name="toCal" value="${param.toCal}" />
				<div class="srhcondi">
				<ul>
					<li>
						<strong class="srhcondipop"><spring:message code="lbl.workplaces"/></strong>
						<div class="selectBox">
							<input type='text' id='workplaces' name='workplaces' class="ipt" style="width:120px;" value="${param.workplaces}" disabled="disabled">
						</div>
					</li>
					<li>
						<strong class="srhcondipop"><spring:message code="lbl.workerGroup"/></strong>
						<div class="selectBox">
							<input type='text' id='workerGroup' name='workerGroup' class="ipt" style="width:120px;" value="${param.workerGroup}" disabled="disabled">
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
				<a href="javascript:;" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
			</div>
		</div>
		
	</div>
</body>
</html>