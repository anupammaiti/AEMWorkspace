<%--
  Copyright 1997-2011 Day Management AG
  Barfuesserplatz 6, 4001 Basel, Switzerland
  All Rights Reserved.

  This software is the confidential and proprietary information of
  Day Management AG, ("Confidential Information"). You shall not
  disclose such Confidential Information and shall use it only in
  accordance with the terms of the license agreement you entered into
  with Day.
  --%><%
%><%@include file="/libs/foundation/global.jsp"%><%
%><%@page session="false" import="com.day.cq.wcm.foundation.forms.FormsHelper,
                                  com.day.cq.wcm.foundation.forms.LayoutHelper,
 	  	                          java.util.ResourceBundle,
 	  	                          java.util.Locale" %><%
    final Locale pageLocale = currentPage.getLanguage(true);
    final ResourceBundle bundle = slingRequest.getResourceBundle(pageLocale);
    final String name = FormsHelper.getParameterName(resource);
    final String id = FormsHelper.getFieldId(slingRequest, resource);
    final String title = FormsHelper.getTitle(resource, bundle.getString("Account Name"));
    final boolean hideTitle = properties.get("hideTitle", false);
    final boolean required = FormsHelper.isRequired(resource);
    final String width = properties.get("width", String.class);
    final String cols = properties.get("cols", String.class);
    final String uid = request.getParameter("uid") == null ? null : slingRequest.getRequestParameter("uid").getString();

    %><div class="form_row">
        <% LayoutHelper.printTitle(id, title, required, hideTitle, out); %>
        <div class="form_rightcol">
            <input class="geo textinput" <%
                %>id="<%= xssAPI.encodeForHTMLAttr(id) %>" <%
                %>name="<%= xssAPI.encodeForHTMLAttr(name) %>" <%
                if (uid == null) {
                    %>value="" <%
                } else {
                    %>readonly="readonly" <%
                    %>value="<%= xssAPI.encodeForHTMLAttr(uid) %>" <%
                }
                %>type="text" <%
                %>size="<%= xssAPI.getValidInteger(cols, 35) %>" <%
                if (width != null) {
                    %>style="width:<%= xssAPI.getValidInteger(width, 100) %>px;" <%
                }
            %>>
        </div>
    </div><%

    LayoutHelper.printDescription(FormsHelper.getDescription(resource, ""), out);
    LayoutHelper.printErrors(slingRequest, name, out);
%>
