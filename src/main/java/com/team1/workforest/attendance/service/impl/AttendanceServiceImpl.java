package com.team1.workforest.attendance.service.impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team1.workforest.attendance.mapper.AttendanceMapper;
import com.team1.workforest.attendance.service.AttendanceService;
import com.team1.workforest.attendance.vo.AttendanceManageVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class AttendanceServiceImpl implements AttendanceService{

	@Autowired
	AttendanceMapper attendanceMapper;
	

	@Override
	public List<AttendanceManageVO> getAttendanceList(Map<String, String> map) {
		
		return this.attendanceMapper.getAttendanceList(map);
	}


	@Override
	public String getPlusTime(Map<String, String> map) {
		return this.attendanceMapper.getPlusTime(map);
	}


	@Override
	public String getMinusTime(Map<String, String> map) {
		return this.attendanceMapper.getMinusTime(map);
	}


	@Override
	public String getOverTime(Map<String, String> map) {
		return this.attendanceMapper.getOverTime(map);
	}


	@Override
	public String getAvgAttend(Map<String, String> map) {
		return this.attendanceMapper.getAvgAttend(map);
	}


	@Override
	public String getAvgLeave(Map<String, String> map) {
		return this.attendanceMapper.getAvgLeave(map);
	}


	@Override
	public String getAvgWork(Map<String, String> map) {
		return this.attendanceMapper.getAvgWork(map);
	}


	@Override
	public String getLateCount(Map<String, String> map) {
		return this.attendanceMapper.getLateCount(map);
	}


	@Override
	public String getRestCount(Map<String, String> map) {
		return this.attendanceMapper.getRestCount(map);
	}


	@Override
	public String getOut1Count(Map<String, String> map) {
		return this.attendanceMapper.getOut1Count(map);
	}


	@Override
	public String getOut2Count(Map<String, String> map) {
		return this.attendanceMapper.getOut2Count(map);
	}


	@Override
	public String getOut3Count(Map<String, String> map) {
		return this.attendanceMapper.getOut3Count(map);
	}


	@Override
	public int insertAttend(Map<String, String> map) {
		return this.attendanceMapper.insertAttend(map);
	}

	@Override
	public int insertLvffc(Map<String, String> map) {
		
		String restCd = this.attendanceMapper.getRestCd(map);
		String attend = this.attendanceMapper.getAttendMinute(map);
		String state = "1";
		
		Date date = new Date();
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		
		String current = formatter.format(date);
		current = current.split(" ")[1];
		
		int attendTime = Integer.parseInt(attend.split(":")[0]);
		int attendMinute = Integer.parseInt(attend.split(":")[1]);
		int attendTotal = attendTime * 60 + attendMinute;
		
		int currentTime = Integer.parseInt(current.split(":")[0]);
		int currentMinute = Integer.parseInt(current.split(":")[1]);
		int currentTotal = (currentTime * 60) + currentMinute;
		
		int total = currentTotal - attendTotal;
		log.info("restCd:" + restCd);
		log.info("current:" + current);
		log.info("currentTime:" + currentTime);
		log.info("currentMinute:" + currentMinute);
		log.info("currentTotal:" + currentTotal);
		log.info("attend:" + attend);
		log.info("attendTime:" + attendTime);
		log.info("attendMinute:" + attendMinute);
		log.info("attendTotal:" + attendTotal);
		
		if(restCd.equals("0")) {
			if(attendTotal > 570) {
				state = "2";
			}
			if(currentTotal < (17 * 60) + 30) {
				state = "3";
			}
			
			if(attendTotal > 570 && currentTotal < (17 * 60) + 30) {
				state = "6";
			}
			
		}else if(restCd.equals("1")) {
			state = "1";
		}else if(restCd.equals("2")) {
			if(attendTotal > ((14 * 60) + 30)) {
				state = "2";
			}else if(currentTotal < (17 * 60) + 30) {
				state = "3";
			}
			
			if(attendTotal > ((14 * 60) + 30) && currentTotal < (17 * 60) + 30) {
				state = "6";
			}
		}else if(restCd.equals("3")) {
			if(attendTotal > 570) {
				state = "2";
			}else if(currentTotal < (13 * 60) + 30) {
				state = "3";
			}
			
			if(attendTotal > 570 && currentTotal < (13 * 60) + 30) {
				state = "6";
			}
		}
		map.put("state", state);
		
		return this.attendanceMapper.insertLvffc(map);
	}

	@Override
	public String getAttendTime(Map<String, String> map) {
		return this.attendanceMapper.getAttendTime(map);
	}
	
	@Override
	public String getLvffcTime(Map<String, String> map) {
		return this.attendanceMapper.getLvffcTime(map);
	}


	@Override
	public String getTodayWorkTime(Map<String, String> map) {
		return this.attendanceMapper.getTodayWorkTime(map);
	}
	
	@Override
	public List<String> getWeekWorkTime(Map<String, String> map) {
		return this.attendanceMapper.getWeekWorkTime(map);
	}


	@Override
	public String getTodayRestUse(Map<String, String> map) {
		return this.attendanceMapper.getTodayRestUse(map);
	}


	@Override
	public List<String> getVcatnSeCd(Map<String, String> map) {
		return this.attendanceMapper.getVcatnSeCd(map);
	}





}
