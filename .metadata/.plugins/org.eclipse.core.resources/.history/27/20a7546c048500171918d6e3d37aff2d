/*
 * Copyright 1997-2009 Day Management AG
 * Barfuesserplatz 6, 4001 Basel, Switzerland
 * All Rights Reserved.
 *
 * This software is the confidential and proprietary information of
 * Day Management AG, ("Confidential Information"). You shall not
 * disclose such Confidential Information and shall use it only in
 * accordance with the terms of the license agreement you entered into
 * with Day.
 */
package com.day.cq.wcm.foundation.forms.impl;

import com.day.cq.commons.PathInfo;
import com.day.cq.commons.servlets.NonExistingResourceServlet;
import com.day.cq.search.PredicateConverter;
import com.day.cq.search.Query;
import com.day.cq.search.QueryBuilder;
import com.day.cq.search.result.Hit;
import com.day.cq.search.result.SearchResult;
import com.day.cq.wcm.api.components.IncludeOptions;
import com.day.cq.wcm.foundation.forms.FormResourceEdit;
import com.day.cq.wcm.foundation.forms.FormsHelper;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Properties;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.request.RequestDispatcherOptions;
import org.apache.sling.api.request.RequestPathInfo;
import org.apache.sling.api.resource.NonExistingResource;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ResourceResolver;
import org.apache.sling.api.servlets.SlingAllMethodsServlet;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.jcr.RepositoryException;
import javax.jcr.Session;
import javax.servlet.RequestDispatcher;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

/**
 * {@linkplain FormChooserServlet} allows to render the current resource (plus optionally
 * a list of other resources given as request parameters) with a certain form, which is
 * given as suffix, selector alias or by a default form for the resource type.
 * <p/>
 * <p/>
 * This servlet is registered twice, once for any resource under the "form" selector
 * and secondly for non-existent resources using the special dispatching mechanism for
 * this case in cq-commons. For creating resources it is adviced to use the additional
 * "create" selector to clearly mark that special case. This is required when the form
 * will later create a new node below an existing node using :name, :nameHint, jcr:title
 * property or similar way in the Sling POST servlet and thereby setting the resource
 * path to the parent node + "/", which will not result in a NonExistingResource (as is
 * the case if the parent node does not exist, but eg. the grandparent), but directly
 * match that parent node.
 */
@Component(metatype = false)
@Service({Servlet.class, NonExistingResourceServlet.class})
@Properties({
        @Property(name = "service.name", value = "CQ Form chooser servlet"),
        @Property(name = "service.description", value = "Renders the current resource(s) with a form"),
        @Property(name = "sling.servlet.resourceTypes", value = "sling/servlet/default"),
        @Property(name = "sling.servlet.selectors", value = FormChooserServlet.SELECTOR),
        @Property(name = "sling.servlet.methods", value = {"GET", "POST"}),
        @Property(name = "service.ranking", intValue = 100)
})
@SuppressWarnings("serial")
public class FormChooserServlet extends SlingAllMethodsServlet implements NonExistingResourceServlet {

    /**
     * @deprecated
     */
    @Deprecated
    public static final String REQ_PARAM_PATH = "path";
    public static final String REQ_PARAM_QUERY = "query";
    public static final String PN_FORM_ALIAS = "cq:formAlias";
    public static final String PN_FORM_DEFAULT_RT = "cq:defaultFormFor";
    public static final String CONTENT_PATH = "/content";
    protected static final String SELECTOR = "form";
    protected static final String CREATE_SELECTOR = "create";
    protected static final String READ_ONLY_SELECTOR = "view";
    private static final Logger log = LoggerFactory.getLogger(FormChooserServlet.class);
    @Reference
    private QueryBuilder queryBuilder;

    // ------------------------------------------------------------< servlet methods >

    public static boolean isNonExistingResource(Resource resource) {
        return "sling:nonexisting".equals(resource.getResourceType());
    }

    public static RequestPathInfo getPathInfo(SlingHttpServletRequest request) {
        if (isNonExistingResource(request.getResource())) {
            return new PathInfo(request.getResource().getPath());
        } else {
            return request.getRequestPathInfo();
        }
    }

    public static boolean hasSelector(RequestPathInfo pathInfo, String selector) {
        for (String s : pathInfo.getSelectors()) {
            if (s.equals(selector)) {
                return true;
            }
        }
        return false;
    }

