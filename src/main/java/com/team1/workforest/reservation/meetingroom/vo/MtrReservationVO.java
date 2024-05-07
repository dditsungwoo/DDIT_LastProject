package com.team1.workforest.reservation.meetingroom.vo;


import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MtrReservationVO {
	private String mtrResveNo;		// 회의실 예약 번호
	private String mtrNo;			// 회의실 번호
	private String empNo;			// 예약자 사번
	private String empNm;
	private String resveCn;			// 예약 내용
	private String resveBeginDate;	// 예약 시작 일시
	private String resveEndDate;	// 예약 종료 일시
	
	private String mtrLoc;			// 회의실 위치
	private String mtrNm;			// 회의실 명
	
	private int rnum;				// 페이지네이션을 위한
	private int total;				// 페이지네이션을 위한
}
