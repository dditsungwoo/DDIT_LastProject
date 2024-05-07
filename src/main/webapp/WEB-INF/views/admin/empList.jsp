<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec"
   uri="http://www.springframework.org/security/tags"%>
<style>
#ui-id-1 {
   z-index: 100000;
}

.swal2-container {
   z-index: 100000;
}

</style>
<script type="text/javascript">
            $(function () {
               //검색
               $("#btnSearch").on(
                  "click",
                  function () {
                     let searchOption = $("#searchOption").val();
                     let keyword = $.trim($("input[name='keyword']").val());

                     console.log("searchOption: " + searchOption);
                     console.log("keyword : " + keyword);

                     //검색 시 페이지번호는 1로 초기화
                     let currentPage = "1";

                     //json 오브젝트
                     let data = {
                        "searchOption": searchOption,
                        "keyword": keyword,
                        "currentPage": currentPage
                     };

                     console.log("data : ", data);

                     $.ajax({
                        url: "/emp/list",
                        contentType: "application/json;charset=utf-8",
                        data: JSON.stringify(data),
                        type: "post",
                        dataType: "json",
                        beforeSend: function (xhr) {
                           xhr.setRequestHeader("${_csrf.headerName}",
                              "${_csrf.token}");
                        },
                        success: function (result) {
                           console.log("result : ", result);

                           let str = "";
                           let studPwStr = "";

                           // 목록을 초기화
                           $("#empTBody").html("");

                           $.each(result.content, function (idx, empVO) {
                              console.log("empVO[" + idx + "] : ", empVO);
                              str += "<tr>";
                              str += "<td>" + empVO.rnum + "</td>";
                              str += "<td>" + empVO.empNo + "</td>";
                              str += "<td>" + empVO.workSeCd + "</td>";
                              str += "<td>" + empVO.empNm + "</td>";
                              str += "<td>" + empVO.workLocation + "</td>";
                              str += "<td>" + empVO.lxtn + "</td>";
                              str += "<td>" + empVO.cntcNo + "</td>";
                              str += "<td>" + empVO.deptNm + "</td>";
                              str += "<td>" + empVO.position + "</td>";
                              str += "<td>" + empVO.rspnsblCtgryNm + "</td>";
                              str += "<td>" + empVO.email + "</td>";
                              str += "</tr>";
                           });

                           $("#empTBody").append(str);

                           //페이징 처리
                           $("#divPaging").html(result.pagingArea);

                        }
                     });
                  });
            });

            //excel 시작====================================
            //excel 파일로 양식 폼 다운로드, 업로드
            document.addEventListener("DOMContentLoaded", function () {
               // Excel 파일 업로드 링크 클릭 시
               document.querySelector('.xi-upload').addEventListener('click',
                  function (event) {
                     event.preventDefault(); // 기본 이벤트 실행 방지

                     // 파일 입력 필드 클릭
                     document.getElementById('fileInput').click();
                  });

               // 파일 선택 시
               document.getElementById('fileInput').addEventListener('change',
                  function () {
                     // 파일이 선택되었을 때 파일 업로드 폼 제출
                     document.getElementById('uploadForm').submit();
                     //alert("등록 성공");
                      Swal.fire({
                              title: _msg.employee.uploadSuccessAlert,
                              text: "",
                              icon: "success"
                            });
                  });
            });
            //excel 끝====================================
            //모달 시작===================================
            // 예약 등록(추가) 버튼 클릭하면 모달 표시
            $("#createBtn").on("click", function () {

               $("#empAddModal").show();


            });
            //모달 끝===================================



         </script>