    // -----------------------------------------------------------< internal methods >

    /**
     * This method is called to decide if this servlet will handle the request
     * for a sling:nonexisting resource.
     */
    public boolean accepts(SlingHttpServletRequest request) {
        return hasSelector(getPathInfo(request), SELECTOR);
    }

    @Override
    protected void doPost(SlingHttpServletRequest request,
                          SlingHttpServletResponse response) throws ServletException, IOException {

        doGet(request, response);
    }

    @Override
    protected void doGet(SlingHttpServletRequest request,
                         SlingHttpServletResponse response) throws ServletException,
            IOException {

        String formPath = findForm(request);
        if (formPath != null) {
            log.debug("using form: " + formPath);

            FormResourceEdit.setResources(request, collectResources(request));

            if (isReadOnly(request)) {
                FormsHelper.setFormReadOnly(request);
            }

            request.setAttribute("browsermap.enabled", false);
            forward(formPath, request, response);
        } else {
            log.debug("no form found");

            response.sendError(404, "No form found");
        }
    }

    protected boolean isReadOnly(SlingHttpServletRequest request) {
        return hasSelector(request.getRequestPathInfo(), READ_ONLY_SELECTOR);
    }

    protected String findForm(SlingHttpServletRequest request) {
        // a) the URL suffix can provide the full path to the target form:
        //      /content/dam/frog1.png.form.html/content/geometrixx/pngform

        // b) another selector specifies an alias (for shorter URLs)
        //      /content/dam/frog1.png.form.mypngform.html
        //
        //      - the alias would be stored in the form page as "cq:formAlias" property
        //      - in form-calling applications (eg. the calendar component for the event
        //        form), the author can choose which form to use by path; if an alias is
        //        present, this one is automatically used to build the form URL

        // c) if no suffix or selector is defined, a default form registered for the
        //      resource type of the current resource is searched
        //      /content/dam/frog1.png.form.html
        //
        //      - the form page that shall be the default form for a resource type must
        //        have a "cq:defaultFormFor" property

        RequestPathInfo pathInfo = getPathInfo(request);

        // a) suffix is present
        String suffix = pathInfo.getSuffix();
        if (suffix != null) {
            return suffix;
        }

        // b) use selector as form alias
        String[] selectors = pathInfo.getSelectors();
        String formAlias = null;
        if (selectors.length > 1) {
            // contains more than only "form"
            for (String selector : selectors) {
                if (!selector.equals(SELECTOR) && !selector.equals(CREATE_SELECTOR)) {
                    formAlias = selector;
                    break;
                }
            }
        }
        if (formAlias != null) {
            // find forms with this alias
            List<String> list = search(null, PN_FORM_ALIAS, formAlias, request.getResourceResolver());
            if (list.size() > 0) {
                return list.get(0);
            }
        }

        // c) look for a default form for this resource type
        List<String> list = search(null, PN_FORM_DEFAULT_RT, request.getResource().getResourceType(), request.getResourceResolver());
        if (list.size() > 0) {
            return list.get(0);
        }

        return null;
    }

    protected void forward(String path, SlingHttpServletRequest request, SlingHttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcherOptions options = new RequestDispatcherOptions();
        options.setReplaceSelectors(null);
        options.setReplaceSuffix(null);

        // #34402 - tolerate suffixes ending with ".html"
        if (path.endsWith(".html")) {
            path = path.substring(0, path.length() - ".html".length());
        }

        // pass on all selectors except our selector (form)
        StringBuffer includePath = new StringBuffer(path);

        // solution for bug #23286: set same context + avoid wcm page ProxyServlet
        IncludeOptions.getOptions(request, true).forceSameContext(true);
        includePath.append("/jcr:content");

        for (String selector : request.getRequestPathInfo().getSelectors()) {
            if (!selector.equals(SELECTOR)) {
                includePath.append(".").append(selector);
            }
        }
        includePath.append(".html");

        RequestDispatcher dispatcher = request.getRequestDispatcher(includePath.toString(), options);
        // use forward instead of include to start with a fresh wcm page/component context (bug #26393)
        dispatcher.forward(new FormsHandlingRequest(request), response);
    }

