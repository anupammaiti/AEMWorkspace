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

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspWriter;

import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ResourceUtil;
import org.apache.sling.api.resource.ValueMap;

import com.day.cq.wcm.foundation.forms.impl.JspSlingHttpServletResponseWrapper;
import com.day.cq.wcm.foundation.forms.impl.ResourceWrapper;

/**
 * Helper class for the forms components for validation.
 * @deprecated Check the methods for alternatives.
 */
@Deprecated
public class ValidationHelper {

    private ValidationHelper() {
        // no intances
    }

    /**
     * Return the current validation info for server side validation
     * @param request The current request
     * @return The validation info object.
     * @deprecated Use {@link ValidationInfo#createValidationInfo(SlingHttpServletRequest)}
     */
    @Deprecated
    public static ValidationInfo getValidationInfo(final SlingHttpServletRequest request) {
        return ValidationInfo.createValidationInfo(request);
    }

    /**
     * Check if there are validation errors for the current request.
     * @param request The curren t request.
     * @return <code>true</code> if there are validation errors.
     * @deprecated Use {@link ValidationInfo#getValidationInfo(HttpServletRequest)}
     */
    @Deprecated
    public static boolean hasValidationInfo(final HttpServletRequest request) {
        return ValidationInfo.getValidationInfo(request) != null;
    }

    /**
     * Return the required message for this element.
     * @param resource The form element resource.
     * @return The required message.
     * @deprecated Use a {@link FieldDescription} instead.
     */
    @Deprecated
    public static String getRequiredMessage(final Resource resource) {
        final ValueMap properties = ResourceUtil.getValueMap(resource);
        String msg = properties.get(FormsConstants.ELEMENT_PROPERTY_REQUIRED_MSG, "");
        if ( msg.length() == 0 ) {
            msg = "Field is required.";
        }
        return msg;
    }

    /**
     * Return the constraint message for this element.
     * @param resource The form element resource.
     * @return The constraint message.
     * @deprecated Use {@link FieldHelper#getConstraintMessage(FieldDescription, SlingHttpServletRequest)}
     */
    @Deprecated
    public static String getConstraintMessage(final Resource resource) {
        final ValueMap properties = ResourceUtil.getValueMap(resource);
        String msg = properties.get(FormsConstants.ELEMENT_PROPERTY_CONSTRAINT_MSG, "");
        if ( msg.length() == 0 ) {
            msg = "Field is not valid.";
        }
        return msg;
    }

    /**
     * Convenience method to check the required flag of a form element.
     * @param request
     * @param resource The form element resource.
     * @return true if check passed.
     * @deprecated Use {@link FieldHelper#checkRequired(SlingHttpServletRequest, FieldDescription)}
     */
    @Deprecated
    public static boolean checkRequired(final SlingHttpServletRequest request,
                                        final Resource resource) {
        final String name = FormsHelper.getParameterName(resource);
        final String value = request.getParameter(name);

        final boolean isEmpty = (value == null || value.trim().length() == 0);
        // required is checked first
        if ( FormsHelper.isRequired(resource) && isEmpty ) {
            ValidationInfo.createValidationInfo(request).addErrorMessage(name,
                    ValidationHelper.getRequiredMessage(resource));
            return false;
        }
        return true;
    }

    /**
     * Convenience method to check the constraint of a form element.
     * @param request
     * @param resource The form element resource.
     * @deprecated Use {@link FieldHelper#checkConstraint(SlingHttpServletRequest, SlingHttpServletResponse, FieldDescription)}
     */
    @Deprecated
    public static void checkConstraint(final SlingHttpServletRequest request,
                                       final SlingHttpServletResponse response,
                                       final Resource resource)
    throws IOException, ServletException {
        final ValueMap properties = ResourceUtil.getValueMap(resource);
        final String name = FormsHelper.getParameterName(resource);
        final String value = request.getParameter(name);

        final boolean isEmpty = (value == null || value.trim().length() == 0);

        // we evaluate the constraint only if the field is not null
        if ( !isEmpty ) {
            // additional constraint?
            final String constraint = properties.get(FormsConstants.ELEMENT_PROPERTY_CONSTRAINT_TYPE, "");
            if ( constraint.length() > 0 ) {
                String rt = constraint;
                if ( constraint.indexOf('/') == -1) {
                    rt = FormsConstants.RT_FORM_CONSTRAINT + "s/" + rt;
                }
                final Resource includeResource = new ResourceWrapper(resource, rt, FormsConstants.RST_FORM_CONSTRAINT);
                FormsHelper.includeResource(request, response, includeResource, FormsConstants.SCRIPT_SERVER_VALIDATION);
            }
        }
    }

