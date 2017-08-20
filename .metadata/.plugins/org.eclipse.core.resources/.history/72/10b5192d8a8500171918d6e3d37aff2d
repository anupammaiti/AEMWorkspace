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

import com.day.cq.commons.DownloadResource;
import com.day.cq.dam.api.Asset;
import com.day.cq.dam.api.DamConstants;
import com.day.cq.dam.api.Rendition;
import com.day.cq.wcm.api.components.Component;
import com.day.cq.wcm.commons.WCMUtils;
import org.apache.sling.api.resource.Resource;

/**
 * Provides convenience methods for rendering download paragraphs.
 */
public class Download extends DownloadResource {

    /**
     * Creates a new download based on the given resource. the file properties
     * are considered to be 'on' the given resource.
     *
     * @param resource resource of the image
     * @throws IllegalArgumentException if the given resource is not adaptable to node.
     */
    public Download(Resource resource) {
        super(resource);
    }

    /**
     * {@inheritDoc}
     *
     * Checks if the component of the resource provides an icon for the
     * respective type.
     * 
     * @deprecated since 5.4 please use css classes for the icon, like "icon_xls.gif"
     */
    @Override
    @Deprecated
    public String getIconPath() {
        // Note: copied in Image.java, since we cannot extend from 2 classes.
        //       whenever you change this, also update the copy in Image.java
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
        // Note: copied in Image.java, since we cannot extend from 2 classes.
        //       whenever you change this, also update the copy in Image.java
        Resource res = super.getReferencedResource(path);
        if (res != null) {
            // check for asset
            if (res.adaptTo(Asset.class) != null) {
                final Rendition rendition = res.adaptTo(Asset.class).getRendition(DamConstants.ORIGINAL_FILE);
                res = (null != rendition) ? rendition.adaptTo(Resource.class) : null;
            }
        }
        return res;
    }
}