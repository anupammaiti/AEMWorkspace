<%@page session="false"%><%--
  Copyright 1997-2008 Day Management AG
  Barfuesserplatz 6, 4001 Basel, Switzerland
  All Rights Reserved.

  This software is the confidential and proprietary information of
  Day Management AG, ("Confidential Information"). You shall not
  disclose such Confidential Information and shall use it only in
  accordance with the terms of the license agreement you entered into
  with Day.

  ==============================================================================

  Top Navigation component

  Draws the top navigation

--%><%@include file="/libs/foundation/global.jsp"%><%
%><%@ page import="com.day.cq.wcm.api.PageFilter,
        com.day.text.Text,
        org.apache.commons.lang3.StringEscapeUtils,
        java.util.Iterator" %><%

    // get starting point of navigation
    long absParent = currentStyle.get("absParent", 2L);
    String navstart = currentPage.getAbsoluteParent((int) absParent).getPath();

    //if not deep enough take current node
    if (navstart.equals("")) navstart=currentPage.getPath();

    Resource rootRes = slingRequest.getResourceResolver().getResource(navstart);
    Page rootPage = rootRes == null ? null : rootRes.adaptTo(Page.class);
    if (rootPage != null) {
        Iterator<Page> children = rootPage.listChildren(new PageFilter(request));
%>
        <ul>
<%
        String cssClass = null;
        while (children.hasNext()) {
            Page child = children.next();
                if (null == cssClass) {
                    cssClass = "first";
                } else if (!children.hasNext()) {
                    cssClass = "last";
                } else {
                    cssClass = "item";
                }

                cssClass += (Text.isDescendantOrEqual(child.getPath(), currentPage.getPath())) ? " on" : "";
%>          <li class="<%=cssClass%>"><a href="<%= xssAPI.getValidHref(child.getPath()) %>.html"><%= xssAPI.encodeForHTML(child.getTitle()) %></a></li>
<%
        }
%>        </ul>
<%
    }
%>
