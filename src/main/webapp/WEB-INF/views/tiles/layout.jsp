<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/views/tiles/taglib.jsp"%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>WorkForest</title> 
  <tiles:insertAttribute name="resource" />
</head>
<script>
const _ctx = "${_ctx}";
$.ajaxSetup({
   beforeSend: (xhr) => {
      xhr.setRequestHeader("${_csrf.headerName}", "${_csrf.token}");
   },
   error: (arguments) => {
      console.log(arguments);
   },
   contentType: "application/json;charset=utf-8",
   dataType: 'json'
});
</script>
<body>
    <canvas id="gradient" width="1536" height="600" class="is-loaded"></canvas>

    <div class="main-container">
		<!-- -------------- header 시작 -------------- -->
		<tiles:insertAttribute name="header" />
		<!-- -------------- header 끝 -------------- -->
        <div class="content-wrap">
			
			<!-- -------------- left 시작 -------------- -->
			<tiles:insertAttribute name="left" />
			<!-- -------------- left 끝 -------------- -->
	
            <main class="custom">
            	<div class="wf-main-container">
					<!-- -------------- body 시작 -------------- -->
	               	<tiles:insertAttribute name="body" />
		            <!-- -------------- body 끝 -------------- -->
            	</div>
            </main>
        </div>
    </div>
</body>
</html>
