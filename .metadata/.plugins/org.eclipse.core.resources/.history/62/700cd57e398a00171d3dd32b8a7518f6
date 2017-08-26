<%--
  ADOBE CONFIDENTIAL
  __________________

   Copyright 2013 Adobe Systems Incorporated
   All Rights Reserved.

  NOTICE:  All information contained herein is, and remains
  the property of Adobe Systems Incorporated and its suppliers,
  if any.  The intellectual and technical concepts contained
  herein are proprietary to Adobe Systems Incorporated and its
  suppliers and are protected by trade secret or copyright law.
  Dissemination of this information or reproduction of this material
  is strictly forbidden unless prior written permission is obtained
  from Adobe Systems Incorporated.
--%><%
%><%@page session="false"
          import="com.adobe.granite.i18n.LocaleUtil,
          javax.jcr.Node" %><%
%><%@include file="/libs/granite/ui/global.jsp"%><%
    final String DEFAULT_RENDITION = "jcr:content/renditions/plain";
    final String ORIGINAL_RENDITION = "jcr:content/renditions/original";
    final String DAM_ASSET_TITLE = "jcr:content/metadata/dc:title";

    String resourcePath = "";
    String title = i18n.get("No file");
    try {
        Node testNode = currentNode;
        resourcePath = resource.getPath();

        if(testNode.hasNode(DEFAULT_RENDITION)) {
            resourcePath += "/"+DEFAULT_RENDITION;
        } else {
            resourcePath += "/"+ORIGINAL_RENDITION;
        }


        if(testNode.hasProperty(DAM_ASSET_TITLE)){
            title = testNode.getProperty(DAM_ASSET_TITLE).getString();
        }else{
            title = testNode.getName();
        }

    } catch(Exception e) {
        response.sendError(404);
    }

%><!DOCTYPE html>
<html class="coral-App" lang="<%= LocaleUtil.toRFC4646(request.getLocale()).toLowerCase() %>" data-i18n-dictionary-src="<%= request.getContextPath() %>/libs/cq/i18n/dict.{+locale}.json">
<head>
    <title>AEM Copy Editor | <%= title %></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <ui:includeClientLib categories="media.copyeditor"/>
    <sling:include resourceType="cq/gui/components/common/favicon"/>
    <script language="javascript">
        $(window).load(function(){
            media.CopyEditor.loadArticle("<%= resourcePath %>","<%= xssAPI.encodeForHTML(title) %>");
        });
    </script>
</head>
<body class="endor-Panel coral--light">
    <div class="foundation-content-current">
        <div class="endor-Panel-header foundation-layout-mode2">
            <nav class="foundation-layout-mode2-item foundation-layout-mode2-item-active endor-ActionBar mode-default" id="navbar"></nav>
        </div>
        <div id="editorbox" class="endor-Panel-content endor-Panel-content--actionBarHeight">
            <div id="epiceditor"></div>
        </div>
    </div>

<script id="navbar-template" type="x-handlebars-template">
    <div class="endor-ActionBar-left">
        <div class="stat"><%=i18n.get("Words")%>: <span id="word-count-field"></span> </div>
        <div class="stat"><%=i18n.get("Chars")%>: <span id="char-count-field"></span> </div>
    </div>
    <div class="endor-ActionBar-center"><div class="title">{{title}}</span></div></div>
    <div class="endor-ActionBar-right">
        <button class="fullscreen-button endor-ActionBar-item coral-Button coral-Button--secondary coral-Button--quiet"  title="<%=i18n.get("Toggle Fullscreen")%>" type="button">
            <i class="endor-ActionButton-icon coral-Icon coral-Icon--fullScreen"></i>
        </button>
        <button class="preview-button endor-ActionBar-item coral-Button coral-Button--secondary coral-Button--quiet"  title="<%=i18n.get("Toggle Preview")%>" type="button">
            <i class="endor-ActionButton-icon coral-Icon coral-Icon--preview"></i>
        </button>
        <button class="save-button endor-ActionBar-item coral-Button coral-Button--secondary coral-Button--quiet"  title="<%=i18n.get("Save")%>" type="button">
            <i class="endor-ActionButton-icon coral-Icon coral-Icon--save"></i>
        </button>
        <a title="<%=i18n.get("Help")%>" class="endor-ActionBar-item cq-projects-admin-create coral-Button coral-Button--secondary coral-Button--quiet" href="http://www.adobe.com/go/aem6_docs_text_formating__en" target="_blank">
            <i class="endor-ActionButton-icon coral-Icon coral-Icon--helpCircle"></i>
        </a>
    </div>
</script>
</body>
</html>

