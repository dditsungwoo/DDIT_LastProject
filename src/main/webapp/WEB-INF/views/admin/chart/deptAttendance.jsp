<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
let dept1 = "DEPT01"
let dept2 = "DEPT0101"
let baseWorkTime = 8;
let myChart_1 = "";
let myChart2_1 = "";
let myChart_2 = "";
let myChart2_2 = "";
let chartDiv1 = "";
let chartDiv2 = "";
let targetNo = "";
let targetDept = "";
let year = "";
let month = "";
let nextMonth = "";
let firstDay = "";
let lastDay = "";
let parent = "";

getDept1()
getDept2()
$(function(){
	
	// 통계 자료가 들어갈 위치들
	let avgAttendLoc = document.querySelector(".avgAttend")
	let avgLeaveLoc = document.querySelector(".avgLeave")
	let avgWorkLoc = document.querySelector(".avgWork")
	let restLoc = document.querySelector(".rest")
	let workLoc = document.querySelector(".work")
	let lateLoc = document.querySelector(".late")
	let out1Loc = document.querySelector(".out1")
	let out2Loc = document.querySelector(".out2")
	let out3Loc = document.querySelector(".out3")
	
	let avgAttendLoc2 = document.querySelectorAll(".avgAttend")[1]
	let avgLeaveLoc2 = document.querySelectorAll(".avgLeave")[1]
	let avgWorkLoc2 = document.querySelectorAll(".avgWork")[1]
	let restLoc2 = document.querySelectorAll(".rest")[1]
	let workLoc2 = document.querySelectorAll(".work")[1]
	let lateLoc2 = document.querySelectorAll(".late")[1]
	let out1Loc2 = document.querySelectorAll(".out1")[1]
	let out2Loc2 = document.querySelectorAll(".out2")[1]
	let out3Loc2 = document.querySelectorAll(".out3")[1]
	
	$(".selectDept1").on("change",function(){
		dept1 = $(this).find("option:selected").val()
		parent = $(this).parents(".mainContainer");
		getDept2()
	})
	
	$(".selectDept2").on("change",function(){
		dept2 = $(this).find("option:selected").val()
	})
	
	$(".searchBtn").on("click",function(){
		targetDept = $(this).parents(".mainContainer").find(".searchDept2:selected").val();
		year = $(this).parents(".mainContainer").find(".searchYear:selected").val();
		month = $(this).parents(".mainContainer").find(".searchMonth:selected").val()
		dept2 = $(this).parents(".mainContainer").find(".searchDept2:selected").val()
		
		
		if(parseInt(month) < 9 ){
			nextMonth = "0" + (parseInt(month)+1);
		}else{
			nextMonth = parseInt(month) + 1;
		}
		
		firstDay = year + month + "01";
		lastDay = year + nextMonth + "01";
		
		chartDiv1 = $(this).parents(".mainContainer").find(".statisticsChart1");
		chartDiv2 = $(this).parents(".mainContainer").find(".statisticsChart2");
		targetNo = $(this).attr("idx");
		getDeptEmpAttendance()
		getAvgRes()
	})
	
	function getAvgRes(){
		
		let date = new Date();
		let sysdate = new Date();
		
		let startDate = new Date(year, month-1, 1);
		let endDate = new Date();
		let startDateStr = "";
		let endDateStr = "";
		
		if(month != "00"){
			
			endDate = new Date(startDate.getFullYear(), startDate.getMonth() + 1, 0)
			startDateStr = getDate(startDate)
			endDateStr = getDate(endDate);
		}else{
			date.setFullYear(parseInt(year))
			date.setMonth(0)
			date.setDate(1)
			
			startDate = date
			endDate = new Date(startDate.getFullYear()+1, startDate.getMonth(), 1)
			if(endDate > sysdate){
				endDate = sysdate
			}
			startDateStr = getDate(startDate)
			endDateStr = getDate(endDate);
		}
		
		if(dept2 != ""){
			
			$.ajax({
				url:"/adminDeptAttendance/getAvgRes",
				data:{
					"deptNo":dept2,
					"firstDay":startDateStr,
					"lastDay":endDateStr,
				},
				type:"get",
				success:function(res){
					let attendHour = parseInt(res.avgAttend.split(":")[0])
					let attendMinute = parseInt(res.avgAttend.split(":")[1]);
					if(attendMinute == 60){
						attendHour += 1;
						attendMinute = 0;
					}
					if(attendMinute < 10){
						res.avgAttend = attendHour + ":0" + attendMinute
					}else{
						res.avgAttend = attendHour + ":" + attendMinute
					}
					
					let lvffcHour = parseInt(res.avgLeave.split(":")[0])
					let lvffcMinute = parseInt(res.avgLeave.split(":")[1]);
					if(lvffcMinute == 60){
						lvffcHour += 1;
						lvffcMinute = 0;
					}
					if(lvffcMinute < 10){
						res.avgLeave = lvffcHour + ":0" + lvffcMinute
					}else{
						res.avgLeave = lvffcHour + ":" + lvffcMinute
					}
					
					if(targetNo == "1"){
						avgAttendLoc.innerHTML = res.avgAttend;
						avgLeaveLoc.innerHTML = res.avgLeave;
						avgWorkLoc.innerHTML = res.avgWork;
						restLoc.innerHTML = res.restCount;
						workLoc.innerHTML = res.workCount;
						lateLoc.innerHTML = res.lateCount;
						out1Loc.innerHTML = res.out1;
						out2Loc.innerHTML = res.out2;
						out3Loc.innerHTML = res.out3;
					}else{
						avgAttendLoc2.innerHTML = res.avgAttend;
						avgLeaveLoc2.innerHTML = res.avgLeave;
						avgWorkLoc2.innerHTML = res.avgWork;
						restLoc2.innerHTML = res.restCount;
						workLoc2.innerHTML = res.workCount;
						lateLoc2.innerHTML = res.lateCount;
						out1Loc2.innerHTML = res.out1;
						out2Loc2.innerHTML = res.out2;
						out3Loc2.innerHTML = res.out3;
					}
					
					let chartLabels = ["정상근무","지각","외출","조퇴","결근"]
					let chartData = [];
					chartData.push(res.workCount)
					chartData.push(res.lateCount)
					chartData.push(res.out1)
					chartData.push(res.out2)
					chartData.push(res.out3)
					
					if(targetNo == "1"){
						if (myChart2_1 && myChart2_1.data.labels) { 
							
							newLabels = chartLabels
							newData = chartData
							
							myChart2_1.data.labels = newLabels
					        // 기존 차트의 데이터를 업데이트
						    myChart2_1.data.datasets[0].data = newData; // 새로운 데이터로 업데이트
					        // 차트 업데이트
					        myChart2_1.update();
					        
					    }else{
					    	drawWorkChart2_1(chartDiv2, chartLabels, chartData)
					    }
					}else{
						if (myChart2_2 && myChart2_2.data.labels) { 
							
							newLabels = chartLabels
							newData = chartData
							
							myChart2_2.data.labels = newLabels
					        // 기존 차트의 데이터를 업데이트
						    myChart2_2.data.datasets[0].data = newData; // 새로운 데이터로 업데이트
					        // 차트 업데이트
					        myChart2_2.update();
					        
					    }else{
					    	drawWorkChart2_2(chartDiv2, chartLabels, chartData)
					    }
					}
					
					
					
				}
			})
			
		
		}
		
	}
	
})

