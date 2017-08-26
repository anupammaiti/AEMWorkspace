/*
 * Copyright 1997-2011 Day Management AG
 * Barfuesserplatz 6, 4001 Basel, Switzerland
 * All Rights Reserved.
 *
 * This software is the confidential and proprietary information of
 * Day Management AG, ("Confidential Information"). You shall not
 * disclose such Confidential Information and shall use it only in
 * accordance with the terms of the license agreement you entered into
 * with Day.
 */
package com.day.cq.wcm.foundation.forms;

import static org.apache.sling.servlets.post.SlingPostConstants.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Enumeration;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.TreeMap;

import javax.jcr.RepositoryException;
import javax.jcr.Session;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;

import org.apache.commons.collections.CollectionUtils;
import org.apache.jackrabbit.util.Text;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.request.RequestDispatcherOptions;
import org.apache.sling.api.request.RequestParameter;
import org.apache.sling.api.request.RequestParameterMap;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ResourceResolver;
import org.apache.sling.api.resource.ValueMap;
import org.apache.sling.api.wrappers.SlingHttpServletRequestWrapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * Helper class for bulk editing of multiple resources via CQ forms and the
 * Sling POST servlet.
 * 
 * @since 5.5
 */
public abstract class FormResourceEdit {
    
    private static final Logger log = LoggerFactory.getLogger(FormResourceEdit.class);

    public static final String RESOURCES_ATTRIBUTE = "cq.form.editresources";

    public static final String RESOURCES_PARAM = ":resource";

    public static final String REOPEN_PARAM = "reopen";

    // suffix for checkbox which indicates if a property has to be written if multiple resources are loaded
    public static final String WRITE_SUFFIX = "@Write";

    /**
     * Sets the list of resources to be handled by the "edit" resources form action.
     * @param req current request
     * @param resources the list of resources
     */
    public static void setResources(ServletRequest req, List<Resource> resources) {
        req.setAttribute(RESOURCES_ATTRIBUTE, resources);
    }
    
    /**
     * Get the list of resources to be handled by the "edit" resources form action.
     * @param req current request
     * @return the list of resources (or <code>null</code> if not set)
     */
    @SuppressWarnings("unchecked")
    public static List<Resource> getResources(ServletRequest req) {
        return (List<Resource>) req.getAttribute(RESOURCES_ATTRIBUTE);
    }

    /**
     * Retrieves a resource that presents a synthetic resource with merged
     * values for all the given resources. Uses {@link MergedValueMap}.
     * 
     * @param resources
     *            list of resources to merge
     * @return a synthetic resource with merged values
     */
    public static Resource getMergedResource(List<Resource> resources) {
        return new MergedMultiResource(resources);
    }

    /**
     * Helper struct for the result of
     * {@link FormResourceEdit#getCommonAndPartialMultiValues(List, String)}.
     */
    public static class CommonAndPartial {
        /**
         * Common values, present in all multi-value properties.
         */
        public Set<String> common = new HashSet<String>();
        /**
         * Partial values, present only in one or a few multi-value properties,
         * but not in all.
         */
        public Set<String> partial = new HashSet<String>();
    }

    /**
     * Calculates the set of common values and the set of partially present
     * values for a multi-value property on a list of resources. The
     * {@link #common} values will be the ones that are present in the property
     * in all resources, whereas the {@link #partial} values will be the set of
     * all values that are present at least in one resource, but not all of
     * them. The multi-value property is seen as set, so the order and multiple
     * occurences of the same value in a single property do not make any
     * difference.
     * 
     * @param resources
     *            a list of resources
     * @param name
     *            the name of the multi-value property to inspect
     * @return a struct object with the {@link #common} and {@link #partial}
     *         sets of values
     */
    @SuppressWarnings("unchecked")
    public static CommonAndPartial getCommonAndPartialMultiValues(List<Resource> resources, String name) {
        CommonAndPartial r = new CommonAndPartial();
        
        boolean firstResource = true;
        for (Resource resource : resources) {
            ValueMap map = resource.adaptTo(ValueMap.class);
            if (map != null) {
                String[] values = map.get(name, new String[0]);
                if (firstResource) {
                    for (String v: values) {
                        r.common.add(v);
                    }
                    firstResource = false;
                } else {
                    List<String> newValues = Arrays.asList(values);
                    // partial: add all that are not in common
                    r.partial.addAll(CollectionUtils.disjunction(r.common, newValues));
                    // common: reset to only what actually overlaps, all the time
                    r.common = new HashSet<String>(CollectionUtils.intersection(r.common, newValues));
                }
            }
        }
        return r;
    }

