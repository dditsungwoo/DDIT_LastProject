package com.team1.workforest.menu.service;

import java.util.List;

import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.vo.MenuVO;

public interface MenuService {

	public List<MenuVO> selectMenu();

	public int insertGlance(MenuVO vo);

	public List<MenuVO> selectGlance(MenuVO vo);

	public List<MenuVO> selectEmail(EmployeeVO vo);

}
