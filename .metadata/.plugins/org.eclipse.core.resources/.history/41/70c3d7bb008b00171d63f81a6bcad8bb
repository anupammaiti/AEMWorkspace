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

package com.day.cq.wcm.foundation;

import com.adobe.granite.xss.XSSAPI;
import com.day.cq.wcm.api.Page;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ValueMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.jcr.Node;
import javax.jcr.RepositoryException;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Provides convenience methods for rendering external application paragraphs.
 */
public class External {

    /**
     * Limit enumeration.
     */
    public static enum Limit {

        NO("no"),
        HOST("host"),
        OFF("off");

        private final String value;

        private Limit(String value) {
            this.value = value;
        }

        @Override
        public String toString() {
            return value;
        }
    }

    /**
     * internal logger
     */
    private static final Logger log = LoggerFactory.getLogger(External.class);

    /**
     * Target property.
     */
    public static final String PN_TARGET = "target";

    /**
     * Inclusion property.
     */
    public static final String PN_INCLUSION = "inclusion";

    /**
     * Limit property.
     */
    public static final String PN_LIMIT = "limit";

    /**
     * Pass parameters property.
     */
    public static final String PN_PASSPARAMS = "passparams";

    /**
     * Width property.
     */
    public static final String PN_WIDTH = "width";

    /**
     * Height property.
     */
    public static final String PN_HEIGHT = "height";

    /**
     * Fixed property value.
     */
    public static final String PV_FIXED = "fixed";

    /**
     * internal resource
     */
    protected final Resource resource;

    /**
     * internal properties
     */
    protected final ValueMap properties;

    /**
     * internal node
     */
    protected final Node node;

    /**
     * Path to containing page.
     */
    protected final String pagePath;

    /**
     * Resource path extended by selector.
     */
    protected final String resourcePath;

    /**
     * POST selector.
     */
    protected final String postSelector;

    /**
     * Target parameter name.
     */
    protected final String targetParam;

    /**
     * Target.
     */
    protected String target;

    /**
     * Creates a new external based on the given resource
     *
     * @param resource resource
     *
     * @throws IllegalArgumentException if the given resource is not adaptable to node.
     */
    public External(Resource resource, Page page, String spoolSelector, String postSelector, String targetParam) {

        if (null == resource) {
            throw new IllegalArgumentException("resource may not be null");
        }

        this.resource = resource;
        this.properties = resource.adaptTo(ValueMap.class);
        this.node = resource.adaptTo(Node.class);
        this.pagePath = page.getPath();
        this.resourcePath = resource.getPath() + "." + spoolSelector;
        this.postSelector = postSelector;
        this.targetParam = targetParam;
    }

    /**
     * Returns the underlying resource.
     *
     * @return the resource
     */
    public Resource getResource() {
        return resource;
    }

    /**
     * Checks if this external component has content.
     *
     * @return <code>true</code> if this download has content.
     */
    public boolean hasContent() {
        return getTarget() != null;
    }

    /**
     * Return the target of the external application component.
     *
     * @return target
     */
    public String getTarget() {
        if (target != null) {
            return target;
        }
        return getStringProperty(PN_TARGET);
    }

    /**
     * Override the target to display.
     *
     * @param target target
     */
    public void setTarget(String target) {
        this.target = target;
    }

    /**
     * Return a flag indicating whether parameters should be passed to the external site.
     *
     * @return <code>true</code> if the parameters should be passed; <code>false</code> otherwise
     */
    public boolean passParameters() {
        return "true".equals(getStringProperty(PN_PASSPARAMS));
    }

    /**
     * Return a flag indicating whether the external site should be included adaptive (rewritten html) or fixed (as an
     * IFRAME).
     *
     * @return <code>true</code> if the external site should be included fixed; <code>false</code> otherwise
     */
    public boolean isFixed() {
        return PV_FIXED.equals(getStringProperty(PN_INCLUSION));
    }

    /**
     * Return the width as a string. If none is found, returns "100%".
     *
     * @return width
     */
    public String getWidth() {
        return getStringProperty(PN_WIDTH, "100%");
    }

    /**
     * Return the height as a string. If none is found, returns "100%".
     *
     * @return height
     */
    public String getHeight() {
        return getStringProperty(PN_HEIGHT, "100%");
    }

    /**
     * Return the limit.
     *
     * @return limit
     */
    public Limit getLimit() {
        String s = getStringProperty(PN_LIMIT);
        if (s != null) {
            try {
                return Limit.valueOf(s.toUpperCase());
            } catch (IllegalArgumentException e) {
                log.warn("Value of " + PN_LIMIT + " illegal: " + s);
            }
        }
        return Limit.NO;
    }

    /**
     * Return the value of a property in this component's associated node.
     *
     * @param name property name
     *
     * @return property value or <code>null</code>
     */
    private String getStringProperty(String name) {
        return getStringProperty(name, null);
    }

    /**
     * Return the value of a property in this component's associated node.
     *
     * @param name         property name
     * @param defaultValue default value
     *
     * @return property value or default value
     */
    private String getStringProperty(String name, String defaultValue) {
        try {
            if (node.hasProperty(name)) {
                return node.getProperty(name).getString();
            }
        } catch (RepositoryException e) {
            log.warn("Unable to retrieve property " + name, e);
        }
        return defaultValue;
    }

    /**
     * Draw this component.
     */
    public void draw(SlingHttpServletRequest request, SlingHttpServletResponse response) throws IOException {

        final String target = getTarget();
        if (target == null) {
            return;
        }

        final XSSAPI xssapi = request.adaptTo(XSSAPI.class);

        final PrintWriter writer = response.getWriter();
        writer.println("<iframe src=\"");
        writer.println(xssapi.getValidHref(target));
        writer.println("\" width=\"");
        writer.println(getWidth());
        writer.println("\" height=\"");
        writer.println(getHeight());
        writer.println("\"></iframe>");
    }
}