<%@page session="false"%><%--
  Copyright 1997-2011 Day Management AG
  Barfuesserplatz 6, 4001 Basel, Switzerland
  All Rights Reserved.

  This software is the confidential and proprietary information of
  Day Management AG, ("Confidential Information"). You shall not
  disclose such Confidential Information and shall use it only in
  accordance with the terms of the license agreement you entered into
  with Day.

  ==============================================================================
--%><%@include file="/libs/foundation/global.jsp"%>
<%@include file="../init.jsp"%><%
%><%@page import="com.day.cq.commons.ImageHelper,
                  com.day.cq.wcm.foundation.Image,
                  com.day.cq.wcm.foundation.forms.FormsHelper,
                  com.day.cq.wcm.foundation.forms.LayoutHelper,
                  com.day.text.Text,
                  org.apache.sling.api.resource.ValueMap,
                  java.util.Iterator,
                  com.day.cq.i18n.I18n" %><%

    I18n i18n = new I18n(slingRequest);

    String name = FormsHelper.getParameterName(resource);
    if(name != null)
        name = xssAPI.encodeForHTMLAttr(name);
    String id = FormsHelper.getFieldId(slingRequest, resource);
    if(id != null)
	id = xssAPI.encodeForHTMLAttr(id);
    final String title = FormsHelper.getTitle(resource, "Avatar");
    final String width = xssAPI.encodeForHTMLAttr(properties.get("width", ""));

    final String path = "./" + name;
    final boolean required = FormsHelper.isRequired(resource);

	Resource primPhoto = null;
    if (profile != null) {
        Iterator<Resource> photos = profile.getPhotos();
        while (photos.hasNext()) {
            Resource check = photos.next();
            if (check.adaptTo(ValueMap.class).get("primary", false)) {
                primPhoto = check;
                break;
            }
        }
    }
    Image img = null;
    if (primPhoto != null) {
        img = new Image(primPhoto);
        img.setItemName("file", "image");
    }

    %><div class="form_row"><%
        LayoutHelper.printTitle(id, title, required, out);
        %><div class="form_rightcol"><%
        String size = "28";
        if (img!=null && img.hasContent()) {
            // TODO: replace with Granite security user API and eventually AuthorizableUtil.getFormattedName
            img.addAttribute("style", "padding-right:10px;");
            %><img src="<%= img.getFileNodePath()%>.prof.thumbnail.<%=
                ImageHelper.getExtensionFromType(img.getMimeType()) == null?
                "png" : ImageHelper.getExtensionFromType(img.getMimeType()) %>"
                 alt="<%=Text.escape(profile.getFormattedName())%>"
                 style="float:left;padding-right:10px;" /><%
            size="12";
            %><span><input type="checkbox" onclick="{if (this.checked) {this.name='<%= path%>@Delete';} else {this.name = ''; }}"/>&nbsp;<%= xssAPI.encodeForHTML(properties.get("deleteTitle", i18n.get("Delete")))%></span><br><%
            }
        %><input class="geo" id="<%= id %>" name="<%=path%>/image" type="file" size="<%= size %>" <%= (width.length()>0?"style='width:"+ width +"px;'":"") %>></div>
        <input type="hidden" name="<%=path%>/primary" value="true">
</div>