let _apvSeCds = []; // 결재구분코드
const _html = _HTML.create;
$(function () {
	// 결재구분코드 조회 및 전역변수 저장
	getSeCds();

	// 결재 라인 모달 활성화
	$('#apv_modal_btn').on('click', openApprovalModal);
	// 결재 라인 모달 탭 클릭
	$('#APV_LINE_MODAL #MODAL_BKMK_BTN, #MODAL_EMP_BTN').click(clearApvLineInModal);
	// 즐겨찾기 저장 버튼 클릭 
	$('#MODAL_BKMK_SAVE_BTN').click(saveBkmk);
	// 확인 버튼 클릭 
	$('#MODAL_APV_LINE_SAVE_BTN').click(saveApvLine);
});

// 결재구분코드 조회 및 전역변수 저장
function getSeCds() {
	$.ajax({
		url: `${_ctx}/approval/getCommonCode`,
		type: 'get',
		success: (result) => {
			_apvSeCds = result;
		}
	});
}

// 결재라인 모달 활성화
function openApprovalModal() {
	// 모달 활성화
	$('#APV_LINE_MODAL').addClass('open');
	$('html').addClass('scroll-hidden');

	drawBkmkList();
	drawEmpList();
}

// 탭 클릭 시 화면 초기화 
function clearApvLineInModal(e) {
	let id = e.currentTarget.id;

	// 결재라인 비우기
	$('#MODAL_APV_LINE_LIST').empty();

	if (id === 'MODAL_BKMK_BTN') {

	}
	else {
		$('.bookmark-list li').removeClass('active');
	}
}

// 즐겨찾기 목록 생성
function drawBkmkList() {
	$.ajax({
		url: `${_ctx}/approval/getBkmkList`,
		type: 'get',
		success: (result) => {
			if (result.length > 0) {
				let ul = $('ul#MODAL_BKMK_LIST');
				ul.empty();
				result.forEach((e) => {
					// bkmk li html 생성
					let html = _html.modal.apvLine.bkmk_li(e);
					// event, prop 추가
					html = $(html)
						// 즐겨찾기 결재라인 표시 이벤트 추가
						.click((e) => {
							// 버블링으로 인한 자식들(button) 일 경우 예외처리
							if ($(e.target).is('button')) {
								return false;
							}
							let info = e.currentTarget.info;
							$(e.currentTarget).addClass('active').siblings('li').removeClass('active');
							drawBkmkApvLine(info);
						})
						// 즐겨찾기 삭제 이벤트 추가
						.find('.delete-btn')
						.click(clickDeleteBkmk).end()
						// 즐겨찾기 수정 이벤트 추가
						.find('.modify-btn')
						.click(clickUpdateBkmk).end()
						// 즐겨찾기 저장 이벤트 추가 
						.find('.save-btn')
						.click(clickSaveBkmk).end()
						.prop('info', e);
					ul.append(html);
				});
			} else {
				let html = _html.modal.bkmkNodata();
				$('#MODAL_BKMK_LIST').append(html);
			}
		}
	});
}

