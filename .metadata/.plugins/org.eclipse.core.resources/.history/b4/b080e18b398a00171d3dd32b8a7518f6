<%@page session="false"%><%--

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

  Initializes the field descriptions for later use by the validation &
   constraint logic.

  ==============================================================================

--%><%@include file="/libs/foundation/global.jsp"%><%
%><%@ page import="com.day.cq.wcm.foundation.forms.FieldDescription,
                   com.day.cq.wcm.foundation.forms.FieldHelper,
                   com.day.cq.wcm.foundation.forms.FormsHelper,
                   org.apache.commons.lang.StringUtils,
                   com.day.cq.wcm.foundation.forms.FormsConstants,
                   java.util.Locale, java.util.ResourceBundle,
                   com.day.cq.i18n.I18n" %><%
    final Locale pageLocale = currentPage.getLanguage(true);
    final ResourceBundle bundle = slingRequest.getResourceBundle(pageLocale);
    I18n i18n = new I18n(bundle);

    final String name = FormsHelper.getParameterName(resource);
    String required = StringUtils.join(properties.get(FormsConstants.ELEMENT_PROPERTY_REQUIRED, String[].class), ",");
    if (required == null) {
        required = "";
    }
    String title = FormsHelper.getTitle(resource, "");
    if (title.length() > 0) {
        title += " ";
    }

    FieldDescription desc = new FieldDescription(resource, name + ".firstname");
    desc.setRequired(required.contains("firstname"));
    desc.setRequiredMessage(properties.get(FormsConstants.ELEMENT_PROPERTY_REQUIRED_MSG, title + i18n.get("First Name is required.")));
    FieldHelper.addDescription(slingRequest, desc);

    desc = new FieldDescription(resource, name + ".lastname");
    desc.setRequired(required.contains("lastname"));
    desc.setRequiredMessage(properties.get(FormsConstants.ELEMENT_PROPERTY_REQUIRED_MSG, title + i18n.get("Last Name is required.")));
    FieldHelper.addDescription(slingRequest, desc);

    desc = new FieldDescription(resource, name + ".street1");
    desc.setRequired(required.contains("street1"));
    desc.setRequiredMessage(properties.get(FormsConstants.ELEMENT_PROPERTY_REQUIRED_MSG, title + i18n.get("Street Address 1 is required.")));
    FieldHelper.addDescription(slingRequest, desc);

    desc = new FieldDescription(resource, name + ".street2");
    desc.setRequired(required.contains("street2"));
    desc.setRequiredMessage(properties.get(FormsConstants.ELEMENT_PROPERTY_REQUIRED_MSG, title + i18n.get("Street Address 2 is required.")));
    FieldHelper.addDescription(slingRequest, desc);

    desc = new FieldDescription(resource, name + ".city");
    desc.setRequired(required.contains("city"));
    desc.setRequiredMessage(properties.get(FormsConstants.ELEMENT_PROPERTY_REQUIRED_MSG, title + i18n.get("City is required.")));
    FieldHelper.addDescription(slingRequest, desc);

    desc = new FieldDescription(resource, name + ".state");
    desc.setRequired(required.contains("state"));
    desc.setRequiredMessage(properties.get(FormsConstants.ELEMENT_PROPERTY_REQUIRED_MSG, title + i18n.get("State / Province is required.")));
    FieldHelper.addDescription(slingRequest, desc);

    desc = new FieldDescription(resource, name + ".zip");
    desc.setRequired(required.contains("zip"));
    desc.setRequiredMessage(properties.get(FormsConstants.ELEMENT_PROPERTY_REQUIRED_MSG, title + i18n.get("Postal / Zip Code is required.")));
    FieldHelper.addDescription(slingRequest, desc);

    desc = new FieldDescription(resource, name + ".country");
    desc.setRequired(required.contains("country"));
    desc.setRequiredMessage(properties.get(FormsConstants.ELEMENT_PROPERTY_REQUIRED_MSG, title + i18n.get("Country is required.")));
    FieldHelper.addDescription(slingRequest, desc);
%>
