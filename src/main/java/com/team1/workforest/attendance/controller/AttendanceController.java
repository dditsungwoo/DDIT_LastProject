package com.team1.workforest.attendance.controller;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.team1.workforest.attendance.service.AttendanceService;
import com.team1.workforest.attendance.vo.AttendanceManageVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/attendance")
public class AttendanceController {
	
	@Autowired
	AttendanceService attendanceService;
	
	// 근태 관리 메인 페이지
	@GetMapping("/main")
	public String AttendanceMain() {
		return "attendance/main";
	}
	
	// 근태 관리 메인 페이지
	@GetMapping("/main2")
	public String AttendanceMain2() {
		return "attendance/main2";
	}

	@ResponseBody
	@GetMapping("/getAttendList")
	public List<AttendanceManageVO> getAttendList(@RequestParam Map<String, String> map) {
		List<AttendanceManageVO> attendanceVOList = this.attendanceService.getAttendanceList(map);
		
		return attendanceVOList;
	}
	
	@ResponseBody
	@GetMapping("/chart02")
	public String chart02(@RequestParam Map<String, String> map) {
		String workTime = this.attendanceService.getTodayWorkTime(map);
		
		return workTime;
	}
	
	@ResponseBody
	@GetMapping("/chart03")
	public List<String> chart03(@RequestParam Map<String, String> map) {
		List<String> weekWorkTime = this.attendanceService.getWeekWorkTime(map);
		
		return weekWorkTime;
	}
	
	@ResponseBody
	@GetMapping("/getPlusTime")
	public String getPlusTime(@RequestParam Map<String, String> map) {
		String plusTime = this.attendanceService.getPlusTime(map);
		return plusTime;
	}
	
	@ResponseBody
	@GetMapping("/getMinusTime")
	public String getMinusTime(@RequestParam Map<String, String> map) {
		String MinusTime = this.attendanceService.getMinusTime(map);
		
		return MinusTime;
	}
	
	@ResponseBody
	@GetMapping("/getOverTime")
	public String getOverTime(@RequestParam Map<String, String> map) {
		String OverTime = this.attendanceService.getOverTime(map);
		
		return OverTime;
	}
	
	@ResponseBody
	@GetMapping("/getAvgAttend")
	public String getAvgAttend(@RequestParam Map<String, String> map) {
		String avgAttend = this.attendanceService.getAvgAttend(map);
		
		return avgAttend;
	}
	
	@ResponseBody
	@GetMapping("/getAvgLeave")
	public String getAvgLeave(@RequestParam Map<String, String> map) {
		String avgLeave = this.attendanceService.getAvgLeave(map);
		
		return avgLeave;
	}
	
	@ResponseBody
	@GetMapping("/getAvgWork")
	public String getAvgWork(@RequestParam Map<String, String> map) {
		String avgWork = this.attendanceService.getAvgWork(map);
		
		return avgWork;
	}
	
	@ResponseBody
	@GetMapping("/getLateCount")
	public String getLateCount(@RequestParam Map<String, String> map) {
		String lateCount = this.attendanceService.getLateCount(map);
		
		return lateCount;
	}
	
	@ResponseBody
	@GetMapping("/getRestCount")
	public String getRestCount(@RequestParam Map<String, String> map) {
		String restCount = this.attendanceService.getRestCount(map);
		
		return restCount;
	}
	
	@ResponseBody
	@GetMapping("/getOut1Count")
	public String getOut1Count(@RequestParam Map<String, String> map) {
		String out1Count = this.attendanceService.getOut1Count(map);
		
		return out1Count;
	}
	
	@ResponseBody
	@GetMapping("/getOut2Count")
	public String getOut2Count(@RequestParam Map<String, String> map) {
		String out2Count = this.attendanceService.getOut2Count(map);
		
		return out2Count;
	}
	
	@ResponseBody
	@GetMapping("/getOut3Count")
	public String getOut3Count(@RequestParam Map<String, String> map) {
		String out3Count = this.attendanceService.getOut3Count(map);
		
		return out3Count;
	}
	
	
	@ResponseBody
	@GetMapping("/getAttendTime")
	public String getAttendTime(@RequestParam Map<String, String> map) {
		String attendTime = this.attendanceService.getAttendTime(map);
		
		return attendTime;
	}
	
	@ResponseBody
	@GetMapping("/getLvffcTime")
	public String getLvffcTime(@RequestParam Map<String, String> map) {
		String lvffcTime = this.attendanceService.getLvffcTime(map);
		
		return lvffcTime;
	}
	
	@GetMapping("/attendConfirm")
	public String attendConfirm(@RequestParam Map<String, String> map, Model model) {
		
		model.addAttribute("empNo", map.get("empNo"));
		model.addAttribute("vcatnSeCd", map.get("vcatnSeCd"));
		
		return "attendance/attendConfirm";
	}
	
	@GetMapping("/lvffcConfirm")
	public String lvffcConfirm(@RequestParam Map<String, String> map, Model model) {
		
		model.addAttribute("empNo", map.get("empNo"));
		
		return "attendance/lvffcConfirm";
	}
	
	@ResponseBody
	@PostMapping("/insertAttend")
	public int insertAttend(@RequestParam Map<String, String> map) {
		int insertAttend = this.attendanceService.insertAttend(map);
		
		return insertAttend;
	}
	
	@ResponseBody
	@PostMapping("/insertLvffc")
	public int insertLvffc(@RequestParam Map<String, String> map) {
		log.info("map:",map);
		int insertLvffc = this.attendanceService.insertLvffc(map);
		
		return insertLvffc;
	}
	
	@ResponseBody
	@GetMapping("/getTodayRestUse")
	public String getTodayRestUse(@RequestParam Map<String, String> map) {
		log.info("map:",map);
		String restUse = this.attendanceService.getTodayRestUse(map);
		
		return restUse;
	}
	
	@ResponseBody
	@GetMapping("/getVcatnSeCd")
	public List<String> getVcatnSeCd(@RequestParam Map<String, String> map) {
		List<String> data = this.attendanceService.getVcatnSeCd(map);
		
		return data;
	}
	
}
