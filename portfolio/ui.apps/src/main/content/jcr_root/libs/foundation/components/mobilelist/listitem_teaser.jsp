<%--
  Copyright 1997-2008 Day Management AG
  Barfuesserplatz 6, 4001 Basel, Switzerland
  All Rights Reserved.

  This software is the confidential and proprietary information of
  Day Management AG, ("Confidential Information"). You shall not
  disclose such Confidential Information and shall use it only in
  accordance with the terms of the license agreement you entered into
  with Day.

  ==============================================================================

  List component sub-script

  Draws a list item as a teaser.

  request attributes:
  - {com.day.cq.wcm.foundation.List} list The list
  - {com.day.cq.wcm.api.Page} listitem The list item as a page

--%><%
%><%@ page session="false"
           import="com.day.cq.wcm.api.Page,
                   com.day.cq.wcm.mobile.api.device.capability.DeviceCapability,
                   com.day.cq.wcm.mobile.core.MobileUtil,
                   org.apache.sling.api.SlingHttpServletRequest,
                   javax.jcr.Node,
                   javax.jcr.RepositoryException,
                   org.apache.commons.lang3.StringEscapeUtils"%><%

    final SlingHttpServletRequest slingRequest = (SlingHttpServletRequest) request;

    Page listItem = (Page)request.getAttribute("listitem");

    boolean hasImage = false;
    String title = listItem.getTitle() != null ? listItem.getTitle() : listItem.getName();
    String description = listItem.getDescription() != null ? listItem.getDescription() : "";

    try {
        hasImage = listItem.getContentResource().adaptTo(Node.class).hasNode("image") ||
                listItem.getProperties().get("imageReference", "").length() > 0;
    } catch (RepositoryException re) {
    }

    %><li<%=request.getAttribute("listitemclass")%>><p><a href="<%= listItem.getPath() %>.html" title="<%= StringEscapeUtils.escapeHtml4(title) %>"><%

    if (hasImage && MobileUtil.hasCapability(slingRequest, DeviceCapability.CAPABILITY_IMAGES)) {
        %><img class="teaser" src="<%= listItem.getPath() %>.thumbnail.jpg" alt="<%= StringEscapeUtils.escapeHtml4(title) %>" title="<%= StringEscapeUtils.escapeHtml4(title) %>"><%
    }

    %><span class="teaser-title"><%= StringEscapeUtils.escapeHtml4(title) %></span></a><%

    if (!"".equals(description)) {
        %><br/><span class="teaser-description"><%= StringEscapeUtils.escapeHtml4(description) %></span><%
    }

%></p></li>