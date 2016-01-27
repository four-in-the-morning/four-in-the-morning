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
	String courseNames = "";
	ArrayList<String> courseList = MySQLHelper.queryCourseForTeacher(userId);
	for (String course : courseList) {
		courseNames += "<option value=\"" + course + "\">" + course + "</option>";
	}
	String course_name = "";
	String class_id = "";
	String ta_id = "";
	String hintToUser = "";
	if (method.equals("POST")) {
		course_name = request.getParameter("course_name");
		courseName = request.getParameter("course_name");
		class_id = request.getParameter("class_id");
		ta_id = request.getParameter("ta_id");
		if (MySQLHelper.chooseTA(course_name, class_id, ta_id)) {
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
					<label for="course_name">课程名：</label>
					<select name="course_name" id="selCourseNames"><%=courseNames%></select><br /><br />
					<label for="class_id">教学班号：</label>
					<input type="text" name="class_id" value="<%=class_id%>" /><br /><br />
					<label for="ta_id">TA学号：</label>
					<input type="text" name="ta_id" value="<%=ta_id%>" /><br /><br />
					<div class="Center">
						<input type="submit" value="确定" name="postTA"><br /><br />
						<%=hintToUser%>
					</div>
				</form>
			</div>
		</div>
	</div>
	<script type="text/javascript">
		var selectChanged = false;
		var selOpt = document.getElementById("selCourseNames").options;
		for (var i = 0; i < selOpt.length; i++) {
			if (selOpt[i].value == '<%=course_name%>') {
				selOpt[i].selected = true;
				selectChanged = true;
			} else {
				selOpt[i].selected = false;
			}
		}
		if (!selectChanged) {
			selOpt[0].selected = true;
		}
	</script>
</body>
</html>