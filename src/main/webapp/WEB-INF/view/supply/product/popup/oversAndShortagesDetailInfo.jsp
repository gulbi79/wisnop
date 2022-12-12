<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
    <jsp:param name="popupYn" value="Y"/>
</jsp:include>

<script type="text/javascript">
    var popupWidth, popupHeight;
    //var codeMap, codeMapEx;
    var popUpMenuCd = "${param.menuCd}";
    var lv_conFirmFlag = true;
    var oversAndShortagesDetailInfo = {
            
        init : function() {
            gfn_popresize();
            this.comCode.initCode();
            this.grid.initGrid();
            this.events();
            fn_apply();
        }, 
        
        _siq    : "supply.product.detailInfoList",
        
        comCode : {
            codeMapEx : null,           
            codeMap : null,
            
            initCode : function () {
            }
        },
        
        grid : {
            
            gridInstance : null,
            grdMain      : null,
            dataProvider : null,
            
            initGrid : function() {
                
                this.gridInstance = new GRID();
                this.gridInstance.init("realgrid");
                this.gridInstance.totalFlag = true;
                this.gridInstance.custBucketFalg = true;
                
                this.grdMain      = this.gridInstance.objGrid;
                this.dataProvider = this.gridInstance.objData;
            }
        },
        
        events : function () {
            $("#btnClose").on("click", function() { 
                window.close(); 
            });
            
            $("#btnSearch").on("click", function(e) {
                fn_apply(false);
            }); 
        },
        
        getBucket : function(sqlFlag) {
            
            if (!sqlFlag) {
                oversAndShortagesDetailInfo.grid.gridInstance.setDraw();
                
                //조회조건 설정
                FORM_SEARCH = $("#searchForm").serializeObject();
                FORM_SEARCH.sql        = sqlFlag;
                FORM_SEARCH.bucketList = BUCKET.query;
                FORM_SEARCH.dimList    = DIMENSION.user;
                
                oversAndShortagesDetailInfo.search();
            } 
            //SQL 쿼리 조회 버튼 
            else
            {
                //조회조건 설정
                FORM_SEARCH = $("#searchForm").serializeObject();
                FORM_SEARCH.sql        = sqlFlag;
                FORM_SEARCH.bucketList = BUCKET.query;
                FORM_SEARCH.dimList    = DIMENSION.user;
                
                oversAndShortagesDetailInfo.search();
            }
        },
        
        search : function () {
            FORM_SEARCH._mtd     = "getList";
            FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq}];
            
            var aOption = {
                url     : GV_CONTEXT_PATH + "/biz/obj.do",
                data    : FORM_SEARCH,
                success : function (data) {
                    
                    if (FORM_SEARCH.sql == 'N') {
                        
                    	var resList = data.resList;
                    	var resListLen = resList.length;
                        
                        if(resListLen == 0){
                            alert('<spring:message code="msg.noDataFound"/>');
                            return;
                        }
                        
                    	oversAndShortagesDetailInfo.grid.dataProvider.clearRows(); //데이터 초기화
                        
                        //그리드 데이터 생성
                        oversAndShortagesDetailInfo.grid.grdMain.cancel();
                        
                        oversAndShortagesDetailInfo.grid.dataProvider.setRows(data.resList);
                        oversAndShortagesDetailInfo.grid.dataProvider.clearSavePoints();
                        //oversAndShortagesDetailInfo.grid.dataProvider.savePoint(); //초기화 포인트 저장
                        //gfn_setSearchRow(oversAndShortagesDetailInfo.grid.dataProvider.getRowCount());
                        //gfn_actionMonthSum(oversAndShortagesDetailInfo.grid.gridInstance);
                        //gfn_setRowTotalFixed(oversAndShortagesDetailInfo.grid.grdMain);
                    }
                }
            }
            gfn_service(aOption, "obj");
        }
    };
    
    var fn_apply = function(sqlFlag) {
        
        // 디멘전 정리
        DIMENSION.user = [];
        DIMENSION.user.push({DIM_CD:"MEAS_NM", DIM_NM:'<spring:message code="lbl.generationCriteria"/>', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100, SQL_TOTAL_FLAG:"Y"});
        DIMENSION.user.push({DIM_CD:"ITEM_CD", DIM_NM:'<spring:message code="lbl.materialsCode"/>', LVL:20, DIM_ALIGN_CD:"L", WIDTH:100});
        DIMENSION.user.push({DIM_CD:"ITEM_NM", DIM_NM:'<spring:message code="lbl.materialsName"/>', LVL:20, DIM_ALIGN_CD:"L", WIDTH:100});
        DIMENSION.user.push({DIM_CD:"SPEC", DIM_NM:'<spring:message code="lbl.materialsSpec"/>', LVL:20, DIM_ALIGN_CD:"L", WIDTH:100});
        DIMENSION.user.push({DIM_CD:"REP_CUST_GROUP_NM", DIM_NM:'<spring:message code="lbl.salesGroupNm"/>', LVL:20, DIM_ALIGN_CD:"L", WIDTH:100});
        DIMENSION.user.push({DIM_CD:"PARENT_ITEM_CD", DIM_NM:'<spring:message code="lbl.parentItemCd"/>', LVL:20, DIM_ALIGN_CD:"L", WIDTH:100});
        DIMENSION.user.push({DIM_CD:"PARENT_SPEC", DIM_NM:'<spring:message code="lbl.parentSpec"/>', LVL:20, DIM_ALIGN_CD:"L", WIDTH:100});
        
        oversAndShortagesDetailInfo.getBucket(sqlFlag);
    }
    
    function fn_setFieldsBuket() {
        //필드 배열 객체를  생성합니다.
        var fields = [
            {fieldName : "CHILD_ITEM_QTY", dataType : "number"},
            {fieldName : "W1_QTY", dataType : "number"},
            {fieldName : "W2_QTY", dataType : "number"},
            {fieldName : "W3_QTY", dataType : "number"},
            {fieldName : "W4_QTY", dataType : "number"},
            {fieldName : "M0_QTY", dataType : "number"},
            {fieldName : "M1_QTY", dataType : "number"},
            {fieldName : "M2_QTY", dataType : "number"},
            {fieldName : "M3_QTY", dataType : "number"},
            {fieldName : "M4_QTY", dataType : "number"},
            {fieldName : "M5_QTY", dataType : "number"},
            {fieldName : "M6_QTY", dataType : "number"},
            {fieldName : "M7_QTY", dataType : "number"},
            {fieldName : "M8_QTY", dataType : "number"},
            {fieldName : "M9_QTY", dataType : "number"},
            {fieldName : "M10_QTY", dataType : "number"},
            {fieldName : "M11_QTY", dataType : "number"},
            {fieldName : "M12_QTY", dataType : "number"},
            /* {fieldName : "TOTAL", dataType : "number"}, */
        ];
        return fields;
    }

    function fn_setColumnsBuket() {
        //필드와 연결된 컬럼 배열 객체를 생성합니다.
        var columns = 
        [   
            {
                name : "CHILD_ITEM_QTY", fieldName: "CHILD_ITEM_QTY", editable: false, header: {text: '<spring:message code="lbl.childItemQty" javaScriptEscape="true" />'},
                dynamicStyles : [gfn_getDynamicStyle(-2)],
                styles: {textAlignment: "far", numberFormat : "#,##0"},
                dataType : "number",
                nanText : "",
                width: 70
            }, {
                name : "UNREG_QTY", fieldName: "UNREG_QTY", editable: false, header: {text: '<spring:message code="lbl.notRegisterQty" javaScriptEscape="true" />'},
                dynamicStyles : [gfn_getDynamicStyle(-2)],
                styles: {textAlignment: "far", numberFormat : "#,##0"},
                dataType : "number",
                nanText : "",
                width: 70
            }, {
                name : "W1_QTY", fieldName: "W1_QTY", editable: false, header: {text: '<spring:message code="lbl.ww01" javaScriptEscape="true" />'},
                dynamicStyles : [gfn_getDynamicStyle(-2)],
                styles: {textAlignment: "far", numberFormat : "#,##0"},
                dataType : "number",
                nanText : "",
                width: 70
            }, {
                name : "W2_QTY", fieldName: "W2_QTY", editable: false, header: {text: '<spring:message code="lbl.ww02" javaScriptEscape="true" />'},
                dynamicStyles : [gfn_getDynamicStyle(-2)],
                styles: {textAlignment: "far", numberFormat : "#,##0"},
                dataType : "number",
                nanText : "",
                width: 70
            }, {
                name : "W3_QTY", fieldName: "W3_QTY", editable: false, header: {text: '<spring:message code="lbl.ww03" javaScriptEscape="true" />'},
                dynamicStyles : [gfn_getDynamicStyle(-2)],
                styles: {textAlignment: "far", numberFormat : "#,##0"},
                dataType : "number",
                nanText : "",
                width: 70
            }, {
                name : "W4_QTY", fieldName: "W4_QTY", editable: false, header: {text: '<spring:message code="lbl.ww04" javaScriptEscape="true" />'},
                dynamicStyles : [gfn_getDynamicStyle(-2)],
                styles: {textAlignment: "far", numberFormat : "#,##0"},
                dataType : "number",
                nanText : "",
                width: 70
            }, {
                name : "M0_QTY", fieldName: "M0_QTY", editable: false, header: {text: '<spring:message code="lbl.am0" javaScriptEscape="true" />'},
                dynamicStyles : [gfn_getDynamicStyle(-2)],
                styles: {textAlignment: "far", numberFormat : "#,##0"},
                dataType : "number",
                nanText : "",
                width: 70
            }, {
                name : "M1_QTY", fieldName: "M1_QTY", editable: false, header: {text: '<spring:message code="lbl.am1" javaScriptEscape="true" />'},
                dynamicStyles : [gfn_getDynamicStyle(-2)],
                styles: {textAlignment: "far", numberFormat : "#,##0"},
                dataType : "number",
                nanText : "",
                width: 70
            }, {
                name : "M2_QTY", fieldName: "M2_QTY", editable: false, header: {text: '<spring:message code="lbl.am2" javaScriptEscape="true" />'},
                dynamicStyles : [gfn_getDynamicStyle(-2)],
                styles: {textAlignment: "far", numberFormat : "#,##0"},
                dataType : "number",
                nanText : "",
                width: 70
            }, {
                name : "M3_QTY", fieldName: "M3_QTY", editable: false, header: {text: '<spring:message code="lbl.am3" javaScriptEscape="true" />'},
                dynamicStyles : [gfn_getDynamicStyle(-2)],
                styles: {textAlignment: "far", numberFormat : "#,##0"},
                dataType : "number",
                nanText : "",
                width: 70
            }, {
                name : "M4_QTY", fieldName: "M4_QTY", editable: false, header: {text: '<spring:message code="lbl.am4" javaScriptEscape="true" />'},
                dynamicStyles : [gfn_getDynamicStyle(-2)],
                styles: {textAlignment: "far", numberFormat : "#,##0"},
                dataType : "number",
                nanText : "",
                width: 70
            }, {
                name : "M5_QTY", fieldName: "M5_QTY", editable: false, header: {text: '<spring:message code="lbl.am5" javaScriptEscape="true" />'},
                dynamicStyles : [gfn_getDynamicStyle(-2)],
                styles: {textAlignment: "far", numberFormat : "#,##0"},
                dataType : "number",
                nanText : "",
                width: 70
            }, {
                name : "M6_QTY", fieldName: "M6_QTY", editable: false, header: {text: '<spring:message code="lbl.am6" javaScriptEscape="true" />'},
                dynamicStyles : [gfn_getDynamicStyle(-2)],
                styles: {textAlignment: "far", numberFormat : "#,##0"},
                dataType : "number",
                nanText : "",
                width: 70
            }, {
                name : "M7_QTY", fieldName: "M7_QTY", editable: false, header: {text: '<spring:message code="lbl.am7" javaScriptEscape="true" />'},
                dynamicStyles : [gfn_getDynamicStyle(-2)],
                styles: {textAlignment: "far", numberFormat : "#,##0"},
                dataType : "number",
                nanText : "",
                width: 70
            }, {
                name : "M8_QTY", fieldName: "M8_QTY", editable: false, header: {text: '<spring:message code="lbl.am8" javaScriptEscape="true" />'},
                dynamicStyles : [gfn_getDynamicStyle(-2)],
                styles: {textAlignment: "far", numberFormat : "#,##0"},
                dataType : "number",
                nanText : "",
                width: 70
            }, {
                name : "M9_QTY", fieldName: "M9_QTY", editable: false, header: {text: '<spring:message code="lbl.am9" javaScriptEscape="true" />'},
                dynamicStyles : [gfn_getDynamicStyle(-2)],
                styles: {textAlignment: "far", numberFormat : "#,##0"},
                dataType : "number",
                nanText : "",
                width: 70
            }, {
                name : "M10_QTY", fieldName: "M10_QTY", editable: false, header: {text: '<spring:message code="lbl.am10" javaScriptEscape="true" />'},
                dynamicStyles : [gfn_getDynamicStyle(-2)],
                styles: {textAlignment: "far", numberFormat : "#,##0"},
                dataType : "number",
                nanText : "",
                width: 70
            }, {
                name : "M11_QTY", fieldName: "M11_QTY", editable: false, header: {text: '<spring:message code="lbl.am11" javaScriptEscape="true" />'},
                dynamicStyles : [gfn_getDynamicStyle(-2)],
                styles: {textAlignment: "far", numberFormat : "#,##0"},
                dataType : "number",
                nanText : "",
                width: 70
            }, {
                name : "M12_QTY", fieldName: "M12_QTY", editable: false, header: {text: '<spring:message code="lbl.am12" javaScriptEscape="true" />'},
                dynamicStyles : [gfn_getDynamicStyle(-2)],
                styles: {textAlignment: "far", numberFormat : "#,##0"},
                dataType : "number",
                nanText : "",
                width: 70
            }/* , {
                name : "TOTAL", fieldName: "TOTAL", editable: false, header: {text: '<spring:message code="lbl.am12" javaScriptEscape="true" />'},
                dynamicStyles : [gfn_getDynamicStyle(-2)],
                styles: {textAlignment: "far", numberFormat : "#,##0"},
                dataType : "number",
                nanText : "",
                width: 100
            } */
        ];
        return columns;
    }
    
    $(document).ready(function() {
        oversAndShortagesDetailInfo.init();
        fn_excelSqlAuth();
        $(".viewfnc5").click("on", function() {
            gfn_doExportExcel({fileNm:"${menuInfo.menuNm}", conFirmFlag: lv_conFirmFlag}); 
            $(".pClose").click(function() {
                $("#divTempLayerPopup").hide();
                $(".back").hide();
            });
            $(".popClose").click(function() {
                $("#divTempLayerPopup").hide();
                $(".back").hide();
            });
            $(".back").click(function() {
                $(".popup2").hide();
                $(".back").hide();
            });
        });
        
        $(".viewfnc4").click("on", function() {
            
            fn_apply(true);
            
            $(document).on("click",".popup2 .popClose, .popup2 .pClose",function() {
                $(".popup2").hide();
                $(".back").hide();
            });
            
            $(".back").click(function() {
                $(".popup2").hide();
                $(".back").hide();
            });
            
        })
        
        
    });

    $(window).resize(function() {
        gfn_popresizeSub();
    }).resize();
    //엑셀, 쿼리 다운로드 권한 확인
    function fn_excelSqlAuth() {
        
        gfn_service({
            async   : false,
            url     : GV_CONTEXT_PATH + "/biz/obj.do",
            data    : {
                _mtd : "getList",
                popUpMenuCd : popUpMenuCd,
                tranData : [
                    {outDs : "authorityList", _siq : "supply.purchase.topIetmListExcelSql"}
                ]
            },
            success :function(data) {
                
                for(i=0;i<data.authorityList.length;i++)
                {
                    if(data.authorityList[i].USE_FLAG == "Y"&&data.authorityList[i].ACTION_CD=="EXCEL")
                    {
                        $('#excelSqlContainer').show();
                        $("#excel").show();
                    }
                    else if(data.authorityList[i].USE_FLAG == "Y"&&data.authorityList[i].ACTION_CD=="SQL")
                    {
                        $('#excelSqlContainer').show();
                        $("#sql").show();
                    }
                }
                    
            }
        }, "obj");
    }

