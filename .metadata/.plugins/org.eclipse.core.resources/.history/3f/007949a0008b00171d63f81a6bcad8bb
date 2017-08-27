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

  Form 'action' component
  Handles requests to update the

--%><%@page session="false" %><%
%><%@page import="org.apache.sling.api.SlingHttpServletRequest"%><%
%><%@page import="org.apache.sling.api.request.RequestParameterMap" %><%
%><%@page import="com.day.cq.wcm.foundation.forms.FormsHelper"%><%

final SlingHttpServletRequest slingRequest = (SlingHttpServletRequest) request;    
final RequestParameterMap paras = slingRequest.getRequestParameterMap();
if (paras.containsKey(":profile")) {
    final String path = paras.getValue(":profile").getString();
    if (path.length()>0) {
        FormsHelper.setForwardPath(slingRequest, path, true);
    }
}
%>