<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp"%>

    <script type="text/javascript">
    var SCM_ROLE_SEARCH = {};
    var enterSearchFlag = "Y";
    var hasSCMRoleYn = 'N';
    //20220323 김수호 추가: 생산 완료 계획 페이지 생산계획수량 입력 권한 적용 요청 from 김동현B
    var hasProdPlanQtyWriteRole = 'N';
    var prodPlan = {
        _PLAN_LT : [],
        _siq : "supply.product.prodPlan",
        
        init : function () {
            gfn_formLoad();
            this.comCode.initCode();
            this.initFilter();
            this.events();
            prodGrid.initGrid();
        },
        
        initFilter : function() {
            
            var itemTypeEvent = {
                childId   : ["upItemGroup","route"],  
                childData : [this.comCode.codeMapEx.UPPER_ITEM_GROUP, this.comCode.codeMapEx.ROUTING]
                
            };
            
            //품목대그룹
            var upperItemEvent = {
                childId   : ["itemGroup"],
                childData : [this.comCode.codeMapEx.ITEM_GROUP],
            };
            
            // 키워드팝업
            gfn_keyPopAddEvent([
                { target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>' }
            ]);
            
            // 콤보박스
            gfn_setMsComboAll([
                { target : 'divProcurType',   id : 'procurType',    title : '<spring:message code="lbl.procure"/>',        data : this.comCode.codeMap.PROCUR_TYPE, exData:[""]},
                { target : 'divItemType',     id : 'itemType',      title : '<spring:message code="lbl.itemType"/>',       data : this.comCode.codeMap.ITEM_TYPE, exData:["*"], event : itemTypeEvent},
                { target : 'divUpItemGroup',  id : 'upItemGroup',   title : '<spring:message code="lbl.upperItemGroup"/>', data : this.comCode.codeMapEx.UPPER_ITEM_GROUP, exData:["*"], event: upperItemEvent },
                { target : 'divItemGroup'   , id : 'itemGroup'    , title : '<spring:message code="lbl.itemGroup"/>'    , data : this.comCode.codeMapEx.ITEM_GROUP,     exData:[""] },
                { target : 'divRoute'       , id : 'route'        , title : '<spring:message code="lbl.routing"/>'      , data : this.comCode.codeMapEx.ROUTING,        exData:[""] },
                { target : 'divRepCustGroup', id : 'reptCustGroup', title : '<spring:message code="lbl.reptCustGroup"/>', data : this.comCode.codeMapEx.REP_CUST_GROUP, exData:[""] },
                { target : 'divCustGroup'   , id : 'custGroup'    , title : '<spring:message code="lbl.custGroup"/>'    , data : this.comCode.codeMapEx.CUST_GROUP,     exData:[""] },
                { target : 'divExcluded'    , id : 'excluded'     , title : '<spring:message code="lbl.excluded"/>'     , data : this.comCode.codeMap.FLAG_YN,     exData:["A"], type : "S" },
            ]);
            
            prodPlan.getPlanId();
            
            $("#itemType").multipleSelect("setSelects", ["10","20"]);
        },
        
        /*
        * common Code 
        */
        comCode : {
            codeMap : null,
            codeMapEx : null,
            initCode  : function () {
                var grpCd    = 'PROCUR_TYPE,FLAG_YN,ITEM_TYPE';
                this.codeMap = gfn_getComCode(grpCd, 'Y'); //공통코드 조회
                
                this.codeMap.FLAG_YN[1].CODE_NM = '<spring:message code="lbl.reqProdQty" /> < <spring:message code="lbl.prodPlan" />'
                this.codeMap.FLAG_YN[2].CODE_NM = '<spring:message code="lbl.reqProdQty" /> > <spring:message code="lbl.prodPlan" />'
                this.codeMapEx = gfn_getComCodeEx(["REP_CUST_GROUP", "CUST_GROUP", "UPPER_ITEM_GROUP", "ITEM_GROUP", "ROUTING"], null, {itemType : "10,20"});
                
                this.codeMap.PROCUR_TYPE = $.grep(this.codeMap.PROCUR_TYPE, function(v,n) {
                    return v.CODE_CD == 'MG' || v.CODE_CD == 'MH'; 
                });
                
                this.codeMap.ITEM_TYPE = $.grep(this.codeMap.ITEM_TYPE, function(v,n) {
                    return v.CODE_CD == '10' || v.CODE_CD == '20'; 
                });
                
                scmRoleAuthorityHasOrNot();
                //20220323 김수호 추가: 생산 완료 계획 페이지 생산계획수량 입력 권한 적용 요청 from 김동현B
                
            }
        },
        
        events : function () {
            
            $("#btnSearch").on("click", function(e) {
                fn_apply(false);
            });
            
            $("#btnSave").on('click', function (e) {
                prodPlan.save(false);
            });
            
            $("#btnSummary").on('click', function (e) {
                gfn_comPopupOpen("MP_PROD_PLAN", {
                    rootUrl : "supply/product",
                    url     : "prodPlanSummary",
                    width   : 800,
                    height  : 680,
                    menuCd  : "MP106"
                });
            });
            
            $("#btnExcelDown").on('click', function (e) {
                prodGrid.excelDown();
            });
            
            $("#btnExcelUpload").on('click', function (e) {
                $("#excelFile").click();
            });
            
            $("#excelFile").on('change', function (e) {
                prodGrid.excelUpload();
            });

            $("#btnReset").on('click', function (e) {
                prodGrid.grdMain.cancel();
                prodGrid.dataProvider.rollback(prodGrid.dataProvider.getSavePoints()[0]);
                prodGrid.gridCallback();
            });
            
            $("#btnConfirmY").click ("on", function() { prodGrid.fn_confirm("Y"); });
            $("#btnConfirmN").click ("on", function() { prodGrid.fn_confirm("N"); });
            $("#btnLoading").click ("on", function() { prodGrid.fn_loading(); });
            
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
                    }else if(id == "divExcluded"){
                        EXCEL_SEARCH_DATA += $("#excluded option:selected").text();
                    }else if(id == "divPlanId"){
                        EXCEL_SEARCH_DATA += $("#planId option:selected").text();
                    }
                }
            });
            
            EXCEL_SEARCH_DATA += "\n" + '<spring:message code="lbl.period"/>' + " : ";
            EXCEL_SEARCH_DATA += $("#fromCal").val() + "(" + $("#fromPWeek").val() + ") ~ ";
            EXCEL_SEARCH_DATA += $("#toCal").val() + "(" + $("#toPWeek").val() + ")";
            
        },
        
        search : function () {
            
            FORM_SEARCH._mtd     = "getList";
            FORM_SEARCH.tranData = [ {outDs : "resList", _siq : prodPlan._siq}
                                   , {outDs : "confirmList", _siq : prodPlan._siq + "Confirm"}
                                   , {outDs : "loadingList", _siq : prodPlan._siq + "Loading"}
                                   , {outDs : "scmWeek", _siq : prodPlan._siq + "ScmWeek"}
            ];
            
            var aOption = {
                url     : GV_CONTEXT_PATH + "/biz/obj.do",
                data    : FORM_SEARCH,
                success : function (data) {
                    
                    var loadingCutOffFlag = data.loadingList[0].CUT_OFF_FLAG;
                    var loadingReleaseFlag = data.loadingList[0].RELEASE_FLAG;
                    var tConfirmYn = data.confirmList[0].CONFIRM_FLAG;
                    var planIdFlag = $('#planId').val().indexOf("_M");
                    var scmWeek = data.scmWeek[0].START_WEEK;
                    
                    if (FORM_SEARCH.sql == 'N') {
                        
                        var fDs = gfn_getFindDataDsInDs(prodPlan._PLAN_LT, {CODE_CD : {VALUE : $('#planId').val(), CONDI : "="}});
                        if (fDs.length > 0) {
                            
                            //불러오기 버튼 활성화 기준 -> 1.현재주차, CUT_OFF_FLAG = 'N', RELEASE_FLAG = 'Y', PLAN_ID가 _M이 있어야 함
                            if(prodPlan._PLAN_LT[0].PLAN_ID == fDs[0].PLAN_ID && planIdFlag != -1) {
                                $("#btnLoading").show();
                                
                                if(loadingCutOffFlag == "N" && loadingReleaseFlag == "Y"){
                                    $("#btnLoading").removeClass("app");
                                    $("#btnLoading").addClass("app1");
                                }else{
                                    $("#btnLoading").removeClass("app1");
                                    $("#btnLoading").addClass("app");
                                }
                            }else{
                                $("#btnLoading").hide();
                            }
                            
                            //버튼 display
                            prodPlan.setButtonDip();
                        }
                        
                        prodGrid.dataProvider.clearRows(); //데이터 초기화
                
                        //그리드 데이터 생성
                        prodGrid.grdMain.cancel();
                        prodGrid.dataProvider.setRows(data.resList);
                        prodGrid.dataProvider.clearSavePoints();
                        prodGrid.dataProvider.savePoint(); //초기화 포인트 저장
                        gfn_actionMonthSum(prodGrid.gridInstance);
                        
                        $("#scmWeek").val(scmWeek);
                        
                        if(tConfirmYn == "N"){
                            prodGrid.gridCallback();    
                        }
                    }
                }
            }
            
            gfn_service(aOption, "obj");
        },
        
        getBucket : function (sqlFlag) {
            
            var ajaxMap = {
                fromDate : gfn_replaceAll($("#fromCal").val(),"-",""),
                toDate   : gfn_replaceAll($("#toCal").val(),"-",""),
                week     : {isDown: "Y", isUp : "N", upCal : "M", isMt : "N", isExp : "N", expCnt : 999},
                sqlId    : ["bucketWeek"]
            };
            gfn_getBucket(ajaxMap);
            
            var query = new Array();
            $.each(BUCKET.query, function (i, el) {
                query.push(el);
            });
            
            //  bucketList 셋
            FORM_SEARCH.bucketList = query;
            
            var params  = {
                fromDate : gfn_replaceAll($("#fromCal").val(), "-", ""),
                toDate   : gfn_replaceAll($("#toCal").val(), "-", "")
            };
            params._mtd = "getList";
            params.tranData = [{outDs : "resList", _siq : "supply.product.bucketProduct"}];
            
            var opt = {
                url     : GV_CONTEXT_PATH + "/biz/obj.do",
                data    : params,
                async   : false,
                success : function(data) {
                    
                    BUCKET.init();
                    // 마지막 사유만 
                    data.resList[data.resList.length-3].DATA_TYPE  = 'text';
                    data.resList[data.resList.length-3].TEXT_ALIGN = 'near';
                    data.resList[data.resList.length-2].DATA_TYPE  = 'text';
                    data.resList[data.resList.length-2].TEXT_ALIGN = 'near';
                    data.resList[data.resList.length-1].DATA_TYPE  = 'text';
                    data.resList[data.resList.length-1].TEXT_ALIGN = 'near';
                    
                    BUCKET.push($.grep(data.resList, function (n, k) {
                        return n.TYPE == 'group';
                    }));
                    BUCKET.push($.grep(data.resList, function (n, k) {
                        return n.TYPE != 'group';
                    }));
                    gfn_bucketCallback(false, "N");
                }
            };
            gfn_service(opt, "obj");
        },
        
        save : function(isConfirm) {
            
            isConfirm = isConfirm || false;
            
            var grdData;
            var tGrdData;
            var excelYn   = "N";
            var scmPastWeek = "N";
            var scmWeek   = $("#scmWeek").val();
            var confirmYn = (isConfirm == true ? "Y" : "N");
            
            if ($("#realgrid").is(":visible")) {
                grdData = gfn_getGrdSavedataAll(prodGrid.grdMain);
                for (var i = grdData.length-1; i >= 0; i--) {
                    if (grdData[i].GRP_LVL_ID != "0") {
                        grdData.splice(i, 1);
                    }
                }
                if (grdData.length == 0 && confirmYn == false) {
                    alert('<spring:message code="msg.noChangeData"/>');  //변경된 데이터가 없습니다.
                    return;
                }
                
            } else {
                excelYn   = 'Y'
                prodGrid.grdMainEx.commit();
                tGrdData = prodGrid.dataProviderEx.getJsonRows();
                grdData = new Array();
                
                $.each(tGrdData, function(n, v){
                    var addFlag = 0;
                    var tSalesMemo = gfn_nvl(v.SALES_MEMO, "");
                    var tRemark = gfn_nvl(v.REMARK, "");
                    var tManufactReply = gfn_nvl(v.MANUFACT_REPLY, "");
                    if(tSalesMemo == "" && tRemark == "" && tManufactReply == ""){
                        $.each(BUCKET.query, function(nn, vv){
                            var tRootCd = vv.ROOT_CD;
                            var tCd = vv.CD;
                            
                            if(tRootCd == "PPW" && tCd != "PPW_TOT" && tCd != "PPW_AMT" ){
                                var data = gfn_nvl(eval("v." + tCd), "");
                                if(data != ""){
                                    addFlag++;
                                }
                            }
                        });
                        if(addFlag > 0){
                            grdData.push(v);    
                        }
                    }else{
                        grdData.push(v);
                    }
                });
            }
            
            //SCM 과거 주차 입력되어있을경우
            $.each(BUCKET.query, function(i, val){
                
                var rootCd = val.ROOT_CD;
                var bucketVal = val.BUCKET_VAL;
                
                if(rootCd == "PPW" && bucketVal.indexOf(scmWeek) != -1){
                    scmPastWeek = "Y"
                    return false;
                }
            });
            
            confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?

                /*******************************************************
                 * 1. 엑셀 업로드 일경우 삭제후 등록
                 * 2. 사용자 입력후 저장일 경우 merge
                 *******************************************************/
                FORM_SAVE            = {}; //초기화
                FORM_SAVE._mtd       = "saveUpdate";
                FORM_SAVE.planId     = FORM_SEARCH.planId;
                FORM_SAVE.fromPWeek  = FORM_SEARCH.fromPWeek; 
                FORM_SAVE.toPWeek    = FORM_SEARCH.toPWeek;
                FORM_SAVE.bucketList = BUCKET.query;
                FORM_SAVE.excelYn    = excelYn
                FORM_SAVE.confirmYn  = confirmYn;
                FORM_SAVE.scmPastWeek  = scmPastWeek;
                FORM_SAVE.hasSCMRoleYn = hasSCMRoleYn;
                FORM_SAVE.tranData   = [
                    {outDs : "saveCnt", _siq : prodPlan._siq, grdData : [{rowList : grdData}]},
                ];
                
                var ajaxOpt = {
                    url     : GV_CONTEXT_PATH + "/biz/obj.do",
                    data    : FORM_SAVE,
                    success : function(data) {
                        
                        if (confirmYn) {
                            prodPlan.getPlanId();
                        }
                        
                        alert('<spring:message code="msg.saveOk"/>');
                        fn_apply(false);
                    },
                };
                
                gfn_service(ajaxOpt, "obj");
            });
            
        },
    
        getPlanId : function() {
            var params  = {planTypeCd : "MP"};
            params._mtd = "getList";
            params.tranData = [{outDs : "resList", _siq : "common.planId"}];
            
            var opt = {
                url     : GV_CONTEXT_PATH + "/biz/obj.do",
                data    : params,
                async   : false,
                success : function(data) {
                    
                    // 전역으로 올림.
                    prodPlan._PLAN_LT = data.resList;
                    
                    gfn_setMsCombo("planId", data.resList, [""]);
                    
                    var planChange = function(_this) {
                        
                        var fDs = gfn_getFindDataDsInDs(prodPlan._PLAN_LT, {CODE_CD : {VALUE : $(_this).val(), CONDI : "="}});
                        if (fDs.length > 0) {
                            if (prodPlan._PLAN_LT[0].PLAN_ID == fDs[0].PLAN_ID) {
                                prodGrid.IS_CONFIRM = (fDs[0].CUT_OFF_FLAG == 'Y'? false : true);
                            } else {
                                prodGrid.IS_CONFIRM = false;
                            }

                            var sDt = gfn_getStringToDate(fDs[0].SW_START_DATE);
                            var tDt = gfn_getStringToDate(fDs[0].SW_START_DATE);
                            sDt = sDt.getWeekDay(5, false);
                            DATEPICKET(null, fDs[0].SW_START_DATE, gfn_getDateToString(sDt));
                            
                            if (prodGrid.IS_CONFIRM) {
                                if (gfn_getRoleCd('GOCQT0001')) {
                                    $('#fromCal').datepicker("option", "minDate", tDt.getWeekDay(-1));
                                } else {
                                    $("#fromCal").datepicker("option", "minDate", tDt);
                                }
                            } else {
                                $("#fromCal").datepicker("option", "minDate", tDt);
                            }
                            
                            //max set
                            var eDt = gfn_getStringToDate(fDs[0].SW_END_DATE);
                            $("#toCal").datepicker("option", "maxDate", eDt);
                        } else {
                            DATEPICKET();
                        }
                    }
                    $("#planId").off("change").on("change", function() {
                        planChange(this);
                    });
                    
                    $("#planId").change();
                }
            };
            gfn_service(opt, "obj");
            
        },
        
        setButtonDip : function() {
        	
        	if (prodGrid.IS_CONFIRM) {
                $('.roleCfn').show();
            } else {
                $('.roleCfn').hide();
            }
        	
        	var trueOrfalse = hasProdPlanQtyWriteRole == 'Y'? true:false;
        	if (trueOrfalse) {
                $('.roleSaveCfn').show();
            } else {
                $('.roleSaveCfn').hide();
            }
        }
    };
    
    /********************************************************************************************************
    ** 조회 
    ********************************************************************************************************/
    var fn_apply = function (sqlFlag) {
        // 메인그리드 보이기
        $("#realgrid").show();
        // 엑셀그리드 숨기기
        $("#realgridExcel").hide();
        
        gfn_getMenuInit();
        
        FORM_SEARCH     = $("#searchForm").serializeObject(); //초기화
        FORM_SEARCH.sql = sqlFlag;
        prodPlan.getBucket(sqlFlag); //2. 버켓정보 조회
        FORM_SEARCH.dimList    = DIMENSION.user;
        FORM_SEARCH.CONFIRM_YN = (prodGrid.IS_CONFIRM ? 'Y' : 'N')
        
        if (!sqlFlag) {
            
            for (var i in DIMENSION.user) {
                
                var dimensionUser = DIMENSION.user[i].DIM_CD;
                
                if (dimensionUser == "SS_QTY" || dimensionUser == "MFG_LT" || dimensionUser == "SALES_PRICE_KRW" || dimensionUser == "EXP_INV_QTY2_NM") {
                    DIMENSION.user[i].numberFormat = "#,##0";
                }
            }
            
            prodGrid.gridInstance.setDraw();
            
            var fileds = prodGrid.dataProvider.getFields();
            for (var i = 0; i < fileds.length; i++) {
                if (fileds[i].fieldName == 'SS_QTY_NM' || fileds[i].fieldName == 'MFG_LT_NM'|| fileds[i].fieldName == 'SALES_PRICE_KRW_NM' || fileds[i].fieldName == 'EXP_INV_QTY2_NM') {
                    fileds[i].dataType = "number";
                }
                
                if(fileds[i].fieldName == 'SALES_MEMO' || fileds[i].fieldName == 'REMARK'|| fileds[i].fieldName == 'MANUFACT_REPLY'){
                    prodGrid.grdMain.setColumnProperty("SALES_MEMO", "width", 300); //Measure 길이 조정
                    prodGrid.grdMain.setColumnProperty("REMARK", "width", 300); //Measure 길이 조정   
                    prodGrid.grdMain.setColumnProperty("MANUFACT_REPLY", "width", 300); //Measure 길이 조정 
                }
            }
            prodGrid.dataProvider.setFields(fileds);
            
            //버킷컬럼 재구성
            var dynamicStyles;
            $.each(BUCKET.query, function(idx, item) {
                //스타일적용
                if (item.CD.indexOf("SALES_UNREL_QTY") > -1) {
                    dynamicStyles = prodGrid.grdMain.getColumnProperty(item.CD, "dynamicStyles");
                    if (dynamicStyles != undefined) {
                        dynamicStyles.push({
                            criteria : "value >= 0",
                            styles   : "foreground=#ff0000ff"
                        });
                        prodGrid.grdMain.setColumnProperty(item.CD, "dynamicStyles", dynamicStyles);
                    }
                }
            });
        }
        prodPlan.search();
        prodPlan.excelSubSearch();
    }
    
    /********************************************************************************************************
    ** grid  선언  
    ********************************************************************************************************/
    var prodGrid = {
        
        _DIM_EX        : [],
        IS_CONFIRM     : false,
        gridInstance   : null,
        grdMain        : null,
        dataProvider   : null,
        
        gridInstanceEx : null,
        grdMainEx      : null,
        dataProviderEx : null,
        
        initGrid       : function () {
            
            this.gridInstance = new GRID();
            this.gridInstance.init("realgrid");
            
            this.grdMain      = this.gridInstance.objGrid;
            this.dataProvider = this.gridInstance.objData;
            
            this.gridInstanceEx = new GRID();
            this.gridInstanceEx.init("realgridExcel");
            
            this.grdMainEx      = this.gridInstanceEx.objGrid;
            this.dataProviderEx = this.gridInstanceEx.objData;
            
            this.setOptions();
            this.gridEvents();
            
            this.initExcelDraw();
            
            gfn_setMonthSum(prodGrid.gridInstance, false, false, true);
        },
        
        initExcelDraw : function () {
            
            this.getDimMeaInfo();
            
            prodPlan.getBucket(false); 
            
            for (var i in DIMENSION.user) {
                if (DIMENSION.user[i].DIM_CD == "SS_QTY" ||
                    DIMENSION.user[i].DIM_CD == "MFG_LT" ||
                    DIMENSION.user[i].DIM_CD == "SALES_PRICE_KRW" ) {
                    DIMENSION.user[i].numberFormat = "#,##0";
                }
            }
            
            prodGrid.gridInstanceEx.setDraw()
            
            var fileds = prodGrid.dataProviderEx.getFields();
            for (var i = 0; i < fileds.length; i++) {
                if (fileds[i].fieldName == 'SS_QTY_NM' ||
                    fileds[i].fieldName == 'MFG_LT_NM'||
                    fileds[i].fieldName == 'SALES_PRICE_KRW_NM') {
                    fileds[i].dataType = "number";
                }
            }
            prodGrid.dataProviderEx.setFields(fileds);
        },
        
        setOptions : function () {
            this.grdMain.setOptions({
                stateBar: { visible       : true  },
                sorting : { enabled       : false },
                display : { columnMovable : false }
            });
            //스타일 추가
            this.grdMain.addCellStyles([
                { id : "editStyleRow", editable : true, background : gv_editColor }
            ]);
            
            this.grdMainEx.setOptions({
                sorting : { enabled       : false },
                display : { columnMovable : false }
            });
            this.grdMainEx.addCellStyles([
                { id : "editStyleExRow", editable : false, background : gv_editColor }
            ]);
        },
        
        gridEvents : function() {
            
            this.grdMain.onEditRowChanged = function (grid, itemIndex, dataRow, field, oldValue, newValue) {
                prodGrid.gridCalc(grid, itemIndex, dataRow, field, oldValue, newValue);
            };

            this.grdMain.onEditRowPasted = function(grid, itemIndex, dataRow, fields, oldValues, newValues) {
                
                if (fields.length == newValues.length) {
                    prodGrid.gridCalc(grid, itemIndex, dataRow, fields, oldValues, newValues);
                } else {
                    var arrNewVal = [];
                    $.each(fields, function(n,v) {
                        arrNewVal.push(newValues[v]);
                    });
                    prodGrid.gridCalc(grid, itemIndex, dataRow, fields, oldValues, arrNewVal);
                }
            };
        },
        
        gridCallback : function () {
            
            var isEdit   = false;
            var cols     = this.grdMain.getColumnNames();
            var planWeek = new Array();
            var arrIdx   = new Array();
            
            // 조건
            isEdit  = prodGrid.IS_CONFIRM;

            this.dataProvider.beginUpdate();
            for (var i = 0; i < this.dataProvider.getRowCount(); i++) {
                if (this.dataProvider.getValue(i, gv_grpLvlId) != '0') {
                    this.dataProvider.setValue(i, 'REMARK', '');
                    this.dataProvider.setValue(i, 'SALES_MEMO', '');
                    this.dataProvider.setValue(i, 'MANUFACT_REPLY', '');
                    this.dataProvider.setRowState(i, "none");
                }
            }
            this.dataProvider.endUpdate();

            if (!isEdit) {
                return;
            }
            
            for (var i = 0; i < this.dataProvider.getRowCount(); i++) {
                // 조건
                if (this.dataProvider.getValue(i, gv_grpLvlId) == '0') {
                    arrIdx.push(i);
                }
            } 
            
            for (var j = 0; j < cols.length; j++) {
                if (cols[j].indexOf("PPW") > -1 && (cols[j] != "PPW_TOT" && cols[j] != "PPW_AMT")) {
                    planWeek.push(cols[j])
                }
            }
        
            
            if(hasSCMRoleYn == 'Y')
            {
                planWeek.push('REMARK');
            }
            
            planWeek.push('SALES_MEMO');
            planWeek.push('MANUFACT_REPLY');
            
            this.grdMain.setCellStyles(arrIdx, planWeek , "editStyleRow");
        },
        
        gridExCallback : function () {
            
            var cols     = this.grdMainEx.getColumnNames();
            var planWeek = new Array();
            var arrIdx   = new Array();
            
            for (var i = 0; i < this.dataProviderEx.getRowCount(); i++) {
                // 조건
                arrIdx.push(i);
            } 
            
            for (var j = 0; j < cols.length; j++) {
                if (cols[j].indexOf("PPW") > -1 && (cols[j] != "PPW_TOT" && cols[j] != "PPW_AMT")) {
                    planWeek.push(cols[j])
                }
            }
        
            planWeek.push('MANUFACT_REPLY');
            planWeek.push('SALES_MEMO');
            planWeek.push('REMARK');
            
            this.grdMainEx.setCellStyles(arrIdx, planWeek , "editStyleExRow");
        },
        
        excelDown : function () {
            
            //조회조건 설정
            var EXCEL_FORM = $("#searchForm").serializeObject();
            
            EXCEL_FORM.sql        = false;
            EXCEL_FORM.dimList    = this._DIM_EX;
            EXCEL_FORM.bucketList = FORM_SEARCH.bucketList;
            EXCEL_FORM.CONFIRM_YN = (prodGrid.IS_CONFIRM ? 'Y' : 'N')
            EXCEL_FORM._mtd       = "getList";
            EXCEL_FORM.tranData   = [{outDs : "gridList", _siq : prodPlan._siq}];

            gfn_service({
                url    : GV_CONTEXT_PATH + "/biz/obj.do",
                data   : EXCEL_FORM,
                success: function(data) {
                    //엑셀데이터 정리 (로우 데이터만 추가)
                    var gridListExcel = [];
                    $.each(data.gridList, function(idx, item) {
                        if (item.GRP_LVL_ID == "0") {
                            gridListExcel.push(item);
                        }
                    });
                    //그리드 데이터 삭제
                    prodGrid.dataProviderEx.clearRows();
                    prodGrid.grdMainEx.cancel();
                    //그리드 데이터 생성
                    prodGrid.dataProviderEx.setRows(gridListExcel);
                    
                    prodGrid.gridExCallback();

                    //엑셀다운로드
                    gfn_doExportExcel({
                        gridIdx            : 1,
                        fileNm             : "${menuInfo.menuNm}",
                        formYn             : "Y",
                        indicator          : "hidden",
                        conFirmFlag        : false,
                        applyDynamicStyles : true
                    });
                }
            }, "obj");
        },
        
        excelUpload : function () {
            gfn_importGrid({
                gridIdx  : 1,
                callback : function() {
                    //그리드 초기화 포인트 저장
                    prodGrid.dataProviderEx.clearSavePoints();
                    prodGrid.dataProviderEx.savePoint();

                    // 메인그리드 숨기기
                    $("#realgrid").hide();
                    // 엑셀그리드 보이기
                    $("#realgridExcel").show();
                    prodGrid.grdMainEx.resetSize();
                    prodGrid.gridExCallback();
                }
            });
        },
        
        gridCalc : function (grid, itemIndex, dataRow, field, oldValue, newValue) {
            if ($.isArray(field)) {
                var tmpOldVal;
                $.each(field, function(n,v) {
                    prodGrid.setTotalVal(itemIndex, field);
                });
            } else {
                prodGrid.setTotalVal(itemIndex, field);
            }
        },
        
        setTotalVal : function (idx, field) {
            var fileNm = null;
            var qty = 0, amt = 0;
            var tmpFieldNm = prodGrid.dataProvider.getFieldName(field);
            
            if (tmpFieldNm.indexOf("PPW") == -1) {
                return false;
            }
            
            try {
                prodGrid.dataProvider.beginUpdate();
                for (var i in prodGrid.dataProvider.getFieldNames()) {
                    fileNm = prodGrid.dataProvider.getFieldName(i);
                    if (fileNm.indexOf("PPW") > -1 && (fileNm != "PPW_TOT" && fileNm != "PPW_AMT")) {
                        qty += gfn_nvl(prodGrid.dataProvider.getValue(idx, fileNm), 0);
                    }
                }
                amt = qty * gfn_nvl(prodGrid.dataProvider.getValue(idx, "SALES_PRICE_KRW"), 0);
                prodGrid.dataProvider.setValue(idx, "PPW_TOT", qty);
                prodGrid.dataProvider.setValue(idx, "PPW_AMT", amt);
                
            } finally {
                prodGrid.dataProvider.endUpdate();
            }
        },
        
        getDimMeaInfo : function() {
            //엑셀다운로드 디멘전
            gfn_service({
                url     : GV_CONTEXT_PATH + "/biz/obj.do",
                async   : false,
                data    : {
                    _mtd           : "getList",
                    SEARCH_MENU_CD : "${menuInfo.menuCd}",
                    tranData       : [
                        {outDs:"dimList",_siq:"admin.dimMapMenu"},
                    ]
                },
                success : function(data) {
                    //디멘전 정리
                    $.each(data.dimList, function(idx, dim) {
                        prodGrid._DIM_EX.push(dim)
                        DIMENSION.user.push(dim);
                    });
                }
            }, "obj");
        },
        
        fn_confirm : function(confirm_yn){
            
            var msg = "";
            var resMsg = "";
            
            if(confirm_yn == "Y"){
                msg = '<spring:message code="msg.confirmed"/>';
                resMsg = '<spring:message code="msg.wantConfirm"/>';
            }else if(confirm_yn == "N"){
                msg = '<spring:message code="msg.cancelConfirmed"/>';
                resMsg = '<spring:message code="msg.cancelConfirm"/>';
            }
            
            confirm(resMsg, function() {  // 저장하시겠습니까?
                //저장
                FORM_SAVE            = {}; //초기화
                FORM_SAVE._mtd       = "saveUpdate";
                FORM_SAVE.confirmYn  = confirm_yn;
                FORM_SAVE.tranData   = [
                    {outDs : "saveCnt", _siq : prodPlan._siq + "Confirm", grdData : [{planId : $('#planId').val(), confirmYn : confirm_yn}]},
                ];
                var ajaxOpt = {
                    url     : GV_CONTEXT_PATH + "/biz/obj.do",
                    data    : FORM_SAVE,
                    success : function(data) {
                        
                        prodPlan.getPlanId();
                        
                        alert(msg);
                        fn_apply(false);
                    },
                };
                
                gfn_service(ajaxOpt, "obj");
            });
        },
        
        
        fn_loading : function(){
            
            var flag = $("#btnLoading").hasClass("app1");
            
            if(flag){
                var msg = '<spring:message code="msg.done"/>';
                var resMsg = '<spring:message code="msg.loadingMsg"/>';
                
                confirm(resMsg, function() {
                    FORM_SAVE            = {}; //초기화
                    FORM_SAVE._mtd       = "saveUpdate";
                    FORM_SAVE.tranData   = [
                        {outDs : "saveCnt", _siq : prodPlan._siq + "Loading", grdData : [{planId : $('#planId').val()}]},
                    ];
                    var ajaxOpt = {
                        url     : GV_CONTEXT_PATH + "/biz/obj.do",
                        data    : FORM_SAVE,
                        success : function(data) {
                            alert(msg);
                        },
                    };
                    
                    gfn_service(ajaxOpt, "obj");
                }); 
            }
        }
    };
    

    function fn_checkClose() {
        return gfn_getGrdSaveCount(prodGrid.grdMain) == 0;
    }
    
    /********************************************************************************************************
    ** onload  
    ********************************************************************************************************/
    $(document).ready(function() {
        prodPlan.init();
    });

    
    function scmRoleAuthorityHasOrNot(){
        
        SCM_ROLE_SEARCH = {}; // 초기화
        
        SCM_ROLE_SEARCH.USER_ID = "${sessionScope.userInfo.userId}" ;
        
        
        SCM_ROLE_SEARCH._mtd     = "getList";
        SCM_ROLE_SEARCH.tranData = [
                               { outDs : "hasSCMRoleYn",_siq : "supply.product.prodPlanSCMRoleYn"},
                               { outDs : "hasProdPlanQtyWriteRole",_siq : "supply.product.prodPlanQtyWriteRoleYn"}
                            ];
        
        
        
        var aOption = {
            async   : false,
            url     : GV_CONTEXT_PATH + "/biz/obj.do",
            data    : SCM_ROLE_SEARCH,
            success : function (data) {
            
                if (SCM_ROLE_SEARCH.sql == 'N') {
                	
                    hasSCMRoleYn = data.hasSCMRoleYn[0].hasSCMRoleYn;
                    hasProdPlanQtyWriteRole = data.hasProdPlanQtyWriteRole[0].hasProdPlanQtyWriteRoleYn;

                }
            }
        }
        
        gfn_service(aOption, "obj");
        
        
    }
    </script>

