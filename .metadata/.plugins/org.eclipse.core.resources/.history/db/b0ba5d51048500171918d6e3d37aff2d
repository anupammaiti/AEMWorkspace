<%--
  Copyright 1997-2008 Day Management AG
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
%><%@page import="com.day.cq.wcm.foundation.forms.FormsHelper,
                  com.day.cq.wcm.foundation.forms.ValidationHelper"%><%
%><%@taglib prefix="cq" uri="http://www.day.com/taglibs/cq/1.0" %><%
%><cq:defineObjects/><%
    final String name = FormsHelper.getParameterName(resource);
    final String formId = FormsHelper.getFormId(slingRequest);
%>
{   var result=false;
    var elem = document.forms["<%= xssAPI.encodeForJSString(formId) %>"].elements;
    var last, confirm;
    for (var i=0; i < elem.length; i++) {
       var name = elem[i].name;
       if (name=='<%= xssAPI.encodeForJSString(name) %>') {
            last = elem[i].value;       
       } else if (name=='<%= xssAPI.encodeForJSString(name) %>_confirm') {
            confirm = elem[i].value;
            break;
       }   
    }
    if(last!=confirm) {
        cq5forms_showMsg(<%
            %>'<%= xssAPI.encodeForJSString(formId) %>',<%
            %>'<%= xssAPI.encodeForJSString(name) %>_confirm',<%
            %>'<%= xssAPI.encodeForJSString(ValidationHelper.getConstraintMessage(resource)) %>');
        return false; } 
   }