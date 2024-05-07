package com.team1.workforest.approval.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.http.HttpRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.team1.workforest.approval.service.ApprovalService;
import com.team1.workforest.approval.vo.ApvBkmkVO;
import com.team1.workforest.approval.vo.ApvLineBkmkVO;
import com.team1.workforest.approval.vo.ApvLineVO;
import com.team1.workforest.approval.vo.ApvReferVO;
import com.team1.workforest.approval.vo.ApvVO;
import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.vo.CommonCodeVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/approval")
public class ApprovalController {
	
	@Autowired 
	ApprovalService approvalService;
	
	// 진행중인 내 결재(메인 대시보드)
	@ResponseBody
	@GetMapping("/getAllProgressMine")
	public List<ApvVO> getAllProgressMine(){
		List<ApvVO> list = approvalService.getAllProgressMine();
		return list;
	}	
	
	// 결재 메인 VIEW
	@GetMapping("/mainView")
	public String mainView(Model model){
		return "approval/main";
	}
	
	// 문서별 갯수 조회(메인)
	@ResponseBody
	@GetMapping("/mainView/totalCnt")
	public Map<String, Object> getTotalCnt(){
		Map<String, Object> totalCnt = approvalService.getTotalCnt();
		return totalCnt;
	}
	
	// 결재 진행 현황(메인)
	@ResponseBody
	@GetMapping("/mainView/allProgress")
	public List<ApvVO> getAllProgress(){
		List<ApvVO> progressList = approvalService.getAllProgress();
		return progressList;
	}
	
	// 결재 완료 목록(메인)
	@ResponseBody
	@GetMapping("/mainView/completed")
	public List<ApvVO> getCompletedOfMine(){
		List<ApvVO> getCompleted = approvalService.getCompletedOfMine();
		return getCompleted;
	}
	
	// 결재 대기 목록(메인)
	@ResponseBody
	@GetMapping("/mainView/pending")
	public List<ApvVO> getPendingOfMine(){
		List<ApvVO> getPending = approvalService.getPendingOfMine();
		return getPending;
	}
	
	// 결재 등록 VIEW
	@GetMapping("/createView")
	public String createView() {
		return "approval/create";
	}
	
	// 재기안 등록 VIEW
	@GetMapping("/reWriteView")
	public String reWriteView() {
		return "approval/reWrite";
	}
	
	// 재기안 데이터 조회
	@ResponseBody
	@GetMapping("/reWrite")
	public List<ApvVO> getDraft(@RequestParam int apvNo) {
		List<ApvVO> draftList = approvalService.getDraft(apvNo);
		return draftList;
	}
	
	// 결재(승인)
	@ResponseBody
	@PostMapping("/approval")
	public int approval(@RequestBody int apvNo) {
		int result = approvalService.approval(apvNo);
		return result;
	}

	// 기안 상신(파일포함)
	@ResponseBody
	@PostMapping("/create")
	public Map<String, Object> create(@RequestPart(value="files", required=false) MultipartFile[] files,
					  @RequestPart("data") Map<String, Object> apvMap,
					  @RequestPart(value="apvEtc", required=false) List<Map<String, Object>> apvEtc) {
		
		log.info("apvMap : {} ", apvMap);
//		int result = approvalService.create(files, apvMap, apvEtc);
		Map<String, Object> cntMap = approvalService.create(files, apvMap, apvEtc);
				
		return cntMap;
	}
	
	
	// 결재 상세 VIEW
	@GetMapping("/approvalDetailView")
	public String approvalDetailView(@RequestParam int apvNo, Model model) {
		
	    ApvVO apvVO = approvalService.approvalDetailView1(apvNo);
	    List<ApvLineVO> apvLineList = approvalService.approvalDetailView2(apvNo);
		List<ApvReferVO> apvReferVOList = approvalService.approvalDetailView3(apvNo);
		
		model.addAttribute("apvVO", apvVO);
		model.addAttribute("apvLineList", apvLineList);
		model.addAttribute("apvReferVOList", apvReferVOList);
		
		return "approval/detail";
	}
	
	// 결재 상세 - 내용 조회
	@ResponseBody
	@GetMapping("/approvalDetailView/{apvNo}")
	public Map<String, Object> approvalDetailView(@PathVariable int apvNo, ApvVO apvVo) {
		apvVo = approvalService.approvalDetailView1(apvNo);
	    List<ApvLineVO> apvLineList = approvalService.approvalDetailView2(apvNo);
		List<ApvReferVO> apvReferVOList = approvalService.approvalDetailView3(apvNo);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("apvVo", apvVo);
		map.put("apvLineList", apvLineList);
		map.put("apvReferVOList", apvReferVOList);
		
		return map;
	}
	
	// 결재라인 구분코드 조회
	@ResponseBody
	@GetMapping("/getCommonCode")
	public List<CommonCodeVO> getCommonCode(){
		List<CommonCodeVO> commonCodeList = approvalService.getCommonCode();
		return commonCodeList;
	}
	
	// 즐겨찾기 저장
	@ResponseBody
	@PostMapping("/createBkmk")
	public int createBkmk(@RequestBody Map<String, Object> bkmkMap) {
		int result = approvalService.createBkmk(bkmkMap);
		return result;
	}	
	
	// 즐겨찾기 목록 조회
	@ResponseBody
	@GetMapping("/getBkmkList")
	public List<ApvBkmkVO> getBkmkList() {
		List<ApvBkmkVO> getBkmkList = approvalService.getBkmkList();
		return getBkmkList;
	}
	
