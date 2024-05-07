package com.team1.workforest.vo;

import lombok.Data;

@Data
public class EmpUserSetupVO {
	private String userSetupNo;				// 사용자 설정 번호
	private String empNo;					// 사원 번호
	private String carResveCldrSetupNo;		// 차량 예약 달력 설정 코드
	private String mtgRoomResveCldrSetupNo;	// 회의실 예약 달력 설정 코드
	private String resrcesLendCldrSetupNo;	// 자원 대여 달력 설정 코드
	private String useYnCd;					// 사용 여부 코드
}
