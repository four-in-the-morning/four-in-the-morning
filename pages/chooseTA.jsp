<%@ page language="java" 
	import="java.util.*,java.text.SimpleDateFormat,java.util.Date"
	contentType="text/html; charset=utf-8"%>
<% request.setCharacterEncoding("utf-8"); %>
<%@ include file="MySQLHelper.jsp"%>

<%
	String userId = (String) session.getAttribute("userId");
	if (userId == null) {
		out.print("Please Login first");
		response.sendRedirect("index.jsp");
	}
%>

<%
	String method = request.getMethod();
	String course_id = "";
	String course_name = "";
	String class_id = "";
	String ta_id = "";
	String hintToUser = "";
	if (method.equals("POST")) {
		course_id = request.getParameter("course_id");
		course_name = request.getParameter("course_name");
		class_id = request.getParameter("class_id");
		ta_id = request.getParameter("ta_id");
		if(MySQLHelper.chooseTA(course_id, course_name, class_id, ta_id)) {
			hintToUser = "成功指定课程TA";
		}
	}
%>

<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="css/main.css">
<link rel="stylesheet" type="text/css" href="css/chooseTA.css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>指定课程TA</title>
</head>
<body>
	<div id="header">
		<span id="siteName">凌晨四点</span>
		<span id="jumpHerf"><a href="homepage.jsp">个人主页</a></span>
	</div>
	<div id="container">
		<h2 id="title">指定课程TA</h2>
		<div id="postForm">
			<div id="postFormContent" style="width: 278px;">
				<form action="chooseTA.jsp" method="post">
					<label for="course_id">课程号：</label>
					<input type="text" name="course_id" value="<%=course_id%>" /><br /><br />
					<label for="course_name">课程名：</label>
					<input type="text" name="course_name" value="<%=course_name%>" /><br /><br />
					<label for="class_id">教学班号：</label>
					<input type="text" name="class_id" value="<%=class_id%>" /><br /><br />
					<label for="ta_id">TA学号：</label>
					<input type="text" name="ta_id" value="<%=class_id%>" /><br /><br />
					<div class="Center">
						<input type="submit" value="确定" name="postTA"><br /><br />
						<%=hintToUser%>
					</div>
				</form>
			</div>
		</div>
	</div>
</body>
</html>