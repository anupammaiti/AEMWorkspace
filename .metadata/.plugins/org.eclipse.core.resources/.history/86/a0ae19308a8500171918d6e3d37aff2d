/*
 * Copyright 1997-2008 Day Management AG
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
import java.util.Iterator;

import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.Predicate;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Properties;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ResourceUtil;
import org.apache.sling.api.resource.ValueMap;
import org.apache.sling.commons.json.JSONException;
import org.apache.sling.commons.json.io.JSONWriter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.day.cq.commons.servlets.AbstractPredicateServlet;
import com.day.cq.wcm.foundation.forms.FieldDescription;
import com.day.cq.wcm.foundation.forms.FieldHelper;
import com.day.cq.wcm.foundation.forms.FormsConstants;
import com.day.cq.wcm.foundation.forms.FormsHelper;
import com.day.cq.wcm.foundation.forms.FormsManager;
import com.day.cq.wcm.foundation.forms.FormsManager.ComponentDescription;

/**
 * Exports a list of form actions.
 */
@Component(metatype = false)
@Service(Servlet.class)
@Properties({
        @Property(
                name = "sling.servlet.paths",
                value = {
                        "/bin/wcm/foundation/forms/actions",
                        "/bin/wcm/foundation/forms/constraints",
                        "/bin/wcm/foundation/forms/actiondialog",
                        "/bin/wcm/foundation/forms/report"
                }
        ),
        @Property(name = "sling.servlet.extensions", value = {"json", "html"}),
        @Property(name = "sling.servlet.methods", value = "GET")
})
public class FormsListServlet extends AbstractPredicateServlet {

    /**
     * default logger
     */
    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    @Reference
    private FormsManager formsManager;

    /**
     * {@inheritDoc}
     */
    protected void doGet(SlingHttpServletRequest req, SlingHttpServletResponse resp,
                         Predicate predicate)
    throws ServletException, IOException {
        try {
            JSONWriter w = new JSONWriter(resp.getWriter());
            if ( req.getRequestURI().contains("/actions") ) {
                resp.setContentType("application/json");
                resp.setCharacterEncoding("utf-8");

                writeActions(w);
            } else if ( req.getRequestURI().contains("/constraints") ) {
                resp.setContentType("application/json");
                resp.setCharacterEncoding("utf-8");

                writeConstraints(w);
            } else if ( req.getRequestURI().contains("/actiondialog") ) {
                final String dialogPath = this.formsManager.getDialogPathForAction(req.getParameter("id"));
                if ( dialogPath != null ) {
                    req.getRequestDispatcher(dialogPath + ".infinity.json").forward(req, resp);
                } else {
                    // if there is no dialog just return an empty dialog
                    resp.setContentType("application/json");
                    resp.setCharacterEncoding("utf-8");

                    resp.getWriter().write("{jcr:primaryType:\"cq:WidgetCollection\"}");
                }
            } else if ( req.getRequestURI().contains("/report") ) {
                // we collect the information and then redirect to the bulk editor
                final String path = req.getParameter("path");
                if ( path == null || path.trim().length() == 0 ) {
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Path parameter is missing.");
                    return;
                }
                final Resource formStartResource = req.getResourceResolver().getResource(path);
                if ( formStartResource == null ) {
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Resource not found.");
                    return;
                }
                final ValueMap vm = ResourceUtil.getValueMap(formStartResource);
                final StringBuilder sb = new StringBuilder();
                sb.append(req.getContextPath());
                sb.append("/etc/importers/bulkeditor.html?rootPath=");
                String actionPath = vm.get(FormsConstants.START_PROPERTY_ACTION_PATH, "");
                if( actionPath == null || actionPath.trim().length() == 0) {
                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST, 
                            "Missing '" + FormsConstants.START_PROPERTY_ACTION_PATH + "' property on node " 
                            + formStartResource.getPath());
                }
                if ( actionPath.endsWith("*") ) {
                    actionPath = actionPath.substring(0, actionPath.length() - 1);
                }
                if ( actionPath.endsWith("/") ) {
                    actionPath = actionPath.substring(0, actionPath.length() - 1);
                }
                sb.append(FormsHelper.encodeValue(actionPath));
                sb.append("&initialSearch=true&contentMode=false&spc=true");
                final Iterator<Resource> elements = FormsHelper.getFormElements(formStartResource);
                while ( elements.hasNext() ) {
                    final Resource element = elements.next();
                    FieldHelper.initializeField(req, resp, element);
                    final FieldDescription[] descs = FieldHelper.getFieldDescriptions(req, element);
                    for(final FieldDescription desc : descs) {
                        if ( !desc.isPrivate() ) {
                            final String name = FormsHelper.encodeValue(desc.getName());
                            sb.append("&cs=");
                            sb.append(name);
                            sb.append("&cv=");
                            sb.append(name);
                        }
                    }
                }
                resp.sendRedirect(sb.toString());
            }
        } catch (Exception e) {
            logger.error("Error while generating JSON list", e);
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.toString());
            return;
        }
    }

    private void writeJson(Iterator<ComponentDescription> descIter, JSONWriter w, boolean writeEmpty)
    throws JSONException {
        w.array();
        if ( writeEmpty ) {
            w.object();
            w.key("value").value("");
            w.key("text").value("None");
            w.endObject();
        }
        while (descIter.hasNext() ) {
            final ComponentDescription desc = descIter.next();
            w.object();
            w.key("value");
            w.value(desc.getResourceType());
            w.key("text");
            w.value(desc.getTitle());
            if ( desc.getHint() != null ) {
                w.key("qtip");
                w.value(desc.getHint());
            }
            w.endObject();
        }
        w.endArray();
    }

    /**
     * Generates a JSON export of actions
     */
    private void writeActions(JSONWriter w)
    throws JSONException {
        writeJson(this.formsManager.getActions(), w, false);
    }

    /**
     * Generates a JSON export of constraints
     */
    private void writeConstraints(JSONWriter w)
    throws JSONException {
        writeJson(this.formsManager.getConstraints(), w, true);
   }
}