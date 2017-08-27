<%@include file="/libs/foundation/global.jsp"%>
<%@taglib prefix="cq" uri="http://www.day.com/taglibs/cq/1.0" %>
<h1><%= properties.get("title", currentPage.getTitle()) %></h1>
<%
//create a PDFService instance
org.myorg.portfolio.PDFService.PDFService pdfService = sling.getService(org.myorg.portfolio.PDFService.PDFService.class);
 
%>
<h2>About to write out the location of the PDF created by the custom AEM PDF Service</h2>
  
<h3>The PDF was saved in this AEM DAM location: <%=  pdfService.createPDF("TestDAM.pdf","This string will be written to the PDF")%></h3>
