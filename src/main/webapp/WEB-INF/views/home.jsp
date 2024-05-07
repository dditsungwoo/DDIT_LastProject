<%@ page language="java" contentType="text/html; charset=UTF-8"%> <%@ include file="/WEB-INF/views/tiles/taglib.jsp"%>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
<script src="https://www.gstatic.com/charts/loader.js"></script>

<script>
            $(function () {

     			if(${drag} == "1"){
     				$("#settingBtn").css("display", "block");
    				$(".wf-box.custom").addClass("draggable");
    		        dragDrop();
    			}

                showTime();
                setInterval(showTime, 1000);

                var dragGrid = document.querySelector(".wf-box-wrap");
            	var dragDivs = Array.from(document.querySelectorAll(".wf-box.custom"));
				console.log("dragGrid",dragGrid);
				console.log("dragDivs",dragDivs);
            	function fSort(){
                	dragDivs.sort((a,b)=>{
                		return parseInt(a.dataset.order) - parseInt(b.dataset.order);

                	});
                		for(let i=0; i<dragDivs.length; i++){
                			dragGrid.appendChild(dragDivs[i]);
                		}
                	}

            	//대시보드의 순서 처리
            	let ordStr = "${dashboardVO.dashOrder}";//1,2,3,4,5,6,7,8,9
        		let ordStrArr = ordStr.split(",");
                console.log("ordStrArr",ordStrArr);

            	//data-order의 값 넣어주기(DB에서 가져옴)
            	$(".wf-box.custom").each(function(idx){            		
            		$(this).attr("data-order",ordStrArr[idx]);
            		console.log(".wf-box.custom data-order",ordStrArr[idx]);
            	});

            	fSort();
            	//대쉬보드 위치 저장하기
        		$("#settingBtn").on("click",function(){
        			//data-order의 값 넣어주기(DB에서 가져옴)
        			let str = "";
        	    	$(".wf-box.custom").each(function(idx){
        	    		let ord = this.dataset.order;
      	    		   
      	    		    console.log("ord : "+ ord);
        	   		if (idx === $(".wf-box.custom").length - 1) {
        	          str += ord;
        	        } else {
        	            str += ord + ",";
        	        }
            	});

        	    	console.log("str : " + str);

        	    	//$.ajax -> update
        	    	$.ajax({
        	    		url: "/dashboard/list",
        	    		type: "get",
        	    		data: { str: str },
        	    		dataType: "text",
        	    		success: function(result){

        	    			if(result == "success"){
        	    				Swal.fire({
        	    					icon: "success",
        	    					title: _msg.common.saveSuccessAlert,
        	    				}).then((rslt) => {
        	    					if(rslt.isConfirmed){
    		    	    				//window.location.href = "/home";
        	    					}
        	    				});
        	    			}else{
        	    				Toast.fire({
        	    					icon: "info",
        	    					title: _msg.common.saveFailedAlert,
        	    				});
        	    			}

        	    		},
        	    		error: function(xhr, status, error){
        	    			console.error("failed:", error);
        	    		}
        	    	});
        		});

                $("#modal-qr").on("click", function () {
                    $("#modal-qr").removeClass("open");
                });

                $("#attendBtn").on("click", function () {
                    $(".attendLvffcSe").html("출근");
                });
                $("#lvffcBtn").on("click", function () {
                    $(".attendLvffcSe").html("퇴근");
                });

                var generateQRButton1 = document.querySelector("#attendBtn");
                var qrCodeContainer1 = document.querySelector(".qr-modal-cont");

                generateQRButton1.addEventListener("click", function () {
                    $(".qr-modal-cont").html("");
                    // QR 코드 생성을 위한 데이터
                    var qrCodeData = "http://192.168.146.64/attendance/attendConfirm?empNo=" + sessionEmpNo; // 원하는 URL 또는 데이터

                    // QR 코드 생성
                    var qrCode = new QRCode(qrCodeContainer1, {
                        text: qrCodeData,
                        width: 100,
                        height: 100,
                        colorDark: "#000000",
                        colorLight: "#ffffff",
                        correctLevel: QRCode.CorrectLevel.H,
                    });
                });

                var generateQRButton2 = document.querySelector("#lvffcBtn");
                var qrCodeContainer2 = document.querySelector(".qr-modal-cont");

                generateQRButton2.addEventListener("click", function () {
                    $(".qr-modal-cont").html("");
                    // QR 코드 생성을 위한 데이터
                    var qrCodeData2 = "http://192.168.146.64/attendance/lvffcConfirm?empNo=" + sessionEmpNo; // 원하는 URL 또는 데이터

                    // QR 코드 생성
                    var qrCode = new QRCode(qrCodeContainer2, {
                        text: qrCodeData2,
                        width: 100,
                        height: 100,
                        colorDark: "#000000",
                        colorLight: "#ffffff",
                        correctLevel: QRCode.CorrectLevel.H,
                    });
                });

                /* let sessionEmpNo = ${empVO.empNo}; */

                //대시보드 정렬

                // 데이터 가져오기
                gData(sessionEmpNo);

                // 업무
                getDashDuty(sessionEmpNo);

                // 프로젝트
                getPrjctSttusIng(sessionEmpNo);

                // 메일
                getEmailList();

                // 오늘의 일정
                getTodayScheduleList(sessionEmpNo);

                // 오늘의 회의실 예약
                getTodayMtrResveList();

                // 진행중인 결재
                getApvProgressList();
            });

            let sessionEmpNo = ${empVO.empNo}
    	  /* -------------------------- 대시보드 관련 시작 --------------------------*/
            function dragDrop(){
    			    const draggables = document.querySelectorAll(".draggable");
    			    const containers = document.querySelectorAll(".wf-box-wrap");
    				const divs = Array.from(document.querySelectorAll(".wf-box"));



    			    draggables.forEach((draggable) => {
    			        draggable.addEventListener("dragstart", () => {
    			            draggable.classList.add("dragging");
    			        });

    			        draggable.addEventListener("dragend", () => {
    			            draggable.classList.remove("dragging");
    			//             alert($(".wf-box-wrap").children().eq(2).data('drag'));
    			        });
    			    });

    			    containers.forEach((container) => {
    			        container.addEventListener("dragover", (e) => {
    			            e.preventDefault();
    			            const afterElement = getDragAfterElement(container, e.clientX, e.clientY);
    			            const draggable = document.querySelector(".dragging");
    			            if (afterElement === undefined) {
    			                container.appendChild(draggable);
    			            } else {
    			                container.insertBefore(draggable, afterElement);
    			            }
    			        });
    			    });
    				}

    			function getDragAfterElement(container, x, y) {
    			    const draggableElements = [...container.querySelectorAll(".draggable:not(.dragging)")];

    			    return draggableElements.reduce(
    			        (closest, child) => {
    			            const box = child.getBoundingClientRect();
    			            const xOffset = x - box.left - box.width / 2;
    			            const yOffset = y - box.top - box.height / 2;
    			            if ((xOffset < 0 && yOffset < 0) && (xOffset > closest.offsetX) && (yOffset > closest.offsetY)) {
    			            	 return { offsetX: xOffset, offsetY: yOffset, element: child };
    			            } else {
    			                return closest;
    			            }
    			        },
    			        { offsetX: Number.NEGATIVE_INFINITY, offsetY: Number.NEGATIVE_INFINITY }
    			    ).element;
    			}
            /* -------------------------- 대시보드 관련 끝 --------------------------*/

            /* -------------------------- 출퇴근 시작 -------------------------- */
            getAttendanceTime();

            function getTime(date) {
                // sysdate의 시간 부분을 hh:mm:ss 식으로 추출
                let hours = date.getHours();
                let minutes = date.getMinutes();
                let seconds = date.getSeconds();

                // 한 자리 숫자일 경우 앞에 0을 붙여 두 자리로 만듭니다.
                hours = hours < 10 ? "0" + hours : hours;
                minutes = minutes < 10 ? "0" + minutes : minutes;
                seconds = seconds < 10 ? "0" + seconds : seconds;

                let sysTime = hours + ":" + minutes + ":" + seconds;

                return sysTime;
            }

            function getDate(date) {
                // date의 날짜 부분을 yy.MM.dd 식으로 추출
                let years = date.getFullYear();
                let months = date.getMonth() + 1;
                let days = date.getDate();

                months = months < 10 ? "0" + months : months;
                days = days < 10 ? "0" + days : days;

                let sysDate = years + "." + months + "." + days;

                return sysDate;
            }

            function showTime() {
                let day = ["일", "월", "화", "수", "목", "금", "토"];
                let currentDate = new Date();
                let currentDay = currentDate.getDay();
                currentDay = day[currentDay];
                let sysDate = getDate(currentDate) + "(" + currentDay + ")";
                let sysTime = getTime(currentDate);

                document.querySelector("#sysDate").innerHTML = sysDate;
                document.querySelector("#sysTime").innerHTML = sysTime;
            }

            function getAttendanceTime() {
                $.ajax({
                    url: "/attendance/getAttendTime",
                    type: "get",
                    data: { empNo: sessionEmpNo },
                    dataType: "text",
                    success: function (res) {
                        if (res != "") {
                            let attendTime = "";
                            attendTime = res.substr(11, 8);
                            $(".attendTime").html(attendTime);
                        }
                    },
                });

                $.ajax({
                    url: "/attendance/getLvffcTime",
                    type: "get",
                    data: { empNo: sessionEmpNo },
                    dataType: "text",
                    success: function (res) {
                        if (res != "") {
                            let lvffcTime = "";
                            lvffcTime = res.substr(11, 8);
                            $(".lvffcTime").html(lvffcTime);
                        }
                    },
                });
            }

            function drawChart() {
                let workTime = "";

                $.ajax({
                    url: "/attendance/chart02",
                    type: "get",
                    data: { empNo: sessionEmpNo },
                    async: false,
                    success: function (res) {
                        workTime = res;
                    },
                });
                
                $.ajax({
            		url:"/attendance/getTodayRestUse",
            		type:"get",
            		data:{"empNo": headerEmpNo},
            		dataType:"text",
            		async:false,
            		success:function(res){
            			console.log("res:",res)
            			if(res == "2"){
            				$(".restUse").html("오늘은 오전반차 사용일입니다.")
            			}
            			if(res == "3"){
            				$(".restUse").html("오늘은 오후반차 사용일입니다.")
            			}
            		}
            	})


                let workTimeInt = 0;
                workTimeInt = parseInt(workTime * 100) / 100;
                if($(".restUse").text() != ""){
            		workTimeInt += 4;
            	}
                let todayWorkTimeStr = "";
                todayWorkTimeStr = workTimeInt.toFixed(2) + "";
                todayWorkTimeStr = todayWorkTimeStr.split(".")[0] + "h " + parseInt(todayWorkTimeStr.split(".")[1] * 6 / 10) + "m";
                
                if (workTimeInt == 0) {
                    todayWorkTimeStr = "0h 0m";
                }
                todayOverTime = 0;
                todayMinusTime = 0;
    			
                if (workTimeInt <= 8) {
                    todayMinusTime = 8 - workTimeInt;
                } else {
                    todayOverTime = 0;
                }
                if (workTimeInt <= 8) {
                    todayOverTime = 0;
                } else {
                    todayOverTime = workTimeInt - 8.0;
                    workTimeInt = 8;
                }

                let jsonData = {
                    cols: [
                        { id: "", label: "근무시간", pattern: "", type: "string" },
                        { id: "", label: "시간", pattern: "", type: "number" },
                        { id: "", label: "비율", pattern: "", type: "number" },
                    ],
                    rows: [
                        { c: [{ v: "초과근무시간" }, { v: todayOverTime }, { v: parseInt((todayOverTime / 8) * 10000) / 100 }] }, // 10%
                        { c: [{ v: "현재근무시간" }, { v: workTimeInt }, { v: parseInt((workTimeInt / 8) * 10000) / 100 }] }, // 20%
                        { c: [{ v: "잔여근무시간" }, { v: todayMinusTime }, { v: parseInt((todayMinusTime / 8) * 10000) / 100 }] }, // 30%
                    ],
                };

                //구글 차트용 데이터 테이블 생성
                let data1 = new google.visualization.DataTable(jsonData);

                //어떤 차트 모양으로 출력할지를 정해주자 => LineChart
                //LineChart , ColumnChart, PieChart
                let chart = new google.visualization.PieChart(document.getElementById("chart_div"));

                // data 데이터를 chart 모양으로 출력해보자
                chart.draw(data1, {
                    pieHole: 0.5,
                    colors: ["#FF9900", "#3366CC", "#DC3912"],
                    width: 200,
                    height: 250,
                    backgroundColor: "transparent",
                    chartArea: {
                        //left: '20%', // 좌측 간격 조정
                        top: "0%", // 상단 간격 조정
                        width: "50%", // 차트 영역의 너비 조정
                        height: "50%", // 차트 영역의 높이 조정
                    },
                    legend: { position: "none" }, // 레전드를 표시하지 않음
                    pieSliceText: "none", // 툴팁에 값을 표시할 때 % 표시 없이 값만 표시
                });

                var textContainer = document.createElement("div");
                textContainer.innerHTML =
                    '<div style="position: absolute; top: 57%; left: 50%; transform: translate(-50%, -50%); font-size: 13px;">' + todayWorkTimeStr + "</div>";
                document.getElementById("chart_div").appendChild(textContainer);
            }

            //구글 차트 라이브러리를 로딩
            google.load("visualization", "1", { packages: ["corechart"] });

            //불러오는 작업이 완료되어 로딩이 되었다면 drawChart() 함수를 호출하는 콜백이 일어남
            google.setOnLoadCallback(drawChart);

            /* -------------------------- 출퇴근 끝 -------------------------- */

            /* -------------------------- 프로젝트 시작 -------------------------- */
            function getPrjctSttusIng(empNo) {
                let data = {
                    empNo: empNo,
                };
                $.ajax({
                    url: "/project/getPrjctSttusForDashboard",
                    data: JSON.stringify(data),
                    contentType: "application/json;charset=utf-8",
                    type: "post",
                    dataType: "json",
                    beforeSend: function (xhr) {
                        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                    },
                    success: function (res) {
                        let str = "";
                        str = res.total;
                        $("#prjctSttusIng").html(str);
                    },
                });
            }

            gData = function (empNo) {
                let data = {
                    empNo: empNo,
                };


                $.ajax({
                    url: "/project/allProjectProgress",
                    data: JSON.stringify(data),
                    contentType: "application/json;charset=utf-8",
                    type: "post",
                    dataType: "json",
                    beforeSend: function (xhr) {
                        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                    },
                    success: function (res) {
                        // 차트 렌더링 함수를 호출합니다.
                        prenderChart(res);
                    },
                });
            };

            function prenderChart(projectData) {
                // 차트 생성
                if (!Array.isArray(projectData)) {
                    // 배열로 변환
                    projectData = [projectData];
                }
                const ctx = document.getElementById("prjctChart").getContext("2d");
                new Chart(ctx, {
                    type: "bar",
                    data: {
                        labels: [], //projectData.map(project => project.total), // 프로젝트명을 라벨로 사용
                        datasets: [
                            {
                                label: "진행률", // 라벨을 '진행률'로 설정
                                backgroundColor: projectData.map((project) => getColorByProgress(project.total)), // 진행률에 따라 색상 설정
                                borderWidth: 1,
                                data: projectData.map((project) => ({
                                    x: project.prjctNm, // x축에 진행률
                                    y: project.total, // y축에 프로젝트명
                                })),
                            },
                        ],
                    },
                    options: {
                        scales: {
                            y: {
                                display: true, // Hide Y axis labels
                            },
                            x: {
                                display: false, // Hide X axis labels
                            },
                        },
                    },
                });
            }

            // 진행률에 따라 색상을 반환하는 함수
            function getColorByProgress(progress) {
                // 진행률이 높을수록 파란색에 가까운 색을 반환합니다.
                const red = Math.floor((255 * (100 - progress)) / 100);
                const green = 0;
                const blue = Math.floor((255 * progress) / 100);
                return "rgba(" + red + ", " + green + ", " + blue + ", 0.5)"; // 투명도는 0.5로 설정합니다.
            }

            /* -------------------------- 프로젝트 끝 -------------------------- */

            /* -------------------------- 업무 시작 -------------------------- */
            function getDashDuty(empNo) {
                _prgBadge = {
                    0: "wf-badge5",
                    1: "wf-badge1",
                    2: "wf-badge1",
                    3: "wf-badge1",
                    4: "wf-badge1",
                    5: "wf-badge1",
                    6: "wf-badge1",
                    7: "wf-badge1",
                    8: "wf-badge2",
                    9: "wf-badge2",
                    10: "wf-badge4",
                };

                _prgName = {
                    0: "중지",
                    1: "진행중",
                    2: "진행중",
                    3: "진행중",
                    4: "진행중",
                    5: "진행중",
                    6: "진행중",
                    7: "진행중",
                    8: "진행중",
                    9: "진행중",
                    10: "완료",
                };

                let data = {
                    empNo: empNo,
                };
                $.ajax({
                    url: "/duty/getDashDuty",
                    data: JSON.stringify(data),
                    contentType: "application/json;charset=utf-8",
                    type: "post",
                    dataType: "json",
                    beforeSend: function (xhr) {
                        xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                    },
                    success: function (res) {
                        let str = "";
                        str += `<div class="tit-wrap">
              					<div class="tit-wrap-inner">
                              		<h1 class="wf-box-tit">업무</h1>
                              		<span class="txt">/ 진행중인 업무 <span class="cnt">\${res.total}</span></span>
                          		</div>
                          			<button type="button" class="go-btn" onclick="location.href='/duty/main'">더보기</button>
                      			</div>
                     					 <ul class="box-list3" style="height:160px;">`;
                        $.each(res.list, function (idx, vo) {
                            let position = vo.position;
                            let rspnsbl = vo.rspnsbl;
                            if (rspnsbl != "팀원") {
                                position = rspnsbl;
                            }
                            str += `<li>
                              				<a href="/duty/detail?dutyNo=\${vo.dutyNo}&empNo=\${vo.empNo}">
                                  			<span class="\${_prgBadge[vo.prgsRate]}">\${_prgName[vo.prgsRate]}</span>
                                  			<span class="tit">\${vo.dutySj}</span>
                                 				<div class="top">
                                      		<span class="emp">\${vo.empNm} \${position}</span>
                                      		<span class="emp">\${vo.sender}</span>

                                      		<span class="date">\${vo.closDate}</span>
                                 				 </div>
                              				</a>
                          				</li>`;
                        });
                        str += `</ul>`;
                        $("#dutyBox").html(str);
                    },
                });
            }
            

            /* -------------------------- 업무 끝 -------------------------- */

    	    /* -------------------------- 메일 시작 -------------------------- */
    		function getEmailList(){
    	    	$.ajax({
    	    		url: "/mail/getDashboardList",
    	    		contentType: "application/json;charset=utf-8",
    	    		type:"get",
    	    		dataType:"json",
    	    		success:function(result){
    				$('#noreadCnt').text(result.noreadCnt);
    				let str ="";

    	    		//목록 초기화
    	    		$("#emailList").html("");

    	    		if(!result.emailList.length){
    	    			str += `<li><a class="noData">받은 메일이 없습니다.</a></li>`;
    	    		} else {
    	    		$.each(result.emailList,function(idx,emailVO){
    					str += `<li><a href="/mail/detail/main/\${emailVO.emailNo}?prevMailNo=\${emailVO.prevMailNo}&nextMailNo=\${emailVO.nextMailNo}">
    					<div class="img-wrap">
    					<img src="/resources/img/icon/\${emailVO.senderImageUrl}" />
    					</div>
    					<div class="emp-wrap">
    					<span class="tit">\${emailVO.emailSj}</span>
    					<span class="emp">\${emailVO.senderName}</span>
    					</div> <span class="date">\${emailVO.sendDate}</span>
    					</a></li>`;
    	    		});
    	    		}
    	    		$("#emailList").append(str);
    	    		},
    	    		error: function(xhr, status, error){
    	    			console.error("mail ajax error:", status, error);
    	    		}
    	    	});
    	    }
    	    /* -------------------------- 메일 끝 -------------------------- */

            /* -------------------------- 공지사항 시작 -------------------------- */

            function getNoticeList(){
                let counter = 0;
                $.ajax({
                    url: "/notice/home/list",
                    contentType: "application/json;charset=utf-8",
                    type: "GET",
                    dataType: "json",
                    success: function (res) {
                        if(res == null){
                            //공지사항 헤더
                            let noticeHeadearArea = document.getElementById("noticeHeader");

                            // 공지사항 바디
                            let noticeBodyArea = document.getElementById("noticeBody");

                            let strHeader="";
                            // header페이지
                            strHeader += "<div class='tit-wrap-inner'>";
                            strHeader += "<h1 class='wf-box-tit'>공지사항</h1>";
                            strHeader += "<span class='txt'>";
                            strHeader += "<span class='cnt'>0</span>";
                            strHeader += "</span>";
                            strHeader += "</div>";
                            strHeader += "<button type='button' class='go-btn' id='goNoticeList'>";
                            strHeader += "더보기</button>";


                            let strBody = "";
                            strBody += "<p>공지사항이 존재하지 않습니다</p>";
                            noticeBodyArea.innerHTML+=strBody;
                            noticeHeadearArea.innerHTML += strHeader;
                        }


                        //공지사항 헤더
                        let noticeHeadearArea = document.getElementById("noticeHeader");

                        // 공지사항 바디
                        let noticeBodyArea = document.getElementById("noticeBody");


                        //공지가 10개 이하일 경우
                        if(res.length<10){
                            for(let i=0; i<res.length;i++){
                                let strBody="";
                                strBody += "<li>";
                                strBody += "<a href='/notice/list/detail?noticeBrdNo="+res[i].noticeBrdNo+"'>";
                                strBody += "<span class='badge badge1'>";
                                strBody += "<i class='xi-bell'>";
                                strBody += "</i>";
                                strBody += "</span>";
                                strBody += "<span class='tit'>";
                                if(res[i].fixingEndDate != null){
                                  strBody += "<span class='wf-badge3'>중요</span>&nbsp;";
                                }
                                strBody += res[i].noticeBrdSj;
                                strBody += "</span>";

                                //시간 자르기
                                let datePart = res[i].writngDate;
                                let date = datePart.substr(0, 10);

                                strBody += "<span class='date'>"+date+"</span>";
                                strBody += "</a>";
                                strBody += "</li>";

                                noticeBodyArea.innerHTML+=strBody;
                                counter ++;
                            }
                        }
                        //공지가 10개 이상일 경우
                        else{
                            for(let i=0;i<10;i++){
                                let strBody="";
                                strBody += "<li>";
                                strBody += "<a href='/notice/list/detail?noticeBrdNo="+res[i].noticeBrdNo+"'>";
                                strBody += "<span class='badge badge1'>";
                                strBody += "<i class='xi-bell'>";
                                strBody += "</i>";
                                strBody += "</span>";
                                strBody += "<span class='tit'>";
                                if(res[i].fixingEndDate != null){
                                  strBody += "<span class='wf-badge3'>중요</span>&nbsp;";
                                }
                                strBody += res[i].noticeBrdSj;
                                strBody += "</span>";

                                //시간 자르기
                                let datePart = res[i].writngDate;
                                let date = datePart.substr(0, 10);

                                strBody += "<span class='date'>"+date+"</span>";
                                strBody += "</a>";
                                strBody += "</li>";
                                counter ++;
                                noticeBodyArea.innerHTML+=strBody;
                            }

                        }



                        //공지사항 헤더만들기
                        let strHeader="";
                        // header페이지
                        strHeader += "<div class='tit-wrap-inner'>";
                        strHeader += "<h1 class='wf-box-tit'>공지사항</h1>";
                        strHeader += "<span class='txt'>";
                        strHeader += "<span class='cnt'>"+counter+"</span>";
                        strHeader += "</span>";
                        strHeader += "</div>";
                        strHeader += "<button type='button' class='go-btn' id='goNoticeList'>";
                        strHeader += "더보기</button>";


                        noticeHeadearArea.innerHTML += strHeader;
                    },
                });
            }

            getNoticeList();

            $(document).on("click","#goNoticeList",function(){
                window.location.href = "/notice/list";
            });



            /* -------------------------- 공지사항 끝 -------------------------- */

            /* -------------------------- 결재 시작 -------------------------- */

        	function getApvProgressList() {
        	    $.ajax({
        	        url: '/approval/getAllProgressMine',
        	        type: 'get',
        	        dataType: 'json',
        	        success: (data) => {
        	            if(data.length>0){
        	            	$('#apvCnt').text(data.length);
        		            data.forEach((e) => {

        		            	let docNm;
        		            	let type;
        		        		switch(e.docFormNo){
        		        			case '1':
        		        				docNm = '품의서';
        		        				type = 'badge4';
        		        				break;
        		        			case '2':
        		        				docNm = '출장신청서';
        		        				type = 'badge3';
        		        				break;
        		        			case '3':
        		        				docNm = '도서구입신청서';
        		        				type = 'badge1';
        		        				break;
        		        			default:
        		        				docNm = '품의서';
        		        				type = 'badge4';
        	        					break;
        		        		}

        		                let html = '<li>' +
        	                    '    <a href="/approval/approvalDetailView?apvNo=' + e.apvNo + '">' +
        	                    '        <span class="badge ' + type + '">' + docNm + '</span>' +
        	                    '        <span class="tit">' + e.apvSj + '</span>' +
        	                    '        <span class="date">' + e.drftDate.split(" ")[0] + '</span>' +
        	                    '    </a>' +
        	                    '</li>';
        	         			$('#apvUl').append(html);
        		            });

        	            } else{
        	            	let html = `<li><a class="noData">진행중인 문서가 없습니다.</a></li>`;
        	            	$('#apvUl').append(html);
        	            }
        	        }
        	    });
        	}

            /* -------------------------- 결재 끝 -------------------------- */

           /* -------------------------- 일정 시작 -------------------------- */
                // 내 오늘 일정
                function getTodayScheduleList(empNo) {
                    $.ajax({
                        url:`/api/schedules/today/\${empNo}`,
                        type:"GET",
                        dataType: "json",
                        success: function(schedules) {
                            let mySchStr="";
                            let teamSchStr="";
                            let deptSchStr="";
                            let compSchStr="";

                            $("#mySchBox").empty();
                            $("#teamSchBox").empty();
                            $("#deptSchBox").empty();
                            $("#compSchBox").empty();

                            if(schedules) {
                                schedules.forEach(function(schedule, index) {

                                    let allDayCd = schedule.allDayCd;
                                    let schType = schedule.schType;
                                    let rowStr = "";

                                    if(schType == "teamSch" && schedule.schSeCd == "1") {
                                        schedule.title += schedule.empInfo;
                                    }

                                    if(allDayCd == "1") {
                                        rowStr +=  `<span class="tit">\${schedule.title}</span>`

                                    } else {
                                        let timeStr = getTimeStr(schedule.start);
                                        rowStr +=  `<span class="tit">\${timeStr} \${schedule.title}</span>`
                                    }

                                    switch(schType){
            		        			case 'mySch':
                                            mySchStr += rowStr;
            		        				break;
            		        			case 'teamSch':
                                            teamSchStr += rowStr;
            		        				break;
            		        			case 'deptSch':
                                            deptSchStr += rowStr;
                                            break;
                                        case 'compSch':
                                            compSchStr += rowStr;
                                            break;
            		        			default:
                                            compSchStr += rowStr;
            	        					break;
            		        		}

                                })
                            }
                            $("#mySchBox").append(mySchStr);
                            $("#teamSchBox").append(teamSchStr);
                            $("#deptSchBox").append(deptSchStr);
                            $("#compSchBox").append(compSchStr);
                            $("#schCnt").text(schedules.length);

                        }
                    })

                }

                function getTimeStr(dateTimeStr) {
                    let dateTime = new Date(dateTimeStr);
                    let hours = dateTime.getHours();

                    if (hours < 12) {
                        return "오전 " + hours + "시";
                    } else {
                        return "오후 " + (hours-12) + "시";;
                    }
                }
                /* -------------------------- 일정 끝 -------------------------- */

            /* -------------------------- 크롤링 시작 -------------------------- */
            //IT 뉴스 go-btn 클릭 시
            function goBtn() {
                window.open("https://news.naver.com/breakingnews/section/105/283", "_blank");
            }
            /* -------------------------- 크롤링 끝 -------------------------- */

            /* -------------------------- 회의실 예약 시작 -------------------------- */
            function getTodayMtrResveList() {
                $.ajax({
                    url: "/api/reservations/mtr/today",
                    type: "GET",
                    dataType: "json",
                    success: function (resves) {
                        console.log("resves : ", resves);
                        $("#resveCnt").text(resves.length);
                        let rowStr = "";
                        if (!resves.length) {
                            rowStr += ` <li><a class="noData">회의실 예약이 없습니다.</a></li>`;
                        } else {
                            resves.forEach(function (resve, index) {
                                let mtrNo = resve.mtrNo;
                                let mtrStr = "";
                                if (mtrNo == "ROOM1") {
                                    mtrStr = "badge2'>소회의실1";
                                } else if (mtrNo == "ROOM2") {
                                    mtrStr = "badge2'>소회의실2";
                                } else if (mtrNo == "ROOM2") {
                                    mtrStr = "badge4'>중회의실1";
                                } else if (mtrNo == "ROOM2") {
                                    mtrStr = "badge4'>중회의실2";
                                } else {
                                    mtrStr = "badge1'>대회의실";
                                }

                                rowStr += ` <li>
                                                      <a href="#">
                                                          <span class='badge \${mtrStr}</span>
                                                          <span class="tit">\${resve.resveCn}</span>
                                                          <div class="right">
                                                              <span class="emp">예약자 : \${resve.empNm}</span>
                                                              <span class="date">\${resve.resveBeginDate.substr(11,5)}~\${resve.resveEndDate.substr(11,5)}</span>
                                                          </div>
                                                      </a>
                                                  </li>`;
                            });
                        }
                        $("#resveUl").append(rowStr);
                    },
                });
            }
            /* -------------------------- 회의실 예약 끝 -------------------------- */