function getDate(date){	// date의 날짜 부분을 yyyyMMdd 식으로 추출
	let years = date.getFullYear();
	let months = date.getMonth() +1;
	let days = date.getDate(); 
	
	months = (months < 10) ? '0' + months : months;
	days = (days < 10) ? '0' + days : days;
	
	let sysDate = years + months +  days;
	
	return sysDate;
}

function getDept1(){
	$.ajax({
		url:"/adminDeptAttendance/getDept1",
		data:"",
		type:"get",
		success:function(res){
			let str = "";
			$.each(res,function(i,v){
				str += `<option class="searchDept1" value="\${v.deptNo}">\${v.deptNm}</option>`
			})
			
			$(".selectDept1").html(str)
			
		}
	})
}
function getDept2(){
	$.ajax({
		url:"/adminDeptAttendance/getDept2",
		data:{"deptNo":dept1},
		type:"get",
		success:function(res){
			let str = "";
			
			$.each(res,function(i,v){
				str += `<option class="searchDept2" value="\${v.deptNo}">\${v.deptNm}</option>`
			})
			
			if(parent == ""){
				$(".selectDept2").html(str);
			}else{
				parent.find(".selectDept2").html(str)
			}
			
		}
	})
}

function getDeptEmpAttendance(){
	
	$.ajax({
		url:"/adminDeptAttendance/getDeptEmpAttendance",
		data:{
			"deptNo":targetDept,
			"firstDay":firstDay,
			"lastDay":lastDay
		},
		type:"get",
		success:function(res){
			console.log(res)
			let chartLabels = [];
			let workTimes = [];
			let workTime = 0;
			let minusWorkTimes = [];
			let minusWorkTime = 0;
			let overWorkTimes = [];
			let overWorkTime = 0;
			
			$.each(res,function(i,v){
				// 0h 00m 을 숫자로 전환
				workTime = parseInt(v.total.split("h")[0]) + parseInt(v.total.split("m")[0].substr(-2,2).trim() / 60 * 100) / 100;
				if(workTime > baseWorkTime){
					overWorkTime = parseInt(v.over * 100) / 100;
					minusWorkTime = 0;
				}else{
					overWorkTime = 0;
					minusWorkTime = baseWorkTime - workTime;
				}
				
				workTimes.push(workTime);
				minusWorkTimes.push(minusWorkTime);
				overWorkTimes.push(overWorkTime);
				chartLabels.push(v.empNm);
			})
			
			if(targetNo == "1"){
				if (myChart_1 && myChart_1.data.datasets) { // weekDayGraph8가 존재하고 datasets도 존재하는 경우에만 실행
					newLabels = chartLabels
					newData = [workTimes,minusWorkTimes,overWorkTimes]
					
					myChart_1.data.labels = newLabels
			        // 기존 차트의 데이터를 업데이트
			        myChart_1.data.datasets.forEach((dataset, i) => {
			            dataset.data = newData[i]; // 새로운 데이터로 업데이트
			        });
			        // 차트 업데이트
			        myChart_1.update();
			    }else{
			    	drawWorkChart_1(chartDiv1,chartLabels, workTimes, minusWorkTimes, overWorkTimes)
			    }
			}else{
				if (myChart_2 && myChart_2.data.datasets) { // weekDayGraph8가 존재하고 datasets도 존재하는 경우에만 실행
					newLabels = chartLabels
					newData = [workTimes,minusWorkTimes,overWorkTimes]
					
					myChart_2.data.labels = newLabels
			        // 기존 차트의 데이터를 업데이트
			        myChart_2.data.datasets.forEach((dataset, i) => {
			            dataset.data = newData[i]; // 새로운 데이터로 업데이트
			        });
			        // 차트 업데이트
			        myChart_2.update();
			    }else{
			    	drawWorkChart_2(chartDiv1,chartLabels, workTimes, minusWorkTimes, overWorkTimes)
			    }
			}
			
			
		}
	})
}

