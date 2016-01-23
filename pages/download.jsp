<%@page language="java" contentType="application/x-msdownload" pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*, javax.servlet.*" %>
<%@page import="java.net.URLEncoder" %>
<%@page import="org.apache.commons.io.output.*" %>
<%
    response.reset();
    response.setContentType("application/x-download");
    // 你要下载的文件名称，这个名称是帮助你定位服务器文件的
    String filename = "fuwuqi.txt";
    application.getRealPath("/home/web/four-in-the-morning/homeworks/" + filename);
    String filedownload = "/home/web/four-in-the-morning/homeworks/" + filename;
    // 这里是文件显示名称，这个名称是用户拿到文件的命名，可以友好一些
    String filedisplay = "youhao.txt";

    filedisplay = URLEncoder.encode(filedisplay,"UTF-8");
    response.addHeader("Content-Disposition","attachment;filename=" + filedisplay);
    java.io.OutputStream outp = null;
    java.io.FileInputStream in = null;
    try{
        outp = response.getOutputStream();
        in = new FileInputStream(filedownload);

        byte[] b = new byte[1024];
        int i = 0;

        while((i = in.read(b)) > 0)
        {
        outp.write(b, 0, i);
        }
        outp.flush();
        out.clear();
        out = pageContext.pushBody();
    } catch(Exception e){
        System.out.println("Error!");
        e.printStackTrace();
    } finally {
        if(in != null){
            in.close();
            in = null;
        }
    }
%>