<%--
  Copyright 1997-2010 Day Management AG
  Barfuesserplatz 6, 4001 Basel, Switzerland
  All Rights Reserved.

  This software is the confidential and proprietary information of
  Day Management AG, ("Confidential Information"). You shall not
  disclose such Confidential Information and shall use it only in
  accordance with the terms of the license agreement you entered into
  with Day.

  Password Reset component.

  Reset a user's password

--%><%
%><%@include file="/libs/foundation/global.jsp"%><%
%><%@page session="false"
          import="java.util.Locale,
                  java.util.ResourceBundle,
                  org.apache.sling.jcr.api.SlingRepository,
                  com.day.cq.i18n.I18n,
                  com.day.cq.security.AccountManager,
                  com.day.cq.security.AccountManagerFactory,
                  com.day.cq.security.User,
                  com.day.cq.wcm.foundation.forms.FormsHelper,
                  com.day.cq.wcm.foundation.forms.LayoutHelper" %><%
%><%
    final Locale pageLocale = currentPage.getLanguage(true);
    final ResourceBundle resourceBundle = slingRequest.getResourceBundle(pageLocale);
    I18n i18n = new I18n(resourceBundle);

    final String name = FormsHelper.getParameterName(resource);
    final String id = FormsHelper.getFieldId(slingRequest, resource);
    final String title = FormsHelper.getTitle(resource, i18n.get("Password"));
    final boolean hideTitle = properties.get("hideTitle", false);
    final String confirmTitle = properties.get("confirmationTitle", i18n.get("Confirm Password"));
    final boolean hideConfirmTitle = properties.get("hideConfirmTitle", false);
    final boolean required = FormsHelper.isRequired(resource);

    String width = properties.get("width", "");
    if (width.length() > 0) {
        width = width + "px;";
    }
    final String cols = properties.get("cols", "35");

    final String key = request.getParameter("ky") == null ? null : slingRequest.getRequestParameter("ky").getString();
    final String uid = request.getParameter("uid") == null ? null : slingRequest.getRequestParameter("uid").getString();
    String userName = null;

    // todo deny anonymous, admin

    if (key == null && uid == null) {
        User user = resourceResolver.adaptTo(User.class);
        if (user == null) {
            log.error("Could not resolve logged in user");
            // todo handle error
            // response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
        else {
            userName = user.getName();
        }

    } else if (key != null && uid != null) {
        SlingRepository repository = sling.getService(SlingRepository.class);
        Session session = repository.loginAdministrative(null);
        try {
            AccountManagerFactory factory = sling.getService(AccountManagerFactory.class);
            AccountManager accountManager = factory.createAccountManager(session);
            User user = accountManager.findAccount(uid);
            if (user == null) {
                log.debug("No user matching uid {}", uid);
                // todo handle error
                // response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            }
            else {
                userName = user.getName();
            }
        }
        finally {
            session.logout();
        }

    } else {
        // todo handle error
        // response.sendError(HttpServletResponse.SC_BAD_REQUEST);
    }

%>
<div class="form_row">
    <% LayoutHelper.printTitle(id, title, required, hideTitle, out); %>
    <div class="form_rightcol">
        <input class="geo textinput" name="<%=xssAPI.encodeForHTMLAttr(name)%>" value="" type="password" autocomplete="off" size="<%=xssAPI.encodeForHTMLAttr(cols)%>" <%= width.length() > 0 ? "style=\"width:" + xssAPI.encodeForHTMLAttr(width) + "\"" : "" %>>
    </div>
</div>
<div class="form_row">
    <% LayoutHelper.printTitle(id, confirmTitle, required, hideConfirmTitle, out); %>
    <div class="form_rightcol">
        <input class="geo textinput" name="<%=xssAPI.encodeForHTMLAttr(name)%>_confirm" value="" type="password" autocomplete="off" size="<%=xssAPI.encodeForHTMLAttr(cols)%>" <%= width.length() > 0 ? "style=\"width:" + xssAPI.encodeForHTMLAttr(width) + "\"" : "" %>>
    </div>
</div>
<%
    if (key != null && uid != null) {
%>
<input type="hidden" name="uid" value="<%=xssAPI.encodeForHTMLAttr(uid)%>">
<input type="hidden" name="ky" value="<%=xssAPI.encodeForHTMLAttr(key)%>">
<%
    }
%>
<%
    LayoutHelper.printDescription(FormsHelper.getDescription(resource, ""), out);
    LayoutHelper.printErrors(slingRequest, name, out);
%>