    protected List<String> search(String nodeType, String property, String value, ResourceResolver resolver) {
        final List<String> result = new ArrayList<String>();

        final StringBuilder buffer = new StringBuilder();
        if (nodeType != null) {
            buffer.append("//element(*, ").append(nodeType).append(")");
        } else {
            buffer.append("//*");
        }
        buffer.append("[@");
        buffer.append(property);
        buffer.append("='");
        buffer.append(value);
        buffer.append("']");

        log.debug("Query: {}", buffer.toString());
        final Iterator<Resource> iter = resolver.findResources(buffer.toString(), "xpath");
        while (iter.hasNext()) {
            result.add(iter.next().getPath());
        }

        // make sure the list is sorted by search path
        Collections.sort(result, new SearchPathComparator(getFormSearchPath(resolver)));

        return result;
    }

    // ------------------------------------------------< path info helper >

    /**
     * Returns the resource resolver's search path, prefixed with "/content",
     * because user-defined form pages in /content have precedence over
     * everything.
     */
    protected List<String> getFormSearchPath(ResourceResolver resolver) {
        List<String> searchPath = new ArrayList<String>();
        searchPath.add(CONTENT_PATH);
        for (String path : resolver.getSearchPath()) {
            searchPath.add(path);
        }
        return searchPath;
    }

    @SuppressWarnings("unchecked")
    protected List<Resource> collectResources(SlingHttpServletRequest request) {
        List<Resource> resources = new ArrayList<Resource>();

        if (isNonExistingResource(request.getResource())) {
            // only handle the single, non existing resource
            String nonExistentPath = new PathInfo(request.getResource().getPath()).getResourcePath();
            resources.add(new NonExistingResource(request.getResourceResolver(), nonExistentPath));
            return resources;
        } else if (hasSelector(request.getRequestPathInfo(), CREATE_SELECTOR)) {
            // explicit commando to create a new resource at this path or as node below it
            // make sure the path ends with a / for the forms handling servlet
            String path = request.getResource().getPath();
            resources.add(new NonExistingResource(request.getResourceResolver(), path.endsWith("/") ? path : path + "/"));
            return resources;
        }

        String[] paths = request.getParameterValues(FormResourceEdit.RESOURCES_PARAM);

        ResourceResolver resolver = request.getResourceResolver();

        if (request.getParameter(REQ_PARAM_QUERY) != null) {
            // case 1): querybuilder query that defines the list of resources
            log.debug("resources defined by query");

            Map map = new HashMap(request.getParameterMap());
            // remove the query flag
            map.remove(REQ_PARAM_QUERY);
            Session session = resolver.adaptTo(Session.class);
            if (session != null) {
                Query query = queryBuilder.createQuery(PredicateConverter.createPredicates(map), session);
                SearchResult result = query.getResult();
                for (Hit hit : result.getHits()) {
                    try {
                        resources.add(hit.getResource());
                    } catch (RepositoryException e) {
                        log.error("could not get resource from hit", e);
                    }
                }
            } else {
                log.warn("cannot execute query: no session found in request");
            }

        } else if (paths != null && paths.length >= 1) {
            // case 2): paths define the list of resources (+ the current one)
            log.debug("multiple resources");

            resources.add(request.getResource());
            String resPath = request.getResource().getPath();
            for (String path : paths) {
                if (resPath.equals(path)) continue; // path already set by resource
                Resource res = resolver.resolve(path);
                if (res != null) {
                    resources.add(res);
                }
            }
        } else {
            // case 3): current resource only
            log.debug("single resource only");
            resources.add(request.getResource());
        }

        if (log.isDebugEnabled()) {
            for (Resource res : resources) {
                log.debug("resource: " + res);
            }
        }

        return resources;
    }

    /**
     * Compares two paths based on a given search path order (eg. /content,
     * /apps, /libs). The path with the lower search path index is preferred (in
     * this example: /content/foo before /apps/bar).
     */
    private static class SearchPathComparator implements Comparator<String> {

        private List<String> searchPath;

        public SearchPathComparator(List<String> searchPath) {
            this.searchPath = searchPath;
        }

        public int compare(String path1, String path2) {
            int index1 = getSearchPathIndex(path1);
            int index2 = getSearchPathIndex(path2);
            return index2 - index1;
        }

        private int getSearchPathIndex(String path) {
            for (int i = 0; i < searchPath.size(); i++) {
                if (path.startsWith(searchPath.get(i))) {
                    return i;
                }
            }
            return searchPath.size() + 1;
        }

    }
}
