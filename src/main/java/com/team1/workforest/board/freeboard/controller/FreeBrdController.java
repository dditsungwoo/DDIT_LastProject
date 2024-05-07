package com.team1.workforest.board.freeboard.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/freeboard")
public class FreeBrdController {
	
	// 자유게시판 리스트 페이지(메인)
	@GetMapping("/list")
	public String getFreeBrdList () {
		return "board/freeboard/list";
	}

}
