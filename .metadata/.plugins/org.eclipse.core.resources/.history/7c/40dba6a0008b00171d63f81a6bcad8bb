<%--
  Copyright 1997-2010 Day Management AG
  Barfuesserplatz 6, 4001 Basel, Switzerland
  All Rights Reserved.

  This software is the confidential and proprietary information of
  Day Management AG, ("Confidential Information"). You shall not
  disclose such Confidential Information and shall use it only in
  accordance with the terms of the license agreement you entered into
  with Day.

  ==============================================================================

  Form 'element' component

  Generate the client javascript code to validate this field.

--%><%@page session="false" %><%
%><%@page import="java.util.ResourceBundle"%>
<%@ page import="javax.jcr.RepositoryException" %>
<%@ page import="javax.jcr.Session" %>
<%@ page import="javax.jcr.SimpleCredentials" %>
<%@ page import="org.apache.sling.jcr.api.SlingRepository" %>
<%@ page import="com.day.cq.security.User" %>
<%@ page import="com.day.cq.security.UserManager" %>
<%@ page import="com.day.cq.security.UserManagerFactory" %>
<%@ page import="com.day.cq.wcm.api.WCMMode" %>
<%@ page import="com.day.cq.wcm.foundation.forms.ValidationInfo" %><%
%><%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %><%
%><sling:defineObjects/><%
    final User user = slingRequest.getResourceResolver().adaptTo(User.class);
    final ResourceBundle resBundle = slingRequest.getResourceBundle(request.getLocale());
    final String name = "cq:login";
    final String userId = request.getParameter(name);
    final SlingRepository repos = sling.getService(SlingRepository.class);
    if (!user.getID().equals("anonymous") && WCMMode.fromRequest(request).equals(WCMMode.DISABLED)) {
        log.warn("Won't create new user if logged in on publish");

    // form fileds for existing user are filled in, test if the credentials provided would validate
    } else if (userId!=null && userId.length()>0) {
        log.debug("Attempt to login for form as {}", userId);
        final String pw = request.getParameter("cq:password");
        if (pw==null || pw.length()==0) {
            ValidationInfo.createValidationInfo(slingRequest).addErrorMessage("cq:password", resBundle.getString("No password to login"));
        } else{
            Session check = null;
            try {
                check = repos.login(new SimpleCredentials(userId, pw.toCharArray()));
            } catch (RepositoryException e) {
                ValidationInfo.createValidationInfo(slingRequest).addErrorMessage(name, resBundle.getString("Userid / Password do not match"));
            } finally {
                if (check!=null) {
                    check.logout();
                }
            }
        }
    // the form fields to create a new user have been filled in
    // validate if the users id is available
    } else {
        final String newId = request.getParameter("rep:userId");
        final String newPw = request.getParameter("rep:password");
        if (newId!=null && newPw!=null && newId.length()>0 && newPw.length()>0) {
            log.debug("Attempt to create new account");
            final UserManagerFactory fact = sling.getService(UserManagerFactory.class);
            if (!(repos==null || fact==null)) {
                Session session = null;
                try {
                    session = repos.loginAdministrative(null);
                    final UserManager umgr = fact.createUserManager(session);
                    if (umgr.hasAuthorizable(newId)) {
                        ValidationInfo.createValidationInfo(slingRequest).addErrorMessage("rep:userId", resBundle.getString("User-Id not available"));
                    }
                } finally {
                    if (session!=null) {
                        session.logout();
                    }
                }
            }
        } else {
            ValidationInfo.createValidationInfo(slingRequest).addErrorMessage("rep:userId", resBundle.getString("User-Id and Password needed for registration"));
        }
    }
%>