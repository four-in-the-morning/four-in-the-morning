<%@ page language="java" import="java.util.*"
	contentType="text/html; charset=utf-8"%>
<%
	request.setCharacterEncoding("utf-8");
%>
<%@include file="MySQLHelper.jsp"%>
<%
	String hintToUser = "";
	String method = request.getMethod();
	String confirm_button = request.getParameter("commit");
	if (method.equals("POST") && confirm_button != null) {
		String userId = request.getParameter("user_id");
		String password_old = request.getParameter("password_old");
		String password_new = request.getParameter("password_new");
		String password_confirm = request.getParameter("password_confirm");
		boolean exist = MySQLHelper.checkPwd(userId, password_old);
		if (exist == false) {
			hintToUser = "用户名或密码错误";
		} else {
			if (password_new == "") {
				hintToUser = "新密码不能为空";
			} else if (password_confirm == "") {
				hintToUser = "确认密码不能为空";
			} else if (!password_new.equals(password_confirm)) {
				hintToUser = "新密码与确认新密码不匹配";
			} else {
				hintToUser = "成功修改密码";
				response.sendRedirect("index.jsp");
				MySQLHelper.modifyPwd(userId, password_old, password_confirm);
			}
		}
	}
%>

<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="css/updatePassword.css">
<meta charset="UTF-8">
<title>修改密码</title>
</head>
<body>
	<h2>修改密码</h2>
	<div id="updatePassword">
		<form action="updatePassword.jsp" method="post">
			用户名： <input type="text" name="user_id" /> <br /> 旧密码： <input
				type="password" name="password_old" /> <br /> 新密码： <input
				type="password" name="password_new" /> <br /> 确认新密码： <input
				type="password" name="password_confirm" /> <br /> <input
				type="submit" value="确认修改密码" name="commit"> <br />
		</form>
		<p><%=hintToUser%></p>
	</div>
</body>
</html>