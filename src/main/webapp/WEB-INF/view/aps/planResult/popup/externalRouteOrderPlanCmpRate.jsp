<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>업체별 계획 준수율</title>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
    <jsp:param name="popupYn" value="Y"/>
</jsp:include>

<script type="text/javascript">
    var popupWidth, popupHeight;
    var lv_conFirmFlag = true;
    var planId      = "${param.planId}";
    var prodPart    = "${param.prodPart}";
    var planVersion = "${param.planVersion}";
    var fromCal     = '${param.fromCal}';
    var toCal       = '${param.toCal}';
    
    var externalRouteOrderPlanCmpRate = {
        init : function() {
            gfn_popresize();
            this.grid.initGrid();
            this.events();
            fn_apply();
        },
        
        _siq    : "aps.planResult.externalRouteOrderPlanCmpRate",
                
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
                        name : "BP_NM", fieldName : "BP_NM", editable : false, header: {text: '업체'},
                        styles : {textAlignment: "far", background : gv_noneEditColor},
                        dataType : "text",
                        width : 100
                    }, {
                        name : "PLAN_CMP_RATE", fieldName : "PLAN_CMP_RATE", editable : false, header: {text: '입하준수율'},
                        styles : {textAlignment: "far", background : gv_noneEditColor},
                        dataType : "text",
                        width : 120
                    }, {
                        name : "FOLLOW_CNT", fieldName : "FOLLOW_CNT", editable : false, header: {text: '준수(건수)'},
                        styles : {textAlignment: "far", background : gv_noneEditColor},
                        dataType : "text",
                        width : 120
                    }, {
                        name : "NOT_FOLLOW_CNT", fieldName : "NOT_FOLLOW_CNT", editable : false, header: {text: '미준수(건수)'},
                        styles : {textAlignment: "far", background : gv_noneEditColor},
                        dataType : "text",
                        width : 120
                    
                    }
                    
                    
                ];
                
                this.setFields(columns);
                
                this.grdMain.setColumns(columns); 
            },
            
            setFields : function(cols) {
                
               
                
                var fields = new Array();
                
                $.each(cols, function(i, v) {
                    
                    var tFieldName = v.fieldName;
                    var tDataType = v.dataType;
                    
                    fields.push({fieldName : tFieldName, dataType : tDataType});
                    
                });
                
                
                this.dataProvider.setFields(fields);
            },
            
            setOptions : function() {
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
            
            $("#btnClose" ).on("click", function(e) {
                window.close(); 
            });
            
        },
        
        search : function() {
            FORM_SEARCH._mtd     = "getList";
            FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq}];
            FORM_SEARCH.planId   = planId;
            FORM_SEARCH.prodPart = prodPart;
            FORM_SEARCH.planVersion = planVersion;
            FORM_SEARCH.fromCal     = fromCal;
            FORM_SEARCH.toCal       = toCal;
            
            var aOption = {
                url     : GV_CONTEXT_PATH + "/biz/obj",
                data    : FORM_SEARCH,
                success : function (data) {
                    
                    if (FORM_SEARCH.sql == 'N') {
                        externalRouteOrderPlanCmpRate.grid.dataProvider.clearRows(); //데이터 초기화
                        
                        //그리드 데이터 생성
                        externalRouteOrderPlanCmpRate.grid.grdMain.cancel();
                        
                        externalRouteOrderPlanCmpRate.grid.dataProvider.setRows(data.resList);
                        externalRouteOrderPlanCmpRate.grid.dataProvider.clearSavePoints();
                        externalRouteOrderPlanCmpRate.grid.dataProvider.savePoint(); //초기화 포인트 저장
                        gfn_setSearchRow(externalRouteOrderPlanCmpRate.grid.dataProvider.getRowCount());
                        
                        //externalRouteOrderPlanCmpRate.gridCallback(data.resList);
                    }
                }
            }
            
            gfn_service(aOption, "obj");
        }/* ,
        
        gridCallback : function(resList) {
            

            var fileds = externalRouteOrderPlanCmpRate.grid.dataProvider.getFields();
            var filedsLen = fileds.length;
            var colorFlagArr = new Array(); 
            
            
            
            $.each(resList, function(i, val){
                
                var colorFlag = val.COLOR_FLAG;
                
                if(colorFlag == "Y"){
                    colorFlagArr.push(i);
                }
            });
            
            for (var i = 0; i < filedsLen; i++) {
                
                var fieldName = fileds[i].fieldName;
                var param = fieldName;
                
                externalRouteOrderPlanCmpRate.grid.grdMain.setColumnProperty(param, "styles", {background : gv_noneEditColor, criteria:"row div 1"})
                
            }
        } */
    };
    
    var fn_apply = function (sqlFlag) {
        //조회조건 설정
        FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
        FORM_SEARCH.sql        = sqlFlag;
        
        externalRouteOrderPlanCmpRate.search();
    }
    
    // onload 
    $(document).ready(function() {
        externalRouteOrderPlanCmpRate.init();
        //fn_excelSqlAuth();
        
        /*
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
        */
        
    });
    
    $(window).resize(function() {
        gfn_popresizeSub();
    }).resize();
    
    //엑셀, 쿼리 다운로드 권한 확인
    function fn_excelSqlAuth() {
        
        gfn_service({
            async   : false,
            url     : GV_CONTEXT_PATH + "/biz/obj",
            data    : {
                _mtd : "getList",
                popUpMenuCd : popUpMenuCd,
                tranData : [
                    {outDs : "authorityList", _siq : "aps.dynamic.externalRouteOrderPlanCmpRateExcelSql"}
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
        <div class="pop_tit">업체별 계획 준수율</div>
        <div class="popCont">
            <div class="srhwrap">
                <form id="searchForm" name="searchForm" method="POST" onSubmit="return false;">
                <input type="hidden" id="prodPart" name="prodPart" value="${param.prodPart}" />
                <div class="srhcondi">
              
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
            <div class="pop_btn" style="display:inline-block;">
                <a href="javascript:;" id="btnClose" class="pbtn pClose"><spring:message code="lbl.close"/></a>
            </div>
        </div>
        
    </div>
</body>
</html>