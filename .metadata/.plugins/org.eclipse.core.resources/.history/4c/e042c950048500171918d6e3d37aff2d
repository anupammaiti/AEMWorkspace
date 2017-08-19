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

  Form 'element' component

  Draws an element of a form

--%><%@include file="/libs/foundation/global.jsp"%><%
%><%@include file="../init.jsp"%><%
%><%@page import="java.util.Iterator" %><%
%><%@page import="java.util.Map" %><%
%><%@page import="com.day.cq.security.profile.Profile" %><%
%><%@page import="org.apache.commons.collections.BeanMap" %><%
%><%@page import="com.day.cq.wcm.foundation.forms.FormsHelper" %><%!

  Resource getPrimaryResource(final String propName, final Profile profile) {
	if (profile!=null) {
		Map bm = new BeanMap(profile);
		Iterator<Resource> itr = (Iterator<Resource>) bm.get(propName);
		if (itr!=null) {
			while(itr.hasNext()) {
				Resource res = itr.next();
				if (res.adaptTo(ValueMap.class).get("primary", false)) {
					return res;
				}
			}
		}
	}
	return null;
    }

%><%
final String width = properties.get("width", "");
final String cols = properties.get("cols", "35");
final boolean required = FormsHelper.isRequired(resource);
final String title = FormsHelper.getTitle(resource, "Contact");
final String nodeName = properties.get("name", "emails");

String path, value = "";
if (properties.get("usePrimary", false)) {
	Resource primaryResource = getPrimaryResource(nodeName, profile);
	path = (profile==null) ? "" : "./"+nodeName+ "/primary/"; 
	if (primaryResource!=null) {
		value = primaryResource.adaptTo(ValueMap.class).get("value", String.class);
	} else if (properties.get("getter")!=null){
		value = (String) new BeanMap(profile).get(properties.get("getter", String.class));
		if (value==null) {
			value = ""; 
		}
	}
    %><input type="hidden" value="true" name="<%= xssAPI.encodeForHTMLAttr(path) %>primary"><%

    path = path + "value"; 

    %><%@include file="../formrowtext.jsp"  %><%
}
//todo: add multiples %>
