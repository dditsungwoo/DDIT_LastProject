package com.team1.workforest.attendance.vo;


import java.util.Date;

import lombok.Data;

@Data
public class AttendanceManageVO {
	private String attNo;			// 근태 번호
	private String empNo;			// 사원 번호
	private Date attendTime;		// 출근 일시
	private Date lvffcTime;			// 퇴근 일시
	private String workResultCd;	// 근무 결과 코드
	
	// 프로퍼티 추가
	private Double lvffcLeft;
	private String total;
	private String over;
	private String fullDate;
	private String empNm;
	
	private String formatAttend;
	private String formatLvffc;
	
}
