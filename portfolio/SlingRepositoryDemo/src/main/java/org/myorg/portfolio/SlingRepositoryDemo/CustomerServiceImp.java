package org.myorg.portfolio.SlingRepositoryDemo;

import java.util.Iterator;

import javax.jcr.Node;
import javax.jcr.RepositoryException;
import javax.jcr.Session;

import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.jackrabbit.commons.JcrUtils;
import org.apache.sling.jcr.api.SlingRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
 
//This is a component so it can provide or consume services
@Component
// This component provides the service defined through the interface
@Service
 
public class CustomerServiceImp implements CustomerService {
 
/** Default log. */
protected final Logger log = LoggerFactory.getLogger(this.getClass());
     
@Reference
private SlingRepository repository;
     
public void bindRepository(SlingRepository repository) {
    this.repository = repository; 
    }
     
//Stores customer data in the Adobe CQ JCR
public int injestCustData(String firstName, String lastName, String phone, String desc)
{
    int num  = 0; 
    try { 
    Session session = this.repository.loginAdministrative(null);
              
        //Create a node that represents the root node
    Node root = session.getRootNode(); 
               
    //Get the content node in the JCR
    Node content = root.getNode("content");
                
    //Determine if the content/customer node exists
    Node customerRoot = null;
    int custRec = doesCustExist(content);
                                      
    //-1 means that content/customer does not exist
    if (custRec == -1)
     {
       //content/customer does not exist -- create it
        customerRoot = content.addNode("customer");
       }
       else
       {
       //content/customer does exist -- retrieve it
       customerRoot = content.getNode("customer");
       }
                
     int custId = custRec+1; //assign a new id to the customer node
                
     //Store content from the client JSP in the JCR
    Node custNode = customerRoot.addNode("customer"+firstName+lastName+custId); 
         
        //make sure name of node is unique
    custNode.setProperty("id", custId); 
    custNode.setProperty("firstName", firstName); 
    custNode.setProperty("lastName", lastName); 
    custNode.setProperty("phone", phone);  
    custNode.setProperty("desc", desc);
                              
    // Save the session changes and log out
    session.save(); 
    session.logout();
    return custId; 
    }
 
 catch(RepositoryException  e){
     log.error("RepositoryException: " + e);
      }
 return 0 ; 
 } 
 
/*
 * Determines if the content/customer node exists 
 * This method returns these values:
 * -1 - if customer does not exist
 * 0 - if content/customer node exists; however, contains no children
 * number - the number of children that the content/customer node contains
*/
private int doesCustExist(Node content)
{
    try
    {
        int index = 0 ; 
        int childRecs = 0 ; 
         
    java.lang.Iterable<Node> custNode = JcrUtils.getChildNodes(content, "customer");
    Iterator it = custNode.iterator();
              
    //only going to be 1 content/customer node if it exists
    if (it.hasNext())
        {
        //Count the number of child nodes in content/customer
        Node customerRoot = content.getNode("customer");
        Iterable itCust = JcrUtils.getChildNodes(customerRoot); 
        Iterator childNodeIt = itCust.iterator();
             
        //Count the number of customer child nodes 
        while (childNodeIt.hasNext())
        {
            childRecs++;
            childNodeIt.next();
        }
         return childRecs; 
       }
    else
        return -1; //content/customer does not exist
    }
    catch(Exception e)
    {
    log.error(e.getMessage());
    }
    return 0;
 }
}
