package com.team1.workforest.schedulerUtil.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.schedulerUtil.service.AlramService;
import com.team1.workforest.vo.NotificationVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/alram")
public class AlramController {
	
	@Autowired
	AlramService alramService;
	
	@ResponseBody
	@GetMapping("/addAlram")
	public int addAlram(@RequestParam Map<String, String> map) {
		
		int data = this.alramService.addAlram(map);
		
		return data;
	}
	
	@ResponseBody
	@GetMapping("/getAlramCount")
	public String getAlramCount(@RequestParam Map<String, String> map) {
		
		String data = this.alramService.getAlramCount(map);
		
		return data;
	}
	
	@ResponseBody
	@GetMapping("/updateAlramYN")
	public int updateAlramYN(EmployeeVO empVo) {
		
		int data = this.alramService.updateAlramYN(empVo);
		
		return data;
	}
	@ResponseBody
	@GetMapping("/updateAlramSeeYN")
	public int updateAlramSeeYN(@RequestParam Map<String, String> map) {
		
		int data = this.alramService.updateAlramSeeYN(map);
		
		return data;
	}
	
	@ResponseBody
	@GetMapping("/getAlram")
	public List<NotificationVO> getAlram(EmployeeVO empVo) {
		
		List<NotificationVO> data = this.alramService.getAlramList(empVo);
		
		return data;
		
	}
	
	@ResponseBody
	@GetMapping("/getEmpDutyYN")
	public String getEmpDutyYN(EmployeeVO empVo) {
		
		String data = this.alramService.getEmpDutyYN(empVo);
		
		return data;
		
	}
	
	@ResponseBody
	@GetMapping("/getEmpApvYN")
	public String getEmpApvYN(EmployeeVO empVo) {
		
		String data = this.alramService.getEmpApvYN(empVo);
		
		return data;
		
	}
	
	
}
