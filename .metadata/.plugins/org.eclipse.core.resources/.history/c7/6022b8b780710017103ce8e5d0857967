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
package com.day.cq.wcm.foundation.forms.impl;

import java.util.List;

import javax.jcr.Session;

import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.jcr.api.SlingRepository;
import org.apache.sling.servlets.post.Modification;
import org.apache.sling.servlets.post.SlingPostProcessor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.day.cq.wcm.foundation.forms.FormsConstants;
import com.day.cq.workflow.WorkflowException;
import com.day.cq.workflow.WorkflowService;
import com.day.cq.workflow.WorkflowSession;
import com.day.cq.workflow.exec.WorkflowData;
import com.day.cq.workflow.model.WorkflowModel;

/** SlingPostProcessor that starts a workflow on content that was just
 *  created, if a specific request attribute points to a workflow model.
 *  Used to start workflows on forms, right after storing their content.    
 */
@Component
@Service
public class StartWorkflowPostProcessor implements SlingPostProcessor {
    
    private final Logger log = LoggerFactory.getLogger(getClass());
    
    @Reference
    private WorkflowService workflowService;
    
    @Reference
    private SlingRepository repository;
    
    public void process(SlingHttpServletRequest request, List<Modification> mods) throws Exception {
        final String workflowModelPath = getStringAttr(request,FormsConstants.REQUEST_ATTR_WORKFLOW_PATH);
        final String payloadPath = getStringAttr(request,FormsConstants.REQUEST_ATTR_WORKFLOW_PAYLOAD_PATH);

        if(workflowModelPath == null) {
            log.debug("No workflow model path supplied, not starting workflow");
        } else {
            // Start workflow on supplied content
            // Using admin session as user might not have rights to do that
            log.info("Starting workflow {} on path {}", workflowModelPath, payloadPath);
            final Session s = repository.loginAdministrative(null);
            try {
                final WorkflowSession wfs = workflowService.getWorkflowSession(s);
                final WorkflowModel model = wfs.getModel(workflowModelPath);
                if(model == null) {
                    throw new WorkflowException("Workflow Model with ID '" + workflowModelPath + "' not found");
                }
                
                final WorkflowData data = wfs.newWorkflowData("JCR_PATH", payloadPath);
                wfs.startWorkflow(model, data);
            } finally {
                s.logout();
            }
        }
    }
    
    private String getStringAttr(SlingHttpServletRequest request, String name) {
        final Object obj = request.getAttribute(name);
        if(obj != null && obj instanceof String) {
            return (String)obj;
        }
        return null;
    }
}