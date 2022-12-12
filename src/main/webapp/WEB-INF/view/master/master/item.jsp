<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
<script type="text/javascript">
    var enterSearchFlag = "Y";
    
    var item = {
            init : function() {
                gfn_formLoad();             // 공통 초기화
                this.auth.search();
                this.comCode.initData();    // 데이터 초기화
                this.initFilter();          // 필터 초기화
                this.grid.initGrid();       // 그리드 초기화
                this.initEvent();           // 이벤트 초기화
            },
            
            comCode : {
                codeMap   : null,
                codeMapEx : null,
                
				codeRoutingFirstClass_2_T : null,
				codeRoutingFirstClass_2_M : null,
				codeRoutingFirstClass_2_L : null,
				
				codeRoutingSecondClass_2_T : null, // 신규추가, 김지혜님, 20221116 김지혜님 요청 
				codeRoutingSecondClass_2_M : null, // 신규추가, 김지혜님, 20221116 김지혜님 요청
				codeRoutingSecondClass_2_L : null,
				
				codeRoutingThirdClass_2_T : null,
				codeRoutingThirdClass_2_M : null,
				codeRoutingThirdClass_2_L : null,
				
                initData  : function() {
                    this.codeMap   = gfn_getComCode("ITEM_TYPE,FLAG_YN,ITEM_GRADE,CAMPUS_PRIORITY,ANNEALING_ITEM_GROUP_CD,PROCUR_TYPE", "Y"); //공통코드 조회
                    this.codeMapEx = gfn_getComCodeEx(["REP_CUST_GROUP","REP_ITEM_GROUP","ROUTING"]);
                    this.codeRoutingFirstClass_2_T = comCodeRouting('2-T','FirstClass');
                    this.codeRoutingFirstClass_2_T.push({CODE_CD:  ' ', CODE_NM_KR: " "});
                    
                    this.codeRoutingFirstClass_2_M = comCodeRouting('2-M','FirstClass');
                    this.codeRoutingFirstClass_2_M.push({CODE_CD: ' ', CODE_NM_KR: " "});
                    
                    this.codeRoutingFirstClass_2_L = comCodeRouting('2-L','FirstClass');
                    this.codeRoutingFirstClass_2_L.push({CODE_CD:  ' ', CODE_NM_KR: " "});
                    
                    // 신규추가, 김지혜님, 20221116 김지혜님 요청
                    /////////////////////////////////////////////////////////////////////////
                    this.codeRoutingSecondClass_2_T = comCodeRouting('2-T','SecondClass');
                    this.codeRoutingSecondClass_2_T.push({CODE_CD: ' ', CODE_NM_KR: " "});
                    
                    this.codeRoutingSecondClass_2_M = comCodeRouting('2-M','SecondClass');
                    this.codeRoutingSecondClass_2_M.push({CODE_CD: ' ', CODE_NM_KR: " "});
                    /////////////////////////////////////////////////////////////////////////
                    
                    this.codeRoutingSecondClass_2_L = comCodeRouting('2-L','SecondClass');
                    this.codeRoutingSecondClass_2_L.push({CODE_CD: ' ', CODE_NM_KR: " "});
                    
                    this.codeRoutingThirdClass_2_T	= comCodeRouting('2-T','ThirdClass');
                    this.codeRoutingThirdClass_2_T.push({CODE_CD: ' ', CODE_NM_KR: " "});
                    
                    this.codeRoutingThirdClass_2_M  = comCodeRouting('2-M','ThirdClass');
                    this.codeRoutingThirdClass_2_M.push({CODE_CD: ' ', CODE_NM_KR: " "});
                    
                    this.codeRoutingThirdClass_2_L  = comCodeRouting('2-L','ThirdClass');
                    this.codeRoutingThirdClass_2_L.push({CODE_CD: ' ', CODE_NM_KR: " "});
                    // 메뉴 정보 확인
                    $.each(gfn_getGlobal("DS_MENU"), function(idx, item) {
                        if (item.MENU_CD == "MNG105") {
                            $("#btnOpenMenu").show();
                            return false;
                        }
                    });
                }
            
            },
            
            auth : {
                authProd : "N",
                authPurc : "N",
                authGoc  : "N",
                authQc   : "N",
                
                search   : function() {
                    gfn_service({
                        async   : false,
                        url     : GV_CONTEXT_PATH + "/biz/obj.do",
                        data    : {
                                    _mtd : "getList",
                                    tranData : [
                                        {outDs : "authorityList", _siq : "master.master.authority"}
                                    ]
                        },
                        success :function(data) {
                            var dataLen = data.authorityList.length;
                            
                            for(var i = 0; i < dataLen; i++) {
                                var menuCd = data.authorityList[i].MENU_CD;
                                
                                if(menuCd == "MNG10101") {//생관권한(생산기획 권한)
                                    item.auth.authProd = "Y";
                                } else if(menuCd == "MNG10102") {//구매권한
                                    item.auth.authPurc = "Y";
                                } else if(menuCd == "MNG10103") {//SCM권한
                                    item.auth.authGoc = "Y";
                                } else if(menuCd == "MNG10104") {//QC권한
                                    item.auth.authQc = "Y";
                                } 
                            }
                            
                        }
                    }, "obj");
                }
            },
            
            excelSubSearch : function (){
                
                EXCEL_SEARCH_DATA = "";
                EXCEL_SEARCH_DATA += "Product" + " : ";
                EXCEL_SEARCH_DATA += $("#loc_product").html();
                
                $.each($(".view_combo"), function(i, val){
                    
                    var temp = "";
                    var id = gfn_nvl($(this).attr("id"), "");
                    
                    if(id != ""){
                        
                        var name = $("#" + id + " .ilist .itit").html();
                        
                        //타이틀
                        EXCEL_SEARCH_DATA += "\n" + name + " : ";   
                        
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
                        }else if(id == "divRepCust"){
                            EXCEL_SEARCH_DATA += $("#reptCust").val();
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
                        }else if(id == "divFireWorkYn"){
                            EXCEL_SEARCH_DATA += $("#fireworkYn option:selected").text();
                        }else if(id == "divCleaningYn"){
                            EXCEL_SEARCH_DATA += $("#cleaningYn option:selected").text();
                        }else if(id == "divLpYn"){
                            EXCEL_SEARCH_DATA += $("#lpYn option:selected").text();
                        }else if(id == "divOsYn"){
                            EXCEL_SEARCH_DATA += $("#osYn option:selected").text();
                        }else if(id == "divValidYn"){
                            EXCEL_SEARCH_DATA += $("#validYn option:selected").text();
                        }else if(id == "divValidYnERP"){
                            EXCEL_SEARCH_DATA += $("#validYnERP option:selected").text();
                        }else if(id == "divValiDate"){
                            EXCEL_SEARCH_DATA += $("#validDateFrom").val() + " ~ " + $("#validDateTo").val();
                        }
                    }
                });
                //console.log(EXCEL_SEARCH_DATA);
            },
            
            grid : {
                gridInstance : null,
                grdMain      : null,
                dataProvider : null,
                initGrid     : function() {
                    this.gridInstance = new GRID();
                    this.gridInstance.init("realgrid");
                    
                    this.grdMain      = this.gridInstance.objGrid;
                    this.dataProvider = this.gridInstance.objData;
                    
                    this.gridInstance.measureHFlag = true;      // 메저 행모드 안보이게..
                    this.gridInstance.measureCFlag = true;
                    
                    item.setOptions();
                }
            },
            
            setOptions : function() {
                item.grid.grdMain.setOptions({
                    stateBar: { visible       : true  },
                    sorting : { enabled       : true  },
                    display : { columnMovable : false }
                }); 
                
                item.grid.grdMain.setPasteOptions({
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
                
                //positiveOnly: true
                
                //스타일 추가
                item.grid.grdMain.addCellStyles([{
                    id         : "editStyle",
                    editable   : true,
                    background : gv_editColor
                }]);
                
                item.grid.grdMain.addCellStyles([{
                    id         : "editAuthNoneStyle",
                    editable   : true,
                    background : gv_noneEditColor
                }]);
                
                item.grid.grdMain.addCellStyles([{
                    id         : "editNoneStyle",
                    editable   : false,
                    background : gv_noneEditColor
                }]);
                
                
            }, 
            
            initFilter : function() {
                // 키워드팝업
                gfn_keyPopAddEvent([
                    { target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>' }
                ]);
                
                // 콤보박스
                gfn_setMsComboAll([
                    { target : 'divItemType'     , id : 'itemType'     , title : '<spring:message code="lbl.itemType"/>'     , data : this.comCode.codeMap.ITEM_TYPE , exData:[''] },
                    { target : 'divProcurType'      , id : 'procurType'   , title : '<spring:message code="lbl.procure"/>'      , data : this.comCode.codeMap.PROCUR_TYPE, exData:[""] },
                    { target : 'divReptItemGroup', id : 'reptItemGroup', title : '<spring:message code="lbl.reptItemGroup"/>', data : this.comCode.codeMapEx.REP_ITEM_GROUP, exData:[  ] },
                    { target : 'divRoute'        , id : 'route'        , title : '<spring:message code="lbl.routing"/>'      , data : this.comCode.codeMapEx.ROUTING,        exData:["*"] },
                    { target : 'divRepCustGroup' , id : 'reptCustGroup', title : '<spring:message code="lbl.reptCustGroup"/>', data : this.comCode.codeMapEx.REP_CUST_GROUP, exData:["*"] },
                    { target : 'divFireWorkYn'   , id : 'fireworkYn'   , title : '<spring:message code="lbl.fireYn"/>'       , data : this.comCode.codeMap.FLAG_YN   , exData:[  ], type : "S" },
                    { target : 'divCleaningYn'   , id : 'cleaningYn'   , title : '<spring:message code="lbl.cleanYn"/>'       , data : this.comCode.codeMap.FLAG_YN   , exData:[  ], type : "S" },
                    { target : 'divValidYn'      , id : 'validYn'      , title : '<spring:message code="lbl.validYn"/>'      , data : this.comCode.codeMap.FLAG_YN   , exData:[  ], type : "S" },
                    { target : 'divValidYnERP'   , id : 'validYnERP'   , title : '<spring:message code="lbl.validYnErp"/>'   , data : this.comCode.codeMap.FLAG_YN   , exData:[  ], type : "S" },
                    { target : 'divLpYn'         , id : 'lpYn'         , title : '<spring:message code="lbl.lpYn"/>'   , data : this.comCode.codeMap.FLAG_YN   , exData:[  ], type : "S" },
                    { target : 'divOsYn'         , id : 'osYn'         , title : '<spring:message code="lbl.osYn"/>'   , data : this.comCode.codeMap.FLAG_YN   , exData:[  ], type : "S" }
                ]);
                
                // 달력
                DATEPICKET({
                    arrTarget : [
                        { calId : "validDateFrom", validType : "from", validId : "validDateTo"  , defVal : 0 },
                        { calId : "validDateTo"  , validType : "to"  , validId : "validDateFrom", defVal : 0 }
                    ]
                });
                
                // 필터값 초기화
                $("#validYn").val("Y");
                $("#searchForm .datepicker2").val("");
                $("#searchForm .datepicker2").datepicker("option", "minDate"  , "1950-01-01");
                $("#searchForm .datepicker2").datepicker("option", "maxDate"  , fn_getDate(2));
                $("#searchForm .datepicker2").datepicker("option", "yearRange", "1950:"+(new Date().getFullYear()+2))
                
                //숫자만입력
                $("#fromAmt,#toAmt,#fromLt,#toLt").inputmask("numeric");
            },
            
            initEvent : function() {
                $(".fl_app"     ).click("on", function() { fn_apply(); });
                $("#btnOpenMenu").click("on", function() { gfn_newTab("MNG105"); });
                $("#btnSave"    ).click("on", function() { fn_save(); });
                $("#btnReset").on('click', function (e) {
                    item.grid.grdMain.cancel();
                    item.grid.dataProvider.rollback(item.grid.dataProvider.getSavePoints()[0]);
                    
                    item.grid.grdMain.setCellStyles(item.getReset.campus, "CAMPUS_PRIORITY", "editStyle");            // 캠퍼스 우선순위
                    item.grid.grdMain.setCellStyles(item.getReset.campus2, "CAMPUS_PRIORITY", "editAuthNoneStyle");   // 캠퍼스 우선순위
                    item.grid.grdMain.setCellStyles(item.getReset.area, "AREA", "editStyle");                         // 제품면적
                    item.grid.grdMain.setCellStyles(item.getReset.area2, "AREA", "editAuthNoneStyle");                // 제품면적
                    item.grid.grdMain.setCellStyles(item.getReset.loadYn, "LOAD_YN", "editStyle");                    // 적재여부
                    item.grid.grdMain.setCellStyles(item.getReset.loadYn2, "LOAD_YN", "editAuthNoneStyle");           // 적재여부
                    item.grid.grdMain.setCellStyles(item.getReset.loadQty, "LOAD_QTY", "editStyle");                  // 최대 적재 수량
                    item.grid.grdMain.setCellStyles(item.getReset.loadQty2, "LOAD_QTY", "editAuthNoneStyle");         // 최대 적재 수량
                    item.grid.grdMain.setCellStyles(item.getReset.keyMatYn, "KEY_MAT_YN", "editStyle");               // Key 자재 여부
                    item.grid.grdMain.setCellStyles(item.getReset.keyMatYn2, "KEY_MAT_YN", "editAuthNoneStyle");      // Key 자재 여부
                    
                                                                                                                      // 반영 LT
                                                                                                                      
                    item.grid.grdMain.setCellStyles(item.getReset.minPurLt, "MIN_PUR_LT", "editStyle");               // 입고 LT          
                    item.grid.grdMain.setCellStyles(item.getReset.minPurLt2, "MIN_PUR_LT", "editNoneStyle");          // 입고 LT(수정불가)
                    
                    item.grid.grdMain.setCellStyles(item.getReset.bufferPurLt, "BUFFER_PUR_LT", "editStyle");         // 자재입고 버퍼 LT
                    item.grid.grdMain.setCellStyles(item.getReset.bufferPurLt2, "BUFFER_PUR_LT", "editAuthNoneStyle");// 자재입고 버퍼 LT
                    item.grid.grdMain.setCellStyles(item.getReset.sbsQty, "SBS_QTY", "editStyle");                    // 전략 재고
                    item.grid.grdMain.setCellStyles(item.getReset.sbsQty2, "SBS_QTY", "editNoneStyle");               // 전략 재고(수정불가)
                    item.grid.grdMain.setCellStyles(item.getReset.grMngYn, "GR_MNG_YN", "editStyle");                    // 입고수량 관리여부
                    item.grid.grdMain.setCellStyles(item.getReset.grMngYn2, "GR_MNG_YN", "editAuthNoneStyle");           // 입고수량 관리여부
                    item.grid.grdMain.setCellStyles(item.getReset.weeklyGrQty, "WEEKLY_GR_QTY", "editStyle");                    // 주당 입고 가능수량
                    item.grid.grdMain.setCellStyles(item.getReset.weeklyGrQty2, "WEEKLY_GR_QTY", "editAuthNoneStyle");           // 주당 입고 가능수량
                    item.grid.grdMain.setCellStyles(item.getReset.firstClass, "FIRST_CLASS", "editStyle");                    // 대분류
                    item.grid.grdMain.setCellStyles(item.getReset.firstClass2, "FIRST_CLASS", "editNoneStyle");           // 대분류
                    item.grid.grdMain.setCellStyles(item.getReset.secondClass, "SECOND_CLASS", "editStyle");               // 중분류
                    item.grid.grdMain.setCellStyles(item.getReset.secondClass2, "SECOND_CLASS", "editNoneStyle");          // 중분류
                    item.grid.grdMain.setCellStyles(item.getReset.thirdClass, "THIRD_CLASS", "editStyle");                // 소분류
                    item.grid.grdMain.setCellStyles(item.getReset.thirdClass2, "THIRD_CLASS", "editNoneStyle");           // 소분류
                });
                
                this.grid.grdMain.onEditRowChanged = function (grid, itemIndex, dataRow, field, oldValue, newValue) {
                    
                    var provider = item.grid.dataProvider;
                    var filedNm  = provider.getFieldName(field);
                    
                    var minPurLt  = 0;
                    var recInspLt = 0;
                    var recInspYn = "";
                    var keyMapLt  = 0;
                
                    if(filedNm == "MIN_PUR_LT") {
                        minPurLt  = newValue;
                        
                        recInspLt = gfn_nvl(provider.getValue(dataRow, "REC_INSP_LT"), 0);
                        recInspYn = gfn_nvl(provider.getValue(dataRow, "REC_INSP_YN"), "");
                    }
                    
                    if(filedNm == "MIN_PUR_LT") {
                        if(recInspYn == "Y") {
                            keyMapLt = Number(minPurLt) + Number(recInspLt);
                        } else {
                            keyMapLt = Number(minPurLt);
                        }
                        
                        provider.setValue(dataRow, "KEY_MAT_LT", keyMapLt);
                    }
                    
                    if(filedNm == "KEY_MAT_YN") {
                        if(newValue == "N") {
                            item.grid.grdMain.setCellStyles(dataRow, "MIN_PUR_LT", "editNoneStyle");
                        } else {
                            item.grid.grdMain.setCellStyles(dataRow, "MIN_PUR_LT", "editStyle");
                        }
                    }
                };
                
                this.grid.grdMain.onKeyUp = function (grid, key, ctrl, shift, alt) {
                    if(key == 46){  //Delete Key
                        //gfn_selBlockDelete(grid, item.grid.dataProvider);  
                        gfn_selBlockDelete(grid, item.grid.dataProvider, "cell");
                    }
                };
                
               /* 
              //사용자 입력이 셀에 반영될때 발생하는 이벤트
                this.grid.grdMain.onEditCommit = function (id, index, oldValue, newValue) {
                    if (index.field == "FIRST_CLASS") {
                       // lookupDataChange(newValue);
                    }
                };
              */

              //그리드의 포커스 셀의 위치가 변경된 후 발생하는 이벤트
              /*  
              this.grid.grdMain.onCurrentChanged = function (grid, newIndex) {
                    if (newIndex && newIndex.dataRow > -1) {
                    	//console.log("newIndex:",newIndex);
                        var keyValue = grid.getValue(newIndex.itemIndex, "ROUTING_ID_NM");
                        console.log("keyValue:",keyValue);
                        if(keyValue=='2-T')
                        {
                        	//lookupDataChange(keyValue);	
                        }
                        else if(keyValue=='2-M')
                        {
                        	//lookupDataChange(keyValue);
                        }
                        else if(keyValue=='2-L')
                        {
                        	//lookupDataChange(keyValue);
                        }

                        
                    }
                };
                */
            },
            
            getBucket : function(sqlFlag) {
                
                if (!sqlFlag) {
                    
                    // 데이터셋에만 존재하는 컬럼 추가
                    DIMENSION.hidden = [];
                    DIMENSION.hidden.push({CD:"COMPANY_CD"  , dataType:"text"});
                    DIMENSION.hidden.push({CD:"BU_CD"       , dataType:"text"});
                    DIMENSION.hidden.push({CD:"REC_INSP_YN" , dataType:"text"});
                    DIMENSION.hidden.push({CD:"REC_INSP_LT" , dataType:"number"});
                    DIMENSION.hidden.push({CD:"ITEM_TYPE"   , dataType:"text"});
                    DIMENSION.hidden.push({CD:"PROCUR_TYPE" , dataType:"text"});
                    
                    for (var i in DIMENSION.user) {
                        if (DIMENSION.user[i].DIM_CD.indexOf("SALES_PRICE_KRW") > -1) {
                            DIMENSION.user[i].numberFormat = "#,##0";
                        }
                        
                        if (DIMENSION.user[i].DIM_CD.indexOf("OS_PRICE_KRW") > -1) {
                            DIMENSION.user[i].numberFormat = "#,##0";
                        }
                        
                        if (DIMENSION.user[i].DIM_CD.indexOf("OUT_LOT_SIZE") > -1) {
                            DIMENSION.user[i].numberFormat = "#,##0";
                        }
                        
                        if (DIMENSION.user[i].DIM_CD.indexOf("PROCESS_TIME") > -1) {
                            DIMENSION.user[i].numberFormat = "#,##0.0";
                        }
                        
                        if (DIMENSION.user[i].DIM_CD.indexOf("SS_QTY") > -1) {
                            DIMENSION.user[i].numberFormat = "#,##0";
                        }
                        
                        if (DIMENSION.user[i].DIM_CD.indexOf("BOM_CNT") > -1) {
                            DIMENSION.user[i].numberFormat = "#,##0";
                        }
                        
                        if (DIMENSION.user[i].DIM_CD.indexOf("PUR_LT") > -1) {
                            DIMENSION.user[i].numberFormat = "#,##0";
                        }
                        
                        if (DIMENSION.user[i].DIM_CD.indexOf("MFG_LT") > -1) {
                            DIMENSION.user[i].numberFormat = "#,##0";
                        }
                    }
                    
                    for (var i in MEASURE.user) {
                        if (MEASURE.user[i].CD.indexOf("AREA") > -1 || MEASURE.user[i].CD.indexOf("LOAD_QTY") > -1 || MEASURE.user[i].CD.indexOf("KEY_MAT_LT") > -1 ||
                            MEASURE.user[i].CD.indexOf("MIN_PUR_LT") > -1 || MEASURE.user[i].CD.indexOf("REC_INSP_LT") > -1 || MEASURE.user[i].CD.indexOf("BUFFER_PUR_LT") > -1 || MEASURE.user[i].CD.indexOf("SBS_QTY") > -1
                            ||MEASURE.user[i].CD.indexOf("WEEKLY_GR_QTY") > -1
                        ) 
                        {
                            MEASURE.user[i].dataType = "number";
                        }
                        
                    }
                    
                    item.grid.gridInstance.setDraw();
                    
                    var fileds = item.grid.dataProvider.getFields();
                    
                    for (var i in fileds) {
                        if (fileds[i].fieldName.indexOf("SALES_PRICE_KRW") > -1) {
                            fileds[i].dataType = "number";
                        }
                        
                        if (fileds[i].fieldName.indexOf("OS_PRICE_KRW") > -1) {
                            fileds[i].dataType = "number";
                        }
                        
                        if (fileds[i].fieldName.indexOf("OUT_LOT_SIZE") > -1) {
                            fileds[i].dataType = "number";
                        }
                        
                        if (fileds[i].fieldName.indexOf("PROCESS_TIME") > -1) {
                            fileds[i].dataType = "number";
                        }
                        
                        if (fileds[i].fieldName.indexOf("SS_QTY") > -1) {
                            fileds[i].dataType = "number";
                        }
                        
                        if (fileds[i].fieldName.indexOf("BOM_CNT") > -1) {
                            fileds[i].dataType = "number";
                        }
                        
                        if (fileds[i].fieldName.indexOf("PUR_LT") > -1) {
                            fileds[i].dataType = "number";
                        }
                        
                        if (fileds[i].fieldName.indexOf("MFG_LT") > -1) {
                            fileds[i].dataType = "number";
                        }
                        if (fileds[i].fieldName.indexOf("WEEKLY_GR_QTY") > -1) {
                            fileds[i].dataType = "number";
                        }
                        
                    }
                    item.grid.dataProvider.setFields(fileds);
                    
                  /*
                  //lookup tree에서 사용할 lookup source들을 등록
                    item.grid.grdMain.setLookups([{
                        id: "firstCLASS",
                        levels: 1,
                        keys: [
                            ["France", "VINET"],
                            ["France", "VICTE"],
                            ["Germany", "TOMSP"],
                            ["Brazil", "HANAR"]
                        ],
                        values: [
                            "Vins et alcools Chevalier",
                            "Victuailles en stock",
                            "Toms Spezialitäten",
                            "Hanari Carnes"
                        ]

                    }]);
                  
					
                    item.grid.grdMain.setLookups([{
                        id: "secondCLASS",
                        levels: 2,
                        keys: [],
                        values: []

                    }]);
                  
                    
                    item.grid.grdMain.setLookups([{
                        id: "thirdCLASS",
                        levels: 3,
                        keys: [],
                        values: []

                    }]);
                  */
                    
                    $.each(MEASURE.user, function() {
                        var col = item.grid.grdMain.columnByName(this.CD);
                        
                        
                        if(this.CD == "CAMPUS_PRIORITY" || this.CD == "LOAD_YN" || this.CD == "KEY_MAT_YN" || this.CD == "REC_INSP_YN" || this.CD == "GR_MNG_YN") {
                        	item.grid.grdMain.setColumnProperty(this.CD, "editor", { type: "dropDown", domainOnly: true });
                            if(this.CD == "CAMPUS_PRIORITY") {
                                col.values = gfn_getArrayExceptInDs(item.comCode.codeMap.CAMPUS_PRIORITY, "CODE_CD", "");
                                col.labels = gfn_getArrayExceptInDs(item.comCode.codeMap.CAMPUS_PRIORITY, "CODE_NM", "");
                            } 
                           
                            else {
                                col.values = gfn_getArrayExceptInDs(item.comCode.codeMap.FLAG_YN, "CODE_CD", "");
                                col.labels = gfn_getArrayExceptInDs(item.comCode.codeMap.FLAG_YN, "CODE_NM", "");
                            }
                            col.styles = {textAlignment: "center", background : gv_noneEditColor};
                            col.lookupDisplay = true;
                        }else if(this.CD == "AREA" || this.CD == "LOAD_QTY" || this.CD == "KEY_MAT_LT" || this.CD == "MIN_PUR_LT" || this.CD == "REC_INSP_LT" || this.CD == "SBS_QTY" || this.CD == "BUFFER_PUR_LT"|| this.CD == "WEEKLY_GR_QTY") {
                            item.grid.grdMain.setColumnProperty(this.CD, "editor", {type : "number", positiveOnly : true, integerOnly : true});
                            col.styles = {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"};
                        }
                        else if(this.CD == "FIRST_CLASS") {
                        	

                           col.editable = true;
                        }
                        else if(this.CD == "SECOND_CLASS") {
                        	

                            col.editable = true;
                         }
                        else if(this.CD == "THIRD_CLASS") {
                        	

                            col.editable = true;
                         }
                         
                        /* else if(this.CD == "BUFFER_PUR_LT"){
                            
                        } */
                        
                        col.equalBlank = false;
                        
                        item.grid.grdMain.setColumn(col);
                    });
                    

                }
            },
            
            search : function() {
                FORM_SEARCH._mtd     = "getList";
                FORM_SEARCH.tranData = [{outDs:"resList",_siq:"master.master.item"}];
                
                var aOption = {
                    url     : GV_CONTEXT_PATH + "/biz/obj.do",
                    data    : FORM_SEARCH,
                    success : function (data) {
                        
                        if (FORM_SEARCH.sql == 'N') {
                            //그리드 데이터 삭제
                            item.grid.dataProvider.clearRows();
                            item.grid.grdMain.cancel();
                            //그리드 데이터 생성
                            item.grid.dataProvider.setRows(data.resList);
                            
                            item.grid.dataProvider.clearSavePoints();
                            item.grid.dataProvider.savePoint();
                            // 그리드 데이터 건수 출력
                            gfn_setSearchRow(item.grid.dataProvider.getRowCount());
                            
                            //fn_authority();
                            item.gridCallback(data.resList);
                            func_setColumnProperty();
                        }
                    }
                }
                
                gfn_service(aOption, "obj");
            },
            
            getReset : {
                campus   : [],
                campus2  : [],
                area     : [],
                area2    : [],
                loadYn   : [],
                loadYn2  : [],
                loadQty  : [],
                loadQty2 : [],
                keyMatYn : [],
                keyMatYn2 : [],
                minPurLt : [],
                minPurLt2 : [],
                bufferPurLt : [],
                bufferPurLt2 : [],
                sbsQty       : [],
                sbsQty2      : [],
                grMngYn       : [],
                grMngYn2      : [],
                weeklyGrQty   : [],
                weeklyGrQty2  : [],
                firstClass    : [],
                firstClass2    : [],
                secondClass    : [],
               	secondClass2    : [],
                thirdClass    : [],
                tnirdClass2    : [],
                
            },
            
            gridCallback : function(resList) {
                
                item.getReset.campus = [];
                item.getReset.campus2 = [];
                item.getReset.area = [];
                item.getReset.area2 = [];
                item.getReset.loadYn = [];
                item.getReset.loadYn2 = [];
                item.getReset.loadQty = [];
                item.getReset.loadQty2 = [];
                item.getReset.keyMatYn = [];
                item.getReset.keyMatYn2 = [];
                item.getReset.minPurLt = [];
                item.getReset.minPurLt2 = [];
                item.getReset.bufferPurLt = [];
                item.getReset.bufferPurLt2 = [];
                item.getReset.sbsQty = [];
                item.getReset.sbsQty2 = [];
                item.getReset.grMngYn = [];
                item.getReset.grMngYn2 = [];
                item.getReset.weeklyGrQty = [];
                item.getReset.weeklyGrQty2 = [];
                item.getReset.firstClass = [];
                item.getReset.firstClass2 = [];
                item.getReset.secondClass = [];
                item.getReset.secondClass2 = [];
                item.getReset.thirdClass = [];
                item.getReset.thirdClass2 = [];
                
                $.each(resList, function(n, v){
                    var produrType = v.PROCUR_TYPE;
                    var itemType = v.ITEM_TYPE;
                    var fireworkYn = v.FIREWORK_YN;
                    var keyMatYn = v.KEY_MAT_YN;
                    var annealingYn = v.ANNEALING_YN;
                    var routing		= v.ROUTING_ID
                    // 캠퍼스 우선순위
                    if(item.grid.grdMain.columnByName("CAMPUS_PRIORITY")) {
                        if(item.auth.authProd == "Y" || item.auth.authGoc == "Y") {  // 생관권한(생산기획 권한) 또는  SCM권한
                            if(produrType == "MG" || produrType == "MH" || produrType == "MM") {  // 조달구분(사내가공품) 또는 조달구분(사내반제품) 또는 조달구분(원자재생산품)
                                item.getReset.campus.push(n);// 수정가능, 색깔노랑
                            } else {//수정가능, 색깔회색
                                item.getReset.campus2.push(n);
                            }
                        }
                        //수정불가, 색깔회색
                    }
                    
                    // 제품면적
                    if(item.grid.grdMain.columnByName("AREA")) {
                        if(item.auth.authProd == "Y" || item.auth.authGoc == "Y") {  // 생관권한(생산기획 권한) 또는  SCM권한
                            if(annealingYn == "Y") {        // 어닐링 YN이  Y이면 
                                item.getReset.area.push(n);// 수정가능, 색깔노랑
                            } else {//수정가능, 색깔회색
                                item.getReset.area2.push(n);
                            }
                        }
                        //수정불가, 색깔회색
                    }
                    
                    // 적재여부
                    if(item.grid.grdMain.columnByName("LOAD_YN")) {
                        if(item.auth.authProd == "Y") {                             // 생관권한(생산기획 권한)
                            if(annealingYn == "Y") {         // 어닐링 YN이  Y이면 
                                item.getReset.loadYn.push(n);//색깔 노랑, 수정가능
                            } else {//수정가능, 색깔회색
                                item.getReset.loadYn2.push(n);//
                            }
                        }
                        // 수정불가, 색깔회색
                    }
                    
                    // 최대 적재 수량
                    if(item.grid.grdMain.columnByName("LOAD_QTY")) {
                        if(item.auth.authProd == "Y") {                    // 생관권한(생산기획 권한)
                            if(annealingYn == "Y") {           // 어닐링 YN이  Y이면 
                                item.getReset.loadQty.push(n); //색깔 노랑, 수정가능
                            } else {//수정가능, 색깔회색
                                item.getReset.loadQty2.push(n);
                            }
                        }
                        // 수정불가, 색깔회색
                    }
                    
                    // Key 자재 여부
                    if(item.grid.grdMain.columnByName("KEY_MAT_YN")) {
                        if(item.auth.authProd == "Y" || item.auth.authGoc == "Y") {  // 생관권한(생산기획 권한) 또는  SCM권한
                            if(produrType == "MG" || itemType == "50") {             // 사내가공품 또는  품목유형(상품)
                                item.getReset.keyMatYn2.push(n);// 수정가능, 색깔 회색
                            }else{//수정가능, 색깔노랑
                                item.getReset.keyMatYn.push(n);     
                            }
                        }
                        //수정불가, 색깔회색
                    }
                    
                    // 입고 L/T
                    if(item.grid.grdMain.columnByName("MIN_PUR_LT")) {              
                        if(item.auth.authPurc == "Y" || item.auth.authGoc == "Y") {  // 생관권한(생산기획 권한) 또는  SCM권한
                            if(keyMatYn != "N" && produrType != "MG") {   // Key 자재 여부 'N'이 아니고 && 조달구분(사내가공품)이 아니면
                                item.getReset.minPurLt.push(n);
                            } else {//수정불가, 색깔회색
                                item.getReset.minPurLt2.push(n);
                            }
                        }
                        //수정불가, 색깔회색
                    }
                    
                    //자재입고 버퍼 LT
                    //ITEM_TYPE = '20' AND PROCUR_TYPE = 'OH' -> YELLOW
                    //ITEM_TYPE = '30' AND PROCUR_TYPE = 'OP' -> YELLOW
                    //다른것들은 GREY                    
                    if(item.grid.grdMain.columnByName("BUFFER_PUR_LT")) {
                        if(item.auth.authGoc == "Y") {                 // SCM권한
                            if((itemType == "20" && produrType == "OH") || (itemType == "30" && produrType == "OP")){ //품목유형(반제품)이고 조달구분(외주반제품)이거나  또는   품목유형(원자재)이고 조달구분(구매품)
                                item.getReset.bufferPurLt.push(n);
                            } else {//수정가능, 색깔회색
                                item.getReset.bufferPurLt2.push(n);
                            }
                        }else{ //수정가능, 색깔회색
                            item.getReset.bufferPurLt2.push(n);
                        }
                    }
                    
                    //전략 재고
                    if(item.grid.grdMain.columnByName("SBS_QTY")) {                 
                        if(item.auth.authGoc == "Y" && itemType == "10" ) {   //SCM권한이고 품목유형(제품)
                            item.getReset.sbsQty.push(n);
                        }else{  // 수정불가, 색깔회색
                            item.getReset.sbsQty2.push(n);
                        }
                    }
                    
                    //입고수량 관리여부
                    if(item.grid.grdMain.columnByName("GR_MNG_YN")) {             
                    
                        if(item.auth.authProd == "Y" || item.auth.authGoc == "Y" || item.auth.authPurc == "Y") //생관권한, 구매권한, SCM권한 을 가지고 있을 경우 수정가능
                        {
                            if((itemType == "20" && produrType == "OH") || (itemType == "30" && produrType == "OP") ) {   //(품목유형) 반제품 & (조달유형) 외주반제품 또는 (품목유형) 원자재 & (조달유형) 구매품
                                item.getReset.grMngYn.push(n);
                            }else{  // 수정가능, 색깔회색
                                item.getReset.grMngYn2.push(n);
                            }   
                        }
                        //그외 수정불가, 색깔회색                 
                    }
                    
                    //주당 입고 가능수량
                    if(item.grid.grdMain.columnByName("WEEKLY_GR_QTY")) {             
                    
                        if(item.auth.authProd == "Y" || item.auth.authGoc == "Y" || item.auth.authPurc == "Y")
                        {
                            if((itemType == "20" && produrType == "OH") || (itemType == "30" && produrType == "OP") ) {   //(품목유형) 반제품 & (조달유형) 외주반제품 또는 (품목유형) 원자재 & (조달유형) 구매품
                                item.getReset.weeklyGrQty.push(n);
                            }else{  // 수정가능, 색깔회색
                                item.getReset.weeklyGrQty2.push(n);
                            }
                        }
                        //그외 수정불가, 색깔회색
                    }
                    
                  //대분류
                    if(item.grid.grdMain.columnByName("FIRST_CLASS")) {             
                    
                        if(item.auth.authProd == "Y" || item.auth.authGoc == "Y" || item.auth.authPurc == "Y")
                        {
                            if((routing == "2-T" ) || (routing == "2-M" )|| (routing == "2-L" )) {   //routing: 2-T, 2-M, 2-L 에 대해 drop down 처리, 나머지는 not editable
                                item.getReset.firstClass.push(n);
                            }else{  // 수정가능, 색깔회색
                                item.getReset.firstClass2.push(n);
                            }
                        }
                        //그외 수정불가, 색깔회색
                    }
                  
                  //중분류
                    if(item.grid.grdMain.columnByName("SECOND_CLASS")) {             
                    
                        if(item.auth.authProd == "Y" || item.auth.authGoc == "Y" || item.auth.authPurc == "Y")
                        {
                            if((routing == "2-T") || (routing == "2-M" )|| (routing == "2-L" )) {   //routing: 2-T, 2-M, 2-L 에 대해 drop down 처리, 나머지는 not editable
                                item.getReset.secondClass.push(n);
                            }else{  // 수정가능, 색깔회색
                                item.getReset.secondClass2.push(n);
                            }
                        }
                        //그외 수정불가, 색깔회색
                    }
                  //소분류
                    if(item.grid.grdMain.columnByName("THIRD_CLASS")) {             
                    
                        if(item.auth.authProd == "Y" || item.auth.authGoc == "Y" || item.auth.authPurc == "Y")
                        {
                            if((routing == "2-T" ) || (routing == "2-M" )|| (routing == "2-L" )) {   //routing: 2-T, 2-M, 2-L 에 대해 drop down 처리, 나머지는 not editable
                                item.getReset.thirdClass.push(n);
                            }else{  // 수정가능, 색깔회색
                                item.getReset.thirdClass2.push(n);
                            }
                        }
                        //그외 수정불가, 색깔회색
                    }
                  
                  
                  
                });
                
                item.grid.grdMain.setCellStyles(item.getReset.campus, "CAMPUS_PRIORITY", "editStyle");            // 캠퍼스 우선순위
                item.grid.grdMain.setCellStyles(item.getReset.campus2, "CAMPUS_PRIORITY", "editAuthNoneStyle");   // 캠퍼스 우선순위
                item.grid.grdMain.setCellStyles(item.getReset.area, "AREA", "editStyle");                         // 제품면적
                item.grid.grdMain.setCellStyles(item.getReset.area2, "AREA", "editAuthNoneStyle");                // 제품면적
                item.grid.grdMain.setCellStyles(item.getReset.loadYn, "LOAD_YN", "editStyle");                    // 적재여부
                item.grid.grdMain.setCellStyles(item.getReset.loadYn2, "LOAD_YN", "editAuthNoneStyle");           // 적재여부
                item.grid.grdMain.setCellStyles(item.getReset.loadQty, "LOAD_QTY", "editStyle");                  // 최대 적재 수량
                item.grid.grdMain.setCellStyles(item.getReset.loadQty2, "LOAD_QTY", "editAuthNoneStyle");         // 최대 적재 수량
                item.grid.grdMain.setCellStyles(item.getReset.keyMatYn, "KEY_MAT_YN", "editStyle");               // Key 자재 여부
                item.grid.grdMain.setCellStyles(item.getReset.keyMatYn2, "KEY_MAT_YN", "editAuthNoneStyle");      // Key 자재 여부
                
                                                                                                                  // 반영 LT
                                                                                                                  
                item.grid.grdMain.setCellStyles(item.getReset.minPurLt, "MIN_PUR_LT", "editStyle");               // 입고 LT          
                item.grid.grdMain.setCellStyles(item.getReset.minPurLt2, "MIN_PUR_LT", "editNoneStyle");          // 입고 LT(수정불가)
                
                item.grid.grdMain.setCellStyles(item.getReset.bufferPurLt, "BUFFER_PUR_LT", "editStyle");         // 자재입고 버퍼 LT
                item.grid.grdMain.setCellStyles(item.getReset.bufferPurLt2, "BUFFER_PUR_LT", "editAuthNoneStyle");// 자재입고 버퍼 LT
                item.grid.grdMain.setCellStyles(item.getReset.sbsQty, "SBS_QTY", "editStyle");                    // 전략 재고
                item.grid.grdMain.setCellStyles(item.getReset.sbsQty2, "SBS_QTY", "editNoneStyle");               // 전략 재고(수정불가)
                item.grid.grdMain.setCellStyles(item.getReset.grMngYn, "GR_MNG_YN", "editStyle");                    // 입고수량 관리여부
                item.grid.grdMain.setCellStyles(item.getReset.grMngYn2, "GR_MNG_YN", "editAuthNoneStyle");           // 입고수량 관리여부
                item.grid.grdMain.setCellStyles(item.getReset.weeklyGrQty, "WEEKLY_GR_QTY", "editStyle");                    // 주당 입고 가능수량
                item.grid.grdMain.setCellStyles(item.getReset.weeklyGrQty2, "WEEKLY_GR_QTY", "editAuthNoneStyle");           // 주당 입고 가능수량
                item.grid.grdMain.setCellStyles(item.getReset.firstClass, "FIRST_CLASS", "editStyle");                // 대분류
                item.grid.grdMain.setCellStyles(item.getReset.firstClass2, "FIRST_CLASS", "editNoneStyle");           // 대분류
                item.grid.grdMain.setCellStyles(item.getReset.secondClass, "SECOND_CLASS", "editStyle");               // 중분류
                item.grid.grdMain.setCellStyles(item.getReset.secondClass2, "SECOND_CLASS", "editNoneStyle");          // 중분류
                item.grid.grdMain.setCellStyles(item.getReset.thirdClass, "THIRD_CLASS", "editStyle");                // 소분류
                item.grid.grdMain.setCellStyles(item.getReset.thirdClass2, "THIRD_CLASS", "editNoneStyle");           // 소분류
               
                
            }
    };
    
    var fn_apply = function (sqlFlag) {
        item.grid.grdMain.commit();
        gfn_getMenuInit();
        item.getBucket(sqlFlag);
        
        FORM_SEARCH            = $("#searchForm").serializeObject(); 
        FORM_SEARCH.sql        = sqlFlag;
        FORM_SEARCH.hrcyFlag   = true;
        FORM_SEARCH.dimList    = DIMENSION.user;
        FORM_SEARCH.meaList    = MEASURE.user;
        
        item.search();
        item.excelSubSearch();
    }
    
    function fn_save() {
        var grdData = gfn_getGrdSavedataAll(item.grid.grdMain);
        if (grdData.length == 0) {
            alert('<spring:message code="msg.noChangeData"/>');  //변경된 데이터가 없습니다.
            return;
        }
        
        confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
            //저장
            FORM_SAVE = {}; //초기화
            FORM_SAVE._mtd   = "saveUpdate";
            FORM_SAVE.tranData = [{outDs:"saveCnt",_siq:"master.master.item", grdData : grdData}];
            
            var serviceMap = {
                url: "${ctx}/biz/obj.do",
                data: FORM_SAVE,
                success:function(data) {
                    alert('<spring:message code="msg.saveOk"/>');
                    fn_apply();
                }
            }
            gfn_service(serviceMap, "obj");
        });
    }
    
    
    function fn_getDate(addYear) {
        var curDate  = new Date();
        var curYear  = curDate.getFullYear()+addYear;
        var curMonth = curDate.getMonth()+1;
        var curDate  = curDate.getDate();
        return curYear + (curMonth<10?'-0':'-') + curMonth + (curDate<10?'-0':'-') + curDate;
    }
    
  //해당 이벤트의 keyValue값에 해당하는 lookupSource에 lookupData를 추가
    function lookupDataChange(keyValue) {
	  
      
            FORM_SEARCH = {};
            FORM_SEARCH.FIRST_CLASS = keyValue;
            FORM_SEARCH._mtd     = "getList";
            FORM_SEARCH.tranData = [{outDs:"resList",_siq:"master.master.groupCode"}];
            
            var aOption = {
                url     : GV_CONTEXT_PATH + "/biz/obj.do",
                data    : FORM_SEARCH,
                success : function (data) {
                    
                    if (FORM_SEARCH.sql == 'N') {
                        
                    	var lookups = [];
                        console.log("item.grid.grdMain.existsLookupData:",item.grid.grdMain.existsLookupData("firstCLASS", [data.resList[0].CODE_CD, data.resList[0].CODE_NM_KR]));
                    	for (var i in data.resList) {
                            if (!item.grid.grdMain.existsLookupData("firstCLASS", [data.resList[i].CODE_CD, data.resList[i].CODE_NM_KR])) {
                                var lookup = [data.resList[i].CODE_CD, data.resList[i].CODE_NM_KR];
                                lookups.push(lookup);
                            }
                        }
                        console.log("lookups:",lookups);
                        item.grid.grdMain.fillLookupData("firstCLASS", {
                            rows: lookups
                        });
                    	
                    }
                }
            }
            
            gfn_service(aOption, "obj");
            
            /*
            $.getJSON("/Demo/GetCustomerByCountry", params, function (data) {
                var lookups = [];
                for (var i in data) {
                    if (!gridView.existsLookupData("customers", [data[i].Country, data[i].CustomerID])) {
                        var lookup = [data[i].Country, data[i].CustomerID, data[i].CompanyName];
                        lookups.push(lookup);
                    }
                }
                gridView.fillLookupData("customers", {
                    rows: lookups
                });
            });
     		
            */
        
        
    }
  
    function comCodeRouting(routing,class_group){
    	
    	var rtnMap = {};
		if(class_group == 'FirstClass')
		{
			FORM_SEARCH = {};
			FORM_SEARCH.class_group = class_group
	        FORM_SEARCH.routing = routing;
	        FORM_SEARCH._mtd     = "getList";
	        FORM_SEARCH.tranData = [{outDs:"resList",_siq:"master.master.groupCode"}];
	        	
		}	
		else if(class_group == 'SecondClass')
		{
			FORM_SEARCH = {};
			FORM_SEARCH.class_group = class_group
	        FORM_SEARCH.routing = routing;
	        FORM_SEARCH._mtd     = "getList";
	        FORM_SEARCH.tranData = [{outDs:"resList",_siq:"master.master.groupCode"}];
		}
		else if(class_group == 'ThirdClass')
		{
			FORM_SEARCH = {};
			FORM_SEARCH.class_group = class_group
	        FORM_SEARCH.routing = routing;
	        FORM_SEARCH._mtd     = "getList";
	        FORM_SEARCH.tranData = [{outDs:"resList",_siq:"master.master.groupCode"}];
		}
    	
        var aOption = {
        	async: false,
            url     : GV_CONTEXT_PATH + "/biz/obj.do",
            data    : FORM_SEARCH,
            success : function (data) {
            	
                   	rtnMap = data.resList;
            	           	
            }
        }
        
        gfn_service(aOption, "obj");
        
    	return rtnMap;
    }
    
    function func_setColumnProperty()
    {
      
		$.each(MEASURE.user, function(n, v) {
		    
			
			if(v.CD.indexOf("CLASS") > -1)
			{
			  
			  var col_CLASS = item.grid.grdMain.columnByName(v.CD);
			  
		      if (col_CLASS.name === "FIRST_CLASS" ) {
		    	  
		  		  		 item.grid.grdMain.setColumnProperty(col_CLASS.name,"dynamicStyles",function(grid, index, value){
		          			  	 var gubun = grid.getValue(index.itemIndex,"ROUTING_ID_NM");
		          	             var ret = {};
		          	            
		          	             if (gubun === '2-T') {
		          	            	ret.editor = {
		         	                         type: "dropDown",
		         	                         
		         	                         domainOnly : true, 
		         	                         textReadOnly: true,
		             	                	 values:gfn_getArrayExceptInDs(item.comCode.codeRoutingFirstClass_2_T, "CODE_CD", ""),
		             	                	 labels:gfn_getArrayExceptInDs(item.comCode.codeRoutingFirstClass_2_T, "CODE_NM_KR", "")
		         	                        
		         	                     }
		          	           	 }
		          	             if (gubun === '2-M') {
		          	            	ret.editor = {
		         	                         type: "dropDown",
		         	                         
		         	                         domainOnly : true, 
		         	                         textReadOnly: true,
		             	                	 values:gfn_getArrayExceptInDs(item.comCode.codeRoutingFirstClass_2_M, "CODE_CD", ""),
		             	                	 labels:gfn_getArrayExceptInDs(item.comCode.codeRoutingFirstClass_2_M, "CODE_NM_KR", "")
		         	                       
		         	                     }
				                 }
								 if (gubun === '2-L') {
									 ret.editor = {
		          	                         type: "dropDown",
		          	                         
		          	                         domainOnly : true, 
		          	                         textReadOnly: true,
		              	                	 values:gfn_getArrayExceptInDs(item.comCode.codeRoutingFirstClass_2_L, "CODE_CD", ""),
		              	                	 labels:gfn_getArrayExceptInDs(item.comCode.codeRoutingFirstClass_2_L, "CODE_NM_KR", "")
		          	                        
		          	                     }
				            	 }
		
		          	             
		          	             return ret;
		          			});
		
		          		  item.grid.grdMain.setColumnProperty("FIRST_CLASS","displayCallback",function(grid, index, value){
		            			  var gubun = grid.getValue(index.itemIndex,"ROUTING_ID_NM");
		            			  var retValue = value;
								if (gubun === '2-T') {
					                 var idx = gfn_getArrayExceptInDs(item.comCode.codeRoutingFirstClass_2_T, "CODE_CD", "").indexOf(value);
										
					                 retValue = gfn_getArrayExceptInDs(item.comCode.codeRoutingFirstClass_2_T, "CODE_NM_KR", "")[idx];
					            }
								if (gubun === '2-M') {
					                 var idx = gfn_getArrayExceptInDs(item.comCode.codeRoutingFirstClass_2_M, "CODE_CD", "").indexOf(value);
										
					                 retValue = gfn_getArrayExceptInDs(item.comCode.codeRoutingFirstClass_2_M, "CODE_NM_KR", "")[idx];
					            }
								if (gubun === '2-L') {
					                 var idx = gfn_getArrayExceptInDs(item.comCode.codeRoutingFirstClass_2_L, "CODE_CD", "").indexOf(value);
										
					                 retValue = gfn_getArrayExceptInDs(item.comCode.codeRoutingFirstClass_2_L, "CODE_NM_KR", "")[idx];
					            }
								return retValue;
		            			                              			  
		            		});
		          		  
		           }// END OF IF col_FIRST_CLASS
		           
		           if (col_CLASS.name === "SECOND_CLASS" ) {
				  		 	
		        	   item.grid.grdMain.setColumnProperty(col_CLASS.name,"dynamicStyles",function(grid, index, value){
		        			  	 var gubun = grid.getValue(index.itemIndex,"ROUTING_ID_NM");
		        	             var ret = {};
		
		        	             switch (gubun) {
		        	                 //구분값이 T이면 text에디터를 표시
		        	                
			    	                 case '2-T':  
			    	                	 ret.editor = {
			    	                         type: "dropDown",
			    	                         
			    	                         domainOnly : true, 
			    	                         textReadOnly: true,
			        	                	 values:gfn_getArrayExceptInDs(item.comCode.codeRoutingSecondClass_2_T, "CODE_CD", ""),
			        	                	 labels:gfn_getArrayExceptInDs(item.comCode.codeRoutingSecondClass_2_T, "CODE_NM_KR", "")
			    	                         
			
			    	                     }
			    	                 break;
		        	                 
		        	                 case '2-M':  
		        	                	 ret.editor = {
		        	                         type: "dropDown",
		        	                         
		        	                         domainOnly : true, 
		        	                         textReadOnly: true,
		            	                	 values:gfn_getArrayExceptInDs(item.comCode.codeRoutingSecondClass_2_M, "CODE_CD", ""),
		            	                	 labels:gfn_getArrayExceptInDs(item.comCode.codeRoutingSecondClass_2_M, "CODE_NM_KR", "")
		        	                         
		
		        	                     }
		        	                 break;
		        	                 
		        	                 case '2-L':  
		        	                	 ret.editor = {
		        	                         type: "dropDown",
		        	                         
		        	                         domainOnly : true, 
		        	                         textReadOnly: true,
		            	                	 values:gfn_getArrayExceptInDs(item.comCode.codeRoutingSecondClass_2_L, "CODE_CD", ""),
		            	                	 labels:gfn_getArrayExceptInDs(item.comCode.codeRoutingSecondClass_2_L, "CODE_NM_KR", "")
		        	                         
		
		        	                     }
		        	                 break;
		        	                 
		        	             }
		        	             return ret;
		        			});
		
		        		  item.grid.grdMain.setColumnProperty("SECOND_CLASS","displayCallback",function(grid, index, value){
		          			  var gubun = grid.getValue(index.itemIndex,"ROUTING_ID_NM");
		          			  var retValue = value;
								
			          			if (gubun === '2-T') {
					                 var idx = gfn_getArrayExceptInDs(item.comCode.codeRoutingSecondClass_2_T, "CODE_CD", "").indexOf(value);
										
					                 retValue = gfn_getArrayExceptInDs(item.comCode.codeRoutingSecondClass_2_T, "CODE_NM_KR", "")[idx];
					            }
			          			if (gubun === '2-M') {
					                 var idx = gfn_getArrayExceptInDs(item.comCode.codeRoutingSecondClass_2_M, "CODE_CD", "").indexOf(value);
										
					                 retValue = gfn_getArrayExceptInDs(item.comCode.codeRoutingSecondClass_2_M, "CODE_NM_KR", "")[idx];
					            }
								if (gubun === '2-L') {
					                 var idx = gfn_getArrayExceptInDs(item.comCode.codeRoutingSecondClass_2_L, "CODE_CD", "").indexOf(value);
										
					                 retValue = gfn_getArrayExceptInDs(item.comCode.codeRoutingSecondClass_2_L, "CODE_NM_KR", "")[idx];
					            }
								return retValue;
		          			                              			  
		          		});
		         }// END OF IF col_SECOND_CLASS
		           
		         if (col_CLASS.name === "THIRD_CLASS" ) {
				  		 item.grid.grdMain.setColumnProperty(col_CLASS.name,"dynamicStyles",function(grid, index, value){
		      			  	 var gubun = grid.getValue(index.itemIndex,"ROUTING_ID_NM");
		      	             var ret = {};
		
		      	             switch (gubun) {
		      	                 //구분값이 T이면 text에디터를 표시
		      	                 case '2-T':  
		      	                	 ret.editor = {
		      	                         type: "dropDown",
		      	                         
		      	                         domainOnly : true, 
		      	                         textReadOnly: true,
		          	                	 values:gfn_getArrayExceptInDs(item.comCode.codeRoutingThirdClass_2_T, "CODE_CD", ""),
		          	                	 labels:gfn_getArrayExceptInDs(item.comCode.codeRoutingThirdClass_2_T, "CODE_NM_KR", "")
		      	                        
		      	                     }
		      	                 break;
		      	                 case '2-M':  
		      	                	 ret.editor = {
		      	                         type: "dropDown",
		      	                         
		      	                         domainOnly : true, 
		      	                         textReadOnly: true,
		          	                	 values:gfn_getArrayExceptInDs(item.comCode.codeRoutingThirdClass_2_M, "CODE_CD", ""),
		          	                	 labels:gfn_getArrayExceptInDs(item.comCode.codeRoutingThirdClass_2_M, "CODE_NM_KR", "")
		      	                       
		      	                     }
		      	                 break;
		      	                 case '2-L':  
		      	                	 ret.editor = {
		      	                         type: "dropDown",
		      	                         
		      	                         domainOnly : true, 
		      	                         textReadOnly: true,
		          	                	 values:gfn_getArrayExceptInDs(item.comCode.codeRoutingThirdClass_2_L, "CODE_CD", ""),
		          	                	 labels:gfn_getArrayExceptInDs(item.comCode.codeRoutingThirdClass_2_L, "CODE_NM_KR", "")
		      	                        
		      	                     }
		      	                 break;
		      	                 
		      	             }
		      	             return ret;
		      			});
		
		      		  item.grid.grdMain.setColumnProperty("THIRD_CLASS","displayCallback",function(grid, index, value){
		        			  var gubun = grid.getValue(index.itemIndex,"ROUTING_ID_NM");
		        			  var retValue = value;
							if (gubun === '2-T') {
				                 var idx = gfn_getArrayExceptInDs(item.comCode.codeRoutingThirdClass_2_T, "CODE_CD", "").indexOf(value);
									
				                 retValue = gfn_getArrayExceptInDs(item.comCode.codeRoutingThirdClass_2_T, "CODE_NM_KR", "")[idx];
				            }
							if (gubun === '2-M') {
				                 var idx = gfn_getArrayExceptInDs(item.comCode.codeRoutingThirdClass_2_M, "CODE_CD", "").indexOf(value);
									
				                 retValue = gfn_getArrayExceptInDs(item.comCode.codeRoutingThirdClass_2_M, "CODE_NM_KR", "")[idx];
				            }
							if (gubun === '2-L') {
				                 var idx = gfn_getArrayExceptInDs(item.comCode.codeRoutingThirdClass_2_L, "CODE_CD", "").indexOf(value);
									
				                 retValue = gfn_getArrayExceptInDs(item.comCode.codeRoutingThirdClass_2_L, "CODE_NM_KR", "")[idx];
				            }
							return retValue;
		        			                              			  
		        		});
		       }// END OF IF col_THIRD_CLASS
			}  
		}); //END OF $.each(MEASURE.user
			  
  	 }// END OF func_setColumnProperty
    
    
    $(document).ready(function() {
        item.init();
        
        var colsArray = ["CAMPUS_PRIORITY"];
        gfn_pasteValueToLabel(item.grid.grdMain, item.grid.dataProvider, colsArray);
    });
</script>

</head>
<body id="framesb">
    <%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
    <!-- left -->
    <div id="a" class="split split-horizontal">
        <!-- tree -->
        <div id="c" class="split content">
            <%@ include file="/WEB-INF/view/common/leftTree.jsp" %>
        </div>
        <!-- filter -->
        <div id="d" class="split content">
            <form id="searchForm" name="searchForm">
            <div id="filterDv">
                <div class="inner">
                    <h3>Filter</h3>
                    <div class="tabMargin"></div>
                    <div class="scroll">
                        <div class="view_combo" id="divItem"></div>
                        <div class="view_combo" id="divProcurType"></div>
                        <div class="view_combo" id="divItemType"></div>
                        <div class="view_combo" id="divReptItemGroup"></div>
                        <div class="view_combo" id="divRoute"></div>
                        <div class="view_combo" id="divRepCust">
                            <div class="ilist">
                                <div class="itit"><spring:message code="lbl.reptCust"/></div>
                                <input type="text" id="reptCust" name="reptCust" class="ipt">
                            </div>
                        </div>
                        <div class="view_combo" id="divRepCustGroup"></div>
                        <div class="view_combo" id="divFireWorkYn"></div>
                        <div class="view_combo" id="divCleaningYn"></div>
                        <div class="view_combo" id="divLpYn"></div>
                        <div class="view_combo" id="divOsYn"></div>
                        <div class="view_combo" id="divValidYn"></div>
                        <div class="view_combo" id="divValidYnERP"></div>
                        <div class="view_combo" id="divValiDate">
                            <div class="ilist">
                                <div class="itit" style="width:59px;"><spring:message code="lbl.validDate"/></div>
                                <input type="text" id="validDateFrom" name="validDateFrom" class="iptdate datepicker2" value="2016-08-23"> <span class="ihpen">~</span>
                                <input type="text" id="validDateTo"   name="validDateTo"   class="iptdate datepicker2" value="2016-08-23">
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
                <div class="bleft">
                    <a style="display:none" href="javascript:;" id="btnOpenMenu" class="app"><spring:message code="lbl.reptItemGroup"/></a>
                </div>
                <div class="bright">
                    <a href="javascript:;" id="btnReset" class="app1 roleWrite"><spring:message code="lbl.reset" /></a>
                    <a id="btnSave" href="#" class="app2 roleWrite"><spring:message code="lbl.save"/></a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