    /**
     * Returns if exactly a single resource is handled by the "edit" resource
     * form action.
     * 
     * @param req
     *            current request
     * @return true if a single resource is handled, false if multiple resources
     *         or no resource at all is handled
     */
    public static boolean isSingleResource(ServletRequest req) {
        List<Resource> r = getResources(req);
        return r != null && r.size() == 1;
    }

    /**
     * Returns if multiple resources are handled by the "edit" resource form
     * action.
     * 
     * @param req
     *            current request
     * @return true if multiple resources are handled, false if a single or no
     *         resource at all is handled
     */
    public static boolean isMultiResource(ServletRequest req) {
        List<Resource> r = getResources(req);
        return r != null && r.size() > 1;
    }

    /**
     * Returns whether the given form POST based on the "edit" resource action
     * targets a single resource.
     * 
     * @param request
     *            current request
     * @return if a single resource is target of the POST
     */
    public static boolean isSingleResourcePost(SlingHttpServletRequest request) {
        RequestParameter[] resourceParams = request.getRequestParameters(RESOURCES_PARAM);
        return resourceParams == null || resourceParams.length == 1;
    }

    /**
     * Returns whether the given form POST based on the "edit" resource action
     * targets multiple resources.
     * 
     * @param request
     *            current request
     * @return if multiple resources are target of the POST
     */
    public static boolean isMultiResourcePost(SlingHttpServletRequest request) {
        RequestParameter[] resourceParams = request.getRequestParameters(RESOURCES_PARAM);
        return resourceParams != null && resourceParams.length > 1;
    }
    
    /**
     * Returns the (unvalidated) path of the single resource that is target of
     * the form POST request. If this is not a form POST based on the "edit"
     * resource action or if multiple resources are the target, this will return
     * <code>null</code>.
     * 
     * @param request
     *            current request
     * @return path of the resource or <code>null</code>
     */
    public static String getPostResourcePath(SlingHttpServletRequest request) {
        RequestParameter[] resourceParams = request.getRequestParameters(RESOURCES_PARAM);
        if (resourceParams != null && resourceParams.length == 1) {
            return resourceParams[0].getString();
        }
        return null;
    }

    /**
     * Returns a list of all resources that are the target of the form POST
     * request based on the "edit" resource action, and which can actually
     * be written to using the request session.
     * 
     * @param request
     *            current request
     * @return list with all resolved target resources
     */
    public static List<Resource> getPostResources(SlingHttpServletRequest request) {
        ResourceResolver resolver = request.getResourceResolver();
        RequestParameter[] resourceParams = request.getRequestParameters(RESOURCES_PARAM);
        Session session = request.getResourceResolver().adaptTo(Session.class);

        List<Resource> resources = new ArrayList<Resource>();
        if (resourceParams != null) {
            for (RequestParameter rp : resourceParams) {
                Resource r = resolver.getResource(rp.getString());
                try {
                    if (r != null && session.hasPermission(r.getPath(), Session.ACTION_SET_PROPERTY)) {
                        resources.add(r);
                    }
                } catch (RepositoryException e) {
                    log.error("Could not check write permission on node", e);
                }
            }
        }
        return resources;
    }

