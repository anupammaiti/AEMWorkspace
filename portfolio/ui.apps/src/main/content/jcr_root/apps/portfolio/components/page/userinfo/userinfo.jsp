<%--

  ADOBE CONFIDENTIAL
  __________________

   Copyright 2011 Adobe Systems Incorporated
   All Rights Reserved.

  NOTICE:  All information contained herein is, and remains
  the property of Adobe Systems Incorporated and its suppliers,
  if any.  The intellectual and technical concepts contained
  herein are proprietary to Adobe Systems Incorporated and its
  suppliers and are protected by trade secret or copyright law.
  Dissemination of this information or reproduction of this material
  is strictly forbidden unless prior written permission is obtained
  from Adobe Systems Incorporated.
--%><%@include file="/apps/geometrixx-media/global.jsp"%><%
%><%@page session="false" import="
          com.day.cq.personalization.UserPropertiesUtil,
          com.day.cq.wcm.commons.WCMUtils"%><%
%><%@taglib prefix="personalization" uri="http://www.day.com/taglibs/cq/personalization/1.0" %><%

    final boolean isAnonymous = UserPropertiesUtil.isAnonymous(slingRequest);
    final boolean isDisabled = WCMMode.DISABLED.equals(WCMMode.fromRequest(request));
    final String profilePagePath = WCMUtils.getInheritedProperty(currentPage, resourceResolver, "cq:profilePage");
    String myProfileLink = "javascript:void(0)";
    if (profilePagePath != null) {
        myProfileLink = "${profile.path}.form.html" + profilePagePath;
    }

    final String loginPagePath = WCMUtils.getInheritedProperty(currentPage, resourceResolver, "cq:loginPage");
    final String signupPagePath = WCMUtils.getInheritedProperty(currentPage, resourceResolver, "cq:signupPage");
    final String messageBoxPagePath = WCMUtils.getInheritedProperty(currentPage, resourceResolver, "cq:messageBoxPage");
%>
<nav><ul>
    <%
    if (!isAnonymous || !isDisabled) { %>
        <li class="user"><personalization:contextProfileProperty propertyName="formattedName" prefix="(" suffix=")"/></li><%
    }
    // if we are a logged in user
    if (!isAnonymous) { %>
        <li class="profilepage"><personalization:contextProfileLink displayValue="<%= i18n.get("My Profile") %>" href="<%= myProfileLink %>" id="myprofile-link"/></li>
        <li>
            <script>
                var data = {};
                data["messageFolder"] = "inbox";
                var messagecount;
                $.ajax({
                    type: "GET",
                    url: "<%=messageBoxPagePath%>" + "/jcr:content/grid-10-par/inbox.social.json",
                    async: true,
                    data: data,
                    success: function(json) {
                        messagecount = json["messageCounts"].nonDeletedUnreadCount;
                        $("a.messageBoxPrimaryLink").html( $("a.messageBoxPrimaryLink").html() + " (" + messagecount + ")");
                    }
                });
            </script>
            <a href="<%= xssAPI.getValidHref(messageBoxPagePath)%>.html" class="messageBoxPrimaryLink"><%=i18n.get("Messages")%></a>
        </li>
        <li class="signout">
            <script type="text/javascript">function logout() {
                if (_g && _g.shared && _g.shared.ClientSidePersistence) {
                    _g.shared.ClientSidePersistence.clearAllMaps();
                }
            <%      if( !isDisabled ) { %>
                if( CQ_Analytics && CQ_Analytics.CCM) {
                    CQ_Analytics.ProfileDataMgr.loadProfile("anonymous");
                    CQ.shared.Util.reload();
                }
            <%      } else { %>
                if( CQ_Analytics && CQ_Analytics.CCM) {
                    CQ_Analytics.ProfileDataMgr.clear();
                    CQ_Analytics.CCM.reset();
                }
                CQ.shared.Util.load("<%= resourceResolver.map(request, "/system/sling/logout") %>.html");
            <%      } %>
            }</script>
            <a href="javascript:logout();"><%= i18n.get("Sign Out") %></a>
        </li><%
    } else { %>
        <li class="login"><a href="<%= xssAPI.getValidHref(resourceResolver.map(loginPagePath)) %>.html"><%= i18n.get("Sign In") %></a></li>
        <li class="signup"><a href="<%= xssAPI.getValidHref(resourceResolver.map(signupPagePath)) %>.html"><%= i18n.get("Sign Up") %></a></li><%
    }%>
</ul></nav>