<!-- =============== body 시작 =============== -->
<div class="wf-main-container">
   <!-- =============== 상단타이틀영역 시작 =============== -->
   <div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
      <h1 class="page-tit">조직 관리</h1>

      <ul class="wf-util">
         <li>
            <a href="javascript:void(0)" class="btn5">사원 등록 </a>
            <div class="wf-menu-dropdown" style="margin-right:22px;">

               <a href="#" modal-id="empAddModal"><i class="xi-plus">사원 등록</i></a>
               <hr>
               <a href="#"><i class="xi-upload"> Excel파일로 사원 등록</i></a><br> <br>
               <form id="empForm" action="/excel/empFormDownload" method="get">
                  (&nbsp;&nbsp;<i class="xi-tag"></i>
                  <!--                <a href="/excel/empFormDownload" id="downloadLink"> 양식 다운로드</a> -->

                  <button type="button" id="downloadLink">양식 다운로드</button>

                  &nbsp;&nbsp;)
                  
                  
                  <sec:csrfInput />
               </form>
            </div>
         </li>
         <li>
          <button type="button" class="btn5" modal-id="empUpdModal">재직
			구분 변경</button>
         </li>
        
      </ul>
        
   </div>
   <!-- =============== 상단타이틀영역 끝 =============== -->


   <!--  excel 다운로드 시작 -->
   <form id="empForm" action="/excel/empFormDownload" method="get">
      <!--                         <button type="submit" class="btn5">Excel양식 다운로드<i class="xi-download"></i></button> -->
      <sec:csrfInput />
   </form>
   <!--  excel 다운로드 끝 -->
   <!--  excel 업로드 시작 -->
   <form id="uploadForm" action="/excel/empupload" method="post"
      enctype="multipart/form-data">
      <input type="file" id="fileInput" name="file" style="display: none;" />
      <!--                   <button type="button" id="fileSelectBtn" class="btn5">Excel파일 업로드 <i class="xi-upload"></i></button> -->
      <!--                <button type="submit" id="confirmBtn" class="btn5" style="display: none;">확인</button> -->
      <sec:csrfInput />
   </form>
   <!--  excel 업로드 끝 -->
   <br>

   <!-- =============== 컨텐츠 영역 시작 =============== -->
   <div class="wf-content-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">
      <div class="wf-content-area">
         <table class="wf-table">
            <colgroup>
               <col style="width: 5%;">
               <col style="width: 9%;">
               <col style="width: 8%;">
               <col style="width: 8%;">
               <col style="width: 9%;">
               <col style="width: 12%;">
               <col style="width: 12%;">
               <col style="width: 9%;">
               <col style="width: 9%;">
               <col style="width: 9%;">
               <col style="width: 10%;">
            </colgroup>
            <thead>
               <tr>
                  <th>번호</th>
                  <th>사원번호</th>
                  <th>재직구분</th>
                  <th>사원명</th>
                  <th>근무지역</th>
                  <th>내선번호</th>
                  <th>개인 연락처</th>
                  <th>부서명</th>
                  <th>직책</th>
                  <th>직급</th>
                  <th>이메일주소</th>
               </tr>
            </thead>
            <tbody id="empTBody">
               <c:forEach var="empVO" items="${data.content}" varStatus="stat">
                  <tr>


                     <td>${empVO.rnum}</td>
                     <td>${empVO.empNo}</td>
                     <td>${empVO.workSeCd}</td>
                     <td>${empVO.empNm}</td>
                     <td>${empVO.workLocation}</td>
                     <td>${empVO.lxtn}</td>
                     <td>${empVO.cntcNo}</td>
                     <td>${empVO.deptNm}</td>
                     <td>${empVO.position}</td>
                     <td>${empVO.rspnsblCtgryNm}</td>
                     <td>${empVO.email}</td>
                  </tr>
               </c:forEach>
            </tbody>
         </table>
      </div>
      <br>
      <div class="row justify-content-center" id="divPaging">
         <!-- 페이지네이션 시작 -->
         ${data.getPagingArea()}
         <!-- 페이지네이션 끝 -->
      </div>
      <!-- 검색 시작 -->
      <div class="wf-search-area">
         <div class="select-box">
            <select name="searchOption" id="searchOption">
               <option value="empNm">사원명</option>
               <option value="deptNm">부서명</option>
               <option value="workLocation">근무지역</option>
               <option value="workSeCdNm">재직구분</option>
            </select>
         </div>
         <input type="text" name="keyword" id="keyword"
            placeholder="검색어를 입력해주세요">
         <button type="button" class="btn4" id="btnSearch">
            <i class="xi-search"></i>
         </button>
      </div>
      <!-- 검색 끝 -->
   </div>
   <!-- =============== 컨텐츠 영역 끝 =============== -->