// 즐겨찾기 삭제
function clickDeleteBkmk(e) {
	let info = $(e.currentTarget).closest('li').prop('info');
	// if (confirm(_msg.common.deleteConfirm)) {
	// 	$.ajax({
	// 		url: `${_ctx}/approval/deleteBkmk`,
	// 		type: 'delete',
	// 		contentType: "application/json;charset=utf-8",
	// 		data: JSON.stringify(info.bkmkNo),
	// 		dataType: 'text',
	// 		success: (result) => {

	// 			if (result > 0) {
	// 				alert(_msg.common.deleteSuccessAlert);
	// 				$('#MODAL_APV_LINE_LIST').empty();
	// 				drawBkmkList();
	// 			} else {
	// 				alert(_msg.common.deleteFailAlert);
	// 			}
	// 		}
	// 	});
	// }

	Swal.fire({
		title: _msg.common.deleteConfirm,
		showDenyButton: true,
		confirmButtonText: "삭제",
		denyButtonText: "취소",
	}).then((result) => {
		if (result.isConfirmed) {
			$.ajax({
				url: `${_ctx}/approval/deleteBkmk`,
				type: 'delete',
				contentType: "application/json;charset=utf-8",
				data: JSON.stringify(info.bkmkNo),
				dataType: 'text',
				success: (data) => {
					if (data > 0) {
						Toast.fire({
							icon: "success",
							title: _msg.common.deleteSuccessAlert,
						});

						$('#MODAL_APV_LINE_LIST').empty();
						drawBkmkList();
					} else {
						Toast.fire({
							icon: "info",
							title: _msg.common.deleteFailAlert,
						});
					}
				}
			});

		} else if (result.isDenied) {
			Toast.fire({
				icon: "info",
				title: _msg.common.deleteFailAlert,
			});
		}
	});
}

// 즐겨찾기 수정 버튼
function clickUpdateBkmk(e) {
	let info = $(e.currentTarget).closest('li').prop('info');

	let btn = $(e.currentTarget);
	let input = btn.closest('li').find('.update-input');

	btn.css({ 'position': 'absolute', 'left': '-99999999999px' });
	btn.siblings('.save-btn').css({ 'position': 'static' });

	input.prop('readonly', false);
}

// 즐겨찾기 수정 저장 버튼
function clickSaveBkmk(e) {

	Swal.fire({
		title: _msg.common.insertConfirm,
		showDenyButton: true,
		confirmButtonText: "확인",
		denyButtonText: "취소",
	}).then((result) => {
		if (result.isConfirmed) {
			let info = $(e.currentTarget).closest('li').prop('info');

			let btn = $(e.currentTarget);
			let input = btn.closest('li').find('.update-input');

			let newName = input.val().trim();

			// 입력하지 않았을 때
			if (!newName) {
				Toast.fire({
					icon: "info",
					title: _msg.approval.fillEmptyFieldsAlert,
				});
				input.css('border', '1px solid #00a287');
			}
			// 입력했을 때
			else {
				$.ajax({
					url: `${_ctx}/approval/updateBkmk`,
					type: 'put',
					data: JSON.stringify({
						bkmkNo: info.bkmkNo,
						bkmkNm: newName
					}),
					contentType: "application/json;charset=utf-8",
					dataType: 'text',
					success: (data) => {
						if (data > 0) {
							Toast.fire({
								icon: "success",
								title: _msg.common.updateSuccessAlert,
							});
							drawBkmkList();
							input.prop('readonly', true);

							// 저장버튼 안보이게, 수정버튼 보이게
							btn.css({ 'position': 'absolute', 'left': '-99999999999px' });
							btn.siblings('modify-btn').css({ 'position': 'static' });
						} else {
							Toast.fire({
								icon: "info",
								title: _msg.common.updateFailAlert,
							});
						}
					}
				});
			}

		}
	});


}

// 즐겨찾기 결재라인 생성
function drawBkmkApvLine(data) {
	// 결재라인 목록 비우기
	let ul = $('#APV_LINE_MODAL ul#MODAL_APV_LINE_LIST');
	ul.empty();

	$.ajax({
		url: `${_ctx}/approval/getBkmkDetail?bkmkNo=` + data.bkmkNo,
		type: 'get',
		success: (data) => {
			data
				.sort((a, b) => a.apvLineSeq - b.apvLineSeq)
				.forEach(function (e) {

					let html = _html.modal.apvLine.selected_li({
						options: _apvSeCds.reduce((acc, e2) => {
							return acc += `
						<option value="${e2.cmmnCd}" ${e.apvSeCd == e2.cmmnCd ? 'selected' : ''}>
						${e2.cmmnCdNm}</option>
						`;
						}, ''),
						positionNm: `${e.rspnsblCtgryNm == '팀원' ? e.cmmnCdNm : e.rspnsblCtgryNm}`,
						isDisabled: true,
						isDraggable: false,
						...e
					});
					html = $(html).find('select')
						//.mouseenter(changeApvSeCdInModal)
						//.change(changeApvSeCdInModal)
						.end().prop('info', {
							empNo: e.empNo,
							empNm: e.empNm,   // 이름
							deptNm: e.deptNm,
							positionNm: e.cmmnCdNm, // 직급
							rspnsblCtgryNm: e.rspnsblCtgryNm, // 직책
						});
					ul.append(html);
				});
			//dragAndDrop();
		}
	});
}

