<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
    <script type="text/javascript">
    //전역변수 설정
    //var planInterval = null;
    var planIntervalTel = null;
    var planIntervalLam = null;
    var planIntervalDiff = null;
    var planIntervalMat = null;
    
    var planIntervalTelData = null;
    var planIntervalLamData = null;
    var planIntervalDiffData = null;
    var planIntervalMatData = null;
    
    var areaVersionTypeCd = "";
    var versionFlag = false;
    var planConfirmFlag = false;
    var planConfirmCancelFlag = false;
    var planOtionFlag = false;
    var precedeLimitFlag = false;
    var executeAFlag = false;
    
    var priorityOptionFlag = false;
    var woReleaseWeekFlag = false;
    
    var gridInstance, grdMain, dataProvider;
    var gridInstance2, grdMain2, dataProvider2;
    
    var GlobalIndex = null;
    
    $(function() {
        //공통 폼 초기 정보 설정
        gfn_formLoad();
        fn_initCode(); //공통코드 조회
        fn_initGrid(); //그리드를 그린다.
        fn_initEvent(); //이벤트 정의
    });
    
    //공통코드 조회
    function fn_initCode() {
        
        var weeklyDaily = $('input[name="weeklyDaily"]:checked').val();
        var grpCd = "PROD_PART,CB_BAL_WEEK,CB_PRIORITY_OPTION,CB_WO_RELEASE_WEEK";
        codeMap = gfn_getComCode(grpCd, "Y"); //공통코드 조회
        codeMap.PROD_PART[0].CODE_NM = "";
        codeMap.CB_BAL_WEEK[0].CODE_NM = "";
        codeMap.CB_PRIORITY_OPTION[0].CODE_NM = "";
        codeMap.CB_WO_RELEASE_WEEK[0].CODE_NM = "";
        
        var temp = "";
        
        $.each(codeMap.CB_BAL_WEEK, function(i, val){
            
            var codeCd = val.CODE_CD;
            var codeNm = val.CODE_NM;
            
            temp += "<option value=\""+ codeCd +"\">" + codeNm + "</option>";
        });
        $("#precedeLimit").html(temp);
        
        temp = "";
        
        $.each(codeMap.CB_PRIORITY_OPTION, function(i, val){
            
            var codeCd = val.CODE_CD;
            var codeNm = val.CODE_NM;
            
            temp += "<option value=\""+ codeCd +"\">" + codeNm + "</option>";
        });
        $("#priorityOption").html(temp);
        
        temp = "";
        
        $.each(codeMap.CB_WO_RELEASE_WEEK, function(i, val){
            
            var codeCd = val.CODE_CD;
            var codeNm = val.CODE_NM;
            
            temp += "<option value=\""+ codeCd +"\">" + codeNm + "</option>";
        });
        $("#woReleaseWeek").html(temp);
        
        gfn_service({
            async   : false,
            url     : GV_CONTEXT_PATH + "/biz/obj.do",
            data    : {_mtd : "getList", weekly_daily : weeklyDaily,  
                tranData : [
                    {outDs : "planList", _siq : "aps.planExecute.planIdControl"},
            ]},
            success : function(data) {
                
                codeMap.PLAN_ID = data.planList;
                $("#textPlanId").html(codeMap.PLAN_ID[0].CODE_NM);
            }
        }, "obj");
        
        var msMap = [
            { target : 'divPlanId', id : 'planId', title : '<spring:message code="lbl.planId2"/>', data : codeMap.PLAN_ID, exData:[''], type : "S" },  
            { target : 'divProdPart', id : 'prodPart', title : '<spring:message code="lbl.prodPart"/>', data : codeMap.PROD_PART, exData:["*"], type : "S"},
            { target : 'divPlanVersion', id : 'planVersion', title : '<spring:message code="lbl.planVersion2"/>', data : "", exData:["*"], type : "S"}
        ];
        
        gfn_setMsComboAll(msMap);
        
        dateParam = {
            arrTarget : [
                {calId : "searchCal", weekId : "searchWeek", defVal : 0}
            ]
        };
        DATEPICKET(dateParam);
    }
    
    //이벤트 정의
    function fn_initEvent() {
        
        //계획 Version
        $("#planVersion").change(function() {
            fn_authorityReset();
        });
        
        //주간,월간
        $("#weeklyDaily1,#weeklyDaily2").change(function() {
            
            var weeklyDaily = $('input[name="weeklyDaily"]:checked').val();
            
            gfn_service({
                async   : false,
                url     : GV_CONTEXT_PATH + "/biz/obj.do",
                data    : {_mtd : "getList", weekly_daily : weeklyDaily,  
                    tranData : [
                        {outDs : "planList", _siq : "aps.planExecute.planIdControl"}
                      , {outDs : "defaultList", _siq : "common.planIdFp"}
                ]},
                success : function(data) {
                    gfn_setMsCombo("planId", data.planList, [""]);
                    
                    if(data.planList.length == 0){
                        $("#textStart").html("");
                        $("#textEnd").html("");
                    }else{
                        $("#textPlanId").html(data.planList[0].CODE_NM);    
                    }
                    
                    if(weeklyDaily == "FP"){
                        var defaultPlanId = data.defaultList[0].PLAN_ID;
                        $("#planId").val(defaultPlanId);
                    }
                }
            }, "obj");
        });
        
        $("#prodPart,#planId,#weeklyDaily1,#weeklyDaily2").change(function() {
            fn_planVersionChg();
        });
        
        //생상파트
        $("#prodPart").change(function() {
            
            var prodPart = gfn_nvl($("#prodPart").val(), "");
            
            if(prodPart != ""){
                gfn_service({
                    async   : false,
                    url     : GV_CONTEXT_PATH + "/biz/obj.do",
                    data    : {_mtd : "getList", prodPart : prodPart, tranData:[
                        {outDs : "planOption", _siq : "aps.planExecute.planOption"},
                    ]},
                    success : function(data) {
                        
                        var temp = "<option value=\"\"></option>";
                        
                        $.each(data.planOption, function(i, val){
                            
                            var codeCd = val.CODE_CD;
                            var codeNm = val.CODE_NM;
                            
                            temp += "<option value=\""+ codeCd +"\">" + codeNm + "</option>";
                            
                        });
                        $("#planOption").html(temp);
                    }
                }, "obj");
            }
        });
        
        $(".fl_app").click("on", function() { fn_apply(); });
        
        $("#btnConfirm").click("on", function() { 
            //fn_confirm();
            fn_planVersionChg_customized_for_Confirm();            
        });
        
        $("#btnConfirmCancel").click("on", function() { 
            //fn_confirmCancel();
            fn_planVersionChg_customized_for_ConfirmCancel();            
        });
        
        $("#btnVersion").click("on", function() { 
            fn_versionProd(); 
        });
        
        $("#savePriorityOption").click("on", function() { 
            fn_priorityOption(); 
        });
        
        $("#savePlanOption").click("on", function() { 
            fn_planOption(); 
        });
        
        $("#savePrecedeLimit").click("on", function() { 
            fn_precedeLimit(); 
        });
        
        $("#saveWoReleaseWeek").click("on", function() { 
            fn_woReleaseWeek(); 
        });
        
        $("#btnSave").click("on", function() { 
            fn_save(); 
        });
        
        $("#divPlanVersion .itit").click("on", function() { 
            fn_planVersionChg();
        });
        
        $("#divPlanVersion .itit").css("cursor", "pointer");
        
        gfn_setMonthSum(gridInstance, true, true, true); //month sum omit0 처리
    }
    
    //그리드를 초기화
    function fn_initGrid() {
        
        gridInstance = new GRID();
        gridInstance.init("realgrid");
        grdMain = gridInstance.objGrid;
        dataProvider = gridInstance.objData;
        
        gridInstance2 = new GRID();
        gridInstance2.init("realgrid2");
        grdMain2 = gridInstance2.objGrid;
        dataProvider2 = gridInstance2.objData;
        
        fn_setFields(dataProvider2);
        fn_setColumns(grdMain2);
        
        grdMain.setOptions({
            sorting : { enabled      : false },
            display : { columnMovable: false }
        });
        
        grdMain2.setOptions({
            sorting : { enabled      : false },
            display : { columnMovable: false }
        });
        
        //계획 실행
        grdMain.onDataCellDblClicked = function (grid, index) {
        	
        	GlobalIndex = index;
        	
        	fn_planVersionChg_customized();
        	
        	
        };
    }
    
    //완료후 팝업 
    function planExcuteInterval(formData){
        
        FORM_SEARCH = {};
        FORM_SEARCH.company_cd = formData.company;
        FORM_SEARCH.bu_cd = formData.buCd;
        FORM_SEARCH.plan_id = formData.planId;
        FORM_SEARCH.prod_part = formData.prodPart;
        FORM_SEARCH.version_id = formData.versionId;
        FORM_SEARCH.row_id = formData.rowId;
        FORM_SEARCH._mtd = "getList";
        FORM_SEARCH.tranData = [
            {outDs : "gridList", _siq : "aps.planExecute.controlBoardAInterval"},
        ];
        
        var sMap = {
            url: "${ctx}/biz/obj.do",
            data: FORM_SEARCH,
            success:function(data) {
                
                var successFlag = data.gridList[0].CB_STATUS_CD;
                var selProdPart = data.gridList[0].PROD_PART;
                
                if(successFlag == "C" || successFlag == "E"){
                    
                    if(selProdPart == "TEL"){
                        clearInterval(planIntervalTel);
                    }else if(selProdPart == "LAM"){
                        clearInterval(planIntervalLam);
                    }else if(selProdPart == "DIFFUSION"){
                        clearInterval(planIntervalDiff);
                    }else if(selProdPart == "MATERIAL"){
                        clearInterval(planIntervalMat);
                    }
                    
                    gfn_comPopupOpen("CONTROL_POP", {
                        rootUrl : "aps/planExecute",
                        url     : "controlBoardAlert",
                        width   : 800,
                        height  : 400,
                        company_cd : formData.company,
                        bu_cd : formData.buCd,
                        plan_id : formData.planId,
                        prod_part : formData.prodPart,
                        version_id : formData.versionId,
                        row_id : formData.rowId,
                        popupTitle : formData.prodPart + ' <spring:message code="lbl.controlPop"/>'
                    }); 
                    
                    fn_apply();
                }
            }
        }
        gfn_service(sMap, "obj");
    }
   
    //조회
    function fn_apply(sqlFlag) {
        
        var tmpProd = gfn_nvl($("#prodPart").val(), "");
        var tmpPlanVersion = gfn_nvl($("#planVersion").val(), "");
        
        if(tmpProd == ""){
            alert('<spring:message code="msg.prodPartMsg"/>');
            return;
        } 
        
        if(tmpPlanVersion == ""){
            alert('<spring:message code="msg.planVersionMsg"/>');
            return;
        } 
        
        DIMENSION.hidden = [];
        DIMENSION.hidden.push({CD : "COMPANY_CD", dataType : "text"});
        DIMENSION.hidden.push({CD : "BU_CD", dataType : "text"});
        DIMENSION.hidden.push({CD : "PLAN_ID", dataType : "text"});
        DIMENSION.hidden.push({CD : "PROD_PART", dataType : "text"});
        DIMENSION.hidden.push({CD : "VERSION_ID", dataType : "text"});
        DIMENSION.hidden.push({CD : "EXEC_YN_NM_HD", dataType : "text"});
        
        gfn_getMenuInit(); 
        fn_drawGrid(sqlFlag); 
        
        FORM_SEARCH = $("#searchForm").serializeObject();
        FORM_SEARCH.sql = sqlFlag;
        FORM_SEARCH.dimList = DIMENSION.user;
        
        var fileds = dataProvider.getFields();
        
        for (var i = 0; i < fileds.length; i++) {
                
            if (fileds[i].fieldName == 'START_DTTM_NM' || fileds[i].fieldName == 'END_DTTM_NM') {
                
                fileds[i].dataType = "datetime";
                fileds[i].datetimeFormat = "yyyy-MM-dd HH:mm:ss";
                
                grdMain.setColumnProperty(fileds[i].fieldName, "styles", {"datetimeFormat" : "yyyy-MM-dd HH:mm:ss"});
            }
            
            dataProvider.setFields(fileds);
        }
        
        //4. 메인 데이터를 조회
        fn_getGridData();
        fn_getExcelData();
    }
    
    function fn_apply_customized(sqlFlag) {
        
        var tmpProd = gfn_nvl($("#prodPart").val(), "");
        var tmpPlanVersion = gfn_nvl($("#planVersion").val(), "");
        
        if(tmpProd == ""){
            alert('<spring:message code="msg.prodPartMsg"/>');
            return;
        } 
        
        if(tmpPlanVersion == ""){
            alert('<spring:message code="msg.planVersionMsg"/>');
            return;
        } 
        
        DIMENSION.hidden = [];
        DIMENSION.hidden.push({CD : "COMPANY_CD", dataType : "text"});
        DIMENSION.hidden.push({CD : "BU_CD", dataType : "text"});
        DIMENSION.hidden.push({CD : "PLAN_ID", dataType : "text"});
        DIMENSION.hidden.push({CD : "PROD_PART", dataType : "text"});
        DIMENSION.hidden.push({CD : "VERSION_ID", dataType : "text"});
        DIMENSION.hidden.push({CD : "EXEC_YN_NM_HD", dataType : "text"});
        
        gfn_getMenuInit(); 
        fn_drawGrid(sqlFlag); 
        
        FORM_SEARCH = $("#searchForm").serializeObject();
        FORM_SEARCH.sql = sqlFlag;
        FORM_SEARCH.dimList = DIMENSION.user;
        
        var fileds = dataProvider.getFields();
        
        for (var i = 0; i < fileds.length; i++) {
                
            if (fileds[i].fieldName == 'START_DTTM_NM' || fileds[i].fieldName == 'END_DTTM_NM') {
                
                fileds[i].dataType = "datetime";
                fileds[i].datetimeFormat = "yyyy-MM-dd HH:mm:ss";
                
                grdMain.setColumnProperty(fileds[i].fieldName, "styles", {"datetimeFormat" : "yyyy-MM-dd HH:mm:ss"});
            }
            
            dataProvider.setFields(fileds);
        }
        
        //4. 메인 데이터를 조회
        fn_getGridData_customized();
        fn_getExcelData();
    }
    
    
