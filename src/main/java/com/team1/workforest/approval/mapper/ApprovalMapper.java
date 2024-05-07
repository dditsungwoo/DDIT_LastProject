package com.team1.workforest.approval.mapper;

import java.util.List;
import java.util.Map;

import com.team1.workforest.approval.vo.ApvBkmkVO;
import com.team1.workforest.approval.vo.ApvLineBkmkVO;
import com.team1.workforest.approval.vo.ApvLineVO;
import com.team1.workforest.approval.vo.ApvReferVO;
import com.team1.workforest.approval.vo.ApvVO;
import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.vo.AttachedFileVO;
import com.team1.workforest.vo.CommonCodeVO;

public interface ApprovalMapper {
	
	// 진행중인 내 결재(메인 대시보드)
	public List<ApvVO> getAllProgressMine(String empNo);

	// 대기 문서 총 갯수
	public int getPendingCnt(String apvEmpNo);
	
	// 진행 문서 총 갯수
	public int getProgressCnt(String apvEmpNo);
	
	// 완료 문서 총 갯수
	public int getCompletedCnt(String apvEmpNo);
	
	// 반려 문서 총 갯수
	public int getRefusedCnt(String apvEmpNo);
	
	// 결재 진행 조회 (메인)
	public List<ApvVO> getAllProgress(String apvEmpNo);
	
	// 결재 완료 목록 조회 (메인)
	public List<ApvVO> getCompletedOfMine(String apvEmpNo);
	
	// 결재 대기 목록 조회 (메인)
	public List<ApvVO> getPendingOfMine(String apvEmpNo);
	
	// 재기안
	public List<ApvVO> getDraft(Map<String, Object> apvMap);
	
	// 결재(승인)
	public int approval(Map<String, Object> apvMap);
	
	// 기안 상신
	public int create(ApvVO apvVO);
	
	// 결재 상세1
	public ApvVO approvalDetailView1(int apvNo);
	
	// 결재 상세2 (결재라인)
	public List<ApvLineVO> approvalDetailView2(int apvNo);
	
	// 결재 상세3 (참조인)
	public List<ApvReferVO> approvalDetailView3(int apvNo);
	
	// 결재라인 구분코드 조회
	public List<CommonCodeVO> getCommonCode();
	
	// 결재라인 등록
	public int createApvLine(List<ApvLineVO> apvLineList);
	
	// 참조자 등록
	public int createRefer(List<ApvReferVO> apvReferList);

	// 즐겨찾기 저장
	public int createBkmk(Map<String, Object> bkmkMap);
	
	// 즐겨찾기 목록 조회
	public List<ApvBkmkVO> getBkmkList(Map<String, Object> map);
	
	// 즐겨찾기 상세 조회
	public List<ApvBkmkVO> getBkmkDetail(int bkmkNo);
	
	// 즐겨찾기 삭제
	public int deleteBkmk(int bkmkNo);
	
	// 즐겨찾기 수정
	public int updateBkmk(ApvLineBkmkVO bkmkVO);
	
	// 결재라인 조회
	public List<ApvLineVO> getApvLine(int apvNo);
	
	// 즐겨찾기 상세 저장
	public int createBkmkDetail(Map<String, Object> bkmkMap);

	// ===========================================
	// *** 페이지네이션 진행중  ***
	
	// 결재 대기 목록 갯수
	public int getPendingCnt(Map map);
	
	// 결재 대기 목록 조회
	public List<ApvVO> getPending(Map map);

	// 결재 진행 목록 갯수
	public int getProgressCnt(Map map);
	
	// 결재 진행 목록 조회
	public List<ApvVO> getProgress(Map map);
	
	// 결재 완료 목록 갯수
	public int getCompletedCnt(Map map);
	
	// 결재 완료 목록 조회
	public List<ApvVO> getCompleted(Map map);
	
	// 반려 목록 갯수
	public int getRefusedCnt(Map map);
	
	// 반려 목록 조회
	public List<ApvVO> getRefused(Map map);
	
	// 회수 목록 갯수
	public int getDocReturnCnt(Map map);
	
	// 회수 목록 조회
	public List<ApvVO> getDocReturn(Map map);
	
	// 부서 목록 갯수
	public int getDeptApvCnt(Map param);
	
	// 부서 목록 조회
	public List<ApvVO> getDeptApv(Map param);
	
	// 임시저장 목록 갯수
	public int getTempCnt(Map param);
	
	// 임시저장 목록 조회
	public List<ApvVO> getTemp(Map param);
	
	// ===========================================
	
	// 반려 목록 조회
	public List<ApvVO> getRefuseList(String empNo);
	
	// 회수 목록 조회
	public List<ApvVO> getDocReturn(String empNo);
	
	// 반려 처리
	public int refuse(Map<String, Object> apvMap);
	
	// 회수 처리
	public int docReturn(ApvLineVO apvLineVO);
	
	// 직원 목록 조회
	public List<Map<String, Object>> getEmpList();
	
	// 파일 첨부
	public int createAttachedFile(AttachedFileVO attachedFileVO);
	
	// 결재라인 조회 (결재 대기 상태)
	public List<ApvLineVO> getApvLinePending(String apvEmpNo);
	
	// 결재문서 반려
	public int updateApvRefuse(int apvNo);

	// 회수 문서 삭제
	public int deleteDraft(Map apvMap);

	// 서명등록
	public int signUpload(EmployeeVO empVo);

	// 서명조회
	public EmployeeVO getSign(EmployeeVO empVo);

}
