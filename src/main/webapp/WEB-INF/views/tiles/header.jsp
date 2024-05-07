<%@page import="org.springframework.beans.factory.annotation.Autowired" %>
	<%@page import="com.team1.workforest.employee.service.EmployeeService" %>
		<%@page import="com.team1.workforest.employee.vo.EmployeeVO" %>
			<%@ page language="java" contentType="text/html; charset=UTF-8" %>
				<%@ include file="/WEB-INF/views/tiles/taglib.jsp" %>
					<script src="/resources/script/project/glance.js"></script>
					<script>
						let headerEmpNo = <%=session.getAttribute("empNo") %>
					</script>
					<script src="/resources/js/header_chatting.js"></script>
					<script src="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.3.15/jstree.min.js"></script>
					<link rel="stylesheet"
						href="https://cdnjs.cloudflare.com/ajax/libs/jstree/3.3.15/themes/default/style.min.css" />
					<script src="/resources/js/weather.js"></script>
					<link rel="stylesheet" href="/resources/css/weather.css" />

					<script>

							function openPopup() {
								window.open('/emp/tree', '_blank', 'width=800,height=600');
							}

						// js에서는 스크립틀릿을 쓸수없어서 jsp에서 받아온다.
						let proflImageUrl = "${proflImageUrl}";


    function openPopup() {
        window.open('/emp/tree', '_blank', 'width=1500,height=600');
    }

						$(document).ready(function () {
							// checkedMenuNos를 전역 변수로 선언
							var checkedMenuNos = [];
							selectGlance();


							$("#dsbrdSetBtn").click(function () {

								//파라미터 1 주기
								window.location.href = "/home?drag=1";
							});



							var isQuickMenuActive = false;

							$("#quickBtn").on("click", function () {
								if (!isQuickMenuActive) {
									$(".quick-menu-area").addClass("active");
									$("#glanceIcons").css("display", "block");
								} else {
									$(".quick-menu-area").removeClass("active");
									$("#glanceIcons").css("display", "none");
								}

								isQuickMenuActive = !isQuickMenuActive;
							});

							$('#jstree1').on('select_node.jstree', function (e, data) {
								e.preventDefault();
								console.log("jstree 시작");

								var checkedNodes = $('#jstree1').jstree(true).get_checked();
								// checkedMenuNos를 초기화한 후 선택된 노드들의 menuNo를 다시 할당
								checkedMenuNos = checkedNodes.map(function (nodeId) {
									var node = $('#jstree1').jstree(true).get_node(nodeId);
									return node.id;
								});
							});

							// 초기화버튼 클릭 이벤트 핸들러
							$("#resetGlanceBtn").on("click", function () {
								$('#jstree1').jstree(true).deselect_all();
								// checkedMenuNos를 빈 배열로 초기화
								checkedMenuNos = [];
							});

							// 바로가기 생성 버튼 클릭 이벤트 핸들러
							$("#insertGlanceBtn").on("click", function () {
								console.log(checkedMenuNos);
								if (checkedMenuNos.length > 4 || checkedMenuNos.length < 1) {
									console.log("선택을 안했거나 4개이상 선택 불가능합니다");
									checkedMenuNos = [];
									$('#jstree1').jstree(true).deselect_all();
									return;
								}

								/*       let glanNm=$("#glanceName").val();
									  console.log("glanNm" + glanNm);
									  if(glanNm == '') {
										  console.log("바로가기 명을 적어주세요");
										  return;
									  } */
								let numToExtract = Math.min(4, checkedMenuNos.length);
								let data = {
									"menuNos": checkedMenuNos.slice(-numToExtract),
									"empNo": headerEmpNo,
									"glanNm": "바로가기1"
								};
								console.log("data", data);
								$.ajax({
									url: "/menu/insertGlance",
									data: JSON.stringify(data),
									contentType: "application/json;charset=utf-8",
									type: "post",
									dataType: "json",
									beforeSend: function (xhr) {
										xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
									},
									success: function (res) {
										if (res > 0) {
											$('.modal').removeClass('open');
											$('html').removeClass('scroll-hidden');
											$('#jstree1').jstree(true).deselect_all();
											location.reload();
										}
									}
								});
							});
						});

						function selectGlance() {
							let data = {
								"empNo": headerEmpNo,
								"glanNm": "바로가기1"
							};
							$.ajax({
								url: "/menu/selectGlance",
								data: JSON.stringify(data),
								contentType: "application/json;charset=utf-8",
								type: "post",
								dataType: "json",
								beforeSend: function (xhr) {
									xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
								},
								success: function (res) {
									let str = '';
									res.forEach(function (item) {
										$("#glanceIcons").html('');
										str += `<p>
    			 <a href="\${item.pageUrl}">
    			 	<i class="\${item.menuIcon}"></i>
         			<span class="tit">\${item.menuNm}</span>
     		  	 </a>
     		  </p>`;
									})
									$("#glanceIcons").html(str);
								}
							});
						};
						
						
						////// 설문조사
						
						$(() => {
							getSurveyNum();
							getSurveyList();

							$(document).on("click", ".surveyDetail", function () {
								console.log("체크");
								console.log("this----> ", this);
								let surveyNo = $(this).data("surveyNo");
								console.log("surveyNo--->", surveyNo);


								let url = "/admin/survey/response?surveyNo=" + surveyNo
								let name = "설문조사"
								let option = "width = 800, height = 800, left=2000, location=no, toolbars=no, status=no"
								let newWindow = window.open(url, name, option);

								// 새 창이 닫힐 때 이벤트 처리
								// 일정 시간마다 새 창이 닫혔는지 확인
								let checkInterval = setInterval(function () {
									if (newWindow.closed) {
										console.log("새 창이 닫혔습니다.");
										clearInterval(checkInterval); // 확인하는 인터벌 제거
										getSurveyList();
										getSurveyNum();
									}
								}, 500); // 1초마다 확인
							});





						});
						//설문조사 계수구하는 함수
						function getSurveyNum() {
							let surveyParticNo = headerEmpNo;
							console.log("surveyParticNo----->", surveyParticNo);
							let surveyListArea = document.getElementById("surveyList");
							console.log("surveyListArea ----> ", surveyListArea);
							let data = {
								surveyParticNo: surveyParticNo,
							};
							$.ajax({
								url: "/admin/survey/getSurveyNum",
								data: JSON.stringify(data),
								contentType: "application/json;charset=utf-8",
								type: "post",
								dataType: "json",
								beforeSend: function (xhr) {
									xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
								},
								success: function (res) {
									let spanArea = document.getElementById("surveyNum");
									if (res > 0) {
										spanArea.textContent = res;
										spanArea.style.display="flex";
									}
									else {
										spanArea.style.display="none";	
									}
								},
							});

						}

						function getSurveyList() {
								let surveyParticNo = headerEmpNo;
								let surveyListArea = document.getElementById("surveyList");
								let data = {
									surveyParticNo: surveyParticNo,
								};
								$.ajax({
									url: "/admin/survey/header/list",
									data: JSON.stringify(data),
									contentType: "application/json;charset=utf-8",
									type: "post",
									dataType: "json",
									beforeSend: function (xhr) {
										xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
									},
									success: function (res) {
										let str = "";
										if (res.length == 0) {
											str += "<li>";
											str += "<p>참여할 설문조사가 없습니다</p>";
											str += "</li>";
										} else {
											for (let i = 0; i < res.length; i++) {
												str += "<li>";
												str += "<p class='tit surveyDetail' data-survey-no='" + res[i].surveyNo + "'  >" + res[i].surveyTitle + "</p>";
												str += "<p>";
												str += "<span class='date'>" + res[i].surveyOpenDate + "</span>";
												str += "<span class='employee'>" + res[i].empNm + " " + res[i].cmmnCdNm + "</span>";
												str += "</p>";
												str += "</li>";
											}
										}
										surveyListArea.innerHTML = str;

									},
								});
							}

					</script>

					<header class="custom">
						<a href="/home" class="logo">WORKFOREST</a>
						<p class="header-txt">${empNm}님, 오늘도 힘차게 화이팅하세요! </p>
						<button class="btn2" id="settingBtn" style="display: none;">저장</button>
						<div class="weather_icon"></div>
						<ul class="wf-util">
							<li>
								<a href="javascript:void(0)" title="조직도" onclick="openPopup()">
									<i class="xi-group"></i>
								</a>
							</li>
							<li>
								<a href="javascript:void(0)" title="채팅">
									<i class="xi-wechat"></i>
								</a>
							</li>
							<li>
								<a href="javascript:void(0)" title="설문">
									<i class="xi-document"><span class="note-num" id="surveyNum">3</span></i>
								</a>
								<div class="wf-menu-dropdown">
									<ul class="alarm-list">
										<ul class="alarm-list" id="surveyList">
										</ul>
									</ul>
								</div>
								<!-------------------설문조사 끝-------------->
							</li>
							<li>
								<a href="javascript:void(0)" title="알림">
									<i class="xi-bell"><span class="note-num1"></span></i>
								</a>
								<div class="wf-menu-dropdown">
									<ul class="alarm-list getAlram">
										<!-- 	                  <li> -->
										<%-- <img src="/resources/img/icon/${proflImageUrl}" class="user-img" /> --%>
										<!-- 	                      <div> -->
										<!-- 	                          <span class="tit">[일정등록]'주간회의' 일정이 등록되었습니다.</span> -->
										<!-- 	                          <p> -->
										<!-- 	                              <span class="date">2024-03-03 11:30</span> -->
										<!-- 	                          </p> -->
										<!-- 	                      </div> -->
										<!-- 	                  </li> -->
										<!-- 	                  <li> -->
										<%-- <img src="/resources/img/icon/${proflImageUrl}" class="user-img" /> --%>
										<!-- 	                      <div> -->
										<!-- 	                          <span class="tit">[일정등록]'주간회의' 일정이 등록되었습니다.</span> -->
										<!-- 	                          <p> -->
										<!-- 	                              <span class="date">2024-03-03 11:30</span> -->
										<!-- 	                              <span class="employee">양연주 사장</span> -->
										<!-- 	                          </p> -->
										<!-- 	                      </div> -->
										<!-- 	                  </li> -->
									</ul>
								</div>
							</li>
							<li>
								<a href="javascript:void(0)" title="설정">
									<i class="xi-cog"></i>
									<div class="wf-menu-dropdown" style="min-width: max-content; padding:auto 20px;">
										<a class="menu-tit" href="#" modal-id="modal-user-alram">알림 설정</a>
										<a class="menu-tit" href="#" modal-id="modal-glance">바로가기 설정</a>
										<a class="menu-tit" href="#" id="dsbrdSetBtn">대시보드 설정</a>
									</div>
								</a>
							</li>
							<li>
								<a href="javascript:void(0)" class="user-img-icon" title="사용자">
									<img src="/resources/img/icon/${proflImageUrl}" class="user-img" />
								</a>
								<div class="wf-menu-dropdown">
									<div class="wf-flex-box center">
										<img src="/resources/img/icon/${proflImageUrl}" class="user-img" />

										<div>
