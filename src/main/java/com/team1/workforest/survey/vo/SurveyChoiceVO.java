package com.team1.workforest.survey.vo;

import lombok.Data;

@Data
public class SurveyChoiceVO {
	private String surveyNo;
	private String surveyQuestionId;	// 몇번 질문의 선택
	private String surveyChoiceNo;		//기본키
	private String surveySj;				// 답변 받을 변수
	
	private String[] surveyChoiceSj;		// 답변 목록
	
}
