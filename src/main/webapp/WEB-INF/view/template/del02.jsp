<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp"%>
<script type="text/javascript" src="${ctx}/statics/js/biz/gridcalc.js" ></script>
<!-- BSC 품질 -->
	<script type="text/javascript">

	var enterSearchFlag = "Y";
	var bscGwp = {
		init : function () {
			gfn_formLoad();
			
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.bscGrid.initGrid();
			fn_apply();
			
			MONTHPICKER(null, 0, 0);
			var baseDt = new Date();
			$("#fromMon").monthpicker("option", "maxDate", new Date(baseDt.getFullYear(), baseDt.getMonth(), '01'));
			
		},
			
		_siq    : "bsc.bscGwp",
		
		initFilter : function() {
			/* gfn_setMsComboAll([
				{target : 'divMonthAcc', id : 'rdoAqType', title : '<spring:message code="lbl.monthAccFlag"/>', data : this.comCode.codeMap.MONTH_ACC_TYPE, exData:[""], type : "R"},
				{target : 'divHiddenFlag', id : 'hiddenFlag', title : '<spring:message code="lbl.hiddenFlag"/>', data : this.comCode.codeMap.HIDDEN_CD, exData:[""], type : "R"}
			]);
			
			$(':radio[name=rdoAqType]:input[value="MON"]').attr("checked", true);
			$(':radio[name=hiddenFlag]:input[value="Y"]').attr("checked", true); */
		},
		
		comCode : {
			codeMap : null,
			codeReptMap : null,
			
			initCode : function () {
				/* var grpCd = 'MONTH_ACC_TYPE,HIDDEN_CD';
				this.codeMap = gfn_getComCode(grpCd, 'N'); //공통코드 조회 */
			}
		},
		
		/* 
		* grid  선언
		*/
		bscGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;

				this.setColumn();
				this.setFields();
				this.setOptions();
				//this.gridEvents();
			},
			
			setColumn     : function () {
				//var totAr =  ['BU_NM', 'DIV_NM', 'TEAM_NM', 'PART_NM'];
				var columns = 
				[
					{
						name : "DATA01", fieldName: "DATA01", editable: false, header: {text: 'PO No'},
						styles: {textAlignment: "center", background : gv_noneEditColor},
						dynamicStyles : [gfn_getDynamicStyle(0)],
						mergeRule    : { criteria: "value" },
						width: 80
					}, {
						name : "DATA02", fieldName: "DATA02", editable: false, header: {text: '발주일자'},
						styles: {textAlignment: "center", background : gv_noneEditColor},
						dynamicStyles : [gfn_getDynamicStyle(0)],
						mergeRule    : { criteria: "value" },
						width: 80
					}, {
						name : "DATA03", fieldName: "DATA03", editable: false, header: {text: '발주경과일'},
						styles: {textAlignment: "center", background : gv_noneEditColor},
						dynamicStyles : [gfn_getDynamicStyle(0)],
						mergeRule    : { criteria: "value" },
						width: 80
					}, {
						name : "DATA04", fieldName: "DATA04", editable: false, header: {text: '예상입고일자'},
						styles: {textAlignment: "center", background : gv_noneEditColor},
						dynamicStyles : [gfn_getDynamicStyle(0)],
						mergeRule    : { criteria: "value" },
						width: 80
					}, {
						name : "DATA05", fieldName: "DATA05", editable: false, header: {text: '지연일'},
						styles: {textAlignment: "center", background : gv_noneEditColor},
						dynamicStyles : [gfn_getDynamicStyle(0)],
						mergeRule    : { criteria: "value" },
						width: 80
					}, {
						name : "DATA06", fieldName: "DATA06", editable: false, header: {text: '공급업체'},
						styles: {textAlignment: "center", background : gv_noneEditColor},
						dynamicStyles : [gfn_getDynamicStyle(0)],
						mergeRule    : { criteria: "value" },
						width: 80
					}, {
						name : "DATA07", fieldName: "DATA07", editable: false, header: {text: 'Seq.'},
						styles: {textAlignment: "center", background : gv_noneEditColor},
						dynamicStyles : [gfn_getDynamicStyle(0)],
						width: 80
					}, {
						name : "DATA08", fieldName: "DATA08", editable: false, header: {text: '제품'},
						styles: {textAlignment: "center", background : gv_noneEditColor},
						dynamicStyles : [gfn_getDynamicStyle(0)],
						width: 80
					}, 
				];
				
				this.grdMain.setColumns(columns); 
			},
			
			setFields : function(cols) {
				
				var fields = new Array();
				
				fields = [
					{ fieldName : "DATA01", dataType : "text"},
					{ fieldName : "DATA02", dataType : "text"},
					{ fieldName : "DATA03", dataType : "text"},
					{ fieldName : "DATA04", dataType : "text"},
					{ fieldName : "DATA05", dataType : "text"},
					{ fieldName : "DATA06", dataType : "text"},
					{ fieldName : "DATA07", dataType : "text"},
					{ fieldName : "DATA08", dataType : "text"},
				];
				
				this.dataProvider.setFields(fields);
			},
			
			setOptions : function () {
				this.grdMain.setOptions({
					//stateBar: { visible      : true  },
					sorting : { enabled      : false },
					display : { columnMovable: false }
				});

				this.dataProvider.setOptions({
					softDeleting : true
				});
				
				this.grdMain.addCellStyles([{
					id         : "editStyle",
					editable   : true,
					background : gv_editColor
				}]);
				
				this.grdMain.addCellStyles([{
					id : "fontColorRed"
				  , foreground : "#FF0000"
				}]);
				
				
				/* var group = this.grdMain.columnByName("DIV");
				if (group) {
					var hide = !this.grdMain.getColumnProperty(group, "hideChildHeaders");
					this.grdMain.setColumnProperty(group, "hideChildHeaders", hide);
				} */
				
				/* var valArray = ["EQUALIZATION", "KPI16_WEIGHT_RATE", "KPI16_TARGET_VALUE", "KPI16_TARGET_VALUE_02", "KPI16_RESULT_RATE", "KPI16_BSC_VAL", "DISASTER", "KPI18_WEIGHT_RATE", "KPI18_TARGET_VALUE", "KPI18_RESULT_RATE", "KPI18_BSC_VAL"];
				var valArrayLen = valArray.length;
				
				for(var i = 0; i < valArrayLen; i++){
					var val = valArray[i];
					
					var setHeader = this.grdMain.getColumnProperty(val, "header");
					setHeader.styles = {background: gv_headerColor};
					this.grdMain.setColumnProperty(val, "header", setHeader);
				} */
				
			}
		},
	
		/*
		* event 정의
		*/
		events : function () {
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			
		},
		
		
		// 조회
		search : function () {
			
			var data = [
			{
				"DATA01": "PO-1",
			    "DATA02": "19/09/01",
			    "DATA03": "4",
			    "DATA04": "19/09/03",
			    "DATA05": "+2",
			    "DATA06": "(나)대리점",
			    "DATA07": "1",
			    "DATA08": "Item-2"
			}, {
				"DATA01": "PO-1",
			    "DATA02": "19/09/01",
			    "DATA03": "4",
			    "DATA04": "19/09/03",
			    "DATA05": "+2",
			    "DATA06": "(나)대리점",
			    "DATA07": "2",
			    "DATA08": "Item-9"
			}]
			
			bscGwp.bscGrid.dataProvider.fillJsonData(data, {fillMode: "set"});

			bscGwp.bscGrid.grdMain.setCellStyles([0], "DATA05", "fontColorRed");
			
			/* FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq }];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						bscGwp.bscGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						bscGwp.bscGrid.grdMain.cancel();
						
						bscGwp.bscGrid.dataProvider.setRows(data.resList);
						bscGwp.bscGrid.dataProvider.clearSavePoints();
						bscGwp.bscGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(bscGwp.bscGrid.dataProvider.getRowCount());
						
						bscGwp.bscGrid.gridInstance.setFocusKeys();
						//bscGwp.bscGrid.gridCallback();
					}
				}
			}
			
			gfn_service(aOption, "obj"); */
		}
	};
	

	//조회
	var fn_apply = function (sqlFlag) {
		
		FORM_SEARCH     = $("#searchForm").serializeObject(); //초기화
		FORM_SEARCH.sql = sqlFlag;
		
		bscGwp.search();
	}
	
	// onload 
	$(document).ready(function() {
		bscGwp.init();
	});

	</script>

