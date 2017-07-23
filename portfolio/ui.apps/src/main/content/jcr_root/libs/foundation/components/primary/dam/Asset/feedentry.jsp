<%--
 Copyright 1997-2009 Day Management AG
 Barfuesserplatz 6, 4001 Basel, Switzerland
 All Rights Reserved.

 This software is the confidential and proprietary information of
 Day Management AG, ("Confidential Information"). You shall not
 disclose such Confidential Information and shall use it only in
 accordance with the terms of the license agreement you entered into
 with Day.

 ==============================================================================

 Atom feed entry renderer for dam:Asset nodes

 Draws the current dam asset as a feed entry.

--%><%@ page session="false" %><%
%><%@ page import="java.util.Date,
                   com.day.cq.commons.Externalizer,
                   javax.jcr.Node,
                   javax.jcr.NodeIterator,
                   com.day.text.Text,
                   org.apache.sling.api.resource.ResourceResolver,
                   com.day.cq.dam.commons.util.DamUtil,
                   com.day.cq.wcm.api.WCMMode"%><%
%><%@ taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %><%
%><%@ taglib prefix="cq" uri="http://www.day.com/taglibs/cq/1.0" %><%
%><%@ taglib prefix="atom" uri="http://sling.apache.org/taglibs/atom/1.0" %><%
%><%@ taglib prefix="media" uri="http://sling.apache.org/taglibs/mediarss/1.0" %><%
%><cq:defineObjects /><%

    try {
        WCMMode.DISABLED.toRequest(request);
        
        Node renditions = currentNode.getNode("jcr:content/renditions");
        Node metadata = currentNode.getNode("jcr:content/metadata");

        Externalizer externalizer = sling.getService(Externalizer.class);
        String url = externalizer.absoluteLink(slingRequest, slingRequest.getScheme(), currentNode.getPath());

        String title = DamUtil.getValue(metadata, "dc:title", currentNode.getName());

        String mimetype = DamUtil.getValue(metadata, "dc:format", "application/octet-stream");

        Date pdate = properties.get("cq:lastPublished", properties.get("jcr:created", Date.class));

        //separating default value extraction, because in ValueMap.get(String, T) if second argument is null. Then return type is unknown.
        Date udate = properties.get("jcr:lastModified", Date.class);

        if (udate == null) {
          udate = properties.get("cq:lastModified", Date.class);
        }

        String desc = DamUtil.getValue(metadata, "dc:description", properties.get("jcr:description", String.class));

        %><atom:entry
               id="<%= url %>"
               updated="<%= udate %>"
               published="<%= pdate %>"><%
            %><atom:title><%= title %></atom:title><%
            %><atom:link href="<%= url %>"/><%
            %><atom:content><%
                // todo: find suitable thumbnail in content instead of hardcoded 140x100
                %><img src="<%=url%>/jcr:content/renditions/cq5dam.thumbnail.140.100.png" alt="<%= title %>"/><%
                // disabled desc for bug #27019
                // desc - even provided by a camera - ends sometimes with a null character %00
//              if (desc != null) {
                  %><%-- <p><%= desc %></p> --%><%
//          }
            %></atom:content><%

            String[] tags =
                    properties.get("./jcr:content/metadata/cq:tags", new String[0]);
            for (String tag : tags) {
                %><atom:category term="<%=tag%>"/><%
            }

            if (desc != null) {
                %><%--<atom:summary><%= desc %></atom:summary>--%><%
            }

            try {
                NodeIterator rIter = renditions.getNodes();
                String medium = "document";
                if (mimetype.startsWith("image/")) {
                  medium = "image";
                } else if (mimetype.startsWith("video/")) {
                  medium = "video";
                } else if (mimetype.startsWith("audio/")) {
                  medium = "audio";
                }
                %><media:content url="<%= url %>" type="<%=mimetype %>" medium="<%=medium %>"><%
                while (rIter.hasNext()) {
                    Node rendition = rIter.nextNode();
                    if (rendition.getName().indexOf(".thumbnail.") > 0) {
                        String[] nameParts = Text.explode(rendition.getName(), '.');
                        int width = nameParts.length > 2 ? Integer.parseInt(nameParts[2]) : 0;
                        int height = nameParts.length > 3 ? Integer.parseInt(nameParts[3]) : 0;
                        url = externalizer.absoluteLink(slingRequest, slingRequest.getScheme(), rendition.getPath());
                        %><media:thumbnail
                               url="<%= url %>"
                               width="<%= width %>"
                               height="<%= height %>"/><%
                    }
                }
                %></media:content><%
            } catch (Exception e) { }
        %></atom:entry><%

    } catch (Exception e) {
        log.error("error while rendering feed entry for dam asset", e);
    }
%>