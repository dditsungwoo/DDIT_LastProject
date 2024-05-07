package com.team1.workforest.dashboard.service.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team1.workforest.dashboard.mapper.DashboardMapper;
import com.team1.workforest.dashboard.service.DashboardService;

@Service
public class DashboardServiceImpl implements DashboardService {

	@Autowired
	DashboardMapper dashboardMapper;
	
	@Override
	public int updateDashboard(Map<String, Object> map) {
		return this.dashboardMapper.updateDashboard(map);
	}

}
