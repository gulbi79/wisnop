<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
<script type="text/javascript">
    var enterSearchFlag = "Y";
    var monthArray  = [];
    var weekArray   = [];
    var urgentPerformance = {
        init : function () {
            gfn_formLoad();
            this.comCode.initCode();
            this.initFilter();
            this.grid.initGrid();
            this.events();
        },
        
        _siq    : "aps.dynamic.urgentPerformance",
        
        comCode : {
            codeMapEx : null,           
            codeMap : null,
            
            
            initCode : function () {
                var grpCd = 'URGENT_REASON_CD';
                this.codeMap = gfn_getComCode(grpCd, 'Y'); 
                this.codeMapEx = gfn_getComCodeEx(["ROUTING"], null, {itemType : "10,50"});
            }
            
        },
        
        
        initFilter : function() {
        	fn_getYearId();
        	fn_getMonth();
            fn_getWeek();
            
            fn_urgentPerformanceSummaryByItemDate();
            
            // 키워드팝업
            gfn_keyPopAddEvent([
                { target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>' }
            ]);
            
            // 콤보박스
            gfn_setMsComboAll([
                {target : 'divRoute'       , id : 'route'        , title : '<spring:message code="lbl.routing"/>'      , data : this.comCode.codeMapEx.ROUTING,        exData:["*"] },
                {target : 'divReqType'     , id : 'reqType'        , title : '<spring:message code="lbl.urgentReasonCd"/>'      , data : this.comCode.codeMap.URGENT_REASON_CD,        exData:["*"] },
                {target : 'divMonth'       , id : 'month'        , title : '해당월'      , data : monthArray,        exData:["*"] },
                {target : 'divWeek'        , id : 'week'         , title : '해당주차'      , data : weekArray,        exData:["*"] }
            ]);
            
            var date = new Date();
            var m = date.getMonth()+1;
            var nowMonth = [];
            nowMonth.push(date.getFullYear()+(m>9?m:'0'+m))
            
            $("#month").multipleSelect("setSelects",nowMonth);
            
            $('#month').change(function() {
            	fn_getWeek();
            	gfn_setMsCombo("week", weekArray, ["*"]);
            	
            });
            
            
        },
        
        grid : {
            gridInstance : null,
            grdMain      : null,
            dataProvider : null,
            
            initGrid : function() {
                this.gridInstance = new GRID();
                this.gridInstance.init("realgrid");
                
                this.grdMain      = this.gridInstance.objGrid;
                this.dataProvider = this.gridInstance.objData;
                
                this.setColumn();
                this.setOptions();
                

            },
            
            setColumn : function() {
                var columns = [
                    
                	{
                        name : "MONTH", fieldName : "MONTH", editable : false, header: {text: '월'},
                        styles : {textAlignment: "center" , background :"#edf7fd"},
                        
                        width : 120
                    },
                    {
                        name : "YEARPWEEK", fieldName : "YEARPWEEK", editable : false, header: {text: '주차(요청납기일 기준)'},
                        styles : {textAlignment: "center", background :"#edf7fd"},
                        
                        width : 120
                    },
                	{
                        name : "ITEM_CD", fieldName : "ITEM_CD", editable : false, header: {text: '<spring:message code="lbl.itemCd" javaScriptEscape="true" />'},
                        styles : {textAlignment: "center", background :"#edf7fd"},
                        width : 120
                    }, {
                        name : "ITEM_NM", fieldName : "ITEM_NM", editable : false, header: {text: '<spring:message code="lbl.itemName" javaScriptEscape="true" />'},
                        styles : {textAlignment: "center", background :"#edf7fd"},
                        width : 120
                    }, {
                        name : "ROUTING_ID", fieldName : "ROUTING_ID", editable : false, header: {text: '<spring:message code="lbl.routing" javaScriptEscape="true" />'},
                        styles : {textAlignment: "center", background :"#edf7fd"},
                        width : 120
                    }, {
                        name : "SPEC", fieldName : "SPEC", editable : false, header: {text: '<spring:message code="lbl.spec" javaScriptEscape="true" />'},
                        styles : {textAlignment: "center", background :"#edf7fd"},
                        width : 120
                    },
                    {
                        name : "CONF_DATE", fieldName : "CONF_DATE", editable : false, header: {text: '협의일자'},
                        styles : {textAlignment: "center", datetimeFormat : "yyyy-MM-dd", background :"#edf7fd"},
                        
                        width : 120
                    },
                    {
                        name : "DUE_DATE", fieldName : "DUE_DATE", editable : false, header: {text: '<spring:message code="lbl.dueDate" javaScriptEscape="true" />'},
                        styles : {textAlignment: "center", datetimeFormat : "yyyy-MM-dd", background :"#edf7fd"},
                        
                        width : 120
                    },
                    {
                        name : "URGENT_REASON_CD", fieldName : "URGENT_REASON_CD", editable : false, header: {text: '<spring:message code="lbl.urgentReasonCd" javaScriptEscape="true" />'},
                        styles : {textAlignment: "center", background :"#edf7fd"}, 
                        width  : 120,
                        values : gfn_getArrayExceptInDs(urgentPerformance.comCode.codeMap.URGENT_REASON_CD, "CODE_CD", ""),
                        labels : gfn_getArrayExceptInDs(urgentPerformance.comCode.codeMap.URGENT_REASON_CD, "CODE_NM", ""),
                        lookupDisplay: true
                    },
                    {
						name : "CREATE_DTTM", fieldName : "CREATE_DTTM", editable : false, header: {text: '<spring:message code="lbl.regDttm" javaScriptEscape="true" />'},
						styles : {textAlignment: "center", background : gv_noneEditColor},
						width : 120
					},
                    {
                        name : "REQ_QTY", fieldName : "REQ_QTY", editable : false, header: {text: '<spring:message code="lbl.reqQty2" javaScriptEscape="true" />'},
                        editor : { type : "number", textAlignment : "far", editFormat : "#,##0", integerOnly : true},
                        styles : {textAlignment: "center", numberFormat : "#,##0", background : gv_noneEditColor},
                        width : 120
                    }, 
                    {
                        name : "RESULT_QTY", fieldName : "RESULT_QTY", editable : false, header: {text: '실적수량'},
                        editor : { type : "number", textAlignment : "far", editFormat : "#,##0", integerOnly : true},
                        styles : {textAlignment: "center", numberFormat : "#,##0", background : gv_noneEditColor},
                        width : 120
                    },
                    {
                        name : "RELEASE_DATE", fieldName : "RELEASE_DATE", editable : false, header: {text: '완료일'},
                        styles : {textAlignment: "center", datetimeFormat : "yyyy-MM-dd", background :"#edf7fd"},
                        
                        width : 120
                    },
                    {
                        name : "SUCCESS_YN", fieldName : "SUCCESS_YN", editable : false, header: {text: '달성'},
                        styles : {textAlignment: "center" , background : gv_noneEditColor},
                        
                        width : 120
                    },
                    {
                        name : "FAIL_YN", fieldName : "FAIL_YN", editable : false, header: {text: '미달성'},
                        styles : {textAlignment: "center" , background : gv_noneEditColor},
                        
                        width : 120
                    },
                    {
                        name : "ACHIVE_YN", fieldName : "ACHIVE_YN", editable : false, header: {text: '준수'},
                        styles : {textAlignment: "center" , background : gv_noneEditColor},
                        
                        width : 120
                    },
                    {
                        name : "OVER_SHORT", fieldName : "OVER_SHORT", editable : false, header: {text: '과부족'},
                        editor : { type : "number", textAlignment : "far", editFormat : "#,##0", integerOnly : true},
                        styles : {textAlignment: "far", numberFormat : "#,##0", background :gv_noneEditColor},
                        width : 120,
                        dataType : "number"
                        
                    },
                    {
                        name : "COMPLIANCE_RATE", fieldName : "COMPLIANCE_RATE", editable : false, header: {text: '준수율'},
                        editor : { type : "number", textAlignment : "far", editFormat : "#,##0.0", integerOnly : true},
                        styles : {textAlignment: "far", numberFormat : "#,##0.0", background :gv_noneEditColor, suffix: " %"},
                        width : 120,
                        dataType : "number"
                        
                    },
                    
                    {
                        name : "SALES_PRICE_KRW", fieldName : "SALES_PRICE_KRW", editable : false, header: {text: '<spring:message code="lbl.unitPrice" javaScriptEscape="true" />'},
                        editor : { type : "number", textAlignment : "far", editFormat : "#,##0", integerOnly : true},
                        styles : {textAlignment: "far", numberFormat : "#,##0", background :"#edf7fd"},
                        width : 120,
                        dataType : "number"
                        
                    }, {
                        name : "REP_CUST_GROUP_NM", fieldName : "REP_CUST_GROUP_NM", editable : false, header: {text: '대표거래처'},
                        styles : {textAlignment: "center", background :"#edf7fd"},
                        width : 120
                    }
                    
                ];
                
                this.setFields(columns, ["COMPANY_CD", "BU_CD"]);
                
                this.grdMain.setColumns(columns); 
            },
            
            setFields : function(cols, hiddenCols) {
                var fields = new Array();
                
                $.each(cols, function(i, v) {
                    
                    var tFieldName = v.fieldName;
                    var tDataType = v.dataType;
                    
                    fields.push({fieldName : tFieldName, dataType : tDataType});
                    
                });
                
                if (hiddenCols !== undefined && hiddenCols.length > 0) {
                    for (hid in hiddenCols) {
                        fields.push({fieldName : hiddenCols[hid]});
                    }
                }
                
                this.dataProvider.setFields(fields);
            },
            
            setOptions : function() {
                this.grdMain.setOptions({
                    checkBar: { visible : true },
                    stateBar: { visible : true }
                });

                this.dataProvider.setOptions({
                    softDeleting : true
                });
                
                this.grdMain.addCellStyles([{
                    id         : "editStyle",
                    editable   : true,
                    background : gv_editColor
                }]);
                
                this.grdMain.addCellStyles([{
                    id         : "editNoneStyle",
                    editable   : false,
                    background : gv_noneEditColor
                }]);
                
                this.grdMain.setPasteOptions({
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
            }
        },
        
        events : function () {
           
        	$("#btnSearch").on("click", function(e) {
                fn_apply(false);
            });
        	
        	$("#btnSummaryByItem").on("click", function(e) {
                
                gfn_comPopupOpen("JOB_LIST", {
                    rootUrl    : "aps/dynamic",
                    url        : "urgentPerformanceSummaryByItem",
                    width      : 1200,
                    height     : 800,
                    yearId     : $('#yearId').val(),
                    fromCalDate    : $('#fromCalDate').val(),
                    toCalDate      : $('#toCalDate').val()
                    
                });
             
             });
             
        	$("#btnCumulativeComplianceRate").on("click", function(e) {
            
        	   gfn_comPopupOpen("JOB_LIST", {
                   rootUrl    : "aps/dynamic",
                   url        : "urgentPerformanceCumComplRate",
                   width      : 1200,
                   height     : 400,
                   yearId     : $('#yearId').val(),
                   fromCal    : $('#fromCal').val(),
                   toCal      : $('#toCal').val()
                   
               });
        	
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
                        
                    if(id == "divItem"){
                        EXCEL_SEARCH_DATA += $("#item_nm").val();
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
                    }
                }
            });
        },
        
        search : function () {
            
            
            FORM_SEARCH._mtd     = "getList";
            FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq}];
            var aOption = {
                url     : GV_CONTEXT_PATH + "/biz/obj.do",
                data    : FORM_SEARCH,
                success : function (data) {
                    
                    if (FORM_SEARCH.sql == 'N') {
                        
                         
                         
                        urgentPerformance.grid.dataProvider.clearRows(); //데이터 초기화
                
                        //그리드 데이터 생성
                        urgentPerformance.grid.grdMain.cancel();
                        
                        urgentPerformance.grid.dataProvider.setRows(data.resList);
                        urgentPerformance.grid.dataProvider.clearSavePoints();
                        urgentPerformance.grid.dataProvider.savePoint(); //초기화 포인트 저장
                        gfn_setSearchRow(urgentPerformance.grid.dataProvider.getRowCount());
                        
                        if(data.resList.length > 0){
                            urgentPerformance.gridCallback(data.resList);   
                        }
                        
                        
                    }
                }
            }
                
           gfn_service(aOption, "obj")
            
        },
        
        
        gridCallback : function(resList) {
            
        	  
        	urgentPerformance.grid.grdMain.setColumnProperty("OVER_SHORT", "dynamicStyles", function(grid, index, value) {
                
                    if(value >= 0)
                    {
                        return {foreground:"#ff0000"} 
                    }
                    else
                    {
                        return {foreground:"#0054FF"}                              
                    }
                
              }
                  
             );//end of setColumnProperty
        	
        	
        	  
            
        }
     
    };
    
    //조회
 function fn_apply(sqlFlag) {
        //조회조건 설정
        FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
        FORM_SEARCH.sql        = sqlFlag;
            
        urgentPerformance.search();
        urgentPerformance.excelSubSearch();
    }
    
    // onload 
    $(document).ready(function() {
        urgentPerformance.init();
    });
    
    function getAddDay(days) {
        var date = new Date();
        date.setDate(date.getDate() + days);
        return date;
    }
  
    
    
    
    function now(){
        var date = new Date();
        var m = date.getMonth()+1;
        var d = date.getDate();
        var h = date.getHours();
        var i = date.getMinutes();
        var s = date.getSeconds();
        return date.getFullYear()+'-'+(m>9?m:'0'+m)+'-'+(d>9?d:'0'+d)+' '+(h>9?h:'0'+h)+':'+(i>9?i:'0'+i)+':'+(s>9?s:'0'+s);
    }
    
    function nowMonth(){
        var date = new Date();
        var m = date.getMonth()+1;
        var d = date.getDate();
        var h = date.getHours();
        var i = date.getMinutes();
        var s = date.getSeconds();
        return date.getFullYear()+(m>9?m:'0'+m);
    }
    
    
    /*
     * 날짜포맷에 맞는지 검사
     */
    function isDateFormat(d) {
        var df = /[0-9]{4}-[0-9]{2}-[0-9]{2}/;
        return d.match(df);
    }

    /*
     * 윤년여부 검사
     */
    function isLeaf(year) {
        var leaf = false;

        if(year % 4 == 0) {
            leaf = true;

            if(year % 100 == 0) {
                leaf = false;
            }

            if(year % 400 == 0) {
                leaf = true;
            }
        }

        return leaf;
    }

    /*
     * 날짜가 유효한지 검사
     */
    function isValidDate(d) {
        
        d = d.substring(0, 4) + "-" + d.substring(4, 6) + "-" + d.substring(6, 8);
        
        if(!isDateFormat(d)) {
            return false;
        }

        var month_day = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

        var dateToken = d.split('-');
        var year = Number(dateToken[0]);
        var month = Number(dateToken[1]);
        var day = Number(dateToken[2]);
        
        // 날짜가 0이면 false
        if(day == 0) {
            return false;
        }

        var isValid = false;

        // 윤년일때
        if(isLeaf(year)) {
            if(month == 2) {
                if(day <= month_day[month-1] + 1) {
                    isValid = true;
                }
            } else {
                if(day <= month_day[month-1]) {
                    isValid = true;
                }
            }
        } else {
            if(day <= month_day[month-1]) {
                isValid = true;
            }
        }

        return isValid;
    }
    
