package com.team1.workforest.mail.service.impl;

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
import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.mail.mapper.EmailMapper;
import com.team1.workforest.mail.service.MailService;
import com.team1.workforest.mail.vo.EmailRecipientVO;
import com.team1.workforest.mail.vo.EmailVO;
import com.team1.workforest.util.FileToAwsUtil;
import com.team1.workforest.vo.AttachedFileVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class MailServiceImpl implements MailService {

	@Autowired
	String uploadPath;

	@Autowired
	EmailMapper emailMapper;
	
	@Autowired
	SuggestionMapper suggetionMapper;
	
	@Override
	public List<EmailVO> getMailList(Map<String, Object> map) {
		return this.emailMapper.getMailList(map);
	}

	@Override
	public int getTotal(Map<String, Object> map) {
		return this.emailMapper.getTotal(map);
	}

	@Override
	public EmailVO getMailDetail(String emailNo) {
		return this.emailMapper.getMailDetail(emailNo);
	}

	@Override
	public int getMailCount(Map<String, Object> map) {
		return this.emailMapper.getMailCount(map);
	}

	@Override
	public int getSendMailCount(Map<String, Object> map) {
		return this.emailMapper.getSendMailCount(map);
	}

	@Override
	public List<EmailVO> getSendList(Map<String, Object> map) {
		return this.emailMapper.getSendList(map);
	}

	@Override
	public int getNoreadCount(Map<String, Object> map) {
		return this.emailMapper.getNoreadCount(map);
	}

	@Override
	public int insertMail(MultipartFile[] files, EmailVO emailVO) {
		//파일처리
		File uploadPath = new File(this.uploadPath, getFolder());
		
		//경로 만들기
		if(!uploadPath.exists()) {
			uploadPath.mkdirs();
		}
		
		int result = 0;
		long size = 0;
		int seq = 1;
		String mime = "";
		String uploadFileName = "";
//		log.info("files : " + files);
		emailVO.setMultipartFile(files);
		
		MultipartFile[] uploadFile = emailVO.getMultipartFile();
//		log.info("uploadFile : "+ uploadFile);
//		log.info("uploadFile.length : "+ uploadFile.length);
			String FileCheck = uploadFile[0].getOriginalFilename();
//			log.info("filecheck : " + FileCheck);
			if(!FileCheck.equals("") && !FileCheck.equals(null)) {
				
				String atchmnflNo = this.suggetionMapper.attachmnflNo();
				int attachNo = (Integer.parseInt(atchmnflNo)+1);
				 
				emailVO.setAtchmnflNo(attachNo+"");
				result = this.emailMapper.insertMail(emailVO);
				
				for(MultipartFile multipartFile : uploadFile) {
					String orginalFileName = multipartFile.getOriginalFilename();
//					log.info("원본 파일명 : " + multipartFile.getOriginalFilename());
//					log.info("파일 크기    : " + multipartFile.getSize());
//					log.info("MIME타입  : " + multipartFile.getContentType());
					
					uploadFileName = multipartFile.getOriginalFilename();
					size = multipartFile.getSize();
					mime = multipartFile.getContentType();
					
					uploadFileName = UUID.randomUUID().toString() + "_" + uploadFileName;
					
					File saveFile = new File(uploadPath + "\\", uploadFileName);
					
					try {
						multipartFile.transferTo(saveFile);
						FileToAwsUtil.uploadToS3(saveFile);
						AttachedFileVO attachedFileVO = new AttachedFileVO();
						attachedFileVO.setAtchmnflOriginNm(orginalFileName);
						attachedFileVO.setAtchmnflNm(uploadFileName);
						attachedFileVO.setAtchmnflSize(size);
						attachedFileVO.setAtchmnflSeq(String.valueOf(seq++));
						attachedFileVO.setAtchmnflUrl(uploadFileName);
						
//						log.info("attachedFileVO : " + attachedFileVO);
						
						
						attachedFileVO.setAtchmnflNo(attachNo+"");
						result += this.emailMapper.insertAttachedFile(attachedFileVO);

						
					} catch (IllegalStateException | IOException e) {
						
					}
				}
				String[] list = emailVO.getEmailRVOList();		
				for(int i=0; i<list.length; i++) {
					EmailRecipientVO emailRecipientVO=new EmailRecipientVO();
					
					emailRecipientVO.setEmpNo(list[i]);
					result+=this.emailMapper.insertRMail(emailRecipientVO);
				}
			}
		else {
//			log.info("첨부파일이 없습니다.");
			emailVO.setAtchmnflNo(null);
			result = this.emailMapper.insertMail(emailVO);
			String[] list = emailVO.getEmailRVOList();		
			for(int i=0; i<list.length; i++) {
				EmailRecipientVO emailRecipientVO=new EmailRecipientVO();
				
				emailRecipientVO.setEmpNo(list[i]);
				result+=this.emailMapper.insertRMail(emailRecipientVO);
			}
		}
		
		return result;
	}

	
	@Override
	public int temporaryMail(EmailRecipientVO emailRVO) {
		return this.emailMapper.temporaryMail(emailRVO);
	}

	@Override
	public int getTemporaryMailCount(Map<String, Object> map) {
		return this.emailMapper.getTemporaryMailCount(map);
	}

	@Override
	public List<EmailVO> getTemporaryList(Map<String, Object> map) {
		return this.emailMapper.getTemporaryList(map);
	}

	@Override
	public List<EmailVO> getUnreadList(Map<String, Object> map) {
		return this.emailMapper.getUnreadList(map);
	}

	@Override
	public int insertTemporaryMail(EmailVO emailVO) {
		int result = this.emailMapper.insertTemporaryMail(emailVO);
		String[] list = emailVO.getEmailRVOList();
		for (int i = 0; i < list.length; i++) {
			EmailRecipientVO emailRecipientVO = new EmailRecipientVO();

			emailRecipientVO.setEmpNo(list[i]);
			result += this.emailMapper.insertTemporaryRMail(emailRecipientVO);
		}
		return result;
	}

	@Override
	public int putCnfirmDate(EmailVO emailVO) {
		return this.emailMapper.putCnfirmDate(emailVO);
	}

	@Override
	public List<EmailVO> getDeleteList(Map<String, Object> map) {
		return this.emailMapper.getDeleteList(map);
	}

	@Override
	public int getDeleteCount(Map<String, Object> map) {
		return this.emailMapper.getDeleteCount(map);
	}

	@Override
	public int getAttachMailCount(Map<String, Object> map) {
		return this.emailMapper.getAttachMailCount(map);
	}

	@Override
	public List<EmailVO> getAttachList(Map<String, Object> map) {
		return this.emailMapper.getAttachList(map);
	}

	@Override
	public int deleteGetMail(EmailVO demailVO) {
		return this.emailMapper.deleteGetMail(demailVO);
	}

	@Override
	public EmailVO getSendMailDetail(String emailNo) {
		return this.emailMapper.getSendMailDetail(emailNo);
	}

	@Override
	public int deleteSendMail(EmailVO demailVO) {
		return this.emailMapper.deleteSendMail(demailVO);
	}

	@Override
	public int hardDeleteMail(EmailVO demailVO) {
		return this.emailMapper.hardDeleteMail(demailVO);
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
//			log.info("contentType : " + contentType);
			// image/jpeg는 image로 시작함->true
			return contentType.startsWith("image");
		} catch (IOException e) {
			e.printStackTrace();
		}
		// 이 파일이 이미지가 아닐 경우
		return false;
	}

	@Override
	public List<AttachedFileVO> getattachedFiles(String atchmnflNo) {
		return this.emailMapper.getattachedFiles(atchmnflNo);
	}

	@Override
	public List<EmailVO> getDashboardList(Map<String, Object> map) {
		return this.emailMapper.getDashboardList(map);
	}

	@Override
	public EmployeeVO getEmpEmail(String reEmpNo) {
		return this.emailMapper.getEmpEmail(reEmpNo);
	}

}
