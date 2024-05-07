package com.team1.workforest.schedule.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/schedule")
public class ScheduleViewController {

	// 일정 메인 페이지
	@GetMapping("/main")
	public String scheduleMain() {
		return "schedule/main";
	}
}
