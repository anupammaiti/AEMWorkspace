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

--%>
<%@page session="false" %>
<%@page import="com.day.cq.wcm.foundation.forms.FieldDescription,
                com.day.cq.wcm.foundation.forms.FieldHelper,
                com.day.cq.wcm.foundation.forms.ValidationInfo,
                com.day.text.Text"%>
<%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0" %>

<sling:defineObjects/><%

    // Get field description and force its name
    FieldDescription desc = FieldHelper.getConstraintFieldDescription(slingRequest);
    desc.setName(":cq:captcha");

    // Check if a value has been provided
    if (FieldHelper.checkRequired(slingRequest, desc)) {
        final String captchatry = request.getParameter(desc.getName());
        final String captchakey = request.getParameter(":cq:captchakey");

        final String mins = "" + (System.currentTimeMillis() / (60 * 1000));
        final String minsold = "" + (System.currentTimeMillis() / (60 * 1000) - 1);

        final String captchacurrent = (Text.md5("" + (captchakey + mins))).substring(1, 6);
        final String captchaold = (Text.md5("" + (captchakey + minsold))).substring(1, 6);

        if (!captchatry.equals(captchacurrent) && !captchatry.equals(captchaold)) {
            ValidationInfo.addConstraintError(slingRequest, desc);
        }
    }

%>
