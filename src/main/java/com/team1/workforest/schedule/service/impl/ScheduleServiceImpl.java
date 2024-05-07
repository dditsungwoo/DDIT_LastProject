package com.team1.workforest.schedule.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team1.workforest.common.mapper.CommonMapper;
import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.schedule.mapper.ScheduleMapper;
import com.team1.workforest.schedule.service.ScheduleService;
import com.team1.workforest.schedule.vo.ScheduleVO;

@Service
public class ScheduleServiceImpl implements ScheduleService{

	@Autowired
	ScheduleMapper scheduleMapper;
	
	@Autowired
	CommonMapper commonMapper;

	@Override
	public JSONArray getScheduleList(String empNo, List<String> chkSchs) {
		Map<String, String> params = new HashMap<String, String>();
		params.put("empNo", empNo);
		
		JSONArray jsonArr = new JSONArray();

		// 체크박스에 선택한 일정 찾은 후 데이터 가져와서 반환
		if (chkSchs != null) {
			// 내 일정 불러오기
			if (chkSchs.contains("mySch")) {
	        	String schType = "mySch";
	        	convertScheduleList(scheduleMapper.getMyScheduleList(params), schType, jsonArr);
	        }
			// 팀 일정 불러오기(팀 일정 + 팀원 개인 일정)
	        if (chkSchs.contains("teamSch")) {
	        	String schType = "teamSch";
	        	convertScheduleList(scheduleMapper.getTeamScheduleList(params), schType, jsonArr);
	        }
	        // 본부 일정 불러오기
	        if (chkSchs.contains("deptSch")) {
	        	String schType = "deptSch";
	        	convertScheduleList(scheduleMapper.getDeptScheduleList(params), schType, jsonArr);
	        }
	        // 회사 일정 불러오기
	        if (chkSchs.contains("compSch")) {
	        	String schType = "compSch";
	        	convertScheduleList(scheduleMapper.getCompScheduleList(params), schType, jsonArr);
	        }

		}
		
		return jsonArr;
	}
	
	@Override
	public ScheduleVO getSchedule(String schdulNo) {
		return scheduleMapper.getSchedule(schdulNo);
	}
	
	@Override
	public int createSchedule(ScheduleVO scheduleVO) {
		return scheduleMapper.createSchedule(scheduleVO);
	}

	@Override
	public int updateSchedule(ScheduleVO scheduleVO) {
		return scheduleMapper.updateSchedule(scheduleVO);
	}

	@Override
	public int deleteSchedule(String schdulNo) {
		return scheduleMapper.deleteSchedule(schdulNo);
	}
	
	@Override
	public JSONArray getTodayScheduleList(String empNo) {
		Map<String, String> params = new HashMap<String, String>();
		params.put("empNo", empNo);
		params.put("date", "1");		
		
		JSONArray jsonArr = new JSONArray();
		
		convertScheduleList(scheduleMapper.getMyScheduleList(params), "mySch", jsonArr);		
		convertScheduleList(scheduleMapper.getTeamScheduleList(params), "teamSch", jsonArr);
	    convertScheduleList(scheduleMapper.getDeptScheduleList(params), "deptSch", jsonArr);
	    convertScheduleList(scheduleMapper.getCompScheduleList(params), "compSch", jsonArr);   

		return jsonArr;
	}
	
	// 캘린더에 랜더링하기 위한 데이터로 포맷
	public void convertScheduleList(List<ScheduleVO> inputScheduleList, String schType, JSONArray jsonArr) {
        for (ScheduleVO schedule : inputScheduleList) {
        	String empNo = schedule.getEmpNo();
        	EmployeeVO empVO = commonMapper.getEmpInfo(empNo);
			String empNm = empVO.getEmpNm();
			String position = empVO.getPosition();
			String rspnsblCtgryNm = empVO.getRspnsblCtgryNm();
			if(!rspnsblCtgryNm.equals("팀원")) {
				position = rspnsblCtgryNm;
			}
			String deptNm = empVO.getDeptNm();
        	
            JSONObject jsonObj = new JSONObject();
            jsonObj.put("schNo", schedule.getSchdulNo());
            jsonObj.put("empNo", schedule.getEmpNo());
            jsonObj.put("empInfo", "(" + empNm + " " + position + ")");
            jsonObj.put("deptNo", schedule.getDeptNo());
            jsonObj.put("schSeCd", schedule.getSchdulSeCd());
            jsonObj.put("title", schedule.getSchdulSj());
            jsonObj.put("start", schedule.getSchdulBeginDate());
            jsonObj.put("end", schedule.getSchdulEndDate());
            jsonObj.put("location", schedule.getSchdulLoc());
            jsonObj.put("content", schedule.getSchdulCn());
            jsonObj.put("schType", schType);
            jsonObj.put("allDayCd", schedule.getAllDayCd());
            jsonArr.add(jsonObj);
        }
    }

	
}
