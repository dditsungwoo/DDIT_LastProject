package com.team1.workforest.admin.chart.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.team1.workforest.admin.chart.service.AdminAttendanceService;
import com.team1.workforest.admin.chart.service.AdminProjectService;
import com.team1.workforest.admin.chart.vo.adminEmpVO;
import com.team1.workforest.attendance.controller.AttendanceController;
import com.team1.workforest.attendance.vo.AttendanceManageVO;
import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.project.vo.ProjectVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/adminAttendance")
public class AdminAttendanceController {
	
	@Autowired
	AdminAttendanceService adminAttendanceService;
	
	// 관리자 근태 통계 메인 페이지
	@GetMapping("/main")
	public String AdminProject() {
		return "admin/chart/attendance";
	}
	
	@ResponseBody
	@GetMapping("/getEmp")
	public List<EmployeeVO> getEmp(@RequestParam Map<String, String> map) {
		List<EmployeeVO> empVOList = this.adminAttendanceService.getEmp(map);
		
		return empVOList;
	}
	
	@ResponseBody
	@GetMapping("/getEmpNo")
	public List<EmployeeVO> getEmpNo(@RequestParam Map<String, String> map) {
		List<EmployeeVO> empVOList = this.adminAttendanceService.getEmpNo(map);
		
		return empVOList;
	}
	
	@ResponseBody
	@GetMapping("/getAvgRes")
	public Map<String,String> getAvgRes(@RequestParam Map<String, String> map) {
		Map<String,String> data = this.adminAttendanceService.getAvgRes(map);
		
		return data;
	}
	
	@ResponseBody
	@GetMapping("/getAttendList")
	public List<AttendanceManageVO> getAttendList(@RequestParam Map<String, String> map) {
		log.warn("Map{}:" + map);
		List<AttendanceManageVO> attendanceVOList = this.adminAttendanceService.getAttendanceList(map);
		
		return attendanceVOList;
	}
	
		
	
}
