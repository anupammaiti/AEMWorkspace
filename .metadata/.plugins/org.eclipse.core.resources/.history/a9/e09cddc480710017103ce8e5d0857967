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
%><%@ page import="com.adobe.cq.social.forum.api.Forum,
com.adobe.cq.social.forum.api.ForumUtil,
		 com.adobe.granite.security.user.UserProperties,
		 org.apache.sling.jcr.base.AbstractSlingRepository"%><%@include file="/apps/geometrixx-media/global.jsp" %><%
%><%@page session="false" %>
<%
	final UserProperties loggedInUserProperties = slingRequest.getResourceResolver().adaptTo(UserProperties.class);
    final String loggedInUserID = (loggedInUserProperties == null) ? null : loggedInUserProperties.getAuthorizableID();
    final String loggedInUserName = (loggedInUserProperties == null) ? null : (loggedInUserProperties.getDisplayName() == null)? loggedInUserID : loggedInUserProperties.getDisplayName();
    final Boolean isanon = loggedInUserName.equals(AbstractSlingRepository.DEFAULT_ANONYMOUS_USER);

%><%
%><%@ page contentType="text/html; charset=utf-8" %>
<div class="new-topic-form">
	<div class="row-fluid">
		<div class="span12">
			<%    final Forum forum = resource.adaptTo(Forum.class);

			if (isanon) {
			%>
			<div class="login">
				<%= xssAPI.encodeForHTML(i18n.get("Sign in in order to ask a question.")) %>
			</div><%
			}
			else{
			%>

			<cq:include path="par" resourceType="foundation/components/parsys"/>

			<%
			}
			%>
		</div>
	</div>
</div>