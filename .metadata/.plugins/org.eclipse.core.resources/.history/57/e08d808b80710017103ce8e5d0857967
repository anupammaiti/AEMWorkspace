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

  Form 'element' component

  Generate the client javascript code to validate this field.

--%><%@page session="false" %><%
%><%@page import="com.day.cq.wcm.foundation.forms.FieldHelper,
                  com.day.cq.wcm.foundation.forms.FieldDescription,
                  org.apache.sling.scripting.jsp.util.JspSlingHttpServletResponseWrapper,
                  com.day.cq.wcm.foundation.forms.FormResourceEdit" %><%
%><%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %><%
%><sling:defineObjects/><%
    FieldDescription[] descs = FieldHelper.getFieldDescriptions(slingRequest, resource);
    for(final FieldDescription desc : descs) {
        boolean checkMulti = FormResourceEdit.isMultiResource(slingRequest) && (desc.isRequired() || desc.getConstraintType() != null);
        if (checkMulti) {
            // multiple resources: validate solely if the @Write checkbox is checked
            %>
            var cb = <%= FieldHelper.getClientFieldQualifier(slingRequest, desc, FormResourceEdit.WRITE_SUFFIX) %>;
            if (cb && cb.checked) {
            <%
        }
        FieldHelper.writeClientRequiredCheck(slingRequest, new JspSlingHttpServletResponseWrapper(pageContext), desc);
        FieldHelper.writeClientConstraintCheck(slingRequest, new JspSlingHttpServletResponseWrapper(pageContext), desc);        
        if (checkMulti) {
            %>
            }
            <%
        }
    }
%>
