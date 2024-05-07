package com.team1.workforest.common;

public class LoggingAdvice {
	public void printLog() {
		System.out.println("[공통로그 - LoggingAdvice] 비즈니스 로직 수행 전 동작");
	}
	
	public void printLogging() {
		System.out.println("[공통로그 - LoggingAdvice] 비즈니스 로직 수행 후 동작");
	}
	
}
