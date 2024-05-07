package com.team1.workforest.project.controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.rmi.CORBA.PortableRemoteObjectDelegate;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.team1.workforest.duty.vo.DutyVO;
import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.project.service.ProjectService;
import com.team1.workforest.project.util.ArticlePageForProject;
import com.team1.workforest.project.util.ArticlePageForProjectDone;
import com.team1.workforest.project.util.ArticlePageForProjectReply;
import com.team1.workforest.util.ArticlePage;
import com.team1.workforest.project.vo.ProjectDutyReplyVO;
import com.team1.workforest.project.vo.ProjectDutyVO;

import com.team1.workforest.project.vo.ProjectVO;

import lombok.extern.slf4j.Slf4j;
import oracle.jdbc.proxy.annotation.Post;

@Slf4j
@Controller
@RequestMapping("/project")
public class ProjectController {
	
	@Autowired
	ProjectService projectService;

	// 프로젝트 메인 페이지
	
	  @GetMapping("/main")
	  public String projectMain(){ 
		  
		  return "project/main"; 
	  }
	
	
	// 프로젝트 리스트 출력 	
	@GetMapping("/projects")
	public String getProjectList(Model model,
			@RequestParam(value = "currentPage", required = false, defaultValue = "1") int currentPage,HttpSession session	) {
		Map<String, Object> map = new HashMap<String, Object>();
		String empNo=(String)session.getAttribute("empNo");
		log.info("리스트출력"+currentPage);
		
		map.put("currentPage", currentPage);
		map.put("empNo", empNo);
	
		// 전체 행의 수 (total)
		//int total = this.projectService.getTotal();
		// 한 화면에 보여지는 행의 수
		int size = 5;
		String url= "/project/projects";
		List <ProjectVO> plist =new ArrayList<ProjectVO>();
		plist = this.projectService.getProjectList(map);
		if (plist == null || plist.isEmpty()) {	
		    plist.add(new ProjectVO());
	
		}
		for (int i = 0; i < plist.size(); i++) {
			
			String startDate=plist.get(i).getPrjctBeginDate();			
			String endDate=plist.get(i).getPrjctEndDate();
			 if (startDate != null && endDate != null) {
				LocalDate localDate = LocalDate.parse(startDate, DateTimeFormatter.ofPattern("yyyyMMdd"));
				DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
				String formattedDate = localDate.format(outputFormatter);
				log.info("간트 컨트롤러 startDate" + formattedDate );
			
				LocalDate localDate2 = LocalDate.parse(endDate, DateTimeFormatter.BASIC_ISO_DATE);
				DateTimeFormatter outputFormatter2 = DateTimeFormatter.ofPattern("yyyy-MM-dd");
				String formattedDate2 = localDate2.format(outputFormatter2);
				plist.get(i).setPrjctBeginDate(formattedDate);
				plist.get(i).setPrjctEndDate(formattedDate2);
		}
		}
		log.info("리스트출력 plist 넘어왔음: "+plist.get(0).getTotal());
		int total =plist.get(0).getTotal();
		model.addAttribute("data", new ArticlePageForProject<ProjectVO>(total, currentPage, size, plist,"", url));
		log.info("plist",plist);
		
		
		return "project/main";
	}
	
	//프로젝트 생성 
	@ResponseBody
	@PostMapping("/project")
	public int createProject(@RequestBody ProjectVO vo) {
		log.info("createProject"+vo);
		int res= this.projectService.createProject(vo);
		return res;
	}
	

	//프로젝트 상세 
	@GetMapping("project/{prjctNo}")
	public String getProjectDetail(@PathVariable String prjctNo) {	
		return "project/detail";
	}
	
