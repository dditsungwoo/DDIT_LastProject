package com.team1.workforest.board.notice.vo;

import java.util.Date;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class NoticeBoardVO {
	private String noticeBrdNo;		// 글번혼
	private String empNo;			// 게시글 사원 번호
	private String noticeBrdSj;		// 제목
	private String writngDate;		// 글쓴일
	private int rdcnt;				//조회수
	private String updtDate;		
	private String noticeBrdSeCd;	// 게시글 분류 코드
	private String fixingEndDate;	// 중요태그 날짜
	private String noticeBrdCn;	//게시글 내용
	private String atchmnflNo;	//파일 번호
	
	private String empNm;		// 사원 이름
	private String rnum;		//리스트 조회 할때 rnum
	
	private String cmmnCdNm;	// 분류 코드명
	private MultipartFile[] uploadfile;		//다중 파일
	private String fileName;
	private String proflImageUrl;
	
	private String rspnsblCtgryNm;
	
}
