<%@include file="/libs/foundation/global.jsp"%>
<%@taglib prefix="cq" uri="http://www.day.com/taglibs/cq/1.0" %>
<h1>TemplateSling Page</h1>
<%
//create a custom.sling.Query instance
org.myorg.portfolio.slingAPIRetrieveContent.Query wfService = sling.getService(org.myorg.portfolio.slingAPIRetrieveContent.Query.class);
 
%>
<h2>Use the Sling API to get title of the resource at /content/geometrixx/en/service</h2>
  
<h3>The title of the page is: <%=  wfService.getJCRData("/content/geometrixx/en/services")%></h3>
