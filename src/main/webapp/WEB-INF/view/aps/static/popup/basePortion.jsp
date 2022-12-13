<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
	<jsp:param name="popupYn" value="Y"/>
</jsp:include>

<script type="text/javascript">
	var popUpMenuCd = "${param.menuCd}";
	var popupWidth, popupHeight;

	var lv_conFirmFlag = true;
	var basePortion = {
		init : function() {
			gfn_popresize();
			this.comCode.initCode();
			this.initFilter();
			this.grid.initGrid();
			this.events();
			fn_apply();
		},
		
		_siq : "aps.static.basePortion",
		
		mesList : [],
		
		comCode : {
			codeMapEx : null,
			codeMap   : null,
			initCode  : function() {
				var grpCd      = 'PROD_PART';
				this.codeMap   = gfn_getComCode(grpCd, 'Y'); 
				this.codeMapEx = gfn_getComCodeEx(["WORK_PLACES_CD"], null, {commFlag : "Y"});
			}
		},
		
		initFilter : function() {
			var upperWorkPlaces = {
				childId   : ["workplaces"],
				childData : [this.comCode.codeMapEx.WORK_PLACES_CD]
			};
			
			// 콤보박스
			gfn_setMsCombo("prodPart"    , this.comCode.codeMap.PROD_PART  , [""], {}, upperWorkPlaces);
			gfn_setMsCombo("workplaces"  , this.comCode.codeMapEx.WORK_PLACES_CD, ["*"], {width:"180px"});
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
		
		events : function() {
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("#btnReset").on('click', function (e) {
				basePortion.grid.grdMain.cancel();
				basePortion.grid.dataProvider.rollback(basePortion.grid.dataProvider.getSavePoints()[0]);
			});
			
			$("#btnSave").on('click', function (e) {
				basePortion.save();
			});
			
			$("#btnClose" ).on("click", function() { window.close(); });
			
			this.grid.grdMain.onKeyUp = function (grid, key, ctrl, shift, alt) {
				if(key == 46){  //Delete Key
					gfn_selBlockDelete(grid, basePortion.grid.dataProvider, "cols");  
				}
			};
		},
		
		getBucket : function(sqlFlag) {
			for (var i in MEASURE.user) {
				MEASURE.user[i].numberFormat = "#,##0";
				MEASURE.user[i].dataType = "number";
				MEASURE.user[i].measureAlign = "far";
			}
			
			if (!sqlFlag) {
				basePortion.grid.gridInstance.setDraw();
			}
		},
		
		search : function() {
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq}];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						basePortion.grid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						basePortion.grid.grdMain.cancel();
						
						basePortion.grid.dataProvider.setRows(data.resList);
						basePortion.grid.dataProvider.clearSavePoints();
						basePortion.grid.dataProvider.savePoint(); //초기화 포인트 저장
						//gfn_setSearchRow(basePortion.grid.dataProvider.getRowCount());
						//gfn_actionMonthSum(basePortion.grid.gridInstance);
						gfn_setRowTotalFixed(basePortion.grid.grdMain);
						
						basePortion.gridCallback(data.resList);
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		gridCallback : function(resList) {
			var saveYn = $("#saveYn").val();
			
			$.each(MEASURE.user, function(n, v) {
				if(saveYn == "Y") {
					basePortion.grid.grdMain.setColumnProperty(v.CD, "editable", true);
					basePortion.grid.grdMain.setColumnProperty(v.CD, "styles", {"background" : gv_editColor});
				} else {
					basePortion.grid.grdMain.setColumnProperty(v.CD, "editable", false);
					basePortion.grid.grdMain.setColumnProperty(v.CD, "styles", {"background" : gv_noneEditColor});
				}
			});
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
				$.each(MEASURE.user, function(n, v) {
					var prodPart = v.CD;
					var portion  = eval("row." + prodPart);
					
					var dataMap = {
						COMPANY_CD  : row.COMPANY_CD,
						BU_CD       : row.BU_CD,
						PLANT_CD    : row.PLANT_CD,
						RESOURCE_CD : row.RESOURCE_CD,
						PROD_PART   : prodPart,
						PORTION     : portion,
						state       : row.state
					};
					
					rowData.push(dataMap);
				});
			});
			
			confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
				
				FORM_SAVE            = {}; //초기화
				FORM_SAVE._mtd       = "saveAll";
				FORM_SAVE.tranData   = [
					{outDs : "saveCnt", _siq : basePortion._siq, grdData : rowData, mergeFlag : "Y"}
				];
				
				var ajaxOpt = {
					url     : GV_CONTEXT_PATH + "/biz/obj",
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
	
	var fn_apply = function (sqlFlag) {
		fn_getMenuInit();
		
		// 디멘전 정리
		DIMENSION.user = [];
		DIMENSION.user.push({DIM_CD:"PROD_PART_NM", DIM_NM:'<spring:message code="lbl.prodPart2"      />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"WC_CD"       , DIM_NM:'<spring:message code="lbl.workplacesCode" />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"WC_NM"       , DIM_NM:'<spring:message code="lbl.workplacesName" />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"RESOURCE_CD" , DIM_NM:'<spring:message code="lbl.facilityCode"   />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"RESOURCE_NM" , DIM_NM:'<spring:message code="lbl.facilityName"   />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"CAMPUS_NM"   , DIM_NM:'<spring:message code="lbl.campus"         />', LVL:10, DIM_ALIGN_CD:"C", WIDTH:100});
		
		DIMENSION.hidden = [];
    	DIMENSION.hidden.push({CD:"COMPANY_CD"  , dataType:"text"});
    	DIMENSION.hidden.push({CD:"BU_CD"       , dataType:"text"});
    	DIMENSION.hidden.push({CD:"PLANT_CD"    , dataType:"text"});
    	
    	basePortion.getBucket(sqlFlag);
    	
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
    	FORM_SEARCH.dimList    = DIMENSION.user;
   		FORM_SEARCH.meaList    = MEASURE.user;
   		
   		basePortion.search();
	}
	
	function fn_getMenuInit() {
		var params = {};
		params._mtd   = "getList";
		params.tranData = [{outDs:"meaList",_siq : basePortion._siq + "Mea"}];
		gfn_service({
		    async: false,
		    url: GV_CONTEXT_PATH + "/biz/obj",
		    data:params,
		    success:function(data) {
		    	MEASURE.user   = data.meaList;
		    }
		},"obj");
	}
	
	// onload 
	$(document).ready(function() {
		basePortion.init();
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
	   				{outDs : "authorityList", _siq : "aps.static.basePortionExcelSql"}
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
		<div class="pop_tit"><spring:message code="lbl.comPortion"/></div>
		<div class="popCont">
			<div class="srhwrap">
				<form id="searchForm" name="searchForm" method="POST" onSubmit="return false;">
				<div class="srhcondi">
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
			<div class="pop_btn">
				<a href="javascript:;" id="btnReset" class="app1"><spring:message code="lbl.reset"/></a>
				<a href="javascript:;" id="btnSave" class="app2 roleWrite"><spring:message code="lbl.save"/></a>
				<a href="javascript:;" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
			</div>
		</div>
	</div>
</body>
</html>