package com.team1.workforest.duty.mapper;

import java.util.List;
import java.util.Map;

import com.team1.workforest.duty.vo.DutyRecipientVO;
import com.team1.workforest.duty.vo.DutyVO;

public interface DutyMapper {

	public List<DutyVO> getDutyList(Map<String, Object> map);

	public List<DutyRecipientVO> getPieChart(DutyVO vo);

	public List<DutyVO> todayDoList(DutyVO vo);

	public int clickAndDone(DutyVO vo);

	public List<DutyVO> weekDoList(DutyVO vo);

	public DutyVO dutyDetail(DutyVO vo);

	public int detailPrgsUpdate(DutyVO vo);

	public List<DutyVO> senderChart1(DutyVO vo);

	public List<DutyVO> senderChart2(DutyVO vo);

	public List<DutyVO> senderChart3(DutyVO vo);

	public List<DutyVO> getDutyListForSender(Map<String, Object> map);

	public List<DutyVO> getDutyListCnfirmDate(Map<String, Object> map);

	public int updateCnfirmDate(DutyVO vo);

	public DutyVO senderDetail(DutyVO vo);

	public int insertDuty(DutyVO vo);

	public DutyVO selectLast();

	public int insertDutyRecipient(DutyRecipientVO rVo);

	public int deleteDuty(DutyVO vo);

	public int updateDuty(DutyVO vo);

	public int noRead(DutyVO vo);

	public int getDashTotal(DutyVO vo);

	public List<DutyVO> getDashDuty(DutyVO vo);

	
}
