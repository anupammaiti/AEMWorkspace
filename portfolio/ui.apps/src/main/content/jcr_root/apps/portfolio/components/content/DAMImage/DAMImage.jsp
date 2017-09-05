<%@include file="/libs/foundation/global.jsp"%>
<%@page session="false" %>
<%@page import="com.day.cq.tagging.*,com.day.cq.wcm.api.*"%>
  
<%@ page import="java.util.*,
    javax.jcr.*,
    org.apache.sling.api.resource.*,
    org.apache.sling.api.scripting.*,
    org.apache.sling.jcr.api.*,
    com.day.cq.search.*,
    com.day.cq.search.result.*"
  
 %>
  
<%@page import="com.day.cq.dam.api.Asset"%>
  
<% 
SlingRepository slingRep = sling.getService(SlingRepository.class); 
Session session = slingRep.loginAdministrative(null);
QueryBuilder qb ; 
Map<String, String> map = new HashMap<String,String>();
map.put("type", "dam:Asset");
map.put("property", "jcr:content/metadata/dc:format"); 
map.put("property.value", "image/jpeg");
qb=resource.getResourceResolver().adaptTo(QueryBuilder.class);
Query query = qb.createQuery(PredicateGroup.create(map), session);
  
SearchResult sr= query.getResult();
String assetPath=null; 
  
 // iterating over the results
  for (Hit hit : sr.getHits()) {
      String path = hit.getPath();
      Resource rs = resourceResolver.getResource(path);
      Asset asset = rs.adaptTo(Asset.class);     
     assetPath = asset.getPath(); 
%>
<img src="<%= assetPath %>" />
<%
 
}
%>