</div>
<!-- =============== body 끝 =============== -->

<!--------------------------------- 사원 등록 모달 시작 --------------------------------->
<div class="modal" id="empAddModal">
   <div class="modal-cont">
      <h1 class="modal-tit" id="modalTit">사원등록</h1>
      <div class="modal-content-area">
         <div class="wf-flex-box">
            <form id="empAddForm" action="/admin/addEmp" method="post">
               <ul class="wf-insert-form">
                  <li><label for="empNo">사원번호<i class="i">*</i></label>
                     <div>
                        <input type="text" id="empNo" name="empNo"
                           placeholder="사원번호:년도+순번">
                     </div></li>

                  <li><label for="empNm">사원명<i class="i">*</i></label>
                     <div>
                        <input type="text" id="empNm" name="empNm" placeholder="사원명">
                     </div></li>

                  <li><label for="gender">성별<i class="i">*</i></label>
                     <div>
                        <div class="wf-select-group">
                           <select name="gender" id="gender" required>
                              <option value="">성별</option>
                              <option value="1">남성</option>
                              <option value="2">여성</option>
                           </select>
                        </div>
                     </div></li>
                  <li><label for="bdate">생년월일(8자리)<i class="i">*</i></label>
                     <div>
                        <input type="text" id="bdate" name="bdate"
                           placeholder="예시: 19970101">
                     </div></li>



                  <li><label for="cntcNo">개인연락처(- 포함)<i class="i">*</i></label>
                     <div>
                        <input type="text" id="cntcNo" name="cntcNo"
                           placeholder="010-****-****">
                     </div></li>
                  <li><label for="email">이메일주소<i class="i">*</i></label>
                     <div>
                        <input type="text" id="email" name="email" placeholder="**@**">
                     </div></li>
                  <li><label for="ecnyDate">입사일(8자리)<i class="i">*</i></label>
                     <div>
                        <input type="text" id="ecnyDate" name="ecnyDate"
                           placeholder="예시: 20240325">
                     </div></li>
                  <li><label for="lxtn">내선번호(- 포함)<i class="i">*</i></label>
                     <div>
                        <input type="text" id="lxtn" name="lxtn"
                           placeholder="070-****-****">
                     </div></li>
                  <li><label for="workLocCd">근무지역<i class="i">*</i></label>
                     <div>
                        <div class="wf-select-group">
                           <select name="workLocCd" id="workLocCd" required>
                              <option value="">근무지역</option>
                              <option value="1">서울</option>
                              <option value="2">대전</option>
                              <option value="3">세종</option>
                              <option value="4">천안</option>
                           </select>
                        </div>
                     </div></li>

                  <li><label for="deptNo">부서<i class="i">*</i></label>
                     <div>
                        <div class="wf-select-group">
                           <select name="deptNo" id="deptNo" required>
                              <option value="">부서</option>
                              <option value="DEPT01">기획본부</option>
                              <option value="DEPT0101">사업기획팀</option>
                              <option value="DEPT0102">경영기획팀</option>
                              <option value="DEPT0103">연구기획팀</option>
                              <option value="DEPT02">경영지원본부</option>
                              <option value="DEPT0201">회계팀</option>
                              <option value="DEPT0202">인사팀</option>
                              <option value="DEPT0203">설비관리팀</option>
                              <option value="DEPT03">영업본부</option>
                              <option value="DEPT0301">국내영업팀</option>
                              <option value="DEPT0302">해외영업팀</option>
                              <option value="DEPT04">마케팅본부</option>
                              <option value="DEPT0401">국내마케팅팀</option>
                              <option value="DEPT0402">해외마케팅팀</option>
                              <option value="DEPT0403">홍보팀</option>
                              <option value="DEPT05">연구개발본부</option>
                              <option value="DEPT0501">개발팀</option>
                              <option value="DEPT0502">디자인팀</option>
                              <option value="DEPT0503">데이터관리팀</option>
                           </select>
                        </div>
                     </div></li>
                  <li><label for="superEmpNo">상급자사번<i class="i">*</i></label>
                     <div>
                        <input type="text" id="superEmpNo" value="">
                     </div></li>
                  <li><label for="positionCd">직급<i class="i">*</i></label>
                     <div>
                        <div class="wf-select-group">
                           <select name="positionCd" id="positionCd" required>
                              <option value="">직급</option>
                              <option value="1">사장</option>
                              <option value="2">이사</option>
                              <option value="3">부장</option>
                              <option value="4">차장</option>
                              <option value="5">과장</option>
                              <option value="6">대리</option>
                              <option value="7">사원</option>
                              <option value="8">계약사원</option>
                           </select>
                        </div>
                     </div></li>

                  <li><label for="rspnsblCd">직책<i class="i">*</i></label>
                     <div>
                        <div class="wf-select-group">
                           <select name="rspnsblCd" id="rspnsblCd" required>
                              <option value="">직책</option>
                              <option value="1">팀원</option>
                              <option value="2">팀장</option>
                              <option value="3">본부장</option>
                           </select>
                        </div>
                     </div></li>


                  <li><label for="empPw">초기비밀번호<i class="i">*</i></label>
                     <div>
                        <input type="text" id="empPw" name="empPw" value="java"
                           placeholder="비밀번호">
                     </div></li>
                  <li><label for="workSeCd">재직구분<i class="i">*</i></label>
                     <div>
                        <input type="text" id="workSeCd" name="workSeCd" value="1"
                           placeholder="변경 금지">
                     </div></li>
                  <li><label for="enabled">활성화<i class="i">*</i></label>
                     <div>
                        <input type="text" id="enabled" name="enabled" value="1"
                           placeholder="변경 금지">
                     </div></li>

               </ul>
               <sec:csrfInput />
            </form>

         </div>
      </div>

      <div class="modal-btn-wrap" id="createBtnGroup">
         <!--          <button class="btn6">취소</button> -->
         <button type="button" class="btn1" onclick="autoFillEmp()">자동입력</button>
         <button type="button" form="empAddForm" class="btn2"
            id="createEmpBtn">등록</button>

         <!-- /admin/addEmp -->
      </div>



      <button class="close-btn" id="rsvModalCloseBtn"></button>
   </div>
