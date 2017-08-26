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
package com.day.cq.wcm.foundation.profile;

import javax.jcr.RepositoryException;
import javax.jcr.Session;

import org.apache.sling.api.SlingHttpServletRequest;

import com.day.cq.security.profile.Profile;

/**
 * @deprecated Use {@link com.day.cq.personalization.ProfileUtil} instead.
 */
public class ProfileUtil {

    /**
     * Gets the profile for the given request. The resolution order is: <ul> <li>Profile resolution is cached, that is
     * if this method is called again for a given <code>request</code> the previous result is returned.</li> <li>If any
     * of the below processes resolves the userId to ~ (tilde) then the userId of the current user is assumed.</li>
     * <li>If the resource addressed by the original request is a profile, adapt the resource to a Profile.</li> <li>If
     * there is a 'profile' property set on the current resource use the value of that property as the userId to get the
     * profile.</li> <li>If there is a request parameter named 'authorizable' use the value as the userId to get the
     * profile.</li> <li>If there is a request suffix use the suffix without the initial slash as the userId to get the
     * profile.</li> <li>Use the userId to get get the profile and if that fails get the profile of the current
     * user.</li> </ul>
     *
     * @param request a request.
     *
     * @return the profile for the given request.
     * @deprecated Use <code>request.adaptTo(Profile.class)</code> instead.
     */
    public static Profile fromRequest(SlingHttpServletRequest request) {
        return request.adaptTo(Profile.class);
    }

    /**
     * Tries to get the profile for the given <code>userId</code> using the provided <code>session</code>.
     *
     * @param userId  a userId.
     * @param session the current session.
     *
     * @return the userId or <code>null</code> if the userId is unknown or an error occurs.
     * @throws RepositoryException if an error occurs
     *
     * @throws UnsupportedOperationException always.
     */
    @Deprecated
    public static Profile getProfile(String userId, Session session) throws RepositoryException {
        throw new UnsupportedOperationException("getProfile() no longer supported. Retrieve via ProfileManager instead.");
    }

    @Deprecated
    public static boolean isAnonymous(Profile profile) {
        return com.day.cq.personalization.ProfileUtil.isAnonymous(profile);
    }

    @Deprecated
    public static boolean isAnonymous(SlingHttpServletRequest request) {
        return com.day.cq.personalization.ProfileUtil.isAnonymous(request);
    }
}
