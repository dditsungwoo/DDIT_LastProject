package com.team1.workforest.schedulerUtil.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class ChatHandler extends TextWebSocketHandler {
	public static List<WebSocketSession> list = new ArrayList<WebSocketSession>();
	
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		log.info("## 누군가 접속");
		list.add(session);
	}
	
	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		//String uMsg = message.getPayload();
		for (WebSocketSession webSocketSession : list) {
			webSocketSession.sendMessage(message);
		}
	}
	
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		log.info("## 누군가 떠남" + status);
		list.remove(session);
	}
	
	
}