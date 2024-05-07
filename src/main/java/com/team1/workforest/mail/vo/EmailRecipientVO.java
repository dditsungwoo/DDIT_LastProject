package com.team1.workforest.mail.vo;

import java.util.Date;

import lombok.Data;

@Data
public class EmailRecipientVO {
	private String emailNo;
	private String empNo;
	private Date cnfirmDate;
	private Date delCd;
}
