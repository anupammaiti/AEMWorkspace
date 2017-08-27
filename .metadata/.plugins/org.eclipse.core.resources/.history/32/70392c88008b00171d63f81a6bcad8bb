<%--
    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.
--%><%
%><%@page session="false"%><%
%><%@page import="org.apache.sling.api.request.RequestParameterMap"%><%
%><%@ taglib prefix="cq" uri="http://www.day.com/taglibs/cq/1.0" %><%
%><cq:defineObjects /><%
%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
    <head>
        <meta http-equiv="content-type" content="text/html; charset=UTF-8">
        <%
            RequestParameterMap params = slingRequest.getRequestParameterMap();
            int debug = (params.getValue("debug") != null) ? Integer.valueOf(params.getValue("debug").getString()) : 0;
        %>
        <title>AEM Dialog Editor</title>
        <cq:includeClientLib categories="cq.widgets,cq.tagging,cq.scaffolding"/>
        <script type="text/javascript">
            CQ.I18n.init({ "locale": "<%= request.getLocale() %>" });
            
            CQ.Ext.onReady(function() {
                var debug = <%= debug %>;

                var path = "<%= slingRequest.getContextPath() %><%= currentNode.getPath() %>";
                var editor = CQ.Util.build({ "xtype": "dialogeditor" }, null, null, debug);
                editor.loadDialog(path + ".infinity.json");
                editor.on("save", function(dlgCfg) {
                    var json = CQ.Ext.util.JSON.encode(dlgCfg);
                    CQ.HTTP.post(path,
                        function(options, success, xhr) {
                            // notify user about success
                            var response = CQ.HTTP.buildPostResponseFromHTML(xhr.responseText);
                            if (CQ.utils.HTTP.isOk(response)) {
                                CQ.Notification.notifyFromResponse(response);
                            }
                        },{
                            "json":json,
                            "_charset_":"utf-8"
                        }
                     );
                });
            });
        </script>
    </head>
    <body style="margin:0;"><div id="CQ"></div></body>
</html>