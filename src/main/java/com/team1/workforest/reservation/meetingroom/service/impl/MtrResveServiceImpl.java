package com.team1.workforest.reservation.meetingroom.service.impl;

import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team1.workforest.common.mapper.CommonMapper;
import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.reservation.meetingroom.mapper.MtrResveMapper;
import com.team1.workforest.reservation.meetingroom.service.MtrResveService;
import com.team1.workforest.reservation.meetingroom.vo.MtrReservationVO;
import com.team1.workforest.reservation.meetingroom.vo.MtrVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class MtrResveServiceImpl implements MtrResveService{
	
	@Autowired
	MtrResveMapper mtrResveMapper;
	
	@Autowired
	CommonMapper commonMapper;
	
	@Override
	public JSONArray getMtrResveList(MtrReservationVO mtrReservationVO) {
		log.info("mtrReservationVO : {}", mtrReservationVO);

		List<MtrReservationVO> mtrResveList = mtrResveMapper.getMtrResveList(mtrReservationVO);

		JSONArray jsonArr = new JSONArray();

		for (MtrReservationVO mtrResve : mtrResveList) {
			String empNo = mtrResve.getEmpNo();
			EmployeeVO empVO = commonMapper.getEmpInfo(empNo);
			String empNm = empVO.getEmpNm();
			String position = empVO.getPosition();
			String rspnsblCtgryNm = empVO.getRspnsblCtgryNm();
			if(!rspnsblCtgryNm.equals("팀원")) {
				position = rspnsblCtgryNm;
			}
			String deptNm = empVO.getDeptNm();
			
			JSONObject jsonObj = new JSONObject();
			jsonObj.put("mtrResveNo", mtrResve.getMtrResveNo());
			jsonObj.put("mtrNo", mtrResve.getMtrNo());
			jsonObj.put("empNo", mtrResve.getEmpNo());
			jsonObj.put("start", mtrResve.getResveBeginDate());
			jsonObj.put("end", mtrResve.getResveEndDate());
			jsonObj.put("content", mtrResve.getResveCn());
			jsonObj.put("title", mtrResve.getMtrNm() + "(" + empNm + " " + position + ", " + deptNm + ")");
			
			jsonArr.add(jsonObj);
		}
		
		return jsonArr;
	}

	@Override
	public MtrReservationVO getMtrResve(String mtrResveNo) {
		return mtrResveMapper.getMtrResve(mtrResveNo);
	}
	
	@Override
	public List<MtrReservationVO> getMyMtrResve(String empNo) {
		return mtrResveMapper.getMyMtrResve(empNo);
	}
	
	@Override
	public List<MtrReservationVO> getMyPastMtrResve(String empNo) {
		return mtrResveMapper.getMyPastMtrResve(empNo);
	}

	@Override
	public int createMtrResve(MtrReservationVO mtrResveVO) {
		return mtrResveMapper.createMtrResve(mtrResveVO);
	}

	@Override
	public int updateMtrResve(MtrReservationVO mtrResveVO) {
		return mtrResveMapper.updateMtrResve(mtrResveVO);
	}

	@Override
	public int deleteMtrResve(String mtrResveNo) {
		return mtrResveMapper.deleteMtrResve(mtrResveNo);
	}

	@Override
	public MtrVO getMtrInfo(String mtrNo) {
		return mtrResveMapper.getMtrInfo(mtrNo);
	}

	@Override
	public List<MtrReservationVO> getMtrResvedTimes(Map<String, String> params) {
		return mtrResveMapper.getMtrResvedTimes(params);
	}

	@Override
	public List<MtrReservationVO> getTodayMtrResveList() {
		return mtrResveMapper.getTodayMtrResveList();
	}

	@Override
	public List<MtrVO> getMtrs() {
		return mtrResveMapper.getMtrs();
	}

}
