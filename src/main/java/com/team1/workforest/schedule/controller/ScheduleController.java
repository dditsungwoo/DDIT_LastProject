package com.team1.workforest.schedule.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.team1.workforest.schedule.service.ScheduleService;
import com.team1.workforest.schedule.vo.ScheduleVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api")
public class ScheduleController {

	@Autowired
	ScheduleService scheduleService;

	// 일정 리스트 불러오기(캘린더)
	@GetMapping("/schedules")
	public JSONArray getScheduleList(HttpServletRequest request, @RequestParam(value = "chkSchs", required = false) List<String> chkSchs) {
		log.info("chkSchs : " + chkSchs);
		
		// HttpServletRequest를 사용하여 세션에 접근
        HttpSession session = request.getSession();
        // 세션에서 속성값 가져오기
        String empNo = (String) session.getAttribute("empNo");
        log.info("empNo : {}", empNo);
        
  		return scheduleService.getScheduleList(empNo, chkSchs);
	}
	
	// 특정 일정 불러오기
	@GetMapping("/schedule/{schdulNo}")
	public ScheduleVO getSchedule(@PathVariable String schdulNo) {
		return scheduleService.getSchedule(schdulNo);
	}


	// 일정 추가
	@PostMapping("/schedule")
	public String createSchedule(@RequestBody ScheduleVO scheduleVO) {
		log.info("scheduleVO : {}", scheduleVO);

		int result = scheduleService.createSchedule(scheduleVO);

		if (result != 0) {
			return "success";
		}

		return "fail";
	}

	// 일정 수정
	@PutMapping("/schedule/{schdulNo}")
	public String updateSchedule(@PathVariable String schdulNo, @RequestBody ScheduleVO scheduleVO) {
		// 일정 번호 vo에 추가
		scheduleVO.setSchdulNo(schdulNo);
		int result = scheduleService.updateSchedule(scheduleVO);
		log.info("scheduleVO : {}", scheduleVO);

		if (result != 0) {
			return "success";
		}
		return "fail";
	}

	// 일정 삭제하기
	@DeleteMapping("/schedule/{schdulNo}")
	public String deleteSchedule(@PathVariable String schdulNo) {
		int result = scheduleService.deleteSchedule(schdulNo);
		
		if (result != 0) {
			return "success";
		}
		return "fail";
	}
	
	// 오늘 일정 불러오기
	@GetMapping("/schedules/today/{empNo}")
	public JSONArray getTodayMyScheduleList(@PathVariable String empNo) {
		return scheduleService.getTodayScheduleList(empNo);
	}
}
