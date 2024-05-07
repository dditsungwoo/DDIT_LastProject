<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<script src="/resources/js/weather.js"></script>
<link rel ="stylesheet" href="/resources/css/weather.css">
<%--  <p>${newsList}</p> --%>
<div class="wf-content-wrap">
	<div class="wf-content-area">
		<table class="wf-table">
			<tr>
				<th>IT/컴퓨터 기사</th>
			</tr>
			<%--  <td><a href="${newsList[0].url}">${newsList[0].subject}</a></td> --%>
			<c:forEach var="news" items="${newsList}" varStatus="stat">
				<tr>
					<td><a href="${news.url}">${news.subject}</a></td>
				</tr>
			</c:forEach>
		</table>
	</div>

			<div class='weather'>
				<div class='city'></div>
				<div class='weather_icon'></div>
				<div class='currTemp'></div>
				<div class='nowTime'></div>
			</div>
	
</div>


