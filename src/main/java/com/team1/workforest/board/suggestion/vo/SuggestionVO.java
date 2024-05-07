package com.team1.workforest.board.suggestion.vo;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class SuggestionVO {
	private String sugestBrdNo;	// 글번호
	private String empNo;		// 사원번호
	private String sugestBrdSj;	//제목
	
	
	private String writngDate;	// 글쓴날
	
	private int rdcnt;			//조회수
	private String updtDate;	// 수정날짜
	private String sugestBrdCn;	// 내용
	private String atchmnflNo;	// 파일 코드
	private String rnum;		// 리스트 조회 할때 rnum
	
	
	private String empNm;		// 사용자이름
	private MultipartFile[] uploadfile;			// 파일
	private String fileName;	
	private String proflImageUrl;
}
