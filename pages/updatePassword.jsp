<%@ page language="java" import="java.util.*"
	contentType="text/html; charset=utf-8"%>
<% request.setCharacterEncoding("utf-8"); %>
<%@ include file="MySQLHelper.jsp"%>

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
<link rel="stylesheet" type="text/css" href="css/main.css">
<link rel="stylesheet" type="text/css" href="css/updatePassword.css">
<meta charset="UTF-8">
<title>修改密码</title>
</head>
<body>
	<div id="header">
		<span id="siteName">凌晨四点</span>
		<span id="jumpHerf"><a href="index.jsp">登录</a></span>
	</div>
	<div id="container">
		<h2 id="title">修改密码</h2>
		<div id="postForm">
			<div id="postFormContent" style="width: 169px;">
				<form action="updatePassword.jsp" method="post">
					<label for="user_id">用户名：</label>
					<input type="text" name="user_id" /><br />
					<label for="password_old">旧密码：</label>
					<input type="password" name="password_old" /><br />
					<label for="password_new">新密码：</label>
					<input type="password" name="password_new" /><br />
					<label for="password_confirm">确认新密码：</label>
					<input type="password" name="password_confirm" /><br />
					<div class="Center">
						<input type="submit" value="确认修改密码" name="commit"><br />
						<%=hintToUser%>
					</div>
				</form>
			</div>
		</div>
	</div>
</body>
</html>