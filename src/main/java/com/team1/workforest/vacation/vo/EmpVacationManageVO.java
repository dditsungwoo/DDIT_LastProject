package com.team1.workforest.vacation.vo;

import lombok.Data;

@Data
public class EmpVacationManageVO {
	private String empNo;			// 사원 번호
	private String giveYear;		// 지급 연도
	private String vcatnCtgryNo;	// 휴가 종류 번호
	private float remainCnt;			// 잔여 수
	
	private String vcatnCtgrySj;	// 휴가 종류 제목
	private String vcatnCtgryCn;	// 휴가 종류 내용
}
