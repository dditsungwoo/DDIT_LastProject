package com.team1.workforest.admin.reservation.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
public class AdminResveViewController {
	
	@GetMapping("/reservation/manageMtrResves")
	public String manageMtrReservationMain() {
		return "admin/reservation/manageMtrResves";
	}

	@GetMapping("/reservation/manageCarResves")
	public String manageCarReservationMain() {
		return "admin/reservation/manageCarResves";
	}
	
	@GetMapping("/reservation/manageResources")
	public String manageResourcesMain() {
		return "admin/reservation/manageResources";
	}
}
