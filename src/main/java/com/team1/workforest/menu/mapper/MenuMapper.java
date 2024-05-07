package com.team1.workforest.menu.mapper;

import java.util.List;

import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.vo.EmpUserSetupVO;
import com.team1.workforest.vo.GlanceVO;
import com.team1.workforest.vo.MenuVO;

public interface MenuMapper {

	public List<MenuVO> selectMenu();

	public List<GlanceVO> findGlance(MenuVO vo);

	public int insertGlance(MenuVO vo);
	
	public int deleteGlance(MenuVO vo);

	public List<MenuVO> selectGlance(MenuVO vo);

	public List<EmpUserSetupVO> getEmployeeUserSetup(MenuVO vo);

	public int insertEmployeeUserSetup(MenuVO vo);

	public List<MenuVO> selectEmail(EmployeeVO vo);

	

}
