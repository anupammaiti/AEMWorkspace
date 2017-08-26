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
package com.day.cq.wcm.foundation;

import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ResourceWrapper;

import com.day.cq.commons.DiffInfo;

/**
 * Provides an abstraction of paragraph within a paragraph system.
 */
public class Paragraph extends ResourceWrapper {

    /**
     * Type of the paragraph
     */
    public enum Type {

        /**
         * normal paragraph
         */
        NORMAL,

        /**
         * Column control 'start' paragraph
         */
        START,

        /**
         * Column control 'break' paragraph
         */
        BREAK,

        /**
         * Column control 'end' paragraph
         */
        END
    }

    /**
     * type of this paragraph
     */
    private final Type type;

    /**
     * columns number of this paragraph
     */
    private final int colNr;

    /**
     * the total number of columns
     */
    private final int numCols;

    /**
     * the css class
     */
    private final String cssClass;

    /**
     * The optional diff information.
     */
    private DiffInfo diffInfo;

    /**
     * Creates a new paragraph
     *
     * @param resource underlying resource
     * @param type     paragraph type
     * @param colNr    columns number
     * @param cssClass the css class
     * @param numCols  total number of columns
     */
    protected Paragraph(Resource resource, Type type, int colNr,
                        String cssClass, int numCols) {
        super(resource);
        this.type = type;
        this.colNr = colNr;
        this.cssClass = cssClass;
        this.numCols = numCols;
    }

    /**
     * Creates a new paragraph
     *
     * @param resource underlying resource
     * @param type     paragraph type
     */
    protected Paragraph(Resource resource, Type type) {
        this(resource, type, 0, "", 0);
    }

    /**
     * Returns the type of this paragraph
     *
     * @return type of this paragraph
     */
    public Type getType() {
        return type;
    }

    /**
     * Returns the columns number of this paragraph. Note that
     * {@link Type#BREAK} and {@link Type#END} paragraphs have the number of
     * the next columns.
     *
     * @return the columns number of this paragraph.
     */
    public int getColNr() {
        return colNr;
    }

    /**
     * Returns the total number of columns of the column group this paragraph
     * is in.
     *
     * @return the total number of columns.
     */
    public int getNumCols() {
        return numCols;
    }

    /**
     * Returns the css class of this paragraph.
     *
     * @return the CSS class
     */
    public String getBaseCssClass() {
        return cssClass;
    }

    /**
     * Returns the auto generated css class for the column of this paragraph.
     *
     * @return the CSS class
     */
    public String getCssClass() {
        return cssClass + "-c" + colNr;
    }

    /**
     * Set the diff information for this paragraph.
     *
     * @param di The diff information
     */
    public void setDiffInfo(final DiffInfo di) {
        this.diffInfo = di;
    }

    /**
     * {@inheritDoc}
     */
    @SuppressWarnings("unchecked")
    public <AdapterType> AdapterType adaptTo(Class<AdapterType> type) {
        if (type == DiffInfo.class) {
            return (AdapterType) diffInfo;
        } else if (type == com.day.cq.wcm.foundation.DiffInfo.class) {
            // deprecated
            return diffInfo == null
                    ? null
                    : (AdapterType) new com.day.cq.wcm.foundation.DiffInfo(diffInfo.getContent(), diffInfo.getType());
        }
        return super.adaptTo(type);
    }

    /**
     * Returns a human readable string representation of this resource.
     */
    public String toString() {
        return getClass().getSimpleName() + ", path=" + getPath() + ", type="
                + getResourceType() + ", cssClass=" + getBaseCssClass()
                + ", column=" + getColNr() + "/" + getNumCols() + ", diffInfo=["
                + diffInfo + "]" + ", resource=[" + getResource() + "]";
    }

}