function fn_apply_customized_for_Confirm(sqlFlag) {
        
        var tmpProd = gfn_nvl($("#prodPart").val(), "");
        var tmpPlanVersion = gfn_nvl($("#planVersion").val(), "");
        
        if(tmpProd == ""){
            alert('<spring:message code="msg.prodPartMsg"/>');
            return;
        } 
        
        if(tmpPlanVersion == ""){
            alert('<spring:message code="msg.planVersionMsg"/>');
            return;
        } 
        
        DIMENSION.hidden = [];
        DIMENSION.hidden.push({CD : "COMPANY_CD", dataType : "text"});
        DIMENSION.hidden.push({CD : "BU_CD", dataType : "text"});
        DIMENSION.hidden.push({CD : "PLAN_ID", dataType : "text"});
        DIMENSION.hidden.push({CD : "PROD_PART", dataType : "text"});
        DIMENSION.hidden.push({CD : "VERSION_ID", dataType : "text"});
        DIMENSION.hidden.push({CD : "EXEC_YN_NM_HD", dataType : "text"});
        
        gfn_getMenuInit(); 
        fn_drawGrid(sqlFlag); 
        
        FORM_SEARCH = $("#searchForm").serializeObject();
        FORM_SEARCH.sql = sqlFlag;
        FORM_SEARCH.dimList = DIMENSION.user;
        
        var fileds = dataProvider.getFields();
        
        for (var i = 0; i < fileds.length; i++) {
                
            if (fileds[i].fieldName == 'START_DTTM_NM' || fileds[i].fieldName == 'END_DTTM_NM') {
                
                fileds[i].dataType = "datetime";
                fileds[i].datetimeFormat = "yyyy-MM-dd HH:mm:ss";
                
                grdMain.setColumnProperty(fileds[i].fieldName, "styles", {"datetimeFormat" : "yyyy-MM-dd HH:mm:ss"});
            }
            
            dataProvider.setFields(fileds);
        }
        
        //4. 메인 데이터를 조회
        fn_getGridData_customized_for_Confirm();
        fn_getExcelData();
    }
    
    

function fn_apply_customized_for_ConfirmCancel(sqlFlag) {
        
        var tmpProd = gfn_nvl($("#prodPart").val(), "");
        var tmpPlanVersion = gfn_nvl($("#planVersion").val(), "");
        
        if(tmpProd == ""){
            alert('<spring:message code="msg.prodPartMsg"/>');
            return;
        } 
        
        if(tmpPlanVersion == ""){
            alert('<spring:message code="msg.planVersionMsg"/>');
            return;
        } 
        
        DIMENSION.hidden = [];
        DIMENSION.hidden.push({CD : "COMPANY_CD", dataType : "text"});
        DIMENSION.hidden.push({CD : "BU_CD", dataType : "text"});
        DIMENSION.hidden.push({CD : "PLAN_ID", dataType : "text"});
        DIMENSION.hidden.push({CD : "PROD_PART", dataType : "text"});
        DIMENSION.hidden.push({CD : "VERSION_ID", dataType : "text"});
        DIMENSION.hidden.push({CD : "EXEC_YN_NM_HD", dataType : "text"});
        
        gfn_getMenuInit(); 
        fn_drawGrid(sqlFlag); 
        
        FORM_SEARCH = $("#searchForm").serializeObject();
        FORM_SEARCH.sql = sqlFlag;
        FORM_SEARCH.dimList = DIMENSION.user;
        
        var fileds = dataProvider.getFields();
        
        for (var i = 0; i < fileds.length; i++) {
                
            if (fileds[i].fieldName == 'START_DTTM_NM' || fileds[i].fieldName == 'END_DTTM_NM') {
                
                fileds[i].dataType = "datetime";
                fileds[i].datetimeFormat = "yyyy-MM-dd HH:mm:ss";
                
                grdMain.setColumnProperty(fileds[i].fieldName, "styles", {"datetimeFormat" : "yyyy-MM-dd HH:mm:ss"});
            }
            
            dataProvider.setFields(fileds);
        }
        
        //4. 메인 데이터를 조회
        fn_getGridData_customized_for_ConfirmCancel();
        fn_getExcelData();
    }
    
    
    
    //그리드 데이터 조회
    function fn_getGridData(sqlFlag) {
        
        FORM_SEARCH._mtd = "getList";
        FORM_SEARCH.tranData = [
            {outDs : "gridListA", _siq : "aps.planExecute.controlBoardA"},
            {outDs : "gridListB", _siq : "aps.planExecute.controlBoardB"}
        ];
        
        fn_authorityReset();
        
        var sMap = {
            url: "${ctx}/biz/obj.do",
            data: FORM_SEARCH,
            success:function(data) {
                
                var grdDataA = data.gridListA;
                var grdDataB = data.gridListB;
                dataProvider.setRows(grdDataA);
                dataProvider2.setRows(grdDataB);
                
                gfn_setSearchRow(dataProvider.getRowCount() + " / " + dataProvider2.getRowCount());
                
                fn_gridCallback(grdDataA);
            }
        }
        gfn_service(sMap, "obj");
    }
    
    
    function fn_getGridData_customized_for_Confirm(sqlFlag) {
        
        FORM_SEARCH._mtd = "getList";
        FORM_SEARCH.tranData = [
            {outDs : "gridListA", _siq : "aps.planExecute.controlBoardA"},
            {outDs : "gridListB", _siq : "aps.planExecute.controlBoardB"}
        ];
        
        fn_authorityReset();
        
        var sMap = {
            url: "${ctx}/biz/obj.do",
            data: FORM_SEARCH,
            success:function(data) {
                
                var grdDataA = data.gridListA;
                var grdDataB = data.gridListB;
                dataProvider.setRows(grdDataA);
                dataProvider2.setRows(grdDataB);
                
                gfn_setSearchRow(dataProvider.getRowCount() + " / " + dataProvider2.getRowCount());
                
                fn_gridCallback_customized_for_Confirm(grdDataA);
            }
        }
        gfn_service(sMap, "obj");
    }
    
    function fn_getGridData_customized_for_ConfirmCancel(sqlFlag) {
        
        FORM_SEARCH._mtd = "getList";
        FORM_SEARCH.tranData = [
            {outDs : "gridListA", _siq : "aps.planExecute.controlBoardA"},
            {outDs : "gridListB", _siq : "aps.planExecute.controlBoardB"}
        ];
        
        fn_authorityReset();
        
        var sMap = {
            url: "${ctx}/biz/obj.do",
            data: FORM_SEARCH,
            success:function(data) {
                
                var grdDataA = data.gridListA;
                var grdDataB = data.gridListB;
                dataProvider.setRows(grdDataA);
                dataProvider2.setRows(grdDataB);
                
                gfn_setSearchRow(dataProvider.getRowCount() + " / " + dataProvider2.getRowCount());
                
                fn_gridCallback_customized_for_ConfirmCancel(grdDataA);
            }
        }
        gfn_service(sMap, "obj");
    }
    
    
    
    
    
