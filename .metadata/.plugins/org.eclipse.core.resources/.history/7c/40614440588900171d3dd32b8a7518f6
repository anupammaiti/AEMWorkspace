<%@page session="false"%><%--
  Copyright 1997-2009 Day Management AG
  Barfuesserplatz 6, 4001 Basel, Switzerland
  All Rights Reserved.

  This software is the confidential and proprietary information of
  Day Management AG, ("Confidential Information"). You shall not
  disclose such Confidential Information and shall use it only in
  accordance with the terms of the license agreement you entered into
  with Day.

  ==============================================================================

  Form 'element' component

  Draws an link/url field

--%><%@include file="/libs/foundation/global.jsp"%><%
%><%@ page import="com.day.cq.wcm.foundation.forms.FormsHelper,
        com.day.cq.wcm.foundation.forms.LayoutHelper,
        org.apache.jackrabbit.util.Text,
        org.apache.sling.api.SlingHttpServletRequest,
        org.apache.sling.api.resource.ResourceResolver,
        java.net.URI,
        java.net.URISyntaxException,
        com.day.cq.widget.HtmlLibraryManager,
		java.util.ResourceBundle,
		com.day.cq.i18n.I18n" %><%!

    public static String[] makeLink(SlingHttpServletRequest request, String pageOrUrl) {
        String[] linkAndName = new String[2];
        try {
            URI link = new URI(pageOrUrl);
            if (link.isAbsolute()) {
                linkAndName[0] = pageOrUrl;
                linkAndName[1] = pageOrUrl;
            } else {
                ResourceResolver rr = request.getResourceResolver();
                linkAndName[0] = rr.map(request, link.toString()) + ".html";
                PageManager pm = rr.adaptTo(PageManager.class);
                Page page = pm.getPage(pageOrUrl);
                if (page != null) {
                    linkAndName[1] = page.getTitle();
                } else {
                    linkAndName[1] = Text.getName(pageOrUrl);
                }
            }
        } catch (URISyntaxException e) {
            linkAndName[0] = pageOrUrl;
            linkAndName[1] = pageOrUrl;
        }
        return linkAndName;
    }

%><%
    HtmlLibraryManager htmlMgr = sling.getService(HtmlLibraryManager.class);
    if (htmlMgr != null) {
        htmlMgr.writeJsInclude(slingRequest, out, "cq.widgets");
    }

    final ResourceBundle resourceBundle = slingRequest.getResourceBundle(null);
    I18n i18n = new I18n(resourceBundle);

    final String name = FormsHelper.getParameterName(resource);
    final String id = FormsHelper.getFieldId(slingRequest, resource);
    final String title = FormsHelper.getTitle(resource, i18n.get("Link"));
    final boolean hideTitle = properties.get("hideTitle", false);
    final boolean required = FormsHelper.isRequired(resource);
    final boolean readOnly = FormsHelper.isReadOnly(slingRequest, resource);

    final String width = properties.get("width", String.class);
    final String target = properties.get("target", String.class);
    String value = FormsHelper.getValue(slingRequest, resource);
    if (value == null) {
        value = "";
    }

    final long time = System.currentTimeMillis();
%>
<style>
        /* ie7 fix */
    .ext-ie7 .pathfield_wrapper {
        margin-left: -104px;
    }
</style>

<div class="form_row">
    <% LayoutHelper.printTitle(id, title, required, hideTitle, out); %>
    <div class="form_rightcol">
        <%
            if (readOnly) {
                String[] linkAndName = makeLink(slingRequest, value);

                String targetAttr = target != null ? " target=\"" + xssAPI.encodeForHTMLAttr(target) + "\"" : "";
        %>
        <div class="form-readonly"><a href="<%= xssAPI.getValidHref(linkAndName[0]) %>"<%= targetAttr %>><%= xssAPI.filterHTML(linkAndName[1]) %></a></div>
        <%  } else { %>
        <div id="path_<%= time %>_wrapper" class="pathfield_wrapper"></div>

        <script type="text/javascript">
            jQuery(document).ready(function() {

                var pathField = new CQ.form.PathField({
                    "name": "<%= xssAPI.encodeForJSString(name) %>",
                    "renderTo": "path_<%= time %>_wrapper",
                    "hideLabel": true,
                    "width": <%= xssAPI.getValidDimension(width, "\"auto\"") %>
                });
                pathField.setValue("<%= xssAPI.encodeForJSString(value) %>");
            });
        </script>
        <%  } %>
    </div>
</div>
<%
    LayoutHelper.printDescription(FormsHelper.getDescription(resource, ""), out);
    LayoutHelper.printErrors(slingRequest, name, hideTitle, out);
%>
