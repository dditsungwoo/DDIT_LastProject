package com.team1.workforest.vacation.service;

import java.util.List;
import java.util.Map;

import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.vacation.vo.EmpVacationManageVO;
import com.team1.workforest.vacation.vo.VacationRecordVO;

public interface VacationService {

	public List<EmpVacationManageVO> getMyVacationList(EmpVacationManageVO empVcatnManageVO);

	public EmpVacationManageVO getMyVacation(EmpVacationManageVO empVcatnManageVO);
	
	public List<EmployeeVO> getApvLine(String empNo, int apvLevel);
	
	public Map<Integer, List<VacationRecordVO>> getMyVacationRecordList(VacationRecordVO vacationRecordVO);

	public float getVacationRecordsCount(VacationRecordVO vacationRecordVO);

	public int createVacation(VacationRecordVO vacationRecordVO);

	public int deleteVacation(int apvNo);


}