</script>
<style type="text/css">
.locationext .fnc a {display:inline-block;overflow:hidden;height:27px;margin-left:4px;}
.li_none {list-style-type:none;background:white}
</style>
</head>
<body>
    <%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
    <div id="keywordpop" class="popupDv">
        <div class="pop_tit">${param.popupTitle}</div>
        <div class="popCont">
            <div class="srhwrap">
                <form id="searchForm" name="searchForm" method="POST" onSubmit="return false;">
                <input type="hidden" id="planId" name="planId" value="${param.planId }"/>
                <input type="hidden" id="itemCd" name="itemCd" value="${param.itemCd }"/>
                <div class="srhcondi">
                    <ul style="float:right;">
                        <li id="excelSqlContainer" style="display:none;">
                                <div class="locationext">
                                    <div class="fnc">
                                        <a href="#" id='excel' style="display:none" class="viewfnc5"><img src="${ctx}/statics/images/common/btn_gun5.gif" title="Excel Download"></a>
                                        <a href="#" id='sql' style="display:none"class="viewfnc4"><img src="${ctx}/statics/images/common/btn_gun4.gif" title="SQL View"></a>
                                    </div>
                                </div>
                        </li>
                    </ul>
                </div>
            </div>
            <div id="realgrid" class="realgrid1"></div>
            
        </div>
        <div class="pop_btm">
            <div class="pop_btn_info">
                <strong >Sum  :</strong> <span id="bottom_userSum"></span>
            </div>
            <div class="pop_btn_info">
                <strong >Avg  :</strong> <span id="bottom_userAvg"></span>
            </div>
            <div class="pop_btn">
                <%-- <a href="#" id="btnApply" class="pbtn pApply"><spring:message code="lbl.apply"/></a> --%>
                <a href="javascript:;" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
            </div>
        </div>
    </div>
</body>
</html>