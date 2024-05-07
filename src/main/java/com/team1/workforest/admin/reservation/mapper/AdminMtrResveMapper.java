package com.team1.workforest.admin.reservation.mapper;

import java.util.List;
import java.util.Map;

import com.team1.workforest.reservation.meetingroom.vo.MtrReservationVO;

public interface AdminMtrResveMapper {

	List<MtrReservationVO> adminGetMtrResveList(Map<String, String> params);

	List<MtrReservationVO> adminGetPastMtrResveList(Map<String, String> params);

}
