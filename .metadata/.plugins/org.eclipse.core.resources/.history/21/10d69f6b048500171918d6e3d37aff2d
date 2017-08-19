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

import java.util.Iterator;

/**
 * The forms manager keeps track of all available actions
 * and constraints.
 */
public interface FormsManager {

    /**
     * Return the paths for all action resources.
     * @return An iterator for paths.
     */
    Iterator<ComponentDescription> getActions();

    /**
     * Return the paths for all constraint resources.
     * @return An iterator for paths.
     */
    Iterator<ComponentDescription> getConstraints();

    /**
     * Return the dialog path (resource path) for the
     * form action.
     * @param resourceType The resource type of the form action
     * @return The full path or <code>null</code>.
     */
    String getDialogPathForAction(String resourceType);

    public static interface ComponentDescription extends Comparable<ComponentDescription> {

        /**
         * Return the resource type for this component.
         */
        String getResourceType();

        /**
         * Return the title.
         */
        String getTitle();

        /**
         * Return a hint (text) for this component.
         * @return A hint or <code>null</code>.
         * @since 5.3
         */
        String getHint();
    }
}
