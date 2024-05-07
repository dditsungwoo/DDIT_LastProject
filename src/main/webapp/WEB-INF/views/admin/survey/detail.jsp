<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

		<link rel="stylesheet" href="/resources/css/project/detail.css" />
		<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.0/chart.umd.min.js"></script>
		<script>
			let surveyNo = "${surveyVO.surveyNo}";

			$(() => {
				let questionNo = "${questionNum}";
				let surveyNo = "${surveyVO.surveyNo}";
				getResultList();


				console.log("questionNo--->", questionNo);

				async function getResultList() {
					let questionNum = `${questionNum}`;
					console.log("questionNum---->", questionNum);

					let typeCode = "${typeCode}";
					console.log("typeCode ----> ", typeCode);
					var surveyQuestionVOArray = typeCode.split(', ');

					// surveyQuestionTypeCd에 해당하는 문자들을 추출하여 새로운 배열에 저장
					var surveyQuestionTypeCdArray = [];
					// 정규표현식을 사용하여 surveyQuestionTypeCd 값 추출
					var regex = /surveyQuestionTypeCd=(\d+)/g;
					var surveyQuestionTypeCdArray = [];
					var match;
					while ((match = regex.exec(typeCode)) !== null) {
						surveyQuestionTypeCdArray.push(match[1]);
					}



					// 질문 자른거
					let questionSj = "${questionSj}";
					console.log("questionSj---->", questionSj);
					var regex = /surveyQuestionSj=([^,]+),/g;
					var surveyQuestionSjArray = [];
					var match;
					while ((match = regex.exec(questionSj)) !== null) {
						surveyQuestionSjArray.push(match[1]);
					}

					console.log(surveyQuestionSjArray);



					let questNum = 0;

					let surveyQuestionList = `${surveyQuestionVOList}`;

					//var jsonArray = JSON.parse(surveyQuestionList);
					//4
					//let count = jsonArray.length;
					//console.log("count---->",count)

					// 3
					questNum = questionNum / 4;


					//2
					console.log("questNum---->", questNum);



					let surveyVO = "${surveyVO}";
					console.log("surveyVO--->", surveyVO);




					let inputArea = document.getElementById('inputArea');
					console.log("inputArea----->", inputArea);
					let countIndex = 0;
					let str = "";





					for (let i = 0; i < questNum; i++) {
						let countRes = countIndex + 1;
						str += "<div class='wf-flex-box' style='height:435px;'>";
						for (let j = 0; j < 4; j++) {
							if (surveyQuestionTypeCdArray[countIndex] == 1) {
								str += "<div class='wf-content-area' style='width:25%;'>";
								str += "<p class='heading2'>" + countRes + ") " + surveyQuestionSjArray[countIndex] + "</p>";
								str += "<div class='chart-container'style='display: inline-block; width: 100%; height: 90%; box-sizing: border-box;'>";
								str += "<canvas id='myChart" + countRes + "'style='display: block; box-sizing: border-box; height: 90%; width: 90%;' width='90%'height='90%'>";
								str += "</canvas>";
								str += "</div>";
								str += "</div>";
								countIndex++;
								countRes++;
							} else if (surveyQuestionTypeCdArray[countIndex] == 2) {
								str += "<div class='wf-content-area' style='width:25%;'>";
								str += "<p class='heading2'>" + countRes + ")" + surveyQuestionSjArray[countIndex] + "</p>";
								str += "<div class='chart-container' style='position: relative; margin: auto; height: 200; width: 200; justify-content: center;'>";
								str += "<canvas id='myChart" + countRes + "'>";
								str += "</canvas>";
								str += "</div>";
								str += "</div>";
								countIndex++;
								countRes++;
							} else {
								console.log("경우의 수3 여기들어옴");
								str += "<div class='wf-content-area' style='width:25%;'>";
								str += "<p class='heading2'>" + countRes + ")" + surveyQuestionSjArray[countIndex] + "</p>";
								let aaa = getSeosul(countRes, surveyNo);
								console.log("for문 바로 위");
								await aaa.then(result => {
									console.log("result ----> ", result);
									for (let i = 0; i < result.length; i++) {
										console.log("for문돎", result[i].surveyResponseResult);
										let strA = result[i].surveyResponseResult;
										str += "<p class='heading1'>" + (i + 1) + "." + strA + "</p>";
									}
								});
								str += "</div>";
								countIndex++;
								countRes++;
							}
						}
						str += "</div>";
						str += "<br>";
					}
					console.log("str ---> ", str);
					inputArea.innerHTML += str;


					for (let i = 0; i < questionNo; i++) {
						console.log("i---->", i);
						gData(surveyNo, i + 1);
					}
				};






				$(document).on("click", "#deleteSurvey", function () {
					console.log("삭제 버튼 누름");
					let data = {
						surveyNo: surveyNo,
					};

					console.log("surveyNo---->", surveyNo);

					Swal.fire({
						title: _msg.common.deleteConfirm,
						showDenyButton: true,
						confirmButtonText: "삭제",  // 필요시 수정 거능
						denyButtonText: `취소`,  // 필요시 수정 가능
					}).then((result) => {
						if (result.isConfirmed) { // 컨펌 확인 버튼 누르면
							$.ajax({
								url: "/admin/survey/delete",
								data: JSON.stringify(data),
								contentType: "application/json;charset=utf-8",
								type: "post",
								dataType: "json",
								beforeSend: function (xhr) {
									xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
								},
								success: function (res) {
									if (res == "1") {
										// 성공 알림 출력
										Toast.fire({
											icon: "success",
											title: "설문조사가 성공적으로 삭제되었습니다.", // 메세지 수정해서 사용
										});
										setTimeout(function() {
								            window.location.href = "/admin/survey/list"; // 리스트 페이지 URL로 변경
								        }, 1000);
									} else {
										// 실패 알림 출력
										Toast.fire({
											icon: "info",
											title: _msg.common.deleteFailAlert,
										});
									}
								},
							});
						} else if (result.isDenied) { // 컨펌 취소 버튼 누르면

							// 실패 알림 출력
							Toast.fire({
								icon: "info",
								title: _msg.common.deleteFailAlert,
							});
						}
					});
				});













			});



			// 질문 타입, 설문조사 번호,질문 번호, 결과 선택지 번호
			gData = function (surveyNo, questionId) {
				let data = {
					surveyNo: surveyNo,
					questionId: questionId,
				};
				console.log("data ----> ", data);

				$.ajax({
					url: "/admin/survey/statis",
					data: JSON.stringify(data),
					contentType: "application/json;charset=utf-8",
					type: "post",
					dataType: "json",
					beforeSend: function (xhr) {
						xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
					},
					success: function (res) {
						console.log("list Survey", res);
						console.log("surveyQuestionTypeCd", res[0].surveyQuestionTypeCd);
						// 차트 렌더링 함수를 호출합니다.
						if (res[0].surveyQuestionTypeCd == "1") {
							console.log("막대그래프");
							renderChart(res, questionId);
						} else if (res[0].surveyQuestionTypeCd == "2") {
							console.log("pie그래프");
							pieChart(res, questionId);
						}
						else {
							console.log("서술")
						}
					}
				});

			}


			function renderChart(projectData, questionId) {
				if (!Array.isArray(projectData)) {
					// 배열로 변환
					projectData = [projectData];
				}
				console.log("projectData---->", projectData);
				console.log("rederChart--->", questionId);
				// 각 프로젝트 데이터를 바탕으로 데이터셋을 구성
				const datasets = projectData.map(project => ({
					label: project.surveyChoiceSj, // 각 항목의 라벨
					data: [project.cnt] // 각 항목의 데이터
				}));


				// Canvas 요소를 가져옵니다.
				var ctx = document.getElementById('myChart' + questionId).getContext('2d');
				// 차트를 생성합니다.
				var myChart = new Chart(ctx, {
					type: 'bar', // 차트 종류를 설정합니다. (bar, line, radar, polarArea, doughnut, pie)
					data: {
						labels: projectData.map(project => project.surveyChoiceSj), // 프로젝트명을 라벨로 사용
						datasets: [{
							label: "인원수",
							borderWidth: 1,
							data: projectData.map(project => ({
								x: project.surveyChoiceSj, // x축에 진행률
								y: project.cnt // y축에 프로젝트명
							}))
						}]
					},
					options: {
						scales: {
							yAxes: [{
								ticks: {
									autoSkip: true,
									maxTicksLimit: 10, // 최대 눈금 수를 설정합니다.
									stepSize: 1 // y축의 눈금 간격을 설정합니다.
								}
							}]
						}
					}
					
					
				});
			}

			function pieChart(projectData, questionId) {
				if (!Array.isArray(projectData)) {
					// 배열로 변환
					projectData = [projectData];
				}
				console.log("projectData---->", projectData);


				// Canvas 요소를 가져옵니다.
				var ctx = document.getElementById('myChart' + questionId).getContext('2d');
				// 차트를 생성합니다.
				var myChart = new Chart(ctx, {
					type: 'doughnut', // 차트 종류를 설정합니다. (bar, line, radar, polarArea, doughnut, pie)
					data: {
						labels: projectData.map(project => project.surveyChoiceSj), // 프로젝트명을 라벨로 사용
						datasets: [{
							label: "인원수",
							data: projectData.map(project => project.cnt) // 프로젝트의 인원수 데이터
						}]
					},
					options: {
						legend: {
							position: 'right' // 범례 위치를 오른쪽으로 설정
						}
					}
				});
			}


			async function getSeosul(questionId, surveyNo) {
				return new Promise((resolve) => {
					let data = {
						"questionId": questionId,
						"surveyNo": surveyNo
					};
					$.ajax({
						url: "/admin/survey/getSeosul",
						data: JSON.stringify(data),
						contentType: "application/json;charset=utf-8",
						type: "post",
						beforeSend: function (xhr) {
							xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
						},
						success: function (res) {
							let str = "";
							console.log("res---->", res);
							/* for(let i=0; i<res.length; i++){
								console.log("for문 돔");
								str += "<p class='heading1'>"+i+"."+res[i].surveyResponseResult+"</p>";
							} */
							resolve(res); // 비동기 호출 성공 시 결과를 resolve로 반환
						}
					});
				});
			}




			/*
			data: {
						labels: projectData.map(project => project.surveyChoiceSj), // 바 차트의 경우 라벨을 설정합니다.
						datasets: datasets // 데이터셋 설정
					}
	
			*/



			document.addEventListener('DOMContentLoaded', function () {
				let data = {
					surveyNo: surveyNo,
				};

				$.ajax({
					url: "/admin/survey/percent",
					data: JSON.stringify(data),
					contentType: "application/json;charset=utf-8",
					type: "post",
					dataType: "json",
					beforeSend: function (xhr) {
						xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
					},
					success: function (res) {
						let percentArea = document.getElementById("progress");
						var progressPercentElement = document.querySelector(".progressPercent");

						// 내용 변경
						console.log("percetArea ----> ", percentArea);
						console.log("퍼센트 ------>", res);
						progressPercentElement.textContent = res + "%";
						percentArea.style.width = res + "%";

					},
				});
			});








		</script>
		<style>
			.chart-container {
				margin: 0 auto;
				/* 가운데 정렬 */
				height: 80%;
			}
		</style>
		<!DOCTYPE html>



		<div class="wf-main-container">
			<!-- =============== body 시작 =============== -->
			<!-- =============== 상단타이틀영역 시작 =============== -->
			<div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
				<h1 class="page-tit">설문조사 상세</h1>
				<div class="side-util">
					
					<button type="button" class="btn4" onclick="location.href='/admin/survey/list'"
						id="go list">목록</button>
					<button type="button" class="btn3" id="deleteSurvey">삭제</button>
				</div>
			</div>
			<!-- =============== 상단타이틀영역 끝 =============== -->
			<!-- =============== 컨텐츠 영역 시작 =============== -->
			<div class="wf-content-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">
				<div class="wf-content-area"">
			<p class=" heading1">${surveyVO.surveyTitle}</p>
					<ul>
						<div class="wf-content-box">
							<div class="wf-flex-box">
								<div class="wf-content-box" style="flex: 1;">
									<p class="heading2">설문조사 진행상황</p>
									<div class="wf-flex-box wf-content-box progressBar" id="progress"
										style="width: 90%">
										<p class="progressPercent">90%</p>
									</div>
								</div>
								<div class="wf-content-box">
									<div>
										<p class="box-heading1">설문 조사 시작일</p>
										<c:set var="openDate" value="${surveyVO.surveyOpenDate.substring(0, 10)}" />
										<p>${openDate}</p>
										<br> <br>
										<p class="box-heading1">설문 조사 종료일</p>
										<c:set var="endDate" value="${surveyVO.surveyEndDate.substring(0, 10)}" />
										<p>${endDate}</p>
									</div>
								</div>
								<div class="wf-content-box" style="height:160px; overflow:auto;">
									<div>
										<p class="box-heading1">설문 조사 참여 인원</p>
										<c:if test="${surveyVO.surveyAnonyCd =='N'}">
											<c:forEach var="particVO" items="${surveyParticVOList}" varStatus="stat">
												<c:if test="${particVO.rspnsblCtgryNm =='팀원'}">
													<p class="box-heading3">${particVO.empNm}
														${particVO.cmmnCdNm}</p>
												</c:if>
												<c:if test="${particVO.rspnsblCtgryNm != '팀원'}">
													<p class="box-heading3">${particVO.empNm}
														${particVO.rspnsblCtgryNm }</p>
												</c:if>
											</c:forEach>
										</c:if>
										<c:if test="${surveyVO.surveyAnonyCd =='Y'}">
											<p class="box-heading3">익명 설문조사입니다.</p>
										</c:if>
									</div>
								</div>
							</div>
						</div>
					</ul>
				</div>

				<!--메인 컨텐츠-->
				<div class="wf-content-wrap">
					<div class="wf-content-area box2" id="inputArea">
						<!--//////////입력 지역///////////////////-->
						<!--//////////입력 지역 끝///////////////////-->
					</div>
				</div>
				<!-- =============== 컨텐츠 영역 끝 =============== -->
			</div>
			<!-- =============== body 끝 =============== -->
		</div>
		<!-- -------------- body 끝 -------------- -->
		</div>