    /**
     * Write java script client code for a required check.
     * @deprecated Use {@link FieldHelper#writeClientRequiredCheck(SlingHttpServletRequest, SlingHttpServletResponse, FieldDescription)}
     */
    @Deprecated
    public static void writeRequiredCheck(final SlingHttpServletRequest request,
                                          final Resource resource,
                                          final JspWriter out)
    throws IOException {
        final String formId = FormsHelper.getFormId(request);
        final String name = FormsHelper.getParameterName(resource);

        if ( FormsHelper.isRequired(resource) ) {
            final String qualifier = getFormElementQualifier(request, resource);
            out.print("if (cq5forms_isEmpty(");
            out.print(qualifier);
            out.print(")) {cq5forms_showMsg('");
            out.print(StringEscapeUtils.escapeEcmaScript(formId));
            out.print("','");
            out.print(StringEscapeUtils.escapeEcmaScript(name));
            out.print("','");
            out.print(StringEscapeUtils.escapeEcmaScript(ValidationHelper.getRequiredMessage(resource)));
            out.println("'); return false; }");
        }
    }

    /**
     * @deprecated Use {@link FieldHelper#getClientFieldQualifier(SlingHttpServletRequest, FieldDescription)}
     */
    @Deprecated
    public static String getFormElementQualifier(final SlingHttpServletRequest request,
                                                 final Resource resource) {
        final String formId = FormsHelper.getFormId(request);
        final String name = FormsHelper.getParameterName(resource);
        return "document.forms[\"" + StringEscapeUtils.escapeEcmaScript(formId) + "\"]"
				+ ".elements[\"" + StringEscapeUtils.escapeEcmaScript(name) + "\"]";
    }

    /**
     * Write java script client code for a constraint check.
     * @deprecated Use {@link FieldHelper#writeClientConstraintCheck(SlingHttpServletRequest, SlingHttpServletResponse, FieldDescription)}
     */
    @Deprecated
    public static void writeConstraintCheck(final SlingHttpServletRequest request,
                                            final SlingHttpServletResponse response,
                                            final Resource resource,
                                            final JspWriter out)
    throws IOException, ServletException {
        final ValueMap properties = ResourceUtil.getValueMap(resource);

        // additional constraint?
        final String constraint = properties.get(FormsConstants.ELEMENT_PROPERTY_CONSTRAINT_TYPE, "");
        if ( constraint.length() > 0 ) {
            final String qualifier = getFormElementQualifier(request, resource);
            out.print("if (!cq5forms_isEmpty(");
            out.print(qualifier);
            out.print(")){");
            String rt = constraint;
            if ( constraint.indexOf('/') == -1) {
                rt = FormsConstants.RT_FORM_CONSTRAINT + "s/" + rt;
            }
            final Resource includeResource = new ResourceWrapper(resource, rt, FormsConstants.RST_FORM_CONSTRAINT);

            FormsHelper.includeResource(request, new JspSlingHttpServletResponseWrapper(response, out), includeResource, FormsConstants.SCRIPT_CLIENT_VALIDATION);
            out.print("}");
        }
    }

    /**
     * Write java script client code for a regexp.
     * @deprecated Use {@link FieldHelper#writeClientRegexpText(SlingHttpServletRequest, SlingHttpServletResponse, FieldDescription, String)}
     */
    @Deprecated
    public static void writeRegexpText(final SlingHttpServletRequest request,
                                       final Resource resource,
                                       final String regexp,
                                       final JspWriter out)
    throws IOException {
        final String id = ValidationHelper.getFormElementQualifier(request, resource);
        final String name = FormsHelper.getParameterName(resource);
        out.println("{ var result=false;");
        out.print("var pattern = ");
        out.print(regexp);
        out.print("; var t = pattern.exec(");
        out.print(id);
        out.print(".value);");
        out.println("if (t) {");
        out.println("var len = ");
        out.print(id);
        out.print(".value.length;");
        out.println("var pattlen = t[0].length;");
        out.println("result = (pattlen == len); ");
        out.println("}");
        out.println("if ( !result ) {");
        out.print("cq5forms_showMsg('");
        out.print(StringEscapeUtils.escapeEcmaScript(FormsHelper.getFormId(request)));
        out.print("','");
        out.print(StringEscapeUtils.escapeEcmaScript(name));
        out.print("','");
        out.print(StringEscapeUtils.escapeEcmaScript(ValidationHelper.getConstraintMessage(resource)));
        out.print("');");
        out.println("return false; } }");
    }
}