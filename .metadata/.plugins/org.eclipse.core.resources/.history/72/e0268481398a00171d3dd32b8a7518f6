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
            import="java.util.HashMap,
                    org.apache.jackrabbit.api.JackrabbitSession,
                    javax.jcr.RepositoryException,
                    org.apache.sling.api.request.RequestParameter,
                    org.apache.sling.api.resource.ResourceUtil,
                    org.apache.sling.api.resource.ValueMap,
                    org.apache.jackrabbit.api.security.user.UserManager,
                    org.apache.jackrabbit.api.security.user.User,
                    com.day.cq.wcm.foundation.forms.FormsHelper" %>
<%
%><%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %><%
%><sling:defineObjects/><%
    final ValueMap properties = ResourceUtil.getValueMap(resource);
    // key is no longer in use, CQ security API has been deprecated, use Jackrabbit security API
    // and include current password instead.
    // String key = slingRequest.getRequestParameter("ky").getString();
    RequestParameter uid = slingRequest.getRequestParameter("uid");
    RequestParameter pwd = slingRequest.getRequestParameter("passwordreset");

    // Current password parameter is optional. This is to be compatible with < 6.0
    // New developments must send current password
    RequestParameter currentPwd = slingRequest.getRequestParameter("currentPwd");

    boolean pwdChanged = false;
    JackrabbitSession session = (JackrabbitSession) resourceResolver.adaptTo(javax.jcr.Session.class);
    try {
        UserManager userManager = session.getUserManager();
        String userId = (uid == null) ? resourceResolver.getUserID() : uid.toString();
        User user = (User) userManager.getAuthorizable(userId);
        if (user != null) {
            if (currentPwd == null) {
                log.warn("Resetting password without checking the current password");
                user.changePassword(pwd.toString());
            } else {
                user.changePassword(pwd.toString(), currentPwd.toString());
            }
            if (!userManager.isAutoSave()) {
                session.save();
            }
            pwdChanged = true;
            log.info("Password changed for user [ {} ]", userId);
        } else {
            log.error("Failed to locate user [ {} ]", userId);
        }
    } catch (RepositoryException e) {
        log.error("Failed to reset password", e);
    }

    if (pwdChanged) {
        String path = properties.get("pwdChangedPage", "");
        if ("".equals(path)) {
            log.warn("Success page 'pwdChangedPage' is not defined. Redirecting to the referrer");
            FormsHelper.redirectToReferrer(slingRequest, slingResponse, new HashMap<String, String[]>());
        } else {
            path = slingRequest.getResourceResolver().map(request, path);
            if (path.indexOf(".") < 0) {
                path += ".html";
            }
            response.sendRedirect(path);
        }
    } else {
        log.error("Failed to reset password. Redirecting to the referrer");
        // Currently there is no defined way to report server error.
        // until 5.6, reset failure was not reported and request was redirected to the success page.
        // adding a simple error parameter. This should probably be a part of FormsHelper
        final HashMap<String, String[]> params = new HashMap<String, String[]>();
        params.put("error", new String[]{"Could not set Password"});
        FormsHelper.redirectToReferrer(slingRequest, slingResponse, params);
    }
%>