<%@page session="false"%><%@ page import="java.util.Locale,
                                          java.util.ResourceBundle,
                                          com.day.cq.i18n.I18n,
                                          com.day.cq.tagging.TagManager,
                                          com.day.cq.wcm.foundation.Search" %>
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

  Search component

  Draws the search form and evaluates a query

--%><%@include file="/libs/foundation/global.jsp" %><%
%><cq:setContentBundle source="page" /><%
    Search search = new Search(slingRequest);

    final Locale pageLocale = currentPage.getLanguage(true);
    final ResourceBundle resourceBundle = slingRequest.getResourceBundle(pageLocale);
    I18n i18n = new I18n(resourceBundle);

    String searchIn = (String) properties.get("searchIn");
    String requestSearchPath = request.getParameter("path");
    if (searchIn != null) {
        // only allow the "path" request parameter to be used if it
        // is within the searchIn path configured
        if (requestSearchPath != null && requestSearchPath.startsWith(searchIn)) {
            search.setSearchIn(requestSearchPath);
        } else {
            search.setSearchIn(searchIn);
        }
    } else if (requestSearchPath != null) {
        search.setSearchIn(requestSearchPath);
    }
    
    final String escapedQuery = xssAPI.encodeForHTML(search.getQuery());
    final String escapedQueryForAttr = xssAPI.encodeForHTMLAttr(search.getQuery());
    final String escapedQueryForHref = xssAPI.getValidHref(search.getQuery());

    pageContext.setAttribute("escapedQuery", escapedQuery);
    pageContext.setAttribute("escapedQueryForAttr", escapedQueryForAttr);
    pageContext.setAttribute("escapedQueryForHref", escapedQueryForHref);

    pageContext.setAttribute("search", search);
    TagManager tm = resourceResolver.adaptTo(TagManager.class);

    Search.Result result = null;
    try {
        result = search.getResult();
    } catch (RepositoryException e) {
        log.error("Unable to get search results", e);
    }
    pageContext.setAttribute("result", result);

    String nextText = properties.get("nextText", i18n.get("Next", "Next page"));
    String noResultsText = properties.get("noResultsText", i18n.get("Your search - <b>{0}</b> - did not match any documents.", null, escapedQuery));
    String previousText = properties.get("previousText", i18n.get("Previous", "Previous page"));
    String relatedSearchesText = properties.get("relatedSearchesText", i18n.get("Related searches:"));
    String resultPagesText = properties.get("resultPagesText", i18n.get("Results", "Search results"));
    String searchButtonText = properties.get("searchButtonText", i18n.get("Search", "Search button text"));
    String searchTrendsText = properties.get("searchTrendsText", i18n.get("Search Trends"));
    String similarPagesText = properties.get("similarPagesText", i18n.get("Similar Pages"));
    String spellcheckText = properties.get("spellcheckText", i18n.get("Did you mean:", "Spellcheck text if typo in search term"));

%><c:set var="trends" value="${search.trends}"/><c:set var="result" value="${result}"/><%
%><center>
  <form action="${currentPage.path}.html">
    <input size="41" maxlength="2048" name="q" value="${escapedQueryForAttr}"/>
    <input value="<%= xssAPI.encodeForHTMLAttr(searchButtonText) %>" type="submit"/>
  </form>
