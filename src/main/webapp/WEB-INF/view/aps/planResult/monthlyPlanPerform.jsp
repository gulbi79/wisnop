<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
<script type="text/javascript">
    var enterSearchFlag = "Y";
    var codeMap;
    var codeMapEx;
    var datePickerOption;
    var gridInstance, grdMain, dataProvider;
    var objToday;
    
	$(function(){
		gfn_formLoad();
		fn_initCode();            
		fn_initFilter();
		fn_initGrid();
		fn_initEvent();
		
		$("#fromCal").attr("disabled", true);
		$("#toCal").attr("disabled", true)
	});
    
    
    function fn_initCode()
    {
    	 //콤보박스 셋팅
    	 var grpCd = 'MONTH_TYPE_MINUS,MONTH_TYPE_PLUS,ITEM_TYPE,CHANGE_AREA,PROCUR_TYPE,DAILY_CD,SALE_QA_TYPE,PROD_PART';
         codeMap = gfn_getComCode(grpCd, 'Y'); //공통코드 조회
         codeMapEx = gfn_getComCodeEx(["REP_CUST_GROUP", "CUST_GROUP", "UPPER_ITEM_GROUP", "ITEM_GROUP", "ROUTING"], null, {itemType : "10,20" });      //공통코드
         
         codeMap.PROCUR_TYPE = $.grep(codeMap.PROCUR_TYPE, function(v,n) {
             return v.CODE_CD == 'MG' || v.CODE_CD == 'MH'; 
         });
         
        /*  codeMap.ITEM_TYPE = $.grep(codeMap.ITEM_TYPE, function(v,n) {
             return v.CODE_CD == '10' || v.CODE_CD == '20' || v.CODE_CD == '50'; 
         }); */
         
         gfn_service({
             async   : false,
             url     : GV_CONTEXT_PATH + "/biz/obj",
             data    : {_mtd : "getList", menuParam : "CFM", tranData:[
                        {outDs : "planIdPast", _siq : "dp.planMonth.planIdPast"}, 
                        {outDs:"currentWeek" ,_siq:"dp.planCommon.currentWeek"},
                        {outDs:"planList"    ,_siq:"dp.planMonth.planConfirmationVersion"},
                        {outDs:"today"    ,_siq:"aps.planResult.getToday"},
                         
             ]},
             success : function(data) {
                 codeMap.PLAN_ID_PAST = data.planIdPast;
                 codeMap.CURRENT_WEEK = data.currentWeek;
                 codeMap.PLAN_INFO = data.planList[0];
                 objToday = data.today[0];
             }
         }, "obj");
    }
    
    function fn_initFilter()
    {
        var itemTypeEvent = {
                 childId   : ["upItemGroup","route"],  
                 childData : [codeMapEx.UPPER_ITEM_GROUP, codeMapEx.ROUTING]
                 
             };
             
        //품목대그룹
        var upperItemEvent = {
            childId   : ["itemGroup"],
            childData : [codeMapEx.ITEM_GROUP],
        };
        
        // 키워드팝업
        gfn_keyPopAddEvent([
            { target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>' }
        ]);
        
        // 콤보박스
        gfn_setMsComboAll([
            {target : 'divProcurType',   id : 'procurType',    title : '<spring:message code="lbl.procure"/>',        data : codeMap.PROCUR_TYPE, exData:[""]},
            {target : 'divItemType',     id : 'itemType',      title : '<spring:message code="lbl.itemType"/>',       data : codeMap.ITEM_TYPE, exData:["*"], event : itemTypeEvent},
            {target : 'divUpItemGroup',  id : 'upItemGroup',   title : '<spring:message code="lbl.upperItemGroup"/>', data : codeMapEx.UPPER_ITEM_GROUP, exData:["*"], event: upperItemEvent },
            {target : 'divItemGroup',    id : 'itemGroup',     title : '<spring:message code="lbl.itemGroup"/>',      data : codeMapEx.ITEM_GROUP, exData:["*"]},
            {target : 'divRoute',        id : 'route',         title : '<spring:message code="lbl.routing"/>',        data : codeMapEx.ROUTING, exData:["*"]},
            {target : 'divRepCustGroup', id : 'reptCustGroup', title : '<spring:message code="lbl.reptCustGroup"/>',  data : codeMapEx.REP_CUST_GROUP, exData:["*"]},
            {target : 'divCustGroup',    id : 'custGroup',     title : '<spring:message code="lbl.custGroup"/>',      data : codeMapEx.CUST_GROUP, exData:["*"]},
            {target : 'divProdPart',     id : 'prodPart',      title : '<spring:message code="lbl.prodPart2"/>',      data : codeMap.PROD_PART, exData:[""]},
            {target : 'divPlanIdPast',   id : 'planIdPast',    title : '<spring:message code="lbl.planId"/>',               data : codeMap.PLAN_ID_PAST, exData:[''],    type : "S" },
            {target : 'divAmtQty',       id : 'amtQty',     title : '<spring:message code="lbl.quantityAmountPart"/>',   data : codeMap.SALE_QA_TYPE, exData:[""],    type : "R"},
        ]);
        
        //달력
        datePickerOption = DATEPICKET(null, codeMap.PLAN_INFO.MIN_DATE.split("-").join(""), codeMap.PLAN_INFO.MAX_DATE.split("-").join(""));
        
        $("#itemType").multipleSelect("setSelects", ["10"]);
        $(':radio[name=amtQty]:input[value="QTY"]').attr("checked", true);
    }
    
    function fn_initGrid()
    {   
        gridInstance = new GRID();
        gridInstance.init("realgrid");
       
        grdMain      = gridInstance.objGrid;
        dataProvider = gridInstance.objData;
       
        gridInstance.custNextBucketFalg = true;
       
        grdMain.setOptions({
            stateBar: { visible : true }
        });

        dataProvider.setOptions({
            softDeleting : true
        });
        
        grdMain.addCellStyles([{
            id         : "editStyle",
            editable   : true,
            background : gv_editColor
        }]);
        
        gfn_setMonthSum(gridInstance, false, false, true);
    }
    
    function fn_initEvent()
    {
    	//조회버튼 클릭 이벤트
        $("#btnSearch").on("click", function(e) {
             fn_apply(false);
        });
         
        $("#planIdPast").change("on", function(){
             var tPlanIdPast = $("#planIdPast").val();
             $.each(codeMap.PLAN_ID_PAST, function(n, v){
                 
                 var tempVal = v.CODE_CD;
                 var tStartDay = v.START_DAY.substring(0, 4) + "-" + v.START_DAY.substring(4, 6) + "-" + v.START_DAY.substring(6, 8);
                 var tEndDay = v.END_DAY.substring(0, 4) + "-" + v.END_DAY.substring(4, 6) + "-" + v.END_DAY.substring(6, 8);
                 var tStartWeek = v.START_WEEK;
                 var tEndWeek = v.END_WEEK;
                 var tDimWeek = v.DIM_WEEK;
                 var tPartADimWeek = v.PART_A_DIM_WEEK;
                 var tPartBDimWeek = v.PART_B_DIM_WEEK;
                 var tQtyDate = v.QTY_DATE;
                 var tStartRemains = v.START_REMAINS;
                 var tEndRemains = v.END_REMAINS;
                 var tMinLastDate = v.MIN_LAST_DATE;
                 var tMaxLastDate = v.MAX_LAST_DATE;
                 var tStartMonth = v.START_MONTH;
                 
                 if(tPlanIdPast == tempVal)
                 {
                     $("#fromCal").datepicker("option", "minDate", tMinLastDate);
                     $("#toCal").datepicker("option", "maxDate", tMaxLastDate);
                     
                     $("#fromCal").val(tStartDay);
                     var tmpV = gfn_getFindDataDsInDs(datePickerOption.arrTarget, {calId : {VALUE : "fromCal", CONDI : "="}});
                     gfn_onSelectFn(tmpV[0], tStartDay);
                     
                     $("#toCal").val(tEndDay);       
                     var tmpV = gfn_getFindDataDsInDs(datePickerOption.arrTarget, {calId : {VALUE : "toCal", CONDI : "="}});
                     gfn_onSelectFn(tmpV[0], tEndDay);   
                 }
             });
        });
    }

    function fn_apply(sqlFlag) 
    {
        gfn_getMenuInit();
        
        FORM_SEARCH         = $("#searchForm").serializeObject(); 
        FORM_SEARCH.sql     = sqlFlag;
        FORM_SEARCH.dimList = DIMENSION.user;
        
        fn_getBucket(sqlFlag); 
        fn_search();
        fn_excel();
       // dailyProdPlan.excelSubSearch();
    }
    
    function fn_excel()
    {
    	$.each($(".view_combo"), function(i, val){
            
            var temp = "";
            var id = gfn_nvl($(this).attr("id"), "");
            
            if(id != ""){
                
                var name = $("#" + id + " .ilist .itit").html();
                if(id == "divAmtQty")
                	name = "금액수량구분"
                
                //타이틀
                if(i == 0){
                    EXCEL_SEARCH_DATA = name + " : ";   
                }else{
                    EXCEL_SEARCH_DATA += "\n" + name + " : ";   
                }
                
                if(id == "divItem"){
                    EXCEL_SEARCH_DATA += $("#divItem").val();
                }
                else if(id == "divProcurType"){
                    $.each($("#divProcurType option:selected"), function(i2, val2){
                        
                        var txt = gfn_nvl($(this).text(), "");
                        
                        if(i2 == 0){
                            temp = txt;                             
                        }else{
                            temp += ", " + txt;
                        }
                    });     
                    EXCEL_SEARCH_DATA += temp;
                }
                else if(id == "divItemType"){
                    $.each($("#divItemType option:selected"), function(i2, val2){
                        
                        var txt = gfn_nvl($(this).text(), "");
                        
                        if(i2 == 0){
                            temp = txt;                             
                        }else{
                            temp += ", " + txt;
                        }
                    });     
                    EXCEL_SEARCH_DATA += temp;
                }
                else if(id == "divUpItemGroup"){
                    $.each($("#divUpItemGroup option:selected"), function(i2, val2){
                        
                        var txt = gfn_nvl($(this).text(), "");
                        
                        if(i2 == 0){
                            temp = txt;                             
                        }else{
                            temp += ", " + txt;
                        }
                    });     
                    EXCEL_SEARCH_DATA += temp;
                }
                else if(id == "divItemGroup"){
                    $.each($("#divItemGroup option:selected"), function(i2, val2){
                        
                        var txt = gfn_nvl($(this).text(), "");
                        
                        if(i2 == 0){
                            temp = txt;                             
                        }else{
                            temp += ", " + txt;
                        }
                    });     
                    EXCEL_SEARCH_DATA += temp;
                }
                else if(id == "divRoute"){
                    $.each($("#divRoute option:selected"), function(i2, val2){
                        
                        var txt = gfn_nvl($(this).text(), "");
                        
                        if(i2 == 0){
                            temp = txt;                             
                        }else{
                            temp += ", " + txt;
                        }
                    });     
                    EXCEL_SEARCH_DATA += temp;
                }
                else if(id == "divRepCustGroup"){
                    $.each($("#divRepCustGroup option:selected"), function(i2, val2){
                        
                        var txt = gfn_nvl($(this).text(), "");
                        
                        if(i2 == 0){
                            temp = txt;                             
                        }else{
                            temp += ", " + txt;
                        }
                    });     
                    EXCEL_SEARCH_DATA += temp;
                }
                else if(id == "divCustGroup"){
                    $.each($("#divCustGroup option:selected"), function(i2, val2){
                        
                        var txt = gfn_nvl($(this).text(), "");
                        
                        if(i2 == 0){
                            temp = txt;                             
                        }else{
                            temp += ", " + txt;
                        }
                    });     
                    EXCEL_SEARCH_DATA += temp;
                }
                else if(id == "divPlanIdPast"){
                    EXCEL_SEARCH_DATA += $("#divPlanIdPast option:selected").text();
                }
                else if(id == "divPlanIdPast"){
                    EXCEL_SEARCH_DATA += $("#divPlanIdPast option:selected").text();
                }
                else if(id == "divAmtQty"){
                	if($(':radio[name="amtQty"]:checked').val() == "QTY") 
                	    EXCEL_SEARCH_DATA += "수량"
                	else
                		EXCEL_SEARCH_DATA += "금액"
                }
                
                
                
            }
        });
    }
    
    function fn_getBucket(sqlFlag) 
    {
    	var strFromDate = $("#fromCal").val().replace("-", "");
        var strToDate   =$("#toCal").val().replace("-", "");
    	
    	var ajaxMap = {
                fromDate : strFromDate,
                toDate   : strToDate,
                week     : {isDown: "Y", isUp:"N", upCal:"M", isMt:"N", isExp:"N", expCnt:1},
                day      : {isDown: "N", isUp:"Y", upCal:"W", isMt:"N", isExp:"N", expCnt:999}, 
                sqlId    : ["bucketWeek"]
        };
            
        gfn_getBucket(ajaxMap);
        
        
        var bucketLen = BUCKET.query.length;
        for(var i = 0; i < bucketLen; i++){
        	BUCKET.query[i].SALES_QTY = "SALES_"+ BUCKET.query[i].BUCKET_VAL + "_QTY"
            BUCKET.query[i].SALES_AMT = "SALES_"+ BUCKET.query[i].BUCKET_VAL + "_AMT"
            BUCKET.query[i].PROD_QTY = "PROD_"+ BUCKET.query[i].BUCKET_VAL + "_QTY"
            BUCKET.query[i].PROD_AMT = "PROD_"+ BUCKET.query[i].BUCKET_VAL + "_AMT"
        } 
        
        FORM_SEARCH.bucketList = BUCKET.query; 
        
        if (!sqlFlag) {
            BUCKET.all[0] = null;
            gridInstance.setDraw();
            
            
        }  
    }
    
    function fn_search()
    {
        FORM_SEARCH._mtd     = "getList";
        FORM_SEARCH.tranData = [{ outDs : "resList", _siq : "aps.planResult.monthlyPlanPerform"}];
        console.log("FORM_SEARCH:",FORM_SEARCH);
        var aOption = {
            url     : GV_CONTEXT_PATH + "/biz/obj",
            data    : FORM_SEARCH,
            success : function (data) {
                if (FORM_SEARCH.sql == 'N') {
                    dataProvider.clearRows(); //데이터 초기화
            
                    //그리드 데이터 생성
                    grdMain.cancel();
                    
                    dataProvider.setRows(data.resList);
                    dataProvider.clearSavePoints();
                    dataProvider.savePoint(); //초기화 포인트 저장
                    gfn_actionMonthSum(gridInstance);
                    gfn_setRowTotalFixed(grdMain);
                }
            }
        }
        gfn_service(aOption, "obj");
    }
    
    function fn_setNextFieldsBuket() {
        var fields = [
            {fieldName: "SALES_PRICE_KRW", dataType : "number"},
            
            {fieldName: "CFM_SP_QTY", dataType : "number"},
            {fieldName: "CFM_SP_AMT", dataType : "number"},
            {fieldName: "SALES_WEEK_REMAIN_QTY", dataType : "number"},
            {fieldName: "SALES_ACCUM_SALES_QTY", dataType : "number"},
            {fieldName: "SALES_ACCUM_SALES_AMT", dataType : "number"},
            {fieldName: "SALES_ACCUM_PRG_RATE", dataType : "number"},
            {fieldName: "SALES_OVER_SHORT", dataType : "number"},
            {fieldName: "SALES_CUR_MONTH_SALES_QTY", dataType : "number"},
            {fieldName: "SALES_CUR_MONTH_SALES_AMT", dataType : "number"},
            {fieldName: "SALES_EXPACT_TARGET_RATE", dataType : "number"},
            {fieldName: "SALES_EXPACT_OVER_AMT", dataType : "number"},
            
            //20210929 김수호 추가: 계획 내 예상 출하 금액 컬럼, 출하 예상준수율
            {fieldName: "ESTIMATED_SALES_AMT_IN_PLAN", dataType : "number"},
            {fieldName: "EXPECT_SALES_CPL_RATE", dataType : "number"},
            
            
            {fieldName: "PROD_PLAN_QTY", dataType : "number"},
            {fieldName: "PROD_PLAN_AMT", dataType : "number"},
            {fieldName: "PROD_PRE_PRODUCTION_QTY", dataType : "number"},
            {fieldName: "PROD_WEEK_REMAIN_QTY", dataType : "number"},
            {fieldName: "PROD_ACCUM_PROD_QTY", dataType : "number"},
            {fieldName: "PROD_ACCUM_PROD_AMT", dataType : "number"},
            {fieldName: "PROD_ACCUM_PRG_RATE", dataType : "number"},
            {fieldName: "PROD_OVER_SHORT", dataType : "number"},
            {fieldName: "PROD_CUR_MONTH_PROD_QTY_RES", dataType : "number"},
            {fieldName: "PROD_CUR_MONTH_PROD_AMT_RES", dataType : "number"},
            {fieldName: "PROD_EXPACT_PRG_RATE", dataType : "number"},
            {fieldName: "PROD_EXPACT_OVER_AMT", dataType : "number"},
            {fieldName: "PROD_CUR_MONTH_PROD_END_QTY", dataType : "number"},
            
            //20210929 김수호 추가: 계획 내 예상 생산 금액 컬럼, 생산 예상준수율
            {fieldName: "ESTIMATED_PROD_AMT_IN_PLAN", dataType : "number"},
            {fieldName: "EXPECT_PROD_CPL_RATE", dataType : "number"},
            
        ];
        
        for(var i=0; i < FORM_SEARCH.bucketList.length; i++){
            var obj = new Object();
            var strFieldNm = "";
            
            strFieldNm = "SALES_" + FORM_SEARCH.bucketList[i].NM + "_QTY"
            obj = {fieldName: strFieldNm, dataType : "number"},
            fields.push(obj)
            
            strFieldNm = "SALES_" + FORM_SEARCH.bucketList[i].NM + "_AMT"
            obj = {fieldName: strFieldNm, dataType : "number"},
            fields.push(obj)
            
            strFieldNm = "PROD_" + FORM_SEARCH.bucketList[i].NM + "_QTY"
            obj = {fieldName: strFieldNm, dataType : "number"},
            fields.push(obj)
            
            strFieldNm = "PROD_" + FORM_SEARCH.bucketList[i].NM + "_AMT"
            obj = {fieldName: strFieldNm, dataType : "number"},
            fields.push(obj)
        }
        
        return fields;
    }

    function fn_setNextColumnsBuket() 
    {
        var columns = [ 
            {
                name : "SALES_PRICE_KRW", fieldName: "SALES_PRICE_KRW", editable: false, header: {text: '<spring:message code="lbl.salesPrice" javaScriptEscape="true" />'},
                styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
                dynamicStyles : [gfn_getDynamicStyle(-2)],
                dataType : "number",
                width: 80
            }, 
            {
                type: "group",
                name: '<spring:message code="lbl.sales" javaScriptEscape="true" />',
                header: {text : '<spring:message code="lbl.sales"/>' + gv_expand },
                fieldName: "SALES_GROUP",
                width: 1500,
                columns : [
                    {   //출하계획 확정수량
                        name : "CFM_SP_QTY", fieldName: "CFM_SP_QTY", editable: false, header: {text: '<spring:message code="lbl.cfmSpQty" javaScriptEscape="true" />'},
                        styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
                        dynamicStyles : [gfn_getDynamicStyle(-2)],
                        dataType : "number",
                        width: 200
                    }, 
                    {   //출하계획 확정금액
                        name : "CFM_SP_AMT", fieldName: "CFM_SP_AMT", editable: false, header: {text: '<spring:message code="lbl.cfmSpAmt" javaScriptEscape="true" />'},
                        styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
                        dynamicStyles : [gfn_getDynamicStyle(-2)],
                        dataType : "number",
                        width: 200
                    }, 
                ]
            },
            {
                type: "group",
                name: '<spring:message code="lbl.prod" javaScriptEscape="true" />',
                header: {text : '<spring:message code="lbl.prod"/>' + gv_expand },
                fieldName: "PROD_GROUP",
                width: 1500,
                columns : [
                    {   //생산계획수량
                        name : "PROD_PLAN_QTY", fieldName: "PROD_PLAN_QTY", editable: false, header: {text: '<spring:message code="lbl.prodPlanQty3" javaScriptEscape="true" />'},
                        styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
                        dynamicStyles : [gfn_getDynamicStyle(-2)],
                        dataType : "number",
                        width: 200
                    }, 
                    {   //생산계획금액
                        name : "PROD_PLAN_AMT", fieldName: "PROD_PLAN_AMT", editable: false, header: {text: '<spring:message code="lbl.prodPlanAmt" javaScriptEscape="true" />'},
                        styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
                        dynamicStyles : [gfn_getDynamicStyle(-2)],
                        dataType : "number",
                        width: 200
                    }, 
                ]
            },
        ];
        
        for(var i=0; i < FORM_SEARCH.bucketList.length; i++){
            var objCol = new Object();
            
            var strFieldNm = "SALES_" + FORM_SEARCH.bucketList[i].NM + "_" + $(':radio[name="amtQty"]:checked').val();          //AMT OR QTY
            var strWeek = FORM_SEARCH.bucketList[i].NM;
            
            objCol = {
                    name : strFieldNm, fieldName: strFieldNm, editable: false, header: {text: FORM_SEARCH.bucketList[i].NM},
                    styles: {textAlignment: "far", numberFormat : "#,##0", background : strWeek > objToday.YEARPWEEK ? gv_whiteColor : gv_noneEditColor},
                    dynamicStyles : [gfn_getDynamicStyle(-2)],
                    dataType : "number",
                    width: 200
            }
            columns[1].columns.push(objCol)
        }
        
        //당주잔량
        columns[1].columns.push({name : "SALES_WEEK_REMAIN_QTY", fieldName: "SALES_WEEK_REMAIN_QTY", editable: false, header: {text: '<spring:message code="lbl.weekRemain" javaScriptEscape="true" />'},
                                 styles: {textAlignment: "far", background : gv_whiteColor, numberFormat : "#,##0"},
                                 dynamicStyles : [gfn_getDynamicStyle(-2)], dataType : "number", width: 140});
        //누적출하수량
        columns[1].columns.push({name : "SALES_ACCUM_SALES_QTY", fieldName: "SALES_ACCUM_SALES_QTY", editable: false, header: {text: '<spring:message code="lbl.accumSalesQty" javaScriptEscape="true" />'},
                                 styles: {textAlignment: "far", background : gv_whiteColor, numberFormat : "#,##0"},
                                 dynamicStyles : [gfn_getDynamicStyle(-2)], dataType : "number",width: 160});
        //누적출하금액
        columns[1].columns.push({name : "SALES_ACCUM_SALES_AMT", fieldName: "SALES_ACCUM_SALES_AMT", editable: false, header: {text: '<spring:message code="lbl.accumSalesAmt" javaScriptEscape="true" />'},
                                 styles: {textAlignment: "far", background : gv_whiteColor, numberFormat : "#,##0"},
                                 dynamicStyles : [gfn_getDynamicStyle(-2)], dataType : "number", width: 160});
        
        //누적진척률(%)
        columns[1].columns.push({name : "SALES_ACCUM_PRG_RATE", fieldName: "SALES_ACCUM_PRG_RATE", editable: false, header: {text: '<spring:message code="lbl.accumPrgRate" javaScriptEscape="true" />'},
                                 styles: {textAlignment: "far", background : gv_whiteColor, numberFormat : "#,##0"},
                                 dynamicStyles : [gfn_getDynamicStyle(-2)], dataType : "number", width: 160});
        
        //과부족
        columns[1].columns.push({name : "SALES_OVER_SHORT", fieldName: "SALES_OVER_SHORT", editable: false, header: {text: '<spring:message code="lbl.overShort" javaScriptEscape="true" />'},
                                 styles: {textAlignment: "far", background : gv_whiteColor, numberFormat : "#,##0"},
                                 dynamicStyles : [gfn_getDynamicStyle(-2)], dataType : "number", width: 160});
        
        //당월예상 출하수량
        columns[1].columns.push({name : "SALES_CUR_MONTH_SALES_QTY", fieldName: "SALES_CUR_MONTH_SALES_QTY", editable: false, header: {text: '<spring:message code="lbl.curMonthSalesCnt" javaScriptEscape="true" />', styles : {background : "#FF6C6C"}},
                                 styles: {textAlignment: "far", background : gv_whiteColor, numberFormat : "#,##0"}, 
                                 dynamicStyles : [gfn_getDynamicStyle(-2)], dataType : "number", width: 200});
        
        //당월예상 출하금액
        columns[1].columns.push({name : "SALES_CUR_MONTH_SALES_AMT", fieldName: "SALES_CUR_MONTH_SALES_AMT", editable: false, header: {text: '<spring:message code="lbl.curMonthSalesAmt" javaScriptEscape="true" />', styles : {background : "#FF6C6C"}},
                                 styles: {textAlignment: "far", background : gv_whiteColor, numberFormat : "#,##0"},
                                 dynamicStyles : [gfn_getDynamicStyle(-2)], dataType : "number", width: 200});
        
        //예상 적중률(%)
        columns[1].columns.push({name : "SALES_EXPACT_TARGET_RATE", fieldName: "SALES_EXPACT_TARGET_RATE", editable: false, header: {text: '<spring:message code="lbl.expactTargetRate" javaScriptEscape="true" />', styles : {background : "#FF6C6C"}},
                                 styles: {textAlignment: "far", background : gv_whiteColor, numberFormat : "#,##0"},
                                 dynamicStyles : [gfn_getDynamicStyle(-2)], dataType : "number", width: 160});
        //예상 과부족
        columns[1].columns.push({name : "SALES_EXPACT_OVER_AMT", fieldName: "SALES_EXPACT_OVER_AMT", editable: false, header: {text: '<spring:message code="lbl.expactOverAmt" javaScriptEscape="true" />', styles : {background : "#FF6C6C"}},
                                 styles: {textAlignment: "far", background : gv_whiteColor, numberFormat : "#,##0"},
                                 dynamicStyles : [gfn_getDynamicStyle(-2)], dataType : "number", width: 160});
        
        //출하: 예상준수율
        //EXPECT_SALES_CPL_RATE
        ///////////////////////////////#FFFF00
        
        columns[1].columns.push({name : "EXPECT_SALES_CPL_RATE", fieldName: "EXPECT_SALES_CPL_RATE", editable: false, header: {text: '<spring:message code="lbl.expectedComplianceRate" javaScriptEscape="true" />', styles : {background : "#FFFF00"}},
                                 styles: {textAlignment: "far", background : gv_whiteColor, numberFormat : "#,##0"},
                                 dynamicStyles : [gfn_getDynamicStyle(-2)], dataType : "number", width: 200});
        
        
        
        //계획 내 예상 출하 금액    컬럼
        //ESTIMATED_SALES_AMT_IN_PLAN
        ///////////////////////////////
        columns[1].columns.push({name : "ESTIMATED_SALES_AMT_IN_PLAN", fieldName: "ESTIMATED_SALES_AMT_IN_PLAN", editable: false, header: {text: '<spring:message code="lbl.planExtSalesAmt" javaScriptEscape="true" />', styles : {background : "#9acd32"}},
                                 styles: {textAlignment: "far", background : gv_whiteColor, numberFormat : "#,##0"},
                                 dynamicStyles : [gfn_getDynamicStyle(-2)], dataType : "number", width: 300});
        
        
        
        
        for(var i=0; i < FORM_SEARCH.bucketList.length; i++){
            var objCol = new Object();
            
            var strFieldNm = "PROD_" + FORM_SEARCH.bucketList[i].NM + "_" + $(':radio[name="amtQty"]:checked').val();          //AMT OR QTY
            var strWeek = FORM_SEARCH.bucketList[i].NM;
            
            objCol = {
                    name : strFieldNm, fieldName: strFieldNm, editable: false, header: {text: FORM_SEARCH.bucketList[i].NM},
                    styles: {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0", background : strWeek > objToday.YEARPWEEK ? gv_whiteColor : gv_noneEditColor},
                    dynamicStyles : [gfn_getDynamicStyle(-2)],
                    dataType : "number",
                    width: 200
            }
            
            columns[2].columns.push(objCol)
        }
        
        //W-1선행생산
        columns[2].columns.push({name : "PROD_PRE_PRODUCTION_QTY", fieldName: "PROD_PRE_PRODUCTION_QTY", editable: false, header: {text: '<spring:message code="lbl.PreproductionW1" javaScriptEscape="true" />'},
                                 styles: {textAlignment: "far", background : gv_whiteColor, numberFormat : "#,##0"},
                                 dynamicStyles : [gfn_getDynamicStyle(-2)], dataType : "number", width: 200});
        
        //당주잔량
        columns[2].columns.push({name : "PROD_WEEK_REMAIN_QTY", fieldName: "PROD_WEEK_REMAIN_QTY", editable: false, header: {text: '<spring:message code="lbl.weekRemain" javaScriptEscape="true" />'},
                                 styles: {textAlignment: "far", background : gv_whiteColor, numberFormat : "#,##0"},
                                 dynamicStyles : [gfn_getDynamicStyle(-2)], dataType : "number", width: 200});
        
        //누적생산수량
        columns[2].columns.push({name : "PROD_ACCUM_PROD_QTY", fieldName: "PROD_ACCUM_PROD_QTY", editable: false, header: {text: '<spring:message code="lbl.accumProdQty" javaScriptEscape="true" />'},
                                 styles: {textAlignment: "far", background : gv_whiteColor, numberFormat : "#,##0"},
                                 dynamicStyles : [gfn_getDynamicStyle(-2)], dataType : "number", width: 200});
        
        //누적생산금액
        columns[2].columns.push({name : "PROD_ACCUM_PROD_AMT", fieldName: "PROD_ACCUM_PROD_AMT", editable: false, header: {text: '<spring:message code="lbl.accumProdAmt" javaScriptEscape="true" />'},
                                 styles: {textAlignment: "far", background : gv_whiteColor, numberFormat : "#,##0"},
                                 dynamicStyles : [gfn_getDynamicStyle(-2)], dataType : "number", width: 200});
        
        //누적진척율(%)
        columns[2].columns.push({name : "PROD_ACCUM_PRG_RATE", fieldName: "PROD_ACCUM_PRG_RATE", editable: false, header: {text: '<spring:message code="lbl.accumPrgRate" javaScriptEscape="true" />'},
                                 styles: {textAlignment: "far", background : gv_whiteColor, numberFormat : "#,##0"},
                                 dynamicStyles : [gfn_getDynamicStyle(-2)], dataType : "number", width: 200});
        
        //과부족
        columns[2].columns.push({name : "PROD_OVER_SHORT", fieldName: "PROD_OVER_SHORT", editable: false, header: {text: '<spring:message code="lbl.overShort" javaScriptEscape="true" />'},
                                 styles: {textAlignment: "far", background : gv_whiteColor, numberFormat : "#,##0"},
                                 dynamicStyles : [gfn_getDynamicStyle(-2)], dataType : "number", width: 200});
        
        //당월예상 생산수량
        columns[2].columns.push({name : "PROD_CUR_MONTH_PROD_QTY_RES", fieldName: "PROD_CUR_MONTH_PROD_QTY_RES", editable: false, header: {text: '<spring:message code="lbl.curMonthProdCnt" javaScriptEscape="true" />', styles : {background : "#FF6C6C"}},
                                 styles: {textAlignment: "far", background : gv_whiteColor, numberFormat : "#,##0"},
                                 dynamicStyles : [gfn_getDynamicStyle(-2)], dataType : "number", width: 200});
        
        //당월예상 생산금액
        columns[2].columns.push({name : "PROD_CUR_MONTH_PROD_AMT_RES", fieldName: "PROD_CUR_MONTH_PROD_AMT_RES", editable: false, header: {text: '<spring:message code="lbl.curMonthProdAmt" javaScriptEscape="true" />', styles : {background : "#FF6C6C"}},
                                 styles: {textAlignment: "far", background : gv_whiteColor, numberFormat : "#,##0"},
                                 dynamicStyles : [gfn_getDynamicStyle(-2)], dataType : "number", width: 200});
        
        //예상 진척율(%)
        columns[2].columns.push({name : "PROD_EXPACT_PRG_RATE", fieldName: "PROD_EXPACT_PRG_RATE", editable: false, header: {text: '<spring:message code="lbl.expactPrgRate" javaScriptEscape="true" />', styles : {background : "#FF6C6C"}},
                                 styles: {textAlignment: "far", background : gv_whiteColor, numberFormat : "#,##0"},
                                 dynamicStyles : [gfn_getDynamicStyle(-2)], dataType : "number", width: 200});
        
        //예상과부족
        columns[2].columns.push({name : "PROD_EXPACT_OVER_AMT", fieldName: "PROD_EXPACT_OVER_AMT", editable: false, header: {text: '<spring:message code="lbl.expactOverAmt" javaScriptEscape="true" />', styles : {background : "#FF6C6C"}},
                                 styles: {textAlignment: "far", background : gv_whiteColor, numberFormat : "#,##0"},
                                 dynamicStyles : [gfn_getDynamicStyle(-2)], dataType : "number", width: 200});
        
        //당주 당주생산완료예정 수량(일간)            
        columns[2].columns.push({name : "PROD_CUR_MONTH_PROD_END_QTY", fieldName: "PROD_CUR_MONTH_PROD_END_QTY", editable: false, header: {text: '<spring:message code="lbl.curMonthProdEndQty" javaScriptEscape="true" />'},
                                 styles: {textAlignment: "far", background : gv_whiteColor, numberFormat : "#,##0"},
                                 dynamicStyles : [gfn_getDynamicStyle(-2)], dataType : "number", width: 330});
        
        
        //생산: 예상준수율
        //EXPECT_PROD_CPL_RATE
        //////////////////////////////////////////
        columns[2].columns.push({name : "EXPECT_PROD_CPL_RATE", fieldName: "EXPECT_PROD_CPL_RATE", editable: false, header: {text: '<spring:message code="lbl.expectedComplianceRate" javaScriptEscape="true" />', styles : {background : "#FFFF00"}},
                                 styles: {textAlignment: "far", background : gv_whiteColor, numberFormat : "#,##0"},
                                 dynamicStyles : [gfn_getDynamicStyle(-2)], dataType : "number", width: 200});
        
        
        //계획 내 예상 생산 금액 컬럼
        //ESTIMATED_PROD_AMT_IN_PLAN
        //////////////////////////////////////////
        columns[2].columns.push({name : "ESTIMATED_PROD_AMT_IN_PLAN", fieldName: "ESTIMATED_PROD_AMT_IN_PLAN", editable: false, header: {text: '<spring:message code="lbl.planExtProdAmt" javaScriptEscape="true" />' , styles : {background : "#9acd32"}},
                                 styles: {textAlignment: "far", background : gv_whiteColor, numberFormat : "#,##0"},
                                 dynamicStyles : [gfn_getDynamicStyle(-2)], dataType : "number", width: 300});
        
        
        return columns;
    }
    
</script>
</head>
<body id="framesb">
    <%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
    <div id="a" class="split content split-horizontal">
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
                <input type="hidden" id="fromMon" name="fromMon" />
                <input type="hidden" id="toMon" name="toMon" />
                <input type="hidden" id="currentDay" name="currentDay" />
                <input type="hidden" id="pastPlanIdStartWeek" name="pastPlanIdStartWeek" />
                <input type="hidden" id="pastPlanIdEndWeek" name="pastPlanIdEndWeek" />
                <input type="hidden" id="futurePlanIdStartWeek" name="futurePlanIdStartWeek" />
                <input type="hidden" id="futurePlanIdEndWeek" name="futurePlanIdEndWeek" />
                <input type="hidden" id="dimWeek" name="dimWeek" />
                <input type="hidden" id="partADimWeek" name="partADimWeek" />
                <input type="hidden" id="partBDimWeek" name="partBDimWeek" />
                <input type="hidden" id="planStartWeek" name="planStartWeek" />
                <input type="hidden" id="planEndWeek" name="planEndWeek" />
                <input type="hidden" id="qtyDate" name="qtyDate" />
                <input type="hidden" id="startRemains" name="startRemains" />
                <input type="hidden" id="endRemains" name="endRemains" />
                <input type="hidden" id="startMonth" name="startMonth" />
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
                    <div class="view_combo" id="divProdPart"></div>
                    
                    <div class="view_combo" id="divPlanIdPast"></div>
                    <jsp:include page="/WEB-INF/view/common/filterViewHorizon.jsp" flush="false">
                        <jsp:param name="radioYn" value="N" />
                        <jsp:param name="wType" value="PW" />
                    </jsp:include>
                    <div class="view_combo" id="divAmtQty" hidden></div>
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
        </div>
    </div>
</body>
</html>