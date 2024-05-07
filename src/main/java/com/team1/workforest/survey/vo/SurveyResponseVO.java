package com.team1.workforest.survey.vo;

import java.util.ArrayList;
import java.util.List;

import lombok.Data;

@Data
public class SurveyResponseVO {
	private String surveyResponseNo;
	private String surveyNo;
	private String [] surveyQuestionId;
	private String questionId;
	private String surveyResponseResult;
	//private String[][] responseResult;	// 집어넣은 값들 가져오기
	private ArrayList<Object> responseResult;	// 집어넣은 값들 가져오기
	private List<String> checkBoxList;
	
	private String questionNum;
	private String surveyQuestionTypeCd;
	private String surveyChoiceNo;
	
	private String [] choiceNo;
	
	
	private String surveyResponEmpNo;
	
	
	
	
	
}
