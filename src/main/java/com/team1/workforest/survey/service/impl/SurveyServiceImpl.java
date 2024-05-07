package com.team1.workforest.survey.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.catalina.tribes.util.Arrays;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.survey.mapper.SurveyMapper;
import com.team1.workforest.survey.service.SurveyService;
import com.team1.workforest.survey.vo.SurveyChoiceVO;
import com.team1.workforest.survey.vo.SurveyParticVO;
import com.team1.workforest.survey.vo.SurveyQuestionVO;
import com.team1.workforest.survey.vo.SurveyResponseVO;
import com.team1.workforest.survey.vo.SurveyVO;
import com.team1.workforest.vo.DepartmentVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class SurveyServiceImpl implements SurveyService {

	@Autowired
	SurveyMapper surveyMapper;

	@Override
	public List<SurveyVO> getSurveyList(Map<String, Object> map) {
		return this.surveyMapper.getSurveyList(map);
	}

	@Override
	public int getkeywordTotal(Map<String, Object> map) {
		return this.surveyMapper.getkeywordTotal(map);
	}

	@Override
	public List<EmployeeVO> empSearch(SurveyVO vo) {
		return this.surveyMapper.empSearch(vo);
	}

	@Override
	public EmployeeVO empImpomation(SurveyVO vo) {
		return this.surveyMapper.empImpomation(vo);
	}

	@Override
	public List<DepartmentVO> deptSearch(DepartmentVO vo) {
		return this.surveyMapper.deptSearch(vo);
	}

	@Override
	public DepartmentVO deptImpomation(DepartmentVO vo) {
		return this.surveyMapper.deptImpomation(vo);
	}

	/*
	 * 
	 * SurveyVO(surveyNo=null, surveyEmpNo=null, surveyCompleteCd=null,
	 * surveyOpenDate=null, surveyTitle=ㅂㅈㄷㅂㅈㄷㅂㅈㄷ, surveyEndDate=2024-04-24,
	 * surveyAnonyCd=Y, empNo=null, empNm=null, rnum=null, deptNo=DEPT0101,
	 * surveyParticEmpNo=2019006, abc=null,
	 * 
	 * surveyChoiceList=[ SurveyChoiceVO(surveyNo=null, surveyQuestionId=1,
	 * surveyChoiceNo=null, surveyChoiceSj=[11111111ㅂㅂㅂㅂㅂ]),
	 * SurveyChoiceVO(surveyNo=null, surveyQuestionId=2, surveyChoiceNo=null,
	 * surveyChoiceSj=[222222ㅈㅈㅈㅈㅈ, 222222222ㄷㄷㄷㄷㄷㄷㄷ]),
	 * SurveyChoiceVO(surveyNo=null, surveyQuestionId=3, surveyChoiceNo=null,
	 * surveyChoiceSj=[333333ㅂㅂㅂㅂ]), SurveyChoiceVO(surveyNo=null,
	 * surveyQuestionId=4, surveyChoiceNo=null, surveyChoiceSj=[4444ㅁㅁㅁㅁ,
	 * 44444ㄴㄴㄴㄴㄴ, 4444444ㅊㅊㅊㅊㅊ]) ],
	 * 
	 * 
	 * surveyQuestionList=[ SurveyQuestionVO(surveyNo=null, surveyQuestionNo=null,
	 * surveyQuestionTypeCd=1, surveyQuestionSj=11111111111111, surveyQuestionId=1),
	 * SurveyQuestionVO(surveyNo=null, surveyQuestionNo=null,
	 * surveyQuestionTypeCd=1, surveyQuestionSj=2222222222222, surveyQuestionId=2),
	 * SurveyQuestionVO(surveyNo=null, surveyQuestionNo=null,
	 * surveyQuestionTypeCd=1, surveyQuestionSj=333333333333, surveyQuestionId=3),
	 * SurveyQuestionVO(surveyNo=null, surveyQuestionNo=null,
	 * surveyQuestionTypeCd=1, surveyQuestionSj=444444444, surveyQuestionId=4) ],
	 * 
	 * surveyParticList=null)
	 * 
	 */
	// 설문조사 생성
	@Override
	public int createSurvey(SurveyVO vo) {
		log.info("vo----> " + vo);
		return this.surveyMapper.createSurvey(vo);
	}

	// 자식 생성
	@Override
	public int createChild(SurveyVO vo) {
		// 최댓값(공통 외래키)
		int MaxSurveyNo = this.surveyMapper.maxsurveyNo();

		log.info("surveyNo 최댓값---->" + MaxSurveyNo);

		// 직원 선택 여부
		boolean isEmployeeSelected = (vo.getSurveyParticEmpNo() != null && !vo.getSurveyParticEmpNo().isEmpty());
		// 부서 인원을 선택했는지 여부 확인
		boolean isDepartmentSelected = (vo.getDeptNo() != null && !vo.getDeptNo().isEmpty());
		// 둘 다 선택했는지 여부 확인
		boolean isBothSelected = (isEmployeeSelected && isDepartmentSelected);
		log.info("여기 지나가유");
		int result = 0;

		if (isBothSelected) {

			log.info("직원과 부서를 모두 선택했습니다." + "11");
			log.info("vo.deptNo ------>" + vo.getDeptNo());
			log.info("vo.getSurveyParticEmpNo---> " + vo.getSurveyParticEmpNo());
			String deptNo = vo.getDeptNo();
			String EmpNo = vo.getSurveyParticEmpNo();
			String[] EmpParts = EmpNo.split(",");
			log.info("EmpParts ----> " + EmpParts);
			String[] parts = deptNo.split(",");
			log.info("parts-----> " + parts);

			for (String part : EmpParts) {
				log.info("empNo 분리--->" + part);
				SurveyParticVO partVO = new SurveyParticVO();
				partVO.setSurveyNo(String.valueOf(MaxSurveyNo));
				partVO.setSurveyParticEmpNo(part);
				log.info("partVO 인원 ----> " + partVO);
				result += this.surveyMapper.insertSurveyPartic(partVO);
			}

			// 해당 부서의 인원들 전원 집합
			for (String part : parts) {
				log.info("part ---> " + part);
				List<SurveyParticVO> Deptvo = this.surveyMapper.collectDept(part);
				log.info("DeptVo ------> " + Deptvo);
				// 집합시킨 인원들 sql에 넣기
				for (SurveyParticVO deptVO : Deptvo) {
					log.info("surveyParticNo: " + deptVO.getSurveyParticNo());
					SurveyParticVO partVO = new SurveyParticVO();
					partVO.setSurveyNo(String.valueOf(MaxSurveyNo));
					partVO.setSurveyParticEmpNo(deptVO.getSurveyParticNo());
					log.info("partVO---> " + partVO);
					result += this.surveyMapper.insertSurveyPartic(partVO);
				}
			}
//

			// 직원 넣기
		} else if (isEmployeeSelected) {
			log.info("직원을 선택했습니다." + "11");
			log.info("vo.deptNo ------>" + vo.getDeptNo());
			String EmpNo = vo.getSurveyParticEmpNo();
			String[] parts = EmpNo.split(",");
			// 인원 DB에 넣기
			for (String part : parts) {
				log.info("empNo 분리--->" + part);
				SurveyParticVO partVO = new SurveyParticVO();
				partVO.setSurveyNo(String.valueOf(MaxSurveyNo));
				partVO.setSurveyParticEmpNo(part);
				log.info("partVO 인원 ----> " + partVO);
				result += this.surveyMapper.insertSurveyPartic(partVO);
			}

			// 부서의 인원 넣기
		} else if (isDepartmentSelected) {
			log.info("부서를 선택했습니다." + "11");
			String deptNo = vo.getDeptNo();
			String[] parts = deptNo.split(",");
			// 해당 부서의 인원들 전원 집합
			for (String part : parts) {
				log.info("part ---> " + part);
				List<SurveyParticVO> Deptvo = this.surveyMapper.collectDept(part);
				log.info("DeptVo ------> " + Deptvo);

				// 집합시킨 인원들 sql에 넣기
				for (SurveyParticVO deptVO : Deptvo) {
					log.info("surveyParticNo: " + deptVO.getSurveyParticNo());
					SurveyParticVO partVO = new SurveyParticVO();
					partVO.setSurveyNo(String.valueOf(MaxSurveyNo));
					partVO.setSurveyParticEmpNo(deptVO.getSurveyParticNo());
					log.info("partVO---> " + partVO);
					result += this.surveyMapper.insertSurveyPartic(partVO);
				}
			}
		}

		// 질문 넣기-------------
		int QuestionResult = 0;
		List<SurveyQuestionVO> aaa = vo.getSurveyQuestionList();
		for (SurveyQuestionVO surveyQuestionVO : aaa) {
			log.info("surveyQuestionVO---> " + surveyQuestionVO);
			// 기본키 주고
			surveyQuestionVO.setSurveyNo(String.valueOf(MaxSurveyNo));
			log.info("surveyQuestionVO surveyNo 추가한 VO---> " + surveyQuestionVO);
			// SurveyQuestionVO(surveyNo=null, surveyQuestionNo=null,
			// surveyQuestionTypeCd=1, surveyQuestionSj=1111111111, surveyQuestionId=1)
			QuestionResult += this.surveyMapper.createQuestion(surveyQuestionVO);
		}
		log.info("QuestionResult -------> " + QuestionResult);

		/*
		 * surveyChoiceList=[ SurveyChoiceVO(surveyNo=null,
		 * surveyQuestionId=1,surveyChoiceNo=null, surveyChoiceSj=[11111111ㅂㅂㅂㅂㅂ]),
		 * SurveyChoiceVO(surveyNo=null, surveyQuestionId=2,
		 * surveyChoiceNo=null,surveyChoiceSj=[222222ㅈㅈㅈㅈㅈ, 222222222ㄷㄷㄷㄷㄷㄷㄷ]),
		 * SurveyChoiceVO(surveyNo=null, surveyQuestionId=3,
		 * surveyChoiceNo=null,surveyChoiceSj=[333333ㅂㅂㅂㅂ]),
		 * SurveyChoiceVO(surveyNo=null,surveyQuestionId=4, surveyChoiceNo=null,
		 * surveyChoiceSj=[4444ㅁㅁㅁㅁ,44444ㄴㄴㄴㄴㄴ, 4444444ㅊㅊㅊㅊㅊ]) ],
		 */

		// SURVEY_CHOICE 데이터 삽입--------------------
		List<SurveyChoiceVO> test = vo.getSurveyChoiceList();
		int ChoiceResult = 0;
		for (SurveyChoiceVO bb : test) {
			log.info("bb---> " + bb.getSurveyChoiceSj());
			log.info("bb----> " + bb.getSurveyQuestionId());

			// 서술일 경우 choiceSj---> null insert시키면 안됌
			if (bb.getSurveyChoiceSj() != null) {
				SurveyChoiceVO surveyChVO = new SurveyChoiceVO();
				surveyChVO.setSurveyQuestionId(bb.getSurveyQuestionId());
				surveyChVO.setSurveyNo(String.valueOf(MaxSurveyNo));
				log.info("surveyChVO -----> " + surveyChVO);
				for (String cc : bb.getSurveyChoiceSj()) {
					log.info("cc----->" + cc);
					surveyChVO.setSurveySj(cc);

					log.info("surveyChVO ------> " + surveyChVO);
					ChoiceResult += this.surveyMapper.createChoice(surveyChVO);
				}
			} else {
				log.info("서술형이 하나있습니다.");
			}
		}

		return result;
	}

	@Override
	public List<SurveyVO> getParticList(SurveyParticVO vo) {
		return this.surveyMapper.getParticList(vo);
	}

	@Override
	public SurveyVO surveyDetail(String surveyNo) {
		return this.surveyMapper.surveyDetail(surveyNo);
	}

	@Override
	public List<SurveyQuestionVO> surveyQuestion(SurveyVO vo) {
		return this.surveyMapper.surveyQuestion(vo);
	}

	@Override
	public List<SurveyChoiceVO> surveyChoiceList(SurveyVO vo) {
		return this.surveyMapper.surveyChoiceList(vo);
	}

	@Override
	public int createResponse(SurveyResponseVO vo) {
		log.info("Response vo-----------> " + vo);
		int choiceIndex = 0;
		int result = 0;
		String surveyNo = vo.getSurveyNo();	//번호
		String empNo = vo.getSurveyResponEmpNo(); // 2019001
		log.info("surveyNo---->"+surveyNo);
		log.info("empNo---->"+empNo);
		/*
		Response vo-----------> SurveyResponseVO(surveyResponseNo=null, surveyNo=36
		, surveyQuestionId=[1, 2, 3, 4], questionId=null, surveyResponseResult=null
		, responseResult=[1, [2, 3], [1, 2], test], checkBoxList=null, questionNum=null
		, surveyQuestionTypeCd=null, surveyChoiceNo=null, choiceNo=[79, 83, 84, 85, 86]
		, surveyResponEmpNo=2019001)
		*/
		List<Object> list = vo.getResponseResult();
		int questionNum = vo.getSurveyQuestionId().length;
		log.info("questionNum(질문 계수)---->"+questionNum);
		String[]choiceNoList = vo.getChoiceNo();
		log.info("choiceNoList(선택지 번호 1번)--->"+choiceNoList[choiceIndex]);
		log.info("list[1] ---> "+list.get(1));
		
		// 5번돌고
		for (int i = 0; i < questionNum; i++) {
			Object element = list.get(i);
			
			if(isNumeric(element.toString())){
				//숫자일 경우
				log.info("element숫자----->"+element);
				SurveyResponseVO surResVO = new SurveyResponseVO();
				// 번호
				surResVO.setSurveyNo(surveyNo);
				// 질문 번호
				surResVO.setQuestionId(String.valueOf(i+1));
				// 응답 결과
				surResVO.setSurveyResponseResult(String.valueOf(element));
				// 응답자 번호
				surResVO.setSurveyResponEmpNo(empNo);
				//선택지 기본키
				surResVO.setSurveyChoiceNo(choiceNoList[choiceIndex]);
				log.info("surResVO----->"+surResVO);
				result += this.surveyMapper.createResponse(surResVO);
				choiceIndex++;
			}else if (element instanceof ArrayList) {
				// 배열일경우
				log.info("element는 배열---->"+element);
				ArrayList<?> arrayListElement = (ArrayList<?>) element;
				log.info("arrayListElement.size()==>"+arrayListElement.size());
				for(int j =0 ; j<arrayListElement.size() ;j++) {
					String listNum = (String) arrayListElement.get(j);
					log.info("listNum ---->"+listNum);
					SurveyResponseVO surResVO = new SurveyResponseVO();
					// 번호
					surResVO.setSurveyNo(surveyNo);
					// 질문 번호
					surResVO.setQuestionId(String.valueOf(i+1));
					// 응답자가 선택한 선택지
					surResVO.setSurveyResponseResult(listNum);
					// 응답자 번호
					surResVO.setSurveyResponEmpNo(empNo);
					//선택지 기본키
					surResVO.setSurveyChoiceNo(choiceNoList[choiceIndex]);
					log.info("surResVO(배열)----->"+surResVO);
					result += this.surveyMapper.createResponse(surResVO);
					choiceIndex++;
				}
			}else {
				//서술일 경우
				log.info("서술입니다."+element);
				SurveyResponseVO surResVO = new SurveyResponseVO();
				// 번호
				surResVO.setSurveyNo(surveyNo);
				// 질문 번호
				surResVO.setQuestionId(String.valueOf(i+1));
				// 응답자가 선택한 선택지
				surResVO.setSurveyResponseResult(String.valueOf(element));
				// 응답자 번호
				surResVO.setSurveyResponEmpNo(empNo);
				log.info("surResVO(서술)----->"+surResVO);
				result += this.surveyMapper.createSurveyDes(surResVO);
			}
		}

		return result;
	}

	@Override
	public int updatePartic(SurveyResponseVO vo) {
		return this.surveyMapper.updatePartic(vo);
	}

	@Override
	public SurveyVO getSurveyVO(String surveyNo) {
		return this.surveyMapper.getSurveyVO(surveyNo);
	}

	@Override
	public List<SurveyParticVO> getSurveyParticVOList(String surveyNo) {
		return this.surveyMapper.getSurveyParticVOList(surveyNo);
	}

	@Override
	public List<SurveyQuestionVO> getSurveyQuestionVOList(String surveyNo) {
		return this.surveyMapper.getSurveyQuestionVOList(surveyNo);
	}

	@Override
	public List<SurveyResponseVO> getSurveyResponseVOList(String surveyNo) {
		return this.surveyMapper.getSurveyResponseVOList(surveyNo);
	}

	@Override
	public List<SurveyChoiceVO> getSurveyChoiceVOList(String surveyNo) {
		return this.surveyMapper.getSurveyChoiceVOList(surveyNo);
	}

	@Override
	public int getQuestionSum(String surveyNo) {
		return this.surveyMapper.getQuestionSum(surveyNo);
	}

	@Override
	public List<SurveyVO> statisSurvey(SurveyResponseVO vo) {
		return this.surveyMapper.statisSurvey(vo);
	}

	@Override
	public List<SurveyQuestionVO> getTypeCd(String surveyNo) {
		return this.surveyMapper.getTypeCd(surveyNo);
	}

	@Override
	public List<SurveyQuestionVO> getQuestionSj(String surveyNo) {
		return this.surveyMapper.getQuestionSj(surveyNo);
	}

	@Override
	public List<SurveyResponseVO> getType3Response(SurveyResponseVO vo) {
		return this.surveyMapper.getType3Response(vo);
	}

	@Override
	public int getAllTotal(SurveyVO vo) {
		return this.surveyMapper.getAllTotal(vo);
	}

	@Override
	public int getCpCount(SurveyVO vo) {
		return this.surveyMapper.getCpCount(vo);
	}

	@Override
	public int getNoCount(SurveyVO vo) {
		return this.surveyMapper.getNoCount(vo);
	}

	// 숫자형태의 문자열인지 판별
	public static boolean isNumeric(String input) {
		try {
			Double.parseDouble(input);
		} catch (NumberFormatException e) {
			return false;
		}
		return true;
	}

	@Override
	public int completeSurvey(SurveyVO vo) {
		return this.surveyMapper.completeSurvey(vo);
	}

	@Override
	public int deleteSurvey(SurveyVO vo) {
		return this.surveyMapper.deleteSurvey(vo);
	}

	@Override
	public List<SurveyVO> getAutoEmp(SurveyVO vo) {
		//autoEmpNo=[2019001, 2019002, 2019003, 2019004, 2019005, 2019006, 2019007]
		int autoEmpNoLength = vo.getAutoEmpNo().length;		//7
		List<SurveyVO> list = new ArrayList<SurveyVO>();
		/* List<SurveyVO> list = */
		for(int i =0 ; i<autoEmpNoLength;i++) {
			//2019001, 2019002, 2019003, 2019004, 2019005, 2019006, 2019007
			String empNo = vo.getAutoEmpNo()[i];	
			SurveyVO svo = this.surveyMapper.getEmp(empNo);
			list.add(svo);
		}
		
		return list;
	}

	@Override
	public int getSurveyNum(SurveyVO vo) {
		return this.surveyMapper.getSurveyNum(vo);
	}
}
