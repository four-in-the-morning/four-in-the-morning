<%@ page import="java.io.*,java.util.*, javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.io.output.*" %>

<%
   /*
   文件上传功能，统一存在"/home/web/four-in-the-morning/homeworks/"目录下
   作业名称命名规则:课程号 + 教学班号 + 学号 + 作业号
   */
   File file ;
   int maxFileSize = 5000 * 1024;
   int maxMemSize = 5000 * 1024;
   ServletContext context = pageContext.getServletContext();
   // 设置文件存储路径，即变量file-upload的值，该变量在ROOT/WEB-INF/web.xml文件中定义
   String filePath = context.getInitParameter("file-upload");

   // Verify the content type
   String contentType = request.getContentType();
   if ((contentType.indexOf("multipart/form-data") >= 0)) {

      DiskFileItemFactory factory = new DiskFileItemFactory();
      // maximum size that will be stored in memory
      factory.setSizeThreshold(maxMemSize);
      // Location to save data that is larger than maxMemSize.
      factory.setRepository(new File("/home/"));

      // Create a new file upload handler
      ServletFileUpload upload = new ServletFileUpload(factory);
      // maximum file size to be uploaded.
      upload.setSizeMax(maxFileSize);
      try{ 
         // Parse the request to get file items.
         List fileItems = upload.parseRequest(request);

         // Process the uploaded file items
         Iterator i = fileItems.iterator();

         out.println("<html>");
         out.println("<head>");
         out.println("<title>JSP File upload</title>");  
         out.println("</head>");
         out.println("<body>");
         while (i.hasNext ()) {
            FileItem fi = (FileItem)i.next();
            if (!fi.isFormField()){
               // Get the uploaded file parameters
               String fieldName = fi.getFieldName();
               String fileName = fi.getName();
               //在此处给出文件名称
               //fileName = "123.jpg";
               boolean isInMemory = fi.isInMemory();
               long sizeInBytes = fi.getSize();
               // Write the file
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
%>