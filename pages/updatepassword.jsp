<!DOCTYPE html>
<html>
<head>
<style>
	div#updatepassword {
		border:solid 1px #666699;
		margin-left:200px;
		margin-right:200px;
		padding:10px;
	}
</style>

<meta charset="UTF-8">
<title>Updatepassword</title>

</head>
<body>
	<div id="updatepassword">
	<h1>修改密码</h1>
	<form action="login.html" method="post">
		旧密码：<input type="password" name="old_password" />
		</br></br>
		新密码：<input type="password" name="new_password" />
		</br></br>
		确认新密码：<input type="password" name="new_password_confirm" />
		</br></br>
		<input type="submit" value="确认修改" name="submit1">
	</form>
	</div>
</body>
</html>