function fn_getGridData_customized(sqlFlag) {
        
        FORM_SEARCH._mtd = "getList";
        FORM_SEARCH.tranData = [
            {outDs : "gridListA", _siq : "aps.planExecute.controlBoardA"},
            {outDs : "gridListB", _siq : "aps.planExecute.controlBoardB"}
        ];
        
        fn_authorityReset();
        
        var sMap = {
            url: "${ctx}/biz/obj.do",
            data: FORM_SEARCH,
            success:function(data) {
                
                var grdDataA = data.gridListA;
                var grdDataB = data.gridListB;
                dataProvider.setRows(grdDataA);
                dataProvider2.setRows(grdDataB);
                
                gfn_setSearchRow(dataProvider.getRowCount() + " / " + dataProvider2.getRowCount());
                
                fn_gridCallback_customized(grdDataA);
            }
        }
        gfn_service(sMap, "obj");
    }
    
    
    
    function fn_gridCallback(dataA){
        
        gfn_service({
            async   : false,
            url     : GV_CONTEXT_PATH + "/biz/obj.do",
            data    : {
                _mtd : "getList",
                tranData : [
                    {outDs : "authorityList", _siq : "aps.planExecute.controllAuthority"}
                ]
            },
            success :function(data) {
                
                var planVersion = $("#planVersion").val();
                var prodPart = $("#prodPart").val();
                var weeklyDaily = $('input[name="weeklyDaily"]:checked').val();
                var dataLen = data.authorityList.length;
                var authorityCnt = 0;
                
                //1. Version 생성 버튼 활성화 여부, 2. 계획 확정 버튼 활성화 여부, 3. 계획 Option 권한 
                //실행버튼 권한은 따로 설정 하기
                for(var i = 0; i < dataLen; i++){
                    
                    var menuCd = data.authorityList[i].MENU_CD;
                    
                    if((menuCd == "APS40501" && prodPart == "LAM") || (menuCd == "APS40502" && prodPart == "TEL") || (menuCd == "APS40503" && prodPart == "DIFFUSION") || (menuCd == "APS40504" && prodPart == "MATERIAL")){
                        
                        authorityCnt++;
                        
                        var confirmCnt2 = 0;
                        var currentMasterCutOffFlag = "";
                        var currentCutOffFlag = "";
                        var currentVersionTypeFlag = "";
                        var currentVersionType = "";
                        var versionCntP = 0;
                        var versionTotCntP = 0;
                        var versionCntM = 0;
                        var versionTypeCnt = 0;
                        var versionTypeTotCnt = 0;
                        
                        $.each(codeMap.PLAN_VERSION, function(i, val){
                            
                            var valPlanVersion = val.CODE_CD;
                            var valVersionTypeCd = val.VERSION_TYPE_CD;
                            var valCutOffFlag = val.CUT_OFF_FLAG;
                            var valPlanOption = val.PLAN_OPTION;
                            var valBalWeek = val.BAL_WEEK;
                            var valPriorityOption = val.PRIORITY_OPTION;
                            var valWoReleaseWeek = val.WO_RELEASE_WEEK;
                            var valMasterCutOffFlag = val.MASTER_CUT_OFF_FLAG;
                            
                            if(planVersion == valPlanVersion){
                                
                                currentVersionType = valVersionTypeCd;
                                currentCutOffFlag = valCutOffFlag;
                                currentMasterCutOffFlag = valMasterCutOffFlag;
                                
                                $("#priorityOption").val(valPriorityOption);
                                $("#planOption").val(valPlanOption);
                                $("#precedeLimit").val(valBalWeek);
                                $("#woReleaseWeek").val(valWoReleaseWeek);
                                
                                areaVersionTypeCd = valVersionTypeCd; 
                                
                                if(valCutOffFlag == "Y"){
                                    confirmCnt2++;
                                }
                            }
                            
                            if(valVersionTypeCd == "P"){
                                if(valCutOffFlag == "Y"){
                                    versionCntP++
                                }
                                versionTotCntP++;
                            }
                            
                            if(valVersionTypeCd == "M"){
                                if(valCutOffFlag == "Y"){
                                    versionCntM++
                                }
                            }
                        });
                        
                        //선택된 계획 Version 에 VERSION_TYPE_CD의 CUT_OFF_FLAG가
                        $.each(codeMap.PLAN_VERSION, function(i, val){
                            
                            var valCutOffFlag = val.CUT_OFF_FLAG;
                            var valVersionTypeCd = val.VERSION_TYPE_CD;
                            
                            if(valVersionTypeCd == currentVersionType){
                                versionTypeTotCnt++;
                                
                                if(valCutOffFlag == "N"){
                                    versionTypeCnt++;   
                                }
                            }
                        });
                        
                        //Main Version 생성 버튼 권한
                        //TB_MST_PLAN_VERSION -> CUT_OFF_FLAG = 'N'
                        //선택된 계획 VersionId가 M
                        //TB_MST_PLAN_VERSION_SUB -> VERSION_tYPE_CD = 'P' 일경우 CUT_OFF_FLAG = 'Y'의 갯수가 0 초과일경우
                        //TB_MST_PLAN_VERSION_SUB -> VERSION_tYPE_CD = 'M' 일경우 CUT_OFF_FLAG = 'Y'의 갯수가 0 일경우
                        if(currentMasterCutOffFlag == "N" && currentVersionType == "M" && versionCntP == versionTotCntP && versionCntM == 0){
                            versionFlag = true;
                            $("#btnVersion").addClass("app1");
                            $("#btnVersion").removeClass("app");
                        }else{
                            versionFlag = false;
                            $("#btnVersion").removeClass("app1");
                            $("#btnVersion").addClass("app");
                        }
                        
                        //계획 확정 버튼 권한, 계획 확정 취소 버튼 권한
                        //1. 계획 확정 버튼 
                        // - TB_MST_PLAN_VERSION -> CUT_OFF_FLAG = 'N'
                        // - vesrion_type = 'M'
                        // - vesrion_type = 'M' AND TB_MST_PLAN_VERSION_SUB cut_off_flag = 'Y' 카운트가 0
                        //2 . 계획 확정 취소 버튼
                        // - TB_MST_PLAN_VERSION -> CUT_OFF_FLAG = 'N'
                        // - vesrion_type = 'M'
                        // - vesrion_type = 'M' AND TB_MST_PLAN_VERSION_SUB cut_off_flag = 'Y' 카운트가 0보다 클때
                        if(currentMasterCutOffFlag == "N" && currentVersionType == "M" && versionCntM > 0){//계획 확정 취소
                            planConfirmFlag = false;
                            $("#btnConfirm").removeClass("app1");
                            $("#btnConfirm").addClass("app");
                            
                            planConfirmCancelFlag = true;
                            $("#btnConfirmCancel").addClass("app1");
                            $("#btnConfirmCancel").removeClass("app");  
                            
                        }else if(currentMasterCutOffFlag == "N" && currentVersionType == "M" && versionCntM == 0){//계획 확정 
                            planConfirmFlag = true;
                            $("#btnConfirm").addClass("app1");
                            $("#btnConfirm").removeClass("app");
                            
                            planConfirmCancelFlag = false;
                            $("#btnConfirmCancel").removeClass("app1");
                            $("#btnConfirmCancel").addClass("app");
                        }else{
                            
                            planConfirmFlag = false;
                            $("#btnConfirm").removeClass("app1");
                            $("#btnConfirm").addClass("app");
                            
                            planConfirmCancelFlag = false;
                            $("#btnConfirmCancel").removeClass("app1");
                            $("#btnConfirmCancel").addClass("app");
                        }
                        
                        //우선 순위 옵션(비활성화 조건)
                        //일간 계획에서는 비활성화, 계획 Option 조건과 동일
                        if(weeklyDaily == "MP" && currentMasterCutOffFlag == "N" && confirmCnt2 == 0){//활성화 조건
                            priorityOptionFlag = true;
                            $("#savePriorityOption").addClass("app1");
                            $("#savePriorityOption").removeClass("app");
                            $("#priorityOption").attr("disabled", false);
                        }else{
                            priorityOptionFlag = false;
                            $("#savePriorityOption").removeClass("app1");
                            $("#savePriorityOption").addClass("app");
                            $("#priorityOption").attr("disabled", true);
                        }
                        
                        //계획 Option 권한 & 선행제약 기간
                        //TB_MST_PLAN_VERSION -> CUT_OFF_FLAG = 'N'
                        //TB_MST_PLAN_VERSION_SUB -> CUT_OFF_FLAG = 'Y'의 갯수가 0 일경우
                        if(currentMasterCutOffFlag == "N" && confirmCnt2 == 0){//활성화 조건
                            planOtionFlag = true;
                            $("#savePlanOption").addClass("app1");
                            $("#savePlanOption").removeClass("app");
                            $("#planOption").attr("disabled", false);
                            
                            precedeLimitFlag = true;
                            $("#savePrecedeLimit").addClass("app1");
                            $("#savePrecedeLimit").removeClass("app");
                            $("#precedeLimit").attr("disabled", false);
                        }else{
                            planOtionFlag = false;
                            $("#savePlanOption").removeClass("app1");
                            $("#savePlanOption").addClass("app");
                            $("#planOption").attr("disabled", true);
                            
                            precedeLimitFlag = false;
                            $("#savePrecedeLimit").removeClass("app1");
                            $("#savePrecedeLimit").addClass("app");
                            $("#precedeLimit").attr("disabled", true);
                        }
                        
                        //작업지시서 생성(비활성화 조건)
                        //1) 일간 계획에서는 비활성화
                        //2) TB_MST_PLAN_VERSION -> 선택한 PLAN ID의 CUT_OFF 가 'Y'면 비활성화
                        //3) TB_MST_PLAN_VERSION_SUB -> 계획 VERSION이 MAIN 일때만 활성화 MAIN 계획 : VERSION_TYPE_CD = 'M' (PRE/ FINAL VERSION에서는 비활성화)
                        //4) TB_MST_PLAN_VERSION_SUB -> PLAN_ID 기준으로 MAIN 계획을 CUT-OFF한 생산파트가 하나라도 있으면 비활성화
                        if(weeklyDaily == "MP" && currentMasterCutOffFlag == "N" && currentVersionType == "M" && versionCntM == 0){//활성화 조건
                            woReleaseWeekFlag = true;
                            $("#saveWoReleaseWeek").addClass("app1");
                            $("#saveWoReleaseWeek").removeClass("app");
                            $("#woReleaseWeek").attr("disabled", false);
                        }else{
                            woReleaseWeekFlag = false;
                            $("#saveWoReleaseWeek").removeClass("app1");
                            $("#saveWoReleaseWeek").addClass("app");
                            $("#woReleaseWeek").attr("disabled", true);
                        }

                        //계획실행, Master I/F 권한 체크
                        //1.해당 Version의 같은 version_type_cd의 전체가  cutOffFlag = 'N' 일경우
                        //2.전체 ROW의 CB_STATUS_CD 가 R 가 0이면 활성화(P, R, E, C) 
                        //3.EXEC_YN = 'Y' 
                        var executeACnt = 0;
                        
                        if(versionTypeTotCnt != versionTypeCnt){
                            executeAFlag = false;
                        }else{
                            $.each(dataA, function(i, val){
                                
                                var pCbStatusCd = val.CB_STATUS_CD;
                                
                                if(pCbStatusCd == "P" || pCbStatusCd == "C" || pCbStatusCd == "E"){
                                    executeACnt++;  
                                }
                            }); 
                            
                            if(dataA.length == executeACnt){
                                executeAFlag = true;
                            }else{
                                executeAFlag = false;
                            }
                        }
                    }
                }
                
                if(authorityCnt == 0){
                    
                    $.each(codeMap.PLAN_VERSION, function(i, val){
                        
                        var valPlanVersion = val.CODE_CD;
                        var valPlanOption = val.PLAN_OPTION;
                        var valBalWeek = val.BAL_WEEK;
                        
                        if(planVersion == valPlanVersion){
                            
                            $("#planOption").val(valPlanOption);
                            $("#precedeLimit").val(valBalWeek);
                            areaVersionTypeCd = "";
                        }
                    });
                }
            }
        }, "obj");
    }
    
    function fn_gridCallback_customized(dataA){
        
        gfn_service({
            async   : false,
            url     : GV_CONTEXT_PATH + "/biz/obj.do",
            data    : {
                _mtd : "getList",
                tranData : [
                    {outDs : "authorityList", _siq : "aps.planExecute.controllAuthority"}
                ]
            },
            success :function(data) {
                
                var planVersion = $("#planVersion").val();
                var prodPart = $("#prodPart").val();
                var weeklyDaily = $('input[name="weeklyDaily"]:checked').val();
                var dataLen = data.authorityList.length;
                var authorityCnt = 0;
                
                //1. Version 생성 버튼 활성화 여부, 2. 계획 확정 버튼 활성화 여부, 3. 계획 Option 권한 
                //실행버튼 권한은 따로 설정 하기
                for(var i = 0; i < dataLen; i++){
                    
                    var menuCd = data.authorityList[i].MENU_CD;
                    
                    if((menuCd == "APS40501" && prodPart == "LAM") || (menuCd == "APS40502" && prodPart == "TEL") || (menuCd == "APS40503" && prodPart == "DIFFUSION") || (menuCd == "APS40504" && prodPart == "MATERIAL")){
                        
                        authorityCnt++;
                        
                        var confirmCnt2 = 0;
                        var currentMasterCutOffFlag = "";
                        var currentCutOffFlag = "";
                        var currentVersionTypeFlag = "";
                        var currentVersionType = "";
                        var versionCntP = 0;
                        var versionTotCntP = 0;
                        var versionCntM = 0;
                        var versionTypeCnt = 0;
                        var versionTypeTotCnt = 0;
                        
                        $.each(codeMap.PLAN_VERSION, function(i, val){
                            
                            var valPlanVersion = val.CODE_CD;
                            var valVersionTypeCd = val.VERSION_TYPE_CD;
                            var valCutOffFlag = val.CUT_OFF_FLAG;
                            var valPlanOption = val.PLAN_OPTION;
                            var valBalWeek = val.BAL_WEEK;
                            var valPriorityOption = val.PRIORITY_OPTION;
                            var valWoReleaseWeek = val.WO_RELEASE_WEEK;
                            var valMasterCutOffFlag = val.MASTER_CUT_OFF_FLAG;
                            
                            if(planVersion == valPlanVersion){
                                
                                currentVersionType = valVersionTypeCd;
                                currentCutOffFlag = valCutOffFlag;
                                currentMasterCutOffFlag = valMasterCutOffFlag;
                                
                                $("#priorityOption").val(valPriorityOption);
                                $("#planOption").val(valPlanOption);
                                $("#precedeLimit").val(valBalWeek);
                                $("#woReleaseWeek").val(valWoReleaseWeek);
                                
                                areaVersionTypeCd = valVersionTypeCd; 
                                
                                if(valCutOffFlag == "Y"){
                                    confirmCnt2++;
                                }
                            }
                            
                            if(valVersionTypeCd == "P"){
                                if(valCutOffFlag == "Y"){
                                    versionCntP++
                                }
                                versionTotCntP++;
                            }
                            
                            if(valVersionTypeCd == "M"){
                                if(valCutOffFlag == "Y"){
                                    versionCntM++
                                }
                            }
                        });
                        
                        //선택된 계획 Version 에 VERSION_TYPE_CD의 CUT_OFF_FLAG가
                        $.each(codeMap.PLAN_VERSION, function(i, val){
                            
                            var valCutOffFlag = val.CUT_OFF_FLAG;
                            var valVersionTypeCd = val.VERSION_TYPE_CD;
                            
                            if(valVersionTypeCd == currentVersionType){
                                versionTypeTotCnt++;
                                
                                if(valCutOffFlag == "N"){
                                    versionTypeCnt++;   
                                }
                            }
                        });
                        
                        //Main Version 생성 버튼 권한
                        //TB_MST_PLAN_VERSION -> CUT_OFF_FLAG = 'N'
                        //선택된 계획 VersionId가 M
                        //TB_MST_PLAN_VERSION_SUB -> VERSION_tYPE_CD = 'P' 일경우 CUT_OFF_FLAG = 'Y'의 갯수가 0 초과일경우
                        //TB_MST_PLAN_VERSION_SUB -> VERSION_tYPE_CD = 'M' 일경우 CUT_OFF_FLAG = 'Y'의 갯수가 0 일경우
                        if(currentMasterCutOffFlag == "N" && currentVersionType == "M" && versionCntP == versionTotCntP && versionCntM == 0){
                            versionFlag = true;
                            $("#btnVersion").addClass("app1");
                            $("#btnVersion").removeClass("app");
                        }else{
                            versionFlag = false;
                            $("#btnVersion").removeClass("app1");
                            $("#btnVersion").addClass("app");
                        }
                        
                        //계획 확정 버튼 권한, 계획 확정 취소 버튼 권한
                        //1. 계획 확정 버튼 
                        // - TB_MST_PLAN_VERSION -> CUT_OFF_FLAG = 'N'
                        // - vesrion_type = 'M'
                        // - vesrion_type = 'M' AND TB_MST_PLAN_VERSION_SUB cut_off_flag = 'Y' 카운트가 0
                        //2 . 계획 확정 취소 버튼
                        // - TB_MST_PLAN_VERSION -> CUT_OFF_FLAG = 'N'
                        // - vesrion_type = 'M'
                        // - vesrion_type = 'M' AND TB_MST_PLAN_VERSION_SUB cut_off_flag = 'Y' 카운트가 0보다 클때
                        if(currentMasterCutOffFlag == "N" && currentVersionType == "M" && versionCntM > 0){//계획 확정 취소
                            planConfirmFlag = false;
                            $("#btnConfirm").removeClass("app1");
                            $("#btnConfirm").addClass("app");
                            
                            planConfirmCancelFlag = true;
                            $("#btnConfirmCancel").addClass("app1");
                            $("#btnConfirmCancel").removeClass("app");  
                            
                        }else if(currentMasterCutOffFlag == "N" && currentVersionType == "M" && versionCntM == 0){//계획 확정 
                            planConfirmFlag = true;
                            $("#btnConfirm").addClass("app1");
                            $("#btnConfirm").removeClass("app");
                            
                            planConfirmCancelFlag = false;
                            $("#btnConfirmCancel").removeClass("app1");
                            $("#btnConfirmCancel").addClass("app");
                        }else{
                            
                            planConfirmFlag = false;
                            $("#btnConfirm").removeClass("app1");
                            $("#btnConfirm").addClass("app");
                            
                            planConfirmCancelFlag = false;
                            $("#btnConfirmCancel").removeClass("app1");
                            $("#btnConfirmCancel").addClass("app");
                        }
                        
                        //우선 순위 옵션(비활성화 조건)
                        //일간 계획에서는 비활성화, 계획 Option 조건과 동일
                        if(weeklyDaily == "MP" && currentMasterCutOffFlag == "N" && confirmCnt2 == 0){//활성화 조건
                            priorityOptionFlag = true;
                            $("#savePriorityOption").addClass("app1");
                            $("#savePriorityOption").removeClass("app");
                            $("#priorityOption").attr("disabled", false);
                        }else{
                            priorityOptionFlag = false;
                            $("#savePriorityOption").removeClass("app1");
                            $("#savePriorityOption").addClass("app");
                            $("#priorityOption").attr("disabled", true);
                        }
                        
                        //계획 Option 권한 & 선행제약 기간
                        //TB_MST_PLAN_VERSION -> CUT_OFF_FLAG = 'N'
                        //TB_MST_PLAN_VERSION_SUB -> CUT_OFF_FLAG = 'Y'의 갯수가 0 일경우
                        if(currentMasterCutOffFlag == "N" && confirmCnt2 == 0){//활성화 조건
                            planOtionFlag = true;
                            $("#savePlanOption").addClass("app1");
                            $("#savePlanOption").removeClass("app");
                            $("#planOption").attr("disabled", false);
                            
                            precedeLimitFlag = true;
                            $("#savePrecedeLimit").addClass("app1");
                            $("#savePrecedeLimit").removeClass("app");
                            $("#precedeLimit").attr("disabled", false);
                        }else{
                            planOtionFlag = false;
                            $("#savePlanOption").removeClass("app1");
                            $("#savePlanOption").addClass("app");
                            $("#planOption").attr("disabled", true);
                            
                            precedeLimitFlag = false;
                            $("#savePrecedeLimit").removeClass("app1");
                            $("#savePrecedeLimit").addClass("app");
                            $("#precedeLimit").attr("disabled", true);
                        }
                        
                        //작업지시서 생성(비활성화 조건)
                        //1) 일간 계획에서는 비활성화
                        //2) TB_MST_PLAN_VERSION -> 선택한 PLAN ID의 CUT_OFF 가 'Y'면 비활성화
                        //3) TB_MST_PLAN_VERSION_SUB -> 계획 VERSION이 MAIN 일때만 활성화 MAIN 계획 : VERSION_TYPE_CD = 'M' (PRE/ FINAL VERSION에서는 비활성화)
                        //4) TB_MST_PLAN_VERSION_SUB -> PLAN_ID 기준으로 MAIN 계획을 CUT-OFF한 생산파트가 하나라도 있으면 비활성화
                        if(weeklyDaily == "MP" && currentMasterCutOffFlag == "N" && currentVersionType == "M" && versionCntM == 0){//활성화 조건
                            woReleaseWeekFlag = true;
                            $("#saveWoReleaseWeek").addClass("app1");
                            $("#saveWoReleaseWeek").removeClass("app");
                            $("#woReleaseWeek").attr("disabled", false);
                        }else{
                            woReleaseWeekFlag = false;
                            $("#saveWoReleaseWeek").removeClass("app1");
                            $("#saveWoReleaseWeek").addClass("app");
                            $("#woReleaseWeek").attr("disabled", true);
                        }

                        //계획실행, Master I/F 권한 체크
                        //1.해당 Version의 같은 version_type_cd의 전체가  cutOffFlag = 'N' 일경우
                        //2.전체 ROW의 CB_STATUS_CD 가 R 가 0이면 활성화(P, R, E, C) 
                        //3.EXEC_YN = 'Y' 
                        var executeACnt = 0;
                        
                        if(versionTypeTotCnt != versionTypeCnt){
                            executeAFlag = false;
                        }else{
                            $.each(dataA, function(i, val){
                                
                                var pCbStatusCd = val.CB_STATUS_CD;
                                
                                if(pCbStatusCd == "P" || pCbStatusCd == "C" || pCbStatusCd == "E"){
                                    executeACnt++;  
                                }
                            }); 
                            
                            if(dataA.length == executeACnt){
                                executeAFlag = true;
                            }else{
                                executeAFlag = false;
                            }
                        }
                    }
                }
                
                if(authorityCnt == 0){
                    
                    $.each(codeMap.PLAN_VERSION, function(i, val){
                        
                        var valPlanVersion = val.CODE_CD;
                        var valPlanOption = val.PLAN_OPTION;
                        var valBalWeek = val.BAL_WEEK;
                        
                        if(planVersion == valPlanVersion){
                            
                            $("#planOption").val(valPlanOption);
                            $("#precedeLimit").val(valBalWeek);
                            areaVersionTypeCd = "";
                        }
                    });
                }
                
                fn_DoubleClickEvent(grdMain,GlobalIndex)
                
                
            }
        }, "obj");
    }
    
    
