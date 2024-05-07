let myWeekChart = "";
let myMonthChart = "";
let chartIdWM = "weekDayGraph";
let chartLabels = [];
let vcatnSeCd = "";
function drawWeekWorkChart(chartId,chartLabels, workTime, baseWorkTime, overWorkTime ){
	
	var data = {
	    labels: chartLabels,
	    datasets: [{
	        label: '근무시간',
	        backgroundColor: 'rgba(255, 99, 132, 0.5)',
	        data: workTime
	    }, {
	        label: '기본근무시간',
	        backgroundColor: 'rgba(54, 162, 235, 0.5)',
	        data: baseWorkTime
	    }, {
	        label: '초과근무시간',
	        backgroundColor: 'rgba(255, 206, 86, 0.5)',
	        data: overWorkTime
	    }]
	};
	// 차트 생성
	var ctx = document.getElementById(chartId).getContext('2d');
	myWeekChart = new Chart(ctx, {
	    type: 'bar',
	    data: data,
	    options: {
	        scales: {
	            x: {
	                stacked: true
	            },
	            y: {
	                stacked: true,
	                min: 0,
	                max: 12
	            }
	        },
			barThickness: 20,
	    }
	});
	
}

function drawMonthWorkChart(chartId,chartLabels, workTime, baseWorkTime, overWorkTime ){
	
	var data = {
	    labels: chartLabels,
	    datasets: [{
	        label: '근무시간',
	        backgroundColor: 'rgba(255, 99, 132, 0.5)',
	        data: workTime
	    }, {
	        label: '기본근무시간',
	        backgroundColor: 'rgba(54, 162, 235, 0.5)',
	        data: baseWorkTime
	    }, {
	        label: '초과근무시간',
	        backgroundColor: 'rgba(255, 206, 86, 0.5)',
	        data: overWorkTime
	    }]
	};
	// 차트 생성
	var ctx = document.getElementById(chartId).getContext('2d');
	myMonthChart = new Chart(ctx, {
	    type: 'bar',
	    data: data,
	    options: {
	        scales: {
	            x: {
	                stacked: true
	            },
	            y: {
	                stacked: true
	            }
	        },
			barThickness: 20
	    }
	});
	
}

function drawMonthChart(){
    
    let chartWorkTime = []
    let chartBaseTime = []
    let chartOverTime = []
    let vcatnSeCdList = []
    $.ajax({
    	url:"/attendance/getVcatnSeCd",
		type:"get",
		data:{
			"firstDay":firstMonthDay.replaceAll(".",""),
			"lastDay": lastMonthDay.replaceAll(".",""),
			"empNo": sessionEmpNo
		},
		async:false,
		success:function(res){
			vcatnSeCdList.push(res)
		}
    })
    
	$.ajax({
		url:"/attendance/chart03",
		type:"get",
		data:{
			"firstDay":firstMonthDay.replaceAll(".",""),
			"lastDay": lastMonthDay.replaceAll(".",""),
			"empNo": sessionEmpNo
		},
		async:false,
		success:function(res){
			for(let i=1;i<res.length+1;i++){
				
				let weekWorkTime = 0;
				let weekOverTime = 0;
				let weekBaseTime = 0;
				
				if(res[i-1] == null){
					weekWorkTime = 0;
				}else{
					weekWorkTime = parseInt(res[i-1].split("h")[0]) + parseInt(res[i-1].split("m")[0].substr(-2,2)/60*100)/100;
				}
				if(vcatnSeCdList[i-1] == "2" || vcatnSeCdList[i-1] == "3"){
					weekWorkTime += 4
				}
				if(weekWorkTime > 8){
					weekOverTime = weekWorkTime - 8
					weekWorkTime = 8;
					weekBaseTime = 0;
					
					chartWorkTime.push(weekWorkTime)
					chartBaseTime.push(weekBaseTime)
					chartOverTime.push(weekOverTime)
					
				}else{
					weekOverTime = 0
					weekWorkTime = weekWorkTime;
					weekBaseTime = 8-weekWorkTime;
					
					chartWorkTime.push(weekWorkTime)
					chartBaseTime.push(weekBaseTime)
					chartOverTime.push(weekOverTime)
				
				}
				
				// 차트가 없으면 새로 생성, 차트가 있으면 업데이트
				if (myMonthChart && myMonthChart.data.datasets) { 
					newData = [chartWorkTime,chartBaseTime,chartOverTime]
					newLabels = chartLabels
					
					myMonthChart.data.labels = newLabels
			        // 기존 차트의 데이터를 업데이트
			        myMonthChart.data.datasets.forEach((dataset, i) => {
			            dataset.data = newData[i]; // 새로운 데이터로 업데이트
			        });
			        // 차트 업데이트
			        myMonthChart.update();
			    }else{
					drawMonthWorkChart(chartIdWM ,chartLabels,chartWorkTime,chartBaseTime,chartOverTime)
			    }
				
				
			}
		}
	})
}

