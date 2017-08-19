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
package com.day.cq.wcm.foundation;

import com.day.cq.wcm.api.AuthoringUIMode;
import com.day.cq.wcm.api.WCMMode;
import com.day.cq.wcm.api.components.Component;
import org.apache.commons.lang3.StringUtils;

import javax.servlet.ServletRequest;

/**
 * Class to handle placeholders
 */
public class Placeholder {

    public static final String DEFAULT_PLACEHOLDER_TOUCH = "cq-placeholder";
    public static final String ATTRIBUTE_EMTPYTEXT = "data-emptytext";


    /**
     * Check if UI is in authoring mode TOUCH
     *
     * @param slingRequest
     * @return
     */
    public static boolean isAuthoringUIModeTouch(ServletRequest slingRequest) {
        return AuthoringUIMode.TOUCH.equals(AuthoringUIMode.fromRequest(slingRequest));
    }

    /**
     * Get default placeholder for any component incl. title as text information
     *
     * @param slingRequest
     * @param title              text information for placeholder
     * @param defaultPlaceholder default placeholder
     * @param addClasses add additional classes to the placeholder div
     * @return default placeholder for component
     */
    public static String getDefaultPlaceholder(ServletRequest slingRequest, String title, String defaultPlaceholder,
                                               String... addClasses) {
        String placeholder = defaultPlaceholder;
        if (isAuthoringUIModeTouch(slingRequest)) {
            if (title == null) {
                title = "";
            }
            String cls = DEFAULT_PLACEHOLDER_TOUCH;
            for (String cl : addClasses) {
                if (cl == null) continue;
                cls += " " + cl;
            }
            placeholder = "<div " +
                    "class=\"" + cls + "\" " +
                    ATTRIBUTE_EMTPYTEXT + "=\"" + title + "\">" +
                    "</div>";
        }
        return placeholder;
    }

    /**
     * Get default placeholder for any component incl. title as text information
     *
     * @param slingRequest
     * @param component          component to read title from
     * @param defaultPlaceholder default placeholder
     * @return default placeholder for component
     */
    public static String getDefaultPlaceholder(ServletRequest slingRequest, Component component,
                                               String defaultPlaceholder, String... addClasses) {
        return getDefaultPlaceholder(slingRequest, getComponentTitle(component), defaultPlaceholder, addClasses);
    }

    /**
     * Get default placeholder for any component incl. title as text information
     *
     * @param slingRequest
     * @param component          component to read title from
     * @param defaultPlaceholder default placeholder
     * @return default placeholder for component
     */
    public static String getDefaultPlaceholder(ServletRequest slingRequest, Component component,
                                               String defaultPlaceholder) {
        return getDefaultPlaceholder(slingRequest, getComponentTitle(component), defaultPlaceholder);
    }

    /**
     * Get title of component
     *
     * @param component Component
     * @return
     */
    public static String getComponentTitle(Component component) {
        String title = null;
        if (component != null) {
            title = component.getProperties().get("./jcr:title").toString();
            if (StringUtils.isEmpty(title)) {
                title = component.getPath();
            }
        }
        return title;
    }

}