</center>
<br/>
<c:choose>
  <c:when test="${empty result && empty escapedQuery}">
  </c:when>
  <c:when test="${empty result.hits}">
    ${result.trackerScript}
    <c:if test="${result.spellcheck != null}">
      <p><%= xssAPI.encodeForHTML(spellcheckText) %> <a href="<c:url value="${currentPage.path}.html"><c:param name="q" value="${result.spellcheck}"/></c:url>"><b><c:out value="${result.spellcheck}"/></b></a></p>
    </c:if>
    <%= xssAPI.filterHTML(noResultsText) %>
    <span data-tracking="{event:'noresults', values:{'keyword': '<c:out value="${escapedQuery}"/>', 'results':'zero', 'executionTime':'${result.executionTime}'}, componentPath:'<%=resource.getResourceType()%>'}"></span>
  </c:when>
  <c:otherwise>
    <span data-tracking="{event:'search', values:{'keyword': '<c:out value="${escapedQuery}"/>', 'results':'${result.totalMatches}', 'executionTime':'${result.executionTime}'}, componentPath:'<%=resource.getResourceType()%>'}"></span>
    ${result.trackerScript}
    <%= xssAPI.filterHTML(properties.get("statisticsText", i18n.get("Results {0} - {1} of {2} for <b>{3}</b> ({4} seconds)", "Search query information", result.getStartIndex() + 1, result.getStartIndex() + result.getHits().size(), result.getTotalMatches(), escapedQuery, result.getExecutionTime()))) %>
    <div class="searchRight">
          <c:if test="${fn:length(trends.queries) > 0}">
              <p><%= xssAPI.encodeForHTML(searchTrendsText) %></p>
              <div class="searchTrends">
                  <c:forEach var="query" items="${trends.queries}">
                      <a href="<c:url value="${currentPage.path}.html"><c:param name="q" value="${query.query}"/></c:url>"><span style="font-size:${query.size}px"><c:out value="${query.query}"/></span></a>
                  </c:forEach>
              </div>
          </c:if>

          <c:if test="${result.facets.languages.containsHit}">
              <p><%= i18n.get("Languages") %></p>
              <c:forEach var="bucket" items="${result.facets.languages.buckets}">
                  <c:set var="bucketValue" value="${bucket.value}"/>
                  <c:set var="label" value='<%= new java.util.Locale((String) pageContext.getAttribute("bucketValue")).getDisplayLanguage(request.getLocale()) %>'/>
                  <c:choose>
                      <c:when test="${param.language != null}">
                        ${label} (${bucket.count}) - <a title="filter results" href="<c:url value="${currentPage.path}.html"><c:param name="q" value="${escapedQueryForHref}"/></c:url>">remove filter</a>
                      </c:when>
                      <c:otherwise>
                          <a title="filter results" href="
                            <c:url value="${currentPage.path}.html">
                                <c:param name="q" value="${escapedQueryForHref}"/>
                                <c:param name="language" value="${bucket.value}"/>
                            </c:url>">
                            ${label} (${bucket.count})
                          </a>
                      </c:otherwise>
                  </c:choose><br/>
              </c:forEach>
          </c:if>

          <c:if test="${result.facets.tags.containsHit}">
              <p><%=i18n.get("Tags")%></p>
              <c:forEach var="bucket" items="${result.facets.tags.buckets}">
                  <c:set var="bucketValue" value="${bucket.value}"/>
                  <c:set var="tag" value="<%= tm.resolve((String) pageContext.getAttribute("bucketValue")) %>"/>
                  <c:if test="${tag != null}">
                      <c:set var="label" value="${tag.title}"/>
                      <c:choose>
                          <c:when test="<%= request.getParameter("tag") != null && java.util.Arrays.asList(request.getParameterValues("tag")).contains(pageContext.getAttribute("bucketValue")) %>">
                            ${label} (${bucket.count}) - <a title="filter results" href="<c:url value="${currentPage.path}.html"><c:param name="q" value="${escapedQueryForHref}"/></c:url>">remove filter</a>
                          </c:when>
                          <c:otherwise>
                              <a title="filter results" href="
                            <c:url value="${currentPage.path}.html">
                                <c:param name="q" value="${escapedQueryForHref}"/>
                                <c:param name="tag" value="${bucket.value}"/>
                            </c:url>">
                                      ${label} (${bucket.count})
                              </a>
                          </c:otherwise>
                      </c:choose><br/>
                  </c:if>
              </c:forEach>
          </c:if>

          <c:if test="${result.facets.mimeTypes.containsHit}">
              <jsp:useBean id="fileTypes" class="com.day.cq.wcm.foundation.FileTypes"/>
              <p><%=i18n.get("File types")%></p>
              <c:forEach var="bucket" items="${result.facets.mimeTypes.buckets}">
                  <c:set var="bucketValue" value="${bucket.value}"/>
                  <c:set var="label" value="${fileTypes[bucket.value]}"/>
                  <c:choose>
                      <c:when test="<%= request.getParameter("mimeType") != null && java.util.Arrays.asList(request.getParameterValues("mimeType")).contains(pageContext.getAttribute("bucketValue")) %>">
                        ${label} (${bucket.count}) - <a title="filter results" href="<c:url value="${currentPage.path}.html"><c:param name="q" value="${escapedQueryForHref}"/></c:url>">remove filter</a>
                      </c:when>
                      <c:otherwise>
                          <a title="filter results" href="
                            <c:url value="${currentPage.path}.html">
                                <c:param name="q" value="${escapedQueryForHref}"/>
                                <c:param name="mimeType" value="${bucket.value}"/>
                            </c:url>">
                                  ${label} (${bucket.count})
                          </a>
                      </c:otherwise>
                  </c:choose><br/>
              </c:forEach>
          </c:if>

          <c:if test="${result.facets.lastModified.containsHit}">
              <p><%=i18n.get("Last Modified")%></p>
              <c:forEach var="bucket" items="${result.facets.lastModified.buckets}">
                  <c:choose>
                      <c:when test="${param.from == bucket.from && param.to == bucket.to}">
                        ${bucket.value} (${bucket.count}) - <a title="filter results" href="<c:url value="${currentPage.path}.html"><c:param name="q" value="${escapedQueryForHref}"/></c:url>">remove filter</a>
                      </c:when>
                      <c:otherwise>
                          <a title="filter results" href="
                            <c:url value="${currentPage.path}.html">
                                <c:param name="q" value="${escapedQueryForHref}"/>
                                <c:param name="from" value="${bucket.from}"/>
                                <c:if test="${bucket.to != null}">
                                    <c:param name="to" value="${bucket.to}"/>
                                </c:if>
                            </c:url>">
                                  ${bucket.value} (${bucket.count})
                          </a>
                      </c:otherwise>
                  </c:choose><br/>
              </c:forEach>
          </c:if>
      </div>

      <c:if test="${fn:length(search.relatedQueries) > 0}">
        <br/><br/>
        <%= xssAPI.encodeForHTML(relatedSearchesText) %>
        <c:forEach var="rq" items="${search.relatedQueries}">
            <a style="margin-right:10px" href="${currentPage.path}.html?q=${rq}"><c:out value="${rq}"/></a>
        </c:forEach>
      </c:if>
      <br/>
      <c:forEach var="hit" items="${result.hits}" varStatus="status">
        <br/>
        <c:if test="${hit.extension != \"\" && hit.extension != \"html\"}">
            <span class="icon type_${hit.extension}"><img src="/etc/designs/default/0.gif" alt="*"></span>
        </c:if>
        <a href="${hit.URL}" onclick="trackSelectedResult(this, ${status.index + 1})">${hit.title}</a>
        <div>${hit.excerpt}</div>
        ${hit.URL}<c:if test="${!empty hit.properties['cq:lastModified']}"> - <c:catch><fmt:formatDate value="${hit.properties['cq:lastModified'].time}" dateStyle="medium"/></c:catch></c:if> - <a href="${hit.similarURL}"><%= xssAPI.encodeForHTML(similarPagesText) %></a>
        <br/>
      </c:forEach>
      <br/>
      <c:if test="${fn:length(result.resultPages) > 1}">
        <%= xssAPI.encodeForHTML(resultPagesText) %>
        <c:if test="${result.previousPage != null}">
          <a href="${result.previousPage.URL}"><%= xssAPI.encodeForHTML(previousText) %></a>
        </c:if>
        <c:forEach var="page" items="${result.resultPages}">
          <c:choose>
            <c:when test="${page.currentPage}">${page.index + 1}</c:when>
            <c:otherwise>
              <a href="${page.URL}">${page.index + 1}</a>
            </c:otherwise>
          </c:choose>
        </c:forEach>
        <c:if test="${result.nextPage != null}">
          <a href="${result.nextPage.URL}"><%= xssAPI.encodeForHTML(nextText) %></a>
        </c:if>
      </c:if>
  </c:otherwise>
</c:choose>
