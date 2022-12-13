<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
	<jsp:param name="popupYn" value="Y"/>
</jsp:include>

<script type="text/javascript">
	var popupWidth, popupHeight;
	var facilityMappingProductCatePop = {
		init : function() {
			gfn_popresize();
			//this.comCode.initCode();
			//this.initFilter();
			this.grid.initGrid();
			this.events();
			fn_apply();
		},
		
		_siq : "aps.static.facilityMappingProductCate.toolList",
		
		grid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid : function() {
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				
				//this.gridInstance.measureHFlag = true;		// 메저 행모드 안보이게..
				//this.gridInstance.measureCFlag = true;
				
				this.setOptions();
			},
			
			setOptions : function() {
				this.grdMain.setOptions({
					//checkBar: { visible : true },
					stateBar: { visible : true }
				});

				this.dataProvider.setOptions({
					softDeleting : true
				});
			}
		},
		
		events : function() {
			
			$("#btnClose" ).on("click", function() { window.close(); });
			
		},
		
		
		search : function() {
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq}];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						facilityMappingProductCatePop.grid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						facilityMappingProductCatePop.grid.grdMain.cancel();
						
						facilityMappingProductCatePop.grid.dataProvider.setRows(data.resList);
						facilityMappingProductCatePop.grid.dataProvider.clearSavePoints();
						facilityMappingProductCatePop.grid.dataProvider.savePoint(); //초기화 포인트 저장
						//gfn_setSearchRow(facilityMappingProductCatePop.grid.dataProvider.getRowCount());
						//gfn_actionMonthSum(facilityMappingProductCatePop.grid.gridInstance);
						gfn_setRowTotalFixed(facilityMappingProductCatePop.grid.grdMain);
						
						//facilityMappingProductCatePop.gridCallback(data.resList);
					}
				}
			}
			
			gfn_service(aOption, "obj");
		}
		
		
	};
	
	var fn_apply = function (sqlFlag) {
		//fn_getMenuInit();
		
		// 디멘전 정리
		DIMENSION.user = [];
		DIMENSION.user.push({DIM_CD:"PROD_PART", DIM_NM:'<spring:message code="lbl.prodPart2" />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"PROD_GROUP", DIM_NM:'<spring:message code="lbl.prodItemGroupMst2" />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"PROD_GROUP_DET", DIM_NM:'<spring:message code="lbl.productCateItem" />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"ITEM_CD", DIM_NM:'<spring:message code="lbl.item" />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"ITEM_NM", DIM_NM:'<spring:message code="lbl.itemName" />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:150});
		DIMENSION.user.push({DIM_CD:"SPEC", DIM_NM:'<spring:message code="lbl.spec" />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:150});
		DIMENSION.user.push({DIM_CD:"DRAW_NO", DIM_NM:'<spring:message code="lbl.drawNo" />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:150});
		
    	if (!sqlFlag) {
			facilityMappingProductCatePop.grid.gridInstance.setDraw();
		}
    	
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
    	FORM_SEARCH.dimList    = DIMENSION.user;
   		//FORM_SEARCH.meaList    = MEASURE.user;
   		
   		facilityMappingProductCatePop.search();
	}
	
	// onload 
	$(document).ready(function() {
		facilityMappingProductCatePop.init();
	});
	
	$(window).resize(function() {
		gfn_popresizeSub();
	}).resize();
</script>
</head>
<body>
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="keywordpop" class="popupDv">
		<div class="pop_tit"><spring:message code="lbl.productCateItem2"/></div>
		<div class="popCont">
			<div class="srhwrap">
				<form id="searchForm" name="searchForm" method="POST" onSubmit="return false;">
				<input type="hidden" id="prodItemGroupMst" name="prodItemGroupMst" value="${param.prodItemGroupMst }"/>
				<input type="hidden" id="prodGroupDet" name="prodGroupDet" value="${param.prodGroupDet }"/>
				
				
				<%-- <div class="srhcondi">
				<ul>
					<li>
						<strong class="srhcondipop"><spring:message code="lbl.prodPart2"/></strong>
						<div class="selectBox">
							<select id="prodPart" name="prodPart" multiple="multiple"></select>
						</div>
					</li>
					<li>
						<strong class="srhcondipop"><spring:message code="lbl.workplaces"/></strong>
						<div class="selectBox">
							<select id="workplaces" name="workplaces" multiple="multiple"></select>
						</div>
					</li>
				</ul>
				</div> --%>
				</form>
 				<%-- <div class="bt_btn">
					<a href="#" id="btnSearch" class="fl_app"><spring:message code="lbl.search"/></a>
				</div> --%>
			</div>
			<div id="realgrid" class="realgrid1"></div>
			<div class="pop_btn">
				<%-- <a href="javascript:;" id="btnReset" class="app1"><spring:message code="lbl.reset"/></a>
				<a href="javascript:;" id="btnSave" class="app2 roleWrite"><spring:message code="lbl.save"/></a> --%>
				<a href="javascript:;" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
			</div>
		</div>
	</div>
</body>
</html>