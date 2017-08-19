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

  Server validation of a date fields. Allowed formats:
    EEE MMM dd yyyy HH:mm:ss 'GMT'Z
    yyyy-MM-dd'T'HH:mm:ss.SSSZ
    yyyy-MM-dd'T'HH:mm:ss
    yyyy-MM-dd
    dd.MM.yyyy HH:mm:ss
    dd.MM.yyyy

--%><%@page session="false" %><%
%><%@page import="java.text.SimpleDateFormat,
                java.util.Date,
                java.text.DateFormat,
                java.text.ParsePosition,
                com.day.cq.wcm.foundation.forms.FieldDescription,
                com.day.cq.wcm.foundation.forms.FieldHelper,
                com.day.cq.wcm.foundation.forms.ValidationInfo" %>
<%
%><%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %><%
%><sling:defineObjects/><%!
    final static SimpleDateFormat[] SLING_FORMATS = new SimpleDateFormat[]{
        new SimpleDateFormat("EEE MMM dd yyyy HH:mm:ss 'GMT'Z"),
        new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ"),
        new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss"),
        new SimpleDateFormat("yyyy-MM-dd"),
        new SimpleDateFormat("dd.MM.yyyy HH:mm:ss"),
        new SimpleDateFormat("dd.MM.yyyy")};

    /**
     * Parse a date/time using an array of DateFormat objects
     *
     * @param sDate    the date string
     * @param formats  the array of DateFormat objects to try, one by one
     * @return the parsed date, or null if not parseable
     */
    private static boolean isDate(String sDate, DateFormat[] formats) {
        for (int i = 0; i < formats.length; i++) {
            try {
                formats[i].setLenient(false);
                Date d = formats[i].parse(sDate, new ParsePosition(0));
                if (d != null) return true;
            }
            catch (NumberFormatException ex) {}
            catch (Exception ex) {}
        }
        return false;
    }

%><%
    final FieldDescription desc = FieldHelper.getConstraintFieldDescription(slingRequest);
    final String[] values = request.getParameterValues(desc.getName());
    if ( values != null ) {
        for(int i=0; i<values.length; i++) {
            boolean isDate = false;
            if ((values[i] != null) && (values[i].length() > 0)) {
                synchronized (SLING_FORMATS) {
                    isDate = isDate(values[i], SLING_FORMATS);
                }
            }
            if (!isDate) {
                if ( desc.isMultiValue() ) {
                    ValidationInfo.addConstraintError(slingRequest, desc, i);
                } else {
                    ValidationInfo.addConstraintError(slingRequest, desc);                    
                }
            }            
        }
    }
%>
