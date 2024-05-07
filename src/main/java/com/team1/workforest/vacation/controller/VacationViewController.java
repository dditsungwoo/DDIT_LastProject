package com.team1.workforest.vacation.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/vacation")
public class VacationViewController {

	// 휴가 메인 페이지
	@GetMapping("/main")
	public String vacationMain() {
		return "vacation/main";
	}

}