// 부서 목록 생성
function drawEmpList() {
	$.ajax({
		url: `${_ctx}/approval/getEmpList`,
		type: 'get',
		success: (result) => {
			if (Array.isArray(result)) {

				_emp = result.reduce((acc, e) => {

					let state = {
						opened: false,
						disabled: false,
						selected: false
					}

					// 부서
					if (!acc.tmpDeptNoList.includes(e.DEPT_NO)) {
						acc.arr.push({
							id: e.DEPT_NO,
							text: e.DEPT_NM,
							parent: e.UPPER_DEPT || '#',
							state: state,
							type: 'dept',
						});
						acc.tmpDeptNoList.push(e.DEPT_NO)
					}


					// 직원 
					acc.arr.push(
						Object.assign({
							id: e.EMP_NO,
							text: `${e.EMP_NM} ${e.RSPNSBL_CTGRY_NM == '팀원' ? e.POSITION_NM : e.RSPNSBL_CTGRY_NM}`,
							parent: e.DEPT_NO,
							state: state,
							type: 'emp',
						}, e)
					);

					return acc;
				}, {
					arr: [],
					tmpDeptNoList: [],
				}).arr;

				$('#APV_LINE_MODAL #MODAL_EMP_LIST').jstree({
					core: {
						data: _emp,
						multiple: true,
						animation: 100
					},
					checkbox: {
						keep_selected_style: false
					},
					plugins: [
						'types',
						'wholerow',
						'checkbox'
					],
					default: {
						"icon": "ico-dir"
					}
				}).on('changed.jstree', drawSelectedApvLine);
			}
		}
	});
}

// 부서 선택 결재라인 생성 
function drawSelectedApvLine(event, e) {
	let selectedEmp = _emp.filter((emp) => e.selected.includes(emp.EMP_NO));
	console.log(selectedEmp);

	$('#MODAL_APV_LINE_LIST').empty();
	selectedEmp.forEach((e) => {

		// 선택된 결재라인 li 생성 
		let html = _html.modal.apvLine.selected_li({
			deptNm: e.DEPT_NM,
			empNm: e.EMP_NM,
			positionNm: `${e.RSPNSBL_CTGRY_NM == '팀원' ? e.POSITION_NM : e.RSPNSBL_CTGRY_NM}`,
			options: _apvSeCds.reduce((acc, e2) => {
				return acc += `
				<option value="${e2.cmmnCd}"}>
				${e2.cmmnCdNm}</option>
				`;
			}, ''),
			isDraggable: true
		});

		// change event, prop 추가
		html = $(html).find('select')
			.mouseenter(changeApvSeCdInModal)
			.change(changeApvSeCdInModal)
			.end().prop('info', {
				empNo: e.EMP_NO,
				empNm: e.EMP_NM,   // 이름
				deptNm: e.DEPT_NM,
				positionNm: e.POSITION_NM, // 직급
				rspnsblCtgryNm: e.RSPNSBL_CTGRY_NM, // 직책
				isDraggable: true
			});

		$('#MODAL_APV_LINE_LIST').append(html);
	});
	dragAndDrop();
}

