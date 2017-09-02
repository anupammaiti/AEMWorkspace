<%@include file="/libs/foundation/global.jsp"%>
<%@ page import="org.apache.sling.commons.json.io.*,com.adobe.cq.mobile.*" %><%
String first = request.getParameter("first");
String last = request.getParameter("last");
String address = request.getParameter("address");
String city = request.getParameter("city");
String details = request.getParameter("details");
String state = request.getParameter("state");
String date = request.getParameter("date");
String cat =  request.getParameter("cat");
 
//Create a ClaimService instance
org.myorg.portfolio.mobileData.ClaimService cs = sling.getService(org.myorg.portfolio.mobileData.ClaimService.class);
  
String claimId = cs.createClaim(last,first, date,address, city, state, cat, details) ; 
   
//Send the data back to the client 
JSONWriter writer = new JSONWriter(response.getWriter());
writer.object();
writer.key("claimId");
writer.value(claimId);
  
writer.endObject();
%>
