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
package com.day.cq.wcm.foundation.impl.diff;

import com.day.cq.wcm.foundation.DiffService;
import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;

/**
 * The default implementation of the diff service.
 *
 * The basic diff algorithm is string based:
 * - html elements are "removed" from the input string
 * - the string is parsed into words
 * - the resulting two arrays of words are compared by a diff
 * - words are marked by the diff
 * - a compact algorithm tries to link marked areas.
 *
 * @deprecated since 5.4; replaced by {@link com.day.cq.commons.impl.DefaultDiffService}
 */
@Component(metatype = false)
@Service(DiffService.class)
public class DefaultDiffService implements DiffService {

    @Reference
    private com.day.cq.commons.DiffService baseSvc;

    /**
     * {@inheritDoc}
     */
    public String diff(final String origText, final String diffText, final boolean isRichText) {
        return baseSvc.diff(origText, diffText, isRichText);
    }
}
