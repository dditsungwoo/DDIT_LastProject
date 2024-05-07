<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

	<script>





		$(() => {
			getSurveyList(1,"","","");
			$("#ingBar").on("click", function () {		//진행중
				getSurveyList(1, "","" ,"1");
			})
			$("#doneBar").on("click", function () {	//완료
				getSurveyList(1, "","" ,"2");
			})
			$(".totalBar").on("click", function () {	//전체 리스트
				getSurveyList(1, "" ,"", "");
			});





		});






		function getSurveyList(currentPage, keyword ,searchOption,surveyCompleteCd ) {
			//json 오브젝트
			let data = {
				"currentPage": currentPage,
				"keyword": keyword,
				"searchOption":searchOption,
				"surveyCompleteCd":surveyCompleteCd,
			};

			console.log("data : ", data);

			$.ajax({
				url: "/admin/survey/getSurveyList",
				contentType: "application/json;charset=utf-8",
				data: JSON.stringify(data),
				type: "post",
				dataType: "json",
				beforeSend: function (xhr) {
					xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
				},
				success: function (result) {
					console.log("result --->",result.content);
					
					
					let str = "";
					
					let tid = "#tabId" + surveyCompleteCd;
					console.log("tid ---> ",tid);
					
					// 목록을 초기화
					$(tid).html("");
					console.log("result", result);
					str += "<table class='wf-table'>";
					str += "<colgroup><col style='width: 5%;'><col style='width: 15%;'>";
					str += "<col style='width: 40%;'><col style='width: 15%;'>";
					str += "<col style='width: 15%;'><col style='width: 15%;'>";
					str += "</colgroup><thead><tr>";
					str += "<th>번호</th><th>진행상태</th><th>설문 문항</th><th>작성자</th><th>설문조사 시작일</th><th>설문조사 마감일</th>";
					str += "</tr></thead><tbody>";

					$.each(result.content, function (idx, vo) {
						//console.log(_prgBadge[vo.prgsRate]);
						//console.log(vo.cnfirmDate);
						//var isNew = vo.cnfirmDate.length != 10 ? "<badge class='wf-badge3'>new</badge>" : "";
						str += "<tr class='surveyLists' data-duty-no='" + vo.surveyNo + "' "; 
						str += "onclick=\"location.href='/admin/survey/list/detail?surveyNo=" + vo.surveyNo + "'\">";
						str += "<td><p>"+vo.rnum+"</p></td>";

						if(vo.surveyCompleteCd == 1){
							str += "<td><span class='wf-badge1'>진행중</span></td>";
						}else{
							str += "<td><span class='wf-badge2'>완료</span></td>";
						}
						str += "<td><p>" + vo.surveyTitle +"</p></td>";
						str += "<td><p>" + vo.empNm + "</p></td>";
						let openDate = vo.surveyOpenDate.substr(0,10);
						str += "<td><p>" + openDate + "</p></td>";
						let endDate = vo.surveyEndDate.substr(0,10);
						str += "<td><p>" + endDate + "</p></td></tr>";
					});
					str += "</tbody></table>";
					str += result.pagingArea;
					str += "<div class='wf-search-area'>";
					str += "<div class='select-box'>";
					str += "<select name='searchOption' id='searchOption'>";
					str += "<option value='title' selected>제목</option>";
					str += "<option value='titlecontent'>제목+내용</option>";
					str += "<option value='empNm'>작성자</option>";
					str += "</select>";
					str += "</div>";
					str += "<input type='text' id='keyword' name='keyword' placeholder='검색할 내용을 입력해주세요' value='${param.keyword}' />";
					str += "<button type='button' id='btnSearch' class='btn4'>";
					str += "<i class='xi-search'>";
					str += "</i>";
					str += "</button>";
					str += "</div>";
					$(tid).append(str);
					
				}
			});
		} //getDutyList 끝--------------------------------------------









	</script>






	<!-- 메인 컨텐츠  -->
	<div class="wf-main-container">
		<!-- =============== 상단타이틀영역 시작 =============== -->
		<div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
			<h1 class="page-tit">설문조사</h1>
			 <button type="button" class="btn2" id="insertBtn" onclick="location.href='/admin/survey/insert'">
                        		등록</button>
		</div>
		<!-- 컨텐츠 영역 시작     -->
		<!-- =============== 컨텐츠 영역 시작 =============== -->
		<div class="wf-content-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">
			<!-- Tab영역 -->
			<div class="wf-content-area">
				<div class="tab-type tab-type1">
					<div class="wf-flex-box between">
						<div class="tab-menu">
							<button data-tab="tab1" type="button" class="tab-btn active totalBar">전체</button>
							<button data-tab="tab2" type="button" class="tab-btn" id="ingBar">진행중</button>
							<button data-tab="tab3" type="button" class="tab-btn" id="doneBar">완료</button>
							<div class="tab-indicator" style="width: 140px; transform: translateX(0px);"></div>
						</div>
					</div>

					<!-- tab1  -->
					<div data-tab="tab1" class="tab-content active ">
						<div class="tab-board-lst">
							<div id="tabId"></div>
						</div>
					</div>

					<!-- tab2  -->
					<div data-tab="tab2" class="tab-content">
						<div class="tab-board-lst">
							 <div id="tabId1"></div> 
						</div>
					</div>

					<!-- tab3  -->
					<div data-tab="tab3" class="tab-content">
						<div class="tab-board-lst">
							<div id="tabId2"></div>
						</div>
					</div>
				</div>

			</div>
		</div>
		<!-- =============== 컨텐츠 영역 끝 =============== -->
	</div>