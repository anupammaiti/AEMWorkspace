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
<%@ page import="com.day.cq.commons.TidyJSONWriter" %>
 
<%
 
//Local variables
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
     
    userIterator = um.getUsers();
    List<User> users = new ArrayList<User>();
    User tmpUser;
     
    // copy iterator into a List for additional manipulations.
    while(userIterator.hasNext())
    {
        tmpUser = userIterator.next();
        users.add(tmpUser);
         
    }
     
    //Begin writing JSON response
    writer.setTidy("true".equals(request.getParameter("tidy")));
    writer.object();
    writer.key("page").value(1);
    writer.key("total").value(users.size());
    writer.key("rows").array();
     
     
    for(int i=0; i < users.size(); i++)
    {
         
        User aUser = users.get(i);
        Profile aProfile = aUser.getProfile();
         
        writer.object();
        writer.key("id").value(aUser.getID());
        writer.key("cell").array();
        writer.value(aUser.getID());
        writer.value(aProfile.getGivenName());
        writer.value(aProfile.getFamilyName());
        writer.value(aProfile.getPrimaryMail());
        writer.endArray();
        writer.endObject();
    }
         
        writer.endArray();
        writer.endObject();
        session.logout();
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