<%-- 											<span class="user-info">${deptNm}</span> --%>
											<sec:authorize access="${empNo != '2018001'}">
                    <span class="user-info">${deptNm}</span>
                </sec:authorize>
											<span class="user-name">${empNm} ${rspnsblCtgryNm}</span>
										</div>
									</div>
									<div class="menu-wrap">
										<a href="/emp/detailLogin" + class="menu-tit my-profile">내 프로필</a>
										<form id="logoutForm" action="/logout" method="post">
											<sec:csrfInput />
										</form>
										<a href="#" class="menu-tit logout" onclick="logout()">로그아웃</a>
										<script>
											function logout() {
												event.preventDefault(); //a 태그 동작 막기
												document.querySelector("#logoutForm").submit();
											}
										</script>

									</div>
								</div>
							</li>
						</ul>

						<!-- ////////////////////// 바로가기 설정 모달 창////////////////////// -->
						<div class="modal" id="modal-glance">
							<div class="modal-cont">
								<h1 class="modal-tit">바로가기 설정</h1>
								<br />
								<div class="wf-flex-box"></div>
								<div class="modal-content-area">
									<div id='jstree1'></div>
									<br />
								</div>
								<div class="modal-btn-wrap">
									<button class="btn6" id='resetGlanceBtn'>초기화</button>
									<button class="btn2" id='insertGlanceBtn'>바로가기 생성</button>
								</div>

								<button class="close-btn"></button>
							</div>
						</div>
						<!-- ////////////////////// 바로가기 설정 모달 창 끝////////////////////// -->

						<!-- 퀵메뉴 -->
						<div class="quick-menu-area">
							<button class="quickBtn" id="quickBtn"><i class="xi-plus"></i></button>
							<div id="glanceIcons"></div>
						</div>

					</header>


					<div class="modal" id="modal-user-alram">
						<div class="modal-cont">
							<div class="user-alram">
								<div class="myAlarmSetUp">
									<ul class="checkbox-radio-custom myAlarmSetUpUl">
									</ul>
								</div>
							</div>
							<button class="close-btn"></button>
						</div>
					</div>