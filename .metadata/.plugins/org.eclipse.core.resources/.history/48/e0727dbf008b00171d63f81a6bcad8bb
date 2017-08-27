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
package com.day.cq.wcm.foundation.forms.impl;

import org.apache.sling.api.resource.Resource;

/**
 * ResourceWrapper for overriding the resource type and the
 * resource super type of a resource.
 */
public class ResourceWrapper extends org.apache.sling.api.resource.ResourceWrapper {

    private final String resourceType;

    private final String resourceSuperType;

    public ResourceWrapper(final Resource r, final String rt, final String rst) {
        super(r);
        this.resourceType = rt;
        this.resourceSuperType = rst;
    }

    public String getResourceSuperType() {
        return this.resourceSuperType;
    }

    public String getResourceType() {
        return this.resourceType;
    }
}