	// 즐겨찾기 상세 조회
	@ResponseBody
	@GetMapping("/getBkmkDetail")
	public List<ApvBkmkVO> getBkmkDetail(@RequestParam int bkmkNo) {
		List<ApvBkmkVO> apvBkmkDetail = approvalService.getBkmkDetail(bkmkNo);
		return apvBkmkDetail;
	}
	
	// 즐겨찾기 삭제
	@ResponseBody
	@DeleteMapping("/deleteBkmk")
	public int deleteBkmk(@RequestBody int bkmkNo) {
		int result = approvalService.deleteBkmk(bkmkNo);
		return result;
	}
	
	// 즐겨찾기 수정
	@ResponseBody
	@PutMapping("/updateBkmk")
	public int updateBkmk(@RequestBody ApvLineBkmkVO bkmkVO) {
		int result = approvalService.updateBkmk(bkmkVO);
		return result;
	}

	// 내 문서함 VIEW
	@GetMapping("/listView")
	public String listView() {
		return "approval/myList";
	}
	
	// 내 문서함 조회
	@ResponseBody
	@GetMapping("/listView/{tab}")
	public ResponseEntity<Object> getDocumentsByTab(
			@PathVariable String tab, 
			HttpServletRequest req) {
	    
	    int page = Integer.valueOf(req.getParameter("PAGE").toString());
	    int rowSize = Integer.valueOf(req.getParameter("ROWSIZE").toString());
	    
	    String searchType = req.getParameter("SEARCH_TYPE");
	    String searchValue = req.getParameter("SEARCH_VALUE");
	    
	    Map param = new HashMap<String, Object>();
	    param.put("PAGE", page);
	    param.put("ROWSIZE", rowSize);
	    param.put("SEARCH_TYPE", searchType);
	    param.put("SEARCH_VALUE", searchValue);
	    
	    Object documentList = null;
	    switch (tab) {
	        case "tab1":
	            documentList = approvalService.getPending(param);  // 대기
	            break;
	        case "tab2":
	        	documentList = approvalService.getProgress(param); // 진행
	        	break;
	        case "tab3":
	            documentList = approvalService.getCompleted(param);// 완료
	            break;
	        case "tab4":
	            documentList = approvalService.getRefused(param);  // 반려
	            break;
	        case "tab5":
	            documentList = approvalService.getDocReturn(param);// 회수
	            break;
	        case "tab6":
	            documentList = approvalService.getTemp(param);     // 임시저장함
	            break;
	        default:
	            return ResponseEntity.badRequest().build();
	    }

	    if (documentList == null) {
	        return ResponseEntity.notFound().build();
	    }

	    return ResponseEntity.ok(documentList);
	}
	
	// 부서문서함
	@ResponseBody
	@GetMapping("/deptListView/list")
	public ResponseEntity<Object> getDeptApv(HttpServletRequest req){
		Object documentList = null;
		
	    int page = Integer.valueOf(req.getParameter("PAGE").toString());
	    int rowSize = Integer.valueOf(req.getParameter("ROWSIZE").toString());
	    
	    String searchType = req.getParameter("SEARCH_TYPE");
	    String searchValue = req.getParameter("SEARCH_VALUE");
	    
	    Map param = new HashMap<String, Object>();
	    param.put("PAGE", page);
	    param.put("ROWSIZE", rowSize);
	    param.put("SEARCH_TYPE", searchType);
	    param.put("SEARCH_VALUE", searchValue);
		
	    documentList = approvalService.getDeptApv(param);
	
	    if (documentList == null) {
	        return ResponseEntity.notFound().build();
	    }

	    return ResponseEntity.ok(documentList);
	}
	
	// 부서문서함 (test용)
//	@ResponseBody
//	@GetMapping("/deptListView/list")
//	public List<ApvVO> getDeptApv(){
//		List<ApvVO> list = approvalService.getDeptApvTest();
//		return list;
//	}
	
	// 반려
	@ResponseBody
	@PutMapping("/refuse")
	public int refuse(@RequestBody int apvNo) {
		int result = approvalService.refuse(apvNo);
		return result;
	}
	
	// 회수
	@ResponseBody
	@PutMapping("/docReturn")
	public int docReturn(@RequestBody ApvLineVO apvLineVO) {
		int result = approvalService.docReturn(apvLineVO);
		return result;
	}
	
	// 회수 문서 삭제
	@ResponseBody
	@DeleteMapping("/deleteDraft")
	public int deleteDraft(@RequestBody int apvNo) {
		int result = approvalService.deleteDraft(apvNo);
		return result;
	}
	
	// 부서 문서함 VIEW
	@GetMapping("/deptListView")
	public String deptListView() {
		return "approval/deptList";
	}
	
	// 직원 목록 조회
	@ResponseBody
	@GetMapping("/getEmpList")	
	public List<Map<String, Object>> getEmpList(){
		List<Map<String, Object>> empMapList = approvalService.getEmpList();
		return empMapList;
	}
	
	// 서명 등록
	@ResponseBody
	@PostMapping("/signUpload")
	public int signUpload(@RequestPart("file") MultipartFile file) 
	        throws IOException {
	    int cnt = approvalService.signUpload(file);
	    return cnt;
	}
	
	// 서명 조회
	@ResponseBody
	@GetMapping("/getSign")	
	public EmployeeVO getSign(){
		EmployeeVO sign = approvalService.getSign();
		return sign;
	}

}
