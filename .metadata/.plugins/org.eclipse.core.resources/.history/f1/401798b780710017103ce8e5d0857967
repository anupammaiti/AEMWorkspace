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

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.jcr.RepositoryException;
import javax.jcr.Session;
import javax.jcr.observation.Event;
import javax.jcr.observation.EventIterator;
import javax.jcr.observation.EventListener;

import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ResourceResolver;
import org.apache.sling.api.resource.ResourceUtil;
import org.apache.sling.api.resource.ValueMap;
import org.apache.sling.jcr.api.SlingRepository;
import org.apache.sling.jcr.resource.JcrResourceResolverFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.day.cq.commons.jcr.JcrConstants;
import com.day.cq.wcm.foundation.forms.FormsConstants;
import com.day.cq.wcm.foundation.forms.FormsManager;
import com.day.cq.widget.HtmlLibraryManager;

/**
 * Default implementation of the forms manager.
 */
@Component(metatype = false)
@Service(FormsManager.class)
public class FormsManagerImpl implements FormsManager {

    /** Logger */
    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    /** Registered listeners */
    private final List<EventListenerWrapper> listeners = new ArrayList<EventListenerWrapper>();

    /** Search paths for constraints and actions.*/
    private String[] searchPaths;

    @Reference
    private SlingRepository repository;

    @Reference
    private HtmlLibraryManager htmlLibraryManager;

    @Reference
    private JcrResourceResolverFactory resolverFactory;

    private Collection<ComponentDescription> actions;

    private Collection<ComponentDescription> constraints;

    private Session session;

    /** Html Library manager for the forms utils. */
    public static volatile HtmlLibraryManager HTML_LIBRARY_MANAGER;

    /**
     * @see com.day.cq.wcm.foundation.forms.FormsManager#getActions()
     */
    public Iterator<ComponentDescription> getActions() {
        synchronized ( this ) {
            if ( this.actions == null ) {
                this.searchFormElements();
            }
            return this.actions.iterator();
        }
    }

    /**
     * @see com.day.cq.wcm.foundation.forms.FormsManager#getConstraints()
     */
    public Iterator<ComponentDescription> getConstraints() {
        synchronized ( this ) {
            if ( this.constraints == null ) {
                this.searchFormElements();
            }
            return this.constraints.iterator();
        }
    }

    /**
     * @see com.day.cq.wcm.foundation.forms.FormsManager#getDialogPathForAction(java.lang.String)
     */
    public String getDialogPathForAction(String resourceType) {
        if ( resourceType == null ) {
            return null;
        }
        final ResourceResolver resourceResolver = this.resolverFactory.getResourceResolver(session);
        for(final String path : this.searchPaths ) {
            final String dialogPath = path + '/' + resourceType + "/dialog";
            if ( resourceResolver.getResource(dialogPath) != null ) {
                return dialogPath;
            }
        }
        return null;
    }

    protected void activate(org.osgi.service.component.ComponentContext componentContext) throws RepositoryException {
        session = repository.loginAdministrative(null);
        
        // Get search paths and remove trailing slashes 
        final ResourceResolver resourceResolver = this.resolverFactory.getResourceResolver(session);
        this.searchPaths = resourceResolver.getSearchPath();
        for(int i=0;i<searchPaths.length;i++) {
            this.searchPaths[i] = this.searchPaths[i].substring(0, this.searchPaths[i].length() - 1);
        }
        
        // set up observation listener
        for(final String path : this.searchPaths) {
            EventListenerWrapper wrapper = new EventListenerWrapper(this);
            session.getWorkspace().getObservationManager()
                       .addEventListener(wrapper,
                               Event.NODE_ADDED|Event.NODE_REMOVED|Event.PROPERTY_CHANGED|Event.PROPERTY_ADDED|Event.PROPERTY_REMOVED,
                               path,
                               true /* isDeep */,
                               null /* uuid */,
                               null /* nodeTypeName */,
                               true /* noLocal */
                               );
            this.listeners.add(wrapper);
        }
        
    }
    
    /**
     * Dectivate the forms manager.
     * @param context
     */
    protected void deactivate(org.osgi.service.component.ComponentContext componentContext) {
        if (session != null) {
            for(final EventListener listener : this.listeners) {
                try {
                    session.getWorkspace().getObservationManager().removeEventListener(listener);
                } catch (RepositoryException e) {
                    // ignore
                }
            }
            listeners.clear();
            session.logout();
            session = null;
        }
        actions = null;
    }

    void clearActions() {
        synchronized ( this ) {
            this.actions = null;
        }
    }

