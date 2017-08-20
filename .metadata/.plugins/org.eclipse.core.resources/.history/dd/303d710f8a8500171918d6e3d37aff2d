<%@page session="false"%><div class="form_row">
      <div class="form_leftcol">
          <div class="form_leftcollabel"><label for="<%= xssAPI.encodeForHTMLAttr(path) %>"><%= xssAPI.encodeForHTML(title) %></label></div>
          <div class="form_leftcolmark <%= required ? "form_required" : ""%>"></div>
      </div>
      <div class="form_rightcol">
        <select class="geo" name="<%= xssAPI.encodeForHTMLAttr(path) %>" <%
            if (width.length() > 0) {
                %>style="width:<%= xssAPI.getValidInteger(width, 100) %>px;" <%
            }
        %>><%
        for(String key : displayOptions.keySet()) {
            final String v = key;
            final String t = displayOptions.get(key);
            if (v.equals(value)) {
                %>
                <option value="<%= xssAPI.encodeForHTMLAttr(v) %>" selected><%= xssAPI.encodeForHTML(t) %></option><%
            } else {
                %>
                <option value="<%= xssAPI.encodeForHTMLAttr(v) %>"><%= xssAPI.encodeForHTML(t) %></option><%
            }
        }
        %>
        </select></div>
</div>
