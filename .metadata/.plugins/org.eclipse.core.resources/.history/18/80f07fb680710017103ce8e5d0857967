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

import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ResourceUtil;
import org.apache.sling.api.resource.ValueMap;

import com.day.cq.wcm.foundation.forms.impl.FormsUtil;


/**
 * A description of a form field as it is later used in the html
 * form.
 * A field component usually maps to a single field description,
 * however compound fields like an address field map to
 * several field descriptions.
 *
 * The field description is used mostly during validation as it
 * contains all necessary information.
 *
 * Field descriptions can be maintained from the {@link FieldHelper}.
 * @since 5.3
 */
public class FieldDescription {

    /** Field name. */
    private String name;

    /** Is this field required? */
    private boolean required = false;

    /** The message which is displayed if a required field is not set. */
    private String requiredMsg;

    /** Optional constraint type */
    private String constraintType;

    /** The message which is displayed if the constraint is not met. */
    private String constraintMsg;

    /** Is this a read only field? */
    private boolean readOnly = false;

    /** Is this a private field? */
    private boolean privateField = false;

    /** Is this a multi value field? */
    private boolean multiValue = false;

    /** The associated resource. */
    private final Resource fieldResource;

    /**
     * Construct a new field description for a field resource.
     * @param rsrc
     */
    public FieldDescription(final Resource rsrc) {
        this.fieldResource = rsrc;
    }

    /**
     * Construct a new field description for a field resource
     * and set the name property.
     * @param rsrc The resource
     * @param name The field name.
     */
    public FieldDescription(final Resource rsrc, final String name) {
        this.fieldResource = rsrc;
        this.name = name;
    }

    public void update(final Resource rsrc) {
        final ValueMap props = ResourceUtil.getValueMap(rsrc);
        this.required = props.get(FormsConstants.ELEMENT_PROPERTY_REQUIRED, Boolean.FALSE);
        this.readOnly = props.get(FormsConstants.ELEMENT_PROPERTY_READ_ONLY, Boolean.FALSE);
        String name = props.get(FormsConstants.ELEMENT_PROPERTY_NAME, "");
        if ( name.length() == 0 ) {
           name = ResourceUtil.getName(rsrc);
           name = FormsUtil.filterElementName(name);
        }
        this.name = name;
        String msg = props.get(FormsConstants.ELEMENT_PROPERTY_REQUIRED_MSG, "");
        if ( msg.length() == 0 ) {
            msg = "This field is required";
        }
        this.requiredMsg = msg;
        String constraint = props.get(FormsConstants.ELEMENT_PROPERTY_CONSTRAINT_TYPE, "");
        if ( constraint.length() > 0 ) {
            if ( constraint.indexOf('/') == -1) {
                constraint = FormsConstants.RT_FORM_CONSTRAINT + "s/" + constraint;
            }
        } else {
            constraint = null;
        }
        this.constraintType = constraint;
        msg = props.get(FormsConstants.ELEMENT_PROPERTY_CONSTRAINT_MSG, "");
        if ( msg.length() == 0 ) {
            msg = null;
        }
        this.constraintMsg = msg;
    }

    /**
     * Return the associated field resource
     */
    public Resource getFieldResource() {
        return this.fieldResource;
    }

    /**
     * Return the name of the field.
     */
    public String getName() {
        return name;
    }

    /**
     * Set the name for the field.
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * Is this field required?
     */
    public boolean isRequired() {
        return required;
    }

    /**
     * Set if this field is requried.
     */
    public void setRequired(boolean required) {
        this.required = required;
    }

    /**
     * Return the error message for a required field.
     */
    public String getRequiredMessage() {
        return requiredMsg;
    }

    /**
     * Set the error message for a required field.
     */
    public void setRequiredMessage(String requiredMsg) {
        this.requiredMsg = requiredMsg;
    }

    /**
     * Get the constraint type (might be null).
     */
    public String getConstraintType() {
        return constraintType;
    }

    /**
     * Set the constraint type (might be null).
     */
    public void setConstraintType(String constraintType) {
        this.constraintType = constraintType;
    }

    /**
     * The error message if the constraint is not met.
     */
    public String getConstraintMessage() {
        return constraintMsg;
    }

    /**
     * Set error message if the constraint is not met.
     */
    public void setConstraintMessage(String constraintMsg) {
        this.constraintMsg = constraintMsg;
    }

    /**
     * Is this field readonly?
     */
    public boolean isReadOnly() {
        return readOnly;
    }

    /**
     * Set if this field is readonly.
     */
    public void setReadOnly(boolean readOnly) {
        this.readOnly = readOnly;
    }

    /**
     * Is this a private field?
     */
    public boolean isPrivate() {
        return privateField;
    }

    /**
     * Set if this is a private field.
     */
    public void setPrivateField(boolean flag) {
        this.privateField = flag;
    }

    /**
     * Is this a multi value field?
     */
    public boolean isMultiValue() {
        return multiValue;
    }

    /**
     * Set if this is a private field.
     */
    public void setMultiValue(boolean flag) {
        this.multiValue = flag;
    }
}
