<%--
  Copyright 1997-2011 Day Management AG
  Barfuesserplatz 6, 4001 Basel, Switzerland
  All Rights Reserved.

  This software is the confidential and proprietary information of
  Day Management AG, ("Confidential Information"). You shall not
  disclose such Confidential Information and shall use it only in
  accordance with the terms of the license agreement you entered into
  with Day.

  ==============================================================================

  Form 'action' component

  Revert (if any) temporary policy assigned on the given path.

--%><%@page session="false" %>
<%@page import="org.slf4j.LoggerFactory"%>
<%@page import="org.slf4j.Logger"%>
<%@page import="javax.jcr.Session"%>
<%@page import="org.apache.sling.jcr.api.SlingRepository"%>
<%@page import="javax.jcr.security.AccessControlManager"%>
<%@page import="javax.jcr.security.AccessControlList"%>
<%@page import="com.day.cq.wcm.foundation.forms.FormsHelper"%>
<%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %>

<%@page import="javax.jcr.RepositoryException"%><sling:defineObjects/>

<%!
private final Logger log = LoggerFactory.getLogger(getClass()); %><%
final AccessControlList acl = (AccessControlList) request.getAttribute("cq.form.temp.policy");

if (acl != null) {
    final SlingRepository repository = sling.getService(SlingRepository.class);
    final Session adminSession = repository.loginAdministrative(null);
	try {
		adminSession.getAccessControlManager().removePolicy(FormsHelper.getForwardPath(slingRequest),acl);
	} catch (RepositoryException e) {
		log.error("Failed to remove temporary policy for the user.", e);
	} finally {
		if (adminSession != null) {
            if (adminSession.hasPendingChanges()) {
                adminSession.save();
            }
			adminSession.logout();
		}
	}
}
%>