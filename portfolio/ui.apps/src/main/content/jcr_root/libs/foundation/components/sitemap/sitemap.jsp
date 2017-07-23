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

  Text component

  Draws text. If it's not rich text it is formatted beforehand.

--%><%@ page import="org.apache.jackrabbit.util.Text,
                     com.day.cq.wcm.foundation.Sitemap,
                     com.day.cq.wcm.api.PageFilter,
                     com.day.cq.wcm.api.PageManager"%><%
%><%@include file="/libs/foundation/global.jsp"%><%

    String rootPath = properties.get("rootPath", "");
    if (rootPath.length() > 0) {
        if (rootPath.startsWith("path:")) {
            rootPath = rootPath.substring(5,rootPath.length());
        }
    } else {
        long absParent = currentStyle.get("absParent", 2L);
        rootPath = currentPage.getAbsoluteParent((int) absParent).getPath();
    }

    %><div class="text"><%
    Page rootPage = slingRequest.getResourceResolver().adaptTo(PageManager.class).getPage(rootPath);
    Sitemap stm = new Sitemap(rootPage);
    stm.draw(out);
    %>

</div>
