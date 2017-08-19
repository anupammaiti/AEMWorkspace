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

  MVT (Multivariate testing) component

--%><%@page import="java.text.MessageFormat,
                    java.util.ArrayList,
                    java.util.List,
                    java.util.Random,
                    com.day.cq.i18n.I18n,
                    com.day.cq.wcm.api.WCMMode,
                    com.day.cq.wcm.api.components.DropTarget,
                    com.day.cq.wcm.api.components.Toolbar,
                    com.day.cq.wcm.core.mvt.MVTStatistics" %><%
%><%@include file="/libs/foundation/global.jsp"%><%

    //drop target css class = dd prefix + name of the drop target in the edit config
    String ddClassName = DropTarget.CSS_CLASS_PREFIX + "mvt " + DropTarget.CSS_CLASS_PREFIX + "page";
    String id = currentNode.getPath() + "_mvt";
    MVTStatistics mvtStats = sling.getService(MVTStatistics.class);
    String trackURL = null;
    if (mvtStats != null && mvtStats.getTrackingURI() != null) {
    	trackURL = mvtStats.getTrackingURI().toString();
    }
    if (WCMMode.fromRequest(request) == WCMMode.EDIT) {
        %><cq:includeClientLib categories="cq.mvt"/><%
    }

    // add buttons to edit bar
    if (editContext != null && WCMMode.fromRequest(request) == WCMMode.EDIT) {
        Toolbar tb = editContext.getEditConfig().getToolbar();
        tb.add(0, new Toolbar.Label("MVT"));
    }

    String href = null;
    if (currentNode.hasProperty("href")) {
        href = currentNode.getProperty("href").getString();
        if (href.startsWith("/")) {
            href = request.getContextPath() + href + ".html";
        }
    }

    String size = "";
    if (currentNode.hasProperty("width")) {
        size += " width=\"" + currentNode.getProperty("width").getString() + "\"";
    }
    if (currentNode.hasProperty("height")) {
        size += " height=\"" + currentNode.getProperty("height").getString() + "\"";
    }

    NodeIterator images = currentNode.getNodes("image*");
    int numDistinctBanners = 0;
    List<Banner> banners = new ArrayList<Banner>();
    while (images.hasNext()) {
        Node banner = images.nextNode();
        if (!banner.hasProperty("fileReference")) {
            continue;
        }
        String fileRef = request.getContextPath() + banner.getProperty("fileReference").getString();
        String title = banner.hasProperty("jcr:title") ? banner.getProperty("jcr:title").getString() : "";
        int bias = banner.hasProperty("bias") ?  (int) banner.getProperty("bias").getLong() : 1;
        Banner b = new Banner(fileRef, title, bias, numDistinctBanners);
        for (int i = 0; i < bias; i++) {
            banners.add(b);
        }
        numDistinctBanners++;
    }

    String bannerSelector = "0";
    String msgPattern = I18n.get(slingRequest, "Showing {0} of {1} ({2}/{3})");
    String fileRef = "";
    long impressions = 0;
    long clicks = 0;
    double ctr = 0.0;
    int bannerIdx = 0;
    if (WCMMode.fromRequest(request) == WCMMode.EDIT && mvtStats != null) {
        if (banners.isEmpty()) {
            if (editContext != null) {
                editContext.getEditConfig().getToolbar().add(new Toolbar.Label("Showing none"));
            }
        } else {
            // pick banner on the server side and display statistics in tool bar
            int idx = new Random().nextInt(banners.size());
            Banner b = banners.get(idx);
            fileRef = b.fileRef;
            for (Object[] result : mvtStats.report(currentPage)) {
                String ref = (String) result[0];
                if (ref.equals(b.fileRef)) {
                    impressions = (Long) result[1];
                    clicks = (Long) result[2];
                    ctr = (Double) result[3];
                    break;
                }
            }
            // fix impressions, the value does not reflect the current impression
            impressions++;
            bannerIdx = b.idx;
            // add info
            String msg = MessageFormat.format(msgPattern, b.idx + 1, numDistinctBanners, clicks, impressions);
            if (editContext != null) {
                editContext.getEditConfig().getToolbar().add(new Toolbar.Label(msg));

            }
            bannerSelector = String.valueOf(idx);
        }

    } else {
        // let client side javascript decide
        bannerSelector = "Math.floor(Math.random() * banners.length)";
    }

