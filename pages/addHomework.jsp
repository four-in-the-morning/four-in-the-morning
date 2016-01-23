<%@ page language="java" import="java.util.*" import="java.text.SimpleDateFormat" import="java.util.Date"
	contentType="text/html; charset=utf-8"%>
<%
	request.setCharacterEncoding("utf-8");
%>
<%@include file="MySQLHelper.jsp"%>
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
	String homework_id = "";
	String homework_title = "";
	String homework_description = "";
	String detail_attach_file = "";
	String post_date = "";
	String ddl = "";
	if (method.equals("POST")) {
		course_id = request.getParameter("course_id");
		homework_id = request.getParameter("homework_id");
		homework_title = request.getParameter("homework_title");
		homework_description = request.getParameter("homework_description");
		detail_attach_file = request.getParameter("detail_attach_file");
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		post_date = df.format(new Date());
		ddl = request.getParameter("ddl");
		MySQLHelper.HomeworkPost homeworkPost = new MySQLHelper.HomeworkPost(course_id, homework_id,
				homework_title, homework_description, detail_attach_file, post_date, ddl);
		MySQLHelper.addHomework(homeworkPost);
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="css/addHomework.css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>发布作业</title>
</head>
<body>
	<div class="notice">
		<span id="posthw">凌晨四点</span><span id="home"><a
			href="homepage.jsp">个人主页</a></span>
	</div>
	<h2 id="title">发布作业</h2>
	<div class="postForm">
		<form action="addHomework.jsp" method="post">
			课程号： <input type="text" name="course_id" value="<%=course_id%>" /><br /><br />
			作业号： <input type="text" name="homework_id" value="<%=homework_id%>" /><br /><br />
			作业标题： <input type="text" name="homework_title"
				value="<%=homework_title%>" /><br /><br /> 作业描述： <input type="text"
				name="homework_description" value="<%=homework_description%>" /><br /><br />
			附件： <input type="text" name="detail_attach_file"
				value="<%=detail_attach_file%>" /><br /><br /> DDL： <input
				type="date" name="ddl" value="<%=ddl%>"/><br /><br /> <input type="submit"
				value="发布" name="postHomework"><br /><br />
		</form>
	</div>
</body>
</html>