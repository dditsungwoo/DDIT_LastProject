let _signPad;

window.addEventListener('load', function() {

	// 문서별 갯수
	getTotalCnt();

	// 결재완료 목록
	getCompletedOfMine();

	// 결재 대기
	getPending();

	// 결재 진행 현황
	getAllProgress();

	// 전자서명
	initSignPad();

	getSign();
	
	
});

// 상세 이동
$(document).on('click', '.apvInfo', (e) => {
	let apvNo = e.currentTarget.dataset.id;

	$.ajax({
		url: `${_ctx}/approval/approvalDetailView?apvNo=` + apvNo,
		type: 'get',
		dataType: 'text',
		success: () => {
			location.href = `${_ctx}/approval/approvalDetailView?apvNo=` + apvNo;
		}
	});

});

// 검토자 결재 현황 tooltip
/*$(document).on('mouseenter', '.level2', (e) => {
	$(e.currentTarget).find('.middle-tooltip').addClass('active');
	// $('.approval-process').css('overflow-y', 'visible');
	// $('.process-area').css('overflow', 'visible');
}).on('mouseleave', '.level2', (e) => {
	$(e.currentTarget).find('.middle-tooltip').removeClass('active');
	// $('.approval-process').css('overflow-y', 'auto');
	// $('.process-area').css('overflow', 'auto');
});*/


// 날짜 변환
function dateConverter(date) {
	return date.substring(0, 10);
}

// 문서별 갯수 조회
function getTotalCnt() {
	$.ajax({
		url: `${_ctx}/approval/mainView/totalCnt`,
		type: 'get',
		dataType: "json",
		success: (data) => {
			console.log("문서별갯수조회->", data);
			$('#pendingCnt').countNumber(0, data.pendingCnt);
			$('#progressCnt').countNumber(0, data.progressCnt);
			$('#completedCnt').countNumber(0, data.completedCnt);
			$('#rejectedCnt').countNumber(0, data.rejectedCnt);
		}
	});
}

// 대기 목록 조회
function getPending() {
	$.ajax({
		url: `${_ctx}/approval/mainView/pending`,
		type: 'get',
		dataType: 'json',
		success: (data) => {

			if (data.length > 0) {
				data.forEach((e) => {
					let HTML = `
						<li>
							<a href="${_ctx}/approval/approvalDetailView?apvNo=${e.apvNo}">
								<div class="img-wrap">
									<img src="${_ctx}/resources/img/icon/avatar.png">
								</div>
								<div class="emp-wrap">
									<div class="tit">${e.apvSj}</div>
									<div class="sub">
										<div class="empInfo">${e.empNm} ${e.apvPosition} ${e.deptNm}</div>
										<div class="date">${e.drftDate.split(' ')[0]}</div>
									</div>
								</div>
							</a>
						</li>
					`;
					$('#pending .form-list').append(HTML);
				});
			} else {
				let HTML = `
						<li style="display: flex; align-items: center; justify-content: center;
 						height: 100%; background: #6565650f;">결재할 문서가 없습니다.</li>
					`;
				$('#pending .form-list').append(HTML);
			}
		}
	});
}

// 결재 완료 목록 조회
function getCompletedOfMine() {
	$.ajax({
		url: `${_ctx}/approval/mainView/completed`,
		type: "GET",
		dataType: "json",
		success: function (data) {
			if (data.length > 0) {
				data.forEach((e) => {
					let HTML = `
						<li>
							<a href="${_ctx}/approval/approvalDetailView?apvNo=${e.apvNo}">
								<i class="xi-document"></i>
								<div class="tit">${e.apvSj}</div>
								<div class="date">${e.drftDate.split(' ')[0]}</div>
							</a>
						</li>
					`;
					$('#completed .form-list').append(HTML);
				});
			} else {
				let HTML = `
						<li style="display: flex; align-items: center; justify-content: center;
 						height: 100%; background: #6565650f;">결재완료된 문서가 없습니다.</li>
					`;
				$('#completed .form-list').append(HTML);
			}
		}
	});
}

// 결재 진행 현황
function getAllProgress() {
	$.ajax({
		url: `${_ctx}/approval/mainView/allProgress`,
		type: "GET",
		dataType: "json",
		success: function (data) {

			if (data.length > 0) {
				data = Object.values(data.reduce((acc, e) => {
					if (acc[e.apvNo] == undefined) {
						acc[e.apvNo] = {
							apvNo: e.apvNo,
							apvSj: e.apvSj,
							docFormNm: _HTML.msg.docNm[e.docFormNo],
							drftDate: e.drftDate.split(' ')[0],
							apvLine: [],
						};
					}
					acc[e.apvNo].apvLine.push({
						empNm: e.empNm,
						apvPosition: e.apvPosition,
						apvRspnsbl: e.apvRspnsbl,
						deptNm: e.deptNm,
						apvSttusCd: e.apvSttusCd,
						apvSeCd: e.apvSeCd,
						proflImageUrl: e.proflImageUrl
					});
					return acc;
				}, {})).sort((a, b) => b.apvNo - a.apvNo);

				data.forEach((e, i, arr) => {
					$('.process-cont').append(_HTML.main.progress_ul(e));
					
					let li = $(`[data-id=${e.apvNo}]`);
					
					if(li.find('div.middle-tooltip').length>0) {
						initPoper(li.find('li.level2')[0], li.find('div.middle-tooltip')[0]);
					}
				});
				
				
			} else {
				let html = `
					<div style="display: flex; background: #6565650f;
					align-items: center; justify-content: center; height: 100%;
					">현재 진행중인 결재가 없습니다.</div>
				`;
				$('.approval-process').append(html);
			}

		}
	});
}


