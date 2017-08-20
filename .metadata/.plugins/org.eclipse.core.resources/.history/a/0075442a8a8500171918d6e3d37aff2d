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

  Text-Image component

  Combines the text and the image component

--%>
<%@ page import="com.day.cq.wcm.foundation.Image,
    com.day.cq.wcm.foundation.TextFormat,
    com.day.cq.wcm.api.components.DropTarget,
    com.day.cq.wcm.api.WCMMode,
    org.apache.sling.api.resource.ResourceUtil,
    org.apache.sling.api.resource.ValueMap,
    com.day.cq.commons.Doctype,
    com.day.cq.wcm.mobile.api.device.capability.DeviceCapability,
    com.day.cq.wcm.mobile.core.MobileUtil,
    com.day.cq.commons.DiffInfo,
    com.day.cq.commons.DiffService" %>
<%@include file="/libs/foundation/global.jsp"%><%
    //drop target css class = dd prefix + name of the drop target in the edit config
    String ddClassName = DropTarget.CSS_CLASS_PREFIX + "image";

    Image img = new Image(resource, "image");
    final DiffInfo diffInfo = resource.adaptTo(DiffInfo.class);
    final Image diffImg = (diffInfo == null || diffInfo.getContent() == null ? null : new Image(diffInfo.getContent(), "image"));
    final DiffService diffService = (diffInfo == null ? null : sling.getService(DiffService.class));
    if ((img.hasContent() || WCMMode.fromRequest(request) == WCMMode.EDIT) && MobileUtil.hasCapability(slingRequest, DeviceCapability.CAPABILITY_IMAGES)) {
        String cssClass = "image ";
        if ( diffInfo != null ) {
            if ( diffInfo.getType() == DiffInfo.TYPE.ADDED ) {
                cssClass += "imageAdded ";
            } else if ( diffInfo.getType() == DiffInfo.TYPE.REMOVED ) {
                cssClass += "imageRemoved ";
            } else {
                final String path1 = (img.getHref() != null ? img.getHref() : "");
                final String path2 = (diffImg != null && diffImg.getHref() != null ? diffImg.getHref() : "");
                if ( !path1.equals(path2) ) {
                    if ( path1.length() == 0 ) {
                        img.addCssClass("imageRemoved");
                    } else if ( path2.length() == 0 ) {
                        img.addCssClass("imageAdded");
                    } else {
                        int pos = path2.indexOf("jcr:frozenNode/");
                        if ( pos == -1
                             || !path1.endsWith(path2.substring(pos+14))
                             || img.getLastModified().compareTo(diffImg.getLastModified()) != 0 ) {    
                            img.addCssClass("imageChanged");
                        }
                    }
                } else if ( img.getLastModified().compareTo(diffImg.getLastModified()) !=  0 ) {
                    img.addCssClass("imageChanged");                
                }
            }
        }
        %><div class="<%= cssClass %><%= properties.get("cq:cssClass", "") %>"><%
        img.loadStyleData(currentStyle);
        // add design information if not default (i.e. for reference paras)
        if (!currentDesign.equals(resourceDesign)) {
            img.setSuffix(currentDesign.getId());
        }
        img.addCssClass(ddClassName);
        img.setSelector(".img");
        img.setDoctype(Doctype.fromRequest(request));
        String title = img.getTitle();
        if ( title.length() > 0 ) {
            title = img.getTitle(true);
        }
        if ( diffInfo != null ) {
            final String other = (diffImg == null ? "" : diffImg.getTitle(true));
            final String diffOutput = diffInfo.getDiffOutput(diffService, title, other, false);
            if ( diffOutput != null ) {
                title = diffOutput;
            }
        }
        %><% img.draw(out); %><br><%
        String desc = img.getDescription();
        if ( desc.length() > 0 ) {
            desc = img.getDescription(true);
        }
        if ( diffInfo != null ) {
            final String other = (diffImg == null ? "" : diffImg.getDescription(true));
            final String diffOutput = diffInfo.getDiffOutput(diffService, desc, other, false);
            if ( diffOutput != null ) {
                desc = diffOutput;
            }
        }
        if (desc.length() > 0) {            
            %><small><%= desc %></small><%
        }
        %></div><%
    }
    if (properties.get("text", "").length() > 0) {
        String text = properties.get("text", String.class);
        boolean isRichText = properties.get("textIsRich", "false").equals("true");
        if ( diffInfo != null ) {
            final ValueMap map = ResourceUtil.getValueMap(diffInfo.getContent());
            final String diffOutput = diffInfo.getDiffOutput(diffService, text, map.get("text", ""), isRichText);
            if ( diffOutput != null ) {
                text = diffOutput;
                isRichText = true;
            }
        }
        %><div class="text"><%
        if (isRichText) {
            %><%= text %><%
        } else {
            TextFormat fmt = new TextFormat();
            fmt.setTagUlOpen("<ul>");
            fmt.setTagOlOpen("<ol start=\"%s\">");
            %><%= fmt.format(text) %><%
        }
        %></div><%
    } else if (WCMMode.fromRequest(request) == WCMMode.EDIT) {
        %><img src="/libs/cq/ui/resources/0.gif" class="cq-text-placeholder <%= ddClassName %>" alt=""><%
    }
    %><div class="clear"></div>
