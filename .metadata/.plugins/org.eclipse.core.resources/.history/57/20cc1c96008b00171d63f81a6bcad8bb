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
        com.day.cq.wcm.foundation.forms.LayoutHelper" %><%
    final String name = FormsHelper.getParameterName(resource);
    final String id = FormsHelper.getFieldId(slingRequest, resource);
    final String title = FormsHelper.getTitle(resource, "");
    final boolean hideTitle = properties.get("hideTitle", false);

    final String width = properties.get("width", "");
    final String src = properties.get("src", "");
    final String css = FormsHelper.getCss(properties, "form_button");
%>
    <div class="form_row">
      <% LayoutHelper.printTitle(id, title, false, hideTitle, out); %>
      <div class="form_rightcol form_rightcolnooverflow">
        <%
        out.write("<input type=\"image\" class=\"");
        out.write(css);
        out.write("\"");
        if ( name.length() > 0 ) {
            out.write(" name=\"");
            out.write(Text.encodeIllegalXMLCharacters(name));
            out.write("\"");
        }
        if ( src.length() > 0 ) {
            out.write(" src=\"");
            out.write(xssAPI.getValidHref(src));
            out.write("\"");
        }
        if ( title.length() > 0 ) {
            out.write(" alt=\"");
            out.write(Text.encodeIllegalXMLCharacters(title));
            out.write("\"");
        }
        if ( FormsHelper.doClientValidation(slingRequest) ) {
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

        if (width.length() > 0) {
            out.write(" style=\"width:");
            out.write(xssAPI.encodeForHTMLAttr(width));
            out.write("px;\"");
        }
        out.write(">");
        %>
          </div>
        </div>
      <%
      LayoutHelper.printDescription(FormsHelper.getDescription(resource, ""), out);
      LayoutHelper.printErrors(slingRequest, name, out);
%>
