package com.team1.workforest.admin.emp.controller;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.team1.workforest.employee.service.EmployeeService;
import com.team1.workforest.employee.vo.EmployeeVO;
import com.team1.workforest.vo.DepartmentVO;

import lombok.extern.slf4j.Slf4j;
import net.nurigo.java_sdk.api.Message;
import net.nurigo.java_sdk.exceptions.CoolsmsException;

@Slf4j
@Controller
public class MessageController {
	
	@Autowired
	EmployeeService empService;
	
	
	@ResponseBody
	 @PostMapping("/findCntcNo")
	 public List<EmployeeVO>findCntcNo(@RequestBody EmployeeVO empVO, RedirectAttributes redirectAttributes){
			List<EmployeeVO> list =this.empService.findCntcNo(empVO);
			log.info("findCntcNo =>"+list);
	        return list;
	 }
    
    String api_key = "NCSJJCPLCIASPJKX";
    String api_secret = "ABYI4ANTFIIY2O9B3FBDOWLMYCMASKL0";
    Message coolsms = new Message(api_key, api_secret);


    @GetMapping("/sendSMS")
    public String sendSMS() {
    	 return "admin/message";
    }
 
    
    @PostMapping("/sendSMSAfter")
    public String sendSMS(HttpServletRequest request, Model model) {
        HashMap<String, String> set = new HashMap<String, String>();
        log.info("to 들",request.getParameter("to"));
        set.put("from", "01036298937"); // 발신번호
        set.put("to", request.getParameter("to")); // 수신번호
       
       
        String baseMessage = "안녕하세요. WorkForest관리자입니다.\n";
        String additionalMessage = request.getParameter("text");
        String finalMessage = baseMessage + additionalMessage;
        set.put("text", finalMessage); //내용
        
        set.put("type", "sms"); // 문자 타입
        set.put("app_version", "test app 1.2"); 

        System.out.println(set);

        
		
		 try { 
			JSONObject result = coolsms.send(set); 
		 log.info("성공시: ",result);


		  
		 } catch (CoolsmsException e) { 
			// log.info(e.getMessage());
		//log.info(e.getCode()); 

		 }
		 
    
       return "redirect:/sendSMS";
    }
    
    
    
    
    
}
