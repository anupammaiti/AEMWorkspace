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
--%>
<%@page session="false" %>
<%@page import="com.day.cq.wcm.foundation.forms.FieldDescription,
                com.day.cq.wcm.foundation.forms.FieldHelper,
                com.day.cq.wcm.foundation.forms.FormsHelper,
                org.apache.commons.lang3.StringEscapeUtils"%>
<%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %>
<sling:defineObjects/>
<%
    final FieldDescription desc = FieldHelper.getConstraintFieldDescription(slingRequest);
    final String clientFieldQualifier = FieldHelper.getClientFieldQualifier(slingRequest, desc);
    final String formId = FormsHelper.getFormId(slingRequest);
    final String requiredMsg = desc.getConstraintMessage();
%>
var creditCardNumberValue = <%= clientFieldQualifier %>.value;
var creditCardNumber = parseInt(creditCardNumberValue, 10);
if (isNaN(creditCardNumber) || !luhn.validate(creditCardNumber)) {
    cq5forms_showMsg(
        '<%= StringEscapeUtils.escapeEcmaScript(formId) %>',
        '<%= StringEscapeUtils.escapeEcmaScript(desc.getName()) %>',
        '<%= StringEscapeUtils.escapeEcmaScript(requiredMsg) %>'
    );
    return false;
};
