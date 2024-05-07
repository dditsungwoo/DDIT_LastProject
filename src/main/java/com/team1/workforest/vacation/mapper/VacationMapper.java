package com.team1.workforest.vacation.mapper;

import java.util.List;
import java.util.Map;

import com.team1.workforest.approval.vo.ApvLineVO;
import com.team1.workforest.approval.vo.ApvVO;
import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.vacation.vo.EmpVacationManageVO;
import com.team1.workforest.vacation.vo.VacationRecordVO;

public interface VacationMapper {

	public List<EmpVacationManageVO> getMyVacationList(EmpVacationManageVO empVcatnManageVO);

	public EmpVacationManageVO getMyVacation(EmpVacationManageVO empVcatnManageVO);
	
	public EmployeeVO getApvLine(String empNo);
	
	public List<VacationRecordVO> getMyVacationRecordList(VacationRecordVO vacationRecordVO);

	public int getAllDayVacationRecordsCount(VacationRecordVO vacationRecordVO);

	public int getHalfDayVacationRecordsCount(VacationRecordVO vacationRecordVO);

	public int createApvForVacation(ApvVO apv);

	public int createApvLineForVacation(ApvLineVO apvLineVO);

	public int createVacation(VacationRecordVO record);

	public int updateVcatnCount(EmpVacationManageVO empVacationManageVO);

	public int checkVcatnApvComplete(int apvNo);

	public List<VacationRecordVO> getVcatn(int apvNo);

	public int checkBusiTripApvComplete(int apvNo);

	public int deleteVacation(int apvNo);

	public int deleteApvForVacation(int apvNo);

	public void updateVcatnCountBack(EmpVacationManageVO empVacationManageVO);

	public int createAttendance(Map<String, String> map);

}
