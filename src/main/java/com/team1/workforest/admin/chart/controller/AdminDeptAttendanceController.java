package com.team1.workforest.admin.chart.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.team1.workforest.admin.chart.service.AdminDeptAttendanceService;
import com.team1.workforest.attendance.vo.AttendanceManageVO;
import com.team1.workforest.vo.DepartmentVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/adminDeptAttendance")
public class AdminDeptAttendanceController {
	
	@Autowired
	AdminDeptAttendanceService adminDeptAttendanceService;
	
	// 관리자 근태 통계 메인 페이지
	@GetMapping("/main")
	public String AdminProject() {
		return "admin/chart/deptAttendance";
	}
	
	@ResponseBody
	@GetMapping("/getDept1")
	public List<DepartmentVO> getDept1() {
		
		List<DepartmentVO> data = this.adminDeptAttendanceService.getDept1();
		
		return data;
	}
	
	@ResponseBody
	@GetMapping("/getDept2")
	public List<DepartmentVO> getDept2(DepartmentVO deptVo) {
		
		List<DepartmentVO> data = this.adminDeptAttendanceService.getDept2(deptVo);
		
		return data;
	}
	
	@ResponseBody
	@GetMapping("/getDeptEmpAttendance")
	public List<AttendanceManageVO> getDeptEmpAttendance(@RequestParam Map<String, String> map) {
		
		List<AttendanceManageVO> data = this.adminDeptAttendanceService.getDeptEmpAttendance(map);
		
		return data;
	}
	
	@ResponseBody
	@GetMapping("/getAvgRes")
	public Map<String, String> getAvgRes(@RequestParam Map<String, String> map) {
		
		Map<String, String> data = this.adminDeptAttendanceService.getAvgRes(map);
		
		return data;
	}
	
	
		
	
}
