<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
    <!-- 자재준비율 -->
    <script type="text/javascript">
    
    var dimArr;
    var enterSearchFlag = "Y";
    var prepareMaterials = {
        init : function () {
            gfn_formLoad();
            this.comCode.initCode();
            this.initFilter();
            
            this.matGrid.initGrid();
            this.events();
        },
            
        _siq    : "snop.oprtKpi.prepareMaterials",
        
        
        initFilter : function() {
            
            var itemTypeEvent = {
                childId   : ["upItemGroup"],  
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
            
            //집계제외항목표기여부 default: N 셋팅
            var temp = prepareMaterials.comCode.codeMap.FLAG_YN[1];
            prepareMaterials.comCode.codeMap.FLAG_YN[1] = prepareMaterials.comCode.codeMap.FLAG_YN[2]
            prepareMaterials.comCode.codeMap.FLAG_YN[2] = temp;
            
            // 콤보박스
            gfn_setMsComboAll([
                {target : 'divProcurType', id : 'procurType', title : '<spring:message code="lbl.procure"/>', data : this.comCode.codeMap.PROCUR_TYPE, exData:[""]},
                {target : 'divUpItemGroup', id : 'upItemGroup', title : '<spring:message code="lbl.upperItemGroup"/>', data : this.comCode.codeMapEx.UPPER_ITEM_GROUP, exData:["*"], event: upperItemEvent, option: {allFlag:"Y"}},
                {target : 'divItemGroup', id : 'itemGroup', title : '<spring:message code="lbl.itemGroup"/>', data : this.comCode.codeMapEx.ITEM_GROUP, exData:["*"]},
                {target : 'divItemType', id : 'itemType', title : '<spring:message code="lbl.itemType"/>', data : this.comCode.codeMap.ITEM_TYPE, exData:["*"], event : itemTypeEvent, option: {allFlag:"Y"}},
                {target : 'divAvailRate', id : 'availRate', title : '<spring:message code="lbl.availRate"/>', data : this.comCode.codeMap.AVAILABLE_CD, exData:[""], type : "S"},
                {target : 'divAvail', id : 'avail', title : '<spring:message code="lbl.avail"/>', data : this.comCode.codeMap.CUMULATIVE_CD, exData:["*"], type : "S"},
                {target : 'divIncYn'     , id : 'incYn'     , title : '<spring:message code="lbl.itmExcldFromCnt"/>' , data : this.comCode.codeMap.FLAG_YN, exData:[""], type : "S"}
                
            ]);
            
            $('#procurType').multipleSelect("setSelects",["OH","OP"]);
            
            var dateParam = {
                arrTarget : [
                    {calId : "fromCal", weekId : "fromWeek", defVal : 0}
                ]
            };
            DATEPICKET(dateParam);
            $('#fromCal').datepicker("option", "maxDate", new Date().getWeekDay(1, false));
            
            getGrDate();
        },
        
        /*
        * common Code 
        */
        comCode : {
            codeMapEx : null,
            codeMap : null,
            
            initCode  : function () {
                var grpCd = 'AVAILABLE_CD,ITEM_TYPE,CUMULATIVE_CD,PROCUR_TYPE,MAT_SHORT_TYPE,FLAG_YN';
                this.codeMap = gfn_getComCode(grpCd, 'Y'); //공통코드 조회
                this.codeMapEx = gfn_getComCodeEx(["ITEM_GROUP", "UPPER_ITEM_GROUP"], null, {itemType : "20,30" });
                
                this.codeMap.ITEM_TYPE = $.grep(this.codeMap.ITEM_TYPE, function(v,n) {
                    return v.CODE_CD == '20' || v.CODE_CD == '30'; 
                });
            }
        },
        
        /* 
        * grid  선언
        */
        matGrid : {
            gridInstance : null,
            grdMain      : null,
            dataProvider : null,
            
            initGrid     : function () {
                
                this.gridInstance = new GRID();
                this.gridInstance.init("realgrid");
                this.gridInstance.custBucketFalg = true;
                this.gridInstance.custBeforeDimensionFalg = true;
                
                this.grdMain      = this.gridInstance.objGrid;
                this.dataProvider = this.gridInstance.objData;
                
                this.grdMain.addCellStyles([{
                    id         : "noneEditStyle",
                    editable   : false,
                    background : gv_totalColor
                }]);
                
                this.grdMain.addCellStyles([{
                    id         : "editStyle",
                    editable   : true,
                    background : gv_editColor
                }]);
                
                gfn_setMonthSum(prepareMaterials.matGrid.gridInstance, false, false, true);
                
                this.setOptions();
            },
            setOptions : function() {
                
                this.grdMain.addCellStyles([{
                    id         : "yellowStyle",
                    background : "#ffff00"
                }]);
                
                this.grdMain.addCellStyles([{
                    id         : "bucketStyle",
                    background : "#ffffff"
                }]);
                
                this.grdMain.addCellStyles([{
                    id         : "dimensionStyle",
                    background : "#edf7fd"
                }]);
                
                this.grdMain.addCellStyles([{
                    id         : "remarkStyle",
                    background : gv_editColor
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
            
            $("#btnConfirmY").on("click", function(e) {
                fn_confirm("Y");
            });
            
            $("#btnConfirmN").on("click", function(e) {
                fn_confirm("N");
            });
            
            $("#fromCal").on("change", function(e){
                getGrDate();
            });
            
            $("#btnSummary").on('click', function (e) {
                gfn_comPopupOpen("MATERIAL_SUMMARY", {
                    rootUrl : "snop/oprtKpi",
                    url     : "materialSummary",
                    width   : 900,
                    height  : 680,
                    fromWeek : $("#fromWeek").val(),
                    fromCal : $("#fromCal").val(),
                    menuCd  : "SNOP305"
                });
            });
            
            $("#btnSave").click ("on", function() { prepareMaterials.save(); });
            
            
            prepareMaterials.matGrid.grdMain.onDataCellClicked = function (grid, index) {
                var rowId     = index.itemIndex;
                var field = index.fieldName;
                var detailPoup = grid.getValue(rowId, "DETAIL_POPUP");
                
                if(detailPoup == 'Y' && field == 'DETAIL_POPUP')
                {
                    var companyCd = grid.getValue(rowId, "COMPANY_CD");
                    var buCd      = grid.getValue(rowId, "BU_CD");
                    
                    var itemNm    = grid.getValue(rowId, "ITEM_NM_NM");
                    
                    var planId = grid.getValue(rowId, "PLAN_ID");
                    var itemCd = grid.getValue(rowId, "ITEM_CD_NM");
                    
                
                    gfn_comPopupOpen("MAT_REQUIR_PLAN_DETAIL", {
                        rootUrl    : "snop/oprtKpi",
                        url        : "materialPreparationDetail",
                        width      : 1200,
                        height     : 680,
                        companyCd  : companyCd,
                        buCd       : buCd,
                        //prodPart   : prodPart,
                        itemCd     : itemCd,
                        itemNm     : itemNm,
                        planId     : planId,
                        menuCd     : "SNOP305"
                    });
                    
                }
                
        
            }
            
            prepareMaterials.matGrid.grdMain.onEditRowChanged = function (grid, itemIndex, dataRow, field, oldValue, newValue) {

                var provider = prepareMaterials.matGrid.dataProvider;
                var filedNm  = provider.getFieldName(field);

                if(filedNm == "ISSUE_YN_NM" && (grid.getValue(itemIndex, "GRP_LVL_ID")==0)) {
                    
                    if(newValue == "Y") 
                    {

                        $.each(prepareMaterials.matGrid.grdMain.getColumns(), function() {
                            prepareMaterials.matGrid.grdMain.setCellStyles(dataRow,this.name, "yellowStyle");
                        });
                        
                        prepareMaterials.matGrid.grdMain.setCellStyles(dataRow,
                                ["MAT_GR_SCHED_QTY_W0","MAT_GR_SCHED_QTY_W1","MAT_GR_SCHED_QTY_W2","MAT_GR_SCHED_QTY_W3"
                                ,"ONE_WEEK_DATA","TWO_WEEK_DATA","THREE_WEEK_DATA","FOUR_WEEK_DATA",
                                "MRP_ONE_WEEK_DATA","MRP_TWO_WEEK_DATA","MRP_THREE_WEEK_DATA","MRP_FOUR_WEEK_DATA"],
                                "yellowStyle");
                        
                    }
                    else // false
                    {
                        $.each(prepareMaterials.matGrid.grdMain.getColumns(), function() {
                            if(this.name == "REMARK_NM" || this.name == "MAT_SHORT_TYPE_NM" || this.name == "REMARK_CONF_NM" || this.name == "ISSUE_YN_NM")
                            {
                                prepareMaterials.matGrid.grdMain.setCellStyles(dataRow,this.name, "remarkStyle");   
                            }
                            else
                            {
                                prepareMaterials.matGrid.grdMain.setCellStyles(dataRow,this.name, "dimensionStyle");    
                            }
                            
                        });
                        
                        prepareMaterials.matGrid.grdMain.setCellStyles(dataRow,
                                ["MAT_GR_SCHED_QTY_W0","MAT_GR_SCHED_QTY_W1","MAT_GR_SCHED_QTY_W2","MAT_GR_SCHED_QTY_W3"
                                ,"ONE_WEEK_DATA","TWO_WEEK_DATA","THREE_WEEK_DATA","FOUR_WEEK_DATA",
                                "MRP_ONE_WEEK_DATA","MRP_TWO_WEEK_DATA","MRP_THREE_WEEK_DATA","MRP_FOUR_WEEK_DATA"],
                                "bucketStyle");                 
                        
                    }
                
                }
                
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
                    }else if(id == "divAvailRate"){
                        EXCEL_SEARCH_DATA += $("#availRate option:selected").text();
                    }else if(id == "divAvail"){
                        EXCEL_SEARCH_DATA += $("#avail option:selected").text();
                    }else if(id == "divWeekId"){
                        EXCEL_SEARCH_DATA += $("#fromCal").val() + "(" + $("#fromWeek").val() + ")";
                    }
                }
            });
        },
        
        // 조회
        search : function () {
            
            FORM_SEARCH._mtd     = "getList";
            FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq }, { outDs : "authorityList",_siq : this._siq + "AuthorityList"}, { outDs : "confirm",_siq : this._siq + "Confirm"}];
            
            var aOption = {
                url     : GV_CONTEXT_PATH + "/biz/obj",
                data    : FORM_SEARCH,
                success : function (data) {
                    
                    if (FORM_SEARCH.sql == 'N') {
                        prepareMaterials.matGrid.dataProvider.clearRows(); //데이터 초기화
                
                        //그리드 데이터 생성
                        prepareMaterials.matGrid.grdMain.cancel();
                        
                        prepareMaterials.matGrid.dataProvider.setRows(data.resList);
                        prepareMaterials.matGrid.dataProvider.clearSavePoints();
                        prepareMaterials.matGrid.dataProvider.savePoint(); //초기화 포인트 저장
                        gfn_actionMonthSum(prepareMaterials.matGrid.gridInstance);
                        gfn_setRowTotalFixed(prepareMaterials.matGrid.grdMain);
                        
                        prepareMaterials.matGrid.grdMain.setCellStyles(0, dimArr, "noneEditStyle");
                        prepareMaterials.gridCallBack(data);
                    }
                }
            }
            
            gfn_service(aOption, "obj");
        },
        
        gridCallBack : function(data){
            
            var iconStyles = [{
                criteria: "value='Y'",
                styles: "iconIndex=0"
            }, {
                criteria: "value='N'",
                styles: "iconIndex=-1"
            }];
            
            
            var auth = data.authorityList[0].CNT;
            var confirmLen = data.confirm.length;
            
            if(auth > 0){
                
                var confrimYn = "N"; 
                var resData = data.resList;
                var resDataArr = new Array();
                
                if(confirmLen > 0){
                    confrimYn = data.confirm[0].CONFRIM_YN;
                }
                
                if(confrimYn == "N"){
                    $.each(resData, function(i, val){
                        
                        var grpLvlId = val.GRP_LVL_ID;
                        
                        if(grpLvlId == 0){
                            resDataArr.push(i);
                        }
                    });
                    
                    prepareMaterials.matGrid.grdMain.setCellStyles(resDataArr, "ADJ_QTY_NM", "editStyle");  
                }
                
                $("#btnConfirmY").show();
                $("#btnConfirmN").show();
            }
            
            prepareMaterials.matGrid.grdMain.setColumnProperty("DETAIL_POPUP", "dynamicStyles", iconStyles)
            
            //ISSUE_FLAG: 'Y' 여부에 따라 ROW 전체 노란색으로 바꾸기
            var newDynamicStyles = [
                {
                    criteria : "values['ISSUE_YN_NM'] = 'Y'",
                    styles : "background=" + "#ffff00"
                }
            ];
            prepareMaterials.matGrid.grdMain.setStyles({
                body: {
                    dynamicStyles: newDynamicStyles
                }
            });
            
        },
        
        save : function() {
            var grdData = gfn_getGrdSavedataAll(this.matGrid.grdMain);
            var grdDataLen = grdData.length;
            if (grdDataLen == 0) {
                alert('<spring:message code="msg.noChangeData"/>');
                return;
            }
            
            confirm('<spring:message code="msg.confirmSave"/>', function() {  // 저장하시겠습니까?
                    
                FORM_SAVE = {}; //초기화
                FORM_SAVE._mtd = "saveAll";
                FORM_SAVE.tranData = [{outDs : "saveCnt", _siq : prepareMaterials._siq, grdData : grdData}];
                
                var sMap = {
                    url: GV_CONTEXT_PATH + "/biz/obj",
                    data: FORM_SAVE,
                    success:function(data) {
                        alert('<spring:message code="msg.saveOk"/>');
                        fn_apply();
                    }
                }
                gfn_service(sMap, "obj");
            }); 
        },
        
        getBucket : function (sqlFlag) {
            var ajaxMap = {
                fromDate : gfn_replaceAll($("#fromCal").val(),"-",""),
                toDate   : gfn_replaceAll($("#toCal").val(),"-",""),
                week     : {isDown: "Y", isUp : "N", upCal : "M", isMt : "N", isExp : "N", expCnt : 999},
                sqlId    : ["bucketFullWeek"]
            }
            gfn_getBucket(ajaxMap);
        }
    };

    //조회
    var fn_apply = function (sqlFlag) {
        
        var fromMon = gfn_replaceAll($("#fromCal").val(), "-", "").substring(0, 6);

        if ($('#item_nm')){
            gfn_getMenuInit();
        }
        
        if (!sqlFlag) {
            
            dimArr = new Array();
            
            DIMENSION.hidden = [];
            DIMENSION.hidden.push({CD : "COMPANY_CD", dataType : "text"});
            DIMENSION.hidden.push({CD : "BU_CD", dataType : "text"});
            DIMENSION.hidden.push({CD : "YEARWEEK", dataType : "text"});
            DIMENSION.hidden.push({CD : "PLAN_ID", dataType : "text"});
            prepareMaterials.matGrid.gridInstance.setDraw();
            
            var imgs = new RealGridJS.ImageList("images1", GV_CONTEXT_PATH + "/statics/images/common/");
            imgs.addUrls([
                "ico_srh.png"
            ]);
            
            prepareMaterials.matGrid.grdMain.registerImageList(imgs);
            
            prepareMaterials.matGrid.grdMain.setColumnProperty("DETAIL_POPUP", "imageList", "images1");
            prepareMaterials.matGrid.grdMain.setColumnProperty("DETAIL_POPUP", "renderer", {type : "icon"}); 
            
            prepareMaterials.matGrid.grdMain.setColumnProperty("DETAIL_POPUP", "styles", {
                textAlignment: "center",
                iconIndex: 0,
                iconLocation: "center",
                iconAlignment: "center",
                iconOffset: 4,
                iconPadding: 2
            }); 
            
            var fileds = prepareMaterials.matGrid.dataProvider.getFields();
            for (var i = 0; i < fileds.length; i++) {
                
                var vFileds = fileds[i].fieldName;
                
                if (vFileds == 'MRP_QTY_NM' || vFileds == 'NON_MOVING_QTY_NM'|| vFileds == 'NON_DEPLOY_QTY_NM'
                    || vFileds == 'REQ_TOTAL_NM' || vFileds == 'MAIN_REQ_QTY_NM' || vFileds == 'ADJ_QTY_NM'
                    || vFileds == 'INV_QTY2_NM' || vFileds == 'GR_QTY_NM' || vFileds == 'INV_GR_QTY_NM'
                    || vFileds == 'OVER_SHORT_NM' || vFileds == 'AVAIL_RATE_NM' || vFileds == 'CC_QTY2_NM'
                    || vFileds == 'STK_ON_INSP_QTY_NM' || vFileds == 'URGENT_REMAIN_QTY_NM'
                    || vFileds == 'REQ_QTY_NM' || vFileds == 'GAP_QTY_NM' || vFileds == 'RECV_QC_NG_QTY_NM'
                    || vFileds == 'READY_NM' || vFileds == 'NO_READY_NM' || vFileds == 'PERCENTAGE_NM'
                    || vFileds == 'PERCENTAGE2_NM' || vFileds == 'AVAIL_RATE2_NM' || vFileds == 'PUR_LT_NM'
                    || vFileds == 'THREE_MONTH_QTY_NM' || vFileds == 'PRICE_KRW_NM' || vFileds == 'REQ_AMOUNT_NM'
                    || vFileds == 'AVAIL_AMOUNT_NM' || vFileds == 'MRP_QTY_NM' || vFileds == 'MRP_QTY_NM'
                    || vFileds == 'MRP_QTY_NM' || vFileds == 'OS_NON_MOVING_QTY_NM'|| vFileds == 'GR_OVER_SHORT_W0_NM'
                ) {
                    fileds[i].dataType = "number";
                    fileds[i].numberFormat = "#,##0";

                    prepareMaterials.matGrid.grdMain.setColumnProperty(vFileds, "mergeRule", {criteria:"row div 1"})
                    prepareMaterials.matGrid.grdMain.setColumnProperty(vFileds, "styles", {"numberFormat" : "#,##0"});  
                } else if(vFileds == 'MAT_SHORT_TYPE_NM'){
                    
                    var col = prepareMaterials.matGrid.grdMain.columnByName(vFileds);
                    
                    prepareMaterials.matGrid.grdMain.setColumnProperty(vFileds, "editor", { type: "dropDown", domainOnly: true });
                    col.values = gfn_getArrayExceptInDs(prepareMaterials.comCode.codeMap.MAT_SHORT_TYPE, "CODE_CD", "");
                    col.labels = gfn_getArrayExceptInDs(prepareMaterials.comCode.codeMap.MAT_SHORT_TYPE, "CODE_NM", "");
                    
                    col.styles = {textAlignment: "center", background : gv_editColor};
                    col.editable = true;
                    col.lookupDisplay = true;
                    col.editButtonVisibility = "visible"
                    
                    prepareMaterials.matGrid.grdMain.setColumn(col);
                } else if(vFileds == 'REMARK_NM'){
                    
                    var col = prepareMaterials.matGrid.grdMain.columnByName(vFileds);
                    prepareMaterials.matGrid.grdMain.setColumnProperty(vFileds, "editor", { type: "text"});
                    col.styles = {textAlignment: "near", background : gv_editColor};
                    col.editable = true;
                    
                    prepareMaterials.matGrid.grdMain.setColumn(col);
                } 
                
                else if(vFileds =='REMARK_CONF_NM'){
                    
                    var col = prepareMaterials.matGrid.grdMain.columnByName(vFileds);
                    prepareMaterials.matGrid.grdMain.setColumnProperty(vFileds, "editor", { type: "text"});
                    col.styles = {textAlignment: "near", background : gv_editColor};
                    col.editable = true;
                    
                    prepareMaterials.matGrid.grdMain.setColumn(col);
                } 
                
                else if(vFileds =='ISSUE_YN_NM'){
                    var col = prepareMaterials.matGrid.grdMain.columnByName(vFileds);
                    col.type = "data",
                    col.width= "70",
                    col.editable = false,
                    col.renderer = {
                        type: "check",
                        editable:true,
                        startEditOnClick:true,
                        trueValues: "Y",
                        falseValues: "N",
                        
                        
                    },
                    col.styles = {
                            
                        paddingLeft: 8,
                        textAlignment: "center",
                        background:gv_editColor
                    }
                    
                    prepareMaterials.matGrid.grdMain.setColumn(col);
                    prepareMaterials.matGrid.grdMain.setColumnProperty("ISSUE_YN_NM", "mergeRule", null);
                }
                    
                
                dimArr.push(vFileds);
            }
            prepareMaterials.matGrid.dataProvider.setFields(fileds);
        }
        
        //조회조건 설정
        FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
        FORM_SEARCH.sql        = sqlFlag;
        FORM_SEARCH.dimList    = DIMENSION.user;
        FORM_SEARCH.bucketList = BUCKET.query;
        FORM_SEARCH.fromMon    = fromMon;
        prepareMaterials.search();
        prepareMaterials.excelSubSearch();
    };
    
    // onload 
    $(document).ready(function() {
        prepareMaterials.init();
    });
    
    
    
    
    function fn_setNextFieldsBuket() {
        var fields = [
    
            {fieldName: "ITEM_CD_NM", dataType : "text"},
            {fieldName: "ITEM_NM_NM", dataType : "text"},
            {fieldName: "SPEC_NM", dataType : "text"},
            {fieldName: "DETAIL_POPUP", dataType : "text"}
        
        ];
        
        return fields;
    }
    
    function fn_setNextColumnsBuket() {
        var columns = 
        [
            
            
            
            { 
                name : "ITEM_CD_NM", fieldName : "ITEM_CD_NM", editable : false, header: {text: '<spring:message code="lbl.item" javaScriptEscape="true" />'},
                styles : {textAlignment: "near", background : gfn_getArrDimColor(0)},
                width : 80,
                dynamicStyles:[gfn_getDynamicStyle(-2)],
            }, {
                name : "ITEM_NM_NM", fieldName : "ITEM_NM_NM", editable : false, header: {text: '<spring:message code="lbl.itemName" javaScriptEscape="true" />'},
                styles : {textAlignment: "near", background : gfn_getArrDimColor(0)},
                width : 80,
                dynamicStyles:[gfn_getDynamicStyle(-2)],
            }, {
                name : "SPEC_NM", fieldName : "SPEC_NM", editable : false, header: {text: '<spring:message code="lbl.spec" javaScriptEscape="true" />'},
                styles : {textAlignment: "near", background : gfn_getArrDimColor(0)},
                width : 80,
                dynamicStyles:[gfn_getDynamicStyle(-2)],
            },
            {
                name : "DETAIL_POPUP", fieldName : "DETAIL_POPUP", editable : false, header: {text: '<spring:message code="lbl.detailInfo" javaScriptEscape="true" />'},
                styles : {textAlignment: "near", background : gfn_getArrDimColor(0)},
                width : 44,
                dynamicStyles:[gfn_getDynamicStyle(-2)],
            },
        ];
        
        return columns;
    }
    
    
    
    
    function fn_setFieldsBuket() {
        //필드 배열 객체를  생성합니다.
        var fields = [
            {fieldName : "MAT_GR_SCHED_QTY_W0", dataType : "number"},
            {fieldName : "MAT_GR_SCHED_QTY_W1" , dataType : "number"},
            {fieldName : "MAT_GR_SCHED_QTY_W2", dataType : "number"},
            {fieldName : "MAT_GR_SCHED_QTY_W3", dataType : "number"},
            {fieldName : "ONE_WEEK_DATA", dataType : "number"},
            {fieldName : "TWO_WEEK_DATA" , dataType : "number"},
            {fieldName : "THREE_WEEK_DATA", dataType : "number"},
            {fieldName : "FOUR_WEEK_DATA", dataType : "number"},
            {fieldName : "MRP_ONE_WEEK_DATA", dataType : "number"},
            {fieldName : "MRP_TWO_WEEK_DATA" , dataType : "number"},
            {fieldName : "MRP_THREE_WEEK_DATA", dataType : "number"},
            {fieldName : "MRP_FOUR_WEEK_DATA", dataType : "number"},
        ];
        
        return fields;
    }

    function fn_setColumnsBuket() {
        //필드와 연결된 컬럼 배열 객체를 생성합니다.
        var columns = 
        [
            {
                type: "group",
                name: '<spring:message code="lbl.conQtyReqHis" javaScriptEscape="true" />',
                header: {text: '<spring:message code="lbl.conQtyReqHis" javaScriptEscape="true" />' + gv_expand},
                fieldName: "WEEK_GROUP",
                width: 400,
                columns : [
                    {
                        name : "MRP_ONE_WEEK_DATA", fieldName: "MRP_ONE_WEEK_DATA", editable: false, header: {text: '<spring:message code="lbl.reqQtyW1" javaScriptEscape="true" />'},
                        dynamicStyles : [gfn_getDynamicStyle(-2)],
                        styles: {textAlignment: "far", numberFormat : "#,##0"},
                        dataType : "number",
                        nanText : "",
                        width: 100
                    }, {
                        name : "MRP_TWO_WEEK_DATA", fieldName: "MRP_TWO_WEEK_DATA", editable: false, header: {text: '<spring:message code="lbl.reqQtyW2" javaScriptEscape="true" />'},
                        dynamicStyles : [gfn_getDynamicStyle(-2)],
                        styles: {textAlignment: "far", numberFormat : "#,##0"},
                        dataType : "number",
                        nanText : "",
                        width: 100
                    }, {
                        name : "MRP_THREE_WEEK_DATA", fieldName: "MRP_THREE_WEEK_DATA", editable: false, header: {text: '<spring:message code="lbl.reqQtyW3" javaScriptEscape="true" />'},
                        dynamicStyles : [gfn_getDynamicStyle(-2)],
                        styles: {textAlignment: "far", numberFormat : "#,##0"},
                        dataType : "number",
                        nanText : "",
                        width: 100
                    }, {
                        name : "MRP_FOUR_WEEK_DATA", fieldName: "MRP_FOUR_WEEK_DATA", editable: false, header: {text: '<spring:message code="lbl.reqQtyW4" javaScriptEscape="true" />'},
                        dynamicStyles : [gfn_getDynamicStyle(-2)],
                        styles: {textAlignment: "far", numberFormat : "#,##0"},
                        dataType : "number",
                        nanText : "",
                        width: 100
                    }
                ]
            }, {
                type: "group",
                name: '<spring:message code="lbl.schedQty" javaScriptEscape="true" />',
                header: {text: '<spring:message code="lbl.schedQty" javaScriptEscape="true" />' + gv_expand},
                fieldName: "WEEK_GROUP",
                width: 400,
                columns : [
                    {
                        name : "MAT_GR_SCHED_QTY_W0", fieldName: "MAT_GR_SCHED_QTY_W0", editable: false, header: {text: '<spring:message code="lbl.preQtyW0" javaScriptEscape="true" />'},
                        dynamicStyles : [gfn_getDynamicStyle(-2)],
                        styles: {textAlignment: "far", numberFormat : "#,##0"},
                        dataType : "number",
                        nanText : "",
                        width: 100
                    }, {
                        name : "MAT_GR_SCHED_QTY_W1", fieldName: "MAT_GR_SCHED_QTY_W1", editable: false, header: {text: '<spring:message code="lbl.preQtyW1" javaScriptEscape="true" />'},
                        dynamicStyles : [gfn_getDynamicStyle(-2)],
                        styles: {textAlignment: "far", numberFormat : "#,##0"},
                        dataType : "number",
                        nanText : "",
                        width: 100
                    }, {
                        name : "MAT_GR_SCHED_QTY_W2", fieldName: "MAT_GR_SCHED_QTY_W2", editable: false, header: {text: '<spring:message code="lbl.preQtyW2" javaScriptEscape="true" />'},
                        dynamicStyles : [gfn_getDynamicStyle(-2)],
                        styles: {textAlignment: "far", numberFormat : "#,##0"},
                        dataType : "number",
                        nanText : "",
                        width: 100
                    }, {
                        name : "MAT_GR_SCHED_QTY_W3", fieldName: "MAT_GR_SCHED_QTY_W3", editable: false, header: {text: '<spring:message code="lbl.preQtyW3" javaScriptEscape="true" />'},
                        dynamicStyles : [gfn_getDynamicStyle(-2)],
                        styles: {textAlignment: "far", numberFormat : "#,##0"},
                        dataType : "number",
                        nanText : "",
                        width: 100
                    }
                ]
            }, {
                type: "group",
                name: '<spring:message code="lbl.weekAvailable Rate" javaScriptEscape="true" />',
                header: {text: '<spring:message code="lbl.weekAvailable Rate" javaScriptEscape="true" />' + gv_expand},
                fieldName: "WEEK_GROUP",
                width: 400,
                columns : [
                    {
                        name : "ONE_WEEK_DATA", fieldName: "ONE_WEEK_DATA", editable: false, header: {text: '<spring:message code="lbl.w-1AvailableRate" javaScriptEscape="true" />'},
                        dynamicStyles : [gfn_getDynamicStyle(-2)],
                        styles: {textAlignment: "far", numberFormat : "#,##0"},
                        dataType : "number",
                        nanText : "",
                        width: 100
                    }, {
                        name : "TWO_WEEK_DATA", fieldName: "TWO_WEEK_DATA", editable: false, header: {text: '<spring:message code="lbl.w-2AvailableRate" javaScriptEscape="true" />'},
                        dynamicStyles : [gfn_getDynamicStyle(-2)],
                        styles: {textAlignment: "far", numberFormat : "#,##0"},
                        dataType : "number",
                        nanText : "",
                        width: 100
                    }, {
                        name : "THREE_WEEK_DATA", fieldName: "THREE_WEEK_DATA", editable: false, header: {text: '<spring:message code="lbl.w-3AvailableRate" javaScriptEscape="true" />'},
                        dynamicStyles : [gfn_getDynamicStyle(-2)],
                        styles: {textAlignment: "far", numberFormat : "#,##0"},
                        dataType : "number",
                        nanText : "",
                        width: 100
                    }, {
                        name : "FOUR_WEEK_DATA", fieldName: "FOUR_WEEK_DATA", editable: false, header: {text: '<spring:message code="lbl.w-4AvailableRate" javaScriptEscape="true" />'},
                        dynamicStyles : [gfn_getDynamicStyle(-2)],
                        styles: {textAlignment: "far", numberFormat : "#,##0"},
                        dataType : "number",
                        nanText : "",
                        width: 100
                    }
                ]
            }
        ];
        return columns;
    }
    
    function fn_confirm(confirm_yn) {
        
        var msg = "";
        
        if(confirm_yn == "Y"){
            msg = '<spring:message code="msg.wantConfirm"/>';
        }else{
            msg = '<spring:message code="msg.cancelConfirm"/>';
        }
        
        confirm(msg, function() {
            
            FORM_SAVE          = {}; //초기화
            FORM_SAVE._mtd     = "saveUpdate";
            FORM_SAVE.tranData = [{outDs : "saveCnt", _siq : "snop.oprtKpi.prepareMaterialsConfirmYn", grdData : [{confirmYn : confirm_yn, fromWeek : $("#fromWeek").val()}]}];
            
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
    
    function getGrDate(){
        var swFromDate = $("#swFromDate").val();
        
        gfn_service({
            async   : false,
            url     : GV_CONTEXT_PATH + "/biz/obj",
            data    : {_mtd : "getList", swFromDate : swFromDate, tranData : [
                {outDs : "grList", _siq:"snop.oprtKpi.grDate"}
            ]},
            success : function(data) {
                
                $("#grStartDate").val(data.grList[0].GR_START_DATE);
                $("#grEndDate").val(data.grList[0].GR_END_DATE);
                
                $("#oneWeekGrStartDate").val(data.grList[0].ONE_WEEK_GR_START_DATE);
                $("#oneWeekGrEndDate").val(data.grList[0].ONE_WEEK_GR_END_DATE);
                $("#twoWeekGrStartDate").val(data.grList[0].TWO_WEEK_GR_START_DATE);
                $("#twoWeekGrEndDate").val(data.grList[0].TWO_WEEK_GR_END_DATE);
                $("#threeWeekGrStartDate").val(data.grList[0].THREE_WEEK_GR_START_DATE);
                $("#threeWeekGrEndDate").val(data.grList[0].THREE_WEEK_GR_END_DATE);
                $("#fourWeekGrStartDate").val(data.grList[0].FOUR_WEEK_GR_START_DATE);
                $("#fourWeekGrEndDate").val(data.grList[0].FOUR_WEEK_GR_END_DATE);
            }
        }, "obj");
                
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
                <%@ include file="/WEB-INF/view/common/filterMonthSum.jsp" %>
                <div class="tabMargin"></div>
                <div class="scroll">
                    <div class="view_combo" id="divItem"></div>
                    <div class="view_combo" id="divProcurType"></div>
                    <div class="view_combo" id="divItemType"></div>
                    <div class="view_combo" id="divUpItemGroup"></div>
                    <div class="view_combo" id="divItemGroup"></div>
                    <div class="view_combo" id="divAvailRate"></div>
                    <div class="view_combo" id="divAvail"></div>
                    <div class="view_combo" id="divIncYn"></div>
                    <div class="view_combo" id="divWeekId">
                        <div class="ilist">
                            <div class="itit"><spring:message code="lbl.weekId"/></div>
                            <input type="text" id="fromCal" name="fromCal" class="iptdate datepicker2"/>
                            <input type="text" id="fromWeek" name="fromWeek" class="iptdateweek" disabled="disabled" value=""/>
                            <input type="hidden" id="swFromDate" name="swFromDate"/>
                            <input type="hidden" id="swToDate" name="swToDate"/>
                            <input type="hidden" id="grStartDate" name="grStartDate"/>
                            <input type="hidden" id="grEndDate" name="grEndDate"/>
                            <input type="hidden" id="oneWeekGrStartDate" name="oneWeekGrStartDate"/>
                            <input type="hidden" id="oneWeekGrEndDate" name="oneWeekGrEndDate"/>
                            <input type="hidden" id="twoWeekGrStartDate" name="twoWeekGrStartDate"/>
                            <input type="hidden" id="twoWeekGrEndDate" name="twoWeekGrEndDate"/>
                            <input type="hidden" id="threeWeekGrStartDate" name="threeWeekGrStartDate"/>
                            <input type="hidden" id="threeWeekGrEndDate" name="threeWeekGrEndDate"/>
                            <input type="hidden" id="fourWeekGrStartDate" name="fourWeekGrStartDate"/>
                            <input type="hidden" id="fourWeekGrEndDate" name="fourWeekGrEndDate"/>
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
            <!-- <div class="use_tit">
                <h3>My Opportunities</h3> <h4>- recently created</h4>
            </div> -->
            <div class="scroll">
                <!-- 그리드영역 -->
                <div id="realgrid" style="width: 100%;" class="realgrid1"></div>
            </div>
            
            <div class="cbt_btn" style="height:25px">
                <div class="bright">
                    <a style="display:none" href="javascript:;" id="btnConfirmY" class="app1 roleWrite"><spring:message code="lbl.confirm" /></a>
                    <a style="display:none" href="javascript:;" id="btnConfirmN" class="app1 roleWrite"><spring:message code="lbl.confirmCancel" /></a>
                    <a href="javascript:;" id="btnSummary" class="app1"><spring:message code="lbl.summary" /></a>
                    <a href="javascript:;" id="btnReset" class="app1 roleWrite"><spring:message code="lbl.reset" /></a>
                    <a href="javascript:;" id="btnSave" class="app2 roleWrite"><spring:message code="lbl.save" /></a>
                </div>
            </div>
            
        </div>
    </div>
</body>
</html>