function fn_gridCallback_customized_for_Confirm(dataA){
        
        gfn_service({
            async   : false,
            url     : GV_CONTEXT_PATH + "/biz/obj.do",
            data    : {
                _mtd : "getList",
                tranData : [
                    {outDs : "authorityList", _siq : "aps.planExecute.controllAuthority"}
                ]
            },
            success :function(data) {
                
                var planVersion = $("#planVersion").val();
                var prodPart = $("#prodPart").val();
                var weeklyDaily = $('input[name="weeklyDaily"]:checked').val();
                var dataLen = data.authorityList.length;
                var authorityCnt = 0;
                
                //1. Version 생성 버튼 활성화 여부, 2. 계획 확정 버튼 활성화 여부, 3. 계획 Option 권한 
                //실행버튼 권한은 따로 설정 하기
                for(var i = 0; i < dataLen; i++){
                    
                    var menuCd = data.authorityList[i].MENU_CD;
                    
                    if((menuCd == "APS40501" && prodPart == "LAM") || (menuCd == "APS40502" && prodPart == "TEL") || (menuCd == "APS40503" && prodPart == "DIFFUSION") || (menuCd == "APS40504" && prodPart == "MATERIAL")){
                        
                        authorityCnt++;
                        
                        var confirmCnt2 = 0;
                        var currentMasterCutOffFlag = "";
                        var currentCutOffFlag = "";
                        var currentVersionTypeFlag = "";
                        var currentVersionType = "";
                        var versionCntP = 0;
                        var versionTotCntP = 0;
                        var versionCntM = 0;
                        var versionTypeCnt = 0;
                        var versionTypeTotCnt = 0;
                        
                        $.each(codeMap.PLAN_VERSION, function(i, val){
                            
                            var valPlanVersion = val.CODE_CD;
                            var valVersionTypeCd = val.VERSION_TYPE_CD;
                            var valCutOffFlag = val.CUT_OFF_FLAG;
                            var valPlanOption = val.PLAN_OPTION;
                            var valBalWeek = val.BAL_WEEK;
                            var valPriorityOption = val.PRIORITY_OPTION;
                            var valWoReleaseWeek = val.WO_RELEASE_WEEK;
                            var valMasterCutOffFlag = val.MASTER_CUT_OFF_FLAG;
                            
                            if(planVersion == valPlanVersion){
                                
                                currentVersionType = valVersionTypeCd;
                                currentCutOffFlag = valCutOffFlag;
                                currentMasterCutOffFlag = valMasterCutOffFlag;
                                
                                $("#priorityOption").val(valPriorityOption);
                                $("#planOption").val(valPlanOption);
                                $("#precedeLimit").val(valBalWeek);
                                $("#woReleaseWeek").val(valWoReleaseWeek);
                                
                                areaVersionTypeCd = valVersionTypeCd; 
                                
                                if(valCutOffFlag == "Y"){
                                    confirmCnt2++;
                                }
                            }
                            
                            if(valVersionTypeCd == "P"){
                                if(valCutOffFlag == "Y"){
                                    versionCntP++
                                }
                                versionTotCntP++;
                            }
                            
                            if(valVersionTypeCd == "M"){
                                if(valCutOffFlag == "Y"){
                                    versionCntM++
                                }
                            }
                        });
                        
                        //선택된 계획 Version 에 VERSION_TYPE_CD의 CUT_OFF_FLAG가
                        $.each(codeMap.PLAN_VERSION, function(i, val){
                            
                            var valCutOffFlag = val.CUT_OFF_FLAG;
                            var valVersionTypeCd = val.VERSION_TYPE_CD;
                            
                            if(valVersionTypeCd == currentVersionType){
                                versionTypeTotCnt++;
                                
                                if(valCutOffFlag == "N"){
                                    versionTypeCnt++;   
                                }
                            }
                        });
                        
                        //Main Version 생성 버튼 권한
                        //TB_MST_PLAN_VERSION -> CUT_OFF_FLAG = 'N'
                        //선택된 계획 VersionId가 M
                        //TB_MST_PLAN_VERSION_SUB -> VERSION_tYPE_CD = 'P' 일경우 CUT_OFF_FLAG = 'Y'의 갯수가 0 초과일경우
                        //TB_MST_PLAN_VERSION_SUB -> VERSION_tYPE_CD = 'M' 일경우 CUT_OFF_FLAG = 'Y'의 갯수가 0 일경우
                        if(currentMasterCutOffFlag == "N" && currentVersionType == "M" && versionCntP == versionTotCntP && versionCntM == 0){
                            versionFlag = true;
                            $("#btnVersion").addClass("app1");
                            $("#btnVersion").removeClass("app");
                        }else{
                            versionFlag = false;
                            $("#btnVersion").removeClass("app1");
                            $("#btnVersion").addClass("app");
                        }
                        
                        //계획 확정 버튼 권한, 계획 확정 취소 버튼 권한
                        //1. 계획 확정 버튼 
                        // - TB_MST_PLAN_VERSION -> CUT_OFF_FLAG = 'N'
                        // - vesrion_type = 'M'
                        // - vesrion_type = 'M' AND TB_MST_PLAN_VERSION_SUB cut_off_flag = 'Y' 카운트가 0
                        //2 . 계획 확정 취소 버튼
                        // - TB_MST_PLAN_VERSION -> CUT_OFF_FLAG = 'N'
                        // - vesrion_type = 'M'
                        // - vesrion_type = 'M' AND TB_MST_PLAN_VERSION_SUB cut_off_flag = 'Y' 카운트가 0보다 클때
                        if(currentMasterCutOffFlag == "N" && currentVersionType == "M" && versionCntM > 0){//계획 확정 취소
                            planConfirmFlag = false;
                            $("#btnConfirm").removeClass("app1");
                            $("#btnConfirm").addClass("app");
                            
                            planConfirmCancelFlag = true;
                            $("#btnConfirmCancel").addClass("app1");
                            $("#btnConfirmCancel").removeClass("app");  
                            
                        }else if(currentMasterCutOffFlag == "N" && currentVersionType == "M" && versionCntM == 0){//계획 확정 
                            planConfirmFlag = true;
                            $("#btnConfirm").addClass("app1");
                            $("#btnConfirm").removeClass("app");
                            
                            planConfirmCancelFlag = false;
                            $("#btnConfirmCancel").removeClass("app1");
                            $("#btnConfirmCancel").addClass("app");
                        }else{
                            
                            planConfirmFlag = false;
                            $("#btnConfirm").removeClass("app1");
                            $("#btnConfirm").addClass("app");
                            
                            planConfirmCancelFlag = false;
                            $("#btnConfirmCancel").removeClass("app1");
                            $("#btnConfirmCancel").addClass("app");
                        }
                        
                        //우선 순위 옵션(비활성화 조건)
                        //일간 계획에서는 비활성화, 계획 Option 조건과 동일
                        if(weeklyDaily == "MP" && currentMasterCutOffFlag == "N" && confirmCnt2 == 0){//활성화 조건
                            priorityOptionFlag = true;
                            $("#savePriorityOption").addClass("app1");
                            $("#savePriorityOption").removeClass("app");
                            $("#priorityOption").attr("disabled", false);
                        }else{
                            priorityOptionFlag = false;
                            $("#savePriorityOption").removeClass("app1");
                            $("#savePriorityOption").addClass("app");
                            $("#priorityOption").attr("disabled", true);
                        }
                        
                        //계획 Option 권한 & 선행제약 기간
                        //TB_MST_PLAN_VERSION -> CUT_OFF_FLAG = 'N'
                        //TB_MST_PLAN_VERSION_SUB -> CUT_OFF_FLAG = 'Y'의 갯수가 0 일경우
                        if(currentMasterCutOffFlag == "N" && confirmCnt2 == 0){//활성화 조건
                            planOtionFlag = true;
                            $("#savePlanOption").addClass("app1");
                            $("#savePlanOption").removeClass("app");
                            $("#planOption").attr("disabled", false);
                            
                            precedeLimitFlag = true;
                            $("#savePrecedeLimit").addClass("app1");
                            $("#savePrecedeLimit").removeClass("app");
                            $("#precedeLimit").attr("disabled", false);
                        }else{
                            planOtionFlag = false;
                            $("#savePlanOption").removeClass("app1");
                            $("#savePlanOption").addClass("app");
                            $("#planOption").attr("disabled", true);
                            
                            precedeLimitFlag = false;
                            $("#savePrecedeLimit").removeClass("app1");
                            $("#savePrecedeLimit").addClass("app");
                            $("#precedeLimit").attr("disabled", true);
                        }
                        
                        //작업지시서 생성(비활성화 조건)
                        //1) 일간 계획에서는 비활성화
                        //2) TB_MST_PLAN_VERSION -> 선택한 PLAN ID의 CUT_OFF 가 'Y'면 비활성화
                        //3) TB_MST_PLAN_VERSION_SUB -> 계획 VERSION이 MAIN 일때만 활성화 MAIN 계획 : VERSION_TYPE_CD = 'M' (PRE/ FINAL VERSION에서는 비활성화)
                        //4) TB_MST_PLAN_VERSION_SUB -> PLAN_ID 기준으로 MAIN 계획을 CUT-OFF한 생산파트가 하나라도 있으면 비활성화
                        if(weeklyDaily == "MP" && currentMasterCutOffFlag == "N" && currentVersionType == "M" && versionCntM == 0){//활성화 조건
                            woReleaseWeekFlag = true;
                            $("#saveWoReleaseWeek").addClass("app1");
                            $("#saveWoReleaseWeek").removeClass("app");
                            $("#woReleaseWeek").attr("disabled", false);
                        }else{
                            woReleaseWeekFlag = false;
                            $("#saveWoReleaseWeek").removeClass("app1");
                            $("#saveWoReleaseWeek").addClass("app");
                            $("#woReleaseWeek").attr("disabled", true);
                        }

                        //계획실행, Master I/F 권한 체크
                        //1.해당 Version의 같은 version_type_cd의 전체가  cutOffFlag = 'N' 일경우
                        //2.전체 ROW의 CB_STATUS_CD 가 R 가 0이면 활성화(P, R, E, C) 
                        //3.EXEC_YN = 'Y' 
                        var executeACnt = 0;
                        
                        if(versionTypeTotCnt != versionTypeCnt){
                            executeAFlag = false;
                        }else{
                            $.each(dataA, function(i, val){
                                
                                var pCbStatusCd = val.CB_STATUS_CD;
                                
                                if(pCbStatusCd == "P" || pCbStatusCd == "C" || pCbStatusCd == "E"){
                                    executeACnt++;  
                                }
                            }); 
                            
                            if(dataA.length == executeACnt){
                                executeAFlag = true;
                            }else{
                                executeAFlag = false;
                            }
                        }
                    }
                }
                
                if(authorityCnt == 0){
                    
                    $.each(codeMap.PLAN_VERSION, function(i, val){
                        
                        var valPlanVersion = val.CODE_CD;
                        var valPlanOption = val.PLAN_OPTION;
                        var valBalWeek = val.BAL_WEEK;
                        
                        if(planVersion == valPlanVersion){
                            
                            $("#planOption").val(valPlanOption);
                            $("#precedeLimit").val(valBalWeek);
                            areaVersionTypeCd = "";
                        }
                    });
                }
                
                

                if(planConfirmFlag){
                    
                    confirm('<spring:message code="msg.msgPlanConfirm"/>', function() {
                        var data = [{call : "call"}];
                        
                        FORM_SAVE = $("#searchForm").serializeObject();
                        FORM_SAVE._mtd = "saveUpdate";
                        FORM_SAVE.precedeLimit = $("#precedeLimit").val();
                        FORM_SAVE.cutOffFlag = "Y";
                        FORM_SAVE.tranData = [
                            {outDs : "saveCnt", _siq : "aps.planExecute.saveConfrim", grdData : data}
                        ];
                        
                        gfn_service({
                            url     : GV_CONTEXT_PATH + "/biz/obj.do",
                            data    : FORM_SAVE,
                            success : function(data) {
                                alert('<spring:message code="msg.msgPlanConfirmExec"/>');
                                fn_planVersionChg();
                                fn_apply();
                            }
                        }, "obj");  
                    });
                }
                
                
            }
        }, "obj");
    }
    
    
