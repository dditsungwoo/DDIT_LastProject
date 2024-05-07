<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
    <TItle>자유게시판 리스트</TItle>
    <!DOCTYPE html>
    <html>


    <main class="custom">
        <div class="wf-main-container">
            <!-- =============== body 시작 =============== -->
            <!-- =============== 상단타이틀영역 시작 =============== -->
            <div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
                <h1 class="page-tit">자유 게시판</h1>
                <div class="side-util">
                    <button type="button" class="btn2" onclick="location.href='http://localhost/freeboard/list/insertFreeBoard'">등록</button>
                </div>
            </div>
            <!-- =============== 상단타이틀영역 끝 =============== -->
            <!-- =============== 컨텐츠 영역 시작 =============== -->
            <div class="wf-content-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">

                <div class="wf-content-area">
                    <table class="wf-table">
                        <colgroup>
                            <col style="width: 7%;">
                            <col style="width: 5%;">
                            <col style="width: 56%;">
                            <col style="width: 7%;">
                            <col style="width: 15%;">
                            <col style="width: 15%;">
                        </colgroup>
                        <thead>
                            <tr>
                                <th>분류</th>
                                <th>번호</th>
                                <th>제목</th>
                                <th>작성자</th>
                                <th>작성일</th>
                                <th>조회수</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="freeBoardVO" items="${data.content}" varStatus="stat">
                            <tr>
                                <td>
                                    <p>${freeBoardVO.cmmnCdNm}</p>
                                </td>
                                <td>
                                    <p>${freeBoardVO.freeBrdNo}</p>
                                </td>
                                <td onclick="location.href='/freeboard/list/detail?freeBrdNo=${freeBoardVO.freeBrdNo}'">
                                    <a href="/freeboard/list/detail?freeBrdNo=${freeBoardVO.freeBrdNo}"><p>${freeBoardVO.freeBrdSj}</p></a>
                                </td>
                                <td>
                                   <p>${freeBoardVO.empNm }</p>
                                </td>
                                <td>
                                    <p>${freeBoardVO.writngDate }</p>
                                </td>
                                <td>
                                    <p style="content: center;">${freeBoardVO.rdcnt}</p>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
	
	
                <!-- 페이지네이션 시작 -->
				${data.getPagingArea() }
                <!-- 페이지네이션 끝 -->

                <!-- 검색영역 시작 -->
                <div class="wf-search-area">
                    <div class="select-box">
                        <select name="" id="">
                            <option value="">제목</option>
                            <option value="">제목+내용</option>
                            <option value="">작성자</option>
                        </select>
                    </div>
                    <input type="text" placeholder="검색할 내용을 입력해주세요">
                    <button type="button" class="btn4">
                        <i class="xi-search"></i>
                    </button>
                </div>
                <!-- 검색영역 끝 -->
            </div>
            <!-- =============== 컨텐츠 영역 끝 =============== -->
            <!-- =============== body 끝 =============== -->
        </div>
    </main>

    </html>