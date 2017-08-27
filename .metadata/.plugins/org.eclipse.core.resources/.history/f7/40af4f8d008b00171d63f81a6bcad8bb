<%--
  Copyright 1997-2010 Day Management AG
  Barfuesserplatz 6, 4001 Basel, Switzerland
  All Rights Reserved.

  This software is the confidential and proprietary information of
  Day Management AG, ("Confidential Information"). You shall not
  disclose such Confidential Information and shall use it only in
  accordance with the terms of the license agreement you entered into
  with Day.
  --%><%@page session="false"
              import="java.net.URL,
                      java.util.HashMap,
                      javax.jcr.Session,
                      org.apache.sling.api.resource.ResourceUtil,
                      org.apache.sling.api.resource.ValueMap,
                      org.apache.sling.jcr.api.SlingRepository,
                      com.day.cq.security.AccountManager,
                      com.day.cq.security.AccountManagerFactory,
                      com.day.cq.wcm.foundation.forms.FormsHelper" %><%
%><%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %><%
%><sling:defineObjects/><%
    final ValueMap properties = ResourceUtil.getValueMap(resource);
    String createAccountPage = properties.get("createAccountPage", null);
    final String email = request.getParameter("rep:userId") == null ? null : slingRequest.getRequestParameter("rep:userId").getString();

    // todo check existing
    if (email != null && createAccountPage != null) {
        final SlingRepository repos = sling.getService(SlingRepository.class);
        final AccountManagerFactory af = sling.getService(AccountManagerFactory.class);
        final Session session = repos.loginAdministrative(null);
        try {
            AccountManager am = af.createAccountManager(session);
            URL url = new URL(request.getRequestURL().toString());
            if (!createAccountPage.endsWith(".html")) {
                createAccountPage += ".html";
            }
            if (!am.requestAccount(email, new URL(url.getProtocol(), url.getHost(), url.getPort(), createAccountPage))) {
                // todo handle error
            }
        }
        finally {
            if (session != null) {
                session.logout();
            }
        }
    }

    String path = properties.get("ThankYouPage", "");
    if ("".equals(path)) {
        FormsHelper.redirectToReferrer(slingRequest, slingResponse, new HashMap<String, String[]>());
    } else {
        if (path.indexOf(".") < 0) {
            path += ".html";
        }
        response.sendRedirect(slingRequest.getResourceResolver().map(request, path));
    }

%>