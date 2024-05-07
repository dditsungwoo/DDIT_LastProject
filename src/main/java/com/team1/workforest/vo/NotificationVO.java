package com.team1.workforest.vo;


import java.util.Date;

import lombok.Data;

@Data
public class NotificationVO {
	private String ntcnNo;		// 알림 번호
	private String empNo;		// 사원 번호
	private Date rcveDate;		// 송수신 일시
	private String ntcnCn;		// 알림 내용
	private String cnfirmYnCd;	// 확인 여부 코드

	// 프로퍼티 추가
	private String formatTime;	// dateFormatter
	private String position;	// 보낸 사원 직급
	private String senderEmpNm;	// 보낸 사원 이름
	
	
}