function drawChart(){


	chartLabel1 = $(".weekDay2").text();
		
	firstChartDay = chartLabel1.substr(0,4) + chartLabel1.substr(5,2) + chartLabel1.substr(8,2);
	lastChartDay = chartLabel1.substr(16,4) + chartLabel1.substr(21,2) + chartLabel1.substr(24,2)
	
	let param = {
		"firstDay":firstChartDay,
		"lastDay": lastChartDay,
		"empNo": sessionEmpNo
	}
	
	$.ajax({
		url:"/attendance/getTodayRestUse",
		type:"get",
		data:param,
		dataType:"text",
		async:false,
		success:function(res){
			vcatnSeCd = res;
			if(res == "2"){
				$(".restUse").html("오늘은 오전반차 사용일입니다.")
			}
			if(res == "3"){
				$(".restUse").html("오늘은 오후반차 사용일입니다.")
			}
		}
	})
	let workTime = "";
	$.ajax({
		url:"/attendance/chart02",
		type:"get",
		data:param,
		async:false,
		success:function(res){
			workTime = res + ""
		}
	})
	let workTimeInt = 0;
	workTimeInt = (parseInt(workTime*100))/100;
	
	if($(".restUse").text() != ""){
		workTimeInt += 4;
	}
	let todayWorkTimeStr = "";
	todayWorkTimeStr = workTimeInt.toFixed(2) + "";
	
	todayWorkTimeStr = todayWorkTimeStr.split(".")[0] + "h " + parseInt(todayWorkTimeStr.split(".")[1] * 6 / 10) + "m";
	if(workTimeInt < 0){
		workTimeInt = 0;
		todayWorkTimeStr = "0h 0m"
	}
		
	if(workTimeInt == 0){
		todayWorkTimeStr = "0h 0m";
	}
	
	console.log("todayWorkTimeStr:",todayWorkTimeStr)
    console.log("todayWorkTimeStr:",todayWorkTimeStr.split(".")[0])
	
	todayOverTime = 0;
	todayMinusTime = 0;
	
	if(workTimeInt <= 8){
		todayMinusTime = 8 - workTimeInt;
	}else{
		todayOverTime = 0;
	}
	if(workTimeInt <= 8){
		todayOverTime = 0;
	}else{
		todayOverTime = workTimeInt - 8.0
		workTimeInt = 8;
	}
	
	let jsonData = {
	    "cols": [
	        {"id":"","label":"근무시간","pattern":"","type":"string"},
	        {"id":"","label":"시간","pattern":"","type":"number"},
	        {"id":"","label":"비율","pattern":"","type":"number"}
	    ],
	    "rows": [
	        {"c":[{"v":"초과근무시간"},{"v":todayOverTime},{"v":parseInt(todayOverTime/8 * 10000)/100}]}, // 10%
	        {"c":[{"v":"현재근무시간"},{"v":workTimeInt},{"v":parseInt(workTimeInt/8 * 10000)/100}]}, // 20%
	        {"c":[{"v":"잔여근무시간"},{"v":todayMinusTime},{"v":parseInt(todayMinusTime/8 * 10000)/100}]} // 30%
	    ]
	};
	
	//구글 차트용 데이터 테이블 생성
	let data1 = new google.visualization.DataTable(jsonData);
	
	//어떤 차트 모양으로 출력할지를 정해주자 => LineChart
	//LineChart , ColumnChart, PieChart
	let chart = new google.visualization.PieChart(
		document.getElementById("chart_div")
	);
	
	// data 데이터를 chart 모양으로 출력해보자
	chart.draw(data1,
		{
			pieHole: 0.5,
			colors: ['#FF9900', '#3366CC', '#DC3912'],
			width:400,
			height:350,
			backgroundColor: 'transparent',
			chartArea: {
            left: '8%', // 좌측 간격 조정
            top: '0%', // 상단 간격 조정
            width: '37%', // 차트 영역의 너비 조정
            height: '37%' // 차트 영역의 높이 조정
        	},
        	pieSliceText: "none",
        	legend: { position: "none" } // 레전드를 표시하지 않음
		}		
	);
	
	var textContainer = document.createElement('div');
    textContainer.innerHTML = '<div style="position: absolute; top: 58%; left: 50%; transform: translate(-50%, -50%); font-size: 17px;">'+todayWorkTimeStr+'</div>';
    document.getElementById('chart_div').appendChild(textContainer);
	
	let weekFirstDay = "";
	weekFirstDay = $(".weekDay2Span").text().substr(5,8)
	$(".graphSpan1").html(weekFirstDay)
	
	let weekFirstDayInt = 0;
	let weekLastDayInt = 0;
	weekFirstDayInt = parseInt(weekFirstDay.substr(3,2))
	weekLastDayInt = parseInt($(".weekDay2Span").text().substr(24,2))
	
	let weekMonth = "";
	let weekDay = "";
	weekMonth = $(".weekDay2Span").text().substr(5,3)
	
	chartLabels = []
	weekDateDay = ["(월)","(화)","(수)","(목)","(금)","(토)","(일)"]
	
	for(let i=1;i<8;i++){
		
		if(weekFirstDayInt <10){
			weekDay = "0" + weekFirstDayInt;
		}else{
			weekDay = "" + weekFirstDayInt;
		}
		
		$(".graphSpan"+i).html(weekMonth + weekDay)
		
		chartLabels.push(weekMonth + weekDay + weekDateDay[i-1])
		
		weekFirstDayInt += 1;
		if(weekLastDayInt - 7 + i == 0){
			weekMonth = $(".weekDay2Span").text().substr(21,3)
			weekFirstDayInt = 1;
		}
		$(".weekDayGraph"+i).css("background-color","lightblue")
	}
	
	let chartWorkTime = [];
	let chartOverTime = [];
	let chartBaseTime = []; 
	
	$.ajax({
		url:"/attendance/chart03",
		type:"get",
		data:param,
		async:false,
		success:function(res){
			
			for(let i=1;i<8;i++){
				let weekWorkTime = 0;
				let weekOverTime = 0;
				let weekBaseTime = 0;
				if(res[i-1] == null){
					weekWorkTime = 0;
					res[i-1] = "0h 0m";
				}else{
					weekWorkTime = parseInt(res[i-1].split("h")[0]) + parseInt(res[i-1].split("m")[0].substr(-2,2)/60*100)/100;
				}
				
				chartLabels[i-1] = chartLabels[i-1] + "\n" + res[i-1]
				
				if(weekWorkTime > 8){
					weekOverTime = weekWorkTime - 8
					weekWorkTime = 8;
					weekBaseTime = 0;
					
					chartWorkTime.push(weekWorkTime)
					chartBaseTime.push(weekBaseTime)
					chartOverTime.push(weekOverTime)
					
				}else{
					weekOverTime = 0
					weekWorkTime = weekWorkTime;
					weekBaseTime = 8-weekWorkTime;
					
					chartWorkTime.push(weekWorkTime)
					chartBaseTime.push(weekBaseTime)
					chartOverTime.push(weekOverTime)
				
				}
				
			}
		}
	})
	if(chartIdWM == "weekDayGraph"){
		if (myWeekChart && myWeekChart.data.datasets) { // weekDayGraph8가 존재하고 datasets도 존재하는 경우에만 실행
			newData = [chartWorkTime,chartBaseTime,chartOverTime]
			newLabels = chartLabels
			
			myWeekChart.data.labels = newLabels
	        // 기존 차트의 데이터를 업데이트
	        myWeekChart.data.datasets.forEach((dataset, i) => {
	            dataset.data = newData[i]; // 새로운 데이터로 업데이트
	        });
	        // 차트 업데이트
	        myWeekChart.update();
	    }else{
			drawWeekWorkChart(chartIdWM ,chartLabels,chartWorkTime,chartBaseTime,chartOverTime)
	    }
	}
	if(chartIdWM == "monthDayGraph"){
		if (myMonthChart && myMonthChart.data.datasets) { // weekDayGraph8가 존재하고 datasets도 존재하는 경우에만 실행
			newData = [chartWorkTime,chartBaseTime,chartOverTime]
			newLabels = chartLabels
			
			myMonthChart.data.labels = newLabels
	        // 기존 차트의 데이터를 업데이트
	        myMonthChart.data.datasets.forEach((dataset, i) => {
	            dataset.data = newData[i]; // 새로운 데이터로 업데이트
	        });
	        // 차트 업데이트
	        myMonthChart.update();
	    }else{
			drawMonthWorkChart(chartIdWM ,chartLabels,chartWorkTime,chartBaseTime,chartOverTime)
	    
	    }
	}
	
	
}


