package com.team1.workforest.vacation.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.team1.workforest.approval.vo.ApvLineVO;
import com.team1.workforest.approval.vo.ApvVO;
import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.vacation.mapper.VacationMapper;
import com.team1.workforest.vacation.service.VacationService;
import com.team1.workforest.vacation.util.VacationCategory;
import com.team1.workforest.vacation.vo.EmpVacationManageVO;
import com.team1.workforest.vacation.vo.VacationRecordVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class VacationServiceImpl implements VacationService {

	@Autowired
	VacationMapper vacationMapper;

	// 내 휴가 목록(잔여 휴가 개수) 가져오기
	@Override
	public List<EmpVacationManageVO> getMyVacationList(EmpVacationManageVO empVcatnManageVO) {
		return vacationMapper.getMyVacationList(empVcatnManageVO);

	}

	// 내 특정 휴가 정보 가져오기
	@Override
	public EmpVacationManageVO getMyVacation(EmpVacationManageVO empVcatnManageVO) {
		EmpVacationManageVO result = vacationMapper.getMyVacation(empVcatnManageVO);
		log.info("result : {}", result);
		return result;
	}

	// 결재 라인 불러오기
	@Override
	public List<EmployeeVO> getApvLine(String empNo, int apvLevel) {
		List<EmployeeVO> apvLines = new ArrayList<EmployeeVO>();

		EmployeeVO firstEmpVO = vacationMapper.getApvLine(empNo);
		apvLines.add(0, firstEmpVO);

		if (apvLevel == 2) {
			String supEmpNo = firstEmpVO.getEmpNo();

			EmployeeVO secondEmpVO = vacationMapper.getApvLine(supEmpNo);
			log.info("secondEmpVO : {}", secondEmpVO);
			apvLines.add(1, secondEmpVO);
		}
		return apvLines;
	}

	// 지난 휴가 가져오기
	@Override
	public Map<Integer, List<VacationRecordVO>> getMyVacationRecordList(VacationRecordVO vacationRecordVO) {
		List<VacationRecordVO> records = vacationMapper.getMyVacationRecordList(vacationRecordVO);
		log.info("records : {}", records);

		Map<Integer, List<VacationRecordVO>> recordGroups = new HashMap<>();
		for (VacationRecordVO record : records) {
			if (!recordGroups.containsKey(record.getApvNo())) {
				recordGroups.put(record.getApvNo(), new ArrayList<VacationRecordVO>());
			}
			recordGroups.get(record.getApvNo()).add(record);
		}
		return recordGroups;
	}

	// 사용 연차 카운트
	@Override
	public float getVacationRecordsCount(VacationRecordVO vacationRecordVO) {
		// 종일 연차 카운트
		int allDayCount = vacationMapper.getAllDayVacationRecordsCount(vacationRecordVO);
		// 반차 카운트
		float halfDayCount = vacationMapper.getHalfDayVacationRecordsCount(vacationRecordVO);

		float AllVacationRecordsCount = allDayCount + (halfDayCount / 2);
		log.info("count : {}", AllVacationRecordsCount);

		return AllVacationRecordsCount;
	}

	// 휴가 등록
	@Override
	public int createVacation(VacationRecordVO vacationRecordVO) {
		log.info("vacationRecordVO : {}", vacationRecordVO);
		
		String vcatnUseDate = vacationRecordVO.getVcatnUseDate();
		String[] vcatnUseDateArr = vcatnUseDate.split(",");
		
		String vcatnSeCd = vacationRecordVO.getVcatnSeCd();
		String[] vcatnSeCdArr = vcatnSeCd.split(",");
		
		String apvLine = vacationRecordVO.getApvLine();
		String[] apvLineArr = apvLine.split(","); 
		
		//log.info("vcatnUseDateArr : " + vcatnUseDateArr[0] + " : " + vcatnUseDateArr[1]);
		//log.info("vcatnSeCdArr : " + vcatnSeCdArr.length);  // Log -> Simple Log4j가 배열을 무시하는 듯
		
		// 휴가 종류	
		String categoryStr = "";
		VacationCategory category = VacationCategory.fromValue(vacationRecordVO.getVcatnCtgryNo());
		categoryStr = category.getDescription();
		
		// 휴가일수 계산
		float vcatnPeriod = 0;
		for(int i = 0 ; i < vcatnSeCdArr.length ; i++) {
			log.info("vcatnSeCd : {}", vcatnSeCdArr[i]);
			if(vcatnSeCdArr[i].equals("1")) {
				vcatnPeriod += 1;
			} else {
				vcatnPeriod += 0.5;
			}
		}
		
		if(vacationRecordVO.getVcatnCtgryNo().equals("1") && vcatnPeriod == 0.5 && vcatnSeCdArr[0].equals("2")) {
			categoryStr = "오전 반차";
		} else if(vacationRecordVO.getVcatnCtgryNo().equals("1") && vcatnPeriod == 0.5 && vcatnSeCdArr[0].equals("3")) {
			categoryStr = "오후 반차";
		}
		
		// 결재 내용 만들기
		StringBuffer sb = new StringBuffer();
		sb.append("휴가 종류 : ");
		sb.append(categoryStr+"\n\n");
		sb.append("휴가 사용일자 : ");
		sb.append(vcatnUseDateArr[0]);
		sb.append("~");
		sb.append(vcatnUseDateArr[vcatnUseDateArr.length-1]);
		sb.append("("+vcatnPeriod+"일)\n\n");
		sb.append("휴가 신청 내용 : ");
		sb.append(vacationRecordVO.getVcatnCn());
		
		String apvContent = sb.toString();
		
		// 결재 인서트
		ApvVO apv = new ApvVO();
		
		apv.setEmpNo(vacationRecordVO.getEmpNo());
		apv.setDocFormNo("1");
		apv.setSttusCd("Y");
		apv.setApvSj("휴가 신청");
		apv.setApvCn(apvContent);
		apv.setTmprStreYnCd("N");
		
		int result = vacationMapper.createApvForVacation(apv);
		
		// 기안자 결재 라인 인서트
		ApvLineVO apvLineMe = new ApvLineVO();
		apvLineMe.setApvEmpNo(vacationRecordVO.getEmpNo());
		apvLineMe.setApvSeCd("1");// 결재 구분 코드 삽입
		apvLineMe.setApvSttusCd("Y");// 결재 상태 코드 삽입
		apvLineMe.setApvLineSeq(1);// 결재 라인 순서 삽입
		
		result += vacationMapper.createApvLineForVacation(apvLineMe);

		
		// 결재 라인수 가져오기(1차 승인인지 2차 승인인지)
		int apvLineNum = apvLineArr.length;
		
		// 결재자 결재 라인 인서트
		if(apvLineNum == 1) {
			ApvLineVO apvLineVO = new ApvLineVO();
			apvLineVO.setApvEmpNo(apvLineArr[0]);
			apvLineVO.setApvSeCd("3"); // 결재 구분 코드 삽입
			apvLineVO.setApvSttusCd("0"); // 결재 상태 코드 삽입
			apvLineVO.setApvLineSeq(2); // 결재 라인 순서 삽입

			result += vacationMapper.createApvLineForVacation(apvLineVO);
		} else {
			for (int i = 0; i<apvLineArr.length; i++) {
				ApvLineVO apvLineVO = new ApvLineVO();
				apvLineVO.setApvEmpNo(apvLineArr[i]);
				apvLineVO.setApvSeCd(String.valueOf(i+2));// 결재 구분 코드 삽입
				apvLineVO.setApvSttusCd("0");// 결재 상태 코드 삽입
				apvLineVO.setApvLineSeq(i+2);// 결재 라인 순서 삽입
				
				result += vacationMapper.createApvLineForVacation(apvLineVO);
			}
		}
					
		// 휴가 사용 일자마다 insert
		for (int i = 0; i < vcatnUseDateArr.length; i++) {
			VacationRecordVO record = new VacationRecordVO();
			record.setVcatnUseDate(vcatnUseDateArr[i]);						// 사용일자
			record.setEmpNo(vacationRecordVO.getEmpNo());					// 사원번호
			record.setVcatnCtgryNo(vacationRecordVO.getVcatnCtgryNo());		// 휴가종류번호
			record.setGiveYear(vacationRecordVO.getGiveYear());				// 휴가지급연도
			record.setVcatnCn(vacationRecordVO.getVcatnCn());				// 휴가내용
			record.setVcatnSeCd(vcatnSeCdArr[i]);							// 휴가구분코드
			
			result += vacationMapper.createVacation(record);
		}
		
		
		
		return result;
	}

	// 휴가 삭제
	@Override
	public int deleteVacation(int apvNo) {
		// 삭제한 휴가가 결재 완료 됐는지 확인
		int check = vacationMapper.checkVcatnApvComplete(apvNo);
		
		// 결재 완료 됐으면 휴가 일수 업데이트
		if(check == 1) {
			List<VacationRecordVO> records = vacationMapper.getVcatn(apvNo);
			
			// 휴가수 계산
			float vcatnCnt = 0;
			for (int i = 0; i < records.size(); i++) {
				if (records.get(i).getVcatnSeCd().equals("1")) {
					vcatnCnt += 1;
				} else {
					vcatnCnt += 0.5;
				}
			}
			
			EmpVacationManageVO empVacationManageVO = new EmpVacationManageVO();
			empVacationManageVO.setGiveYear(records.get(0).getGiveYear());
			empVacationManageVO.setEmpNo(records.get(0).getEmpNo());
			empVacationManageVO.setVcatnCtgryNo(records.get(0).getVcatnCtgryNo());
			empVacationManageVO.setRemainCnt(vcatnCnt);
			
			vacationMapper.updateVcatnCountBack(empVacationManageVO);
		}
		
		// 휴가 삭제
		int result = vacationMapper.deleteVacation(apvNo);
				
		// 결재 삭제
		result += vacationMapper.deleteApvForVacation(apvNo);
		
		return result;
	}
	

}
