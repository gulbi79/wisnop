<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
<script type="text/javascript">
	var enterSearchFlag = "Y";
	
	var prodOvenMapping = {
		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.grid.initGrid();
			this.events();
		},
		
		_siq    : "aps.static.prodOvenMapping",
		
		comCode : {
			codeMapEx : null,
			codeMap   : null,
			initCode  : function() {
				var grpCd      = 'PROD_PART,ANNEALING_ITEM_GROUP_CD,ANNEALING_REPT_ROUTE,FLAG_YN';
				this.codeMap   = gfn_getComCode(grpCd, 'Y'); 
				this.codeMapEx = gfn_getComCodeEx(["APS_OVEN_ROUTING_ID"]);
				this.codeMap.PROD_PART[0].CODE_NM = "";
			}
		},
		
		initFilter : function() {
			// 콤보박스
			gfn_setMsComboAll([
				{target : 'divProdPart'             , id : 'prodPart'             , title : '<spring:message code="lbl.prodPart"/>'          , data : this.comCode.codeMap.PROD_PART         , exData:["*"], type : "S"},
				{target : 'divRoutingId'            , id : 'routingId'            , title : '<spring:message code="lbl.routing"/>', data : this.comCode.codeMapEx.APS_OVEN_ROUTING_ID, exData:[""], option: {allFlag:"Y"}},
				{target : 'divAnnealingItemGroupCd' , id : 'annealingItemGroupCd' , title : '<spring:message code="lbl.annealingItemGroup"/>', data : this.comCode.codeMap.ANNEALING_ITEM_GROUP_CD, exData:[""], option: {allFlag:"Y"}},
				{target : 'divAnnealingReptRoute'   , id : 'annealingReptRoute'   , title : '<spring:message code="lbl.annealingReptRoute"/>', data : this.comCode.codeMap.ANNEALING_REPT_ROUTE, exData:[""], option: {allFlag:"Y"}}
			]);
			
			$("#prodPart").change(function() {
				var newData   = [];
				var selectVal = $("#prodPart").val();
				
				if(selectVal != "") {
					$.each(prodOvenMapping.comCode.codeMapEx.APS_OVEN_ROUTING_ID, function(idx, item) {
						if(selectVal == item.UPPER_CD) {
							newData.push(item);
						}
					});
				} else {
					newData = prodOvenMapping.comCode.codeMapEx.APS_OVEN_ROUTING_ID;
				}
				
				gfn_setMsCombo("routingId", newData, [""], {allFlag:"Y"});
			});
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
				
				this.grdMain.addCellStyles([{
					id         : "editStyle",
					editable   : true,
					background : gv_editColor
				}]);
			}
		},
		
		events : function () {
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("#btnReset").on('click', function (e) {
				prodOvenMapping.grid.grdMain.cancel();
				prodOvenMapping.grid.dataProvider.rollback(prodOvenMapping.grid.dataProvider.getSavePoints()[0]);
				
				$.each(BUCKET.query, function() {
		    		prodOvenMapping.grid.grdMain.setCellStyles(prodOvenMapping.getReset, this.CD, "editStyle");
		    	});
			});
			
			$("#btnSave").on('click', function (e) {
				prodOvenMapping.save();
			});
			
			this.grid.grdMain.onKeyUp = function (grid, key, ctrl, shift, alt) {
				if(key == 46){  //Delete Key
					gfn_selBlockDelete(grid, prodOvenMapping.grid.dataProvider);  
				}
			};
		},
		
		getBucket : function(sqlFlag) {
			var ajaxMap = {
				prodPartCd : $("#searchForm #prodPart").val(),
				sqlId      : ["aps.static.prodOvenMappingBucket"]
			}
			
			gfn_getBucket(ajaxMap, false, fn_getBucketNext(sqlFlag));
		},
		
		excelSubSearch : function (){
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
					if(id == "divProdPart"){
						EXCEL_SEARCH_DATA += $("#prodPart option:selected").text();
					}else if(id == "divItem"){
						EXCEL_SEARCH_DATA += $("#item_nm").val();
					}else if(id == "divRoutingId"){
						
						$.each($("#routingId option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divAnnealingItemGroupCd"){
						$.each($("#annealingItemGroupCd option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divAnnealingReptRoute"){
						$.each($("#annealingReptRoute option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}
				}
			});
			
		},
		
		search : function () {
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq}];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj.do",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						prodOvenMapping.grid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						prodOvenMapping.grid.grdMain.cancel();
						
						prodOvenMapping.grid.dataProvider.setRows(data.resList);
						prodOvenMapping.grid.dataProvider.clearSavePoints();
						prodOvenMapping.grid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(prodOvenMapping.grid.dataProvider.getRowCount());
						
						prodOvenMapping.gridCallback(data.resList);
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		getReset : [],
		
		gridCallback : function(resList) {
			gfn_service({
			    async   : false,
			    url     : GV_CONTEXT_PATH + "/biz/obj.do",
			    data    : {
	    			_mtd : "getList",
	    			tranData : [
	    				{outDs : "authorityList", _siq : this._siq + "Authority"}
	    			]
			    },
			    success :function(data) {
			    	
			    	prodOvenMapping.getReset = [];
			    	
			    	var dataLen = data.authorityList.length;
			    	
			    	for(var i = 0; i < dataLen; i++){
			    		
			    		var menuCd = data.authorityList[i].MENU_CD;
			    		
			    		$.each(resList, function(n, v){
			    			
			    			var prodPart = v.PROD_PART_CD;
			    			if((menuCd == "APS11101" && prodPart == "LAM") || (menuCd == "APS11102" && prodPart == "TEL") || (menuCd == "APS11103" && prodPart == "DIFFUSION") || (menuCd == "APS11104" && prodPart == "MATERIAL")){ 
			    				prodOvenMapping.getReset.push(n);
			    			}
			    		});
			    	}
			    	
			    	$.each(BUCKET.query, function() {
			    		prodOvenMapping.grid.grdMain.setCellStyles(prodOvenMapping.getReset, this.CD, "editStyle");
			    	});
			    	
		    	}
			}, "obj");
		},
		
		save : function() {
			var grdData = gfn_getGrdSavedataAll(this.grid.grdMain);
			
			var grdDataLen = grdData.length;
			if (grdDataLen == 0) {
				alert('<spring:message code="msg.noChangeData"/>');
				return;
			}
			
			var rowData = [];
			
			$.each(grdData, function(i, row) {
				$.each(BUCKET.query, function(n, v) {
					var bucketId     = v.BUCKET_ID;
					var validFlag    = eval("row." + bucketId);
					
					var dataMap = {
						COMPANY_CD           : row.COMPANY_CD,
						BU_CD                : row.BU_CD,
						PROD_PART            : row.PROD_PART_CD,
						ROUTING_ID           : row.ROUTING_ID,
						ANNEALING_ITEM_GROUP_CD : row.ANNEALING_ITEM_GROUP_CD,
						ANNEALING_REPT_ROUTE : row.ANNEALING_REPT_ROUTE,
						RESOURCE_CD          : v.BUCKET_VAL,
						VALID_FLAG           : validFlag,
						state                : row.state
					};
					
					rowData.push(dataMap);
				});
			});
			
			confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
				
				FORM_SAVE            = {}; //초기화
				FORM_SAVE._mtd       = "saveAll";
				FORM_SAVE.tranData   = [
					{outDs : "saveCnt", _siq : prodOvenMapping._siq, grdData : rowData, mergeFlag : "Y"}
				];
				
				var ajaxOpt = {
					url     : GV_CONTEXT_PATH + "/biz/obj.do",
					data    : FORM_SAVE,
					success : function(data) {
						
						alert('<spring:message code="msg.saveOk"/>');
						fn_apply(false);
					},
				};
				
				gfn_service(ajaxOpt, "obj");
			});
		}
	};
	
	//조회
	var fn_apply = function (sqlFlag) {
		var prodPart = $("#searchForm #prodPart").val();
		
		if(prodPart == ""){
			alert('<spring:message code="msg.prodPartMsg"/>');
			return;
		}
		
		// 디멘전 정리
		DIMENSION.user = [];
		DIMENSION.user.push({DIM_CD:"PROD_PART_NM"           , DIM_NM:'<spring:message code="lbl.prodPart2"          />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"ROUTING_ID"             , DIM_NM:'<spring:message code="lbl.routing"          />'  , LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"ANNEALING_ITEM_GROUP_NM", DIM_NM:'<spring:message code="lbl.annealingItemGroup" />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"ANNEALING_REPT_ROUTE_NM", DIM_NM:'<spring:message code="lbl.annealingReptRoute" />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		
		DIMENSION.hidden = [];
    	DIMENSION.hidden.push({CD:"COMPANY_CD"          , dataType:"text"});
    	DIMENSION.hidden.push({CD:"BU_CD"               , dataType:"text"});
    	DIMENSION.hidden.push({CD:"PROD_PART_CD"        , dataType:"text"});
    	DIMENSION.hidden.push({CD:"ROUTING_ID"        , dataType:"text"});
    	DIMENSION.hidden.push({CD:"ANNEALING_ITEM_GROUP_CD", dataType:"text"});
    	DIMENSION.hidden.push({CD:"ANNEALING_REPT_ROUTE", dataType:"text"});
		
		prodOvenMapping.getBucket(sqlFlag);
	}
	
	function fn_getBucketNext(sqlFlag) {
		var param  = {
				prodPartCd : $("#searchForm #prodPart").val()
		};
		
		param._mtd     = "getList";
		param.tranData = [{ outDs : "resList",_siq : "aps.static.prodOvenMappingBucket2"}];
		
		var aOption = {
			url     : GV_CONTEXT_PATH + "/biz/obj.do",
			data    : param,
			success : function (data) {
				gfn_clearArrayObject(BUCKET.query);
				
				BUCKET.push(data.resList);
				BUCKET.query = data.resList;
				
				if (!sqlFlag) {
					for (var i in BUCKET.query) {
						BUCKET.query[i].DATA_TYPE = "text";
					}
					
					prodOvenMapping.grid.gridInstance.setDraw();
					
					$.each(BUCKET.query, function() {
						var col = prodOvenMapping.grid.grdMain.columnByName(this.CD);
						
						prodOvenMapping.grid.grdMain.setColumnProperty(this.CD, "editor", { type: "dropDown", domainOnly: true });
						col.values = gfn_getArrayExceptInDs(prodOvenMapping.comCode.codeMap.FLAG_YN, "CODE_CD", "");
						col.labels = gfn_getArrayExceptInDs(prodOvenMapping.comCode.codeMap.FLAG_YN, "CODE_NM", "");
						
						col.styles = {textAlignment: "center", background : gv_noneEditColor};
						col.lookupDisplay = true;
						
						prodOvenMapping.grid.grdMain.setColumn(col);
					});
				}
				
				
				//조회조건 설정
		    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
		    	FORM_SEARCH.sql        = sqlFlag;
		   		FORM_SEARCH.bucketList = BUCKET.query;
		   		
		   		prodOvenMapping.search();
		   		prodOvenMapping.excelSubSearch();
			}
		}
		
		gfn_service(aOption, "obj");
	}
	
	// onload 
	$(document).ready(function() {
		prodOvenMapping.init();
	});
</script>
</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="a" class="split content split-horizontal">
		<form id="searchForm" name="searchForm">
		<div id="filterDv">
			<div class="inner">
				<h3>Filter</h3>
				<div class="tabMargin"></div>
				<div class="scroll">
					<div class="view_combo" id="divProdPart"></div>
					<div class="view_combo" id="divRoutingId"></div>
					<div class="view_combo" id="divAnnealingItemGroupCd"></div>
					<div class="view_combo" id="divAnnealingReptRoute"></div>
				</div>
				<div class="bt_btn">
					<a href="#" class="fl_app" id="btnSearch"><spring:message code="lbl.search"/></a>
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
				<div id="realgrid" style="width: 100%;" class="realgrid1"></div>
			</div>
			<div class="cbt_btn">
				<div class="bright">
					<a href="javascript:;" id="btnReset" class="app1 roleWrite"><spring:message code="lbl.reset" /></a>
					<a href="javascript:;" id="btnSave"  class="app2 roleWrite"><spring:message code="lbl.save" /></a>
				</div>
			</div>
		</div>
    </div>
</body>
</html>