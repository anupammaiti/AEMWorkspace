<%--
  Copyright 1997-2010 Day Management AG
  Barfuesserplatz 6, 4001 Basel, Switzerland
  All Rights Reserved.

  This software is the confidential and proprietary information of
  Day Management AG, ("Confidential Information"). You shall not
  disclose such Confidential Information and shall use it only in
  accordance with the terms of the license agreement you entered into
  with Day.

  ==============================================================================

  Form 'element' component

  Initialize this field.

--%><%@page session="false" %><%
%><%@page import="com.day.cq.wcm.foundation.forms.FieldDescription,
                  com.day.cq.wcm.foundation.forms.FieldHelper"%><%
%><%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %><%
%><sling:defineObjects/><%
    final FieldDescription defaultDesc = FieldHelper.createDefaultDescription(slingRequest, resource);
    final FieldDescription desc = new FieldDescription(resource, defaultDesc.getName() + "@Delete");
    desc.setPrivateField(true);
    FieldHelper.addDescription(slingRequest, desc);
%>
