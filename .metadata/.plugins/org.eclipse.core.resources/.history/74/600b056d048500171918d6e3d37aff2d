/*
 * Copyright 1997-2010 Day Management AG
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

import com.adobe.granite.xss.XSSAPI;
import com.day.cq.commons.jcr.JcrConstants;
import com.day.cq.wcm.api.LanguageManager;
import com.day.cq.wcm.api.WCMMode;
import com.day.cq.wcm.api.components.ComponentContext;
import com.day.cq.wcm.foundation.ELEvaluator;
import com.day.cq.wcm.foundation.forms.impl.FormChooserServlet;
import com.day.cq.wcm.foundation.forms.impl.FormsManagerImpl;
import com.day.cq.wcm.foundation.forms.impl.FormsUtil;
import com.day.cq.wcm.foundation.forms.impl.JspSlingHttpServletResponseWrapper;
import com.day.cq.wcm.foundation.forms.impl.ResourceWrapper;
import com.day.cq.widget.HtmlLibraryManager;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.request.RequestDispatcherOptions;
import org.apache.sling.api.request.RequestParameter;
import org.apache.sling.api.request.RequestParameterMap;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ResourceResolver;
import org.apache.sling.api.resource.ResourceUtil;
import org.apache.sling.api.resource.ValueMap;
import org.apache.sling.api.scripting.SlingBindings;
import org.apache.sling.api.scripting.SlingScriptHelper;
import org.apache.sling.commons.json.JSONException;
import org.apache.sling.commons.json.jcr.JsonItemWriter;
import org.apache.sling.jcr.resource.JcrResourceConstants;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.jcr.Node;
import javax.jcr.NodeIterator;
import javax.jcr.RepositoryException;
import javax.jcr.Session;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.PageContext;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.io.Writer;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.security.AccessControlException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.ResourceBundle;

/**
 * Helper class for the forms components.
 */
public class FormsHelper {

    /** The logger. */
    private static final Logger LOGGER = LoggerFactory.getLogger(FormsHelper.class.getName());

    private FormsHelper() {
        // no instances
    }

    public static final String REQ_ATTR_GLOBAL_LOAD_MAP      = "cq.form.loadmap";
    public static final String REQ_ATTR_GLOBAL_LOAD_RESOURCE = "cq.form.loadresource";
    public static final String REQ_ATTR_EDIT_RESOURCES       = FormResourceEdit.RESOURCES_ATTRIBUTE;
    public static final String REQ_ATTR_CLIENT_VALIDATION    = "cq.form.clientvalidation";
    public static final String REQ_ATTR_FORMID               = "cq.form.id";
    public static final String REQ_ATTR_WRITTEN_JAVASCRIPT   = "cq.form.javascript";
    public static final String REQ_ATTR_ACTION_SUFFIX        = "cq.form.action.suffix";
    public static final String REQ_ATTR_FORWARD_PATH         = "cq.form.forward.path";
    public static final String REQ_ATTR_FORWARD_OPTIONS      = "cq.form.forward.options";
    public static final String REQ_ATTR_IS_INIT              = "cq.form.init";
    public static final String REQ_ATTR_READ_ONLY            = "cq.form.readonly";
    public static final String REQ_ATTR_REDIRECT             = "cq.form.redirect";
    public static final String REQ_ATTR_REDIRECT_TO_REFERRER = FormsConstants.REQUEST_ATTR_REDIRECT_TO_REFERRER;
    public static final String REQ_ATTR_PROP_WHITELIST         = "cq.form.prop.whitelist";

    /**
     * Signal the start of the form.
     * Prepare the request object, write out the client javascript (if the form
     * is configured accordingly) and write out the start form tag and hidden fields:
     * {@link FormsConstants#REQUEST_PROPERTY_FORMID} with the value of the form id.
     * {@link FormsConstants#REQUEST_PROPERTY_FORM_START} with the relative path to the form start par
     * and <code>_charset_</code> with the value <code>UTF-8</code>
     *
     * @param request The current request.
     * @param response The current response.
     * @param out The jsp writer.
     * @deprecated Use {@link #startForm(SlingHttpServletRequest, SlingHttpServletResponse)}
     */
    @Deprecated
    public static void startForm(final SlingHttpServletRequest request,
                                 final SlingHttpServletResponse response,
                                 final JspWriter out)
    throws IOException, ServletException {
        startForm(request, new JspSlingHttpServletResponseWrapper(response, out));
    }

    /**
     * Signal the start of the form.
     * Prepare the request object, write out the client javascript (if the form
     * is configured accordingly) and write out the start form tag and hidden fields:
     * {@link FormsConstants#REQUEST_PROPERTY_FORMID} with the value of the form id.
     * {@link FormsConstants#REQUEST_PROPERTY_FORM_START} with the relative path to the form start par
     * and <code>_charset_</code> with the value <code>UTF-8</code>
     *
     * @param request The current request.
     * @param response The current response.
     * @since 5.3
     */
    public static void startForm(final SlingHttpServletRequest request,
                                 final SlingHttpServletResponse response)
    throws IOException, ServletException {
        // get resource and properties
        final Resource formResource = request.getResource();
        initialize(request, formResource, response);

        writeJavaScript(request, response, formResource);
        
        final ValueMap properties = ResourceUtil.getValueMap(formResource);
        String formId = properties.get("id", "");
        if(StringUtils.isEmpty(formId))
        	formId = getFormId(request);
        // write form element, we post to the same url we came from
        final PrintWriter out = response.getWriter();
        String url = request.getRequestURI();

        final String suffix = getActionSuffix(request);
        if (StringUtils.isNotBlank(suffix)) {
            url += (suffix.startsWith("/")) ? suffix : "/" + suffix;
        }

        SlingBindings bindings = (SlingBindings) request.getAttribute(SlingBindings.class.getName());
        XSSAPI xssAPI = bindings.getSling().getService(XSSAPI.class).getRequestSpecificAPI(request);
        String cssClass = properties.get("css", "");
        out.print("<form method=\"POST\" action=\"");
        out.print(xssAPI.getValidHref(url));
        out.print("\" id=\"");
        out.print(xssAPI.encodeForHTMLAttr(formId));
        out.print("\" name=\"");
        out.print(xssAPI.encodeForHTMLAttr(formId));
        if(!StringUtils.isEmpty(cssClass)){
        	out.print("\" class=\"");
            out.print(xssAPI.encodeForHTMLAttr(cssClass));
        }
        out.print("\" enctype=\"multipart/form-data\">");

        // write form id as hidden field
        out.print("<input type=\"hidden\" name=\"");
        out.print(FormsConstants.REQUEST_PROPERTY_FORMID);
        out.print("\" value=\"");
        out.print(xssAPI.encodeForHTMLAttr(formId));
        out.print("\"/>");
        // write form start as hidden field
        out.print("<input type=\"hidden\" name=\"");
        out.print(FormsConstants.REQUEST_PROPERTY_FORM_START);
        out.print("\" value=\"");
        if ( formResource.getPath().startsWith(url) ) {
            // relative
            out.print(formResource.getPath().substring(url.length() + 1));
        } else {
            // absolute
            out.print(formResource.getPath());
        }
        out.print("\"/>");
        // write charset as hidden field
        out.print("<input type=\"hidden\" name=\"_charset_\" value=\"UTF-8\"/>");

        // check for redirect configuration
        String redirect = properties.get("redirect", "");
        if ( redirect.length() > 0 ) {
            redirect = request.getResourceResolver().map(request, redirect);
            final int lastSlash = redirect.lastIndexOf('/');
            if ( redirect.indexOf('.', lastSlash) == -1 ) {
                redirect = redirect + ".html";
            }
            out.print("<input type=\"hidden\" name=\"" + FormsConstants.REQUEST_PROPERTY_REDIRECT + "\" value=\"");
            out.print(xssAPI.encodeForHTMLAttr(redirect));
            out.print("\"/>");
        }

        // allow action to add form fields
        final String actionType = properties.get(FormsConstants.START_PROPERTY_ACTION_TYPE, "");
        if (actionType.length() > 0) {
            runAction(actionType, "addfields", formResource, request, response);
        }
    }

