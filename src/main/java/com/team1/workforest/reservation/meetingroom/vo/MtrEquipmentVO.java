package com.team1.workforest.reservation.meetingroom.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MtrEquipmentVO {
	private String eqpmnNo;		// 장비 번호
	private String mtrNo;	// 회의실 번호
	private String equipYnCd;	// 보유 여부 코드
}
