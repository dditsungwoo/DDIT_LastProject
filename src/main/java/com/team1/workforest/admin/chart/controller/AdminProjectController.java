package com.team1.workforest.admin.chart.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.team1.workforest.admin.chart.service.AdminProjectService;
import com.team1.workforest.admin.chart.vo.adminEmpVO;
import com.team1.workforest.attendance.controller.AttendanceController;
import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.project.vo.ProjectDutyVO;
import com.team1.workforest.project.vo.ProjectVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/adminProject")
public class AdminProjectController {
	
	@Autowired
	AdminProjectService adminProjectService;
	
	// 관리자 프로젝트 통계 메인 페이지
	@GetMapping("/main")
	public String AdminProject() {
		return "admin/chart/project";
	}
	
	@ResponseBody
	@GetMapping("/getProjectCount")
	public List<String> getProjectCount() {
		List<String> data = this.adminProjectService.getProjectCount();
		
		return data;
	}
	
	@ResponseBody
	@GetMapping("/getEnableEmp")
	public List<adminEmpVO> getEnableEmp() {
		List<adminEmpVO> data = this.adminProjectService.getEnableEmp();
		
		return data;
	}
	
	@ResponseBody
	@GetMapping("/getMonthNewProj")
	public List<String> getMonthNewProj(@RequestParam Map<String, String> map) {
		List<String> data = this.adminProjectService.getMonthNewProj(map);
		
		return data;
	}
	
	@ResponseBody
	@GetMapping("/getMonthEndProj")
	public List<String> getMonthEndProj(@RequestParam Map<String, String> map) {
		List<String> data = this.adminProjectService.getMonthEndProj(map);
		
		return data;
	}
	
	@ResponseBody
	@GetMapping("/getProceedPeriod")
	public List<String> getProceedPeriod() {
		List<String> data = this.adminProjectService.getProceedPeriod();
		
		return data;
	}
	
	@ResponseBody
	@GetMapping("/getProjects")
	public List<ProjectVO> getProjects() {
		List<ProjectVO> data = this.adminProjectService.getProjects();
		
		return data;
	}
	
	@ResponseBody
	@GetMapping("/getProjectEmp")
	public List<EmployeeVO> getProjectEmp(ProjectVO pVo) {
		List<EmployeeVO> list = this.adminProjectService.getProjectEmp(pVo);
		
		return list;
	}
	
	@ResponseBody
	@GetMapping("/getEmpPjDuty")
	public List<ProjectDutyVO> getEmpPjDuty(ProjectVO pVo) {
		List<ProjectDutyVO> list = this.adminProjectService.getEmpPjDuty(pVo);
		
		return list;
	}
		
	
}
