package com.team1.workforest.util;

import java.io.IOException;
import java.io.OutputStream;
import java.sql.*;
import javax.servlet.http.HttpServletResponse;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

@Controller
public class ExcelController {
	
	//비밀번호 암호화 의존성 주입
	@Autowired
	PasswordEncoder passwordEncoder;
    

    @GetMapping("/excel/empdownload")
    public void excelDownload(HttpServletResponse response) throws IOException, SQLException {
        String jdbcURL = "jdbc:oracle:thin:@112.220.114.130:1521:xe";
        String username = "team1_202309F";
        String password = "java";

        //출력 원하는 데이터의 쿼리문
        String query = "SELECT A.EMP_NO AS 사원번호, A.EMP_NM AS 사원명,  A.LXTN AS 내선번호, B.DEPT_NM AS 부서명, A.EMAIL AS 이메일주소," + 
                " C1.CMMN_CD_NM AS 직급, D.RSPNSBL_CTGRY_NM AS 직책, C2.CMMN_CD_NM AS 근무지" + 
                " FROM EMPLOYEE A" + 
                " JOIN DEPARTMENT B ON A.DEPT_NO = B.DEPT_NO" + 
                " JOIN COMMON_CODE C1 ON A.POSITION_CD = C1.CMMN_CD AND C1.CMMN_CD_GROUP = 'EMP002' " + 
                " JOIN COMMON_CODE C2 ON A.WORK_LOC_CD = C2.CMMN_CD AND C2.CMMN_CD_GROUP = 'EMP005' " + 
                " JOIN RESPONSIBILITY_CATEGORY D ON A.RSPNSBL_CD = D.RSPNSBL_CD " + 
                " WHERE C1.CMMN_CD_GROUP = 'EMP002' " + 
                " AND C2.CMMN_CD_GROUP = 'EMP005' ";

        Workbook wb = new XSSFWorkbook();
        Sheet sheet = wb.createSheet("직원 목록");
        Row row = null;
        Cell cell = null;
        int rowNum = 0;

        // 데이터베이스 연결
        try (Connection connection = DriverManager.getConnection(jdbcURL, username, password);
             Statement statement = connection.createStatement();
             ResultSet resultSet = statement.executeQuery(query)) {

            // Header
            row = sheet.createRow(rowNum++);
            ResultSetMetaData metaData = resultSet.getMetaData();
            int columnCount = metaData.getColumnCount();
            for (int i = 1; i <= columnCount; i++) {
                cell = row.createCell(i - 1);
                cell.setCellValue(metaData.getColumnName(i));
            }

            // Body
            while (resultSet.next()) {
                row = sheet.createRow(rowNum++);
                for (int i = 1; i <= columnCount; i++) {
                    cell = row.createCell(i - 1);
                    cell.setCellValue(resultSet.getString(i));
                }
            }
        }

        // 컨텐츠 타입과 파일명 지정
        response.setContentType("ms-vnd/excel");
        response.setHeader("Content-Disposition", "attachment;filename=emp_addressBook.xlsx");

        // Excel 파일 출력
        wb.write(response.getOutputStream());
        wb.close();
        
    }

