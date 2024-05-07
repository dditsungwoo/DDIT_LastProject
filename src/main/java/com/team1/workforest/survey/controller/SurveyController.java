package com.team1.workforest.survey.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.github.mustachejava.reflect.DepthGuard;
import com.team1.workforest.board.notice.vo.NoticeBoardVO;
import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.survey.service.SurveyService;
import com.team1.workforest.survey.util.ArticlePageForSurvey;
import com.team1.workforest.survey.vo.SurveyChoiceVO;
import com.team1.workforest.survey.vo.SurveyParticVO;
import com.team1.workforest.survey.vo.SurveyQuestionVO;
import com.team1.workforest.survey.vo.SurveyResponseVO;
import com.team1.workforest.survey.vo.SurveyVO;
import com.team1.workforest.util.ArticlePagebrdCd;
import com.team1.workforest.vo.DepartmentVO;

import lombok.Getter;
import lombok.extern.slf4j.Slf4j;
import oracle.jdbc.proxy.annotation.Post;

@Slf4j
@Controller
@RequestMapping("/admin/survey")
public class SurveyController {

	@Autowired
	SurveyService surveyService;
	
	// 설문조사 리스트 페이지
	@GetMapping("/list")
	public String getSurveyList() {
		return "admin/survey/list";
	}
	
	
	@ResponseBody
	@PostMapping("/getSurveyList")
	public ArticlePageForSurvey<SurveyVO> getSurveyList(@RequestBody(required = false) Map<String, Object> map) {
		log.info("map: " + map);

		List<SurveyVO> surveyVOList = this.surveyService.getSurveyList(map);

		log.info("list -> surveyVOList : " + surveyVOList);

		// 검색한 키워드의 행 수
		int total = this.surveyService.getkeywordTotal(map);

		log.info("listAjax->list -> total : " + total);

		int size = 10;

		String currentPage = map.get("currentPage").toString();
		String keyword = map.get("keyword").toString();
		String searchOption = map.get("searchOption").toString();
		String surveyCompleteCd = map.get("surveyCompleteCd").toString();

		log.info("total : " + total + ", currentPage : " + currentPage + ", size : " + size + ", keyword : " + keyword
				+ ", searchOption : " + searchOption + ", surveyCompleteCd : " + surveyCompleteCd);

		ArticlePageForSurvey<SurveyVO> data = new ArticlePageForSurvey<SurveyVO>(total, Integer.parseInt(currentPage),
				size, surveyVOList, keyword, searchOption, surveyCompleteCd);

		log.info("listAjax->data : " + data);

		String url = "/admin/survey/list";

		data.setUrl(url);

		return data;
	}

	
	  // 등록 페이지 만들기 용
	  
	  @GetMapping("/insert") 
	  public String insert(){
		  return "admin/survey/insert"; 
		  }
	  
	  
	  
	  @ResponseBody
	  @PostMapping("/empSearch")
	  public List<EmployeeVO> empSearch(@RequestBody SurveyVO vo){
		 List<EmployeeVO> list = this.surveyService.empSearch(vo);
		 log.info("list----> "+list);
		 return list;
	  }
	  
	  
	  @ResponseBody
	  @PostMapping("/emp/imp")
	  public EmployeeVO empImpomation(@RequestBody SurveyVO vo) {
		  log.info("vo-----> "+vo);
		  EmployeeVO empVO = this.surveyService.empImpomation(vo);
		  return empVO;
	  }
	 
	  
	  @ResponseBody
	  @PostMapping("/deptSearch")
	  public List<DepartmentVO> deptSearch(@RequestBody DepartmentVO vo){
		  List<DepartmentVO> list = this.surveyService.deptSearch(vo);
		  log.info("list---> "+list);
		  return list;
	  }
	  
	  
	  @ResponseBody
	  @PostMapping("/dept/imp")
	  public DepartmentVO deptImpomation(@RequestBody DepartmentVO vo) {
		  log.info("vo--------> "+vo);
		  DepartmentVO deptVO = this.surveyService.deptImpomation(vo);
		  return deptVO;
	  }
	  

	  
	  // 부모등록
	  @PostMapping("/creatSurvey")
	  public String createSurvey(@Validated SurveyVO vo, BindingResult brResult) {
		  log.info("vo-------> "+vo);
		  
		  
		  int result = this.surveyService.createSurvey(vo);
		  
		  log.info("result ----> "+result);
		  
		  if(result == 1) {
			  int result2 = this.surveyService.createChild(vo);
			  log.info("result2 --------> "+result2);
		  }
		  /*	사람 구하기
			  log.info("vo.deptNo" + vo.getDeptNo()); 
			  String str = vo.getDeptNo(); 
			  String [] parts = str.split(","); 
			  for(String part : parts) { 
				  log.info(""+part); 
			  }
		*/ 
		  
		  
		/* 질문 항목 찢기
		  List<SurveyChoiceVO> aaa= vo.getSurveyChoiceList();
		  for(SurveyChoiceVO bb : aaa) {
			  log.info("bb---> "+ bb.getSurveyChoiceSj());
			  for(String cc : bb.getSurveyChoiceSj()) {
				  log.info("cc----->"+cc);
			  }
		  }
		  
		  */
		  
		  return "redirect:/admin/survey/list";
	  }
	  
