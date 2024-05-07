package com.team1.workforest.survey.service;

import java.util.List;
import java.util.Map;

import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.survey.vo.SurveyChoiceVO;
import com.team1.workforest.survey.vo.SurveyParticVO;
import com.team1.workforest.survey.vo.SurveyQuestionVO;
import com.team1.workforest.survey.vo.SurveyResponseVO;
import com.team1.workforest.survey.vo.SurveyVO;
import com.team1.workforest.vo.DepartmentVO;

public interface SurveyService {

	public List<SurveyVO> getSurveyList(Map<String, Object> map);

	public int getkeywordTotal(Map<String, Object> map);

	public List<EmployeeVO> empSearch(SurveyVO vo);

	public EmployeeVO empImpomation(SurveyVO vo);

	public List<DepartmentVO> deptSearch(DepartmentVO vo);

	public DepartmentVO deptImpomation(DepartmentVO vo);
	
	// 설문조사 생성
	public int createSurvey(SurveyVO vo);
	
	// 인원 넣기
	public int createChild(SurveyVO vo);
	
	//
	public List<SurveyVO> getParticList(SurveyParticVO vo);

	public SurveyVO surveyDetail(String surveyNo);

	public List<SurveyQuestionVO> surveyQuestion(SurveyVO vo);

	public List<SurveyChoiceVO> surveyChoiceList(SurveyVO vo);

	public int createResponse(SurveyResponseVO vo);

	public int updatePartic(SurveyResponseVO vo);

	public SurveyVO getSurveyVO(String surveyNo);

	public List<SurveyParticVO> getSurveyParticVOList(String surveyNo);

	public List<SurveyQuestionVO> getSurveyQuestionVOList(String surveyNo);

	public List<SurveyResponseVO> getSurveyResponseVOList(String surveyNo);

	public List<SurveyChoiceVO> getSurveyChoiceVOList(String surveyNo);

	public int getQuestionSum(String surveyNo);

	public List<SurveyVO> statisSurvey(SurveyResponseVO vo);

	public List<SurveyQuestionVO> getTypeCd(String surveyNo);

	public List<SurveyQuestionVO> getQuestionSj(String surveyNo);

	public List<SurveyResponseVO> getType3Response(SurveyResponseVO vo);

	public int getAllTotal(SurveyVO vo);

	public int getCpCount(SurveyVO vo);

	public int getNoCount(SurveyVO vo);

	public int completeSurvey(SurveyVO vo);

	public int deleteSurvey(SurveyVO vo);

	public List<SurveyVO> getAutoEmp(SurveyVO vo);

	public int getSurveyNum(SurveyVO vo);

	
	
}
