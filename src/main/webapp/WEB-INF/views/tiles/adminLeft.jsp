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
            <span class="team">${empVO.deptNm}</span>
        </sec:authorize>

        <!------------------------- 로그인 했을 때  끝 ------------------------->
    </div>
    <div id="leftside-navigation" class="leftside-navigation">
        <ul class="depth1">
            <li class="sub-menu">
                <a href="javascript:void(0)" class="arrow">
                    <i class="xi-chart-bar"></i>
                    <span>통계</span>
                </a>
                <ul class="depth2">
                    <li>
                        <a href="/adminEmp/main">사원통계</a>
                    </li>
                    <li>
                        <a href="/adminProject/main">프로젝트통계</a>
                    </li>
                    <li>
                        <a href="/adminAttendance/main">근태통계</a>
                    </li>
                    <li>
                        <a href="/adminDeptAttendance/main">근태통계(부서)</a>
                    </li>
                </ul>
            </li>
        </ul>
        <ul class="depth1">
            <li class="sub-menu">
                <a href="javascript:void(0)" class="arrow">
                    <i class="xi-pen"></i>
                    <span>예약관리</span>
                </a>
                <ul class="depth2">
                    <li>
                        <a href="/admin/reservation/manageMtrResves">회의실 예약 관리</a>
                    </li>
                    <li>
                        <a href="/admin/reservation/manageCarResves">차량 예약 관리</a>
                    </li>
                    <li>
                        <a href="/admin/reservation/manageResources">시설/자원관리</a>
                    </li>
                </ul>
            </li>
        </ul>
        <ul class="depth1">
            <li class="sub-menu">
                <a href="javascript:void(0)" class="arrow">
                    <i class="xi-group"></i>
                    <span>조직관리</span>
                </a>
                <ul class="depth2">
                    <li>
                        <a href="/admin/list">조직관리</a>
                    </li>
                    <li>
                        <a href="/admin/deptList">부서관리</a>
                    </li>
                </ul>
            </li>
        </ul>
        <ul class="depth1">
            <li class="sub-menu">
                <a href="/docList" class="arrow">
                    <i class="xi-documents"></i>
                    <span>문서발급관리</span>
                </a>
            </li>
        </ul>
        <ul class="depth1">
            <li class="sub-menu">
                <a href="/admin/survey/list" class="arrow">
                    <i class="xi-document">
                    </i>
                    <span>설문</span>
                </a>
            </li>
        </ul>

        <ul class="depth1">
            <li class="sub-menu">
                <a href="/sendSMS">
                    <i class="xi-message"></i>
                    <span>문자발송</span>
                </a>
            </li>
        </ul>
    </div>
    <div class="goAdminBtn" id="goMainBtn">
    	<a href="/home"><i class="xi-external-link"></i>&nbsp;메인</a>
    </div>
</aside>
