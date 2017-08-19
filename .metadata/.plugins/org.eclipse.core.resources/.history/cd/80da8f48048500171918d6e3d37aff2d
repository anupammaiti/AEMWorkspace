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

  Handle POST by forwarding to Sling POST servlet

--%><%
%><%@ page session="false" %><%
%><%@ page import="com.day.cq.wcm.foundation.forms.FormResourceEdit,
                   com.day.cq.wcm.foundation.forms.FormsHelper,
                   org.apache.sling.api.request.RequestDispatcherOptions" %><%
%><%@ taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %><%
%><sling:defineObjects/><%

    if (FormResourceEdit.isSingleResourcePost(slingRequest)) {
        // simply use form forwarding here
        FormsHelper.setForwardPath(slingRequest, FormResourceEdit.getPostResourcePath(slingRequest), true);
    }

    // in case of multiple resources, we let the post.POST.jsp do the job
%>