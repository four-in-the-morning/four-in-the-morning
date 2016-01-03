<!-- <%@ page language="java" import="java.util.*" 
         contentType="text/html; charset=utf-8"%>
<%request.setCharacterEncoding("utf-8");%> -->
<!DOCTYPE html>
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="css/login.css">
		<meta charset="UTF-8">
		<title>登录</title>
		</head>
	<body>
		<h1>登录</h1>
		<div id="login">
			<form action="homepage.jsp" method="post">
				<label for="user_id">学号：</label>
				<input type="text" name="user_id" /> <br/>
				<label for="password">密码：</label>
				<input type="password" name="password" /> <br/>
				<input type="submit" value="登录" name="commit">
			</form>
		</div>
	</body>
</html>