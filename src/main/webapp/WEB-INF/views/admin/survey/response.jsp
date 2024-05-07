<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
	
		<style>
			.wf-main-container {
				width: 100%;
			}

			.wf-mail-wrap {
				height: 100%;
				width: 95%;
			}

			.wf-content-area {
				height: 100%;
			}

			.wf-table {
				font-size: 0.7rem;
				/* 원하는 크기로 조정 */
				overflow-x: auto;
			}

			#jstree {
				font-size: 0.7rem;
				/* 원하는 크기로 조정 */
			}

			.jstree-anchor {
				font-size: 0.7rem;
				/* 원하는 크기로 조정 */
			}

			#modal-test {
				width: 200px;
				height: 150px;
				background-color: #ffffff;
				border: 1px solid #ccc;
				position: fixed;
				bottom: 10px;
				right: 10px;
				z-index: 1000;
			}
			
			.heading1{
				margin-bottom:5px;
			}
			
			
			
			
		</style>

		<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
		<script src="/resources/js/jquery.serializeObject.min.js"></script>
		<script>
			//aside랑 header 없애는 스크립트 없애면 바로나옴
			let realSize = window.innerWidth;
			let realHeight = window.innerHeight;
			let empNo = <%=session.getAttribute("empNo") %> + "";
			let empNm = "";
			let chatRoomNo = "0";
			/* let empNo = ${empNo} + ""; */
			let chatAddOrInvite = "";	// 모달창 타겟이 기존 채팅방에 초대인지 새로운 채팅방 생성인지 구분
			let chatRoomEmpList = [];
			let chatRoomEmpListTemp = []; // 일단 임시저장해뒀다가 필요할때 chatRoomEmpList로 덮어씌우기용도
			$("body").css("width", realSize)
			window.addEventListener("resize", function () {
				realSize = window.innerWidth;
				realHeight = window.innerHeight;
				$("body").css("width", realSize)
				$("body").css("height", realHeight)
			})
			$("header").html("")
			$("header").css("height", "0px")
			$("aside").html("")
			$("aside").css("width", "0px")
			$.ajax({
				url: "/chat/getEmp",
				data: { "empNo": empNo },
				type: "get",
				contentType: "application/x-www-form-urlencoded; charset=UTF-8",
				success: function (res) {
					empNm = res.empNm
				}
			})
		</script>
		<script>
			let __count = 1;

			$(() => {
				questionList();
			});


			function questionList() {
				let surveyNo = "${surveyDetail.surveyNo}";
				console.log("surveyNo--->",surveyNo);
				let data = {
					surveyNo: surveyNo,
				};
				let QuestionArea = document.getElementsByClassName("surveyQuestion");
				console.log("QuestionArea--->",QuestionArea);
				$.ajax({
					url: "/admin/survey/getQuest",
					data: JSON.stringify(data),
					contentType: "application/json;charset=utf-8",
					type: "post",
					dataType: "json",
					beforeSend: function (xhr) {
						xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
					},
					success: function (res) {
						console.log("res----->",res);
						//{surveyNo: '25', surveyQuestionNo: '30', surveyQuestionTypeCd: '1', surveyQuestionSj: '11111111111', surveyQuestionId: '1'}
						// 0[ surveyChoiceNo: "20",surveyChoiceSj: null,surveyNo: "25",surveyQuestionId: "1",surveySj: "1111ㅁ" ]
						let ChoiceList = res.SurveyChoiceVOList;
						console.log("ChoiceList--->",ChoiceList);
						// 1[ surveyChoiceNo: "21",surveyChoiceSj: null ,surveyNo: "25",surveyQuestionId: "1",surveySj: "1111ㄴ"]

						let str = "";
						for (let i = 0; i < res.SurveyQuestionVOList.length; i++) {
							console.log("i--->",i);
							str += getQuestCode(res.SurveyQuestionVOList[i].surveyQuestionTypeCd, res.SurveyQuestionVOList[i].surveyQuestionSj, res.SurveyQuestionVOList[i].surveyQuestionId, ChoiceList,i);
						}
						QuestionArea[0].innerHTML += str;
					},
				});



			}

			// 질문 유형 코드 넣으면 형식 return 시킴
			function getQuestCode(cd, surveyQuestionSj, surveyQuestionId, choiceList,r) {
				let str = "";
				//1 중복 불가
				if (cd == 1 || cd == 2) {
					let count2 = 1;
					let cnt = count2 -1;
					str += "<div>";
					str += "<p class='heading1'> " + surveyQuestionId + "." + surveyQuestionSj + "</p>";
					str += "<ul class='checkbox-radio-custom'>";
					str += "<input type='hidden' name='surveyQuestionId' value='"+surveyQuestionId+"' />";
					
					//질문지 계수에 따라 ex) 9번 for문
					for (let i = 0; i < choiceList.length; i++) {
						//질문번호가 같다면 
						if (choiceList[i].surveyQuestionId == surveyQuestionId) {
							if (cd == 1) {
								str += "<li>";
								str += "<input type='radio' name='ResponseResult_"+r+"' value='"+count2+"'  id='radio" + __count + "' data-info='"+choiceList[i].surveyChoiceNo+"'>";
								str += "<label for='radio" + __count + "'>" + choiceList[i].surveySj + "</label>";
								str += "</li>";
								__count++;
								count2++;
								
							} else if (cd == 2) {
								//중복가능
								str += "<li>";
								str += "<input type='checkbox' name='ResponseResult_"+r+"' value='"+count2+"' id='ch" + __count + "' data-info='"+choiceList[i].surveyChoiceNo+"'>";
								str += "<label for='ch" + __count + "'>" + choiceList[i].surveySj + "</label>";
								//str += "<input type='hidden' name='surveyChoiceNo' value='"+choiceList[i].surveyChoiceNo+"'/>";
								str += "</li>";
								__count++;
								count2++;
								cnt ++;
							}
						}

					}
					str += "</ul>";
					str += "</div>";
				}
				
				// 서술
				else if (cd == 3) {
					str += "<div>";
					str += "<p class='heading1'>" + surveyQuestionId + "." + surveyQuestionSj + "</p>";
					str += "<ul class='wf-insert-form'>";
					str += "<li>";
					str += "<label>답변</label>";
					str += "<input type='hidden' name='surveyQuestionId' value='"+surveyQuestionId+"' />";
					str += "<input name='ResponseResult_"+r+"' id='' placeholder='텍스트틀 입력해주세요' />";
					str += "</li>";
					str += "</ul>";
					str += "</div>";
					__count++;
				}
				
				return str;
			}

			$(document).ready(function () {
            $("#submitBtn").click(function () {

				var selectedValues = [];
				var inputs = document.querySelectorAll('input[name^="ResponseResult_"]');
				inputs.forEach(function(input) {
					if (input.checked) {
						selectedValues.push(input.dataset.info);
					}
				});
				// 사용자가 선택한 질문 번호
				console.log(selectedValues);

                // 폼 데이터를 JSON 형식으로 직렬화
                var formData = $("#signup").serializeArray();
                var jsonData = {};

				var jsonData = $('form#signup').serializeObject();
				// { 1:[답변],2:[답변,답변,답변] }
				


                // JSON 데이터 출력 (콘솔 또는 다른 작업에 사용)
                console.log("jsonData : " + JSON.stringify(jsonData));
				var responseResult = jsonData["ResponseResult[2]"];
				/*
				jsonData : {"surveyNo":"27","surveyResponEmpNo":"2019001"
				,"surveyQuestionId":["1","2","3","4"]
				,"ResponseResult_0":"1","ResponseResult_1":["2","3"],"ResponseResult_2":["1","2"],"ResponseResult_3":["1","3"]}
				*/

				var responseResult = [];

				var questionLength = jsonData.surveyQuestionId.length;
				console.log("질문의 계수(길이)"+questionLength);
				console.log("체크-------> ", jsonData["surveyNo"]);
				console.log("체크--->",jsonData["ResponseResult_1"]);


				for(var i = 0 ; i < questionLength ;i++){
					responseResult[i] = []; // 새로운 배열을 만들어 요소에 할당
					responseResult[i] = jsonData["ResponseResult_"+i];
				}

				jsonData.responseResult = responseResult;

				console.log("추가한 json ---> ",jsonData);
				
				jsonData.choiceNo = selectedValues;

				$.ajax({
					url: "/admin/survey/createResponse",
					data: JSON.stringify(jsonData),
					contentType: "application/json;charset=utf-8",
					type: "post",
					dataType: "json",
					beforeSend: function (xhr) {
						xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
					},
					success: function (res) {
						console.log(res);
						window.close();
					},
				});
				



            });
        });
		</script>
		<form  id="signup" method="post" enctype="multipart/form-data">
			<div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
				<h1 class="page-tit">[${surveyDetail.surveyTitle}]</h1>
				<input type = "hidden" name= "surveyNo" value="${surveyDetail.surveyNo }" />
				<input type = "hidden" name="surveyResponEmpNo" value="<%=session.getAttribute("empNo")%>" />
				<div class="wf-util">
					<button type="button" id="submitBtn" class="btn2">등록</button>
				</div>
			</div>

			<div class="wf-mail-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">
				<div style="width: 100%;">
					<div class="wf-content-area surveyQuestion" style="float: left; width: 105%; overflow-y: auto;">
					</div>
					<div class="wf-mail-right" style="float: right; width: 60%; overflow-x: auto;">
					</div>
				</div>

			</div>
		</form>
		<script type="text/javascript">

		</script>