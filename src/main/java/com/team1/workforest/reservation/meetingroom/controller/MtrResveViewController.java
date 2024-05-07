package com.team1.workforest.reservation.meetingroom.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/reservation/mtr")
public class MtrResveViewController {

	// 회의실 예약 메인 페이지
	@GetMapping("/main")
	public String mtrResveMain() {
		return "reservation/meetingroom/main";
	}

}
