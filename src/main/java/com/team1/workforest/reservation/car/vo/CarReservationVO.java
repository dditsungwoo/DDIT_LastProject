package com.team1.workforest.reservation.car.vo;


import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class CarReservationVO {
	private String carResveNo;		// 차량 예약 번호
	private String carNo;			// 차량 번호
	private String empNo;			// 예약자 사번
	private String empNm;			// 예약자 이름
	private String resveCn;			// 예약 내용
	private String resveBeginDate;	// 예약 시작 일시
	private String resveEndDate;	// 예약 종료 일시
	private String rturnCd;			// 반납 여부 코드
	private String allDayCd;		// 종일 여부
	
	private String carNm;			// 차량 이름
	
	private int rnum;				// 페이지네이션을 위한
	private int total;				// 페이지네이션을 위한

}
