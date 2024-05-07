package com.team1.workforest.project.service;

import java.util.List;
import java.util.Map;

import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.project.vo.ProjectDutyReplyVO;
import com.team1.workforest.project.vo.ProjectDutyVO;

import com.team1.workforest.project.vo.ProjectVO;



public interface ProjectService {

	public int getTotal();

	public List<ProjectVO> getProjectList(Map<String, Object> map);

	public List<ProjectDutyVO> getProjectDuty(ProjectDutyVO vo);

	public int getProgress(ProjectDutyVO vo);

	public int updateProgress(ProjectDutyVO vo);

	public int addDuty(ProjectDutyVO vo);

	public int deleteDuties(ProjectDutyVO vo);

	public ProjectDutyVO getDutyModal(ProjectDutyVO vo);

	public ProjectDutyVO getNameByEmpNo(ProjectDutyVO vo);

	public List<EmployeeVO> findEmpByName(ProjectDutyVO vo);

	public int updateDuty(ProjectDutyVO vo);

	public int createProject(ProjectVO vo);

	public String getEmpNmByEmpNo(String empNo);
	
	public String getLeader(ProjectDutyVO vo);

	public List<ProjectDutyVO> getDutyModalForGantt(ProjectDutyVO vo);

	public List<ProjectVO> getMainGantt(ProjectDutyVO vo);

	public List<ProjectVO> allProjectProgress(ProjectVO vo);
	
	public List<ProjectVO> allProjectProgress2(ProjectVO vo);

	public List<ProjectVO> countProjectSttus(ProjectVO vo);

	public List<ProjectDutyVO> getEmpImage(ProjectDutyVO vo);

	public List<ProjectDutyVO> getEmployeePicture(ProjectDutyVO vo);

	public List<ProjectDutyVO> getOneEmployeePicture(ProjectDutyVO vo);

	public int doneProjectProgress(ProjectVO vo);

	public List<ProjectDutyReplyVO> getProjectDutyReply(Map<String, Object> map);

	public int insertReply(ProjectDutyReplyVO vo);

	public ProjectDutyReplyVO selectLastReply();

	public int deleteReply(ProjectDutyReplyVO vo);

	public int updateReply(ProjectDutyReplyVO vo);

	public ProjectVO getPrjctSttusForDashboard(ProjectVO vo);

	public int getStart(ProjectVO vo);


	public int updateLeader(ProjectVO vo);

	public ProjectVO isProjectDone(ProjectVO vo);

	public List<ProjectVO> getDoneProjectList(ProjectVO vo);

}
