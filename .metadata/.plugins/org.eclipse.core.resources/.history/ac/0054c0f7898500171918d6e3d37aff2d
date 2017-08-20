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

  Default proxy script

  Includes a 'jcr:content' child resource if available

--%><%@page session="false"
            import="org.apache.sling.api.resource.Resource,
                    org.slf4j.Logger,
                    org.slf4j.LoggerFactory,
                    com.day.cq.wcm.api.NameConstants"
%><%@ taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %><%!

    private final Logger logger = LoggerFactory.getLogger(getClass());

%><sling:defineObjects /><%

    Resource cr = resourceResolver.getResource(resource, NameConstants.NN_CONTENT);
    if (cr == null) {
        logger.error("resource has no content. path={} referrer={}", request.getRequestURI(), request.getHeader("Referrer"));
        response.sendError(HttpServletResponse.SC_NOT_FOUND, "no content");
        return;
    }
    RequestDispatcher crd = slingRequest.getRequestDispatcher(cr);
    if (crd != null) {
        crd.include(request, response);
        return;
    } else {
        logger.error("Unable to dispatch proxy request.for {} referrer={}", request.getRequestURI(), request.getHeader("Referrer"));
        throw new ServletException("No Content");
    }

%>