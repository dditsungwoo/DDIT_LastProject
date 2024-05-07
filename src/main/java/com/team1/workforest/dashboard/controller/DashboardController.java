package com.team1.workforest.dashboard.controller;

import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.team1.workforest.dashboard.service.DashboardService;

import lombok.extern.slf4j.Slf4j;
@Slf4j
@RestController
@RequestMapping("/dashboard")
public class DashboardController {
	
	@Autowired
	DashboardService dashboardService;
	
	@GetMapping("/list")
	public String updateDashboard(@RequestParam("str") String str, String empNo, HttpSession session, Map<String, Object> map){
		log.info("str : " + str);
		empNo = (String)session.getAttribute("empNo");
		map.put("empNo", empNo);
		map.put("dashOrder", str);
		
		int result = dashboardService.updateDashboard(map);
		
		if (result != 0) {
			return "success";
		}
		return "fail";
	}
	
}