    /**
     * Initialize the current request object.
     * Provide the required environment for form elements.
     */
    private static void initialize(final SlingHttpServletRequest request,
                                   final Resource formResource,
                                   final SlingHttpServletResponse response)
    throws IOException, ServletException {
        final ValueMap properties = ResourceUtil.getValueMap(formResource);

        // set some "variables"
        final Boolean clientValidation = properties.get(FormsConstants.START_PROPERTY_CLIENT_VALIDATION, Boolean.FALSE);
        request.setAttribute(REQ_ATTR_CLIENT_VALIDATION, clientValidation);
        request.setAttribute(REQ_ATTR_FORMID, properties.get(FormsConstants.START_PROPERTY_FORMID, "new_form"));

        request.setAttribute(REQ_ATTR_IS_INIT, "true");

        // now invoke init script for action (if response is set)
        if (response != null) {
            final String actionType = properties.get(FormsConstants.START_PROPERTY_ACTION_TYPE, FormsConstants.DEFAULT_ACTION_TYPE);
            if (actionType.length() != 0) {
                runAction(actionType, "init", formResource, request, response);
            }
        }

        // check for load path
        if ( request.getAttribute(REQ_ATTR_GLOBAL_LOAD_MAP) == null ) {
            Resource loadResource = null;
            final String loadPath = properties.get(FormsConstants.START_PROPERTY_LOAD_PATH, "");
            if ( loadPath.length() > 0 ) {
                loadResource = formResource.getResourceResolver().getResource(loadPath);
            }
            FormsHelper.setFormLoadResource(request, loadResource);
        }

    }

    /**
     * Runs/includes a script of the form action.
     */
    public static void runAction(final String actionType,
                                 final String scriptName,
                                 final Resource formResource,
                                 final SlingHttpServletRequest request,
                                 final SlingHttpServletResponse response) throws IOException, ServletException {

        String rt = actionType;
        // eg. foundation/components/form/actions/TYPE
        if (actionType.indexOf('/') == -1) {
            rt = FormsConstants.RT_FORM_ACTION + "s/" + actionType;
        }

        final Resource includeResource = new ResourceWrapper(formResource, rt, FormsConstants.RST_FORM_ACTION);
        FormsHelper.includeResource(request, response, includeResource, scriptName);
    }

    /**
     * Check if the request is initialized.
     * This method checks if a form start has already been processed during this
     * request. The check is usually only required in author mode where a form
     * element might be requested directly (and not by a complete page reload).
     * @param request The current request.
     */
    private static void checkInit(final SlingHttpServletRequest request) {
        if ( request.getAttribute(REQ_ATTR_IS_INIT) == null ) {
            // search the form start element
            final Resource formStart = searchFormStart(request.getResource());
            try {
                initialize(request, formStart, null);
            } catch (IOException e) {
                // this can never happen
            } catch (ServletException e) {
                // this can never happen
            }
        }
    }

    /**
     * Search the form start for the current form element.
     */
    private static Resource searchFormStart(final Resource resource) {
        if ( ResourceUtil.getName(resource).equals(JcrConstants.JCR_CONTENT) ) {
            return null;
        }
        if ( resource.getPath().lastIndexOf("/") == 0 ) {
            return null;
        }
        if ( checkResourceType(resource, FormsConstants.RT_FORM_BEGIN) ) {
            return resource;
        }
        // first, we have to collect all predecessors
        final Resource parent = ResourceUtil.getParent(resource);
        final List<Resource> predecessor = new ArrayList<Resource>();
        final Iterator<Resource> i = ResourceUtil.listChildren(parent);
        while ( i.hasNext() ) {
            final Resource current = i.next();
            if ( current.getPath().equals(resource.getPath()) ) {
                break;
            }
            predecessor.add(current);
        }
        // reverse the order, to get the immediate predecessors first
        Collections.reverse(predecessor);
        // iterate, as soon as we find a form begin, we're done
        // as soon as we find a form end, the form begin is missing for this form
        final Iterator<Resource> rsrcIter = predecessor.iterator();
        while ( rsrcIter.hasNext() ) {
            final Resource current = rsrcIter.next();
            if ( checkResourceType(current, FormsConstants.RT_FORM_BEGIN) ) {
                return resource;
            }
            if ( checkResourceType(current, FormsConstants.RT_FORM_END) ) {
                return null;
            }
        }
        return searchFormStart(parent);
    }

    /**
     * Check the type of the resource.
     * @return <code>true</code> if the type or super type is the given type.
     * @since 5.2
     */
    private static boolean checkResourceType(final Resource resource, final String type) {
        return ResourceUtil.isA(resource, type);
    }

    /**
     * Signal the end of the form.
     * @param req Request
     */
    public static void endForm(final SlingHttpServletRequest req) {
        FormsHelper.setFormLoadResource(req, null);
        req.removeAttribute(REQ_ATTR_CLIENT_VALIDATION);
        req.removeAttribute(REQ_ATTR_FORMID);
        req.removeAttribute(REQ_ATTR_IS_INIT);
    }

    /**
     * Set the forward path for processing the form.
     * @param req The current request.
     * @param path The forward path.
     */
    public static void setForwardPath(final SlingHttpServletRequest req, final String path) {
        setForwardPath(req, path, false);
    }

    /**
     * Set the forward path for processing the form and makes sure the "form"
     * selector from the form request is cleared upon forwarding. This is
     * usually required if the forward should go to the sling POST servlet, to
     * avoid conflicts with the form chooser.
     * 
     * <p>
     * This is not required if the forward path already contains an extension
     * and possible selectors, in which case these overwrite the form request
     * selector anyway.
     * 
     * <p>
     * * This uses
     * {@link #setForwardOptions(ServletRequest, RequestDispatcherOptions)
     * setForwardOptions} with
     * {@link RequestDispatcherOptions#setReplaceSelectors(String)
     * RequestDispatcherOptions.setReplaceSelectors("")}.
     * 
     * @since 5.5
     * 
     * @param req
     *            The current request.
     * @param path
     *            The forward path.
     * @param clearFormSelector
     *            if the "form" selector should be cleared
     */
    public static void setForwardPath(final SlingHttpServletRequest req, final String path, final boolean clearFormSelector) {
        req.setAttribute(REQ_ATTR_FORWARD_PATH, path);

        if (clearFormSelector) {
            RequestDispatcherOptions options = new RequestDispatcherOptions();
            options.setReplaceSelectors("");
            setForwardOptions(req, options);
        }
    }
    
