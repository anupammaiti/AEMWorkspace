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

  Form 'action' component

  Called after the form start to add action-specific fields

--%><%
%><%@ page session="false" %><%
%><%@ page import="java.util.List,
                   org.apache.commons.lang3.StringEscapeUtils,
                   org.apache.sling.api.resource.Resource,
                   com.day.cq.wcm.foundation.forms.FormsConstants,
                   com.day.cq.wcm.foundation.forms.FormResourceEdit" %><%
%><%@ taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %><%
%><sling:defineObjects/><%

    List<Resource> resources = FormResourceEdit.getResources(slingRequest);
    if (resources != null) {
        for (Resource r : resources) { %>
<input type="hidden" name="<%= FormResourceEdit.RESOURCES_PARAM %>" value="<%= StringEscapeUtils.escapeHtml4(r.getPath()) %>"><%
        }
    }

    String redirectTo = slingRequest.getParameter("redirectTo");
    if (redirectTo != null) { %>
<input type="hidden" name="<%= FormsConstants.REQUEST_PROPERTY_REDIRECT %>" value="<%= StringEscapeUtils.escapeHtml4(redirectTo) %>">
<%
    }
%>
