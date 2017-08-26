<%@include file="/libs/foundation/global.jsp"%>
<%@ page import="org.apache.sling.commons.json.io.*,com.adobe.cq.*" %><%
String first = request.getParameter("first");
String last = request.getParameter("last");
String phone = request.getParameter("phone");
String desc = request.getParameter("desc");
   
//create a CustomerService instance
org.myorg.portfolio.relationalDB.CustomerService custService = sling.getService(org.myorg.portfolio.relationalDB.CustomerService.class);
 
int myPK = custService.injestCustData(first, last, phone, desc) ; 
    
//Send the data back to the client
JSONWriter writer = new JSONWriter(response.getWriter());
writer.object();
writer.key("pk");
writer.value(myPK);
   
writer.endObject();
%>