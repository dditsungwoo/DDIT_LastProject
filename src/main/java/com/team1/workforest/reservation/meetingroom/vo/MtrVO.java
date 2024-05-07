package com.team1.workforest.reservation.meetingroom.vo;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MtrVO {
	private String mtrNo;		// 회의실 번호
	private String mtrLoc;		// 회의실 위치
	private String mtrNm;		// 회의실 명
	private int aceptblNmpr;		// 수용가능 인원
	private String photoUrl;		// 사진 URL
	private String usePosblYnCd;	// 사용 가능 여부 코드
	private String[] equipments;
	
	private List<MtrEquipmentVO> mtrEquipedList;
	
	private MultipartFile uploadFile;
}