function drawWorkChart_1(chartDiv,chartLabels, workTime, baseWorkTime, overWorkTime ){
	
	var data = {
	    labels: chartLabels,
	    datasets: [{
	        label: '평균근무시간',
	        backgroundColor: 'rgba(255, 99, 132, 0.5)',
	        data: workTime,
	        stack:'stack0'
	    }, {
	        label: '미달근무시간',
	        backgroundColor: 'rgba(54, 162, 235, 0.5)',
	        data: baseWorkTime,
	        stack:'stack0'
	    }, {
	        label: '초과근무시간',
	        backgroundColor: 'rgba(255, 206, 86, 0.5)',
	        data: overWorkTime,
	        stack:'stack1'
	    }]
	};
	// 차트 생성
	var ctx = chartDiv
	myChart_1 = new Chart(ctx, {
	    type: 'bar',
	    data: data,
	    options: {
	    	responsive: true, // 차트가 반응형으로 크기를 조절하도록 설정합니다.
            maintainAspectRatio: false, // 차트의 종횡비를 유지하지 않고 부모 요소에 맞추도록 설정합니다.
	        scales: {
	            x: {
	                stacked: true,
	                grid: {
	                    offset: true
	                }
	            },
	            y: {
	                stacked: true,
	                min: 0,
	                max: 10
	            }
	        },
			barThickness: 15
	    }
	});
	
}
function drawWorkChart_2(chartDiv,chartLabels, workTime, baseWorkTime, overWorkTime ){
	
	var data = {
	    labels: chartLabels,
	    datasets: [{
	        label: '평균근무시간',
	        backgroundColor: 'rgba(255, 99, 132, 0.5)',
	        data: workTime,
	        stack:'stack0'
	    }, {
	        label: '미달근무시간',
	        backgroundColor: 'rgba(54, 162, 235, 0.5)',
	        data: baseWorkTime,
	        stack:'stack0'
	    }, {
	        label: '초과근무시간',
	        backgroundColor: 'rgba(255, 206, 86, 0.5)',
	        data: overWorkTime,
	        stack:'stack1'
	    }]
	};
	// 차트 생성
	var ctx = chartDiv
	myChart_2 = new Chart(ctx, {
	    type: 'bar',
	    data: data,
	    options: {
	    	responsive: true, // 차트가 반응형으로 크기를 조절하도록 설정합니다.
            maintainAspectRatio: false, // 차트의 종횡비를 유지하지 않고 부모 요소에 맞추도록 설정합니다.
	        scales: {
	            x: {
	                stacked: true,
	                grid: {
	                    offset: true
	                }
	            },
	            y: {
	                stacked: true,
	                min: 0,
	                max: 10
	            }
	        },
			barThickness: 15
	    }
	});
	
}

