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

  Form 'action' component

  Return the action path for the store form handling

--%><%@page session="false" %><%
%><%@page import="org.apache.sling.api.resource.ResourceUtil,
                com.adobe.cq.social.commons.CollabUtil,
                org.apache.sling.jcr.api.SlingRepository,
                org.apache.sling.api.resource.ValueMap,
                com.day.cq.wcm.foundation.forms.FormsConstants,
                com.day.cq.wcm.foundation.forms.FormsHelper,
                java.util.concurrent.atomic.AtomicInteger,
                java.util.Map,
                java.util.HashMap,
                javax.jcr.Session,
                javax.jcr.Node,
                javax.jcr.security.Privilege,
                javax.jcr.RepositoryException,
                org.slf4j.Logger,
                org.slf4j.LoggerFactory,
                com.day.cq.commons.jcr.JcrUtil,
                com.day.cq.security.UserManager,
                com.day.cq.security.UserManagerFactory,
                javax.jcr.security.AccessControlManager,
                javax.jcr.security.AccessControlPolicyIterator,
                javax.jcr.security.AccessControlPolicy,
                javax.jcr.security.AccessControlList"%><%!

    private static final AtomicInteger uniqueIdCounter = new AtomicInteger();
    private final Logger log = LoggerFactory.getLogger(getClass());

    %><%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %><%
    %><%@taglib prefix="cq" uri="http://www.day.com/taglibs/cq/1.0" %>
    <cq:defineObjects/><sling:defineObjects/><%!

    AccessControlList getAcl(AccessControlManager acMgr, String path) throws RepositoryException {
        AccessControlPolicyIterator it = acMgr.getApplicablePolicies(path);
        while (it.hasNext()) {
            AccessControlPolicy p = it.nextAccessControlPolicy();
            if (p instanceof AccessControlList) {
                return (AccessControlList) p;
            }
        }
        return null;
    }

    %><%

    final SlingRepository repository = sling.getService(SlingRepository.class);
    final ValueMap props = ResourceUtil.getValueMap(resource);

    String path = props.get(FormsConstants.START_PROPERTY_ACTION_PATH, "");
    // create a default path if no path is specified:
    // For example if the form is at /content/geometrixx/en/formpage
    // then the default path is /content/usergenerated/content/geometrixx/en/formpage
    if ( path.length() == 0 ) {
        final String pagePath = currentPage.getPath();
        final int pos = pagePath.indexOf('/', 1);
        path = pagePath.substring(0, pos + 1) + "usergenerated/content" + pagePath.substring(pos) + "/*";
    }

    // If path ends with / or /*, compute a unique name ourselves for the node to create,
    // so that we can pass it to StartWorkflowPostProcessor. Sling might create ancestor
    // nodes of that one if they don't exist yet, so it's hard for the processor to
    // compute the right payload path without this
    for(String suffix : new String [] { "/", "/*" }) {
        if(path.endsWith(suffix)) {
            final String uniqueId = System.currentTimeMillis() + "_" + uniqueIdCounter.addAndGet(1);
            path = path.substring(0, path.length() - suffix.length() + 1) + uniqueId;
            Session userSession = slingRequest.getResourceResolver().adaptTo(Session.class);
            if (CollabUtil.canAddNode(userSession, path)) {
                // Create the parent node beforehand and set "formPath" and "sling:resourceType"
                // on it to allow bulk editor and forms payload summary respectively.
                final Session adminSession = repository.loginAdministrative(null);
                try {
                    final Node node = JcrUtil.createPath(path, "sling:Folder", adminSession);
                    final Node parent = node.getParent();
                    parent.setProperty("formPath", request.getParameter(FormsConstants.REQUEST_PROPERTY_FORM_START));
                    parent.setProperty("sling:resourceType", "foundation/components/form/actions/showbulkeditor");
                    adminSession.save();
                    // Now change anonymous user permissions before forward
                    // This is needed since we deligate the save (forward) to sling
                    final UserManager userManager = sling.getService(UserManagerFactory.class).createUserManager(adminSession);
                    final AccessControlManager acMgr = adminSession.getAccessControlManager();
                    final AccessControlList acl = getAcl(acMgr, path);
                    // if found, and if current session does not have appropriate privileges...
                    // ...add an entry for 'this' principal to allow modify properties...
                    // ... assign it to the newly created path (this policy will be revoked in cleanup action)
                    if (acl != null) {
                    	final Privilege[] privileges = new Privilege[] {acMgr.privilegeFromName(Privilege.JCR_MODIFY_PROPERTIES)};
                    	if (!userSession.getAccessControlManager().hasPrivileges(path, privileges)) {
                            acl.addAccessControlEntry(userManager.get(userSession.getUserID()).getPrincipal(), privileges);
                            acMgr.setPolicy(path, acl);
                            request.setAttribute("cq.form.temp.policy",acl);
                    	}
                    } else {
                    	log.error("No applicable policies found for {}", path);
                    }
                } catch (Exception e) {
                    log.error("Failed to create path or set permissions.", e);
                } finally {
                    if (adminSession != null) {
	                	if (adminSession.hasPendingChanges()) {
	                        adminSession.save();
	                	}
                        adminSession.logout();
                    }
                }
            } else {
                log.error("User does not have add_node permissions on {}", path);
            }
            break;
        }
    }
    request.setAttribute(FormsConstants.REQUEST_ATTR_WORKFLOW_PAYLOAD_PATH, path);

    // If a workflow model was specified, store it in
    // a request attribute for the StartWorkflowPostProcessor
    final String model = props.get(FormsConstants.START_PROPERTY_WORKFLOW_MODEL, null);
    if(model != null) {
        request.setAttribute(FormsConstants.REQUEST_ATTR_WORKFLOW_PATH, model);
    }

    FormsHelper.setForwardPath(slingRequest, path, true);
    FormsHelper.setRedirectToReferrer(request, true);
%>