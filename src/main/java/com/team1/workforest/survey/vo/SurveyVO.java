package com.team1.workforest.survey.vo;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class SurveyVO {
	private String surveyNo;
	private String surveyEmpNo;
	private String surveyCompleteCd;
	private String surveyOpenDate;
	private String surveyTitle;
	private String surveyEndDate;
	//익명 여부
	private String surveyAnonyCd;
	
	
	private String empNo;
	private String empNm;
	private String rnum;
	
	private String deptNo;
	private String surveyParticEmpNo;
	private String deptNm;
	private String [] abc;
	
	//답변 목록
	List<SurveyChoiceVO> surveyChoiceList;
	
	// 질문 목록
	List<SurveyQuestionVO> surveyQuestionList;
	
	// 참여자 목록
	List<SurveyParticVO> surveyParticList;
	
	
	private String surveyParticNo;
	private String surveyParticComCd;
	private String cmmnCdNm;
	private String surveyQuestionId;
	
	
	private String surveyQuestionSj;
	private String surveyChoiceSj;
	private String cnt;
	
	private String surveyQuestionTypeCd;
	private String rspnsblCtgryNm;
	private String[] autoEmpNo;
	
	
	
}
