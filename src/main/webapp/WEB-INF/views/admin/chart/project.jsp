<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<link rel="stylesheet" href="/resources/css/statistics/adminProject.css" />

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="/resources/script/statistics/adminProject.js"></script>

<div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
	<h1 class="page-tit">프로젝트 통계</h1>
</div>
<div class="wf-flex-box" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">
	<div>
		<div class="wf-flex-box line2">
			<div class="wf-content-area line2 box" style="margin-top: 0px;">
				<p class="heading2 align-center">프로젝트 진행 기간(일)그래프</p>
				<div class="chart-container2">
					<canvas id="periodChart" width="300" height="250"></canvas>
				</div>
			</div>
			<div class="yearClassify1" style="height: 320px; overflow: auto; overflow-x:hidden;">
				<div class="wf-content-box yearClassify" style="margin-top: 10px; width:70px; background: #00a287; color:#fff;">
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
				<div class="wf-content-box yearClassify" style="margin-top: 10px; width:70px;">
					<p class="heading2 align-center">2015</p>
				</div>
				<div class="wf-content-box yearClassify" style="margin-top: 10px; width:70px;">
					<p class="heading2 align-center">2014</p>
				</div>
				<div class="wf-content-box yearClassify" style="margin-top: 10px; width:70px;">
					<p class="heading2 align-center">2013</p>
				</div>
				<div class="wf-content-box yearClassify" style="margin-top: 10px; width:70px;">
					<p class="heading2 align-center">2012</p>
				</div>
				<div class="wf-content-box yearClassify" style="margin-top: 10px; width:70px;">
					<p class="heading2 align-center">2011</p>
				</div>
				<div class="wf-content-box yearClassify" style="margin-top: 10px; width:70px;">
					<p class="heading2 align-center">2010</p>
				</div>
			</div>
			
			<div class="wf-content-area line2">
				<p class="heading2 align-center">생성된 프로젝트</p>
				<div class="chart-container2">
					<canvas id="monthNewProj" width="300" height="230"></canvas>
				</div>
			</div>
			
			<div class="wf-content-area line2">
				<p class="heading2 align-center">완료된 프로젝트</p>
				<div id="deptDetailChart-container">
					<canvas id="monthEndProj" width="300" height="230"></canvas>
				</div>
			</div>
		</div>
	
		<div class="wf-content-wrap wf-flex-box line1" style="margin-top: 15px;">
<!-- 				<div class="wf-content-area box2"> -->
<!-- 					<p class="heading1 align-center">프로젝트</p> -->
<!-- 					<p class="heading1 align-center">관리/통계</p> -->
<!-- 				</div> -->
			<div class="wf-content-box box1 moreInfo" style="margin-top: 0px; background: #00a287; color:#fff;" idx="1">
				<p class="heading1 align-center pjState">대기중인 프로젝트</p>
				<p class="heading1 align-center sttus1">&nbsp;</p>
			</div>
			<div class="wf-content-box box1 moreInfo" style="margin-top: 0px;" idx="2">
				<p class="heading1 align-center pjState">진행중인 프로젝트</p>
				<p class="heading1 align-center sttus2">&nbsp;</p>
				
			</div>
			<div class="wf-content-box box1 moreInfo" style="margin-top: 0px;" idx="4">
				<p class="heading1 align-center pjState">완료된 프로젝트</p>
				<p class="heading1 align-center sttus4">&nbsp;</p>
			</div>
			<div class="wf-content-box box1 moreInfo" style="margin-top: 0px;" idx="3">
				<p class="heading1 align-center pjState">중단된 프로젝트</p>
				<p class="heading1 align-center sttus3">&nbsp;</p>
			</div>
			<!-- <div class="wf-content-box box1" style="margin-top: 0px;">
				<p class="heading1 align-center">즉시 투입 가능사원</p>
				<p class="heading1 align-center enableEmp">&nbsp;</p>
			</div> -->
		</div>
	</div>
	
	<div class="wf-content-area listBox" style="width:400px; height: 430px; overflow: auto; overflow-x: hidden;">
		<div class="wf-flex-box" style="width: 360px;">
			<p class="heading2 listBoxP" style="width: 250px;">프로젝트 팀원</p>
			<div class="wf-flex-box" style="width: 110px;">
				<button type="button" class="btn1 prevBtn" disabled><i class="xi-angle-left"></i></button>
				<button type="button" class="btn1 nextBtn" disabled><i class="xi-angle-right"></i></button>
			</div>
		</div>
		<table class="wf-table" style="width: 360px; max-height: 420px;">
	        <thead class="theadList" style="float:left; width: 360px;">
	            <tr style="width: 360px;">
	                <th style="width: 120px;">부서</th>
	                <th style="width: 120px;">이름</th>
	                <th style="width: 120px;">역할</th>
	            </tr>
	        </thead>
	        <tbody class="pjEmpList" style="overflow-y: auto; overflow-x:hidden; max-height: 320px; float:left">
	        	<tr>
		        	<td style="text-align: center; width: 360px;">
	                    <p>프로젝트를 선택해주세요.</p>
	                </td>
	        	</tr>
	        </tbody>
	    </table>
	</div>
	
</div>

<div class="wf-content-area box3" style="width: 100%; overflow: hidden;" data-aos="fade-right" data-aos-duration="700" data-aos-delay="400">
	<p class="heading2 targetPjState">대기중인 프로젝트</p>
	<table class="wf-table" style="width: 1510px;">
        <thead style="float:left; width: 1510px;">
            <tr style="width: 1510px;">
                <th style="width: 305px;">프로젝트 번호</th>
                <th style="width: 305px;">이름</th>
                <th style="width: 305px;">진행 기간</th>
                <th style="width: 305px;">내용</th>
                <th style="width: 290px;">투입 인원</th>
            </tr>
        </thead>
        <tbody class="pjList" style="height: 140px; overflow-y: auto; overflow-x:hidden; float:left ">
            <tr>
                <td>
                    <p class="pjNo"></p>
                </td>
                <td>
                    <p class="pjNm"></p>
                </td>
                <td>
                    <p class="pjDate"></p>
                </td>
                <td>
                    <p class="pjContent"></p>
                </td>
                <td>
                    <p class="pjEmp"></p>
                </td>
            </tr>
        </tbody>
    </table>
</div>