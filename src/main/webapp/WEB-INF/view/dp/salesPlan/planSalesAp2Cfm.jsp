<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="wi.com.wisnop.dto.common.MenuVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp"%>
<%
MenuVO menuInfo = (MenuVO) request.getAttribute("menuInfo");
if (menuInfo != null) {
    String menuParam = menuInfo.getMenuParam();
    if (!StringUtils.isEmpty(menuParam)) {
        String[] arrParam = menuParam.split("&");
        for (int i = 0; i < arrParam.length; i++) {
            if (!StringUtils.isEmpty(arrParam[i])) {
                if ("MEA_CD".equals(arrParam[i].split("=")[0])) {
                    request.setAttribute("MEA_CD", arrParam[i].split("=")[1]);
                    break;
                }
            }
        }
    }
}
%>
<script type="text/javascript" src="${ctx}/statics/js/biz/gridcalcPlanAp2Cfm.js"></script>
<script type="text/javascript">
    var yellowColor = "#FFFF00";
    var periodNumPlus = 0;
    var periodNumMinus = 0;
    var weekFlag = false; //false = 132일, true = 372
    var widthCnt = 0;
    var excelUpdateCnt = 0;
    var authorityFlag = "N";
    var enterSearchFlag = "Y";
    var codeMap;
    var gridInstance, grdMain, dataProvider;
    var gridInstanceExcel, grdMainExcel, dataProviderExcel;
    var datePickerOption;
    var paramMenuCd = "${menuInfo.menuCd}";
    var tExDate, tExDatePast, tDataCheck;
    var apMeaCompare = "";
    var meaCd = "${MEA_CD}";
    var apMeaCd = "${MEA_CD}_SP";
    var apAmtCd = "${MEA_CD}_SP_AMT_KRW";
    var apMeaCdSql = "";
    var EXCEL_GRID_DATA;
    
    if(apMeaCd == "CFM_SP"){
        apMeaCompare = "AP2_SP";
        tExDatePast = ["SALES_PRICE", "CFM_AP2_DIFF"];
        tExDate = ["OPEN_SO_SP", "OPEN_SO_SP2", "OPEN_SO_INV_WIP"];
        tDataCheck = ["INV_WIP", "WIP_SP"];
        apMeaCdSql = "dp.planSalesCfm.salesPlanListCfm";
        
    }else if(apMeaCd == "AP2_SP"){
        apMeaCompare = "AP1_SP";
        tExDatePast = ["SALES_PRICE", "WIP_SP", "CFM_AP2_DIFF"];
        tExDate = ["OPEN_SO_SP", "OPEN_SO_SP2", "OPEN_SO_INV_WIP", "CFM_AP2_DIFF"];
        tDataCheck = ["INV_WIP", "WIP_SP", "CFM_AP2_DIFF"];
        apMeaCdSql = "dp.planSalesAp2.salesPlanListAp2";
    }
    
    $(function() {
        gfn_formLoad();     //공통 초기화
        fn_initData();      //데이터 초기화
        fn_initFilter();    //필터 초기화
        fn_initGrid();      //그리드 초기화
        fn_initEvent();     //이벤트 초기화
        fn_fillterChange();
        fn_measureEvent();
    });
    
    /******************************************************************************************
    ** 데이터 초기화 -> TREE, 공통코드 조회
    ******************************************************************************************/
    function fn_initData() {
        
        codeMap = gfn_getComCode("SP_DATA_CHECK,SO_DATA_CHECK,FLAG_YN", "Y");
        fn_getInitData();
    }
    
    /******************************************************************************************
    ** Plan Version 
    ******************************************************************************************/
    function fn_getInitData() {
        
        gfn_service({
            async   : false,
            url     : GV_CONTEXT_PATH + "/biz/obj",
            data    : {_mtd : "getList", menuParam : meaCd, tranData:[
                {outDs : "planList", _siq : "dp.planCommon.salesPlanVersion"},
                {outDs : "roleList", _siq : "dp.planCommon.salesPlanRole"},
                {outDs : "ap13mWeek", _siq : "dp.planCommon.ap13mWeek"},
                {outDs : "planIdPast", _siq : "dp.planCommon.salesPlanIdPast"},
                {outDs : "currentWeek", _siq : "dp.planCommon.currentWeek"},
               
            ]},
            success : function(data) {
            	
            	
                
            	codeMap.PLAN_INFO = data.planList[0];
                codeMap.ROLE_INFO = data.roleList[0];
                codeMap.AP1_3M_WEEK = data.ap13mWeek;
                codeMap.CURRENT = data.currentWeek;
                codeMap.PLAN_ID_PAST = data.planIdPast;

                
               
            }
        }, "obj");
    }
    
    /******************************************************************************************
    ** 선택된 planId의 시작주차 부터 +2주차의 주차데이터 가져오기
    ******************************************************************************************/
    function fn_selectWeekData(fCal, tCal){
        
        fCal = gfn_replaceAll(fCal, "-", "");
        tCal = gfn_replaceAll(tCal, "-", "");
        
        gfn_service({
            async   : false,
            url     : GV_CONTEXT_PATH + "/biz/obj",
            data    : {_mtd : "getList", fCal : fCal, tCal : tCal, tranData:[
                {outDs : "weekList", _siq : "dp.planCommon.weekList"},
            ]},
            success : function(data) {
                codeMap.WEEK_LIST = data.weekList;
            }
        }, "obj");
    }

    /******************************************************************************************
    ** 필터 세팅
    ******************************************************************************************/
    function fn_initFilter() {
        
        gfn_keyPopAddEvent([
            { target : 'divItem', id : 'item', type : 'COM_ITEM_PLAN', title : '<spring:message code="lbl.item"/>' }
        ]);
        
        gfn_setMsComboAll([
            { target : 'divDataCheck', id : 'dataCheck', title : '<spring:message code="lbl.dataCheck"/>', data : codeMap.SP_DATA_CHECK, exData : tDataCheck, type : "S" },
            { target : 'divSoDataCheck', id : 'soDataCheck', title : '<spring:message code="lbl.soDataCheck"/>', data : codeMap.SO_DATA_CHECK, exData:[], type : "S" },
            { target : 'divDataAddSales', id : 'dataAddSales', title : '<spring:message code="lbl.dataAddSales"/>', data : codeMap.SP_DATA_CHECK, exData : tExDatePast, type : "S" },
            { target : 'divPlanIdPast', id : 'planIdPast', title : '<spring:message code="lbl.planId"/>', data : codeMap.PLAN_ID_PAST, exData:[''], type : "S" },
            { target : 'divOverShortMQtyCheckNeedYn', id : 'overShortMQtyCheckNeedYn', title : '<spring:message code="lbl.overShortMQtyCheckNeedYn"/>', data : codeMap.FLAG_YN, exData:[], type : "S" }
       
        ]);
        
        var baseDt = new Date();
        var yymmdd = baseDt.getFullYear() + '' + (baseDt.getMonth() + 1 < 10 ? '0' + (baseDt.getMonth() + 1) : baseDt.getMonth() + 1) + (baseDt.getDate() < 10 ? '0' + baseDt.getDate() : baseDt.getDate());
        
        datePickerOption = DATEPICKET(null, codeMap.PLAN_INFO.MIN_DATE.split("-").join(""), codeMap.PLAN_INFO.TO_DATE.split("-").join(""));
        $("#fromCal").datepicker("option", "minDate", codeMap.PLAN_INFO.MIN_DATE);
        $("#toCal").datepicker("option", "maxDate", codeMap.PLAN_INFO.CLOSE_DATE);
        
        //Plan Version 정보
        $("#planStartPW").val(codeMap.PLAN_INFO.MIN_PWEEK);
        $("#planEndPW").val(codeMap.PLAN_INFO.MAX_PWEEK);
        $("#planStartDay").val(codeMap.PLAN_INFO.MIN_DATE.split("-").join(""));
        $("#planEndDay").val(codeMap.PLAN_INFO.MAX_DATE.split("-").join(""));
        $("#planId").val(codeMap.PLAN_INFO.PLAN_ID);

        //권한정보
        $("#ap2_yn").val(codeMap.ROLE_INFO.AP2_YN);
        $("#goc_yn").val(codeMap.ROLE_INFO.GOC_YN);
        $("#dimWeek").val(codeMap.PLAN_ID_PAST[0].DIM_WEEK);
        $("#dimWeek1").val(codeMap.PLAN_ID_PAST[0].DIM_WEEK_1);
        $("#dimWeekMonday").val(codeMap.PLAN_ID_PAST[0].DIM_WEEK_MONDAY);
        $("#partADimWeek").val(codeMap.PLAN_ID_PAST[0].PART_A_DIM_WEEK);
        $("#partBDimWeek").val(codeMap.PLAN_ID_PAST[0].PART_B_DIM_WEEK);
        $("#planStartWeek").val(codeMap.PLAN_ID_PAST[0].START_WEEK);
        $("#planEndWeek").val(codeMap.PLAN_ID_PAST[0].END_WEEK);
        $("#beforePlanId").val(codeMap.PLAN_ID_PAST[0].BEFORE_PLAN_ID);
        $("#startRemains").val(codeMap.PLAN_ID_PAST[0].START_REMAINS);
        $("#endRemains").val(codeMap.PLAN_ID_PAST[0].END_REMAINS);
        
        $("#currentWeekPop").val(codeMap.CURRENT[0].CURRENT_WEEK);
        $("#currentMonthPop").val(codeMap.CURRENT[0].CURRENT_MONTH);
        $("#currentMonthNextPop").val(codeMap.CURRENT[0].CURRENT_MONTH_NEXT);
        $("#planIdOnePlusWeekPop").val(codeMap.PLAN_ID_PAST[0].DIM_WEEK);
        $("#planStartWeekPop").val(codeMap.PLAN_ID_PAST[0].START_WEEK);
        
        if(apMeaCd == "CFM_SP"){
            $("#pastFlag").val(codeMap.PLAN_ID_PAST[0].CUT_OFF_FLAG);   
        }else{
            $("#pastFlag").val(codeMap.PLAN_ID_PAST[0].RELEASE_FLAG);   
        }
        
        $("#currentDay").val(yymmdd);
        $("#planIdPastW1").val($("#planIdPast option:eq(1)").val()); //계획ID의 전 PlanId
        $("#planIdMonth").val(codeMap.PLAN_ID_PAST[0].YEARMONTH_M);
        fn_selectWeekData(codeMap.PLAN_INFO.MIN_DATE, codeMap.PLAN_INFO.TO_DATE);
        
        
        
        
    }
    
    /******************************************************************************************
    ** 그리드를 초기화 -> 엑셀그리드, 메인 그리드
    ******************************************************************************************/
    function fn_initGrid() {
        
        gv_meaW = 140; //메저 width 설정
        fn_initGridMain(); //메인그리드 초기화
        fn_initGridExcel(); //엑셀그리드 초기화
    }
    
    /******************************************************************************************
    ** 메인 그리드 세팅
    ******************************************************************************************/
    function fn_initGridMain() {
        
        //그리드 설정
        gridInstance = new GRID();
        gridInstance.init("realgrid");
        grdMain      = gridInstance.objGrid;
        dataProvider = gridInstance.objData;
        
        gridInstance.measureHFlag = true;
        
        //그리드 옵션
        grdMain.setOptions({
            stateBar: { visible      : true  },
            sorting : { enabled      : false },
            display : { columnMovable: false }
        });
       
        grdMain.setPasteOptions({
        	
        	checkReadOnly: false,
        	enableAppend: false,
        	
        	applyNumberFormat: false,
            checkDomainOnly: false,
            commitEdit: true,
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
    
    
    /******************************************************************************************
    ** 엑셀 그리드 세팅
    ******************************************************************************************/
    function fn_initGridExcel() {
        
        gridInstanceExcel = new GRID();
        gridInstanceExcel.init("realgridExcel");
        grdMainExcel = gridInstanceExcel.objGrid;
        dataProviderExcel = gridInstanceExcel.objData;
        
        gridInstanceExcel.measureHFlag = true;
        
        //그리드 옵션
        grdMainExcel.setOptions({
            sorting : { enabled      : false },
            display : { columnMovable: false }
        });
       
    }
    
    /******************************************************************************************
    ** 엑셀다운로드 디맨전, 메저 정리
    ******************************************************************************************/
    function fn_getDimMeaInfo(sqlFlag) {
        
        if (sqlFlag != true) {
            
            //메인그리드 보이기
            if (!$("#realgrid").is(":visible")) {
                $("#realgridExcel").hide();
                $("#realgrid").show();
            }
        }
        
        gfn_getMenuInit();      //디멘전 메저 조회
        fn_getBucket("Y").then(function() {
            
            fn_drawGrid(sqlFlag);   //그리드를 그린다.
            
            $("#fromMon").val(gfn_replaceAll($("#fromCal").val(), "-", "").substring(0, 6));
            $("#toMon").val(gfn_replaceAll($("#toCal").val(), "-", "").substring(0, 6));
            
            /* 1. AP1, AP2 화면(23주차기준)
                 - 현재 주차 와 SELECT PLAN_ID에서 선택된 주차를 비교
                 - 과거구간, 미래구간의 기준은 SELECT PLAN_ID의 주차로 비교
                 
                1.1 현재 주차 주차 == SELECT PLAN_ID
                       과거 구간 : TB_KPI_SALES_PLAN 을 조회한다. 과거구간은 22주차 이전
                          미래 구간 : TB_DYN_SALES_PLAN 을 조회한다. 미래구간은 23주차 이후
                1.2 현재 주차 주차 != SELECT PLAN_ID
                       과거 구간 : TB_KPI_SALES_PLAN 을 조회한다. 과거구간은 22주차 이전
                    미래 구간 : TB_HIS_SALES_PLAN 을 조회한다. 미래구간은 23주차 이후 
                      
               2. 판매확정 계호기 화면(23주차기준)
                - 쿼리에서 조회한 현재 주차와 SELECT PLAN_ID에서 선택된 주차을 비교 
                - 과거구간, 미래구간의 기준은 SELECT PLAN_ID의 주차로 비교
            
                2.1 쿼리 주차 == SELECT PLAN_ID
                       과거 구간 : TB_KPI_SALES_PLAN 을 조회한다. 과거구간은 22주차 이전
                          미래 구간 : TB_DYN_SALES_PLAN 을 조회한다. 미래구간은 23주차 이후
                          
                2.2 쿼리 주차 != SELECT PLAN_ID
                       과거 구간 : TB_KPI_SALES_PLAN 을 조회한다. 과거구간은 22주차 이전
                    미래 구간 : TB_HIS_SALES_PLAN 을 조회한다. 미래구간은 23주차 이후             
                    
                EX)    
                현재 주차31주차, SELECT 31주
                 -과거주간은 30주차
                 -미래구간 31주차
                    
                 현재 주차 31, SELECT 29주
                 - 과거구간 28주차까지가 과거구간
                 - 미래구간 29주차부터 
            */
            
            var pastFlag = $("#pastFlag").val();
            var tPlanIdPast = gfn_replaceAll($("#planIdPast").val(), "_W", "");
            var tFomWeek = $("#fromWeek").val();
            var tFormPWeek = $("#fromPWeek").val();
            var tToWeek = $("#toWeek").val();
            var tToPWeek = $("#toPWeek").val();
            
            if(meaCd == "CFM"){ //판매확정 계획화면
                
                if(tFomWeek >= tPlanIdPast){ //과거구간 없음(KPI 미존재)                 
                    $("#pastPlanIdStartWeek").val("");
                    $("#pastPlanIdEndWeek").val("");
                    $("#futurePlanIdStartWeek").val(tFormPWeek);  
                    $("#futurePlanIdEndWeek").val(tToPWeek); 
                }else if(tToWeek < tPlanIdPast){//미래구간 없음(HIS 미존재)
                    $("#pastPlanIdStartWeek").val(tFormPWeek); 
                    $("#pastPlanIdEndWeek").val(tToPWeek);
                    $("#futurePlanIdStartWeek").val("");  
                    $("#futurePlanIdEndWeek").val(""); 
                }else{//둘다 존재
                    $("#pastPlanIdStartWeek").val(tFormPWeek); 
                    $("#pastPlanIdEndWeek").val(tPlanIdPast); 
                    $("#futurePlanIdStartWeek").val(tPlanIdPast);  
                    $("#futurePlanIdEndWeek").val(tToPWeek); 
                }
                
            }else{//AP1, AP2화면
                
                if(tFomWeek >= tPlanIdPast){ //과거구간 없음(KPI 미존재)                 
                    $("#pastPlanIdStartWeek").val("");
                    $("#pastPlanIdEndWeek").val("");
                    $("#futurePlanIdStartWeek").val(tFormPWeek);  
                    $("#futurePlanIdEndWeek").val(tToPWeek); 
                
                }else if(tToWeek < tPlanIdPast){//미래구간 없음(HIS 미존재)
                    $("#pastPlanIdStartWeek").val(tFormPWeek); 
                    $("#pastPlanIdEndWeek").val(tToPWeek);
                    $("#futurePlanIdStartWeek").val("");  
                    $("#futurePlanIdEndWeek").val("");
                }else{
                    $("#pastPlanIdStartWeek").val(tFormPWeek); 
                    $("#pastPlanIdEndWeek").val(tPlanIdPast); 
                    $("#futurePlanIdStartWeek").val(tPlanIdPast);  
                    $("#futurePlanIdEndWeek").val(tToPWeek); 
                }
            }
            
            gfn_service({
                async   : false,
                url     : GV_CONTEXT_PATH + "/biz/obj",
                data    : {_mtd : "getList", menuParam : meaCd, yearWeek : $("#planStartWeek").val(), pastFlag : pastFlag, 
                    tranData:[
                    {outDs : "qtyDate", _siq : "dp.planCommon.qtyDateSearch"},
                    
                ]},
                success : function(data) {
                    $("#qtyDate").val(data.qtyDate[0].YYYYMMDD);
                }
            }, "obj");

            //조회조건 설정
            FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
            FORM_SEARCH.sql        = sqlFlag;
            FORM_SEARCH.hrcyFlag   = true;
            FORM_SEARCH.dimList    = DIMENSION.user;
            FORM_SEARCH.hiddenList = DIMENSION.hidden;
            FORM_SEARCH.meaList    = MEASURE.user;
            FORM_SEARCH.bucketList = BUCKET.query;
            FORM_SEARCH.pastFlag   = pastFlag;
            FORM_SEARCH.authorityFlag = authorityFlag;
            
            fn_getGridData();
            fn_getExcelData();
        });
        
    }
    
    /******************************************************************************************
    ** 엑셀 그리드 그리기
    ******************************************************************************************/
    function fn_drawGridExcel(sqlFlag) {
        
        gridInstanceExcel.setDraw();
        fn_setNumberFields(dataProviderExcel); // Dimension 중에 숫자 타입인 필드 number 타입으로 변경
        fn_getDimMeaInfo(sqlFlag);
    }
    
    /******************************************************************************************
    ** 엑셀다운로드
    ******************************************************************************************/
    function fn_excelDown() {
        
        var EXCEL_FORM = $("#searchForm").serializeObject();
        EXCEL_FORM.fromPWeek  = EXCEL_FORM.planStartPW;
        EXCEL_FORM.toPWeek    = EXCEL_FORM.planEndPW;
        EXCEL_FORM.fromCal    = EXCEL_FORM.planStartDay;
        EXCEL_FORM.toCal      = EXCEL_FORM.planEndDay;
        
        EXCEL_FORM.sql        = false;
        EXCEL_FORM.hrcyFlag   = true;
        EXCEL_FORM.dimList    = EXCEL_GRID_DATA.DIM;
        EXCEL_FORM.meaList    = EXCEL_GRID_DATA.MEA;
        EXCEL_FORM.bucketList = EXCEL_GRID_DATA.BUC;
        EXCEL_FORM.hiddenList = EXCEL_GRID_DATA.DIM_H;
        EXCEL_FORM._mtd       = "getList";
        EXCEL_FORM.excelFlag  = "Y";
        EXCEL_FORM.pastFlag   = "N";
        EXCEL_FORM.authorityFlag = EXCEL_GRID_DATA.authorityFlag;
        EXCEL_FORM.tranData   = [{outDs : "gridList", _siq : apMeaCdSql}];
        
        gfn_service({
            url    : GV_CONTEXT_PATH + "/biz/obj",
            data   : EXCEL_FORM,
            success: function(data) {
                
                var gridListExcel = [];
                
                $.each(data.gridList, function(idx, item) {
                    
                    if (item.GRP_LVL_ID == "0") {
                        gridListExcel.push(item);
                    }
                });
                
                dataProviderExcel.clearRows();
                grdMainExcel.cancel();
                dataProviderExcel.setRows(gridListExcel);
                dataProviderExcel.clearSavePoints();
                dataProviderExcel.savePoint();
                
                //권한 주기
                dataProviderExcel.beginUpdate();
                
                
                if(meaCd == "AP2")
                {
                    
                    var editStyle = {};
                    var val = gfn_getDynamicStyle(-2);
                    
                    editStyle.background = yellowColor;
                    
                    val.criteria.push("(values['OVER_SHORT_M_NM'] < 0) and (values['NEW_DEMAND_CUSTOM'] > 0)");
                    val.styles.push(editStyle);
                    
                    grdMainExcel.setColumnProperty("OVER_SHORT_M_NM", "dynamicStyles", [val]);
                }
                
                if(meaCd == "AP2")
                {
                    
                    var editStyle = {};
                    var val = gfn_getDynamicStyle(-2);
                    
                    editStyle.background = yellowColor;
                    
                    val.criteria.push("(values['MAT_ISSUE_FLAG'] = 'Y')");
                    val.styles.push(editStyle);
                    
                    grdMainExcel.setColumnProperty("ITEM_CD_NM", "dynamicStyles", [val]);
                }
                
                
                $.each(EXCEL_GRID_DATA.BUC, function(n, v) {
            
                    var pBucketId = v.BUCKET_ID;
                    var pBucketIdSub = pBucketId + "_YN";
                    
                    if(pBucketId.indexOf("_AMT_KRW") == -1 && pBucketId.indexOf("MT_") == -1 && pBucketId.indexOf("_DMD") != -1 && pBucketId.indexOf(meaCd) != -1 && pBucketId.indexOf("_W1") == -1){
                        
                        var editStyle = {};
                        var val = gfn_getDynamicStyle(-2);
                        
                        editStyle.background = gv_editColor;
                        //editStyle.editable = true;
                        
                        val.criteria.push("(values['"+ pBucketIdSub +"'] = 'Y')");
                        val.styles.push(editStyle);
                        
                        grdMainExcel.setColumnProperty(grdMainExcel.columnByField(pBucketId), "dynamicStyles", [val]);
                    }
                    
                    //비고 권한주기
                    if(n == 0){
                        var editStyle = {};
                        var val = gfn_getDynamicStyle(-2);
                        
                        editStyle.background = gv_editColor;
                        editStyle.editable = true;
                        
                        val.criteria.push("(values['PW_REMARK_YN'] = 'Y')");
                        val.styles.push(editStyle);
                        
                        grdMainExcel.setColumnProperty(grdMainExcel.columnByField("REMARK_NM"), "dynamicStyles", [val]);
                        if(meaCd == "CFM"){
                            grdMainExcel.setColumnProperty(grdMainExcel.columnByField("CFM_CHG_REASON_NM"), "dynamicStyles", [val]);    
                        }
                    } 
                });  
                
                
              
                
                dataProviderExcel.endUpdate(); 
                
                gfn_doExportExcel({
                    gridIdx            : 1,
                    fileNm             : "${menuInfo.menuNm} ("+$("#planId").val()+")",
                    formYn             : "Y",
                    indicator          : "hidden",
                    conFirmFlag        : false,
                    applyDynamicStyles : true
                });
            }
        }, "obj"); 
    }
    
    /******************************************************************************************
    ** 엑셀업로드
    ******************************************************************************************/
    function fn_excelUpload() {
        
        gfn_importGrid({
            gridIdx  : 1,
            callback : function() {
                
                dataProviderExcel.clearSavePoints(); //그리드 초기화 포인트 저장
                dataProviderExcel.savePoint();
                
                $("#realgrid").hide(); // 메인그리드 숨기기
                $("#realgridExcel").show(); // 엑셀그리드 보이기
                grdMainExcel.resetSize();
                
                fn_setBtnDisplay("Y");
            }
        });
    }
    
    /******************************************************************************************
    ** 이벤트 세팅
    ******************************************************************************************/
    function fn_initEvent() {
        
        //달력 이벤트
        $("#fromCal").change("on", function() {
            $(this).val($("#swFromDate").val());
            var tmpV = gfn_getFindDataDsInDs(datePickerOption.arrTarget, {calId : {VALUE : "fromCal", CONDI : "="}});
            gfn_onSelectFn(tmpV[0], $(this).val());
            
            setDayDate(tmpV[0].calId, periodNumPlus);
        });
        
        $("#toCal").change("on", function() {
            $(this).val($("#swToDate").val());
            var tmpV = gfn_getFindDataDsInDs(datePickerOption.arrTarget, {calId : {VALUE : "toCal", CONDI : "="}});
            gfn_onSelectFn(tmpV[0], $(this).val());
            
            setDayDate(tmpV[0].calId, periodNumMinus);
        });
        
        $("#btnSummary").on('click', function (e) {
            gfn_comPopupOpen("PLAN_SUMMARY", {
                rootUrl : "dp/salesPlan",
                url     : "salesPlanSummary",
                width   : 1060,
                height  : 680,
                currentWeekPop : $("#currentWeekPop").val(),
                planIdOnePlusWeekPop : $("#planIdOnePlusWeekPop").val(),
                planStartWeekPop : $("#planStartWeekPop").val(),
                currentMonthPop : $("#currentMonthPop").val(),
                currentMonthNextPop : $("#currentMonthNextPop").val(),
                measCd : apMeaCd,
                menuCd : paramMenuCd
            });
        });
        
        /* $("#btnSummary2").on('click', function (e) {
            gfn_comPopupOpen("PLAN_SUMMARY2", {
                rootUrl : "dp/salesPlan",
                url     : "salesPlanCfmSummary",
                width   : 1200,
                height  : 600,
                planId : $("#planIdPast").val(),
                planStartWeek : $("#planStartWeek").val(),
                planStartWeek_1 : $("#dimWeek").val(),
                planStartWeek_2 : $("#dimWeek1").val(),
                planStartWeekMonday : $("#dimWeekMonday").val(),
            });
        }); */
        
        $("#planIdPast").change("on", function(){
            
            var tPlanIdPast = $("#planIdPast").val();
            
            $.each(codeMap.PLAN_ID_PAST, function(n, v){
                
                var num = Number(n) + 1;
                var tempVal = v.CODE_CD;
                var tStartDay = v.START_DAY.substring(0, 4) + "-" + v.START_DAY.substring(4, 6) + "-" + v.START_DAY.substring(6, 8);
                var tEndDay = v.END_DAY.substring(0, 4) + "-" + v.END_DAY.substring(4, 6) + "-" + v.END_DAY.substring(6, 8);
                var tCloseDay = v.CLOSE_DAY.substring(0, 4) + "-" + v.CLOSE_DAY.substring(4, 6) + "-" + v.CLOSE_DAY.substring(6, 8);
                var tStartWeek = v.START_WEEK;
                var tEndWeek = v.END_WEEK;
                var tDimWeek = v.DIM_WEEK;
                var tDimWeek1 = v.DIM_WEEK_1;
                var tDimWeekMonday = v.DIM_WEEK_MONDAY;
                var tPartADimWeek = v.PART_A_DIM_WEEK;
                var tPartBDimWeek = v.PART_B_DIM_WEEK;
                var tBeforePlanId = v.BEFORE_PLAN_ID;
                var tStartRemains = v.START_REMAINS;
                var tEndRemains = v.END_REMAINS;
                var tW3Day = v.W3_DAY;
                var tPastFlag = ""; 
                var tYEARMONTH = v.YEARMONTH_M
                
                
                if(apMeaCd == "CFM_SP"){
                    tPastFlag = v.CUT_OFF_FLAG;
                }else{
                    tPastFlag = v.RELEASE_FLAG;
                }
                
                if(tPlanIdPast == tempVal){
                    
                    $("#fromCal").datepicker("option", "minDate", tStartDay);
                    $("#toCal").datepicker("option", "maxDate", tCloseDay);
                    
                    $("#fromCal").val(tStartDay);
                    var tmpV = gfn_getFindDataDsInDs(datePickerOption.arrTarget, {calId : {VALUE : "fromCal", CONDI : "="}});
                    gfn_onSelectFn(tmpV[0], tStartDay);
                    
                    $("#toCal").val(tEndDay);       
                    var tmpV = gfn_getFindDataDsInDs(datePickerOption.arrTarget, {calId : {VALUE : "toCal", CONDI : "="}});
                    gfn_onSelectFn(tmpV[0], tEndDay);
                    
                    //디멘저 생산계획, 생산미반영, 예상주말재고, 가용수량, 생산계획 잔량 을 구하기 위한 주차 세팅
                    $("#dimWeek").val(tDimWeek);
                    $("#dimWeek1").val(tDimWeek1);
                    $("#dimWeekMonday").val(tDimWeekMonday);
                    
                    $("#partADimWeek").val(tPartADimWeek);
                    $("#partBDimWeek").val(tPartBDimWeek);
                    $("#planStartWeek").val(tStartWeek);
                    $("#planEndWeek").val(tEndWeek);
                    $("#beforePlanId").val(tBeforePlanId);
                    $("#startRemains").val(tStartRemains);
                    $("#endRemains").val(tEndRemains);
                    $("#pastFlag").val(tPastFlag);
                    $("#planIdPastW1").val($("#planIdPast option:eq("+ num +")").val());
                    $("#planIdMonth").val(tYEARMONTH);
                    
                    
                    fn_selectWeekData(v.START_DAY, v.END_DAY);
                }
            });
            
            fn_setBtnDisplay();
            
            
        });
        
        // 버튼 이벤트
        $(".fl_app").click ("on", function() { fn_apply();}); 
        $("#btnCopyST").click ("on", function() { fn_copy("ST"); });
        $("#btnCopyWW").click ("on", function() { fn_copy("WW"); });
        $("#btnCopyValue").click ("on", function() { fn_copy("Value"); }); 
        $("#btnExcelDown").click ("on", function() { fn_excelDown(); }); 
        $("#btnExcelUpload").click ("on", function() { $("#excelFile").trigger("click"); });
        $("#excelFile").change("on", function() { fn_excelUpload(); });
        $("#btnConfirmY").click ("on", function() { fn_confirm("Y"); });
        $("#btnConfirmN").click ("on", function() { fn_confirm("N"); });
        $("#btnReset").click ("on", function() { fn_reset(); });
        $("#btnSave").click ("on", function() { fn_save(); });
        
        $("#btnMonthOut").show();
        //month sum omit0 처리
        gfn_setMonthSum(gridInstance, true, true, true, false, true);
        
        
        
        //그리드 이벤트
        grdMain.onCellPasting = function(grid, index, value) {
			  
        	if(apMeaCd == 'AP2_SP')
            {
        		
        		/* 
                code가 1일때는 붙여넣기허용 2 일때는 붙여넣기불가 그 외에는 cell상태에 따라 결정.
                */
                
                var code = grdMain.getValue(index.itemIndex, index.fieldName+'_YN')
                
        		//return code === 'Y' ? true : code === '2' ? false : null;
                return code === 'Y' ? true : false;
                
        		
            }
        	else
            {
                return false;
            }
        	 
        }
        
        
        grdMain.onEditRowChanged = function (grid, itemIndex, dataRow, field, oldValue, newValue) {
            fn_allInOneCalc(grid, itemIndex, dataRow, field, oldValue, newValue);
        };
        
        grdMain.onEditRowPasted = function(grid, itemIndex, dataRow, fields, oldValues, newValues) {
            
            if (fields.length == newValues.length) {
                fn_allInOneCalc(grid, itemIndex, dataRow, fields, oldValues, newValues);
            } else {
                var arrNewVal = [];
                $.each(fields, function(n, v) {
                    arrNewVal.push(newValues[v]);
                });
                fn_allInOneCalc(grid, itemIndex, dataRow, fields, oldValues, arrNewVal);
            } 
        };
        
        grdMain.onKeyUp = function (grid, key, ctrl, shift, alt) {
            
            if(key == 46){  //Delete Key
                gfn_selBlockDelete(grid, dataProvider, "dynamic", "PLAN_SALES"); //셀구성  
            }
        };
        
        grdMain.onRowsPasted = function (grid, items) {
            GRIDCALC.changeMap = []; //변경된 데이터 초기화
        };
        
        grdMain.onShowHeaderTooltip = function (grid, column, value) {
            
            var result = value;
            var fname = gfn_nvl(column.fieldName, "");
            
            if(fname.indexOf("_AMT_KRW") == -1 && fname.indexOf("PW") != -1){
                
                if(fname.indexOf("_DMD1") != -1){
                    result = '<spring:message code="lbl.apdmd1"/>';
                }else if(fname.indexOf("_DMD2") != -1){
                    result = '<spring:message code="lbl.apdmd2"/>';
                }else if(fname.indexOf("_DMD3") != -1){
                    result = '<spring:message code="lbl.apdmd3"/>';
                }
            }
            return result;
        }   
    }
    
    /******************************************************************************************
    ** 버켓에 메저를 가로로 세팅
    ******************************************************************************************/
    function fn_bucketMeasure(){
        
        $.each(BUCKET.all[1], function(n, v) {
            
            if(v.TOT_TYPE == "MT"){
                v.TOT_TYPE = "";
                v.TYPE = "group";
            }
        });
    }
    
    /******************************************************************************************
    ** 메인 그리드 그리기
    ******************************************************************************************/
    function fn_drawGrid(sqlFlag) {
        
        $.each(BUCKET.all[1], function(i, val){
            
            var bucketIdHd = val.CD;
            var bucketIdHdSub = gfn_replaceAll(bucketIdHd, "PW", "");
            
            if(bucketIdHd.indexOf("MT_") == -1){
                
                var hd1 = bucketIdHd + "_" + meaCd + "_DMD1_SP_HD";
                var hd2 = bucketIdHd + "_" + meaCd + "_DMD2_SP_HD";
                var hd3 = bucketIdHd + "_" + meaCd + "_DMD3_SP_HD";
                var hd = bucketIdHd + "_" + meaCd + "_SP_HD";
                var adjHd = "";
                
                if(apMeaCd == "CFM_SP"){
                    adjHd = bucketIdHd + "_AP2_SP_HD";
                }else if(apMeaCd == "AP2_SP"){
                    adjHd = bucketIdHd + "_" + meaCd + "_SP_W1_HD";
                }
                
                var hd1Option = {ROOT_CD : bucketIdHd, BUCKET_ID : hd1, BUCKET_VAL : bucketIdHdSub, CD : hd1, NM : "HD_1"};
                var hd2Option = {ROOT_CD : bucketIdHd, BUCKET_ID : hd2, BUCKET_VAL : bucketIdHdSub, CD : hd2, NM : "HD_2"};
                var hd3Option = {ROOT_CD : bucketIdHd, BUCKET_ID : hd3, BUCKET_VAL : bucketIdHdSub, CD : hd3, NM : "HD_3"};
                var hdOption = {ROOT_CD : bucketIdHd, BUCKET_ID : hd, BUCKET_VAL : bucketIdHdSub, CD : hd, NM : "HD"};
                var adjHdOption = {ROOT_CD : bucketIdHd, BUCKET_ID : adjHd, BUCKET_VAL : bucketIdHdSub, CD : adjHd, NM : "ADJ_HD"};
                
                BUCKET.query.push(hd1Option);
                BUCKET.query.push(hd2Option);
                BUCKET.query.push(hd3Option);
                BUCKET.query.push(hdOption);
                BUCKET.query.push(adjHdOption);
            }
        });
        
        if (sqlFlag) {
            return;
        }
        
        // 데이터셋에만 존재하는 컬럼 추가
        DIMENSION.hidden = [];
        DIMENSION.hidden.push({CD : "SALES_1M", dataType : "number"});
        DIMENSION.hidden.push({CD : "SALES_3M", dataType : "number"});
        DIMENSION.hidden.push({CD : "SALES_12M", dataType : "number"});
        DIMENSION.hidden.push({CD : "SALES_PRICE_KRW_HIDDEN", dataType : "number"});
        DIMENSION.hidden.push({CD : "SALES_3M_WEEK_HIDDEN", dataType : "number"});
        DIMENSION.hidden.push({CD : "CONFIRM_YN", dataType : "text"});
        DIMENSION.hidden.push({CD : "PROD_LVL2_CD", dataType : "text"});
        DIMENSION.hidden.push({CD : "CUST_LVL2_CD_HIDDEN", dataType : "text"});
        DIMENSION.hidden.push({CD : "PW_REMARK_YN", dataType : "text"});
        DIMENSION.hidden.push({CD : "MY_SELECT_ITEM", dataType : "text"});
        if(meaCd == "AP2")
        {
            DIMENSION.hidden.push({CD : "NEW_DEMAND_CUSTOM", dataType : "number"});
        }
        var authorityCnt = 0;
        //권한 필드 추가
        $.each(BUCKET.query, function(i, val){
            
            var bucketIdVal = val.BUCKET_ID + "_YN";
            
            if(bucketIdVal.indexOf("_AMT_KRW") == -1 && bucketIdVal.indexOf("MT_") == -1 && bucketIdVal.indexOf("_DMD") != -1 && bucketIdVal.indexOf(meaCd) != -1 && bucketIdVal.indexOf("_W1") == -1 && bucketIdVal.indexOf("_HD") == -1){
                DIMENSION.hidden.push({CD : bucketIdVal, dataType : "text"});
                authorityCnt++;
            }
            
            if(meaCd == "AP2" || meaCd == "CFM"){
                if(bucketIdVal.indexOf("ADJ_REASON") != -1 && bucketIdVal.indexOf("MT_") == -1){
                    DIMENSION.hidden.push({CD : bucketIdVal, dataType : "text"});
                    authorityCnt++;
                }       
            }
        });
        
        if(authorityCnt > 0){
            authorityFlag = "Y";
        }else{
            authorityFlag = "N";
        }
        
        gridInstance.setDraw();
        fn_setNumberFields(dataProvider);
    }
    
    /******************************************************************************************
    ** 버켓정보 조회
    ******************************************************************************************/
    function fn_getBucket(isWeekMt) {
        
        var deferred = $.Deferred();
        
        var fromDate, toDate;
        if(isWeekMt == "Y"){
            fromDate = gfn_replaceAll($("#fromCal").val(), "-", "");
            toDate   = gfn_replaceAll($("#toCal").val(), "-", "");
        }else{
            fromDate = gfn_replaceAll(codeMap.PLAN_INFO.MIN_DATE, "-", "");
            toDate   = gfn_replaceAll(codeMap.PLAN_INFO.MAX_DATE, "-", "");
        }
        
        var ajaxMap = {
            fromDate: fromDate,
            toDate  : toDate,
            month   : {isDown : "Y", isUp : "N", upCal : "Q", isMt : "N", isExp : "Y", expCnt : 999},
            week    : {isDown : "Y", isUp : "Y", upCal : "M", isMt : isWeekMt, isExp : "N", expCnt : 999},
            sqlId   : ["bucketMonth", "bucketWeek"]
        }
        
        
        if(isWeekMt == "Y"){
            gfn_getBucket(ajaxMap, true, fn_bucketMeasure); 
        }else{
            gfn_getBucket(ajaxMap, true);
        }
        
        return deferred.resolve();
        
    }
    
    /******************************************************************************************
    ** 조회에 필요한 데이터 세팅
    ******************************************************************************************/
    function fn_apply(sqlFlag) {
        
        gfn_service({
            async   : false,
            url     : GV_CONTEXT_PATH + "/biz/obj",
            data    : {
                _mtd           : "getList",
                SEARCH_MENU_CD : "${menuInfo.menuCd}",
                tranData       : [
                    {outDs : "dimList", _siq : "admin.dimMapMenu"},
                    {outDs : "meaList", _siq : "common.meaConf"},
                ]
            },
            success :function(data) {
                
                DIMENSION.user = [];
                DIMENSION.user = data.dimList;
                
                //Total Open S/O
                DIMENSION.user.push({
                    DIM_CD       : "TOTAL_OPEN_SO",
                    DIM_NM       : '<spring:message code="lbl.totalOpenSo" />',
                    LVL          : DIMENSION.user[DIMENSION.user.length-1].LVL,  
                    DIM_ALIGN_CD : "L",
                    WIDTH        : "80"
                });
                
                DIMENSION.hidden = [];
                DIMENSION.hidden.push({CD : "CONFIRM_YN", dataType : "text"});
                DIMENSION.hidden.push({CD : "PROD_LVL2_CD", dataType : "text"});
                DIMENSION.hidden.push({CD : "CUST_LVL2_CD_HIDDEN", dataType : "text"});
                DIMENSION.hidden.push({CD : "PW_REMARK_YN", dataType : "text"});
                DIMENSION.hidden.push({CD : "MY_SELECT_ITEM", dataType : "text"});
                
                if(meaCd == "AP2")
                {
                    DIMENSION.hidden.push({CD : "NEW_DEMAND_CUSTOM", dataType : "number"});
                }
                
                //메저 정리
                MEASURE.user = [];
                
                excelUpdateCnt = 0;
                widthCnt = 0;
                
                $.each(data.meaList, function(idx, mea) {
                    
                    var measCd = mea.MEAS_CD;
                    var userUseFlag = mea.USER_USE_FLAG;
                    
                    if(measCd.indexOf("_AMT_KRW") == -1 && measCd.indexOf(meaCd) != -1 && measCd.indexOf("_W1") == -1 && measCd.indexOf(apMeaCd) == -1 && userUseFlag == "Y"){
                        mea.CD = measCd;
                        mea.NM = mea.MEAS_NM;
                        MEASURE.user.push(mea);
                        excelUpdateCnt++;
                    }
                    
                    if(measCd.indexOf(meaCd) != -1 && measCd.indexOf("_W1") == -1 && userUseFlag == "Y"){
                        widthCnt++;
                    }
                });
            }
        }, "obj");
        
        fn_getBucket("N").then(function() {
            
            //권한 필드 추가
            var authorityCnt = 0;
            
            $.each(BUCKET.query, function(i, val){
                var bucketIdVal = val.BUCKET_ID + "_YN";
                
                if(bucketIdVal.indexOf("_AMT_KRW") == -1 && bucketIdVal.indexOf("MT_") == -1 && bucketIdVal.indexOf("_DMD") != -1 && bucketIdVal.indexOf("_W1") == -1){
                    DIMENSION.hidden.push({CD : bucketIdVal, dataType : "text"});
                    authorityCnt++;
                }
            });
            
            if(authorityCnt > 0){
                authorityFlag = "Y";
            }else{
                authorityFlag = "N";
            }
            
            //엑셀그리드데이터 (디멘전,메저,버킷)
            EXCEL_GRID_DATA = {
                DIM : DIMENSION.user,
                DIM_H : DIMENSION.hidden,
                MEA : MEASURE.user,
                BUC : BUCKET.query,
                BUC_B : BUCKET.all[1],
                authorityFlag : authorityFlag 
            };  
            
            fn_drawGridExcel(sqlFlag);  //그리드를 그린다
        });
        
    }
    
    /******************************************************************************************
    ** 조회
    ******************************************************************************************/
    function fn_getGridData() {
        
        FORM_SEARCH._mtd = "getList";
        FORM_SEARCH.tranData = [
            {outDs : "gridList", _siq : apMeaCdSql}
        ];
        gfn_service({
            url    : GV_CONTEXT_PATH + "/biz/obj",
            data   : FORM_SEARCH,
            success: function(data) {
                
                dataProvider.clearRows(); //그리드 데이터 삭제
                grdMain.cancel();
                dataProvider.setRows(data.gridList); //그리드 데이터 생성
                dataProvider.clearSavePoints(); //그리드 초기화 포인트 저장
                dataProvider.savePoint();
                gfn_actionMonthSum(gridInstance); //month sum omit0
                fn_setBtnDisplay("Y");
                fn_gridCallback();
                gfn_setRowTotalFixed(grdMain);
                
            }
        }, "obj");
    }
    
    /******************************************************************************************
    ** 그리드 Callback
    ******************************************************************************************/
    function fn_gridCallback(){
        
        var flagCnt = 0;
        var flagColorCnt = 0;
        var measureLen = MEASURE.user.length;
        //권한 주기 및 헤더 색상 변경
        dataProvider.beginUpdate();
        
        
        if(meaCd == "AP2")
        {
        	
            var editStyle = {};
            var val = gfn_getDynamicStyle(-2);
            
            editStyle.background = yellowColor;
            
            val.criteria.push("(values['OVER_SHORT_M_NM'] < 0) and (values['NEW_DEMAND_CUSTOM'] > 0)");
            val.styles.push(editStyle);
            
            grdMain.setColumnProperty("OVER_SHORT_M_NM", "dynamicStyles", [val]);
        }
        
        if(meaCd == "AP2")
        {
            
            var editStyle = {};
            var val = gfn_getDynamicStyle(-2);
            
            editStyle.background = yellowColor;
            
            val.criteria.push("(values['MAT_ISSUE_FLAG'] = 'Y')");
            val.styles.push(editStyle);
            
            grdMain.setColumnProperty("ITEM_CD_NM", "dynamicStyles", [val]);
        }
        
        
        $.each(BUCKET.query, function(n, v) {
            
            var pRootCd = v.ROOT_CD;
            var pBucketId = v.BUCKET_ID;
            var pBucketIdSub = pBucketId + "_YN";
            
            
            
            if(pBucketId.indexOf("_AMT_KRW") == -1 && pBucketId.indexOf("MT_") == -1 && pBucketId.indexOf("_DMD") != -1 && pBucketId.indexOf(meaCd) != -1 && pBucketId.indexOf("_W1") == -1){
                
                var editStyle = {};
                var val = gfn_getDynamicStyle(-2);
                
                editStyle.background = gv_editColor;
                editStyle.editable = true;
                
                val.criteria.push("(values['"+ pBucketIdSub +"'] = 'Y')");
                val.styles.push(editStyle);
                
                grdMain.setColumnProperty(grdMain.columnByField(pBucketId), "dynamicStyles", [val]);
                grdMain.setColumnProperty(pBucketId, "editor", {type : "number", positiveOnly : true, integerOnly : true});
            }
            
            //조정사유
            if(meaCd == "AP2" || meaCd == "CFM"){
                if(pBucketId.indexOf("ADJ_REASON") != -1 && pBucketId.indexOf("MT_") == -1){
                    
                    var editStyle = {};
                    var val = gfn_getDynamicStyle(-2);
                    
                    editStyle.background = gv_editColor;
                    editStyle.editable = true;
                    
                    val.criteria.push("(values['"+ pBucketIdSub +"'] = 'Y')");
                    val.styles.push(editStyle);
                    
                    grdMain.setColumnProperty(grdMain.columnByField(pBucketId), "dynamicStyles", [val]);
                }       
            }
            
            //비고, 확정변경사유 권한주기
            if(n == 0){
                var editStyle = {};
                var val = gfn_getDynamicStyle(-2);
                
                editStyle.background = gv_editColor;
                editStyle.editable = true;
                
                val.criteria.push("(values['PW_REMARK_YN'] = 'Y')");
                val.styles.push(editStyle);
                
                grdMain.setColumnProperty(grdMain.columnByField("REMARK_NM"), "dynamicStyles", [val]);
                if(meaCd == "CFM"){
                    grdMain.setColumnProperty(grdMain.columnByField("CFM_CHG_REASON_NM"), "dynamicStyles", [val]);  
                }
            } 
            
            //헤더 컬럼 변경 START
            if(pBucketId.indexOf("_HD") == -1){
                flagCnt++;
                
                if(flagColorCnt % 2 == 1){
                    
                    var setHeader = grdMain.getColumnProperty(pBucketId, "header");
                    setHeader.styles = {background: gv_headerColor};
                    grdMain.setColumnProperty(pBucketId, "header", setHeader);          
                    
                    if(flagCnt == 1){
                        var setHeader = grdMain.getColumnProperty(pRootCd, "header");
                        setHeader.styles = {background: gv_headerColor};
                        grdMain.setColumnProperty(pRootCd, "header", setHeader);            
                    }
                }
                
                if(flagCnt == measureLen){
                    flagCnt = 0;
                    flagColorCnt++;
                }   
            }
            //헤더 컬럼 변경 END
        });  
        
        dataProvider.endUpdate();
    }
    
    
    
    
    /******************************************************************************************
    ** 저장
    ******************************************************************************************/
    function fn_save() {
        
        var jsonRows;
        var excelFlag = $("#realgrid").is(":visible");
        var excelFlagYn = "";
        
        if(excelFlag){
            jsonRows = gfn_getGrdSavedataAll(grdMain);
            
            var jsonRowsLen = jsonRows.length - 1;
            
            for(var i = jsonRowsLen; i >= 0; i--){
                
                var grpLvlCd = jsonRows[i].GRP_LVL_ID;
                
                if(grpLvlCd != "0"){
                    jsonRows.splice(i, 1);
                }
            } 
        }else{
            grdMainExcel.commit();
            jsonRows = dataProviderExcel.getJsonRows();
        }
        
        if(jsonRows.length == 0){
            alert('<spring:message code="msg.noChangeData"/>');
            return;
        }
        
        confirm('<spring:message code="msg.saveCfm"/>', function() {
        
            var salesPlanDatas = [];
            var salesReasonDatas = [];
            
            $.each(jsonRows, function(i, row) {
                
                var custLvl2Cd = row.CUST_LVL2_CD_HIDDEN;
                
                if(!excelFlag){
                    custLvl2Cd = row.CUST_LVL2_CD_NM;
                }
                
                var planData = {
                    ITEM_CD       : row.ITEM_CD_NM,
                    CUST_GROUP_CD : row.CUST_GROUP_CD_NM,
                    CUST_LVL2_CD  : custLvl2Cd,
                    MEAS_CD       : apMeaCd,
                    BUCKET_LIST   : []
                };
                
                var planReasonData = {
                    ITEM_CD       : row.ITEM_CD_NM,
                    CUST_GROUP_CD : row.CUST_GROUP_CD_NM,
                    CUST_LVL2_CD  : custLvl2Cd,
                    MEAS_CD       : apMeaCd,
                    BUCKET_LIST   : []
                };
                
                //AP1_SP, AP2_SP, CFM_SP -> 4번재 마다 UPDATE
                var updateCnt = 0; 
                
                if(excelFlag){
                    excelFlagYn = "N";
                    
                    $.each(row, function(attr, value) {
                        
                        var attrSplit = attr.split("_");
                        var yearpweek = gfn_replaceAll(attrSplit[0], "PW", "");
                        var paramMeasCd = gfn_replaceAll(attr, attrSplit[0] + "_", "");
                        
                        
                        
                        if(attr.indexOf("PW") == 0 && attr.indexOf("_AMT_KRW") == -1 && attr.indexOf(meaCd) != -1 && attr.indexOf("_YN") == -1 && attr.indexOf("_W1") == -1 && attr.indexOf("_HD") != -1){
                            
                            updateCnt++;
                            
                            var paramMeasCdSub = gfn_replaceAll(paramMeasCd, "_HD", "");
                            
                            planData.BUCKET_LIST.push({
                                YEARPWEEK  : yearpweek,
                                YEARWEEK   : yearpweek.length == 6 ? yearpweek : yearpweek.substring(0, 6),
                                QTY        : value == undefined ? 'NULL' : value,
                                MEAS       : paramMeasCdSub,
                                UPDATE_CNT : updateCnt
                            });
                            
                            if(updateCnt == 4){
                                updateCnt = 0;
                            }
                            
                        }else if(attr.indexOf("PW") == 0 && attr.indexOf("ADJ_REASON") != -1 && attr.indexOf("_YN") == -1){
                            planReasonData.BUCKET_LIST.push({
                                YEARPWEEK  : yearpweek,
                                YEARWEEK   : yearpweek.length == 6 ? yearpweek : yearpweek.substring(0, 6),
                                ADJ_REASON : value == undefined ? '' : value
                            });
                        }
                    });
                    
                    salesPlanDatas.push(planData);
                    
                    if(planReasonData.BUCKET_LIST.length > 0){
                        salesReasonDatas.push(planReasonData)   
                    }
                }else{
                    excelFlagYn = "Y";
                    
                    $.each(row, function(attr, value) {
                        
                        var attrSplit = attr.split("_");
                        var yearpweek = gfn_replaceAll(attrSplit[0], "PW", "");
                        var paramMeasCd = gfn_replaceAll(attr, attrSplit[0] + "_", "");
                        
                        if(attr.indexOf("PW") == 0 && attr.indexOf("_AMT_KRW") == -1 && attr.indexOf(meaCd) != -1 && attr.indexOf("_YN") == -1){
                            
                            updateCnt++;
                            
                            planData.BUCKET_LIST.push({
                                YEARPWEEK  : yearpweek,
                                YEARWEEK   : yearpweek.length == 6 ? yearpweek : yearpweek.substring(0, 6),
                                QTY        : value == undefined ? 'NULL' : value,
                                MEAS       : paramMeasCd,
                                UPDATE_CNT : updateCnt
                            });
                            
                            if(updateCnt == excelUpdateCnt){
                                updateCnt = 0;
                            }
                        }
                    });
                    
                    salesPlanDatas.push(planData);
                    
                    if(planReasonData.BUCKET_LIST.length > 0){
                        salesReasonDatas.push(planReasonData)   
                    }
                }
            });
            
            FORM_SAVE              = {};
            FORM_SAVE._mtd         = "saveUpdate";
            FORM_SAVE.menuParam    = '${MEA_CD}';
            FORM_SAVE.planId       = $("#planId").val();
            FORM_SAVE.planStartDay = $("#planStartDay").val();
            FORM_SAVE.toCal        = $("#planEndDay").val();
            FORM_SAVE.planIdPast   = $("#planIdPast").val();
            FORM_SAVE.excelFlag    = excelFlagYn;
            FORM_SAVE.excelUpdateCnt = excelUpdateCnt;
            FORM_SAVE.apMeaCd = apMeaCd;
            FORM_SAVE.tranData     = [
                {outDs : "saveCnt1", _siq : "dp.planCommon.salesPlan", grdData : salesPlanDatas},
                {outDs : "saveCnt2", _siq : "dp.planCommon.salesPlanReason", grdData : salesReasonDatas},
                {outDs : "saveCnt3", _siq : "dp.planCommon.salesPlanRemark", grdData : jsonRows}
            ];
            
            gfn_service({
                url    : GV_CONTEXT_PATH + "/biz/obj",
                data   : FORM_SAVE,
                success: function(data) {
                    
                    if(apMeaCd == "CFM_SP"){
                        FORM_SAVE.tranData     = [
                            {outDs : "saveCnt1", _siq : "dp.planCommon.salesPlanProcedure", grdData : jsonRows},
                        ];
                        
                        gfn_service({
                            url    : GV_CONTEXT_PATH + "/biz/obj",
                            data   : FORM_SAVE,
                            success: function(data) {
                                alert('<spring:message code="msg.saveOk"/>');
                                fn_apply();     
                            }
                        }, "obj");
                    }else{
                        alert('<spring:message code="msg.saveOk"/>');
                        fn_apply(); 
                    }
                }
            }, "obj");
        });
    }
    
    /******************************************************************************************
    ** 확정, 확정취소
    ******************************************************************************************/
    function fn_confirm(confirm_yn) {
        
        var msg = "";
        
        if(dataProvider.getRowCount() == 0){
            alert('<spring:message code="msg.noDataFound"/>');
            return;
        }
        
        if(confirm_yn == "Y"){
            msg = '<spring:message code="msg.wantConfirm"/>';
        }else{
            msg = '<spring:message code="msg.cancelConfirm"/>';
        }
        
        confirm(msg, function() {
            
            var jsonRows = dataProvider.getJsonRows();
            var jsonRowsNew = [];
            
            for (var i = jsonRows.length-1; i >= 0; i--) {
                if (jsonRows[i].GRP_LVL_ID == "0" && jsonRows[i].MY_SELECT_ITEM == "Y") {
                    jsonRows[i].CONFIRM_YN = confirm_yn;
                    jsonRows[i].MENU_PARAM = meaCd;
                    jsonRowsNew.push(jsonRows[i]);
                }
            }
            
            FORM_SAVE          = {}; //초기화
            FORM_SAVE._mtd     = "saveUpdate";
            FORM_SAVE.tranData = [{outDs : "saveCnt", _siq : "dp.planCommon.salesPlanConfirm", grdData : jsonRowsNew}];
            
            gfn_service({
                url    : GV_CONTEXT_PATH + "/biz/obj",
                data   : FORM_SAVE,
                success: function(data) {
                    if(confirm_yn == "Y") {
                        alert('<spring:message code="msg.confirmed"/>');
                    } else {
                        alert('<spring:message code="msg.cancelConfirmed"/>');
                    }
                    
                    fn_apply();
                }
            }, "obj");
        });
    }
    
    /******************************************************************************************
    ** 그리드 초기화
    ******************************************************************************************/
    function fn_reset() {
        if ($("#realgrid").is(":visible")) {
            grdMain.cancel();
            dataProvider.rollback(dataProvider.getSavePoints()[0]);
            fn_gridCallback();
        } else {
            grdMainExcel.cancel();
            dataProviderExcel.rollback(dataProviderExcel.getSavePoints()[0]);
        }
    }
    
    /******************************************************************************************
    ** 버튼 세팅
    ******************************************************************************************/
    function fn_setBtnDisplay(flag) {
        
        var isMain = false;
        var isAuth = false;
        
        var pastFlag = fn_fillterChange(flag);
        
        
        if(pastFlag == "Y"){
            $("#btnCopyST,#btnCopyWW,#btnCopyValue,#btnExcelDown,#btnExcelUpload,#btnReset,#btnSave,#btnConfirmY,#btnConfirmN").hide();
            return;
        }
        
        
        if($("#realgrid").is(":visible")){
            isMain = true;
        }
        
        if($("#ap2_yn").val() == "Y"){
            isAuth = true;
        }
        
        if(isMain && isAuth){
            $("#btnCopyST,#btnCopyWW,#btnCopyValue").show();
            $("#btnConfirmY,#btnConfirmN").show();
        }else{
            $("#btnCopyST,#btnCopyWW,#btnCopyValue").hide();
            $("#btnConfirmY,#btnConfirmN").hide();
        }
        
        if((isMain && isAuth) || (!isMain && isAuth)){
            $("#btnExcelDown,#btnExcelUpload").show();
            $("#btnReset,#btnSave").show();
        }else{
            $("#btnExcelDown,#btnExcelUpload").hide();
            $("#btnReset,#btnSave").hide();
        }
        
        if($("#saveYn").val() != "Y"){
            $(".roleWrite").hide();
        }
        
        
    }
    
    /******************************************************************************************
    ** 그리드 계산 로직
    ******************************************************************************************/
    function fn_allInOneCalc(grid, itemIndex, dataRow, field, oldValue, newValue) {
        
        var filedName;
        
        dataProvider.beginUpdate();
        
        if ($.isArray(field)) {
            
            var tmpOldVal = 0;
            $.each(field, function(n, v) {
                
                filedName = dataProvider.getFieldName(v);
                
                if (filedName != "REMARK_NM") {
                    tmpOldVal = GRIDCALC.getChangeVal(dataProvider, dataRow, v, oldValue[n]);
                    GRIDCALC.autoCalc(gridInstance, itemIndex, dataRow, field[n], tmpOldVal, newValue[n]);
                } 
            }); 
        } else {
            
            filedName = dataProvider.getFieldName(field);
            
            if (filedName != "REMARK_NM") {
                GRIDCALC.autoCalc(gridInstance, itemIndex, dataRow, field, oldValue, newValue);
            } 
        }
        
        dataProvider.endUpdate();
    }
    
    /******************************************************************************************
    ** 필터 계획ID CHANGE EVENT
    ******************************************************************************************/
    function fn_fillterChange(flag){
        
        var pastFlag = $("#pastFlag").val();
        
        if(apMeaCd == "CFM_SP"){ //판매확정 계획화면
            if(pastFlag == "N"){
                if(flag != "Y"){
                    gfn_setMsComboAll([{ target : 'divSoDataCheck', id : 'soDataCheck', title : '<spring:message code="lbl.soDataCheck"/>', data : codeMap.SO_DATA_CHECK, exData : tExDatePast, type : "S" }]); 
                }
            }else if(pastFlag == "Y"){
                if(flag != "Y"){
                    gfn_setMsComboAll([{ target : 'divSoDataCheck', id : 'soDataCheck', title : '<spring:message code="lbl.soDataCheck"/>', data : codeMap.SO_DATA_CHECK, exData : tExDate, type : "S" }]); 
                }
            }
        }else{//AP1, AP2화면
            
            if(pastFlag == "N"){
                if(flag != "Y"){
                    gfn_setMsComboAll([{ target : 'divSoDataCheck', id : 'soDataCheck', title : '<spring:message code="lbl.soDataCheck"/>', data : codeMap.SO_DATA_CHECK, exData : tExDatePast, type : "S" }]); 
                }
            }else if(pastFlag == "Y"){
                if(flag != "Y"){
                    gfn_setMsComboAll([{ target : 'divSoDataCheck', id : 'soDataCheck', title : '<spring:message code="lbl.soDataCheck"/>', data : codeMap.SO_DATA_CHECK, exData : tExDate, type : "S" }]); 
                }
            }
        }
        return pastFlag;
    }
    
    /******************************************************************************************
    ** Dimension 중에 숫자 타입인 필드 number 타입으로 변경, number 타임 text로 변경 
    ******************************************************************************************/
    function fn_setNumberFields(provider) {
        
        var bucketAll0 = BUCKET.all[0].length;
        var monthArray = new Array();
        var monthContainArray = new Array();
        var fileds = provider.getFields();

        var filedsLen = fileds.length;
        var tDimWeek = $("#dimWeek").val().substring(4, 6);
        var tStartWeek = $("#planStartWeek").val().substring(4, 6);
        var tYEARMONTH = $("#planIdMonth").val();
        for (var i = 0; i < filedsLen; i++) {
            
            var fieldName = fileds[i].fieldName;
            
            //number 타입으로 변경
            if (fieldName == 'SS_QTY_NM' || fieldName == 'SO_QTY_NM' || fieldName == 'INV_QTY_NM' || fieldName == 'WIP_MFG_QTY_NM' || fieldName == 'WIP_MFG_QTY2_NM' ||
                fieldName == 'WIP_QC_QTY_NM' || fieldName == 'SALES_QTY_Y1_NM' || fieldName == 'YTD_QTY_NM' || fieldName == 'SALES_1M_WEEK_NM' ||
                fieldName == 'SALES_3M_WEEK_NM' || fieldName == 'SALES_12M_WEEK_NM' || fieldName == 'TOTAL_OPEN_SO_NM' || fieldName == 'SALES_PRICE_KRW_NM' ||
                fieldName == 'DIM_PROD_PLAN_QTY_NM' || fieldName == 'DIM_PROD_NO_REFLECTION_NM' || fieldName == 'DIM_CALC_EOH_QTY_NM' ||
                fieldName == 'DIM_AVAIL_QTY_NM' || fieldName == 'DIM_ALLOC_QTY_W_NM' || fieldName == 'DIM_PROD_PLAN_QTY_REMAINS_NM'
                    || fieldName == 'DIM_CALC_BOH_QTY_NM' || fieldName == 'DIM_AVAIL_QTY2_NM' || fieldName == 'DIM_PROD_PLAN_QTY2_NM'
                    || fieldName == 'DIM_CPFR_QTY_NM' || fieldName == 'DIM_CPFR_REMAIN_QTY_NM'
                    || fieldName == 'DIM_CFM_DMD1_SP_NM' || fieldName == 'DIM_CFM_DMD2_SP_NM'
                    || fieldName == 'DIM_CFM_DMD3_SP_NM' || fieldName == 'DIM_SALES_REMAIN_QTY_NM'
                    || fieldName == 'DIM_PROD_REMAIN_QTY_NM' || fieldName == 'DIM_PROD_1ST_QTY_NM'
                    || fieldName == 'DIM_PROD_2ND_QTY_NM' || fieldName == 'DIM_PROD_3RD_QTY_NM' || fieldName == 'PROD_ORDER_QTY3_NM' || fieldName == 'DIM_PROD_QTY_NM'||fieldName == 'SHPMT_PERFRMNCE_QTY_NM'
                    || fieldName  == 'CFM_SHPMT_QTY_M_NM' || fieldName  ==  'ADDITIONAL_INPUT_AVAIL_QTY_M_NM' || fieldName  == 'OVER_SHORT_M_NM' || fieldName  == "PROD_NO_REFLECTION_NM"
            ) {
                
                fileds[i].dataType = "number";
                
                if (fieldName == 'DIM_ALLOC_QTY_W_NM'){
                    grdMain.setColumnProperty(fieldName, "styles", {"numberFormat" : "#,##0.0"});
                }else{
                    grdMain.setColumnProperty(fieldName, "styles", {"numberFormat" : "#,##0"}); 
                }
                if(fieldName =='SHPMT_PERFRMNCE_QTY_NM'||fieldName  == 'CFM_SHPMT_QTY_M_NM'||fieldName  == 'OVER_SHORT_M_NM'||fieldName  == 'ADDITIONAL_INPUT_AVAIL_QTY_M_NM')
                {
                    var headerName = gfn_nvl(grdMain.getColumnProperty(fieldName, "header"), "")
                    
                    if(headerName != ""){
                        var tText = headerName.text;
                        
                        grdMain.setColumnProperty(fieldName, "header", tYEARMONTH +' '+ tText);
                    }
                }
                
                if(fieldName == 'DIM_PROD_PLAN_QTY_NM' || fieldName == 'DIM_PROD_NO_REFLECTION_NM' || fieldName == 'DIM_CALC_EOH_QTY_NM' || fieldName == 'DIM_AVAIL_QTY_NM' || fieldName == 'DIM_ALLOC_QTY_W_NM'
                   || fieldName == 'DIM_PROD_PLAN_QTY_REMAINS_NM' || fieldName == 'DIM_CALC_BOH_QTY_NM' || fieldName == 'DIM_AVAIL_QTY2_NM' || fieldName == 'DIM_PROD_PLAN_QTY2_NM'){
                    
                    var headerName = gfn_nvl(grdMain.getColumnProperty(fieldName, "header"), "")
                    /////apMeaCd
                    if(headerName != ""){
                        var tText = headerName.text;
                        
                        if(fieldName == 'DIM_PROD_PLAN_QTY_REMAINS_NM'){
                            grdMain.setColumnProperty(fieldName, "header", tStartWeek + ' <spring:message code="lbl.weekDim"/> ' + tText);  
                        }else{
                            grdMain.setColumnProperty(fieldName, "header", tDimWeek + ' <spring:message code="lbl.weekDim"/> ' + tText);    
                        }
                    }
                }
            }
           
            
            
            //text로 변경(조정사유)
            if(fieldName.indexOf("MT_") == -1 && fieldName.indexOf("_ADJ_REASON") != -1){
                fileds[i].dataType = "text";
                grdMain.setColumnProperty(fieldName, "styles", {textAlignment: "near"});
            }else if(fieldName.indexOf("MT_") != -1 && fieldName.indexOf("_ADJ_REASON") != -1){
                grdMain.setColumnProperty(fieldName, "visible", false);
            }
            
            if(meaCd == "AP2"){
                //너비 조정 할때 사용 수정해야함
                //최대기간으로 했을경우 마지막 month total이 너비가 조정이 안됨
                var columnHiddenCnt = 0;
                
                $.each(codeMap.WEEK_LIST, function(i, val){
                    
                    var paramYearPWeek = val.YEARPWEEK;
                    
                    if(fieldName.indexOf(paramYearPWeek) != -1 && fieldName.indexOf("MT_") == -1){
                        columnHiddenCnt++;
                    }
                });
                
                //1.MT_ 안의 갯수 ex) [6,2]
                //2.둘중 어디에 3주가 속해 있는지 여부 ex) [3,0]
                //3. 2번 - 1번 에 계산
                //4. ((3번 * (DMD1~3,SP)) + (2번 * MEASURE.LENGTH)) * 80 
                if(columnHiddenCnt == 0){
                    
                    if((fieldName.indexOf("PW") == 0 || fieldName.indexOf("MT_") == 0) && fieldName.indexOf("_REMARK_YN") == -1 && fieldName.indexOf("_HD") == -1 && fieldName.indexOf("_YN") == -1){
                        
                        if(fieldName.indexOf("W1") != -1 || fieldName.indexOf("_ADJ_QTY") != -1 || fieldName.indexOf("_ADJ_REASON") != -1){
                            grdMain.setColumnProperty(fieldName, "visible", false);
                        }else{
                            
                            var monthCnt = 0;
                            var monthContainCnt = 0;
                            
                            $.each(BUCKET.all[1], function(i, val){
                                
                                monthCnt++;
                                var paramCd = val.CD;
                                
                                $.each(codeMap.WEEK_LIST, function(i2, val2){
                                    
                                    var paramYearPWeek2 = val2.YEARPWEEK;
                                    
                                    if(paramCd.indexOf(paramYearPWeek2) != -1){
                                        monthContainCnt++;
                                    }
                                }); 
                                
                                if(paramCd.indexOf("MT_") == 0){
                                    
                                    if(monthContainArray.length != bucketAll0){
                                        var monthId = "M" + gfn_replaceAll(paramCd, "MT_", "");
                                        var tmp = {id : monthId, cnt : monthContainCnt};
                                        
                                        monthArray.push(monthCnt);
                                        monthContainArray.push(tmp);
                                        monthCnt = 0;
                                        monthContainCnt = 0;    
                                    }
                                }
                            });
                            
                            //2단 WIDTH
                            var widthLen = widthCnt * 80;
                                                    
                            if(fieldName.indexOf("MT_") == 0){
                                grdMain.setColumnProperty(fieldName.split("_")[0] + "_" + fieldName.split("_")[1], "width", widthLen);
                            }else{
                                grdMain.setColumnProperty(fieldName.split("_")[0], "width", widthLen);  
                            } 
                        }
                    }
                } 
            }
        }
        
        if(meaCd == "AP2"){
            
            //1단 WIDTH
            $.each(monthContainArray, function(n, v){
                var widthLen = (((monthArray[n] - v.cnt) * (excelUpdateCnt + 1)) + (v.cnt * MEASURE.user.length)) * 80;
                grdMain.setColumnProperty(v.id, "width", widthLen);
            });
        }
        
        provider.setFields(fileds);
    }
    
    /******************************************************************************************
    ** 복사
    ******************************************************************************************/
    function fn_copy(type) {
        
        if(dataProvider.getRowCount() == 0){
            alert('<spring:message code="msg.noDataFound"/>');
            return;
        }
            
        gfn_comPopupOpen("DP_COPY_" + type.toUpperCase(), {
            rootUrl : "dp",
            url     : "planCopyAp2Cfm",
            width   : 600,
            height  : 200,
            type    : type,
            menuCd  : "${menuInfo.menuCd}",
            measure : apMeaCd,
            fromWeek: FORM_SEARCH.fromPWeek,
            toWeek  : FORM_SEARCH.toPWeek,
        });
    } 
    
    /******************************************************************************************
    ** 복사 팝업 콜백
    ******************************************************************************************/
    function fn_popupApplyCallback(type, source, target, fromWeek, toWeek){
        if(type == "ST" || type == "WW"){
            fn_dataCopy(type, source, target, fromWeek, toWeek);
        }else if (type == "Value"){
            fn_copyValue(type, source, target, fromWeek, toWeek)
        } 
    }
    
    /******************************************************************************************
    ** 대상구간 데이터 일괄처리
    ******************************************************************************************/
    function fn_copyValue(type, source, target, fromWeek, toWeek) {
        
        var dataLen = dataProvider.getRowCount();
        var compare = gfn_replaceAll(apMeaCompare, "_SP", "");
        var targetIdx = gfn_getFindPositionInDs(MEASURE.user, "CD", target);
        
        if (targetIdx == -1) return; //없으면 처리안함
        
        var arrWeek = $.grep(BUCKET.all[1], function (v, n) {
            
            var bucketVal = v.BUCKET_VAL;
            
            return v.TOT_TYPE != "MT" && bucketVal >= fromWeek && bucketVal <= toWeek;
        });
        
        dataProvider.beginUpdate();
        
        for (var i = 0; i < dataLen; i++) {
            var grpLvlId = dataProvider.getValue(i, gv_grpLvlId);
            var confirmYn = dataProvider.getValue(i, "CONFIRM_YN");
            
            if(grpLvlId == 0 && confirmYn == "N"){
                
                $.each(arrWeek, function(n, v) {
                    
                    if(target == "AP2_SP" || target == "CFM_SP"){
                        
                        var tCd1 = v.CD + "_" + meaCd + "_DMD1_SP";
                        var tCd2 = v.CD + "_" + meaCd + "_DMD2_SP";
                        var tCd3 = v.CD + "_" + meaCd + "_DMD3_SP";
                        
                        var edit1 = tCd1 + "_YN";
                        var edit2 = tCd2 + "_YN";
                        var edit3 = tCd3 + "_YN";
                        
                        var editVal1 = dataProvider.getValue(i, edit1);
                        var editVal2 = dataProvider.getValue(i, edit2);
                        var editVal3 = dataProvider.getValue(i, edit3);
                        
                        if(editVal1 == "Y"){
                            dataProvider.setValue(i, tCd1, source);
                            fn_allInOneCalc(grdMain, i, i, dataProvider.getFieldIndex(tCd1));   
                        }
                        if(editVal2 == "Y"){
                            dataProvider.setValue(i, tCd2, source);
                            fn_allInOneCalc(grdMain, i, i, dataProvider.getFieldIndex(tCd2));   
                        }
                        if(editVal3 == "Y"){
                            dataProvider.setValue(i, tCd3, source);
                            fn_allInOneCalc(grdMain, i, i, dataProvider.getFieldIndex(tCd3));   
                        }
                        
                    }else{
                        var tCd = v.CD + "_" + target;
                        var edit = tCd + "_YN";
                        
                        var editVal = dataProvider.getValue(i, edit);
                        
                        if(editVal == "Y"){
                            dataProvider.setValue(i, tCd, source);
                            fn_allInOneCalc(grdMain, i, i, dataProvider.getFieldIndex(tCd));    
                        }   
                    }
                });
            }
        }
        
        dataProvider.endUpdate();
    }
    
    /******************************************************************************************
    ** 구간 복사
    ******************************************************************************************/
    function fn_dataCopy(type, source, target, fromWeek, toWeek) {
        
        var dataLen = dataProvider.getRowCount();
        var compare = gfn_replaceAll(apMeaCompare, "_SP", "");
        
        if(meaCd == "AP2"){
            compare = meaCd;
        }else if(meaCd == "CFM"){
            compare = gfn_replaceAll(apMeaCompare, "_SP", "");
        }
        
        var sourceIdx = gfn_getFindPositionInDs(MEASURE.user, "CD", source);
        var targetIdx = gfn_getFindPositionInDs(MEASURE.user, "CD", target);
        
        if (sourceIdx == -1 || targetIdx == -1) return; //없으면 처리안함
        
        var arrWeek = $.grep(BUCKET.all[1], function (v, n){    
            
            var bucketId = v.BUCKET_ID;
            var bucketVal = v.BUCKET_VAL;
            var typeMtFlag = bucketId.indexOf("MT_");
            
            if(type == "ST"){
                return typeMtFlag == -1 && bucketVal >= fromWeek && bucketVal <= toWeek;
            }else if (type == "WW"){
                return typeMtFlag == -1 && (bucketVal == fromWeek || bucketVal == toWeek);
            }else{
                return true;
            }
        });
        
        dataProvider.beginUpdate();
        
        if(type == "WW") {
            var sCdTmp = gfn_getFindValueInDs(arrWeek, "BUCKET_VAL", fromWeek, "CD");
            var tCdTmp = gfn_getFindValueInDs(arrWeek, "BUCKET_VAL", toWeek, "CD");
            
            for (var i = 0; i < dataLen; i++) {
                var grpLvlId = dataProvider.getValue(i, gv_grpLvlId);
                var confirmYn = dataProvider.getValue(i, "CONFIRM_YN");
                
                if(grpLvlId == 0 && confirmYn == "N"){
                    
                    if(target == "AP2_SP" || target == "CFM_SP"){
                        
                        var sCd1 = sCdTmp + "_" + compare + "_DMD1_SP";
                        var sCd2 = sCdTmp + "_" + compare + "_DMD2_SP";
                        var sCd3 = sCdTmp + "_" + compare + "_DMD3_SP";
                        
                        if(target == "AP2_SP"){
                            sCd1 = sCd1 + "_W1";
                            sCd2 = sCd2 + "_W1";
                            sCd3 = sCd3 + "_W1";
                        }
                        
                        var tCd1 = tCdTmp + "_" + meaCd + "_DMD1_SP";
                        var tCd2 = tCdTmp + "_" + meaCd + "_DMD2_SP";
                        var tCd3 = tCdTmp + "_" + meaCd + "_DMD3_SP";
                        
                        var edit1 = tCd1 + "_YN";
                        var edit2 = tCd2 + "_YN";
                        var edit3 = tCd3 + "_YN";
                        
                        var editVal1 = dataProvider.getValue(i, edit1);
                        var editVal2 = dataProvider.getValue(i, edit2);
                        var editVal3 = dataProvider.getValue(i, edit3);
                        
                        if(editVal1 == "Y"){
                            dataProvider.setValue(i, tCd1, dataProvider.getValue(i, sCd1));
                            fn_allInOneCalc(grdMain, i, i, dataProvider.getFieldIndex(tCd1));   
                        }
                        if(editVal2 == "Y"){
                            dataProvider.setValue(i, tCd2, dataProvider.getValue(i, sCd2));
                            fn_allInOneCalc(grdMain, i, i, dataProvider.getFieldIndex(tCd2));   
                        }
                        if(editVal3 == "Y"){
                            dataProvider.setValue(i, tCd3, dataProvider.getValue(i, sCd3));
                            fn_allInOneCalc(grdMain, i, i, dataProvider.getFieldIndex(tCd3));   
                        }
                        
                    }else{
                        
                        var sCd = sCdTmp + "_" + source;    
                        var tCd = tCdTmp + "_" + target;
                        var edit = tCd + "_YN";
                        
                        var editVal = dataProvider.getValue(i, edit);
                        
                        if(editVal == "Y"){
                            dataProvider.setValue(i, tCd, dataProvider.getValue(i, sCd));
                            fn_allInOneCalc(grdMain, i, i, dataProvider.getFieldIndex(tCd));    
                        }   
                    }
                }
            }
            
        }else if(type == "ST"){
            
            for (var i = 0; i < dataLen; i++) {
                
                var grpLvlId = dataProvider.getValue(i, gv_grpLvlId);
                var confirmYn = dataProvider.getValue(i, "CONFIRM_YN");
                
                if(grpLvlId == 0 && confirmYn == "N"){
                    
                    $.each(arrWeek, function(n, v) {
                        
                        var vCd = v.CD;
                        
                        if(target == "AP2_SP" || target == "CFM_SP"){
                            
                            var sCd1 = vCd + "_" + compare + "_DMD1_SP";
                            var sCd2 = vCd + "_" + compare + "_DMD2_SP";
                            var sCd3 = vCd + "_" + compare + "_DMD3_SP";
                            
                            if(target == "AP2_SP"){
                                sCd1 = sCd1 + "_W1";
                                sCd2 = sCd2 + "_W1";
                                sCd3 = sCd3 + "_W1";
                            }
                            
                            var tCd1 = vCd + "_" + meaCd + "_DMD1_SP";
                            var tCd2 = vCd + "_" + meaCd + "_DMD2_SP";
                            var tCd3 = vCd + "_" + meaCd + "_DMD3_SP";
                            
                            var edit1 = tCd1 + "_YN";
                            var edit2 = tCd2 + "_YN";
                            var edit3 = tCd3 + "_YN";
                            
                            var editVal1 = dataProvider.getValue(i, edit1);
                            var editVal2 = dataProvider.getValue(i, edit2);
                            var editVal3 = dataProvider.getValue(i, edit3);
                            
                            if(editVal1 == "Y"){
                                dataProvider.setValue(i, tCd1, dataProvider.getValue(i, sCd1));
                                fn_allInOneCalc(grdMain, i, i, dataProvider.getFieldIndex(tCd1));   
                            }
                            if(editVal2 == "Y"){
                                dataProvider.setValue(i, tCd2, dataProvider.getValue(i, sCd2));
                                fn_allInOneCalc(grdMain, i, i, dataProvider.getFieldIndex(tCd2));   
                            }
                            if(editVal3 == "Y"){
                                dataProvider.setValue(i, tCd3, dataProvider.getValue(i, sCd3));
                                fn_allInOneCalc(grdMain, i, i, dataProvider.getFieldIndex(tCd3));   
                            }
                            
                        }else{
                            
                            var sCd = vCd + "_" + source;   
                            var tCd = vCd + "_" + target;
                            var edit = tCd + "_YN";
                            
                            var editVal = dataProvider.getValue(i, edit);
                            
                            if(editVal == "Y"){
                                dataProvider.setValue(i, tCd, dataProvider.getValue(i, sCd));
                                fn_allInOneCalc(grdMain, i, i, dataProvider.getFieldIndex(tCd));    
                            }
                        }
                    });
                }
            }
        }
        
        dataProvider.endUpdate();
    } 
    
    function fn_getExcelData(){
        
        EXCEL_SEARCH_DATA = "";
        EXCEL_SEARCH_DATA += "Product" + " : ";
        EXCEL_SEARCH_DATA += $("#loc_product").html();
        EXCEL_SEARCH_DATA += "\nCustomer" + " : ";
        EXCEL_SEARCH_DATA += $("#loc_customer").html();
        
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
                }else if(id == "divRemark"){
                    EXCEL_SEARCH_DATA += $("#remark").val();
                }else if(id == "divDrawNo"){
                    EXCEL_SEARCH_DATA += $("#drawNo").val();
                }else if(id == "divDataCheck"){
                    EXCEL_SEARCH_DATA += $("#dataCheck option:selected").text();
                }else if(id == "divDataAddSales"){
                    EXCEL_SEARCH_DATA += $("#dataAddSales option:selected").text();
                }else if(id == "divSoDataCheck"){
                    EXCEL_SEARCH_DATA += $("#soDataCheck option:selected").text();
                }else if(id == "divPlanIdPast"){
                    EXCEL_SEARCH_DATA += $("#planIdPast option:selected").text();
                }
            }
        });
        
        EXCEL_SEARCH_DATA += "\n" + '<spring:message code="lbl.period"/>' + " : ";
        EXCEL_SEARCH_DATA += $("#fromCal").val() + "(" + $("#fromPWeek").val() + ") ~ ";
        EXCEL_SEARCH_DATA += $("#toCal").val() + "(" + $("#toPWeek").val() + ")";
    }
    
    /******************************************************************************************
    ** 1. 처음로딩시 132일인지 372일인지 판단 작업
    ******************************************************************************************/
    function fn_measureEvent(){
        var params = $("#commonForm").serializeObject();
        params._mtd   = "getList";
        params.tranData = [{outDs:"meaList",_siq:"common.measure"}];
        gfn_service({
            async: false,
            url: GV_CONTEXT_PATH + "/biz/obj",
            data:params,
            success:function(data) {
                fn_popCallback(data.meaList);               
            }
        },"obj");
    }
    
    /******************************************************************************************
    ** 1.처음 로딩시 132일인지, 372일인지 판단
    ** 2.Measure 선택 후 132일인지, 372일인지 판단
    ******************************************************************************************/
    function fn_popCallback(grdData, callFlag){
        
        callFlag = gfn_nvl(callFlag, "");
        
        //weekCnt = 0 이면 372일, 0이 아니면 132일
        var weekCnt = 0;
        
        $.each(grdData, function(i, val){
            
            var measCdVal = gfn_nvl(val.MEAS_CD, val.CD);
            var userUseFlagVal = gfn_nvl(val.USER_USE_FLAG, "Y");
            
            if(meaCd == "AP2"){
                if(measCdVal != "AP2_DMD1_SP" && measCdVal != "AP2_DMD2_SP" && measCdVal != "AP2_DMD3_SP" && measCdVal != "AP2_SP"){
                    if(userUseFlagVal == "Y"){
                        weekCnt++;
                        return false;
                    }
                }
            }else if(meaCd == "CFM"){
                if(measCdVal != "CFM_DMD1_SP" && measCdVal != "CFM_DMD2_SP" && measCdVal != "CFM_DMD3_SP" && measCdVal != "CFM_SP"){
                    if(userUseFlagVal == "Y"){
                        weekCnt++;
                        return false;
                    }
                }
            }
        });
        
        if(weekCnt == 0){
            weekFlag = true;
        }else{
            weekFlag = false;
        }
        
        if(callFlag == "call"){
            fn_fromToChangeEvent("fromCal", "call");    
        }else{
            fn_fromToChangeEvent("fromCal");
        }
    }
    
    /******************************************************************************************
    ** 1.처음 로딩시 132일인지, 372일인지 판단
    ** 2.Measure 선택 후 132일인지, 372일인지 판단
    ** 3. AP2일경우 372일, CFM일경우 140일
    ******************************************************************************************/
    function fn_fromToChangeEvent(dateFlag, callFlag){
        
        callFlag = gfn_nvl(callFlag, "");       
        
        if(weekFlag){
            if(meaCd == "CFM"){
                periodNumPlus = 140;
                periodNumMinus = -140;
            }else if(meaCd == "AP2"){
                periodNumPlus = 372;
                periodNumMinus = -372;  
            }
        }else{
            periodNumPlus = 132;
            periodNumMinus = -132;
        }
        
        if(dateFlag == "fromCal"){
            $("#fromCal").trigger("change");
        }else if(dateFlag == "toCal"){
            $("#toCal").trigger("change");
        }
        
        if(callFlag == "call"){
            fn_apply();
        }
    }
    
    /******************************************************************************************
    ** 날짜 구간 변동(132일, 372일)
    ******************************************************************************************/
    function setDayDate(calId, val){
        
        var calIdData = $("#" + calId).val();
        var paramVal = gfn_replaceAll(calIdData, "-", "");
        var dateVal = paramVal.substring(0, 4) + "/" + paramVal.substring(4, 6) + "/" + paramVal.substring(6, 8);
        
        var date = new Date(dateVal);
        
        date.setDate(date.getDate() + Number(val));
        
        var year = date.getFullYear();
        var month = date.getMonth() + 1;
        var day = date.getDate();
        
        if(month < 10){
            month = "0" + month;
        }
        
        if(day < 10){
            day = "0" + day;
        }
        
        var resultData = year + "-" + month + "-" + day;
        
        if(calId == "fromCal"){
            $("#fromCal").datepicker("option", "minDate", calIdData);
            $("#toCal").datepicker("option", "maxDate", resultData);
            
            //처음로딩시나, Measure 선택후 올경우 toWeek이 변경이 되지 않아 로직 추가
            if($("#swToDate").val() >= resultData.split("-").join("") && !weekFlag){
                var tmpV = gfn_getFindDataDsInDs(datePickerOption.arrTarget, {calId : {VALUE : "toCal", CONDI : "="}});
                gfn_onSelectFn(tmpV[0], resultData);
            }
        }else if(calId == "toCal"){
            $("#fromCal").datepicker("option", "minDate", resultData);
            $("#toCal").datepicker("option", "maxDate", calIdData);
        }
    }
    
  
    
