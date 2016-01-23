<%@ page language="java" import="java.util.*"
	contentType="text/html; charset=utf-8"%>
<%request.setCharacterEncoding("utf-8");%>
<%@include file="MySQLHelper.jsp"%>
<%@ page import="java.io.*,java.util.*, javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.io.output.*" %>

<%
    InputStream uploaddone = request.getInputStream();
    if(uploaddone != null) {
        /*
        文件上传功能，统一存在"/home/web/four-in-the-morning/homeworks/"目录下
        作业名称命名规则:课程号 + 教学班号 + 学号 + 作业号
        */
        File file ;
        int maxFileSize = 5000 * 1024;
        int maxMemSize = 5000 * 1024;
        ServletContext context = pageContext.getServletContext();
        //设置文件存储路径，即变量file-upload的值，该变量在ROOT/WEB-INF/web.xml文件中定义
        String filePath = context.getInitParameter("file-upload");

        //Verify the content type
        String contentType = request.getContentType();
        if ((contentType.indexOf("multipart/form-data") >= 0)) {

            DiskFileItemFactory factory = new DiskFileItemFactory();
            //maximum size that will be stored in memory
            factory.setSizeThreshold(maxMemSize);
            //Location to save data that is larger than maxMemSize.
            factory.setRepository(new File("/home/"));

            //Create a new file upload handler
            ServletFileUpload upload = new ServletFileUpload(factory);
            //maximum file size to be uploaded.
            upload.setSizeMax(maxFileSize);
            try{ 
                //Parse the request to get file items.
                List fileItems = upload.parseRequest(request);

                //Process the uploaded file items
                Iterator i = fileItems.iterator();

                out.println("<html>");
                out.println("<head>");
                out.println("<title>JSP File upload</title>");  
                out.println("</head>");
                out.println("<body>");
            while (i.hasNext ()) {
                FileItem fi = (FileItem)i.next();
                if (!fi.isFormField()){
                    //Get the uploaded file parameters
                    String fieldName = fi.getFieldName();
                    String fileName = fi.getName();
                    //在此处给出文件名称
                    fileName = "123.jpg";
                    boolean isInMemory = fi.isInMemory();
                    long sizeInBytes = fi.getSize();
                    //Write the file
                    if(fileName.lastIndexOf("\\") >= 0){
                        file = new File(filePath + fileName.substring(fileName.lastIndexOf("\\")));
                    } else {
                        file = new File(filePath + fileName.substring(fileName.lastIndexOf("\\") + 1));
                    }
                    fi.write(file);
                    out.println("Uploaded Filename: " + filePath + fileName + "<br>");
                }
            }
            out.println("</body>");
            out.println("</html>");
            }catch(Exception ex) {
                System.out.println(ex);
            }
        }else{
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Servlet upload</title>");  
        out.println("</head>");
        out.println("<body>");
        out.println("<p>No file uploaded</p>"); 
        out.println("</body>");
        out.println("</html>");
        }
    } 
%>
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
						"<tr id=\"showOrHidden%d\" style=\"display: none\"><td colspan=\"4\">作业描述:<br/>"
						+"<form action=\"uploadFile2.jsp\" method=\"post\" enctype=\"multipart/form-data\">"
						+"<input type=\"file\" name=\"file\" size=\"50\" /><br />"
						+"<input type=\"submit\" value=\"Submit\" name=\"commit\"/>"
						+"</form>" 
						+ "<a href=\"%s\">附件更新啦</a></td></tr>",
						count,
						//post.homework_description,
						post.detail_attach_file));
					count++;
				}
			%>
		</table>
		<script type="text/javascript">
			function onClickChangeShow(e, index) {
				var temp = document.getElementById("showOrHidden" + index);
				if (temp.style.display == "none") {
					temp.style.display = "";
				} else {
					temp.style.display = "none";
				}
			}
		</script>
	</body>
</html>
