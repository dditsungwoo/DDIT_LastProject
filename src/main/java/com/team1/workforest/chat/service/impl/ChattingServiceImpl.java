package com.team1.workforest.chat.service.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team1.workforest.chat.mapper.ChattingMapper;
import com.team1.workforest.chat.service.ChattingService;
import com.team1.workforest.chat.vo.ChatRoomEmployeeVO;
import com.team1.workforest.chat.vo.ChatRoomVO;
import com.team1.workforest.chat.vo.MessageVO;
import com.team1.workforest.employee.vo.EmployeeVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ChattingServiceImpl implements ChattingService{

	@Autowired
	ChattingMapper chattingMapper;

	@Override
	public List<ChatRoomEmployeeVO> getChatRoom(Map<String, String> map) {
		return this.chattingMapper.getChatRoom(map);
	}

	@Override
	public List<MessageVO> getChat(Map<String, String> map) {
		List<MessageVO> msgVOList = this.chattingMapper.getChat(map);
		
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd hh:mm");
		
		for(MessageVO vo : msgVOList) {
			Date date = vo.getMssageDate();
			String fDate = formatter.format(date);
			vo.setFormatDate(fDate);
		}
		
		return msgVOList;
	}

	@Override
	public int addChat(Map<String, String> map) {
		
		
		return this.chattingMapper.addChat(map);
	}

	@Override
	public EmployeeVO getEmp(Map<String, String> map) {
		return this.chattingMapper.getEmp(map);
	}

	@Override
	public MessageVO getChatRoomLastChat(Map<String, String> map) {
		MessageVO vo = this.chattingMapper.getChatRoomLastChat(map);
		if(vo != null) {
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd_hh:mm");
			
			Date date = vo.getMssageDate();
			String fDate = formatter.format(date);
			vo.setFormatDate(fDate);
		}
		
		return vo;
	}

	@Override
	public List<EmployeeVO> getEmpList(Map<String, String> map) {
		return this.chattingMapper.getEmpList(map);
	}

	// 기존 채팅방에 사원 추가 및 새로운 채팅방 추가
	@Override
	public int addNewChatRoom(Map<String, String[]> map) {
		String[] empNoList = map.get("newEmpNoList");
		String[] empNmList = map.get("newEmpNmList");
		String[] chatRoomNoList = map.get("chatRoomNoList");
		
		String chatRoomNo = chatRoomNoList[0];
		
		String chatRoomNm = "";
		for(String empNm : empNmList) {
			chatRoomNm += empNm + ", ";
		}
		
		int res = 0;
		
		Map<String, String> map2 = new HashMap<String, String>();
		
		map2.put("chatRoomNo", chatRoomNo);
		
		// 기존 채팅방에 사원 추가시 파라미터로 받아온 채팅방번호, 새로운 채팅방일 시 채팅방 번호 생성
		if(chatRoomNo == "") {
			chatRoomNo = this.chattingMapper.getChatRoomNo();
			map2.put("chatRoomNo", chatRoomNo);
			map2.put("chatRoomNm", chatRoomNm);
			
			res+= this.chattingMapper.addNewChatRoom(map2);
		}
		
		
		
		for(String empNo : empNoList) {
			map2.put("empNo", empNo);
			res += this.chattingMapper.addNewChatRoomEmp(map2);
		}
		
		int chatRoomNoInt = Integer.parseInt(chatRoomNo);
		
		return chatRoomNoInt;
	}

	@Override
	public List<ChatRoomEmployeeVO> getChatRoomEmp(Map<String, String> map) {
		return this.chattingMapper.getChatRoomEmp(map);
	}

	@Override
	public int modChatRoomNm(Map<String, String> map) {
		return this.chattingMapper.modChatRoomNm(map);
	}
	
	@Override
	public int deleteChatRoom(Map<String, String> map) {
		return this.chattingMapper.deleteChatRoom(map);
	}

	@Override
	public List<ChatRoomVO> getAllChatRoom() {
		return this.chattingMapper.getAllChatRoom();
	}

	@Override
	public int modChatEmpDate(Map<String, String> map) {
		return this.chattingMapper.modChatEmpDate(map);
	}

	@Override
	public int getOverMsgCount(Map<String, String> map) {
		return this.chattingMapper.getOverMsgCount(map);
	}

}
