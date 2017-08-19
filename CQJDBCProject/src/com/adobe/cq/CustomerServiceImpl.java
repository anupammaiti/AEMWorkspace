package com.adobe.cq;

import com.adobe.cq.ConnectionHelper;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

	public class CustomerServiceImpl {
     
    public int injestCustData(String firstName, String lastName, String phone, String desc)
    {
            Connection c = null;
            int rowCount= 0; 
            try {
                                       
                  // Create a Connection object
                  c =  ConnectionHelper.getConnection();
              
                   ResultSet rs = null;
                   Statement s = c.createStatement();
                   Statement scount = c.createStatement();
                    
                   //Use prepared statements to protected against SQL injection attacks
                   PreparedStatement pstmt = null;
                   PreparedStatement ps = null; 
                              
                   //Set the query and use a preparedStatement
                   String query = "Select * FROM Customer";
                   pstmt = c.prepareStatement(query); 
                   rs = pstmt.executeQuery();
                    
                   while (rs.next()) 
                        rowCount++;
                                 
                   //Set the PK value
                   int pkVal = rowCount + 2; 
                    
                   String insert = "INSERT INTO Customer(custId,custFirst,custLast,custDesc,custAddress) VALUES(?, ?, ?, ?, ?);";
                   ps = c.prepareStatement(insert);
                   ps.setInt(1, pkVal);
                   ps.setString(2, firstName);
                   ps.setString(3, lastName);
                   ps.setString(4, phone);
                   ps.setString(5, desc);
                   
                   
//                   CREATE TABLE Customer(
//                		   custId   INT  ,            
//                		   custFirst VARCHAR (20) ,    
//                		   custLast  VARCHAR (20)  ,
//                		   custDesc  VARCHAR (20) ,
//                		   custAddress   VARCHAR (20),       
//                		   PRIMARY KEY (custId )
//                		);
                   
                   ps.execute();
                   return pkVal;
            }
            catch (Exception e) {
              e.printStackTrace();
             }
            finally {
              ConnectionHelper.close(c);
        }
            return 0; 
     }
    
  
}
