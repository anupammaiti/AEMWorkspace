<%--
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
--%><%
%><%@include file="/libs/foundation/global.jsp"%><%
%><%@page session="false"
          import="com.day.cq.commons.ImageResource,
                  com.day.cq.wcm.api.WCMMode, com.day.cq.wcm.foundation.Placeholder, javax.jcr.*"%><%
%><%
    String fileReference = properties.get("fileReference", "");
    if (fileReference.length() != 0 || resource.getChild("file") != null) {
        String path = request.getContextPath() + resource.getPath();
        String alt = xssAPI.encodeForHTMLAttr( properties.get("alt", ""));
        ImageResource image = new ImageResource(resource);

        // Handle extensions on both fileReference and file type images
        String extension = "jpg";
        String suffix = "";
        if (fileReference.length() != 0) {
            extension = fileReference.substring(fileReference.lastIndexOf(".") + 1);
            suffix = image.getSuffix();
            suffix = suffix.substring(0, suffix.indexOf('.') + 1) + extension;
        }
        else {
            Resource fileJcrContent = resource.getChild("file").getChild("jcr:content");
            if (fileJcrContent != null) {
                ValueMap fileProperties = fileJcrContent.adaptTo(ValueMap.class);
                String mimeType = fileProperties.get("jcr:mimeType", "jpg");
                extension = mimeType.substring(mimeType.lastIndexOf("/") + 1);
            }
        }
        extension = xssAPI.encodeForHTMLAttr(extension);
%><cq:includeClientLib categories="cq.adaptiveimage"/>
<div data-picture data-alt='<%= alt %>'>
    <div data-src='<%= path + ".img.320.low." + extension + suffix %>'       data-media="(min-width: 1px)"></div>                                        <%-- Small mobile --%>
    <div data-src='<%= path + ".img.320.medium." + extension + suffix %>'    data-media="(min-width: 320px)"></div>  <%-- Portrait mobile --%>
    <div data-src='<%= path + ".img.480.medium." + extension + suffix %>'    data-media="(min-width: 321px)"></div>  <%-- Landscape mobile --%>
    <div data-src='<%= path + ".img.476.high." + extension + suffix %>'      data-media="(min-width: 481px)"></div>   <%-- Portrait iPad --%>
    <div data-src='<%= path + ".img.620.high." + extension + suffix %>'      data-media="(min-width: 769px)"></div>  <%-- Landscape iPad --%>
    <div data-src='<%= path + ".img.full.high." + extension + suffix %>'     data-media="(min-width: 1025px)"></div> <%-- Desktop --%>

    <%-- Fallback content for non-JS browsers. Same img src as the initial, unqualified source element. --%>
    <noscript>
        <img src='<%= path + ".img.320.low." + extension + suffix %>' alt='<%= alt %>'>
    </noscript>
</div>
<%
    } else if (WCMMode.fromRequest(request) != WCMMode.DISABLED) {
        String classicPlaceholder =
                "<img class='cq-dd-image cq-image-placeholder' src='/etc/designs/default/0.gif'>";
        String placeholder = Placeholder.getDefaultPlaceholder(slingRequest, component,
                classicPlaceholder, "cq-dd-image");
        %><%= placeholder %><%
    }
%>