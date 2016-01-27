<%@ page language="java" import="java.util.*" 
         contentType="text/html; charset=utf-8"%>
<%request.setCharacterEncoding("utf-8");%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>登录</title>
		<link rel="stylesheet" type="text/css" href="css/main.css">
		<link rel="stylesheet" type="text/css" href="css/login.css">
	</head>
	<body>
		<div id="header">
			<span id="siteName">凌晨四点</span>
			<span id="jumpHerf"><a href="index.jsp">登陆</a></span>
		</div>
		<div id="container">
			<h2 id="title">登录</h2>
			<div id="postForm">
				<div id="postFormContent" style="width: 169px;">
					<form action="homepage.jsp" method="post">
						<label for="user_id">学号：</label><br/>
						<input type="text" name="user_id" /><br/>
						<label for="password">密码：</label><br/>
						<input type="password" name="password" /><br/>
						<div class="Center" id="twoBtnStyle">
							<input type="submit" value="登录" name="commit" />
							<input type="button" value="修改密码" onclick="jumpUpadtePassword();" />
						</div>
					</form>
				</div>
			</div>
		</div>
		<script language="javascript" type="text/javascript">
			function jumpUpadtePassword() {
				window.location.href = "updatepassword.jsp";
				return false;
			}
		</script>
	</body>
</html>