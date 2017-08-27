<%@page session="false"%><%--
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

  Draws an element of a form

--%><%@include file="/libs/foundation/global.jsp"%><%
%><%@ page import="com.day.cq.wcm.foundation.forms.FormsHelper,
        com.day.cq.wcm.foundation.forms.LayoutHelper,
        java.util.Locale,
		java.util.ResourceBundle,
		com.day.cq.i18n.I18n" %><%
		
	final Locale pageLocale = currentPage.getLanguage(true);
	final ResourceBundle resourceBundle = slingRequest.getResourceBundle(pageLocale);
	I18n i18n = new I18n(resourceBundle);  
		
    final String name = FormsHelper.getParameterName(resource);
    final String id = FormsHelper.getFieldId(slingRequest, resource);
    final boolean required = FormsHelper.isRequired(resource);
    final boolean hideTitle = properties.get("hideTitle", false);
    final String title = FormsHelper.getTitle(resource, i18n.get("Password"));
    final String width = properties.get("width", String.class);
    final String cols = properties.get("cols", String.class);
    String value = FormsHelper.getValue(slingRequest, resource);
    if ( value == null ) {
        value = "";
    }
%>
    <div class="form_row">
      <% LayoutHelper.printTitle(id, title, required, hideTitle, out); %>
      <div class="form_rightcol"><input class="<%= FormsHelper.getCss(properties, "form_field form_field_password") %>" <%
                                    %>id="<%= xssAPI.encodeForHTMLAttr(id) %>" type="password" autocomplete="off" <%
                                    %>name="<%= xssAPI.encodeForHTMLAttr(name) %>" <%
                                    %>value="<%= xssAPI.encodeForHTMLAttr(value) %>" <%
                                    %>size="<%= xssAPI.getValidInteger(cols, 35) %>" <%
                                    if (width != null) {
                                        %>style="width:<%= xssAPI.getValidInteger(width, 100) %>px;" <%
                                    }
                                    %>></div>
    </div>
<%
    LayoutHelper.printDescription(FormsHelper.getDescription(resource, ""), out);
    LayoutHelper.printErrors(slingRequest, name, hideTitle, out);
%>
