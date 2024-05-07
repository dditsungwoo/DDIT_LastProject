package com.team1.workforest.schedulerUtil.mapper;

import java.util.List;
import java.util.Map;

import com.team1.workforest.reservation.meetingroom.vo.MtrReservationVO;

public interface MtrMapper {

	public List<String> getMtr();

	public MtrReservationVO getMtrReservation(String mtrNo);


}
