package com.team1.workforest.security;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class CommonControl {
	@GetMapping("/accessError")
	public String accessError(Authentication auth, Model model) {
		log.info("accessError");
		
		model.addAttribute("msg", "권한이 없습니다.");
		return "accessError";
	}

}