function getAvgTime(){
	let dateRange = $(".weekDay2").text();
	startDay = dateRange.substr(0,4) + dateRange.substr(5,2) + dateRange.substr(8,2);
	endDay = dateRange.substr(16,4) + dateRange.substr(21,2) + dateRange.substr(24,2)
	if(dateRange.length < 28){
		endDay = dateRange.substr(13,4) + dateRange.substr(18,2) + dateRange.substr(21,2)
	}
	
	let param = {
		"firstDay":startDay,
		"lastDay": endDay,
		"empNo": sessionEmpNo
	}
	// 평균 출근시간
	$.ajax({
		url:"/attendance/getAvgAttend",
		type:"get",
		data:param,
		dataType:'text',
		success:function(res){
			let resHour = parseInt(res.split(":")[0])
			let resMinute = parseInt(res.split(":")[1]);
			console.log("resHour:",resHour)
			console.log("resMinute:",resMinute)
			if(resMinute == 60){
				resHour += 1;
				resMinute = 0;
			}
			if(resMinute < 10){
				res = resHour + ":0" + resMinute
			}else{
				res = resHour + ":" + resMinute
			}
		
			$(".avgAttend").html(" " +res);
			let resInt = 0;
			resInt = parseInt(res.split(":")[0] * 60) + parseInt(res.split(":")[1])
			if(resInt <= 540 && resInt >= 480){
				$(".badge-avgAttend").html("<span class='wf-badge2'>Good</span>")
			}else if(resInt >= 570 && resInt <= 600){
				$(".badge-avgAttend").html("<span class='wf-badge4'>warn</span>")
			}else if(resInt >= 600){
				$(".badge-avgAttend").html("<span class='wf-badge5'>danger</span>")
			}else{
				$(".badge-avgAttend").html("&nbsp;")
			}
		}
	})
	// 평균 퇴근시간
	$.ajax({
		url:"/attendance/getAvgLeave",
		type:"get",
		data:param,
		dataType:'text',
		success:function(res){
			let resHour = parseInt(res.split(":")[0])
			let resMinute = parseInt(res.split(":")[1]);
			console.log("resHour:",resHour)
			console.log("resMinute:",resMinute)
			if(resMinute == 60){
				resHour += 1;
				resMinute = 0;
			}
			if(resMinute < 10){
				res = resHour + ":0" + resMinute
			}else{
				res = resHour + ":" + resMinute
			}
			$(".avgLeave").html(" " +res)
		}
	})
	
	// 평균 근무시간
	$.ajax({
		url:"/attendance/getAvgWork",
		type:"get",
		data:param,
		dataType:'text',
		success:function(res){
			
			$(".avgWork").html(" " +res)
			let resInt = 0;
			resInt = parseInt(res.split("h")[0] * 60) + parseInt(res.split("m")[0].substr(-2,2));
			if(resInt >= 480 && resInt <= 510){
				$(".badge-avgWork").html("<span class='wf-badge2'>Good</span>")
			}else if(resInt >= 600){
				$(".badge-avgWork").html("<span class='wf-badge2'>휴식을 취해주세요</span>")
			}else{
				$(".badge-avgWork").html("&nbsp;")
			}
		}
	})
	// 지각횟수
	$.ajax({
		url:"/attendance/getLateCount",
		type:"get",
		data:param,
		dataType:'text',
		success:function(res){
			$(".late").html(" " +res)
			if(res == 0){
		    	$(".badge-late").html("<span class='wf-badge2'>Good</span>")
			}else if(res >= 2){
				$(".badge-late").html("<span class='wf-badge2'>warn</span>")
			}else{
				$(".badge-late").html("&nbsp;")
			}
		}
	})
	// 연차횟수
	$.ajax({
		url:"/attendance/getRestCount",
		type:"get",
		data:param,
		dataType:'text',
		success:function(res){
			if(res != ""){
				$(".rest").html(" " +res)
			}else{
				$(".rest").html("0")
			}
		}
	})
	
	$.ajax({
		url:"/attendance/getOut1Count",
		type:"get",
		data:param,
		dataType:'text',
		success:function(res){
			$(".out1").html(" " +res)
		}
	})
	
	$.ajax({
		url:"/attendance/getOut2Count",
		type:"get",
		data:param,
		dataType:'text',
		success:function(res){
			$(".out2").html(" " +res)
		}
	})
	
	$.ajax({
		url:"/attendance/getOut3Count",
		type:"get",
		data:param,
		dataType:'text',
		success:function(res){
			$(".out3").html(" " +res)
			if(res == 0){
		    	$(".badge-out").html("<span class='wf-badge2'>Good</span>")
			}else if(res >= 1){
				$(".badge-out").html("<span class='wf-badge2'>danger</span>")
			}else{
				$(".badge-out").html("&nbsp;")
			}
		}
	})
        
	
	
}



