<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<title>품목별요약</title>
<jsp:include page="/WEB-INF/view/layout/include.jsp" flush="false">
    <jsp:param name="popupYn" value="Y"/>
</jsp:include>

<style>
#searchForm{
    display:inline-block;
    width:50%;
}
#view_Her{

    background-color:white;
    display:block;
    padding:3px;
    width:220px;
    border-radius:5px;

}

#view_Her > .tlist{

    display:block;
    padding:5px; 

}

#view_Her > .tlist > .tit2{

    width:45px;

}

#view_Her > .tlist > div{
    display:inline-block;
    padding:5px;
}



</style>
<script type="text/javascript">
    var popupWidth, popupHeight;
    var gYearId     = "${param.yearId}";
    var gfromCalDate     = "${param.fromCalDate}";
    var gtoCalDate       = "${param.toCalDate}";
    

    
    var lv_conFirmFlag = true;
    var urgentPerformanceSummaryByItem = {
        init : function() {
            gfn_popresize();
            this.comCode.initCode();
            this.initFilter();
            this.grid.initGrid();
            this.events();
            fn_apply();
            
        },
        
        _siq    : "aps.dynamic.urgentPerformanceSummaryByItem",
        
        comCode : {
            codeMapEx : null,
            codeMap   : null,
            initCode  : function() {
              /*
                var grpCd      = 'FLAG_YN,ORDER_STATUS';
                this.codeMap   = gfn_getComCode(grpCd, 'Y');
                */
            }
        },
        
        initFilter : function() {
            /*
            gfn_setMsComboAll([
                {target : 'divUseFlag'     , id : 'useFlag'     , title : '<spring:message code="lbl.useFlag"/>' , data : this.comCode.codeMap.FLAG_YN, exData:[""], type : "S"},
                {target : 'divOrderStatus' , id : 'orderStatus' , title : '<spring:message code="lbl.orderStatus"/>'  , data : this.comCode.codeMap.ORDER_STATUS, exData:[""]}
            ]);
            
            $("#orderStatus").multipleSelect("setSelects", ["OP","RL","ST"]);
            
            $("#useFlag").val("N");
            */
        	DATEPICKET(null,gfromCalDate,gtoCalDate);
        	
            
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
                
                this.gridInstance.measureHFlag = true;      // 메저 행모드 안보이게..
                //this.gridInstance.measureCFlag = true;
                
                //this.setColumn();
                this.setOptions();
                
                this.events();
                
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
            },
            events   : function () {
                this.grdMain.onColumnHeaderClicked = function (grid, column) {
                    fn_setChildColumnResize(urgentPerformanceSummaryByItem.grid.gridInstance, urgentPerformanceSummaryByItem.grid.grdMain, column.name);
                }
            },
            gridCallBack : function () {
                
                $.each(BUCKET.all[0], function(n,v) {
                    //if (v.BUCKET_VAL != dt.getFullYear()) {
                        fn_setChildColumnResize(urgentPerformanceSummaryByItem.grid.gridInstance, urgentPerformanceSummaryByItem.grid.grdMain, v.BUCKET_ID);
                    //}
                });
                

            }
        },
        
        events : function() {
            $("#btnSearch").on("click", function(e) {
                fn_apply(false);
            });
          
            
        },

        search : function() {
            FORM_SEARCH._mtd     = "getList";
            FORM_SEARCH.tranData = [{ outDs : "resList",_siq : this._siq}];
            var aOption = {
                url     : GV_CONTEXT_PATH + "/biz/obj.do",
                data    : FORM_SEARCH,
                success : function (data) {
                    
                    if (FORM_SEARCH.sql == 'N') {
                        urgentPerformanceSummaryByItem.grid.dataProvider.clearRows(); //데이터 초기화
                
                        //그리드 데이터 생성
                        urgentPerformanceSummaryByItem.grid.grdMain.cancel();
                        
                        urgentPerformanceSummaryByItem.grid.dataProvider.setRows(data.resList);
                        urgentPerformanceSummaryByItem.grid.dataProvider.clearSavePoints();
                        urgentPerformanceSummaryByItem.grid.dataProvider.savePoint(); //초기화 포인트 저장
                        gfn_setSearchRow(urgentPerformanceSummaryByItem.grid.dataProvider.getRowCount());
                        //gfn_actionMonthSum(commFacility.grid.gridInstance);
                        gfn_setRowTotalFixed(urgentPerformanceSummaryByItem.grid.grdMain);
                        
                        urgentPerformanceSummaryByItem.grid.gridCallBack();
                    }
                }
            }
            
            gfn_service(aOption, "obj");
        },
        
        getBucket : function (sqlFlag) {
        
            //var dt = new Date();
            MEASURE.user = [];
            var custBucket = function() {
                $.each(BUCKET.all[0], function(n,v) {
                    /*
                    if (v.BUCKET_VAL != dt.getFullYear()) {
                        v.FOLDING_FLAG = 'N'
                    } else {
                        v.EXPAND_YN = 'N'
                        delete v.FOLDING_FLAG
                    }
                    */
                    v.FOLDING_FLAG = 'Y';
                    v.EXPAND_YN = 'Y';
                });
                
                $.each(BUCKET.all[1], function(n,v) {
                    /*
                    if (v.BUCKET_VAL == dt.getFullYear()) {
                        BUCKET.all[1].splice(n, 1)
                        return true;
                    }
                    */
                    if (v.TOT_TYPE == "MT") {
                        v.TOT_TYPE = "";
                        v.TYPE = "group";
                    }
                });
            };
            
            MEASURE.user.push({CD : "REQ_QTY", NM : '요청수량' , numberFormat : "#,##0"})
            MEASURE.user.push({CD : "RESULT_QTY",    NM : '실적' , numberFormat : "#,##0"})
            MEASURE.user.push({CD : "COMPLIANCE_RATE",  NM : '준수율', numberFormat : "#,##0.0", suffix: " %"} )
        
            
            
            var ajaxMap = {
                fromDate : $('#fromCal').val(),
                toDate   : $('#toCal').val(),
                year     : {isDown: "Y", isUp:"N", upCal:"" , isMt:"Y", isExp:"Y", expCnt:999},
                week     : {isDown: "Y", isUp:"Y", upCal:"Y", isMt:"Y", isExp:"N", expCnt:999},
                sqlId    : ["bucketYear","bucketWeek"]
            };
            
            
            gfn_getBucket_customized(ajaxMap, true, custBucket);
            
            if(!sqlFlag) {
            	urgentPerformanceSummaryByItem.grid.gridInstance.setDraw();
                
            } 
        	
            
        }
        
    };
    
    var fn_apply = function (sqlFlag) {
        
    	// 디멘전 정리
        DIMENSION.user = [];
        DIMENSION.user.push({DIM_CD:"ITEM_CD"        , DIM_NM:'품목', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
        DIMENSION.user.push({DIM_CD:"ITEM_NM"        , DIM_NM:'픔목명', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
        DIMENSION.user.push({DIM_CD:"ITEM_GROUP_NM"  , DIM_NM:'픔목그룹명', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
        DIMENSION.user.push({DIM_CD:"SPEC"           , DIM_NM:'규격', LVL:10, DIM_ALIGN_CD:"L", WIDTH:100});
        DIMENSION.user.push({DIM_CD:"ROUTING_ID"        , DIM_NM:'Routing', LVL:10, DIM_ALIGN_CD:"C", WIDTH:100});
        //DIMENSION.user.push({DIM_CD:"PRIORITY_OPTION"  , DIM_NM:'<spring:message code="lbl.priorityOption" />', LVL:10, DIM_ALIGN_CD:"C", WIDTH:100});
        
    	
    	
    	urgentPerformanceSummaryByItem.getBucket(sqlFlag); //2. 버켓정보 조회
        
    	
    	//조회조건 설정
        FORM_SEARCH = $("#searchForm").serializeObject(); //초기화
        FORM_SEARCH.sql        = sqlFlag;
        FORM_SEARCH.dimList    = DIMENSION.user;
        FORM_SEARCH.bucketList = BUCKET.query;
        urgentPerformanceSummaryByItem.search();
    }
    
    // onload 
    $(document).ready(function() {
        urgentPerformanceSummaryByItem.init();
        
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

    });
    
    $(window).resize(function() {
        gfn_popresizeSub();
    }).resize();
        
    
    
    function gfn_getBucket_customized(ajaxMap,meaFlag,callback){

        var bucketLen = ajaxMap.sqlId.length;
        gfn_service({
            async: false,
            url: GV_CONTEXT_PATH + "/common/bucketInit.do",
            data:ajaxMap,
            success:function(data) {
                
                var bucketLen = ajaxMap.sqlId.length;
                BUCKET.init(); //초기화
                var tmpId = "";
                var bucketList;
                for (var i=1; i<=bucketLen; i++) {
                    bucketList = eval("data.bucket"+i+"List");
                    tmpId = ajaxMap.sqlId[i-1].replace("bucketFull","").replace("bucket","").toLowerCase();
                    if (!gfn_isNull(ajaxMap[tmpId]) && !gfn_isNull(ajaxMap[tmpId].preBucket)) {
                        bucketList = $.merge(ajaxMap[tmpId].preBucket, bucketList);
                    }
                    if (!gfn_isNull(ajaxMap[tmpId]) && !gfn_isNull(ajaxMap[tmpId].nextBucket)) {
                        bucketList = $.merge(bucketList, ajaxMap[tmpId].nextBucket);
                    }
                    BUCKET.push(bucketList);
                    
                }
                
                if ($.isFunction(callback)) {
                    callback.call();
                }
                
                gfn_bucketCallback_customized(meaFlag,"N");
            }
        }, "obj");
    }
    
    function gfn_bucketCallback_customized(meaFlag, initFlag) {
        if (initFlag != "N") BUCKET.init(); //초기화
        
        //query에 사용되는 버켓정보를 만든다.
        $.each(BUCKET.all, function(idx) {
            //최하단 버켓
            if (BUCKET.all.length-1 == idx) {
                $.each(this, function() {
                    BUCKET.query.push(this);
                });
            } else {
                $.each(this, function() {
                    if (this.TOT_TYPE == "MT") {
                        BUCKET.query.push(this);
                    }
                });
            }
        });

        //measure horizon
        if (meaFlag == true) {
            gfn_setCustBucket(MEASURE.user);
        }
    }
    

  //버켓에 사용자 버켓을 추가한다.
  function gfn_setCustBucket(pBucketObj) {
      var custBucket = BUCKET.last;
      var userBucket = pBucketObj;
      var objLastBucket = [];
      gfn_clearArrayObject(BUCKET.query);
      var tmpObj;
      $.each(custBucket, function(n,v) {
          if (v.TYPE == "group") {
        	  
	              $.each(userBucket, function(nn,vv) {
	            	  if((v.CD).indexOf("PW") != -1)
	            	  {
	            		  if((vv.CD).indexOf("REQ_QTY")!=-1||(vv.CD).indexOf("RESULT_QTY")!=-1)
	            		  {
		            		  tmpObj = {ROOT_CD: v.CD, CD: v.CD+"_"+vv.CD, NM: vv.NM, BUCKET_ID: v.CD+"_"+vv.CD, BUCKET_VAL: v.BUCKET_VAL, TYPE: vv.TYPE, numberFormat: vv.numberFormat};
	                          objLastBucket.push(tmpObj);
	                          BUCKET.query.push(tmpObj);
	            		  }
	            	  }
	            	  else if((v.CD).indexOf("MT") != -1)
	            	  {
	            		  tmpObj = {ROOT_CD: v.CD, CD: v.CD+"_"+vv.CD, NM: vv.NM, BUCKET_ID: v.CD+"_"+vv.CD, BUCKET_VAL: v.BUCKET_VAL, TYPE: vv.TYPE, numberFormat: vv.numberFormat};
                          objLastBucket.push(tmpObj);
                          BUCKET.query.push(tmpObj);
	            	  }
		                  
	              });
        	  
          }
      });
      BUCKET.push(objLastBucket);
      
  }

  
//그리드 접힘 펼침 처리
  function fn_setChildColumnResize(objInstance, objGrd, name) {
      //접힘/펼침모드인지 확인
      var header = objGrd.getColumnProperty(name, "header");
      if (header.text.indexOf(gv_expand) == -1 && header.text.indexOf(gv_folding) == -1) {
          return;
      }

      var visible = false;
      var columns = objGrd.getColumnProperty(name, "columns");
      var chkCnt = -1;
      var cName,subColumns,cDisplayWidth;
      for (var i=columns.length-1; i>=0; i--) {
      
          cName         = columns[i]._name;
          subColumns    =  objGrd.getColumnProperty(cName, "columns");
          visible       = !objGrd.getColumnProperty(cName, "visible");
          cDisplayWidth =  objGrd.getColumnProperty(cName, "displayWidth");
          
          if (isNaN(cDisplayWidth)) cDisplayWidth = objGrd.getColumnProperty(cName, "width"); 
          
          if (cDisplayWidth > 0) {
              chkCnt++;
              if (subColumns) {
                  _fn_setChildColumnResize(objInstance,objGrd, cName, !visible);
              }
          }
          if (chkCnt == 0) continue;

          objGrd.setColumnProperty(cName, "visible", visible);
          if (subColumns) {
              _fn_setChildColumnResize(objInstance,objGrd, cName, visible);
          }
      }
      

      var tmpWidth = 0;
      var addHTxt  = gv_folding;
      if (visible) {
          addHTxt = gv_expand;
          $.each(objInstance.idMap, function() {
              if (this.key == name) {
                  tmpWidth = this.value;
                  return false;
              }
          });
      } else {
          var chkColumn = true;
          $.each(objInstance.idMap, function() {
              if (this.key == name) {
                  this.value = objGrd.getColumnProperty(name, "displayWidth");
                  chkColumn = false;
              }
          });
          if (chkColumn) {
              objInstance.idMap.push({key:name,value:objGrd.getColumnProperty(name, "displayWidth")});
          }
      }

      objGrd.setColumnProperty(name, "displayWidth", tmpWidth);

      //헤더텍스트 변경
      var header = objGrd.getColumnProperty(name, "header");
      header.text = (header.text).replace(gv_folding,"").replace(gv_expand,"") + addHTxt;
      objGrd.setColumnProperty(name, "header", header);

  }

  function _fn_setChildColumnResize(objInstance,objGrd, name, isVisible) {
      var chkCnt = -1;
      var visible = isVisible;
      var cName,subColumns,cDisplayWidth;
      var columns = objGrd.getColumnProperty(name, "columns");
      for (var i=columns.length-1; i>=0; i--) {
          cName         = columns[i]._name;
          subColumns    =  objGrd.getColumnProperty(cName, "columns");
          cDisplayWidth =  objGrd.getColumnProperty(cName, "displayWidth");
          
          if (isNaN(cDisplayWidth)) cDisplayWidth = objGrd.getColumnProperty(cName, "width"); 
          
          if (cDisplayWidth > 0) chkCnt++;
          if (chkCnt == 0) continue;

          objGrd.setColumnProperty(cName, "visible", visible);

          if (subColumns) {
              _fn_setChildColumnResize(objInstance,objGrd, cName, visible);
          }
      }
  }
  
  
  
  // 현재날짜 기준 6개월전
  function getDateStr(myDate){
      return (myDate.getFullYear() + ((myDate.getMonth() + 1)<10?'0':'') + (myDate.getMonth() + 1) + ((myDate.getDate())<10?'0':'') + myDate.getDate())
  }
  function fn_getDate() {
      
      var d = new Date()
        var monthOfYear = d.getMonth()
        d.setMonth(monthOfYear - 6)   // 6개월전 
      
      
      return getDateStr(d);
  }

  //현재날짜
  function fn_getTodayDate() {
      var curDate  = new Date();
      var curYear  = curDate.getFullYear();
      var curMonth = curDate.getMonth()+1;
      var curDate  = curDate.getDate();
      
      return curYear + (curMonth<10?'0':'') + curMonth + (curDate<10?'0':'') + curDate;
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
        <div class="pop_tit">품목별요약</div>
        <div class="popCont">
            <div class="srhwrap" style="display:inline-block;">
                <form id="searchForm" name="searchForm" method="POST" onSubmit="return false;">
                <input type="hidden" id="yearId" name="yearId" value="${param.yearId}" />
                
                <div id="filterViewWeek"><jsp:include page="/WEB-INF/view/common/filterViewHorizon.jsp" flush="false" /></div>
                
				
                </form>
                <div class="bt_btn">
                    <a href="#" id="btnSearch" class="fl_app"><spring:message code="lbl.search"/></a>
                </div>
                <div class="srhcondi" style="float:right;">
                <ul>
					<li id="excelSqlContainer" style="padding-right: 10px;padding-top:2px;margin:0px;">
						<div class="locationext">
							<div class="fnc">
								<a href="#" id="excel" class="viewfnc5"><img src="${ctx}/statics/images/common/btn_gun5.gif" title="Excel Download"></a>
								<!--<a href="#" id='sql' style="display:none"class="viewfnc4"><img src="${ctx}/statics/images/common/btn_gun4.gif" title="SQL View"></a>-->
							</div>
						</div>
					</li>
                </ul>
                </div>

            </div>
            <div id="realgrid" class="realgrid1" style="overflow-x:scroll;"></div>
            
        </div>
        <div class="pop_btm">
            <div class="pop_btn_info">
                <strong >Sum  :</strong> <span id="bottom_userSum"></span>
            </div>
            <div class="pop_btn_info">
                <strong >Avg  :</strong> <span id="bottom_userAvg"></span>
            </div>

        </div>
    </div>
</body>
</html>