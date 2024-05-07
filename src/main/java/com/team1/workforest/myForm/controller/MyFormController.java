package com.team1.workforest.myForm.controller;

import java.text.SimpleDateFormat;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.team1.workforest.myForm.service.MyFormService;
import com.team1.workforest.myForm.vo.MyFormVO;
import com.team1.workforest.vo.DepartmentVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class MyFormController {
	
	@Autowired
	MyFormService mformService;

	// 문서발급관리 메인
	@GetMapping("/docList")
	public String docMain() {
		return "admin/docMain";
	}

	// 관리- 목록
	@ResponseBody
	@PostMapping("/docList")
	public List<MyFormVO> getDocList(@RequestBody MyFormVO mFormVO) {
		log.info("mFormVO:", mFormVO);
		List<MyFormVO> docVOList = this.mformService.docList(mFormVO);
		log.info("MyFormVO: {}", docVOList);
	//	model.addAttribute("docVOList", docVOList);
		return docVOList;
	}
	  

	

	// 발급 상태 변경 
	@PostMapping("/updateDocStatus")
	public String updateDocStatus(MyFormVO mFormVO) {
		log.info("mFormVO: " + mFormVO);

		int result = this.mformService.updateDocStatus(mFormVO);
		log.info("updateDocStatus->result : " + result);

		return "redirect:/docList";
	}

	// 발급신청번호 자동 부여
	@ResponseBody
	@PostMapping("/findDocNo")
	public String findDocNo() {
		//log.info("mFormVO:{}", mFormVO);
		String MyDocNo = this.mformService.findDocNo();
		log.info("MyDocNo:", MyDocNo);
		return MyDocNo;
	}

	// 발급 신청 addDoc
	@PostMapping("/addDoc")
	public String addDoc(MyFormVO mFormVO, HttpSession session) {
		log.info("mFormVO: " + mFormVO);

	
		int result = this.mformService.addDoc(mFormVO);

		log.info("addDoc->result : " + result);

		//return null;
		return "redirect:/emp/detail?empNo=" + session.getAttribute("empNo");
	}
	
	//내발급신청목록
	@ResponseBody
	@PostMapping("/getMyDocList")
		public List<MyFormVO> getMyDocList(@RequestBody MyFormVO mFormVO) {

//		   log.info("sempNo:",empNo);
//		   mFormVO.setEmpNo(empNo);
		
			List<MyFormVO> mFormVOList = this.mformService.getMyDocList(mFormVO);
			log.info("mFormVOList: {}", mFormVOList);
			//model.addAttribute("mFormVOList", mFormVOList);
			
			return mFormVOList;
			//return "redirect:/emp/detail?empNo=" + session.getAttribute("empNo");
		}

}
