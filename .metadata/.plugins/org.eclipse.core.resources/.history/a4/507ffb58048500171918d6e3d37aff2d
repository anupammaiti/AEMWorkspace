<%@page session="false"%><%--
  Copyright 1997-2008 Day Management AG
  Barfuesserplatz 6, 4001 Basel, Switzerland
  All Rights Reserved.

  This software is the confidential and proprietary information of
  Day Management AG, ("Confidential Information"). You shall not
  disclose such Confidential Information and shall use it only in
  accordance with the terms of the license agreement you entered into
  with Day.

  ==============================================================================

  Chart component

  Draws a chart.

--%><%@ page import="com.day.cq.wcm.foundation.Chart" %><%
%><%@page import="com.day.cq.wcm.foundation.Placeholder, java.util.ResourceBundle"%><%
%><%@include file="/libs/foundation/global.jsp"%><%
    ResourceBundle bundle = slingRequest.getResourceBundle(null);
    try {
        Chart chart = new Chart(resource);

	    String chartUrl, legendUrl = null;
	    if (chart.hasData()) {
	        String suffix = currentDesign.equals(resourceDesign) ? "" : "/" + currentDesign.getId();
            // add mod timestamp to avoid client-side caching of updated images
            long tstamp = properties.get("jcr:lastModified", properties.get("jcr:created", System.currentTimeMillis()));
            suffix += "/" + tstamp + ".png";
	        chartUrl = resource.getPath() + ".img.png" + suffix;
	        legendUrl = resource.getPath() + ".legend.png" + suffix;
	    } else {
	        chartUrl = "/etc/designs/default/0.gif";
	    }
	    String alt = chart.getAlt();

	    if (legendUrl != null) {
	        if (properties.get(Chart.PN_CHART_TYPE) == null) {
	            %><div><%= bundle.getString("No chart type selected.") %></div><%
	        } else if (properties.get(Chart.PN_CHART_TYPE).equals(Chart.PIE_CHART_TYPE)) { %>
	            <div style="text-align:center">
	                <img src="<%= xssAPI.getValidHref(chartUrl) %>" <% if (alt != null) { %>alt="<%= xssAPI.encodeForHTMLAttr(alt) %>" <% } %>/>
	                <img src="<%= xssAPI.getValidHref(legendUrl) %>"/>
	            </div>
	        <% } else { %>
	            <table cellspacing="4px"><tbody><tr>
	                <td><img src="<%= xssAPI.getValidHref(chartUrl) %>" <% if (alt != null) { %>alt="<%= xssAPI.encodeForHTMLAttr(alt) %>" <% } %>/></td>
	                <td><img src="<%= xssAPI.getValidHref(legendUrl) %>"/></td>
	            </tr></tbody></table>
	        <% }
	    } else {
                String classicPlaceholder =
                        "<img src=\"" + xssAPI.getValidHref(chartUrl) +"\" class=\"cq-chart-placeholder\"/>";
                String placeholder = Placeholder.getDefaultPlaceholder(slingRequest, component, classicPlaceholder);
	        %><%= placeholder %><%
	    }
    } catch (Exception e) {
        %><div><%= bundle.getString("Chart could not be generated:") + " " + xssAPI.encodeForHTML(e.getLocalizedMessage()) %></div><%
    }
%>
