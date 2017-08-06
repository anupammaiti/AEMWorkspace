/*************************************************************************
 *
 * ADOBE CONFIDENTIAL
 * __________________
 *
 *  Copyright 2013 Adobe Systems Incorporated
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of Adobe Systems Incorporated and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to Adobe Systems Incorporated and its
 * suppliers and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Adobe Systems Incorporated.
 **************************************************************************/
package libs.foundation.components.primary.nt.file;

import com.day.cq.commons.ImageHelper;
import com.day.cq.wcm.commons.AbstractImageServlet;
import com.day.image.Layer;
import org.apache.sling.api.resource.Resource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.jcr.RepositoryException;
import java.io.IOException;

/**
 * The img_GET supports retrieving image content and forcing
 * a content type on the response that will be set to the image/*.
 */
public class img_GET extends AbstractImageServlet {

    protected final Logger logger = LoggerFactory.getLogger(img_GET.class);

    @Override
    protected Layer createLayer(ImageContext c) throws RepositoryException, IOException
    {
        logger.debug("Processing a request to retrieve safe image content for resource" + c.resource.getPath());

        Resource image = c.resource.getResourceResolver().getResource(c.resource.getPath());
        return ImageHelper.createLayer(image);
    }
}