package com.team1.workforest.vacation.vo;


import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class VacationRecordVO {
	private String vcatnUseDate;	// 휴가 사용 일시
	private String empNo;			// 사원 번호
	private String vcatnCtgryNo;	// 휴가 종류 번호
	private String giveYear;		// 지급 연도
	private String vcatnSeCd;		// 휴가 구분 코드
	private String vcatnCn;			// 휴가 내용
	private int apvNo;			// 결재 번호
	
	private String apvSttusCd;   	// 결재 상태 코드
	
	private String apvLine;		// 결재 라인
}