</script>
</head>
<body id="framesb">
    <%@ include file="/WEB-INF/view/layout/commonForm.jsp"%>
    <!-- left -->
    <div id="a" class="split split-horizontal">
        <!-- tree -->
        <div id="c" class="split content">
            <%@ include file="/WEB-INF/view/common/leftTree.jsp"%>
        </div>
        <!-- filter -->
        <div id="d" class="split content">
            <form id="searchForm" name="searchForm">
                <%-- Plan ID 정보 --%>
                <input type="hidden" id="planStartPW" name="planStartPW" />
                <input type="hidden" id="planEndPW" name="planEndPW" />
                <input type="hidden" id="planStartDay" name="planStartDay" />
                <input type="hidden" id="planEndDay" name="planEndDay" />
                <input type="hidden" id="planId" name="planId" />
                <input type="hidden" id="ap1_yn" name="ap1_yn" />
                <input type="hidden" id="ap2_yn" name="ap2_yn" />
                <input type="hidden" id="goc_yn" name="goc_yn" />
                <input type="hidden" id="menuParam2" name="menuParam2" value="${MEA_CD}" />
                <input type="hidden" id="fromMon" name="fromMon" />
                <input type="hidden" id="toMon" name="toMon" />
                <input type="hidden" id="pastPlanIdStartWeek" name="pastPlanIdStartWeek" />
                <input type="hidden" id="pastPlanIdEndWeek" name="pastPlanIdEndWeek" />
                <input type="hidden" id="futurePlanIdStartWeek" name="futurePlanIdStartWeek" />
                <input type="hidden" id="futurePlanIdEndWeek" name="futurePlanIdEndWeek" />
                <input type="hidden" id="dimWeek" name="dimWeek" />
                <input type="hidden" id="dimWeek1" name="dimWeek1" />
                <input type="hidden" id="dimWeekMonday" name="dimWeekMonday" />
                <input type="hidden" id="partADimWeek" name="partADimWeek" />
                <input type="hidden" id="partBDimWeek" name="partBDimWeek" />
                <input type="hidden" id="planStartWeek" name="planStartWeek" />
                <input type="hidden" id="planEndWeek" name="planEndWeek" />
                <input type="hidden" id="beforePlanId" name="beforePlanId" />
                <input type="hidden" id="qtyDate" name="qtyDate" />
                <input type="hidden" id="startRemains" name="startRemains" />
                <input type="hidden" id="endRemains" name="endRemains" />
                <input type="hidden" id="currentWeekPop" name="currentWeekPop" />
                <input type="hidden" id="planIdOnePlusWeekPop" name="planIdOnePlusWeekPop" />
                <input type="hidden" id="planStartWeekPop" name="planStartWeekPop" />
                <input type="hidden" id="currentMonthPop" name="currentMonthPop" />
                <input type="hidden" id="currentMonthNextPop" name="currentMonthNextPop" />
                <input type="hidden" id="currentDay" name="currentDay" />
                <input type="hidden" id="planIdPastW1" name="planIdPastW1" />
                <input type="hidden" id="pastFlag" name="pastFlag" />
                <input type="hidden" id="planIdMonth" name="planIdMonth" />
                <div id="filterDv">
                    <div class="inner">
                        <h3>Filter</h3>
                        <%@ include file="/WEB-INF/view/common/filterMonthSum.jsp"%>
                        <div class="tabMargin"></div>
                        <div class="scroll">
                            <div class="view_combo" id="divItem"></div>
                            <div class="view_combo" id="divRemark">
                                <div class="ilist">
                                    <div class="itit"><spring:message code="lbl.remark"/></div>
                                    <input type="text" id="remark" name="remark" class="ipt"/>
                                </div>
                            </div>
                            <div class="view_combo" id="divDrawNo">
                                <div class="ilist">
                                    <div class="itit"><spring:message code="lbl.drawNo"/></div>
                                    <input type="text" id="drawNo" name="drawNo" class="ipt"/>
                                </div>
                            </div>
                            <div class="view_combo" id="divDataCheck"></div>
                            <div class="view_combo" id="divDataAddSales"></div>
                            <div class="view_combo" id="divSoDataCheck"></div>
                            <div class="view_combo" id="divPlanIdPast"></div>
                            <c:if test="${MEA_CD  == 'AP2'}">
                            <div class="view_combo" id="divOverShortMQtyCheckNeedYn" style="padding-bottom:10px;"></div>
                            </c:if>
                            <jsp:include page="/WEB-INF/view/common/filterViewHorizon.jsp" flush="false">
                                <jsp:param name="radioYn" value="N" />
                                <jsp:param name="wType" value="SW" />
                            </jsp:include>
                        </div>
                        <div class="bt_btn">
                            <a href="javascript:;" class="fl_app"><spring:message code="lbl.search" /></a>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>
    <!-- contents -->
    <div id="b" class="split split-horizontal">
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
                        <input type="hidden" id="headerLine" name="headerLine" value="3" />
                        <input type="hidden" id="columnNames" name="columnNames" />
                    </form>
                    <a style="display:none" href="javascript:;" id="btnCopyST" class="app1 roleWrite"><spring:message code="lbl.copyST" /></a>
                    <a style="display:none" href="javascript:;" id="btnCopyWW" class="app1 roleWrite"><spring:message code="lbl.copyWW" /></a>
                    <a style="display:none" href="javascript:;" id="btnCopyValue" class="app1 roleWrite"><spring:message code="lbl.copyValue" /></a>
                    <a style="display:none" href="javascript:;" id="btnExcelDown" class="app1 roleWrite"><spring:message code="lbl.excelDownload" /></a>
                    <a style="display:none" href="javascript:;" id="btnExcelUpload" class="app1 roleWrite"><spring:message code="lbl.excelUpload" /></a>
                    <a style="display:none" href="javascript:;" id="btnConfirmY" class="app1 roleWrite"><spring:message code="lbl.confirm" /></a>
                    <a style="display:none" href="javascript:;" id="btnConfirmN" class="app1 roleWrite"><spring:message code="lbl.confirmCancel" /></a>
                </div>
                <div class="bright">
                    <%-- <c:if test="${MEA_CD == 'CFM'}">
                    <a href="javascript:;" id="btnSummary2" class="app1"><spring:message code="lbl.summary" /></a> 
                    </c:if> --%>
                    <a href="javascript:;" id="btnSummary" class="app1"><spring:message code="lbl.allocPlanCapa" /></a>
                    <a style="display:none" href="javascript:;" id="btnReset" class="app1"><spring:message code="lbl.reset" /></a>
                    <a style="display:none" href="javascript:;" id="btnSave" class="app2 roleWrite"><spring:message code="lbl.save" /></a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
