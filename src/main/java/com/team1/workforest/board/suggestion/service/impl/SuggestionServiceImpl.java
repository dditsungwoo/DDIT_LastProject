package com.team1.workforest.board.suggestion.service.impl;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.team1.workforest.board.suggestion.mapper.SuggestionMapper;
import com.team1.workforest.board.suggestion.service.SuggestionService;
import com.team1.workforest.board.suggestion.vo.SuggestionReplyVO;
import com.team1.workforest.board.suggestion.vo.SuggestionVO;
import com.team1.workforest.util.FileToAwsUtil;
import com.team1.workforest.vo.AttachedFileVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class SuggestionServiceImpl implements SuggestionService {

	@Autowired
	String uploadFolderDirect;

	@Autowired
	SuggestionMapper suggestMapper;

	// 전체의 행수
	@Override
	public int getTotal() {
		return this.suggestMapper.getTotal();
	}

	// 건의 게시판 목록
	@Override
	public List<SuggestionVO> list(Map<String, Object> map) {
		return this.suggestMapper.list(map);
	}

	// 조회수증가
	@Override
	public int suggestionView(String sugestBrdNo) {
		return this.suggestMapper.suggestionView(sugestBrdNo);
	}

	// 건의 게시판 상세 조회
	@Override
	public SuggestionVO detail(String sugestBrdNo) {
		return this.suggestMapper.detail(sugestBrdNo);
	}

	// 댓글 조회
	@Override
	public List<SuggestionReplyVO> suggestReplylist(SuggestionReplyVO vo) {
		
		// 댓글 개수
		
		log.info("vo ----> "+vo);
		
		
		
//		int ReplyNum = this.suggestMapper.suggestReplyNum(sugestBrdReNo);
		
		//log.info("ReplyNum -> "+ReplyNum);
		
		return this.suggestMapper.suggestReplylist(vo);
	}

	// 댓글 등록
	@Override
	public int SuggestionReplyInsert(SuggestionReplyVO vo) {
		return this.suggestMapper.SuggestionReplyInsert(vo);
	}

	// insert한 날짜 가져오기
	@Override
	public SuggestionReplyVO insertdate(SuggestionReplyVO vo) {
		return this.suggestMapper.insertdate(vo);
	}

	// 건의 게시판 삭제
	@Override
	public int deleteSuggestion(SuggestionVO vo) {
		return this.suggestMapper.deleteSuggestion(vo);
	}

	// 건의 게시판 댓글 입력 후 입력한 값 보여주기
	@Override
	public SuggestionReplyVO insertSuggestionReplyVO(SuggestionReplyVO vo) {
		return this.suggestMapper.insertSuggestionReplyVO(vo);
	}

	// 댓글 삭제
	@Override
	public int deleteSuggestionReplyVO(SuggestionReplyVO vo) {
		return this.suggestMapper.deleteSuggestionReplyVO(vo);
	}

	// 건의 게시판 등록
	@Transactional("txManager")
	@Override
	public int createSuggest(SuggestionVO suggestionVO) {
		int result = 0;
		int flag = 0;
		int attachmnflNo = 0;
		File uploadPath = new File(uploadFolderDirect, getFolder());

		// ATTACHMNFL_NO 최댓값
		attachmnflNo = Integer.parseInt(this.suggestMapper.attachmnflNo());
		attachmnflNo++;

		// 연월일 폴더 생성
		if (!uploadPath.exists()) {
			uploadPath.mkdirs();
		}

		String uploadFileName = "";
		long size = 0;

		MultipartFile[] uploadFile = suggestionVO.getUploadfile();
		log.info("uploadFile -> " + uploadFile.length);
		log.info("uploadFile -> " + uploadFile[0]);
		log.info("uploadFile -> " + uploadFile[0].getOriginalFilename());
		log.info("uploadFile -> " + uploadFile[0].getName());
		log.info("uploadFile -> " + uploadFile[0].getSize());
		String FileCheck = uploadFile[0].getOriginalFilename();
		// 파일 존재여부 확인
		if (!FileCheck.equals("") && !FileCheck.equals(null)) {
			// 원본 파일명이 있을 때만 파일 입력 처리
			log.info("파일이 있음");
			for (MultipartFile multipartFile : uploadFile) {
				String orginalFileName = multipartFile.getOriginalFilename();
				log.info("원본 파일명 : " + orginalFileName);
				log.info("파일 크기    : " + multipartFile.getSize());
				log.info("MIME타입  : " + multipartFile.getContentType());

				uploadFileName = multipartFile.getOriginalFilename();
				size = multipartFile.getSize(); // 파일 크기
				String mime = multipartFile.getContentType(); // mime타입
				String ext = orginalFileName.substring(orginalFileName.lastIndexOf("."));
				/*
				 * String ext = ""; int lastIndex = orginalFileName.lastIndexOf("."); if
				 * (lastIndex != -1) { ext = orginalFileName.substring(lastIndex); }
				 */

				UUID uuid = UUID.randomUUID();
				uploadFileName = uuid.toString() + "_" + ext;
				log.info("uploadFileName : " + uploadFileName);

				File saveFile = new File(uploadFolderDirect + File.separator +  uploadFileName);

				try {
					// 파일 복사 실행
					multipartFile.transferTo(saveFile);
					FileToAwsUtil.uploadToS3(saveFile);
					
					AttachedFileVO attachFileVO = new AttachedFileVO();
					attachFileVO.setAtchmnflSize(size);
					attachFileVO.setAtchmnflNm(uploadFileName);
					attachFileVO.setAtchmnflOriginNm(orginalFileName);
					attachFileVO.setAtchmnflUrl("/" + uploadFileName);
					log.info("attachmnflNo :" + attachmnflNo);

					attachFileVO.setAtchmnflNo(String.valueOf(attachmnflNo));

					log.info("attachFileVO : " + attachFileVO);

					// 파일 정보 데이터베이스에 저장
					result = this.suggestMapper.insertAttachedFile(attachFileVO);
					log.info("file result -> " + result);

					flag = 1;

				} catch (IllegalStateException | IOException e) {
					log.error("파일이 없음" + e.getMessage());
				}
			}
		}

		// 파일이 있을 경우에만 파일 정보를 설정한 후 suggestMapper.createSuggest 호출
		if (flag == 1) {
			log.info("File suggestionVO -> " + suggestionVO);
			result = this.suggestMapper.createSuggest(suggestionVO);
			return result;
		} else {
			log.info("NoFile suggestionVO -> " + suggestionVO);
			result = this.suggestMapper.createSuggestNoFile(suggestionVO); // 파일이 없는 경우 호출
			return result;
		}
	}

	// 건의 게시글 수정 (기존 파일이 있을 시)
	@Transactional("txManager")
	@Override
	public int upDateSuggest(SuggestionVO suggestionVO) {
		log.info("suggestionVO update - > "+suggestionVO);
		int result = 0;
		int flag = 0;
		int attachmnflNo = 0;
		File uploadPath = new File(uploadFolderDirect, getFolder());

		// ATTACHMNFL_NO 최댓값
		attachmnflNo = Integer.parseInt(this.suggestMapper.attachmnflNo());
		attachmnflNo++;
		
		log.info("attachmnflNo -> "+attachmnflNo);
		
		// 연월일 폴더 생성
		if (!uploadPath.exists()) {
			uploadPath.mkdirs();
		}

		String uploadFileName = "";
		long size = 0;

		MultipartFile[] uploadFile = suggestionVO.getUploadfile();
		log.info("uploadFile -> " + uploadFile.length);
		log.info("uploadFile -> " + uploadFile[0]);
		log.info("uploadFile -> " + uploadFile[0].getOriginalFilename());
		log.info("uploadFile -> " + uploadFile[0].getName());
		log.info("uploadFile -> " + uploadFile[0].getSize());
		String FileCheck = uploadFile[0].getOriginalFilename();
		// 파일 존재여부 확인
		if (!FileCheck.equals("") && !FileCheck.equals(null)) {
			// 원본 파일명이 있을 때만 파일 입력 처리
			log.info("파일이 있음");
			// 기존 파일이 없을 경우
			
			log.info("suggestionVO.getAtchmnflNo() -> "+suggestionVO.getAtchmnflNo());
			
			if(suggestionVO.getAtchmnflNo() == null || suggestionVO.getAtchmnflNo().isEmpty()) {
				log.info("기존 파일이 존재하지 않습니다. 그래서 조건문을 들어옵니다");
				suggestionVO.setAtchmnflNo(Integer.toString(attachmnflNo));
				log.info("새롭게 파일 번호번호를 부여합니다."+attachmnflNo);
			}
			
			
			
			// 기존에 있던 파일 번호로 추가
			attachmnflNo = Integer.parseInt(suggestionVO.getAtchmnflNo());
			log.info("attachmnflNo --> "+attachmnflNo);
			for (MultipartFile multipartFile : uploadFile) {
				String orginalFileName = multipartFile.getOriginalFilename();
				log.info("원본 파일명 : " + orginalFileName);
				log.info("파일 크기    : " + multipartFile.getSize());
				log.info("MIME타입  : " + multipartFile.getContentType());

				uploadFileName = multipartFile.getOriginalFilename();
				size = multipartFile.getSize(); // 파일 크기
				String mime = multipartFile.getContentType(); // mime타입
				String ext = orginalFileName.substring(orginalFileName.lastIndexOf("."));
				

				UUID uuid = UUID.randomUUID();
				uploadFileName = uuid.toString() + "_" + ext;
				log.info("uploadFileName : " + uploadFileName);

				File saveFile = new File(uploadFolderDirect + File.separator + uploadFileName);

				try {
					// 파일 복사 실행
					multipartFile.transferTo(saveFile);
					FileToAwsUtil.uploadToS3(saveFile);
					
					AttachedFileVO attachFileVO = new AttachedFileVO();
					attachFileVO.setAtchmnflSize(size);
					attachFileVO.setAtchmnflNm(uploadFileName);
					attachFileVO.setAtchmnflOriginNm(orginalFileName);
					attachFileVO.setAtchmnflUrl("/" + uploadFileName);
					log.info("attachmnflNo :" + attachmnflNo);

					attachFileVO.setAtchmnflNo(String.valueOf(attachmnflNo));

					log.info("attachFileVO : " + attachFileVO);

					// 파일 정보 데이터베이스에 저장
					result = this.suggestMapper.insertAttachedFile(attachFileVO);
					log.info("file result -> " + result);

					flag = 1;

				} catch (IllegalStateException | IOException e) {
					log.error("파일이 없음" + e.getMessage());
				}
			}
		}
		// 파일이 있을 경우에만 파일 정보를 설정한 후 suggestMapper.createSuggest 호출
		if (flag == 1) {
			log.info("파일이 있음");
			log.info("suggestionVO -> "+suggestionVO);
			return this.suggestMapper.updateSuggest(suggestionVO);
		} else

		{
			log.info("파일이 없음");
			return this.suggestMapper.updateNoFileSuggest(suggestionVO); // 파일이 없는 경우 호출
		}
	}

	// 연/월/일 폴더 생성
	public String getFolder() {
		// 2024-01-30 형식(format) 지정
		// 간단한 날짜 형식
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		// 날짜 객체 생성(java.util 패키지)
		Date date = new Date();
		// 2024-01-30
		String str = sdf.format(date);
		// 2024-01-30 -> 2024\\01\\30
		return str.replace("-", File.separator);
	}

	// 이미지인지 판단. 썸네일은 이미지만 가능하므로..
	public boolean checkImageType(File file) {
		// MIME(Multipurpose Internet Mail Extensions) : 문서, 파일 또는 바이트 집합의 성격과 형식. 표준화
		// MIME 타입 알아냄. .jpeg / .jpg의 MIME(ContentType)타입 : image/jpeg
		String contentType;
		try {
			contentType = Files.probeContentType(file.toPath());
			log.info("contentType : " + contentType);
			// image/jpeg는 image로 시작함->true
			return contentType.startsWith("image");
		} catch (IOException e) {
			e.printStackTrace();
		}
		// 이 파일이 이미지가 아닐 경우
		return false;
	}

	// 대댓글 리스트 출력
	@Override
	public List<SuggestionReplyVO> suggestionReplyReList(SuggestionReplyVO vo) {
		return this.suggestMapper.suggestionReplyReList(vo);
	}

	// 검색한 행의 수
	@Override
	public int getkeywordTotal(Map<String, Object> map) {
		return this.suggestMapper.getkeywordTotal(map);
	}
	
	
	// 게시판 파일 목록
	@Override
	public List<AttachedFileVO> sugestAtchList(String atchmnflNo) {
		return this.suggestMapper.sugestAtchList(atchmnflNo);
	}
	
	
	// 대댓글 등록
	@Override
	public int insertReplyRe(SuggestionReplyVO vo) {
		return this.suggestMapper.insertReplyRe(vo);
	}

	@Override
	public int suggestReplyNum(String sugestBrdReNo) {
		return this.suggestMapper.suggestReplyNum(sugestBrdReNo);
	}

	//detail.jsp에 대댓글 1행 추가
	@Override
	public SuggestionReplyVO getNewSuggestionReply(SuggestionReplyVO vo) {
		return this.suggestMapper.getNewSuggestionReply(vo);
	}
	
	// 댓글 수정
	@Override
	public int updateReSugest(SuggestionReplyVO vo) {
		return this.suggestMapper.updateReSugest(vo);
	}
	
	//대댓글 삭제
	@Override
	public int deleteReSugestReply(SuggestionReplyVO vo) {
		return this.suggestMapper.deleteReSugestReply(vo);
	}

	// 수정 시 해당 번호의 파일들 정보 얻기
	@Override
	public  List<AttachedFileVO> getSugestFiles(String atchmnflNo) {
		return this.suggestMapper.getSugestFiles(atchmnflNo);
	}

	
	//업데이트란에서 기존 파일 삭제
	@Override
	public int deleteUpdateFile(AttachedFileVO vo) {
		return this.suggestMapper.deleteUpdateFile(vo);
	}

	
	
	

}
