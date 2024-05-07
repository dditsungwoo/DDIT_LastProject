package com.team1.workforest.admin.chart.service.serviceImpl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team1.workforest.admin.chart.mapper.AdminDeptAttendanceMapper;
import com.team1.workforest.admin.chart.service.AdminDeptAttendanceService;
import com.team1.workforest.attendance.vo.AttendanceManageVO;
import com.team1.workforest.vo.DepartmentVO;

@Service
public class AdminDeptAttendanceServiceImpl implements AdminDeptAttendanceService{
	
	@Autowired
	AdminDeptAttendanceMapper adminDeptAttendanceMapper;

	@Override
	public List<DepartmentVO> getDept1() {
		return this.adminDeptAttendanceMapper.getDept1();
	}

	@Override
	public List<DepartmentVO> getDept2(DepartmentVO deptVo) {
		return this.adminDeptAttendanceMapper.getDept2(deptVo);
	}

	@Override
	public List<AttendanceManageVO> getDeptEmpAttendance(Map<String, String> map) {
		return this.adminDeptAttendanceMapper.getDeptEmpAttendance(map);
	}

	@Override
	public Map<String, String> getAvgRes(Map<String, String> map) {
		Map<String, String> result = new HashMap<String, String>();
		
		// 평균 출근시간
		String data1 = this.adminDeptAttendanceMapper.getAvgAttend(map);
		// 평균 퇴근시간
		String data2 = this.adminDeptAttendanceMapper.getAvgLeave(map);
		// 평균 근무시간
		String data3 = this.adminDeptAttendanceMapper.getAvgWork(map);
		// 연차 사용횟수
		String data4 = this.adminDeptAttendanceMapper.getRestCount(map);
		// 정상근무 횟수
		String data5 = this.adminDeptAttendanceMapper.getWorkCount(map);
		// 지각 횟수
		String data6 = this.adminDeptAttendanceMapper.getLateCount(map);
		// 외출 횟수
		String data7 = this.adminDeptAttendanceMapper.getOut1Count(map);
		// 조퇴 횟수
		String data8 = this.adminDeptAttendanceMapper.getOut2Count(map);
		// 결근 횟수
		String data9 = this.adminDeptAttendanceMapper.getOut3Count(map);
		
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

	
}
