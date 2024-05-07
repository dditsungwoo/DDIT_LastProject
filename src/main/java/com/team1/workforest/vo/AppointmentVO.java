package com.team1.workforest.vo;

import lombok.Data;

@Data
public class AppointmentVO {
	private String appointmentNo;	// 발령 번호
	private String empNo;			// 사원 번호
	private String deptNo;			// 부서 번호
	private String gnfdDate;		// 발령 일자
	private String endDate;			// 종료 일자
	private String positionCd;		// 직급 코드
	private String rspnsblCd;		// 직책 코드
}
