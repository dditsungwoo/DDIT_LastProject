<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<style>

/* 틀어짐 수정 */
.content-wrap {height: 100%;}
.wf-mail-wrap {width: 100% !important;}
.wf-chat-left {min-height: auto;}


.wf-main-container{
	width: 100%;
}
.wf-mail-wrap{
	height: 100%;
	width: 95%;
}
.wf-content-area{
	height: 100%;
}
.wf-table {
/*     font-size: 0.7rem; /* 원하는 크기로 조정 */ */
	font-size: 13px;
    overflow-x: auto;
}

/* #jstree { */
/*     font-size: 0.7rem; /* 원하는 크기로 조정 */ */
/* } */

/* .jstree-anchor { */
/*     font-size: 0.7rem; /* 원하는 크기로 조정 */ */
/* } */

#EMP_TREE .jstree-anchor {font-size: 13px; font-weight: 600;}

</style>
<script>
let myStatisticsChart = "";
let weekDateDay = ["(일)","(월)","(화)","(수)","(목)","(금)","(토)"]
function getDate(date){	// date의 날짜 부분을 yyyyMMdd 식으로 추출
	let years = date.getFullYear();
	let months = date.getMonth() +1;
	let days = date.getDate(); 
	
	months = (months < 10) ? '0' + months : months;
	days = (days < 10) ? '0' + days : days;
	
	let sysDate = years + months +  days;
	
	return sysDate;
}

