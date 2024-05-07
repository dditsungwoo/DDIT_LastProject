package com.team1.workforest.crawling.vo;

import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@Getter
@Builder
@ToString
public class NewsVO {
	private String subject;
	private String url;
	
}
