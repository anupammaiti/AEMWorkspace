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

package libs.foundation.components.form.captcha;

import java.io.IOException;

import javax.jcr.RepositoryException;

import com.day.text.Text;
import com.day.cq.wcm.commons.AbstractImageServlet;
import com.day.image.Layer;
import com.day.image.Font;

import java.awt.Color;

import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;

/**
 * Renders an image
 */
public class captcha_png extends AbstractImageServlet {

    protected Layer createLayer(ImageContext c)
            throws RepositoryException, IOException {
        // don't create the later yet. handle everything later
        return null;
    }

    protected void writeLayer(SlingHttpServletRequest req,
                              SlingHttpServletResponse resp,
                              ImageContext c, Layer layer)
            throws IOException, RepositoryException {

        String captchakey = req.getParameter("id");
        String hours = "" + (System.currentTimeMillis() / (60 * 1000));
        
        String captcha = (Text.md5("" + (captchakey + hours))).substring(1, 6);
        layer = new Layer(512, 256, new Color(0,0,0,0));
        Font titleFont = new Font("Georgia", 16 * 8, 0);
        layer.setPaint(new Color(0xff000000, true));
        layer.drawText(10, 25 * 8, 0, 0, captcha, titleFont, Font.ALIGN_BASE, 0, 0);
        layer.resize(48, 24);

        layer.write("image/png", 1.0, resp.getOutputStream());

         resp.flushBuffer();
    }
}