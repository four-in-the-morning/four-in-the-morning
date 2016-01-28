<%@ page language="java" import="java.util.*" import="java.text.SimpleDateFormat" import="java.util.Date"
	contentType="text/html; charset=utf-8"%>
<%
	request.setCharacterEncoding("utf-8");
%>
<%@include file="MySQLHelper.jsp"%>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.FileUploadException" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>

<%
	String userId = (String) session.getAttribute("userId");
	if (userId == null) {
		out.print("Please Login first");
		response.sendRedirect("index.jsp");
	}
%>

<%
	String method = request.getMethod();
	String pageAddress = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath();
	String course_id = "";
	String homework_id = "";
	String homework_title = "";
	String homework_description = "";
	String detail_attach_file = "";
	String post_date = "";
	String ddl = "";
	String hintToUser = "";
	if (method.equals("POST")) {
		DiskFileItemFactory diskFileItemFactory = new DiskFileItemFactory();
		ServletFileUpload servletFileUpload = new ServletFileUpload(diskFileItemFactory);
		try {
			List list = servletFileUpload.parseRequest(request);
			Iterator iterator = list.iterator();
			while (iterator.hasNext()) {
				FileItem item = (FileItem)iterator.next();
				if (item.isFormField()) { //此处是判断非文件域，即不是<input type="file"/>的标签
					String name = item.getFieldName(); //获取form表单中name的id
					if (name.equals("course_id")) 
						course_id = item.getString("utf-8");
					else if (name.equals("homework_id")) 
						homework_id = item.getString("utf-8");
					else if (name.equals("homework_title"))
						homework_title = item.getString("utf-8");
					else if (name.equals("homework_description"))
						homework_description = item.getString("utf-8");
					else if (name.equals("ddl"))
						ddl = item.getString("utf-8");
				} else { //如果是文件域，则上传文件
					String fName = item.getName();  //这里是获取文件名
					int i = fName.lastIndexOf("\\");//此处由于ie中上传文件时是以图片的绝对路径全称作为文件名所以必需截取后面的文件名
					fName = fName.substring(i + 1, fName.length());
					// String filepath = request.getRealPath("/") + "four-in-the-morning/homeworkPost";
					String filepath = request.getRealPath("/") + "homeworkPost\\";
					File path = new File(filepath);
					if (!path.isDirectory()) {
						path.mkdir();
					}
					String finalFilePath = null;
					if (homework_title.isEmpty()) {
						finalFilePath = path + "\\" + fName;
						detail_attach_file = pageAddress + "/homeworkPost/" + fName;
					} else {
						String[] fNameSplit = fName.split("\\.");
						finalFilePath = path + "\\" + homework_title + "文档." + fNameSplit[fNameSplit.length - 1];
						detail_attach_file = pageAddress + "/homeworkPost/" + homework_title + "文档." + fNameSplit[fNameSplit.length - 1];
					}
					try {
						if (fName != "") {
							item.write(new File(finalFilePath));
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
		} catch (FileUploadException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		post_date = df.format(new Date());
		MySQLHelper.HomeworkPost homeworkPost = new MySQLHelper.HomeworkPost(course_id, homework_id,
				homework_title, homework_description, detail_attach_file, post_date, ddl, "");
		if(MySQLHelper.addHomework(homeworkPost)) {
			hintToUser = "成功发布作业";
		}
	}
%>

<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="css/main.css">
<link rel="stylesheet" type="text/css" href="css/addHomework.css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>发布作业</title>
</head>
<body>
	<div id="header">
		<span id="siteName">凌晨四点</span>
		<span id="jumpHerf"><a href="homepage.jsp">个人主页</a></span>
	</div>
	<div id="container">
		<h2 id="title">发布作业</h2>
		<div id="postForm">
			<div id="postFormContent" style="width: 345px;">
				<form action="addHomework.jsp" method="post" enctype = "multipart/form-data">
					<label for="course_id">课程号：</label>
					<input type="text" name="course_id" value="<%=course_id%>" /><br /><br />
					<label for="homework_id">作业号：</label> 
					<input type="text" name="homework_id" value="<%=homework_id%>" /><br /><br />
					<label for="homework_title">作业标题：</label>
					<input type="text" name="homework_title" value="<%=homework_title%>" /><br /><br /> 
					<label for="homework_description">作业描述：</label>
					<input type="text" name="homework_description" value="<%=homework_description%>" /><br /><br />
					<label for="detail_attach_file">附件：</label>
					<input type="file" name="detail_attach_file" value="<%=detail_attach_file%>" /><br /><br />
					<label for="ddl">DDL：</label>
					<input type="date" name="ddl" value="<%=ddl%>" /><br /><br />
					<div class="Center">
						<input type="submit" value="发布" name="postHomework"><br /><br />
						<%=hintToUser%>
					</div>
				</form>
			</div>
		</div>
	</div>
</body>
</html>