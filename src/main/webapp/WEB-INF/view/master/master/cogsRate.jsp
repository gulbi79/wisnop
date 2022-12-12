<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	<script type="text/javascript">
	
	//전역변수
	var enterSearchFlag = "Y";
	var codeMap;
	var gridInstance, grdMain, dataProvider;
	
	$(function() {
		gfn_formLoad();		//공통 초기화
		fn_initData();		//데이터 초기화
		fn_initFilter();	//필터 초기화
		fn_initGrid();		//그리드 초기화
		fn_initEvent();		//이벤트 초기화
	});
	
	//데이터 초기화
	function fn_initData() {
		//데이터 조회
		fn_getInitData();
	}
	
	//데이터 조회
	function fn_getInitData() {
		gfn_service({
		    async   : false,
		    url     : GV_CONTEXT_PATH + "/biz/obj.do",
		    data    : {
		    	_mtd:"getList",
		    	tranData:[
		    		{outDs:"infoList",_siq:"master.master.cogsRateInfo"},
		    		{outDs:"teamList",_siq:"master.master.cogsRateTeam"},
		    	]
		    },
		    success :function(data) {
		    	codeMap = {};
		    	codeMap.CURRENCY = data.infoList[0].CURRENCY;
		    	codeMap.UOM      = data.infoList[0].UOM;
		    	codeMap.TEAM_CD  = data.teamList;
		    }
		}, "obj");
	}
	
	//필터 초기화
	function fn_initFilter() {
		
		// 콤보박스
		gfn_setMsComboAll([
			{ target : 'divTeam', id : 'team', title : '<spring:message code="lbl.productionTeam"/>', data : codeMap.TEAM_CD, exData:[] },
		]);
		
		//숫자만입력
		$("#fromAmt,#toAmt").inputmask("numeric");
	}
	
	//그리드 초기화
	function fn_initGrid() {
		//그리드 설정
		gridInstance = new GRID();
		gridInstance.init("realgrid");
		grdMain	     = gridInstance.objGrid;
		dataProvider = gridInstance.objData;
		
		fn_setFields(dataProvider);
		fn_setColumns(grdMain);
		fn_setOptions(grdMain);
		
		grdMain.setOptions({
			sorting : { enabled : false }
		});
	}
	
	//그리드필드
	function fn_setFields(provider) {
		var fields = [
			/* { fieldName : "DIV_CD" }, */
			{ fieldName : "SEQ" },
			{ fieldName : "TEAM_CD" },
			{ fieldName : "CURRENCY" },
			{ fieldName : "UOM" },
			{ fieldName : "FROM_AMT", dataType : "number" },
			{ fieldName : "TO_AMT", dataType : "number" },
			{ fieldName : "COGS_RATE", dataType : "number" },
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
				name         : "TEAM_CD",
				fieldName    : "TEAM_CD",
				editable     : false,
				header       : { text: '<spring:message code="lbl.productionTeam"/>' },
				styles       : { background : gv_noneEditColor, textAlignment: "near" },
				width        : 100,
			},
			{
				name         : "TEAM_CD",
				fieldName    : "TEAM_CD",
				editable     : true,
				header       : { text: '<spring:message code="lbl.productionTeamName"/>' },
				styles       : { textAlignment: "near", background : gv_requiredColor },
				editor       : { type: "dropDown", domainOnly: true },
				values       : gfn_getArrayExceptInDs(codeMap.TEAM_CD, "CODE_CD", ""),
				labels       : gfn_getArrayExceptInDs(codeMap.TEAM_CD, "CODE_NM", ""),
				nanText      : "",
				lookupDisplay: true,
				width        : 150
			},
			{
				name         : "CURRENCY",
				fieldName    : "CURRENCY",
				editable     : false,
				header       : { text: '<spring:message code="lbl.currency"/>' },
				styles       : { background : gv_noneEditColor },
				width        : 80,
			},
			{
				name         : "UOM",
				fieldName    : "UOM",
				editable     : false,
				header       : { text: '<spring:message code="lbl.uom"/>' },
				styles       : { background : gv_noneEditColor },
				width        : 80,
			},
			{
				name         : "FROM_AMT",
				fieldName    : "FROM_AMT",
				editable     : true,
				header       : { text: '<spring:message code="lbl.from"/>' },
				styles       : { textAlignment: "far", numberFormat: "#,###" },
				editor       : { type: "number", positiveOnly: true, editFormat: "#,###" },
				width        : 100,
			},
			{
				name         : "TO_AMT",
				fieldName    : "TO_AMT",
				editable     : true,
				header       : { text: '<spring:message code="lbl.to"/>' },
				styles       : { textAlignment: "far", numberFormat: "#,###" },
				editor       : { type: "number", positiveOnly: true, editFormat: "#,###" },
				width        : 100,
			},
			{
				name         : "COGS_RATE",
				fieldName    : "COGS_RATE",
				editable     : true,
				header       : { text: '<spring:message code="lbl.rate"/> (%)' },
				styles       : { textAlignment: "far", background : gv_requiredColor, numberFormat: "#,###.0" },
				editor       : { type: "number", positiveOnly: true, editFormat: "#,###.0" },
				width        : 80,
			},
			{
				name         : "UPDATE_DTTM",
				fieldName    : "UPDATE_DTTM",
				editable     : false,
				header       : { text: '<spring:message code="lbl.updateDttm"/>' },
				styles       : { background : gv_noneEditColor },
				width        : 120,
			},
			{
				name         : "UPDATE_ID",
				fieldName    : "UPDATE_ID",
				editable     : false,
				header       : { text: '<spring:message code="lbl.updateBy"/>' },
				styles       : { background : gv_noneEditColor, textAlignment: "near" },
				width        : 100,
			},
			{
				name         : "CREATE_DTTM",
				fieldName    : "CREATE_DTTM",
				editable     : false,
				header       : { text: '<spring:message code="lbl.createDttm"/>' },
				styles       : { background : gv_noneEditColor },
				width        : 120,
			},
			{
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
		$("#btnAdd"   ).click("on", function() { fn_add(); });
		$("#btnDelete").click("on", function() { fn_del(); });
		$("#btnReset" ).click("on", function() { fn_reset(); });
		$("#btnSave"  ).click("on", function() { fn_save(); });
	}
	
	//조회
	function fn_apply(sqlFlag) {
		
		//조회조건 설정
		FORM_SEARCH = $("#searchForm").serializeObject();
		
		//그리드 데이터 조회
		fn_getGridData(sqlFlag);
		fn_getExcelData();
	}
	
	//그리드 데이터 조회
	function fn_getGridData(sqlFlag) {
		
		FORM_SEARCH.sql	     = sqlFlag;
		FORM_SEARCH.hrcyFlag = false;
		FORM_SEARCH._mtd     = "getList";
		FORM_SEARCH.tranData = [{outDs:"rtnList",_siq:"master.master.cogsRate"}];
		
		gfn_service({
			url    : GV_CONTEXT_PATH + "/biz/obj.do",
			data   : FORM_SEARCH,
			success: function(data) {
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
	}
	
	//그리드 행추가
	function fn_add() {
		grdMain.commit();
		dataProvider.insertRow(0,{CURRENCY:codeMap.CURRENCY, UOM:codeMap.UOM});
	}

	//삭제
	function fn_del() {
		var rows = grdMain.getCheckedRows();
		dataProvider.removeRows(rows, false);
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
		var arrColumn = ["TEAM_CD","COGS_RATE"];
		if (!gfn_getValidation(gridInstance,arrColumn)) return;
		
		//From ~ To 검사
		for (var i = 0; i < grdData.length; i++) {
			if (grdData[i].FROM_AMT == undefined && grdData[i].TO_AMT == undefined) {
				alert('<spring:message code="msg.dataCheck1"/>');
				grdMain.setCurrent({dataRow : grdData[i]._ROWNUM - 1, column : "FROM_AMT"});
				return;
			}
		}
		
		// 저장
		confirm('<spring:message code="msg.saveCfm"/>', function() {
			
			// set DIV_CD
			/* $.each(grdData, function(i, item) {
				$.each(codeMap.TEAM_CD, function(j, code) {
					if (item.TEAM_CD == code.CODE_CD) {
						item.DIV_CD = code.DIV_CD;
						return false;
					}
				});
			}); */
			
			var saveDataIdx, saveDataList = [];
			$.each(grdData, function(i, item) {
				
				saveDataIdx = -1;
				$.each(saveDataList, function(j, data) {
					/* if (item.DIV_CD == data.DIV_CD && item.TEAM_CD == data.TEAM_CD) { */
					if (item.TEAM_CD == data.TEAM_CD) {
						saveDataIdx = j;
						return false;
					}
				});
				
				if (saveDataIdx == -1) {
					saveDataIdx = saveDataList.length;
					saveDataList.push({
						state   : "updated",
						/* DIV_CD  : item.DIV_CD, */
						TEAM_CD : item.TEAM_CD,
						RATE_LT : []
					});
				}
				
				saveDataList[saveDataIdx].RATE_LT.push({
					state     : item.state,
					_ROWNUM   : item._ROWNUM,
					SEQ       : item.SEQ,
					FROM_AMT  : item.FROM_AMT == undefined ? "NULL" : item.FROM_AMT,
					TO_AMT    : item.TO_AMT   == undefined ? "NULL" : item.TO_AMT,
					COGS_RATE : item.COGS_RATE,
				});
			});
			
			FORM_SAVE          = {}; //초기화
			FORM_SAVE._mtd     = "saveAll";
			FORM_SAVE.tranData = [
				{outDs:"saveCnt1",_siq:"master.master.cogsRate", grdData : saveDataList, custDupChkYn : {"update":"Y"}},
			];
			
			gfn_service({
				url    : GV_CONTEXT_PATH + "/biz/obj.do",
				data   : FORM_SAVE,
				success: function(data) {
					if ( data.errCode == -20 ) {
						alert('<spring:message code="msg.duplicateCheck"/>');
						grdMain.setCurrent({dataRow : data.errpkInt - 1, column : "FROM_AMT"});
					} else {
						alert('<spring:message code="msg.saveOk"/>');
						fn_apply();
					}
				}
			}, "obj");
		});
	}
	
	function fn_checkClose() {
		return gfn_getGrdSaveCount(grdMain) == 0;
	}
	
	function fn_getExcelData(){
		$.each($(".view_combo"), function(i, val){
			
			var temp = "";
			var id = gfn_nvl($(this).attr("id"), "");
			
			if(id != ""){
				
				var name = $("#" + id + " .ilist .itit").html();
				
				//타이틀
				if(i == 0){
					EXCEL_SEARCH_DATA = name + " : ";	
				}else{
					EXCEL_SEARCH_DATA += "\n" + name + " : ";	
				}
				
				//데이터
				if(id == "divTeam"){
					$.each($("#team option:selected"), function(i2, val2){
						
						var txt = gfn_nvl($(this).text(), "");
						
						if(i2 == 0){
							temp = txt;								
						}else{
							temp += ", " + txt;
						}
					});		
					EXCEL_SEARCH_DATA += temp;
				}else if(id == "divFromTo"){
					EXCEL_SEARCH_DATA += $("#fromAmt").val() + " ~ " + $("#toAmt").val();
				}
			}
		});
	}
	
	</script>

</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<!-- left -->
	<div id="a" class="split content split-horizontal">
		<form id="searchForm" name="searchForm">
			<div id="filterDv">
				<div class="inner">
					<h3>Filter</h3>
					<div class="tabMargin"></div>
					<div class="scroll">
						<div class="view_combo" id="divTeam"></div>
						<div class="view_combo" id="divFromTo">
							<div class="ilist">
								<div class="itit"><spring:message code="lbl.fromTo" /></div>
								<input type="text" id="fromAmt" name="fromAmt" class="ipt" style="width:55px"> <span class="ihpen">~</span>
								<input type="text" id="toAmt" name="toAmt" class="ipt" style="width:55px">
							</div> 
						</div>
					</div>
					<div class="bt_btn">
						<a href="javascript:;" class="fl_app"><spring:message code="lbl.search"/></a>
					</div>
				</div>
			</div>
		</form>
	</div>
	<!-- contents -->
	<div id="b" class="split split-horizontal">
		<div id="grid1" class="fconbox">
			<%@ include file="/WEB-INF/view/common/commonLocation.jsp" %>
			<div class="scroll">
				<!-- 그리드영역 -->
				<div id="realgrid" class="realgrid1"></div>
			</div>
			<div class="cbt_btn">
				<div class="bleft"></div>
				<div class="bright">
					<a href="javascript:;" id="btnAdd" class="app1 roleWrite"><spring:message code="lbl.add"/></a>
					<a href="javascript:;" id="btnDelete" class="app1 roleWrite"><spring:message code="lbl.delete"/></a>
					<a href="javascript:;" id="btnReset" class="app1"><spring:message code="lbl.reset"/></a>
					<a href="javascript:;" id="btnSave" class="app2 roleWrite"><spring:message code="lbl.save"/></a>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
