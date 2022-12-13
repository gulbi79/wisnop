<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>History List</title>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
	<jsp:param name="popupYn" value="Y"/>
</jsp:include>

<script type="text/javascript">
	var popupWidth, popupHeight;
	var agingInventoryAddInfoHistoryList = {
		init : function() {
			gfn_popresize();
			//this.comCode.initCode();
			//this.initFilter();
			this.grid.initGrid();
			this.events();
			//this.baseData();
			fn_apply();
		},
		
		_siq    : "supply.purchase.agingInventoryAddInfoHistoryList",
		
		grid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid : function() {
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				
				this.grdMain.setColumnProperty("REMARKS_SALES", "editor", {type : "multiline"});
				this.grdMain.setColumnProperty("REMARKS_SALES", "style", {textWrap : "normal"});
				
				this.grdMain.setColumnProperty("REMARKS_COMMON", "editor", {type : "multiline"});
				this.grdMain.setColumnProperty("REMARKS_COMMON", "style", {textWrap : "normal"});
				
				this.grdMain.setDisplayOptions({eachRowResizable : true});
				
				this.setColumn();
				this.setOptions();
			},
			
			setColumn : function() {
				var columns = [
					//아이템 코드
					{
						name : "ITEM_CD", 
						fieldName : "ITEM_CD", 
						editable : false, 
						header: {text: '<spring:message code="lbl.item" javaScriptEscape="true" />'},
						styles : {textAlignment: "near"},
						dataType : "text",
						dynamicStyles : [gfn_getDynamicStyle(0)],
						width : 100
					},
					//년월
					{
						name   : "YEARMONTH", 
						fieldName : "YEARMONTH",
						editable : false,
						header: {text: 'YEARMONTH'},
						styles : {textAlignment : "center"},
						editor : {type : "date", datetimeFormat : "yyyy-MM"},
						dynamicStyles : [gfn_getDynamicStyle(0)],
						width  : 100
					},
					//발생사유
					{
						name : "REASON_FOR_OCCURRENCE", 
						fieldName : "REASON_FOR_OCCURRENCE", 
						editable : false, 
						header: {text: '발생사유'},
						styles : {textAlignment: "near"},
						dataType : "text",
						dynamicStyles : [gfn_getDynamicStyle(0)],
						width : 120
					},
					//처리일정
					{
						name   : "SCHED_DT", 
						fieldName : "SCHED_DT",
						editable : false,
						header: {text: '처리일정'},
						styles : {textAlignment : "center"},
						editor : {type: "multiline", textCase: "upper"},
						dynamicStyles : [gfn_getDynamicStyle(0)],
						width  : 100
					},
					//상세정보(영업)
					{
	                	name: "REMARKS_SALES",
	                    fieldName: "REMARKS_SALES",
	                    editable : false,
	                    header: {text: '상세정보(영업)'},
	                    editor       : { type: "multiline", textCase: "upper" },
	                    styles : {textAlignment: "far"},
	                    dynamicStyles : [gfn_getDynamicStyle(0)],
	    				width : 80
	                },
	                //REMARKS
	                {
	                	name: "REMARKS_COMMON",
	                    fieldName: "REMARKS_COMMON",
	                    editable : false,
	                    header: {text: 'REMARK'},
	                    editor       : { type: "multiline", textCase: "upper" },
	                    styles : {textAlignment: "far"},
	                    dynamicStyles : [gfn_getDynamicStyle(0)],
	    				width : 80
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
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						agingInventoryAddInfoHistoryList.grid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						agingInventoryAddInfoHistoryList.grid.grdMain.cancel();
						
						agingInventoryAddInfoHistoryList.grid.dataProvider.setRows(data.resList);
						//agingInventoryAddInfoHistoryList.grid.dataProvider.clearSavePoints();
						//agingInventoryAddInfoHistoryList.grid.dataProvider.savePoint(); //초기화 포인트 저장z
						gfn_setSearchRow(agingInventoryAddInfoHistoryList.grid.dataProvider.getRowCount());
						//gfn_actionMonthSum(commFacility.grid.gridInstance);
						//gfn_setRowTotalFixed(agingInventoryAddInfoHistoryList.grid.grdMain);
						agingInventoryAddInfoHistoryList.grid.grdMain.fitRowHeightAll(0, true);
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
   		
    	agingInventoryAddInfoHistoryList.search();
	}
	
	// onload 
	$(document).ready(function() {
		agingInventoryAddInfoHistoryList.init();
	});
	
	$(window).resize(function() {
		gfn_popresizeSub();
	}).resize();
</script>
</head>

<body>
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="keywordpop" class="popupDv">
		<div class="pop_tit">${param.popupTitle}</div>
		<div class="popCont">
			<div class="srhwrap">
				<form id="searchForm" name="searchForm" method="POST" onSubmit="return false;">
				<input type="hidden" id="yearWeek" name="yearWeek" value="${param.yearMonth }"/>
				<input type="hidden" id="itemCd" name="itemCd" value="${param.itemCd }"/>
				<input type="hidden" id="yearMonth" name="yearMonth" value="${param.yearMonth }"/>
			</div>
			<div id="realgrid" class="realgrid1"></div>
			<div class="pop_btn">
				<%-- <a href="#" id="btnApply" class="pbtn pApply"><spring:message code="lbl.apply"/></a> --%>
				<a href="javascript:;" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
			</div>
		</div>
	</div>
</body>

</html>