function fn_gridCallback_customized_for_ConfirmCancel(dataA){
    
    gfn_service({
        async   : false,
        url     : GV_CONTEXT_PATH + "/biz/obj.do",
        data    : {
            _mtd : "getList",
            tranData : [
                {outDs : "authorityList", _siq : "aps.planExecute.controllAuthority"}
            ]
        },
        success :function(data) {
            
            var planVersion = $("#planVersion").val();
            var prodPart = $("#prodPart").val();
            var weeklyDaily = $('input[name="weeklyDaily"]:checked').val();
            var dataLen = data.authorityList.length;
            var authorityCnt = 0;
            
            //1. Version 생성 버튼 활성화 여부, 2. 계획 확정 버튼 활성화 여부, 3. 계획 Option 권한 
            //실행버튼 권한은 따로 설정 하기
            for(var i = 0; i < dataLen; i++){
                
                var menuCd = data.authorityList[i].MENU_CD;
                
                if((menuCd == "APS40501" && prodPart == "LAM") || (menuCd == "APS40502" && prodPart == "TEL") || (menuCd == "APS40503" && prodPart == "DIFFUSION") || (menuCd == "APS40504" && prodPart == "MATERIAL")){
                    
                    authorityCnt++;
                    
                    var confirmCnt2 = 0;
                    var currentMasterCutOffFlag = "";
                    var currentCutOffFlag = "";
                    var currentVersionTypeFlag = "";
                    var currentVersionType = "";
                    var versionCntP = 0;
                    var versionTotCntP = 0;
                    var versionCntM = 0;
                    var versionTypeCnt = 0;
                    var versionTypeTotCnt = 0;
                    
                    $.each(codeMap.PLAN_VERSION, function(i, val){
                        
                        var valPlanVersion = val.CODE_CD;
                        var valVersionTypeCd = val.VERSION_TYPE_CD;
                        var valCutOffFlag = val.CUT_OFF_FLAG;
                        var valPlanOption = val.PLAN_OPTION;
                        var valBalWeek = val.BAL_WEEK;
                        var valPriorityOption = val.PRIORITY_OPTION;
                        var valWoReleaseWeek = val.WO_RELEASE_WEEK;
                        var valMasterCutOffFlag = val.MASTER_CUT_OFF_FLAG;
                        
                        if(planVersion == valPlanVersion){
                            
                            currentVersionType = valVersionTypeCd;
                            currentCutOffFlag = valCutOffFlag;
                            currentMasterCutOffFlag = valMasterCutOffFlag;
                            
                            $("#priorityOption").val(valPriorityOption);
                            $("#planOption").val(valPlanOption);
                            $("#precedeLimit").val(valBalWeek);
                            $("#woReleaseWeek").val(valWoReleaseWeek);
                            
                            areaVersionTypeCd = valVersionTypeCd; 
                            
                            if(valCutOffFlag == "Y"){
                                confirmCnt2++;
                            }
                        }
                        
                        if(valVersionTypeCd == "P"){
                            if(valCutOffFlag == "Y"){
                                versionCntP++
                            }
                            versionTotCntP++;
                        }
                        
                        if(valVersionTypeCd == "M"){
                            if(valCutOffFlag == "Y"){
                                versionCntM++
                            }
                        }
                    });
                    
                    //선택된 계획 Version 에 VERSION_TYPE_CD의 CUT_OFF_FLAG가
                    $.each(codeMap.PLAN_VERSION, function(i, val){
                        
                        var valCutOffFlag = val.CUT_OFF_FLAG;
                        var valVersionTypeCd = val.VERSION_TYPE_CD;
                        
                        if(valVersionTypeCd == currentVersionType){
                            versionTypeTotCnt++;
                            
                            if(valCutOffFlag == "N"){
                                versionTypeCnt++;   
                            }
                        }
                    });
                    
                    //Main Version 생성 버튼 권한
                    //TB_MST_PLAN_VERSION -> CUT_OFF_FLAG = 'N'
                    //선택된 계획 VersionId가 M
                    //TB_MST_PLAN_VERSION_SUB -> VERSION_tYPE_CD = 'P' 일경우 CUT_OFF_FLAG = 'Y'의 갯수가 0 초과일경우
                    //TB_MST_PLAN_VERSION_SUB -> VERSION_tYPE_CD = 'M' 일경우 CUT_OFF_FLAG = 'Y'의 갯수가 0 일경우
                    if(currentMasterCutOffFlag == "N" && currentVersionType == "M" && versionCntP == versionTotCntP && versionCntM == 0){
                        versionFlag = true;
                        $("#btnVersion").addClass("app1");
                        $("#btnVersion").removeClass("app");
                    }else{
                        versionFlag = false;
                        $("#btnVersion").removeClass("app1");
                        $("#btnVersion").addClass("app");
                    }
                    
                    //계획 확정 버튼 권한, 계획 확정 취소 버튼 권한
                    //1. 계획 확정 버튼 
                    // - TB_MST_PLAN_VERSION -> CUT_OFF_FLAG = 'N'
                    // - vesrion_type = 'M'
                    // - vesrion_type = 'M' AND TB_MST_PLAN_VERSION_SUB cut_off_flag = 'Y' 카운트가 0
                    //2 . 계획 확정 취소 버튼
                    // - TB_MST_PLAN_VERSION -> CUT_OFF_FLAG = 'N'
                    // - vesrion_type = 'M'
                    // - vesrion_type = 'M' AND TB_MST_PLAN_VERSION_SUB cut_off_flag = 'Y' 카운트가 0보다 클때
                    if(currentMasterCutOffFlag == "N" && currentVersionType == "M" && versionCntM > 0){//계획 확정 취소
                        planConfirmFlag = false;
                        $("#btnConfirm").removeClass("app1");
                        $("#btnConfirm").addClass("app");
                        
                        planConfirmCancelFlag = true;
                        $("#btnConfirmCancel").addClass("app1");
                        $("#btnConfirmCancel").removeClass("app");  
                        
                    }else if(currentMasterCutOffFlag == "N" && currentVersionType == "M" && versionCntM == 0){//계획 확정 
                        planConfirmFlag = true;
                        $("#btnConfirm").addClass("app1");
                        $("#btnConfirm").removeClass("app");
                        
                        planConfirmCancelFlag = false;
                        $("#btnConfirmCancel").removeClass("app1");
                        $("#btnConfirmCancel").addClass("app");
                    }else{
                        
                        planConfirmFlag = false;
                        $("#btnConfirm").removeClass("app1");
                        $("#btnConfirm").addClass("app");
                        
                        planConfirmCancelFlag = false;
                        $("#btnConfirmCancel").removeClass("app1");
                        $("#btnConfirmCancel").addClass("app");
                    }
                    
                    //우선 순위 옵션(비활성화 조건)
                    //일간 계획에서는 비활성화, 계획 Option 조건과 동일
                    if(weeklyDaily == "MP" && currentMasterCutOffFlag == "N" && confirmCnt2 == 0){//활성화 조건
                        priorityOptionFlag = true;
                        $("#savePriorityOption").addClass("app1");
                        $("#savePriorityOption").removeClass("app");
                        $("#priorityOption").attr("disabled", false);
                    }else{
                        priorityOptionFlag = false;
                        $("#savePriorityOption").removeClass("app1");
                        $("#savePriorityOption").addClass("app");
                        $("#priorityOption").attr("disabled", true);
                    }
                    
                    //계획 Option 권한 & 선행제약 기간
                    //TB_MST_PLAN_VERSION -> CUT_OFF_FLAG = 'N'
                    //TB_MST_PLAN_VERSION_SUB -> CUT_OFF_FLAG = 'Y'의 갯수가 0 일경우
                    if(currentMasterCutOffFlag == "N" && confirmCnt2 == 0){//활성화 조건
                        planOtionFlag = true;
                        $("#savePlanOption").addClass("app1");
                        $("#savePlanOption").removeClass("app");
                        $("#planOption").attr("disabled", false);
                        
                        precedeLimitFlag = true;
                        $("#savePrecedeLimit").addClass("app1");
                        $("#savePrecedeLimit").removeClass("app");
                        $("#precedeLimit").attr("disabled", false);
                    }else{
                        planOtionFlag = false;
                        $("#savePlanOption").removeClass("app1");
                        $("#savePlanOption").addClass("app");
                        $("#planOption").attr("disabled", true);
                        
                        precedeLimitFlag = false;
                        $("#savePrecedeLimit").removeClass("app1");
                        $("#savePrecedeLimit").addClass("app");
                        $("#precedeLimit").attr("disabled", true);
                    }
                    
                    //작업지시서 생성(비활성화 조건)
                    //1) 일간 계획에서는 비활성화
                    //2) TB_MST_PLAN_VERSION -> 선택한 PLAN ID의 CUT_OFF 가 'Y'면 비활성화
                    //3) TB_MST_PLAN_VERSION_SUB -> 계획 VERSION이 MAIN 일때만 활성화 MAIN 계획 : VERSION_TYPE_CD = 'M' (PRE/ FINAL VERSION에서는 비활성화)
                    //4) TB_MST_PLAN_VERSION_SUB -> PLAN_ID 기준으로 MAIN 계획을 CUT-OFF한 생산파트가 하나라도 있으면 비활성화
                    if(weeklyDaily == "MP" && currentMasterCutOffFlag == "N" && currentVersionType == "M" && versionCntM == 0){//활성화 조건
                        woReleaseWeekFlag = true;
                        $("#saveWoReleaseWeek").addClass("app1");
                        $("#saveWoReleaseWeek").removeClass("app");
                        $("#woReleaseWeek").attr("disabled", false);
                    }else{
                        woReleaseWeekFlag = false;
                        $("#saveWoReleaseWeek").removeClass("app1");
                        $("#saveWoReleaseWeek").addClass("app");
                        $("#woReleaseWeek").attr("disabled", true);
                    }

                    //계획실행, Master I/F 권한 체크
                    //1.해당 Version의 같은 version_type_cd의 전체가  cutOffFlag = 'N' 일경우
                    //2.전체 ROW의 CB_STATUS_CD 가 R 가 0이면 활성화(P, R, E, C) 
                    //3.EXEC_YN = 'Y' 
                    var executeACnt = 0;
                    
                    if(versionTypeTotCnt != versionTypeCnt){
                        executeAFlag = false;
                    }else{
                        $.each(dataA, function(i, val){
                            
                            var pCbStatusCd = val.CB_STATUS_CD;
                            
                            if(pCbStatusCd == "P" || pCbStatusCd == "C" || pCbStatusCd == "E"){
                                executeACnt++;  
                            }
                        }); 
                        
                        if(dataA.length == executeACnt){
                            executeAFlag = true;
                        }else{
                            executeAFlag = false;
                        }
                    }
                }
            }
            
            if(authorityCnt == 0){
                
                $.each(codeMap.PLAN_VERSION, function(i, val){
                    
                    var valPlanVersion = val.CODE_CD;
                    var valPlanOption = val.PLAN_OPTION;
                    var valBalWeek = val.BAL_WEEK;
                    
                    if(planVersion == valPlanVersion){
                        
                        $("#planOption").val(valPlanOption);
                        $("#precedeLimit").val(valBalWeek);
                        areaVersionTypeCd = "";
                    }
                });
            }
            

            if(planConfirmCancelFlag){
                confirm('<spring:message code="msg.msgPlanConfirmCancel"/>', function() {
                    var data = [{call : "call"}];
                    
                    FORM_SAVE = $("#searchForm").serializeObject();
                    FORM_SAVE._mtd = "saveUpdate";
                    FORM_SAVE.precedeLimit = $("#precedeLimit").val();
                    FORM_SAVE.cutOffFlag = "N";
                    FORM_SAVE.tranData = [
                        {outDs : "saveCnt", _siq : "aps.planExecute.saveConfrimCancel", grdData : data}
                    ];
                    
                    gfn_service({
                        url     : GV_CONTEXT_PATH + "/biz/obj.do",
                        data    : FORM_SAVE,
                        success : function(data) {
                            alert('<spring:message code="msg.msgPlanConfirmExecCancel"/>');
                            fn_planVersionChg();
                            fn_apply();
                        }
                    }, "obj");  
                });
            }
            
            
        }
    }, "obj");
}

    
    
    
    //그리드를 그린다.
    function fn_drawGrid(sqlFlag) {
        if (sqlFlag) {
            return;
        }
        
        gridInstance.setDraw();
    }
    
    function fn_save() {
        var grdData = gfn_getGrdSavedataAll(grdMain);
    }
    
    function fn_planVersionChg(){
        
        var planId = $("#planId").val();
        var prodPart = gfn_nvl($("#prodPart").val(), "");
        var versionId = gfn_nvl($("#planVersion").val(), "");
        
        if(prodPart != ""){
            gfn_service({
                async   : false,
                url     : GV_CONTEXT_PATH + "/biz/obj.do",
                data    : {_mtd : "getList", planId : planId, prodPart : prodPart, tranData:[
                    {outDs : "planVersion", _siq : "aps.planExecute.planVersionControl"},
                ]},
                success : function(data) {
                    
                    codeMap.PLAN_VERSION = data.planVersion;
                    
                    gfn_setMsCombo("planVersion", data.planVersion, [""]);
                    
                    if(versionId != ""){
                        $("#planVersion").val(versionId);   
                    }
                    
                    $.each(codeMap.PLAN_VERSION, function(i, val){
                        
                        var codeCd = val.CODE_CD;
                        var cutOffFlag = val.CUT_OFF_FLAG;
                        var versionTypeCd = val.VERSION_TYPE_CD;
                        
                        if(cutOffFlag == "Y" && versionTypeCd == "M"){
                            $("#planVersion option:eq("+ i +")").css("color", gv_redColor);
                            return false;
                        }
                    });
                }
            }, "obj");
        }
        
        fn_authorityReset();
    }
    
