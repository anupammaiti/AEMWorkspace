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
import java.io.PrintWriter;
import java.util.Locale;
import java.util.ResourceBundle;

import javax.servlet.ServletException;

import com.day.cq.wcm.api.LanguageManager;
import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.sling.api.SlingException;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ResourceResolver;
import org.apache.sling.api.resource.ResourceUtil;
import org.apache.sling.api.resource.ValueMap;

import com.day.cq.wcm.foundation.forms.impl.FormsHandlingResponse;
import com.day.cq.wcm.foundation.forms.impl.ResourceWrapper;
import org.apache.sling.api.scripting.SlingBindings;
import org.apache.sling.api.scripting.SlingScriptHelper;


/**
 * Helper class for the field components.
 * @since 5.3
 */
public class FieldHelper {

    private FieldHelper() {
        // no instances
    }

    /** Request attribute prefix for description cache. */
    private static final String ATTR_CACHE = FieldHelper.class.getName() + "/Cache";
    /** Request attribute prefix for init flag. */
    private static final String ATTR_INIT = FieldHelper.class.getName() + "/Init";
    /** Request attribute for the current field description. */
    private static final String ATTR_DESC = FieldHelper.class.getName() + "/CurrentDesc";

    /**
     * Get the attribute name for the cache entry.
     */
    private static String getCacheAttrName(final Resource rsrc) {
        return ATTR_CACHE + rsrc.getPath();
    }

    /**
     * Get the attribute name for the init flag.
     */
    private static String getInitAttrName(final Resource rsrc) {
        return ATTR_INIT + rsrc.getPath();
    }

    /**
     * Create a default field description for the field.
     * This methods creates a new field description via
     * {@link FieldDescription#FieldDescription(Resource)}
     * and associates this with the resource.
     * If this method is invoked twice for the same resource
     * and request combination, the default description is
     * added twice as well!
     *
     * @param req  The current request.
     * @param rsrc The field resource.
     * @return The new field description.
     */
    public static FieldDescription createDefaultDescription(final SlingHttpServletRequest req,
                                                            final Resource rsrc) {
        final FieldDescription desc = new FieldDescription(rsrc);
        desc.update(rsrc);
        addDescription(req, desc);
        return desc;
    }

    /**
     * Add a field description for the field.
     *
     * @param req  The current request.
     * @param desc The new field description.
     */
    public static void addDescription(final SlingHttpServletRequest req,
                                      final FieldDescription desc) {
        final String key = getCacheAttrName(desc.getFieldResource());
        FieldDescription[] descs = (FieldDescription[]) req.getAttribute(key);
        if ( descs == null ) {
            descs = new FieldDescription[] {desc};
        } else {
            FieldDescription[] newDescs = new FieldDescription[descs.length + 1];
            System.arraycopy(descs, 0, newDescs, 0, descs.length);
            newDescs[descs.length] = desc;
            descs = newDescs;
        }
        req.setAttribute(key, descs);
    }

    /**
     * Return all field descriptions associated with this field.
     * @param req  The current request.
     * @param rsrc The field resource.
     * @return The descriptions for this field.
     */
    public static FieldDescription[] getFieldDescriptions(final SlingHttpServletRequest req,
                                                          final Resource rsrc) {
        final String key = getCacheAttrName(rsrc);
        FieldDescription[] descs = (FieldDescription[]) req.getAttribute(key);
        if ( descs == null ) {
            descs = new FieldDescription[] { createDefaultDescription(req, rsrc)};
        }
        return descs;
    }

    /**
     * Call the initialize script for the field.
     * @param req The current request.
     * @param res The current response.
     * @param rsrc The field resource.
     */
    public static void initializeField(final SlingHttpServletRequest req,
                                       final SlingHttpServletResponse res,
                                       final Resource rsrc)
    throws ServletException, IOException {
        initField(req, res, rsrc);
    }

    /**
     * Get the full qualified path to the field to be used in client java script.
     */
    public static String getClientFieldQualifier(final SlingHttpServletRequest request,
                                                 final FieldDescription desc) {
        return getClientFieldQualifier(request, desc, "");
    }

    /**
     * Get the full qualified path to a suffixed field (e.g. @Write) to be used in client java script.
     * @param request The request
     * @param desc The field descritpion
     * @param suffix The suffix
     * @return The qualified path
     * @since 5.5
     */
    public static String getClientFieldQualifier(SlingHttpServletRequest request, FieldDescription desc, String suffix) {
        final String formId = FormsHelper.getFormId(request);
        return "document.forms[\"" + StringEscapeUtils.escapeEcmaScript(formId) + "\"]"
				+ ".elements[\"" + desc.getName() + suffix + "\"]";
    }

