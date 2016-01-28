<%@ page language="java" import="java.util.*"
	contentType="text/html; charset=utf-8" %>
<%@ include file="downloadFilesHelper.jsp" %>
<% request.setCharacterEncoding("utf-8"); %>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>DownloadFile</title>
		<link rel="stylesheet" type="text/css" href="css/main.css">
		<link rel="stylesheet" type="text/css" href="css/download.css">
	</head>
	<body>
		<div id="header">
			<span id="siteName">凌晨四点</span>
			<span id="jumpHerf"><a href="homepage.jsp">个人主页</a></span>
		</div>
		<div id="container">
			<h2 id="title">下载文件</h2>
			<%
				// 服务器路径
				String filePath = request.getRealPath("/") + "homeworkUpload\\";
				// 构建路径File
				File path = new File(filePath);
				// 正则表达式
				String homeworkNamePrefix = request.getParameter("homeworkNamePrefix");
				// String homeworkNamePrefix = "数据库第一周作业";
				String regex = "^(" + homeworkNamePrefix + ")";
				// String regex = "^(数据库第一周作业)";
				// 获取文件List
				List<File> listFiles = getAllFiles(path, regex);
				// List转String[]
				String[] files = listToStringArray(listFiles);
				// 压缩文件名
				// String outputFileName = "批量下载" + homeworkNamePrefix + ".zip";
				String outputFileName = "Homework.zip";
				// 准备压缩
				JspFileDownload jspFileDownload = new JspFileDownload();
				jspFileDownload.setResponse(response);
				jspFileDownload.setDownType(1); // zip file
				jspFileDownload.setDisFileName(outputFileName);
				jspFileDownload.setZipFilePath(filePath);
				jspFileDownload.setZipDelFlag(false); // 不删除压缩文件
				jspFileDownload.setZipFileNames(files);
				jspFileDownload.setDownFileName(outputFileName);
				// jspFileDownload.setFileContent(homeworkNamePrefix);
				// jspFileDownload.setFileContentEnd();
				// 开始压缩并下载
				int status = jspFileDownload.process();
				// Debug
				// out.println("status = " + status + "<br/>");
				// out.println("regex = " + regex + "<br/>");
				// for (int i = 0; i < files.length; i++) {
				// 	out.println(files[i] + "<br/>");
				// }
				// out.println(outputFileName + "<br/>");
				if (status == 4) {
					out.println("<p>还没有同学上交作业</p>");
				}
			%>
		</div>
	</body>
</html>