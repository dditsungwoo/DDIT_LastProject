package com.team1.workforest.menu.vo;

import java.util.Date;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class S3GetResponseDto2 {
 
  
    private List<String> fileNames;
    private List<Long> fileSizes;
    private List<String> fileExtensions;
    private List<Date> dates;
    
    public static S3GetResponseDto2 searchfrom(List<String> fileNames, List<Long> fileSizes, List<String> fileExtensions, List<Date> dates) {
        return new S3GetResponseDto2(fileNames,fileSizes,fileExtensions,dates);
    }
    
    
 
   
    
    
}