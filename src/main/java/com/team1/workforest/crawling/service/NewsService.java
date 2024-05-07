package com.team1.workforest.crawling.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.PostConstruct;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import org.jsoup.nodes.Element;

import com.team1.workforest.crawling.vo.NewsVO;
import com.team1.workforest.dashboard.mapper.DashboardMapper;
import com.team1.workforest.dashboard.vo.DashboardVO;
import com.team1.workforest.employee.vo.EmployeeVO;

import lombok.extern.slf4j.Slf4j;
@Slf4j
@Service
public class NewsService {
	
	private static String News_URL= "https://news.naver.com/breakingnews/section/105/283";
	
	@Autowired
	DashboardMapper dashboardMapper;
	
	@PostConstruct
	public List<NewsVO> getNewsDatas()  throws IOException {
		
		List<NewsVO> newsList= new ArrayList<>();
		
		Document document= Jsoup.connect(News_URL).get();
		Elements contents = document.select("div.section_article._TEMPLATE");
		
		for (Element content : contents) {
			NewsVO news= NewsVO.builder() 
					.subject(content.select("strong.sa_text_strong").text()) // 제목
                    .url(content.select("a").attr("abs:href")) // 링크
                    .build();
			newsList.add(news);
		}
		//log.info("newsList:{}", newsList);
		return newsList;
	}

	//<div class="wf-box custom" draggable="true" data-aos="fade-up" data-aos-duration="1000" data-aos-delay="" data-order="1" data-drag="attend" id="d1">
	public DashboardVO getDashboard(EmployeeVO empVO) {
		return this.dashboardMapper.getDashboard(empVO);
	}
}
