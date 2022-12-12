<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	<!-- Aging 재고 현황 -->
	<script type="text/javascript">
	var searchData = null;
	var enterSearchFlag = "Y";
	var agingInventory = {
	
		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.events();
			this.agingInventoryGrid.initGrid();
		},
			
		_siq    : "supply.purchase.agingInventoryList",
		
		initFilter : function() {
			
			// 키워드팝업
			gfn_keyPopAddEvent([
				{ target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>' }
			]);
			
			// 콤보박스
			gfn_setMsComboAll([
				{target : 'divProcurType', id : 'procurType', title : '<spring:message code="lbl.procure"/>', data : this.comCode.codeMap.PROCUR_TYPE, exData:[""]},
				{target : 'divItemType', id : 'itemType', title : '<spring:message code="lbl.itemType"/>', data : this.comCode.codeMap.ITEM_TYPE, exData:["*"]},
				{target : 'divCumulative', id : 'cumulative', title : '<spring:message code="lbl.cumulative"/>', data : this.comCode.codeMap.CUMULATIVE_CD, exData:["*"], type : "S"},
				{target : 'divAmtQty', id : 'rdoAqType', title : '<spring:message code="lbl.quantityAmountPart"/>', data : this.comCode.codeMap.SALE_QA_TYPE, exData:[""], type : "R"},
				{target : 'divUnitPrice', id : 'unitPrice', title : '<spring:message code="lbl.unitPrice"/>', data : this.comCode.codeMap.PRICE_CD, exData:[""], type : "R"},
				{
					target : 'divMonthCnt'     , id : 'monthCnt'     , title : '<spring:message code="lbl.futureRequireCol"/>'
					, data : [
						{CODE_CD:1,CODE_NM:1}
						,{CODE_CD:2,CODE_NM:2}
						,{CODE_CD:3,CODE_NM:3}
						,{CODE_CD:4,CODE_NM:4}
						,{CODE_CD:5,CODE_NM:5}
						,{CODE_CD:6,CODE_NM:6}
						,{CODE_CD:7,CODE_NM:7}
						,{CODE_CD:8,CODE_NM:8}
						,{CODE_CD:9,CODE_NM:9}
						,{CODE_CD:10,CODE_NM:10}
						,{CODE_CD:11,CODE_NM:11}
						,{CODE_CD:12,CODE_NM:12}
						
					]
					, exData:[  ]
					, type : "S" 
				}
				
			]);
			
			$(':radio[name=rdoAqType]:input[value="QTY"]').attr("checked", true);
			$(':radio[name=unitPrice]:input[value="COST"]').attr("checked", true);
			
			var dateParam = {arrTarget : [{calId : "fromMon", defVal : -1}]};
			
			MONTHPICKER(dateParam);
			$('#fromMon').monthpicker("option", "maxDate", -1);
			
			$("#monthCnt > option[value='4']").prop("selected","selected");
		},
		
		/*
		* common Code 
		*/
		comCode : {
			codeMap : null,
			codeReptMap : null,
			
			initCode : function () {
				var grpCd = 'SALE_QA_TYPE,ITEM_TYPE,CUMULATIVE_CD,PROCUR_TYPE,PRICE_CD,M_LONG_TERM_INV_REASON';
				this.codeMap = gfn_getComCode(grpCd, 'N'); //공통코드 조회
				
				this.codeMap.ITEM_TYPE = $.grep(this.codeMap.ITEM_TYPE, function(v,n) {
					return v.CODE_CD != '25' && v.CODE_CD != '35'; 
				});
			}
		},
		
		/* 
		* grid  선언
		*/
		agingInventoryGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				this.gridInstance.custNextBucketFalg       = true;
				this.setOptions();
				
				this.grdMain.setColumnProperty("REMARKS_SALES", "editor", {type : "multiline"});
				this.grdMain.setColumnProperty("REMARKS_SALES", "style", {textWrap : "normal"});
				
				this.grdMain.setColumnProperty("REMARKS_COMMON", "editor", {type : "multiline"});
				this.grdMain.setColumnProperty("REMARKS_COMMON", "style", {textWrap : "normal"});
				
				this.grdMain.setDisplayOptions({eachRowResizable : true});
				
				this.grdMain.onDataCellClicked = function (grid, index) {
					
					var rowId = index.itemIndex;
		       		var field = index.fieldName;
		       		var grpLvlId = grid.getValue(rowId, "GRP_LVL_ID");
		       		var planId = grid.getValue(rowId, "PLAN_ID");
	       			var itemCd = grid.getValue(rowId, "ITEM_CD");
	       			var yearMonth = grid.getValue(rowId, "YEARMONTH");
	       			
		       		if(grpLvlId == 0 && field == "TOP_ITEM"){//최상위 품목
		       			
		       			gfn_comPopupOpen("FP_POP", {
		    				rootUrl : "supply/purchase",
		    				url     : "agingInvetoryTopItem",
		    				width   : 1060,
		    				height  : 680,
		    				planId : planId,
		    				itemCd : itemCd,
		    				rowId : rowId,
		    				callback : "",
		    				menuCd	 : "MP203" 
		    			});
		       		}else if(grpLvlId == 0 && field == "HISTORY"){
		       			
		       			gfn_comPopupOpen("FP_POP", {
		    				rootUrl : "supply/purchase",
		    				url     : "agingInvetoryAddInfoHistoryList",
		    				width   : 1000,
		    				height  : 500,
		    				planId : planId,
		    				itemCd : itemCd,
		    				yearMonth: yearMonth,
		    				rowId : rowId,
		    				callback : ""
		    			});
		       		}
		       		
				};
				
				
				this.grdMain.onCellEdited= function (grid, itemIndex, dataRow, field) {
					
					var v = grid.getValue(itemIndex, field);
					var values = {SCHED_DT:"",REMARKS_SALES:"", REMARKS_COMMON:""};
					if(v == "BLANK")
					{
						agingInventory.agingInventoryGrid.grdMain.setValues(itemIndex,values,true);
					}
					
				};
			
				
				
				
			},
			setOptions : function() {
				
				this.grdMain.setOptions({
					stateBar: { visible : true  }
				});
				
				this.grdMain.addCellStyles([{
					id         : "editNoneStyleTotal",
					editable   : false,
					background : gv_totalColor
				}]);
				
				this.grdMain.addCellStyles([{
					id         : "editNoneStyleSubTotal",
					editable   : false,
					background : gv_noneEditColor
				}]);
				
				
			}
		},
	
		/*
		* event 정의
		*/
		events : function () {
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			$("#btnSave").on('click', function (e) {
				agingInventory.save();
			});
			
			$("#btnReset").on('click', function (e) {
				agingInventory.agingInventoryGrid.grdMain.cancel();
				agingInventory.agingInventoryGrid.dataProvider.rollback(agingInventory.agingInventoryGrid.dataProvider.getSavePoints()[0]);
				
				if(searchData!=null)
				{
					agingInventory.gridCallback(searchData);
					agingInventory.agingInventoryGrid.grdMain.fitRowHeightAll(0, true);
				}
			});
			
		},
		
		excelSubSearch : function (){
			
			$.each($(".view_combo"), function(i, val){
				
				var temp = "";
				var id = gfn_nvl($(this).attr("id"), "");
				
				if(id != ""){
					
					var name = gfn_nvl($("#" + id + " .ilist .itit").html(), "");
					
					if(name == ""){
						name = $("#" + id + " .filter_tit").html();
					}
					
					//타이틀
					if(i == 0){
						EXCEL_SEARCH_DATA = name + " : ";	
					}else{
						EXCEL_SEARCH_DATA += "\n" + name + " : ";	
					}
					
					//데이터
					if(id == "divItem"){
						EXCEL_SEARCH_DATA += $("#item_nm").val();
					}else if(id == "divProcurType"){
						$.each($("#procurType option:selected"), function(i2, val2){
							
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
					}else if(id == "divCumulative"){
						EXCEL_SEARCH_DATA += $("#cumulative option:selected").text();
					}else if(id == "divAmtQty"){
						
						var qtyAmt = $('input[name="rdoAqType"]:checked').val();
						
						if(qtyAmt == "QTY"){
							EXCEL_SEARCH_DATA += '<spring:message code="lbl.qty"/>';
						}else if(qtyAmt == "AMT"){
							EXCEL_SEARCH_DATA += '<spring:message code="lbl.amt"/>';
						}
					}else if(id == "divUnitPrice"){
						
						var qtyAmt = $('input[name="unitPrice"]:checked').val();
						
						if(qtyAmt == "COST"){
							EXCEL_SEARCH_DATA += '<spring:message code="lbl.costChart"/>';
						}else if(qtyAmt == "SALE_COST"){
							EXCEL_SEARCH_DATA += '<spring:message code="lbl.amtChart"/>';
						}
					}else if(id == "divFromMon"){
						EXCEL_SEARCH_DATA += $("#fromMon").val();
					}
				}
			});
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
						
						agingInventory.agingInventoryGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						agingInventory.agingInventoryGrid.grdMain.cancel();
						
						agingInventory.agingInventoryGrid.dataProvider.setRows(data.resList);
						agingInventory.agingInventoryGrid.dataProvider.clearSavePoints();
						agingInventory.agingInventoryGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(agingInventory.agingInventoryGrid.dataProvider.getRowCount());
						gfn_setRowTotalFixed(agingInventory.agingInventoryGrid.grdMain);
						searchData = data.resList;
						agingInventory.gridCallback(data.resList);
						agingInventory.agingInventoryGrid.grdMain.fitRowHeightAll(0, true);
						
					}
				}
			}
			
			gfn_service(aOption, "obj");
		},
		
		getBucket : function (sqlFlag) {
			
			var subBucket;
			var paramRdoAqType = $(":input:radio[name=rdoAqType]:checked").val();
			
			var ajaxMap = {
				param : [{cd : "ONE_MONTH", nm : '<spring:message code="lbl.monthOne"/>'}
						,{cd : "THREE_MONTH", nm : '<spring:message code="lbl.monthThree"/>'}
				        ,{cd : "SIX_MONTH", nm : '<spring:message code="lbl.monthSix"/>'}
				        ,{cd : "NINE_MONTH", nm : '<spring:message code="lbl.monthNine"/>'}
				        ,{cd : "TWELVE_MONTH", nm : '<spring:message code="lbl.yearOneWithin"/>'}
				        ,{cd : "ONE_YEAR_OVER", nm : '<spring:message code="lbl.yearOneMore"/>'}]
						,sqlId    : ["supply.purchase.bucketAging"]
			}
			gfn_getBucket(ajaxMap);
			 
			if(paramRdoAqType == "QTY"){
				subBucket = [
					{CD : "QTY", NM : '<spring:message code="lbl.qty"/>'},
					{CD : "RATE", NM : '<spring:message code="lbl.rate"/>'},
				];	
			}else if(paramRdoAqType == "AMT"){
				subBucket = [
					{CD : "AMT", NM : '<spring:message code="lbl.amt"/>'},
					{CD : "RATE", NM : '<spring:message code="lbl.rate"/>'},
				];
			}
			
			gfn_setCustBucket(subBucket);
			
			MEASURE.fix = new Array();
			MEASURE.fix = [
				  {CD : "TWO_MONTH_BEFORE_INV_QTY", WIDTH: 100, NM : '<spring:message code="lbl.twoMonthQty"/>', dataType : "number", TEXTALIGNMENT : "far", numberFormat : "#,##0", nanText : ""}
				, {CD : "TWO_MONTH_BEFORE_INV_AMT", WIDTH: 100, NM : '<spring:message code="lbl.twoMonthAmt"/>', dataType : "number", TEXTALIGNMENT : "far", numberFormat : "#,##0", nanText : ""}
				, {CD : "ONE_MONTH_BEFORE_INV_QTY", WIDTH: 100, NM : '<spring:message code="lbl.oneMonthQty"/>', dataType : "number", TEXTALIGNMENT : "far", numberFormat : "#,##0", nanText : ""}
				, {CD : "ONE_MONTH_BEFORE_INV_AMT", WIDTH: 100, NM : '<spring:message code="lbl.oneMonthAmt"/>', dataType : "number", TEXTALIGNMENT : "far", numberFormat : "#,##0", nanText : ""}
				, {CD : "INV_QTY", WIDTH: 100, NM : '<spring:message code="lbl.thisMonthQty"/>', dataType : "number", TEXTALIGNMENT : "far", numberFormat : "#,##0", nanText : ""}
				, {CD : "INV_AMT", WIDTH: 100, NM : '<spring:message code="lbl.thisMonthAmt"/>', dataType : "number", TEXTALIGNMENT : "far", numberFormat : "#,##0", nanText : ""}
				
				, {CD : "M01_WB01_QTY", WIDTH: 100, NM : '현재고 (M01+WB01)', dataType : "number", TEXTALIGNMENT : "far", numberFormat : "#,##0", nanText : ""}
				, {CD : "WI01_QTY", WIDTH: 100, NM : '현재고 (WI01)', dataType : "number", TEXTALIGNMENT : "far", numberFormat : "#,##0", nanText : ""}
				
			];
			
			if (!sqlFlag) {
				agingInventory.agingInventoryGrid.gridInstance.setDraw();
			}
		},
		gridCallback : function(resList){
			
			var iconStyles = [{
		        criteria: "value='Y'",
		        styles: "iconIndex=0"
		    }, {
		        criteria: "value='N'",
		        styles: "iconIndex=-1"
		    }];
			
			for (var i = resList.length-1; i >= 0; i--) 
			{
				if(resList[i].GRP_LVL_ID!= 0 )
				{
					if(i==0)
					{
						//TOTAL 수정 못하게 막기
					    agingInventory.agingInventoryGrid.grdMain.setCellStyles(i,"TOP_ITEM", "editNoneStyleTotal");			 //최상위품목	
					    agingInventory.agingInventoryGrid.grdMain.setCellStyles(i,"HISTORY", "editNoneStyleTotal");			  	 //HISTORY 
					    agingInventory.agingInventoryGrid.grdMain.setCellStyles(i,"REASON_FOR_OCCURRENCE", "editNoneStyleTotal");//발생사유
					    agingInventory.agingInventoryGrid.grdMain.setCellStyles(i,"REMARKS_COMMON", "editNoneStyleTotal");		 //REMARK	
					    agingInventory.agingInventoryGrid.grdMain.setCellStyles(i,"REMARKS_SALES", "editNoneStyleTotal");		 //상세정보(영업)	
					    agingInventory.agingInventoryGrid.grdMain.setCellStyles(i,"SCHED_DT", "editNoneStyleTotal");			 //처리일정	
					}
					else
					{
						//SUB TOTAL 수정 못하게 막기
					    agingInventory.agingInventoryGrid.grdMain.setCellStyles(i,"TOP_ITEM", "editNoneStyleSubTotal");			 //최상위품목	
					    agingInventory.agingInventoryGrid.grdMain.setCellStyles(i,"HISTORY", "editNoneStyleSubTotal");			  	 //HISTORY 
					    agingInventory.agingInventoryGrid.grdMain.setCellStyles(i,"REASON_FOR_OCCURRENCE", "editNoneStyleSubTotal");//발생사유
					    agingInventory.agingInventoryGrid.grdMain.setCellStyles(i,"REMARKS_COMMON", "editNoneStyleSubTotal");		 //REMARK	
					    agingInventory.agingInventoryGrid.grdMain.setCellStyles(i,"REMARKS_SALES", "editNoneStyleSubTotal");		 //상세정보(영업)	
					    agingInventory.agingInventoryGrid.grdMain.setCellStyles(i,"SCHED_DT", "editNoneStyleSubTotal");			 //처리일정
					}
				  	
				
				}
				
			}
		    
			//팝업 아이콘
			var imgs = new RealGridJS.ImageList("images1", GV_CONTEXT_PATH + "/statics/images/common/");
		    imgs.addUrls([
		        "ico_srh.png"
		    ]);

		    agingInventory.agingInventoryGrid.grdMain.registerImageList(imgs);
		    
		    agingInventory.agingInventoryGrid.grdMain.setColumnProperty("TOP_ITEM", "imageList", "images1");
		    agingInventory.agingInventoryGrid.grdMain.setColumnProperty("TOP_ITEM", "renderer", {type : "icon"}); 
		    agingInventory.agingInventoryGrid.grdMain.setColumnProperty("TOP_ITEM", "styles", {
			    textAlignment: "center",
			    iconIndex: 0,
			    iconLocation: "center",
			    iconAlignment: "center",
			    iconOffset: 4,
			    iconPadding: 2
			});
			
		    agingInventory.agingInventoryGrid.grdMain.setColumnProperty("TOP_ITEM", "dynamicStyles", iconStyles);

		    agingInventory.agingInventoryGrid.grdMain.setColumnProperty("HISTORY", "imageList", "images1");
		    agingInventory.agingInventoryGrid.grdMain.setColumnProperty("HISTORY", "renderer", {type : "icon"}); 
		    agingInventory.agingInventoryGrid.grdMain.setColumnProperty("HISTORY", "styles", {
			    textAlignment: "center",
			    iconIndex: 0,
			    iconLocation: "center",
			    iconAlignment: "center",
			    iconOffset: 4,
			    iconPadding: 2
			});
		    
		    agingInventory.agingInventoryGrid.grdMain.setColumnProperty("HISTORY", "dynamicStyles", iconStyles);
		    
		    
		    for(i=0;i<parseInt($('#monthCnt').val());i++)
	 		{
				if(i === 3)
				{
					//columns[0].columns.push({name:'M'+i+'_OVER_QTY',fieldName:'M'+i+'_OVER_QTY',header:{text:'M'+i+''}, editable: false,styles : {textAlignment: "far", background : gv_noneEditColor,numberFormat : "#,##0.#"},width : 80});
					agingInventory.agingInventoryGrid.grdMain.setCellStyles(0,'M'+i+'_OVER_QTY', "editNoneStyleTotal");
				}
				else{
					//columns[0].columns.push({name:'M'+i+'_QTY',fieldName:'M'+i+'_QTY',header:{text:'M'+i+''},styles : {textAlignment: "far", background : gv_noneEditColor,numberFormat : "#,##0.#"},width : 80});
					agingInventory.agingInventoryGrid.grdMain.setCellStyles(0,'M'+i+'_QTY', "editNoneStyleTotal");
				}
	 		}
		    
		    /*
		    agingInventory.agingInventoryGrid.grdMain.setCellStyles(0,"", "editNoneStyleTotal");
		    agingInventory.agingInventoryGrid.grdMain.setCellStyles(0,"", "editNoneStyleTotal");
		    agingInventory.agingInventoryGrid.grdMain.setCellStyles(0,"", "editNoneStyleTotal");
		    agingInventory.agingInventoryGrid.grdMain.setCellStyles(0,"", "editNoneStyleTotal");
		    */
		},
		
		save : function() {
			
			//var dateChk = 0;
			var grdData = gfn_getGrdSavedataAll(this.agingInventoryGrid.grdMain);
			var grdDataLen = grdData.length;
			
			for(i=0;i<grdData.length;i++)
			{
				grdData[i].UPDATE_ID = "${sessionScope.userInfo.userId}";	
			}
			
			
			if (grdDataLen == 0) {
				alert('<spring:message code="msg.noChangeData"/>');
				return;
			}
			
						
			/*
			if(dateChk > 0){
				alert(dateChk + '<spring:message code="msg.dueDateChk"/>')
				return;
			}
			*/
			confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
				
				FORM_SAVE            = {}; //초기화
				FORM_SAVE._mtd       = "saveUpdate";
				FORM_SAVE.tranData   = [
					{outDs : "saveCnt", _siq : "supply.purchase.agingInventoryAddInfoHistoryList", grdData : grdData}
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
		
		gfn_getMenuInit();
		DIMENSION.hidden = [];
		DIMENSION.hidden.push({CD : "PLAN_ID", dataType : "text"});
		DIMENSION.hidden.push({CD : "YEARMONTH", dataType : "text"});
		agingInventory.getBucket(sqlFlag); 
    	
    	FORM_SEARCH = $("#searchForm").serializeObject(); 
    	FORM_SEARCH.sql        = sqlFlag;
   		FORM_SEARCH.dimList    = DIMENSION.user;
   		FORM_SEARCH.hiddenList = DIMENSION.hidden;
   		FORM_SEARCH.bucketList = BUCKET.query;
   		
		agingInventory.search();
		agingInventory.excelSubSearch();
	}
	
	function limitNumberWithinRange(num, min, max){
		  const MIN = min || 1;
		  const MAX = max || 20;
		  const parsed = parseInt(num)
		  return Math.min(Math.max(parsed, MIN), MAX)
	}
	
	function fn_setNextFieldsBuket() {
		
		var fields = [];
		
		for(i=0;i<parseInt($('#monthCnt').val());i++)
		{
			
			if(i === 3)
			{
				fields.push({fieldName:'M'+i+'_OVER_QTY',dataType : "number"});
			}
			else
			{
				fields.push({fieldName:'M'+i+'_QTY',dataType : "number"});
			}
			
		}
		fields.push({fieldName:"TOP_ITEM"});
		fields.push({fieldName:"REASON_FOR_OCCURRENCE"});
		fields.push({fieldName:"HISTORY"});
		fields.push({fieldName:"SCHED_DT"});
		fields.push({fieldName:"REMARKS_SALES"});
		fields.push({fieldName:"REMARKS_COMMON"});
		
	
		
		return fields;
	}
	
	function fn_setNextColumnsBuket() {
		
		var columns = [
			
			{//미래소요량(컬럼)
				name: "GROUP1",
                header: {text: '<spring:message code="lbl.futureRequireCol" javaScriptEscape="true" />'},
                width: 500,
                type: "group",
                columns : [
                	
	                ]
			},
			{//최상위품목
				name : "TOP_ITEM", fieldName: "TOP_ITEM", editable: false, header: {text: '<spring:message code="lbl.topItem" javaScriptEscape="true" />'},
				styles: {textAlignment: "near", background: gv_noneEditColor},
				dynamicStyles : [gfn_getDynamicStyle(-1)],
				width: 80
			},
			{
                name: "GROUP2",
                header: {text: '<spring:message code="lbl.analysisContent" javaScriptEscape="true" />'},
                width: 400,
                type: "group",
                columns : [{
                	name: "REASON_FOR_OCCURRENCE",
                    fieldName: "REASON_FOR_OCCURRENCE",
                    editable: true,
                    lookupDisplay: true,
                    values: gfn_getArrayExceptInDs(agingInventory.comCode.codeMap.M_LONG_TERM_INV_REASON, "CODE_CD", ""),
                    labels: gfn_getArrayExceptInDs(agingInventory.comCode.codeMap.M_LONG_TERM_INV_REASON, "CODE_NM", ""),
                    editor: {
                        type: "dropDown",
                        domainOnly: false
                    },
                    header: {text: '<spring:message code="lbl.reasonForOccurrence" javaScriptEscape="true" />'},
                    
                    dynamicStyles: function(grid, index, value){
                    	
                    	var rowState = agingInventory.agingInventoryGrid.dataProvider.getRowState(index.itemIndex);
                    	
                    	if(grid.getValue(index.itemIndex,"REASON_FOR_OCCURRENCE")=="KEYIN")
                        {
                            return{
                                background:gv_editColor,
                                editable: true,  //편집가능
                                editor: {
                                    type: "text",
                                    domainOnly: false,
                                    
                                }
                            }
                        }
                        else
                        {
                            return{
                                background:gv_editColor,
                                editable: true,
                                editor: {
                                    type: "dropDown",
                                    domainOnly: true
                                }
                            }
                        }
                    },
                    
                    //styles : {textAlignment: "near", background : gv_editColor},
    				width : 100,
    				nanText      : "",
    				lookupDisplay: true,
    				editButtonVisibility: "visible"
                },
                {
                	name: "HISTORY",
                    fieldName: "HISTORY",
                    header: {text: '<spring:message code="lbl.history" javaScriptEscape="true" />'},
                    styles : {textAlignment: "far", background : gv_noneEditColor},
    				width : 80
                },
                {
                	name: "SCHED_DT",
                    fieldName: "SCHED_DT",
                    editable: true,
                    editor : {type: "multiline", textCase: "upper"},
                    
                    header: {text: '<spring:message code="lbl.processingSchedule" javaScriptEscape="true" />'},
                    styles : {textAlignment: "center",background : gv_editColor},
                    width : 80
                },
                {
                	name: "REMARKS_SALES",
                    fieldName: "REMARKS_SALES",
                    header: {text: '<spring:message code="lbl.detail3" javaScriptEscape="true" />'},
                    editor       : { type: "multiline", textCase: "upper" },
                    styles : {textAlignment: "far", background : gv_editColor,textWrap: 'explicit'},
    				width : 80
                },
                {
                	name: "REMARKS_COMMON",
                    fieldName: "REMARKS_COMMON",
                    header: {text: '<spring:message code="lbl.remark3" javaScriptEscape="true" />'},
                    editor       : { type: "multiline", textCase: "upper" },
                    styles : {textAlignment: "far", background : gv_editColor,textWrap: 'explicit'},
    				width : 80
                }
                ]
            }
            
			
			
			
		];
		
		for(i=0;i<parseInt($('#monthCnt').val());i++)
 		{
			if((parseInt($('#monthCnt').val())-1)===i)
				if((parseInt($('#monthCnt').val())-1)===11)
				{
					if(i === 3)
					{
						columns[0].columns.push({name:'M'+i+'_OVER_QTY',fieldName:'M'+i+'_OVER_QTY',header:{text:'M'+i+''}, editable: false, styles : {textAlignment: "far", background : gv_noneEditColor,numberFormat : "#,##0.#"},width : 80});
					}
					else{
						columns[0].columns.push({name:'M'+i+'_QTY',fieldName:'M'+i+'_QTY',header:{text:'M'+i+''},editable: false, styles : {textAlignment: "far", background : gv_noneEditColor,numberFormat : "#,##0.#"},width : 80});
					}	
				}
				else
				{
					if(i === 3)
					{
						columns[0].columns.push({name:'M'+i+'_OVER_QTY',fieldName:'M'+i+'_OVER_QTY',header:{text:'M'+i+'~'}, editable: false, styles : {textAlignment: "far", background : gv_noneEditColor,numberFormat : "#,##0.#"},width : 80});
					}
					else{
						columns[0].columns.push({name:'M'+i+'_QTY',fieldName:'M'+i+'_QTY',header:{text:'M'+i+'~'},editable: false, styles : {textAlignment: "far", background : gv_noneEditColor,numberFormat : "#,##0.#"},width : 80});
					}
				}
			else
			{
				if(i === 3)
				{
					columns[0].columns.push({name:'M'+i+'_OVER_QTY',fieldName:'M'+i+'_OVER_QTY',header:{text:'M'+i+''}, editable: false, styles : {textAlignment: "far", background : gv_noneEditColor,numberFormat : "#,##0.#"},width : 80});
				}
				else{
					columns[0].columns.push({name:'M'+i+'_QTY',fieldName:'M'+i+'_QTY',header:{text:'M'+i+''},editable: false, styles : {textAlignment: "far", background : gv_noneEditColor,numberFormat : "#,##0.#"},width : 80});
				}
			}
 		}
		
        return columns;
	}
	
	// onload 
	$(document).ready(function() {
		agingInventory.init();
		
	});
	
	
	function isDate(SCHED_DATE){
		 var currVal = SCHED_DATE;
		 
		    var rxDatePattern = /^(19|20)\d{2}-(0[1-9]|1[012])$/; // yyyy-mm 데이트 format 정규식 검사
		    var dtArray = currVal.match(rxDatePattern); // is format OK?
		 
		    if (dtArray == null)
		        return false;
		 
		    //Checks for yyyymmdd format.
		    dtYear = dtArray[1];
		    dtMonth = dtArray[2];
		    dtDay = dtArray[3];
		 
		    if (dtMonth < 1 || dtMonth > 12)
		        return false;
		    else if (dtDay < 1 || dtDay > 31)
		        return false;
		    else if ((dtMonth == 4 || dtMonth == 6 || dtMonth == 9 || dtMonth == 11) && dtDay == 31)
		        return false;
		    
		    return true;
		
	}
	
	function getMonth(){
	    var date = new Date();
	    var year = date.getFullYear();
	    var month = ("0" + (1 + date.getMonth())).slice(-2);
	    
	    return year + "-" + month;
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
					<div class="view_combo" id="divItem"></div>
					<div class="view_combo" id="divProcurType"></div>
					<div class="view_combo" id="divItemType"></div>
					<div class="view_combo" id="divCumulative"></div>
					<div class="view_combo" id="divAmtQty"></div>
					<div class="view_combo" id="divUnitPrice"></div>
					<div class="view_combo" id="divFromMon">
						<div class="ilist">
							<div class="itit">Month</div>
							<input type="text" id="fromMon" name="fromMon" class="iptdate datepicker2 monthpicker" value="">
						</div>
					</div>
					<div class="view_combo" id="divMonthCnt">
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
			
			<!-- 하단버튼 영역 -->
			<div class="cbt_btn roleWrite">
				<div class="bright">
					<a id="btnReset"href="#" class="app1"><spring:message code="lbl.reset" /></a>
					<a id="btnSave" href="#" class="app2"><spring:message code="lbl.save" /></a>
				</div>
			</div>
			
			
		</div>
    </div>
</body>
</html>