function drawWorkChart2_1(chartDiv, chartLabels, chartData){
	
	var ctx = chartDiv
	
	myChart2_1 = new Chart(ctx, {
		type: 'doughnut',
		data:{
			labels:chartLabels,
			datasets: [{
				label: chartLabels,
				data: chartData,
				hoverOffset: 4
			}]
		},
		options: {
			maintainAspectRatio: false, // 캔버스 비율 유지 기능 해제
		    width: "100%", // 너비 지정
		    height: "100%", // 높이 지정
			plugins: {
			    tooltip: {
			        callbacks: {
			            label: function(context) {
			            	let label = context.label || '';

	                        if (label) {
	                            label += ': ';
	                        }
	                        if (context.dataset.data[context.dataIndex] !== null) {
	                            label += context.dataset.data[context.dataIndex];
	                        }
	                        return label;
			            }
			       }
			   }
			},
		}
	})	
}

function drawWorkChart2_2(chartDiv, chartLabels, chartData){
	
	var ctx = chartDiv
	
	myChart2_2 = new Chart(ctx, {
		type: 'doughnut',
		data:{
			labels:chartLabels,
			datasets: [{
				label: chartLabels,
				data: chartData,
				hoverOffset: 4
			}]
		},
		options: {
			maintainAspectRatio: false, // 캔버스 비율 유지 기능 해제
		    width: "100%", // 너비 지정
		    height: "100%", // 높이 지정
			plugins: {
			    tooltip: {
			        callbacks: {
			            label: function(context) {
			            	let label = context.label || '';

	                        if (label) {
	                            label += ': ';
	                        }
	                        if (context.dataset.data[context.dataIndex] !== null) {
	                            label += context.dataset.data[context.dataIndex];
	                        }
	                        return label;
			            }
			       }
			   }
			},
		}
	})	
}
</script>  
  
<div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
	<h1 class="page-tit">근태 통계</h1>
</div>

