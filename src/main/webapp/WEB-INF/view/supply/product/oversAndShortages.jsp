<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
    <!-- 급증감 겈토-->
    <script type="text/javascript">
    var SCM_SEARCH ={};
    var enterSearchFlag = "Y";
    var yellowColor = "#FFFF00";
    var oversAndShortages = {

        init : function () {
        
            gfn_formLoad();
            this.comCode.initCode();
            this.initFilter();
            this.roleSearch();
            this.events();
            this.oversAndShortagesGrid.initGrid();
        },
            
        _siq    : "supply.product.oversAndShortages",
        
        initFilter : function() {
            
            //Plan ID
            fn_getPlanId({picketType:"W",planTypeCd:"MP"});
            
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
                { target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>'}
            ]);
            
            // 콤보박스
            gfn_setMsComboAll([
                {target : 'divProcurType',   id : 'procurType',    title : '<spring:message code="lbl.procure"/>',        data : this.comCode.codeMap.PROCUR_TYPE, exData:[""]},
                {target : 'divItemGroup', id : 'itemGroup', title : '<spring:message code="lbl.itemGroup"/>', data : this.comCode.codeMapEx.ITEM_GROUP, exData:["*"]},
                {target : 'divUpItemGroup',  id : 'upItemGroup',   title : '<spring:message code="lbl.upperItemGroup"/>', data : this.comCode.codeMapEx.UPPER_ITEM_GROUP, exData:["*"], event: upperItemEvent, option: {allFlag:"Y"}},
                {target : 'divItemType', id : 'itemType', title : '<spring:message code="lbl.itemType"/>', data : this.comCode.codeMap.ITEM_TYPE, exData:[""], event: itemTypeEvent, option: {allFlag:"Y"}},
                //과부족량 콤보
                {target : 'divExcessShortQty', id : 'excessShortQty', title : '<spring:message code="lbl.excessShortQt"/>', data : this.comCode.codeMap.EXCESS_BELOW, exData:[""],  option: {allFlag:"Y"}},
                //과재공량 콤보
                {target : 'divOverWorkItemQty', id : 'overWorkItem', title : '<spring:message code="lbl.workQty"/>', data : this.comCode.codeMap.EXCESS_BELOW, exData:[""]},
                //대표거래처 그룹
                {target : 'divRepCustGroup', id : 'reptCustGroup', title : '<spring:message code="lbl.salesGroup"/>', data : this.comCode.codeMapEx.REP_CUST_GROUP, exData:[""]},
                
                
            ]);
            
            $("#overWorkItem").multipleSelect("setSelects", ["EXCESS"]);
        },
        
        roleSearch :function(){
            
            SCM_SEARCH = {}; // 초기화
            
            SCM_SEARCH.USER_ID = "${sessionScope.userInfo.userId}" ;
            
            
            SCM_SEARCH._mtd     = "getList";
            SCM_SEARCH.tranData = [
                                   { outDs : "hasWriteRole",_siq : "supply.product.hasWriteRole"}
                                ];
            
            
            
            var aOption = {
                async   : false,
                url     : GV_CONTEXT_PATH + "/biz/obj.do",
                data    : SCM_SEARCH,
                success : function (data) {
                
                    if (SCM_SEARCH.sql == 'N') {
                        
                        SCM_SEARCH.SALES_ROLE_CNT = data.hasWriteRole[0].SALES_ROLE_CNT;
                        SCM_SEARCH.PURCHASE_ROLE_CNT = data.hasWriteRole[0].PURCHASE_ROLE_CNT;
                        SCM_SEARCH.PRODUCTION_ROLE_CNT = data.hasWriteRole[0].PRODUCTION_ROLE_CNT;
                        SCM_SEARCH.SCM_ROLE_CNT = data.hasWriteRole[0].SCM_ROLE_CNT;
                        
                    }
                }
            }
            
            gfn_service(aOption, "obj");
            
            
            
        },
        
        /*
        * common Code 
        */
        comCode : {
            codeMap : null,
            codeMapEx : null,
            codeMapApsStartWeekMonth: null,
            initCode : function () {
                var grpCd    = 'MONTH_TYPE_MINUS,MONTH_TYPE_PLUS,ITEM_TYPE,PROCUR_TYPE,MONTH_TYPE_OUTBOUND,EXCESS_BELOW';
                this.codeMap = gfn_getComCode(grpCd, 'Y'); //공통코드 조회
                this.codeMapEx = gfn_getComCodeEx(["REP_CUST_GROUP", "CUST_GROUP", "UPPER_ITEM_GROUP", "ITEM_GROUP", "ROUTING"], null, {itemType : "10,20,30,50" });
                this.codeMap.ITEM_TYPE = $.grep(this.codeMap.ITEM_TYPE, function(v,n) {
                    return v.CODE_CD != '25' && v.CODE_CD != '35'; 
                });
                
            }
        },
    
        /* 
        * grid  선언
        */
        oversAndShortagesGrid : {
            gridInstance : null,
            grdMain      : null,
            dataProvider : null,
            
            initGrid     : function () {
                
                this.gridInstance = new GRID();
                this.gridInstance.init("realgrid");
                this.gridInstance.custNextBucketFalg = true;
                
                this.grdMain      = this.gridInstance.objGrid;
                this.dataProvider = this.gridInstance.objData;
                
                this.setOptions();
                
                gfn_setMonthSum(oversAndShortages.oversAndShortagesGrid.gridInstance, false, false, true);
                
                this.grdMain.onDataCellClicked = function (grid, index) {
                    
                    var rowId = index.itemIndex;
                    var field = index.fieldName;
                    
                    var grpLvlId = grid.getValue(rowId, "GRP_LVL_ID");
                    var planId = grid.getValue(rowId, "PLAN_ID");
                    var itemCd = grid.getValue(rowId, "ITEM_CD");
                    
                    if(grpLvlId == 0 && field == "DETAIL_INFO"){
                        
                        
                        gfn_comPopupOpen("FP_POP", {
                            rootUrl : "supply/product",
                            url     : "oversAndShortagesDetailInfo",
                            width   : 1000,
                            height  : 680,
                            planId : planId,
                            itemCd : itemCd,
                            rowId : rowId,
                            callback : "",
                            menuCd   : "MP113"
                        });
                        
                    }
                    
                    
                }
                
                this.grdMain.setColumnProperty("REVIEW_CONTENTS_SALES","editor", {type : "multiline"});
                   
                this.grdMain.setColumnProperty("REVIEW_CONTENTS_SALES","style", {textWrap : "normal"});         
                    
                this.grdMain.setColumnProperty("REVIEW_CONTENTS_PURCHASE","editor", {type : "multiline"});
                this.grdMain.setColumnProperty("REVIEW_CONTENTS_PURCHASE","style", {textWrap : "normal"});          
                
                this.grdMain.setColumnProperty("REVIEW_CONTENTS_PRODUCTION","editor", {type : "multiline"});
                this.grdMain.setColumnProperty("REVIEW_CONTENTS_PRODUCTION","style", {textWrap : "normal"});          
                
                this.grdMain.setDisplayOptions({eachRowResizable : true});
                
                
            
                
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
                
                oversAndShortages.save();
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
                    
                    if(id == "divPlanId"){
                        EXCEL_SEARCH_DATA += $("#planId option:selected").text();
                    }
                    else if(id == "divItem"){
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
                    }
                }
            });
            
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
                        oversAndShortages.oversAndShortagesGrid.dataProvider.clearRows(); //데이터 초기화
                
                        //그리드 데이터 생성
                        oversAndShortages.oversAndShortagesGrid.grdMain.cancel();
                        
                        oversAndShortages.oversAndShortagesGrid.dataProvider.setRows(data.resList);
                        oversAndShortages.oversAndShortagesGrid.dataProvider.clearSavePoints();
                        oversAndShortages.oversAndShortagesGrid.dataProvider.savePoint(); //초기화 포인트 저장
                        gfn_actionMonthSum(oversAndShortages.oversAndShortagesGrid.gridInstance);
                        gfn_setRowTotalFixed(oversAndShortages.oversAndShortagesGrid.grdMain);
                                
                        oversAndShortages.gridCallback();
                    }
                }
            }
            
            gfn_service(aOption, "obj");
        },
        
        gridCallback : function(){
            
            var iconStyles = [{
                criteria: "value='Y'",
                styles: "iconIndex=0"
            }, {
                criteria: "value='N'",
                styles: "iconIndex=-1"
            }];
            
            //팝업 아이콘
            var imgs = new RealGridJS.ImageList("images1", GV_CONTEXT_PATH + "/statics/images/common/");
            imgs.addUrls([
                "ico_srh.png"
            ]);

            oversAndShortages.oversAndShortagesGrid.grdMain.registerImageList(imgs);
            

            oversAndShortages.oversAndShortagesGrid.grdMain.setColumnProperty("DETAIL_INFO", "imageList", "images1");
            oversAndShortages.oversAndShortagesGrid.grdMain.setColumnProperty("DETAIL_INFO", "renderer", {type : "icon"}); 
            oversAndShortages.oversAndShortagesGrid.grdMain.setColumnProperty("DETAIL_INFO", "styles", {
                textAlignment: "center",
                iconIndex: 0,
                iconLocation: "center",
                iconAlignment: "center",
                iconOffset: 4,
                iconPadding: 2
            });
            
            oversAndShortages.oversAndShortagesGrid.grdMain.setColumnProperty("DETAIL_INFO", "dynamicStyles", iconStyles);
            
            //TOTAL 수정 못하게 막기
            oversAndShortages.oversAndShortagesGrid.grdMain.setCellStyles(0, "DETAIL_INFO", "editNoneStyleTotal");
            
            
            // -------권한처리-------
            /*
            SCM_SEARCH.SALES_ROLE_CNT            AP3
            SCM_SEARCH.PURCHASE_ROLE_CNT         구매팀, 구매팀장
            SCM_SEARCH.PRODUCTION_ROLE_CNT       생산기획팀원
            SCM_SEARCH.SCM_ROLE_CNT              SCM팀
            */
            
            
            var editStyle = {};
            var val = gfn_getDynamicStyle(-2);
            
            editStyle.background = gv_editColor;
            editStyle.editable = true;
            
            val.criteria.push("(values['DETAIL_INFO'] = 'Y')");
            val.styles.push(editStyle);
            
            
            
            var editStyleMatIssue = {};
            var valMatIssue = gfn_getDynamicStyle(-2);
            
            editStyleMatIssue.background = yellowColor;
            
            valMatIssue.criteria.push("(values['MAT_ISSUE_FLAG'] = 'Y')");
            valMatIssue.styles.push(editStyleMatIssue);
            
            oversAndShortages.oversAndShortagesGrid.grdMain.setColumnProperty("ITEM_CD_NM", "dynamicStyles", [valMatIssue])
            
            
            
            if(SCM_SEARCH.SCM_ROLE_CNT  >= 1)
            {
                oversAndShortages.oversAndShortagesGrid.grdMain.setColumnProperty(oversAndShortages.oversAndShortagesGrid.grdMain.columnByField("REVIEW_CONTENTS_SALES"), "dynamicStyles", [val]);
                oversAndShortages.oversAndShortagesGrid.grdMain.setColumnProperty(oversAndShortages.oversAndShortagesGrid.grdMain.columnByField("REVIEW_CONTENTS_PURCHASE"), "dynamicStyles", [val]);
                oversAndShortages.oversAndShortagesGrid.grdMain.setColumnProperty(oversAndShortages.oversAndShortagesGrid.grdMain.columnByField("REVIEW_CONTENTS_PRODUCTION"), "dynamicStyles", [val]);
               
            }
            else if(SCM_SEARCH.SALES_ROLE_CNT >= 1 )
            {
                oversAndShortages.oversAndShortagesGrid.grdMain.setColumnProperty(oversAndShortages.oversAndShortagesGrid.grdMain.columnByField("REVIEW_CONTENTS_SALES"), "dynamicStyles", [val]);
                
            }
            else if(SCM_SEARCH.PURCHASE_ROLE_CNT  >= 1)
            {
                oversAndShortages.oversAndShortagesGrid.grdMain.setColumnProperty(oversAndShortages.oversAndShortagesGrid.grdMain.columnByField("REVIEW_CONTENTS_PURCHASE"), "dynamicStyles", [val]);
                
            }
            else if(SCM_SEARCH.PRODUCTION_ROLE_CNT >= 1)
            {
                oversAndShortages.oversAndShortagesGrid.grdMain.setColumnProperty(oversAndShortages.oversAndShortagesGrid.grdMain.columnByField("REVIEW_CONTENTS_PRODUCTION"), "dynamicStyles", [val]);          
                
            }
            
            
            
            
          //-------------------------------------------------------------
        },
        
        getBucket : function (sqlFlag) {
            var ajaxMap = {
                fromDate : gfn_replaceAll($("#fromCal").val(),"-",""),
                toDate   : gfn_replaceAll($("#toCal").val(),"-",""),
                week     : {isDown: "Y", isUp:"N", upCal:"M", isMt:"N", isExp:"N", expCnt:999},
                sqlId    : ["bucketFullWeek"]
            }
            gfn_getBucket(ajaxMap);
            
            if (!sqlFlag) {
                oversAndShortages.oversAndShortagesGrid.gridInstance.setDraw();
                
                var fileds = oversAndShortages.oversAndShortagesGrid.dataProvider.getFields();
                var filedsLen = fileds.length;
                
                for (var i = 0; i < filedsLen; i++) {
                    var fieldName = fileds[i].fieldName;
                    if (fieldName == 'SALES_PRICE_KRW_NM'){
                        fileds[i].dataType = "number";
                        oversAndShortages.oversAndShortagesGrid.grdMain.setColumnProperty(fieldName, "styles", {"numberFormat" : "#,##0"}); 
                    }
                }
                
                oversAndShortages.oversAndShortagesGrid.dataProvider.setFields(fileds);
                
                
            }
        },
        
        save : function(){
            

            
            //var dateChk = 0;
            var grdData = gfn_getGrdSavedataAll(this.oversAndShortagesGrid.grdMain);
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
                    {outDs : "saveCnt", _siq : "supply.product.oversAndShortagesAddReviewContents", grdData : grdData}
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
        
        var pChangeAreaStart = $("#changeAreaStart").val();
        var pChangeAreaEnd = $("#changeAreaEnd").val();
        
        if(pChangeAreaStart != "" && pChangeAreaEnd != "" && pChangeAreaStart > pChangeAreaEnd){
            alert('<spring:message code="msg.changeCheck" javaScriptEscape="true" />');
            return;
        }

        gfn_getMenuInit();
        
        DIMENSION.hidden = [];
        DIMENSION.hidden.push({CD : "PLAN_ID", dataType : "text"});
        
        oversAndShortages.getBucket(sqlFlag); 
        
        FORM_SEARCH = $("#searchForm").serializeObject(); 
        FORM_SEARCH.sql        = sqlFlag;
        FORM_SEARCH.dimList    = DIMENSION.user;
        FORM_SEARCH.bucketList = BUCKET.query;
        
        oversAndShortages.search();
        oversAndShortages.excelSubSearch();
    }

    // onload 
    $(document).ready(function() {
        oversAndShortages.init();
    });
    
    
    function fn_setNextFieldsBuket() {
        //필드 배열 객체를  생성합니다.
        var fields = [
            {fieldName : "DETAIL_INFO"},
            {fieldName: "AVAIL_QTY", dataType : "number"},                  //가용수량
            {fieldName: "INV_QTY", dataType : "number"},                    //현재고
            {fieldName: "WIP_QTY", dataType : "number"},                    //WIP
            {fieldName: "OPEN_ORDER_QTY", dataType : "number"},             //OPEN  
            {fieldName: "GR_SCHED_QTY", dataType : "number"},               //입고예정
            {fieldName: "SBS_QTY", dataType : "number"},                    //전략재고
            {fieldName: "SS_QTY", dataType : "number"},                     //안전재고
            {fieldName: "WEEK_REMN_QTY", dataType : "number"},              //당주잔량
            {fieldName: "POST_YEAR_QTY", dataType : "number"},              //신규필요수량(1년)
            {fieldName: "NON_MOV_QTY", dataType : "number"},                //미이동
            {fieldName: "OPEN_MAT_QTY", dataType : "number"},               //미투입
            {fieldName: "K_QTY", dataType : "number"},                      //과부족량
            {fieldName: "K_WIP_QTY", dataType : "number"},                  //과재공량
            {fieldName: "K_QTY_PRICE", dataType : "number"},                      //과부족 금액
            {fieldName: "K_WIP_QTY_PRICE", dataType : "number"},                  //과재공 금액
            {fieldName: "NEED_QTY", dataType : "number"},                    //필요수량
            {fieldName: "REVIEW_CONTENTS_SALES"},                             //검토내용(영업)
            {fieldName: "REVIEW_CONTENTS_PURCHASE"},                          //검토내용(구매)
            {fieldName: "REVIEW_CONTENTS_PRODUCTION"}                         //검토내용(생산)
        ];
        
        return fields;
    }
    
    function fn_setNextColumnsBuket() {
        //필드와 연결된 컬럼 배열 객체를 생성합니다.
        var columns = [
            {//상세정보
                name : "DETAIL_INFO", fieldName: "DETAIL_INFO", editable: false, header: {text: '<spring:message code="lbl.detailInfo" javaScriptEscape="true" />'},
                styles: {textAlignment: "near", background: gv_noneEditColor},
                dynamicStyles : [gfn_getDynamicStyle(-1)],
                width: 35
            },
            {//공급현황
                type: "group",
                name: 'SUPPLY_STATUS',
                header: {text: '<spring:message code="lbl.supplyStatus" javaScriptEscape="true" />'},
                fieldName: "SUPPLY_STATUS",
                width: 400,
                columns : [
                    {
                        name : "INV_QTY", fieldName: "INV_QTY",  editable: false, header: {text: '<spring:message code="lbl.curStockQt" javaScriptEscape="true" />'},
                        dynamicStyles : [gfn_getDynamicStyle(-2)],
                        styles: {textAlignment: "far", numberFormat : "#,##0"},
                        dataType : "number",
                        width: 80
                    }, {
                        name : "WIP_QTY", fieldName: "WIP_QTY",  editable: false, header: {text: '<spring:message code="lbl.wipQt" javaScriptEscape="true" />'},
                        dynamicStyles : [gfn_getDynamicStyle(-2)],
                        styles: {textAlignment: "far", numberFormat : "#,##0"},
                        dataType : "number",
                        width: 80
                    }, {
                        name : "OPEN_ORDER_QTY", fieldName: "OPEN_ORDER_QTY",  editable: false, header: {text: '<spring:message code="lbl.openQt" javaScriptEscape="true" />'},
                        dynamicStyles : [gfn_getDynamicStyle(-2)],
                        styles: {textAlignment: "far", numberFormat : "#,##0"},
                        dataType : "number",
                        width: 80
                    }, {
                        name : "GR_SCHED_QTY", fieldName: "GR_SCHED_QTY",  editable: false, header: {text: '<spring:message code="lbl.schedQty" javaScriptEscape="true" />'},
                        dynamicStyles : [gfn_getDynamicStyle(-2)],
                        styles: {textAlignment: "far", numberFormat : "#,##0"},
                        dataType : "number",
                        width: 80
                    }
                ]
            }, {//수요현황
                type: "group",
                name: 'DEMAND_STATUS',
                header: {text: '<spring:message code="lbl.demandStatus" javaScriptEscape="true" />'},
                fieldName: "DEMAND_STATUS",
                width: 480,
                columns : [
                    {//전략재고
                        name : "SBS_QTY", fieldName: "SBS_QTY",  editable: false, header: {text: '<spring:message code="lbl.strategyStock" javaScriptEscape="true" />'},
                        dynamicStyles : [gfn_getDynamicStyle(-2)],
                        styles: {textAlignment: "far", numberFormat : "#,##0"},
                        dataType : "number",
                        width: 80
                    }, 
                    {//안전재고
                        name : "SS_QTY", fieldName: "SS_QTY",  editable: false, header: {text: '<spring:message code="lbl.safetyInv" javaScriptEscape="true" />'},
                        dynamicStyles : [gfn_getDynamicStyle(-2)],
                        styles: {textAlignment: "far", numberFormat : "#,##0"},
                        dataType : "number",
                        width: 80
                    },
                    {//당주잔량
                        name : "WEEK_REMN_QTY", fieldName: "WEEK_REMN_QTY",  editable: false, header: {text: '<spring:message code="lbl.weekRemain" javaScriptEscape="true" />'},
                        dynamicStyles : [gfn_getDynamicStyle(-2)],
                        styles: {textAlignment: "far", numberFormat : "#,##0"},
                        dataType : "number",
                        width: 80
                    },
                    {//신규 필요수량(1년)
                        name : "POST_YEAR_QTY", fieldName: "POST_YEAR_QTY",  editable: false, header: {text: '<spring:message code="lbl.newReqQt" javaScriptEscape="true" />'},
                        dynamicStyles : [gfn_getDynamicStyle(-2)],
                        styles: {textAlignment: "far", numberFormat : "#,##0"},
                        dataType : "number",
                        width: 80
                    }, 
                    {//미이동
                        name : "NON_MOV_QTY", fieldName: "NON_MOV_QTY",  editable: false, header: {text: '<spring:message code="lbl.nonMovingQty" javaScriptEscape="true" />'},
                        dynamicStyles : [gfn_getDynamicStyle(-2)],
                        styles: {textAlignment: "far", numberFormat : "#,##0"},
                        dataType : "number",
                        width: 80
                    }
                    ,{//미투입
                        name : "OPEN_MAT_QTY", fieldName: "OPEN_MAT_QTY",  editable: false, header: {text: '<spring:message code="lbl.nonDeployQty" javaScriptEscape="true" />'},
                        dynamicStyles : [gfn_getDynamicStyle(-2)],
                        styles: {textAlignment: "far", numberFormat : "#,##0"},
                        dataType : "number",
                        width: 80
                    }
                    
                    
                ]
            }, 
            {//Total
                type: "group",
                name: 'TOTAL_COLUMN',
                header: {text: 'Total'},
                fieldName: "TOTAL_COLUMN",
                width: 160,
                columns : [
                    {//가용 수량
                        name : "AVAIL_QTY", fieldName: "AVAIL_QTY",  editable: false, header: {text: '<spring:message code="lbl.availQty" javaScriptEscape="true" />'},
                        dynamicStyles : [gfn_getDynamicStyle(-2)],
                        styles: {textAlignment: "far", numberFormat : "#,##0"},
                        dataType : "number",
                        width: 80
                    }
                    
                    , {//필요수량
                        name : "NEED_QTY", fieldName: "NEED_QTY",  editable: false, header: {text: '필요수량'},
                        dynamicStyles : [gfn_getDynamicStyle(-2)],
                        styles: {textAlignment: "far", numberFormat : "#,##0"},
                        dataType : "number",
                        width: 80
                    }
                ]
            },
            
            
            {//과부족검토
                type: "group",
                name: 'OVER_UNDER_REVIEW',
                header: {text: '<spring:message code="lbl.overAndUnderReview" javaScriptEscape="true" />'},
                fieldName: "OVER_UNDER_REVIEW",
                width: 300,
                columns : [
                    {
                        name : "K_QTY", fieldName: "K_QTY",  editable: false, header: {text: '<spring:message code="lbl.excessShortQt" javaScriptEscape="true" />'},
                        dynamicStyles : [gfn_getDynamicStyle(-2)],
                        styles: {textAlignment: "far", numberFormat : "#,##0"},
                        dataType : "number",
                        width: 80
                    },
                    {
                        name : "K_QTY_PRICE", fieldName: "K_QTY_PRICE",  editable: false, header: {text: '과부족금액'},
                        dynamicStyles : [gfn_getDynamicStyle(-2)],
                        styles: {textAlignment: "far", numberFormat : "#,##0"},
                        dataType : "number",
                        width: 80
                    },
                    {
                        name : "K_WIP_QTY", fieldName: "K_WIP_QTY",  editable: false, header: {text: '<spring:message code="lbl.workQty" javaScriptEscape="true" />'},
                        dynamicStyles : [gfn_getDynamicStyle(-2)],
                        styles: {textAlignment: "far", numberFormat : "#,##0"},
                        dataType : "number",
                        width: 80
                    }, 
                    {
                        name : "K_WIP_QTY_PRICE", fieldName: "K_WIP_QTY_PRICE",  editable: false, header: {text: '과재공금액'},
                        dynamicStyles : [gfn_getDynamicStyle(-2)],
                        styles: {textAlignment: "far", numberFormat : "#,##0"},
                        dataType : "number",
                        width: 80
                    }
                    
                    
                    
                ]
            },
            {//검토내용(영업)
                name : "REVIEW_CONTENTS_SALES", fieldName: "REVIEW_CONTENTS_SALES", editable: false,
                editor       : { type: "multiline", textCase: "upper" },
                header: {text: '검토내용(영업)'},
                styles: {textAlignment: "near", background: gv_noneEditColor, textWrap: 'explicit'},
                width: 100
            },
            {//검토내용(구매)
                name : "REVIEW_CONTENTS_PURCHASE", fieldName: "REVIEW_CONTENTS_PURCHASE",  editable: false, 
                editor       : { type: "multiline", textCase: "upper" },
                header: {text: '검토내용(구매)'},
                styles: {textAlignment: "near", background: gv_noneEditColor, textWrap: 'explicit'},
                width: 100
            },
            {//검토내용(생산)
                name : "REVIEW_CONTENTS_PRODUCTION", fieldName: "REVIEW_CONTENTS_PRODUCTION",   editable: false,
                editor       : { type: "multiline", textCase: "upper" },
                header: {text: '검토내용(생산)'},
                styles: {textAlignment: "near", background: gv_noneEditColor, textWrap: 'explicit'},
                width: 100
            },
            
        ];
        
        return columns;
    }
    
    
