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

    FieldDescription desc = new FieldDescription(resource, name + ".credit-card-type");
    desc.setRequired(required.contains("credit-card-type"));
    desc.setRequiredMessage(properties.get(FormsConstants.ELEMENT_PROPERTY_REQUIRED_MSG, title + i18n.get("Credit Card Type is required.")));
    FieldHelper.addDescription(slingRequest, desc);

    desc = new FieldDescription(resource, name + ".primary-account-number");
    desc.setRequired(required.contains("primary-account-number"));
    desc.setRequiredMessage(properties.get(FormsConstants.ELEMENT_PROPERTY_REQUIRED_MSG, title + i18n.get("Credit Card Number is required.")));
    desc.setConstraintType("foundation/components/form/constraints/luhn");
    desc.setConstraintMessage(title + i18n.get("The Credit Card Number is invalid. Please check that you introduced the correct Credit Card Number."));
    FieldHelper.addDescription(slingRequest, desc);

    desc = new FieldDescription(resource, name + ".name-on-card");
    desc.setRequired(required.contains("name-on-card"));
    desc.setRequiredMessage(properties.get(FormsConstants.ELEMENT_PROPERTY_REQUIRED_MSG, title + i18n.get("Name on Card is required.")));
    FieldHelper.addDescription(slingRequest, desc);

    desc = new FieldDescription(resource, name + ".expiration-date-month");
    desc.setRequired(required.contains("expiration-date"));
    desc.setRequiredMessage(properties.get(FormsConstants.ELEMENT_PROPERTY_REQUIRED_MSG, title + i18n.get("Expiration Month is required.")));
    desc.setConstraintType("foundation/components/form/constraints/datenumericmonth");
    desc.setConstraintMessage(title + i18n.get("The Expiration Month is invalid."));
    FieldHelper.addDescription(slingRequest, desc);

    desc = new FieldDescription(resource, name + ".expiration-date-year");
    desc.setRequired(required.contains("expiration-date"));
    desc.setRequiredMessage(properties.get(FormsConstants.ELEMENT_PROPERTY_REQUIRED_MSG, title + i18n.get("Expiration Year is required.")));
    desc.setConstraintType("foundation/components/form/constraints/dateyear");
    desc.setConstraintMessage(title + i18n.get("The Expiration Year is invalid."));
    FieldHelper.addDescription(slingRequest, desc);

    final boolean showCCV = properties.get("showCCV", true);

    if (showCCV) {
        desc = new FieldDescription(resource, name + ".ccv");
        desc.setRequired(required.contains("ccv"));
        desc.setRequiredMessage(properties.get(FormsConstants.ELEMENT_PROPERTY_REQUIRED_MSG, title + i18n.get("Security Code is required.")));
        desc.setConstraintType("foundation/components/form/constraints/ccv");
        desc.setConstraintMessage(title + i18n.get("The Security Code is invalid."));
        FieldHelper.addDescription(slingRequest, desc);
    }
%>
