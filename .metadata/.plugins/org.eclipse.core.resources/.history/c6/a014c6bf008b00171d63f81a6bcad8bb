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
package com.day.cq.wcm.foundation.forms.impl;

import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.wrappers.SlingHttpServletRequestWrapper;

public class FormsHandlingRequest extends SlingHttpServletRequestWrapper {

    public FormsHandlingRequest(SlingHttpServletRequest wrappedRequest) {
        super(wrappedRequest);
    }

    /**
     * Validation includes always assume GET
     */
    @Override
    public String getMethod() {
        return "GET";
    }
}
