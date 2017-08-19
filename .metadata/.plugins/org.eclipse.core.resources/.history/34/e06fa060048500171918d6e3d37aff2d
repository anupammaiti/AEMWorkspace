<%@page session="false"%><%--
  Copyright 1997-2008 Day Management AG
  Barfuesserplatz 6, 4001 Basel, Switzerland
  All Rights Reserved.


  This software is the confidential and proprietary information of
  Day Management AG, ("Confidential Information"). You shall not
  disclose such Confidential Information and shall use it only in
  accordance with the terms of the license agreement you entered into
  with Day.


  ==============================================================================


  Default reference component.


  Includes the referenced component addressed by the "path" property. It
  temporarily disables the WCM so that the included components cannot be
  edited.


  ==============================================================================


--%><%@page import="com.day.cq.wcm.api.WCMMode,
    com.day.cq.wcm.api.components.DropTarget, com.day.cq.wcm.foundation.Placeholder" %><%
  %><%@include file="/libs/foundation/global.jsp" %><%


WCMMode mode = WCMMode.DISABLED.toRequest(request);
boolean needToCloseDiv = false;
try {
    // Use request attributes to guard against reference loops
    String path = resource.getPath();
    String key = "com.day.cq.wcm.components.reference:" + path;
    if (request.getAttribute(key) == null) {
        request.setAttribute(key, Boolean.TRUE);
    } else {
        throw new IllegalStateException("Reference loop: " + path);
    }

    //drop target css class = dd prefix + name of the drop target in the edit config
    String ddClassName = DropTarget.CSS_CLASS_PREFIX + "paragraph";

    // Include the target paragraph by path
    String target = properties.get("path", String.class);
    if (target != null) {
        %><div style="display:inline;" class="<%= ddClassName %>"><% needToCloseDiv = true; %><sling:include path="<%= target %>"/></div><% needToCloseDiv = false; %><%
    } else if (mode == WCMMode.EDIT) {
        String classicPlaceholder =
                "<p><img src=\"/libs/cq/ui/resources/0.gif\" class=\"cq-reference-placeholder " + ddClassName + "\" alt=\"\"></p>";
        String placeholder = Placeholder.getDefaultPlaceholder(slingRequest, component, classicPlaceholder, ddClassName);
        %><%= placeholder %><%
    }
} catch (Exception e) {
    // Log errors always
    log.error("Reference component error", e);

    // Display errors only in edit mode 
    if (mode == WCMMode.EDIT) {
        %><p>Reference error: <%= xssAPI.encodeForHTML(e.toString()) %></p><%
    }
} finally {
    if (needToCloseDiv) {
        %></div><%
    }
    mode.toRequest(request);
}
%>
