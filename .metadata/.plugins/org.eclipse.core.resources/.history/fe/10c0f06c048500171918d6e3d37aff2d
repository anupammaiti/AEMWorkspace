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
package com.day.cq.wcm.foundation.forms;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Locale;
import java.util.Map;
import java.util.ResourceBundle;

import javax.servlet.http.HttpServletRequest;

import com.day.cq.wcm.api.LanguageManager;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.request.RequestParameter;
import org.apache.sling.api.scripting.SlingBindings;
import org.apache.sling.api.scripting.SlingScriptHelper;
import org.apache.sling.api.resource.Resource;

/**
 * This class collects validation information (error messages) for a
 * form.
 */
public class ValidationInfo {

    /** Constant for global validation messages. */
    private static final String GLOBAL = "";

    /** The map containing all error messages. */
    private final Map<String, String[]> messages;

    /** The map containing all values */
    private final Map<String, String[]> values;

    /** The form id. */
    private final String formId;

    /** The resource bundle. */
    private final ResourceBundle resBundle;

    /** The request attribute caching the validation info. */
    private static final String REQ_ATTR = ValidationInfo.class.getName();

    /**
     * Construct a new validation info.
     * The validation info stores the form id, all content request parameters
     * and their values together with possible validation messages.
     * @param request The current request.
     */
    public ValidationInfo(final SlingHttpServletRequest request) {
        this.formId = FormsHelper.getFormId(request);
        this.values = new HashMap<String, String[]>();
        final Iterator<String> nameIter = FormsHelper.getContentRequestParameterNames(request);
        while ( nameIter.hasNext() ) {
            final String name = nameIter.next();
            final RequestParameter reqParam = request.getRequestParameter(name);
            if ( reqParam != null && reqParam.isFormField() ) {
                final String[] values = request.getParameterValues(name);
                if ( values != null && values.length > 0 ) {
                    this.values.put(name, values);
                }
            }
        }
        this.messages = new HashMap<String, String[]>();
        Locale locale = FormsHelper.getLocale(request);
        this.resBundle = request.getResourceBundle(locale);
        request.setAttribute(REQ_ATTR, this);
    }

    /**
     * Return all values for a field.
     * @param field The name of the field.
     * @return The array of values or <code>null</code>
     */
    public String[] getValues(String field) {
        return this.values.get(field);
    }

    /**
     * Add the error message for the field.
     * @param field The name of the field or <code>null</code>
     * @param msg The error message.
     */
    public void addErrorMessage(String field, String msg) {
        if ( this.resBundle == null ) {
            throw new IllegalStateException("Validation info is not mutable. The ResourceBundle of the request is not defined for the request locale.");
        }
        if ( field == null ) {
            field = GLOBAL;
        }
        // localize msg
        msg = this.resBundle.getString(msg);

        String[] msgs = this.messages.get(field);
        if ( msgs == null ) {
            this.messages.put(field, new String[] {msg});
        } else {
            String[] newMsgs = new String[msgs.length+1];
            System.arraycopy(msgs, 0, newMsgs, 0, msgs.length);
            newMsgs[msgs.length] = msg;
            this.messages.put(field, newMsgs);
        }
    }

    /**
     * Add the error message for the constraint of the field.
     * If the field description has a constraint message, this message is used,
     * if not a default constraint message is looked up from the constraint
     * resource. If no such message is available, "Field is not valid" is
     * used as the message.
     * @param request The current request usually targetting a constraint resource.
     * @param desc The field description.
     * @since 5.3
     */
    public static void addConstraintError(final SlingHttpServletRequest request,
                                          final FieldDescription desc) {
        createValidationInfo(request).addErrorMessage(desc.getName(),
                FieldHelper.getConstraintMessage(desc, request));
    }

    /**
     * Add the error message for the constraint of the field.
     * If the field description has a constraint message, this message is used,
     * if not a default constraint message is looked up from the constraint
     * resource. If no such message is available, "Field is not valid" is
     * used as the message.
     * @param request The current request usually targetting a constraint resource.
     * @param desc The field description.
     * @param valueIndex The value index.
     * @since 5.3
     */
    public static void addConstraintError(final SlingHttpServletRequest request,
                                          final FieldDescription desc,
                                          final int valueIndex) {
        createValidationInfo(request).addErrorMessage(desc.getName() + ':' + valueIndex,
                FieldHelper.getConstraintMessage(desc, request));
    }

    /**
     * Return the form id.
     * @return The form id or <code>null</code>
     */
    public String getFormId() {
        return this.formId;
    }

    /**
     * Return all error messages for this parameter.
     * @param field Parameter name or <code>null</code> to get global errors.
     * @return <code>null</code> if there are no messages
     */
    public String[] getErrorMessages(String field) {
        if ( field == null ) {
            field = GLOBAL;
        }
        return this.messages.get(field);
    }

    /**
     * Return all error messages for this parameter.
     * @param field Parameter name or <code>null</code> to get global errors.
     * @return <code>null</code> if there are no messages
     * @since 5.3
     */
    public String[] getErrorMessages(String field, final int valueIndex) {
        if ( field == null ) {
            field = GLOBAL;
        }
        return this.messages.get(field + ':' + valueIndex);
    }

    /**
     * Return the validation information for a request
     * @param req The current request.
     * @return The validation info for this request or <code>null</null>
     */
    public static ValidationInfo getValidationInfo(final HttpServletRequest req) {
        // we know that this one exists if it has been submitted
        ValidationInfo info = (ValidationInfo) req.getAttribute(REQ_ATTR);
        if ( info != null ) {
            final String currentFormId = (String)req.getAttribute(FormsHelper.REQ_ATTR_FORMID);
            // check if  this is the same form
            if ( !currentFormId.equals(info.getFormId()) ) {
                info = null;
            }
        }
        return info;
    }

    /**
     * Return the validation information for a request.
     * If a validation info is already associated with the request, this info is
     * returned, otherwise a new one is created, associated with the request
     * and returned.
     * @param req The current request.
     * @return The validation info
     */
    public static ValidationInfo createValidationInfo(final SlingHttpServletRequest req) {
        // we know that this one exists if it has been submitted
        ValidationInfo info = getValidationInfo(req);
        if ( info == null ) {
            info = new ValidationInfo(req);
        }
        return info;
    }
}
