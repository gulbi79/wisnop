<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	<!-- 급증감 겈토-->
	<script type="text/javascript">

	var enterSearchFlag = "Y";
	//var arrExtCol = ["M0_QTY","M0_QTY_AVG","M1_QTY","M1_QTY_AVG","M2_QTY","M2_QTY_AVG","M3_QTY","M3_QTY_AVG","M12_QTY_CUMULATIVE","M12_QTY_AVG"];
	var faciltySupport = {

		init : function () {
			//$("#view_Her").hide();
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.faciltySupportGrid.initGrid();
		},
			
		_siq    : "aps.static.faciltySupportList",
		
		initFilter : function() {
			
			// 키워드팝업
			gfn_keyPopAddEvent([
				{ target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>'}
			]);
			
			// 콤보박스
			gfn_setMsComboAll([
				{target : 'divProdPart', id : 'prodPart', title : '<spring:message code="lbl.reqProdPart"/>', data : this.comCode.codeMap.PROD_PART, exData:[""]},
				{target : 'divSupProdPart', id : 'supProdPart', title : '<spring:message code="lbl.supProdPart"/>', data : this.comCode.codeMap.PROD_PART, exData:[""]},
				{target : 'divItemType', id : 'itemType', title : '<spring:message code="lbl.itemType"/>', data : this.comCode.codeMap.ITEM_TYPE, exData:[""]},
			]);
		},
		
		/*
		* common Code 
		*/
		comCode : {
			codeMap : null,
			codeMapEx : null,
			
			initCode : function () {
				var grpCd = "PROD_PART,ITEM_TYPE,APPLY_YN";
				this.codeMap = gfn_getComCode(grpCd, 'Y'); //공통코드 조회
				
				this.codeMap.PROD_PART = $.grep(this.codeMap.PROD_PART, function(v, n) {
					
					var result = v.CODE_CD;
					
					if(result != "MATERIAL"){
						return result;
					}
				});
				
				gfn_service({
					async   : false,
					url     : GV_CONTEXT_PATH + "/biz/obj.do",
					data    : {_mtd : "getList", tranData:[
						{outDs : "calList", _siq : "aps.static.faciltySupportCal"},
					]},
					success : function(data) {
						var minDate = data.calList[0].MIN_DATE;
						var maxDate = data.calList[0].MAX_DATE;
						var today = data.calList[0].TODAY;
						
						DATEPICKET(null, today.split("-").join(""), maxDate.split("-").join(""));
						$("#toCal").datepicker("option", "maxDate", maxDate);
					}
				}, "obj");
			}
		},
	
		/* 
		* grid  선언
		*/
		faciltySupportGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				this.gridInstance.custNextBucketFalg = true;
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				
				gfn_setMonthSum(faciltySupport.faciltySupportGrid.gridInstance, false, false, true);
				
				this.setColumn();
				this.setFields();
				this.setOptions();
				
				var imgs = new RealGridJS.ImageList("images1", GV_CONTEXT_PATH + "/statics/images/common/");
			    imgs.addUrls([
			        "ico_srh.png"
			    ]);

			    this.grdMain.registerImageList(imgs);
			    
			    this.grdMain.setColumnProperty("WC_NM", "imageList", "images1");
			    this.grdMain.setColumnProperty("WC_NM", "renderer", {type : "icon"}); 
				
			    this.grdMain.setColumnProperty("WC_NM", "styles", {
				    textAlignment: "center",
				    iconIndex: 0,
				    iconLocation: "right",
				    iconAlignment: "center",
				    iconOffset: 4,
				    iconPadding: 2
				});
			    
			    this.grdMain.setColumnProperty("JOB_NM", "imageList", "images1");
			    this.grdMain.setColumnProperty("JOB_NM", "renderer", {type : "icon"}); 
				
			    this.grdMain.setColumnProperty("JOB_NM", "styles", {
				    textAlignment: "center",
				    iconIndex: 0,
				    iconLocation: "right",
				    iconAlignment: "center",
				    iconOffset: 4,
				    iconPadding: 2
				});
			},
			setColumn     : function () {
				var columns = 
				[
					{ 
						type      : "group",
						name      : "DIV", 
						header    : { fixedHeight : 20, text : "<spring:message code='lbl.faciltySupportReqInfo'/>" },
						width     : 1850, 
						columns   : [
							{
								name      : "REQ_PROD_PART_NM", 
								fieldName : "REQ_PROD_PART_NM", 
								header    : { text : "<spring:message code='lbl.reqProdPart'/>" }, 
								styles : {textAlignment: "near", background : gv_noneEditColor},
								width     : 100, 
								editable  : false 
							}, {
								name      : "PROD_ORDER_NO", 
								fieldName : "PROD_ORDER_NO", 
								header    : { text : "<spring:message code='lbl.prodOrderNo3'/>" }, 
								styles : {textAlignment: "near", background : gv_noneEditColor},
								width     : 150, 
								editable  : false 
							}, {
								name      : "ITEM_TYPE_NM", 
								fieldName : "ITEM_TYPE_NM", 
								header    : { text : "<spring:message code='lbl.itemType'/>" }, 
								styles : {textAlignment: "center", background : gv_noneEditColor},
								width     : 80, 
								editable  : false 
							}, {
								name      : "ITEM_CD", 
								fieldName : "ITEM_CD", 
								header    : { text : "<spring:message code='lbl.itemCd'/>" }, 
								styles : {textAlignment: "near", background : gv_noneEditColor},
								width     : 80, 
								editable  : false 
							}, {
								name      : "ITEM_NM", 
								fieldName : "ITEM_NM", 
								header    : { text : "<spring:message code='lbl.itemName'/>" }, 
								styles : {textAlignment: "near", background : gv_noneEditColor},
								width     : 80, 
								editable  : false 
							}, {
								name      : "ROUTING_ID", 
								fieldName : "ROUTING_ID", 
								header    : { text : "<spring:message code='lbl.routing'/>" }, 
								styles : {textAlignment: "center", background : gv_noneEditColor},
								width     : 80, 
								editable  : false 
							}, {
								name      : "SPEC", 
								fieldName : "SPEC", 
								header    : { text : "<spring:message code='lbl.spec'/>" }, 
								styles : {textAlignment: "near", background : gv_noneEditColor},
								width     : 80, 
								editable  : false 
							}, {
								name      : "ROUTING_NO", 
								fieldName : "ROUTING_NO", 
								header    : { text : "<spring:message code='lbl.routingNo'/>" }, 
								styles : {textAlignment: "center", background : gv_noneEditColor},
								width     : 80, 
								editable  : false 
							}, {
								name      : "PROD_ORDER_QTY", 
								fieldName : "PROD_ORDER_QTY", 
								header    : { text : "<spring:message code='lbl.prodOrderQty3'/>" }, 
								styles : {textAlignment: "far", background : gv_noneEditColor},
								width     : 80, 
								editable  : false 
							}, {
								name      : "REMAIN_QTY", 
								fieldName : "REMAIN_QTY", 
								header    : { text : "<spring:message code='lbl.remainQty2'/>" }, 
								styles : {textAlignment: "far", background : gv_noneEditColor},
								width     : 80, 
								editable  : false 
							}, {
								name      : "PROCESS_TIME", 
								fieldName : "PROCESS_TIME", 
								header    : { text : "<spring:message code='lbl.proccessTime'/>" }, 
								editor    : { type : "number", textAlignment : "far", editFormat : "#,##0.0", positiveOnly : true},
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0.0"}, 
								width     : 80, 
								editable  : false 
							}, {
								name      : "OPERATION_NO", 
								fieldName : "OPERATION_NO", 
								header    : { text : "<spring:message code='lbl.operationNo'/>" }, 
								editor    : { type : "number", textAlignment : "far", positiveOnly : true},
								styles    : { textAlignment : "center", background : gv_noneEditColor}, 
								width     : 80, 
								editable  : false 
							}, {
								name      : "JOB_NM", 
								fieldName : "JOB_NM", 
								header    : { text : "<spring:message code='lbl.jobCd3'/>" }, 
								styles : {textAlignment: "near", background : gv_noneEditColor},
								width     : 120, 
								editable  : false 
							}, {
								name      : "SUP_PROD_PART", 
								fieldName : "SUP_PROD_PART", 
								header    : { text : "<spring:message code='lbl.supProdPart'/>" }, 
								styles : {textAlignment: "center", background : gv_noneEditColor},
								editor : { type: "dropDown", domainOnly: true },
								values : gfn_getArrayExceptInDs(faciltySupport.comCode.codeMap.PROD_PART, "CODE_CD", ""),
								labels : gfn_getArrayExceptInDs(faciltySupport.comCode.codeMap.PROD_PART, "CODE_NM", ""),
								editable  : false,
								lookupDisplay: true
								, labelField: "SUP_PROD_PART_DROP" 
							}, {
								name      : "REQ_END_DATE", 
								fieldName : "REQ_END_DATE", 
								header    : { text : "<spring:message code='lbl.reqEndDate'/>" }, 
								styles : {textAlignment: "center", background : gv_noneEditColor, datetimeFormat : "yyyy-MM-dd"},
								editor : {
									type : "date", 
									mask : {editMask : "9999-99-99", placeHolder : "yyyy-MM-dd", includedFormat : true}, 
									datetimeFormat : "yyyy-MM-dd",
									minDate : getAddDay(0)
								},
								width     : 80, 
								editable  : false 
							}, {
								name      : "REQ_START_DATE", 
								fieldName : "REQ_START_DATE", 
								header    : { text : "<spring:message code='lbl.reqStartDate'/>" }, 
								styles : {textAlignment: "center", background : gv_noneEditColor, datetimeFormat : "yyyy-MM-dd"},
								editor : {
									type : "date", 
									mask : {editMask : "9999-99-99", placeHolder : "yyyy-MM-dd", includedFormat : true}, 
									datetimeFormat : "yyyy-MM-dd",
									minDate : getAddDay(0)
								},
								width     : 80, 
								editable  : false 
							}, {
								name      : "REQ_QTY", 
								fieldName : "REQ_QTY", 
								header    : { text : "<spring:message code='lbl.reqQty2'/>" }, 
								editor    : { type : "number", textAlignment : "far", editFormat : "#,##0", positiveOnly : true},
								styles    : { textAlignment : "far", background : gv_noneEditColor, numberFormat : "#,##0"}, 
								width     : 80, 
								editable  : false 
							}, {
								name      : "REQ_REASON", 
								fieldName : "REQ_REASON", 
								header    : { text : "<spring:message code='lbl.urgentReason2'/>" }, 
								styles : {textAlignment: "near", background : gv_noneEditColor},
								width     : 80, 
								editable  : false 
							}, {
								name      : "CREATE_ID", 
								fieldName : "CREATE_ID", 
								header    : { text : "<spring:message code='lbl.requestUser'/>" }, 
								styles : {textAlignment: "center", background : gv_noneEditColor},
								width     : 80, 
								editable  : false 
							}, {
								name      : "CREATE_DTTM", 
								fieldName : "CREATE_DTTM", 
								header    : { text : "<spring:message code='lbl.regDttm'/>" }, 
								styles : {textAlignment: "center", background : gv_noneEditColor},
								width     : 80, 
								editable  : false 
							}
						]
					}, { 
						type      : "group",
						name      : "FACILTY_SUPPORT_REPLY_INFO", 
						header    : { fixedHeight : 20, text : "<spring:message code='lbl.faciltySupportReplyInfo'/>" },
						width     : 800, 
						columns   : [
							{
								name      : "APPLY_YN", 
								fieldName : "APPLY_YN", 
								header    : { text : "<spring:message code='lbl.urgentStatus'/>" }, 
								styles : {textAlignment: "center", background : gv_noneEditColor},
								editor : { type: "dropDown", domainOnly: true },
								values : gfn_getArrayExceptInDs(faciltySupport.comCode.codeMap.APPLY_YN, "CODE_CD", ""),
								labels : gfn_getArrayExceptInDs(faciltySupport.comCode.codeMap.APPLY_YN, "CODE_NM", ""),
								width     : 80, 
								editable  : false,
								lookupDisplay: true
							}, {
								name      : "WC_NM", 
								fieldName : "WC_NM", 
								header    : { text : "<spring:message code='lbl.wcNm'/>" }, 
								styles : {textAlignment: "near", background : gv_noneEditColor},
								width     : 80, 
								editable  : false 
							}, {
								name      : "RESOURCE_NM", 
								fieldName : "RESOURCE_NM", 
								header    : { text : "<spring:message code='lbl.resourceNm2'/>" }, 
								styles : {textAlignment: "near", background : gv_noneEditColor},
								width     : 80, 
								editable  : false 
							}, {
								name      : "SUP_START_DATE", 
								fieldName : "SUP_START_DATE", 
								header    : { text : "<spring:message code='lbl.supStartDate'/>" }, 
								styles : {textAlignment: "center", background : gv_noneEditColor, datetimeFormat : "yyyy-MM-dd"},
								editor : {
									type : "date", 
									mask : {editMask : "9999-99-99", placeHolder : "yyyy-MM-dd", includedFormat : true}, 
									datetimeFormat : "yyyy-MM-dd",
									minDate : getAddDay(0)
								},
								width     : 80, 
								editable  : false 
							}, {
								name      : "SUP_END_DATE", 
								fieldName : "SUP_END_DATE", 
								header    : { text : "<spring:message code='lbl.supEndDate'/>" }, 
								styles : {textAlignment: "center", background : gv_noneEditColor, datetimeFormat : "yyyy-MM-dd"},
								editor : {
									type : "date", 
									mask : {editMask : "9999-99-99", placeHolder : "yyyy-MM-dd", includedFormat : true}, 
									datetimeFormat : "yyyy-MM-dd",
									minDate : getAddDay(0)
								},
								width     : 80, 
								editable  : false 
							}, {
								name      : "REMARK", 
								fieldName : "REMARK", 
								header    : { text : "<spring:message code='lbl.remark2'/>" }, 
								styles : {textAlignment: "near", background : gv_noneEditColor},
								width     : 80, 
								editable  : false 
							}, {
								name      : "ACCEPT_USER_ID", 
								fieldName : "ACCEPT_USER_ID", 
								header    : { text : "<spring:message code='lbl.acceptNm'/>" }, 
								styles : {textAlignment: "center", background : gv_noneEditColor},
								width     : 80, 
								editable  : false 
							}, {
								name      : "ACCEPT_DTTM", 
								fieldName : "ACCEPT_DTTM", 
								header    : { text : "<spring:message code='lbl.acceptDttm'/>" },
								styles : {textAlignment: "center", background : gv_noneEditColor},
								width     : 80, 
								editable  : false 
							}
						]
					}
				];
				
				this.grdMain.setColumns(columns); 
			},
			
			setFields : function(cols) {
				
				var fields = new Array();
				
				fields = [
					{ fieldName : "REQ_PROD_PART", dataType : "text" },
					{ fieldName : "REQ_PROD_PART_NM", dataType : "text" },
					{ fieldName : "PROD_ORDER_NO", dataType : "text" },
					{ fieldName : "ITEM_TYPE", dataType : "text" },
					{ fieldName : "ITEM_TYPE_NM", dataType : "text" },
					{ fieldName : "ITEM_CD", dataType : "text" },
					{ fieldName : "ITEM_NM", dataType : "text" },
					{ fieldName : "ROUTING_ID", dataType : "text" },
					{ fieldName : "SPEC", dataType : "text" },
					{ fieldName : "ROUTING_NO", dataType : "text" },
					{ fieldName : "PROD_ORDER_QTY", dataType : "text" },
					{ fieldName : "REMAIN_QTY", dataType : "text" },
					{ fieldName : "PROCESS_TIME", dataType : "number" },
					{ fieldName : "JOB_CD" , dataType : "text" },
					{ fieldName : "JOB_NM" , dataType : "text" },
					{ fieldName : "SUP_PROD_PART" , dataType : "text" },
					
					{ fieldName : "REQ_END_DATE", dataType : "text" },
					{ fieldName : "REQ_START_DATE", dataType : "text" },
					{ fieldName : "REQ_QTY", dataType : "number" },
					{ fieldName : "REQ_REASON", dataType : "text" },
					{ fieldName : "CREATE_ID", dataType : "text" },
					{ fieldName : "CREATE_DTTM", dataType : "text" },
					
					{ fieldName : "APPLY_YN", dataType : "text" },
					{ fieldName : "WC_NM", dataType : "text" },
					{ fieldName : "RESOURCE_CD", dataType : "text" },
					{ fieldName : "RESOURCE_NM", dataType : "text" },
					{ fieldName : "SUP_START_DATE", dataType : "text" },
					{ fieldName : "SUP_END_DATE", dataType : "text" },
					{ fieldName : "REMARK", dataType : "text" },
					{ fieldName : "ACCEPT_USER_ID", dataType : "text" },
					{ fieldName : "ACCEPT_DTTM", dataType : "text" },
					{ fieldName : "SEQ", dataType : "number" },
					{ fieldName : "USER_AUTH_YN", dataType : "text" },
					{ fieldName : "OPERATION_NO", dataType : "number" },
					{ fieldName : "SUP_PROD_PART_DROP", dataType: "text" }, // 이름을 가지고 있을 field를 추가로 지정합니다.  
				];
				
				this.dataProvider.setFields(fields);
			},
			
			setOptions : function () {
				this.grdMain.setOptions({
					checkBar: { visible : true },
					stateBar: { visible : true }
				});

				this.dataProvider.setOptions({
					softDeleting : true
				});
				
				this.grdMain.addCellStyles([
					{
						id         : "editStyle",
						editable   : true,
						background : gv_editColor
					}, {
						id         : "editStyle2",
						editable   : false,
						background : gv_editColor
					}, {
						id         : "editNoneStyle",
						editable   : false,
						background : gv_noneEditColor
					}
				]);
				
				this.grdMain.onDataCellClicked = function (grid, index) {
					
					var rowId = index.itemIndex;
					var styleIdx = index.dataRow;
		       		var field = index.fieldName;
		       		var prodPart = grid.getValue(rowId, "REQ_PROD_PART");
		       		var cellStyle = grid.getCellStyle(styleIdx, field);
		       		
		       		if(field == "WC_NM" && cellStyle == "editStyle2"){//지원작업장명
		       			
		       			var supProdPart = grid.getValue(rowId, "SUP_PROD_PART");
		       			var supProdPartNm = grid.getDisplayValues(rowId).SUP_PROD_PART;
		       			
		       			gfn_comPopupOpen("FP_POP", {
		    				rootUrl : "aps/static",
		    				url     : "faciltySupportPop2",
		    				width   : 1000,
		    				height  : 800,
		    				supProdPart : supProdPart,
		    				supProdPartNm : supProdPartNm,
		    				rowId : rowId,
		    				callback : "fnFaciltySupportPop2Callback"
		    			});
		       		}
		       		
		       		if(field == "JOB_NM" && cellStyle == "editStyle2"){//요청공정
		       		
		       			var jobCd = grid.getValue(rowId, "JOB_CD");
		       			var jobNm = grid.getValue(rowId, "JOB_NM");
		       			var prodOrderNo = grid.getValue(rowId, "PROD_ORDER_NO");
		       		
		       			gfn_comPopupOpen("FP_POP", {
		    				rootUrl : "aps/static",
		    				url     : "faciltySupportPop3",
		    				width   : 1000,
		    				height  : 800,
		    				prodOrderNo : prodOrderNo,
		    				rowId : rowId,
		    				jobCd : jobCd,
		    				popupTitle : "<spring:message code='lbl.jobCdSelect'/>",
		    				callback : "fnFaciltySupportPop3Callback"
		    			});
		       		}
		       		
		       		if(index.fieldName == "SUP_PROD_PART") {
						changeDropDown(prodPart);
					}
				};
				
				this.grdMain.onCurrentRowChanged = function (grid, oldRow, newRow) {
			        if (newRow >= 0) {
			            changeDropDown(grid.getValue(newRow, "REQ_PROD_PART"));
			        }
			    };
				
				this.grdMain.onGetEditValue = function (grid, index, editResult) {
					
			        if (index.fieldName == "SUP_PROD_PART") {
			            grid.setValue(index.itemIndex, "SUP_PROD_PART_DROP", editResult.text);
			        }
			    };
				
				this.grdMain.onEditChange = function (grid, index, value) {
					var rowId = index.dataRow;
		       		var field = index.fieldName;
		       		
		       		if(field == "APPLY_YN"){
		       			
		       			if(value == "Y"){
		       				faciltySupport.faciltySupportGrid.grdMain.setCellStyles(rowId, "WC_NM", "editStyle2");
							faciltySupport.faciltySupportGrid.grdMain.setCellStyles(rowId, "SUP_START_DATE", "editStyle");
							faciltySupport.faciltySupportGrid.grdMain.setCellStyles(rowId, "SUP_END_DATE", "editStyle");
		       			}else if(value == "N"){
		       				faciltySupport.faciltySupportGrid.grdMain.setCellStyles(rowId, "WC_NM", "editNoneStyle");
							faciltySupport.faciltySupportGrid.grdMain.setCellStyles(rowId, "SUP_START_DATE", "editNoneStyle");
							faciltySupport.faciltySupportGrid.grdMain.setCellStyles(rowId, "SUP_END_DATE", "editNoneStyle");
		       			}
		       		}
				};
				
				var valArray = ["FACILTY_SUPPORT_REPLY_INFO", "APPLY_YN", "WC_NM", "RESOURCE_NM", "SUP_START_DATE", "SUP_END_DATE", "REMARK", "ACCEPT_USER_ID", "ACCEPT_DTTM"];
				var valArrayLen = valArray.length;
				
				for(var i = 0; i < valArrayLen; i++){
					var val = valArray[i];
					
					var setHeader = this.grdMain.getColumnProperty(val, "header");
					setHeader.styles = {background: gv_headerColor};
					this.grdMain.setColumnProperty(val, "header", setHeader);
				}
			},
		},
	
		/*
		* event 정의
		*/
		events : function () {
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("#btnAdd").click ("on", function() { faciltySupport.add(); });
			$("#btnDel").click ("on", function() { faciltySupport.del(); });
			
			$("#btnSave").on('click', function (e) {
				faciltySupport.save();
			});
		},
		
		add : function (){
			
			gfn_comPopupOpen("FP_POP", {
				rootUrl : "aps/static",
				url     : "faciltySupportPop",
				width   : 1000,
				height  : 800,
				popupTitle : "Item Selection",
				callback : "fnFaciltySupportPopCallback"
			});
		},
		
		del : function (){
			
			var passFlag = true;
			var passRow = -1;
			var rows = faciltySupport.faciltySupportGrid.grdMain.getCheckedRows(true);
			var rowsLen = rows.length;
			var delDataArray = [];
			
			if(rowsLen == 0){
				alert('<spring:message code="msg.chkMsg"/>');
				return;
			}
			
			$.each(rows, function(i, val){
				
				var cellStyle = faciltySupport.faciltySupportGrid.grdMain.getCellStyle(val, "WC_NM");
				var seq = faciltySupport.faciltySupportGrid.grdMain.getValue(val, "SEQ");
				
				if(cellStyle != "editStyle2"){
					passFlag = false;
					passRow = (val + 1);
					return false;
				}
				
				var delData = {
					SEQ : seq	
				};
				
				delDataArray.push(delData);
				
			});
			
			if(passFlag){
				
				confirm('<spring:message code="msg.deleteCfm"/>', function() {  // 저장하시겠습니까?
					
					FORM_SAVE            = {}; //초기화
					FORM_SAVE._mtd       = "saveUpdate";
					FORM_SAVE.tranData   = [
						{outDs : "saveCnt", _siq : "aps.static.faciltySupportListDel", grdData : delDataArray}
					];
					
					var ajaxOpt = {
						url     : GV_CONTEXT_PATH + "/biz/obj.do",
						data    : FORM_SAVE,
						success : function(data) {
							
							alert('<spring:message code="msg.deleteMsg"/>');
							fn_apply(false);
						},
					};
					
					gfn_service(ajaxOpt, "obj");
				});
			}else{
				alert(passRow + '<spring:message code="msg.unauthorized2"/>');
			}
		},
		
		save : function() {
			
			var valitaionFlag = true;
			var grdData = gfn_getGrdSavedataAll(this.faciltySupportGrid.grdMain);
			
			var grdDataLen = grdData.length;
			if (grdDataLen == 0) {
				alert('<spring:message code="msg.noChangeData"/>');
				return;
			}
			
			$.each(grdData, function(i, val){
				
				var jobNm = gfn_nvl(val.JOB_NM, "");
				var supProdPart = gfn_nvl(val.SUP_PROD_PART, "");
				var reqQty = gfn_nvl(val.REQ_QTY, "");
				var reqEndDate = gfn_nvl(val.REQ_END_DATE, "");
				var reqStartDate = gfn_nvl(val.REQ_START_DATE, "");
				
				var applyYn = gfn_nvl(val.APPLY_YN, "");
				var wcNm = gfn_nvl(val.WC_NM, "");
				var supStartDate = gfn_nvl(val.SUP_START_DATE, "");
				var supEndDate = gfn_nvl(val.SUP_END_DATE, "");
				
				if(jobNm == ""){
					alert('<spring:message code="msg.jobCdMsg"/>');
					valitaionFlag = false;
					return false;
				}
				
				if(supProdPart == ""){
					alert('<spring:message code="msg.supProdPartMsg"/>');
					valitaionFlag = false;
					return false;
				}
				
				if(reqEndDate == ""){//인계가능일
					alert('<spring:message code="msg.reqEndDateMsg"/>');
					valitaionFlag = false;
					return false;
				}
				
				if(reqStartDate == ""){//요청완료일
					alert('<spring:message code="msg.reqStartDateMsg"/>');
					valitaionFlag = false;
					return false;
				}
				
				if(reqEndDate != "" && reqStartDate != ""){
					if(reqEndDate > reqStartDate){
						alert('<spring:message code="msg.reqStartEndMsg"/>');
						valitaionFlag = false;
						return false;
					}
				}
				
				if(reqQty == ""){
					alert('<spring:message code="msg.reqQtyMsg"/>');
					valitaionFlag = false;
					return false;
				}else if(reqQty == 0){
					alert('<spring:message code="msg.reqQty0Msg"/>');
					valitaionFlag = false;
					return false;
				}
				
				if(applyYn == "Y"){
					if(wcNm == ""){
						alert('<spring:message code="msg.wcNmMsg"/>');
						valitaionFlag = false;
						return false;
					}
					if(supStartDate == ""){
						alert('<spring:message code="msg.supStartDateMsg"/>');
						valitaionFlag = false;
						return false;
					}
					if(supEndDate == ""){
						alert('<spring:message code="msg.supEndDateMsg"/>');
						valitaionFlag = false;
						return false;
					}
				}
				
				if(supStartDate != "" && supStartDate != ""){
					
					if(supStartDate > supStartDate){
						alert('<spring:message code="msg.supStartEndMsg"/>');
						valitaionFlag = false;
						return false;
					}
				}
			});
			
			if(valitaionFlag){
				confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
					
					FORM_SAVE            = {}; //초기화
					FORM_SAVE._mtd       = "saveAll";
					FORM_SAVE.tranData   = [
						{outDs : "saveCnt", _siq : faciltySupport._siq, grdData : grdData}
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
						$.each($("#prodPart option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divSupProdPart"){
						$.each($("#supProdPart option:selected"), function(i2, val2){
							
							var txt = gfn_nvl($(this).text(), "");
							
							if(i2 == 0){
								temp = txt;								
							}else{
								temp += ", " + txt;
							}
						});		
						EXCEL_SEARCH_DATA += temp;
					}else if(id == "divItemType"){
						$.each($("#itemType option:selected"), function(i2, val2){
							
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
					}
				}
			});
			
			EXCEL_SEARCH_DATA += "\n" + '<spring:message code="lbl.period"/>' + " : ";
			EXCEL_SEARCH_DATA += $("#fromCal").val() + "(" + $("#fromWeek").val() + ") ~ ";
			EXCEL_SEARCH_DATA += $("#toCal").val() + "(" + $("#toWeek").val() + ")";
			
		},
		
		// 조회
		search : function () {
			
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{outDs : "resList", _siq : this._siq }];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj.do",
				data    : FORM_SEARCH,
				success : function (data) {
					
					if (FORM_SEARCH.sql == 'N') {
						faciltySupport.faciltySupportGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						faciltySupport.faciltySupportGrid.grdMain.cancel();
						
						faciltySupport.faciltySupportGrid.dataProvider.setRows(data.resList);
						faciltySupport.faciltySupportGrid.dataProvider.clearSavePoints();
						faciltySupport.faciltySupportGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(faciltySupport.faciltySupportGrid.dataProvider.getRowCount());
						
						faciltySupport.gridCallback(data.resList);
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		getReset : {
			resetAdd    : [],
			resetSearch : [],
			resetPart   : [],
			resetPart2  : []
		},
		
		gridCallback : function(resList) {
			
			faciltySupport.getReset.resetAdd = [];
			faciltySupport.getReset.resetSearch = [];
			faciltySupport.getReset.resetPart   = [];
			faciltySupport.getReset.resetPart2  = [];

			$.each(resList, function(n, v){
				
				var userAuthYn = v.USER_AUTH_YN;
				
				if(userAuthYn == "Y"){
					faciltySupport.getReset.resetSearch.push(n);
				}
			});
			
			faciltySupport.faciltySupportGrid.grdMain.setCellStyles(faciltySupport.getReset.resetSearch, "JOB_NM", "editStyle2");
			faciltySupport.faciltySupportGrid.grdMain.setCellStyles(faciltySupport.getReset.resetSearch, "SUP_PROD_PART", "editStyle");
			faciltySupport.faciltySupportGrid.grdMain.setCellStyles(faciltySupport.getReset.resetSearch, "REQ_END_DATE", "editStyle");
			faciltySupport.faciltySupportGrid.grdMain.setCellStyles(faciltySupport.getReset.resetSearch, "REQ_START_DATE", "editStyle");
			faciltySupport.faciltySupportGrid.grdMain.setCellStyles(faciltySupport.getReset.resetSearch, "REQ_QTY", "editStyle");
			faciltySupport.faciltySupportGrid.grdMain.setCellStyles(faciltySupport.getReset.resetSearch, "REQ_REASON", "editStyle");
			
			gfn_service({
			    async   : false,
			    url     : GV_CONTEXT_PATH + "/biz/obj.do",
			    data    : {
	    			_mtd : "getList",
	    			tranData : [
	    				{outDs : "authorityList", _siq : "aps.static.facilitySupportAuthority"}
	    			]
			    },
			    success :function(data) {
			    	
			    	var dataLen = data.authorityList.length;
			    	
					for(var i = 0; i < dataLen; i++){
			    		
			    		var menuCd = data.authorityList[i].MENU_CD;
			    		
			    		$.each(resList, function(n, v){
			    			
			    			var prodPart = v.SUP_PROD_PART;
			    			var applyYn = v.APPLY_YN;
			    			
			    			if((menuCd == "APS11501" && prodPart == "LAM") || (menuCd == "APS11502" && prodPart == "TEL") || (menuCd == "APS11503" && prodPart == "DIFFUSION") || (menuCd == "APS11504" && prodPart == "MATERIAL")){
			    				if(applyYn == "Y"){
			    					faciltySupport.getReset.resetPart.push(n);	
			    				}
			    				faciltySupport.getReset.resetPart2.push(n);
			    			}
			    		});
			    	}
					
					faciltySupport.faciltySupportGrid.grdMain.setCellStyles(faciltySupport.getReset.resetPart2, "APPLY_YN", "editStyle");
					faciltySupport.faciltySupportGrid.grdMain.setCellStyles(faciltySupport.getReset.resetPart, "WC_NM", "editStyle2");
					faciltySupport.faciltySupportGrid.grdMain.setCellStyles(faciltySupport.getReset.resetPart, "SUP_START_DATE", "editStyle");
					faciltySupport.faciltySupportGrid.grdMain.setCellStyles(faciltySupport.getReset.resetPart, "SUP_END_DATE", "editStyle");
					faciltySupport.faciltySupportGrid.grdMain.setCellStyles(faciltySupport.getReset.resetPart2, "REMARK", "editStyle");
		    	}
			}, "obj");
		},
	};
	
	//조회
	var fn_apply = function (sqlFlag) {
		
		var pChangeAreaStart = $("#changeAreaStart").val();
		var pChangeAreaEnd = $("#changeAreaEnd").val();
		
		if(pChangeAreaStart != "" && pChangeAreaEnd != "" && pChangeAreaStart > pChangeAreaEnd){
			alert('<spring:message code="msg.changeCheck" javaScriptEscape="true" />');
			return;
		}

		gfn_getMenuInit();
		
    	FORM_SEARCH = $("#searchForm").serializeObject(); 
    	FORM_SEARCH.sql        = sqlFlag;
   		FORM_SEARCH.dimList    = DIMENSION.user;
   		FORM_SEARCH.bucketList = BUCKET.query;
   		
		faciltySupport.search();
		faciltySupport.excelSubSearch();
	}

	// onload 
	$(document).ready(function() {
		faciltySupport.init();
	});
	
	function fnFaciltySupportPopCallback(returnData){
		
		var rowCnt = faciltySupport.faciltySupportGrid.dataProvider.getRowCount();
		faciltySupport.faciltySupportGrid.dataProvider.clearSavePoints();
		
		$.each(returnData, function(n, v) {
			var rowAddData = {
				REQ_PROD_PART : v.PROD_PART,
				REQ_PROD_PART_NM : v.PROD_PART_NM,
				PROD_ORDER_NO : v.PROD_ORDER_NO,
				ITEM_TYPE : v.ITEM_TYPE,
				ITEM_TYPE_NM : v.ITEM_TYPE_NM,
				ITEM_CD : v.ITEM_CD,
				ITEM_NM : v.ITEM_NM,
				ROUTING_ID : v.ROUTING_ID,
				SPEC : v.SPEC,
				ROUTING_NO : v.ROUTING_NO,
				PROD_ORDER_QTY : v.PROD_ORDER_QTY,
				REMAIN_QTY : v.REMAIN_QTY
			};
			
			faciltySupport.faciltySupportGrid.dataProvider.insertRow(rowCnt + n, rowAddData);
			faciltySupport.getReset.resetAdd.push(rowCnt + n);
		});
		
		faciltySupport.faciltySupportGrid.dataProvider.savePoint(); //초기화 포인트 저장
		
		faciltySupport.faciltySupportGrid.grdMain.setCellStyles(faciltySupport.getReset.resetAdd, "JOB_NM", "editStyle2");
		faciltySupport.faciltySupportGrid.grdMain.setCellStyles(faciltySupport.getReset.resetAdd, "SUP_PROD_PART", "editStyle");
		faciltySupport.faciltySupportGrid.grdMain.setCellStyles(faciltySupport.getReset.resetAdd, "REQ_END_DATE", "editStyle");
		faciltySupport.faciltySupportGrid.grdMain.setCellStyles(faciltySupport.getReset.resetAdd, "REQ_START_DATE", "editStyle");
		faciltySupport.faciltySupportGrid.grdMain.setCellStyles(faciltySupport.getReset.resetAdd, "REQ_QTY", "editStyle");
		faciltySupport.faciltySupportGrid.grdMain.setCellStyles(faciltySupport.getReset.resetAdd, "REQ_REASON", "editStyle");
		
	}
	
	function fnFaciltySupportPop2Callback(returnData, rowId){
		
		$.each(returnData, function(n, v) {
			
			var wcNm = v.WC_NM;
			var resourceCd = v.RESOURCE_CD;
			var resourceNm = v.RESOURCE_NM;
			
			faciltySupport.faciltySupportGrid.grdMain.setValue(rowId, "WC_NM", wcNm);
			faciltySupport.faciltySupportGrid.grdMain.setValue(rowId, "RESOURCE_CD", resourceCd);
			faciltySupport.faciltySupportGrid.grdMain.setValue(rowId, "RESOURCE_NM", resourceNm);
		});
	}
	
	function fnFaciltySupportPop3Callback(returnData, rowId){
		
		$.each(returnData, function(n, v) {
			
			var jobCd = v.JOB_CD;
			var jobNm = v.JOB_NM;
			var processTime = v.PROCESS_TIME;
			
			faciltySupport.faciltySupportGrid.grdMain.setValue(rowId, "JOB_CD", jobCd);
			faciltySupport.faciltySupportGrid.grdMain.setValue(rowId, "JOB_NM", jobNm);
			faciltySupport.faciltySupportGrid.grdMain.setValue(rowId, "PROCESS_TIME", processTime);
			
		});
	}
	
	function getAddDay(days) {
		var date = new Date();
		date.setDate(date.getDate() + days);
		return date;
	}
	
	function changeDropDown(val){
		
		var codeCdTmp = new Array();
    	var codeNmTmp = new Array();
		
		$.each(faciltySupport.comCode.codeMap.PROD_PART, function(n2, v2){
			 
			var codeCdV2 = v2.CODE_CD;
			var codeNmV2 = v2.CODE_NM;
			
			if(val != codeCdV2){
				codeCdTmp.push(codeCdV2);
	    		codeNmTmp.push(codeNmV2);
			}
		});
		
		var col = faciltySupport.faciltySupportGrid.grdMain.columnByName("SUP_PROD_PART");
		
		col.values = codeCdTmp;
		col.labels = codeNmTmp;
		
		faciltySupport.faciltySupportGrid.grdMain.setColumn(col);
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
					<div class="view_combo" id="divSupProdPart"></div>
					<div class="view_combo" id="divItemType"></div>
					<div class="view_combo" id="divItem"></div>
					<jsp:include page="/WEB-INF/view/common/filterViewHorizon.jsp" flush="false">
						<jsp:param name="radioYn" value="N" />
						<jsp:param name="wType" value="SW" />
					</jsp:include>
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
			<div class="cbt_btn" style="height:25px">
				<div class="bright">
					<%-- <a href="javascript:;" id="btnReset" class="app1 roleWrite"><spring:message code="lbl.reset" /></a> --%>
					<a href="javascript:;" id="btnAdd" class="app1 roleWrite"><spring:message code="lbl.add" /></a>
					<a href="javascript:;" id="btnDel" class="app1 roleWrite"><spring:message code="lbl.delete" /></a>
					<a href="javascript:;" id="btnSave" class="app2 roleWrite"><spring:message code="lbl.save" /></a>
				</div>
			</div>
		</div>
    </div>
</body>
</html>
