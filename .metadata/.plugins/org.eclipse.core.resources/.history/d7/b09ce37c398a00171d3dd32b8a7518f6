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

  External application component

  Intercepts POST requests and forwards to the same url using GET

--%><%@page import="org.apache.sling.api.SlingHttpServletRequest,
                  org.apache.sling.api.wrappers.SlingHttpServletRequestWrapper"%><%
%><%@include file="/libs/foundation/global.jsp"%><sling:defineObjects /><%!

  class GetWrapper extends SlingHttpServletRequestWrapper {

    public GetWrapper(SlingHttpServletRequest wrappedRequest) {
        super(wrappedRequest);
    }

    @Override
    public String getMethod() {
        return "GET";
    }
  }
%><%
    request.setAttribute("cq.ext.app.method", request.getMethod());   
    request.getRequestDispatcher(resource.getPath() + ".html").forward(new GetWrapper(slingRequest), slingResponse);
%>