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
--%><%@include file="../init.jsp"%><%
%><%@page import="com.day.text.Text"%><%
%><%@page import="com.day.cq.wcm.foundation.forms.FormsHelper" %><%
%><%@taglib prefix="cq" uri="http://www.day.com/taglibs/cq/1.0" %><% 
%><cq:defineObjects/><%

    final String width = properties.get("width", "");
    final String cols = properties.get("cols", "35");
    final String name = properties.get("name", String.class);
    final String nodeName = properties.get("nodeName", String.class);
    final String path = "./" + name;
    final String title = FormsHelper.getTitle(resource, name);
    final String value = profile==null? "" : profile.get(name, "");
    final boolean required = FormsHelper.isRequired(resource);

%><%@include file="../formrowtext.jsp"  %>
