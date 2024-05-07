package com.team1.workforest.admin.chart.service.serviceImpl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.map.HashedMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team1.workforest.admin.chart.mapper.AdminAttendanceMapper;
import com.team1.workforest.admin.chart.service.AdminAttendanceService;
import com.team1.workforest.attendance.mapper.AttendanceMapper;
import com.team1.workforest.attendance.vo.AttendanceManageVO;
import com.team1.workforest.chat.vo.MessageVO;
import com.team1.workforest.employee.vo.EmployeeVO;

@Service
public class AdminAttendanceServiceImpl implements AdminAttendanceService{
	
	@Autowired
	AdminAttendanceMapper adminAttendanceMapper;
	
	// 근태관리 기능에서 만들어둔 sql을 써서 근태관리 매퍼를 불러옴
	@Autowired
	AttendanceMapper attendanceMapper;
	
	@Override
	public List<EmployeeVO> getEmp(Map<String, String> map) {
		return this.adminAttendanceMapper.getEmp(map);
	}

	@Override
	public Map<String, String> getAvgRes(Map<String, String> map) {
		
		Map<String, String> result = new HashMap<String, String>();
		
		// 평균 출근시간
		String data1 = this.attendanceMapper.getAvgAttend(map);
		// 평균 퇴근시간
		String data2 = this.attendanceMapper.getAvgLeave(map);
		// 평균 근무시간
		String data3 = this.attendanceMapper.getAvgWork(map);
		// 연차 사용횟수
		String data4 = this.attendanceMapper.getRestCount(map);
		// 정상근무 횟수
		String data5 = this.attendanceMapper.getWorkCount(map);
		// 지각 횟수
		String data6 = this.attendanceMapper.getLateCount(map);
		// 외출 횟수
		String data7 = this.attendanceMapper.getOut1Count(map);
		// 조퇴 횟수
		String data8 = this.attendanceMapper.getOut2Count(map);
		// 결근 횟수
		String data9 = this.attendanceMapper.getOut3Count(map);
		
		result.put("avgAttend", data1);
		result.put("avgLeave", data2);
		result.put("avgWork", data3);
		result.put("restCount", data4);
		result.put("workCount", data5);
		result.put("lateCount", data6);
		result.put("out1", data7);
		result.put("out2", data8);
		result.put("out3", data9);
		
		return result;
	}

	@Override
	public List<AttendanceManageVO> getAttendanceList(Map<String, String> map) {
		List<AttendanceManageVO> dataList = this.attendanceMapper.getAttendanceList(map);
		
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		
		for(AttendanceManageVO vo:dataList) {
			if(vo.getAttendTime() != null) {
				Date date = vo.getAttendTime();
				String fAttend = formatter.format(date);
				vo.setFormatAttend(fAttend.split(" ")[1]);
			}else {
				vo.setFormatAttend("--:--");
			}
			if(vo.getLvffcTime() != null) {
				Date date2 = vo.getLvffcTime();
				String fLvffc = formatter.format(date2);
				vo.setFormatLvffc(fLvffc.split(" ")[1]);
			}else {
				vo.setFormatLvffc("--:--");
			}
			if(vo.getTotal() == null) {
				vo.setTotal("--");
			}
			
		}
		
		return dataList;
	}

	@Override
	public List<EmployeeVO> getEmpNo(Map<String, String> map) {
		return this.adminAttendanceMapper.getEmpNo(map);
	}

}