	//프로젝트 상세페이지에서 일감 출력 
	@ResponseBody
	@PostMapping("/getProjectDuty")
	public List<ProjectDutyVO> getProjectDuty(@RequestBody ProjectDutyVO vo ,Model model){
		log.info("getProjectDuty : "+vo);		
		List<ProjectDutyVO> list= this.projectService.getProjectDuty(vo);
		log.info("getProjectDuty : "+list);		
		for (int i = 0; i < list.size(); i++) {
			String startDate=list.get(i).getPrjctBeginDate();
			
			String endDate=list.get(i).getPrjctEndDate();
				LocalDate localDate = LocalDate.parse(startDate, DateTimeFormatter.ofPattern("yyyyMMdd"));
				DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
				String formattedDate = localDate.format(outputFormatter);
	
				LocalDate localDate2 = LocalDate.parse(endDate, DateTimeFormatter.BASIC_ISO_DATE);
				DateTimeFormatter outputFormatter2 = DateTimeFormatter.ofPattern("yyyy-MM-dd");
				String formattedDate2 = localDate2.format(outputFormatter2);
				String endDate1=list.get(i).getEndDate();
				LocalDate localDate3 = LocalDate.parse(endDate1, DateTimeFormatter.BASIC_ISO_DATE);
				DateTimeFormatter outputFormatter3= DateTimeFormatter.ofPattern("yyyy-MM-dd");
				String formattedDate3 = localDate3.format(outputFormatter3);
				
				list.get(i).setPrjctBeginDate(formattedDate);
				list.get(i).setPrjctEndDate(formattedDate2);
				list.get(i).setEndDate(formattedDate3);
		}
		model.addAttribute("list",list);
		return list;
	}
	
	
	//프로젝트 상세페이지의 진행도 계산함수
	@ResponseBody
	@PostMapping("/getProgress")
	public int getProgress(@RequestBody ProjectDutyVO vo) {
		log.info("getprogress : ",vo);
		return this.projectService.getProgress(vo);
	}
	
	//프로젝트 상세페이지의 진행도 업데이트 함수
	@ResponseBody
	@PostMapping("/updateProgress")
	public int updateProgress(@RequestBody ProjectDutyVO vo) {
		log.info("updateprogress : ",vo);
		return this.projectService.updateProgress(vo);
	}
	
	//프로젝트 하위 일감을 생성하는 함수
	@ResponseBody
	@PostMapping("/addDuty")
	public int addDuty(@RequestBody ProjectDutyVO vo) {
		log.info("addDuty: ",vo);
		return this.projectService.addDuty(vo);		
	}
	
	//프로젝트 하위 일감을 삭제하는 함수
	@ResponseBody
	@PostMapping("/deleteDuties")
	public int deleteDuties(@RequestBody ProjectDutyVO vo) {
		log.info("addDuty: ",vo);
		return this.projectService.deleteDuties(vo);		
	}
	
	
	//프로젝트 하위 일감의 상세를 출력하는 함수
	@ResponseBody
	@PostMapping("/getDutyModal")
	public ProjectDutyVO getDutyModal(@RequestBody ProjectDutyVO vo) {
		log.info("getDutyModal 받기전"+vo);
				
		vo= this.projectService.getDutyModal(vo);
		log.info("getDutyModal db받아온거"+vo);
		String empNm= this.projectService.getEmpNmByEmpNo(vo.getEmpNo());
		vo.setEmpNm(empNm);
		
		String beginDate=vo.getPrjctBeginDate();
		String endDate=vo.getPrjctEndDate();
		LocalDate localDate = LocalDate.parse(beginDate, DateTimeFormatter.ofPattern("yyyyMMdd"));
		DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		String formattedDate = localDate.format(outputFormatter);
		
		LocalDate localDate2 = LocalDate.parse(endDate, DateTimeFormatter.BASIC_ISO_DATE);
		DateTimeFormatter outputFormatter2 = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		String formattedDate2 = localDate2.format(outputFormatter2);
		log.info("간트 컨트롤러 startDate" + formattedDate2 );
		vo.setPrjctBeginDate(formattedDate);
		vo.setPrjctEndDate(formattedDate2);
		
		return vo;
	}
	
	//empNo로 empNm출력하는 함수
	@ResponseBody
	@PostMapping("/getNameByEmpNo")
	public ProjectDutyVO getNameByEmpNo(@RequestBody ProjectDutyVO vo) {
		log.info("getNameByEmpNo 받기전"+vo);
		
		vo= this.projectService.getNameByEmpNo(vo);
		log.info("getNameByEmpNo db받아온거"+vo);
		return vo;
	}
	
