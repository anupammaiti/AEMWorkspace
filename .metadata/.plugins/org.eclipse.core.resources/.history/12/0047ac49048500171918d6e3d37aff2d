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

  Generate the client javascript code to validate a date field. Possible date formats:
    yyyy-MM-dd'T'HH:mm:ss.SSSZ
    yyyy-MM-dd'T'HH:mm:ss
    yyyy-MM-dd
    dd.MM.yyyy HH:mm:ss
    dd.MM.yyyy

  // todo
  Missing in client validation (but supported by server validation):
    EEE MMM dd yyyy HH:mm:ss 'GMT'Z

--%><%@page session="false" %><%
%><%@ page import="com.day.cq.wcm.foundation.forms.FieldDescription,
                 com.day.cq.wcm.foundation.forms.FieldHelper,
                 org.apache.sling.scripting.jsp.util.JspSlingHttpServletResponseWrapper" %><%
%><%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %><%
%><sling:defineObjects/><%
    // RegExp for Date.Month.Year formats, i.e.:
    // dd.MM.yyyy                   21.12.2009
    // dd.MM.yyyy HH:mm:ss          21.12.2009 14:45:00
    // month and day allow single digits: 4.5.2009
    String dmy = "[\\d]{1,2}\\.[\\d]{1,2}.[\\d]{4}( [\\d]{2}:[\\d]{2}:[\\d]{2}){0,1}";

    // RegExp for Year-Month-Date formats, i.e.:
    // yyyy-MM-dd                   2009-12-21
    // yyyy-MM-dd'T'HH:mm:ss        2009-12-21T14:45:00
    // yyyy-MM-dd'T'HH:mm:ss.SSSZ   2009-12-21T14:45:00.000+01:00
    // month and day allow single digits: 2009-5-4
    String ymd = "[\\d]{4}-[\\d]{1,2}-[\\d]{1,2}(T[\\d]{2}:[\\d]{2}:[\\d]{2}(\\.[\\d]{3}([\\+-][\\d]{2}:[\\d]{2}){0,1}){0,1}){0,1}";

    String regexp = "/^" + dmy + "|" + ymd + "$/";

    final FieldDescription desc = FieldHelper.getConstraintFieldDescription(slingRequest);
    FieldHelper.writeClientRegexpText(slingRequest, new JspSlingHttpServletResponseWrapper(pageContext), desc, regexp);
%>
