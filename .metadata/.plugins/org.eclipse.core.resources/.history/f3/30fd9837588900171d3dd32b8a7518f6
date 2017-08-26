<%@page session="false"%><%--
  Copyright 1997-2008 Day Management AG
  Barfuesserplatz 6, 4001 Basel, Switzerland
  All Rights Reserved.

  This software is the confidential and proprietary information of
  Day Management AG, ("Confidential Information"). You shall not
  disclose such Confidential Information and shall use it only in
  accordance with the terms of the license agreement you entered into
  with Day.

  ==============================================================================

  Image component

  Draws an image.

--%><%@ page import="com.day.cq.wcm.mobile.api.device.capability.DeviceCapability,
                     com.day.cq.wcm.mobile.core.MobileUtil" %> <%
%><%@include file="/libs/foundation/global.jsp"%><%

    // only show the image if the device supports image display
    if (MobileUtil.hasCapability(slingRequest, DeviceCapability.CAPABILITY_IMAGES)) {
        %><cq:include script="image.jsp"/><%
    }
%>
