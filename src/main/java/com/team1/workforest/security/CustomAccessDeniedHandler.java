package com.team1.workforest.security;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.web.access.AccessDeniedHandler;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class CustomAccessDeniedHandler implements AccessDeniedHandler{
	@Override
	public void handle(HttpServletRequest request, HttpServletResponse response,
			org.springframework.security.access.AccessDeniedException accessDeniedException)
			throws IOException, ServletException {
			log.info(accessDeniedException.getMessage());
		
		response.sendRedirect("/accessError");
		
	}
	
	/*
	접근 권한에 따라 접근 불가능한 페이지에 접근한 경우,
	지정된 접근 거부 처리자(CustomAccessDeniedHander)에서  접근 거부 처리 페이지(/security/accessError)로 리다이렉트 시킴
	*/
	
}
