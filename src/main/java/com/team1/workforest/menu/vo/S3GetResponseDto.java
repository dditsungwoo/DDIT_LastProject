package com.team1.workforest.menu.vo;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class S3GetResponseDto {
 
    private List<String> fileNames;
 
    
    public static S3GetResponseDto from(List<String> fileNames) {
        return new S3GetResponseDto(fileNames);
    }
    
    
 
   
    
    
}