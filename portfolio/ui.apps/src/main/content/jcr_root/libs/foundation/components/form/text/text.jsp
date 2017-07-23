<%@page session="false"%><%--
  Copyright 1997-2011 Day Management AG
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
%><%@ page import="com.day.cq.wcm.foundation.TextFormat,
                   com.day.cq.wcm.foundation.forms.FormsHelper,
                   com.day.cq.wcm.foundation.forms.LayoutHelper,
                   com.day.cq.wcm.foundation.forms.FormResourceEdit,
				   java.util.ResourceBundle,
				   com.day.cq.i18n.I18n" %><%

	final ResourceBundle resourceBundle = slingRequest.getResourceBundle(null);
	I18n i18n = new I18n(resourceBundle);  
					
    final String name = FormsHelper.getParameterName(resource);
    final String id = FormsHelper.getFieldId(slingRequest, resource);
    final boolean required = FormsHelper.isRequired(resource);
    final boolean readOnly = FormsHelper.isReadOnly(slingRequest, resource);
    final boolean multiValued = properties.get("multivalue", false);
    final boolean hideTitle = properties.get("hideTitle", false);
    final String width = properties.get("width", String.class);
    final int rows = xssAPI.getValidInteger(properties.get("rows", String.class), 1);
    final int cols = xssAPI.getValidInteger(properties.get("cols", String.class), 35);
    String[] values = FormsHelper.getValues(slingRequest, resource);
    if (values == null) {
        values = new String[]{""};
    }

    String title = i18n.getVar(FormsHelper.getTitle(resource, "Text"));

    if (multiValued && !readOnly) {
        %><%@include file="multivalue.jsp"%><%
    }

    boolean multiRes = FormResourceEdit.isMultiResource(slingRequest);
    String mrName = name + FormResourceEdit.WRITE_SUFFIX;
    String mrChangeHandler = multiRes ? "cq5forms_multiResourceChange(event, '" + xssAPI.encodeForJSString(mrName) + "');" : "";
    String forceMrChangeHandler = multiRes ? "cq5forms_multiResourceChange(event, '" + xssAPI.encodeForJSString(mrName) + "', true);" : "";

    %><div class="form_row">
        <% LayoutHelper.printTitle(id, title, required, hideTitle, out); %>
        <div class="form_rightcol" id="<%= xssAPI.encodeForHTMLAttr(name) %>_rightcol"><%
            int i = 0;
            for (String value : values) {
                %><div id="<%= xssAPI.encodeForHTMLAttr(name) %>_<%= i %>_wrapper" class="form_rightcol_wrapper"><%
                if (readOnly) {
                    if (value.length() == 0) {
                        // at least display a space otherwise layout may break
                        value = " ";
                    }
                    %><%= new TextFormat().format(value) %><%
                } else {
                    String currentId = i == 0 ? id : id + "-" + i;
                    if (rows == 1) {
                        %><input class="<%= FormsHelper.getCss(properties, "form_field form_field_text" + (multiValued ? " form_field_multivalued" : "" )) %>" <%
                            %>id="<%= xssAPI.encodeForHTMLAttr(currentId) %>" <%
                            %>name="<%= xssAPI.encodeForHTMLAttr(name) %>" <%
                            %>value="<%= xssAPI.encodeForHTMLAttr(value) %>" <%
                            %>size="<%= cols %>" <%
                            if (width != null) {
                                %>style="width:<%= xssAPI.getValidInteger(width, 100) %>px;" <%
                            }
                            %>onkeydown="<%= mrChangeHandler %>" ><%
                    } else {
                        %><textarea class="<%= FormsHelper.getCss(properties, "form_field form_field_textarea") %>" <%
                            %>id="<%= xssAPI.encodeForHTMLAttr(currentId) %>" <%
                            %>name="<%= xssAPI.encodeForHTMLAttr(name) %>" <%
                            %>rows="<%= rows %>" cols="<%= cols %>" <%
                            if (width != null) {
                                %>style="width:<%= xssAPI.getValidInteger(width, 100) %>px;" <%
                            }
                            %>onkeydown="<%= mrChangeHandler %>" ><%= xssAPI.encodeForHTML(value) %></textarea><%
                    }
                    if (values.length > 1) {
                        %><span class="form_mv_remove" onclick="CQ_form_removeMultivalue('<%= xssAPI.encodeForJSString(name) %>', <%= i %>);<%= forceMrChangeHandler %>">&nbsp;[&ndash;]</span><%
                    }
                    if (i == 0 && multiRes) {
                        %><span class="mr_write"><input type="checkbox" <%
                                                    %>name="<%= xssAPI.encodeForHTMLAttr(mrName) %>" <%
                                                    %>id="<%= xssAPI.encodeForHTMLAttr(mrName) %>" <%
                                                    %>value="true" <%
                                                    if (request.getParameter(mrName) != null) {
                                                        %>checked="checked" <%
                                                    }
                                                    %>></span><%
                    }
                }
                i++;
                %></div><%
            }
        %></div><%
        if (multiValued && !readOnly) {
            %><span class="form_mv_add" onclick="CQ_form_addMultivalue('<%= xssAPI.encodeForJSString(name) %>', <%= rows %>, <%= width == null ? "null" : "'" + xssAPI.getValidInteger(width, 100) + "'" %>);<%= forceMrChangeHandler %>">[+]</span><%
        }
    %></div><%

    LayoutHelper.printDescription(FormsHelper.getDescription(resource, ""), out);
    boolean errorPrinted = false;
    for (int j = 0; j < values.length; j++) {
        // constraints (e.g. "number") are checked per field (multiple fields when multi value)
        errorPrinted = LayoutHelper.printErrors(slingRequest, name, out, j);
        if (errorPrinted) break;
    }
    if (!errorPrinted) {
        // check mandatory and single values constraints
        LayoutHelper.printErrors(slingRequest, name, out);
    }
%>
