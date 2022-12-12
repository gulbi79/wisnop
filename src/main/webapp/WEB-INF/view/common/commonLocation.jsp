<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
var lv_conFirmFlag = true;
$("document").ready(function () {
	var params = {P_MENU_CD : "${menuInfo.menuCd}"};
	$(".viewfnc1").click("on", function() { gfn_doNumberFormat(); }); //소수점 표현
	$(".viewfnc2").click("on", function() { gfn_comPopupOpen("MEASURE", params); });
	$(".viewfnc3").click("on", function() { gfn_comPopupOpen("DIMENSION", params); });
	$(".viewfnc4").click("on", function() { fn_apply(true); });
	$(".viewfnc5").click("on", function() { 
		
		if(params.P_MENU_CD == "APS304"){
			var vPlan = $('input[name="planSummary"]:checked').val();
			if(vPlan == "PROD_PART_CD"){
				gfn_doExportExcel({fileNm:"${menuInfo.menuNm}", conFirmFlag: lv_conFirmFlag, topView : true});
			}else if(vPlan == "REP_CUST_GROUP_CD"){
				gfn_doExportExcel({fileNm:"${menuInfo.menuNm}", conFirmFlag: lv_conFirmFlag, gridIdx : 1, topView : true});
			}
		}else{
			gfn_doExportExcel({fileNm:"${menuInfo.menuNm}", conFirmFlag: lv_conFirmFlag, topView : true});	
		}
	});
	
	if(params.P_MENU_CD == "APS405"){
		$("#viewfnc7").show();
		$(".viewfnc7").click("on", function() { gfn_doExportExcel({fileNm:"${menuInfo.menuNm}", conFirmFlag: lv_conFirmFlag, gridIdx : 1}); });
	}
	
	$(".viewfnc6").click("on", function() { gfn_bookMark(); }); //즐겨찾기
	$('#allItem').click("on",function(){
		
		gfn_comPopupOpen("MAT_REQUIR_PLAN_DETAIL", {
            rootUrl    : "aps/planResult",
            url        : "matRequirPlanDetailItemAll",
            width      : 1200,
            height     : 680,
            companyCd  : "${sessionScope.GV_COMPANY_CD}",
            buCd       : "${sessionScope.GV_BU_CD}",
            planId     : $('#planId').val(),
            
            procurType : $('#procurType').val(),
            itemGroup  : $('#itemGroup').val(),
            itemType   : $('#itemType').val(),
            mrpQtyTot  : $('#mrpQtyTot').val(),
            molQtyTot  : $('#molQtyTot').val(),
            item_cd    : $('#item_cd').val(),
            parentItem_cd: $('#parentItem_cd').val()
            
            
        });
		
	})
});

</script>
	<div class="location">
		<img src="${ctx}/statics/images/common/ico_home.gif" alt=""> 
		<c:if test="${not empty menuInfo.level3Nm}">
		<img src="${ctx}/statics/images/common/img_location_ar.gif" alt=""> ${menuInfo.level1Nm}&nbsp; 
		<img src="${ctx}/statics/images/common/img_location_ar.gif" alt=""> ${menuInfo.level2Nm}&nbsp; 
		<img src="${ctx}/statics/images/common/img_location_ar.gif" alt=""> <strong>${menuInfo.level3Nm} </strong>
			<c:if test="${menuInfo.menuCd eq 'SNOP205'}">
				<font style="color:red" id="invenTrans"><spring:message code="lbl.invenWeek"/></font>
			</c:if>
			
			<c:if test="${menuInfo.menuCd eq 'MP205'}">
				<font style="color:red" id="grCompRate"><spring:message code="lbl.grCompRate"/></font>
			</c:if>
		</c:if>
		
		<div class="fnc">
			<c:if test="${menuInfo.menuCd eq 'APS407'}">
            <a href="#" id="allItem" style="padding-top:7px;"><img src="${ctx}/statics/images/common/square.png" title="All Item"></a>
            </c:if>
			<c:if test="${not empty menuInfo.level3Nm}">
			<a href="#" class="viewfnc6"><img src="${ctx}/statics/images/common/btn_gun6.gif" title="My Favorite"></a>
			</c:if>
			<c:if test="${menuInfo.decimalYn eq 'Y'}">
			<a href="#" class="viewfnc1"><img src="${ctx}/statics/images/common/btn_gun1.gif" title="Decimal"></a>
			</c:if>
			<c:if test="${menuInfo.measureYn eq 'Y'}">
			<a href="#" class="viewfnc2"><img src="${ctx}/statics/images/common/btn_gun2.gif" title="Measure Configration"></a>
			</c:if>
			<c:if test="${menuInfo.dimensionYn eq 'Y'}">
			<a href="#" class="viewfnc3"><img src="${ctx}/statics/images/common/btn_gun3.gif" title="Dimension Configration"></a>
			</c:if>
<%-- 			<c:if test="${menuInfo.sqlYn eq 'Y' && sessionScope['GV_DEV_MODE'] eq 'LOCAL'}"> --%>
			<c:if test="${menuInfo.sqlYn eq 'Y'}">
			<a href="#" class="viewfnc4"><img src="${ctx}/statics/images/common/btn_gun4.gif" title="SQL View"></a>
			</c:if>
			<c:if test="${menuInfo.excelYn eq 'Y'}">
			<a href="#" class="viewfnc5"><img src="${ctx}/statics/images/common/btn_gun5.gif" title="Excel Download"></a>
			</c:if>
			<c:if test="${menuInfo.excelYn eq 'Y'}">
			<a href="#" class="viewfnc7" id="viewfnc7" style="display:none;"><img src="${ctx}/statics/images/common/btn_gun5.gif" title="Excel Download"></a>
			</c:if>
		</div>
	</div>
	<c:if test="${menuInfo.producthrcyYn eq 'Y' || menuInfo.customerhrcyYn eq 'Y' || menuInfo.salesOrghrcyYn eq 'Y'}">
	<div class="srhTab">
		<ul>
			<c:if test="${menuInfo.producthrcyYn eq 'Y'}">
			<li><strong>Product :</strong> <span id="loc_product">All</span></li> 
			</c:if>
			<c:if test="${menuInfo.customerhrcyYn eq 'Y'}">
			<li><strong>Customer :</strong> <span id="loc_customer">All</span></li>
			</c:if>
			<c:if test="${menuInfo.salesOrghrcyYn eq 'Y'}">
			<li><strong>Sales Org  :</strong> <span id="loc_salesOrg">All</span></li>  
			</c:if>
		</ul>
	</div>
	</c:if>
	