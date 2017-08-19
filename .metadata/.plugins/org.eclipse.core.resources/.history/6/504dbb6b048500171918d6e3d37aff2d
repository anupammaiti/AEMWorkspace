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

import java.io.IOException;
import java.util.Dictionary;
import java.util.Iterator;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Properties;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Service;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ResourceUtil;
import org.apache.sling.api.resource.ResourceWrapper;
import org.apache.sling.api.resource.ValueMap;
import org.apache.sling.api.servlets.OptingServlet;
import org.apache.sling.api.servlets.SlingAllMethodsServlet;
import org.apache.sling.commons.osgi.OsgiUtil;
import org.osgi.service.component.ComponentContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.day.cq.wcm.foundation.forms.FieldHelper;
import com.day.cq.wcm.foundation.forms.FormsConstants;
import com.day.cq.wcm.foundation.forms.FormsHelper;
import com.day.cq.wcm.foundation.forms.ValidationInfo;

/**
 * This forms handling servlet accepts POSTs to a form begin paragraph
 * but only if the selector "form" and the extension "html" is used.
 */
@SuppressWarnings("serial")
@Component(metatype = true, label = "Adobe CQ Form Handling Servlet",
        description = "Accepts posting to a form start component and performs validations")
@Service({Servlet.class, Filter.class})
@Properties({
        @Property(name = "sling.servlet.resourceTypes", value = "foundation/components/form/start", propertyPrivate = true),
        @Property(name = "sling.servlet.methods", value = "POST", propertyPrivate = true),
        @Property(name = "sling.servlet.selectors", value = FormsHandlingServlet.SELECTOR, propertyPrivate = true),
        @Property(name = "filter.scope", value = "request", propertyPrivate = true),
        @Property(name = "filter.order", intValue = -600, propertyPrivate = true),
        @Property(name = "service.description", value = "Form Handling Servlet")

})
public class FormsHandlingServlet
        extends SlingAllMethodsServlet
        implements OptingServlet, Filter {

    protected static final String EXTENSION = "html";
    protected static final String SELECTOR = "form";
    protected static final String ATTR_RESOURCE = FormsHandlingServlet.class.getName() + "/resource";
    protected final Logger logger = LoggerFactory.getLogger(getClass());

    @Property(value = {
            "^(:(?!applyTo).+)$",
            "^_charset_$"
    },
            label = "Parameter Name Whitelist",
            description = "List of name expressions that will pass request validation. A validation error will occur if any posted parameters are not in the whitelist and not defined on the form.")
    private static final String DATA_NAME_WHITELIST = "name.whitelist";
    private String[] dataNameWhitelist;

    protected void activate(ComponentContext componentContext) {
        Dictionary<String, Object> properties = componentContext.getProperties();
        dataNameWhitelist = OsgiUtil.toStringArray(properties.get(DATA_NAME_WHITELIST));
    }

    /**
     * @see org.apache.sling.api.servlets.OptingServlet#accepts(org.apache.sling.api.SlingHttpServletRequest)
     */
    public boolean accepts(final SlingHttpServletRequest request) {
        return EXTENSION.equals(request.getRequestPathInfo().getExtension());
    }

    /**
     * @see org.apache.sling.api.servlets.SlingAllMethodsServlet#doPost(org.apache.sling.api.SlingHttpServletRequest, org.apache.sling.api.SlingHttpServletResponse)
     */
    protected void doPost(SlingHttpServletRequest request,
                          final SlingHttpServletResponse response)
            throws ServletException, IOException {
        if (ResourceUtil.isNonExistingResource(request.getResource())
                || request.getAttribute(ATTR_RESOURCE) == null) {
            logger.debug("Received fake request!");
            response.setStatus(500);
            return;
        }
        if (this.logger.isDebugEnabled()) {
            this.logger.debug("Validating POST request with form definition stored at {}.", request.getResource().getPath());
        }

        SlingHttpServletRequest formsRequest = new FormsHandlingRequest(request);
        SlingHttpServletResponse formsResponse = new FormsHandlingResponse(response);

        // validate form
        final Resource formResource = request.getResource();
        // initialize request attributes
        FormsHelper.getFormId(request);

        ValidationInfo info;
        validate(formsRequest, formsResponse, formResource);
        final ValueMap properties = ResourceUtil.getValueMap(formResource);
        // check action type
        final String actionType = (properties == null ? "" : properties.get(FormsConstants.START_PROPERTY_ACTION_TYPE, ""));
        if (actionType.length() == 0) {
            info = ValidationInfo.createValidationInfo(request);
            info.addErrorMessage(null, "Unable to process the form: missing " + FormsConstants.START_PROPERTY_ACTION_TYPE);
        } else {
            // run any validations defined by the action type
            // these validations are a good place to protect against malicious content
            request.setAttribute(FormsHelper.REQ_ATTR_PROP_WHITELIST, dataNameWhitelist);
            FormsHelper.runAction(actionType, FormsConstants.SCRIPT_FORM_SERVER_VALIDATION, formResource, formsRequest, formsResponse);
            info = ValidationInfo.getValidationInfo(request);
        }

        if (info != null) {
            this.logger.debug("Form {} is not valid: {}", formResource.getPath(), info);
            // get real resource from request attribute
            final Resource rsrc = (Resource) request.getAttribute(ATTR_RESOURCE);
            request.removeAttribute(ATTR_RESOURCE);

            request.getRequestDispatcher(rsrc).forward(formsRequest, response);
            return;
        }

        // create forward path by invoking action script
        FormsHelper.runAction(actionType, "forward", formResource, formsRequest, formsResponse);

        String forwardPath = FormsHelper.getForwardPath(request);
        if (forwardPath != null && forwardPath.length() > 0) {
            // check for redirect flag
            if (FormsHelper.isRedirectToReferrer(request)) {
                if (request.getParameter(FormsConstants.REQUEST_PROPERTY_REDIRECT) == null) {
                    request = new RedirectRequest(request, FormsHelper.getReferrer(request));
                }
            }
            String redirect = FormsHelper.getForwardRedirect(request);
            if (redirect != null) {
                request = new RedirectRequest(request, redirect);
            }
            if (forwardPath.endsWith("/")) {
                forwardPath = forwardPath + '*';
            }
            // now forward
            final Resource forwardResource = request.getResourceResolver().resolve(forwardPath);
            request.getRequestDispatcher(forwardResource, FormsHelper.getForwardOptions(request)).forward(request, response);
            //cleanup
            FormsHelper.runAction(actionType, "cleanup", formResource, formsRequest, formsResponse);
            return;
        }

        // if no forward path is set, we "forward" to the post script
        FormsHelper.runAction(actionType, "post", formResource, request, response);
    }

    private ValidationInfo validate(final SlingHttpServletRequest request,
                                    final SlingHttpServletResponse response,
                                    final Resource formResource)
            throws ServletException, IOException {
        // we have to validate all elements
        final Iterator<Resource> iter = FormsHelper.getFormElements(formResource);
        while (iter.hasNext()) {
            final Resource formField = iter.next();
            FieldHelper.initializeField(request, response, formField);
            FormsHelper.includeResource(request, response, formField, FormsConstants.SCRIPT_SERVER_VALIDATION);
        }

        // in addition we check for a global validation RT
        // configured at the form resource
        final ValueMap properties = ResourceUtil.getValueMap(formResource);
        final String valScriptRT = properties.get(FormsConstants.START_PROPERTY_VALIDATION_RT, formResource.getResourceType());
        if (valScriptRT != null && valScriptRT.length() > 0) {
            Resource valScriptResource = formResource;
            if (!formResource.getResourceType().equals(valScriptRT)) {
                valScriptResource = new ResourceWrapper(formResource) {
                    @Override
                    public String getResourceType() {
                        return valScriptRT;
                    }

                    @Override
                    public String getResourceSuperType() {
                        return formResource.getResourceType();
                    }

                };
            }
            FormsHelper.includeResource(request, response, valScriptResource, FormsConstants.SCRIPT_FORM_SERVER_VALIDATION);
        }

        return ValidationInfo.getValidationInfo(request);
    }

    /**
     * @see javax.servlet.Filter#doFilter(javax.servlet.ServletRequest, javax.servlet.ServletResponse, javax.servlet.FilterChain)
     */
    public void doFilter(final ServletRequest request,
                         final ServletResponse response,
                         final FilterChain chain)
            throws IOException, ServletException {
        // check if this is a post to a form
        if (request instanceof SlingHttpServletRequest) {
            final SlingHttpServletRequest req = (SlingHttpServletRequest) request;
            if ("POST".equalsIgnoreCase(req.getMethod())
                    && req.getParameter(FormsConstants.REQUEST_PROPERTY_FORM_START) != null) {
                final String formPath = req.getParameter(FormsConstants.REQUEST_PROPERTY_FORM_START);
                final Resource formResource = ((SlingHttpServletRequest) request).getResourceResolver().getResource(formPath);
                //CQ-3620: only forward request if formPath exists AND is a form/start resource
                if (formResource != null && ResourceUtil.isA(formResource, FormsConstants.RT_FORM_BEGIN)) {
                    // store original resource as request attribute
                    req.setAttribute(ATTR_RESOURCE, req.getResource());
                    final StringBuilder sb = new StringBuilder();
                    if (!formPath.startsWith("/")) {
                        sb.append(req.getResource().getPath());
                        sb.append('/');
                    }

                    sb.append(formPath);
                    sb.append('.');
                    sb.append(SELECTOR);
                    sb.append('.');
                    sb.append(EXTENSION);
                    // forward to forms handling servlet
                    final String forwardPath = sb.toString();
                    req.getRequestDispatcher(forwardPath).forward(request, response);

                    return;
                }
            }
        }

        chain.doFilter(request, response);
    }

    /**
     * @see javax.servlet.Filter#init(javax.servlet.FilterConfig)
     */
    public void init(final FilterConfig config) throws ServletException {
        // nothing to do!
    }
}