function getWeekWorkData(){	// 누적 근무시간, 잔여 근무시간, 초과 근무시간을 페이지에 띄우기 위한 ajax

	let param = {
		"firstDay":startDay,
		"lastDay": endDay,
		"empNo": sessionEmpNo
	}
	
	
	$.ajax({
		url:"/attendance/getPlusTime",
		type:"get",
		data:param,
		dataType:'text',
		success:function(res){
			plusTimetoMinute = parseInt(res.split("h")[0])*60 + parseInt(res.split("h")[1].trim())
			$(".plusTime").append(res)
			
			let minusHours = 0;
			let minusMinutes = 0;
			let minusTime = "";
			
			let overHours = 0;
			let overMinutes = 0;
			let overTime = "";
			
			let plusTimeHours = parseInt(res.split("h")[0]);
			let plusTimeMinutes = 0;
			plusTimeMinutes = parseInt(res.split("m")[0].substr(-2,2).trim());
			
			if(plusTimetoMinute <= 2400){
				minusHours = 40 - plusTimeHours - 1;
				minusMinutes = 60 - plusTimeMinutes;
				if(minusMinutes == 60){
					minusHours = minusHours + 1;
					minusMinutes = 0;
				}
				minusTime = minusHours + "h " + minusMinutes + "m";
				$(".minusTime").append(minusTime);
				$(".overTime").append("0h 0m");
			}else{
				overHours = plusTimeHours - 40;
				overMinutes = plusTimeMinutes;
				overTime = overHours + "h " + overMinutes + "m";
				$(".minusTime").append("0h 0m");
				$(".overTime").append(overTime);
			}
			
			barPlusTime = parseInt(plusTimetoMinute/60*100)/100 *2;
			barMinusTime = minusHours + ((minusMinutes * 60 / 100) / 100) * 2;
			barOverTime = ((plusTimetoMinute - 2400)/60*100)/100 *2;
			if(barPlusTime/2 <= 40){
				$(".todayWeekBar").css("background-image","linear-gradient(to right, rgba(255, 99, 132, 0.7) 0%, rgba(255, 99, 132, 0.7) " + barPlusTime + "%, rgba(255, 255, 255, 0.7) "+barPlusTime+"%,  rgba(255, 255, 255, 0.7) "+100+"%)").css("width","100%")
			}else{
				console.log("40보다 큼")
				barPlusTime = 80;
				$(".todayWeekBar").css("background","linear-gradient(to right, rgba(255, 99, 132, 0.7) 0%, rgba(255, 99, 132, 0.7) " + barPlusTime + "%, rgba(54, 162, 235, 0.7) "+barPlusTime+"%, rgba(54, 162, 235, 0.7) "+(barPlusTime+barOverTime)+"%, rgba(255, 255, 255, 0.7) "+(barPlusTime+barOverTime)+"%,  rgba(255, 255, 255, 0.7) "+100+"%)").css("width","100%")
			}
			
		}
	
	})
}	