function fn_getYearId(pOption) {
        
        try {
            
            if ($("#yearId").length == 0) {
                return;
            }
            
            var params = $.extend({
                _mtd     : "getList",
                tranData : [{outDs : "rtnList", _siq : "aps.dynamic.urgentPerformanceYear"}]
            }, pOption);
            
            gfn_service({
                url     : GV_CONTEXT_PATH + "/biz/obj.do",
                data    : params,
                async   : false,
                success : function(data) {
                    
                    
                    gfn_setMsCombo("yearId", data.rtnList, [""]);
                    
                    $("#yearId").on("change", function(e) {
                        

                            var nowDate = null;
                            var endDate = null;
                            var fDs = gfn_getFindDataDsInDs(data.rtnList, {CODE_CD : {VALUE : $(this).val(), CONDI : "="}});
                            
                            if (fDs.length > 0) {
                                
                                startDate = fDs[0].YEAR_START_DATE;
                                endDate = fDs[0].YEAR_END_DATE
                                
                                DATEPICKET(null, startDate, endDate);
                                
                                var sdt = gfn_getStringToDate(startDate);
                                
                                var edt = gfn_getStringToDate(endDate);
                                
                                $("#fromCal").datepicker("option", "minDate", sdt);
                                $("#fromCal").datepicker("option", "maxDate", edt);
                                $("#toCal").datepicker("option", "maxDate", edt);
                                
                            } 
                           
                    });
                    
                    $("#yearId").trigger("change");
                }
            },"obj");
            
        } catch(e) {console.log(e);}
    }
 
