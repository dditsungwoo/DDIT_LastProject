package com.team1.workforest.menu.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.menu.mapper.MenuMapper;
import com.team1.workforest.menu.service.MenuService;
import com.team1.workforest.vo.EmpUserSetupVO;
import com.team1.workforest.vo.GlanceVO;
import com.team1.workforest.vo.MenuVO;

@Service
public class MenuServiceImpl implements MenuService{
	@Autowired
	MenuMapper menuMapper;
	
	
	
	@Override
	public List<MenuVO> selectMenu() {

		return this.menuMapper.selectMenu();
	}



	@Override
	public int insertGlance(MenuVO vo) {
		String empNo= vo.getEmpNo();
		String glanNm= vo.getGlanNm();
		String[] menus= vo.getMenuNos();
		int result=0;
		
		List<EmpUserSetupVO> setupList= this.menuMapper.getEmployeeUserSetup(vo);
		if(setupList==null || setupList.size()==0) {
			result +=this.menuMapper.insertEmployeeUserSetup(vo);
		}
		
		List<GlanceVO> glist= this.menuMapper.findGlance(vo);
		if(glist != null ) {
			result+= this.menuMapper.deleteGlance(vo);			
		}	
		for(int i=0; i<menus.length; i++) {
			String menu=menus[i];
			MenuVO mvo= new MenuVO();
			mvo.setEmpNo(empNo);
			mvo.setGlanNm(glanNm);
			mvo.setMenuNo(menu);
			result+= this.menuMapper.insertGlance(mvo);			
		}		
		return result;
	}



	@Override
	public List<MenuVO> selectGlance(MenuVO vo) {
		return this.menuMapper.selectGlance(vo);
	}



	@Override
	public List<MenuVO> selectEmail(EmployeeVO vo) {
		return this.menuMapper.selectEmail(vo);
	}

}
