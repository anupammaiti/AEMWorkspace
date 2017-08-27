<%--
  ADOBE CONFIDENTIAL
  __________________

   Copyright 2013 Adobe Systems Incorporated
   All Rights Reserved.

  NOTICE:  All information contained herein is, and remains
  the property of Adobe Systems Incorporated and its suppliers,
  if any.  The intellectual and technical concepts contained
  herein are proprietary to Adobe Systems Incorporated and its
  suppliers and are protected by trade secret or copyright law.
  Dissemination of this information or reproduction of this material
  is strictly forbidden unless prior written permission is obtained
  from Adobe Systems Incorporated.
--%>
<%@page session="false" %>
<%@page import="java.util.regex.Matcher,
                java.util.regex.Pattern,
                com.day.cq.wcm.foundation.forms.FieldHelper,
                com.day.cq.wcm.foundation.forms.FieldDescription,
                com.day.cq.wcm.foundation.forms.FormsHelper,
                com.day.cq.wcm.foundation.forms.ValidationInfo"%>
<%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %>
<sling:defineObjects/><%
    final Pattern p = Pattern.compile("[0-9]{3,4}");
    final FieldDescription desc = FieldHelper.getConstraintFieldDescription(slingRequest);
    final String[] values = request.getParameterValues(desc.getName());
    if ( values != null ) {
        for(int i = 0; i < values.length; i++) {
            final Matcher m = p.matcher(values[i]);
            if ( !m.matches() ) {
                if ( desc.isMultiValue() ) {
                    ValidationInfo.addConstraintError(slingRequest, desc, i);
                } else {
                    ValidationInfo.addConstraintError(slingRequest, desc);                    
                }
            }            
        }
    }
%>
