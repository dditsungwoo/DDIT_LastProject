package com.team1.workforest.survey.mapper;

import java.util.List;
import java.util.Map;

import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.survey.vo.SurveyChoiceVO;
import com.team1.workforest.survey.vo.SurveyParticVO;
import com.team1.workforest.survey.vo.SurveyQuestionVO;
import com.team1.workforest.survey.vo.SurveyResponseVO;
import com.team1.workforest.survey.vo.SurveyVO;
import com.team1.workforest.vo.DepartmentVO;

public interface SurveyMapper {
	
	// 검색
	public List<SurveyVO> getSurveyList(Map<String, Object> map);
	
	// 키워드 검색
	public int getkeywordTotal(Map<String, Object> map);
	
	// 자동 검색
	public List<EmployeeVO> empSearch(SurveyVO vo);
	
	//등록하는 직원 정보
	public EmployeeVO empImpomation(SurveyVO vo);
	
	// 부서 자동 검색
	public List<DepartmentVO> deptSearch(DepartmentVO vo);
	
	
	public DepartmentVO deptImpomation(DepartmentVO vo);
	
	//survey생성
	public int createSurvey(SurveyVO vo);
	
	// survey최댓값
	public int maxsurveyNo();
	
	//부서인원 집합
	public List<SurveyParticVO> collectDept(String part);
	
	// 부서이동
	public int insertSurveyPartic(SurveyParticVO partVO);
	
	// 질문넣기
	public int createQuestion(SurveyQuestionVO surveyQuestionVO);
	
	// 선택지 넣기
	public int createChoice(SurveyChoiceVO surveyChVO);
	
	
	// 해당 인원이 가지고 있는 설문조사 번호 구하기
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

	public int createSurveyDes(SurveyResponseVO surResVO);

	public int completeSurvey(SurveyVO vo);

	public int deleteSurvey(SurveyVO vo);

	public SurveyVO getEmp(String empNo);

	public int getSurveyNum(SurveyVO vo);
	

}
