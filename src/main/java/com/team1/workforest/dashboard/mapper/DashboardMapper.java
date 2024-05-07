package com.team1.workforest.dashboard.mapper;

import java.util.Map;

import com.team1.workforest.dashboard.vo.DashboardVO;
import com.team1.workforest.employee.vo.EmployeeVO;

public interface DashboardMapper {

	public int updateDashboard(Map<String, Object> map);

	//<div class="wf-box custom" draggable="true" data-aos="fade-up" data-aos-duration="1000" data-aos-delay="" data-order="1" data-drag="attend" id="d1">
	public DashboardVO getDashboard(EmployeeVO empVO);

}
