package com.team1.workforest.duty.controller;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.team1.workforest.common.service.CommonService;
import com.team1.workforest.duty.service.DutyService;
import com.team1.workforest.duty.vo.DutyRecipientVO;
import com.team1.workforest.duty.vo.DutyVO;
import com.team1.workforest.employee.vo.EmployeeVO;

import com.team1.workforest.duty.util.ArticlePageForDuty;
import com.team1.workforest.duty.util.ArticlePageForSenderMain;

import lombok.extern.slf4j.Slf4j;
@Slf4j
@Controller
@RequestMapping("/duty")
public class DutyController {
	@Autowired
	DutyService dutyService;
	
	@Autowired
	CommonService commonService;
	
	// 업무 메인 페이지
	@GetMapping("/main")
	public String dutyMain() {
		return "duty/main";
	}
	
	// 받은 업무 리스트 가져오기
	@ResponseBody
	@PostMapping("/getDutyList")
	public ArticlePageForDuty<DutyVO> getDutyList(@RequestBody(required=false) Map<String, Object > map ,HttpSession session ) {
		
		String empNo= (String) session.getAttribute("empNo");
		//Map<String, Object > map =new HashMap<String, Object>();
		map.put("empNo", empNo);
		
		
		List<DutyVO> dutyVOList= this.dutyService.getDutyList(map);
		if(dutyVOList.size()==0) {
			dutyVOList.add(0,new DutyVO());
		}
		log.info("list->empVOList : " + dutyVOList);		
		int total= dutyVOList.get(0).getTotal();
		String keyword= dutyVOList.get(0).getKeyword();
		log.info("list->total : " + total);
		int size = 4;
				
		String currentPage= map.get("currentPage").toString();	
		
		ArticlePageForDuty<DutyVO> data= new ArticlePageForDuty<DutyVO>(total, Integer.parseInt(currentPage), size, dutyVOList, keyword);
		

		String url= "/duty/getDutyList";

		data.setUrl(url);

		
		return data;
	}
	
	//원형 차트의 데이터를 가져오기
	@ResponseBody
	@PostMapping("/getPieChart")
	public List<DutyRecipientVO> getPieChart(@RequestBody DutyVO vo){
		log.info("getPieChart",vo);
		List<DutyRecipientVO> list= this.dutyService.getPieChart(vo);
		log.info("getPieChart 쿼리후"+list);
		return list;
	}
	
	//오늘 할일의 데이터를 가져오기
	@ResponseBody
	@PostMapping("/todayDoList")
	public List<DutyVO> todayDoList(@RequestBody DutyVO vo ,Model model){
		log.info("todayDoList11"+vo);
		List<DutyVO> list= this.dutyService.todayDoList(vo);
		model.addAttribute("day",vo.getSendDate());
		log.info("todayDoList11 쿼리후",list);
		return list;
	}
	
	//오늘 업무를 클릭하면 완료
	@ResponseBody
	@PostMapping("/clickAndDone")
	public int clickAndDone(@RequestBody DutyVO vo) {
		log.info("clickAndDone",vo);
		int result= this.dutyService.clickAndDone(vo);
		log.info("clickAndDone 쿼리후",result);
		return result;
	}
	
	//이번주 업무 리스트
	@ResponseBody
	@PostMapping("/weekDoList")
	public List<DutyVO> weekDoList(@RequestBody DutyVO vo){
		log.info("clickAndDone",vo);
		List<DutyVO> list = this.dutyService. weekDoList(vo);
		log.info("clickAndDone 쿼리후", list);
		return list;
	}
	
	
	// 업무 디테일 페이지로	
	@GetMapping("/detail")
	public String detail(@RequestParam String empNo, String dutyNo, Model model) {
		DutyVO vo= new DutyVO();
		vo.setEmpNo(empNo);
		vo.setDutyNo(dutyNo);
		log.info("/detail",vo);
		vo= this.dutyService.dutyDetail(vo);
		log.info("/detail 쿼리 후 ",vo);
	 	String position = vo.getPosition();
        String rspnsbl = vo.getRspnsbl();
        if (!rspnsbl.equals("팀원")) {
            position = rspnsbl;
        }
        vo.setPosition(position);
		model.addAttribute("vo",vo);
		
		return "duty/detail";
	}
	
	// 업무 디테일 페이지로	
	@GetMapping("/senderDetail")
	public String senderDetail(@RequestParam String empNo,@RequestParam String dutyNo, Model model) {
		DutyVO vo= new DutyVO();
		vo.setEmpNo(empNo);
		vo.setDutyNo(dutyNo);
		log.info("senderDetail",vo);
		vo= this.dutyService.senderDetail(vo);
		log.info("senderDetail 쿼리 후 "+vo);
		model.addAttribute("vo",vo);
		
		return "duty/senderDetail";
	}
	
	//디테일 화면에서 진행률 업데이트	
	@ResponseBody
	@PostMapping("/detailPrgsUpdate")
	public int detailPrgsUpdate(@RequestBody DutyVO vo) {
		log.info("/detailPrgsUpdate",vo);
		int result =this.dutyService.detailPrgsUpdate(vo);
		log.info("/detailPrgsUpdate 쿼리후",vo);
		return result;
	}


