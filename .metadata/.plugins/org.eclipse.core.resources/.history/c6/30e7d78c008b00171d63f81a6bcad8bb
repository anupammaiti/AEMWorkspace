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

  Form 'action' component
  Handles requests to update the

--%><%@page session="false"
            import="java.net.URL,
                    java.util.HashMap,
                    javax.jcr.Session,
                    org.apache.sling.api.resource.ResourceUtil,
                    org.apache.sling.api.resource.ValueMap,
                    org.apache.sling.jcr.api.SlingRepository,
                    com.day.cq.security.AccountManager,
                    com.day.cq.security.AccountManagerFactory,
                    com.day.cq.security.Authorizable,
                    com.day.cq.security.User,
                    com.day.cq.wcm.foundation.forms.FormsHelper" %><%
%><%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %><%!

    final String LOGIN = "rep:userId";

%><sling:defineObjects/><%

    final ValueMap properties = ResourceUtil.getValueMap(resource);
    final SlingRepository repos = sling.getService(SlingRepository.class);
    final AccountManagerFactory af = sling.getService(AccountManagerFactory.class);
    Session session = null;
    String error = null;
    try {
        session = repos.loginAdministrative(null);
        final AccountManager am = af.createAccountManager(session);
        final String auth = request.getParameter(LOGIN)==null? null : slingRequest.getRequestParameter(LOGIN).getString();
        if (auth!=null) {
            Authorizable authorizable = am.findAccount(auth);
            String changePwdPage = properties.get("changePwdPage", null);

            if (authorizable != null && changePwdPage != null && authorizable.isUser()) {
                if (!changePwdPage.endsWith(".html")) {
                    changePwdPage += ".html";
                }
                URL url = new URL(request.getRequestURL().toString());
                am.requestPasswordReset((User)authorizable, new URL(url.getProtocol(), url.getHost(), url.getPort(), changePwdPage));
            }
        }
        } catch (Exception e) {
            error = e.getMessage();
        } finally {
            if (session!=null) {
                session.logout();
            }
        }
    if (error!=null) {
        log.error(error);
    } 
    String path = properties.get("thankyouPage", "");
    if ("".equals(path)) {
        FormsHelper.redirectToReferrer(slingRequest, slingResponse, new HashMap<String, String[]>());
    } else {
        if (path.indexOf(".")<0) {
            path += ".html"; 
        }
        response.sendRedirect(slingRequest.getResourceResolver().map(request, path));
    }
%>