<div class="mainContainer" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">
	<div class="wf-flex-box">
		<div class="wf-search-area" style="height: 40px;">
			<div style="height: 20px;">
				<p class="heading2">DEPT1</p>
		    </div>
			<div class="select-box" style="height: 30px; width: 100px;">
		        <select name="searchDept1" class="selectDept1" style="height: 30px; width: 100px;">
		            <option class="searchDept1" value="2024">기획본부</option>
		        </select>
		    </div>
			<div style="height: 20px;">
				<p class="heading2">DEPT2</p>
		    </div>
		    <div class="select-box" style="height: 30px; width: 100px;">
		        <select name="searchDept2" class="selectDept2" style="height: 30px; width: 100px;">
		            <option class="searchDept2" value="2024">기획1팀</option>
		        </select>
		    </div>
		    <div class="select-box" style="height: 30px; width: 100px;">
		        <select name="searchYear" class="selectYear" style="height: 30px; width: 100px;">
		            <option class="searchYear" value="2024">2024</option>
		            <option class="searchYear" value="2023">2023</option>
		            <option class="searchYear" value="2022">2022</option>
		        </select>
		    </div>
		    <div style="height: 20px;">
				<p class="heading2">년</p>
		    </div>
		    <div class="select-box" style="height: 30px; width: 100px;">
		        <select name="searchMonth" class="selectMonth" style="height: 30px; width: 100px;">
		            <option class="searchMonth" value="00">--</option>
		            <option class="searchMonth" value="01">01</option>
		            <option class="searchMonth" value="02">02</option>
		            <option class="searchMonth" value="03">03</option>
		            <option class="searchMonth" value="04">04</option>
		            <option class="searchMonth" value="05">05</option>
		            <option class="searchMonth" value="06">06</option>
		            <option class="searchMonth" value="07">07</option>
		            <option class="searchMonth" value="08">08</option>
		            <option class="searchMonth" value="09">09</option>
		            <option class="searchMonth" value="10">10</option>
		            <option class="searchMonth" value="11">11</option>
		            <option class="searchMonth" value="12">12</option>
		        </select>
		    </div>
			<div style="height: 20px;">
				<p class="heading2">월</p>
		    </div>
		    <button type="button" class="btn4 searchBtn" idx="1">
		        <i class="xi-search"></i>
		    </button>
		</div>
	</div>
	<div class="wf-content-area wf-flex-box" style="margin-top: 20px; height: 55px;">
		<div class="wf-flex-box" style="width: 15%;">
			<p class="heading1">평균출근시간:</p>
			<p class="heading1 avgAttend"></p>
		</div>
		<div class="wf-flex-box" style="width: 15%;">
			<p class="heading1">평균 퇴근시간:</p>
			<p class="heading1 avgLeave"></p>
		</div>
		<div class="wf-flex-box" style="width: 15%;">
			<p class="heading1">평균 근무시간:</p>
			<p class="heading1 avgWork"></p>
		</div>
		<div class="wf-flex-box" style="width: 8%;">
			<p class="heading1">연차:</p>
			<p class="heading1 rest"></p>
		</div>
		<div class="wf-flex-box" style="width: 12%;">
			<p class="heading1">정상근무:</p>
			<p class="heading1 work"></p>
		</div>
		<div class="wf-flex-box" style="width: 10%;">
			<p class="heading1">지각:</p>
			<p class="heading1 late"></p>
		</div>
		<div class="wf-flex-box" style="width: 10%;">
			<p class="heading1">외출:</p>
			<p class="heading1 out1"></p>
		</div>
		<div class="wf-flex-box" style="width: 10%;">
			<p class="heading1">조퇴:</p>
			<p class="heading1 out2"></p>
		</div>
		<div class="wf-flex-box" style="width: 10%;">
			<p class="heading1">결근:</p>
			<p class="heading1 out3"></p>
		</div>
	</div>
	<div class="wf-flex-box" style="width: 100%; height: 60%; margin-top: 20px;">
		<div class="wf-content-area" style="width:60%; height: 200px; ">
			<div style="width: 100%; height: 100%;">
				<canvas class="statisticsChart1" style="width:100%; height:200px;"></canvas>
			</div>
		</div>
		<div class="wf-content-area" style="width:40%; height: 200px;">
			<div style="width: 100%; height: 100%;">
				<canvas class="statisticsChart2"></canvas>
			</div>
		</div>
	</div>
</div>

