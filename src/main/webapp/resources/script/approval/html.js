const _HTML = {
	msg: {
		docNm: {
			1: '품의서',
			2: '출장신청서',
			3: '도서구입신청서',
		}
	},
	create: {
		docType2: {
			emp_add_div: function (i) {
				return `
				<div class="doc-sub-wrap">
	            <button type="button" class="btn5 emp-remove-btn">
	                <i class="xi-user-plus-o"></i> 출장자 삭제
	            </button>
	            <div class="doc-sub">
	                <div class="doc-tit-wrap">
	                    <span class="doc-sub-tit">출장자</span>
	                </div>
	                <div class="doc-sub-inner">
	                    <input type="text" id="name${i}" placeholder="성명">
	                    <input type="text" id="dept${i}" placeholder="소속">
	                    <input type="text" id="position${i}" placeholder="직급">
	                    <input type="text" id="empId${i}" placeholder="사번">
	                </div>
	            </div>
	            <div class="doc-sub">
	                <span class="doc-sub-tit">출장지</span>
	                <div class="doc-sub-inner">
	                    <input type="text" id="destination${i}" placeholder="출장지">
	                </div>
	            </div>
	            <div class="doc-sub">
	                <div class="doc-tit-wrap">
	                    <span class="doc-sub-tit">출장일정</span>
	                </div>
	                <div class="doc-sub-inner">
	                    <input type="date" id="startDate${i}" data-placeholder="시작일자 선택">
	                    <span> ~ </span>
	                    <input type="date" id="endDate${i}" data-placeholder="종료일자 선택">
	                    <input type="text" id="task${i}" placeholder="업무내용">
	                </div>
	            </div>
	            <div class="doc-sub">
	                <span class="doc-sub-tit">출장비</span>
	                <div class="doc-sub-inner">
	                    <input type="text" id="accommodation${i}" placeholder="숙박비">
	                    <input type="text" id="dailyAllowance${i}" placeholder="일당">
	                    <input type="text" id="transportation${i}" placeholder="교통비">
	                    <input type="text" id="other${i}" placeholder="기타">
	                    	합계 : <input type="text" id="total${i}" placeholder="계">
	                </div>
	            </div>
	        </div>
				`;
			},
		},
	},
	main: {
		progress_ul: function (param) {

			let frst = param.apvLine.shift();
			let last = param.apvLine.pop();

			let middle = param.apvLine.find((e) => e.apvSttusCd == '0');
			let middleTxt;

			if (middle == undefined) {
				middle = param.apvLine[param.apvLine.length - 1];
			}

			if (param.apvLine.length > 1) {
				let length = param.apvLine.length - 1;
				middleTxt = "외" + " " + length + "인";
			} else middleTxt = "";


			// 검토자 진행현황
			function getMiddleStatus(apvLine) {
				let html = "";
				if (apvLine.length > 1) {
					html += `
		                <div class="middle-tooltip">
		                	<div class="tooltip-arrow" data-popper-arrow></div>
							<p class="heading2">검토자 결재 현황</p>
							<ul class="middle-wrap">`;

					apvLine.forEach((e, i) => {

						let cls;
						let apvSttusCd;
						switch (e.apvSttusCd) {
							case "0":
								cls = "wf-badge3";
								apvSttusCd = "대기";
								break;
							case "Y":
								cls = "wf-badge1";
								apvSttusCd = "승인";
								break;
							case "N":
								cls = "wf-badge5";
								apvSttusCd = "반려";
								break;
						}

						html += `
							<li>
								<div class="num">${i + 1}</div>
								<div class="img-wrap">
									<img src="${_ctx}/resources/img/icon/${e.proflImageUrl}">
								</div>
								<span class="emp">
									${e.empNm} 
									${e.apvRspnsbl != '팀원' ? e.apvRspnsbl : e.apvPosition}</span>
								<span class="${cls}">${apvSttusCd}</span>
							</li>
						`;
					});

					html += `</ul></div>`;
				}
				return html;
			}


			function getLastNm(obj) {
				return obj.apvRspnsbl != '팀원' ? obj.apvRspnsbl : obj.apvPosition;
			}

			function getStatusCls(obj) {
				let cls = {
					// 기안
					'1': {
						'0': 'pending',
						'Y': 'completed',
					},
					// 검토
					'2': {
						'0': 'wf-progress',
						'Y': 'completed',
					},
					// 결재
					'3': {
						'0': middle.apvSttusCd == 'Y' ? 'wf-progress' : 'pending',
						'Y': 'completed',
					}
				};
				return cls[obj.apvSeCd][obj.apvSttusCd];
			}

			const docFormInfo = {
				'품의서': { apvType: 'apv-type1', icon: 'doc_type1' },
				'출장신청서': { apvType: 'apv-type2', icon: 'doc_type2' },
				'도서구입신청서': { apvType: 'apv-type3', icon: 'doc_type3' }
			};

			const info = docFormInfo[param.docFormNm] || { apvType: 'apv-type1', icon: 'doc_type1' };
			const { apvType, icon } = info;

			return `
			<ul class="approval-process-wrap">
                <li class="process-icon">
                    <div class="icon"></div>
                </li>
                <li class="apvInfo" data-id="${param.apvNo}">
                    <div class="apv-type ${apvType}">
                        <span class="type-img">
                            <img src="/resources/img/approval/${icon}.png">
                        </span>
                        <span class="type-name">${param.docFormNm}</span>
                    </div>
                    <div class="apv-info">
                        <span class="tit">${param.apvSj}</span>
                        <span class="date">${param.drftDate}</span>
                    </div>
                    <ul class="timeline">
                        <li class="${getStatusCls(frst)} level1">
                            <div class="icon-box">
                                <span class="icon"></span>
                            </div>
                            <div class="emp-box">
                                <span class="img-wrap">
                                    <img src="/resources/img/icon/${frst.proflImageUrl}">
                                </span>
                                <span class="name">${frst.empNm} ${getLastNm(frst)}</span>
                            </div>
                        </li>
                        <li class="${getStatusCls(middle)} level2">
                            <div class="icon-box">
                                <span class="icon"></span>
                            </div>
                            <div class="emp-box">
                                <span class="img-wrap">
                                    <img src="/resources/img/icon/${middle.proflImageUrl}">
                                </span>
                                <span class="name">${middle.empNm} ${getLastNm(middle)} ${middleTxt}</span>
                            </div>
                            
                            <!-- 검토자 tooltip -->
							${getMiddleStatus(param.apvLine)}
							
                        </li>
                        <li class="${getStatusCls(last)} level3">
                            <div class="icon-box">
                                <span class="icon"></span>
                            </div>
                            <div class="emp-box">
                                <span class="img-wrap">
                                    <img src="/resources/img/icon/${last.proflImageUrl}">
                                </span>
                                <span class="name">${last.empNm} ${getLastNm(last)}</span>
                            </div>
                        </li>
                    </ul>
                </li>
            </ul>
			`;
		},
	},
	myList: {
		tab1: {
			colgroup: function () {
				return `
					<col style="width: auto;">
					<col style="width: auto;">
					<col style="width: auto;">
					<col style="width: auto;">
					<col style="width: auto;">
					<col style="width: auto;">
				`;
			},
			th_tr: function (param) {
				return `
					<tr>
                        <th>번호</th>
                        <th>문서종류</th>
                        <th>제목</th>
                        <th>기안자</th>
                        <th>소속부서</th>
                        <th>기안일시</th>
                    </tr>
				`;
			},
			tr: function (param) {
				let approver = getApprover(param);
				return `
					<tr data-apv-no='${param.apvNo}'>
						<td>${param.num}</td>
						<td>${param.docName}</td>
						<td>${param.apvSj}</td>
						<td>${param.empNm} ${approver}</td>
						<td>${param.deptNm}</td>
						<td>${param.drftDate}</td>
					</tr>
				`;
			},
		},
		tab2: {
			colgroup: function () {
				return `
					<col style="width: auto;">
					<col style="width: auto;">
					<col style="width: auto;">
					<col style="width: auto;">
					<col style="width: auto;">
					<col style="width: auto;">
				`;
			},
			th_tr: function (param) {
				return `
					<tr>
                        <th>번호</th>
                        <th>문서종류</th>
                        <th>제목</th>
                        <th>기안자</th>
                        <th>기안부서</th>
                        <th>기안일시</th>
                    </tr>
				`;
			},
			tr: function (param) {
				let approver = getApprover(param);
				return `
					<tr data-apv-no='${param.apvNo}'>
						<td>${param.num}</td>
						<td>${param.docName}</td>
						<td>${param.apvSj}</td>
						<td>${param.empNm} ${approver}</td>
						<td>${param.deptNm}</td>
						<td>${param.drftDate}</td>
					</tr>
				`;
			},
		},
		tab3: {
			colgroup: function () {
				return `
					<col style="width: auto;">
					<col style="width: auto;">
					<col style="width: auto;">
					<col style="width: auto;">
					<col style="width: auto;">
					<col style="width: auto;">
					<col style="width: auto;">
				`;
			},
			th_tr: function (param) {
				return `
					<tr>
                        <th>번호</th>
                        <th>문서종류</th>
                        <th>제목</th>
                        <th>기안자</th>
                        <th>소속부서</th>
                        <th>기안일시</th>
                        <th>최종결재일시</th>
                    </tr>
				`;
			},
			tr: function (param) {
				let approver = getApprover(param);
				return `
					<tr data-apv-no='${param.apvNo}'>
						<td>${param.num}</td>
						<td>${param.docName}</td>
						<td>${param.apvSj}</td>
						<td>${param.empNm} ${approver}</td>
						<td>${param.deptNm}</td>
						<td>${param.drftDate}</td>
						<td>${param.apvDate}</td>
					</tr>	
				`;
			},
		},
		tab4: {
			colgroup: function () {
				return `
					<col style="width: auto;">
					<col style="width: auto;">
					<col style="width: auto;">
					<col style="width: auto;">
					<col style="width: auto;">
				`;
			},
			th_tr: function (param) {
				return `
					<tr>
                        <th>번호</th>
                        <th>문서종류</th>
                        <th>제목</th>
                        <th>기안일시</th>
                        <th>반려일시</th>
                    </tr>
				`;
			},
			tr: function (param) {
				return `
					<tr data-apv-no='${param.apvNo}'>
						<td>${param.num}</td>
						<td>${param.docName}</td>
						<td>${param.apvSj}</td>
						<td>${param.drftDate}</td>
						<td>${param.refuseDate}</td>
					</tr>		
				`;
			},
		},
		tab5: {
			colgroup: function () {
				return `
					<col style="width: auto;">
					<col style="width: auto;">
					<col style="width: auto;">
					<col style="width: auto;">
					<col style="width: auto;">
				`;
			},
			th_tr: function (param) {
				return `
					<tr>
                        <th>번호</th>
                        <th>문서종류</th>
                        <th>제목</th>
                        <th>회수일시</th>
                        <th></th>
                    </tr>
				`;
			},
			tr: function (param) {
				return `
					<tr data-apv-no='${param.apvNo}' class="default-cursor">
						<td>${param.num}</td>
						<td>${param.docName}</td>
						<td>${param.apvSj}</td>
						<td>${param.drftDate}</td>
						<td>
							<button type="button" class="btn7 write-btn">재기안</button>
							<button type="button" class="btn4 del-btn">삭제</button>
						</td>
					</tr>	
				`;
			},
		},
		tab6: {
			colgroup: function () {
				return `
					<col style="width: auto;">
					<col style="width: auto;">
					<col style="width: auto;">
					<col style="width: auto;">
					<col style="width: auto;">
				`;
			},
			th_tr: function (param) {
				return `
					<tr>
                        <th>번호</th>
                        <th>문서종류</th>
                        <th>제목</th>
                        <th>임시저장일시</th>
                        <th></th>
                    </tr>
				`;
			},
			tr: function (param) {
				return `
					<tr data-apv-no='${param.apvNo}'>
						<td>${param.num}</td>
						<td>${param.docName}</td>
						<td>${param.apvSj}</td>
						<td>${param.drftDate}</td>
						<td>
							<button type="button" class="btn7 write-btn">재기안</button>
							<button type="button" class="btn4 del-btn">삭제</button>
						</td>
					</tr>	
				`;
			},
		},
		noData: function () {
			return '<tr><td colspan="10" style="text-align: center;">문서가 없습니다.</td></tr>';
		},
	},
	deptList: {
		tr: function (param) {
			let approver = getApprover(param);
			return `
				<tr data-apv-no='${param.apvNo}'>
					<td>${param.num}</td>
					<td>${param.docName}</td>
					<td>${param.deptNm}</td>
					<td>${param.apvSj}</td>
					<td>${param.empNm} ${approver}</td>
					<td>${param.apvDate}</td>
				</tr>	
			`;
		},
	},
	create: {
		main: {
			apvLine: {
				selected_li: function (param) {
					return `
						<li>
			                <div class="user">
			                	<span class="dept">${param.deptNm}</span>
			                    <span>${param.empNm}</span>
			                    <span>${param.rspnsblCtgryNm == '팀원' ? param.positionNm : param.rspnsblCtgryNm}</span>
			                </div>
			                <span class="approval-status${param.apvSeCd}">${param.apvSeCdNm}</span>
			            </li>
					`;
				},
			},
			refer: {
				selected_li: function (param) {
					return `
						<li>
			                <div class="user">
			                	<span class="dept">${param.deptNm}</span>
			                    <span>${param.empNm}</span>
			                    <span>${param.rspnsblCtgryNm == '팀원' ? param.positionNm : param.rspnsblCtgryNm}</span>
			                </div>
			            </li>
					`;
				},
			}
		},
		modal: {
			apvLine: {
				selected_li: function (param) {
					return `
						<li draggable="${param.isDraggable}" style="${!param.isDraggable ? 'cursor: default;' : ''}">
			                <div class="user">
			                    <span class="dept">${param.deptNm}</span>
			                    <span>${param.empNm}</span>
						        <span>${param.positionNm}</span>
			                </div>
			                <div class="wf-select-group">
			                    <select ${param.isDisabled ? 'disabled' : ''}>
			                    	<option value="">선택</option>
			                    	${param.options}
								</select>
			                </div>
			            </li>
					`;
				},
				bkmk_li: function (param) {
					return `
						<li>
							<input type="text" class="update-input" placeholder="변경할 즐겨찾기명" value="${param.bkmkNm}" readonly>
		                    <div class="button-wrap">
		                    	<button type="button" class="modify-btn"></button>
		                    	<button type="button" class="save-btn" style="position:absolute; left:-99999999999px;"></button>
		                    	<button type="button" class="delete-btn"></button>
		                    </div>
		                </li>
					`;
				},
			},
			refer: {
				selected_li: function (param) {
					return `
						<li draggable="${param.isDraggable}">
							<div class="user">
								<span class="dept">${param.deptNm}</span>
								<span>${param.empNm}</span>
								<span>${param.positionNm}</span>
							</div>
						</li>
					`;
				},
			},
			bkmkNodata: function () {
				return `
					<li class="noData">
						<i class="xi-star-o"></i>
						<strong>현재 저장된 즐겨찾기가 없습니다.</strong>
						<span>자주쓰는 결재선을 즐겨찾기 해보세요.</span>
					</li>
				`
			}
		}
	},
	detail: {
		tr: function (param) {
			return `
				<table>
                    <tbody>
                        <tr>
                            <th>출장자</th>
                            <td>${param[0].name}</td>
                            <th>소속</th>
                            <td>${param[1].dept}</td>
                            <th>직급</th>
                            <td>${param[2].position}</td>
                        </tr>
                        <tr>
                            <th>사번</th>
                            <td>${param[3].empId}</td>
                            <th>출장지</th>
                            <td>${param[4].destination}</td>
                            <th>시작일자</th>
                            <td>${param[5].startDate}</td>
                        </tr>
                        <tr>
                            <th>종료일자</th>
                            <td>${param[6].endDate}</td>
                            <th>업무내용</th>
                            <td colspan="3">${param[7].task}</td>
                        </tr>
                        <tr>
                            <th>숙박비</th>
                            <td>${param[8].accommodation}</td>
                            <th>일당</th>
                            <td>${param[9].dailyAllowance}</td>
                            <th>교통비</th>
                            <td>${param[10].transportation}</td>
                        </tr>
                        <tr>
                            <th>기타</th>
                            <td>${param[11].other}</td>
                            <th>합계</th>
                            <td colspan="3">${param[12].total}</td>
                        </tr>
                    </tbody>
                </table>
			`;
		}
	}
};

// 팀장급 이상이면 직책으로 출력
function getApprover(param) {
	return param.apvRspnsbl !== '팀원' ? param.apvRspnsbl : param.apvPosition;
}