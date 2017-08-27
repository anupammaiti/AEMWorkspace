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
		java.util.ResourceBundle" %><%
    final Locale pageLocale = currentPage.getLanguage(true);
    final ResourceBundle bundle = slingRequest.getResourceBundle(pageLocale);
    final String name = FormsHelper.getParameterName(resource);
    final String id = FormsHelper.getFieldId(slingRequest, resource);
    final boolean required = FormsHelper.isRequired(resource);
    final boolean hideTitle = properties.get("hideTitle", false);
    final String width = properties.get("width", "");

    final String title = FormsHelper.getTitle(resource, bundle.getString("Upload"));
    %><div class="form_row">
        <% LayoutHelper.printTitle(id, title, required, hideTitle, out); %>
        <div class="form_rightcol"><input id="<%=id %>" <%
                                    %>class="<%= FormsHelper.getCss(properties, "form_field form_field_file") %>" <%
                                    %>name="<%= xssAPI.encodeForHTMLAttr(name) %>" <%
                                    %>type="file" <%
                                    %>size="37" <%
                                    if (width.length() > 0) {
                                        %>style="width:<%= xssAPI.getValidInteger(width, 100) %>px;"<%
                                    }
        %>></div>
    </div><%
    LayoutHelper.printDescription(FormsHelper.getDescription(resource, ""), out);
    LayoutHelper.printErrors(slingRequest, name, hideTitle, out);
%>
