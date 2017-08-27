/*
 * Copyright 1997-2008 Day Management AG
 * Barfuesserplatz 6, 4001 Basel, Switzerland
 * All Rights Reserved.
 *
 * This software is the confidential and proprietary information of
 * Day Management AG, ("Confidential Information"). You shall not
 * disclose such Confidential Information and shall use it only in
 * accordance with the terms of the license agreement you entered into
 * with Day.
 */
package com.day.cq.wcm.foundation.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.jcr.RepositoryException;
import javax.jcr.Session;

import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.jcr.api.SlingRepository;
import org.apache.sling.servlets.post.Modification;
import org.apache.sling.servlets.post.SlingPostProcessor;
import org.osgi.service.component.ComponentContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.day.cq.wcm.foundation.ParagraphSystem;
import com.day.text.Text;

/**
 * This processor checks if any modifications to a paragraph system containing
 * a column control were performed and fixes the structure if control nodes are
 * missing.
 */
@Component(metatype = false)
@Service(SlingPostProcessor.class)
public class ColumnCtlPostProcessor implements SlingPostProcessor {

    /**
     * The logger
     */
    private Logger log = LoggerFactory.getLogger(getClass());

    @Reference
    private SlingRepository repository;

    private Session adminSession;

    /**
     * Activate this component.
     * Open the session and register event listeners.
     *
     * @param context The component context-
     */
    protected void activate(ComponentContext context) {
        try {
            adminSession = repository.loginAdministrative(null);
        } catch (RepositoryException e) {
            log.error("unable to initialize session.");
        }
    }

    /**
     * Deactivates this component.
     *
     * @param componentContext The component context
     */
    protected void deactivate(ComponentContext componentContext) {
        if (adminSession != null) {
            adminSession.logout();
            adminSession = null;
        }
    }


    /**
     * @see SlingPostProcessor#process(SlingHttpServletRequest, List)
     */
    public void process(SlingHttpServletRequest request, List<Modification> changes)
            throws Exception {
        if (adminSession == null) {
            return;
        }
        Session session = request.getResourceResolver().adaptTo(Session.class);
        String prt = request.getParameter("parentResourceType");
        if (prt != null && prt.length() == 0) {
            prt = null;
        }
        Map<String, String> parsys = new HashMap<String, String>();
        for (Modification mod : changes) {
            switch (mod.getType()) {
                case DELETE:
                    // check for deleted paras using the admin session because
                    // the nodes are already deleted at this stage
                    try {
                        String rt = adminSession.getProperty(mod.getSource() + "/sling:resourceType").getString();
                        if (rt.endsWith("/colctrl")) {
                            parsys.put(Text.getRelativeParent(mod.getSource(), 1), "");
                        }
                    } catch (RepositoryException e) {
                        // ignore
                    }
                    break;
                case ORDER:
                case MOVE:
                case COPY:
                    break;
                case MODIFY:
                case CREATE:
                    String path = mod.getSource();
                    if (path.endsWith("/sling:resourceType")) {
                        if (session.propertyExists(path)) {
                            String rt = session.getProperty(path).getString();
                            String parSysPath = Text.getRelativeParent(path, 2);
                            if (rt.endsWith("/colctrl")) {
                                parsys.put(parSysPath, Text.getRelativeParent(rt, 1));
                            } else if (prt != null) {
                                // special check for new components that are added to
                                // a parsys that does not have a resourceType yet
                                try {
                                    if (!session.propertyExists(parSysPath + "/sling:resourceType")) {
                                        parsys.put(parSysPath, prt);
                                        prt = null;
                                    }
                                } catch (RepositoryException e) {
                                    // ignore
                                }
                            }
                        } else {
                            log.info("Could not find property {} in jcr session.", path);
                        }
                    }
            }
        }
        for (String path: parsys.keySet()) {
            log.info("columns control modified - repairing parsys at {}", path);
            // fix resource type of par if needed
            if (!session.propertyExists(path + "/sling:resourceType")) {
                String rt = parsys.get(path);
                if (rt.length() > 0) {
                    session.getNode(path).setProperty("sling:resourceType", rt);
                }
            }
            Resource res = request.getResourceResolver().getResource(path);
            ParagraphSystem p = new ParagraphSystem(res);
            p.repair();
            // changes will be saved by sling post servlet
        }
    }
}