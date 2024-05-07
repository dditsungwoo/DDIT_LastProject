<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<script src="/resources/script/attendance/attendance.js"></script>
<link rel="stylesheet" href="/resources/css/attendance/attendance.css" />

<script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
<script src="https://www.gstatic.com/charts/loader.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<style>
#weekDayGraph8{
width: 100px;
height: 200px;
}
</style>
<script>
let sessionEmpNo = <%=session.getAttribute("empNo")%>
//구글 차트 라이브러리를 로딩
google.load("visualization","1",{"packages":["corechart"]})

//불러오는 작업이 완료되어 로딩이 되었다면 drawChart() 함수를 호출하는 콜백이 일어남
google.setOnLoadCallback(drawChart);


getAttendanceTime();


</script>
<c:set var="now" value="<%=new java.util.Date()%>" />
<c:set var="sysDate">
	<fmt:formatDate value="${now}" pattern="yyyy.MM.dd(E)" />
</c:set>
<c:set var="sysTime">
	<fmt:formatDate value="${now}" pattern="HH:mm:ss" />
</c:set>


<div class="wf-main-container">
	<div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
		<h1 class="page-tit">근태관리</h1>
	</div>

	<div class="wf-content-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">
		<section class="wf-flex-box center">
			<div class="wf-box custom wf-content-area attendance-box1" style="width: 40%; height: 265px;">
				<div class="tit-wrap wf-flex-box">
					<h1 class="wf-box-tit">출/퇴근</h1>
					<h2 class="restUse"></h2>
					<!-- <button type="button" class="go-btn">더보기</button> -->
				</div>
				<div class="box-cont attend-cont">
					<div class="attend-box" style="height: 180px; width: 180px;">
						<p id="sysDate" class="current" style="font-size: 1.2em;">&nbsp;</p>
						<p id="sysTime" class="current-date">&nbsp;</p>
						<p class="sub-tit">
							출근: <span class="attendTime">-- : -- : --</span>
						</p>
						<p class="sub-tit">
							퇴근: <span class="lvffcTime">-- : -- : --</span>
						</p>
						<div class="button-wrap">
							<button type="button" id="attendBtn" class="btn2 qrBtn" modal-id="modal-qr">
								<i class="xi-man"></i>출근
							</button>
							<button type="button" id="lvffcBtn" class="btn7 qrBtn" modal-id="modal-qr">
								<i class="xi-run"></i>퇴근
							</button>
						</div>
					</div>
					<div class="chartArea" style="position: relative; margin: 0 auto; height: 180px; width: 180px;">
						<p class="attend-tit">
							오늘의 근무 <i class="xi-time"></i>
						</p>
						<div id="chart_div" style="width: 100%; height: 80%"><div style="position: relative;"></div></div>
					</div>
				</div>
			</div>
			<!-- <div class="wf-content-area attendance-box1">
				<p id="sysDate" class="heading2 align-center"></p>
				<p id="sysTime" class="heading1 align-center"></p>
				<p class="heading2" style="margin-left: 40px;">
					출근: <span class="attendTime">-- : -- : --</span>
				</p>
				<p class="heading2" style="margin-left: 40px;">
					퇴근: <span class="lvffcTime">-- : -- : --</span>
				</p>
				<div class="attendanceBtn-container">
					<button type="button" id="attendBtn" class="btn2 qrBtn" modal-id="modal-qr"><i class="xi-man"></i>출근</button>
					<button type="button" id="lvffcBtn" class="btn7 qrBtn" modal-id="modal-qr"><i class="xi-run"></i>퇴근</button>
				</div>
			</div>

			<div class="wf-content-area chartArea">
				<div id="chart_div" style="position: relative; background: none;"></div>
			</div> -->

			<div class="wf-content-area attendance-box2" style="margin-top: 0px;">
				<p class="weekDay1 heading2 align-center"></p>
				<div class="wf-flex-box">
					<p style="width: 82%; text-align: right;">40h</p>
					<p style="width: 18%; text-align: right;">50h</p>
				</div>
				<div class="wf-content-area todayWeekBar"></div>
				<br>
				<p class="heading2 needTime">필요 근무시간 : 40h 0m</p>
				<p class="heading2 plusTime">누적 근무시간 :&nbsp;</p>
				<p class="heading2 minusTime">잔여 근무시간 :&nbsp;</p>
				<p class="heading2 overTime">초과 근무시간 :&nbsp;</p>
			</div>
		</section>
		<div class="wf-content-area attendance-box3 wf-flex-box">
			<div class="tab-type tab-type1">
				<section class="wf-flex-box">
					<div class="tab-menu">
						<button data-tab="tab1" type="button" class="tab-btn weekTab active">주</button>
						<button data-tab="tab2" type="button" class="tab-btn monthTab">월</button>
						<div class="tab-indicator"
							style="width: 140px; transform: translateX(0px);"></div>
					</div>
					<div>
						<p class="heading1" style="text-align: center; width: 910px;">근태
							분석</p>
					</div>
					<div style="width:280px;">
						<button type="button" class="btn5 mainWeek" style="float:right;">이번주 보기</button>
					</div>
				</section>
				<p class="weekDay2 heading2" style="text-align: center"></p>

				<div class="wf-content-box">
					<div>
						<p class="box-heading1">근무시간</p>
					</div>
					<div class="wf-flex-box workGraphDiv">
						<div class="weekDayDiv weekDayDiv1" style="width: 1000px; height: 200px;">
							<canvas id="weekDayGraph" width="1000" height="200"></canvas>
						</div>
							
						<div class="avgDiv">

							<p class="box-heading1">
								평균 출근 시간: <span class="avgAttend"></span>
							</p>
							<p class="box-heading1">
								평균 퇴근 시간: <span class="avgLeave"></span>
							</p>
							<p class="box-heading1">
								평균 근무 시간: <span class="avgWork"></span>
							</p>
							<p class="box-heading1 ">
								지각 <span class="late">0</span>
							</p>
							<p class="box-heading1 ">
								연차 <span class="rest">0</span>
							</p>
							<p class="box-heading1 ">
								외출 <span class="out1">0</span> 조퇴 <span class="out2">0</span> 결근<span
									class="out3">0</span>
							</p>
						</div>
						<div class="avgBadgeDiv">

							<p class="box-heading1 badge-avgAttend">&nbsp;</p>
							<p class="box-heading1 badge-avgLeave">&nbsp;</p>
							<p class="box-heading1 badge-avgWork">&nbsp;</p>
							<p class="box-heading1 badge-late">&nbsp;</p>
							<p class="box-heading1 badge-rest">&nbsp;</p>
							<p class="box-heading1 badge-out">&nbsp;</p>
						</div>
					</div>
					<!-- 월 데이터 -->
					<div class="wf-flex-box workGraphDiv2" style="display: none;">
						<div class="monthDayDiv monthDayDiv1" style="width: 1400px; height: 200px;">
							<canvas id="monthDayGraph" width="1400" height="200"></canvas>
						</div>
				       

					</div>
					 <div class="avgMonthDiv" style="width:100%; text-align: center; display:none;">
						<br><br>
			        	<p class="box-heading2">평균 출근 시간: <span class="avgAttend"></span> &nbsp;&nbsp;&nbsp;&nbsp;
			        	평균 퇴근 시간: <span class="avgLeave"></span>&nbsp;&nbsp;&nbsp;&nbsp;
			        	평균 근무 시간: <span class="avgWork"></span>&nbsp;&nbsp;&nbsp;&nbsp;
			        	지각 <span class="late">0</span>&nbsp;&nbsp;&nbsp;&nbsp;
			        	연차 <span class="rest">0</span>&nbsp;&nbsp;&nbsp;&nbsp;
			        	외출 <span class="out1">0</span> 조퇴 <span class="out2">0</span>  결근<span class="out3">0</span></p>
			        </div>
				</div>

			</div>

		</div>

	</div>
</div>
<div class="modal" id="modal-qr">
	<div class="modal-cont" style="display: flex; flex-direction: row; width:400px;">
		<div class="qr-modal-cont"></div>
		<div>
			<p class="heading1" style="margin: 30px;">코드를 스캔하여<br> <span class="attendLvffcSe">출근</span>체크를 완료해주세요.</p>
		</div>
	</div>
</div>



