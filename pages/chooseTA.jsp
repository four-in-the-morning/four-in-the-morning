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
	String courseName = "<select name=\"course_name\">";
	ArrayList<String> courseList = MySQLHelper.queryCourseForTeacher(userId);
	for(String course: courseList) {
		courseName += "<option value=" + course + ">" + course + "</option>";
	}
	courseName += "</select>";
	String course_name = "";
	String class_id = "";
	String ta_id = "";
	String hintToUser = "";
	if (method.equals("POST")) {
		course_name = request.getParameter("course_name");
		courseName = request.getParameter("course_name");
		class_id = request.getParameter("class_id");
		ta_id = request.getParameter("ta_id");
		if(MySQLHelper.chooseTA(course_name, class_id, ta_id)) {
			hintToUser = "成功指定课程TA";
		}
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="css/chooseTA.css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>指定课程TA</title>
</head>
<body>
	<div class="notice">
		<span id="posthw">凌晨四点</span><span id="home"><a
			href="homepage.jsp">个人主页</a></span>
	</div>
	<h2 id="title">指定课程TA</h2>
	<div class="postForm">
		<form action="chooseTA.jsp" method="post">
			课程名： <%=courseName%><br /><br />
			教学班号： <input type="text" name="class_id"
				value="<%=class_id%>" /><br /><br />
				TA学号： <input type="text" name="ta_id"
				value="<%=ta_id%>" /><br /><br /><input type="submit"
				value="确定" name="postTA"><br /><br />
			<%=hintToUser%>
		</form>
	</div>
</body>
</html>