    // 엑셀 파일 업로드 폼
    @GetMapping("/excel/empupload")
    public String showUploadForm() {
        return "admin/empList";
    }

    
 // 엑셀 파일 업로드 및 DB에 삽입
    @PostMapping("/excel/empupload")
    public String uploadExcelFile(@RequestParam("file") MultipartFile excelFile) {
        String jdbcURL = "jdbc:oracle:thin:@112.220.114.130:1521:xe";
        String username = "team1_202309F";
        String password = "java";

        try (Connection connection = DriverManager.getConnection(jdbcURL, username, password)) {
            Workbook workbook = new XSSFWorkbook(excelFile.getInputStream());
            Sheet sheet = workbook.getSheetAt(0); // 첫 번째 시트를 읽음

            for (Row row : sheet) {
                // 첫 번째 행은 헤더일 수 있으므로 스킵
                if (row.getRowNum() == 0) {
                    continue;
                }
                
                DataFormatter formatter = new DataFormatter();
                String empNo = formatter.formatCellValue(row.getCell(0));        // EMP_NO
                String deptNo = formatter.formatCellValue(row.getCell(1));       // DEPT_NO
                String empNm = formatter.formatCellValue(row.getCell(2));        // EMP_NM
                String empPw = formatter.formatCellValue(row.getCell(3));          // EMP_PW
                String encodedPwd= this.passwordEncoder.encode(empPw);
                String gender = formatter.formatCellValue(row.getCell(4)); // GENDER
                String email = formatter.formatCellValue(row.getCell(5));          // EMAIL
                String lxtn = formatter.formatCellValue(row.getCell(6));          // LXTN
                String cntcNo = formatter.formatCellValue(row.getCell(7));       // CNTC_NO
                String ecnyDate = formatter.formatCellValue(row.getCell(8));   // ECNY_DATE (문자열로 처리)
                String zipCode= formatter.formatCellValue(row.getCell(9)); //ZIP_CODE
                String basisAdres= formatter.formatCellValue(row.getCell(10)); //BASIS_ADRES
                String detailAdres= formatter.formatCellValue(row.getCell(11)); //DETAIL_ADRES
                String bdate = formatter.formatCellValue(row.getCell(12));      // BDATE (문자열로 처리)
                String suprrEmpNo = formatter.formatCellValue(row.getCell(13));    // SUPRR_EMP_NO
                String enabled =formatter.formatCellValue(row.getCell(14));      // ENABLED
                String workSeCd =formatter.formatCellValue(row.getCell(15));      // WORK_SE_CD
                String workLocCd = formatter.formatCellValue(row.getCell(16));      // WORK_LOC_CD
                String positionCd = formatter.formatCellValue(row.getCell(17));    // POSITION_CD
                String rspnsblCd = formatter.formatCellValue(row.getCell(18));     // RSPNSBL_CD

                
                String insertQuery = "INSERT INTO EMPLOYEE (EMP_NO, DEPT_NO, EMP_NM, EMP_PW, GENDER, EMAIL, LXTN, CNTC_NO, ECNY_DATE, ZIP_CODE, BASIS_ADRES, DETAIL_ADRES, BDATE, SUPRR_EMP_NO, ENABLED, WORK_SE_CD, WORK_LOC_CD, POSITION_CD, RSPNSBL_CD) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                
                try (PreparedStatement pstmt = connection.prepareStatement(insertQuery)) {
                	pstmt.setString(1, empNo);
                    pstmt.setString(2, deptNo);
                    pstmt.setString(3, empNm);
                    pstmt.setString(4, encodedPwd);
                    pstmt.setString(5, gender);
                    pstmt.setString(6, email);
                    pstmt.setString(7, lxtn);
                    pstmt.setString(8, cntcNo);
                    pstmt.setString(9, ecnyDate);
                    pstmt.setString(10, zipCode);
                    pstmt.setString(11, basisAdres);
                    pstmt.setString(12, detailAdres);
                    pstmt.setString(13, bdate);
                    pstmt.setString(14, suprrEmpNo);
                    pstmt.setString(15, enabled);
                    pstmt.setString(16, workSeCd);
                    pstmt.setString(17, workLocCd);
                    pstmt.setString(18, positionCd);
                    pstmt.setString(19, rspnsblCd);

                	pstmt.executeUpdate();
                	
                	// EMPLOYEE_AUTH 테이블에 데이터 삽입
                    String insertEmployeeAuthQuery = "INSERT INTO EMPLOYEE_AUTH (EMP_NO, AUTH) VALUES (?, ?)";
                    try (PreparedStatement authPstmt = connection.prepareStatement(insertEmployeeAuthQuery)) {
                        authPstmt.setString(1, empNo);  // EMP_NO
                        authPstmt.setString(2, "ROLE_MEMBER"); 
                        authPstmt.executeUpdate();
                    }
                }
            }
            workbook.close();
        } catch (IOException | SQLException e) {
            e.printStackTrace();
            // 예외 처리 코드 작성
            return "redirect:/error";
        }

        //성공 시
        return "redirect:/admin/list";
    }
  
    @GetMapping("/excel/empFormDownload")
    public void excelDownload2(HttpServletResponse response) throws IOException {
        Workbook wb = new XSSFWorkbook();
        Sheet sheet = wb.createSheet("직원 목록");
        Row row = sheet.createRow(0); 

        // 열 제목 설정
        String[] columnTitles = {"EMP_NO", "DEPT_NO", "EMP_NM", "EMP_PW", "GENDER", "EMAIL", "LXTN", "CNTC_NO", "ECNY_DATE", "ZIP_CODE", "BASIS_ADRES", "DETAIL_ADRES", "BDATE", "SUPRR_EMP_NO", "ENABLED", "WORK_SE_CD", "WORK_LOC_CD", "POSITION_CD", "RSPNSBL_CD"};

        for (int i = 0; i < columnTitles.length; i++) {
            Cell cell = row.createCell(i);
            cell.setCellValue(columnTitles[i]);
        }

        // 컨텐츠 타입과 파일명 지정
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        //response.setContentType("ms-vnd/excel");
        response.setHeader("Content-Disposition", "attachment;filename=empForm.xlsx");

        // Excel 파일 출력
        OutputStream outputStream = response.getOutputStream();
        wb.write(outputStream);
        outputStream.close();
        wb.close();
    }


   
}
