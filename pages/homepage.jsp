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
		userId = (String) session.getAttribute("userId");
		if (userId == null) {
			out.print("Please Login first");
			response.sendRedirect("index.jsp");
		}
	}

	String postHw = "";
	boolean isTA = false;
	isTA = MySQLHelper.isTA(userId);
	if (isTA) {
		postHw = "<a href=\"addHomework.jsp\">发布作业</a>";
	}
	
%>
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="css/homepage.css">
		<meta charset="UTF-8">
		<title>个人主页</title>
	</head>
	<body>
		<p>你好, ${sessionScope.userId}</p>
		<p>本周作业</p>
		<table>
			<tr><td>课程</td><td>作业</td><td>Deadline</td><td>详情</td></tr>
			<%
				ArrayList<MySQLHelper.HomeworkPost> postList = MySQLHelper.queryDDLHomework(userId);
				Integer count = 0;
				for (MySQLHelper.HomeworkPost post : postList)  {
					String detail = String.format(
						"<button onclick=\"onClickChangeShow(this, %d)\">详情</button>",
						count
					);
					out.println(String.format(
						"<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>",
						post.course_id,
						post.homework_title,
						post.ddl,
						detail));
					out.println(String.format(
						"<tr id=\"showOrHidden%d\" style=\"display: none\"><td colspan=\"4\">作业描述：<br/>"
						+ "<form action=\"uploadFile2.jsp?detailIndex=%d\" method=\"post\" enctype=\"multipart/form-data\">"
						+ "<input type=\"file\" name=\"file\" size=\"0\" /><br />"
						//+ "<input type=\"hidden\" name=\"detailIndex\" value=\"%d\" />"
						+ "<input type=\"submit\" value=\"Submit\" />"
						+ "</form>" 
						+  "<a href=\"%s\">附件</a></td></tr>",
						count, count,
						//post.homework_description,
						post.detail_attach_file));
					count++;
				}
			%>
		</table>
		<%
			String detailIndex = request.getParameter("detailIndex");
		%>
		<script type="text/javascript">
			function onClickChangeShow(e, index) {
				var temp = document.getElementById("showOrHidden" + index);
				if (temp.style.display == "none") {
					temp.style.display = "";
				} else {
					temp.style.display = "none";
				}
			}
			document.getElementById("showOrHidden<%=detailIndex%>").style.display = "";
		</script>
		<%
			String uplodaResult = request.getParameter("submitsuccess");
			if (uplodaResult != null && uplodaResult.equals("true")) {
				out.print(String.format("<script type=\"text/javascript\">%s;</script>", 
					"alert('上传成功')"));
			} else if (uplodaResult != null) {
				out.print("<script>alert('上传失败');</script>");
			}
		%>
	</body>
</html>