	  //팝업창
	  @RequestMapping(value="/response", method= RequestMethod.GET)
	  public String responSurvey(Model model, @RequestParam String surveyNo) {
		  // surveyNo ----> 14
		  log.info("설문조사 번호 ----> " +surveyNo);
		  
		  //제목 -----------
		  SurveyVO vo = this.surveyService.surveyDetail(surveyNo);
		  model.addAttribute("surveyDetail", vo);
		  
		  //질문 내용이랑  선택지
		  return "admin/response";
	  }
	  
	  //질문 찾기
	  @ResponseBody
	  @PostMapping("/getQuest")
	  public Map<String,Object> surveyQuestion(@RequestBody SurveyVO vo){
		  Map<String,Object> map = new HashMap<String, Object>();
		  //질문 가져오기
		  List<SurveyQuestionVO> list = this.surveyService.surveyQuestion(vo);
		  map.put("SurveyQuestionVOList", list);
		  //
		  List<SurveyChoiceVO> Choicelist = this.surveyService.surveyChoiceList(vo);
		  log.info("내가 찾는 질문 ------> "+Choicelist);
		  map.put("SurveyChoiceVOList", Choicelist);
		  
		  
		  
		  return map;
	  }
	  
	  
	  //헤더창 list뽑기
	  @ResponseBody
	  @PostMapping("/header/list")
	  public List<SurveyVO> headerSurveyList(@RequestBody SurveyParticVO vo) {
		  log.info("header.vo------>"+vo);
		  List<SurveyVO> list = this.surveyService.getParticList(vo);
		 log.info("header.list ----> "+list);
		  return list;
	  }
	  
	  
	  @ResponseBody
	  @PostMapping("/createResponse")
	  public int createResponse(@RequestBody SurveyResponseVO vo) {
		  log.info("vo-------> "+vo);
		  int result = this.surveyService.createResponse(vo); 
		  
		  log.info("result ------->" +result);
		  int updateResult = this.surveyService.updatePartic(vo);
		  return result;
	  }
	  
	  
	  
	  
	  @RequestMapping(value="/list/detail", method = RequestMethod.GET)
	  public String detailSurvey(Model model, @RequestParam String surveyNo) {
		  log.info("surveyNo ----> " +surveyNo);
		  
		  //설문조사 내용
		  SurveyVO surveyVO = this.surveyService.getSurveyVO(surveyNo);
		  log.info("surveyNo ----> "+surveyNo);
		  //설문 응답
		  List<SurveyResponseVO> surveyResponseVOList = this.surveyService.getSurveyResponseVOList(surveyNo);
		  log.info("surveyResponseVOList---> "+surveyResponseVOList);
		  
		  //질문
		  List<SurveyQuestionVO> surveyQuestionVOList = this.surveyService.getSurveyQuestionVOList(surveyNo);
		  log.info("surveyQuestionVOList ---> "+surveyQuestionVOList);
		  
		  // 참가자
		  List<SurveyParticVO> surveyParticVOList = this.surveyService.getSurveyParticVOList(surveyNo);
		  log.info("surveyParticVOList----> "+surveyParticVOList);
		  // 선택지
		  List<SurveyChoiceVO> surveyChoiceVOList = this.surveyService.getSurveyChoiceVOList(surveyNo);
		  log.info("surveyChoiceVOList ---> "+surveyChoiceVOList);
		  
		  
		  model.addAttribute("surveyVO", surveyVO);
		  model.addAttribute("surveyResponseVOList", surveyResponseVOList);
		  model.addAttribute("surveyQuestionVOList", surveyQuestionVOList);
		  model.addAttribute("surveyParticVOList", surveyParticVOList);
		  model.addAttribute("surveyChoiceVOList", surveyChoiceVOList);
		  
		  // 질문 코드
		  List<SurveyQuestionVO> typeCode = this.surveyService.getTypeCd(surveyNo);
		  model.addAttribute("typeCode", typeCode);
		  
		  List<SurveyQuestionVO> questionSj = this.surveyService.getQuestionSj(surveyNo);
		  model.addAttribute("questionSj",questionSj);
		  
		  
		  
		  //질문 계수
		  int questionNum = this.surveyService.getQuestionSum(surveyNo);
		  model.addAttribute("questionNum",questionNum);
		  
		  
		  return "admin/survey/detail";
	  }


