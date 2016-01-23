<%@ page language="java" import="java.util.*" 
		 contentType="text/html; charset=utf-8"%>
<%@include file="uploadFileHelper.jsp"%>
<%request.setCharacterEncoding("utf-8");%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>UploadFile</title>
		</head>
	<body>
		<%
			SingleFileUpload upload = new SingleFileUpload();
			upload.parseRequest(request);
			File parent = new File("/home/");
			
			try {
				upload.upload(parent);
			} catch (Exception e) {
				e.printStackTrace();
			}
			//response.sendRedirect("homepage.jsp");
		%>
	</body>
</html>