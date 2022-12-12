<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	
	<script type="text/javascript">

	var enterSearchFlag = "Y";
	var workerGroup = {

		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.workerGroupGrid.initGrid();
			this.events();
		},
			
		_siq    : "aps.static.workerGroupList",
		 
		initFilter : function() {
			
			var itemTypeEvent = {
				childId   : ["upItemGroup"],  
				childData : [this.comCode.codeMapEx.UPPER_ITEM_GROUP, this.comCode.codeMapEx.ROUTING],
				callback  : function() {
					//품목그룹 초기화
					gfn_setMsCombo("itemGroup", [], ["*"]);
				}
			};
	    	
	    	//품목대그룹
			var upperItemEvent = {
				childId   : ["itemGroup"],
				childData : [this.comCode.codeMapEx.ITEM_GROUP],
			};
			
			gfn_keyPopAddEvent([
				{ target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>' }
			]);
			
			gfn_setMsComboAll([
				{ target : 'divProdPart'    , id : 'prodPart', title : '<spring:message code="lbl.prodPart"/>', data : this.comCode.codeMap.PROD_PART, exData:["*"], type : "S"},
				{ target : 'divProcurType'  , id : 'procurType',    title : '<spring:message code="lbl.procure"/>',        data : this.comCode.codeMap.PROCUR_TYPE, exData:[""], option: {allFlag:"Y"}},
				{ target : 'divUpItemGroup' , id : 'upItemGroup',   title : '<spring:message code="lbl.upperItemGroup"/>', data : this.comCode.codeMapEx.UPPER_ITEM_GROUP, exData:["*"], event: upperItemEvent},
				{ target : 'divItemGroup'   , id : 'itemGroup'    , title : '<spring:message code="lbl.itemGroup"/>'    , data : this.comCode.codeMapEx.ITEM_GROUP,     exData:["*"] },
				{ target : 'divRoute'       , id : 'route'        , title : '<spring:message code="lbl.routing"/>'      , data : this.comCode.codeMapEx.ORDER_ROUTING,  exData:["*"] },
				{ target : 'divRepCustGroup', id : 'reptCustGroup', title : '<spring:message code="lbl.reptCustGroup"/>', data : this.comCode.codeMapEx.REP_CUST_GROUP, exData:["*"] },
				{ target : 'divCustGroup'   , id : 'custGroup'    , title : '<spring:message code="lbl.custGroup"/>'    , data : this.comCode.codeMapEx.CUST_GROUP,     exData:["*"] },
				{ target : 'divCpfrYn'      , id : 'cpfrYn', title : '<spring:message code="lbl.cpfrItem"/>', data : this.comCode.codeMap.FLAG_YN, exData:["*"], type : "S"},
				{ target : 'divSsYn'        , id : 'ssYn', title : '<spring:message code="lbl.ssItem"/>', data : this.comCode.codeMap.FLAG_YN, exData:["*"], type : "S"},
				{ target : 'divFireWorkYn'  , id : 'fireWorkYn', title : '<spring:message code="lbl.FIREWORK_YN"/>', data : this.comCode.codeMap.FLAG_YN, exData:["*"], type : "S" }
			]);
			
			$("#fireWorkYn").val("Y");
		},
		
		/*
		* common Code 
		*/
		comCode : {
			codeMapEx : null,			
			codeMap : null,
			
			initCode : function () {
				var grpCd = 'PROD_PART,ITEM_TYPE,PROCUR_TYPE,FLAG_YN';
				this.codeMap = gfn_getComCode(grpCd, 'Y'); 
				this.codeMapEx = gfn_getComCodeEx(["REP_CUST_GROUP", "CUST_GROUP", "ORDER_ROUTING", "ITEM_GROUP", "UPPER_ITEM_GROUP"], null, {itemType : "10,20,30,40,50"});
				
				this.codeMap.PROD_PART = $.grep(this.codeMap.PROD_PART, function(v, n) {
					if(n == 0){
						v.CODE_CD = "notAll";
						v.CODE_NM = "";
					}
					return v.CODE_CD;
				});
				
				this.codeMap.PROCUR_TYPE = $.grep(this.codeMap.PROCUR_TYPE, function(v, n) {
					return v.CODE_CD == 'MG' || v.CODE_CD == 'MH'; 
				});
			}
		},
	
		/* 
		* grid  선언
		*/
		workerGroupGrid : {
			gridInstance : null,
			grdMain      : null,
			dataProvider : null,
			
			initGrid     : function () {
				
				this.gridInstance = new GRID();
				this.gridInstance.init("realgrid");
				
				this.grdMain      = this.gridInstance.objGrid;
				this.dataProvider = this.gridInstance.objData;
				
				
				this.setOptions();
				
				this.grdMain.onKeyUp = function (grid, key, ctrl, shift, alt) {
					if(key == 46){  //Delete Key
						//gfn_selBlockDelete(grid, facility.facilityGrid.dataProvider); //셀구성  
						gfn_selBlockDelete(grid, workerGroup.workerGroupGrid.dataProvider, "cols"); //컬럼구성  
					}
				};
			},
			
			setOptions : function() {
				
				this.grdMain.setOptions({
                    stateBar: { visible : true },
                });
                
                this.grdMain.addCellStyles([
                
                {
                    id         : "editStyle",
                    editable   : true,
                    background : gv_editColor
                },
                {
                    id         : "editStyleTemp", // 20220118 불작업 N에 대해서도 수정가능할수있게 수정, 색깔은 회새으로 처리 FROM 김영락K
                    editable   : true,
                    background : gv_noneEditColor
                }
                
                ]);
                
                
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
				workerGroup.workerGroupGrid.grdMain.cancel();
				workerGroup.workerGroupGrid.dataProvider.rollback(workerGroup.workerGroupGrid.dataProvider.getSavePoints()[0]);
				 
				$.each(MEASURE.next, function(){
                     workerGroup.workerGroupGrid.grdMain.setCellStyles(workerGroup.getReset.otherCol,this.CD+'_NM', "editStyle");
                     workerGroup.workerGroupGrid.grdMain.setCellStyles(workerGroup.getReset.otherColTemp,this.CD+'_NM', "editStyleTemp");
				});
			});
			
			$("#btnSave").on('click', function (e) {
				workerGroup.save();
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
					if(id == "divProdPart"){
						EXCEL_SEARCH_DATA += $("#prodPart option:selected").text();
					}else if(id == "divItem"){
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
					}else if(id == "divCpfrYn"){
						EXCEL_SEARCH_DATA += $("#cpfrYn option:selected").text();
					}else if(id == "divSsYn"){
						EXCEL_SEARCH_DATA += $("#ssYn option:selected").text();
					}else if(id == "divFireWorkYn"){
						EXCEL_SEARCH_DATA += $("#fireWorkYn option:selected").text();
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
						workerGroup.workerGroupGrid.dataProvider.clearRows(); //데이터 초기화
				
						//그리드 데이터 생성
						workerGroup.workerGroupGrid.grdMain.cancel();
						
						workerGroup.workerGroupGrid.dataProvider.setRows(data.resList);
						workerGroup.workerGroupGrid.dataProvider.clearSavePoints();
						workerGroup.workerGroupGrid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(workerGroup.workerGroupGrid.dataProvider.getRowCount());
						//gfn_actionMonthSum(workerGroup.workerGroupGrid.gridInstance);
						gfn_setRowTotalFixed(workerGroup.workerGroupGrid.grdMain);
						
						workerGroup.gridComboList(data.resList);
					}
				}
			}
			gfn_service(aOption, "obj");
		},
		
		save : function (){
			
			var grdData = gfn_getGrdSavedataAll(this.workerGroupGrid.grdMain);
			
			var grdDataLen = grdData.length;
			if (grdDataLen == 0) {
				alert('<spring:message code="msg.noChangeData"/>');
				return;
			}
			var salesPlanDatas = [];
			
			$.each(grdData, function(i, row) {
				
				var planData = {
					ITEM_CD       : row.ITEM_CD_NM,
					BUCKET_LIST   : []
				};
				
				$.each(row, function(attr, value) {
					
					$.each(MEASURE.next, function(n, v){
						var vCd = v.CD;
						if(attr == vCd){
							var result = eval("row." + vCd + "_NM");
							
							if(result == "" || result == undefined){
								result = "NULL";
							}
							
							planData.BUCKET_LIST.push({
								WORKER_GROUP : vCd,
								VALID_FLAG   : result
							});
						}
					});
				});
				salesPlanDatas.push(planData);
			});
			
			confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
					
				FORM_SAVE            = {}; //초기화
				FORM_SAVE._mtd       = "saveUpdate";
				FORM_SAVE.tranData   = [
					{outDs : "saveCnt", _siq : workerGroup._siq, grdData : salesPlanDatas},
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
		
		getReset : {
            otherCol   : [],
            otherColTemp : []
        },
        
		gridMeasureData : function (){
			
			gfn_service({
			    async   : false,
			    url     : GV_CONTEXT_PATH + "/biz/obj.do",
			    data    : {
	    			_mtd : "getList",
	    			tranData : [
	    				{outDs : "measureCustList", _siq : "aps.static.measureWorkerList"}
	    			]
			    },
			    success :function(data) {
			    	
			    	var tmpProdPart = $("#prodPart").val();
			    	
			    	MEASURE.next = []; //초기화
			    	$.each(data.measureCustList, function(n, v){
			    		
			    		var vCd = v.CODE_CD;
			    		var vNm = v.CODE_NM;
			    		var vAttb1Cd = v.ATTB_1_CD;
			    		
			    		if(tmpProdPart == vAttb1Cd){
			    			MEASURE.next.push({CD : vCd, NM : vNm, equalBlankYn : "N", width : 80, TEXT_ALIGN : "center"});	
			    		}
			    	});
		    	}
			    
			}, "obj");
		},
		
		gridComboList : function (resList){
			gfn_service({
			    async   : false,
			    url     : GV_CONTEXT_PATH + "/biz/obj.do",
			    data    : {
	    			_mtd : "getList",
	    			tranData : [
	    				{outDs : "Routing", _siq : "aps.static.workerGroupRouting"},
	                    {outDs : "authority", _siq : "aps.static.workerGroupAuthority"}
	    			]
			    },
			    success :function(data) {
			    	
			    
			        
			        workerGroup.getReset.otherCol = [];
			        workerGroup.getReset.otherColTemp = [];
			    	if(data.authority.length != 0)
                    {
                        
                        for(i = 0; i < data.authority.length; i++ )
                        {
                            // 곹통권한 소유할 경우 Material routing editable 처리
                            if(data.authority[i].ROLE_CD == "PRO0009"||data.authority[i].ROLE_CD == "PRO0010"||data.authority[i].ROLE_CD == "PRO0011" )
                            {
                                data.Routing.push({CODE_CD:"3-R"});
                                data.Routing.push({CODE_CD:"3-W"});
                            }   
                        }
                        
                    }
			    	
			    	
			        $.each(MEASURE.next, function(n, v){
                        
                        var vCd = v.CD;
                        var vCdNm = vCd + "_NM";
                        
                        var col = workerGroup.workerGroupGrid.grdMain.columnByField(vCdNm);
                        workerGroup.workerGroupGrid.grdMain.setColumnProperty(vCd, "editor", { type: "dropDown", domainOnly: true});
			        
                        if(col != null){
                            
                            
                            col.values = gfn_getArrayExceptInDs(workerGroup.comCode.codeMap.FLAG_YN, "CODE_CD", "");
                            col.labels = gfn_getArrayExceptInDs(workerGroup.comCode.codeMap.FLAG_YN, "CODE_NM", "");
                            
                            
                            workerGroup.workerGroupGrid.grdMain.setColumn(col);
                        
                        }    
			        
			        });
			    	
			        var dataLen = data.Routing.length;
			        for(var i = 0; i < dataLen; i++){
                        
                        var codeCd = data.Routing[i].CODE_CD;
                       
                        $.each(resList, function(n, v){
                        
                        	var routingId   = v.ROUTING_ID_NM;
                        	var fireworkYn = v.FIREWORK_YN_HIDDEN;
                            var itemCode   = v.ITEM_CD
                        	if(codeCd == routingId ){
                        		
                        	
                        	    if(fireworkYn == 'Y'){
                        	    	workerGroup.getReset.otherCol.push(n)	       	
                        	    }
                        	    if(fireworkYn =='N'){
                                    workerGroup.getReset.otherColTemp.push(n)           
                                }
                                
                        	    
                            }
                        	
                        	
                        });
			    	
			         }
			        
			        
			         $.each(MEASURE.next, function(){
	                	 workerGroup.workerGroupGrid.grdMain.setCellStyles(workerGroup.getReset.otherCol,this.CD+'_NM', "editStyle");
	                	 workerGroup.workerGroupGrid.grdMain.setCellStyles(workerGroup.getReset.otherColTemp,this.CD+'_NM', "editStyleTemp");
	                 });
			         
			         
		    	} // END OF SUCCESS {
			}, "obj");
		}
	};
	

	//조회
	var fn_apply = function (sqlFlag) {
		
		var tmpProd = gfn_nvl($("#prodPart").val(), "");
		
		if(tmpProd == "notAll"){
			alert('<spring:message code="msg.prodPartMsg"/>');
			return;
		}
		
		// 디멘젼, 메져
		gfn_getMenuInit();
		
		workerGroup.gridMeasureData();
		
		DIMENSION.hidden = [];
    	DIMENSION.hidden.push({CD:"PROD_LVL2_CD", dataType:"text"  });
    	DIMENSION.hidden.push({CD:"FIREWORK_YN_HIDDEN", dataType:"text"  });
    	
    	if(!sqlFlag){
    		workerGroup.workerGroupGrid.gridInstance.setDraw();
		}
		
		//조회조건 설정
    	FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
    	FORM_SEARCH.dimList    = DIMENSION.user;
    	FORM_SEARCH.hiddenList = DIMENSION.hidden;
    	FORM_SEARCH.meaList	   = MEASURE.next;
    	
		if (!sqlFlag) {
			
			var fileds = workerGroup.workerGroupGrid.dataProvider.getFields();
			for (var i = 0; i < fileds.length; i++) {
				if (fileds[i].fieldName == 'SS_QTY_NM' ||
					fileds[i].fieldName == 'MFG_LT_NM'||
					fileds[i].fieldName == 'SALES_PRICE_KRW_NM') {
					fileds[i].dataType = "number";
					fileds[i].numberFormat = "#,##0";
					
					workerGroup.workerGroupGrid.grdMain.setColumnProperty(fileds[i].fieldName, "styles", {"numberFormat" : "#,##0"});	
				}
			}
			workerGroup.workerGroupGrid.dataProvider.setFields(fileds);
			
		}
		workerGroup.search();
		workerGroup.excelSubSearch();
	}

	// onload 
	$(document).ready(function() {
		workerGroup.init();
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
					<div class="view_combo" id="divItem"></div>
					<div class="view_combo" id="divProcurType"></div>
					<div class="view_combo" id="divUpItemGroup"></div>
					<div class="view_combo" id="divItemGroup"></div>
					<div class="view_combo" id="divRoute"></div>
					<div class="view_combo" id="divRepCustGroup"></div>
					<div class="view_combo" id="divCustGroup"></div>
					<div class="view_combo" id="divCpfrYn"></div>
					<div class="view_combo" id="divSsYn"></div>
					<div class="view_combo" id="divFireWorkYn"></div>
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