	  @ResponseBody
	  @PostMapping("/statis")
	  public List<SurveyVO> statisSurvey(@RequestBody SurveyResponseVO vo) {
		  List<SurveyVO> list = this.surveyService.statisSurvey(vo);
		  return list; 
	  }
	  
	  
	  
	  @ResponseBody
	  @PostMapping("/getSeosul")
	  public List<SurveyResponseVO> getType3Response(@RequestBody SurveyResponseVO vo){
		  List<SurveyResponseVO> list = this.surveyService.getType3Response(vo);
		  return list;
	  }
	  
	  
	  @ResponseBody
	  @PostMapping("/percent")
	  public int getPercent(@RequestBody SurveyVO vo) {
		  //전체 인원수 
		  int allCount = this.surveyService.getAllTotal(vo);
		  log.info("allCount--->"+allCount);
		  // 완료인원
		  int cpCount = this.surveyService.getCpCount(vo);
		  log.info("cpCount--->"+cpCount);
		  // 안한 인원
		  int noCount = this.surveyService.getNoCount(vo);
		  
		  float y = ((float)cpCount/allCount);
		  log.info("y----->"+y);
		  
		  int result = (int) (100 * y);
		  log.info("result---->"+result);
		  
		  if(result==100) {
			  int completeSurvey = this.surveyService.completeSurvey(vo);
			  log.info("completeSurvey---->"+completeSurvey);
		  }
		  
		  
		  
		  return result;
	  }
	  
	  
	  @ResponseBody
	  @PostMapping("/delete")
	  public int deleteSurvey(@RequestBody SurveyVO vo) {
		  int result =this.surveyService.deleteSurvey(vo);
		  log.info("삭제 result ----->"+result);
		  if(result == 1) {
			  log.info("삭제했습니다");
		  }
		  return result;
	  }
	  
	  @ResponseBody
	  @PostMapping("/autoEmp")
	  public List<SurveyVO> getAutoEmp(@RequestBody SurveyVO vo) {
		  //autoEmpNo=[2019001, 2019002, 2019003, 2019004, 2019005, 2019006, 2019007]
		  log.info("vo---->"+vo);
		  List<SurveyVO> list = this.surveyService.getAutoEmp(vo);
		  
		  
		  return list;
	  }
	  
	  @ResponseBody
	  @PostMapping("/getSurveyNum")
	  public int getSurveyNum(@RequestBody SurveyVO vo) {
		  //surveyParticNo 
		  int result = this.surveyService.getSurveyNum(vo);
		  return result;
	  }
	  
	  
	 

}
