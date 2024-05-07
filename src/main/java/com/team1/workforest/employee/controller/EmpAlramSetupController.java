package com.team1.workforest.employee.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.team1.workforest.employee.service.EmpAlramSetupService;
import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.vo.UserSetupNtcnMatterVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/empAlram")
public class EmpAlramSetupController {
	
	@Autowired
	EmpAlramSetupService empAlramSetupService;
	
	
	@ResponseBody
	@GetMapping("/getAlramSetUpList")
	public List<UserSetupNtcnMatterVO> getAlramSetUpList(EmployeeVO empVo){
		
		
		List<UserSetupNtcnMatterVO> data = this.empAlramSetupService.getAlramSetUpList(empVo);
		
		
		return data;
		
	}
	
	@ResponseBody
	@GetMapping("/updateAlramSetUpList")
	public int updateAlramSetUpList(@RequestParam Map<String, String> map){
		
		
		int data = this.empAlramSetupService.updateAlramSetUpList(map);
		
		
		return data;
		
	}

}
