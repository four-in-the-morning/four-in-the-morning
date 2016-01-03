<%@ page language="java" import="java.util.*" 
         contentType="text/html; charset=utf-8"%>
<%request.setCharacterEncoding("utf-8");%>
<%@include file="MySQLHelper.jsp"%>
<%
	String userId = request.getParameter("user_id");
	String password = request.getParameter("password");
	boolean login = false;
	if (userId != null && password != null) {
		login = MySQLHelper.checkPwd(userId, password);
		if (login) {
			session.setAttribute("userId", userId);
		} else {
			out.print("wrong password");
			response.sendRedirect("index.jsp");
		}
	} else {
		out.print("Please Login first");
		response.sendRedirect("index.jsp");
	}
%>
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="css/homepage.css">
		<meta charset="UTF-8">
		<title>个人主页</title>
		<p>你好, ${sessionScope.userId}</p>
		<p>本周作业</p>
		<table>
            <tr><td>课程</td><td>作业</td><td>Deadline</td><td>详情</td></tr>
            <%
            	ArrayList<MySQLHelper.HomeworkPost> postList = MySQLHelper.queryDDLHomework(userId);
            	for (MySQLHelper.HomeworkPost post : postList)  {
            		String detail = String.format(
            			"<a href=\"homeworkdetail.jsp?course_id=%s&homework_id=%s\">详情</a>",
            			post.course_id,
            			post.homework_id
            		);
            		out.print(String.format(
                        "<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>",
                        post.course_id,
                        post.homework_title,
                        post.ddl,
                        detail));
            	}
            %>
        </table>
	</head>
	<body>
		<h3>
	</body>
</html>