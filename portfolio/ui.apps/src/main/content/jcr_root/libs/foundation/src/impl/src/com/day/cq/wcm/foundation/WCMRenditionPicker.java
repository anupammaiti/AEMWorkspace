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

import java.util.Iterator;

import com.day.cq.dam.api.Asset;
import com.day.cq.dam.api.Rendition;
import com.day.cq.dam.api.RenditionPicker;

/**
 * The <code>WCMRenditionPicker</code> searches first the web rendition starting
 * with <code>"cq5dam.web."</code>. If no web rendition exists the current original
 * is returned.
 */
public class WCMRenditionPicker implements RenditionPicker {
    private static final String WEB_RENDITION_PREFIX = "cq5dam.web.";

    public Rendition getRendition(Asset asset) {
        // 1. try to get a web enabled rendition
        final Iterator<Rendition> renditions = asset.listRenditions();
        while ( renditions.hasNext() ) {
            final Rendition rendition = renditions.next();
            if (rendition.getName().startsWith(WEB_RENDITION_PREFIX)) {
                return rendition;
            }
        }

        // 2. return current rendition
        return asset.getOriginal();
    }
}
