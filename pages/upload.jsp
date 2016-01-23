<html>
	<head>
		<title>File Uploading Form</title>
	</head>
	<body>
		<h3>File Upload:</h3>
		Select a file to upload: <br />
		<form action="uploadFile.jsp" method="post" enctype="multipart/form-data">
		<input type="file" name="file" size="5000" /><br />
		<input type="submit" value="uploadfile" />
		</form>
	</body>
</html>