function fn_planVersionChg_customized(){
        
        var planId = $("#planId").val();
        var prodPart = gfn_nvl($("#prodPart").val(), "");
        var versionId = gfn_nvl($("#planVersion").val(), "");
        
        if(prodPart != ""){
            gfn_service({
                async   : false,
                url     : GV_CONTEXT_PATH + "/biz/obj.do",
                data    : {_mtd : "getList", planId : planId, prodPart : prodPart, tranData:[
                    {outDs : "planVersion", _siq : "aps.planExecute.planVersionControl"},
                ]},
                success : function(data) {
                    
                    codeMap.PLAN_VERSION = data.planVersion;
                    
                    gfn_setMsCombo("planVersion", data.planVersion, [""]);
                    
                    if(versionId != ""){
                        $("#planVersion").val(versionId);   
                    }
                    
                    $.each(codeMap.PLAN_VERSION, function(i, val){
                        
                        var codeCd = val.CODE_CD;
                        var cutOffFlag = val.CUT_OFF_FLAG;
                        var versionTypeCd = val.VERSION_TYPE_CD;
                        
                        if(cutOffFlag == "Y" && versionTypeCd == "M"){
                            $("#planVersion option:eq("+ i +")").css("color", gv_redColor);
                            return false;
                        }
                    });
                    
                    fn_apply_customized();
                    
                }
            }, "obj");
        }
        
        fn_authorityReset();
    }
    
    

function fn_planVersionChg_customized_for_Confirm(){
        
        var planId = $("#planId").val();
        var prodPart = gfn_nvl($("#prodPart").val(), "");
        var versionId = gfn_nvl($("#planVersion").val(), "");
        
        if(prodPart != ""){
            gfn_service({
                async   : false,
                url     : GV_CONTEXT_PATH + "/biz/obj.do",
                data    : {_mtd : "getList", planId : planId, prodPart : prodPart, tranData:[
                    {outDs : "planVersion", _siq : "aps.planExecute.planVersionControl"},
                ]},
                success : function(data) {
                    
                    codeMap.PLAN_VERSION = data.planVersion;
                    
                    gfn_setMsCombo("planVersion", data.planVersion, [""]);
                    
                    if(versionId != ""){
                        $("#planVersion").val(versionId);   
                    }
                    
                    $.each(codeMap.PLAN_VERSION, function(i, val){
                        
                        var codeCd = val.CODE_CD;
                        var cutOffFlag = val.CUT_OFF_FLAG;
                        var versionTypeCd = val.VERSION_TYPE_CD;
                        
                        if(cutOffFlag == "Y" && versionTypeCd == "M"){
                            $("#planVersion option:eq("+ i +")").css("color", gv_redColor);
                            return false;
                        }
                    });
                    
                    fn_apply_customized_for_Confirm();
                    
                }
            }, "obj");
        }
        
        fn_authorityReset();
    }
    