</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp"%>
	<!-- contents -->
	<div id="a" class="split content split-horizontal">
		<form id="searchForm" name="searchForm">
		<div id="filterDv">
			<div class="inner">
				<h3>Filter</h3>
				<%-- <%@ include file="/WEB-INF/view/common/filterMonthSum.jsp"%> --%>
				<div class="tabMargin"></div>
				<div class="scroll">
					<%-- <div class="view_combo" id="divMonthAcc"></div>
					<div class="view_combo" id="divHiddenFlag"></div>
					<div class="view_combo">
						<div class="tlist">
							<div class="tit"><spring:message code="lbl.month" />  </div>
							<input type="text" id="fromMon" name="fromMon" class="iptdate datepicker2 monthpicker" value="">
						</div>
					</div> --%>
				</div>
				<div class="bt_btn">
					<a href="#" class="fl_app" id="btnSearch"><spring:message code="lbl.search" /></a>
				</div>
			</div>
		</div>
		</form>
	</div>
	
	<div id="b" class="split split-horizontal">
		<!-- contents -->
		<div id="grid1" class="fconbox">
			<%@ include file="/WEB-INF/view/common/commonLocation.jsp"%>
			
			<div class="scroll">
				<!-- 그리드영역 -->
				<div id="realgrid" class="realgrid1"></div>
			</div>
			<!-- 하단버튼 영역 -->
			<div class="cbt_btn roleWrite">	
				<div class="bright">
					<%-- <a id="btnReset"       href="#" class="app1"><spring:message code="lbl.reset" /></a>  
					<a id="btnFilePopup"   href="#" class="app1"><spring:message code="filePopup" /></a> 
					<a id="btnSave"        href="#" class="app2"><spring:message code="lbl.save" /></a> --%>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
