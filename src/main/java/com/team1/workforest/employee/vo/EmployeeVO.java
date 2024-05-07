package com.team1.workforest.employee.vo;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class EmployeeVO { //사원
	private String empNo; //사원_번호
	private String deptNo; //부서_번호
	private String empNm; //사원_이름
	private String empPw; //비밀번호
	private String gender; //성별_코드
	private String email; //이메일
	private String lxtn; //내선_번호
	private String cntcNo; //개인연락처
	private String ecnyDate; //입사_일자
	private String zipCode; //우편번호
	private String basisAdres; //기본_주소
	private String detailAdres; //상세_주소
	private String bdate; //생년월일
	private String suprrEmpNo; //상급자_사번
	private String enabled; //활성화여부
	private String workSeCd; //재직_구분_코드
	private String workLocCd; //근무_위치_코드
	private String positionCd; //직급_코드
	private String rspnsblCd; //직책_코드
	private String retireDate; //퇴직일자
	private String proflImageUrl; //프로필_이미지_URL
	private String signImageUrl; //서명_이미지_URL

	//프로퍼티 추가
	private String  deptNm; //부서명
	private String rspnsblCtgryNm; //직책명
	private String position; //직급명
	private String workLocation; //근무위치지역명
	private String workSeCdNm; //재직구분코드명
	private String rnum;	
	
	private List<EmployeeAuthVO> empAuthVOList;
	
	private MultipartFile multipartFile;
	
	public EmployeeVO(String empNo, String empPw, String empNm) {
		this.empNo= empNo;
		this.empPw= empPw;
		this.empNm= empNm;
	}
	
	public EmployeeVO() {}
	

}