    /**
     * Performs a Sling POST servlet modify operation, but on multiple
     * resources.
     * <p>
     * The Sling POST servlet (more specifically, its modify operation) itself
     * can only handle a single resource (using the request resource) or by
     * using absolute paths to properties. This method will automatically
     * rewrite the parameters for the multiple resources and then call the Sling
     * POST servlet. All resources will be changed in a single transaction. The
     * response will look like the standard Sling POST response.
     * 
     * @param resources
     *            list of resources to bulk-edit
     * @param request
     *            current POST request, including the parameters for the Sling
     *            POST servlet
     * @param response
     *            current response
     * @throws ServletException
     * @throws IOException
     */
    public static void multiPost(List<Resource> resources, SlingHttpServletRequest request, SlingHttpServletResponse response) throws ServletException, IOException {
        // 1. rewrite request params
        
        final RequestParameterMap originalParams = request.getRequestParameterMap();
        
        // group params by their property
        //
        // foo => foo = 1.1.2011
        //        foo@Delete = x
        //        foo@TypeHint = Date
        // bar => bar = test
        // ...
        Map<String, Map<String, RequestParameter[]> > groupedParams = new TreeMap<String, Map<String,RequestParameter[]>>();
        
        // 1. collect params, identify which to consider for writing
        
        boolean requireItemPrefix = false;
        
        Set<String> paramsToKeep   = new HashSet<String>();
        Set<String> paramsToRemove = new HashSet<String>();
        
        for (Entry<String, RequestParameter[]> param : originalParams.entrySet()) {
            final String name = param.getKey();
            
            if (RP_OPERATION.equals(name)) {
                String op = originalParams.getValue(name).getString();
                // abort if operation is not modify as we can't bulk create/copy/move/checkin/checkout
                if (!"modify".equals(op)) {
                    throw new ServletException("Only :operation=modify can be used when posting to multiple resources (was: '" + op + "')");
                }
            }
            
            if (name.startsWith(ITEM_PREFIX_RELATIVE_CURRENT)) {
                requireItemPrefix = true;
            }
            
            // if param name ends with "@something", the property name is the part before it
            final int pos = name.indexOf("@");
            String propName = pos >= 0 ? name.substring(0, pos) : name;
            
            // add to map or use already existing entry for this property
            Map<String, RequestParameter[]> map = groupedParams.get(propName);
            if (map == null) {
                groupedParams.put(propName, map = new TreeMap<String, RequestParameter[]>());
            }
            map.put(name, param.getValue());
            
            // properties to write end with @Write
            if (name.endsWith(WRITE_SUFFIX)) {
                paramsToKeep.add(propName);
                map.remove(name); // we don't need the "@Write" param in the sling post servlet
            }
            
            // remove form params (for cleaner request, technically not needed, as they are ignored by sling anyway)
            if (FormsConstants.REQUEST_PROPERTY_FORMID.equals(name)
                    || FormsConstants.REQUEST_PROPERTY_FORM_START.equals(name)
                    || RESOURCES_PARAM.equals(name)) {
                continue;
            }
            
            // all special :something sling post params must be kept
            if (name.startsWith(RP_PREFIX)) {
                paramsToKeep.add(name);
            }
            
            // @MoveFrom must be ignored (doesn't work for multiple resources)
            if (name.endsWith(SUFFIX_MOVE_FROM)) {
                paramsToRemove.add(propName);
            }
        }
        
        // 2. remove params that should not be written
        
        for (Iterator<String> iter = groupedParams.keySet().iterator(); iter.hasNext();) {
            String name = iter.next();
            if (!paramsToKeep.contains(name) || paramsToRemove.contains(name)) {
                iter.remove();
            }
        }
        
        // 3. rewrite params for each resource
        
        ParameterMap params = new ParameterMap();
        
        log.debug("posting to multiple resources:");
        
        boolean first = true;
        for (Resource r: resources) {
            String path = r.getPath();
            log.debug("{}", path);
            
            for (Map<String, RequestParameter[]> p : groupedParams.values()) {
                for (Entry<String, RequestParameter[]> param : p.entrySet()) {
                    String name = param.getKey();
                    
                    // include :params and absolute paths only once and don't rewrite them
                    if (name.startsWith(RP_PREFIX) || name.startsWith(ITEM_PREFIX_ABSOLUTE)) {
                        if (first) {
                            params.put(name, param.getValue());
                        }
                    } else if (requireItemPrefix) {
                        // only use params with item prefix (and skip others)
                        if (name.startsWith(ITEM_PREFIX_RELATIVE_CURRENT)) {
                            params.put(path + "/" + name.substring(ITEM_PREFIX_RELATIVE_CURRENT.length()), param.getValue());
                        } else if (name.startsWith(ITEM_PREFIX_RELATIVE_PARENT)) {
                            path = Text.getRelativeParent(path, 1);
                            params.put(path + "/" + name.substring(ITEM_PREFIX_RELATIVE_PARENT.length()), param.getValue());
                        }
                    } else /* if (!requireItemPrefix) */ {
                        // rewrite all params
                        params.put(path + "/" + name, param.getValue());
                    }
                }
            }
            first = false;
        }
        
        if (log.isDebugEnabled()) {
            log.debug("rewritten parameters:");
            logParams(params);
        }
        
        // 4. send new internal request to sling post servlet
        
        // forward but make sure we remove the "forms" selector and the suffix
        RequestDispatcherOptions options = new RequestDispatcherOptions();
        options.setReplaceSelectors("");
        options.setReplaceSuffix("");
        RequestDispatcher dispatcher = request.getRequestDispatcher(request.getResource(), options);
        dispatcher.forward(new CustomParameterRequest(request, params), response);
    }
    
