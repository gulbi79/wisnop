<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//JSP 캐시 삭제
	response.setHeader("Cache-Control", "no-cache"); 
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", 0);
%>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
<meta http-equiv="Expires" content="-1" /> 
<meta http-equiv="Pragma" content="no-cache" /> 
<meta http-equiv="Cache-Control" content="No-Cache" />
<sec:csrfMetaTags/>
<c:if test="${param.popupYn == '' || param.popupYn== null}">
<title>${menuInfo.menuNm}</title>
</c:if>
<c:if test="${param.popupYn == 'Y'}">
<title>${param.popupTitle}</title>
</c:if>
<script type="text/javascript">
var GV_DEV_MODE     = "<spring:eval expression="@environment.getProperty('props.devMode')"/>";
var GV_CONTEXT_PATH = "${ctx}";
var monthMessage = '<spring:message code="msg.filterMonth" />';
var monthOutMessage = '<spring:message code="msg.filterMonthOut" />';
</script>

<link rel="stylesheet" href="${ctx}/statics/css/jquery-ui.css" type="text/css" />
<link rel="stylesheet" href="${ctx}/statics/css/multiple-select.css" type="text/css" />

<!-- Publish -->
<link rel="stylesheet" href="${ctx}/statics/css/style.css" type="text/css" />
<link rel="stylesheet" href="${ctx}/statics/css/themes/normalize.css" type="text/css" />

<c:if test="${param.popupYn == '' || param.popupYn== null}">
<link rel="stylesheet" href="${ctx}/statics/css/zTreeStyle/zTreeStyle.css" type="text/css" />
</c:if>
<script type="text/javascript" src="${ctx}/statics/js/jquery/jquery-3.1.0.min.js"></script>
<script type="text/javascript" src="${ctx}/statics/js/jquery/jquery.form.js"></script>

<script type="text/javascript" src="${ctx}/statics/js/realgrid/<spring:eval expression="@environment.getProperty('props.realgridLic')"/>.js"></script>
<script type="text/javascript" src="${ctx}/statics/js/realgrid/<spring:eval expression="@environment.getProperty('props.realgridjs')"/>.js"></script>
<script type="text/javascript" src="${ctx}/statics/js/realgrid/<spring:eval expression="@environment.getProperty('props.realgridapi')"/>.js"></script>
<script type="text/javascript" src="${ctx}/statics/js/realgrid/RealGridSkins.js"></script>
<script type="text/javascript" src="${ctx}/statics/js/realgrid/jszip.min.js"></script>

<script type="text/javascript" src="${ctx}/statics/js/biz/comutil.js?v=${sversion}"></script>
<script type="text/javascript" src="${ctx}/statics/js/biz/objutil.js?v=${sversion}"></script>
<script type="text/javascript" src="${ctx}/statics/js/biz/gridutil.js?v=${sversion}"></script>
<script type="text/javascript" src="${ctx}/statics/js/biz/common.js?v=${sversion}"></script>
<c:if test="${param.popupYn == '' || param.popupYn== null}">
<script type="text/javascript" src="${ctx}/statics/js/jquery/jquery.ztree.core.js"></script>
<script type="text/javascript" src="${ctx}/statics/js/jquery/jquery.ztree.excheck.js"></script>
</c:if>
<script type="text/javascript" src="${ctx}/statics/js/jquery/jquery.blockUI.js"></script>
<script type="text/javascript" src="${ctx}/statics/js/jquery/multiple-select.js"></script>
<script type="text/javascript" src="${ctx}/statics/js/jquery/jquery-ui.js"></script>
<script type="text/javascript" src="${ctx}/statics/js/jquery/jquery.ui.monthpicker.js"></script>

<!-- Publish -->
<c:if test="${param.popupYn == '' || param.popupYn== null}">
<script type="text/javascript" src="${ctx}/statics/js/pub/pubCommon.js"></script>
</c:if>
<script type="text/javascript" src="${ctx}/statics/js/pub/datepicker.kr.js"></script>
<script type="text/javascript" src="${ctx}/statics/js/pub/split.js"></script>
<script type="text/javascript" src="${ctx}/statics/js/jquery/jquery.inputmask.bundle.min.js"></script>

<!-- chart -->
<c:if test="${param.chartYn=='Y'}">

<script type="text/javascript" src="${ctx}/statics/js/highcharts/highcharts.js"></script>
<script type="text/javascript" src="${ctx}/statics/js/highcharts/highcharts-more.js"></script>
<script type="text/javascript" src="${ctx}/statics/js/highcharts/heatmap.js"></script>
<script type="text/javascript" src="${ctx}/statics/js/highcharts/exporting.js"></script>

</c:if>

<link href="${ctx}/statics/js/quill/quill.snow.css" rel="stylesheet"> 
<script src="${ctx}/statics/js/quill/quill.js"></script>
<script type="text/javascript" src="${ctx}/statics/js/node_modules/quill-image-resize-module/image-resize.min.js"></script>
<script type="text/javascript" src="${ctx}/statics/js/node_modules/quill-image-drop-module/image-drop.min.js"></script>