	//이름을 자동완성하는 함수
	@ResponseBody
	@PostMapping("/findEmpByName")
	public List<EmployeeVO> findEmpByName(@RequestBody ProjectDutyVO vo){
		List<EmployeeVO> list =this.projectService.findEmpByName(vo);
		log.info("findEmpByName =>"+list);
   
        return list;
		
	}
	
	
	  //모달창 내에서 수정 확정버튼을 눌렀을때 나오는 함수	 
	@ResponseBody
	@PostMapping("/updateDuty")
	public int updateDuty(@RequestBody ProjectDutyVO vo) {
		log.info("updateDuty =>" + vo);
		//log.info("updateDuty =>" + uploadFile);

		int result = this.projectService.updateDuty(vo);
		log.info("findEmpByName =>" + result);
		return result;
	}
	
	
	
	
	//간트 차트 테스트
	@GetMapping("/gantt/{prjctNo}")
	public String ganttTest(@PathVariable String prjctNo , Model model) {
		model.addAttribute("prjctNo",prjctNo);
		return "project/ganttTest";
	}

	//간트용으로 데이터 가져오기
	@ResponseBody
	@PostMapping("/getDutyModalForGantt")
	public List<ProjectDutyVO> getDutyModalForGantt(@RequestBody ProjectDutyVO vo){
		
		List<ProjectDutyVO> ganttVO= this.projectService.getDutyModalForGantt(vo);

		log.info("간트 컨트롤러 처음" + ganttVO);
		for (int i = 0; i < ganttVO.size(); i++) {
			String startDate=ganttVO.get(i).getStartDate();
			
			String endDate=ganttVO.get(i).getEndDate();
				LocalDate localDate = LocalDate.parse(startDate, DateTimeFormatter.ofPattern("yyyyMMdd"));
				DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
				String formattedDate = localDate.format(outputFormatter);
				log.info("간트 컨트롤러 startDate" + formattedDate );
			
				LocalDate localDate2 = LocalDate.parse(endDate, DateTimeFormatter.BASIC_ISO_DATE);
				DateTimeFormatter outputFormatter2 = DateTimeFormatter.ofPattern("yyyy-MM-dd");
				String formattedDate2 = localDate2.format(outputFormatter2);
				ganttVO.get(i).setStartDate(formattedDate);
				ganttVO.get(i).setEndDate(formattedDate2);
		}
		log.info("간트 컨트롤러 마지막" + ganttVO);

		return ganttVO;
	}
	
	@ResponseBody
	@PostMapping("/getMainGantt")
	public List<ProjectVO> getMainGantt(@RequestBody ProjectDutyVO vo){
		
		List<ProjectVO> ganttVO= this.projectService.getMainGantt(vo);

		log.info("간트 컨트롤러 처음" + ganttVO);
		for (int i = 0; i < ganttVO.size(); i++) {
			String startDate=ganttVO.get(i).getPrjctBeginDate();
			
			String endDate=ganttVO.get(i).getPrjctEndDate();
				LocalDate localDate = LocalDate.parse(startDate, DateTimeFormatter.ofPattern("yyyyMMdd"));
				DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
				String formattedDate = localDate.format(outputFormatter);
				log.info("간트 컨트롤러메인 startDate" + formattedDate );
			
				LocalDate localDate2 = LocalDate.parse(endDate, DateTimeFormatter.BASIC_ISO_DATE);
				DateTimeFormatter outputFormatter2 = DateTimeFormatter.ofPattern("yyyy-MM-dd");
				String formattedDate2 = localDate2.format(outputFormatter2);
				ganttVO.get(i).setPrjctBeginDate(formattedDate);
				ganttVO.get(i).setPrjctEndDate(formattedDate2);
		}
		log.info("간트 컨트롤러 마지막" + ganttVO);

		return ganttVO;
	}
	
	//메인페이지에서 사원이 맡고있는 프로젝트 각자의 진행률 차트로 	
	@ResponseBody
	@PostMapping("/allProjectProgress")
	public List<ProjectVO> allProjectProgress(@RequestBody ProjectVO vo){
		log.info("vo"+vo);
		log.info("vo"+vo.getEmpNo());
		List<ProjectVO> ganttVO= this.projectService.allProjectProgress(vo);
		for (int i = 0; i < ganttVO.size(); i++) {
			String startDate=ganttVO.get(i).getPrjctBeginDate();
			
		String endDate=ganttVO.get(i).getPrjctEndDate();
		LocalDate localDate = LocalDate.parse(startDate, DateTimeFormatter.ofPattern("yyyyMMdd"));
		DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		String formattedDate = localDate.format(outputFormatter);
		log.info("간트 컨트롤러메인 startDate" + formattedDate );
	
		LocalDate localDate2 = LocalDate.parse(endDate, DateTimeFormatter.BASIC_ISO_DATE);
		DateTimeFormatter outputFormatter2 = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		String formattedDate2 = localDate2.format(outputFormatter2);
		ganttVO.get(i).setPrjctBeginDate(formattedDate);
		ganttVO.get(i).setPrjctEndDate(formattedDate2);
		}
		return ganttVO;
		
	}
	
