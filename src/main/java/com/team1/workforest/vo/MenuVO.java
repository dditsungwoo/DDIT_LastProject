package com.team1.workforest.vo;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class MenuVO {
	private String menuNo;		// 메뉴 번호
	private String menuNm;		// 메뉴 명
	private String validYnCd;	// 유효 여부 코드
	private String pageUrl;		// 페이지 URL
	private String upperMenu;	// 상위 메뉴
	private String menuIcon;	// 아이콘 클래스명
	
	private String[] menuNos; // 여러개 넣을 메뉴들
	
	private String empNo;
	private String glanNm;
	
	private MultipartFile[] uploadFile;
	

}
