package com.team1.workforest.chat.mapper;

import java.util.List;
import java.util.Map;

import com.team1.workforest.chat.vo.ChatRoomEmployeeVO;
import com.team1.workforest.chat.vo.ChatRoomVO;
import com.team1.workforest.chat.vo.MessageVO;
import com.team1.workforest.employee.vo.EmployeeVO;

public interface ChattingMapper {

	public List<ChatRoomEmployeeVO> getChatRoom(Map<String, String> map);

	public List<MessageVO> getChat(Map<String, String> map);

	public int addChat(Map<String, String> map);

	public EmployeeVO getEmp(Map<String, String> map);

	public MessageVO getChatRoomLastChat(Map<String, String> map);

	public List<EmployeeVO> getEmpList(Map<String, String> map);

	public int addNewChatRoom(Map<String, String> map);

	public String getChatRoomNo();

	public int addNewChatRoomEmp(Map<String, String> map2);

	public List<ChatRoomEmployeeVO> getChatRoomEmp(Map<String, String> map);

	public int modChatRoomNm(Map<String, String> map);

	public int deleteChatRoom(Map<String, String> map);

	public List<ChatRoomVO> getAllChatRoom();

	public int modChatEmpDate(Map<String, String> map);

	public int getOverMsgCount(Map<String, String> map);

}
