<%@include file="/libs/foundation/global.jsp"%>
<%@taglib prefix="cq" uri="http://www.day.com/taglibs/cq/1.0" %>
<h1>TemplatePDF Page</h1>
<%
//create a InvokeAEMWorkflow instance
org.myorg.portfolio.workflowDemo.InvokeAEMWorkflow wfService = sling.getService(org.myorg.portfolio.workflowDemo.InvokeAEMWorkflow.class);
 
%>
<h2>About to invoke an AEM workflow using the AEM workflow APIs</h2>
  
<h3>AEM Workflow status: <%=  wfService.StartWorkflow("/etc/workflow/models/DeleteContent/jcr:content/model","/content/portfolio/test")%></h3>