    void clearConstraints() {
        synchronized ( this ) {
            this.constraints = null;
        }
    }

    protected void bindHtmlLibraryManager(final HtmlLibraryManager manager) {
        this.htmlLibraryManager = manager;
        HTML_LIBRARY_MANAGER = manager;
    }

    protected void unbindHtmlLibraryManager(final HtmlLibraryManager manager) {
        if ( this.htmlLibraryManager == manager ) {
            this.htmlLibraryManager = null;
            HTML_LIBRARY_MANAGER = null;
        }
    }

    private Collection<ComponentDescription> search(String type) {
        final Map<String, ComponentDescription> map = new HashMap<String, ComponentDescription>();
        final ResourceResolver resourceResolver = this.resolverFactory.getResourceResolver(session);
        final List<String> disabledComponents = new ArrayList<String>();
        for(final String path : this.searchPaths) {
            final StringBuilder buffer = new StringBuilder("/jcr:root");
            buffer.append(path);
            buffer.append("//* [@");
            buffer.append(FormsConstants.PROPERTY_RT);
            buffer.append("='");
            buffer.append(type);
            buffer.append("']");

            logger.debug("Query: {}", buffer.toString());
            final Iterator<Resource> i = resourceResolver.findResources(buffer.toString(), "xpath");
            while ( i.hasNext() ) {
                final Resource rsrc = i.next();
                // check if disabled
                final ValueMap properties = ResourceUtil.getValueMap(rsrc);
                // get resource type
                final String rt = rsrc.getPath().substring(path.length() + 1);
                if ( properties.get(FormsConstants.COMPONENT_PROPERTY_ENABLED, Boolean.TRUE) ) {
                    if ( ! map.containsKey(rt) && !disabledComponents.contains(rt)) {
                        map.put(rt, new ComponentDescriptionImpl(rt, ResourceUtil.getName(rsrc), properties));
                    }
                } else {
                    disabledComponents.add(rt);
                }
            }
        }
        // now sort the entries
        final List<ComponentDescription> entries = new ArrayList<ComponentDescription>(map.values());
        Collections.sort(entries);
        return entries;
    }

    /**
     * Search the repo for action resources and constraints
     */
    private void searchFormElements() {
        if ( this.actions == null ) {
            this.actions = this.search(FormsConstants.RT_FORM_ACTION);
        }
        if ( this.constraints == null ) {
            this.constraints = this.search(FormsConstants.RT_FORM_CONSTRAINT);
        }
    }

    public final static class EventListenerWrapper implements EventListener {

        private final FormsManagerImpl delegatee;

        public EventListenerWrapper(final FormsManagerImpl listener) {
            this.delegatee = listener;
        }

        /**
         * @see javax.jcr.observation.EventListener#onEvent(javax.jcr.observation.EventIterator)
         */
        public void onEvent(EventIterator i) {
            delegatee.clearActions();
            delegatee.clearConstraints();
        }
    }

    public final static class ComponentDescriptionImpl implements ComponentDescription, Comparable<ComponentDescription> {

        private final String resourceType;
        private final String title;
        private final String hint;
        private final int    order;

        public ComponentDescriptionImpl(final String rt, final String defaultName, final ValueMap props) {
            this.resourceType = rt;
            this.title = props.get(JcrConstants.JCR_TITLE, defaultName);
            this.order = props.get(FormsConstants.COMPONENT_PROPERTY_ORDER, 0);
            this.hint = props.get(FormsConstants.COMPONENT_PROPERTY_HINT, String.class);
        }

        /**
         * @see com.day.cq.wcm.foundation.forms.FormsManager.ComponentDescription#getResourceType()
         */
        public String getResourceType() {
            return this.resourceType;
        }

        /**
         * @see com.day.cq.wcm.foundation.forms.FormsManager.ComponentDescription#getTitle()
         */
        public String getTitle() {
            return this.title;
        }

        public int getOrder() {
            return this.order;
        }

        /**
         * @see com.day.cq.wcm.foundation.forms.FormsManager.ComponentDescription#getHint()
         */
        public String getHint() {
            return this.hint;
        }

        /**
         * @see java.lang.Comparable#compareTo(java.lang.Object)
         */
        public int compareTo(ComponentDescription o) {
            final ComponentDescriptionImpl obj = (ComponentDescriptionImpl)o;
            if ( this.order < obj.order ) {
                return -1;
            } else if ( this.order == obj.order ) {
                return this.title.compareTo(obj.title);
            }
            return 1;
        }
    }
}