package com.team1.workforest.mail.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.mail.vo.EmailRecipientVO;
import com.team1.workforest.mail.vo.EmailVO;
import com.team1.workforest.vo.AttachedFileVO;

public interface MailService {

	public List<EmailVO> getMailList(Map<String, Object> map);

	public int getTotal(Map<String, Object> map);

	public EmailVO getMailDetail(String emailNo);

	public int getMailCount(Map<String, Object> map);

	public int getSendMailCount(Map<String, Object> map);

	public List<EmailVO> getSendList(Map<String, Object> map);

	public int getNoreadCount(Map<String, Object> map);

	public int insertMail(MultipartFile[] files, EmailVO emailVO);

	public int temporaryMail(EmailRecipientVO emailRVO);

	public int getTemporaryMailCount(Map<String, Object> map);

	public List<EmailVO> getTemporaryList(Map<String, Object> map);

	public List<EmailVO> getUnreadList(Map<String, Object> map);

	public int insertTemporaryMail(EmailVO emailVO);

	public int putCnfirmDate(EmailVO emailVO);

	public List<EmailVO> getDeleteList(Map<String, Object> map);

	public int getDeleteCount(Map<String, Object> map);

	public int getAttachMailCount(Map<String, Object> map);

	public List<EmailVO> getAttachList(Map<String, Object> map);

	public int deleteGetMail(EmailVO demailVO);

	public EmailVO getSendMailDetail(String emailNo);

	public int deleteSendMail(EmailVO demailVO);

	public int hardDeleteMail(EmailVO demailVO);

	public List<AttachedFileVO> getattachedFiles(String atchmnflNo);

	public List<EmailVO> getDashboardList(Map<String, Object> map);

	public EmployeeVO getEmpEmail(String reEmpNo);

}
