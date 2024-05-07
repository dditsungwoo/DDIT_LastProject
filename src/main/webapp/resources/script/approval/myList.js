let _pagination;
let _tab, _tabPrev;
$(function () {

	// 기존  click event 삭제, 추가
	$('.tab-btn').off('click').on('click', (e) => {
		_tabPrev = _tab;
		_tab = `tab${$(e.currentTarget).index() + 1}`;
		createTable();

		$('.tab-content').removeClass('active')
		// active
		$(e.currentTarget).addClass('active').siblings('button').removeClass('active');
		// indicator
		const buttonRect = e.currentTarget.getBoundingClientRect();
		const tabIndicatorOffset = buttonRect.left - $(e.currentTarget).parent()[0].getBoundingClientRect().left;
		$('.tab-indicator').css({ width: `${buttonRect.width}px`, transform: `translateX(${tabIndicatorOffset}px)` });

		$('.tab-content').addClass('active');
	});


	_pagination = new Pagination({
		search: {
			SEARCH_TYPE: {
				target: $('#SEARCH_TYPE'),
			},
			SEARCH_VALUE: {
				target: $('#SEARCH_VALUE'),
			}
		},
		pagination: {
			rowSize: 10,
			pageListTarget: $('ul#PAGINAION'),
			onClickAll: createTable,
		},
	});


	$('input#SEARCH_VALUE').keypress(function (e) {
		if (e.keyCode === 13) createTable();
	});

	// 검색 버튼 클릭 
	$('button#SEARCH_BTN').click(createTable);

	let paramMap = getParamMap();
	let tabNum = paramMap['tabId'];
	if (tabNum && !isNaN(Number(tabNum)) && Number(tabNum) < 7) {
		$(`.tab-btn:eq(${Number(paramMap['tabId']) - 1})`).click();
	} else {
		$('.tab-btn:eq(0)').click();
	}

});


function createTable() {

	let colgroup = $('.tab-content colgroup');
	let thead = $('.tab-content thead');
	let tbody = $('.tab-content tbody');

	/* tab 이동여부 체크  */
	if (_tab != _tabPrev) {
		_pagination.setPage(1);
		$('#SEARCH_TYPE').val('');
		$('#SEARCH_VALUE').val('');
		_tabPrev = _tab;
	}

	let param = _pagination.getParameter();
	console.log("param->", param);

	$.ajax({
		url: `${_ctx}/approval/listView/${_tab}`,
		type: 'get',
		data: param,
		dataType: 'json',
		success: function (data) {

			colgroup.empty();
			thead.empty();
			tbody.empty();

			let html = _HTML.myList[_tab];
			colgroup.append(html.colgroup());
			thead.append(html.th_tr());

			let { LIST, PAGE, ROWSIZE } = data;

			if (Array.isArray(LIST) && LIST.length > 0) {
				LIST.forEach((e, i) => {

					let tr = html.tr({
						docName: _HTML.msg.docNm[e.docFormNo],
						...e
					});
					tbody.append(tr);
				});
			} else {
				tbody.append(_HTML.myList.noData());
			}

			// pagination 세팅
			_pagination.setPage(parseInt(data.PAGE)).setRowCount(data.ROWCOUNT).makePagination();
		}
	});
}

// 상세 조회
$(document).on('click', '.wf-table tbody tr', function () {
	let apvNo = $(this).data('apvNo');

	let writeBtn = $(document).find('.write-btn'); // 재기안버튼

	// 회수 제외 나머지 문서함
	if (!writeBtn.length > 0) {
		$.ajax({
			url: `${_ctx}/approval/approvalDetailView?apvNo=` + apvNo,
			type: 'get',
			dataType: 'text',
			success: function () {
				location.href =
					"/approval/approvalDetailView?apvNo=" + apvNo;

			}
		});
	}
	// 회수
	else {

		// 재기안
		$('.write-btn').on('click', (e) => {
			let apvNo = $(e.currentTarget).parent().parent().data('apvNo');
			location.href = `${_ctx}/approval/reWriteView?apvNo=` + apvNo;
		});

		// 삭제
		$('.del-btn').on('click', (e) => {
			let apvNo = $(e.currentTarget).parent().parent().data('apvNo');

			Swal.fire({
				title: _msg.common.deleteConfirm,
				showDenyButton: true,
				confirmButtonText: "삭제",
				denyButtonText: "취소",
			}).then((result) => {
				if (result.isConfirmed) { // 컨펌 확인 버튼 누르면

					$.ajax({
						url: `${_ctx} /approval/deleteDraft`,
						type: 'delete',
						data: JSON.stringify(apvNo),
						dataType: 'text',
						success: (data) => {
							if (data > 0) {
								Toast.fire({
									icon: "success",
									title: _msg.common.deleteSuccessAlert,
								});
								createTable();
							} else {
								Toast.fire({
									icon: "info",
									title: _msg.common.deleteFailAlert,
								});
							}
						}
					});

				} else if (result.isDenied) { // 컨펌 취소 버튼 누르면
					// 실패 알림 출력
					Toast.fire({
						icon: "info",
						title: _msg.common.deleteFailAlert,
					});
				}
			});
		});
	}

});

