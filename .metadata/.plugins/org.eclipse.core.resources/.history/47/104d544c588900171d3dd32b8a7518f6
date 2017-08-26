<%@page session="false"%><%--
  Copyright 1997-2009 Day Management AG
  Barfuesserplatz 6, 4001 Basel, Switzerland
  All Rights Reserved.

  This software is the confidential and proprietary information of
  Day Management AG, ("Confidential Information"). You shall not
  disclose such Confidential Information and shall use it only in
  accordance with the terms of the license agreement you entered into
  with Day.

  ==============================================================================
--%><%@include file="/libs/foundation/global.jsp"%><%
%><%@include file="../init.jsp"%><%
%><%@page import="com.day.cq.wcm.foundation.forms.LayoutHelper" %><%
%><%@page import="com.day.cq.wcm.foundation.forms.FormsHelper" %><%
%>    
<div class="form_row">
   <% LayoutHelper.printTitle("", properties.get("title", "Name"), false, out); %>
   <div class="form_rightcol">
     <div class="form_rightcol_left"><c:out value="<%=properties.get("givenNameTitle", "Given Name")%>"/></div>
     <div class="form_rightcol_middle">&nbsp;</div>
     <div class="form_rightcol_right"><c:out value="<%=properties.get("middleNameTitle", "Middle Name")%>"/></div>
   </div>
</div>
<div class="form_row">
   <% LayoutHelper.printTitle("", null, false, out); %>
   <div class="form_rightcol">
     <div class="form_rightcol_left"><input class="geos" name="./givenName" size="16" value="<c:out value="<%=
         profile==null? "": 
             profile.getGivenName()==null? "":profile.getGivenName()%>"/>"></div>
     <div class="form_rightcol_middle">&nbsp;</div>
     <div class="form_rightcol_right"><input class="geos" name="./middleName" size="5" value="<c:out value="<%=
         profile==null? "": 
             profile.getMiddleName()==null? "": profile.getMiddleName()%>"/>"></div>
   </div>
</div>
<div class="form_row">
   <% LayoutHelper.printTitle("", null, false, out); %>
   <div class="form_rightcol"><c:out value="<%=properties.get("familyNameTitle", "Family Name")%>"/></div>
</div>
<div class="form_row">
   <% LayoutHelper.printTitle("", null, false, out); %>
   <div class="form_rightcol"><input class="geo textinput" name="./familyName" size="35" value="<c:out value="<%=
       profile==null? "": 
           profile.getFamilyName()==null? "" : profile.getFamilyName()%>"/>"></div>
</div>