function fn_getMonth(){
	
	 try {
         
         
         var params  = {
             _mtd     : "getList",
             tranData : [
            	   {outDs : "rtnMonth", _siq : "aps.dynamic.urgentPerformanceMonth"}
            	 ]
         
         };
         
         gfn_service({
             url     : GV_CONTEXT_PATH + "/biz/obj.do",
             data    : params,
             async   : false,
             success : function(data) {
                 
            	 monthArray = data.rtnMonth
                
             }
         },"obj");
         
     } catch(e) {console.log(e);}
	
}

function fn_getWeek(){
	
 try {
         
	     FORM_SEARCH = {};
	     
	     var temp = $('#month').val();
	    
	     if(temp != undefined)
	     {
	    	 FORM_SEARCH._mtd = "getList",
             FORM_SEARCH.tranData = [{outDs : "rtnWeek", _siq : "aps.dynamic.urgentPerformanceWeek"}],
             FORM_SEARCH.selectedMonth    = temp.join(",")
         	 
	     }
	     else{
	    	 FORM_SEARCH._mtd = "getList",
             FORM_SEARCH.tranData = [{outDs : "rtnWeek", _siq : "aps.dynamic.urgentPerformanceWeek"}]
	     }
	     
	     
	     gfn_service({
             url     : GV_CONTEXT_PATH + "/biz/obj.do",
             data    : FORM_SEARCH,
             async   : false,
             success : function(data) {
                 
            	 weekArray = data.rtnWeek
                 
             }
         },"obj");
         
     } catch(e) {console.log(e);}
	
}