// 결재라인 구분코드 변경 이벤트, 유효성검사 및 정렬
function changeApvSeCdInModal(e) {
	let info = $(e.currentTarget).closest('li').prop('info');
	let seCd = e.currentTarget.value;
	let prevSeCd = e.currentTarget._prevSeCd;

	// 이전값 저장
	if (e.type == 'mouseenter') {
		e.currentTarget._prevSeCd = seCd;
		return;
	}

	// 구분코드 기안 선택, 선택한 li의 empNo와 현재 접속자 empNo 가 다를 때 
	if (seCd === '1' && info.empNo !== $('input:hidden#empNo').val()) {
		Toast.fire({
			icon: "info",
			title: _msg.approval.errorCheckAlert1,
		});
		$(e.currentTarget).val(prevSeCd);
	}
	// 현재 작성자(=기안자)가 기안말고 다른 구분코드 선택했을 때
	if (info.empNo == $('input:hidden#empNo').val() && !['', '1'].includes(seCd)) {
		Toast.fire({
			icon: "info",
			title: _msg.approval.errorCheckAlert1,
		});
		$(e.currentTarget).val(prevSeCd);
	}

	//let arr = $(e.currentTarget).closest('ul').find('select').toArray()
	//	.sort((a, b) => Number(a.value) - Number(b.value))
	//	.map((e) => $(e).closest('li')[0]);
	//$('#MODAL_APV_LINE_LIST').html(arr);
}

// 선택된 결재라인 드래그앤드롭
function dragAndDrop() {
	const $ = (select) => document.querySelectorAll(select);
	const draggables = $('#MODAL_APV_LINE_LIST li');
	const containers = $('#MODAL_APV_LINE_LIST');

	draggables.forEach(el => {
		el.addEventListener('dragstart', () => {
			el.classList.add('dragging');
		});

		el.addEventListener('dragend', () => {
			el.classList.remove('dragging')
		});
	});

	function getDragAfterElement(container, y) {
		const draggableElements = [...container.querySelectorAll('#MODAL_APV_LINE_LIST li:not(.dragging)')]

		return draggableElements.reduce((closest, child) => {
			const box = child.getBoundingClientRect() //해당 엘리먼트에 top값, height값 담겨져 있는 메소드를 호출해 box변수에 할당
			const offset = y - box.top - box.height / 2  //수직 좌표 - top값 - height값 / 2의 연산을 통해서 offset변수에 할당
			if (offset < 0 && offset > closest.offset) { // (예외 처리) 0 이하 와, 음의 무한대 사이에 조건
				return { offset: offset, element: child } // Element를 리턴
			} else {
				return closest
			}
		}, { offset: Number.NEGATIVE_INFINITY }).element
	};

	containers.forEach(container => {
		container.addEventListener('dragover', e => {
			e.preventDefault()
			const afterElement = getDragAfterElement(container, e.clientY);
			const draggable = document.querySelector('.dragging')
			// container.appendChild(draggable)
			container.insertBefore(draggable, afterElement)
		})
	});
}

// 현재 선택된 결재 라인 체크 (순서)
function checkApvLine() {
	let isOk = true,
		msg = '';
	// 선택된 결재라인 코드 리스트
	let list = $('#MODAL_APV_LINE_LIST li select').toArray().map((e) => e.value);

	// 결재라인 미선택 
	if (list.length == 0) {
		isOk = !isOk;
		msg = _msg.approval.errorCheckApvLineEmptyAlert;
	}
	// 결재구분 미선택 
	else if (list.includes('')) {
		isOk = !isOk;
		msg = _msg.approval.errorCheckApvLineExistNoSeCdAlert;
	}
	// 기안자 누락 체크
	else if (!list.includes('1')) {
		isOk = !isOk;
		msg = _msg.approval.errorCheckApvLine1Alert;
	}
	// 결재자 누락 체크 
	else if (!list.includes('3')) {
		isOk = !isOk;
		msg = _msg.approval.errorCheckApvLine3Alert;
	}
	// 결재 라인 순서 체크
	else if (list.filter((e, i, arr) => e > arr[i + 1]).length > 0) {
		isOk = !isOk;
		msg = _msg.approval.errorCheckApvLineOrderAlert;
	}
	return { isOk: isOk, msg: msg };
}

