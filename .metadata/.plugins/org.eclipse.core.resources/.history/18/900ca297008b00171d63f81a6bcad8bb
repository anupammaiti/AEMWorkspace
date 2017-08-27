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

  An example compound form component which renders a somewhat US-centric
  address block.

  ==============================================================================

--%><%@include file="/libs/foundation/global.jsp"%><%
%><%@ page import="com.day.cq.i18n.I18n,
        com.day.cq.wcm.foundation.forms.FormsHelper,
        com.day.cq.wcm.foundation.forms.LayoutHelper,
        java.util.Locale,
		java.util.ArrayList,
		java.util.List,
		java.util.ResourceBundle,
		org.apache.commons.lang.StringUtils,
		com.day.cq.wcm.foundation.forms.FormsConstants,
		com.adobe.cq.commerce.api.CommerceService,
		com.adobe.cq.commerce.api.CommerceConstants" %><%

    final Locale pageLocale = currentPage.getLanguage(true);
    final ResourceBundle bundle = slingRequest.getResourceBundle(pageLocale);
    I18n i18n = new I18n(bundle);

    final String name = FormsHelper.getParameterName(resource);
    final String id = FormsHelper.getFieldId(slingRequest, resource);

    String required = StringUtils.join(properties.get(FormsConstants.ELEMENT_PROPERTY_REQUIRED, String[].class), ",");
    if (required == null) {
        required = "";
    }

    final boolean readOnly = FormsHelper.isReadOnly(slingRequest, resource);
    final boolean hideTitle = properties.get("hideTitle", false);
    final String title = FormsHelper.getTitle(resource, i18n.get("Address"));
    final boolean applyCommerceCountryFilter = properties.get("applyCommerceCountryFilter", false);

    final String firstName = FormsHelper.getValue(slingRequest, resource, name + ".firstname");
    final String lastName = FormsHelper.getValue(slingRequest, resource, name + ".lastname");
    final String street1 = FormsHelper.getValue(slingRequest, resource, name + ".street1");
    final String street2 = FormsHelper.getValue(slingRequest, resource, name + ".street2");
    final String city = FormsHelper.getValue(slingRequest, resource, name + ".city");
    final String state = FormsHelper.getValue(slingRequest, resource, name + ".state");
    final String zip = FormsHelper.getValue(slingRequest, resource, name + ".zip");
    final String country = FormsHelper.getValue(slingRequest, resource, name + ".country");

%><cq:include script="countries.jsp"/><%
    List<String> countryList = (List<String>) request.getAttribute(CommerceConstants.REQ_ATTR_COUNTRYLIST);

    if (applyCommerceCountryFilter) {
        CommerceService commerceService = resource.adaptTo(CommerceService.class);
        List<String> filter = commerceService.getCountries();
        List<String> unfilteredList = new ArrayList<String>(countryList);
        countryList = new ArrayList<String>();
        for (String countryRecord : unfilteredList) {
            String[] parts = countryRecord.split("=");
            for (String isocode : filter) {
                if (isocode.equals("*") || isocode.equalsIgnoreCase(parts[0])) {
                    countryList.add(countryRecord);
                }
            }
        }
    }

%>
<div class="form_row">
    <% LayoutHelper.printTitle(id, title, false, hideTitle, out); %>
