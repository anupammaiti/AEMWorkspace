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
package com.day.cq.wcm.foundation.forms.impl;

import com.day.cq.wcm.foundation.forms.FormsConstants;

/**
 * Helper class for field handling.
 * @since 5.3
 */
public class FormsUtil {

    private FormsUtil() {
        // no instances
    }

    /**
     * Filter the element name for unallowed characters.
     * @param nodeName The name of the element
     * @return Filtered named
     */
    public static String filterElementName(String nodeName) {
        final StringBuilder sb  = new StringBuilder();
        char lastAdded = 0;

        for(int i=0; i < nodeName.length(); i++) {
            final char c = nodeName.charAt(i);
            char toAdd = c;

            if (FormsConstants.ALLOWED_NAME_CHARS.indexOf(c) < 0) {
                if (lastAdded == FormsConstants.REPLACEMENT_CHAR) {
                    // do not add several _ in a row
                    continue;
                }
                toAdd = FormsConstants.REPLACEMENT_CHAR;

            } else if(i == 0 && Character.isDigit(c)) {
                sb.append(FormsConstants.REPLACEMENT_CHAR);
            }

            sb.append(toAdd);
            lastAdded = toAdd;
        }

        if (sb.length()==0) {
            sb.append(FormsConstants.REPLACEMENT_CHAR);
        }

        return sb.toString();
    }
}