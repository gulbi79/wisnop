<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>

	<script type="text/javascript">

	var enterSearchFlag = "Y";
	var claimStatus = {

		init : function () {
			
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.claimStatusGrid.initGrid();
		},
			
		_siq : "quality.claimStatus",
		
		initFilter : function() {
			//품목대그룹
			var upperItemEvent = {
				childId   : ["itemGroup"],
				childData : [this.comCode.codeMapEx.ITEM_GROUP],
			};
			
			// 콤보박스
			gfn_setMsComboAll([
				{target : 'divUpItemGroup',   id : 'upItemGroup',   title : '<spring:message code="lbl.upperItemGroup"/>', data : this.comCode.codeMapEx.UPPER_ITEM_GROUP, exData:["*"], event: upperItemEvent},
				{target : 'divItemGroup',     id : 'itemGroup',     title : '<spring:message code="lbl.itemGroup"/>',      data : this.comCode.codeMapEx.ITEM_GROUP,     exData:["*"]},
				{target : 'divRoute',         id : 'route',         title : '<spring:message code="Routing"/>',            data : this.comCode.codeMapEx.ROUTING,        exData:["*"]},
				{target : 'divReptItemGroup', id : 'reptItemGroup', title : '<spring:message code="lbl.reptItemGroup"/>',  data : this.comCode.codeMapEx.REP_ITEM_GROUP, exData:["*"]},
				{target : 'divKey',           id : 'keyGroupYn',    title : '<spring:message code="lbl.keyProd"/>',        data : this.comCode.codeMap.KEY_GROUP_YN,     exData:["*"], type : "S"},
			]);
			
			
			MONTHPICKER(null, -2, 0);
			
			//$('#fromMon').monthpicker("option", "minDate", -12);
			$('#toMon')  .monthpicker("option", "maxDate", 0);
			$("#txtClaimW, #txtSalesW, #txtRateW").inputmask("numeric");
		},
		
		/*
		* common Code 
		*/
		comCode : {
			
			codeMap : null,
			codeMapEx : null,
			
			initCode  : function () {
				var grpCd = 'KEY_GROUP_YN,FLAG_YN';
				this.codeMap = gfn_getComCode(grpCd, 'Y'); //공통코드 조회
				this.codeMapEx = gfn_getComCodeEx(["REP_ITEM_GROUP", "ITEM_GROUP", "ROUTING", "UPPER_ITEM_GROUP"], null, {itemType : '10,50' });
			}
		},
	
		/* 
		* grid  선언
		*/
		claimStatusGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");

				this.gridInstance.measureHFlag = true;
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				
				this.events ();
				
				gfn_setMonthSum(claimStatus.claimStatusGrid.gridInstance, false, false, true);
			},
			
			events   : function () {
				this.grdMain.onColumnHeaderClicked = function (grid, column) {
					fn_setChildColumnResize(claimStatus.claimStatusGrid.gridInstance, claimStatus.claimStatusGrid.grdMain, column.name);
				}
			},
			
			gridCallBack : function () {

				var dt = new Date();
				
				$.each(BUCKET.all[0], function(n,v) {
					//if (v.BUCKET_VAL != dt.getFullYear()) {
						fn_setChildColumnResize(claimStatus.claimStatusGrid.gridInstance, claimStatus.claimStatusGrid.grdMain, v.BUCKET_ID);
					//}
				});
				
				$("#realgrid").show();
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
					if(id == "divUpItemGroup"){
						$.each($("#upItemGroup option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divItemGroup"){
						$.each($("#itemGroup option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divRoute"){
						$.each($("#route option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divReptItemGroup"){
						$.each($("#reptItemGroup option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divKey"){
						EXCEL_SEARCH_DATA += $("#keyGroupYn option:selected").text();
					}
				}
			});
			
			EXCEL_SEARCH_DATA += "\n" + $("#view_Her .tlist .tit").html() + " : ";
			EXCEL_SEARCH_DATA += $("#fromMon").val() + " ~ " + $("#toMon").val();
		},
		
		
		// 조회
		search : function () {
			
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq }];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj.do",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						claimStatus.claimStatusGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						claimStatus.claimStatusGrid.grdMain.cancel();
						
						claimStatus.claimStatusGrid.dataProvider.setRows(data.resList);
						claimStatus.claimStatusGrid.dataProvider.clearSavePoints();
						claimStatus.claimStatusGrid.dataProvider.savePoint(); //초기화 포인트 저장
						//gfn_setSearchRow(claimStatus.claimStatusGrid.dataProvider.getRowCount());
						gfn_actionMonthSum(claimStatus.claimStatusGrid.gridInstance);
						gfn_setRowTotalFixed(claimStatus.claimStatusGrid.grdMain);
						claimStatus.claimStatusGrid.gridCallBack();
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		getBucket : function (sqlFlag) {

			var dt = new Date();
			
			var custBucket = function() {
				$.each(BUCKET.all[0], function(n,v) {
					/*
					if (v.BUCKET_VAL != dt.getFullYear()) {
						v.FOLDING_FLAG = 'N'
					} else {
						v.EXPAND_YN = 'N'
						delete v.FOLDING_FLAG
					}
					*/
	                v.FOLDING_FLAG = 'Y';
	                v.EXPAND_YN = 'Y';
				});
				
				$.each(BUCKET.all[1], function(n,v) {
					/*
					if (v.BUCKET_VAL == dt.getFullYear()) {
						BUCKET.all[1].splice(n, 1)
						return true;
					}
					*/
					if (v.TOT_TYPE == "MT") {
						v.TOT_TYPE = "";
						v.TYPE = "group";
					}
				});
			};
			
			var claim = ($.isNumeric($('#txtClaimW').val()) ? Number($('#txtClaimW').val()) : 0);
			var sales = ($.isNumeric($('#txtSalesW').val()) ? Number($('#txtSalesW').val()) : 0);
			var rate  = ($.isNumeric($('#txtRateW').val())  ? Number($('#txtRateW').val())  : 0);
			
			if (claim > 0) {
				MEASURE.user.push({CD : "CLAIM", NM : '<spring:message code="lbl.claimQty"/>' , numberFormat : "#,##0"})
			}
			if (claim == 1) {
				claim = 2;
			} 
			if (sales > 0) {
				MEASURE.user.push({CD : "GI",    NM : '<spring:message code="lbl.salesQty"/>' , numberFormat : "#,##0"})
			}
			if (sales == 1) {
				sales = 2;
			} 
			if (rate > 0) {
				MEASURE.user.push({CD : "RATE",  NM : '<spring:message code="lbl.claimRate"/>', numberFormat : "#,##0"} )
			}
			if (rate == 1) {
				rate = 2;
			} 
			var fromDt = $("#fromMon").val().substring(0, 4) + "0101";
			if (dt.getFullYear() == $("#fromMon").val().substring(0, 4)) {
				fromDt = gfn_replaceAll( $("#fromMon").val(), "-", "")  + "01";
			}
			
			var ajaxMap = {
				fromDate : fromDt,
				toDate   : gfn_replaceAll($("#toMon").val(), "-", "") + "31",
				year     : {isDown: "Y", isUp:"N", upCal:"" , isMt:"Y", isExp:"Y", expCnt:999},
				month    : {isDown: "Y", isUp:"Y", upCal:"Y", isMt:"Y", isExp:"N", expCnt:999},
				sqlId    : ["bucketYear","bucketMonth"]
			};
			
			var allWidth = (claim + sales + rate) ;
			
			gfn_getBucket(ajaxMap, true, custBucket);
			
			if(!sqlFlag) {
				claimStatus.claimStatusGrid.gridInstance.setDraw();
				
				/*
				setTimeout(function () {
					var objGrd  = claimStatus.claimStatusGrid.grdMain;
					var childNm;
					
					$.each(BUCKET.all[0], function(n,v) {
					
						var hCols = objGrd.getColumnProperty(v.BUCKET_ID, "columns");
						objGrd.setColumnProperty(v.BUCKET_ID, "displayWidth", allWidth * hCols.length);
					});

					$.each(BUCKET.all[1], function (i, el) {
						
						if (allWidth > 0) {
							objGrd.setColumnProperty(el.BUCKET_ID, "displayWidth", allWidth);
						} else {
							objGrd.setColumnProperty(el.BUCKET_ID, "visible", false);
						}
						
						var columns = objGrd.getColumnProperty(el.BUCKET_ID, "columns");
						
						for (var i in columns) {
							childNm = columns[i]._name;
							
							if (childNm.indexOf("_CLAIM") > -1) {
								if (claim > 0) {
									objGrd.setColumnProperty(childNm, "displayWidth", claim);
									objGrd.setColumnProperty(childNm, "visible", true);
								} else {
									objGrd.setColumnProperty(childNm, "visible", false);
								}
							}
							
							if (childNm.indexOf("_GI") > -1) {
								if (sales > 0) {
									objGrd.setColumnProperty(childNm, "displayWidth", sales);
									objGrd.setColumnProperty(childNm, "visible", true);
								} else {
									objGrd.setColumnProperty(childNm, "visible", false);
								}
							}
							
							if (childNm.indexOf("_RATE") > -1) {
								if (rate > 0) {
									objGrd.setColumnProperty(childNm, "displayWidth", rate);
									objGrd.setColumnProperty(childNm, "visible", true);
								} else {
									objGrd.setColumnProperty(childNm, "visible", false);
								}
							}
						}
					});
				}, 500);
				*/
			} 
		}
	};

	//조회
	var fn_apply = function (sqlFlag) {
		
		$("#realgrid").hide();
		
		// 디멘젼, 메져
		gfn_getMenuInit();
		
    	claimStatus.getBucket(sqlFlag); //2. 버켓정보 조회
    	
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
   		FORM_SEARCH.hrcyFlag   = true;
   		FORM_SEARCH.dimList    = DIMENSION.user;
   		FORM_SEARCH.meaList    = MEASURE.user;
   		FORM_SEARCH.bucketList = BUCKET.query;
   		FORM_SEARCH.startYear  = $("#fromMon").val().substring(0,4);
        FORM_SEARCH.endYear    = $("#toMon").val().substring(0,4);
   		claimStatus.search();
		claimStatus.excelSubSearch();
	};

	//그리드 접힘 펼침 처리
	function fn_setChildColumnResize(objInstance, objGrd, name) {
		//접힘/펼침모드인지 확인
		var header = objGrd.getColumnProperty(name, "header");
		if (header.text.indexOf(gv_expand) == -1 && header.text.indexOf(gv_folding) == -1) {
			return;
		}

		var visible = false;
		var columns = objGrd.getColumnProperty(name, "columns");
		var chkCnt = -1;
		var cName,subColumns,cDisplayWidth;
		for (var i=columns.length-1; i>=0; i--) {
		
			cName         = columns[i]._name;
			subColumns    =  objGrd.getColumnProperty(cName, "columns");
			visible       = !objGrd.getColumnProperty(cName, "visible");
			cDisplayWidth =  objGrd.getColumnProperty(cName, "displayWidth");
			
			if (isNaN(cDisplayWidth)) cDisplayWidth = objGrd.getColumnProperty(cName, "width"); 
			
			if (cDisplayWidth > 0) {
				chkCnt++;
				if (subColumns) {
					_fn_setChildColumnResize(objInstance,objGrd, cName, !visible);
				}
			}
			if (chkCnt == 0) continue;

			objGrd.setColumnProperty(cName, "visible", visible);
			if (subColumns) {
				_fn_setChildColumnResize(objInstance,objGrd, cName, visible);
			}
		}
		
		var claim = ($.isNumeric($('#txtClaimW').val()) ? Number($('#txtClaimW').val()) : 0);
		var sales = ($.isNumeric($('#txtSalesW').val()) ? Number($('#txtSalesW').val()) : 0);
		var rate  = ($.isNumeric($('#txtRateW').val())  ? Number($('#txtRateW').val())  : 0);
		
		if (claim > 0) {
			if (claim == 1) {
				claim = 2;
			} 
		}
		if (sales > 0) {
			if (sales == 1) {
				sales = 2;
			} 
		}
		if (rate > 0) {
			if (rate == 1) {
				rate = 2;
			} 
		}

		var allWidth = (claim + sales + rate) ;
		
		var tmpWidth = 0;
		var addHTxt  = gv_folding;
		if (visible) {
			addHTxt = gv_expand;
			$.each(objInstance.idMap, function() {
				if (this.key == name) {
					tmpWidth = this.value;
					return false;
				}
			});
		} else {
			var chkColumn = true;
			$.each(objInstance.idMap, function() {
				if (this.key == name) {
					this.value = objGrd.getColumnProperty(name, "displayWidth");
					chkColumn = false;
				}
			});
			if (chkColumn) {
				objInstance.idMap.push({key:name,value:objGrd.getColumnProperty(name, "displayWidth")});
			}
		}

		objGrd.setColumnProperty(name, "displayWidth", tmpWidth + allWidth);

		//헤더텍스트 변경
		var header = objGrd.getColumnProperty(name, "header");
		header.text = (header.text).replace(gv_folding,"").replace(gv_expand,"") + addHTxt;
		objGrd.setColumnProperty(name, "header", header);

	}

	function _fn_setChildColumnResize(objInstance,objGrd, name, isVisible) {
		var chkCnt = -1;
		var visible = isVisible;
		var cName,subColumns,cDisplayWidth;
		var columns = objGrd.getColumnProperty(name, "columns");
		for (var i=columns.length-1; i>=0; i--) {
			cName         = columns[i]._name;
			subColumns    =  objGrd.getColumnProperty(cName, "columns");
			cDisplayWidth =  objGrd.getColumnProperty(cName, "displayWidth");
			
			if (isNaN(cDisplayWidth)) cDisplayWidth = objGrd.getColumnProperty(cName, "width"); 
			
			if (cDisplayWidth > 0) chkCnt++;
			if (chkCnt == 0) continue;

			objGrd.setColumnProperty(cName, "visible", visible);

			if (subColumns) {
				_fn_setChildColumnResize(objInstance,objGrd, cName, visible);
			}
		}
	}

	// onload 
	$(document).ready(function() {
		claimStatus.init();
	});
	
	</script>

</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="a" class="split content split-horizontal">
		<form id="searchForm" name="searchForm">
		<input type="hidden" id="itemType" name="itemType" value="10,50"/> 
		<div id="filterDv">
			<div class="inner">
				<h3>Filter</h3>
				<%@ include file="/WEB-INF/view/common/filterMonthSum.jsp" %> 
				<div class="tabMargin"></div>
				<div class="scroll">
					<!-- <div class="view_combo" id="divProcurType"></div> -->
					<div class="view_combo" id="divUpItemGroup"></div>
					<div class="view_combo" id="divItemGroup"></div>
					<div class="view_combo" id="divRoute"></div>
					<div class="view_combo" id="divReptItemGroup"></div>
					<div class="view_combo" id="divKey"></div>
					<jsp:include page="/WEB-INF/view/common/filterViewHorizonMonth.jsp" flush="false" />
					
					<!-- check box case -->
					<div class="view_combo">
						<strong class="filter_tit">Column Widths</strong>
						<div class="ilist">
							<div class="itit" style="margin-left:5px;"><spring:message code="lbl.claimQty"/></div>
							<input type="text" id="txtClaimW" name="txtClaimW" class="ipt" maxlength="3" value="50" style="width:123px;">
						</div>
						<div class="ilist">
							<div class="itit" style="margin-left:5px;"><spring:message code="lbl.salesQty"/></div>
							<input type="text" id="txtSalesW" name="txtSalesW" class="ipt" maxlength="3" value="50" style="width:123px;">
						</div>
						<div class="ilist">
							<div class="itit" style="margin-left:5px;"><spring:message code="lbl.claimRate"/></div>
							<input type="text" id="txtRateW" name="txtRateW" class="ipt" maxlength="3" value="50" style="width:123px;">
						</div>
					</div>
					
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
			<!-- <div class="use_tit">
				<h3>My Opportunities</h3> <h4>- recently created</h4>
			</div> -->
			<div class="scroll">
				<!-- 그리드영역 -->
				<div id="realgrid" style="width: 100%;" class="realgrid1"></div>
			</div>
		</div>
    </div>
</body>
</html>
