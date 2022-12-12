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
	var lv_conFirmFlag = true;
	var materialPlanRateDetail = {
		init : function() {
			gfn_popresize();
			//this.comCode.initCode();
			//this.initFilter();
			this.grid.initGrid();
			this.events();
			//this.baseData();
			fn_apply();
		},
		
		_siq    : "supply.purchase.materialPlanRateDetailList",
		
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
						name : "ITEM_CD", fieldName : "ITEM_CD", editable : false, header: {text: '<spring:message code="lbl.item" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						dataType : "text",
						dynamicStyles : [gfn_getDynamicStyle(0)],
						width : 100
					}, {
						name : "BP_NM", fieldName : "BP_NM", editable : false, header: {text: '<spring:message code="lbl.bpNm" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						dataType : "text",
						dynamicStyles : [gfn_getDynamicStyle(0)],
						width : 120
					}, {
						name : "CODE_NM", fieldName : "CODE_NM", editable : false, header: {text: '<spring:message code="lbl.expGrQtyInfo" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						dataType : "text",
						dynamicStyles : [gfn_getDynamicStyle(0)],
						width : 120
					}, {
						name : "PO_NO", fieldName : "PO_NO", editable : false, header: {text: '<spring:message code="lbl.estNo" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						dataType : "text",
						dynamicStyles : [gfn_getDynamicStyle(0)],
						width : 120
					}, {
						name : "PO_SEQ", fieldName : "PO_SEQ", editable : false, header: {text: '<spring:message code="lbl.estSeq" javaScriptEscape="true" />'},
						styles : {textAlignment: "center", background : gv_noneEditColor},
						dataType : "text",
						dynamicStyles : [gfn_getDynamicStyle(0)],
						width : 80
					}, {
						name : "ORG_DATE", fieldName : "ORG_DATE", editable : false, header: {text: '<spring:message code="lbl.originalData" javaScriptEscape="true" />'},
						styles : {textAlignment: "center", background : gv_noneEditColor},
						dataType : "text",
						dynamicStyles : [gfn_getDynamicStyle(0)],
						width : 120
					}, {
						name : "SCHED_DATE_ORG", fieldName : "SCHED_DATE_ORG", editable : false, header: {text: '<spring:message code="lbl.schedDate" javaScriptEscape="true" />'},
						styles : {textAlignment: "center", background : gv_noneEditColor},
						dataType : "text",
						dynamicStyles : [gfn_getDynamicStyle(0)],
						width : 120
					}, {
						name : "SCHED_QTY", fieldName: "SCHED_QTY", editable: false, header: {text: '<spring:message code="lbl.schedQty" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 80
					}, {
						name : "GR_QTY", fieldName: "GR_QTY", editable: false, header: {text: '<spring:message code="lbl.expResult" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 80
					}, {
						name : "MOL_QTY", fieldName: "MOL_QTY", editable: false, header: {text: '<spring:message code="lbl.overShort" javaScriptEscape="true" />'},
						dynamicStyles : [gfn_getDynamicStyle(-2)],
						styles: {textAlignment: "far", numberFormat : "#,##0"},
						dataType : "number",
						nanText : "",
						width: 80
					} 
				];
				
				this.setFields(columns, []);
				this.grdMain.setColumns(columns); 
			},
			
			setFields : function(cols, hiddenCols) {
				var fields = new Array();
				
				$.each(cols, function(i, v) {
					
					var tFieldName = v.fieldName;
					var tDataType = v.dataType;
					
					fields.push({fieldName : tFieldName, dataType : tDataType});
					
				});
				
				this.dataProvider.setFields(fields); 
			},
			
			setOptions : function() {
				/* this.grdMain.setOptions({
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
				}]); */
			}
		},
		
		events : function() {
			/* $("#btnSearch").on("click", function(e) {
				fn_apply(false);
			}); */
			
			$("#btnClose").on("click", function() {
				window.close(); 
			});
		},
		
		search : function() {
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq}];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj.do",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						materialPlanRateDetail.grid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						materialPlanRateDetail.grid.grdMain.cancel();
						
						materialPlanRateDetail.grid.dataProvider.setRows(data.resList);
						//materialPlanRateDetail.grid.dataProvider.clearSavePoints();
						//materialPlanRateDetail.grid.dataProvider.savePoint(); //초기화 포인트 저장z
						gfn_setSearchRow(materialPlanRateDetail.grid.dataProvider.getRowCount());
						//gfn_actionMonthSum(commFacility.grid.gridInstance);
						//gfn_setRowTotalFixed(materialPlanRateDetail.grid.grdMain);
					}
				}
			}
			
			gfn_service(aOption, "obj");
		}
	};
	
	var fn_apply = function (sqlFlag) {
		//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql = sqlFlag;
   		
    	materialPlanRateDetail.search();
	}
	
	// onload 
	$(document).ready(function() {
		materialPlanRateDetail.init();
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

	//엑셀, 쿼리 다운로드 권한 확인
	function fn_excelSqlAuth() {
		
		gfn_service({
		    async   : false,
		    url     : GV_CONTEXT_PATH + "/biz/obj.do",
		    data    : {
	   			_mtd : "getList",
	   			popUpMenuCd : popUpMenuCd,
	   			tranData : [
	   				{outDs : "authorityList", _siq : "supply.purchase.materialPlanRateDetailListExcelSql"}
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
		<div class="pop_tit">${param.popupTitle}</div>
		<div class="popCont">
			<div class="srhwrap">
				<form id="searchForm" name="searchForm" method="POST" onSubmit="return false;">
				<input type="hidden" id="yearWeek" name="yearWeek" value="${param.yearWeek }"/>
				<input type="hidden" id="itemCd" name="itemCd" value="${param.itemCd }"/>
				<div class="srhcondi">
						<ul style="float:right;">
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
			<div class="pop_btn">
				<%-- <a href="#" id="btnApply" class="pbtn pApply"><spring:message code="lbl.apply"/></a> --%>
				<a href="javascript:;" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
			</div>
		</div>
	</div>
</body>

</html>