<%@page session="false"%><div class="form_row">
      <div class="form_leftcol">
          <div class="form_leftcollabel"><label for="<%= xssAPI.encodeForHTMLAttr(path) %>"><%= xssAPI.encodeForHTML(title) %></label></div>
          <div class="form_leftcolmark <%= required ? "form_required" : ""%>"><%= required ? "*" : "&nbsp;" %></div>
      </div>
      <div class="form_rightcol"><%
      final String rows = properties.get("rows", "");
      if ( rows.length() == 0 || rows.equals("1") ) {
    	  %><input class="geo textinput" <%
    	        %>name="<%= xssAPI.encodeForHTMLAttr(nodeName) %>" <%
    	        %>value="<%= xssAPI.encodeForHTMLAttr(value)%>" <%
    	        %>size="<%= xssAPI.getValidInteger(cols, 35) %>" <%
                if (width.length() > 0) {
                    %>style="width:<%= xssAPI.getValidInteger(width, 100) %>px;" <%
                }
    	  %>><%
      } else {
    	  %><textarea class="geo" <%
    	        %>name="<%= xssAPI.encodeForHTMLAttr(nodeName) %>" <%
    	        %>rows="<%= xssAPI.getValidInteger(rows, 1) %>" <%
    	        %>cols="<%= xssAPI.getValidInteger(cols, 35) %>" <%
                if (width.length() > 0) {
                    %>style="width:<%= xssAPI.getValidInteger(width, 100) %>px;" <%
                }
    	  %>><%= xssAPI.encodeForHTML(value) %></textarea><%
      }
%></div>
</div>