%><div class="<%= ddClassName %>" id="<%= id %>"><%
    if (banners.isEmpty()) {
        %><img src="/etc/designs/default/0.gif" class="cq-image-placeholder"/><%
    }
%></div><script type="text/javascript">
    function buildMVTBannerList() {
        var banners = new Array();
        var banner;
    <%
        if (href != null) { %>
        banners.href = '<%= href %>';
    <%  }
        Banner previous = null;
        int i = 0;
        for (Banner b : banners) {
            if (b != previous) {
    %>
        banner = new Object();
        banner.fileRef = '<%= b.fileRef %>';
        banner.title = '<%= b.title %>';
        banner.bias = <%= b.bias %>;
    <%
            }
    %>
        banners[<%= i++ %>] = banner;
    <%
        previous = b;
        }
    %>
        if (banners.length > 0) {
            var randomBanner = banners[<%= bannerSelector %>];
            if (window.randomBannerList) {
                window.randomBannerList += '|' + randomBanner.fileRef;
            } else {
                window.randomBannerList = randomBanner.fileRef;
            }
            var div = document.getElementById('<%= id %>');
            var inner = '<img alt="' + randomBanner.title + '" src="' + CQ.shared.HTTP.getXhrHookedURL(randomBanner.fileRef) + '"<%= size %>/>';
            if (banners.href) {
                inner = '<a href="' + CQ.shared.HTTP.getXhrHookedURL(banners.href) + '" onclick="bannerClicked()">' + inner + '</a>';
            }
            div.innerHTML = inner;
        }
    };
<%
    if (WCMMode.fromRequest(request) == WCMMode.EDIT) {
    // update edit bar on refresh
%>
    var mvtOnReady = function() {
        function updateEditBar() {
            var editBar = CQ.WCM.getEditable('<%= currentNode.getPath() %>');
            var toolbarItems = editBar.items.get(0).items;
            for (var i = 0; i < toolbarItems.getCount(); i++) {
                var tbItem = toolbarItems.get(i);
                if (tbItem.el && tbItem.el.dom && tbItem.el.dom.innerHTML && tbItem.el.dom.innerHTML.indexOf("Showing") == 0) {
                    tbItem.el.dom.innerHTML = CQ.Util.patchText('<%= msgPattern %>',
                            ['<%= bannerIdx + 1 %>', '<%= numDistinctBanners %>', '<%= clicks %>', '<%= impressions %>']);
                }
            }
        }
<%
        if (trackURL != null) {
%>
            window.randomBannerList = null;
            CQ.HTTP.get('<%= trackURL %>/view?path=' + encodeURIComponent('<%= currentPage.getPath() %>') + '&vars=' + encodeURIComponent('<%= fileRef %>'), function(){updateEditBar();});
<%
       }
        %>
        buildMVTBannerList();
    };
    if( CQ.Ext.isReady) {
        mvtOnReady.call();
    } else {
        CQ.WCM.onEditableReady("<%= currentNode.getPath() %>",mvtOnReady);
    }
        <%
    } else {
%>
	$CQ(buildMVTBannerList);
	$CQ(trackMVTImpression);
<% } %>

    function bannerClicked() {
    <% if (trackURL != null) { %>
        var trackImg = new Image();
        trackImg.src = CQ.shared.HTTP.getXhrHookedURL('<%= trackURL %>/click?path=' + encodeURIComponent('<%= currentPage.getPath() %>') + '&vars=' + encodeURIComponent(window.randomBannerList));
    <% }%>
    };

</script><%!

    private class Banner {

        final String fileRef;
        final String title;
        final int bias;
        final int idx;

        Banner(String fileRef, String title, int bias, int idx) {
            this.fileRef = fileRef;
            this.title = title;
            this.bias = bias;
            this.idx = idx;
        }
    }
%>
