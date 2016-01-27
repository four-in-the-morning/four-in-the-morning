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
			File parent = new File("/home/web/four-in-the-morning/ROOT/four-in-the-morning/homeworkUpload/");
			
			try {
				upload.upload(parent);
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			String detailIndex = request.getParameter("detailIndex");
			response.sendRedirect("homepage.jsp?submitsuccess=true&detailIndex=" + detailIndex);
		%>
	</body>
</html>