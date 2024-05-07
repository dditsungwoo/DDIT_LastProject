package com.team1.workforest.schedulerUtil.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;

import com.team1.workforest.attendance.mapper.AttendanceMapper;
import com.team1.workforest.attendance.service.AttendanceService;
import com.team1.workforest.attendance.service.impl.AttendanceServiceImpl;
import com.team1.workforest.attendance.vo.AttendanceManageVO;
import com.team1.workforest.reservation.meetingroom.vo.MtrReservationVO;
import com.team1.workforest.schedulerUtil.service.MtrServiceImpl;
import com.team1.workforest.schedulerUtil.service.SchedulerService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
@EnableScheduling
public class Scheduler {
	
	@Autowired
	SchedulerService schedulerService;
	
	@Scheduled(cron = "0 30 9-18 * * *")
	public void mtrMsg() throws Exception {
		// 1시간마다 현재시간과 가장 가까운 시간대의 예약 vo를 받아와서 메세지에 예약자의 사원번호를 담아서 웹소켓메세지로 뿌린다.
		// 그러면 jsp에서 메세지 받았을때 기능으로 만들어둔 부분에서 사원번호가 메세지에 담긴 사원만 따로 기능을 만들면 알림을 해당사원만 보이게 할 수 있다.
		// 동시에 ajax로 알림테이블에 넣으면 끝
		List<String> mtrNoList = this.schedulerService.getMtr();
		List<WebSocketSession> list = ChatHandler.list;
		
		for(String mtrNo:mtrNoList) {
			
			MtrReservationVO vo = this.schedulerService.getMtrReservation(mtrNo);
			if(vo != null) {
				TextMessage message = new TextMessage(" :%" + vo.getEmpNo() + ":%신청하신 "+vo.getMtrLoc()+" 회의실 예약 시간까지 30분 남았습니다 :%mReserve");
				
				for (WebSocketSession webSocketSession : list) {
					webSocketSession.sendMessage(message);
				}
				
			}
			
		}
		
		
	}
	
	@Scheduled(cron = "0 0 18 * * *")
	public void lvffcMsg() throws Exception {
		List<WebSocketSession> list = ChatHandler.list;
		List<AttendanceManageVO> voList = this.schedulerService.getAttendanceList();
		log.error("voList:" + voList);
		String msg = "";
		for(AttendanceManageVO vo:voList) {
			log.error("empNo:" + vo.getEmpNo());
			int hour = vo.getLvffcLeft().intValue();
			log.error("hour:" + hour);
			Double minute = (vo.getLvffcLeft() - vo.getLvffcLeft().intValue()) * 60;
			log.error("minute:" + minute);
			int minuteInt = minute.intValue();
			log.error("minuteInt:" + minuteInt);
			
			if(vo.getLvffcLeft() <= 0) {
				msg = "오늘의 근무시간을 전부 채웠습니다. 꼭 퇴근qr 인식 후 퇴근해주세요.";
			}else {
				msg = "퇴근시간까지 " + hour + "시간 " + minuteInt + "분 남았습니다. 퇴근 시에는 꼭 퇴근qr 인식 후 퇴근해주세요.";
			}
			
			TextMessage message = new TextMessage(" :%" + vo.getEmpNo() + ":%" + msg + ":%lvffcMsg");
			
			for (WebSocketSession webSocketSession : list) {
				webSocketSession.sendMessage(message);
			}
				
		}
		
	}
	
	@Scheduled(cron = "0 30 9 * * *")
	public void attendMsg() throws Exception {
		List<WebSocketSession> list = ChatHandler.list;
		List<String> empNoList = this.schedulerService.getEmpList();
		String msg = "";
		for(String empNo:empNoList) {
			
			TextMessage message = new TextMessage(" :%" + empNo + ":% 출근체크! 잊지 마세요. :%attendMsg");
			
			for (WebSocketSession webSocketSession : list) {
				webSocketSession.sendMessage(message);
			}
				
		}
		
	}
	
	
	
	
	
	
}
