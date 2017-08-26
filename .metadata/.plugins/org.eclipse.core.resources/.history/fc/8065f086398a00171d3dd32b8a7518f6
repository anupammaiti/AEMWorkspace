<%--
 * ADOBE CONFIDENTIAL
 *
 * Copyright 2011 Adobe Systems Incorporated
 * All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of Adobe Systems Incorporated and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to Adobe Systems Incorporated and its
 * suppliers and may be covered by U.S. and Foreign Patents,
 * patents in process, and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Adobe Systems Incorporated.
--%><%@page session="false"
            contentType="text/html; charset=UTF-8"
            import="com.day.cq.wcm.api.WCMMode,
                    com.day.cq.wcm.foundation.forms.FormsHelper,
                    org.apache.commons.lang3.StringEscapeUtils,
                    java.util.Iterator,
                    java.util.Map"
%><%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0"
%><%@taglib prefix="cq" uri="http://www.day.com/taglibs/cq/1.0"
%><sling:defineObjects/><%
    /* resource is the form start, so we need to get to the par to locate all fields */
    Map<String, String> showHideExpressions = FormsHelper.getShowHideExpressions(resource.getParent());

    switch (WCMMode.fromRequest(request)) {
        case EDIT:
        case DESIGN:
            // CQ5.5 deploys abacus only when show/hide expressions are in use.  Future versions may want
            // to support calculations, etc., and if so, will need to change this logic.
            if (!showHideExpressions.isEmpty()) {
                out.write("<script type='text/javascript'>\n");
                out.write("  cq5forms_reloadForPreview = true;\n");
                out.write("</script>\n");
            }
            break;

        default:
            // CQ5.5 deploys abacus only when show/hide expressions are in use.  Future versions may want
            // to support calculations, etc., and if so, will need to change this logic.

            if (!showHideExpressions.isEmpty()) {

                %><cq:includeClientLib categories="cq.abacus"/>
<%
                out.write("<script type='text/javascript'>\n");
                if (WCMMode.fromRequest(request) != WCMMode.DISABLED) {
                    // A page written in one mode can be switched to another mode without a refresh, so
                    // make sure we still have our flag.  On the other hand, if WCMMode is disabled
                    // entirely (ie: on a publish instance), then we can't switch and don't want the flag.
                    out.write("  cq5forms_reloadForPreview = true;\n");
                }
                out.write("  jQuery(document).ready(function() {\n");

                out.write("    var showHideExpressions = {\n");
                for (Iterator<String> iterator = showHideExpressions.keySet().iterator(); iterator.hasNext(); ) {
                    String key = iterator.next();
                    String expression = showHideExpressions.get(key) + ";";
                    out.write("      " + key + ": \"" + StringEscapeUtils.escapeEcmaScript(expression) + "\""
                                + (iterator.hasNext() ? ",\n" : "\n"));
                }
                out.write("    };\n");

                out.write("    abacus.initializeAbacus(showHideExpressions);\n");
                out.write("  });\n");

                out.write("</script>\n");
            }
    }
%>