	//대쉬보드 화면 
	@ResponseBody
	@PostMapping("/getDashDuty")
	public Map<String ,Object> getDashDuty(@RequestBody DutyVO vo) {
		log.info("/detailPrgsUpdate",vo);
		List<DutyVO> list =this.dutyService.getDashDuty(vo);
		log.info("/detailPrgsUpdate 쿼리후",list);
		Map<String ,Object> map =new HashMap<String, Object>();
		map.put("list", list);
		int total= this.dutyService.getDashTotal(vo);
		map.put("total",total);
		return map;
	}
	
	
	

	/*--------이후 관리자------------------------------------------------------------
	------------------------------------------------------------------------------
	*/
	
	
	//관리자 메인 페이지
	@GetMapping("/sender")
	public String senderMain() {
		return "duty/senderMain";
	}
	
	
	//관리자의 왼쪽 상단 통계
	@ResponseBody
	@PostMapping("/senderChart1")
	public List<DutyVO> senderChart1(@RequestBody DutyVO vo){
		log.info("/senderChart1",vo);
		List<DutyVO> list =this.dutyService.senderChart1(vo);
		log.info("/senderChart1 쿼리후"+list);
		return list;
	}
	
	
	//관리자의 중앙 통계(오늘할일)
		@ResponseBody
		@PostMapping("/senderChart2")
		public List<DutyVO> senderChart2(@RequestBody DutyVO vo){
			log.info("/senderChart2",vo);
			List<DutyVO> list =this.dutyService.senderChart2(vo);
			log.info("/senderChart2 쿼리후",list);
			return list;
		}
	
		
		//관리자의 오른쪽 상단 통계(달력)
		@ResponseBody
		@PostMapping("/senderChart3")
		public List<DutyVO> senderChart3(@RequestBody DutyVO vo){
			log.info("/senderChart3",vo);
			List<DutyVO> list =this.dutyService.senderChart3(vo);
			log.info("/senderChart3 쿼리후",list);
			return list;
		}
		
		//관리자용 메인 하단에 보일 리스트
		@ResponseBody
		@PostMapping("/getDutyListForSender")
		public ArticlePageForSenderMain<DutyVO> getDutyListForSender(@RequestBody(required=false) Map<String, Object > map ,HttpSession session ) {
			
			String empNo= (String) session.getAttribute("empNo");
			//Map<String, Object > map =new HashMap<String, Object>();
			map.put("empNo", empNo);
			
			
			List<DutyVO> dutyVOList= this.dutyService.getDutyListForSender(map);
			if(dutyVOList.size()==0) {
				dutyVOList.add(0,new DutyVO());
			}
			log.info("list->empVOList : " + dutyVOList);		
			int total= dutyVOList.get(0).getTotal();
			String keyword= dutyVOList.get(0).getKeyword();
			log.info("list->total : " + total);
			int size = 4;
					
			String currentPage= map.get("currentPage").toString();	
			
			ArticlePageForSenderMain<DutyVO> data= new ArticlePageForSenderMain<DutyVO>(total, Integer.parseInt(currentPage), size, dutyVOList, keyword);
			

			String url= "/duty/getDutyListForSender";

			data.setUrl(url);

			
			return data;
		}
		
		
		//관리자용 메인 하단에 보일 리스트
		@ResponseBody
		@PostMapping("/getDutyListCnfirmDate")
		public ArticlePageForSenderMain<DutyVO> getDutyListCnfirmDate(@RequestBody(required=false) Map<String, Object > map ,HttpSession session ) {
			
			String empNo= (String) session.getAttribute("empNo");
			//Map<String, Object > map =new HashMap<String, Object>();
			map.put("empNo", empNo);
			
			
			List<DutyVO> dutyVOList= this.dutyService.getDutyListCnfirmDate(map);
			if(dutyVOList.size()==0) {
				dutyVOList.add(0,new DutyVO());
			}
			log.info("list->empVOList : " + dutyVOList);		
			int total= dutyVOList.get(0).getTotal();
			String keyword= dutyVOList.get(0).getKeyword();
			log.info("list->total : " + total);
			int size = 4;
					
			String currentPage= map.get("currentPage").toString();	
			
			ArticlePageForSenderMain<DutyVO> data= new ArticlePageForSenderMain<DutyVO>(total, Integer.parseInt(currentPage), size, dutyVOList, keyword);
			

			String url= "/duty/getDutyListCnfirmDate";

			data.setUrl(url);

			
			return data;
			
			
			
		}
		
		
		//(관리자) 업무 insert
		@PostMapping("/insertDuty")
		public String insertDuty(DutyVO vo) {
			log.info("insertDuty "+vo);
			int result=this.dutyService.insertDuty(vo);
			
			return "redirect:/duty/sender";

		}
		
		//(관리자) 업무 delete
		@ResponseBody
		@PostMapping("/deleteDuty")
		public int deleteDuty(@RequestBody DutyVO vo) {
			log.info("insertDuty "+vo);
			int result=this.dutyService.deleteDuty(vo);

			return result;
		}
		
		//(관리자) 업무 update
		@ResponseBody
		@PostMapping("/updateDuty")
		public int updateDuty(@RequestBody DutyVO vo) {
			log.info("updateDuty "+vo);
			int result=this.dutyService.updateDuty(vo);

			return result;
		}
		
		@ResponseBody
		@PostMapping("/getEmpInfo")
		public EmployeeVO getEmpInfo(@RequestBody DutyVO vo) {
			log.info("getEmpInfo "+vo);
			String empNo= vo.getEmpNo();
			EmployeeVO empVO= this.commonService.getEmpInfo(empNo);
			return empVO;
		}
		
		
}
