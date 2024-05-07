package com.team1.workforest.vo;

import lombok.Data;

@Data
public class UserSetupNtcnMatterVO {
	private String setupNtcnNo;		// 알림 사항 번호
	private String userSetupNo;		// 사용자 설정 번호
	private String setupNtcnNm;		// 알림사항 명
	private String ntcnYnCd;		// 알림 여부 코드

}
