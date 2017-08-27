    <%--
      ADOBE CONFIDENTIAL

      Copyright 2013 Adobe Systems Incorporated
      All Rights Reserved.

      NOTICE:  All information contained herein is, and remains
      the property of Adobe Systems Incorporated and its suppliers,
      if any.  The intellectual and technical concepts contained
      herein are proprietary to Adobe Systems Incorporated and its
      suppliers and may be covered by U.S. and Foreign Patents,
      patents in process, and are protected by trade secret or copyright law.
      Dissemination of this information or reproduction of this material
      is strictly forbidden unless prior written permission is obtained
      from Adobe Systems Incorporated.
    --%><%@page session="false"
                import="java.util.ArrayList,
                  java.util.HashMap,
                  com.day.cq.commons.jcr.JcrConstants,
                  org.apache.sling.api.wrappers.ValueMapDecorator,
                  com.adobe.granite.ui.components.Value,
                  com.adobe.granite.ui.components.ds.DataSource,
                  com.adobe.granite.ui.components.ds.EmptyDataSource,
                  com.adobe.granite.ui.components.ds.SimpleDataSource,
                  com.adobe.granite.ui.components.ds.ValueMapResource,
				  org.apache.sling.api.resource.ResourceMetadata,
				  java.util.Iterator,
				  org.apache.sling.api.resource.ResourceUtil" %><%
        %><%@include file="/libs/foundation/global.jsp"%><%

    // pattern to find the listitem_* jsps
    String regex = "^listitem\\_(.*)\\.jsp$";

    // contains final list of synthetic resources
    ArrayList<Resource> resourceList = new ArrayList<Resource>();

    // get list of child nodes of the current component node
    Resource listResource = resourceResolver.getResource((String) request.getAttribute(Value.CONTENTPATH_ATTRIBUTE));
    Resource listComponent = resourceResolver.getResource(listResource.getResourceType());
    Iterator<Resource> children = listComponent.listChildren();
    // iterate over children to find all scripts that match
    while (children.hasNext()) {
        Resource child = children.next();
        String name = child.getName();
        if (name.matches(regex)) {
            // extract part between listitem_ and .jsp, store it as value
            String value = name.replaceFirst(regex, "$1");
            // see if there's a better label
            String text = ResourceUtil.getValueMap(child).get(JcrConstants.JCR_TITLE, value);

            // create a ValueMap
            HashMap map = new HashMap();
            map.put("text", text);
            map.put("value", value);
            // create a synthetic resource
            ValueMapResource mapResource = new ValueMapResource(resourceResolver, new ResourceMetadata(), "", new ValueMapDecorator(map));
            // add resource to list
            resourceList.add(mapResource);
        }
    }

    DataSource ds;

    // if no matching nodes where found
    if (resourceList.size() == 0){
        // return empty datasource
        ds = EmptyDataSource.instance();
    } else {
        // create a new datasource object
        ds = new SimpleDataSource(resourceList.iterator());
    }

    // place it in request for consumption by datasource mechanism
    request.setAttribute(DataSource.class.getName(), ds);
%>