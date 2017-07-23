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

import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.wrappers.SlingHttpServletRequestWrapper;

import com.day.cq.wcm.foundation.forms.FormsConstants;

/**
 * This request wrapper adds a redirect parameter.
 */
public class RedirectRequest extends SlingHttpServletRequestWrapper {

    private final String redirectUrl;

    public RedirectRequest(SlingHttpServletRequest wrappedRequest, final String redirectUrl) {
        super(wrappedRequest);
        this.redirectUrl = redirectUrl;
    }

    @Override
    public String getParameter(String name) {
        if ( FormsConstants.REQUEST_PROPERTY_REDIRECT.equals(name) ) {
            return this.redirectUrl;
        }
        return super.getParameter(name);
    }

    @Override
    public String[] getParameterValues(String name) {
        if ( FormsConstants.REQUEST_PROPERTY_REDIRECT.equals(name) ) {
            return new String[] {this.redirectUrl};
        }
        return super.getParameterValues(name);
    }

}
