<%--

  ADOBE CONFIDENTIAL
  __________________

   Copyright 2012 Adobe Systems Incorporated
   All Rights Reserved.

  NOTICE:  All information contained herein is, and remains
  the property of Adobe Systems Incorporated and its suppliers,
  if any.  The intellectual and technical concepts contained
  herein are proprietary to Adobe Systems Incorporated and its
  suppliers and are protected by trade secret or copyright law.
  Dissemination of this information or reproduction of this material
  is strictly forbidden unless prior written permission is obtained
  from Adobe Systems Incorporated.

  ==============================================================================

  Form Address component.

  Validate the element on the server.

  ==============================================================================

--%><%@page session="false" %><%
%><%@page import="com.day.cq.wcm.foundation.forms.FieldHelper,
                  com.day.cq.wcm.foundation.forms.FieldDescription"%><%
%><%@taglib prefix="cq" uri="http://www.day.com/taglibs/cq/1.0" %><%
%><cq:defineObjects/><%
    FieldDescription[] descs = FieldHelper.getFieldDescriptions(slingRequest, resource);

    // Addresses with a show/hide expression will be empty when hidden.  However,
    // the author may wish to make some fields *within* the address required when
    // they are *not* hidden.
    //
    // So... require address fields with show/hide logic to be *either* completely
    // empty, or to meet the normal constraints.
    //
    if (properties.get("showHideExpression", "").length() > 0) {
        boolean entirelyEmpty = true;
        for (final FieldDescription desc : descs) {
            if (request.getParameterValues(desc.getName()) != null) {
                entirelyEmpty = false;
            }
        }
        if (entirelyEmpty) {
            return;
        }
    }

    for (final FieldDescription desc : descs) {
        if (FieldHelper.checkRequired(slingRequest, desc)) {
            FieldHelper.checkConstraint(slingRequest, slingResponse, desc);
        }
    }
%>