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

import java.net.URI;
import java.net.URISyntaxException;

import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Properties;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Service;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.request.RequestPathInfo;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ResourceResolver;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.day.cq.commons.PathInfo;
import com.day.cq.personalization.ProfileProvider;
import com.day.cq.security.profile.Profile;

@Component(metatype = false,
           label = "CQ5 Foundation: Form Chooser Profile Provider",
           description = "Resolves Profiles from form chooser resources.")
@Service
@Properties({
        @Property(name = "service.description", value = "CQ5 Foundation: Form Chooser Profile Provider"),
        @Property(name = "service.ranking", intValue = 5000, propertyPrivate = true)
})
@SuppressWarnings("unused")
public class FormChooserProfileProvider implements ProfileProvider {

    private static final Logger log = LoggerFactory.getLogger(FormChooserProfileProvider.class);

    public Profile getProfile(final SlingHttpServletRequest request) {

        final ResourceResolver resourceResolver = request.getResourceResolver();
        Resource resource = request.getResource();

        //test if resource is a chooser resource...so set resource to edit-resource
        try {
            RequestPathInfo info = new PathInfo(
                    new URI(request.getRequestURI()).getPath());
            if (!info.getResourcePath().equals(resource.getPath())) {
                log.debug("Found FormChooser request for {} to {}",
                          resource.getPath(),
                          info.getResourcePath());
                resource = resourceResolver.getResource(info.getResourcePath());
            }
            if (resource != null) {
                return resource.adaptTo(Profile.class);
            }

        } catch (URISyntaxException e) {
            log.warn("Found request with invalid syntax fall back to request\'s resource {}",
                     resource.getPath());
        }

        return null;
    }

    public Profile getProfile(final ResourceResolver resolver) {
        return null;
    }
}
