package com.team1.workforest.project.service.impl;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.project.mapper.ProjectMapper;
import com.team1.workforest.project.service.ProjectService;
import com.team1.workforest.project.vo.ProjectDutyReplyVO;
import com.team1.workforest.project.vo.ProjectDutyVO;
import com.team1.workforest.project.vo.ProjectEmployeeVO;

import com.team1.workforest.project.vo.ProjectVO;

@Service
public class ProjectServiceImpl implements ProjectService {

	@Autowired
	ProjectMapper projectMapper;

	@Override
	public int getTotal() {
		return this.projectMapper.getTotal();
	}

	@Override
	public List<ProjectVO> getProjectList(Map<String, Object> map) {		
		return this.projectMapper.getProjectList(map);
	}

	@Override
	public List<ProjectDutyVO> getProjectDuty(ProjectDutyVO vo) {
		return this.projectMapper.getProjectDuty(vo);
	}

	@Override
	public int getProgress(ProjectDutyVO vo) {
		return this.projectMapper.getProgress(vo);
	}

	@Override
	public int updateProgress(ProjectDutyVO vo) {
		return this.projectMapper.updateProgress(vo);
	}

	@Override
	public int addDuty(ProjectDutyVO vo) {
		
		String empNo= this.projectMapper.getLeader(vo);
		vo.setEmpNo(empNo);
		return this.projectMapper.addDuty(vo);
	}

	@Override
	public int deleteDuties(ProjectDutyVO vo) {
		return this.projectMapper.deleteDuties(vo);
	}

	@Override
	public ProjectDutyVO getDutyModal(ProjectDutyVO vo) {

		return this.projectMapper.getDutyModal(vo);
	}

	@Override
	public ProjectDutyVO getNameByEmpNo(ProjectDutyVO vo) {

		return this.projectMapper.getNameByEmpNo(vo);
	}

	@Override
	public List<EmployeeVO> findEmpByName(ProjectDutyVO vo) {
		
		return this.projectMapper.findEmpByName(vo);
	}

	@Override
	public int updateDuty(ProjectDutyVO vo) {

		return this.projectMapper.updateDuty(vo);
	}

	
	// 프로젝트 create메소드
	// projectEmployee도 동시에 insert
	@Override
	public int createProject(ProjectVO vo) {
		int res=0;
		res = this.projectMapper.createProject(vo);
		if (res>0) {
		ProjectVO lastVo= this.projectMapper.selectLast();
	
		String prjctNo= lastVo.getPrjctNo();
		String[] team= vo.getTeams();
		String leader =vo.getLeader();
		
		ProjectEmployeeVO leaderVO= new ProjectEmployeeVO();
		leaderVO.setEmpNo(leader);
		leaderVO.setPrjctEmpRole("1");
		leaderVO.setPrjctNo(prjctNo);
		String empNm= this.projectMapper.getEmpNmByEmpNo(leader);
		leaderVO.setEmpNm(empNm);
		res += this.projectMapper.createProjectEmployee(leaderVO);
		
		if(team !=null) {
			for(int i=0; i<team.length; i++) {
				ProjectEmployeeVO teamVO= new ProjectEmployeeVO();
				teamVO.setEmpNo(vo.getTeams()[i]);
				teamVO.setPrjctEmpRole("2");
				teamVO.setPrjctNo(prjctNo);
				empNm= this.projectMapper.getEmpNmByEmpNo(vo.getTeams()[i]);
				teamVO.setEmpNm(empNm);
				res += this.projectMapper.createProjectEmployee(teamVO);
			}
			
		}
		}
	
		return res;
	}

	@Override
	public String getEmpNmByEmpNo(String empNo) {
		return this.projectMapper.getEmpNmByEmpNo(empNo);
	}

	@Override
	public String getLeader(ProjectDutyVO vo) {
		return this.projectMapper.getLeader(vo);
	}

	@Override
	public List<ProjectDutyVO> getDutyModalForGantt(ProjectDutyVO vo) {
		return this.projectMapper.getDutyModalForGantt(vo);
	}

	@Override
	public List<ProjectVO> getMainGantt(ProjectDutyVO vo) {		
		return this.projectMapper.getMainGantt(vo);
	}

	@Override
	public List<ProjectVO> allProjectProgress(ProjectVO vo) {		
		return this.projectMapper.allProjectProgress(vo);
	}

	@Override
	public List<ProjectVO> countProjectSttus(ProjectVO vo) {
		return this.projectMapper.countProjectSttus(vo);
	}

	@Override
	public List<ProjectDutyVO> getEmpImage(ProjectDutyVO vo) {
		return this.projectMapper.getEmpImage(vo);
	}

	@Override
	public List<ProjectVO> allProjectProgress2(ProjectVO vo) {
		return this.projectMapper.allProjectProgress2(vo);
	}

	@Override
	public List<ProjectDutyVO> getEmployeePicture(ProjectDutyVO vo) {
		return this.projectMapper.getEmployeePicture(vo);
	}

	@Override
	public List<ProjectDutyVO> getOneEmployeePicture(ProjectDutyVO vo) {
		return this.projectMapper.getOneEmployeePicture(vo);
	}

	@Override
	public int doneProjectProgress(ProjectVO vo) {
		return this.projectMapper.doneProjectProgress(vo);
	}

	@Override
	public List<ProjectDutyReplyVO> getProjectDutyReply(Map<String, Object> map) {
		return this.projectMapper.getProjectDutyReply(map);
	}

	@Override
	public int insertReply(ProjectDutyReplyVO vo) {		
		return this.projectMapper.insertReply(vo);
	}

	@Override
	public ProjectDutyReplyVO selectLastReply() {
		return this.projectMapper.selectLastReply();
	}

	@Override
	public int deleteReply(ProjectDutyReplyVO vo) {
		return this.projectMapper.deleteReply(vo);
	}

	@Override
	public int updateReply(ProjectDutyReplyVO vo) {
		return this.projectMapper.updateReply(vo);
	}

	@Override
	public ProjectVO getPrjctSttusForDashboard(ProjectVO vo) {
		return this.projectMapper.getPrjctSttusForDashboard(vo);
	}

	@Override
	public int getStart(ProjectVO vo) {
		
		ProjectVO vo1= this.projectMapper.getStart(vo);
		int result=0;
		String sttus= vo1.getPrjctSttusCd();
		if(sttus.equals("1")) {		
		result= this.projectMapper.getStartUpdate(vo1);
		}
		return result;
	}

	@Override
	public int updateLeader(ProjectVO vo) {
		
		int result = this.projectMapper.updateLeaderFirst(vo);
		if (result >0) {
			result += this.projectMapper.updateLeaderLast(vo);
		}		
		return result;
	}

	@Override
	public ProjectVO isProjectDone(ProjectVO vo) {
		return this.projectMapper.isProjectDone(vo);
	}



	@Override
	public List<ProjectVO> getDoneProjectList(ProjectVO vo) {
		return this.projectMapper.getDoneProjectList(vo);
	}


	
	
}
