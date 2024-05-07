<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix ="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix ="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@ taglib prefix ="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix ="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fmt:requestEncoding value="utf-8"/>

<c:set var="_ctx" value="${pageContext.request.contextPath}" />
<c:set var="_aws" value="https://projectawsimg.s3.ap-northeast-2.amazonaws.com/img" />

<c:set var="_css" value="${_ctx}/resources/css" />
<c:set var="_img" value="${_ctx}/resources/img" />
<c:set var="_js" value="${_ctx}/resources/js" />
<c:set var="_script" value="${_ctx}/resources/script" />
