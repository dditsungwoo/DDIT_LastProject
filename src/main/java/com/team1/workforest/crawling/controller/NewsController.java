package com.team1.workforest.crawling.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.team1.workforest.crawling.service.NewsService;
import com.team1.workforest.crawling.vo.NewsVO;

import lombok.extern.slf4j.Slf4j;
@Slf4j
@RequestMapping("/news")
@Controller
public class NewsController {

	@Autowired
    NewsService newsService;

    public NewsController(NewsService newsService) {
        this.newsService = newsService;
    }
    

// 	@GetMapping("/news")
// 	public String news() {
// 		return "news/news";
//
// 	}

    @GetMapping("/news")
    public String news(Model model) throws Exception{
        List<NewsVO> newsList = newsService.getNewsDatas();
        model.addAttribute("newsList", newsList);
        log.info("newsList:{}", newsList);
        return "news/news";
    }
}
