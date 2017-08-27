<%@page session="false"%><%--
  Copyright 1997-2009 Day Management AG
  Barfuesserplatz 6, 4001 Basel, Switzerland
  All Rights Reserved.

  This software is the confidential and proprietary information of
  Day Management AG, ("Confidential Information"). You shall not
  disclose such Confidential Information and shall use it only in
  accordance with the terms of the license agreement you entered into
  with Day.

  ==============================================================================

  Default body script.

  Draws the HTML body with the page content.

  ==============================================================================

--%><%@page import="org.apache.sling.api.resource.Resource,
				javax.jcr.Node,
				javax.jcr.PathNotFoundException,
				javax.jcr.Session,
                javax.jcr.util.TraversingItemVisitor,
                com.day.cq.commons.Externalizer,
                org.apache.sling.jcr.api.SlingRepository,
                java.util.List,
                java.util.ArrayList,
                java.util.Collections,
                java.util.HashMap,
                java.util.SortedMap,
                java.util.Date,
                com.day.cq.commons.jcr.JcrUtil,
                javax.jcr.NodeIterator" 
%><%@include file="/libs/foundation/global.jsp" %><%
    long startTime = System.currentTimeMillis();
    populatePagesList(currentNode);
    HashMap<String, Date> oldList = parsePagesList(currentNode);
    HashMap<String, Date> newList = tmpPagesList;

    Externalizer externalizer = resourceResolver.adaptTo(Externalizer.class);
    response.setContentType("text/plain");
    
    SlingRepository repo = null;
    Session session = null;
    
    try {
    	repo = sling.getService(SlingRepository.class);
    	session = repo.loginAdministrative(null);
    	saveList(currentNode, newList, session);
    	%><%= appendSitemap(currentNode, oldList, newList, session, externalizer)%><%
    } finally {
        if (session != null) {
            session.logout();
        }
    }
    long endTime = System.currentTimeMillis();
    %># creating this document took <%= endTime - startTime %>ms<%

%><%! 
    HashMap<String, Date> tmpPagesList = new HashMap<String, Date>();
    
    void populatePagesList(Node node) {
        try{
            NodeIterator iter = node.getNodes();
            while(iter.hasNext()) {
                Node child = iter.nextNode();
                if(child.isNodeType("cq:Page")) {
                    Date lastMod = child.getNode("jcr:content").getProperty("cq:lastModified").getDate().getTime();
                    tmpPagesList.put(child.getPath(), lastMod);
                    if(child.hasNodes())
                        populatePagesList(child);
                }
            }
        }catch(Exception e) {
        }
    }
    
    String printPagesList(HashMap<String, Date> pagesList) {
        String list = "";
        for(String key: pagesList.keySet()) {
            list += pagesList.get(key).getTime() + " " + key + "\n";
        }
        return list;
    }
    
    HashMap<String, Date> parsePagesList(Node parent) throws Exception{
        HashMap<String, Date> pagesList = new HashMap<String, Date>();

        try{
            Node sitemapNode = parent.getSession().getRootNode().getNode("var/cache/sitemap" + parent.getPath() + "/cache");
            String pages = sitemapNode.getNode("jcr:content").getProperty("jcr:data").getString();
            if(pages.length() == 0)
                return pagesList;
            String[] lines = pages.split("\n");
            for(int i=0; i < lines.length; i++) {
                String[] entry = lines[i].split(" ");
                pagesList.put(entry[1], new Date(Long.parseLong(entry[0])));
            }
        }catch(PathNotFoundException e) {
        }
        
        return pagesList;
    }
    
    String compareLists(HashMap<String, Date> oldList, HashMap<String, Date> newList, Externalizer externalizer) {
        String resultList = "";
        HashMap<Date, String> newEntries = new HashMap<Date, String>();
        
        /* search for deleted, modified, or added pages
          - iterate over old list and look in new list for old entry
            - if not available, add entry as deleted
            - if available, compare timestamps
              - if they differ, add entry as modified
          - iterate over new list and look in old list for new entry
            - if not available, add entry as added
        */

        for(String oldKey: oldList.keySet()) {
            String entry;
            if(! newList.containsKey(oldKey)) {// deleted
                entry = newEntries.get(oldList.get(oldKey));
                if(entry == null) {
                    entry = "seconds " + (oldList.get(oldKey).getTime() / 1000) + "\n";
                }
                entry += "delete " + externalizer.absoluteLink("http", oldKey + ".html") + "\n";
                newEntries.put(oldList.get(oldKey), entry);
            }else {
                if(oldList.get(oldKey).compareTo(newList.get(oldKey)) != 0) { // modified
                    entry = newEntries.get(newList.get(oldKey));
                    if(entry == null) {
                        entry = "seconds " + (newList.get(oldKey).getTime() / 1000) + "\n";
                    }
                    entry += "update " + externalizer.absoluteLink("http", oldKey + ".html") + "\n";
                    newEntries.put(newList.get(oldKey), entry);
                }
            }
        }
        
        for(String newKey: newList.keySet()) {
            String entry;
            if(! oldList.containsKey(newKey)) {// added
                entry = newEntries.get(newList.get(newKey));
                if(entry == null) {
                    entry = "seconds " + (newList.get(newKey).getTime() / 1000) + "\n";
                }
                entry += "add " + externalizer.absoluteLink("http", newKey + ".html") + "\n";
                newEntries.put(newList.get(newKey), entry);
            }
        }
        
        // sort the list
        List<Date> sortedList = new ArrayList<Date>(newEntries.keySet());
        Collections.sort(sortedList);
        for(Date key: sortedList) {
            resultList += newEntries.get(key) + "\n";
        }

        return resultList;
    }
    
    String appendSitemap(Node parent, HashMap<String, Date> oldList, HashMap<String, Date> newList, Session session, Externalizer externalizer) throws Exception{
        Node sitemapFolder = JcrUtil.createPath("/var/cache/sitemap" + parent.getPath(), "nt:folder", "nt:folder", session, true);
        Node sitemapRes, sitemap;
        try{
            sitemap = sitemapFolder.getNode("sitemap");
            sitemapRes = sitemap.getNode("jcr:content");
        
        }catch(PathNotFoundException e) {
            sitemap = sitemapFolder.addNode("sitemap", "nt:file");
            sitemapRes = sitemap.addNode("jcr:content", "nt:resource");
        }
        String sitemapContent = "";
        if(sitemapRes.hasProperty("jcr:data"))
            sitemapContent = sitemapRes.getProperty("jcr:data").getString();
        sitemapContent += compareLists(oldList, newList, externalizer) + "\n";
        sitemapRes.setProperty ("jcr:data", sitemapContent);
        session.getRootNode().getNode("var").save();
        return sitemapContent;
    }
    
    void saveList(Node parent, HashMap<String, Date> list, Session session) throws Exception{
        Node sitemapFolder = JcrUtil.createPath("/var/cache/sitemap" + parent.getPath(), "nt:folder", "nt:folder", session, true);
        Node sitemapRes, sitemap;
        try{
            sitemap = sitemapFolder.getNode("cache");
            sitemapRes = sitemap.getNode("jcr:content");
        
        }catch(PathNotFoundException e) {
            sitemap = sitemapFolder.addNode("cache", "nt:file");
            sitemapRes = sitemap.addNode("jcr:content", "nt:resource");
        }
        sitemapRes.setProperty ("jcr:data", printPagesList(list));
        session.getRootNode().getNode("var").save();
    }
    
%>