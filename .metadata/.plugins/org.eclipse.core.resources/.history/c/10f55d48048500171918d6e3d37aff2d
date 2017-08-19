<%--
  Copyright 1997-2011 Day Management AG
  Barfuesserplatz 6, 4001 Basel, Switzerland
  All Rights Reserved.

  This software is the confidential and proprietary information of
  Day Management AG, ("Confidential Information"). You shall not
  disclose such Confidential Information and shall use it only in
  accordance with the terms of the license agreement you entered into
  with Day.

  ==============================================================================

  Form 'action' component

  Handle form POST

--%><%@page session="false" %><%
%><%@page import="java.util.*,
                  org.apache.sling.api.resource.Resource,
                  org.apache.sling.api.request.RequestParameter,
                  com.day.cq.wcm.foundation.forms.FormResourceEdit"%><%
%><%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %><%
%><sling:defineObjects/><%

    // handle multi resource posts
    List<Resource> resources = FormResourceEdit.getPostResources(slingRequest);
    FormResourceEdit.multiPost(resources, slingRequest, slingResponse);
    
%>