function getAttendanceTime(){
	
	$.ajax({
		url:"/attendance/getAttendTime",
		type:"get",
		data:{"empNo":sessionEmpNo},
		dataType:'text',
		success:function(res){
			if (res != "") {
                let attendTime = "";
                attendTime = res.substr(11, 8);
                $(".attendTime").html(attendTime);
                $("#attendBtn").prop("disabled", true)
            }else{
                $(".attendTime").html("-- : -- : --");
            }
		}
	})
	
	$.ajax({
		url:"/attendance/getLvffcTime",
		type:"get",
		data:{"empNo":sessionEmpNo},
		dataType:'text',
		success:function(res){
			if(res != ""){
				let lvffcTime = "";
				lvffcTime = res.substr(11,8);
				$(".lvffcTime").html(lvffcTime)
			}else{
				$(".lvffcTime").html("-- : -- : --")
			}
		}
	})

}

function getTime(date){	// sysdate의 시간 부분을 hh:mm:ss 식으로 추출
	let hours = date.getHours();
	let minutes = date.getMinutes();
	let seconds = date.getSeconds();

	// 한 자리 숫자일 경우 앞에 0을 붙여 두 자리로 만듭니다.
	hours = (hours < 10) ? '0' + hours : hours;
	minutes = (minutes < 10) ? '0' + minutes : minutes;
	seconds = (seconds < 10) ? '0' + seconds : seconds;
	
	let sysTime = hours + ":" + minutes + ":" + seconds;
	
	return sysTime;
}

function getDate(date){	// date의 날짜 부분을 yy.MM.dd 식으로 추출
	let years = date.getFullYear();
	let months = date.getMonth() +1;
	let days = date.getDate(); 
	
	months = (months < 10) ? '0' + months : months;
	days = (days < 10) ? '0' + days : days;
	
	let sysDate = years + "." + months + "." + days;
	
	return sysDate;
}