// 즐겨찾기 저장
function saveBkmk(e) {
	let { isOk, msg } = checkApvLine();
	if (!isOk) {
		Toast.fire({
			icon: "info",
			title: msg,
		});
	} else {
		Swal.fire({
			title: _msg.common.saveConfirm,
			showDenyButton: true,
			confirmButtonText: "저장",
			denyButtonText: "취소",
		}).then((result) => {
			if (result.isConfirmed) {
				let data = $('#MODAL_APV_LINE_LIST li').toArray().map((e, i) => {
					let info = e.info;
					return {
						empNo: info.empNo,
						apvSeCd: $(e).find('select').val(),
						apvLineSeq: i + 1,
					}
				});

				$.ajax({
					url: `${_ctx}/approval/createBkmk`,
					type: 'post',
					data: JSON.stringify({
						bkmkNm: '즐겨찾기',
						bkmkDetail: data
					}),
					contentType: "application/json;charset=utf-8",
					success: (data) => {

						if (data > 0) {
							Toast.fire({
								icon: "success",
								title: _msg.common.saveSuccessAlert,
							});
							// 즐겨찾기 목록조회
							drawBkmkList();
							// 즐겨찾기 탭 클릭
							$('#MODAL_BKMK_BTN').trigger('click');
						} else {
							Toast.fire({
								icon: "info",
								title: _msg.common.saveFailedAlert,
							});
						}
					}
				});

			} else if (result.isDenied) { }
		});
		// if (confirm(_msg.common.saveConfirm)) {
		// 	let data = $('#MODAL_APV_LINE_LIST li').toArray().map((e, i) => {
		// 		let info = e.info;
		// 		return {
		// 			empNo: info.empNo,
		// 			apvSeCd: $(e).find('select').val(),
		// 			apvLineSeq: i + 1,
		// 		}
		// 	});

		// 	$.ajax({
		// 		url: `${_ctx}/approval/createBkmk`,
		// 		type: 'post',
		// 		data: JSON.stringify({
		// 			bkmkNm: '즐겨찾기',
		// 			bkmkDetail: data
		// 		}),
		// 		contentType: "application/json;charset=utf-8",
		// 		success: (result) => {
		// 			console.log('result : ', result);
		// 			alert(_msg.common.saveSuccessAlert);

		// 			// 즐겨찾기 목록조회
		// 			drawBkmkList();
		// 			// 즐겨찾기 탭 클릭
		// 			$('#MODAL_BKMK_BTN').trigger('click');
		// 		}
		// 	});
		// }
	}
}

// 결재라인 저장
function saveApvLine(e) {
	let { isOk, msg } = checkApvLine();
	if (!isOk) {
		alert(msg);
	} else {
		Swal.fire({
			title: _msg.approval.apvLineConfirm,
			showDenyButton: true,
			confirmButtonText: "확인",
			denyButtonText: "취소",
		}).then((result) => {
			if (result.isConfirmed) {

				// 이전 내용 비우기
				let list = $('#apv_line1');
				list.removeClass('no-data');
				list.empty();

				$('#MODAL_APV_LINE_LIST li').toArray().forEach((e, i) => {
					let info = e.info;

					let apvSeCd = $(e).find('select').val();
					let newInfo = {
						...info,
						apvSeCd: apvSeCd,
						apvLineSeq: i + 1,
						apvSeCdNm: _apvSeCds.filter((e) => e.cmmnCd == apvSeCd)[0].cmmnCdNm
					};

					let html = _html.main.apvLine.selected_li(newInfo);
					html = $(html).prop('info', newInfo);
					list.append(html);
				});

				$('#APV_LINE_MODAL').removeClass('open');

			} else if (result.isDenied) { }
		});
	}
}