    private static void logParams(Map<String, RequestParameter[]> parameters) {
        for (Entry<String, RequestParameter[]> ps : parameters.entrySet()) {
            for (RequestParameter rp : ps.getValue()) {
                log.debug("{} = {}", ps.getKey(), rp.getString());
            }
        }
    }
    
    /**
     * Custom-tailored internal request to the Sling POST servlet, which wraps
     * an existing request but allows to overwrite the parameters. It uses
     * Sling's {@link RequestParameter}s, allowing to pass them through from the
     * original request, but also providing the standard String representation
     * of the parameters.
     */
    private static class CustomParameterRequest extends SlingHttpServletRequestWrapper {
        
        private ParameterMap parameters;

        public CustomParameterRequest(SlingHttpServletRequest request, ParameterMap params) {
            super(request);
            this.parameters = params;
        }

        @Override
        public RequestParameter getRequestParameter(String name) {
            return parameters.getValue(name);
        }

        @Override
        public RequestParameterMap getRequestParameterMap() {
            return parameters;
        }

        @Override
        public RequestParameter[] getRequestParameters(String name) {
            return parameters.getValues(name);
        }

        @Override
        public String getParameter(String name) {
            return parameters.getStringValue(name);
        }

        @Override
        public Map getParameterMap() {
            return parameters.getStringParameterMap();
        }

        @Override
        public Enumeration getParameterNames() {
            return Collections.enumeration(parameters.keySet());
        }

        @Override
        public String[] getParameterValues(String name) {
            return parameters.getStringValues(name);
        }
        
    }

    /**
     * Custom implementation of Sling's {@link RequestParameterMap} that we have
     * to provide for our custom-tailored internal request to the Sling POST
     * servlet.
     */
    private static class ParameterMap extends TreeMap<String, RequestParameter[]> implements RequestParameterMap {

        private static final long serialVersionUID = 4554110574522792609L;
        
        private Map<String, String[]> stringParameterMap;

        public RequestParameter[] getValues(String name) {
            return get(name);
        }

        public RequestParameter getValue(String name) {
            RequestParameter[] params = get(name);
            return (params != null && params.length > 0) ? params[0] : null;
        }

        //---------- String parameter support

        public String getStringValue(final String name) {
            final RequestParameter param = getValue(name);
            return (param != null) ? param.getString() : null;
        }

        public String[] getStringValues(final String name) {
            return toStringArray(getValues(name));
        }

        public Map<String, String[]> getStringParameterMap() {
            if (this.stringParameterMap == null) {
                LinkedHashMap<String, String[]> pm = new LinkedHashMap<String, String[]>();
                for (Map.Entry<String, RequestParameter[]> ppmEntry : entrySet()) {
                    pm.put(ppmEntry.getKey(), toStringArray(ppmEntry.getValue()));
                }
                this.stringParameterMap = Collections.unmodifiableMap(pm);
            }
            return stringParameterMap;
        }
        
        private static String[] toStringArray(final RequestParameter[] params) {
            if (params == null) {
                return null;
            }

            final String[] ps = new String[params.length];
            for (int i = 0; i < params.length; i++) {
                ps[i] = params[i].getString();
            }
            return ps;
        }
    }
}