</head>
<body id="framesb">
    <%@ include file="/WEB-INF/view/layout/commonForm.jsp"%>
    
    <div id="a" class="split content split-horizontal">
        <form id="searchForm" name="searchForm">
        <input type="hidden" id="scmWeek" name="scmWeek" value=""/>
        <div id="filterDv">
            <div class="inner">
                <h3>Filter</h3>
                <%@ include file="/WEB-INF/view/common/filterMonthSum.jsp" %> 
                <div class="tabMargin"></div>
                <div class="scroll">
                    <div class="view_combo" id="divItem"></div>
                    <div class="view_combo" id="divProcurType"></div>
                    <div class="view_combo" id="divItemType"></div>
                    <div class="view_combo" id="divUpItemGroup"></div>
                    <div class="view_combo" id="divItemGroup"></div>
                    <div class="view_combo" id="divRoute"></div>
                    <div class="view_combo" id="divRepCustGroup"></div>
                    <div class="view_combo" id="divCustGroup"></div>
                    <div class="view_combo" id="divExcluded"></div>
                    <div class="view_combo" id="divPlanId">
                        <div class="ilist">
                            <div class="itit"><spring:message code="lbl.planId"/></div>
                            <div class="iptdv borNone">
                                <select id="planId" name="planId" class="iptcombo"></select>
                            </div>
                        </div>
                    </div>
                    <%@ include file="/WEB-INF/view/common/filterViewHorizon.jsp" %>
                    
                </div>
                <div class="bt_btn">
                    <a href="#" class="fl_app" id="btnSearch"><spring:message code="lbl.search"/></a>
                </div>
            </div>
        </div>
        </form>
    </div>
    
    <div id="b" class="split split-horizontal">
        <!-- contents -->
        <div id="grid1" class="fconbox">
            <%@ include file="/WEB-INF/view/common/commonLocation.jsp"%>
            <div class="scroll">
                <!-- 그리드영역 -->
                <div id="realgrid" class="realgrid1"></div>
                <div id="realgridExcel" class="realgrid1" style="display: none"></div>
            </div>
            <div class="cbt_btn" style="height:25px">
                <div class="bleft">
                    <form id="excelForm" method="post" enctype="multipart/form-data">
                        <input type="file" name="excelFile" id="excelFile" style="display: none;" />
                        <input type="hidden" id="headerLine" name="headerLine" value="2" />
                        <input type="hidden" id="columnNames" name="columnNames" />
                    </form>
                    <a style="display:none" href="javascript:;" id="btnExcelDown" class="app1 roleSaveCfn"><spring:message code="lbl.excelDownload" /></a>
                    <a style="display:none" href="javascript:;" id="btnExcelUpload" class="app1 roleSaveCfn"><spring:message code="lbl.excelUpload" /></a>
                    <a style="display:none" href="javascript:;" id="btnConfirmY" class="app1 roleSaveCfn"><spring:message code="lbl.confirm" /></a>
                    <a style="display:none" href="javascript:;" id="btnConfirmN" class="app1 roleSaveCfn"><spring:message code="lbl.confirmCancel" /></a>
                    <a style="display:none" href="javascript:;" id="btnLoading" class="app roleWrite"><spring:message code="lbl.loading" /></a>
                </div>
                <div class="bright">
                    <a style="display:none" href="javascript:;" id="btnSummary" class="app1 roleCfn"><spring:message code="lbl.summary" /></a>
                    <a style="display:none" href="javascript:;" id="btnReset" class="app1 roleCfn"><spring:message code="lbl.reset" /></a>
                    <a style="display:none" href="javascript:;" id="btnSave" class="app2 roleCfn"><spring:message code="lbl.save" /></a>
                </div>
            </div>
        </div>
    </div>
    
</body>
</html>
