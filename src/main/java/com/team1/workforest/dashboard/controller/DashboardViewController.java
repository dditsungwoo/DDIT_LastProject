package com.team1.workforest.dashboard.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/dashboard")
public class DashboardViewController {
	
	@GetMapping("/main")
	public String dashboardMain() {
		return "dashboard/main";
	}

}