	@ResponseBody
	@PostMapping("/countProjectSttus")
	public List<ProjectVO> countProjectSttus(@RequestBody ProjectVO vo){
		
		List<ProjectVO> list= this.projectService.countProjectSttus(vo);
		return list;
	}
	
	@ResponseBody
	@PostMapping("/getEmpImage")
	public List<ProjectDutyVO> getEmpImage(@RequestBody ProjectDutyVO vo) {
		
		List<ProjectDutyVO> list= this.projectService.getEmpImage(vo);
		return list;
	}
	
	//메인페이지에서 사원이 맡고있는 프로젝트 이번엔 달력	
	@ResponseBody
	@PostMapping("/allProjectProgress2")
	public List<ProjectVO> allProjectProgress2(@RequestBody ProjectVO vo){
		log.info("vo"+vo);
		log.info("vo"+vo.getEmpNo());
		List<ProjectVO> ganttVO= this.projectService.allProjectProgress2(vo);
		for (int i = 0; i < ganttVO.size(); i++) {
			String startDate=ganttVO.get(i).getPrjctBeginDate();
			
		String endDate=ganttVO.get(i).getPrjctEndDate();
		LocalDate localDate = LocalDate.parse(startDate, DateTimeFormatter.ofPattern("yyyyMMdd"));
		DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		String formattedDate = localDate.format(outputFormatter);
		log.info("간트 컨트롤러메인 startDate" + formattedDate );
	
		LocalDate localDate2 = LocalDate.parse(endDate, DateTimeFormatter.BASIC_ISO_DATE);
		DateTimeFormatter outputFormatter2 = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		String formattedDate2 = localDate2.format(outputFormatter2);
		ganttVO.get(i).setPrjctBeginDate(formattedDate);
		ganttVO.get(i).setPrjctEndDate(formattedDate2);
		}
		return ganttVO;
		
	}
	
	//프로젝트 참가 사원 프로필 
	@ResponseBody
	@PostMapping("/getEmployeePicture")
	public List<ProjectDutyVO> getEmployeePicture(@RequestBody ProjectDutyVO vo){
		
		List<ProjectDutyVO> list =this.projectService.getEmployeePicture(vo);
		return list;
	}
	
	//프로젝트 참가 사원 프로필 호버시에 한명
	@ResponseBody
	@PostMapping("/getOneEmployeePicture")
	public List<ProjectDutyVO> getOneEmployeePicture(@RequestBody ProjectDutyVO vo){
		
		List<ProjectDutyVO> list =this.projectService.getOneEmployeePicture(vo);
		return list;
	}
	
	//프로젝트 100%시 완료로
	@ResponseBody
	@PostMapping("/doneProjectProgress")
	public int doneProjectProgress(@RequestBody ProjectVO vo) {
		
		int result= this.projectService.doneProjectProgress(vo);
		return result;		
	}
	
	
	//댓글 보여주기
	@ResponseBody
	@PostMapping("/getProjectDutyReply")
	public ArticlePageForProjectReply<ProjectDutyReplyVO> getProjectDutyReply(@RequestBody(required=false) Map<String, Object > map ,HttpSession session){
		log.info("/getProjectDutyReply"+map);
		if(map.get("currentPage")=="" || map.get("currentPage")==null) {map.put("currentPage", "1");}
		List<ProjectDutyReplyVO> list= this.projectService.getProjectDutyReply(map);
		if(list.size()==0) {
			list.add(0,new ProjectDutyReplyVO());
		}
		log.info("list->empVOList : " + list);
		int total= list.get(0).getTotal();
		int size = 3;
		String currentPage= map.get("currentPage").toString();	
		String prjctDutyNo= map.get("prjctDutyNo").toString();
		ArticlePageForProjectReply<ProjectDutyReplyVO> data =new ArticlePageForProjectReply<ProjectDutyReplyVO>(total, Integer.parseInt(currentPage), size, list, "",prjctDutyNo);
	
		String url= "/project/getProjectDutyReply";

		data.setUrl(url);

		
		return data;
	}
	
