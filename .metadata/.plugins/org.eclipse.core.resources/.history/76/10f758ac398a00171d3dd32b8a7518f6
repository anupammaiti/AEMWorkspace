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

  List children component

  Includes the 'teaser' selected script of child pages.

  ==============================================================================
  DEPRECATED since CQ 5.3.
  ==============================================================================

--%><%@include file="/libs/foundation/global.jsp"%><%
%><%@ page import="java.util.Iterator,
        com.day.cq.wcm.api.PageFilter,
        com.day.cq.wcm.api.Page,
        com.day.cq.wcm.api.PageManager,
        com.day.cq.wcm.api.WCMMode" %><%

    String listroot = properties.get("listroot", currentPage.getPath());
    Page rootPage = slingRequest.getResourceResolver().adaptTo(PageManager.class).getPage(listroot);
    if (rootPage != null) {
        Iterator<Page> children = rootPage.listChildren(new PageFilter(request));

        // disable WCM for included components
        WCMMode mode = WCMMode.DISABLED.toRequest(request);
        try {
            while (children.hasNext()) {
                Page child = children.next();
                String pathtoinclude=child.getPath() + ".teaser.html";
                %><div class="item"><sling:include path="<%= pathtoinclude %>"/></div><%
            }
        } finally {
            mode.toRequest(request);
        }
    }
%>
