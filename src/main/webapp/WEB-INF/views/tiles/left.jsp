<%@ page language="java" contentType="text/html; charset=UTF-8"%> <%@ include file="/WEB-INF/views/tiles/taglib.jsp"%>

<aside class="sidebar custom">
    <div class="sidebar-user-info">
        <!------------------------- 로그인 안했을 때  시작 ------------------------->
        <sec:authorize access="isAnonymous()">
            <div class="user-panel mt-3 pb-3 mb-3 d-flex">
                <div class="info">
                    <a href="/" class="d-block">로그인해주세요</a>
                </div>
            </div>
        </sec:authorize>
        <!------------------------- 로그인 안했을 때  끝 ------------------------->

        <!------------------------- 로그인 했을 때  시작 ------------------------->
        <div class="img-box">
            <img src="/resources/img/icon/${proflImageUrl}" />
        </div>
        <sec:authorize access="isAuthenticated()">
            <sec:authentication property="principal.empVO" var="empVO" />

            <span class="name">${empNm} ${rspnsblCtgryNm}</span>

  <sec:authorize access="${empVO.empNo != '2018001'}">
        <span class="team">${empVO.deptNm}</span>
    </sec:authorize>
    
        </sec:authorize>

        <!------------------------- 로그인 했을 때  끝 ------------------------->
    </div>
    <div id="leftside-navigation" class="leftside-navigation">
        <ul class="depth1">
            <li class="sub-menu">
                <a href="/mail/main">
                    <i class="xi-mail"></i>
                    <span>메일</span>
                </a>
            </li>
        </ul>
        <ul class="depth1">
            <li class="sub-menu">
                <a href="javascript:void(0)" class="arrow">
                    <i class="xi-business"></i>
                    <span>업무관리</span>
                </a>
                <ul class="depth2">
                    <li>
                        <a href="/duty/main">업무</a>
                    </li>
                    <li>
                        <a href="/project/projects">프로젝트</a>
                    </li>
                </ul>
            </li>
        </ul>
        <ul class="depth1">
            <li class="sub-menu">
                <a href="javascript:void(0)" class="arrow">
                    <i class="xi-document"></i>
                    <span>전자결재</span>
                </a>
                <ul class="depth2">
                    <li>
                        <a href="/approval/mainView">결재 진행 현황</a>
                    </li>
                    <li>
                        <a href="/approval/listView">내 문서함</a>
                    </li>
                    <li>
                        <a href="/approval/deptListView">부서 문서함</a>
                    </li>
                </ul>
            </li>
        </ul>
        <ul class="depth1">
            <li class="sub-menu">
                <a href="javascript:void(0)" class="arrow">
                    <i class="xi-calendar"></i>
                    <span>일정관리</span>
                </a>
                <ul class="depth2">
                    <li>
                        <a href="/schedule/main">일정</a>
                    </li>
                    <li>
                        <a href="/vacation/main">휴가</a>
                    </li>
                </ul>
            </li>
        </ul>
        <ul class="depth1">
            <li class="sub-menu">
                <a href="javascript:void(0)" class="arrow">
                    <i class="xi-pen"></i>
                    <span>예약/신청</span>
                </a>
                <ul class="depth2">
                    <li>
                        <a href="/reservation/mtr/main">회의실 예약</a>
                    </li>
                    <li>
                        <a href="/reservation/car/main">차량 예약</a>
                    </li>
                </ul>
            </li>
        </ul>

        <ul class="depth1">
            <li>
                <a href="/attendance/main">
                    <i class="xi-alarm-clock"></i>
                    <span>근태관리</span>
                </a>
            </li>
        </ul>
        <ul class="depth1">
            <li class="sub-menu">
                <a href="javascript:void(0)" class="arrow">
                    <i class="xi-align-justify"></i>
                    <span>게시판</span>
                </a>
                <ul class="depth2">
                    <li>
                        <a href="/notice/list">공지사항</a>
                    </li>
                    <li>
                        <a href="/suggestion/list">건의게시판</a>
                    </li>
                </ul>
            </li>
        </ul>
        <ul class="depth1">
            <li class="sub-menu">
                <a href="/emp/list">
                    <i class="xi-group"></i>
                    <span>주소록</span>
                </a>
            </li>
        </ul>
        <ul class="depth1">
            <li class="sub-menu">
                <a href="/menu/archive?deptNo=<%=session.getAttribute("deptNo")%>">
                    <i class="xi-documents"></i>
                    <span>부서 자료실</span>
                </a>
            </li>
        </ul>
    </div>
    <div class="goAdminBtn" id="goAdminBtn">
    	<a href="/adminEmp/main"><i class="xi-external-link"></i>&nbsp;관리자</a>
    </div>
</aside>

<script>
    let rspnsblCtgryNm = '<%=(String)session.getAttribute("rspnsblCtgryNm")%>';
    if(rspnsblCtgryNm === "팀원") {
        $("#goAdminBtn").css("display", "none");
    }
</script>