    /**
     * Return the current field description.
     * This method can be used by constraints to get the current
     * field description.
     * @return The current field description.
     */
    public static FieldDescription getConstraintFieldDescription(final SlingHttpServletRequest req) {
        FieldDescription desc = (FieldDescription) req.getAttribute(ATTR_DESC);
        if ( desc == null ) {
            desc = new FieldDescription(req.getResource());
            desc.update(req.getResource());
        }
        return desc;
    }

    /**
     * Write the client java script code to check a required field on
     * form submit.
     */
    public static void writeClientRequiredCheck(final SlingHttpServletRequest request,
                                                final SlingHttpServletResponse response,
                                                final FieldDescription desc)
    throws IOException {
        final String formId = FormsHelper.getFormId(request);
        if ( desc.isRequired() ) {
            final PrintWriter out = response.getWriter();
            final String qualifier = getClientFieldQualifier(request, desc);
            String requiredMsg = desc.getRequiredMessage();
            // localize required message
            requiredMsg = FormsHelper.getLocalizedMessage(requiredMsg, request);
            out.write("if (cq5forms_isEmpty(");
            out.write(qualifier);
            out.write(")) {cq5forms_showMsg('");
            out.write(StringEscapeUtils.escapeEcmaScript(formId));
            out.write("','");
            out.write(StringEscapeUtils.escapeEcmaScript(desc.getName()));
            out.write("','");
            out.write(StringEscapeUtils.escapeEcmaScript(requiredMsg));
            out.write("'); return false; }\n");
        }
    }

    /**
     * Return the error message for the constraint of the field.
     * If the field description has a constraint message, this message is used,
     * if not a default constraint message is looked up from the constraint
     * resource. If no such message is available, "Field is not valid" is
     * used as the message.
     *
     * @param desc The field description.
     * @param request The current request.
     * @return The constraint error message.
     */
    public static String getConstraintMessage(final FieldDescription desc,
                                              final SlingHttpServletRequest request) {
        String msg = desc.getConstraintMessage();
        if ( msg == null ) {
            final ResourceResolver resourceResolver = request.getResourceResolver();
            int index = 0;
            final String[] paths = resourceResolver.getSearchPath();
            while ( index < paths.length && msg == null ) {
                final String scriptPath = paths[index] + request.getResource().getResourceType();
                try {
                    final Resource scriptResource = resourceResolver.getResource(scriptPath);
                    if ( scriptResource != null ) {
                        // check for a default message from constraint
                        final ValueMap props = ResourceUtil.getValueMap(scriptResource);
                        msg = props.get(FormsConstants.COMPONENT_PROPERTY_CONSTRAINT_MSG, String.class);
                    }
                } catch (SlingException se) {
                    // we ignore this!
                }
                index++;
            }
            if ( msg == null ) {
                msg = "Field is not valid.";
            }
        }
        // localize msg
        msg = FormsHelper.getLocalizedMessage(msg, request);
        return msg;
    }

    /**
     * Write client regexp text.
     */
    public static void writeClientRegexpText(final SlingHttpServletRequest request,
                                             final SlingHttpServletResponse response,
                                             final FieldDescription desc,
                                             final String regexp)
    throws IOException {
        final PrintWriter out = response.getWriter();
        final String id = getClientFieldQualifier(request, desc);
        out.write("{var obj =");
        out.write(id);
        out.write(";" +
                  "if ( cq5forms_isArray(obj)) {" +
                  "for(i=0;i<obj.length;i++) {" +
                  "if (!cq5forms_regcheck(obj[i].value, ");
        out.write(regexp);
        out.write(")) {" +
                  "cq5forms_showMsg('");
        out.write(FormsHelper.getFormId(request));
        out.write("','");
        out.write(desc.getName());
        out.write("','");
        out.write(getConstraintMessage(desc, request));
        out.write("', i); return false;}}} else {" +
                  "if (!cq5forms_regcheck(obj.value, ");
        out.write(regexp);
        out.write(")) {" +
                  "cq5forms_showMsg('");
        out.write(StringEscapeUtils.escapeEcmaScript(FormsHelper.getFormId(request)));
        out.write("','");
        out.write(StringEscapeUtils.escapeEcmaScript(desc.getName()));
        out.write("','");
        out.write(StringEscapeUtils.escapeEcmaScript(getConstraintMessage(desc, request)));
        out.write("'); return false;}}}");
    }