function fn_planVersionChg_customized_for_ConfirmCancel(){
    
    var planId = $("#planId").val();
    var prodPart = gfn_nvl($("#prodPart").val(), "");
    var versionId = gfn_nvl($("#planVersion").val(), "");
    
    if(prodPart != ""){
        gfn_service({
            async   : false,
            url     : GV_CONTEXT_PATH + "/biz/obj.do",
            data    : {_mtd : "getList", planId : planId, prodPart : prodPart, tranData:[
                {outDs : "planVersion", _siq : "aps.planExecute.planVersionControl"},
            ]},
            success : function(data) {
                
                codeMap.PLAN_VERSION = data.planVersion;
                
                gfn_setMsCombo("planVersion", data.planVersion, [""]);
                
                if(versionId != ""){
                    $("#planVersion").val(versionId);   
                }
                
                $.each(codeMap.PLAN_VERSION, function(i, val){
                    
                    var codeCd = val.CODE_CD;
                    var cutOffFlag = val.CUT_OFF_FLAG;
                    var versionTypeCd = val.VERSION_TYPE_CD;
                    
                    if(cutOffFlag == "Y" && versionTypeCd == "M"){
                        $("#planVersion option:eq("+ i +")").css("color", gv_redColor);
                        return false;
                    }
                });
                
                fn_apply_customized_for_ConfirmCancel();
                
            }
        }, "obj");
    }
    
    fn_authorityReset();
}
    
    
    //Main Version 생성
    function fn_versionProd(){
        
        if(versionFlag){
            
            confirm('<spring:message code="msg.msgVersionProd"/>', function() {
                var data = [{call : "call"}];
                
                FORM_SAVE = $("#searchForm").serializeObject();
                FORM_SAVE._mtd     = "saveUpdate";
                FORM_SAVE.VERSION_TYPE_CD = areaVersionTypeCd;
                FORM_SAVE.tranData = [
                    {outDs : "saveCnt", _siq : "aps.planExecute.versionProd", grdData : data}
                ];
                
                gfn_service({
                    url     : GV_CONTEXT_PATH + "/biz/obj.do",
                    data    : FORM_SAVE,
                    success : function(data) {
                        alert('<spring:message code="msg.msgVersionProdExcute"/>');
                        fn_planVersionChg();
                    }
                }, "obj");  
            });
        }
    }
    
    //우선순위 옵션 저장
    function fn_priorityOption(){
        
        if(priorityOptionFlag){
            
            confirm('<spring:message code="msg.saveCfm"/>', function() {
                var data = [{call : "call"}];
                
                FORM_SAVE = $("#searchForm").serializeObject();
                FORM_SAVE._mtd = "saveUpdate";
                FORM_SAVE.priorityOption = $("#priorityOption").val();
                FORM_SAVE.tranData = [
                    {outDs : "saveCnt", _siq : "aps.planExecute.savePriorityOption", grdData : data}
                ];
                
                gfn_service({
                    url     : GV_CONTEXT_PATH + "/biz/obj.do",
                    data    : FORM_SAVE,
                    success : function(data) {
                        alert('<spring:message code="msg.saveOk"/>');
                        fn_planVersionChg();
                        fn_apply();
                    }
                }, "obj");  
            });
        }
    }
    
    //계획 Option 저장
    function fn_planOption(){
        
        if(planOtionFlag){
            
            confirm('<spring:message code="msg.saveCfm"/>', function() {
                var data = [{call : "call"}];
                
                FORM_SAVE = $("#searchForm").serializeObject();
                FORM_SAVE._mtd = "saveUpdate";
                FORM_SAVE.planOption = $("#planOption").val();
                FORM_SAVE.tranData = [
                    {outDs : "saveCnt", _siq : "aps.planExecute.savePlanOption", grdData : data}
                ];
                
                gfn_service({
                    url     : GV_CONTEXT_PATH + "/biz/obj.do",
                    data    : FORM_SAVE,
                    success : function(data) {
                        alert('<spring:message code="msg.saveOk"/>');
                        fn_planVersionChg();
                        fn_apply();
                        
                    }
                }, "obj");  
            });
        }
    }
    
    //선행 제약 기간 저장
    function fn_precedeLimit(){
        
        if(precedeLimitFlag){
            
            confirm('<spring:message code="msg.saveCfm"/>', function() {
                var data = [{call : "call"}];
                
                FORM_SAVE = $("#searchForm").serializeObject();
                FORM_SAVE._mtd = "saveUpdate";
                FORM_SAVE.precedeLimit = $("#precedeLimit").val();
                FORM_SAVE.tranData = [
                    {outDs : "saveCnt", _siq : "aps.planExecute.savePrecedeLimit", grdData : data}
                ];
                
                gfn_service({
                    url     : GV_CONTEXT_PATH + "/biz/obj.do",
                    data    : FORM_SAVE,
                    success : function(data) {
                        alert('<spring:message code="msg.saveOk"/>');
                        fn_planVersionChg();
                        fn_apply();
                    }
                }, "obj");  
            });
        }
    }
    
    //작업지시 생성 저장
    function fn_woReleaseWeek(){
        
        if(woReleaseWeekFlag){
            
            confirm('<spring:message code="msg.saveCfm"/>', function() {
                var data = [{call : "call"}];
                
                FORM_SAVE = $("#searchForm").serializeObject();
                FORM_SAVE._mtd = "saveUpdate";
                FORM_SAVE.woReleaseWeek = $("#woReleaseWeek").val();
                FORM_SAVE.tranData = [
                    {outDs : "saveCnt", _siq : "aps.planExecute.saveWoReleaseWeek", grdData : data}
                ];
                
                gfn_service({
                    url     : GV_CONTEXT_PATH + "/biz/obj.do",
                    data    : FORM_SAVE,
                    success : function(data) {
                        alert('<spring:message code="msg.saveOk"/>');
                        fn_planVersionChg();
                        fn_apply();
                    }
                }, "obj");  
            });
        }
    }
    
    //Main 계획 확정
    function fn_confirm(){
    	
    	
    }
    
    //계획 확정 취소
    function fn_confirmCancel(){
        
        
    }
    
    function fn_authorityReset(){
        
        var paramPlanId = $("#planId").val();
        
        $("#textPlanId").html(paramPlanId);
        $("#textProdPart").html($("#prodPart").val());
        $("#textPlanVersion").html($("#planVersion").val());
        
        $.each(codeMap.PLAN_ID, function(i, val){
            
            var valPlanId = val.PLAN_ID;
            var valStartDay = val.START_DAY;
            var valCloseDay = val.CLOSE_DAY;
            
            if(paramPlanId == valPlanId){
                
                $("#textStart").html(valStartDay);
                $("#textEnd").html(valCloseDay);
                
                return false;
            }
        });
        
        executeAFlag = false;
        
        //우선순위 옵션, 계획 option, 투입 선행 제약, 작업지시서 생성 초기화
        $("#priorityOption").val("");
        $("#planOption").val("");       
        $("#precedeLimit").val("");
        $("#woReleaseWeek").val("");
        
        versionFlag = false;
        $("#btnVersion").removeClass("app1");
        $("#btnVersion").addClass("app");
        
        planConfirmFlag = false;
        $("#btnConfirm").removeClass("app1");
        $("#btnConfirm").addClass("app");
        
        planConfirmCancelFlag = false;
        $("#btnConfirmCancel").removeClass("app1");
        $("#btnConfirmCancel").addClass("app");
        
        priorityOptionFlag = false;
        $("#savePriorityOption").removeClass("app1");
        $("#savePriorityOption").addClass("app");
        
        woReleaseWeekFlag = false;
        $("#saveWoReleaseWeek").removeClass("app1");
        $("#saveWoReleaseWeek").addClass("app");
        
        planOtionFlag = false;
        $("#savePlanOption").removeClass("app1");
        $("#savePlanOption").addClass("app");
        
        precedeLimitFlag = false;
        $("#savePrecedeLimit").removeClass("app1");
        $("#savePrecedeLimit").addClass("app");
        
        $("#priorityOption").attr("disabled", true);
        $("#planOption").attr("disabled", true);
        $("#precedeLimit").attr("disabled", true);
        $("#woReleaseWeek").attr("disabled", true);
    }
    
    //그리드필드
    function fn_setFields(provider) {
        var fields = [
            { fieldName : "INDX" , dataType : 'text' },
            { fieldName : "FR_SYS_CD" , dataType : 'text' },
            { fieldName : "TO_SYS_CD" , dataType : 'text' },
            { fieldName : "MODUAL_FLAG" , dataType : 'text' },
            { fieldName : "MODUAL_DESC" , dataType : 'text' },
            { fieldName : "RCV_FLAG" , dataType : 'text' },
            { fieldName : "RCV_DT" , dataType : 'datetime' },
            { fieldName : "IF_FLAG" , dataType : 'text' },
            { fieldName : "IF_DTTM" , dataType : 'datetime' },
            { fieldName : "INSRT_USER_ID" , dataType : 'text' },
        ];
        dataProvider2.setFields(fields);
    }

    function fn_setColumns(grd) {
        var columns = [
            {
                name         : "INDX",
                fieldName    : "INDX",
                editable     : false,
                header       : { text: '<spring:message code="lbl.seq"/>' },
                styles       : { textAlignment: "center", background : "rgba(237, 247, 253, 1)" },
                width        : 80,
                mergeRule    : { criteria: "value" }
            }, {
                name         : "FR_SYS_CD",
                fieldName    : "FR_SYS_CD",
                editable     : false,
                header       : { text: '<spring:message code="lbl.frSysCd"/>' },
                styles       : { textAlignment: "center", background : "rgba(237, 247, 253, 1)" },
                width        : 120,
                mergeRule    : { criteria: "value" }
            }, {
                name         : "TO_SYS_CD",
                fieldName    : "TO_SYS_CD",
                editable     : false,
                header       : { text: '<spring:message code="lbl.toSysCd"/>' },
                styles       : { textAlignment: "center", background : "rgba(237, 247, 253, 1)" },
                width        : 120,
                mergeRule    : { criteria: "value" }
            }, {
                name         : "MODUAL_FLAG",
                fieldName    : "MODUAL_FLAG",
                editable     : false,
                header       : { text: '<spring:message code="lbl.modualFlag"/>' },
                styles       : { textAlignment: "center", background : "rgba(237, 247, 253, 1)" },
                width        : 120,
                mergeRule    : { criteria: "value" }
            }, {
                name         : "MODUAL_DESC",
                fieldName    : "MODUAL_DESC",
                editable     : false,
                header       : { text: '<spring:message code="lbl.modualDesc"/>' },
                styles       : { textAlignment: "center", background : "rgba(237, 247, 253, 1)" },
                width        : 120,
                mergeRule    : { criteria: "value" }
            }, {
                name         : "RCV_FLAG",
                fieldName    : "RCV_FLAG",
                editable     : false,
                header       : { text: '<spring:message code="lbl.rcvFlag"/>' },
                styles       : { textAlignment: "center", background : "rgba(237, 247, 253, 1)" },
                width        : 120,
                mergeRule    : { criteria: "value" }
            }, {
                name         : "RCV_DT",
                fieldName    : "RCV_DT",
                editable     : false,
                header       : { text: '<spring:message code="lbl.rcvDt"/>' },
                styles       : {textAlignment: "center", background : "rgba(237, 247, 253, 1)", datetimeFormat : "yyyy-MM-dd HH:mm:ss"},
                width        : 120,
                mergeRule    : { criteria: "value" }
            }, {
                name         : "IF_FLAG",
                fieldName    : "IF_FLAG",
                editable     : false,
                header       : { text: '<spring:message code="lbl.ifFlag"/>' },
                styles       : { textAlignment: "center", background : "rgba(237, 247, 253, 1)" },
                width        : 120,
                mergeRule    : { criteria: "value" }
            }, {
                name         : "IF_DTTM",
                fieldName    : "IF_DTTM",
                editable     : false,
                header       : { text: '<spring:message code="lbl.ifDttm"/>' },
                styles       : {textAlignment: "center", background : "rgba(237, 247, 253, 1)", datetimeFormat : "yyyy-MM-dd HH:mm:ss"},
                width        : 120,
                mergeRule    : { criteria: "value" }
            }, {
                name         : "INSRT_USER_ID",
                fieldName    : "INSRT_USER_ID",
                editable     : false,
                header       : { text: '<spring:message code="lbl.insertUserId"/>' },
                styles       : { textAlignment: "center", background : "rgba(237, 247, 253, 1)" },
                width        : 120,
                mergeRule    : { criteria: "value" }
            }
        ];
        grdMain2.setColumns(columns);
    }
    
    function fn_getExcelData(){
        
        $.each($(".view_combo"), function(i, val){
            
            var temp = "";
            var id = gfn_nvl($(this).attr("id"), "");
            
            if(id != ""){
                
                var name = gfn_nvl($("#" + id + " .ilist .itit").html(), "");
                
                //타이틀
                if(i == 0){
                    EXCEL_SEARCH_DATA = name;
                }else{
                    EXCEL_SEARCH_DATA += "\n" + name + " : ";   
                } 
                    
                if(id == "divWeeklyDaily"){
                    var weeklyDaily = $('input[name="weeklyDaily"]:checked').val();
                    
                    if(weeklyDaily == "MP"){
                        EXCEL_SEARCH_DATA += '<spring:message code="lbl.weekly"/>';
                    }else if(weeklyDaily == "FP"){
                        EXCEL_SEARCH_DATA += '<spring:message code="lbl.daily"/>';
                    }
                }else if(id == "divPlanId"){
                    EXCEL_SEARCH_DATA += $("#planId option:selected").text();
                }else if(id == "divProdPart"){
                    EXCEL_SEARCH_DATA += $("#prodPart option:selected").text();
                }else if(id == "divPlanVersion"){
                    EXCEL_SEARCH_DATA += $("#planVersion option:selected").text();
                }
            }
        });
    
    }
    
    function fn_DoubleClickEvent(grid, index)
    {
        
        var objData = grid.getDataProvider();
        var rowId = index.dataRow;
        var field = index.fieldName ;
        var itemIndex = index.itemIndex;
        var data = grid.getValue(itemIndex, field + "_HD");
        
        if(field == "EXEC_YN_NM" && data == "Y"){
            
            var resultAFlag = false;
            
            if(executeAFlag){
                
                if(rowId == 0){ //맨처음 실행 버튼
                    resultAFlag = true; 
                }else{
                    
                    var resultCnt = 0;
                    
                    for(var i = 0; i  < rowId; i++){
                        var cbStartCd = grid.getValue(i, "CB_STATUS_CD");
                        if(cbStartCd == "C"){
                            resultCnt++;
                        }
                    }
                    
                    if(resultCnt == rowId){
                        resultAFlag = true; 
                    }
                }
                
                if(resultAFlag){
                    
                    var pCompanyCd = grid.getValue(itemIndex, "COMPANY_CD");
                    var pBuCd = grid.getValue(itemIndex, "BU_CD");
                    var pPlanId = grid.getValue(itemIndex, "PLAN_ID");
                    var pProdPart = grid.getValue(itemIndex, "PROD_PART");
                    var pVersionId = grid.getValue(itemIndex, "VERSION_ID"); 
                    var pcbTaskCd = grid.getValue(itemIndex, "CB_TASK_CD");
                    var pcbTaskCdNm = grid.getValue(itemIndex, "CB_TASK_CD_NM");
                    
                    FORM_SAVE          = {}; //초기화
                    FORM_SAVE._mtd     = "getList";
                    FORM_SAVE.COMPANY_CD = pCompanyCd;
                    FORM_SAVE.BU_CD = pBuCd;
                    FORM_SAVE.PLAN_ID = pPlanId;
                    FORM_SAVE.PROD_PART = pProdPart;
                    FORM_SAVE.VERSION_ID = pVersionId;
                    FORM_SAVE.CB_TASK_CD = pcbTaskCd;
                    FORM_SAVE.VERSION_TYPE_CD = areaVersionTypeCd;
                    
                    FORM_SAVE.tranData = [
                        {outDs : "checkCnt", _siq : "aps.planExecute.executeACallCheck"}
                    ];
                             
                    gfn_service({
                        url     : GV_CONTEXT_PATH + "/biz/obj.do",
                        data    : FORM_SAVE,
                        success : function(data) {
                            
                            //해당 Version의 version_type_cd의 전체가  cutOffFlag = 'N' 일경우 한번 더 체크(실시간)
                            var successCnt = data.checkCnt[0].CHECK_CNT;
                            
                            if(successCnt == 0){
                                
                                confirm('<spring:message code="msg.msgExcuteA"/>', function() {
                                    
                                    FORM_SAVE.tranData = [
                                        {outDs : "saveCnt", _siq : "aps.planExecute.executeACall"}
                                    ];
                                    
                                    gfn_service({
                                        url     : GV_CONTEXT_PATH + "/biz/obj.do",
                                        data    : FORM_SAVE,
                                        success : function(data) {
                                            
                                            var msgCode = data.saveCnt[0];
                                            
                                            if(msgCode == 0){
                                                alert(pcbTaskCdNm + ' <spring:message code="msg.msgExcuteCode0"/>');
                                                fn_apply();
                                            }else if(msgCode == 1){
                                                alert('<spring:message code="msg.systemError"/>');
                                            }else if(msgCode == 2){
                                                alert('<spring:message code="msg.planIng"/>');
                                            }
                                            
                                            if(msgCode == 0){
                                                
                                                if(pProdPart == "TEL"){
                                                    planIntervalTelData = {company : pCompanyCd, buCd : pBuCd, planId : pPlanId, prodPart : pProdPart, versionId : pVersionId, rowId : (rowId + 1)};
                                                    
                                                    planIntervalTel = setInterval(function(){
                                                        planExcuteInterval(planIntervalTelData);
                                                    }, 60000);
                                                }else if(pProdPart == "LAM"){
                                                    planIntervalLamData = {company : pCompanyCd, buCd : pBuCd, planId : pPlanId, prodPart : pProdPart, versionId : pVersionId, rowId : (rowId + 1)};
                                                    
                                                    planIntervalLam = setInterval(function(){
                                                        planExcuteInterval(planIntervalLamData);
                                                    }, 60000);
                                                }else if(pProdPart == "DIFFUSION"){
                                                    planIntervalDiffData = {company : pCompanyCd, buCd : pBuCd, planId : pPlanId, prodPart : pProdPart, versionId : pVersionId, rowId : (rowId + 1)};
                                                    
                                                    planIntervalDiff = setInterval(function(){
                                                        planExcuteInterval(planIntervalDiffData);
                                                    }, 60000);
                                                }else if(pProdPart == "MATERIAL"){
                                                    planIntervalMatData = {company : pCompanyCd, buCd : pBuCd, planId : pPlanId, prodPart : pProdPart, versionId : pVersionId, rowId : (rowId + 1)};
                                                    
                                                    planIntervalMat = setInterval(function(){
                                                        planExcuteInterval(planIntervalMatData);
                                                    }, 60000);
                                                }
                                            } 
                                        }
                                    }, "obj");  
                                });
                            }else{
                                alert('<spring:message code="msg.planNoExcute"/>');
                            }
                        }
                    }, "obj");  
                }else{
                    alert('<spring:message code="msg.planNoExcute"/>');
                }
            }else{
                alert('<spring:message code="msg.planNoExcute"/>');
            }
        }
    	
    	
    	
    }
    
    
    </script>