function fn_urgentPerformanceSummaryByItemDate(){
	
	var cDate = gfn_getCurrentDate();
	var pDate = gfn_getAddDate(cDate.YYYYMMDD, -42)
	
	
	$('#fromCalDate').val(pDate.YYYYMMDD);
    $('#toCalDate').val(cDate.YYYYMMDD);
	
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
                    <div class="view_combo" id="divYear">
                        <div class="ilist">
                            <div class="itit">해당년도</div>
                            <div class="iptdv borNone">
                                <select id="yearId" name="yearId" class="iptcombo"></select>
                            </div>
                        </div>
                    </div>
                    <!-- 해당월 -->
                    <div class="view_combo" id="divMonth"></div>
                    <!-- 해당주차 -->
                    <div class="view_combo" id="divWeek"></div>
                    <!-- 요청유형 -->
                    <div class="view_combo" id="divReqType"></div>
                    
                    <div class="view_combo" id="divRoute"></div>
                    <div class="view_combo" id="divItem"></div>
                    <input type="hidden" id="fromCalDate" name="fromCalDate" />
                    <input type="hidden" id="toCalDate" name="toCalDate"     />
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
            <div class="cbt_btn">
                <div class="bright">

                    <a id="btnSummaryByItem" href="#" class="app2">품목별요약</a>
                    <a id="btnCumulativeComplianceRate" href="#" class="app2">누적준수율</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>