<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
<script type="text/javascript">
	var enterSearchFlag = "Y";
	
	var dayEmgReq = {
		init : function () {
			gfn_formLoad();
			this.auth.search();
			this.comCode.initCode();
			this.initFilter();
			this.grid.initGrid();
			this.events();
		},
		
		_siq    : "aps.dynamic.dayEmgReq",
		
		comCode : {
			codeMapEx : null,			
			codeMap : null,
			
			initCode : function () {
				var grpCd = 'URGENT_STATUS_CD,PROD_PART,URGENT_REASON_CD,FLAG_YN';
				this.codeMap = gfn_getComCode(grpCd, 'Y'); 
				this.codeMapEx = gfn_getComCodeEx(["REP_CUST_GROUP", "CUST_GROUP", "ITEM_GROUP", "ROUTING", "UPPER_ITEM_GROUP"], null, {itemType : "10,50"});
			}
		},
		
		auth : {
			btnAuth : "N",
			authLam : "N",
			authTel : "N",
			authDif : "N",
			authMat : "N",
			authConf : "N",
			
			search : function() {
				gfn_service({
				    async   : false,
				    url     : GV_CONTEXT_PATH + "/biz/obj.do",
				    data    : {
		    			_mtd : "getList",
		    			tranData : [
		    				{outDs : "authorityList", _siq : dayEmgReq._siq + "Authority"}
		    			  , {outDs : "authorityConfirmList", _siq : dayEmgReq._siq + "AuthorityConfirm"}
		    			]
				    },
				    success :function(data) {
				    	
				    	var dataLen = data.authorityList.length;
				    	var authConfirm = data.authorityConfirmList[0].CNT;
				    	
				    	for(var i = 0; i < dataLen; i++) {
				    		var menuCd = data.authorityList[i].MENU_CD;
				    		
				    		if(menuCd == "APS30101") {
				    			dayEmgReq.auth.authLam = "Y";
				    		} else if(menuCd == "APS30102") {
				    			dayEmgReq.auth.authTel = "Y";
				    		} else if(menuCd == "APS30103") {
				    			dayEmgReq.auth.authDif = "Y";
				    		} else if(menuCd == "APS30104") {
				    			dayEmgReq.auth.authMat = "Y";
				    		} else if(menuCd == "APS30105") {
				    			dayEmgReq.auth.btnAuth = "Y";
				    		}
				    	}
				    	
				    	if(dayEmgReq.auth.btnAuth == "Y") {
				    		$("#btnAddChild").show();
				    		$("#btnDeleteRows").show();
				    	} else {
				    		$("#btnAddChild").hide();
				    		$("#btnDeleteRows").hide();
				    	}
				    	
				    	if(authConfirm > 0){
				    		dayEmgReq.auth.authConf = "Y";
				    	}
			    	}
				}, "obj");
			}
		},
		
		initFilter : function() {
			//품목대그룹
			var upperItemEvent = {
				childId   : ["itemGroup"],
				childData : [this.comCode.codeMapEx.ITEM_GROUP],
			};
			
			// 키워드팝업
			gfn_keyPopAddEvent([
				{ target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>' }
			]);
			
	    	//Plan ID
	    	fn_getPlanId({picketType:"W",planTypeCd:"MP"});
			
	    	// 콤보박스
			gfn_setMsComboAll([
				{target : 'divProdPart'    , id : 'prodPart'      , title : '<spring:message code="lbl.prodPart2"/>'     , data : this.comCode.codeMap.PROD_PART, exData:[""]},
				{target : 'divUpItemGroup' , id : 'upItemGroup'   , title : '<spring:message code="lbl.upperItemGroup"/>', data : this.comCode.codeMapEx.UPPER_ITEM_GROUP, exData:["*"], event: upperItemEvent },
				{target : 'divItemGroup'   , id : 'itemGroup'     , title : '<spring:message code="lbl.itemGroup"/>'     , data : this.comCode.codeMapEx.ITEM_GROUP,     exData:["*"] },
				{target : 'divRoute'       , id : 'route'        , title : '<spring:message code="lbl.routing"/>'      , data : this.comCode.codeMapEx.ROUTING,        exData:["*"] },
				{target : 'divRepCustGroup', id : 'reptCustGroup' , title : '<spring:message code="lbl.reptCustGroup"/>' , data : this.comCode.codeMapEx.REP_CUST_GROUP, exData:["*"] },
				{target : 'divCustGroup'   , id : 'custGroup'     , title : '<spring:message code="lbl.custGroup"/>'     , data : this.comCode.codeMapEx.CUST_GROUP,     exData:["*"] },
				{target : 'divUrgentStatus', id : 'urgentStatusCd', title : '<spring:message code="lbl.urgentStatus"/>'  , data : this.comCode.codeMap.URGENT_STATUS_CD, exData:[""]}
			]);
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
				
				this.setColumn();
				this.setOptions();
				
				var imgs = new RealGridJS.ImageList("images1", GV_CONTEXT_PATH + "/statics/images/common/");
			    imgs.addUrls([
			        "ico_srh.png"
			    ]);

			    this.grdMain.registerImageList(imgs);
			    
			    this.grdMain.setColumnProperty("PROD_ORDER_NO", "imageList", "images1");
			    this.grdMain.setColumnProperty("PROD_ORDER_NO", "renderer", {type : "icon"}); 
				
			    this.grdMain.setColumnProperty("PROD_ORDER_NO", "styles", {
				    textAlignment: "center",
				    iconIndex: 0,
				    iconLocation: "right",
				    iconAlignment: "center",
				    iconOffset: 4,
				    iconPadding: 2
				}); 
			},
			
			setColumn : function() {
				var columns = [
					{
						name : "PROD_PART_NM", fieldName : "PROD_PART_NM", editable : false, header: {text: '<spring:message code="lbl.prodPart2" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						width : 120
					}, {
						name : "ITEM_CD", fieldName : "ITEM_CD", editable : false, header: {text: '<spring:message code="lbl.itemCd" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						width : 120
					}, {
						name : "ITEM_NM", fieldName : "ITEM_NM", editable : false, header: {text: '<spring:message code="lbl.itemName" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						width : 120
					}, {
						name : "SPEC", fieldName : "SPEC", editable : false, header: {text: '<spring:message code="lbl.spec" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						width : 120
					}, {
						name : "ROUTING_ID", fieldName : "ROUTING_ID", editable : false, header: {text: '<spring:message code="lbl.routing" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						width : 120
					}, {
						name : "UPPER_ITEM_GROUP_NM", fieldName : "UPPER_ITEM_GROUP_NM", editable : false, header: {text: '<spring:message code="lbl.upperItemGroupName" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						width : 120
					}, {
						name : "ITEM_GROUP_NM", fieldName : "ITEM_GROUP_NM", editable : false, header: {text: '<spring:message code="lbl.itemGroupName" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						width : 120
					}, {
						name : "ITEM_GRADE", fieldName : "ITEM_GRADE", editable : false, header: {text: '<spring:message code="lbl.itemGrade" javaScriptEscape="true" />'},
						styles : {textAlignment: "center", background : gv_noneEditColor},
						width : 120
					}, {
						name : "REP_CUST_GROUP_NM", fieldName : "REP_CUST_GROUP_NM", editable : false, header: {text: '<spring:message code="lbl.reptCustGroupName" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						width : 120
					}, {
						name : "CUST_GROUP_NM", fieldName : "CUST_GROUP_NM", editable : false, header: {text: '<spring:message code="lbl.custGroupName" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						width : 120
					}, {
						name : "URGENT_REASON_CD", fieldName : "URGENT_REASON_CD", editable : false, header: {text: '<spring:message code="lbl.urgentReasonCd" javaScriptEscape="true" />'},
						styles : {textAlignment: "center", background : gv_noneEditColor},
						width  : 120,
						editor : { type: "dropDown", domainOnly: true },
						values : gfn_getArrayExceptInDs(dayEmgReq.comCode.codeMap.URGENT_REASON_CD, "CODE_CD", ""),
						labels : gfn_getArrayExceptInDs(dayEmgReq.comCode.codeMap.URGENT_REASON_CD, "CODE_NM", ""),
						lookupDisplay: true
					}, {
						name : "DUE_DATE", fieldName : "DUE_DATE", editable : false, header: {text: '<spring:message code="lbl.dueDate" javaScriptEscape="true" />'},
						styles : {textAlignment: "center", background : gv_noneEditColor, datetimeFormat : "yyyy-MM-dd"},
						editor : {
							type : "date", 
							mask : {editMask : "9999-99-99", placeHolder : "yyyy-MM-dd", includedFormat : true}, 
							datetimeFormat : "yyyy-MM-dd",
							minDate : getAddDay(1)
						},
						width : 120
					}, {
						name : "REQ_QTY", fieldName : "REQ_QTY", editable : false, header: {text: '<spring:message code="lbl.reqQty2" javaScriptEscape="true" />'},
						editor : { type : "number", textAlignment : "far", editFormat : "#,##0", integerOnly : true},
						styles : {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						width : 120
					}, {
						name : "URGENT_REASON", fieldName : "URGENT_REASON", editable : false, header: {text: '<spring:message code="lbl.urgentReason2" javaScriptEscape="true" />'},
						editor : {type : "text", maxLength : 50},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						width : 120
					}, {
						name : "CREATE_NM", fieldName : "CREATE_NM", editable : false, header: {text: '<spring:message code="lbl.regUserNm" javaScriptEscape="true" />'},
						styles : {textAlignment: "center", background : gv_noneEditColor},
						width : 120
					}, {
						name : "CREATE_DTTM", fieldName : "CREATE_DTTM", editable : false, header: {text: '<spring:message code="lbl.regDttm" javaScriptEscape="true" />'},
						styles : {textAlignment: "center", background : gv_noneEditColor},
						width : 120
					}, {
						name : "CONFIRM_YN", fieldName : "CONFIRM_YN", editable : false, header: {text: '<spring:message code="lbl.confirmYn2" javaScriptEscape="true" />'},
						styles : {textAlignment: "center", background : gv_noneEditColor},
						width  : 80,
						editor : { type: "dropDown", domainOnly: true },
						values : gfn_getArrayExceptInDs(dayEmgReq.comCode.codeMap.FLAG_YN, "CODE_CD", ""),
						labels : gfn_getArrayExceptInDs(dayEmgReq.comCode.codeMap.FLAG_YN, "CODE_NM", ""),
						lookupDisplay: true
					}, {
						name : "URGENT_STATUS_CD", fieldName : "URGENT_STATUS_CD", editable : false, header: {text: '<spring:message code="lbl.urgentStatus" javaScriptEscape="true" />'},
						styles : {textAlignment: "center", background : gv_noneEditColor},
						width  : 120,
						editor : { type: "dropDown", domainOnly: true },
						values : gfn_getArrayExceptInDs(dayEmgReq.comCode.codeMap.URGENT_STATUS_CD, "CODE_CD", ""),
						labels : gfn_getArrayExceptInDs(dayEmgReq.comCode.codeMap.URGENT_STATUS_CD, "CODE_NM", ""),
						lookupDisplay: true
					}, {
						name : "PROD_ORDER_QTY", fieldName : "PROD_ORDER_QTY", editable : false, header: {text: '<spring:message code="lbl.prodOrderQty2" javaScriptEscape="true" />'},
						editor : { type : "number", textAlignment : "far", editFormat : "#,##0", integerOnly : true},
						styles : {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						width : 120
					}, {
						name : "RESULT_QTY", fieldName : "RESULT_QTY", editable : false, header: {text: '<spring:message code="lbl.resultQty" javaScriptEscape="true" />'},
						editor : { type : "number", textAlignment : "far", editFormat : "#,##0", integerOnly : true},
						styles : {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						width : 120
					}, {
						name : "PROD_ODER_CNT", fieldName : "PROD_ODER_CNT", editable : false, header: {text: '<spring:message code="lbl.prodOderCnt" javaScriptEscape="true" />'},
						editor : { type : "number", textAlignment : "far", editFormat : "#,##0", integerOnly : true},
						styles : {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
						width : 120
					}, {
						name : "PROD_ORDER_NO", fieldName : "PROD_ORDER_NO", editable : false, header: {text: '<spring:message code="lbl.prodOderNo" javaScriptEscape="true" />'},
						styles : {textAlignment: "center", background : gv_noneEditColor},
						width : 120
					}, {
						name : "REMARK", fieldName : "REMARK", editable : false, header: {text: '<spring:message code="lbl.remark" javaScriptEscape="true" />'},
						styles : {textAlignment: "near", background : gv_noneEditColor},
						width : 120
					}, {
						name : "ACCEPT_NM", fieldName : "ACCEPT_NM", editable : false, header: {text: '<spring:message code="lbl.acceptNm" javaScriptEscape="true" />'},
						styles : {textAlignment: "center", background : gv_noneEditColor},
						width : 120
					}, {
						name : "ACCEPT_DTTM", fieldName : "ACCEPT_DTTM", editable : false, header: {text: '<spring:message code="lbl.acceptDttm" javaScriptEscape="true" />'},
						styles : {textAlignment: "center", background : gv_noneEditColor},
						width : 120
					}, {
                        name : "CONF_DATE", fieldName : "CONF_DATE",  header: {text: '협의일자'},
                        styles : {textAlignment: "center", background : gv_noneEditColor, datetimeFormat : "yyyy-MM-dd"},
                        editor : {
                            type : "date", 
                            mask : {editMask : "9999-99-99", placeHolder : "yyyy-MM-dd", includedFormat : true}, 
                            datetimeFormat : "yyyy-MM-dd",
                        },
                        width : 120,
                        visible: true,
                        dynamicStyles: function(grid, index, value) {
                      	   var ret = {};
                      	   var col1Value = grid.getValue(index.itemIndex, "DID_WRITE_YN");
                      	   
                      	   if(col1Value == 'Y')
                      	   {
                      		   ret.editable   = false;
                      		   ret.background = '#EAEAEA'
                      	   }	    
                      	   else
                      	   {
                               ret.editable = true;                      		  
                               ret.background = '#F5F6CE'
                      	   }
                      	   
                      	   return ret;
                      	  }
                    }, {
                        name : "DID_WRITE_YN", fieldName : "DID_WRITE_YN", editable : false, header: {text: '협의일자 입력여부'},
                        styles : {textAlignment: "near"},
                        width : 120,
                        visible: false
                    }
					
				];
				
				this.setFields(columns, ["COMPANY_CD", "BU_CD", "PLAN_ID", "PROD_PART_CD", "ITEM_GROUP_CD", "REP_CUST_GROUP_CD","CUST_GROUP_CD","SEQ","CREATE_ID","CREATE_YN","ITEM_TYPE","ITEM_TYPE_NM"]);
				
				this.grdMain.setColumns(columns); 
			},
			
			setFields : function(cols, hiddenCols) {
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
				this.grdMain.setOptions({
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
				}]);
				
				this.grdMain.addCellStyles([{
					id         : "editNoneStyle",
					editable   : false,
					background : gv_noneEditColor
				}]);
				
				this.grdMain.setPasteOptions({
					applyNumberFormat: false,
					checkDomainOnly: false,
					checkReadOnly: true,
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
		
		events : function () {
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("#btnReset").on('click', function (e) {
				dayEmgReq.grid.grdMain.cancel();
				dayEmgReq.grid.dataProvider.rollback(dayEmgReq.grid.dataProvider.getSavePoints()[0]);
				
				// 추가건 초기화
				dayEmgReq.grid.grdMain.setCellStyles(dayEmgReq.getReset.resetAdd, "URGENT_REASON_CD", "editStyle");
				dayEmgReq.grid.grdMain.setCellStyles(dayEmgReq.getReset.resetAdd, "DUE_DATE", "editStyle");
				dayEmgReq.grid.grdMain.setCellStyles(dayEmgReq.getReset.resetAdd, "REQ_QTY", "editStyle");
				dayEmgReq.grid.grdMain.setCellStyles(dayEmgReq.getReset.resetAdd, "URGENT_REASON", "editStyle");
				
				// 조회건 초기화
				dayEmgReq.grid.grdMain.setCellStyles(dayEmgReq.getReset.resetSearch, "URGENT_REASON_CD", "editStyle");
				dayEmgReq.grid.grdMain.setCellStyles(dayEmgReq.getReset.resetSearch, "DUE_DATE", "editStyle");
				dayEmgReq.grid.grdMain.setCellStyles(dayEmgReq.getReset.resetSearch, "REQ_QTY", "editStyle");
				dayEmgReq.grid.grdMain.setCellStyles(dayEmgReq.getReset.resetSearch, "URGENT_REASON", "editStyle");
				
				// 파트 담당자 초기화
				dayEmgReq.grid.grdMain.setCellStyles(dayEmgReq.getReset.resetPart, "URGENT_STATUS_CD", "editStyle");
				dayEmgReq.grid.grdMain.setCellStyles(dayEmgReq.getReset.resetPart, "REMARK", "editStyle");
			});
			
			$("#btnSave").on('click', function (e) {
				dayEmgReq.save();
			});
			
			$("#btnAddChild").on('click', function (e) {
				dayEmgReq.addRow();
			});
			
			$("#btnDeleteRows").on('click', function (e) {
				var delCheck = "";
				var rows = dayEmgReq.grid.grdMain.getCheckedRows();
				
				$.each(rows,function (n,v) {
		    		var urgentStatusCd = dayEmgReq.grid.dataProvider.getValue(v, "URGENT_STATUS_CD");
		    		var createYn       = dayEmgReq.grid.dataProvider.getValue(v, "CREATE_YN");
		    		
		    		if(createYn == "Y") {
		    			if(urgentStatusCd != "NEW" && urgentStatusCd != undefined) {
		    				dayEmgReq.grid.grdMain.checkItem(v, false);
		    			} else {
		    				dayEmgReq.grid.dataProvider.setRowState(v, "deleted", true);
		    			}
		    		} else {
		    			dayEmgReq.grid.grdMain.checkItem(v, false);
		    		}
		    	});
				
			});
			
			this.grid.grdMain.onKeyUp = function (grid, key, ctrl, shift, alt) {
				if(key == 46){  //Delete Key
					gfn_selBlockDelete(grid, dayEmgReq.grid.dataProvider, "cols");  
				}
			};
			
			this.grid.grdMain.onDataCellClicked = function (grid, index) {
		    	var rowId     = index.itemIndex;
	       		var field     = index.fieldName;
	       		
	       		if(field == "PROD_ORDER_NO") {
	       			
	       			var urgentStatusCd = grid.getValue(rowId, "URGENT_STATUS_CD");
	       			var state = dayEmgReq.grid.dataProvider.getRowState(rowId);
	       			
	       			var arrColStyle = grid.getCellApplyStyles(rowId, "URGENT_STATUS_CD");
	    		    var edit_yn     = arrColStyle.editable;
	    		    
	       			if(state == "none") {
		    		    
	       				if(urgentStatusCd == "APPLY") {
			       			var itemCd     = grid.getValue(rowId, "ITEM_CD");
			       			var itemNm     = grid.getValue(rowId, "ITEM_NM");
			       			var seq        = grid.getValue(rowId, "SEQ");
			       			var itemType   = grid.getValue(rowId, "ITEM_TYPE");
			       			var itemTypeNm = grid.getValue(rowId, "ITEM_TYPE_NM");
			       			var planId     = grid.getValue(rowId, "PLAN_ID");
			       			
			       			gfn_comPopupOpen("JOB_LIST", {
								rootUrl    : "aps/dynamic",
								url        : "dayEmgReqJobList",
								width      : 1200,
								height     : 680,
								itemCd     : itemCd,
								itemNm     : itemNm,
								itemType   : itemType,
								itemTypeNm : itemTypeNm,
								seq        : seq,
								planId     : planId,
								edit_yn    : edit_yn==true?"Y":"N",
								menuCd     : "APS301",
								callback   : "fnJobListCallback",
								rowId      : rowId
							});
			       		} else {
			       			if(edit_yn) {
			       				alert('<spring:message code="msg.dayEmgReqCheck"/>');
			       			} else {
			       				alert('<spring:message code="msg.unauthorized"/>');
			       			}
			       		}
	       			} else {
	       				if(edit_yn) {
	       					alert('<spring:message code="msg.dataSave"/>');
	       				} else {
	       					alert('<spring:message code="msg.unauthorized"/>');
	       				}
	       			}
	       		}
		    };
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
						
					if(id == "divPlanId"){
						EXCEL_SEARCH_DATA += $("#planId option:selected").text();
					}else if(id == "divProdPart"){
						$.each($("#prodPart option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divItem"){
						EXCEL_SEARCH_DATA += $("#item_nm").val();
					}else if(id == "divUpItemGroup"){
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
					}else if(id == "divRepCustGroup"){
						$.each($("#reptCustGroup option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divCustGroup"){
						$.each($("#custGroup option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divUrgentStatus"){
						$.each($("#urgentStatusCd option:selected"), function(i2, val2){
							
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
		
		search : function (rowId) {
			
			
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq}];
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj.do",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						
						 
						 
						dayEmgReq.grid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						dayEmgReq.grid.grdMain.cancel();
						
						dayEmgReq.grid.dataProvider.setRows(data.resList);
						dayEmgReq.grid.dataProvider.clearSavePoints();
						dayEmgReq.grid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(dayEmgReq.grid.dataProvider.getRowCount());
						
						if(data.resList.length > 0){
							dayEmgReq.gridCallback(data.resList);	
						}
						
						
						if(rowId !== undefined)
						{
						    var index = {
				                    //itemIndex: 90,
				                    //column: $("#PROD_ORDER_NO_idx").val(),
				                    dataRow: rowId, //FORM_SEARCH.rowId,
				                    column: "PROD_ORDER_NO"
				                };
				            
				             setTimeout(()=>{
				            
				                 dayEmgReq.grid.grdMain.setCurrent(index);
				                        
				             }, 1000);
				             
				        }
					}
				}
			}
			    
	       gfn_service(aOption, "obj")
	        
		},
		
		getReset : {
			resetAdd    : [],
			resetSearch : [],
			resetPart   : []
		},
		
		gridCallback : function(resList) {
			dayEmgReq.getReset.resetAdd     = [];
			dayEmgReq.getReset.resetSearch  = [];
			dayEmgReq.getReset.resetPart    = [];
			dayEmgReq.getReset.resetConfirm = [];
			
			$.each(resList, function(n, v){
				var urgentStatusCd = v.URGENT_STATUS_CD;
				var createId       = v.CREATE_ID;
				var createYn       = v.CREATE_YN;
				var prodPartCd     = v.PROD_PART_CD;
				var confrimYn      = v.CONFIRM_YN;
				
				if(createYn == "Y" && urgentStatusCd == "NEW") {
					dayEmgReq.getReset.resetSearch.push(n);
				}
				if(dayEmgReq.auth.authConf == "Y"){
					dayEmgReq.getReset.resetConfirm.push(n);
				}
				if(prodPartCd == "LAM" && dayEmgReq.auth.authLam == "Y" && confrimYn == "Y") {
					dayEmgReq.getReset.resetPart.push(n);
				}
				if(prodPartCd == "TEL" && dayEmgReq.auth.authTel == "Y" && confrimYn == "Y") {
					dayEmgReq.getReset.resetPart.push(n);
				}
				if(prodPartCd == "DIFFUSION" && dayEmgReq.auth.authDif == "Y" && confrimYn == "Y") {
					dayEmgReq.getReset.resetPart.push(n);
				}
				if(prodPartCd == "MATERIAL" && dayEmgReq.auth.authMat == "Y" && confrimYn == "Y") {
					dayEmgReq.getReset.resetPart.push(n);
				}
				
			});
			
			dayEmgReq.grid.grdMain.setCellStyles(dayEmgReq.getReset.resetSearch, "URGENT_REASON_CD", "editStyle");
			dayEmgReq.grid.grdMain.setCellStyles(dayEmgReq.getReset.resetSearch, "DUE_DATE", "editStyle");
			dayEmgReq.grid.grdMain.setCellStyles(dayEmgReq.getReset.resetSearch, "REQ_QTY", "editStyle");
			dayEmgReq.grid.grdMain.setCellStyles(dayEmgReq.getReset.resetSearch, "URGENT_REASON", "editStyle");
			
			dayEmgReq.grid.grdMain.setCellStyles(dayEmgReq.getReset.resetPart, "URGENT_STATUS_CD", "editStyle");
			dayEmgReq.grid.grdMain.setCellStyles(dayEmgReq.getReset.resetPart, "REMARK", "editStyle");
			
			dayEmgReq.grid.grdMain.setCellStyles(dayEmgReq.getReset.resetConfirm, "CONFIRM_YN", "editStyle");
		},
		
		save : function() {
			
			var dateChk = 0;
			var grdData = gfn_getGrdSavedataAll(this.grid.grdMain);
			var grdDataLen = grdData.length;
			if (grdDataLen == 0) {
				alert('<spring:message code="msg.noChangeData"/>');
				return;
			}
			
			$.each(grdData, function(i, row) {
				
				var dueDate = gfn_replaceAll(gfn_nvl(row.DUE_DATE, ""), "-", "");
				
				if(row.URGENT_STATUS_CD == "APPLY" && gfn_isNull(row.ACCEPT_NM)){
					row.ACCEPT_NM = "${sessionScope.GV_USER_ID}";
					row.ACCEPT_DTTM = now();
				}
				
				if(row.URGENT_STATUS_CD != "APPLY"){
					row.ACCEPT_NM = null;
					row.ACCEPT_DTTM = null;
				}
				
				if(dueDate != ""){
					
					if(!isValidDate(dueDate)){
						dateChk = i + 1;
						return false;
					}
				}
				
				if(dueDate == ""){
					dateChk = i + 1;
					return false;
				}
				
			});
			
			if(dateChk > 0){
				alert(dateChk + '<spring:message code="msg.dueDateChk"/>')
				return;
			}
			
			confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
				
				FORM_SAVE            = {}; //초기화
				FORM_SAVE._mtd       = "saveAll";
				FORM_SAVE.authConfirm = dayEmgReq.auth.authConf;
				FORM_SAVE.tranData   = [
					{outDs : "saveCnt", _siq : dayEmgReq._siq, grdData : grdData}
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
		},
		
		addRow : function() {
			var cutOffFlag = $("#searchForm #cutOffFlag").val();
			
			if(cutOffFlag == "Y") {
				alert('<spring:message code="msg.cutOffCheck"/>');
				return;
			}
			
			gfn_comPopupOpen("COM_ITEM", {
				callback : "fnAddItemCallback",
				item_type : "10",
				item_type_disabled : "disable"
			});
		},
		
		jobList : []
	};
	
	//조회
 function fn_apply(sqlFlag,rowId) {
    	//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
    		
    	dayEmgReq.search(rowId);
    	dayEmgReq.excelSubSearch();
	}
	
	// onload 
	$(document).ready(function() {
		dayEmgReq.init();
	});
	
	function getAddDay(days) {
		var date = new Date();
		date.setDate(date.getDate() + days);
		return date;
	}
	
	function fnAddItemCallback(returnData) {
		var rowCnt = dayEmgReq.grid.dataProvider.getRowCount();
		
		dayEmgReq.grid.dataProvider.clearSavePoints();
		
		$.each(returnData, function(n, v) {
			var rowAddData = {
				ITEM_CD : v.ITEM_CD,
				ITEM_NM : v.ITEM_NM,
				PLAN_ID : $("#planId").val(),
				CREATE_YN : "Y"
			};
			
			dayEmgReq.grid.dataProvider.insertRow(rowCnt + n, rowAddData);
			dayEmgReq.getReset.resetAdd.push(rowCnt + n);
		});
		
		dayEmgReq.grid.dataProvider.savePoint(); //초기화 포인트 저장
		
		dayEmgReq.grid.grdMain.setCellStyles(dayEmgReq.getReset.resetAdd, "URGENT_REASON_CD", "editStyle");
		dayEmgReq.grid.grdMain.setCellStyles(dayEmgReq.getReset.resetAdd, "DUE_DATE", "editStyle");
		dayEmgReq.grid.grdMain.setCellStyles(dayEmgReq.getReset.resetAdd, "REQ_QTY", "editStyle");
		dayEmgReq.grid.grdMain.setCellStyles(dayEmgReq.getReset.resetAdd, "URGENT_REASON", "editStyle");
	}
	
	function fnJobListCallback(returnData, rowId) {
		fn_apply(false,rowId);
	}
	
	function fn_getPlanId(pOption) {
		
		try {
			
			if ($("#planId").length == 0) {
				return;
			}
			
			var params = $.extend({
				_mtd     : "getList",
				tranData : [{outDs:"rtnList",_siq:"common.planId"}]
			}, pOption);
			
			gfn_service({
				url     : GV_CONTEXT_PATH + "/biz/obj.do",
				data    : params,
				async   : false,
				success : function(data) {
					
					gfn_setMsCombo("planId",data.rtnList,[""]);
					
					$("#planId").on("change", function(e) {
						var nowDate = null;
						var fDs = gfn_getFindDataDsInDs(data.rtnList, {CODE_CD : {VALUE : $(this).val(), CONDI : "="}});
						
						if (fDs.length > 0) {
							$("#cutOffFlag" ).val(fDs[0].CUT_OFF_FLAG);
						} 
					});
					
					$("#planId").trigger("change");
				}
			},"obj");
			
		} catch(e) {console.log(e);}
	}
	
	function now(){
		var date = new Date();
		var m = date.getMonth()+1;
		var d = date.getDate();
		var h = date.getHours();
		var i = date.getMinutes();
		var s = date.getSeconds();
		return date.getFullYear()+'-'+(m>9?m:'0'+m)+'-'+(d>9?d:'0'+d)+' '+(h>9?h:'0'+h)+':'+(i>9?i:'0'+i)+':'+(s>9?s:'0'+s);
	}
	
	/*
	 * 날짜포맷에 맞는지 검사
	 */
	function isDateFormat(d) {
	    var df = /[0-9]{4}-[0-9]{2}-[0-9]{2}/;
	    return d.match(df);
	}

	/*
	 * 윤년여부 검사
	 */
	function isLeaf(year) {
	    var leaf = false;

	    if(year % 4 == 0) {
	        leaf = true;

	        if(year % 100 == 0) {
	            leaf = false;
	        }

	        if(year % 400 == 0) {
	            leaf = true;
	        }
	    }

	    return leaf;
	}

	/*
	 * 날짜가 유효한지 검사
	 */
	function isValidDate(d) {
		
		d = d.substring(0, 4) + "-" + d.substring(4, 6) + "-" + d.substring(6, 8);
		
	    if(!isDateFormat(d)) {
	        return false;
	    }

	    var month_day = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

	    var dateToken = d.split('-');
	    var year = Number(dateToken[0]);
	    var month = Number(dateToken[1]);
	    var day = Number(dateToken[2]);
	    
	    // 날짜가 0이면 false
	    if(day == 0) {
	        return false;
	    }

	    var isValid = false;

	    // 윤년일때
	    if(isLeaf(year)) {
	        if(month == 2) {
	            if(day <= month_day[month-1] + 1) {
	                isValid = true;
	            }
	        } else {
	            if(day <= month_day[month-1]) {
	                isValid = true;
	            }
	        }
	    } else {
	        if(day <= month_day[month-1]) {
	            isValid = true;
	        }
	    }

	    return isValid;
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
					<div class="view_combo" id="divPlanId">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.planId"/></div>
							<div class="iptdv borNone">
								<select id="planId" name="planId" class="iptcombo"></select>
							</div>
						</div>
					</div>
					<input type='hidden' id='cutOffFlag' name='cutOffFlag'>
					<div class="view_combo" id="divProdPart"></div>
					<div class="view_combo" id="divItem"></div>
					<div class="view_combo" id="divUpItemGroup"></div>
					<div class="view_combo" id="divItemGroup"></div>
					<div class="view_combo" id="divRoute"></div>
					<div class="view_combo" id="divRepCustGroup"></div>
					<div class="view_combo" id="divCustGroup"></div>
					<div class="view_combo" id="divUrgentStatus"></div>
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
					<a id="btnReset" href="#" class="app1 roleWrite"><spring:message code="lbl.reset"/></a>
					<a id="btnAddChild" href="#" class="app1 roleWrite"><spring:message code="lbl.add"/></a>
					<a id="btnDeleteRows" href="#" class="app1 roleWrite"><spring:message code="lbl.delete"/></a>
					<a id="btnSave" href="#" class="app2 roleWrite"><spring:message code="lbl.save"/></a>
				</div>
			</div>
		</div>
    </div>
</body>
</html>