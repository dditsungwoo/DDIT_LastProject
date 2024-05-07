package com.team1.workforest.admin.chart.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.team1.workforest.admin.chart.service.AdminEmpService;
import com.team1.workforest.admin.chart.vo.adminEmpVO;
import com.team1.workforest.vo.DepartmentVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/adminEmp")
public class AdminEmpController {
	
	@Autowired
	AdminEmpService adminEmpService;
	
	// 관리자 사원 통계 메인 페이지
	@GetMapping("/main")
	public String AdminEmp() {
		return "admin/chart/employee";
	}
	
	@GetMapping("/socket")
	public String socket() {
		return "admin/webSocket";
	}
	
	
	
	@ResponseBody
	@GetMapping("/getAgeGraph")
	public List<Integer> getAgeGraph(@RequestParam Map<String, String> map) {
		
		List<Integer> data = this.adminEmpService.getAgeGraph(map);
		
		return data;
		
	}
	
	@ResponseBody
	@GetMapping("/getAvgAge")
	public int getAvgAge(@RequestParam Map<String, String> map) {
		
		int data = this.adminEmpService.getAvgAge(map);
		
		return data;
		
	}
	
	@ResponseBody
	@GetMapping("/getEmpCount")
	public int getEmpCount(@RequestParam Map<String, String> map) {
		
		int data = this.adminEmpService.getEmpCount(map);
		
		return data;
		
	}
	
	@ResponseBody
	@GetMapping("/getGenderRate")
	public List<Integer> getGenderRate(@RequestParam Map<String, String> map) {
		
		List<Integer> data = this.adminEmpService.getGenderRate(map);
		
		return data;
		
	}
	
	@ResponseBody
	@GetMapping("/getRetireCount")
	public List<Integer> getRetireCount(@RequestParam Map<String, String> map) {
		
		List<Integer> data = this.adminEmpService.getRetireCount(map);
		
		return data;
		
	}
	
	@ResponseBody
	@GetMapping("/getHireCount")
	public int getHireCount(@RequestParam Map<String, String> map) {
		
		int data = this.adminEmpService.getHireCount(map);
		
		return data;
		
	}
	
	@ResponseBody
	@GetMapping("/getDeptCount")
	public List<String> getDeptCount(@RequestParam Map<String, String> map) {
		
		List<String> data = this.adminEmpService.getDeptCount(map);
		
		return data;
		
	}
	
	@ResponseBody
	@GetMapping("/getDeptName")
	public List<DepartmentVO> getDeptName(@RequestParam Map<String, String> map) {
		
		List<DepartmentVO> data = this.adminEmpService.getDeptName(map);
		
		return data;
		
	}
	
	@ResponseBody
	@GetMapping("/getRetireRate")
	public List<String> getRetireRate(@RequestParam Map<String, String> map) {
		
		List<String> data = this.adminEmpService.getRetireRate(map);
		
		return data;
		
	}
	
	@ResponseBody
	@GetMapping("/getYearRetireRate")
	public String getYearRetireRate(@RequestParam Map<String, String> map) {
		
		String data = this.adminEmpService.getYearRetireRate(map);
		
		return data;
		
	}
	
	@ResponseBody
	@GetMapping("/getPositionGraph")
	public List<adminEmpVO> getPositionGraph(@RequestParam Map<String, String> map) {
		
		List<adminEmpVO> data = this.adminEmpService.getPositionGraph(map);
		
		return data;
		
	}
	
	@ResponseBody
	@GetMapping("/getLoaclCount")
	public List<adminEmpVO> getLocalCount(@RequestParam Map<String, String> map) {
		
		List<adminEmpVO> data = this.adminEmpService.getLocalCount(map);
		
		return data;
		
	}
	
	@ResponseBody
	@GetMapping("/getWorkerCount")
	public List<adminEmpVO> getWorkerCount(@RequestParam Map<String, String> map) {
		
		List<adminEmpVO> data = this.adminEmpService.getWorkerCount(map);
		
		return data;
		
	}
	
}