</div>
<!--------------------------------- 사원 등록 모달 끝 --------------------------------->
<!--------------------------------- 재직 구분 변경 모달 시작 --------------------------------->
<div class="modal" id="empUpdModal">
   <div class="modal-cont">
      <h1 class="modal-tit" id="modalTit">재직 구분 변경</h1>
      <div class="modal-content-area">
         <div class="wf-flex-box">
            <form id="empUpdForm" method="post">

               <ul class="wf-insert-form">
                  <li><label for="workSeCdd">재직 구분<i class="i">*</i></label>
                     <div>
                        <div class="wf-select-group">
                           <select name="workSeCdd" id="workSeCdd" required>
                              <option value="">재직 구분</option>
                              <option value="5">재택</option>
                              <option value="2">휴직</option>
                              <option value="4">퇴직</option>
                              <option value="1">복직</option>
                           </select>
                        </div>
                     </div></li>
                  <li></li>

                  <li><label for="inputField">사원명<i class="i">*</i></label>
                     <div>
                        <div id="recipientList"></div>
                        <input type="text" id="inputField" class="autocomplete teams"
                           placeholder="사원명을 입력해주세요" required>

                     </div></li>

                  <li><label for="empno">사원 번호<i class="i">*</i></label>
                     <div>
                        <input type="text" id="empno" value="" required>
                     </div></li>
               </ul>
               <sec:csrfInput />
            </form>

         </div>
      </div>

      <div class="modal-btn-wrap" id="createBtnGroup">
         <!--          <button type="reset" class="btn6">취소</button> -->
         <!--                   <button type="submit" form="empUpdForm" class="btn2" id="empUpdModalBtn">확인</button> -->

         <button type="button" class="btn2" id="empUpdModalBtn">확인</button>
      </div>



      <button class="close-btn" id="empUpdModalCloseBtn"></button>
   </div>
