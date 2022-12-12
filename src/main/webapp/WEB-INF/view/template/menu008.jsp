<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/view/layout/include.jsp" %>
	<script type="text/javascript">
    $(function() {
    	//공통 폼 초기 정보 설정
    	gfn_formLoad();
    	fn_init();
    });
    
    function fn_init() {
    }
    
    
    </script>

</head>
<body id="framesb" class="portalFrame bg">
	<%@ include file="/WEB-INF/view/layout/commonForm.jsp" %>
	
	<!-- contents -->
	<div id="grid1" class="fconbox">
		<%@ include file="/WEB-INF/view/common/commonLocation.jsp" %>
		
			<div id="portal">
			  <div id="container" class="bg">
			  	  
				  <div id="cont_chart" class="full_chart">
			      		<!-- 20180213 start -->
			    		<!-- 1줄 3개씩 뿌리길 원하실 경우 col_3 으로 클래스명 변경하시면 됩니다 -->
			    	
			        
			        	<div class="col_3">
			            	<h4>BSC 종합</h4>
			                <div class="graphwrap"></div>
			                <div class="textwrap">
			                	<p>달성률</p>
			                    <p class="per_txt blue_f"><strong>97</strong>%</p>
			                </div>
			            </div>
			            
			            <div class="col_3">
			            	<h4>경영실적</h4>
			                <div class="tablewrap">
			                	<table >
			                    <caption>경영실적</caption>
			  <thead>
			    <tr>
			      <th scope="col" rowspan="2">구분</th>
			      <th scope="col" colspan="2">연간(누계)</th>
			      <th scope="col" colspan="2">연간(누계)</th>
			    </tr>
			    <tr>
			      <th scope="col">실적</th>
			      <th scope="col">달성률</th>
			      <th scope="col">실적</th>
			      <th scope="col">달성률</th>
			    </tr>
			  </thead>
			  <tbody>
			    <tr>
			      <td>매출액</td>
			      <td class="red_f">100.1억</td>
			      <td>96%</td>
			      <td>110.0억</td>
			      <td class="green_f">103%</td>
			    </tr>
			     <tr>
			      <td>영업이익</td>
			      <td class="red_f">100.1억</td>
			      <td>96%</td>
			      <td>110.0억<sup>1</sup></td>
			      <td class="green_f">103%</td>
			    </tr>
			  </tbody>
			</table>
			<p class="help_txt">1) 예상 실적임</p>
			
			                </div>
			            </div>
			            
			            <div class="col_3">
			            	<h4>제품 재고 현황</h4>
			                <div class="graphwrap"></div>
			                <div class="textwrap">
			                	<p>달성률</p>
			                    <p class="per_txt blue_f"><strong>-5</strong>%</p>
			                </div>
			            </div>
			            
			            <div class="col_3">
			            	<h4>불량률 현황</h4>
			                <div class="graphwrap"></div>
			                <div class="textwrap">
			                	<p>목표 달성률</p>
			                    <p class="per_txt red_f"><strong>93</strong>%</p>
			                </div>
			            </div>
			        
			       		<div class="col_3">
			            	<h4>당월 판매 예상</h4>
			                <div class="graphwrap"></div>
			                <div class="textwrap">
			                	<p>달성률</p>
			                    <p class="per_txt blue_f"><strong>93</strong>%</p>
			                </div>
			            </div>
			            
			            <div class="col_3">
			            	<h4>자재 재고 현황</h4>
			                <div class="graphwrap"></div>
			                <div class="textwrap">
			                	<p>달성률</p>
			                    <p class="per_txt red_f"><strong>+93</strong>%</p>
			                </div>
			            </div>
			            
			            <div class="col_3">
			            	<h4>생산 계획 준수율</h4>
			                <div class="graphwrap"></div>
			                <div class="textwrap">
			                	<p>달성률</p>
			                    <p class="per_txt blue_f"><strong>93</strong>%</p>
			                </div>
			            </div>
			        
			       		<div class="col_3">
			            	<h4>판매 계획 준수율</h4>
			                <div class="graphwrap"></div>
			                <div class="textwrap">
			                	<p>달성률</p>
			                    <p class="per_txt blue_f"><strong>107</strong>%</p>
			                </div>
			            </div>
			            
			            <div class="col_3">
			            	<h4>자재 준비율</h4>
			                <div class="graphwrap"></div>
			                <div class="textwrap">
			                	<p>달성률</p>
			                    <p class="per_txt red_f"><strong>93</strong>%</p>
			                </div>
			            </div>
			
				  </div>
				 
				</div>
			</div>
	</div>
</body>
</html>
