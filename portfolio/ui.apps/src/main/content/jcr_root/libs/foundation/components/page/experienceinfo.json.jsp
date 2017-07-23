<%@page session="false"%><%@page import="java.util.Iterator,
                    java.util.HashMap,
                    com.day.cq.commons.LabeledResource,
                    org.apache.sling.commons.json.io.JSONWriter,
                    com.day.text.Text,
                    com.day.cq.mcm.api.MapFilter,
                    com.day.cq.mcm.api.MCMUtil"
%><%@include file="/libs/foundation/global.jsp" %><%

				MapFilter mapFilter = (MapFilter) request.getAttribute("cq.experienceinfofilter");
				HashMap<String, Object> values = new HashMap<String, Object>();

                LabeledResource lr = resource.getParent().adaptTo(LabeledResource.class);

                String name = Text.getName(resource.getParent().getPath());
                String text;
                if (lr == null) {
                    text = name;
                } else {
                    text = (lr.getTitle() == null)
                            ? name
                            : lr.getTitle();
                }
                if (text != null) {
                    text = text.replaceAll("<", "&lt;");
                }
                
                values.put("type", "page");

                values.put("id", name);

                if (lr != null && lr.getDescription() != null) {
                	values.put("description", lr.getDescription());
                }
                
                values.put("experienceTitle", text);

                values.put("analyzeUrl", resource.getParent().getPath());
                values.put("simulateUrl", "");
                
                ValueMap pageVM = resource.adaptTo(ValueMap.class);
                values.put("lastModifiedDate", pageVM.get("cq:lastModified", String.class));
                String userId = pageVM.get("cq:lastModifiedBy", String.class);
                    String userName = MCMUtil.getUserId(resource.getResourceResolver(), userId);
                    if (userName != null) {
                        values.put("lastModifiedByTitle", userName);
                    }
                
                if (mapFilter != null && !mapFilter.filter(values)) {
                    request.setAttribute("cq.notincludedexperience", "true");
                } else {
                    JSONWriter jsonWriter = new JSONWriter(response.getWriter());
                    MCMUtil.writeMapAsJsonObject(jsonWriter, values);                
                }
%>
