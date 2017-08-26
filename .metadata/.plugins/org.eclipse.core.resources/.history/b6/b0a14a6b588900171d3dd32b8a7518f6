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
package com.day.cq.wcm.foundation.forms;

import java.util.List;

import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.SyntheticResource;
import org.apache.sling.api.resource.ValueMap;

/**
 * {@linkplain MergedMultiResource} is a synthetic resource that presents a
 * merged view on multiple resources. This is done by providing a
 * {@link ValueMap} in {@link #adaptTo(Class)} that merges the values of all
 * resources, ie. provide a null value for a key if the value is not the same in
 * all resurces and only present a value if that one is present in exactly all
 * of the resources.
 */
public class MergedMultiResource extends SyntheticResource {

    private List<Resource> resources;

    public MergedMultiResource(List<Resource> resources) {
        super(resources.get(0).getResourceResolver(), resources.get(0).getPath() + "#multiresource", "cq/multiresource");
        
        this.resources = resources;
    }

    @SuppressWarnings("unchecked")
    public <AdapterType> AdapterType adaptTo(Class<AdapterType> type) {
        if (type == ValueMap.class) {
            return (AdapterType) new MergedValueMap(resources);
        }
        return null;
    }

}