    /**
     * Write the client java script code to check a constraint on
     * form submit.
     */
    public static void writeClientConstraintCheck(final SlingHttpServletRequest request,
                                                  final SlingHttpServletResponse response,
                                                  final FieldDescription        desc)
    throws IOException, ServletException {
        if ( desc.getConstraintType() != null ) {
            final PrintWriter out = response.getWriter();
            final String qualifier = getClientFieldQualifier(request, desc);
            out.write("if (!cq5forms_isEmpty(");
            out.write(qualifier);
            out.write(")){");
            try {
                request.setAttribute(ATTR_DESC, desc);
                final Resource includeResource = new ResourceWrapper(desc.getFieldResource(),
                        desc.getConstraintType(), FormsConstants.RST_FORM_CONSTRAINT);

                FormsHelper.includeResource(request, response, includeResource, FormsConstants.SCRIPT_CLIENT_VALIDATION);
                out.write("}");
            } finally {
                request.removeAttribute(ATTR_DESC);
            }
        }
    }

    /**
     * Convenience method to check the constraint of a field element.
     * If the field has a constraint and is not empty, the constraint is checked.
     *
     * @param request The current request.
     * @param response The current response.
     * @param desc The field description.
     */
    public static void checkConstraint(final SlingHttpServletRequest request,
                                       final SlingHttpServletResponse response,
                                       final FieldDescription desc)
    throws IOException, ServletException {
        // we evaluate the constraint only if the field is not null
        if ( !isEmpty(request, desc.getName()) && doValidation(request, desc) ) {
            // additional constraint?
            if ( desc.getConstraintType() != null ) {
                try {
                    request.setAttribute(ATTR_DESC, desc);
                    final Resource includeResource = new ResourceWrapper(desc.getFieldResource(), desc.getConstraintType(), FormsConstants.RST_FORM_CONSTRAINT);
                    FormsHelper.includeResource(request, response, includeResource, FormsConstants.SCRIPT_SERVER_VALIDATION);
                } finally {
                    request.removeAttribute(ATTR_DESC);
                }
            }
        }
    }

    /**
     * Convenience method to check the required flag of a field element.
     * @param request The current element.
     * @return true if check passed.
     */
    public static boolean checkRequired(final SlingHttpServletRequest request,
                                        final FieldDescription desc) {
        // required is checked first
        if ( isRequired(request, desc) && isEmpty(request, desc.getName()) && doValidation(request, desc) ) {
            ValidationInfo.createValidationInfo(request).addErrorMessage(desc.getName(),
                                                                        desc.getRequiredMessage());
            return false;
        }
        return true;
    }

    /**
     * Determine if the field has to be validated. If no or a single post resources
     * is defined the field is always validated. Multiple post resources are only
     * validated when the @Write parameter is set.
     * is set
     */
    private static boolean doValidation(SlingHttpServletRequest request, FieldDescription desc) {
        return request.getParameter(desc.getName() + FormResourceEdit.WRITE_SUFFIX) != null ||
                FormResourceEdit.isSingleResourcePost(request);
    }

    /**
     * Private method to initialize the field.
     */
    private static void initField(final SlingHttpServletRequest req,
                                  final SlingHttpServletResponse res,
                                  final Resource rsrc)
    throws ServletException, IOException {
        final String key = getInitAttrName(rsrc);
        final Object flag = req.getAttribute(key);
        if ( flag == null ) {
            req.setAttribute(key, Boolean.TRUE);
            FormsHelper.includeResource(req, new FormsHandlingResponse(res), rsrc, FormsConstants.SCRIPT_FIELD_INIT);
        }
    }

    /**
     * Checks if the request contains any parameter value of the given name, i.e.
     * either if a single value paramter is not emtpy or if multi value parameters
     * contain at least one value.
     * @param request
     * @param name
     * @return
     */
    private static boolean isEmpty(SlingHttpServletRequest request, String name) {
        String[] values = request.getParameterValues(name);
        if (values != null) {
            for (int i = 0; i < values.length; i++) {
                if (values[i].trim().length() > 0) {
                    return false;
                }
            }
        }
        return true;
    }

    /**
     * Checks that the required property of a field is set and that the field name exists in the request.
     * @param request
     * @param desc
     * @return
     */
    private static boolean isRequired(SlingHttpServletRequest request, FieldDescription desc) {

        // CQ5-34399: ignore required fields that were hidden by abacus
        String[] abacus_fields = request.getParameterValues(FormsConstants.REQUEST_PROPERTY_FIELD_HIDDEN);
        if (abacus_fields != null) {
            for (int i = 0; i < abacus_fields.length; i++) {
                if (abacus_fields[i].trim().equals(desc.getName())) {
                    return false;
                }
            }
        }

        return  desc.isRequired();

    }
}
