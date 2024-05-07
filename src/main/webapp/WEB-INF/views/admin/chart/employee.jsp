<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css"/>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"></script>  
  
<link rel="stylesheet" href="/resources/css/statistics/adminEmp.css" />

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="/resources/script/statistics/adminEmp.js"></script>

<div class="wf-main-container">
	<div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
		<h1 class="page-tit">사원 통계</h1>
	</div>
	<div class="wf-flex-box" style="height: 460px;" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">
		<div>
			<div class="wf-content-wrap wf-flex-box line1">
			
<!-- 				<div class="wf-content-area box2"> -->
<!-- 					<p class="heading1 align-center">사원</p> -->
<!-- 					<p class="heading1 align-center">관리/통계</p> -->
<!-- 				</div> -->
				<div class="wf-content-area box1" style="margin-top: 0px;">
					<p class="heading1 align-center">전체 사원 수</p>
					<p class="point align-center allEmpCount">&nbsp;</p>
				</div>
				<div class="wf-content-area box1" style="margin-top: 0px;">
					<p class="heading1 align-center">입사자 수</p>
					<p class="point align-center hireCount">&nbsp;</p>
				</div>
				<div class="wf-content-area box1" style="margin-top: 0px;">
					<p class="heading1 align-center">이직자 수</p>
					<p class="point align-center retire2">&nbsp;</p>
				</div>
				<div class="wf-content-area box1" style="margin-top: 0px;">
					<p class="heading1 align-center">연간 퇴사율</p>
					<p class="point align-center retire3">&nbsp;</p>
				</div>
				<div class="wf-content-area box1" style="margin-top: 0px;">
					<p class="heading1 align-center">평균 나이</p>
					<p class="point align-center avgage">&nbsp;</p>
				</div>
				
			</div>
			<div class="wf-flex-box line2">
				<div class="yearClassify1">
					<div class="wf-content-box yearClassify" style="margin-top: 10px; width:70px; background: #00a287; color: #fff">
						<p class="heading2 align-center yearChoice">2024</p>
					</div>
					<div class="wf-content-box yearClassify" style="margin-top: 10px; width:70px;">
						<p class="heading2 align-center">2023</p>
					</div>
					<div class="wf-content-box yearClassify" style="margin-top: 10px; width:70px;">
						<p class="heading2 align-center">2022</p>
					</div>
					<div class="wf-content-box yearClassify" style="margin-top: 10px; width:70px;">
						<p class="heading2 align-center">2021</p>
					</div>
					<div class="wf-content-box yearClassify" style="margin-top: 10px; width:70px;">
						<p class="heading2 align-center">2020</p>
					</div>
					<div class="wf-content-box yearClassify" style="margin-top: 10px; width:70px;">
						<p class="heading2 align-center">2019</p>
					</div>
					<div class="wf-content-box yearClassify" style="margin-top: 10px; width:70px;">
						<p class="heading2 align-center">2018</p>
					</div>
					<div class="wf-content-box yearClassify" style="margin-top: 10px; width:70px;">
						<p class="heading2 align-center">2017</p>
					</div>
					<div class="wf-content-box yearClassify" style="margin-top: 10px; width:70px;">
						<p class="heading2 align-center">2016</p>
					</div>
				</div>
				<div class="wf-content-area line2 box">
					<p class="heading2 align-center">지역별 인원수</p>
					<div class="chart-container2">
						<canvas id="localChart" style="width: 300px; height: 250px;"></canvas>
					</div>
				</div>
				<div class="wf-content-area line2">
					<p class="heading2 align-center">본부별 인원수</p>
					<div class="chart-container2">
						<canvas id="deptChart" style="width: 300px; height: 250px;"></canvas>
					</div>
				</div>
				
				<div class="wf-content-area line2">
					<p class="heading2 align-center">부서별 인원수</p>
					<div class="deptSelectWrap">
						<select name="deptSelect" id="deptSelect">
	                        <option value="DEPT01">기획</option>
	                        <option value="DEPT02">경영</option>
	                        <option value="DEPT03">영업</option>
	                        <option value="DEPT04">마케팅</option>
	                        <option value="DEPT05">개발</option>
                   	 	</select>
					</div>
					<div id="deptDetailChart-container">
						<canvas id="deptDetailChart" style="width: 300px; height: 220px;"></canvas>
					</div>
				</div>
				
			</div>
		
		</div>
		
		<div class="wf-content-area genderBox">
				<div style="text-align: center"><p class="heading1">사원 성비</p></div>
			<div class="wf-flex-box">
				<div style="margin: 0px auto;">
					<i class="xi-woman" style="font-size: 60px; color: rgb(255, 99, 132);"></i>
					<p class="heading1 align-center femaleRate">&nbsp;</p>
				</div>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<div style="margin: 0px auto;">
					<i class="xi-man" style="font-size: 60px; color: rgb(54, 162, 235);"></i>
					<p class="heading1 align-center maleRate">&nbsp;</p>
				</div>
			</div>
			<div style="width: 280px; height: 280px;">
				<canvas id="genderChart"></canvas>
			</div>
		</div>
		
	</div>
	<div class="wf-flex-box line3" data-aos="fade-right" data-aos-duration="700" data-aos-delay="400">
		<div class="wf-content-area box3">
			<p class="heading2 align-center">나이 분포도</p>
			<div class="chart-container" style="width: 400px; height:230px;">
				<canvas id="myChart"></canvas>
			</div>
		</div>
		<div class="wf-content-area box3">
			<p class="heading2 align-center">직급 분포도</p>
			<div class="chart-container" style="width: 400px; height:250px;">
				<canvas id="positionChart"></canvas>
			</div>
		</div>
		<div class="wf-content-area box3">
			<p class="heading2 align-center">재직자 통계</p>
			<div class="chart-container" style="height:250px; margin-top: 0px;">
				<canvas id="workerChart"></canvas>
			</div>
		</div>
		
	</div>
</div>