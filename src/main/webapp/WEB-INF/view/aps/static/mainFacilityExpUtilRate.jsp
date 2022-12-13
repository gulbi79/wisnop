<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
    
    <script type="text/javascript">

    var enterSearchFlag = "Y";
    var mainFacilityExpUtilRate = {

        init : function () {
            gfn_formLoad();
            //this.auth.search();
            this.comCode.initCode();
            this.initFilter();
            this.grid.initGrid();
            this.events();
        },
            
        _siq    : "aps.static.mainFacilityExpUtilRate.",
         
        /*
        * common Code 
        */
        comCode : {
            codeMapEx : null,           
            codeMap : null,
            
            initCode : function () {
                var grpCd = 'PROD_PART';
                this.codeMap = gfn_getComCode(grpCd, 'Y'); 
                this.codeMapEx = gfn_getComCodeEx(["PROD_ITEM_GROUP_MST", "PROD_ITEM_GROUP_DETAIL"]);
                this.codeMap.PROD_PART[0].CODE_NM = "";
                this.codeMap.PROD_PART = this.codeMap.PROD_PART.splice(0,3);
            }
        },
        
      
        
        initFilter : function() {
        	
        	//Plan ID
            fn_getPlanId({picketType:"W",planTypeCd:"MP"});
        	
        	
            gfn_setMsComboAll([
                {target : 'divProdPart'        , id : 'prodPart'        , title : '<spring:message code="lbl.prodPart"/>'        , data : this.comCode.codeMap.PROD_PART, exData:["*"], type : "S" },
                {target : 'divProdItemGroupMst', id : 'prodItemGroupMst', title : '<spring:message code="lbl.prodItemGroupMst"/>', data : [], exData:["*"], type : "S"},
                {target : 'divProdItemGroupDet', id : 'prodItemGroupDet', title : '<spring:message code="lbl.prodItemGroupDet"/>', data : [], exData:[""]},
                
            ]);
            
            $("#prodPart").change(function() {
                var groupMst   = [];
                var workplaces = [];
                
                var selectVal = $("#prodPart").val();
                
                $.each(mainFacilityExpUtilRate.comCode.codeMapEx.PROD_ITEM_GROUP_MST, function(idx, item) {
                    if((selectVal == item.UPPER_CD && item.CODE_CD =='LAM_CNC')||(selectVal == item.UPPER_CD && item.CODE_CD =='LAM_MCT')||(selectVal == item.UPPER_CD && item.CODE_CD =='TEL_MCT')||(selectVal == item.UPPER_CD && item.CODE_CD =='TEL_CNC') ) {
                        groupMst.push(item);
                    }
                });
                
               
                
                gfn_setMsCombo("prodItemGroupMst", groupMst, ["*"]);
               
                $("#prodItemGroupMst").change();
            });
            
            $("#prodItemGroupMst").change(function() {
                
                var groupDet = [];
                var selectVal = $("#prodItemGroupMst").val();
                
                $.each(mainFacilityExpUtilRate.comCode.codeMapEx.PROD_ITEM_GROUP_DETAIL, function(idx, item) {
                    if(selectVal == item.UPPER_CD) {
                        groupDet.push(item);
                    }
                });
                
                gfn_setMsCombo("prodItemGroupDet", groupDet, ["*"]);
            });
            
            
            
        },
        /* 
        * grid  선언
        */
        grid : {
            gridInstance : null,
            grdMain      : null,
            dataProvider : null,
            
            initGrid     : function () {
                
                this.gridInstance = new GRID();
                this.gridInstance.init("realgrid");
                
                this.grdMain      = this.gridInstance.objGrid;
                this.dataProvider = this.gridInstance.objData;
                 
                
            }
            
           
        },
    
        /*
        * event 정의
        */
        events : function () {
            
            $("#btnSearch").on("click", function(e) {
                fn_apply(false);
            });
            
           
        },
        
        getBucket : function(sqlFlag) {
        	
            
            var ajaxMap = null;
            
            
            ajaxMap ={
                         fromDate : $("#fromCal").val().replace(/-/g, ''),
                         toDate   : $("#toCal"  ).val().replace(/-/g, ''),
                         week     : {isDown: "N", isUp:"Y", upCal:"M", isMt:"N", isExp:"N", expCnt:1},
                         sqlId    : ["bucketFullWeek"]
                     }
         
      
            
            gfn_getBucket(ajaxMap);
            
            
            if (!sqlFlag) {
            	
                mainFacilityExpUtilRate.grid.gridInstance.setDraw();
                
                
                $.each(BUCKET.query, function(n, v) {
                    
                    mainFacilityExpUtilRate.grid.grdMain.setColumnProperty(v.CD, "dynamicStyles", function(grid, index, value) {
                       
                        var CATEGORY_CD = grid.getValue(index.itemIndex, "CATEGORY_CD");
                        
                        //  AP2_SP_QTY:  AP2 출하계획 수량
                        if (CATEGORY_CD == 'AP2_SP_QTY') {
                            
                            return {numberFormat : "#,##0"}
                        }
                        //  REQ_PROCESS_T_AP2: 필요 공정시간(AP2)
                        else if(CATEGORY_CD == 'REQ_PROCESS_T_AP2')
                        {
                            return {numberFormat : "#,##0.0"}
                        }
                        //  REQ_PROD_QTY:     생산 필요 수량
                        else if(CATEGORY_CD == 'REQ_PROD_QTY')
                        {
                            return {numberFormat : "#,##0"}
                        }
                        //  REQ_PROCESS_T_PROD: 필요 공정시간(생산필요)
                        else if(CATEGORY_CD == 'REQ_PROCESS_T_PROD')
                        {
                            return {numberFormat : "#,##0.0"}
                        }
                        //  FACILITY_AVAIL_TIME: 설비 가용시간
                        else if(CATEGORY_CD == 'FACILITY_AVAIL_TIME')
                        {
                            return {numberFormat : "#,##0.00"}
                        }
                        //  EXP_UTIL_RATE:        예상 가동률
                        else if(CATEGORY_CD == 'EXP_UTIL_RATE')
                        {
                            return {numberFormat : "#,##0.0", suffix: " %"}
                        }
                        //  EXP_REQ_EQUIPT_QTY:   예상 필요 설비수(JIG 수)
                        else if(CATEGORY_CD == 'EXP_REQ_EQUIPT_QTY')
                        {
                            return {numberFormat : "#,##0.0"}
                        }
                        //  ADD_REQ_EQUIPT_QTY:   추가 필요 설비수
                        else if(CATEGORY_CD == 'ADD_REQ_EQUIPT_QTY')
                        {
                          if(value > 0)
                          {
                              return {numberFormat : "#,##0.0",foreground:"#ff0000"} 
                          }
                          else
                          {
                              return {numberFormat : "#,##0.0",foreground:"#0054FF"}                              
                          }
                            
                        }
                        //  ADD_REQ_JIG_QTY:      추가 필요 JIG수
                        else if(CATEGORY_CD == 'ADD_REQ_JIG_QTY')
                        {
                            if(value > 0)
                            {
                                return {numberFormat : "#,##0.0",foreground:"#ff0000"} 
                            }
                            else
                            {
                                return {numberFormat : "#,##0.0",foreground:"#0054FF"}                              
                            }
                        }
                        
                        /*
                        [
                            
                            //  AP2_SP_QTY:  AP2 출하계획 수량
                            {
                                criteria : "(values['CATEGORY_CD'] = 'AP2_SP_QTY')",
                                styles   : {numberFormat : "#,##0"}
                            },
                          
                          //  REQ_PROCESS_T_AP2: 필요 공정시간(AP2)
                            {
                                criteria : "(values['CATEGORY_CD'] = 'REQ_PROCESS_T_AP2')",
                                styles   : {numberFormat : "#,##0.0"}
                            },
                          
                          //  REQ_PROD_QTY:     생산 필요 수량
                            {
                                criteria : "(values['CATEGORY_CD'] = 'REQ_PROD_QTY')",
                                styles   : {numberFormat : "#,##0"}
                            },
                          
                          //  REQ_PROCESS_T_PROD: 필요 공정시간(생산필요)
                            {
                                criteria : "(values['CATEGORY_CD'] = 'REQ_PROCESS_T_PROD')",
                                styles   : {numberFormat : "#,##0.0"}
                            },
                          
                          //  FACILITY_AVAIL_TIME: 설비 가용시간
                            {
                                criteria : "(values['CATEGORY_CD'] = 'FACILITY_AVAIL_TIME')",
                                styles   : {numberFormat : "#,##0.00"}
                            },
                          
                          //  EXP_UTIL_RATE:        예상 가동률
                            {
                                criteria : "(values['CATEGORY_CD'] = 'EXP_UTIL_RATE')",
                                styles   : {numberFormat : "#,##0.0", suffix: " %"}
                            },
                          
                          //  EXP_REQ_EQUIPT_QTY:   예상 필요 설비수(JIG 수)
                            {
                                criteria : "(values['CATEGORY_CD'] = 'EXP_REQ_EQUIPT_QTY')",
                                styles   : {numberFormat : "#,##0.0"}
                            },
                          
                          //  ADD_REQ_EQUIPT_QTY:   추가 필요 설비수
                            {
                                criteria : "(values['CATEGORY_CD'] = 'ADD_REQ_EQUIPT_QTY')",
                                styles   : {
                                            numberFormat : "#,##0.0"
                                            ,foreground:"#0054FF"   
                                }
                            },
                          
                          //  ADD_REQ_JIG_QTY:      추가 필요 JIG수
                            {
                                criteria : "(values['CATEGORY_CD'] = 'ADD_REQ_JIG_QTY')",
                                styles   : {
                                            numberFormat : "#,##0.0"
                                            ,foreground:"#0054FF"
                                }
                            },
                          
                        ]
                        */
                        
                    }
                        
                   );//end of setColumnProperty
                });
                
            
            }//end of if
        	
        	
        	
        },
        
        selectProdPart : "",
        
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
                    if(id == "divPlanId"){
                    	EXCEL_SEARCH_DATA += $("#planId option:selected").text();
                    }
                    else if(id == "divProdPart"){
                        EXCEL_SEARCH_DATA += $("#prodPart option:selected").text();
                    }else if(id == "divProdItemGroupMst"){
                        EXCEL_SEARCH_DATA += $("#prodItemGroupMst option:selected").text();
                    }else if(id == "divProdItemGroupDet"){
                        $.each($("#prodItemGroupDet option:selected"), function(i2, val2){
                            
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
            EXCEL_SEARCH_DATA += "\n" + '<spring:message code="lbl.period"/>' + " : ";
            EXCEL_SEARCH_DATA += $("#fromCal").val() + "(" + $("#fromPWeek").val() + ") ~ ";
            EXCEL_SEARCH_DATA += $("#toCal").val() + "(" + $("#toPWeek").val() + ")";
        },
        
        // 조회
        search : function () {
            

            FORM_SEARCH._mtd     = "getList";
            FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq + "list" }];
            
            var aOption = {
                url     : GV_CONTEXT_PATH + "/biz/obj",
                data    : FORM_SEARCH,
                success : function (data) {

                    if (FORM_SEARCH.sql == 'N') {
                        mainFacilityExpUtilRate.grid.dataProvider.clearRows(); //데이터 초기화
                
                        //그리드 데이터 생성
                        mainFacilityExpUtilRate.grid.grdMain.cancel();
                        
                        mainFacilityExpUtilRate.grid.dataProvider.setRows(data.resList);
                        mainFacilityExpUtilRate.grid.dataProvider.clearSavePoints();
                        mainFacilityExpUtilRate.grid.dataProvider.savePoint(); //초기화 포인트 저장
                        gfn_setSearchRow(mainFacilityExpUtilRate.grid.dataProvider.getRowCount());
                     
                    }
                }
            }
            
            mainFacilityExpUtilRate.selectProdPart = $("#prodPart").val();
            gfn_service(aOption, "obj");
        }
        
       
        
        
     
    };
    
    
    

    //조회
    var fn_apply = function (sqlFlag) {
    	gfn_getMenuInit();
        var prodPart         = $("#searchForm #prodPart").val();
        var prodItemGroupMst = $("#searchForm #prodItemGroupMst").val();
        var prodItemGroupDet = $("#searchForm #prodItemGroupDet").multipleSelect('getSelects');
        
        if(prodPart == ""){
            alert('<spring:message code="msg.prodPartMsg"/>');
            return;
        }
        
        if(prodItemGroupMst == ""){
            alert('<spring:message code="msg.productCateMsg"/>');
            return;
        }
        
        // 디멘전 정리
        DIMENSION.user = [];
        DIMENSION.user.push({DIM_CD:"PRODUCT_CATE", DIM_NM:'제품분류', LVL:10, DIM_ALIGN_CD:"C", WIDTH:100});
        DIMENSION.user.push({DIM_CD:"JIG_HOLDING_QTY"       , DIM_NM:'지그 보유 수량', LVL:10, DIM_ALIGN_CD:"R", WIDTH:100});
        DIMENSION.user.push({DIM_CD:"PROCESS"       , DIM_NM:'공정', LVL:10, DIM_ALIGN_CD:"C", WIDTH:100});
        DIMENSION.user.push({DIM_CD:"ALLOCATED_FACILITY_QTY"   , DIM_NM:'할당 설비 대수', LVL:10, DIM_ALIGN_CD:"R", WIDTH:100});
        DIMENSION.user.push({DIM_CD:"PRODUCT_ITEM_QTY" , DIM_NM:'제품 품목 수', LVL:10, DIM_ALIGN_CD:"R", WIDTH:100});
        
        // 버켓 조회
        mainFacilityExpUtilRate.getBucket(sqlFlag);
        
        //조회조건 설정
        FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
        FORM_SEARCH.sql        = sqlFlag;
        FORM_SEARCH.dimList    = DIMENSION.user;
        FORM_SEARCH.meaList    = MEASURE.user;
        
        FORM_SEARCH.bucketList = BUCKET.query;
        
        mainFacilityExpUtilRate.search();
        mainFacilityExpUtilRate.excelSubSearch();
    }

    // onload 
    $(document).ready(function() {
        mainFacilityExpUtilRate.init();
    });
    
    
    

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
                url     : GV_CONTEXT_PATH + "/biz/obj",
                data    : params,
                async   : false,
                success : function(data) {
                    
                    gfn_setMsCombo("planId", data.rtnList, [""]);
                    
                    $("#planId").on("change", function(e) {
                        
                        
                            var nowDate = null;
                            var endDate = null;
                            var fDs = gfn_getFindDataDsInDs(data.rtnList, {CODE_CD : {VALUE : $(this).val(), CONDI : "="}});
                            if (fDs.length > 0) {
                                
                            	nowDate = fDs[0].SW_START_DATE;
                            	endDate = fDs[0].SW_END_DATE
                            	
                                DATEPICKET(null, nowDate, endDate);
                                
                                var sdt = gfn_getStringToDate(nowDate);
                                
                                var edt = gfn_getStringToDate(endDate);
                                
                                $("#fromCal").datepicker("option", "minDate", sdt);
                                $("#fromCal").datepicker("option", "maxDate", edt);
                                $("#toCal").datepicker("option", "maxDate", edt);
                                
                                
                            } 
                        
                            
                     
                        
                    });
                    
                    $("#planId").trigger("change");
                }
            },"obj");
            
        } catch(e) {console.log(e);}
    }
    
    function weekdatecal(dt, days){
        
        yyyy = dt.substr(0, 4);
        mm   = dt.substr(4, 2);
        dd   = dt.substr(6, 2);
        
        var date = new Date(yyyy + "/" + mm + "/" + dd);
        
        date.setDate(date.getDate() + days);
        
        var rdt = date.getFullYear() + '' + ((date.getMonth() + 1)  < 10 ? '0' + (date.getMonth() + 1) : (date.getMonth() + 1) ) + (date.getDate() < 10 ? '0' + date.getDate() : date.getDate());
        
        return rdt;
    
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
                    <div class="view_combo" id="divPlanId">
                        <div class="ilist">
                            <div class="itit"><spring:message code="lbl.planId"/></div>
                            <div class="iptdv borNone">
                                <select id="planId" name="planId" class="iptcombo"></select>
                            </div>
                        </div>
                    </div>
                  
                    <div class="view_combo" id="divProdPart"></div>
                    <div class="view_combo" id="divProdItemGroupMst"></div>
                    <div class="view_combo" id="divProdItemGroupDet"></div>
                  
                    <div id="filterViewWeek"><jsp:include page="/WEB-INF/view/common/filterViewHorizon.jsp" flush="false" /></div>
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
            
        </div>
    </div>
</body>
</html>
