package com.team1.workforest.mail.vo;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class EmailVO {
	private String emailNo;
	private String senderEmplNo;
	private String emailSj;
	private String emailCn;
	private String sendDate;
	private String tmprStre;
	private String atchmnflNo;
	private String delCd;
	
	private String cnfirmDate;
	//senderEmplNo
	private String empNo;
	private int rnum;
	//보낸사람
	private String senderName;
	private String senderEmail;
	//받는사람
	private String recipientName;
	
	private List<EmailRecipientVO> recipientVOList;
	
	private String[] emailRVOList;
	private String[] checkboxList;
	private String[] deleteDataList;
	
	//이전글, 다음글
	private String prevMailNo;
	private String nextMailNo;
	
	private String atchmnflSeq;        // 첨부파일 순번
	private String atchmnflNm;         // 첨부파일 명
	private String atchmnflOriginNm;   // 첨부파일 원본 명
	private long atchmnflSize;         // 첨부파일 크기
	private MultipartFile[] multipartFile;
	
	
	private String reSend;
	private String reEmpNo;
	private String reTitle;
	private String reCont;
	
	private String senderImageUrl;	//보낸사람 프로필이미지
	
	
}