    /**
     * Get the forward path for processing the form.
     * @param req The current request.
     * @return The forward path or null.
     */
    public static String getForwardPath(final SlingHttpServletRequest req) {
        return (String)req.getAttribute(REQ_ATTR_FORWARD_PATH);
    }

    /**
     * Sets the Sling {@link RequestDispatcherOptions} to be used when
     * forwarding to {@link #getForwardPath(SlingHttpServletRequest)}.
     * 
     * @since 5.5
     * 
     * @param req
     *            The current request
     * @param options
     *            options to use with forward path
     */
    public static void setForwardOptions(final ServletRequest req, final RequestDispatcherOptions options) {
        req.setAttribute(REQ_ATTR_FORWARD_OPTIONS, options);
    }

    /**
     * Gets the Sling {@link RequestDispatcherOptions} to be used when
     * forwarding to {@link #getForwardPath(SlingHttpServletRequest)}.
     * 
     * @since 5.5
     *
     * @param req
     *            The current request
     * @return options to use with forward path or <code>null</code>
     */
    public static RequestDispatcherOptions getForwardOptions(final ServletRequest req) {
        return (RequestDispatcherOptions) req.getAttribute(REQ_ATTR_FORWARD_OPTIONS);
    }

    /**
     * Sets the Sling POST serlvet's ":redirect" parameter dynamically during
     * the form POST execution, when
     * {@link #setForwardPath(SlingHttpServletRequest, String)} is used.
     * 
     * @since 5.5
     * 
     * @param request
     *            the current request
     * @param redirect
     *            a redirect path/url
     */
    public static void setForwardRedirect(final ServletRequest request, String redirect) {
        request.setAttribute(REQ_ATTR_REDIRECT, redirect);
    }

    /**
     * Returns the redirect to inject as ":redirect" parameter for the Sling
     * POST servlet, when a form
     * {@link #setForwardPath(SlingHttpServletRequest, String) forward} is done.
     * 
     * @since 5.5
     * 
     * @param request
     *            the current request
     * @returna redirect path/url
     */
    public static String getForwardRedirect(final ServletRequest request) {
        return (String) request.getAttribute(REQ_ATTR_REDIRECT);
    }
    
    /**
     * Set a request suffix to be added to the form action's URI.
     * @param req The current request.
     * @param suffix The suffix or null.
     */
    public static void setActionSuffix(final SlingHttpServletRequest req, final String suffix) {
        req.setAttribute(REQ_ATTR_ACTION_SUFFIX, suffix);
    }

    /**
     * Get the request suffix currently set for the form action's URI.
     * @param req The current Request.
     * @return THe suffix or null.
     */
    public static String getActionSuffix(final SlingHttpServletRequest req) {
        return (String) req.getAttribute(REQ_ATTR_ACTION_SUFFIX);
    }

    /**
     * Set the load resource for the form.
     * @param req The current request.
     * @param rsrc The load resource
     */
    public static void setFormLoadResource(final SlingHttpServletRequest req, final Resource rsrc) {
        req.removeAttribute(REQ_ATTR_GLOBAL_LOAD_MAP);
        req.removeAttribute(REQ_ATTR_GLOBAL_LOAD_RESOURCE);
        if ( rsrc != null ) {
            req.setAttribute(REQ_ATTR_GLOBAL_LOAD_RESOURCE, rsrc);
            final ValueMap map = ResourceUtil.getValueMap(rsrc);
            req.setAttribute(REQ_ATTR_GLOBAL_LOAD_MAP, map);
        }
    }

    /**
     * Get the load resource for the form.
     * @param req current request
     * @return load resource or <code>null</code> if not set
     */
    public static Resource getFormLoadResource(final SlingHttpServletRequest req) {
        return (Resource)req.getAttribute(REQ_ATTR_GLOBAL_LOAD_RESOURCE);
    }

    /**
     * Return the form values to load.
     * @param req The request
     * @return The values or null
     */
    public static ValueMap getGlobalFormValues(final SlingHttpServletRequest req) {
        checkInit(req);
        return (ValueMap) req.getAttribute(REQ_ATTR_GLOBAL_LOAD_MAP);
    }

    /**
     * Sets the list of resources to be handled by the "edit" resources form action.
     * @param req current request
     * @param resources the list of resources
     */
    public static void setFormEditResources(final SlingHttpServletRequest req, final List<Resource> resources) {
        FormResourceEdit.setResources(req, resources);
    }

    /**
     * Get the list of resources to be handled by the "edit" resources form action.
     * @param req current request
     * @return the list of resources (or <code>null</code> if not set)
     */
    public static List<Resource> getFormEditResources(final SlingHttpServletRequest req) {
        return FormResourceEdit.getResources(req);
    }

    /**
     * Return the name of the check method.
     * Method name is based on from id with any hyphens converted to underscores.  If the form can't be found, it will default to defaultForm.
     * @param req The current request.
     * @return The method name
     */
    public static String getFormsPreCheckMethodName(final SlingHttpServletRequest req) {
        String formId = getFormId(req);

        SlingBindings bindings = (SlingBindings) req.getAttribute(SlingBindings.class.getName());
		XSSAPI xssAPI = bindings.getSling().getService(XSSAPI.class).getRequestSpecificAPI(req);
		
        if (formId != null) {
			formId = xssAPI.getValidJSToken(formId, "defaultForm");
        }
		
        return "cq5forms_preCheck_" + formId;
    }