</head>
<body id="framesb">
    <%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
    <!-- left -->
    <div id="a" class="split split-horizontal">
        <form id="searchForm" name="searchForm">
            <div id="filterDv">
                <div class="inner">
                    <h3>Filter</h3>
                     
                    <div class="tabMargin"></div>
                    <div class="scroll">
                        <div class="view_combo" id="divWeeklyDaily">
                            <strong class="filter_tit"></strong>
                            <ul class="rdofl">
                                <li><input type="radio" id="weeklyDaily1" name="weeklyDaily" value="MP" checked="checked""><label for="weeklyDaily1"><spring:message code="lbl.weekly"/></label></li>
                                <li><input type="radio" id="weeklyDaily2" name="weeklyDaily" value="FP"><label for="weeklyDaily2"><spring:message code="lbl.daily"/></label></li>
                            </ul>
                        </div>
                        <div class="view_combo" id="divPlanId"></div>
                        <div class="view_combo" id="divProdPart"></div>
                        <div class="view_combo" id="divPlanVersion"></div>
                        <div class="view_combo">
                            <div class="ilist" style="overflow: visible;float:right;">
                                <a href="javascript:;" id="btnVersion" class="app roleWrite"><spring:message code="lbl.versionProd" /></a>
                            </div>
                        </div>
                        <div class="view_combo">
                            <ul><spring:message code="lbl.curPlanId" />
                                <li>
                                    <spring:message code="lbl.planId" /> : <span id="textPlanId"></span>
                                </li>
                                <li>
                                    <spring:message code="lbl.prodPart2" /> : <span id="textProdPart"></span>
                                </li>
                                <li>
                                    <spring:message code="lbl.planVersion" /> : <span id="textPlanVersion"></span>
                                </li>
                                <li>
                                    <spring:message code="lbl.planHorizon" /> 
                                    <br/> 
                                    <spring:message code="lbl.start" /> : <span id="textStart"></span>
                                    <br/>
                                    <spring:message code="lbl.end" /> : <span id="textEnd"></span>
                                </li>
                            </ul>
                        </div>
                        
                        <div class="view_combo">
                            <div class="ilist" style="overflow: visible;">
                                <div class="itit"><spring:message code="lbl.priorityOption" /></div>
                                <div class="iptdv borNone" style="float:right;">
                                    <select id="priorityOption" name="priorityOption" style="width:100px;" disabled="disabled"></select>
                                    <a href="javascript:;" id="savePriorityOption" class="app roleWrite"><spring:message code="lbl.save" /></a>
                                </div>
                            </div>
                        </div>
                        
                        <div class="view_combo">
                            <div class="ilist" style="overflow: visible;">
                                <div class="itit"><spring:message code="lbl.planOption" /></div>
                                <div class="iptdv borNone" style="float:right;">
                                    <select id="planOption" name="planOption" style="width:100px;" disabled="disabled"></select>
                                    <a href="javascript:;" id="savePlanOption" class="app roleWrite"><spring:message code="lbl.save" /></a>
                                </div>
                            </div>
                        </div>
                        
                        <div class="view_combo">
                            <div class="ilist" style="overflow: visible;">
                                <div class="itit"><spring:message code="lbl.precedProdLimit" /></div>
                                <div class="iptdv borNone" style="float:right;">
                                    <select id="precedeLimit" name="precedeLimit" style="width:100px;" disabled="disabled"></select>
                                    <a href="javascript:;" id="savePrecedeLimit" class="app roleWrite"><spring:message code="lbl.save" /></a>
                                </div>
                            </div>
                        </div>
                        
                        <div class="view_combo">
                            <div class="ilist" style="overflow: visible;">
                                <div class="itit"><spring:message code="lbl.woReleaseWeek" /></div>
                                <div class="iptdv borNone" style="float:right;">
                                    <select id="woReleaseWeek" name="woReleaseWeek" style="width:100px;" disabled="disabled"></select>
                                    <a href="javascript:;" id="saveWoReleaseWeek" class="app roleWrite"><spring:message code="lbl.save" /></a>
                                </div>
                            </div>
                        </div>
                        
                        <div class="view_combo">
                            <div class="ilist">
                                <div class="itit"><spring:message code="lbl.masterIf"/></div>
                                <input type="text" id="searchCal" name="searchCal" class="iptdate datepicker2" value="">
                                <input type="text" id="searchWeek" name="searchWeek" class="iptdateweek" disabled="disabled" value="">
                            </div>
                        </div>
                        
                    </div>
                    <div class="bt_btn">
                        <a href="#;return false;" class="fl_app"><spring:message code="lbl.search"/></a>
                    </div>
                </div>
            </div>
        </form>
        <!-- </div> -->
    </div>
    <!-- contents -->
    <div id="b" class="split split-horizontal">
        <!-- contents 상 -->
        <div id="e" class="split content" style="border:0;background:transparent;">
            <div id="grid1" class="fconbox">
                <%@ include file="/WEB-INF/view/common/commonLocation.jsp" %>
                <div class="use_tit">
                    <h3><spring:message code="lbl.planAction"/></h3>
                </div>
                <div class="scroll">
                    <!-- 그리드영역 -->
                    <div id="realgrid" class="realgrid1" style="width: 100%; height: 300px;"></div>
                </div>
                <div class="cbt_btn">
                    <div class="bright">
                        <a href="javascript:;" id="btnConfirm" class="app roleWrite"><spring:message code="lbl.planConfirm" /></a>
                        <a href="javascript:;" id="btnConfirmCancel" class="app roleWrite"><spring:message code="lbl.planConfirmCancel" /></a>
                    </div>
                </div>
            </div>
        </div>
        <!-- contents 하 -->
        <div id="f" class="split content" style="border:0;background:transparent;">
            <div id="grid2" class="fconbox">
                <div class="use_tit">
                    <h3><spring:message code="lbl.masterIf"/></h3>
                </div>
                <div class="scroll">
                    <!-- 그리드영역 -->
                    <div id="realgrid2" class="realgrid1" style="width: 100%; height: 300px;"></div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