</div> <%

    if (readOnly) {
        String countryValue = " ";
        for (String countryRecord : countryList) {
            String[] parts = countryRecord.split("=");
            if (parts.length == 2 && parts[0].equalsIgnoreCase(country)) {
                countryValue = parts[1];
                break;
            }
        }
%>
<div class="form_row">
    <div class="form_rightcol">
        <%= xssAPI.encodeForHTML(firstName != null ? firstName : " ") %> <%= xssAPI.encodeForHTML(lastName != null ? lastName : " ") %>
    </div>
    <div class="form_rightcol">
        <%= xssAPI.encodeForHTML(street1 != null ? street1 : " ") %>
    </div>
    <div class="form_rightcol">
        <%= xssAPI.encodeForHTML(street2 != null ? street2 : " ") %>
    </div>
    <div class="form_rightcol">
        <%= xssAPI.encodeForHTML(city != null ? city : " ") %>
    </div>
    <div class="form_rightcol">
        <%= xssAPI.encodeForHTML(state != null ? state : " ") %> <%= xssAPI.encodeForHTML(zip != null ? zip : " ") %>
    </div>
    <div class="form_rightcol">
        <%= xssAPI.encodeForHTML(countryValue) %>
    </div>
</div> <%

} else {
%>
<div class="form_row">
    <div class="form_rightcol"><%
        LayoutHelper.printDescription(id + "-firstname", bundle.getString("First Name"), out);
        LayoutHelper.printErrors(slingRequest, name + ".firstname", hideTitle, out); %>
        <input class="<%= FormsHelper.getCss(properties, "form_field form_field_text form_address_firstname") %>"
               id="<%= xssAPI.encodeForHTMLAttr(id + "-firstname") %>"
               name="<%= xssAPI.encodeForHTMLAttr(name + ".firstname") %>"
               value="<c:out value="<%= firstName != null ? firstName : "" %>"/>"
               size="16">
        <span class="form_rightcolmark"><%=required.contains("firstname") ? " *" : "&nbsp;" %></span>
    </div>
</div>
<div class="form_row">
    <div class="form_rightcol"><%
        LayoutHelper.printDescription(id + "-lastname", bundle.getString("Last Name"), out);
        LayoutHelper.printErrors(slingRequest, name + ".lastname", hideTitle, out); %>
        <input class="<%= FormsHelper.getCss(properties, "form_field form_field_text form_address_lastname") %>"
               id="<%= xssAPI.encodeForHTMLAttr(id + "-lastname") %>"
               name="<%= xssAPI.encodeForHTMLAttr(name + ".lastname") %>"
               value="<c:out value="<%= lastName != null ? lastName : "" %>"/>"
               size="16">
        <span class="form_rightcolmark"><%=required.contains("lastname") ? " *" : "&nbsp;" %></span>
    </div>
</div>
<div class="form_row">
    <div class="form_rightcol"><%
        LayoutHelper.printDescription(id + "-street1", bundle.getString("Street Address 1"), out);
        LayoutHelper.printErrors(slingRequest, name + ".street1", hideTitle, out); %>
        <input class="<%= FormsHelper.getCss(properties, "form_field form_field_text form_address_street1") %>"
               id="<%= xssAPI.encodeForHTMLAttr(id + "-street1") %>"
               name="<%= xssAPI.encodeForHTMLAttr(name + ".street1") %>"
               value="<c:out value="<%= street1 != null ? street1 : "" %>"/>" >
        <span class="form_rightcolmark"><%= required.contains("street1") ? " *" : "&nbsp;" %></span>
    </div>
</div>
<div class="form_row">
    <div class="form_rightcol"><%
        LayoutHelper.printDescription(id + "-street2", bundle.getString("Street Address 2"), out);
        LayoutHelper.printErrors(slingRequest, name + ".street2", hideTitle, out); %>
        <input class="<%= FormsHelper.getCss(properties, "form_field form_field_text form_address_street2") %>"
               id="<%= xssAPI.encodeForHTMLAttr(id + "-street2") %>"
               name="<%= xssAPI.encodeForHTMLAttr(name + ".street2") %>"
               value="<c:out value="<%= street2 != null ? street2 : "" %>"/>" >
        <span class="form_rightcolmark"><%=required.contains("street2") ? " *" : "&nbsp;" %></span>
    </div>
</div>
<div class="form_row">
    <div class="form_rightcol"><%
        LayoutHelper.printDescription(id + "-city", bundle.getString("City"), out);
        LayoutHelper.printErrors(slingRequest, name + ".city", hideTitle, out); %>
        <input class="<%= FormsHelper.getCss(properties, "form_field form_field_text form_address_city") %>"
               id="<%= xssAPI.encodeForHTMLAttr(id + "-city") %>"
               name="<%= xssAPI.encodeForHTMLAttr(name + ".city") %>"
               value="<c:out value="<%= city != null ? city : "" %>"/>" >
        <span class="form_rightcolmark"><%=required.contains("city") ? " *" : "&nbsp;" %></span>
    </div>
</div>
<div class="form_row">
    <div class="form_rightcol">
        <div class="form_address_state"><%
            LayoutHelper.printDescription(id + "-state", bundle.getString("State / Province"), out);
            LayoutHelper.printErrors(slingRequest, name + ".state", hideTitle, out); %>
            <input class="<%= FormsHelper.getCss(properties, "form_field form_field_text form_address_state") %>"
                   id="<%= xssAPI.encodeForHTMLAttr(id + "-state") %>"
                   name="<%= xssAPI.encodeForHTMLAttr(name + ".state") %>"
                   value="<c:out value="<%= state != null ? state : "" %>"/>" >
            <span class="form_rightcolmark"><%=required.contains("state") ? " *" : "&nbsp;" %></span>
        </div>
        <div class="form_address_zip"><%
            LayoutHelper.printDescription(id + "-zip", bundle.getString("Postal / Zip Code"), out);
            LayoutHelper.printErrors(slingRequest, name + ".zip", hideTitle, out); %>
            <input class="<%= FormsHelper.getCss(properties, "form_field form_field_text form_address_zip") %>"
                   id="<%= xssAPI.encodeForHTMLAttr(id + "-zip") %>"
                   name="<%= xssAPI.encodeForHTMLAttr(name + ".zip") %>"
                   value="<c:out value="<%= zip != null ? zip : "" %>"/>" >
            <span class="form_rightcolmark"><%=required.contains("zip") ? " *" : "&nbsp;" %></span>
        </div>
    </div>
</div>
<div class="form_row">
    <div class="form_rightcol"><%
        LayoutHelper.printDescription(id + "-country", bundle.getString("Country"), out);
        LayoutHelper.printErrors(slingRequest, name + ".country", hideTitle, out); %>
        <select class="<%= FormsHelper.getCss(properties, "form_field form_field_select form_address_country") %>"
                id="<%= xssAPI.encodeForHTMLAttr(id + "-country") %>"
                name="<%= xssAPI.encodeForHTMLAttr(name + ".country") %>"><%
            for (String countryRecord : countryList) {
                String[] parts = countryRecord.split("=");
                if (parts.length == 2) {
                    if (parts[0].equalsIgnoreCase(country)) {
        %><option value="<%= xssAPI.encodeForHTMLAttr(parts[0]) %>" selected><%= xssAPI.encodeForHTML(parts[1]) %></option><%
        } else {
        %><option value="<%= xssAPI.encodeForHTMLAttr(parts[0]) %>"><%= xssAPI.encodeForHTML(parts[1]) %></option><%
                    }
                }
            }%>
        </select>
        <span class="form_rightcolmark"><%=required.contains("country") ? " *" : "&nbsp;" %></span>
    </div>
</div> <%

    }
    LayoutHelper.printDescription(FormsHelper.getDescription(resource, ""), out);
    LayoutHelper.printErrors(slingRequest, name, hideTitle, out);
%>
