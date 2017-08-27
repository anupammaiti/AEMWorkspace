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


/**
 * Some constants for the forms components.
 */
public class FormsConstants {

    private FormsConstants() {
        // no instances
    }

    //
    // resource types
    //

    /** The prefix for all form related resource types.*/
    public final static String RT_FORM_PREFIX = "foundation/components/form/";

    /** The resource type for a form begin. */
    public final static String RT_FORM_BEGIN = RT_FORM_PREFIX + "start";

    /** The resource type for a form end. */
    public final static String RT_FORM_END = RT_FORM_PREFIX + "end";

    /** The resource type for a form action. */
    public final static String RT_FORM_ACTION = RT_FORM_PREFIX + "action";

    /** The resource type for a form constraint. */
    public final static String RT_FORM_CONSTRAINT = RT_FORM_PREFIX + "constraint";

    /** The resource super type for a form action. */
    public final static String RST_FORM_ACTION = RT_FORM_PREFIX + "defaults/action";

    /** The resource super type for a form constraint. */
    public final static String RST_FORM_CONSTRAINT = RT_FORM_PREFIX + "defaults/constraint";

    /** The name of the resource property for the resource type. */
    public final static String PROPERTY_RT = "sling:resourceType";

    /** The name of the resource property for the resource super type. */
    public final static String PROPERTY_RST = "sling:resourceSuperType";

    //
    // properties for the start form element
    //
    public static final String START_PROPERTY_ACTION_PATH = "action";
    public static final String START_PROPERTY_ACTION_TYPE = "actionType";
    public static final String START_PROPERTY_LOAD_PATH = "loadPath";
    public static final String START_PROPERTY_CLIENT_VALIDATION = "clientValidation";
    public static final String START_PROPERTY_FORMID = "formid";
    public static final String START_PROPERTY_END_RESOURCE_TYPE = "endResourceType";
    public static final String START_PROPERTY_WORKFLOW_MODEL = "workflowModel";
    /** @since 5.4 */
    public static final String START_PROPERTY_VALIDATION_RT = "validationRT";

    /** The default action type - the store action. */
    public static final String DEFAULT_ACTION_TYPE = "foundation/components/form/actions/store";

    //
    // properties for the form element
    //
    public static final String ELEMENT_PROPERTY_NAME = "name";
    public static final String ELEMENT_PROPERTY_REQUIRED = "required";
    public static final String ELEMENT_PROPERTY_REQUIRED_MSG = "requiredMessage";
    public static final String ELEMENT_PROPERTY_CONSTRAINT_TYPE = "constraintType";
    public static final String ELEMENT_PROPERTY_CONSTRAINT_MSG = "constraintMessage";
    public static final String ELEMENT_PROPERTY_LOAD_PATH = "loadPath";
    public static final String ELEMENT_PROPERTY_DEFAULT_VALUE = "defaultValue";
    public static final String ELEMENT_PROPERTY_OPTIONS = "options";
    public static final String ELEMENT_PROPERTY_OPTIONS_LOAD_PATH = "optionsLoadPath";
    public static final String ELEMENT_PROPERTY_MULTI_SELECTION = "multiSelection";
    public static final String ELEMENT_PROPERTY_READ_ONLY = "readOnly";

    /** @since 5.4 */
    public static final String ELEMENT_PROPERTY_CSS = "css";

    /** Element type for text.
     * @deprecated */
    @Deprecated
    public static final String TYPE_TEXT_FIELD = "text";
    /** Element type for text.
     * @deprecated */
    @Deprecated
    public static final String TYPE_TEXT_AREA = "textarea";
    /** Element type for text.
     *  @deprecated */
    @Deprecated
    public static final String TYPE_PASSWORD = "password";

    //
    // constraint and action properties
    //
    public static final String COMPONENT_PROPERTY_ORDER = "order";
    public static final String COMPONENT_PROPERTY_ENABLED = "enabled";
    public static final String COMPONENT_PROPERTY_HINT = "hint";
    public static final String COMPONENT_PROPERTY_CONSTRAINT_MSG = "constraintMessage";

    //
    // request parameters
    //

    /** The request parameter containing the form id. */
    public static final String REQUEST_PROPERTY_FORMID = ":" + START_PROPERTY_FORMID;

    /** The request parameter containing the form start. */
    public static final String REQUEST_PROPERTY_FORM_START = ":formstart";

    /** The request parameter containing the redirect */
    public static final String REQUEST_PROPERTY_REDIRECT = ":redirect";

    /** The request parameter for fields that have been hidden on the client */
    public static final String REQUEST_PROPERTY_FIELD_HIDDEN = ":fieldhidden";

    /** Characters allowed for an element name. */
    public static final String ALLOWED_NAME_CHARS = "abcdefghijklmnopqrstuvwxyz0123456789_ABCDEFGHIJKLMNOPQRSTUVWXYZ./:-";

    /** Replacement character for invalid characters. */
    public static final char REPLACEMENT_CHAR = '_';

    /** Redirect to the referrer if no redirect is specified. */
    public static final String REQUEST_ATTR_REDIRECT_TO_REFERRER = FormsConstants.class.getName() + "/redirectToReferrer";

    // script names
    public static final String SCRIPT_CLIENT_VALIDATION ="clientvalidation";
    public static final String SCRIPT_SERVER_VALIDATION ="servervalidation";
    public static final String SCRIPT_FORM_INIT ="init";
    public static final String SCRIPT_FORM_ADD_FIELDS ="addfields";
    public static final String SCRIPT_FORM_CLIENT_VALIDATION = "formclientvalidation";
    public static final String SCRIPT_FORM_SERVER_VALIDATION = "formservervalidation";
    public static final String SCRIPT_FIELD_INIT ="init";

    // request attributes
    public static final String REQUEST_ATTR_WORKFLOW_PATH = "Forms.workflow.path";
    public static final String REQUEST_ATTR_WORKFLOW_PAYLOAD_PATH = "Forms.workflow.payloadPath";
}
