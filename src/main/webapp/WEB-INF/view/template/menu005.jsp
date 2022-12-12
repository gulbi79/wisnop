<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>

	<script type="text/javascript">
  	//전역변수 설정
  	var gridInstance, grdMain, dataProvider;
  	var zTreeObj;
    $(function() {
    	//공통 폼 초기 정보 설정
    	gfn_formLoad();
    	fn_initDate(); //달력
    	fn_initGrid(); //그리드를 그린다.
        fn_initEvent(); //이벤트 정의
    });

    //달력 설정
    function fn_initDate() {
    	DATEPICKET(null,-14,0); //option,from,to
    }

    //그리드를 그린다.
    function fn_initGrid() {
    	//변수처리
    	gridInstance = new GRID();
    	gridInstance.init("realgrid1");
    	grdMain = gridInstance.objGrid;
    	dataProvider = gridInstance.objData;
    }

  	//이벤트 정의
    function fn_initEvent() {
  		
    	$('#excelFile').on('change', function(){
    		gfn_importGrid({fieldFlag: "Y"});
    	});
  		
    	$("#btnExcelDownload").click("on", function() { gfn_doExportExcel({fileNm:"Test",formYn:"Y",indicator:"hidden",conFirmFlag:false}); });
    	$("#btnExcelUpload").click("on", function() { $("#excelFile").trigger("click"); });
    }

    </script>

</head>
<body id="framesb">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	<div id="a" class="split content split-horizontal">
		<div id="filterDv">
			<div class="inner">
				<h3>Filter</h3>
				<%@ include file="/WEB-INF/view/common/filterMonthSum.jsp" %>
				<div class="tabMargin"></div>
				<div class="scroll">
					<%@ include file="/WEB-INF/view/common/filterViewHorizon.jsp" %>
					<div class="view_combo">
						<div class="ilist">
							<div class="itit">SubTitle</div>
							<div class="iptdv borNone">
								<select class="iptcombo">
									<option value="--">Single Combo</option>
									<option value="01">Single Combo</option>
									<option value="02">Single Combo</option>
									<option value="03">Single Combo</option>
									<option value="04">Single Combo</option>
								</select>
							</div>
						</div>
					</div>
				</div>
				<div class="bt_btn">
					<a href="#" class="fl_app"><spring:message code="lbl.search"/></a>
				</div>
			</div>
		</div>
	</div>
	<div id="b" class="split split-horizontal">
	<div id="e" class="split content" style="border:0;background:transparent;">
		<div id="grid1" class="fconbox">
			<%@ include file="/WEB-INF/view/common/commonLocation.jsp" %>
			<div class="use_tit">
				<h3>My Opportunities</h3> <h4>- recently created</h4>
			</div>
			<div class="scroll">
				<!-- 그리드영역 -->
				<div id="realgrid1" class="realgrid1" style="width: 100%; height: 300px;"></div>
			</div>
		</div>
	</div>
	<div id="f" class="split content" style="border:0;background:transparent;">
		<div id="grid2" class="fconbox">
			<div class="use_tit">
				<h3>my Activities</h3> <h4>- Next 7 days</h4>
			</div>
			<div class="scroll">
				<!-- 그리드영역 -->
				<div id="realgrid2" class="realgrid1"></div>
			</div>

			<div class="cbt_btn">
				<div class="bleft">
				<form id="excelForm" method="post" enctype="multipart/form-data">
					<input type="file" name="excelFile" id="excelFile" style="display:none;"/>
				</form>
				<a href="javascript:void(null)" id="btnExcelDownload" class="app1"><spring:message code="lbl.excelDownload"/></a>
				<a href="javascript:void(null)" id="btnExcelUpload" class="app1"><spring:message code="lbl.excelUpload"/></a>
				</div>

				<div class="bright">
				<a href="#" class="app1">Reset</a>
				<a href="#" class="app2">Save</a>
				</div>
			</div>
		</div>
	</div>
    </div>
</body>
</html>
