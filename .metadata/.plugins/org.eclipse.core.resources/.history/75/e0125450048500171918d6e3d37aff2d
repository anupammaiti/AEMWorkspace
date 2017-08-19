<%@page session="false"%><%--
  Copyright 1997-2009 Day Management AG
  Barfuesserplatz 6, 4001 Basel, Switzerland
  All Rights Reserved.

  This software is the confidential and proprietary information of
  Day Management AG, ("Confidential Information"). You shall not
  disclose such Confidential Information and shall use it only in
  accordance with the terms of the license agreement you entered into
  with Day.

  ==============================================================================


--%><%@include file="/libs/foundation/global.jsp"%><%
%><%@include file="../init.jsp"%><%
%><%@page import="java.util.ResourceBundle"%><%
%><%@page import="java.util.Iterator" %><%
%><%@page import="java.util.Map" %><%
%><%@page import="java.util.HashMap" %><%
%><%@page import="com.day.cq.security.Authorizable" %><%
%><%@page import="com.day.cq.wcm.foundation.forms.FormsHelper" %><%

final ResourceBundle bundle = slingRequest.getResourceBundle(null);
final String name = FormsHelper.getParameterName(resource);
final String width = properties.get("width", "");
final boolean required = FormsHelper.isRequired(resource);
final String title = FormsHelper.getTitle(resource, "Gender");
final String[] options = properties.get("options", new String[]{"female", "male"});
final Map<String, String> displayOptions = new HashMap<String, String>(options.length+1);
displayOptions.put("", bundle.getString("I would not say"));
for (int i=0;i<options.length;i++) {
	displayOptions.put(options[i], bundle.getString(options[i]));
}
final String value = (profile==null) ? "" : profile.get(name,"");
final String path = "./"+ name;
%><%@include file="../formselect.jsp"  %>
