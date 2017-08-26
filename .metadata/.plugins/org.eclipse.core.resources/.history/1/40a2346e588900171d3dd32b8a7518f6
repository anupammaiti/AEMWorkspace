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
package com.day.cq.wcm.foundation;

/**
 * Simple service that provides the last modified date of a hierarchy in respect
 * to configured pattern.
 * The exact nature of how the last modification times are calculated is dependent
 * of the configuration.
 */
public interface HierarchyModificationListener {

    /**
     * Returns the last modification date of the hierarchy of the given path.
     *
     * @param path the path
     * @return the last modification date.
     */
    long getLastModified(String path);
}