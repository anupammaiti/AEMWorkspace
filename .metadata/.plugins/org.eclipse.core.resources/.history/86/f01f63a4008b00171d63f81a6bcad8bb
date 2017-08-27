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

package libs.foundation.components.title;

import java.awt.Color;
import java.awt.geom.Rectangle2D;
import java.io.IOException;

import javax.jcr.RepositoryException;

import com.day.cq.commons.jcr.JcrConstants;
import com.day.cq.wcm.api.designer.Style;
import com.day.cq.wcm.commons.AbstractImageServlet;
import com.day.cq.wcm.foundation.ImageHelper;
import com.day.image.Font;
import com.day.image.Layer;
import org.apache.sling.api.resource.Resource;

/**
 * Title image servlet
 */
public class title_png extends AbstractImageServlet {

    protected Layer createLayer(ImageContext c)
            throws RepositoryException, IOException {

        // read the style information (we don't use css names).
        Style style = c.style.getSubStyle("titleimage");
        String fontFace = style.get("fontFamily", "Myriad Pro");
        long fontSize = style.get("fontSize", 10L);
        int fontStyle = ImageHelper.parseFontStyle(style.get("fontStyle", "bold"));

        Color bgColor = ImageHelper.parseColor(style.get("bgColor", "#ffffff"), 0);
        Color fgColor = ImageHelper.parseColor(style.get("fgColor", "#000000"), 255);
        long paddingX = style.get("paddingX", 16L);
        long paddingY = style.get("paddingY", -1L);
        long height = style.get("bgHeight", 16L);
        long width = style.get("bgWidth", 50L);

        // constants
        int scale = 6;
        String title = c.properties.get(JcrConstants.JCR_TITLE, String.class);
        if (title == null || title.equals("")) {
            title = c.currentPage.getPageTitle();
        }
        if (title == null || title.equals("")) {
            title = c.currentPage.getTitle();
        }
        if (title == null || title.equals("")) {
            title = c.currentPage.getName();
        }

        // load background image from docroot
        Layer bg = ImageHelper.createLayer(style.get("bgImage", Resource.class));
        if (bg == null) {
            bg = new Layer((int) width, (int) height, bgColor);
        }

        if (title.length() > 0) {
            Font titleFont = new Font(fontFace, ((int) fontSize) * scale, fontStyle);
            int titleBase = bg.getHeight() * scale;

            // draw the title text (4 times bigger)
            Rectangle2D r = titleFont.getTextExtent(0, titleBase, 0, 0, title, 0, 0, 0);
            Layer text = new Layer((int) r.getWidth(), 2 * scale + (int) r.getHeight(), new Color(0x01ffffff, true));
            text.setPaint(fgColor);
            text.drawText(0, titleBase, 0, 0, title, titleFont, Font.ALIGN_LEFT | Font.ALIGN_BASE, 0, 0);
            text.resize(text.getWidth() / scale, text.getHeight() / scale);

            // and merge the layers
            text.setY((int) paddingY);
            text.setX((int) paddingX);
            text.setBackgroundColor(bgColor);
            bg.merge(text);
        }
        return bg;
    }
}