<div class="mainContainer" data-aos="fade-right" data-aos-duration="700" data-aos-delay="400">
	<div class="wf-flex-box">
		<div class="wf-search-area" style="height: 40px;">
			<div style="height: 20px;">
				<p class="heading2">DEPT1</p>
		    </div>
			<div class="select-box" style="height: 30px; width: 100px;">
		        <select name="searchDept1" class="selectDept1" style="height: 30px; width: 100px;">
		            <option class="searchDept1" value="2024">기획본부</option>
		        </select>
		    </div>
			<div style="height: 20px;">
				<p class="heading2">DEPT2</p>
		    </div>
		    <div class="select-box" style="height: 30px; width: 100px;">
		        <select name="searchDept2" class="selectDept2" style="height: 30px; width: 100px;">
		            <option class="searchDept2" value="2024">기획1팀</option>
		        </select>
		    </div>
		    <div class="select-box" style="height: 30px; width: 100px;">
		        <select name="searchYear" class="selectYear" style="height: 30px; width: 100px;">
		            <option class="searchYear" value="2024">2024</option>
		            <option class="searchYear" value="2023">2023</option>
		            <option class="searchYear" value="2022">2022</option>
		        </select>
		    </div>
		    <div style="height: 20px;">
				<p class="heading2">년</p>
		    </div>
		    <div class="select-box" style="height: 30px; width: 100px;">
		        <select name="searchMonth" class="selectMonth" style="height: 30px; width: 100px;">
		            <option class="searchMonth" value="00">--</option>
		            <option class="searchMonth" value="01">01</option>
		            <option class="searchMonth" value="02">02</option>
		            <option class="searchMonth" value="03">03</option>
		            <option class="searchMonth" value="04">04</option>
		            <option class="searchMonth" value="05">05</option>
		            <option class="searchMonth" value="06">06</option>
		            <option class="searchMonth" value="07">07</option>
		            <option class="searchMonth" value="08">08</option>
		            <option class="searchMonth" value="09">09</option>
		            <option class="searchMonth" value="10">10</option>
		            <option class="searchMonth" value="11">11</option>
		            <option class="searchMonth" value="12">12</option>
		        </select>
		    </div>
			<div style="height: 20px;">
				<p class="heading2">월</p>
		    </div>
		    <button type="button" class="btn4 searchBtn" idx="2">
		        <i class="xi-search"></i>
		    </button>
		</div>
	</div>
	
	<div class="wf-content-area wf-flex-box" style="margin-top: 20px; height: 55px;">
		<div class="wf-flex-box" style="width: 15%;">
			<p class="heading1">평균출근시간:</p>
			<p class="heading1 avgAttend"></p>
		</div>
		<div class="wf-flex-box" style="width: 15%;">
			<p class="heading1">평균 퇴근시간:</p>
			<p class="heading1 avgLeave"></p>
		</div>
		<div class="wf-flex-box" style="width: 15%;">
			<p class="heading1">평균 근무시간:</p>
			<p class="heading1 avgWork"></p>
		</div>
		<div class="wf-flex-box" style="width: 8%;">
			<p class="heading1">연차:</p>
			<p class="heading1 rest"></p>
		</div>
		<div class="wf-flex-box" style="width: 12%;">
			<p class="heading1">정상근무:</p>
			<p class="heading1 work"></p>
		</div>
		<div class="wf-flex-box" style="width: 10%;">
			<p class="heading1">지각:</p>
			<p class="heading1 late"></p>
		</div>
		<div class="wf-flex-box" style="width: 10%;">
			<p class="heading1">외출:</p>
			<p class="heading1 out1"></p>
		</div>
		<div class="wf-flex-box" style="width: 10%;">
			<p class="heading1">조퇴:</p>
			<p class="heading1 out2"></p>
		</div>
		<div class="wf-flex-box" style="width: 10%;">
			<p class="heading1">결근:</p>
			<p class="heading1 out3"></p>
		</div>
	</div>
	<div class="wf-flex-box" style="width: 100%; height: 60%; margin-top: 20px;">
		<div class="wf-content-area" style="width:60%; height: 200px; ">
			<div style="width: 100%; height: 100%;">
				<canvas class="statisticsChart1" style="width:100%; height:200px;"></canvas>
			</div>
		</div>
		<div class="wf-content-area" style="width:40%; height: 200px;">
			<div style="width: 100%; height: 100%;">
				<canvas class="statisticsChart2"></canvas>
			</div>
		</div>
	</div>
</div> 