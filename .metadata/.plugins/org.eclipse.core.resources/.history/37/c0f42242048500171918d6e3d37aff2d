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

  Compiles a JSON-formatted list of all tag namespaces

--%><%
%><%@ page import="com.day.cq.tagging.Tag,
                   com.day.cq.tagging.TagManager,
                   java.util.Iterator"%><%
%><%@include file="/libs/foundation/global.jsp"%><%

    response.setContentType("text/plain");

%>[<%

    String delim = "";
    TagManager tagManager = slingRequest.getResourceResolver().adaptTo(TagManager.class);
    for (Tag ns : tagManager.getNamespaces()) {
        %><%= delim %><%
        %>{<%
            // NOTE: Double encoding because of DOM XSS injection !!
            %>"text":"<%= xssAPI.encodeForJSString(xssAPI.encodeForHTMLAttr(ns.getTitle())) %>",<%
            %>"value":"<%= xssAPI.encodeForJSString(xssAPI.encodeForHTMLAttr(ns.getName())) %>"<%
        %>}<%
        if ("".equals(delim)) delim = ",";
    }
%>]
