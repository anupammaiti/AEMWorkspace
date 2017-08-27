<%@ page import="org.apache.sling.commons.json.io.*,com.adobe.cq.sample.email.*" %><%
String server = request.getParameter("server");
String toAddress = request.getParameter("to");
String subject = request.getParameter("subject");
String message = request.getParameter("message");
 
//Send the email message
CustomEmailService mailService = new CustomEmailService();
mailService.send(message); 
 
%>