<%@page session="false"%><%--
  ADOBE CONFIDENTIAL
  __________________

   Copyright 2013 Adobe Systems Incorporated
   All Rights Reserved.

  NOTICE:  All information contained herein is, and remains
  the property of Adobe Systems Incorporated and its suppliers,
  if any.  The intellectual and technical concepts contained
  herein are proprietary to Adobe Systems Incorporated and its
  suppliers and are protected by trade secret or copyright law.
  Dissemination of this information or reproduction of this material
  is strictly forbidden unless prior written permission is obtained
  from Adobe Systems Incorporated.

======================================================================

  Scaffolding selector script

  Finds and includes the correct scaffold for the current resource.

--%><%@page contentType="text/html" pageEncoding="utf-8" import="
        javax.jcr.Node,
        org.apache.sling.api.resource.Resource,
        com.day.cq.wcm.core.utils.ScaffoldingUtils" %><%
%><%@taglib prefix="cq" uri="http://www.day.com/taglibs/cq/1.0" %><%
%><cq:defineObjects/><%

// first check if the resource has a scaffold specified
    String scaffoldPath = properties.get("cq:scaffolding", "");
    if (scaffoldPath.length() == 0) {
        // search all scaffolds for a path match
        Resource scRoot = resourceResolver.getResource("/etc/scaffolding");
        Node root = scRoot == null ? null : scRoot.adaptTo(Node.class);
        if (root != null) {
            scaffoldPath = ScaffoldingUtils.findScaffoldByPath(root, resource.getPath());
        }
    }
    if (scaffoldPath == null || scaffoldPath.length() == 0) {
        // use default
        scaffoldPath = "/etc/scaffolding/resource";
    }
    scaffoldPath += "/jcr:content.html";
    request.setAttribute(ScaffoldingUtils.CONTEXT_RESOURCE_ATTR_NAME, resource);
    %><cq:include resourceType="wcm/scaffolding/components/scaffolding" path="<%= scaffoldPath %>" /><%

%>
