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

  Form 'action' component
  Handles requests to update the profile
  todo: change to client-side load

--%><%@page session="false"
            import="com.day.cq.security.profile.Profile,
                    com.day.cq.wcm.foundation.forms.FormsConstants,
                    com.day.cq.wcm.foundation.forms.FormsHelper" %><%
%><%@taglib prefix="cq" uri="http://www.day.com/taglibs/cq/1.0" %><%
%><cq:defineObjects /><%

final Profile profile = slingRequest.adaptTo(Profile.class);
final StringBuffer target = new StringBuffer(properties.get("thankyouPage", currentPage.getPath()));
target.append(".").append(slingRequest.getRequestPathInfo().getExtension());
if (profile!=null && profile.getAuthorizable()!=null) {
	target.append("?authorizable=").append(profile.getAuthorizable().getID());
}

%><script type="text/javascript">
function addPath() {
	var frm = document.forms['<%= FormsHelper.getFormId(slingRequest)%>'];
	var elem = document.createElement("input");
<% if (profile!=null) {
	%>
	elem.value= '<%= profile.getPath() %>';
	elem.name=":profile";
	elem.type="hidden";
	frm.appendChild(elem);
	elem = document.createElement("input");
<% }%>
    elem.value= '<%= target %>';
    elem.name="<%= FormsConstants.REQUEST_PROPERTY_REDIRECT %>";
    elem.type="hidden";
    frm.appendChild(elem);
}
window.attachEvent ? window.attachEvent("onload", addPath): window.addEventListener("load", addPath, false) ;
 
</script>
