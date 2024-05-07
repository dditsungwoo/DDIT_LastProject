package com.team1.workforest.myForm.service;

import java.util.List;

import com.team1.workforest.myForm.vo.MyFormVO;

public interface MyFormService {

	public List<MyFormVO> docList(MyFormVO mFormVO);

	public int updateDocStatus(MyFormVO mFormVO);

	public int addDoc(MyFormVO mFormVO);

	public String findDocNo();

	public List<MyFormVO> getMyDocList(MyFormVO mFormVO);

}
