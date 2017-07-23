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
package com.day.cq.wcm.foundation.profile.impl;

import com.day.cq.wcm.api.designer.Design;
import com.day.cq.wcm.api.designer.Designer;
import com.day.cq.wcm.api.designer.Style;
import com.day.cq.wcm.commons.AbstractImageServlet;
import com.day.cq.wcm.foundation.Image;
import com.day.image.Layer;
import com.day.text.Text;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Properties;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Service;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;

import javax.jcr.RepositoryException;
import javax.servlet.Servlet;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Little Tool for image Rendering for Images from the Profile including
 * Thumbnail generation.
 * To bypass default Rendering, request the Resource with <code>prof</code>
 * selector.
 * Thumbnails are requested via selector <code>{@value #THUMBNAIL}</code>
 * at second selector index.<br>
 * An additional selector can be used for the image size (since 5.4): image.prof.thumbnail.100.png<br>
 * Default size of the thumbnail is 48x48 pixels.
 * In case of normal Image, the style to use can be requested via the
 * request suffix. The suffix is expected to have a format of a path to
 * a {@link com.day.cq.wcm.api.designer.Design Design} and an optional cell-path
 * Both seperated with following sign :
 * <i><b>/-</b></i><br>
 * Example:
 * /etc/designs/geometrixx/-/par/avatar<br>
 */
@Component(metatype = false)
@Service(Servlet.class)
@Properties({
        @Property(name = "sling.servlet.resourceTypes", value = "nt:file"),
        @Property(name = "sling.servlet.extensions", value = {"jpg", "png", "gif"}),
        @Property(name = "sling.servlet.selectors", value = {"prof", "prof.thumbnail"})
})
public class ProfileImages extends AbstractImageServlet {

    private static final int ICON_WIDTH = 48;
    private static final int ICON_HEIGHT = 48;
    private static final String THUMBNAIL = "thumbnail";

    @Override
    protected Layer createLayer(ImageContext c) throws RepositoryException, IOException {
        Image image = new Image(c.resource.getResourceResolver().getResource(c.resource, ".."));
        image.setItemName(Image.NN_FILE, Text.getName(c.resource.getPath()));
        if (!image.hasContent()) {
            return null;
        }
        String[] selectors = c.request.getRequestPathInfo().getSelectors();

        int width = 0;
        try {
            width = Integer.parseInt(selectors[2]);
        } catch (Exception e) {
        }
        if (width == 0) {
            // no selectors for width and height defined >> defaults
            width = ICON_WIDTH;
        }
        int height = width;

        if (selectors.length > 1 && THUMBNAIL.equals(selectors[1])) {
            Layer org = image.getLayer(false, false, false);
            int w = org.getWidth();
            int h = org.getHeight();
            if (h < height && w < width) {
                org.setX((int) Math.floor((width - w) / 2));
                org.setY((int) Math.floor((height - h) / 2));
            } else {
                float ratio;
                if (h == w && width == height) {
                    org.resize(width, height);
                } else if (h > w) {
                    ratio = h / (float) height;
                    w = (int) Math.floor(w / ratio);
                    org.resize(w, height);
                    org.setX((int) Math.floor((width - w) / 2));
                } else {
                    ratio = w / (float) width;
                    h = (int) Math.floor(h / ratio);
                    org.resize(width, h);
                    org.setY((int) Math.floor((height - h) / 2));
                }
            }
            Layer outLayer = new Layer(width, height, org.getBackgroundColor());
            outLayer.setTransparency(org.getBackgroundColor());
            outLayer.merge(org);
            return outLayer;
        } else {
            Style style = getStyle(c);
            if (style != null) {
                image.loadStyleData(style);
            }
            return image.getLayer(false, true, false);
        }
    }

    @Override
    protected void writeLayer(SlingHttpServletRequest request, SlingHttpServletResponse response, ImageContext context, Layer layer) throws IOException, RepositoryException {
        if (layer == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        } else {
            super.writeLayer(request, response, context, layer);
        }
    }

    private Style getStyle(ImageContext c) {
        String designId = "";
        String cellPath = "";
        String suffix = c.request.getRequestPathInfo().getSuffix();
        if (suffix != null && suffix.length() > 0) {
            if (!suffix.startsWith("/")) {
                suffix = "/" + suffix;
            }
            int idx = suffix.indexOf("/-/");
            if (idx >= 0) {
                designId = suffix.substring(0, idx);
                cellPath = suffix.substring(idx + 3);
            } else {
                designId = suffix;
            }
        }

        // get design
        Design design = null;
        if (designId.length() > 0) {
            Designer d = c.resolver.adaptTo(Designer.class);
            design = d.getDesign(designId);
        }
        if (design == null) {
            return null;
        }
        if (cellPath.length() > 0) {
            return design.getStyle(cellPath);
        } else {
            return design.getStyle(Text.getName(c.resource.getPath()));
        }
    }

    @Override
    protected String getImageType(String ext) {
        if ("res".equals(ext)) {
            // return a dummy image type (return null would result in a 404 in the super class)
            return "res";
        }
        return super.getImageType(ext);
    }
}
