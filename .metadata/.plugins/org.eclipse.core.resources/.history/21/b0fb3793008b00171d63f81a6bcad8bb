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
%><%@ page import="org.apache.jackrabbit.util.Text,
        com.day.cq.wcm.foundation.forms.FormsHelper,
        com.day.cq.wcm.foundation.forms.LayoutHelper,
        java.util.Locale,
		java.util.ResourceBundle,
		com.day.cq.i18n.I18n" %><%

	final Locale pageLocale = currentPage.getLanguage(true);
	final ResourceBundle resourceBundle = slingRequest.getResourceBundle(pageLocale);
	I18n i18n = new I18n(resourceBundle);  
		
    final String name = properties.get("name", "Submit");
    final String title = FormsHelper.getTitle(resource, i18n.get("Submit"));
    final String width = properties.get("width", "");
    final String css = FormsHelper.getCss(properties, "form_button_submit");
%>
    <div class="form_row">
      <% LayoutHelper.printTitle(null, null, false, out); %>
      <div class="form_rightcol">
        <%
        boolean clientValidation = FormsHelper.doClientValidation(slingRequest);
        out.write("<input type=\"" + (clientValidation ? "button" : "submit") + "\" class=\"");
        out.write(css);
        out.write("\"");
        if ( name.length() > 0 ) {
            out.write(" name=\"");
            out.write(Text.encodeIllegalXMLCharacters(name));
            out.write("\"");
        }
        if ( title.length() > 0 ) {
            out.write(" value=\"");
            out.write(Text.encodeIllegalXMLCharacters(title));
            out.write("\"");
        }
        if (clientValidation) {
            out.write(" onclick=\"if (");
            out.write(FormsHelper.getFormsPreCheckMethodName(slingRequest));
            out.write("('");
            if ( name.length() > 0 ) {
                out.write(name);
            }
            out.write("')) { document.forms['");
            out.write(FormsHelper.getFormId(slingRequest));
            out.write("'].submit();} else return false;\"");
        }

        if(width.length()>0) {
            out.write(" style=\"width:");
            out.write(width);
            out.write("px;\"");
        }

        out.write(">");
        %>
      </div>
    </div>
    <% LayoutHelper.printDescription(FormsHelper.getDescription(resource, ""), out); %>
