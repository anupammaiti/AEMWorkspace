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
  
  Tagging field

--%><%@include file="/libs/foundation/global.jsp"%><%
%><%@ page import="com.day.cq.tagging.Tag,
        com.day.cq.tagging.TagManager,
        com.day.cq.wcm.foundation.forms.FormsConstants,
        com.day.cq.wcm.foundation.forms.FormsHelper,
        com.day.cq.wcm.foundation.forms.LayoutHelper,
        com.day.cq.widget.HtmlLibraryManager,
        org.apache.sling.api.resource.ResourceResolver,
        com.day.cq.i18n.I18n,
		java.util.ResourceBundle" %><%

    HtmlLibraryManager htmlMgr = sling.getService(HtmlLibraryManager.class);
    if (htmlMgr != null) {
        // only include cq widgets here for tagging drop-down window that
        // will be rendered in standard #CQ div and thus requires the
        // normal widgets css
        htmlMgr.writeCssInclude(slingRequest, out, "cq.widgets");
        // the tagging widget CSS is included below in a style tag in
        // its non-#CQ div variant (/libs/foundation/components/form/tags/tags.css)
        
        htmlMgr.writeJsInclude(slingRequest, out, "cq.tagging");
    }

	final ResourceBundle resourceBundle = slingRequest.getResourceBundle(null);
	I18n i18n = new I18n(resourceBundle);  
	
    final long time = System.currentTimeMillis();
    final String name = properties.get(FormsConstants.ELEMENT_PROPERTY_NAME, "./cq:tags");
    final String id = FormsHelper.getFieldId(slingRequest, resource);
    final String title = FormsHelper.getTitle(resource, i18n.get("Tags"));
    
    final String width = properties.get("width", String.class);
    final String popupWidth = properties.get("popupWidth", String.class);
    final String popupHeight = properties.get("popupHeight", String.class);
    final String[] namespaces = properties.get("namespaces", String[].class);
    final boolean required = FormsHelper.isRequired(resource);
    final boolean readOnly = FormsHelper.isReadOnly(slingRequest, resource);
    final boolean hideTitle = properties.get("hideTitle", false);
    
    ResourceResolver rr = slingRequest.getResourceResolver();
%>

<%-- 
    TagInputField.css, but without the #CQ selector
--%>
<link type="text/css" href="/libs/foundation/components/form/tags/tags.css" rel="stylesheet"/>

<div class="form_row">
    <% LayoutHelper.printTitle(id, title, required, hideTitle, out); %>
    <div class="form_rightcol">
<%
    if (readOnly) {
        Resource loadResource = FormsHelper.getFormLoadResource(slingRequest);
        TagManager tm = rr.adaptTo(TagManager.class);
        Tag[] tags = tm.getTags(loadResource);
%>        <div class="form-readonly"><%
        for (int i=0; i < tags.length; i++) {
            if (i > 0) %>, <%; 
            %><%= xssAPI.filterHTML(tags[i].getTitle()) %><%
        }
%></div>
<%
    } else {
        String[] values = FormsHelper.getValues(slingRequest, name, null);
        if (values == null) {
            values = new String[]{};
        }
%>
        <div id="tags_<%= time %>_wrapper"> </div>
        
        <script type="text/javascript">
            CQ.Ext.onLoad(function() {
    
                var tagField = new CQ.tagging.TagInputField({
                    "name": "<%= xssAPI.encodeForJSString(name) %>",
                    "id": "<%= xssAPI.encodeForJSString(id) %>",
                    "renderTo": "tags_<%= time %>_wrapper",
                    "hideLabel": true,
                    "width": <%= xssAPI.getValidDimension(width, "\"auto\"") %>,
                    "popupWidth": <%= xssAPI.getValidDimension(popupWidth, "500") %>,
                    "popupHeight": <%= xssAPI.getValidDimension(popupHeight, "300") %>,
                    "namespaces": [<%
                        for (int i = 0; namespaces != null && i < namespaces.length; i++) {
                            if (i > 0) %>, <%;
                            %>"<%= xssAPI.encodeForJSString(namespaces[i]) %>"<%
                        }
                     %>]
                });

                // in this special environment, we must manually trigger the prepareSubmit() method
                if (window.formpage_form && typeof window.formpage_form.on === "function") {
                    window.formpage_form.on("beforesubmit", function() {
                        tagField.prepareSubmit();
                    });
                }
    
                tagField.setValue([<%
                    for (int i = 0; i < values.length; i++) {
                        if (i > 0) %>, <%;
                        %>"<%= xssAPI.encodeForJSString(values[i]) %>"<%
                    }
                %>]);
            });
        </script>
<% } %>
    </div>
</div>
<%
LayoutHelper.printDescription(FormsHelper.getDescription(resource, ""), out);
LayoutHelper.printErrors(slingRequest, name, hideTitle, out);
%>
