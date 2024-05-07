
$(function () {

	// 참조인선택 클릭시 참조인 선택 모달 활성화
	$('#APV_REFER_MODAL_BTN').on('click', openReferModal);

	// 확인 버튼 클릭 
	$('#MODAL_APV_REFER_SAVE_BTN').click(saveRefer);

});

// 참조인 모달 활성화
function openReferModal() {
	// 모달 활성화
	$('#APV_REFER_MODAL').addClass('open');
	$('html').addClass('scroll-hidden');

	// 부서 조직도
	drawEmpListRefer();
}

// 직원 목록 조회
function drawEmpListRefer() {
	$.ajax({
		url: `${_ctx}/approval/getEmpList`,
		type: 'get',
		success: (result) => {
			if (Array.isArray(result)) {

				_emp = result.reduce((acc, e) => {

					let state = {
						opened: true,
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

				$('#APV_REFER_MODAL .container').jstree({
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
				}).on('changed.jstree', drawSelectedRefer);
				//.on('select_node.jstree', drawSelectedRefer);
			}
		}
	});

}

// 직원 선택
function drawSelectedRefer(event, e) {
	let selectedEmp = _emp.filter((emp) => e.selected.includes(emp.EMP_NO));
	console.log(selectedEmp);

	$('#MODAL_APV_REFER_LIST').empty();
	selectedEmp.forEach((e) => {

		// 선택된 결재라인 li 생성 
		let html = _html.modal.refer.selected_li({
			deptNm: e.DEPT_NM,
			empNm: e.EMP_NM,
			positionNm: `${e.RSPNSBL_CTGRY_NM == '팀원' ? e.POSITION_NM : e.RSPNSBL_CTGRY_NM}`,
			isDraggable: true
		});

		// change event, prop 추가
		html = $(html).prop('info', {
			empNo: e.EMP_NO,
			empNm: e.EMP_NM,   // 이름
			deptNm: e.DEPT_NM,
			positionNm: e.POSITION_NM, // 직급
			rspnsblCtgryNm: e.RSPNSBL_CTGRY_NM, // 직책
			isDraggable: true
		});

		$('#MODAL_APV_REFER_LIST').append(html);
	});
}


// 참조자 선택 저장
function saveRefer() {
	Swal.fire({
		title: _msg.approval.apvReferConfirm,
		showDenyButton: true,
		confirmButtonText: "확인",
		denyButtonText: "취소",
	}).then((result) => {
		if (result.isConfirmed) {

			// 이전 내용 비우기
			let list = $('#apv_line2');
			list.removeClass('no-data');
			list.empty();

			$('#MODAL_APV_REFER_LIST li').toArray().forEach((e, i) => {
				let info = e.info;
				console.log("info:", info);
				let html = _html.main.refer.selected_li(info);
				html = $(html).prop('info', info);
				list.append(html);
			});

			$('#APV_REFER_MODAL').removeClass('open');

		} else if (result.isDenied) { }
	});

}