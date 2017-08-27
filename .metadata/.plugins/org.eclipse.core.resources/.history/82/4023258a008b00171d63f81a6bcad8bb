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

 Segment renderer for sling:OrderedFolder nodes

 Creates the segmentation registration for the current folder.

--%>
<%@page import="org.slf4j.LoggerFactory"%>
<%@ page session="false"
             contentType="application/x-javascript"
             pageEncoding="utf-8"
             import="java.util.Iterator,
                     java.util.Calendar,
                     javax.jcr.*,
                     javax.jcr.query.*,
                     com.day.cq.wcm.api.NameConstants,
                     com.day.cq.wcm.api.Page,
                     org.apache.sling.api.resource.Resource,
                     org.apache.sling.api.resource.AbstractResourceVisitor,
                     org.apache.sling.api.resource.ResourceUtil,
                     org.apache.sling.api.resource.ValueMap,
                     org.apache.commons.codec.digest.DigestUtils"%><%
%><%@include file="/libs/foundation/global.jsp"%><%
    boolean stopProcessing = false;
    // only execute last-modified logic once
    if ( !response.containsHeader("ETag")) {

        // TODO - this should be removed and moved to a service, but the API 
        // needs more thought and backing time and should be considered for the next release
        // 
        // computes a checksum using the following algorithm
        // 
        // 1. Retrieve all the cq:lastModified properties from the content hierarchy
        // 2. Appends them to a buffer in order in which they are stored
        // 3. Computes an MD5 of the resulting string and uses it as an ETag
        // 
        // The algorithm ensures the checksums are consistent with the content since:
        //
        // 1. Adding a new page, with a new cq:lastModified value is reflected in the checksum
        // 2. Removing a page is reflected in the checksum
        // 3. Reordering pages is reflected in the checksum, since the dates are appended
        //    in the repository order
        // 4. Modifying a page is reflected in the checksum since the cq:lastModified value
        //    is changed and reflected in the checksum
        
        final StringBuilder checkSum = new StringBuilder();
        
        new AbstractResourceVisitor() {
            protected void visit(Resource r) {
                ValueMap props =  ResourceUtil.getValueMap(r);
                
                if ( props == null ) {
                    return;
                }
                
                Calendar lastModified = props.get(NameConstants.PN_PAGE_LAST_MOD, Calendar.class);
                if ( lastModified != null ) {
                    checkSum.append(lastModified.getTimeInMillis());
                }
            }
        }.accept(resource);
        
        String eTag = DigestUtils.md5Hex(checkSum.toString());
        
        response.addHeader("ETag", eTag);

        String ifNoneMatch = request.getHeader("If-None-Match");
        
        if ( ifNoneMatch != null ) {
            if ( eTag.equals(ifNoneMatch)) {
                response.setStatus(HttpServletResponse.SC_NOT_MODIFIED);
                stopProcessing = true;
            }
        }

    }

    if ( !stopProcessing ) {
        Iterator<Resource> iter = resourceResolver.listChildren(resource);
        while(iter.hasNext()) {
            Resource child = iter.next();
            //exclude jcr:content nodes
            if(!NameConstants.NN_CONTENT.equals(child.getName())) {
                %> <sling:include path="<%= child.getPath() %>" replaceSelectors="segment" replaceSuffix="js" /> <%
            }
        }
    }
%>