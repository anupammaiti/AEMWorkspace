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

import java.io.PrintWriter;
import java.util.Map;

import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ResourceUtil;

import com.day.cq.commons.ImageResource;
import com.day.cq.wcm.api.components.DropTarget;
import com.day.cq.wcm.api.components.Component;
import com.day.cq.wcm.api.designer.Style;
import com.day.cq.wcm.commons.WCMUtils;
import com.day.cq.dam.api.Asset;
import com.day.cq.dam.api.Rendition;
import com.day.text.Text;

/**
 * Provides convenience methods for displaying images.
 */
public class Image extends ImageResource {

    /**
     * name of the image map property
     */
    public static final String PN_IMAGE_MAP = "imageMap";

    /**
     * id of the image map
     */
    private String imageMapId;

    /**
     * deserialized image map
     */
    private ImageMap imageMap;

    /**
     * flag controlling if a placeholder image should be rendered if this image
     * has no content.
     */
    private boolean noPlaceholder;

    /**
     * Creates a new image based on the given resource. the image properties are
     * considered to 'on' the given resource.
     *
     * @param resource resource of the image
     * @throws IllegalArgumentException if the given resource is not adaptable to node.
     */
    public Image(Resource resource) {
        super(resource);

        // init default params
        imageMap = null;
        if (properties.containsKey(PN_IMAGE_MAP)) {
            try {
                String mapDefinition = properties.get(PN_IMAGE_MAP, "");
                if (mapDefinition.length() > 0) {
                    imageMap = ImageMap.fromString(mapDefinition);
                    imageMapId = "map_"
                            + Math.round(Math.random() * Integer.MAX_VALUE) + "_"
                            + System.currentTimeMillis();
                }
            } catch (IllegalArgumentException iae) {
                // ignore wrong map definition
                imageMap = null;
                imageMapId = null;
            }
        }
    }

    /**
     * Creates a new image based on the given resource. the image properties are
     * considered to 'on' the given resource unless <code>imageName</code>
     * is specified. then the respective child resource holds the image
     * properties.
     *
     * @param resource  current resource
     * @param imageName name of the image resource
     * @throws IllegalArgumentException if the given resource is not adaptable to node.
     */
    public Image(Resource resource, String imageName) {
        this(getRelativeResource(resource, imageName));
    }

    /**
     * Sets the drop target id for this image. the id is added as css class
     * to the image attribute. and has the format:
     * "{@value DropTarget#CSS_CLASS_PREFIX}{id}-{classifier}"
     *
     * @param id the drop target id as configured in edit config.
     * @param classifier optional classifier
     */
    public void setDropTargetId(String id, String classifier) {
        if (classifier == null) {
            classifier = "";
        }
        if (!classifier.startsWith("-")) {
            classifier = "-" + classifier;
        }
        addCssClass(DropTarget.CSS_CLASS_PREFIX + id + classifier);
    }

    /**
     *
     * Sets the drop target id for this image, using the name of the resources
     * as path.
     *
     * @param id the drop target id as configured in edit config.
     */
    public void setDropTargetId(String id) {
        String classifier = ResourceUtil.isNonExistingResource(this)
                ? String.valueOf(System.currentTimeMillis())
                : Text.getName(getPath());
        setDropTargetId(id, classifier);
    }

    /**
     * Returns the placeholder flag.
     * @return <code>true</code> if no placeholder for empty content should be
     *         drawn.
     */
    public boolean hasNoPlaceholder() {
        return noPlaceholder;
    }

    /**
     * Sets the placeholder flag.
     * @param noPlaceholder if <code>true</code> no placeholder for empty content
     *        is used.
     */
    public void setNoPlaceholder(boolean noPlaceholder) {
        this.noPlaceholder = noPlaceholder;
    }

    /**
     * Loads several definitions from style.
     * <p>
     * Currently, the minimum/maximum width and height are transferred from the given style.
     *
     * @param style style to load definitions from
     */
    public void loadStyleData(Style style) {
        // load additional definitions from style
        if (style != null) {
            this.set(Image.PN_MIN_WIDTH, style.get("minWidth", ""));
            this.set(Image.PN_MIN_HEIGHT, style.get("minHeight", ""));
            this.set(Image.PN_MAX_WIDTH, style.get("maxWidth", ""));
            this.set(Image.PN_MAX_HEIGHT, style.get("maxHeight", ""));
        }
    }

    /**
     * {@inheritDoc}
     *
     * @return <code>true</code> if {@link #hasNoPlaceholder()} is <code>false</code>
     *         or the image has content.
     */
    @Override
    protected boolean canDraw() {
        return !noPlaceholder || hasContent();
    }

    @Override
    protected Map<String, String> getImageTagAttributes() {
        String src = null;
        if (!hasContent()) {
            src = "/etc/designs/default/0.gif";
            if (isTouchAuthoringUIMode()) {
                // add default empty text if necessary
                Map<String, String> attrs = getAttributes();
                if (attrs.get(Placeholder.ATTRIBUTE_EMTPYTEXT) == null) {
                    addAttribute(Placeholder.ATTRIBUTE_EMTPYTEXT, "Image");
                }
                // add placeholder classes
                addCssClass(Placeholder.DEFAULT_PLACEHOLDER_TOUCH);
                addCssClass("file");
            } else {
                addCssClass("cq-image-placeholder");
            }
        }
        Map<String, String> attributes = super.getImageTagAttributes();
        if (src != null) {
            attributes.put("src", src);
        }
        if (imageMap != null) {
            attributes.put("usemap", "#" + imageMapId);
        }
        return attributes;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    protected void doDraw(PrintWriter w)  {
        super.doDraw(w);
        if (imageMap != null) {
            w.print(imageMap.draw(imageMapId));
        }
    }

    /**
     * {@inheritDoc}
     *
     * Checks if the component of the resource provides an icon for the
     * respective type.
     */
    @Override
    public String getIconPath() {
        // Note: copied from Download.java, since we cannot extend from 2 classes.
        //       whenever you change this, also update the copy in Download.java
        Component c = WCMUtils.getComponent(this);
        if (c == null) {
            return null;
        }
        Resource icon = c.getLocalResource("resources/" + getIconType() + ".gif");
        if (icon == null) {
            icon = c.getLocalResource("resources/default.gif");
        }
        return icon == null ? null : icon.getPath();
    }


    /**
     * {@inheritDoc}
     *
     * Checks if the resource is an asset and returns the correct rendition.
     */
    @Override
    protected Resource getReferencedResource(String path) {
        // Note: copied from Download.java, since we cannot extend from 2 classes.
        //       whenever you change this, also update the copy in Download.java
        Resource res = super.getReferencedResource(path);
        if (res != null) {
            // check for asset
            if (res.adaptTo(Asset.class) != null) {
                final Rendition rendition = res.adaptTo(Asset.class).getRendition(new WCMRenditionPicker());
                res = (null != rendition) ? rendition.adaptTo(Resource.class) : null;
            }
        }
        return res;
    }

}