function initSignPad() {
	// 서명 패드 
	_signPad = new SignPad({ canvas: $('canvas#SIGN_PAD_CANVAS')[0] }).setLineWidth(10);

	// 서명 버튼, 이미지 클릭
	$('#SIGN_BTN, img#SIGN_IMG').on('click', (e) => {
		$('#sign_modal').addClass('open');
		$('html').addClass('scroll-hidden');
		_signPad.eraseAll();
	});

	$('#sign_modal #RESET').click((e) => {
		_signPad.eraseAll();
	});
	$('#sign_modal #UPLOAD').click((e) => {
		$('#sign_modal input#FILE').click();
	});

	$('#sign_modal #DOWNLOAD').click((e) => {
		_signPad.download('sign', 'png');
	});

	$('input#FILE').change((e) => {
		let target = e.currentTarget,
			file = target.files[0],
			name = file.name,
			extension = name.substring(name.lastIndexOf('.')),
			whitelist = $(target).attr('accept') ? $(target).attr('accept').split(',').map((e) => e.trim()) : [];

		// 허용 확장자 아닐 경우
		if (!whitelist.includes(extension)) {
			Toast.fire({
				icon: "info",
				title: "whitelist.join(',') + ' 확장자만 가능합니다.'",
			});
		}
		// 허용 확장자 일 경우
		else {
			if (_signPad) {
				_signPad.setImageFile(e.currentTarget.files[0]);
				$('span.sign-pad-txt').css('display', 'none');
			}
		}
	});

	$('#CANCEL_BTN').click((e) => {
		$('#SIGNPAD_CLOSE').trigger('click');
	});

	$('#SAVE_BTN').click((e) => {
		let isEmpty = _signPad.isEmpty();
		if (!isEmpty) {
			// 이미지 그리기, 보여주기
			$('img#SIGN_IMG').prop('src', _signPad.getDataURL('image/png')).show();
			// 버튼 숨기기
			$('button#SIGN_BTN').hide();
			// 파일 객체로 변환
			let signFile = _signPad.getFile(`sign_${new Date().getTime()}`);
			// input에 file 추가  
			let df = new DataTransfer();
			df.items.add(signFile);
			$('input#SIGN_FILE')[0].files = df.files;
			$('#SIGNPAD_CLOSE').trigger('click');

			let formData = new FormData();
			formData.append('file', $('input#SIGN_FILE')[0].files[0])

			$.ajaxSettings.traditional = true;
			$.ajax({
				url: `${_ctx}/approval/signUpload`,
				type: 'post',
				data: formData,
				processData: false,
				contentType: false,
				// enctype: 'multipart/form-data',
				dataType: 'text',
				cache: false,
				success: function (data) {
					if (data > 0) {
						Toast.fire({
							icon: "success",
							title: _msg.common.insertSuccessAlert,
						});
						getSign();

					} else {
						Toast.fire({
							icon: "info",
							title: _msg.common.insertFailAlert,
						});
					}
				},
				error: function (req, status, err) {
					console.log(req, status, err);
				},
			});

		} else {
			Toast.fire({
				icon: "success",
				title: _msg.common.noSignAlert,
			});
		}
	});
}

function getSign() {
	$.ajax({
		url: `${_ctx}/approval/getSign`,
		type: 'get',
		dataType: 'json',
		success: function (data) {
			let url = data.signImageUrl;
			$('#SIGN_BTN').css('display', 'none');
			$('#SIGN_IMG').attr('src', url).css('display', 'block');
		}
	});
}

function initPoper(target, tooltip) {
		
	const popperInstance = Popper.createPopper(target, tooltip, {
	        modifiers: [
	            {
	                name: 'offset',
	                options: {
	                    offset: [0, 8],
	                },
	            },
	        ],
	    });

    function show() {
        tooltip.setAttribute('data-show', '');
        popperInstance.setOptions((options) => ({
            ...options,
            modifiers: [
                ...options.modifiers,
                { name: 'eventListeners', enabled: true },
            ],
        }));
        popperInstance.update();
    }

    function hide() {
        tooltip.removeAttribute('data-show');
        popperInstance.setOptions((options) => ({
            ...options,
            modifiers: [
                ...options.modifiers,
                { name: 'eventListeners', enabled: false },
            ],
        }));
    }

    const showEvents = ['mouseenter', 'focus'];
    const hideEvents = ['mouseleave', 'blur'];

    showEvents.forEach((event) => {
        target.addEventListener(event, show);
    });

    hideEvents.forEach((event) => {
        target.addEventListener(event, hide);
    });
}
	