	//댓글 인서트
	@ResponseBody
	@PostMapping("/insertReply")
	public ProjectDutyReplyVO insertReply(@RequestBody ProjectDutyReplyVO vo) {
		log.info("insertReply",vo);
		int result= this.projectService.insertReply(vo);
		if(result>0) {
		ProjectDutyReplyVO lastVo= this.projectService.selectLastReply();
		return lastVo;
		}
		return null;
	}
	
	//댓글 삭제
	@ResponseBody
	@PostMapping("/deleteReply")
	public int deleteReply(@RequestBody ProjectDutyReplyVO vo) {
		int result= this.projectService.deleteReply(vo);
		return result;
	}
	
	//댓글 업데이트
	@ResponseBody
	@PostMapping("/updateReply")
	public int updateReply(@RequestBody ProjectDutyReplyVO vo) {
		int result= this.projectService.updateReply(vo);
		return result;
	}
	
	
	//파일업데이트
	@ResponseBody
	@PostMapping("/updateFile")
	public int updateFile(MultipartFile uploadFile) {
		log.info("vo"+uploadFile);
		log.info("vo",uploadFile);
		//int result= this.projectService.updateReply(vo);
		return 0;
	}
	
	//파일업데이트
	@ResponseBody
	@PostMapping("/getPrjctSttusForDashboard")
	public ProjectVO getPrjctSttusForDashboard(@RequestBody ProjectVO vo) {
		log.info("vo"+vo);
		log.info("vo",vo);
		vo= this.projectService.getPrjctSttusForDashboard(vo);
		return vo;
	}
	
	
	@GetMapping("/cpmain")
	public String chatChat() {
		
		return "project/cpmain";
	}
	
	
	//대기에서 진행중으로 업데이트하기
	@ResponseBody
	@PostMapping("/getStart")
	public int getStart(@RequestBody ProjectVO vo) {
		
		int result= this.projectService.getStart(vo);
		return result;
	}
	
	
	//리더를 업데이트하기
	@ResponseBody
	@PostMapping("/updateLeader")
	public int updateLeader(@RequestBody ProjectVO vo) {
		
		int result= this.projectService.updateLeader(vo);
		return result;
	}
	
	//프로젝트 완료된거 확인
	@ResponseBody
	@PostMapping("/isProjectDone")
	public ProjectVO isProjectDone(@RequestBody ProjectVO vo) {
		
		ProjectVO result= this.projectService.isProjectDone(vo);
		log.info("isProjectDone"+result);
		log.info("isProjectDone",result);
		return result;
	}
	
	@ResponseBody
	@PostMapping("/getDoneProjectList")
	public ArticlePageForProjectDone<ProjectVO> getDoneProjectList(@RequestBody ProjectVO vo){
		int currentPage= Integer.parseInt(vo.getCurrentPage());
		String empNo= vo.getEmpNo();
		List <ProjectVO> plist =new ArrayList<ProjectVO>();
		plist = this.projectService.getDoneProjectList(vo);
		if (plist == null || plist.isEmpty()) {	
		    plist.add(new ProjectVO());
	
		}
		for (int i = 0; i < plist.size(); i++) {
			
			String startDate=plist.get(i).getPrjctBeginDate();			
			String endDate=plist.get(i).getPrjctEndDate();
			 if (startDate != null && endDate != null) {
				LocalDate localDate = LocalDate.parse(startDate, DateTimeFormatter.ofPattern("yyyyMMdd"));
				DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
				String formattedDate = localDate.format(outputFormatter);
				log.info("간트 컨트롤러 startDate" + formattedDate );
			
				LocalDate localDate2 = LocalDate.parse(endDate, DateTimeFormatter.BASIC_ISO_DATE);
				DateTimeFormatter outputFormatter2 = DateTimeFormatter.ofPattern("yyyy-MM-dd");
				String formattedDate2 = localDate2.format(outputFormatter2);
				plist.get(i).setPrjctBeginDate(formattedDate);
				plist.get(i).setPrjctEndDate(formattedDate2);
		}
		}
		log.info("리스트출력 plist 넘어왔음: "+plist.get(0).getTotal());
		int total =plist.get(0).getTotal();
		int size = 5;
		ArticlePageForProjectDone<ProjectVO> data=new ArticlePageForProjectDone<ProjectVO> (total, currentPage, size, plist,"", "");
		return  data;
	}
	
}
