<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>Material Preparation Detail</title>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
    <jsp:param name="popupYn" value="Y"/>
</jsp:include>
<!-- 
    
    SCM > 운영 KPI > 자재 준비율  페이지의 DETAIL_POPUP과 동일한 팝업이 필요하여  소스코드 그대로 활용
    
 -->
<style type="text/css">
.locationext .fnc a {display:inline-block;overflow:hidden;height:27px;margin-left:4px;}
.li_none {list-style-type:none;background:white}
.pop_btn{
    display: flex;
    justify-content: center;
}
.pop_btn > div{
    width: 200px;
    margin: 10px;
    line-height: 25px;
    background-color: DodgerBlue;
    border-radius: 2px;
}

.pop_btn > div > strong
{   
    color: white;
}
.pop_btn > div > span
{   
    color: white;
}


</style>
<script type="text/javascript">
    var popupWidth, popupHeight;
    var lv_conFirmFlag = true;
    var gCompanyCd = "${param.companyCd}";
    var gBuCd      = "${param.buCd}";
  
    var gItemCd    = "${param.itemCd}";
    var gItemNm    = "${param.itemNm}";
    var gPlanId    = "${param.planId}";
    var popUpMenuCd = "${param.menuCd}";
    console.log("gCompanyCd:",gCompanyCd);
    console.log("gBuCd:",gBuCd);
    
    console.log("gItemCd:",gItemCd);
    console.log("gItemNm:",gItemNm);
    console.log("gPlanId:",gPlanId);
    console.log("popUpMenuCd:",popUpMenuCd);
    
    var matRequirPlanDetail = {
        init : function() {
            
            gfn_popresize();
            this.comCode.initCode();
            this.initFilter();
            this.grid.initGrid();
            this.events();
            fn_apply();
        },
        
        _siq    : "aps.planResult.matRequirPlanDetail",
        
        comCode : {
            codeMapEx : {},
            codeMap   : {},
            initCode  : function() {
                
                gfn_service({
                    async   : false,
                    url     : GV_CONTEXT_PATH + "/biz/obj.do",
                    data    : {
                        _mtd     : "getList", 
                        companyCd   : gCompanyCd,
                        buCd        : gBuCd,
                        planId      : gPlanId,
                        tranData : [{outDs : "versionIdList", _siq : matRequirPlanDetail._siq + "VersionId"}]
                    },
                    success : function(data) {
                        matRequirPlanDetail.comCode.codeMapEx.VERSION_ID = data.versionIdList;
                    }
                }, "obj"); 
            }
        },
        
        initFilter : function() {
            gfn_setMsComboAll([
                {target : 'divVersionId', id : 'versionId', title : '<spring:message code="lbl.planVersion"/>', data : this.comCode.codeMapEx.VERSION_ID, exData:[""], option: {allFlag:"Y"}}
            ]);
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
                
                //this.gridInstance.custBeforeBucketFalg = true;
                this.gridInstance.custBucketFalg       = true;
                
                this.setColumn();
                this.setOptions();
            },
            
            setColumn : function() {
                var columns = [
                    {
                        name : "VERSION_ID", fieldName : "VERSION_ID", editable : false, header: {text: '<spring:message code="lbl.planVersion" javaScriptEscape="true" />'},
                        styles : {textAlignment: "near", background : gv_noneEditColor},
                        mergeRule : { criteria: "values['VERSION_ID']+value" },
                        dataType : "text",
                        width : 100
                    }, {
                        name : "CHILD_ITEM_CD", fieldName : "CHILD_ITEM_CD", editable : false, header: {text: '<spring:message code="lbl.materialsCode" javaScriptEscape="true" />'},
                        styles : {textAlignment: "near"},
                        mergeRule : { criteria: "values['CHILD_ITEM_CD']+value" },
                        dynamicStyles : [
                            {
                                criteria: ["values['CHILD_ITEM_CD'] = 'Sub Total'","values['CHILD_ITEM_CD'] != 'Sub Total'"],
                                styles: ["background="+gv_noneEditColor,"background=#FFFFFF"]
                            }
                        ],
                        dataType : "text",
                        width : 120
                    }, {
                        name : "ITEM_NM", fieldName : "ITEM_NM", editable : false, header: {text: '<spring:message code="lbl.materialsName" javaScriptEscape="true" />'},
                        styles : {textAlignment: "near"},
                        mergeRule : { criteria: "values['ITEM_NM']+value" },
                        dynamicStyles : [
                            {
                                criteria: ["values['CHILD_ITEM_CD'] = 'Sub Total'","values['CHILD_ITEM_CD'] != 'Sub Total'"],
                                styles: ["background="+gv_noneEditColor,"background=#FFFFFF"]
                            }
                        ],
                        dataType : "text",
                        width : 120
                    }, {
                        name : "SPEC", fieldName : "SPEC", editable : false, header: {text: '<spring:message code="lbl.materialsSpec" javaScriptEscape="true" />'},
                        styles : {textAlignment: "near"},
                        mergeRule : { criteria: "values['SPEC']+value" },
                        dynamicStyles : [
                            {
                                criteria: ["values['CHILD_ITEM_CD'] = 'Sub Total'","values['CHILD_ITEM_CD'] != 'Sub Total'"],
                                styles: ["background="+gv_noneEditColor,"background=#FFFFFF"]
                            }
                        ],
                        dataType : "text",
                        width : 120
                    }, {
                        name : "REQ_WEEK", fieldName : "REQ_WEEK", editable : false, header: {text: '<spring:message code="lbl.materialsReqWeek" javaScriptEscape="true" />'},
                        styles : {textAlignment: "near"},
                        mergeRule : { criteria: "values['REQ_WEEK']+value" },
                        dynamicStyles : [
                            {
                                criteria: ["values['CHILD_ITEM_CD'] = 'Sub Total'","values['CHILD_ITEM_CD'] != 'Sub Total'"],
                                styles: ["background="+gv_noneEditColor,"background=#FFFFFF"]
                            }
                        ],
                        dataType : "text",
                        width : 80
                    }, {
                        name : "CHILD_ITEM_QTY", fieldName : "CHILD_ITEM_QTY", editable : false, header: {text: '<spring:message code="lbl.childItemQty" javaScriptEscape="true" />'},
                        styles : {textAlignment: "far"},
                        dynamicStyles : [
                            {
                                criteria: ["values['CHILD_ITEM_CD'] = 'Sub Total'","values['CHILD_ITEM_CD'] != 'Sub Total'"],
                                styles: ["background="+gv_noneEditColor,"background=#FFFFFF"]
                            }
                        ],
                        dataType : "text",
                        width : 120
                    }, {
                        name : "REQ_QTY", fieldName : "REQ_QTY", editable : false, header: {text: '<spring:message code="lbl.materialsReqQty" javaScriptEscape="true" />'},
                        styles : {textAlignment: "far"},
                        dynamicStyles : [
                            {
                                criteria: ["values['CHILD_ITEM_CD'] = 'Sub Total'","values['CHILD_ITEM_CD'] != 'Sub Total'"],
                                styles: ["background="+gv_noneEditColor,"background=#FFFFFF"]
                            }
                        ],
                        dataType : "number",
                        width : 80
                    }, {
                        name : "PARENT_ITEM_CD", fieldName : "PARENT_ITEM_CD", editable : false, header: {text: '<spring:message code="lbl.parentItemCd" javaScriptEscape="true" />'},
                        styles : {textAlignment: "center"},
                        dynamicStyles : [
                            {
                                criteria: ["values['CHILD_ITEM_CD'] = 'Sub Total'","values['CHILD_ITEM_CD'] != 'Sub Total'"],
                                styles: ["background="+gv_noneEditColor,"background=#FFFFFF"]
                            }
                        ],
                        dataType : "text",
                        width : 80
                    }, {
                        name : "PARENT_ITEM_NM", fieldName : "PARENT_ITEM_NM", editable : false, header: {text: '<spring:message code="lbl.parentItemNm" javaScriptEscape="true" />'},
                        styles : {textAlignment: "center"},
                        dynamicStyles : [
                            {
                                criteria: ["values['CHILD_ITEM_CD'] = 'Sub Total'","values['CHILD_ITEM_CD'] != 'Sub Total'"],
                                styles: ["background="+gv_noneEditColor,"background=#FFFFFF"]
                            }
                        ],
                        dataType : "text",
                        width : 80
                    }, {
                        name : "PARENT_SPEC", fieldName : "PARENT_SPEC", editable : false, header: {text: '<spring:message code="lbl.parentSpec" javaScriptEscape="true" />'},
                        styles : {textAlignment: "near"},
                        dynamicStyles : [
                            {
                                criteria: ["values['CHILD_ITEM_CD'] = 'Sub Total'","values['CHILD_ITEM_CD'] != 'Sub Total'"],
                                styles: ["background="+gv_noneEditColor,"background=#FFFFFF"]
                            }
                        ],
                        dataType : "text",
                        width : 80
                    }, {
                        name : "CUST_GROUP_NM", fieldName : "CUST_GROUP_NM", editable : false, header: {text: '<spring:message code="lbl.custGroupName" javaScriptEscape="true" />'},
                        styles : {textAlignment: "center"},
                        dynamicStyles : [
                            {
                                criteria: ["values['CHILD_ITEM_CD'] = 'Sub Total'","values['CHILD_ITEM_CD'] != 'Sub Total'"],
                                styles: ["background="+gv_noneEditColor,"background=#FFFFFF"]
                            }
                        ],
                        dataType : "text",
                        width : 80
                    }, {
                        name : "PLAN_WEEK", fieldName : "PLAN_WEEK", editable : false, header: {text: '<spring:message code="lbl.planWeek2" javaScriptEscape="true" />'},
                        styles : {textAlignment: "center"},
                        dynamicStyles : [
                            {
                                criteria: ["values['CHILD_ITEM_CD'] = 'Sub Total'","values['CHILD_ITEM_CD'] != 'Sub Total'"],
                                styles: ["background="+gv_noneEditColor,"background=#FFFFFF"]
                            }
                        ],
                        dataType : "text",
                        width : 80
                    }, {
                        name : "PLAN_QTY", fieldName : "PLAN_QTY", editable : false, header: {text: '<spring:message code="lbl.planQty2" javaScriptEscape="true" />'},
                        styles : {textAlignment: "far"},
                        dynamicStyles : [
                            {
                                criteria: ["values['CHILD_ITEM_CD'] = 'Sub Total'","values['CHILD_ITEM_CD'] != 'Sub Total'"],
                                styles: ["background="+gv_noneEditColor,"background=#FFFFFF"]
                            }
                        ],
                        dataType : "number",
                        width : 80
                    }, {
                        name: "GROUP1",
                        header: {text: '<spring:message code="lbl.reqQtyHis"/>'},
                        width: 320,
                        type: "group",
                        columns : [
                            {
                                name : "REQ_QTY_W1", fieldName : "REQ_QTY_W1", editable : false, header: {text: '<spring:message code="lbl.reqQtyW1" javaScriptEscape="true" />'},
                                styles : {textAlignment: "far"},
                                dynamicStyles : [
                                    {
                                        criteria: ["values['CHILD_ITEM_CD'] = 'Sub Total'","values['CHILD_ITEM_CD'] != 'Sub Total'"],
                                        styles: ["background="+gv_noneEditColor,"background=#FFFFFF"]
                                    }
                                ],
                                dataType : "number",
                                width : 80
                            }, {
                                name : "REQ_QTY_W2", fieldName : "REQ_QTY_W2", editable : false, header: {text: '<spring:message code="lbl.reqQtyW2" javaScriptEscape="true" />'},
                                styles : {textAlignment: "far"},
                                dynamicStyles : [
                                    {
                                        criteria: ["values['CHILD_ITEM_CD'] = 'Sub Total'","values['CHILD_ITEM_CD'] != 'Sub Total'"],
                                        styles: ["background="+gv_noneEditColor,"background=#FFFFFF"]
                                    }
                                ],
                                dataType : "number",
                                width : 80
                            }, {
                                name : "REQ_QTY_W3", fieldName : "REQ_QTY_W3", editable : false, header: {text: '<spring:message code="lbl.reqQtyW3" javaScriptEscape="true" />'},
                                styles : {textAlignment: "far"},
                                dynamicStyles : [
                                    {
                                        criteria: ["values['CHILD_ITEM_CD'] = 'Sub Total'","values['CHILD_ITEM_CD'] != 'Sub Total'"],
                                        styles: ["background="+gv_noneEditColor,"background=#FFFFFF"]
                                    }
                                ],
                                dataType : "number",
                                width : 80
                            }, {
                                name : "REQ_QTY_W4", fieldName : "REQ_QTY_W4", editable : false, header: {text: '<spring:message code="lbl.reqQtyW4" javaScriptEscape="true" />'},
                                styles : {textAlignment: "far"},
                                dynamicStyles : [
                                    {
                                        criteria: ["values['CHILD_ITEM_CD'] = 'Sub Total'","values['CHILD_ITEM_CD'] != 'Sub Total'"],
                                        styles: ["background="+gv_noneEditColor,"background=#FFFFFF"]
                                    }
                                ],
                                dataType : "number",
                                width : 80
                            }
                        ]
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
                
                fields.push({fieldName : "REQ_QTY_W1", dataType : "number"});
                fields.push({fieldName : "REQ_QTY_W2", dataType : "number"});
                fields.push({fieldName : "REQ_QTY_W3", dataType : "number"});
                fields.push({fieldName : "REQ_QTY_W4", dataType : "number"});
                
                if (hiddenCols !== undefined && hiddenCols.length > 0) {
                    for (hid in hiddenCols) {
                        fields.push({fieldName : hiddenCols[hid]});
                    }
                }
                
                this.dataProvider.setFields(fields);
            },
            
            setOptions : function() {
                this.grdMain.setOptions({
                    stateBar: { visible : false }
                });

                this.dataProvider.setOptions({
                    softDeleting : true
                });
                
                this.grdMain.addCellStyles([{
                    id         : "editStyle",
                    editable   : true,
                    background : gv_editColor
                }]);
            }
        },
        
        events : function() {
            $("#btnSearch").on("click", function(e) {
                fn_apply(false);
            });
            
            $("#btnClose" ).on("click", function() { window.close(); });
            
        },
        
        search : function() {
            FORM_SEARCH._mtd     = "getList";
            FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq}];
            
            var aOption = {
                url     : GV_CONTEXT_PATH + "/biz/obj.do",
                data    : FORM_SEARCH,
                success : function (data) {
                    
                    if (FORM_SEARCH.sql == 'N') {
                        matRequirPlanDetail.grid.dataProvider.clearRows(); //데이터 초기화
                
                        //그리드 데이터 생성
                        matRequirPlanDetail.grid.grdMain.cancel();
                        
                        matRequirPlanDetail.grid.dataProvider.setRows(data.resList);
                        matRequirPlanDetail.grid.dataProvider.clearSavePoints();
                        matRequirPlanDetail.grid.dataProvider.savePoint(); //초기화 포인트 저장
                        gfn_setSearchRow(matRequirPlanDetail.grid.dataProvider.getRowCount());
                        //gfn_actionMonthSum(matRequirPlanDetail.grid.gridInstance);
                        gfn_setRowTotalFixed(matRequirPlanDetail.grid.grdMain);
                        
                    }
                }
            }
            
            gfn_service(aOption, "obj");
        },
    };
    
    var fn_apply = function (sqlFlag) {
        //조회조건 설정
        FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
        FORM_SEARCH.sql        = sqlFlag;
        
        matRequirPlanDetail.search();
    }
    
    
    
    // onload 
    $(document).ready(function() {
        matRequirPlanDetail.init();
        fn_excelSqlAuth();
        $(".viewfnc5").click("on", function() {
            gfn_doExportExcel({fileNm:"${menuInfo.menuNm}", conFirmFlag: lv_conFirmFlag}); 
            $(".pClose").click(function() {
                console.log(".pClose clicked");
                $("#divTempLayerPopup").hide();
                $(".back").hide();
            });
            $(".popClose").click(function() {
                console.log(".popClose clicked");
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
                    {outDs : "authorityList", _siq : "snop.oprtKpi.materialSummaryExcelSql"}
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
        <div class="pop_tit">자재 준비율 상세리스트</div>
        <div class="popCont">
            <div class="srhwrap">
                <form id="searchForm" name="searchForm" method="POST" onSubmit="return false;">
                <input type='hidden' id='companyCd' name='companyCd' class="ipt" style="width:120px;" value="${param.companyCd}">
                <input type='hidden' id='buCd' name='buCd' class="ipt" style="width:120px;" value="${param.buCd}">
                <div class="srhcondi">
                <ul>
                    <li>
                        <strong class="srhcondipop"><spring:message code="lbl.planId"/></strong>
                        <div class="selectBox">
                            <input type='text' id='planId' name='planId' class="ipt" style="width:120px;" value="${param.planId}" disabled="disabled">
                        </div>
                    </li>
                    <li>
                        <strong class="srhcondipop"><spring:message code="lbl.materialsCode"/></strong>
                        <div class="selectBox">
                            <input type='hidden' id='itemNm' name='itemNm' class="ipt" style="width:120px;" value="${param.itemNm}">
                            <input type='text' id='itemCd' name='itemCd' class="ipt" style="width:120px;" value="${param.itemCd}" disabled="disabled">
                        </div>
                    </li>
                    <li>
                        <strong class="srhcondipop"><spring:message code="lbl.planVersion"/></strong>
                        <div class="selectBox">
                            <select id="versionId" name="versionId" multiple="multiple"></select>
                        </div>
                    </li>
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
                </form>
                <div class="bt_btn">
                    <a href="#" id="btnSearch" class="fl_app"><spring:message code="lbl.search"/></a>
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
                <a href="javascript:;" id="btnClose" class="app1"><spring:message code="lbl.close"/></a>
            </div>
        </div>
    </div>
</body>
</html>