</div>
<!--------------------------------- 재직 구분 변경 모달 끝 --------------------------------->
<script>


            $(() => {
               $(document).on("focus", ".teams", function (e) {
                  if (!$(this).hasClass("ui-autocomplete")) {
                     $(this).autocomplete({

                        source: function (request, response) {
                           console.log("auto1", this.element[0].value);
                           autoNm = this.element[0].value;
                           //console.log("auto2" ,autoNm);
                           data = {
                              "empNm": autoNm
                           }
                           console.log("empNm", autoNm);
                           $.ajax({
                              type: 'post',
                              data: JSON.stringify(data),
                              url: '/project/findEmpByName',
                              contentType: "application/json",
                              dataType: 'json',
                              success: function (data) {
                                 // 서버에서 json 데이터 response 후 목록 추가

                                 console.log("자동완성 : ", data);
                                 response(
                                    $.map(data, function (item) {
                                       console.log("single page app", item.empNm.substr(0, item.empNm.indexOf('(')));

                                       return {
                                          label: item.empNm,
                                          value: item.empNm.substr(0, item.empNm.indexOf('(')),
                                          empNo: item.empNo
                                       }
                                    })
                                 );
                              }
                           });
                        },
                        select: function (event, ui) {

                           console.log("teams시 :", this);

                           $(this).val(ui.item.empNo);
                           $(this).data("empNo", ui.item.empNo);
                           

                           console.log("select시 :", $(this).val());
                           
                           const empNo= $("#inputField").val();
                           console.log("select시 진짜야 empNo :", empNo);
                           $("#empno").val(empNo);
                           
                        },
                        focus: function (event, ui) {

                           return false;
                        },
                        open: function (event, ui) {
                           console.log("open this", this);
                           console.log("open ui", ui);
                           console.log("open event", event);

                        },
                        minLength: 1,
                        autoFocus: true,
                        classes: {
                           'ui-autocomplete': 'highlight'
                        },
                        delay: 500,
                        position: { my: 'right top', at: 'right bottom' },
                        close: function (event) {
                           $("#ui-id-1").remove();
                           console.log(event);

                        }
                     });
                  }
               });
            });
         
            //재직구분변경시 알럿
            document.getElementById("empUpdModalBtn").addEventListener("click", function() {
                Swal.fire({
                    title: _msg.common.docConfirm,
                    showDenyButton: true,
                    confirmButtonText: "확인",
                    denyButtonText: `취소`,
                }).then((result) => {
                    if (result.isConfirmed) { 
                        Toast.fire({
                            icon: "success",
                            title: _msg.common.SuccessAlert, 
                        });
                        // AJAX 요청을 보냅니다.
                        $.ajax({
                            url: "/admin/updEmp", // 수정을 위한 컨트롤러 매핑 URL
                            type: "POST",
                            contentType: "application/json",
                            data: JSON.stringify({
                                "empNo": $("#empno").val(),
                                "workSeCd": $("#workSeCdd").val()
                            }),
                            success: function(response) {
                                if (response === 1) {
                                    // 성공 알림 출력
                                    Toast.fire({
                                        icon: "success",
                                        title: _msg.common.SuccessAlert, 
                                    });
                                } else {
                                    // 실패 알림 출력
                                    Toast.fire({
                                        icon: "info",
                                        title: _msg.common.FailAlert,
                                    });
                                }
                                // 모달 닫기
                                $(".modal").removeClass('open');
                                $('html').removeClass('scroll-hidden');
                            },
                            error: function(xhr, status, error) {
                                // 오류 발생 시 처리
                                console.error(xhr.responseText);
                                console.error(xhr.status);
                                Swal.fire({
                                    title: '오류!',
                                    text: '수정 처리 도중 오류가 발생했습니다.',
                                    icon: 'error'
                                });
                            }
                        });
                    } else if (result.isDenied) { 
                        $(".modal").removeClass('open');
                         $('html').removeClass('scroll-hidden');
                        Toast.fire({
                            icon: "info",
                            title: _msg.common.FailAlert,
                        });
                    }
                });
            });

               //양식다운로드시 알럿   
            document.getElementById("downloadLink").addEventListener("click", function() {
                // 확인 알림 창 표시
                Swal.fire({
                    title: _msg.common.downloadConfirm,
                    showDenyButton: true,
                    confirmButtonText: "확인",
                    denyButtonText: `취소`,
                }).then((result) => {
                    if (result.isConfirmed) { 
                        // 확인 버튼을 클릭한 경우
                        Toast.fire({
                            icon: "success",
                            title: _msg.common.SuccessAlert, 
                        });
                        // 폼 제출
                        document.getElementById("empForm").submit();
                    } else if (result.isDenied) { 
                        // 취소 버튼을 클릭한 경우
                        Toast.fire({
                            icon: "info",
                            title: _msg.common.FailAlert,
                        });
                    }
                });
            });

                //부서 선택시 상급자 사번 자동입력
                $("#deptNo").on("change",function(){
                     var deptNo = $(this).val();
                     console.log("deptNo",deptNo);
                       $.ajax({
                           url: "/emp/findSuperEmpNo", 
                           type: "POST",
                           contentType: "application/json",
                           data: JSON.stringify({
                              "deptNo": deptNo
                           }),
                           beforeSend: function(xhr){
                              xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
                          },
                           success: function(response) {
                               console.log("response:",response);
                               $("#superEmpNo").val(response);
                           },
                           error: function(xhr, status, error) {
                               // 오류가 발생했을 때의 처리를 합니다.
                               console.error(xhr.responseText);
                               console.error(xhr.status);                             
                           }
                       });             
                } );//끝
                
                document.getElementById("createEmpBtn").addEventListener("click", function() {
                   // 확인 알림 창 표시
                   Swal.fire({
                       title: _msg.common.insertConfirm,
                       showDenyButton: true,
                       confirmButtonText: "확인",
                       denyButtonText: `취소`,
                   }).then((result) => {
                       if (result.isConfirmed) { 
                           // 확인 버튼을 클릭한 경우
                           Toast.fire({
                               icon: "success",
                               title: _msg.common.SuccessAlert, 
                               
                           });
                           $(".modal").removeClass('open');
                           $('html').removeClass('scroll-hidden');
                           // 폼 제출
                           document.getElementById("empAddForm").submit();
                       } else if (result.isDenied) { 
                           // 취소 버튼을 클릭한 경우
                           Toast.fire({
                               icon: "info",
                               title: _msg.common.FailAlert,
                           });
                       }
                   });
               });
             
                //사원등록-자동입력
                function autoFillEmp() {

                    var empNo = "2028001";
                    var empNm = "김수지"; 
                    var gender = "2"; 
                    var bdate = "19970101"; 
                    var cntcNo = "010-1234-5678"; 
                    var email = "example@naver.com"; 
                    var ecnyDate = "20240409";
                    var lxtn = "070-1234-0003"; 
                    var workLocCd = "1";
                    var deptNo = "DEPT0101"; 
                    var superEmpNo = "2022008"; 
                    var positionCd = "7"; 
                    var rspnsblCd = "1"; 
                    var empPw = "java"; 
                    var workSeCd = "1"; 
                    var enabled = "1";

                    $("#empNo").val(empNo);
                    $("#empNm").val(empNm);
                    $("#gender").val(gender);
                    $("#bdate").val(bdate);
                    $("#cntcNo").val(cntcNo);
                    $("#email").val(email);
                    $("#ecnyDate").val(ecnyDate);
                    $("#lxtn").val(lxtn);
                    $("#workLocCd").val(workLocCd);
                    $("#deptNo").val(deptNo);
                    $("#superEmpNo").val(superEmpNo);
                    $("#positionCd").val(positionCd);
                    $("#rspnsblCd").val(rspnsblCd);
                    $("#empPw").val(empPw);
                    $("#workSeCd").val(workSeCd);
                    $("#enabled").val(enabled);
                }

             
         </script>