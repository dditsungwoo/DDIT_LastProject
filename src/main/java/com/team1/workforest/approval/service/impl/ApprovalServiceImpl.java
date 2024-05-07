package com.team1.workforest.approval.service.impl;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.team1.workforest.approval.mapper.ApprovalMapper;
import com.team1.workforest.approval.service.ApprovalService;
import com.team1.workforest.approval.vo.ApvBkmkVO;
import com.team1.workforest.approval.vo.ApvLineBkmkVO;
import com.team1.workforest.approval.vo.ApvLineVO;
import com.team1.workforest.approval.vo.ApvReferVO;
import com.team1.workforest.approval.vo.ApvVO;
import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.schedule.mapper.ScheduleMapper;
import com.team1.workforest.schedule.vo.ScheduleVO;
import com.team1.workforest.schedulerUtil.controller.ChatHandler;
import com.team1.workforest.util.FileToAwsUtil;
import com.team1.workforest.vacation.mapper.VacationMapper;
import com.team1.workforest.vacation.util.VacationCategory;
import com.team1.workforest.vacation.vo.EmpVacationManageVO;
import com.team1.workforest.vacation.vo.VacationRecordVO;
import com.team1.workforest.vo.AttachedFileVO;
import com.team1.workforest.vo.CommonCodeVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ApprovalServiceImpl implements ApprovalService {

	@Autowired
	String uploadPath;

	@Autowired
	private ApprovalMapper approvalMapper;

	@Autowired
	private HttpSession session;
	
	@Autowired
	VacationMapper vacationMapper;
	
	@Autowired
	ScheduleMapper scheduleMapper;

	// 진행중인 내 결재(메인 대시보드)
	@Override
	public List<ApvVO> getAllProgressMine() {
		String empNo = (String) session.getAttribute("empNo");
		List<ApvVO> list = approvalMapper.getAllProgressMine(empNo);
		return list;
	}
	
	// 문서별 갯수 조회
	@Override
	public Map<String, Object> getTotalCnt() {
		String apvEmpNo = (String) session.getAttribute("empNo");

		Map<String, Object> totalCntResult = new HashMap<String, Object>();

		int pendingCnt = approvalMapper.getPendingCnt(apvEmpNo);     // 대기
		int progressCnt = approvalMapper.getProgressCnt(apvEmpNo);   // 진행
		int completedCnt = approvalMapper.getCompletedCnt(apvEmpNo); // 완료
		int refusedCnt = approvalMapper.getRefusedCnt(apvEmpNo);     // 반려

		totalCntResult.put("pendingCnt", pendingCnt);
		totalCntResult.put("progressCnt", progressCnt);
		totalCntResult.put("completedCnt", completedCnt);
		totalCntResult.put("rejectedCnt", refusedCnt);

		return totalCntResult;
	}

	// 결재 진행 조회
	@Override
	public List<ApvVO> getAllProgress() {
		String apvEmpNo = (String) session.getAttribute("empNo");
		return approvalMapper.getAllProgress(apvEmpNo);
	}
	
	// 결재 대기 목록 (메인)
	@Override
	public List<ApvVO> getPendingOfMine() {
		String apvEmpNo = (String) session.getAttribute("empNo");
		return approvalMapper.getPendingOfMine(apvEmpNo);
	}
	
	// 재기안
	@Override
	public List<ApvVO> getDraft(int apvNo) {
		String empNo = (String) session.getAttribute("empNo");
		
		Map<String, Object> apvMap = new HashMap<String, Object>();
		apvMap.put("apvNo", apvNo);
		apvMap.put("empNo", empNo);
		
		return approvalMapper.getDraft(apvMap);
	}
	
	// 결재(승인)
	@Override
	public int approval(int apvNo) {
		String empNo = (String) session.getAttribute("empNo");

		if (empNo != null) {

			// 해당 결재에 대한 결재라인 조회
			List<ApvLineVO> apvLineVOList = approvalMapper.getApvLine(apvNo);

			Map<String, Object> apvMap = new HashMap<String, Object>();
			apvMap.put("apvNo", apvNo);
			
			// [현장] 시작
			int seqMe = 0;
			int seqNext = 0;
			String firstEmpNo = "";
			String nextEmpNo = "";
			
			// 자신의 결재 순서와 그 다음순서의 사원이 존재하는지 찾고 존재한다면 그사원에게 알람을 존재하지 않는다면 결재를 올렸던 사원에게 알람을 보냄
			for (ApvLineVO apvLine : apvLineVOList) {
				if(apvLine.getApvLineSeq() == 1) {
					firstEmpNo = apvLine.getApvEmpNo();
				}
				
				if(seqMe != 0) {
					seqNext = apvLine.getApvLineSeq();
					nextEmpNo = apvLine.getApvEmpNo();
				}

				if (apvLine != null && apvLine.getApvEmpNo() != null) {

					// 세션 사번과 결재자 사번 같은지 체크
					if (empNo.equals(apvLine.getApvEmpNo())) {
						seqMe = apvLine.getApvLineSeq();
					}
				}
			}
			log.info("seqMe:" + seqMe);
			log.info("seqNext:" + seqNext);
			log.info("firstEmpNo:" + firstEmpNo);
			log.info("nextEmpNo:" + nextEmpNo);
			
			// 웹소켓 알람 보내기
			List<WebSocketSession> list = ChatHandler.list;
			if(seqNext != 0 ) {
				TextMessage message = new TextMessage(" :%" + nextEmpNo + ":% 새로운 결재가 있습니다. :%approvalReceive");
				
				for (WebSocketSession webSocketSession : list) {
					try {
						webSocketSession.sendMessage(message);
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
			}else {
				TextMessage message = new TextMessage(" :%" + firstEmpNo + ":% 결재가 승인되었습니다. :%approvalResult");
				
				for (WebSocketSession webSocketSession : list) {
					try {
						webSocketSession.sendMessage(message);
					} catch (IOException e) {
						e.printStackTrace();
					}
				}
			}
			// [현장] 끝
			
			for (ApvLineVO apvLine : apvLineVOList) {
				
				if (apvLine != null && apvLine.getApvEmpNo() != null) {

					// 세션 사번과 결재자 사번 같은지 체크
					if (empNo.equals(apvLine.getApvEmpNo())) {
						
						// 현재 결재자가 승인 전 일 때
						if (("2".equals(apvLine.getApvSeCd()) || "3".equals(apvLine.getApvSeCd()))
								&& "0".equals(apvLine.getApvSttusCd())) {

							apvMap.put("apvLineSeq", apvLine.getApvLineSeq());

							int result = approvalMapper.approval(apvMap);
							
							// [연주]
							checkVcatnApvComplete(apvNo);
							checkBusiTripApvComplete(apvNo);
							
							return result;
						} else {
							return 0; // 승인 실패
						}
					}
				}
			}
		}

		// 결재자가 아닌 경우 또는 해당 결재의 결재라인이 없는 경우
		return 0;
	}

	// 기안 상신
	@Override
	public Map<String, Object> create(MultipartFile[] files, Map<String, Object> apvMap, List<Map<String, Object>> apvEtc) {

		Map<String, Object> cntMap = new HashMap<String, Object>();
		
		// JSON을 VO로 변환 ========================================
		ObjectMapper mapper = new ObjectMapper();

		ApvVO apvVO = mapper.convertValue(apvMap.get("apv"), ApvVO.class);
		apvVO.setMultipartFile(files);
		
		List<ApvLineVO> apvLineList = mapper.convertValue(apvMap.get("apvLine"), 
				new TypeReference<List<ApvLineVO>>() {
		});
		List<ApvReferVO> apvReferList = mapper.convertValue(apvMap.get("refer"),
				new TypeReference<List<ApvReferVO>>() {
		});

		apvEtc = mapper.convertValue(apvEtc, 
				new TypeReference<List<Map<String, Object>>>() {});

		try {
			//List<Map<String, Object>>를 JSON 문자열로 변환해서 vo에 저장
			apvVO.setApvEtc(mapper.writeValueAsString(apvEtc));
			
		} catch (JsonProcessingException e1) {
			e1.printStackTrace();
		}

		log.info("apvVo -> {} ", apvVO);
		log.info("apvLineList -> {} ", apvLineList);
		log.info("apvReferList -> {} ", apvReferList);

		// 파일 첨부 ===============================================

		MultipartFile[] uploadFile = apvVO.getMultipartFile();

		// 첨부파일이 있는경우
		if (uploadFile != null && uploadFile.length > 0) {
			int result = 0;
			long size = 0;
			int seq = 1;
			String mime = "";
			String originalFileName = "";
			String uploadFileName = "";
			
			String FileCheck = uploadFile[0].getOriginalFilename();

			if (!FileCheck.equals("") && !FileCheck.equals(null)) {
				for (MultipartFile multipartFile : uploadFile) {
					originalFileName = multipartFile.getOriginalFilename();
					log.debug("[create] originalFileName : {}", originalFileName);
					
					size = multipartFile.getSize();

					uploadFileName = UUID.randomUUID().toString() + "_" + originalFileName;
					
					// 업로드할 파일 경로
					String filePath = "C:\\upload\\" + uploadFileName;
					File newFile = new File(filePath);

					try {
						multipartFile.transferTo(newFile);
						FileToAwsUtil.uploadToS3(newFile);

						AttachedFileVO attachedFileVO = new AttachedFileVO();
						attachedFileVO.setAtchmnflOriginNm(originalFileName);
						attachedFileVO.setAtchmnflNm(uploadFileName);
						attachedFileVO.setAtchmnflSize(size);
						attachedFileVO.setAtchmnflSeq(String.valueOf(seq++));
						attachedFileVO.setAtchmnflUrl(uploadFileName);

						result = approvalMapper.createAttachedFile(attachedFileVO);

						apvVO.setAtchmnflNo(attachedFileVO.getAtchmnflNo());

					} catch (IllegalStateException | IOException e) {
						log.error(e.getMessage());
					}
				}
			}
		} else log.info("첨부 파일이 없습니다.");
		
		// 결재 등록  ===================================================
		String empNo = (String) session.getAttribute("empNo");

		if (empNo != null) {
			for (ApvLineVO apvLine : apvLineList) {
				
				//// [현장] 시작
				log.info("apvLine.getApvSeCd():" + apvLine.getApvSeCd());
				List<WebSocketSession> list = ChatHandler.list;
				if("2".equals(apvLine.getApvSeCd())) {
					log.info("apvLine.getApvEmpNo():" + apvLine.getApvEmpNo());
					TextMessage message = new TextMessage(" :%" + apvLine.getApvEmpNo() + ":% 새로운 결재가 있습니다. :%approvalResult");
					
					for (WebSocketSession webSocketSession : list) {
						try {
							webSocketSession.sendMessage(message);
						} catch (IOException e) {
							e.printStackTrace();
						}
					}
				}
				//// [현장] 끝
				
				
				if ("1".equals(apvLine.getApvSeCd())) {
					apvLine.setApvEmpNo(empNo);
					// 기안자 상태 변경
					apvLine.setApvSttusCd("Y");
				}
				else {
					apvLine.setApvSttusCd("0"); // 결재권자 '대기'상태로 
				}
			}

			// 기안 상신
			int cnt = approvalMapper.create(apvVO);
			log.debug("create -> apvVo(후) : {}", apvVO);
			
			// 결재라인 등록
			cnt += approvalMapper.createApvLine(apvLineList);
			
			// 참조자 등록
			if (apvReferList != null && !apvReferList.isEmpty()) {
				cnt += approvalMapper.createRefer(apvReferList);
			}
			
			if (cnt > 0) {
				int apvNo = apvVO.getApvNo();
				String tmprStreYnCd = apvVO.getTmprStreYnCd();
				
				cntMap.put("isOk", cnt);
				cntMap.put("apvNo", apvNo);
				cntMap.put("tmprStreYnCd", tmprStreYnCd);
				
				return cntMap;
			} else return cntMap;
		}

		// 결재자가 아닌 경우
		return cntMap;
	}

	// 결재 상세1
	@Override
	public ApvVO approvalDetailView1(int apvNo) {
		return approvalMapper.approvalDetailView1(apvNo);
	}

	// 결재 상세2 (결재라인)
	@Override
	public List<ApvLineVO> approvalDetailView2(int apvNo) {
		return approvalMapper.approvalDetailView2(apvNo);
	}

	// 결재 상세3 (참조인)
	@Override
	public List<ApvReferVO> approvalDetailView3(int apvNo) {
		return approvalMapper.approvalDetailView3(apvNo);
	}

	// 결재라인 구분코드 조회
	@Override
	public List<CommonCodeVO> getCommonCode() {
		return approvalMapper.getCommonCode();
	}

	// 즐겨찾기 저장
	@Override
	public int createBkmk(Map<String, Object> bkmkMap) {
		String empNo = (String) session.getAttribute("empNo");

		// 사원번호가 없을 경우
		if (empNo == null || empNo.isEmpty()) {
			throw new IllegalArgumentException("사원 번호 (empNo)는 null이거나 비어 있을 수 없습니다.");
		}

		bkmkMap.put("empNo", empNo);

		// 즐겨찾기 생성
		int cnt = approvalMapper.createBkmk(bkmkMap);

		// 즐겨찾기 상세 생성
		int detailCnt = approvalMapper.createBkmkDetail(bkmkMap);

		return detailCnt;
	}

	// 즐겨찾기 목록 조회
	@Override
	public List<ApvBkmkVO> getBkmkList() {
		String empNo = (String) session.getAttribute("empNo");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("empNo", empNo);
		return approvalMapper.getBkmkList(map);
	}

	// 즐겨찾기 상세 조회
	@Override
	public List<ApvBkmkVO> getBkmkDetail(int bkmkNo) {
		return approvalMapper.getBkmkDetail(bkmkNo);
	}

	// 즐겨찾기 삭제
	@Override
	public int deleteBkmk(int bkmkNo) {
		return approvalMapper.deleteBkmk(bkmkNo);
	}

	// 즐겨찾기 수정
	@Override
	public int updateBkmk(ApvLineBkmkVO bkmkVO) {
		return approvalMapper.updateBkmk(bkmkVO);
	}

	// 결재 대기 목록 조회
	@Override
	public Map<String, Object> getPending(Map param) {
		String apvEmpNo = (String) session.getAttribute("empNo");
		param.put("apvEmpNo", apvEmpNo);
		
		log.info("param : {} ", param);

		int cnt = approvalMapper.getPendingCnt(param);
		List<ApvVO> list = approvalMapper.getPending(param);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("PAGE", param.get("PAGE"));
		map.put("ROWSIZE", param.get("ROWSIZE"));
		map.put("ROWCOUNT", cnt);
		map.put("LIST", list);

		return map;
	}

	// 결재 진행 목록 조회
	@Override
	public Map<String, Object> getProgress(Map param) {
		String apvEmpNo = (String) session.getAttribute("empNo");
		param.put("apvEmpNo", apvEmpNo);
		
		log.info("param : {} ", param);

		int cnt = approvalMapper.getProgressCnt(param);
		List<ApvVO> list = approvalMapper.getProgress(param);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("PAGE", param.get("PAGE"));
		map.put("ROWSIZE", param.get("ROWSIZE"));
		map.put("ROWCOUNT", cnt);
		map.put("LIST", list);

		return map;
	}

	// 결재 완료 목록 조회
	@Override
	public List<ApvVO> getCompletedOfMine() {
		String apvEmpNo = (String) session.getAttribute("empNo");
		return approvalMapper.getCompletedOfMine(apvEmpNo);
	}

	// 결재 완료 목록 조회
	@Override
	public Map<String, Object> getCompleted(Map param) {
		String apvEmpNo = (String) session.getAttribute("empNo");
		param.put("apvEmpNo", apvEmpNo);
		
		int cnt = approvalMapper.getCompletedCnt(param);
		List<ApvVO> list = approvalMapper.getCompleted(param);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("PAGE", param.get("PAGE"));
		map.put("ROWSIZE", param.get("ROWSIZE"));
		map.put("ROWCOUNT", cnt);
		map.put("LIST", list);

		return map;
	}
	
	// 반려 목록 조회
	@Override
	public Map<String, Object> getRefused(Map param) {
		String empNo = (String) session.getAttribute("empNo");
		param.put("empNo", empNo);
		
		int cnt = approvalMapper.getRefusedCnt(param);
		List<ApvVO> list = approvalMapper.getRefused(param);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("PAGE", param.get("PAGE"));
		map.put("ROWSIZE", param.get("ROWSIZE"));
		map.put("ROWCOUNT", cnt);
		map.put("LIST", list);

		return map;
	}

	// 회수 목록 조회
	@Override
	public Map<String, Object> getDocReturn(Map param) {
		String empNo = (String) session.getAttribute("empNo");
		param.put("empNo", empNo);
		
		log.info("param : {} ", param);

		int cnt = approvalMapper.getDocReturnCnt(param);
		List<ApvVO> list = approvalMapper.getDocReturn(param);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("PAGE", param.get("PAGE"));
		map.put("ROWSIZE", param.get("ROWSIZE"));
		map.put("ROWCOUNT", cnt);
		map.put("LIST", list);

		return map;
	}
	
	// 회수 목록 조회
	@Override
	public Map<String, Object> getTemp(Map param) {
		String empNo = (String) session.getAttribute("empNo");
		param.put("empNo", empNo);
		
		log.info("param : {} ", param);

		int cnt = approvalMapper.getTempCnt(param);
		List<ApvVO> list = approvalMapper.getTemp(param);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("PAGE", param.get("PAGE"));
		map.put("ROWSIZE", param.get("ROWSIZE"));
		map.put("ROWCOUNT", cnt);
		map.put("LIST", list);

		return map;
	}
	

	// 반려
	@Override
	public int refuse(int apvNo) {
		String empNo = (String) session.getAttribute("empNo");

		if (empNo != null) {
			
			// 해당 결재에 대한 결재라인 조회
			List<ApvLineVO> apvLineVOList = approvalMapper.getApvLine(apvNo);

			Map<String, Object> apvMap = new HashMap<String, Object>();
			apvMap.put("apvNo", apvNo);
			
			//// [현장] 시작
			String firstEmpNo = "";
			// 결재를 올렸던 사원에게 알람을 보냄
			for (ApvLineVO apvLine : apvLineVOList) {
				if(apvLine.getApvLineSeq() == 1) {
					firstEmpNo = apvLine.getApvEmpNo();
					break;
				}
			}
			// 웹소켓 알람 보내기
			List<WebSocketSession> list = ChatHandler.list;
			TextMessage message = new TextMessage(" :%" + firstEmpNo + ":% 요청하신 결재가 반려되었습니다. :%approvalResult");
			
			for (WebSocketSession webSocketSession : list) {
				try {
					webSocketSession.sendMessage(message);
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			//// [현장] 끝

			for (ApvLineVO apvLine : apvLineVOList) {

				if (apvLine != null && apvLine.getApvEmpNo() != null) {

					// 세션 사번과 결재자 사번 같은지 체크
					if (empNo.equals(apvLine.getApvEmpNo())) {

						// 현재 결재자가 승인 전 일 때
						if (("2".equals(apvLine.getApvSeCd()) || "3".equals(apvLine.getApvSeCd()))
								&& "0".equals(apvLine.getApvSttusCd())) {

							// 넘길 파라미터
							apvMap.put("apvSeCd", apvLine.getApvSeCd());

							int cnt = approvalMapper.refuse(apvMap);

							// 반려됬으면 결재 상태 'N'으로 변경
							if (cnt > 0) {
								return approvalMapper.updateApvRefuse(apvNo);
							}

						} else {
							return 0; // 반려 실패
						}
					}
				}
			}
		}

		// 결재자가 아닌 경우 또는 해당 결재의 결재라인이 없는 경우
		return 0;
	}

	// 회수 처리
	@Override
	public int docReturn(ApvLineVO apvLineVO) {
		int apvNo = apvLineVO.getApvNo(); // 결재번호

		List<ApvLineVO> apvLineVOList = approvalMapper.getApvLine(apvNo);

		for (ApvLineVO apvLine : apvLineVOList) {

			// 다음 결재자 상태로 비교
			if ("2".equals(apvLine.getApvSeCd())) {
				// 현재 ApvLineSeq=2의 apvSttusCd=0일때 만 회수
				if ("0".equals(apvLine.getApvSttusCd())) {
					return approvalMapper.docReturn(apvLineVO);
				} else {
					// 회수 실패
					return 0;
				}
			}
		}
		return 0;
	}

	// 회수 문서 삭제
	@Override
	public int deleteDraft(int apvNo) {
		String empNo = (String) session.getAttribute("empNo");
		
		Map<String, Object> apvMap = new HashMap<String, Object>();
		apvMap.put("apvNo", apvNo);
		apvMap.put("empNo", empNo);
		
		return approvalMapper.deleteDraft(apvMap);
	}
	
	// 직원 목록 조회
	@Override
	public List<Map<String, Object>> getEmpList() {
		return approvalMapper.getEmpList();
	}

	// 부서문서함
	@Override
	public Map<String, Object> getDeptApv(Map param) {
		String empNo = (String) session.getAttribute("empNo");
		param.put("empNo", empNo);
		
		log.info("param : {} ", param);

		int cnt = approvalMapper.getDeptApvCnt(param);
		List<ApvVO> list = approvalMapper.getDeptApv(param);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("PAGE", param.get("PAGE"));
		map.put("ROWSIZE", param.get("ROWSIZE"));
		map.put("ROWCOUNT", cnt);
		map.put("LIST", list);
		
		return map;
	}
	
	// 서명 등록
	@Override
	public int signUpload(MultipartFile file) throws IOException {
		int result = 0;
		
		String saveName = file.getOriginalFilename();
		file.transferTo(new File("d:/team1/upload/" + saveName));
		String webURL = "/team1/upload/" + saveName;
         
        String empNo = (String) session.getAttribute("empNo");
        EmployeeVO empVo = new EmployeeVO();
        empVo.setSignImageUrl(webURL); // 파일 경로 설정
        empVo.setEmpNo(empNo);
        
        result = approvalMapper.signUpload(empVo);
		
	    return result;
	}
	
	// 서명 조회
	@Override
	public EmployeeVO getSign() {
		String empNo = (String) session.getAttribute("empNo");
	    EmployeeVO empVo = new EmployeeVO();
	    empVo.setEmpNo(empNo);
		return approvalMapper.getSign(empVo);
	}
	
	// [연주]
	// 휴가 신청서가 결재 완료 됐는지 확인하여 일정에 추가, 휴가에 따라 휴가 잔여수를 업데이트
	public void checkVcatnApvComplete(int apvNo) {
		int check = vacationMapper.checkVcatnApvComplete(apvNo);
		if (check == 1) {
			List<VacationRecordVO> records = vacationMapper.getVcatn(apvNo);
			
			// [현장] 
			// 웹소켓 알람 보내기
			List<WebSocketSession> list = ChatHandler.list;
			TextMessage message = new TextMessage(" :%" + records.get(0).getEmpNo() + ":% 신청한 휴가가 승인되었습니다. :%approvalReceive");
			
			for (WebSocketSession webSocketSession : list) {
				try {
					webSocketSession.sendMessage(message);
				} catch (IOException e) {
					e.printStackTrace();
				}
			}

			// 휴가수 계산
			float vcatnCnt = 0;
			for (int i = 0; i < records.size(); i++) {
				if (records.get(i).getVcatnSeCd().equals("1")) {
					vcatnCnt += 1;
					// [현장]
					// 연차 사용시 출퇴근목록에 insert
					Map<String,String> map = new HashMap<String, String>();
					map.put("empNo", records.get(i).getEmpNo());
					map.put("vcatnSeCd", records.get(i).getVcatnSeCd());
					map.put("attendTime", records.get(i).getVcatnUseDate() + " 09:00");
					map.put("lvffcTime", records.get(i).getVcatnUseDate() + " 18:00");
					vacationMapper.createAttendance(map);
				} else {
					vcatnCnt += 0.5;
				}
			}
			String beginDate = "";
			String endDate = "";
			String allDayCd = "";

			// 일정 구분
			// 1. 하루 이상의 종일 일정
			if (vcatnCnt % 1 == 0 && vcatnCnt >= 1) {
				beginDate = records.get(0).getVcatnUseDate();
				endDate = records.get(records.size() - 1).getVcatnUseDate();
				allDayCd = "1";
				// 2. 오후 반차 + 종일 연차
			} else if (vcatnCnt % 1 != 0 && vcatnCnt >= 1 && records.get(0).getVcatnSeCd().equals("3")) {
				beginDate = records.get(0).getVcatnUseDate() + " 14:00";
				endDate = records.get(records.size() - 1).getVcatnUseDate() + " 24:00";
				allDayCd = "0";
				// 3. 종일 연차 + 오전 반차
			} else if (vcatnCnt % 1 != 0 && vcatnCnt >= 1
					&& records.get(records.size() - 1).getVcatnSeCd().equals("2")) {
				beginDate = records.get(0).getVcatnUseDate();
				endDate = records.get(records.size() - 1).getVcatnUseDate() + " 14:00";
				allDayCd = "0";
				// 4. 오후 반차 + 종일 연차 + 오전 연차
			} else if (vcatnCnt % 1 == 0 && vcatnCnt >= 1 && records.get(0).getVcatnSeCd().equals("3")) {
				beginDate = records.get(0).getVcatnUseDate() + " 14:00";
				endDate = records.get(records.size() - 1).getVcatnUseDate() + " 14:00";
				allDayCd = "0";
				// 5. 오전 반차
			} else if (records.size() == 1 && records.get(0).getVcatnSeCd().equals("2")) {
				beginDate = records.get(0).getVcatnUseDate() + " 09:00";
				endDate = records.get(0).getVcatnUseDate() + " 14:00";
				allDayCd = "0";
				// 6. 오후 반차
			} else if (records.size() == 1 && records.get(0).getVcatnSeCd().equals("3")) {
				beginDate = records.get(0).getVcatnUseDate() + " 14:00";
				endDate = records.get(0).getVcatnUseDate() + " 18:00";
				allDayCd = "0";
			}

			// 휴가 종류
			String vcatnCategory = records.get(0).getVcatnCtgryNo();
			String categoryStr = "";
			VacationCategory category = VacationCategory.fromValue(vcatnCategory);
			categoryStr = category.getDescription();

			// 개인 일정에 추가
			ScheduleVO scheduleVO = new ScheduleVO();
			scheduleVO.setEmpNo(records.get(0).getEmpNo());
			scheduleVO.setSchdulSeCd("1");
			scheduleVO.setSchdulBeginDate(beginDate);
			scheduleVO.setSchdulEndDate(endDate);
			scheduleVO.setSchdulSj(categoryStr);
			scheduleVO.setAllDayCd(allDayCd);
			scheduleMapper.createSchedule(scheduleVO);
			

			// 휴가 잔여수를 업데이트 해야하는 휴가인지 판단
			if (vcatnCategory.equals("1") || vcatnCategory.equals("2") || vcatnCategory.equals("3")
					|| vcatnCategory.equals("4")) {
				EmpVacationManageVO empVacationManageVO = new EmpVacationManageVO();
				empVacationManageVO.setGiveYear(records.get(0).getGiveYear());
				empVacationManageVO.setEmpNo(records.get(0).getEmpNo());
				empVacationManageVO.setVcatnCtgryNo(vcatnCategory);
				empVacationManageVO.setRemainCnt(vcatnCnt);
				// 휴가 잔여수 업데이트
				vacationMapper.updateVcatnCount(empVacationManageVO);
			}
		}
	}

	// [연주]
	// 출장 신청서가 결재 완료 됐는지 확인하여 일정에 추가
	public void checkBusiTripApvComplete(int apvNo) {
		int check = vacationMapper.checkBusiTripApvComplete(apvNo);
		if (check == 1) {
			ApvVO apvVO = approvalMapper.approvalDetailView1(apvNo);
			String apvCn = apvVO.getApvEtc();
			log.info("apvCn : {}", apvCn);

			try {
		        ObjectMapper objectMapper = new ObjectMapper();
		        List<Map<String, Object>> jsonMapList = objectMapper.readValue(apvCn, new TypeReference<List<Map<String, Object>>>() {});
		        
		        String empId="";
		        String startDate="";
		        String endDate="";
		        String destination="";
		        
		        for (Map<String, Object> jsonMap : jsonMapList) {
		        	
		        	if(jsonMap.get("empId") != null) {
				        empId = (String) jsonMap.get("empId");		        		
		        	}
		        	if(jsonMap.get("startDate") != null) {
		        		startDate = (String) jsonMap.get("startDate");		        		
		        	}
		        	if(jsonMap.get("endDate") != null) {
		        		endDate = (String) jsonMap.get("endDate");		        		
		        	}
		        	if(jsonMap.get("destination") != null) {
		        		destination = (String) jsonMap.get("destination");		        		
		        	}
				}
		        
		        ScheduleVO scheduleVO = new ScheduleVO();
		        
		        scheduleVO.setEmpNo(empId);
		        scheduleVO.setSchdulSeCd("1");
		        scheduleVO.setSchdulBeginDate(startDate);
		        scheduleVO.setSchdulEndDate(endDate);
		        scheduleVO.setSchdulSj("출장");
		        scheduleVO.setAllDayCd("1");
		        scheduleVO.setSchdulLoc(destination);
		        
		        log.info("vo : {}", scheduleVO);
		        
		        scheduleMapper.createSchedule(scheduleVO);

		    } catch (Exception e) {
		        e.printStackTrace();
		        // 예외 처리 필요
		    }
		}

	}

	
	
	// 연/월/일 폴더 생성
	public String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String str = sdf.format(date);
		// 2024-01-30 -> 2024\\01\\30
		return str.replace("-", File.separator);
	}

}
