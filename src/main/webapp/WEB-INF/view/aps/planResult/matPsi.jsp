<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
<script type="text/javascript">
	var enterSearchFlag = "Y";
	var monthCount = 12;
	var matPsi = {
		init : function () {
			gfn_formLoad();
			this.comCode.initCode();
			this.initFilter();
			this.grid.initGrid();
			this.events();
		},
		
		_siq    : "aps.dynamic.matPsi",
		
		comCode : {
			codeMapEx : null,
			codeMap   : null,
			initCode  : function() {
				var grpCd      = 'VERSION_TYPE_CD,PROCUR_TYPE,ITEM_TYPE';
				this.codeMap   = gfn_getComCode(grpCd, 'Y'); 
				this.codeMapEx = gfn_getComCodeEx(["ITEM_GROUP"]);
				
				this.codeMap.VERSION_TYPE_CD[0].CODE_NM = "";
				
				this.codeMap.VERSION_TYPE_CD = $.grep(this.codeMap.VERSION_TYPE_CD, function(v, n) {
					return v.CODE_CD != 'M'; 
				});
			}
		},
		
		initFilter : function() {
			//Plan ID
	    	fn_getPlanId({picketType : "W", planTypeCd : "MP"});
			
			// 키워드팝업
			gfn_keyPopAddEvent([
				{ target : 'divItem', id : 'item', type : 'COM_ITEM', title : '<spring:message code="lbl.item"/>' }
			]);
			
			// 콤보박스
			gfn_setMsComboAll([
				{ target : 'divVersionType', id : 'versionType', title : '<spring:message code="lbl.versionType2"/>', data : this.comCode.codeMap.VERSION_TYPE_CD, exData:["*"], type : "S"},
				{ target : 'divItemType'   , id : 'itemType'   , title : '<spring:message code="lbl.itemType"/>'    , data : this.comCode.codeMap.ITEM_TYPE, exData:[""]},
				{ target : 'divProcurType' , id : 'procurType' , title : '<spring:message code="lbl.procureType"/>' , data : this.comCode.codeMap.PROCUR_TYPE, exData:[""]},
				{ target : 'divItemGroup'  , id : 'itemGroup'  , title : '<spring:message code="lbl.itemGroup"/>'   , data : this.comCode.codeMapEx.ITEM_GROUP, exData:[""]}
			]);
			
			$("#procurType").multipleSelect("setSelects", ["MM", "OH", "OP"]);
			
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
				
				this.gridInstance.custBucketFalg = true;
				
				this.setOptions();
				gfn_setMonthSum(matPsi.grid.gridInstance, false, false, true);  // omit 0 추가
			},
			
			setOptions : function() {
				this.grdMain.setOptions({
					//stateBar: { visible : true }
				});

				this.dataProvider.setOptions({
					softDeleting : true
				});
			}
		},
		
		events : function () {
			
			$('#toMon').on("change",function(event){
				fn_monthCounter();
				
			});
			
			$("#btnSearch").on("click", function(e) {
				fn_apply(false);
			});
			
			
			
			
		},
		
		getBucket : function(sqlFlag) {
			var ajaxMap = {
					fromDate : gfn_replaceAll($("#fromCal").val(), "-", ""),
					toDate   : gfn_replaceAll($("#toCal").val(), "-", ""),
		       		week     : {isDown: "Y", isUp:"N", upCal:"M", isMt:"N", isExp:"N", expCnt:1},
					sqlId    : ["bucketFullWeek"]
				};
			gfn_getBucket(ajaxMap);
			
			if (!sqlFlag) {
				matPsi.grid.gridInstance.setDraw();
				fn_setNumberFields();
				
				for(var i = 1; i < 7; i++) {
					matPsi.grid.grdMain.setColumnProperty("VALUE_W" + i, "header", BUCKET.query[i - 1].NM);
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
					
					if(id == "divPlanId"){
						EXCEL_SEARCH_DATA += $("#planId option:selected").text();
					}else if(id == "divVersionType"){
						EXCEL_SEARCH_DATA += $("#versionType option:selected").text();
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
					}else if(id == "divItem"){
						EXCEL_SEARCH_DATA += $("#item_nm").val();
					}
				}
			});
		},
		
		search : function () {
			FORM_SEARCH._mtd     = "getList";
			FORM_SEARCH.tranData = [{ outDs : "resList",_siq : matPsi._siq }];
			
			var aOption = {
				url     : GV_CONTEXT_PATH + "/biz/obj.do",
				data    : FORM_SEARCH,
				success : function (data) {
					  
					if (FORM_SEARCH.sql == 'N') {
						matPsi.grid.dataProvider.clearRows(); //데이터 초기화
						
						//그리드 데이터 생성
						matPsi.grid.grdMain.cancel();
						
						matPsi.grid.dataProvider.setRows(data.resList);
						matPsi.grid.dataProvider.clearSavePoints();
						matPsi.grid.dataProvider.savePoint(); //초기화 포인트 저장
						gfn_setSearchRow(matPsi.grid.dataProvider.getRowCount());
						gfn_setRowTotalFixed(matPsi.grid.grdMain);
					}
				}
			}
			gfn_service(aOption, "obj");
		}
	};
	
	function fn_setNumberFields(){
		
		var fileds = matPsi.grid.dataProvider.getFields();
		var filedsLen = fileds.length;
		
		for (var i = 0; i < filedsLen; i++) {
			
			var fieldName = fileds[i].fieldName;
			
			if(fieldName == "ITEM_COST_KRW_NM" || fieldName == "SS_QTY_DISP_NM"){
				
				fileds[i].dataType = "number";
				matPsi.grid.grdMain.setColumnProperty(fieldName, "styles", {"numberFormat" : "#,##0"});
			}
		}
		
		matPsi.grid.dataProvider.setFields(fileds);
	}
	
	//조회
	var fn_apply = function (sqlFlag) {
		
		var versionType = gfn_nvl($("#versionType").val(), "");
		
		if(versionType == ""){
			alert('<spring:message code="msg.versionTypeMsg"/>');
			return;
		}
    	
		gfn_getMenuInit();
		matPsi.getBucket(sqlFlag);
		
    	//조회조건 설정
    	FORM_SEARCH            = $("#searchForm").serializeObject(); //초기화
    	FORM_SEARCH.sql        = sqlFlag;
    	FORM_SEARCH.dimList    = DIMENSION.user;
   		FORM_SEARCH.meaList	   = MEASURE.user;
   		
    	matPsi.search();
    	matPsi.excelSubSearch();
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
					
					gfn_setMsCombo("planId",data.rtnList,[""]);
					
				
					
					//fn_monthCounter();
					$("#planId").on("change", function(e) {
						var nowDate = null;
						var fDs = gfn_getFindDataDsInDs(data.rtnList, {CODE_CD : {VALUE : $(this).val(), CONDI : "="}});
						
						if (fDs.length > 0) {
							nowDate = fDs[0].SW_START_DATE;
						
							$("#cutOffFlag").val(fDs[0].CUT_OFF_FLAG);
							$("#fromCal").val(fDs[0].SW_START_DATE);
							$("#toCal").val(fDs[0].SW_END_DATE);
							var DATE_plus_42 = weekdatecal(nowDate,42);
						    var DATE_plus_180 = weekdatecal(nowDate,364);
						    
							
							var tStartMon = nowDate.substring(0, 4) + nowDate.substring(4, 6);
							var tCloseMon = gfn_addDate("month", 5, "", tStartMon + "01").substring(0, 6);
							var ttCloseMon = gfn_addDate("month", 11, "", tStartMon + "01").substring(0, 6);
							
							var minMonthStart = gfn_getStringToDate(tStartMon + "01");
							var maxMonthClose = gfn_getStringToDate(tCloseMon + "01");
							var maxMonthEdt =  gfn_getStringToDate(ttCloseMon + "01");
							
							
							MONTHPICKER(null, tStartMon, tCloseMon);
							$("#fromMon").monthpicker("option", "minDate", minMonthStart);
							$("#toMon").monthpicker("option", "maxDate", maxMonthEdt);
							
					
						}
						
						$('#toMon').on("change",function(event){
							
							fn_monthCounter();
							
						});
						
					});
					
					$("#planId").trigger("change");
				}
			},"obj");
			
		} catch(e) {console.log(e);}
	}
	
	function fn_setFieldsBuket() {
		//필드 배열 객체를  생성합니다.
        var fields = [
        	
            {fieldName: "VALUE_W1", dataType : "number"},
            {fieldName: "VALUE_W2", dataType : "number"},
            {fieldName: "VALUE_W3", dataType : "number"},
            {fieldName: "VALUE_W4", dataType : "number"},
            {fieldName: "VALUE_W5", dataType : "number"},
            {fieldName: "VALUE_W6", dataType : "number"}
            ];    
            //여기서 부터 VALUE_M0 ~ 11가지는 사용자 달력선태에 따른 동적인 FIELD 생성 해야 함
            /*
            {fieldName: "VALUE_M0", dataType : "number"},
            {fieldName: "VALUE_M1", dataType : "number"},
            {fieldName: "VALUE_M2", dataType : "number"},
            {fieldName: "VALUE_M3", dataType : "number"},
            {fieldName: "VALUE_M4", dataType : "number"},
            {fieldName: "VALUE_M5", dataType : "number"},
            {fieldName: "VALUE_M6", dataType : "number"},
            {fieldName: "VALUE_M7", dataType : "number"},
            {fieldName: "VALUE_M8", dataType : "number"},
            {fieldName: "VALUE_M9", dataType : "number"},
            {fieldName: "VALUE_M10", dataType : "number"},
            {fieldName: "VALUE_M11", dataType : "number"}
            */
            
            for(i=0;i<monthCount;i++)
    		{
    	
    			fields.push({fieldName:'VALUE_M'+i+'',dataType : "number"});
    			
    		}
         
        return fields;
	}
	
	function fn_setColumnsBuket() {
		//필드와 연결된 컬럼 배열 객체를 생성합니다.
        var columns = [
            {
            	name: "VALUE_W1",
                fieldName: "VALUE_W1",
                editable: false,
                header: {text: '<spring:message code="lbl.1wk"/>'},
                styles : {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
                dynamicStyles : [gfn_getDynamicStyle(-2)],
				width : 80
            },
            {
            	name: "VALUE_W2",
                fieldName: "VALUE_W2",
                editable: false,
                header: {text: '<spring:message code="lbl.2wk"/>'},
                styles : {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
                dynamicStyles : [gfn_getDynamicStyle(-2)],
				width : 80
            },
            {
            	name: "VALUE_W3",
                fieldName: "VALUE_W3",
                editable: false,
                header: {text: '<spring:message code="lbl.3wk"/>'},
                styles : {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
                dynamicStyles : [gfn_getDynamicStyle(-2)],
				width : 80
            },
            {
            	name: "VALUE_W4",
                fieldName: "VALUE_W4",
                editable: false,
                header: {text: '<spring:message code="lbl.4wk"/>'},
                styles : {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
                dynamicStyles : [gfn_getDynamicStyle(-2)],
				width : 80
            },
            {
            	name: "VALUE_W5",
                fieldName: "VALUE_W5",
                editable: false,
                header: {text: '<spring:message code="lbl.5wk"/>'},
                styles : {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
                dynamicStyles : [gfn_getDynamicStyle(-2)],
				width : 80
            },
            {
            	name: "VALUE_W6",
                fieldName: "VALUE_W6",
                editable: false,
                header: {text: '<spring:message code="lbl.6wk"/>'},
                styles : {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
                dynamicStyles : [gfn_getDynamicStyle(-2)],
				width : 80
            }
            
        ];
		
        //여기서 부터 VALUE_M0 ~ 11가지는 사용자 달력선태에 따른 동적인 FIELD 생성 해야 함
        /*
          {
          	name: "VALUE_M0",
              fieldName: "VALUE_M0",
              editable: false,
              header: {text: '<spring:message code="lbl.apsM0"/>'},
              styles : {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
              dynamicStyles : [gfn_getDynamicStyle(-2)],
				width : 80
          },
          {
          	name: "VALUE_M1",
              fieldName: "VALUE_M1",
              editable: false,
              header: {text: '<spring:message code="lbl.apsM1"/>'},
              styles : {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
              dynamicStyles : [gfn_getDynamicStyle(-2)],
				width : 80
          },
          {
          	name: "VALUE_M2",
              fieldName: "VALUE_M2",
              editable: false,
              header: {text: '<spring:message code="lbl.apsM2"/>'},
              styles : {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
              dynamicStyles : [gfn_getDynamicStyle(-2)],
				width : 80
          },
          {
          	name: "VALUE_M3",
              fieldName: "VALUE_M3",
              editable: false,
              header: {text: '<spring:message code="lbl.apsM3"/>'},
              styles : {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
              dynamicStyles : [gfn_getDynamicStyle(-2)],
				width : 80
          },
          {
          	name: "VALUE_M4",
              fieldName: "VALUE_M4",
              editable: false,
              header: {text: '<spring:message code="lbl.apsM4"/>'},
              styles : {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
              dynamicStyles : [gfn_getDynamicStyle(-2)],
				width : 80
          },
          {
          	name: "VALUE_M5",
              fieldName: "VALUE_M5",
              editable: false,
              header: {text: '<spring:message code="lbl.apsM5"/>'},
              styles : {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
              dynamicStyles : [gfn_getDynamicStyle(-2)],
				width : 80
          },
          {
          	name: "VALUE_M6",
              fieldName: "VALUE_M6",
              editable: false,
              header: {text: '<spring:message code="lbl.apsM6"/>'},
              styles : {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
              dynamicStyles : [gfn_getDynamicStyle(-2)],
				width : 80
          },
          {
          	name: "VALUE_M7",
              fieldName: "VALUE_M7",
              editable: false,
              header: {text: '<spring:message code="lbl.apsM7"/>'},
              styles : {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
              dynamicStyles : [gfn_getDynamicStyle(-2)],
				width : 80
          },
          {
          	name: "VALUE_M8",
              fieldName: "VALUE_M8",
              editable: false,
              header: {text: '<spring:message code="lbl.apsM8"/>'},
              styles : {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
              dynamicStyles : [gfn_getDynamicStyle(-2)],
				width : 80
          },
          {
          	name: "VALUE_M9",
              fieldName: "VALUE_M9",
              editable: false,
              header: {text: '<spring:message code="lbl.apsM9"/>'},
              styles : {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
              dynamicStyles : [gfn_getDynamicStyle(-2)],
				width : 80
          },
          {
          	name: "VALUE_M10",
              fieldName: "VALUE_M10",
              editable: false,
              header: {text: '<spring:message code="lbl.apsM10"/>'},
              styles : {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
              dynamicStyles : [gfn_getDynamicStyle(-2)],
				width : 80
          },
          {
          	name: "VALUE_M11",
              fieldName: "VALUE_M11",
              editable: false,
              header: {text: '<spring:message code="lbl.apsM11"/>'},
              styles : {textAlignment: "far", background : gv_noneEditColor, numberFormat : "#,##0"},
              dynamicStyles : [gfn_getDynamicStyle(-2)],
				width : 80
          }
          
          */
		//ex:name:'MRP_QTY_M'+i+'',, fieldName:'MRP_QTY_M'+i+'',header:{text: '<spring:message code="lbl.apsM'+i+'"/>',styles : {textAlignment: "far", background : gv_noneEditColor}, width : 80
        for(i=0;i<monthCount;i++)
   		{
   	    	columns.push({name:'VALUE_M'+i+'',fieldName:'VALUE_M'+i+'',editable: false,header:{text:'M'+i+''},styles : {textAlignment: "far",background : gv_noneEditColor, numberFormat : "#,##0"},dynamicStyles : [gfn_getDynamicStyle(-2)],width : 80});
   		}
		
        return columns;
	}
	
	// onload 
	$(document).ready(function() {
		matPsi.init();
	});
	
	//사용자 toMon 선택에 따른
	//fromMon 부터 toMon까지 몇개월인지 counting 하는 함수
	//이 값을 계산하여 GRID 상에 보여지는 MONTH 컬럼의 개수를 계산하기 위함
	// 
	function fn_monthCounter(){
	
	var fromMon = $('#fromMon').val();
	var fromMonYear = fromMon.substring(0,4);
	var fromMonMonth = parseInt(fromMon.split('-')[1]);
	
	var toMon = $('#toMon').val();
	var toMonYear = toMon.substring(0,4);
	var toMonMonth = parseInt(toMon.split('-')[1]);
	
	
		//fromMon 년도와 toMon 년도가 다를 때
		// ex:   fromMon=>2020-10,   toMon=> 2021-3 
		//monthCount
		if(fromMonYear==toMonYear)
		{
			monthCount = (toMonMonth-fromMonMonth)+1;
		}
		//fromMon 년도와 toMon 년도가  같을 때,
		// ex:   fromMon=>2020-10,   toMon=> 2020-12	
		//monthCount
		else
		{
			monthCount= toMonMonth +(12-fromMonMonth)+1;
		}
		
	
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
		<input type="hidden" id="omitBaseCd" name="omitBaseCd" value="BOH_QTY"/>
		<div id="filterDv">
			<div class="inner">
				<h3>Filter</h3>
				<%@ include file="/WEB-INF/view/common/filterMonthSum.jsp" %>
				<div class="tabMargin"></div>
				<div class="scroll">
					<div class="view_combo" id="divPlanId">
						<div class="ilist">
							<div class="itit"><spring:message code="lbl.planId2"/></div>
							<div class="iptdv borNone">
								<select id="planId" name="planId" class="iptcombo"></select>
							</div>
						</div>
					</div>
					<input type='hidden' id='cutOffFlag' name='cutOffFlag'>
					<input type="hidden" id="fromCal" name="fromCal"/>
					<input type="hidden" id="toCal" name="toCal"/>
					<div class="view_combo" id="divVersionType"></div>
					<div class="view_combo" id="divItemType"></div>
					<div class="view_combo" id="divProcurType"></div>
					<div class="view_combo" id="divItemGroup"></div>
					<div class="view_combo" id="divItem"></div>
					<div id="filterViewMonth"><%@ include file="/WEB-INF/view/common/filterViewHorizonMonth.jsp" %></div>
					<div class="view_combo" id="divSchedDateOrgDate">
							<strong class="filter_tit">입고예정일자/OriginalDate </strong>
							<ul class="rdofl">
								<li><input type="radio" id="schedDate" name="schedDateOrgDate" value="SCHED" checked="checked"><label for="schedDate">입고예정일자</label></li>
								<li><input type="radio" id="orgDate" name="schedDateOrgDate" value="ORG" ><label for="orgDate">OriginalDate</label></li>
								
							</ul>
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
		</div>
    </div>
</body>
</html>