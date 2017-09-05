<%@page session="false" %>
<%@include file="/libs/foundation/global.jsp"%>
<%@ page import="org.apache.sling.jcr.api.SlingRepository" %>
<%@ page import="com.day.cq.security.UserManagerFactory" %>
<%@ page import="com.day.cq.security.User" %>
<%@ page import="com.day.cq.security.Authorizable" %>
<%@ page import="com.day.cq.security.profile.Profile" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.apache.sling.commons.json.io.JSONWriter" %>

<%@page import="com.day.cq.dam.api.Asset;"%> 
<%
String filter = request.getParameter("filter");

//create a SeachService instance
org.myorg.portfolio.queryBuilder.SearchService queryBuilder = sling.getService( org.myorg.portfolio.queryBuilder.SearchService.class);

String XML = queryBuilder.SearchCQForContent() ; 

//Send the data back to the client 
JSONWriter writer = new JSONWriter(response.getWriter());
writer.object();
writer.key("xml");
writer.value(XML);

writer.endObject();
%>