function drawDoughnutChart(chartDiv, chartLabels, chartData){
	
	const ctx = document.querySelector(chartDiv).getContext('2d');
	
	myStatisticsChart = new Chart(ctx, {
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

window.onload = function(){
	// 사원검색 input
	let inputEmpSearch = document.querySelector("#empSearch");
	// 자동완성 텍스트 들어갈 자리
	let empSearchRes = document.querySelector("#empSearchRes");
	// 자동완성으로 나타난 사원들
	let resEmp = document.querySelector(".resEmp");
	// 검색할 사원번호 (span,display:none 으로 숨겨져있음)
	let searchEmpNo = document.querySelector("#searchEmpNo");
	// 검색버튼
	//let searchBtn = document.querySelector(".searchBtn");
	
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
	// 근태기록이 들어갈 위치들
	let fullDate = document.querySelector(".fullDate")
	let attendTime = document.querySelector(".attendTime")
	let lvffcTime = document.querySelector(".lvffcTime")
	let totalTime = document.querySelector(".totalTime")
	let restUse = document.querySelector(".restUse")
	let attendList = document.querySelector("#attendList")
	
	
	let param = "";
	
	// 사원검색 자동완성기능
	inputEmpSearch.addEventListener("input",empSearch)
	
	// 검색 버튼 클릭시 기능
	let serachMonth = document.querySelector("#searchMonth")
	serachMonth.addEventListener("change",getAvgRes)
	//searchBtn.addEventListener("click",getAvgRes)
	
	// 자동완성 텍스트 클릭시 검색창에 넣기
	$(document).on("click",".resEmp",function(){
		$(".select2").css("display","block");
		let targetEmpNo = $(this).attr("idx")
		$("#searchEmpNo").html(targetEmpNo)
		$("#empSearch").val($(this).find(".resNm").text());
		let str = `<option class="searchMonth" value="00">--</option>`;
		let month = "";
		for(let i=1;i<=12;i++){
			
			if(i<10){
				month = "0" + i;
			}else{
				month = i + "";
			}
			
			str += `<option class="searchMonth" value="\${month}">\${month}</option>`
			
		}
		$("#searchMonth").html("");
		$("#searchMonth").append(str);
		
		let date = new Date();
		let ecnyDate = $(this).attr("ecnydate");
		let ecnyYear = ecnyDate.substr(0,4)
		let sysYear = date.getFullYear();
		
		str = ""
		for(let i=sysYear; i>=ecnyYear; i--){
			str += `<option class="searchYear" value="\${i}">\${i}</option>`
		}
		$("#searchYear").html("");
		$("#searchYear").append(str);
		
		empSearchRes.style.display = "none";
		getAvgRes()
	})
	
	
	
	
	function empSearch(event){
		param = event.target.value
		if(param == ""){
			empSearchRes.style.display = "none"
			return;
		}
		
		$.ajax({
			url:"/adminAttendance/getEmp",
			data:{"param":param},
			type:"get",
			success:function(res){
				if(res != ""){
					empSearchRes.style.display = "block";
					let str = "";
					res.forEach(function(value, index){
						str += "<div class='wf-flex-box resEmp' idx="+ value["empNo"] +" ecnydate=" + value["ecnyDate"] + "><p class='heading2 resNm'>" + value["empNm"] + "</p><p class='heading2'>" + value["deptNm"] + "</p></div>"
					});
					empSearchRes.innerHTML = str;
					if(res.length == 1){
						searchEmpNo.html = res["empNo"];
					}
				}else{
					empSearchRes.style.display = "none";
				}
			}
		})
	}
	
	function getAvgRes(){
		
		let targetEmpNo = $("#searchEmpNo").text();
		let year = $(".searchYear:selected").val();
		let month = $(".searchMonth:selected").val();
		
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
		
		if(targetEmpNo != ""){
			
			$.ajax({
				url:"/adminAttendance/getAvgRes",
				data:{
					"empNo":targetEmpNo,
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
					
					avgAttendLoc.innerHTML = res.avgAttend;
					avgLeaveLoc.innerHTML = res.avgLeave;
					avgWorkLoc.innerHTML = res.avgWork;
					restLoc.innerHTML = res.restCount;
					workLoc.innerHTML = res.workCount;
					lateLoc.innerHTML = res.lateCount;
					out1Loc.innerHTML = res.out1;
					out2Loc.innerHTML = res.out2;
					out3Loc.innerHTML = res.out3;
					
					let chartLabels = ["정상근무","지각","외출","조퇴","결근"]
					let chartData = [];
					chartData.push(res.workCount)
					chartData.push(res.lateCount)
					chartData.push(res.out1)
					chartData.push(res.out2)
					chartData.push(res.out3)
					
					if (myStatisticsChart && myStatisticsChart.data.labels) { 
						
						newLabels = chartLabels
						newData = chartData
						
						myStatisticsChart.data.labels = newLabels
				        // 기존 차트의 데이터를 업데이트
					    myStatisticsChart.data.datasets[0].data = newData; // 새로운 데이터로 업데이트
				        // 차트 업데이트
				        myStatisticsChart.update();
				        
				    }else{
				    	drawDoughnutChart("#statisticsChart", chartLabels, chartData)
				    }
					
				}
			})
			
			$.ajax({
				url:"/adminAttendance/getAttendList",
				data:{
					"empNo":targetEmpNo,
					"firstDay":startDateStr,
					"lastDay":endDateStr
				},
				type:"get",
				success:function(res){
					console.log("res:",res)
					// 근태기록이 들어갈 위치들
					let fullDate = document.querySelector(".fullDate")
					let attendTime = document.querySelector(".attendTime")
					let lvffcTime = document.querySelector(".lvffcTime")
					let totalTime = document.querySelector(".totalTime")
					let restUse = document.querySelector(".restUse")
					
					let str = ""
					console.log("res[0].fullDate:",res[0].fullDate)
					let firstDate = new Date(res[0].fullDate.substr(0,4),res[0].fullDate.substr(4,2)-1,res[0].fullDate.substr(6,2));
					let firstDateDay = firstDate.getDay();
					let dateDay = weekDateDay[firstDateDay]
					let color = ""
					res.forEach(function(value,index){
						
						let dateFormat = value.fullDate.substr(0,4) + "-" + value.fullDate.substr(4,2) + "-" + value.fullDate.substr(6,2);
						
						if(dateDay == "(토)"){
							color = "color:blue"
						}else if(dateDay == "(일)"){
							color = "color:red"
						}else{
							color = "";
						}
						
						str += "<div class='wf-flex-box'>";
						str += "<p class='heading2 fullDate' style='width:24%;" + color + "'>" + dateFormat + dateDay + "</p>";
						str += "<p class='heading2 attendTime' style='width:24%;'>" + value.formatAttend + "</p>";
						str += "<p class='heading2 lvffcTime' style='width:24%;'>" + value.formatLvffc + "</p>";
						str += "<p class='heading2 totalTime' style='width:24%;'>" + value.total + "</p>";
						str += "<p class='heading2 restUse' style='width:10%;'>" + "--" + "</p>";
						str += "</div>";
						
						firstDate.setDate(firstDate.getDate() + 1)
						firstDateDay = firstDate.getDay();
						dateDay = weekDateDay[firstDateDay]
						
					})
					attendList.innerHTML = str
					
				}
			})
		
		}
		
	}
	
	$("#jstree").jstree({
        'core': {
            'data': function(obj, cb) {
                var xhr = new XMLHttpRequest();
                xhr.open("get", "/emp/treeAjax", true);
                xhr.onreadystatechange = function() {
                    if (xhr.readyState == 4 && xhr.status == 200) {
                        var data = JSON.parse(xhr.responseText); // 데이터 파싱
                        var groupedData = groupData(data); // 데이터 그룹화
                        var transformedData = transformData(groupedData); // 데이터 변환
                        cb.call(obj, transformedData); // jstree에 데이터 전달
                    }
                };
                xhr.send();
            }, 
            "check_callback": true
        },
        "plugins": ["wholerow", "dnd"]
    });
	
	$(document).on("click",".jstree-anchor",function(){
		let text = $(this).text().trim();
		console.log(text)
		if(text != "대표이사" && text.substr(-2,2) != "본부" && text.substr(-1,1) != "팀"){
			$(".select2").css("display","block");
			let id = $(this).attr("id");
			let deptNo = id.split("_")[0];
			let empNm = id.split("_")[1];
			$.ajax({
				url:"/adminAttendance/getEmpNo",
				data:{
					"deptNo":deptNo,
					"empNm":empNm
				},
				type:"get",
				success:function(res){
					let targetEmpNo = res[0].empNo
					$("#searchEmpNo").html(targetEmpNo)
					$("#empSearch").val($(this).find(".resNm").text());
					let str = `<option class="searchMonth" value="00">--</option>`;
					let month = "";
					for(let i=1;i<=12;i++){
						
						if(i<10){
							month = "0" + i;
						}else{
							month = i + "";
						}
						
						str += `<option class="searchMonth" value="\${month}">\${month}</option>`
						
					}
					$("#searchMonth").html("");
					$("#searchMonth").append(str);
					
					let date = new Date();
					let ecnyDate = res[0].ecnyDate;
					let ecnyYear = ecnyDate.substr(0,4)
					let sysYear = date.getFullYear();
					
					str = ""
					for(let i=sysYear; i>=ecnyYear; i--){
						str += `<option class="searchYear" value="\${i}">\${i}</option>`
					}
					$("#searchYear").html("");
					$("#searchYear").append(str);
					$("#empSearch").val(text.split("_")[0])
					getAvgRes();
					empSearchRes.style.display = "none";
				}
			})
			
		}
		
	})
	
	
}


// 데이터 그룹화 함수
function groupData(data) {
    var groupedData = {};
    data.forEach(task => {
        if (!groupedData[task.deptNo]) {
            groupedData[task.deptNo] = [];
        }
        groupedData[task.deptNo].push(task);
    });
    return groupedData;
}

// 데이터 변환 함수
function transformData(groupedData) {
    var nodes = [];
    for (var deptNo in groupedData) {
        var deptInfo = groupedData[deptNo][0]; // 부서 정보는 배열의 첫 번째 요소에서 가져옴
        var deptNode = {
            id: deptInfo.deptNo,
            text: deptInfo.deptNm,
            parent: deptInfo.upperDept,
            icon: "https://jstree.com/tree-icon.png"
        };
        nodes.push(deptNode);

        groupedData[deptNo].forEach(employee => {
            var empNode = {
                id: employee.deptNo + "_" + employee.empNm, // 각 팀원의 ID는 부서번호와 이름을 조합하여 설정
                text: employee.empNm+ "_" + employee.position+ "_" + employee.rspnsblCtgryNm,
                parent: employee.deptNo,
                icon: ""
            };
            nodes.push(empNode);
        });
    }
    return nodes;
}

</script>


<div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
	<h1 class="page-tit">근태 통계</h1>
</div>
<div class="wf-flex-box" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">
	<div class="wf-content-area" style="width: 250px; height: 700px; overflow: auto;">
		<div id="jstree"></div>
	</div>
	<div style="width:1200px; height: 700px;">
		<div class="wf-flex-box">
			<div class="wf-search-area" style="height: 40px;">
				<div style="height: 40px; overflow: visible;">
			    	<input type="text" id="empSearch" placeholder="사원 검색"><span id="searchEmpNo" style="display: none"></span>
			    	<div class="wf-content-box" id="empSearchRes" style="display: none;"></div>
			    </div>
			    <!-- <button type="button" class="btn4 searchBtn">
			        <i class="xi-search"></i>
			    </button> -->
			    <div class="select-box select2" style="height: 30px; width: 100px; display: none;">
			        <select name="searchYear" id="searchYear" style="height: 30px; width: 100px;">
			            <option class="searchYear" value="2024">2024</option>
			            <option class="searchYear" value="2023">2023</option>
			            <option class="searchYear" value="2022">2022</option>
			        </select>
			    </div>
			    <div class="select2" style="height: 20px; display: none;">
					<p class="heading2">년</p>
			    </div>
			    <div class="select-box select2" style="height: 30px; width: 100px; display: none;">
			        <select name="searchMonth" id="searchMonth" style="height: 30px; width: 100px;">
			            <option class="searchMonth" value="00">--</option>
			            <option class="searchMonth" value="01">01</option>
			            <option class="searchMonth" value="02">02</option>
			            <option class="searchMonth" value="03">03</option>
			        </select>
			    </div>
				<div class="select2" style="height: 20px; display: none;">
					<p class="heading2">월</p>
			    </div>
			</div>
		</div>
		<div class="wf-content-area wf-flex-box" style="margin-top: 20px; height: 50px;">
			<div class="wf-flex-box" style="width: 20%;">
				<p class="heading2">평균출근시간:<span class="avgAttend"></span></p>
				<!-- <p class="heading2 avgAttend"></p> -->
			</div>
			<div class="wf-flex-box" style="width: 20%;">
				<p class="heading2">평균퇴근시간:<span class="avgLeave"></span></p>
				<!-- <p class="heading2 avgLeave"></p> -->
			</div>
			<div class="wf-flex-box" style="width: 20%;">
				<p class="heading2">평균근무시간:<span class="avgWork"></span></p>
				<!-- <p class="heading2 avgWork"></p> -->
			</div>
			<div class="wf-flex-box" style="width: 8%;">
				<p class="heading2">연차:<span class="rest"></span></p>
				<!-- <p class="heading2 rest"></p> -->
			</div>
			<div class="wf-flex-box" style="width: 10%;">
				<p class="heading2">정상근무:<span class="work"></span></p>
				<!-- <p class="heading2 work"></p> -->
			</div>
			<div class="wf-flex-box" style="width: 10%;">
				<p class="heading2">지각:<span class="late"></span></p>
				<!-- <p class="heading2 late"></p> -->
			</div>
			<div class="wf-flex-box" style="width: 10%;">
				<p class="heading2">외출:<span class="out1"></span></p>
				<!-- <p class="heading2 out1"></p> -->
			</div>
			<div class="wf-flex-box" style="width: 10%;">
				<p class="heading2">조퇴:<span class="out2"></span></p>
				<!-- <p class="heading2 out2"></p> -->
			</div>
			<div class="wf-flex-box" style="width: 10%;">
				<p class="heading2">결근:<span class="out3"></span></p>
				<!-- <p class="heading2 out3"></p> -->
			</div>
		</div>
		<div class="wf-flex-box" style="width: 100%; height: 60%; margin-top: 20px;">
			<div class="wf-content-area" style="width:60%; ">
				<div class="wf-flex-box">
					<p class="heading1" style="width:22%;">일자</p>
					<p class="heading1" style="width:22%;">출근 일시</p>
					<p class="heading1" style="width:22%;">퇴근 일시</p>
					<p class="heading1" style="width:22%;">총 근무시간</p>
					<p class="heading1" style="width:12%;">연차 사용</p>
				</div>
				<div id="attendList" style="overflow: auto; height: 95%;">
				</div>
			</div>
			<div class="wf-content-area" style="width:40%; ">
				<div style="width: 100%; height: 100%;">
					<canvas id="statisticsChart"></canvas>
				</div>
			</div>
		</div>
	</div>
</div>