<%@page session="false" %>
<%@include file="/libs/foundation/global.jsp"%>
<%@ page import="org.apache.sling.jcr.api.SlingRepository" %>
<%@ page import="com.day.cq.security.UserManager" %>
<%@ page import="com.day.cq.security.UserManagerFactory" %>
<%@ page import="com.day.cq.security.User" %>
<%@ page import="com.day.cq.security.Authorizable" %>
<%@ page import="com.day.cq.security.profile.Profile" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.apache.sling.commons.json.io.*" %>
<%@ page import="com.day.cq.commons.TidyJSONWriter" %><%
 
 
String userId = request.getParameter("first");
String password = request.getParameter("password");
String principalName = request.getParameter("principalName");

final SlingRepository repos = sling.getService(SlingRepository.class);
final UserManagerFactory umFactory = sling.getService(UserManagerFactory.class);

Session session = null;
Iterator<User> userIterator = null;
Iterator<Authorizable> authorizableIterator = null;
try
{
    // Ensure that the currently logged on user has admin privileges.
    session = repos.loginAdministrative(null);

    final UserManager um = umFactory.createUserManager(session);
    final TidyJSONWriter writer = new TidyJSONWriter(response.getWriter());

    //Add a new user to Adobe CQ
    um.createUser(userId, password, principalName) ;

    String Response = "User "+ userId + " was added to CQ";   

    //Send the data back to the client using a TidyJSONWriter object
    writer.setTidy("true".equals(request.getParameter("tidy")));
    writer.object();
    writer.key("key").value(Response);
    writer.endObject();

}
catch (Exception e)
{
    System.out.println("myajaxsample Exception Occured: " + e.getMessage());
}
finally
{
    session.logout(); 
    session = null;
}
%>
