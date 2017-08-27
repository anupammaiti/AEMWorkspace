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
  Handles requests to update the

--%><%@page session="false"
            import="java.io.IOException,
                    java.io.InputStream ,java.io.UnsupportedEncodingException,
                    java.util.HashMap,
                    java.util.Iterator,
                    java.util.Map,
                    javax.jcr.RepositoryException,
                    javax.jcr.Session,
                    javax.jcr.SimpleCredentials,
                    org.apache.sling.api.request.RequestParameter,
                    org.apache.sling.api.request.RequestParameterMap,
                    org.apache.sling.api.resource.Resource,
                    org.apache.sling.api.resource.ResourceUtil,
                    org.apache.sling.api.resource.ValueMap,
                    org.apache.sling.jcr.api.SlingRepository,
                    com.day.cq.security.AccountManager,
                    com.day.cq.security.AccountManagerFactory,
                    com.day.cq.wcm.foundation.forms.FormsHelper"%><%

%><%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %><%!

    final String LOGIN = "rep:userId";
    final String PWD = "rep:password";
    final String PWD_CONFIRM = PWD +"_confirm";
    final String CREATE = "cq:create";
    final String SUBMIT = "submit";

    final String PF_REP = "rep:";
    final String PF_CQ = "cq:";
    final String EMAIL = PF_REP + "e-mail";
    final String MEMBER_OF = PF_REP + "memberOf";

    private boolean authenticate(SlingRepository repos, String auth, String pwd) {
        Session session = null;
        try {
            SimpleCredentials creds = new SimpleCredentials(auth, pwd.toCharArray());
            session = repos.login(creds);
            return true;
        } catch (RepositoryException e) {
            return false;
        } finally {
            if (session!=null) {
                session.logout();
            }
        }
    }

    private Map<String, RequestParameter[]> filterParameter(Iterator<Resource> itr, RequestParameterMap paras) {
        Map<String, RequestParameter[]> prefs = new HashMap<String, RequestParameter[]>();
        while(itr.hasNext()) {
            String name = FormsHelper.getParameterName(itr.next());
            if (!paras.containsKey(name)
                    || name.startsWith(SUBMIT)
                    || name.startsWith("_")
                    || name.startsWith(LOGIN)) {
                continue; // filter all rep, anc cq properties but save the email in the profile
            }
            prefs.put(name, paras.getValues(name));
        }
        return prefs;
    }

    final class IntermediatePathParam implements RequestParameter {

        private final String intermediatePath;

        private IntermediatePathParam(String intermediatePath) {
            this.intermediatePath = intermediatePath;
        }

        public boolean isFormField() {
            return true;
        }

        public String getContentType() {
            return null;
        }

        public long getSize() {
            return intermediatePath.length();
        }

        public byte[] get() {
            return intermediatePath.getBytes();
        }

        public InputStream getInputStream() throws IOException {
            return null;
        }

        public String getFileName() {
            return null;
        }

        public String getName() {
            return getString();
        }
        
        public String getString() {
            return intermediatePath;
        }

        public String getString(String s) throws UnsupportedEncodingException {
            return new String(intermediatePath.getBytes(s));
        }
    }

%><sling:defineObjects/><%
    String[] searchPaths = resourceResolver.getSearchPath();
    String requestPath = slingRequest.getRequestPathInfo().getResourcePath();
    boolean shouldProcessRequest = false;
    for (String searchPath : searchPaths) {
        if (requestPath.startsWith(searchPath)) {
            shouldProcessRequest = true;
            break;
        }
    }
    if (requestPath.startsWith("/content") && !requestPath.startsWith("/content/generated/")) {
        shouldProcessRequest = true;
    }
    if (shouldProcessRequest) {
        final ValueMap properties = ResourceUtil.getValueMap(resource);
        final SlingRepository repos = sling.getService(SlingRepository.class);
        final AccountManagerFactory af = sling.getService(AccountManagerFactory.class);
        boolean create = false;
        boolean login = false;
        Session session = null;
        String error = null;
        try {
            session = repos.loginAdministrative(null);
            final String group = properties.get("memberOf", "");
            String intermediatePath = properties.get("intermediatePath", null);
            final AccountManager am = af.createAccountManager(session);
            final String auth = request.getParameter(LOGIN)==null? null : slingRequest.getRequestParameter(LOGIN).getString();
            String pwd = request.getParameter(PWD)==null? null : slingRequest.getRequestParameter(PWD).getString();
            final String createPara = request.getParameter(CREATE)==null? null : slingRequest.getRequestParameter(CREATE).getString();
            final String pwdConfirm = request.getParameter(PWD_CONFIRM)==null? null : slingRequest.getRequestParameter(PWD_CONFIRM).getString();

            final boolean hasAuth = auth!=null && auth.length()>0;
            final boolean hasPwd = pwd!=null && pwd.length()>0;
            final boolean isCreate = createPara!=null && Boolean.valueOf(createPara);
            login = hasAuth && hasPwd;
            create = hasAuth &&((pwdConfirm!=null && pwdConfirm.length()>0) || (isCreate && hasPwd));

            if (!(login || create)) {
                error = "Request incomplete no user-id or no password";
                log.debug(error);
            } else if (create) {
                if (!hasPwd) {
                    pwd = pwdConfirm;
                }
            } else if (login) {
                if (!authenticate(repos, auth, pwd)) {
                    error = "Error credentials do not authenticate";
                }
            }
            if (error==null) {
                Map<String, RequestParameter[]> userProps = filterParameter(FormsHelper.getFormElements(resource), slingRequest.getRequestParameterMap());
                // pass the intermediate path action as additional parameter (see bug #38146)
                if (intermediatePath != null) {
                    userProps.put("rep:intermediatePath", new RequestParameter[] {new IntermediatePathParam(intermediatePath)});
                }
                try {
                    // may fail when email cannot be send
                    am.getOrCreateAccount(auth, pwd, group, userProps);
                } catch (Exception e) {
                    log.warn("error while creating account: " + e.getMessage());
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
        String path = create ?  properties.get("thankyouPage", "") : properties.get("home", "");
        if ("".equals(path)) {
            FormsHelper.redirectToReferrer(slingRequest, slingResponse, new HashMap<String, String[]>());
        } else {
            if (path.indexOf(".")<0) {
                path += ".html";
            }
            response.sendRedirect(slingRequest.getResourceResolver().map(request, path));
        }
    } else {
        log.error("SECURITY: Denying user creation request for component located at " + resource.getPath());
    }
%>
