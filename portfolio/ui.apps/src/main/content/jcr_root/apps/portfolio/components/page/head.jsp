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
%><%@include file="/apps/portfolio/global.jsp" %><%
%><%@page session="false" %>
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="initial-scale=1.0"/>

    <title><%= xssAPI.encodeForHTML( currentPage.getTitle() == null ? currentPage.getName() : currentPage.getTitle() ) %></title>
    <% currentDesign.writeCssIncludes(pageContext); %>
    <cq:include script="/libs/wcm/core/components/init/init.jsp"/>
    <%--- No need of page stats for now <cq:include script="/libs/foundation/components/page/stats.jsp"/>---%>
    <%--- Not going in detail of cloudservices <cq:include script="/libs/cq/cloudserviceconfigs/components/servicelibs/servicelibs.jsp"/> ---%>
    <cq:include script="/libs/wcm/core/browsermap/browsermap.jsp" />
    <cq:include script="/libs/wcm/mobile/components/simulator/simulator.jsp"/>
    
    <cq:includeClientLib categories="apps.geometrixx-media.all"/>
</head>