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

  Sends page view statistics for the MVT component

--%><%@ page import="com.day.cq.wcm.core.mvt.MVTStatistics"
        %><%@include file="/libs/foundation/global.jsp"%><%
    MVTStatistics mvtStats = sling.getService(MVTStatistics.class);
    String trackURL = null;
    if (mvtStats != null && mvtStats.getTrackingURI() != null) {
    	trackURL = mvtStats.getTrackingURI().toString();
    }

    %><script type="text/javascript">function trackMVTImpression() {
    <%
        if (trackURL != null) {
    %>
        if (window.randomBannerList) {
            var trackImg = new Image();
            trackImg.src = CQ.shared.HTTP.getXhrHookedURL('<%= trackURL %>/view?path=' + encodeURIComponent('<%= currentPage.getPath() %>') + '&vars=' + encodeURIComponent(window.randomBannerList));
        }
    <%
        }
    %>
    }</script>
