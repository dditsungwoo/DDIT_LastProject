package com.team1.workforest.chat.vo;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;

@Data
public class MessageVO {
	private String mssageNo;
	private String chatRoomNo;
	private String empNo;
	private String mssageCn;
	private String atchmnflNo;
	private Date mssageDate;
	
	
	//프로퍼티 추가
	private String empNm;
	private String formatDate; 
	
	
}
