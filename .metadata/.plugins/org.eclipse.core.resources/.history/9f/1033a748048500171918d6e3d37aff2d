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

  Initializes the resource(s) to be edited by the form

--%><%
%><%@ page session="false" %><%
%><%@ page import="java.util.List,
                   org.apache.sling.api.resource.Resource,
                   com.day.cq.wcm.foundation.forms.FormResourceEdit,
                   com.day.cq.wcm.foundation.forms.FormsHelper" %><%
%><%@ taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %><%
%><sling:defineObjects/><%

    List<Resource> resources = FormResourceEdit.getResources(slingRequest);
    if (resources != null) {
        if (resources.size() == 1) {
            // single resource
            FormsHelper.setFormLoadResource(slingRequest, resources.get(0));
        } else if (resources.size() > 1) {
            // multiple resources
            FormsHelper.setFormLoadResource(slingRequest, FormResourceEdit.getMergedResource(resources));
        }
    }
%>