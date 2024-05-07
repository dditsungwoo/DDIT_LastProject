package com.team1.workforest.approval.service;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import com.team1.workforest.approval.vo.ApvBkmkVO;
import com.team1.workforest.approval.vo.ApvLineBkmkVO;
import com.team1.workforest.approval.vo.ApvLineVO;
import com.team1.workforest.approval.vo.ApvReferVO;
import com.team1.workforest.approval.vo.ApvVO;
import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.vo.CommonCodeVO;

public interface ApprovalService {
	
	// 진행중인 내 결재(메인 대시보드)
	public List<ApvVO> getAllProgressMine();
	
	// 문서별 갯수 조회
	public Map<String, Object> getTotalCnt();
	
	// 결재 진행 조회
	public List<ApvVO> getAllProgress();
	
	// 결재 완료 목록(메인)
	public List<ApvVO> getCompletedOfMine();
	
	// 결재 대기 목록(메인)
	public List<ApvVO> getPendingOfMine();
	
	// 재기안
	public List<ApvVO> getDraft(int apvNo);
	
	// 결재(승인)
	public int approval(int apvNo);
	
	// 기안 상신
	public Map<String, Object> create(MultipartFile[] files, Map<String, Object> apvMap, List<Map<String, Object>> apvEtc);
	
	// 결재 상세1
	public ApvVO approvalDetailView1(int apvNo);
	
	// 결재 상세2 (결재라인)
	public List<ApvLineVO> approvalDetailView2(int apvNo);

	// 결재 상세3 (참조인)
	public List<ApvReferVO> approvalDetailView3(int apvNo);
	
	// 결재라인 구분코드 조회
	public List<CommonCodeVO> getCommonCode();
	
	// 즐겨찾기 저장
	public int createBkmk(Map<String, Object> bkmkMap);

	// 즐겨찾기 목록 조회
	public List<ApvBkmkVO> getBkmkList();
	
	// 즐겨찾기 상세 조회
	public List<ApvBkmkVO> getBkmkDetail(int bkmkNo);

	// 즐겨찾기 삭제
	public int deleteBkmk(int bkmkNo);

	// 즐겨찾기 수정
	public int updateBkmk(ApvLineBkmkVO bkmkVO);
	
	// 결재 대기 목록 조회
	public Map<String, Object> getPending(Map param);
	
	// 결재 진행 목록 조회
	public Map<String, Object> getProgress(Map param);
	
	// 결재 완료 목록 조회
	public Map<String, Object> getCompleted(Map param);
	
	// 반려 목록 조회
	public Map<String, Object> getRefused(Map param);

	// 회수 목록 조회
	public Map<String, Object> getDocReturn(Map param);
	
	// 임시저장함 목록 조회
	public Map<String, Object> getTemp(Map param);
	
	// 반려 처리
	public int refuse(int apvNo);
	
	// 회수 처리
	public int docReturn(ApvLineVO apvLineVO);
	
	// 직원 목록 조회
	public List<Map<String, Object>> getEmpList();

	// 회수 문서 삭제
	public int deleteDraft(int apvNo);

	// 부서문서함
	public Map<String, Object> getDeptApv(Map param);

	// 부서문서함 test (test용)
//	public List<ApvVO> getDeptApvTest();

	// 서명 등록
	public int signUpload(MultipartFile file) throws IOException;

	// 서명 조회
	public EmployeeVO getSign();

}
