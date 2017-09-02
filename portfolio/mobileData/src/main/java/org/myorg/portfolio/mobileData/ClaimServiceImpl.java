package org.myorg.portfolio.mobileData;

import java.util.Iterator;

import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Service;
import javax.jcr.RepositoryException;
import org.apache.felix.scr.annotations.Activate;
import org.apache.felix.scr.annotations.Reference;
import org.apache.jackrabbit.commons.JcrUtils;
import org.osgi.service.component.ComponentContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.apache.sling.jcr.api.SlingRepository;
import javax.jcr.RepositoryException;
import javax.jcr.Session;
import javax.jcr.Node; 
import org.apache.jackrabbit.commons.JcrUtils;
import java.util.Iterator;
import java.util.UUID;
  
//This is a component so it can provide or consume services
@Component
// This component provides the service defined through the interface
@Service
 
public class ClaimServiceImpl implements ClaimService {
     
     
    /** Default log. */
    protected final Logger log = LoggerFactory.getLogger(this.getClass());
          
    @Reference
    private SlingRepository repository;
          
    public void bindRepository(SlingRepository repository) {
        this.repository = repository; 
        }
 
    //Creates a new claim (submitted from a mobile device) and returns a 
    //claim identifier value
    public String createClaim(String last, String first, String date,
            String address, String city, String state, String cat,
            String details) {
        try { 
            Session session = this.repository.loginAdministrative(null);
                       
            //Generate claim Id - this method returns this value
            String uuid = UUID.randomUUID().toString();
             
            //Create a node that represents the root node
            Node root = session.getRootNode(); 
                        
            //Get the content node in the JCR
            Node content = root.getNode("content");
                         
            //Determine if the content/claim node exists
            Node claimRoot = null;
            int claimRec = doesClaimExist(content);
                                               
            //-1 means that content/claim does not exist
            if (claimRec == -1)
             {
               //content/claim does not exist -- create it
                claimRoot = content.addNode("claim");
               }
               else
               {
               //content/claim does exist -- retrieve it
                claimRoot = content.getNode("claim");
               }
                         
             String claimId = uuid; //assign claim id
                         
             //Store claim data submitted from the CQ mobile form
            Node claimNode = claimRoot.addNode("claim_"+uuid); 
                  
            //make sure name of node is unique
            //String last, String first, String date, String address, String city, String state, String cat,String details );
            claimNode.setProperty("id", claimId); 
            claimNode.setProperty("firstName", first); 
            claimNode.setProperty("lastName", last); 
            claimNode.setProperty("date", date);  
            claimNode.setProperty("address", address);
            claimNode.setProperty("city", city);
            claimNode.setProperty("state", state);
            claimNode.setProperty("cat", cat);
            claimNode.setProperty("details", details);
                                       
            // Save the session changes and log out
            session.save(); 
            session.logout();
            return claimId; 
            }
          
         catch(RepositoryException  e){
             log.error("RepositoryException: " + e);
              }
         return "no claim id" ; 
         } 
 
    /*
     * Determines if the content/claim node exists 
     * This method returns these values:
     * -1 - if content/claim does not exist
     * 0 - if content/claim node exists; however, contains no children
     * number - the number of children that the content/claim node contains
    */
    private int doesClaimExist(Node content)
    {
        try
        {
            int index = 0 ; 
            int childRecs = 0 ; 
              
        java.lang.Iterable<Node> claimNode = JcrUtils.getChildNodes(content, "claim");
        Iterator it = claimNode.iterator();
                   
        //only going to be 1 content/claim node if it exists
        if (it.hasNext())
            {
            //Count the number of child nodes in content/claim
            Node claimRoot = content.getNode("claim");
            Iterable itCust = JcrUtils.getChildNodes(claimRoot); 
            Iterator childNodeIt = itCust.iterator();
                  
            //Count the number of claim child nodes 
            while (childNodeIt.hasNext())
            {
                childRecs++;
                childNodeIt.next();
            }
             return childRecs; 
           }
        else
            return -1; //content/claim does not exist
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return 0;
     }
    }
