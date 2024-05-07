package com.team1.workforest.myForm.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team1.workforest.myForm.mapper.MyFormMapper;
import com.team1.workforest.myForm.service.MyFormService;
import com.team1.workforest.myForm.vo.MyFormVO;
@Service
public class MyFormServiceImpl implements MyFormService {

	@Autowired
	MyFormMapper mFormMapper;
	
	@Override
	public List<MyFormVO> docList(MyFormVO mFormVO) {
		return this.mFormMapper.docList(mFormVO);
	}

	@Override
	public int updateDocStatus(MyFormVO mFormVO) {
		//여기서 docStatus가 3,4로 update할때 issueAcceptDate이거 insert
		return this.mFormMapper.updateDocStatus(mFormVO);
	}

	@Override
	public int addDoc(MyFormVO mFormVO) {
		return this.mFormMapper.addDoc(mFormVO);
	}

	@Override
	public String findDocNo() {
		return this.mFormMapper.findDocNo();
	}

	@Override
	public List<MyFormVO> getMyDocList(MyFormVO mFormVO) {
		return this.mFormMapper.getMyDocList(mFormVO);
	}

}