function fn_getPlanId(pOption) {
        
        try {
            
            if ($("#planId").length == 0) {
                return;
            }
            
            var params = $.extend({
                _mtd     : "getList",
                tranData : [{outDs : "rtnList", _siq : "common.planId"}]
            }, pOption);
            
            gfn_service({
                url     : GV_CONTEXT_PATH + "/biz/obj.do",
                data    : params,
                async   : false,
                success : function(data) {
                    
                    gfn_setMsCombo("planId", data.rtnList, [""]);
                    
                    $("#planId").on("change", function(e) {
                            
                            var fDs = gfn_getFindDataDsInDs(data.rtnList, {CODE_CD : {VALUE : $(this).val(), CONDI : "="}});
                            
                            if (fDs.length > 0) {
                                
                                $("#releaseFlag").val(fDs[0].RELEASE_FLAG);
                                apsStartWeekMonthList();
                            } 
                        
                    });
                    
                    $("#planId").trigger("change");
                }
            },"obj");
            
        } catch(e) {console.log(e);}
    }
        
    function apsStartWeekMonthList(){
        
        FORM_SEARCH           = {}; //초기화
        FORM_SEARCH.I_PLAN_ID =  $("#planId").val();
        FORM_SEARCH._mtd      = "getList";
        FORM_SEARCH.tranData  = [{ outDs : "rtnList", _siq : "supply.product.apsStartWeekMonth"}];
        gfn_service({
            async   : false,
            url     : GV_CONTEXT_PATH + "/biz/obj.do",
            data    : FORM_SEARCH,
            success : function(data) {
            
                gfn_setMsCombo("demandReflectionPeriod", data.rtnList, [""]);
                $("#demandReflectionPeriod option:eq(12)").attr("selected", "selected");
            }
        },"obj");
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
                <%@ include file="/WEB-INF/view/common/filterMonthSum.jsp"%>
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
                    <input type='hidden' id='releaseFlag' name='releaseFlag'>
                    <div class="view_combo" id="divItem"></div>
                    <div class="view_combo" id="divProcurType"></div>
                    <div class="view_combo" id="divItemType"></div>
                    <div class="view_combo" id="divUpItemGroup"></div>
                    <div class="view_combo" id="divItemGroup"></div>
                    <!--과부족량필터  -->
                    <div class="view_combo" id="divExcessShortQty"></div>
                    <!--과재공량필터  -->
                    <div class="view_combo" id="divOverWorkItemQty"></div>
                    <!--대표거래처그룹  -->
                    <div class="view_combo" id="divRepCustGroup"></div>
                    <!--수요반영 기간  -->
                    <div class="view_combo" id="divDemandReflectionPeriod">
                       <div class="ilist">
                            <div class="itit"><spring:message code="lbl.demandReflectionPeriod"/></div>
                            <div class="iptdv borNone">
                                <select id="demandReflectionPeriod" name="demandReflectionPeriod" class="iptcombo"></select>
                            </div>
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
            <div class="scroll">
                <!-- 그리드영역 -->
                <div id="realgrid" style="width: 100%;" class="realgrid1"></div>
            </div>
            
            <!-- 하단버튼 영역 -->
            <div class="cbt_btn">
                <div class="bright">
                    <a id="btnSave" href="#" class="app2"><spring:message code="lbl.save" /></a>
                </div>
            </div>
            
            
        </div>
    </div>
</body>
</html>