</script>

<div class="wf-box-wrap">
    <div class="wf-box custom" draggable="true" data-aos="fade-up" data-aos-duration="1000" data-aos-delay="" data-order="1" id="d1">
        <div class="tit-wrap">
            <h1 class="wf-box-tit">출/퇴근</h1>
            <h2 class="restUse"></h2>
            <!-- <button type="button" class="go-btn">더보기</button> -->
        </div>
        <div class="box-cont attend-cont">
            <div class="attend-box">
                <p id="sysDate" class="current">2024.03.30(토)</p>
                <p id="sysTime" class="current-date">16:38:51</p>
                <p class="sub-tit">출근: <span class="attendTime">-- : -- :--</span></p>
                <p class="sub-tit">퇴근: <span class="lvffcTime">-- : -- :--</span></p>
                <div class="button-wrap">
                    <button type="button" id="attendBtn" class="btn2 qrBtn" modal-id="modal-qr"><i class="xi-man"></i>출근</button>
                    <button type="button" id="lvffcBtn" class="btn7 qrBtn" modal-id="modal-qr"><i class="xi-run"></i>퇴근</button>
                </div>
            </div>
            <div class="chartArea" style="position: relative; margin: 0 auto">
                <p class="attend-tit">오늘의 근무 <i class="xi-time"></i></p>
                <div id="chart_div" style="width: 100%; height: 80%"></div>
            </div>
        </div>
    </div>

    <!-- ================================================== -->
    <!-- 프로젝트 -->
    <div class="wf-box custom" draggable="true" data-aos="fade-up" data-aos-duration="1000" data-aos-delay="100" data-order="2" id="d2">
        <div class="tit-wrap">
            <div class="tit-wrap-inner">
                <h1 class="wf-box-tit">프로젝트</h1>
                <span class="txt">/ 진행중인 프로젝트 <span class="cnt" id="prjctSttusIng">0</span></span>
            </div>
            <button type="button" class="go-btn" onclick="location.href='/project/projects'">더보기</button>
        </div>
        <div class="box-cont" id="prjctUl">
            <canvas id="prjctChart"></canvas>
        </div>
    </div>

    <!-- ================================================== -->
    <!-- 업무 -->
    <div class="wf-box custom" draggable="true" data-aos="fade-up" data-aos-duration="1000" data-aos-delay="200" data-order="3" id="d3">
        <div id="dutyBox"></div>
    </div>

    <!-- ================================================== -->
    <!-- 메일 -->
    <div class="wf-box custom" draggable="true" data-aos="fade-up" data-aos-duration="1000" data-aos-delay="300" data-order="4" id="d4">
        <div class="tit-wrap">
            <div class="tit-wrap-inner">
                <h1 class="wf-box-tit">메일</h1>
                <span class="txt">/ 안읽은메일<span class="cnt" id="noreadCnt"></span></span>
            </div>
            <a href="/mail/main" class="go-btn">더보기</a>
        </div>
        <ul id="emailList" class="box-list1"></ul>
    </div>

    <!-- ================================================== -->
    <!-- 공지사항 -->
    <div class="wf-box custom" draggable="true" data-aos="fade-up" data-aos-duration="1000" data-aos-delay="400" data-order="5" id="d5">
        <div class="tit-wrap" id="noticeHeader"></div>
        <!--공지사항 시작-->
        <ul class="box-list1" id="noticeBody"></ul>
    </div>

    <!-- ================================================== -->
    <!-- 진행중인 결재-->
    <div class="wf-box custom" draggable="true" data-aos="fade-up" data-aos-duration="1000" data-aos-delay="500" data-order="6" id="d6">
        <div class="tit-wrap">
            <div class="tit-wrap-inner">
                <h1 class="wf-box-tit">진행중인 결재</h1>
                <span class="txt"><span id="apvCnt" class="cnt">0</span></span>
            </div>
            <a href="/approval/listView" class="go-btn">더보기</a>
        </div>
        <ul class="box-list1" id="apvUl"></ul>
    </div>

    <!-- ================================================== -->
    <!-- 오늘의 일정 -->
    <div class="wf-box custom" draggable="true" data-aos="fade-up" data-aos-duration="1000" data-aos-delay="600" data-order="7" id="d7">
        <div class="tit-wrap">
            <div class="tit-wrap-inner">
                <h1 class="wf-box-tit">오늘의 일정</h1>
                <span class="txt"><span class="cnt" id="schCnt"></span></span>
            </div>
            <a href="/schedule/main" class="go-btn">더보기</a>
        </div>
        <ul class="box-list2">
            <li>
                <a href="/schedule/main">
                    <span class="badge badge1">내일정</span>
                    <div id="mySchBox"></div>
                </a>
            </li>
            <li>
                <a href="/schedule/main">
                    <span class="badge badge2">팀일정</span>
                    <div id="teamSchBox"></div>
                </a>
            </li>
            <li>
                <a href="/schedule/main">
                    <span class="badge badge3">본부일정</span>
                    <div id="deptSchBox"></div>
                </a>
            </li>
            <li>
                <a href="/schedule/main">
                    <span class="badge badge4">회사일정</span>
                    <div id="compSchBox"></div>
                </a>
            </li>
        </ul>
    </div>

    <!-- ================================================== -->
    <!-- IT 뉴스 -->
    <div class="wf-box custom" draggable="true" data-aos="fade-up" data-aos-duration="1000" data-aos-delay="700" data-order="8" id="d8">
        <div class="tit-wrap">
            <div class="tit-wrap-inner">
                <h1 class="wf-box-tit">IT 뉴스</h1>
            </div>
            <button type="button" class="go-btn" onclick="goBtn()">더보기</button>
        </div>
        <ul class="box-list1">
            <c:forEach var="news" items="${newsList}" varStatus="stat">
                <li>
                    <a href="${news.url}" target="_blank">
                        <span class="badge badge3"> <i class="xi-trending-up"> </i> </span> <span class="tit"> ${news.subject} </span>
                    </a>
                </li>
            </c:forEach>
        </ul>
    </div>

    <!-- ================================================== -->
    <!-- 회의실 예약 현황 -->
    <div class="wf-box custom" draggable="true" data-aos="fade-up" data-aos-duration="1000" data-aos-delay="800" data-order="9" id="d9">
        <div class="tit-wrap">
            <div class="tit-wrap-inner">
                <h1 class="wf-box-tit">회의실 예약 현황</h1>
                <span class="txt">/ 오늘의 예약수<span class="cnt" id="resveCnt"></span></span>
            </div>
            <a href="/reservation/mtr/main" class="go-btn">더보기</a>
        </div>
        <ul class="box-list1" id="resveUl"></ul>
    </div>

    <!------------------------------------- QR 모달 시작 ------------------------------------->
    <div class="modal" id="modal-qr">
        <div class="modal-cont" style="display: flex; flex-direction: row; width: 400px">
            <div class="qr-modal-cont"></div>
            <div>
                <p class="heading1" style="margin: 30px">
                    코드를 스캔하여<br />
                    <span class="attendLvffcSe">출근</span>체크를 완료해주세요.
                </p>
            </div>
        </div>
    </div>
    <!------------------------------------- QR 모달 끝 ------------------------------------->
</div>
