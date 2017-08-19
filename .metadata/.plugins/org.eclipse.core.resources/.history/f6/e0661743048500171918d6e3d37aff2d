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

  Form 'element' component

  Validate the element on the server.

--%><%@page session="false" %><%
%><%@page import="com.day.cq.wcm.foundation.forms.FieldHelper,
                  com.day.cq.wcm.foundation.forms.FieldDescription"%><%
%><%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %><%
%><sling:defineObjects/><%
    FieldDescription[] descs = FieldHelper.getFieldDescriptions(slingRequest, resource);
    for(final FieldDescription desc : descs) {
        if ( FieldHelper.checkRequired(slingRequest, desc) ) {
            FieldHelper.checkConstraint(slingRequest, slingResponse, desc);
        }        
    }
%>