    /**
     * Generate the java script
     */
    private static void writeJavaScript(final SlingHttpServletRequest req,
                                        final SlingHttpServletResponse response,
                                        final Resource formResource)
    throws IOException, ServletException {
        if ( doClientValidation(req) ) {
            final PrintWriter out = response.getWriter();

            // write general java script
            final HtmlLibraryManager htmlMgr = FormsManagerImpl.HTML_LIBRARY_MANAGER;
            if (htmlMgr != null) {
                htmlMgr.writeJsInclude(req, out, "cq.forms");
            }

            // write form-specific java script
            out.println("<script type=\"text/javascript\">");
			if (WCMMode.fromRequest(req) != WCMMode.DISABLED) {
				// A page written in one mode can be switched to another mode without a refresh, so make
				// sure we have the reload flag for all of them.  On the other hand, if WCMMode is disabled
				// entirely (ie: on a publish instance), then we can't switch and don't want the flag.
				out.println("  cq5forms_reloadForPreview = true;");
			}
            out.println("  function " + getFormsPreCheckMethodName(req) + "(submitid) {");
            out.println("    var dMsgs = \"Please fill out the required field.\";");
            final Iterator<Resource> iter = getFormElements(formResource);
            while ( iter.hasNext() ) {
                final Resource formsField = iter.next();
                FieldHelper.initializeField(req, response, formsField);
                FormsHelper.includeResource(req, response, formsField, FormsConstants.SCRIPT_CLIENT_VALIDATION);
            }
            // in addition we check for a global validation RT
            // configured at the form resource
            final ValueMap properties = ResourceUtil.getValueMap(formResource);
            final String valScriptRT = properties.get(FormsConstants.START_PROPERTY_VALIDATION_RT, formResource.getResourceType());
            if ( valScriptRT != null && valScriptRT.length() > 0 ) {
                Resource valScriptResource = formResource;
                if ( !formResource.getResourceType().equals(valScriptRT) ) {
                    valScriptResource = new org.apache.sling.api.resource.ResourceWrapper(formResource) {
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
                FormsHelper.includeResource(req, response, valScriptResource, FormsConstants.SCRIPT_FORM_CLIENT_VALIDATION);
            }
            out.println("    return true;");
            out.println("  }");
            out.println("</script>");
        }
    }

    /**
     * Include the resource with the given selector with method GET
     * @param request The current request.
     * @param response The current response.
     * @param resource The resource to include.
     * @param selectorString The selector string to use for inclusion.
     * @throws IOException
     * @throws ServletException
     */
    public static void includeResource(final SlingHttpServletRequest request,
                                       final SlingHttpServletResponse response,
                                       final Resource resource,
                                       final String selectorString)
    throws IOException, ServletException {
        final Object oldValue = request.getAttribute(ComponentContext.BYPASS_COMPONENT_HANDLING_ON_INCLUDE_ATTRIBUTE);
        try {
            request.setAttribute(ComponentContext.BYPASS_COMPONENT_HANDLING_ON_INCLUDE_ATTRIBUTE, "true");
            final RequestDispatcherOptions options = new RequestDispatcherOptions();
            options.setReplaceSelectors(selectorString);

            request.getRequestDispatcher(resource, options).include(request, response);
        } finally {
            if ( oldValue == null ) {
                request.removeAttribute(ComponentContext.BYPASS_COMPONENT_HANDLING_ON_INCLUDE_ATTRIBUTE);
            } else {
                request.setAttribute(ComponentContext.BYPASS_COMPONENT_HANDLING_ON_INCLUDE_ATTRIBUTE, oldValue);
            }
        }
    }

    /**
     * Are we generating client validation?
     * @param req Request
     * @return true or false
     */
    public static boolean doClientValidation(final SlingHttpServletRequest req) {
        checkInit(req);
        Boolean value = (Boolean)req.getAttribute(REQ_ATTR_CLIENT_VALIDATION);
        if ( value == null ) {
            value = Boolean.FALSE;
        }
        return value.booleanValue();
    }

    /**
     * Return the formid
     * @param req Request
     * @return The form id or null
     */
    public static String getFormId(final SlingHttpServletRequest req) {
        checkInit(req);
        
       	return (String)req.getAttribute(REQ_ATTR_FORMID);
    }

    /**
     * Return the parameter name for the field
     * @param rsrc The resource
     * @return The parameter name.
     */
    public static String getParameterName(final Resource rsrc) {
        final ValueMap properties = ResourceUtil.getValueMap(rsrc);
        String name = properties.get(FormsConstants.ELEMENT_PROPERTY_NAME, "");
        if ( name.length() == 0 ) {
           name = ResourceUtil.getName(rsrc);
           name = FormsUtil.filterElementName(name);
        }
        return name;
    }

    /**
     * Return the id for the field
     * @param req The current request.
     * @param rsrc The resource.
     * @return The id.
     */
    public static String getFieldId(final SlingHttpServletRequest req, final Resource rsrc) {
        return getFormId(req) + '_' + getParameterName(rsrc);
    }

    /**
     * Return all form elements for this form.
     * @param formResource The form resource-
     * @return An iterator for all form elements.
     */
    public static Iterator<Resource> getFormElements(final Resource formResource) {
        final List<Resource> list = new ArrayList<Resource>();
        // get all siblings
        final Iterator<Resource> iter = ResourceUtil.listChildren(ResourceUtil.getParent(formResource));
        while ( !iter.next().getPath().equals(formResource.getPath()) );
        collectFormElements(list, iter);
        return list.iterator();
    }

    /**
     * Return a list of content fields.
     * This method returns all field names (= request parameter names) that contain actually content
     * by filtering out special request parameters like those starting with a ":", "_charset_" etc.
     * @return Iterator for the field names.
     */
    public static Iterator<String> getContentRequestParameterNames(final SlingHttpServletRequest req) {
        final List<String> names = new ArrayList<String>();
        @SuppressWarnings("unchecked")
        final Enumeration<String> paramNames = req.getParameterNames();
        while (paramNames.hasMoreElements() ) {
            final String name = paramNames.nextElement();
            if ( !name.startsWith(":") && !name.equals("_charset_") ) {
                names.add(name);
            }
        }
        return names.iterator();
    }

    /**
     * Helper method to collect all form elements.
     * @param list
     * @param iter
     * @return
     */
    private static boolean collectFormElements(final List<Resource> list, final Iterator<Resource> iter) {
        boolean stop = false;
        while ( !stop && iter.hasNext() ) {
            final Resource n = iter.next();
            if ( checkResourceType(n, FormsConstants.RT_FORM_END) ) {
                // this is the form end
                stop = true;
                break;
            } else if ( n.getResourceType().startsWith(FormsConstants.RT_FORM_PREFIX)
                || ( n.getResourceSuperType() != null && n.getResourceSuperType().startsWith(FormsConstants.RT_FORM_PREFIX))) {
                list.add(n);
            } else {
                // do deep search
                final Iterator<Resource> cI = ResourceUtil.listChildren(n);
                if ( cI != null ) {
                    stop = collectFormElements(list, cI);
                }
            }
        }
        return stop;
    }

    /**
     * Returns a resource identified by a path relative to the
     * <code>elementResource</code>. This method also considers form edit
     * resources.
     *
     * @param request         the current request.
     * @param elementResource the element resource.
     * @param relPath         a path relative to <code>elementResource</code>.
     * @return the resource or <code>null</code> if none exists at the given
     *         <code>relPath</code>.
     */
    public static Resource getResource(SlingHttpServletRequest request,
                                       Resource elementResource,
                                       String relPath) {
        List<Resource> resources = new ArrayList<Resource>();
        // consider edit resources if any
        List<Resource> editRes = FormResourceEdit.getResources(request);
        if (editRes != null) {
            resources.addAll(editRes);
        }
        // then element resource
        resources.add(elementResource);
        ResourceResolver resolver = request.getResourceResolver();
        for (Resource r : resources) {
            Resource res = resolver.getResource(r, relPath);
            if (res != null) {
                return res;
            }
        }
        return null;
    }

    /**
     * Return the value for the element.
     * This method invokes {@link #getValues(SlingHttpServletRequest, Resource)} and returns
     * if available the first value from the array.
     * @param request The current request.
     * @param elementResource The element resource.
     * @return The value for the form element or null.
     */
    public static String getValue(final SlingHttpServletRequest request, final Resource elementResource) {
        return getValue(request, elementResource, null);
    }

    /**
     * Return the value for the element.
     * This method invokes {@link #getValues(SlingHttpServletRequest, Resource)} and returns
     * if available the first value from the array.
     * @param request The current request.
     * @param elementResource The element resource.
     * @param nameParam The name of the name parameter (defaults to "name")
     * @return The value for the form element or null.
     */
    public static String getValue(final SlingHttpServletRequest request, final Resource elementResource, final String nameParam) {
        final String[] values = getValues(request, elementResource, nameParam);
        if ( values != null && values.length > 0 ) {
            return values[0];
        }
        return null;
    }

    /**
     * Return the values for the element.
     * This method
     * @param request The current request.
     * @param elementResource The element resource.
     * @return The values for the form element or null.
     */
    public static String[] getValues(final SlingHttpServletRequest request, final Resource elementResource) {
        return getValues(request, elementResource, null);
    }

    /**
     * Return the values for the element.
     * This method
     * @param request The current request.
     * @param elementResource The element resource.
     * @param nameParam The name of the name parameter (defaults to "name")
     * @return The values for the form element or null.
     */
    public static String[] getValues(final SlingHttpServletRequest request, final Resource elementResource, final String nameParam) {
        final ValueMap properties = ResourceUtil.getValueMap(elementResource);
        final String name = nameParam != null ? nameParam : getParameterName(elementResource);

        // if we have validation errors we will use the old value!
        final ValidationInfo info = ValidationInfo.getValidationInfo(request);
        if ( info != null ) {
            return info.getValues(name);
        }

        // globally defined form values
        final ValueMap globalFormValues = FormsHelper.getGlobalFormValues(request);

        // get the default value
        // this can either be an old value, a constant or a property from the repository
        String[] defaultValues = null;
        final String loadPath = properties.get(FormsConstants.ELEMENT_PROPERTY_LOAD_PATH, "");
        if ( loadPath.length() > 0 ) {
            // check if loadPath is defined and
            // first try this as an absolut path
            // second try this as a property in the global values
            final Resource rsrc = request.getResourceResolver().getResource(loadPath);
            if ( rsrc != null ) {
                defaultValues = rsrc.adaptTo(String[].class);

            } else if ( globalFormValues != null && globalFormValues.get(loadPath) != null ) {
                defaultValues = globalFormValues.get(loadPath, String[].class);
            }
        } else if ( globalFormValues != null && globalFormValues.get(name) != null ) {
            defaultValues = globalFormValues.get(name, String[].class);
        }
        // if we don't have values yet, get default values
        if ( defaultValues == null ) {
            defaultValues = properties.get(FormsConstants.ELEMENT_PROPERTY_DEFAULT_VALUE, String[].class);
        }

        return defaultValues;
    }

    /**
     * Return the values for the element as a list
     * This method
     * @param request The current request.
     * @param elementResource The element resource.
     * @return The values for the form element or an empty list.
     */
    public static List<String> getValuesAsList(final SlingHttpServletRequest request, final Resource elementResource) {
        final String[] values = getValues(request, elementResource);
        if ( values == null ) {
            return Collections.emptyList();
        }
        return Arrays.asList(values);
    }

    /**
     * Returns the value for the given name (property).
     * @param request The current request
     * @param name name of the property (or property path)
     * @param defaultValue default value to return if property is not present
     * @return The value for the given property
     */
    public static String getValue(final SlingHttpServletRequest request, final String name, final String defaultValue) {
        String[] values = getValues(request, name, null);
        if (values == null || values.length == 0) {
            return defaultValue;
        }
        return values[0];
    }

    /**
     * Returns the values for the given name (property).
     * @param request The current request
     * @param name name of the property (or property path)
     * @param defaultValues default values to return if property is not present
     * @return The values for the given property
     */
    public static String[] getValues(final SlingHttpServletRequest request, final String name, final String[] defaultValues) {
        final ValueMap globalFormValues = FormsHelper.getGlobalFormValues(request);
        if (globalFormValues == null || globalFormValues.get(name) == null) {
            return defaultValues;
        }

        return globalFormValues.get(name, String[].class);
    }

    /**
     * Writes the given form load resource as JSON into the given writer. This
     * will dump the full tree; use
     * {@link #inlineValuesAsJson(SlingHttpServletRequest, Writer, String, int)}
     * for controlling the node depth.
     *
     * <p>
     * Can be used in JSPs to inline JSON for javascript code, for example:
     *
     * <pre>
     * var data = &lt;% FormsHelper.inlineValuesAsJson(slingRequest, out, &quot;.&quot;); %&gt;;
     * </pre>
     *
     * which might result in:
     *
     * <pre>
     * var data = { &quot;jcr:primaryType&quot;: &quot;nt:unstructured&quot;, &quot;property&quot; : &quot;value&quot; };
     * </pre>
     *
     * <p>
     * If the path cannot be found, an empty object "<code>{}</code>" will be
     * written. Any exception will be passed to the caller.
     *
     * <p>
     * The underlying form load resource must be based on a JCR Node. The path
     * is relative and allows to specify subnodes. It cannot point to JCR
     * properties, please use
     * {@link #getValue(SlingHttpServletRequest, String, String)} or
     * {@link #getValues(SlingHttpServletRequest, String, String[])} for them.
     *
     * @param request
     *            the current request
     * @param out
     *            a writer, such as a {@link JspWriter}, to write the JSON into.
     *            Will automatically be flushed before and after.
     * @param path
     *            an absolute node path or a node path relativ to the current
     *            form load resource. Use "." for the resource node itself.
     * @throws RepositoryException
     *             if some jcr error happened
     * @throws JSONException
     *             if writing the json failed
     * @throws IOException
     *             if there was a problem with the writer
     */
    public static void inlineValuesAsJson(final SlingHttpServletRequest request, Writer out, String path) throws IOException, RepositoryException, JSONException {
        inlineValuesAsJson(request, out, path, -1);
    }

    /**
     * Writes the given form load resource as JSON into the given writer. Can be
     * used in JSPs to inline JSON for javascript code, for example:
     *
     * <pre>
     * var data = &lt;% FormsHelper.inlineValuesAsJson(slingRequest, out, &quot;.&quot;); %&gt;;
     * </pre>
     *
     * which might result in:
     *
     * <pre>
     * var data = { &quot;jcr:primaryType&quot;: &quot;nt:unstructured&quot;, &quot;property&quot; : &quot;value&quot; };
     * </pre>
     *
     * <p>
     * If the path cannot be found, an empty object "<code>{}</code>" will be
     * written. Any exception will be passed to the caller.
     *
     * <p>
     * The underlying form load resource must be based on a JCR Node. The path
     * is relative and allows to specify subnodes. It cannot point to JCR
     * properties, please use
     * {@link #getValue(SlingHttpServletRequest, String, String)} or
     * {@link #getValues(SlingHttpServletRequest, String, String[])} for them.
     *
     * @param request
     *            the current request
     * @param out
     *            a writer, such as a {@link JspWriter}, to write the JSON into.
     *            Will automatically be flushed before and after.
     * @param path
     *            an absolute node path or a node path relativ to the current
     *            form load resource. Use "." for the resource node itself.
     * @param nodeDepth
     *            until which depth the tree should be written; 0 means the
     *            current node and its properties only; -1 means the whole tree.
     * @throws RepositoryException
     *             if some jcr error happened
     * @throws JSONException
     *             if writing the json failed
     * @throws IOException
     *             if there was a problem with the writer
     */
    public static void inlineValuesAsJson(final SlingHttpServletRequest request, Writer out, String path, int nodeDepth) throws IOException, RepositoryException, JSONException {
        out.flush();

        Node node;
        Session session = request.getResourceResolver().adaptTo(Session.class);
        if (path.startsWith("/")) {
            if (session.nodeExists(path)) {
                node = session.getNode(path);
            } else {
                // write empty object to not break javascript syntax
                out.append("{}");
                return;
            }
        } else {
            Resource loadResource = FormsHelper.getFormLoadResource(request);
            if (loadResource == null) {
                out.append("{}");
                return;
            }
            node = loadResource.adaptTo(Node.class);
            if (node == null) {
                out.append("{}");
                return;
            }
            if (!node.hasNode(path)) {
                out.append("{}");
                return;
            }
            node = node.getNode(path);
        }

        JsonItemWriter jsonWriter = new JsonItemWriter(null);
        jsonWriter.dump(node, new PrintWriter(out), nodeDepth);

        out.flush();
    }

    /**
     * Recurse down a subtree collecting all showHideExpressions into a map keyed by element name.
     *
     * @param node the node to check for showHideExpressions.
     * @param map a collection of node names, and their associated showHideExpression.
     */
    private static void accumulateShowHideExpressions(final Node node, Map<String, String> map) throws RepositoryException {
        if (node.hasProperty("showHideExpression")) {
            map.put(node.hasProperty("name") ? node.getProperty("name").getString() : node.getName(),
                    node.getProperty("showHideExpression").getString());
        }
        for (NodeIterator iterator = node.getNodes(); iterator.hasNext();) {
            accumulateShowHideExpressions(iterator.nextNode(), map);
        }
    }

    /**
     * Return a flattened map of all showHideExpressions that are descendants of a resource.
     *
     * @param resource the node to check to see if there's any showHideExpressions.
     * @return A map of showHideExpressions keyed by element name.
     */
    public static Map<String, String> getShowHideExpressions(final Resource resource) throws RepositoryException {
        Node node = resource.adaptTo(Node.class);
        Map<String, String> map = new HashMap<String, String>();
        accumulateShowHideExpressions(node, map);
        return map;
    }

    /**
     * Return the options for a form element
     * @param request
     * @param elementResource
     * @return A map of options (key-value) or null.
     */
    public static Map<String, String> getOptions(final SlingHttpServletRequest request, final Resource elementResource) {
        final ValueMap properties = ResourceUtil.getValueMap(elementResource);

        String[] options = null;
        final String loadPath = properties.get(FormsConstants.ELEMENT_PROPERTY_OPTIONS_LOAD_PATH, "");
        if ( loadPath.length() > 0 ) {
            // check if loadPath is defined and try this as an absolut path
            final Resource rsrc = request.getResourceResolver().getResource(loadPath);
            if ( rsrc != null ) {
                options = rsrc.adaptTo(String[].class);
            }
        }
        // if we don't have values yet, get default values
        if ( options == null ) {
            options = properties.get(FormsConstants.ELEMENT_PROPERTY_OPTIONS, String[].class);
        }

        if ( options == null ) {
            return null;
        }
        // now split into key value
        final Map<String, String> splitValues = new java.util.LinkedHashMap<String, String>();
        for(int i=0; i<options.length; i++) {
            final String value = options[i].trim();
            if ( value.length() > 0 ) {
                boolean endLoop = true;
                int pos = -1;
                int start = 0;
                do {
                     pos = value.indexOf('=', start);
                     // check for escaping
                     if ( pos > 0 && value.charAt(pos-1) == '\\' ) {
                         start = pos +1;
                         endLoop = false;
                     } else {
                         endLoop = true;
                     }
                } while ( !endLoop);
                String v, t;
                if ( pos == -1 ) {
                    v = value;
                    t = value;
                } else {
                    v = value.substring(0, pos);
                    t = value.substring(pos+1);
                }
                v = v.replace("\\=", "=");
                t = t.replace("\\=", "=");
                splitValues.put(v, t);
            } else {
                splitValues.put("", "");
            }
        }
        if ( splitValues.size() == 0 ) {
            return null;
        }
        return splitValues;
    }

    /**
     * Is this field required?
     * @param formElement The form element.
     * @return true if the field is required, false otherwise.
     */
    public static boolean isRequired(final Resource formElement) {
        final ValueMap properties = ResourceUtil.getValueMap(formElement);
        return properties.get(FormsConstants.ELEMENT_PROPERTY_REQUIRED, Boolean.FALSE);
    }

    /**
     * Marks the current form rendering to produce an read-only form. Form field
     * renderings must use
     * {@link #isReadOnly(SlingHttpServletRequest, Resource)} to decide between
     * edit or read-only representations.
     *
     * @param request
     *            the current request
     */
    public static void setFormReadOnly(final SlingHttpServletRequest request) {
        request.setAttribute(REQ_ATTR_READ_ONLY, true);
    }

    /**
     * Returns true if either the passed form field is configured as read-only
     * or if the entire form is to be displayed in a read-only way. The latter
     * is the case when {@link #setFormReadOnly(SlingHttpServletRequest)} was
     * called, for example if the "view" selector of the
     * {@link FormChooserServlet} is used.
     *
     * @param request
     *            the current request
     * @param formElement
     *            the form field resource
     * @return <code>true</code> if this field is to be rendered as read-only,
     *         <code>false</code> otherwise.
     */
    public static boolean isReadOnly(final SlingHttpServletRequest request, Resource formElement) {
        if (request.getAttribute(REQ_ATTR_READ_ONLY) != null) {
            return true;
        }
        ValueMap properties = ResourceUtil.getValueMap(formElement);
        return properties.get(FormsConstants.ELEMENT_PROPERTY_READ_ONLY, Boolean.FALSE);
    }

    /**
     * Returns true if the entire form has to be displayed in a read-only way.
     * @param request
     *            the current request
     * @return <code>true</code> if a form element has to be rendered as read-only,
     *         <code>false</code> otherwise.
     * @since 5.5
     */
    public static boolean isReadOnly(final SlingHttpServletRequest request) {
         return request.getAttribute(REQ_ATTR_READ_ONLY) != null;
    }

    /**
     * Returns true if the passed form field is configured as read-only. This is
     * determined solely by looking at the field's "readOnly" property.
     *
     * @deprecated
     * To always support the global read-only flag, set for example by the
     * "view" selector of the {@link FormChooserServlet}, use
     * {@link #isReadOnly(SlingHttpServletRequest, Resource)} instead.
     *
     * @param formElement
     *            the form field resource
     * @return <code>true</code> if this field is read-only, <code>false</code>
     *         otherwise.
     */
    @Deprecated
    public static boolean isReadOnly(Resource formElement) {
        ValueMap properties = ResourceUtil.getValueMap(formElement);
        return properties.get(FormsConstants.ELEMENT_PROPERTY_READ_ONLY, Boolean.FALSE);
    }

    /**
     * <p>Checks the rule specified by the given form property.</p>
     * <p>Rules may be used to enable/disable form elements according to some serverside
     * conditions.</p>
     * <p>Currently, only rules depending on access rights are available.</p>
     */
    public static boolean checkRule(final Resource resource,
                                    final SlingHttpServletRequest req,
                                    final PageContext pageContext, String propName) {
        ValueMap valueMap = ResourceUtil.getValueMap(resource);
        String rule = valueMap.get(propName, (String) null);
        if (rule == null) {
            return true;
        }
        rule = ELEvaluator.evaluate(rule, req, pageContext);
        final String[] ruleParts = rule.split(":");
        if (ruleParts.length < 2) {
            return true;
        }
        if (ruleParts[0].equals("access")) {
            if (ruleParts.length != 3) {
                return true;
            }
            final String path = ruleParts[1];
            final String permission = ruleParts[2];
            try {
                final Node node = resource.adaptTo(Node.class);
                final Session session = node.getSession();
                session.checkPermission(path, permission);
                // SecurityUtil.hasPermissionOn(node.getSession(), privilege, path);
            } catch (AccessControlException ace) {
                return false;
            } catch (RepositoryException re) {
                LOGGER.error("Could not determine access rights for path '" + path + "'",
                        re);
                return false;
            }
        }
        return true;
    }

    /**
     * Return the title for the field.
     * @param formElement The form element.
     * @param defaultTitle The default title.
     * @return The title to display.
     */
    public static String getTitle(final Resource formElement, String defaultTitle) {
        final ValueMap properties = ResourceUtil.getValueMap(formElement);
        return properties.get(JcrConstants.JCR_TITLE, defaultTitle);
    }

    /**
     * Return the description for the field.
     * @param formElement The form element.
     * @param defaultDescription The default description.
     * @return The description to display.
     */
    public static String getDescription(final Resource formElement, String defaultDescription) {
        final ValueMap properties = ResourceUtil.getValueMap(formElement);
        return properties.get(JcrConstants.JCR_DESCRIPTION, defaultDescription);
    }

    /**
     * Is this a field with multi selection?
     * @param formElement The form element
     * 
     * @since 5.5
     */
    public static boolean hasMultiSelection(final Resource formElement) {
        final ValueMap properties = ResourceUtil.getValueMap(formElement);
        return properties.get(FormsConstants.ELEMENT_PROPERTY_MULTI_SELECTION, Boolean.FALSE);
    }

    /**
     * Redirect to the referrer.
     * This method redirects to the referer and adds optional request parameters.
     * @param req The current request
     * @param res The current response
     */
    public static void redirectToReferrer(final SlingHttpServletRequest req,
                                          final SlingHttpServletResponse res,
                                          final Map<String, String[]> params)
    throws IOException {
        final String referrer = getReferrer(req);
        if ( params != null && params.size() > 0 ) {
            final StringBuilder buffer = new StringBuilder(referrer);
            boolean hasParams = referrer.indexOf('?') > 0;
            for(final Map.Entry<String, String[]> entry : params.entrySet()) {
                for(final String value : entry.getValue() ) {
                    buffer.append(hasParams ? '&' : '?');
                    hasParams = true;
                    buffer.append(entry.getKey());
                    buffer.append('=');
                    buffer.append(URLEncoder.encode(value, "utf-8"));
                }
            }
            res.sendRedirect(buffer.toString());
        } else {
            res.sendRedirect(referrer);
        }
    }

    /**
     * Redirect to the referrer. This method redirects to the referrerand copies
     * the request parameters.
     *
     * @param request The current request
     * @param res The current response
     * @since 5.2
     */
    public static void redirectToReferrer(final SlingHttpServletRequest request,
                                          final SlingHttpServletResponse res)
    throws IOException {
        String referrer = getReferrer(request);
        final int pos = referrer.indexOf('?');
        if (pos > 0) {
            referrer = referrer.substring(0, pos);
        }
        final StringBuilder buffer = new StringBuilder(referrer);
        final RequestParameterMap params = request.getRequestParameterMap();
        if (params.entrySet().size() > 0) {
            buffer.append("?");
            boolean first = true;
            final Iterator<Map.Entry<String, RequestParameter[]>> entryIter = params.entrySet().iterator();
            while (entryIter.hasNext()) {
                final Map.Entry<String, RequestParameter[]> current = entryIter.next();
                final RequestParameter[] values = current.getValue();
                for (int i = 0; i < values.length; i++) {
                    if (first) {
                        first = false;
                    } else {
                        buffer.append("&");
                    }
                    buffer.append(current.getKey());
                    buffer.append("=");
                    buffer.append(values[i].getString());
                }
            }
        }
        res.sendRedirect(buffer.toString());
    }

    /**
     * Fix the form.
     * When a form start is added, add automatically a forms end (if missing)
     * When only a form end is on the page remove it
     * @since 5.2
     */
    public static Resource checkFormStructure(final Resource rsrc) {
        if ( checkResourceType(rsrc, FormsConstants.RT_FORM_BEGIN) ) {
            // add default action type, form id and action path
            Node start = rsrc.adaptTo(Node.class);
            if(start != null) {
            	try {
					if(!start.hasProperty(FormsConstants.START_PROPERTY_ACTION_TYPE)) {
						start.setProperty(FormsConstants.START_PROPERTY_ACTION_TYPE, FormsConstants.DEFAULT_ACTION_TYPE);
						
						String defaultContentPath = "/content/usergenerated" +
							rsrc.getPath().replaceAll("^.content", "").replaceAll("jcr.content.*", "") +
							"cq-gen" + System.currentTimeMillis() + "/";
						start.setProperty(FormsConstants.START_PROPERTY_ACTION_PATH, defaultContentPath);
					}
					if(!start.hasProperty(FormsConstants.START_PROPERTY_FORMID)) {
						start.setProperty(FormsConstants.START_PROPERTY_FORMID, rsrc.getPath().replaceAll("[/:.]","_"));
					}
					start.getSession().save();
				} catch(RepositoryException e) {
					LOGGER.error("Unable to add default action type and form id " + rsrc, e);
				}
            } else {
                LOGGER.error("Resource is not adaptable to node - unable to add default action type and form id for " + rsrc);
            }

            // search a form end on the same level
            // get all siblings
            final Iterator<Resource> iter = ResourceUtil.listChildren(ResourceUtil.getParent(rsrc));
            while ( !iter.next().getPath().equals(rsrc.getPath()) );
            Resource formEnd = null;
            Resource nextPar = null;
            boolean stop = false;
            while ( iter.hasNext() && formEnd == null && !stop) {
                final Resource current = iter.next();
                if ( nextPar == null ) {
                    nextPar = current;
                }
                if ( checkResourceType(current, FormsConstants.RT_FORM_END) ) {
                    formEnd = current;
                } else if ( checkResourceType(current, FormsConstants.RT_FORM_BEGIN) ) {
                    stop = true;
                }
            }
            // no form end, create one!
            if ( formEnd == null ) {
                // get parent node
                final Node parent = ResourceUtil.getParent(rsrc).adaptTo(Node.class);
                if ( parent != null ) {
                    try {
                        final String nodeName = "form_end_" + System.currentTimeMillis();
                        final Node node = parent.addNode(nodeName);
                        final ValueMap props = ResourceUtil.getValueMap(rsrc);
                        String resourceType = FormsConstants.RT_FORM_END;
                        if ( props != null ) {
                            resourceType = props.get(FormsConstants.START_PROPERTY_END_RESOURCE_TYPE, resourceType);
                        }
                        node.setProperty(JcrResourceConstants.SLING_RESOURCE_TYPE_PROPERTY, resourceType);
                        if ( !resourceType.equals(FormsConstants.RT_FORM_END) ) {
                            node.setProperty(JcrResourceConstants.SLING_RESOURCE_SUPER_TYPE_PROPERTY, FormsConstants.RT_FORM_END);
                        }
                        if ( nextPar != null ) {
                            parent.orderBefore(node.getName(), ResourceUtil.getName(nextPar));
                        }
                        parent.getSession().save();
                        // get resource
                        final Iterator<Resource> i = ResourceUtil.listChildren(ResourceUtil.getParent(rsrc));
                        while ( i.hasNext() ) {
                            final Resource r = i.next();
                            if ( nodeName.equals(ResourceUtil.getName(r)) ) {
                                return r;
                            }
                        }
                    } catch (RepositoryException re) {
                        LOGGER.error("Unable to create missing form end element for form start " + rsrc, re);
                    } finally {
                        try {
                            if ( parent.getSession().hasPendingChanges() ) {
                                parent.getSession().refresh(false);
                            }
                        } catch (RepositoryException re) {
                            // we ignore this
                        }
                    }
                } else {
                    LOGGER.error("Resource is not adaptable to node - unable to add missing form end element for " + rsrc);
                }
            }
        } else if ( checkResourceType(rsrc, FormsConstants.RT_FORM_END) ) {
            // search a form start on the same level
            final Resource formStart = searchFormStart(rsrc);
            if ( formStart == null ) {
                // remove form end
                final Node node = rsrc.adaptTo(Node.class);
                final Node parent = ResourceUtil.getParent(rsrc).adaptTo(Node.class);
                if ( node != null && parent != null ) {
                    try {
                        node.remove();
                        parent.getSession().save();
                        return rsrc;
                    } catch (RepositoryException re) {
                        LOGGER.error("Unable to create missing form end element for form start " + rsrc, re);
                    } finally {
                        try {
                            if ( node.getSession().hasPendingChanges() ) {
                                node.getSession().refresh(false);
                            }
                        } catch (RepositoryException re) {
                            // we ignore this
                        }
                    }
                } else {
                    LOGGER.error("Resource is not adaptable to node - unable to remove form element " + rsrc);
                }
            }

        }
        return null;
    }

    /**
     * Url encode the value.
     * The value is encoded with character set UTF-8.
     * @param value The value
     * @return The encoded value.
     * @since 5.2
     */
    public static String encodeValue(String value) {
        try {
            return URLEncoder.encode(value, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            // utf-8 is always supported, but let's return something anyway...
            return value;
        }
    }

    /**
     * Url decode the value.
     * The value is decoded with character set UTF-8.
     * @param value The value
     * @return The decoded value.
     * @since 5.2
     */
    public static String decodeValue(String value) {
        try {
            return URLDecoder.decode(value, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            // utf-8 is always supported, but let's return something anyway...
            return value;
        }
    }


    /**
     * Return the css classes for the field.
     * If the field has a property {@link FormsConstants#ELEMENT_PROPERTY_CSS}
     * the value of this property is appended to the default css. If not, only the
     * default css is returned.
     * @param props The field properties.
     * @param defaultCss The default css for this field.
     * @return The css classes
     *
     * @since 5.4
     */
    public static String getCss(final ValueMap props, final String defaultCss) {

        final String configCss = props.get(FormsConstants.ELEMENT_PROPERTY_CSS, null);
        if ( configCss == null ) {
            return defaultCss;
        }
        return defaultCss + ' ' + StringEscapeUtils.escapeHtml4(configCss);
    }

    /**
     * Returns the HTTP "referrer" header from the request, and also looks out
     * for the common "referer" misspelling.
     * 
     * @since 5.5
     * 
     * @param request
     *            current request
     * @return value of the referrer header or <code>null</code> if not present
     */
    public static String getReferrer(HttpServletRequest request) {
        return request.getHeader("Referer") != null ? request.getHeader("Referer") : request.getHeader("Referrer");
    }

    /**
     * Sets a flag to redirect to the HTTP referrer after the forward of a form
     * POST request. This will usually only be used if no explicit redirect is
     * already given in the ":redirect" parameter used by the Sling POST servlet.
     * 
     * @since 5.5
     * 
     * @param request
     *            current request
     * @param redirectToReferrer
     *            <code>true</code> to enable the redirect to the referrer
     */
    public static void setRedirectToReferrer(ServletRequest request, boolean redirectToReferrer) {
        if (redirectToReferrer) {
            request.setAttribute(REQ_ATTR_REDIRECT_TO_REFERRER, "true");
        } else {
            request.removeAttribute(REQ_ATTR_REDIRECT_TO_REFERRER);
        }
    }

    /**
     * Returns whether there should be a redirect to the HTTP referrer after the
     * forward of a form POST request.
     * 
     * @since 5.5
     * 
     * @param request
     *            current request
     * @return <code>true</code> if there should be a redirect to the referrer
     */
    public static boolean isRedirectToReferrer(ServletRequest request) {
        return "true".equals(request.getAttribute(REQ_ATTR_REDIRECT_TO_REFERRER));
    }

    /**
     * Returns the locale.
     * If the request originates from a jsp, it returns the locale as defined
     * by the {@link com.day.cq.wcm.api.LanguageManager}, otherwise it returns
     * <code>null</code>
     * @param request The current request
     * @return the locale or <code>null</code> if not determinable
     */
    public static Locale getLocale(SlingHttpServletRequest request) {
        SlingBindings bindings = (SlingBindings) request.getAttribute(SlingBindings.class.getName());
        if (bindings == null) {
            LOGGER.debug("The request does not provide a SlingBindings attribute: the method returns null.");
            return null;
        }
        SlingScriptHelper scriptHelper = bindings.getSling();
        LanguageManager langMgr = scriptHelper.getService(LanguageManager.class);
        if (langMgr == null) {
            LOGGER.debug("The LanguageManager service is not available: the method returns null.");
            return null;
        }
        Resource resource = request.getResource();
        Locale locale = langMgr.getLanguage(resource);
        return locale;
    }

    /**
     * Returns the localized message.
     * If the request originates from a jsp, it returns the localized message
     * based on the {@link java.util.ResourceBundle} of the request and the
     * locale defined by the {@link com.day.cq.wcm.api.LanguageManager}.
     * Otherwise it returns the original message.
     * @param msg The message to be localized
     * @param request The current request
     * @return the localized message or the original message if it cannot be localized
     */
    public static String getLocalizedMessage(String msg, SlingHttpServletRequest request) {
        Locale locale = getLocale(request);
        ResourceBundle resBundle = request.getResourceBundle(locale);
        if (resBundle == null || msg == null || resBundle.getString(msg) == null) {
            LOGGER.debug("The message cannot be localized: the method returns the original message.");
            return msg;
        }
        return resBundle.getString(msg);
    }

    /**
     * Get the list of white listed data name patterns.
     * @param req The current request.
     * @return The array of white listed data name patterns
     */
    public static String[] getWhitelistPatterns(final SlingHttpServletRequest req) {
        return (String[])req.getAttribute(REQ_ATTR_PROP_WHITELIST);
    }

}
