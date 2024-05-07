package com.team1.workforest.reservation.car.vo;

import org.springframework.web.multipart.MultipartFile;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class CarVO {
	private String carNo;			// 차량 번호
	private String carNm;			// 차량 명
	private String photoUrl;		// 사진 URL
	private String carUsePosblYnCd;	// 사용 가능 여부 코드
	
	private MultipartFile uploadFile;
}
