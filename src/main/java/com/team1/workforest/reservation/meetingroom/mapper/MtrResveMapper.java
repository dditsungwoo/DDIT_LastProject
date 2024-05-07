package com.team1.workforest.reservation.meetingroom.mapper;

import java.util.List;
import java.util.Map;

import com.team1.workforest.reservation.meetingroom.vo.MtrReservationVO;
import com.team1.workforest.reservation.meetingroom.vo.MtrVO;

public interface MtrResveMapper {

	public List<MtrReservationVO> getMtrResveList(MtrReservationVO mtrReservationVO);
	
	public MtrReservationVO getMtrResve(String mtrResveNo);
	
	public List<MtrReservationVO> getMyMtrResve(String empNo);

	public List<MtrReservationVO> getMyPastMtrResve(String empNo);
	
	public int createMtrResve(MtrReservationVO mtrResveVO);

	public int updateMtrResve(MtrReservationVO mtrResveVO);

	public int deleteMtrResve(String mtrResveNo);

	public MtrVO getMtrInfo(String mtrNo);

	public List<MtrReservationVO> getMtrResvedTimes(Map<String, String> params);

	public List<MtrReservationVO> getTodayMtrResveList();

	public List<MtrVO> getMtrs();

}
