<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	
	<script type="text/javascript">

	var enterSearchFlag = "Y";
	var facilityMappingProductCate = {

		init : function () {
			gfn_formLoad();
			this.auth.search();
			this.comCode.initCode();
			this.initFilter();
			this.grid.initGrid();
			this.events();
		},
			
		_siq    : "aps.static.facilityMappingProductCate.",
		 
		/*
		* common Code 
		*/
		comCode : {
			codeMapEx : null,			
			codeMap : null,
			
			initCode : function () {
				var grpCd = 'PROD_PART,CAMPUS_CD';
				this.codeMap = gfn_getComCode(grpCd, 'Y'); 
				this.codeMapEx = gfn_getComCodeEx(["PROD_ITEM_GROUP_MST", "WORK_PLACES_CD", "PROD_ITEM_GROUP_DETAIL"]);
				
				this.codeMap.PROD_PART[0].CODE_NM = "";
			}
		},
		
		auth : {
			authLam : "N",
			authTel : "N",
			authDif : "N",
			authMat : "N",
			
			search : function() {
				gfn_service({
				    async   : false,
				    url     : GV_CONTEXT_PATH + "/biz/obj",
				    data    : {
		    			_mtd : "getList",
		    			tranData : [
		    				{outDs : "authorityList", _siq : facilityMappingProductCate._siq + "authority"}
		    			]
				    },
				    success :function(data) {
				    	var dataLen = data.authorityList.length;
				    	
				    	for(var i = 0; i < dataLen; i++) {
				    		var menuCd = data.authorityList[i].MENU_CD;
				    		
				    		if(menuCd == "APS10701") {
				    			facilityMappingProductCate.auth.authLam = "Y";
				    		} else if(menuCd == "APS10702") {
				    			facilityMappingProductCate.auth.authTel = "Y";
				    		} else if(menuCd == "APS10703") {
				    			facilityMappingProductCate.auth.authDif = "Y";
				    		} else if(menuCd == "APS10704") {
				    			facilityMappingProductCate.auth.authMat = "Y";
				    		}
				    	}
			    	}
				}, "obj");
			}
		},
		
		initFilter : function() {
			
			//Plan ID
            fn_getPlanId({picketType:"W",planTypeCd:"MP"});
            
			gfn_setMsComboAll([
				{target : 'divProdPart'        , id : 'prodPart'        , title : '<spring:message code="lbl.prodPart"/>'        , data : this.comCode.codeMap.PROD_PART, exData:["*"], type : "S" },
				{target : 'divProdItemGroupMst', id : 'prodItemGroupMst', title : '<spring:message code="lbl.prodItemGroupMst"/>', data : [], exData:["*"], type : "S"},
				{target : 'divProdItemGroupDet', id : 'prodItemGroupDet', title : '<spring:message code="lbl.prodItemGroupDet"/>', data : [], exData:[""]},
				{target : 'divWorkplaces'      , id : 'workplaces'      , title : '<spring:message code="lbl.workplaces"/>'      , data : this.comCode.codeMapEx.WORK_PLACES_CD, exData:[""]},
				{target : 'divCampus'          , id : 'campus'          , title : '<spring:message code="lbl.campus"/>'          , data : this.comCode.codeMap.CAMPUS_CD, exData:[""]}
			]);
			
			$("#prodPart").change(function() {
				var groupMst   = [];
				var workplaces = [];
				
				var selectVal = $("#prodPart").val();
				
				$.each(facilityMappingProductCate.comCode.codeMapEx.PROD_ITEM_GROUP_MST, function(idx, item) {
					if(selectVal == item.UPPER_CD) {
						groupMst.push(item);
					}
				});
				
				$.each(facilityMappingProductCate.comCode.codeMapEx.WORK_PLACES_CD, function(idx, item) {
					if(selectVal == item.UPPER_CD) {
						workplaces.push(item);
					} 
				});
				
				gfn_setMsCombo("prodItemGroupMst", groupMst, ["*"]);
				gfn_setMsCombo("workplaces", workplaces, [""]);
				$("#prodItemGroupMst").change();
			});
			
			$("#prodItemGroupMst").change(function() {
				
				var groupDet = [];
				var selectVal = $("#prodItemGroupMst").val();
				
				$.each(facilityMappingProductCate.comCode.codeMapEx.PROD_ITEM_GROUP_DETAIL, function(idx, item) {
					if(selectVal == item.UPPER_CD) {
						groupDet.push(item);
					}
				});
				
				gfn_setMsCombo("prodItemGroupDet", groupDet, ["*"]);
				
				//divPlanId
				(selectVal =='LAM_CNC')||(selectVal == 'LAM_MCT')||(selectVal == 'TEL_MCT')||(selectVal =='TEL_CNC') ? $("#divPlanId").show():$("#divPlanId").hide()
				
			});
		},
	
		/* 
		* grid  선언
		*/
		grid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				this.gridInstance.totalFlag = true;
				
				this.setOptions();
				
				this.grdMain.onEditRowChanged = function (grid, itemIndex, dataRow, field, oldValue, newValue) {
					if(newValue == 0){
						alert('<spring:message code="msg.zeroMsg"/>');
						grid.setValue(dataRow, field, oldValue);
					}
				};
				
				this.grdMain.onColumnHeaderClicked = function(grid, column, rightClicked){
					
					var dataId = column.name;
					var dataIdLen = dataId.length;
					var dataType = column.type;
					
					if(dataType == "group"){
						gfn_comPopupOpen("BASE_PORTION", {
							rootUrl : "aps/static",
							url     : "facilityMappingProductCatePop",
							width   : 1036,
							height  : 680,
							prodItemGroupMst : $("#prodItemGroupMst").val(),
							prodGroupDet : dataId.substring(1, dataIdLen),
							
						});	
					}
				}
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
				
				this.grdMain.addCellStyles([{
					id         : "editNoneStyle",
					editable   : false
				}]);
				
				this.grdMain.addCellStyles([{
                    id         : "editNoneStyleColorBlue",
                    editable   : false,
                    background : gv_noneEditColor
                    
                }]);
				
				this.grdMain.addCellStyles([{
                    id         : "jigCellFormat",
                    editable   : false,
                    background : gv_noneEditColor,
                    numberFormat: "#,##0.0"
                }]);
                
				
				this.grdMain.setPasteOptions({
					applyNumberFormat: false,
					checkDomainOnly: false,
					checkReadOnly: false,
					commitEdit: true,
					enableAppend: true,
					enabled: true,
					eventEachRow: true,
					fillColumnDefaults: false,
					fillFieldDefaults: false,
					forceColumnValidation: false,
					forceRowValidation: false,
					noDataEvent: false,
					noEditEvent: false,
					selectBlockPaste: true,
					selectionBase: false,
					singleMode: false,
					startEdit: true,
					stopOnError: true,
					throwValidationError: true
				});
			}
		},
	
		/*
		* event 정의
		*/
		events : function () {
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("#btnReset").on('click', function (e) {
				facilityMappingProductCate.grid.grdMain.cancel();
				facilityMappingProductCate.grid.dataProvider.rollback(facilityMappingProductCate.grid.dataProvider.getSavePoints()[0]);
			});
			
			$("#btnSave").on('click', function (e) {
				facilityMappingProductCate.save();
			});
			
			this.grid.grdMain.onKeyUp = function (grid, key, ctrl, shift, alt) {
				if(key == 46){  //Delete Key
					gfn_selBlockDelete(grid, facilityMappingProductCate.grid.dataProvider, "cols"); //컬럼구성  
				}
			};
		},
		
		getBucket : function(sqlFlag, prodPart, prodItemGroupMst, prodItemGroupDet) {
			
			var ajaxMap = {
				prodPart         : prodPart,
				prodItemGroupMst : prodItemGroupMst,
				prodItemGroupDet : prodItemGroupDet.join(","),
				sqlId            : ["aps.static.facilityMappingProductCate.bucketGroup", "aps.static.facilityMappingProductCate.bucketGroupDetail"]
				//sqlId            : ["aps.static.facilityMappingProductCate.bucketGroup"]
			};
			
			gfn_getBucket(ajaxMap);
			
			if (!sqlFlag) {
				
				DIMENSION.hidden = [];
		    	DIMENSION.hidden.push({CD:"COMPANY_CD"  , dataType:"text"});
		    	DIMENSION.hidden.push({CD:"BU_CD"       , dataType:"text"});
		    	DIMENSION.hidden.push({CD:"PLANT_CD"    , dataType:"text"});
		    	DIMENSION.hidden.push({CD:"PROD_PART_CD", dataType:"text"});
		    	DIMENSION.hidden.push({CD:"PROD_GROUP"  , dataType:"text"});
		    	
		    	$.each(BUCKET.query, function(n, v){
		    		
		    		var pBucketId = v.BUCKET_ID;
					var checkBucketId = pBucketId.substring(1, pBucketId.length);
					
					DIMENSION.hidden.push({CD : checkBucketId, dataType : "text"});
					
	                
					
		    	});
				
				facilityMappingProductCate.grid.gridInstance.setDraw();
			
				
			    $.each(BUCKET.query, function(n, v){
                    
                    
                    
                      facilityMappingProductCate.grid.grdMain.setColumnProperty(v.CD, "dynamicStyles", function(grid, index, value) {
                    	  var CATEGORY_CD = grid.getValue(index.itemIndex, "PROD_PART_NM");
                          
                    	  if(CATEGORY_CD == 'NEXT_ADD_REQ_EQUIPT_QTY'||CATEGORY_CD == 'NEXT_WEEK_JIG_REQ_QTY')
                          {
                              if(value > 0)
                              {
                                  return {foreground:"#ff0000"} 
                              }
                              else
                              {
                                  return {foreground:"#0054FF"}                              
                              }
                          }
                        }
                            
                       );//end of setColumnProperty
                       
                }); // end of $.each(BUCKET.query,
				
				
			}
		},
		
		selectProdPart : "",
		
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
					}else if(id == "divProdItemGroupMst"){
						EXCEL_SEARCH_DATA += $("#prodItemGroupMst option:selected").text();
					}else if(id == "divProdItemGroupDet"){
						$.each($("#prodItemGroupDet option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divWorkplaces"){
						$.each($("#workplaces option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divCampus"){
						$.each($("#campus option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divFacility"){
						EXCEL_SEARCH_DATA += $("#resource").val();
					}
				}
			});
		},
		
		// 조회
		search : function () {
			
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq + "list" }];
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						facilityMappingProductCate.grid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						facilityMappingProductCate.grid.grdMain.cancel();
						
						facilityMappingProductCate.grid.dataProvider.setRows(data.resList);
						facilityMappingProductCate.grid.dataProvider.clearSavePoints();
						facilityMappingProductCate.grid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(facilityMappingProductCate.grid.dataProvider.getRowCount());
						//gfn_actionMonthSum(facilityMappingProductCate.grid.gridInstance);
						//gfn_setRowTotalFixed_custom(facilityMappingProductCate.grid.grdMain);
						
						facilityMappingProductCate.gridCallback(data.resList,FORM_SEARCH.prodItemGroupMst);
					}
				}
			}
			
			facilityMappingProductCate.selectProdPart = $("#prodPart").val();
			gfn_service(aOption, "obj");
		},
		
		gridCallback : function (resList,prodItemGroupMst) {
			
			var editYn = false;
			
			if((facilityMappingProductCate.selectProdPart == "LAM" && facilityMappingProductCate.auth.authLam == "Y") || 
					(facilityMappingProductCate.selectProdPart == "TEL" && facilityMappingProductCate.auth.authTel == "Y") || 
					(facilityMappingProductCate.selectProdPart == "DIFFUSION" && facilityMappingProductCate.auth.authDif == "Y") || 
					(facilityMappingProductCate.selectProdPart == "MATERIAL" && facilityMappingProductCate.auth.authMat == "Y")) {
				
				editYn = true;
			}
			
			if(editYn){
				
				if(prodItemGroupMst == "TEL_CNC" ||prodItemGroupMst == "TEL_MCT" ||prodItemGroupMst == "LAM_CNC" ||prodItemGroupMst == "LAM_MCT")
				{	
				    if(resList[0].PROD_PART_NM == 'NEXT_WEEK_JIG_REQ_QTY')
				    {
				    	$.each(BUCKET.query, function(n, v){
                            facilityMappingProductCate.grid.grdMain.setColumnProperty(v.CD, "editable", true);
                            facilityMappingProductCate.grid.grdMain.setColumnProperty(v.CD, "styles", {"background" : gv_editColor});
                            
                            facilityMappingProductCate.grid.grdMain.setCellStyles(0, v.CD, "editNoneStyleColorBlue"); // 차주 JIG 필요수량 
                            facilityMappingProductCate.grid.grdMain.setCellStyles(0, v.CD, "jigCellFormat");          // 차주 JIG 필요수량 
                            facilityMappingProductCate.grid.grdMain.setCellStyles(1, v.CD, "editNoneStyleColorBlue"); // 추가 필요 설비수
                            facilityMappingProductCate.grid.grdMain.setCellStyles(1, v.CD, "jigCellFormat");          // 추가 필요 설비수 
                            
                            
                            facilityMappingProductCate.grid.grdMain.setCellStyles(3, v.CD, "editNoneStyle");          //Total
                        });
				    }
				    else
				    {
				    	$.each(BUCKET.query, function(n, v){
                            facilityMappingProductCate.grid.grdMain.setColumnProperty(v.CD, "editable", true);
                            facilityMappingProductCate.grid.grdMain.setColumnProperty(v.CD, "styles", {"background" : gv_editColor});
                            
                            facilityMappingProductCate.grid.grdMain.setCellStyles(1, v.CD, "editNoneStyle"); //Total
                        });
				    	
				    }
						
				}
				else
				{
					$.each(BUCKET.query, function(n, v){
                        facilityMappingProductCate.grid.grdMain.setColumnProperty(v.CD, "editable", true);
                        facilityMappingProductCate.grid.grdMain.setColumnProperty(v.CD, "styles", {"background" : gv_editColor});
                        
                        facilityMappingProductCate.grid.grdMain.setCellStyles(0, v.CD, "editNoneStyle"); //Total
                    });
					
				}	
					
			}
		},
		
		
		save : function (){
			
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
					var prodGroupDet = v.BUCKET_VAL;
					var jobCd        = gfn_replaceAll(bucketId, "G" + prodGroupDet + "_", "");
					var priority     = eval("row." + bucketId);
					if(row.PROD_PART_NM == 'JIG_HOLDING_QTY')
					{	
						var dataMap = {
							COMPANY_CD     : row.COMPANY_CD,
							BU_CD          : row.BU_CD,
							PLANT_CD       : row.PLANT_CD,
							//RESOURCE_CD    : row.RESOURCE_CD,
							PROD_GROUP     : row.PROD_GROUP,
							PROD_GROUP_DET : prodGroupDet,
							JOB_CD         : jobCd,
							PRIORITY       : priority,
							state          : row.state,
							JIG_HOLDING_QTY: row.PROD_PART_NM
							
						};
					}
					else
					{
						var dataMap = {
	                            COMPANY_CD     : row.COMPANY_CD,
	                            BU_CD          : row.BU_CD,
	                            PLANT_CD       : row.PLANT_CD,
	                            RESOURCE_CD    : row.RESOURCE_CD,
	                            PROD_GROUP     : row.PROD_GROUP,
	                            PROD_GROUP_DET : prodGroupDet,
	                            JOB_CD         : jobCd,
	                            PRIORITY       : priority,
	                            state          : row.state  
	                        };
					}
						
					rowData.push(dataMap);
				});
			});
			confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
					
				FORM_SAVE            = {}; //초기화
				FORM_SAVE._mtd       = "saveAll";
				FORM_SAVE.tranData   = [
					{outDs : "saveCnt", _siq : facilityMappingProductCate._siq + "resourceProdGroup", grdData : rowData, mergeFlag : "Y"}
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

	//조회
	var fn_apply = function (sqlFlag) {
		
		var prodPart         = $("#searchForm #prodPart").val();
		var prodItemGroupMst = $("#searchForm #prodItemGroupMst").val();
		var prodItemGroupDet = $("#searchForm #prodItemGroupDet").multipleSelect('getSelects');
		
		if(prodPart == ""){
			alert('<spring:message code="msg.prodPartMsg"/>');
			return;
		}
		
		if(prodItemGroupMst == ""){
			alert('<spring:message code="msg.productCateMsg"/>');
			return;
		}
		
		// 디멘전 정리
		DIMENSION.user = [];
		DIMENSION.user.push({DIM_CD:"PROD_PART_NM", DIM_NM:'<spring:message code="lbl.prodPart2"      />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"WC_CD"       , DIM_NM:'<spring:message code="lbl.workplacesCode" />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"WC_NM"       , DIM_NM:'<spring:message code="lbl.workplacesName" />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"WC_MGR_NM"   , DIM_NM:'<spring:message code="lbl.workplacesType" />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"RESOURCE_CD" , DIM_NM:'<spring:message code="lbl.facilityCode"   />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"RESOURCE_NM" , DIM_NM:'<spring:message code="lbl.facilityName"   />', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
		DIMENSION.user.push({DIM_CD:"CAMPUS_NM"   , DIM_NM:'<spring:message code="lbl.campus"         />', LVL:10, DIM_ALIGN_CD:"C", WIDTH:100});
		
		// 버켓 조회
		facilityMappingProductCate.getBucket(sqlFlag, prodPart, prodItemGroupMst, prodItemGroupDet);
		
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
    	FORM_SEARCH.dimList    = DIMENSION.user;
   		FORM_SEARCH.bucketList = BUCKET.query;
   		
		facilityMappingProductCate.search();
		facilityMappingProductCate.excelSubSearch();
	}

	// onload 
	$(document).ready(function() {
		facilityMappingProductCate.init();
	});
	
	
	
	//Total Row Fixed
	function gfn_setRowTotalFixed_custom(grdObj) {
	    
	    if (grdObj.getItemCount() == 0) return;
	    
	    var arrCol = grdObj.getColumns();
	    var fCol = "";
	    $.each(arrCol, function(n,v) {
	        if (v.visible) {
	            fCol = v.name;
	            return false;
	        }
	    });
	    
	    var i = -1;
	    for (i=0; i<grdObj.getItemCount(); i++) {
	        if (grdObj.getValue(i, fCol) != gv_total || grdObj.getValue(i, fCol) != 'JIG 보유수량' ||grdObj.getValue(i, fCol) != '차주 JIG 필요수량') {
	            break;
	        }
	    }
	    
	    if(fixFlagCnt == 0){
	        if (i > -1) {
	            var colCount = gfn_getDisplayIndex(grdObj, fCol);
	            gfn_setFixed(grdObj, colCount, 0, i);
	        }
	    }
	}
	
    function fn_getPlanId(pOption) {
        
        try {
            
            if ($("#planId").length == 0) {
                return;
            }
            
            var params = $.extend({
                _mtd     : "getList",
                tranData : [{outDs : "rtnList", _siq : "common.planId"}]
            }, pOption);
            
            gfn_service({
                url     : GV_CONTEXT_PATH + "/biz/obj",
                data    : params,
                async   : false,
                success : function(data) {
                    
                    gfn_setMsCombo("planId", data.rtnList, [""]);
                     
                }
            },"obj");
            
        } catch(e) {console.log(e);}
    }
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
					<div class="view_combo" id="divProdItemGroupMst"></div>
					<div class="view_combo" id="divProdItemGroupDet"></div>
					<div class="view_combo" id="divWorkplaces"></div>
					<div class="view_combo" id="divCampus"></div>
					<div class="view_combo" id="divFacility">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.facility"/></div>
							<input type="text" id="resource" name="resource" class="ipt">
						</div>
					</div>
					<div class="view_combo" id="divPlanId" style="display:none">
                        <div class="ilist">
                            <div class="itit"><spring:message code="lbl.planId"/></div>
                            <div class="iptdv borNone">
                                <select id="planId" name="planId" class="iptcombo"></select>
                            </div>
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
			<div class="scroll">
				<!-- 그리드영역 -->
				<div id="realgrid" style="width: 100%;" class="realgrid1"></div>
			</div>
			<div class="cbt_btn" style="height:25px">
				<div class="bright">
					<a href="javascript:;" id="btnReset" class="app1 roleWrite"><spring:message code="lbl.reset" /></a>
					<a href="javascript:;" id="btnSave" class="app2 roleWrite"><spring:message code="lbl.save" /></a>
				</div>
			</div>
		</div>
    </div>
</body>
</html>
