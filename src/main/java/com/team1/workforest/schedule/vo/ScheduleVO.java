package com.team1.workforest.schedule.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ScheduleVO {
	private String schdulNo;		// 일정 번호
	private String empNo;			// 사원 번호
	private String deptNo;			// 부서 번호
	private String schdulSeCd;		// 일정 분류 코드
	private String schdulSj;		// 일정 제목
	private String schdulBeginDate;	// 일정 시작 일시
	private String schdulEndDate;	// 일정 종료 일시
	private String schdulLoc;		// 일정 장소
	private String schdulCn;		// 일정 내용
	
	private String allDayCd;		// 종일 여부
}
