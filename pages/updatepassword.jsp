<%@ page language="java" import="java.util.*"
	contentType="text/html; charset=utf-8"%>
<%
	request.setCharacterEncoding("utf-8");
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
		<form action="index.jsp" method="post">
			用户名： <input type="text" name="user_id" /> <br /> 
			旧密码： <input type="password" name="password" /> <br /> 
			新密码： <input type="password" name="password" /> <br /> 
			确认密码： <input type="password" name="password" /> <br /> 
			<input type="submit" value="确认修改密码" name="commit"> <br />
		</form>
	</div>
</body>
</html>