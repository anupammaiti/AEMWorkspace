<%@page session="false"%><%@ page import="org.apache.commons.lang.StringUtils,
                 java.util.Calendar" %><%
%><%@include file="/libs/foundation/global.jsp"%><%

    final String text = currentStyle.get("text", "All rights reserved.");
    final String linkDisclaimer = currentStyle.get("linkDisclaimer", "");
    final String linkDisclaimerText = currentStyle.get("linkDisclaimerText", "Legal statement");
    final String linkPrivacyPolicy = currentStyle.get("linkPrivacyPolicy", "");
    final String linkPrivacyPolicyText = currentStyle.get("linkPrivacyPolicyText", "Privacy Policy");

    final boolean showDisclaimer = StringUtils.isNotBlank(linkDisclaimer);
    final boolean showPrivacyPolicy = StringUtils.isNotBlank(linkPrivacyPolicy);
    final boolean showBoth = showDisclaimer && showPrivacyPolicy;
%>&copy; <%=Calendar.getInstance().get(Calendar.YEAR)%> <%=text%><%

    if (showDisclaimer || showPrivacyPolicy) {
%> Read<%
    }

    if (showDisclaimer) {
%> <a href="<%=linkDisclaimer%>.html"><%=linkDisclaimerText%></a><%
    }

    if (showBoth) {
%> and<%
    }

    if (showPrivacyPolicy) {
%> <a href="<%=linkPrivacyPolicy%>.html"><%=linkPrivacyPolicyText%></a>
<%
    }
%>
