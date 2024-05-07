<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/views/tiles/taglib.jsp"%>
<script src="${_script}/common/util.js"></script>
<script src="${_script}/approval/html.js"></script>
<script src="${_script}/approval/detail.js"></script>
<!-- =============== 상단타이틀영역 시작 =============== -->
<div class="wf-tit-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="0">
    <h1 class="page-tit">결재 확인</h1>
    <div class="wf-util">
    	<button type="button" class="btn4" id="apv_open">새창으로 보기 <i class="xi-external-link"></i></button>
        <button type="button" class="btn5" id="pdf_btn">PDF <i class="xi-download"></i></button>
        <button type="button" class="btn7" id="refuse_btn">반려하기</button>
        <button type="button" class="btn3" id="docReturn_btn">회수하기</button>
        <button type="button" class="btn2" id="approval_btn">결재하기</button>
    </div>
</div>
<!-- =============== 상단타이틀영역 끝 =============== -->

<!-- =============== 컨텐츠 영역 시작 =============== -->
<div>
	<%--${apvVO}
	 ${apvLineList}
	${apvReferVOList} --%>
</div>

<input type="hidden" id="empNo" value="<%= session.getAttribute("empNo") %>">
<div class="wf-content-wrap" data-aos="fade-right" data-aos-duration="700" data-aos-delay="200">    
    <div class="wf-content-area">
        <div class="approval-confirm-cont">
            <div class="pdfViewer" id="pdfViewer">
           	   <div>
			       <div class="apv-doc-form-wrap">
			           <div class="apv-doc-form">
			               <table>
			                   <colgroup>
			                       <col style="width: 10%;">
			                       <col style="width: 25%;">
			                       <col style="width: 10%;">
			                       <col style="width: auto;">
			                       <col style="width: 7%;">
			                       <col style="width: auto;">
			                   </colgroup>
			                   <tbody>
			                       <tr>
			                           <td colspan="2">
			                           		<span class="form-tit">
			                           			<c:choose>
			                           				<c:when test="${apvVO.docFormNo == '1'}">
			                           					<span class="doc-name">품의서</span>
			                           				</c:when>
			                           				<c:when test="${apvVO.docFormNo == '2'}">
			                           					<span class="doc-name">출장신청서</span>
			                           				</c:when>
			                           				<c:when test="${apvVO.docFormNo == '3'}">
			                           					<span class="doc-name">도서구입신청서</span>
			                           				</c:when>
			                           				<c:otherwise>
			                           					<span class="doc-name">품의서</span>
			                           				</c:otherwise>
			                           			</c:choose>
		                           			</span>
			                           	</td>
			                           <td colspan="4">
			                               <table class="apv-sign-table">
			                                   <colgroup>
			                                       <col style="width: 20%;">
			                                       <col style="width: 20%;">
			                                       <col style="width: 20%;">
			                                   </colgroup>
			                                   <tbody>
													 <tr>
												        <c:forEach var="e" items="${apvLineList}">
												            <c:choose>
												                <c:when test="${e.apvSeCd == '1' && e.apvSttusCd == 'Y'}">
												                    <td>${e.empNm} / ${e.apvPosition}</td>
												                </c:when>
												                <c:when test="${e.apvSeCd == '2' && e.apvSttusCd == 'Y'}">
												                    <td>${e.empNm} / ${e.apvPosition}</td>
												                </c:when>
												                <c:when test="${e.apvSeCd == '3' && e.apvSttusCd == 'Y'}">
												                    <td>${e.empNm} / ${e.apvPosition}</td>
												                </c:when>
												                <c:otherwise>
												                    <td></td>
												                </c:otherwise>
												            </c:choose>
												        </c:forEach>
												    </tr>
												    <tr>
												        <c:forEach var="e" items="${apvLineList}">
												            <c:choose>
												                <c:when test="${e.apvSeCd == '1' && e.apvSttusCd == 'Y'}">
												                    <td>
												                    	<img src="${e.signImageUrl}">
											                    	</td>
												                </c:when>
												                <c:when test="${e.apvSeCd == '2' && e.apvSttusCd == 'Y'}">
												                    <td>
												                    	<img src="${e.signImageUrl}">
											                    	</td>
												                </c:when>
												                <c:when test="${e.apvSeCd == '3' && e.apvSttusCd == 'Y'}">
												                    <td>
												                    	<img src="${e.signImageUrl}">
											                    	</td>
												                </c:when>
												                <c:otherwise>
												                    <td></td>
												                </c:otherwise>
												            </c:choose>
												        </c:forEach>
												    </tr>
												    <tr>
												        <c:forEach var="e" items="${apvLineList}">
												            <c:choose>
												                <c:when test="${e.apvSeCd == '1' && e.apvSttusCd == 'Y'}">
												                    <td>
																		<fmt:parseDate value="${e.apvDate}" var="registered" pattern="yyyy-MM-dd" />
																		<fmt:formatDate value="${registered}" pattern="yyyy-MM-dd" />
												                    </td>
												                </c:when>
												                <c:when test="${e.apvSeCd == '2' && e.apvSttusCd == 'Y'}">
												                    <td>
																		<fmt:parseDate value="${e.apvDate}" var="registered" pattern="yyyy-MM-dd" />
																		<fmt:formatDate value="${registered}" pattern="yyyy-MM-dd" />
												                    </td>
												                </c:when>
												                <c:when test="${e.apvSeCd == '3' && e.apvSttusCd == 'Y'}">
												                    <td>
																		<fmt:parseDate value="${e.apvDate}" var="registered" pattern="yyyy-MM-dd" />
																		<fmt:formatDate value="${registered}" pattern="yyyy-MM-dd" />
												                    </td>
												                </c:when>
												                <c:otherwise>
												                    <td></td>
												                </c:otherwise>
												            </c:choose>
												        </c:forEach>
												    </tr>
			                                   </tbody>
			                               </table>
			                           </td>
			                       </tr>
			                       <tr>
			                           <th>기안부서</th>
			                           <td>
			                           		<c:forEach var="e" items="${apvLineList}">
			                           			<c:if test="${e.apvSeCd == '1'}">
			                           				${e.deptNm}
			                           			</c:if>
			                           		</c:forEach>
			                           </td>
			                           <th>기안일자</th>
			                           <td colspan="4">
                     		                <fmt:parseDate value="${apvVO.drftDate}" var="registered" pattern="yyyy-MM-dd" />
											<fmt:formatDate value="${registered}" pattern="yyyy-MM-dd" />
			                           </td>
			                       </tr>
			                       <tr>
			                           <th>기안자</th>
			                           <td>
			                           		<c:forEach var="e" items="${apvLineList}">
			                           			<c:if test="${e.apvSeCd == '1'}">
			                           				${e.empNm}
			                           			</c:if>
			                           		</c:forEach>
			                           </td>
			                           <th>보존년한</th>
			                           <td colspan="4">3년</td>
			                           <!-- <th>비밀등급</th>
									<td><span class="data"></span></td> -->
			                       </tr>
			                       <tr>
			                           <th>제목</th>
			                           <td colspan="5">
			                           		${apvVO.apvSj}
			                           </td>
			                       </tr>
			                       <tr>
			                           <td colspan="6" id="apvCn">
											<div style="min-height: 300px;">
				                           		<input type="hidden" id="apvCn_val" value="${apvVO.apvCn}">
												<div class="convert-txt" style="text-align: left"></div>
												<div class="etc-table" id="etc"></div>
											</div>
			                           </td>
			                       </tr>
			                       <tr>
			                       		<td colspan="7">
		                       				<ul style="line-height: 1.5; color: #939393;">
			                       				<li>
		                   							<span>
					                       				담당 :
						                       			<c:forEach var="e" items="${apvLineList}">
						                           			<c:if test="${e.apvSeCd == '1'}">
						                           				${e.empNm}
						                           			</c:if>
						                           		</c:forEach>
					                       			</span>
					                       			<span>/ 대표 : 김대덕</span>  
			                       				</li>
			                       				<li>협조 : 김수현</li>
			                       				<li>시행 : 이철희
                								    <c:forEach var="e" items="${apvLineList}">
					      								<c:if test="${e.apvSeCd == '3' && e.apvSttusCd == 'Y'}">
										                    <fmt:parseDate value="${e.apvDate}" var="registered" pattern="yyyy-MM-dd" />
															<fmt:formatDate value="${registered}" pattern="yyyy-MM-dd" />
										                </c:if>
											        </c:forEach>
			                       				</li>
			                       				<li>우 34908 / 대전 중구 계룡로 846 / www.ddit.or.kr</li>
			                       				<li>전화 042-222-8202 / 팩스 070-8768-2972 / dditlove@ddit.co.kr / 공개</li>
		                       				</ul>
			                       		</td>
			                       </tr>
			                   </tbody>
			               </table>
			           </div>
			        </div>
				</div>
            </div>
            <div class="right">
                <!-- 첨부파일 시작 -->
                <div class="approval-attach-box">
                    <div class="tit-wrap">
                        <p class="heading2">첨부파일</p>
                    </div>
                    <ul id="fileList" class="file-lst bul-lst01" style="min-height: 57px;"></ul>
                </div>
                <!-- 첨부파일 끝 -->
                
                <!-- 결재선 이력 -->
               	<p class="heading2" style="margin: 20px 0 10px;">결재 현황</p>
                <div class="wf-content-area">
			       	<div class="tab-type tab-type1">
				        <div class="tab-menu">
				            <button data-tab="tab1" type="button" class="tab-btn active">결재선 이력</button>
				            <button data-tab="tab2" type="button" class="tab-btn">참조인</button>
				            <div class="tab-indicator"></div>
				        </div>
				
				        <!-- tab1  -->
				        <div data-tab="tab1" class="tab-content active">
				            <div class="tab-board-lst">
			                    <table class="wf-table read-table center-table">
						            <colgroup>
						                <col style="width: 5%;">
						                <col style="width: 10%;">
						                <col style="width: 10%;">
						                <col style="width: 10%;">
						                <col style="width: 10%;">
						                <col style="width: 15%;">
						            </colgroup>
						            <thead>
						                <tr>
						                    <th>번호</th>
						                    <th>결재구분</th>
						                    <th>소속 부서</th>
						                    <th>결재자</th>
						                    <th>결재일</th>
						                    <th>결재상태</th>
						                </tr>
						            </thead>
						            <tbody>
										<c:forEach var="e" items="${apvLineList}" varStatus="stat">
							             	<tr>
							            		<td>${stat.count}</td>
							            		<td>
				   						            <c:choose>
													    <c:when test="${e.apvSeCd == '1'}">기안</c:when>
													    <c:when test="${e.apvSeCd == '2'}">검토</c:when>
													    <c:when test="${e.apvSeCd == '3'}">결재</c:when>
													</c:choose>	
							            		</td>
							            		<td>${e.deptNm}</td>
							            		<td>${e.empNm}
								            		<c:choose>
						            					<c:when test="${e.apvRspnsbl} != '팀원'">${e.apvRspnsbl}</c:when>
						            					<c:otherwise>${e.apvPosition}</c:otherwise>
						            				</c:choose>
							            		</td>
							            		<td>
							            			<c:choose>
							            			<%-- 기안 상신 날짜 --%>
												    <c:when test="${e.apvSeCd == '1' && e.apvSttusCd == 'Y'}">
												    	<fmt:parseDate value="${e.apvDate}" var="registered" pattern="yyyy-MM-dd" />
														<fmt:formatDate value="${registered}" pattern="yyyy-MM-dd" />
												    </c:when>
												    <%-- 2번째 결재자 승인 전--%>
												    <c:when test="${e.apvSeCd == '2' && e.apvSttusCd == '0'}">-</c:when>
												    <%-- 3번째 결재자 승인 전--%>
												    <c:when test="${e.apvSeCd == '3' && e.apvSttusCd == '0'}">-</c:when>
												    <%-- 2번째 결재자 승인 날짜--%>
												    <c:when test="${e.apvSeCd == '2' && e.apvSttusCd == 'Y'}">
												    	<fmt:parseDate value="${e.apvDate}" var="registered" pattern="yyyy-MM-dd" />
														<fmt:formatDate value="${registered}" pattern="yyyy-MM-dd" />
												    </c:when>
			    								    <%-- 3번째 결재자 승인 날짜--%>
												    <c:when test="${e.apvSeCd == '3' && e.apvSttusCd == 'Y'}">
												    	<fmt:parseDate value="${e.apvDate}" var="registered" pattern="yyyy-MM-dd" />
														<fmt:formatDate value="${registered}" pattern="yyyy-MM-dd" />
												    </c:when>
												    <%-- 2번째 결재자 반려 날짜--%>
												    <c:when test="${e.apvSeCd == '2' && e.apvSttusCd == 'N'}">
												    	<fmt:parseDate value="${e.apvDate}" var="registered" pattern="yyyy-MM-dd" />
														<fmt:formatDate value="${registered}" pattern="yyyy-MM-dd" />
												    </c:when>
												    <%-- 3번째 결재자 반려 날짜--%>
												    <c:when test="${e.apvLineSeq == '3' && e.apvSttusCd == 'N'}">
												    	<fmt:parseDate value="${e.apvDate}" var="registered" pattern="yyyy-MM-dd" />
														<fmt:formatDate value="${registered}" pattern="yyyy-MM-dd" />
												    </c:when>
						            			</c:choose>
							            		</td>
							            		<td>
							            			<c:choose>
													    <c:when test="${e.apvSeCd == '1' && e.apvSttusCd == 'Y'}"><span class="wf-badge wf-badge1">기안</span></c:when>
													    
													    <c:when test="${e.apvSeCd == '2' && e.apvSttusCd == '0'}"><span class="wf-badge wf-badge3">대기</span></c:when>
													    <c:when test="${e.apvSeCd == '2' && e.apvSttusCd == 'Y'}"><span class="wf-badge wf-badge2">승인</span></c:when>
													    <c:when test="${e.apvSeCd == '2' && e.apvSttusCd == 'N'}"><span class="wf-badge wf-badge5">반려</span></c:when>
													    
													    <c:when test="${e.apvSeCd == '3' && e.apvSttusCd == '0'}"><span class="wf-badge wf-badge3">대기</span></c:when>
													    <c:when test="${e.apvSeCd == '3' && e.apvSttusCd == 'Y'}"><span class="wf-badge wf-badge2">승인</span></c:when>
													    <c:when test="${e.apvSeCd == '3' && e.apvSttusCd == 'N'}"><span class="wf-badge wf-badge5">반려</span></c:when>
													</c:choose>
							            		</td>
							            	</tr>
										</c:forEach>
						            </tbody>
					        	</table>
				            </div>
				        </div>
				
				        <!-- tab2  -->
				        <div data-tab="tab2" class="tab-content">
				            <div class="tab-board-lst">
								<table class="wf-table read-table center-table">
						            <colgroup>
						                <col style="width: auto;">
						                <col style="width: auto;">
						                <col style="width: auto;">
						            </colgroup>
						            <thead>
						                <tr>
						                    <th>번호</th>
						                    <th>소속 부서</th>
						                    <th>참조인</th>
						                </tr>
						            </thead>
									<tbody>
									    <c:choose>
									        <c:when test="${empty apvReferVOList}">
									            <tr>
									                <td colspan="3">참조인이 없습니다.</td>
									            </tr>
									        </c:when>
									        <c:otherwise>
									            <c:forEach var="e" items="${apvReferVOList}" varStatus="stat">
									                <tr>
									                    <td>${stat.count}</td>
									                    <td>${e.deptNm}</td>
									                    <td>${e.empNm}
									                        <c:choose>
									                            <c:when test="${e.apvRspnsbl != '팀원'}">${e.apvRspnsbl}</c:when>
									                            <c:otherwise>${e.apvPosition}</c:otherwise>
									                        </c:choose>
									                    </td>
									                </tr>
									            </c:forEach>
									        </c:otherwise>
									    </c:choose>
									</tbody>
					        	</table>
				            </div>
				        </div>
			        </div>
			    </div>
