<%--
  Copyright 1997-2009 Day Management AG
  Barfuesserplatz 6, 4001 Basel, Switzerland
  All Rights Reserved.

  This software is the confidential and proprietary information of
  Day Management AG, ("Confidential Information"). You shall not
  disclose such Confidential Information and shall use it only in
  accordance with the terms of the license agreement you entered into
  with Day.

  ==============================================================================

  Opens the bulkeditor

--%><%@page session="false" %><%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %><%
%><%@include file="/libs/foundation/global.jsp" %><%
%><sling:defineObjects/><%@ page import="java.net.URLEncoder,
    org.apache.sling.api.resource.ResourceUtil,
    org.apache.sling.api.resource.ValueMap"%><%
    final String formPath = properties.get("formPath", null);
    if ( formPath == null || formPath.length() == 0 ) {
        %>
        <html><body>
          <p>Please specify the form path property at <%= xssAPI.encodeForHTML(resource.getPath()) %> to open the bulk editor.</p>
        </body></html>
        <%
    } else {
        final StringBuilder path = new StringBuilder(request.getContextPath());
        path.append("/bin/wcm/foundation/forms/report.html?path=");
        path.append(URLEncoder.encode(formPath, "UTF-8"));
        response.sendRedirect(path.toString());
    }
%>
