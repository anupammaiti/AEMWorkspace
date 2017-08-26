<%--
 Copyright 1997-2009 Day Management AG
 Barfuesserplatz 6, 4001 Basel, Switzerland
 All Rights Reserved.

 This software is the confidential and proprietary information of
 Day Management AG, ("Confidential Information"). You shall not
 disclose such Confidential Information and shall use it only in
 accordance with the terms of the license agreement you entered into
 with Day.

 ==============================================================================

 Segment renderer for sling:Folder nodes

 Creates the segmentation registration for the current folder.

--%><%@ page session="false"
             contentType="application/x-javascript"
             pageEncoding="utf-8"
             import="com.day.cq.wcm.api.NameConstants,
                     org.apache.sling.api.resource.Resource,
                     java.util.Iterator" %><%@ taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling" %><sling:defineObjects /><%
    Iterator<Resource> iter = resourceResolver.listChildren(resource);
    while(iter.hasNext()) {
        Resource child = iter.next();
        //exclude jcr:content nodes
        if(!NameConstants.NN_CONTENT.equals(child.getName())) {
            %> <sling:include path="<%= child.getPath() %>" replaceSelectors="segment" replaceSuffix="js" /> <%
        }
    }
%>