<!--                 의견 영역 시작 -->
<!--                 <div class="comment-area"> -->
<!--                     <p class="heading2">의견</p> -->
<!--                     <ul> -->
<!--                         <li>
<!--                             <div class="user-wrap"> -->
<!--                                 <span class="user-thumb"> -->
<!--                                     <img src="/resources/img/icon/avatar.png" alt="예시이미지"> -->
<!--                                 </span> -->
<!--                                 <div class="user-info"> -->
<!--                                     <div> -->
<!--                                         <span class="user-name">양연주</span> -->
<!--                                         <span class="user-position">과장</span> -->
<!--                                     </div> -->
<!--                                     <div> -->
<!--                                         <span class="user-team">개발본부 개발팀</span> -->
<!--                                         <span class="user-date">2023-05-04 13:20</span> -->
<!--                                     </div> -->
<!--                                 </div> -->
<!--                                 <div class="user-btn"> -->
<!--                                     <button type="button" class="add-btn"><i -->
<!--                                             class="xi-pen"></i></button> -->
<!--                                     <button type="button" class="del-btn"><i -->
<!--                                             class="xi-trash"></i></button> -->
<!--                                 </div> -->
<!--                             </div> -->
<!--                             <div class="txt"> -->
<!--                                 wow, amazing 💜 -->
<!--                             </div> -->
<!--                         </li> -->
<!--                          -->
<!--                     </ul> -->
<!--                     <div class="input-wrap"> -->
<!--                         <span class="user-thumb"> -->
<!--                             <img src="/resources/img/icon/avatar.png" alt="예시이미지"> -->
<!--                         </span> -->
<!--                         <input type="text" placeholder="댓글을 입력하세요"> -->
<!--                         <button class="btn4">등록</button> -->
<!--                     </div> -->
<!--                 </div> -->
<!--                 댓글, 코멘트 영역 끝 -->
            </div>
        </div>
    </div>

</div>


<!-- =============== 컨텐츠 영역 끝 =============== -->