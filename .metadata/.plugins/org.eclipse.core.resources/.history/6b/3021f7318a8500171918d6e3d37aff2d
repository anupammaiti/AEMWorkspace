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
package com.day.cq.wcm.foundation;

import org.apache.sling.api.resource.Resource;

/**
 * The <code>DiffInfo</code> can be used by components
 * to display a diff to a previous version.
 * A component has access to the diff information by
 * calling {@link Resource#adaptTo(Class)} with this
 * class as the argument.
 *
 * @since 5.2
 * @deprecated since 5.4; use {@link com.day.cq.commons.DiffInfo} instead.
 */
public class DiffInfo extends com.day.cq.commons.DiffInfo {

    public DiffInfo(final Resource c, final TYPE l) {
        super(c, l);
    }

    /**
     * Helper method to generate the diff output.
     * @param service The diff service.
     * @param diffInfo The diff info.
     * @param origText The original text.
     * @param isRichText Is this rich text?
     * @param diffText The diff text.
     * @return The complete output or null.
     */
    public static String getDiffOutput(final DiffService service,
                                       final DiffInfo diffInfo,
                                       final String origText,
                                       final boolean isRichText,
                                       final String diffText) {
        if ( service != null ) {
            if ( diffInfo.getType() == DiffInfo.TYPE.ADDED ) {
                return service.diff(origText, null, isRichText);
            } else if ( diffInfo.getType() == DiffInfo.TYPE.REMOVED ) {
                return service.diff(null, origText, isRichText);
            }
            return service.diff(origText, diffText, isRichText);
        }
        return null;
    }
}
