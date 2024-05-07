package com.team1.workforest.reservation.car.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/reservation/car")
public class CarResveViewController {

	// 차량 예약 메인 페이지
	@GetMapping("/main")
	public String carResveMain() {
		return "reservation/car/main";
	}

}
