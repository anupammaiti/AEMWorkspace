package org.myorg.portfolio.workflowDemo;


import javax.jcr.Session;

import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.sling.api.resource.ResourceResolver;
import org.apache.sling.api.resource.ResourceResolverFactory;

import com.day.cq.workflow.WorkflowService ;
import com.day.cq.workflow.WorkflowSession;
import com.day.cq.workflow.exec.WorkflowData;
//Adobe CQ Workflow APIs
import com.day.cq.workflow.model.WorkflowModel ; 
 
  
//This is a component so it can provide or consume services
@Component
    
@Service
public class InvokeAEMWorkflowImp implements InvokeAEMWorkflow {
      
    @Reference
    private WorkflowService workflowService;
  
    private Session session;
      
    @Reference
    private ResourceResolverFactory resolverFactory;
           
    
      
@Override
public String StartWorkflow(String workflowName, String workflowContent) {
                  
try
{
    //Invoke the adaptTo method to create a Session 
    ResourceResolver resourceResolver = resolverFactory.getAdministrativeResourceResolver(null);
    session = resourceResolver.adaptTo(Session.class);
     
 //Create a workflow session 
  WorkflowSession wfSession = workflowService.getWorkflowSession(session);
              
 // Get the workflow model
 WorkflowModel wfModel = wfSession.getModel(workflowName); 
              
  // Get the workflow data
  // The first param in the newWorkflowData method is the payloadType.  Just a fancy name to let it know what type of workflow it is working with.
 WorkflowData wfData = wfSession.newWorkflowData("JCR_PATH", workflowContent);
              
   // Run the Workflow.
    wfSession.startWorkflow(wfModel, wfData);
              
   return workflowName +" has been successfully invoked on this content: "+workflowContent ; 
    }
catch(Exception e)
{
    e.printStackTrace();
}
          
return null;
 }
}