$(function(){
	
	let firstDay = new Date(); //해당 주의 월요일로 설정
	let lastDay = new Date(); // 해당 주의 금요일로 설정
	let day = ["일","월","화","수","목","금","토"];
	
	firstDay.setDate(firstDay.getDate() - firstDay.getDay() + 1); // getDate() - getDay()를 하면 일요일 날짜가 나옴
	lastDay.setDate(lastDay.getDate() - lastDay.getDay() + 7);
    
	firstDayMain = getDate(firstDay);
	lastDayMain = getDate(lastDay);
	
	let prevWeek2Str =	`<ul class="pagination">
		    <li class="page-item">
		        <a class="page-link prev" href="#">
		            <i class="xi-angle-left"></i>
		        </a>
		</ul>`
		
	$(".weekDay1").html("<a class=prevWeek1> </a>" + firstDayMain + "(월) ~ " + lastDayMain + "(일) <a class=nextWeek1></a>")
	$(".weekDay2").html("<button type='button' class='btn1 prevBtn prevWeek2'><i class='xi-angle-left'></i></button><span class=weekDay2Span>" + firstDayMain + "(월) ~ " + lastDayMain + "(일) </span><button type='button' class='btn1 prevBtn nextWeek2'><i class='xi-angle-right'></i></button>")
	todayWeek = $(".weekDay1").text();
	todayWeekFirst = todayWeek.substr(1,4) + todayWeek.substr(6,2) + todayWeek.substr(9,2);
	todayWeekLast = todayWeek.substr(17,4) + todayWeek.substr(22,2) + todayWeek.substr(25,2)
	
	plusTimetoMinute = 0;
	
	let param = {
		"firstDay":todayWeekFirst,
		"lastDay": todayWeekLast,
		"empNo": sessionEmpNo
	}
	
	// "<" 클릭시 이전 주 월~금
	$(document).on("click",".prevWeek2",function(){
		firstDay.setDate(firstDay.getDate() - 7)
		lastDay.setDate(lastDay.getDate() - 7)
		
		firstDayPrev = getDate(firstDay);
		lastDayPrev = getDate(lastDay);
		
		$(".weekDay2").html("<button type='button' class='btn1 prevBtn prevWeek2'><i class='xi-angle-left'></i></button><span class=weekDay2Span>" + firstDayPrev + "(월) ~ " + lastDayPrev + "(일) </span><button type='button' class='btn1 prevBtn nextWeek2'><i class='xi-angle-right'></i></button>")
		drawChart();
		getAvgTime(); // 근태분석 주간 데이터를 가져오기 위한 ajax
	})
	
	// ">" 클릭시 다음 주 월~금
	$(document).on("click",".nextWeek2",function(){
		firstDay.setDate(firstDay.getDate() + 7)
		lastDay.setDate(lastDay.getDate() + 7)
		
		firstDayPrev = getDate(firstDay);
		lastDayPrev = getDate(lastDay);
		
		$(".weekDay2").html("<button type='button' class='btn1 prevBtn prevWeek2'><i class='xi-angle-left'></i></button><span class=weekDay2Span>" + firstDayPrev + "(월) ~ " + lastDayPrev + "(일) </span><button type='button' class='btn1 prevBtn nextWeek2'><i class='xi-angle-right'></i></button>")
		drawChart();
		getAvgTime(); // 근태분석 주간 데이터를 가져오기 위한 ajax
	})
	
	// 이번주 보기 클릭시 이번주 월요일 ~ 금요일로 보이도록
	$(document).on("click",".mainWeek",function(){
		firstDay = new Date();
		lastDay = new Date();
		firstDay.setDate(firstDay.getDate() - firstDay.getDay() + 1); // getDate() - getDay()를 하면 일요일 날짜가 나옴
		lastDay.setDate(lastDay.getDate() - lastDay.getDay() + 7);
		
		$(".weekDay2").html("<button type='button' class='btn1 prevBtn prevWeek2'><i class='xi-angle-left'></i></button><span class=weekDay2Span>" + firstDayMain + "(월) ~ " + lastDayMain + "(일) </span><button type='button' class='btn1 prevBtn nextWeek2'><i class='xi-angle-right'></i></button>")
		drawChart();
		getAvgTime(); // 근태분석 주간 데이터를 가져오기 위한 ajax
	})
	
	 function showTime() {
		
		let currentDate = new Date();
		let currentDay = currentDate.getDay();
		currentDay = day[currentDay]
		let sysDate = getDate(currentDate) + "(" + currentDay + ")";
		let sysTime = getTime(currentDate);
		
		document.querySelector("#sysDate").innerHTML = sysDate;
		document.querySelector("#sysTime").innerHTML = sysTime;
    }
    
    $("#modal-qr").on("click",function(){
		$("#modal-qr").removeClass("open");
	})
    
    $("#attendBtn").on("click",function(){
    	$(".attendLvffcSe").html("출근");
    })
    $("#lvffcBtn").on("click",function(){
    	$(".attendLvffcSe").html("퇴근");
    })
    
    var generateQRButton1 = document.querySelector("#attendBtn");
    var qrCodeContainer1 = document.querySelector(".qr-modal-cont");
    
    generateQRButton1.addEventListener("click", function() {
    	$(".qr-modal-cont").html("")
        // QR 코드 생성을 위한 데이터
        var qrCodeData = "http://192.168.146.64/attendance/attendConfirm?empNo="+sessionEmpNo+"&vcatnSeCd="+vcatnSeCd // 원하는 URL 또는 데이터
        console.log("vcatnSeCd:",vcatnSeCd)
        // QR 코드 생성
        var qrCode = new QRCode(qrCodeContainer1, {
            text: qrCodeData,
            width: 100,
            height: 100,
            colorDark : "#000000",
            colorLight : "#ffffff",
            correctLevel : QRCode.CorrectLevel.H
        });
        
        // $(".qr-modal-cont img").css("width","100px").css("height","100px")
        
    });
    
    var generateQRButton2 = document.querySelector("#lvffcBtn");
    var qrCodeContainer2 = document.querySelector(".qr-modal-cont");
    
    generateQRButton2.addEventListener("click", function() {
    	$(".qr-modal-cont").html("")
        // QR 코드 생성을 위한 데이터
        var qrCodeData2 = "http://192.168.146.64/attendance/lvffcConfirm?empNo="+sessionEmpNo // 원하는 URL 또는 데이터
        
        // QR 코드 생성
        var qrCode = new QRCode(qrCodeContainer2, {
            text: qrCodeData2,
            width: 100,
            height: 100,
            colorDark : "#000000",
            colorLight : "#ffffff",
            correctLevel : QRCode.CorrectLevel.H
        });
        
       // $(".qr-modal-cont img").css("width","100px").css("height","100px")
        
    });
    
    $(".weekTab").on("click",function(){
    	chartIdWM = "weekDayGraph";	// 차트아이디가 week인지 month인지 구분
    	firstDay = new Date();
		lastDay = new Date();
		firstDay.setDate(firstDay.getDate() - firstDay.getDay() + 1); // getDate() - getDay()를 하면 일요일 날짜가 나옴
		lastDay.setDate(lastDay.getDate() - lastDay.getDay() + 7);
		
    	$(".weekDay2").html("<button type='button' class='btn1 prevBtn prevWeek2'><i class='xi-angle-left'></i></button><span class=weekDay2Span>" + firstDayMain + "(월) ~ " + lastDayMain + "(일) </span><button type='button' class='btn1 prevBtn nextWeek2'><i class='xi-angle-right'></i></button>")
    	$(".workGraphDiv").css("display","flex")
    	$(".workGraphDiv2").css("display","none")
    	$(".avgMonthDiv").css("display","none")
    	$(".mainWeek").css("display","block")
    	
    	firstChartDay = chartLabel1.substr(2,4) + chartLabel1.substr(7,2) + chartLabel1.substr(10,2);
		lastChartDay = chartLabel1.substr(18,4) + chartLabel1.substr(23,2) + chartLabel1.substr(26,2)
    	
    	getAvgTime();
    	drawChart();
    })
    
    
    
    $(".monthTab").on("click",function(){
    	chartIdWM = "monthDayGraph";
    	mFirstDay = new Date();
		mLastDay = new Date();
    	// 현재 날짜를 가져옵니다.
    	currentDate = new Date();
    	// 월은 0부터 시작하므로, 현재 월의 첫 번째 날로 설정합니다.
    	currentDate.setDate(1);

    	// 첫 번째 날의 요일을 가져옵니다.
    	dayOfWeek = currentDate.getDay();

    	// 요일을 문자열로 변환합니다.
    	dayOfWeekNames = ["(일)", "(월)", "(화)", "(수)", "(목)", "(금)", "(토)"];
    	dayName = dayOfWeekNames[dayOfWeek];
    	
//     	let currentDate = new Date();
    	firstMonthDay = new Date();
    	firstMonthDay = getDate(firstMonthDay);
    	lastMonthDay = new Date(parseInt(firstMonthDay.substr(0,4)),parseInt(firstMonthDay.substr(5,2)),0)
    	lastMonthDay = getDate(lastMonthDay)
    	firstMonthDay = firstMonthDay.substr(0,8) + "01"
    	
    	$(".weekDay2").html("<button type='button' class='btn1 prevBtn prevMonth'><i class='xi-angle-left'></i></button><span class=weekDay2Span>" + firstMonthDay + " ~ " + lastMonthDay + " </span><button type='button' class='btn1 prevBtn nextMonth'><i class='xi-angle-right'></i></button>")
    	
    	monthGraphStr = ""
    	
    	chartLabels = []
    	
    	for(let i=1; i<=parseInt(lastMonthDay.substr(8,2));i++){
    		
    		dayName = dayOfWeekNames[(dayOfWeek+i-1)%7]
	    	let monthDay = "" + i;
	    	if(i < 10){
	    		monthDay = "0" + i
	    	}
	    	
	    	let monthGraphDay = monthDay
    		let monthDaylabel = monthGraphDay + dayName
    		chartLabels.push(monthDaylabel)
	    	
    	}
    	
    	$(".workGraphDiv").css("display","none")
    	$(".workGraphDiv2").css("display","flex")
    	$(".avgMonthDiv").css("display","block")
    	$(".mainWeek").css("display","none")
    	
		drawMonthChart();
		getAvgTime();
    	
    })
    
    // 이전달 표시
    $(document).on("click",".prevMonth",function(){
    	mFirstDay.setDate(0)
    	mFirstDay.setDate(1)
		mLastDay.setDate(0)
		
		firstDayPrev = getDate(mFirstDay);
		lastDayPrev = getDate(mLastDay);
		
		firstMonthDay = firstDayPrev
		lastMonthDay = lastDayPrev
		
		// 첫 번째 날의 요일을 가져옵니다.
    	dayOfWeek = mFirstDay.getDay();

    	// 요일을 문자열로 변환합니다.
    	dayName = dayOfWeekNames[dayOfWeek];
		
		$(".weekDay2").html("<button type='button' class='btn1 prevBtn prevMonth'><i class='xi-angle-left'></i></button><span class=weekDay2Span>" + firstDayPrev + " ~ " + lastDayPrev + " </span><button type='button' class='btn1 prevBtn nextMonth'><i class='xi-angle-right'></i></button>")
		
		chartLabels = []
		
		for(let i=1; i<=parseInt(lastMonthDay.substr(8,2));i++){
			
    		dayName = dayOfWeekNames[(dayOfWeek+i-1)%7]
	    	let monthDay = "" + i;
	    	if(i < 10){
	    		monthDay = "0" + i
	    	}
	    	
	    	let monthGraphDay = monthDay
    		
    		let monthDaylabel = monthGraphDay + dayName
    		chartLabels.push(monthDaylabel)
    		
		}
		
		drawMonthChart();
		getAvgTime(); // 근태분석 주간 데이터를 가져오기 위한 ajax
    })
    
    // 다음달 표시
    $(document).on("click",".nextMonth",function(){
    	mFirstDay.setMonth(mFirstDay.getMonth() + 1)
    	mFirstDay.setDate(1)
    	
    	// 이런식으로 하면 이상하게  7 ~ 8, 12 ~ 1 부분에서 버그가 걸림
    	//mLastDay.setMonth(mFirstDay.getMonth()+1)    	
    	//mLastDay.setDate(0)
    	mLastDay = new Date(mFirstDay.getFullYear(), mFirstDay.getMonth() + 1, 0);
    	
		firstDayPrev = getDate(mFirstDay);
		lastDayPrev = getDate(mLastDay);
		
		firstMonthDay = firstDayPrev
		lastMonthDay = lastDayPrev
		
		// 첫 번째 날의 요일을 가져옵니다.
    	dayOfWeek = mFirstDay.getDay();

    	// 요일을 문자열로 변환합니다.
    	dayName = dayOfWeekNames[dayOfWeek];
		
		$(".weekDay2").html("<button type='button' class='btn1 prevBtn prevMonth'><i class='xi-angle-left'></i></button><span class=weekDay2Span>" + firstDayPrev + " ~ " + lastDayPrev + " </span><button type='button' class='btn1 prevBtn nextMonth'><i class='xi-angle-right'></i></button>")
		
		chartLabels = []
		
		for(let i=1; i<=parseInt(lastMonthDay.substr(8,2));i++){
    		
    		dayName = dayOfWeekNames[(dayOfWeek+i-1)%7]
	    	let monthDay = "" + i;
	    	if(i < 10){
	    		monthDay = "0" + i
	    	}
	    	
	    	let monthGraphDay = monthDay
	    	
	    	let monthDaylabel = monthGraphDay + dayName
    		chartLabels.push(monthDaylabel)
    		
	    	
    	}
		
		drawMonthChart();
		getAvgTime(); // 근태분석 주간 데이터를 가져오기 위한 ajax
    })
    
    
 	// 1초마다 updateTime 함수를 호출하여 시간을 업데이트합니다.
    showTime();
    setInterval(showTime, 1000);
    getAvgTime(); // 근태분석 주간 데이터를 가져오기 위한 ajax
	getWeekWorkData() // 누적 근무시간, 잔여 근무시간, 초과 근무시간을 페이지에 띄우기 위한 ajax
    
    
})