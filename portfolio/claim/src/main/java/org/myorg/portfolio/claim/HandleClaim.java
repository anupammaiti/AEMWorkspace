/*
 *  Copyright 2015 Adobe Systems Incorporated
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

package org.myorg.portfolio.claim;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.rmi.ServerException;
import java.util.Dictionary;
 
import org.apache.felix.scr.annotations.Properties;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.sling.SlingServlet;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.servlets.SlingSafeMethodsServlet;
import org.apache.sling.commons.osgi.OsgiUtil;
import org.apache.sling.jcr.api.SlingRepository;
import org.apache.felix.scr.annotations.Reference;
import org.osgi.service.component.ComponentContext;
import javax.jcr.Session;
import javax.jcr.Node; 
import org.json.simple.JSONObject;
import java.util.UUID;
 
@SlingServlet(paths="/bin/mySearchServlet", methods = "POST", metatype=true)
public class HandleClaim extends org.apache.sling.api.servlets.SlingAllMethodsServlet {
     private static final long serialVersionUID = 2598426539166789515L;
      
     @Reference
     private SlingRepository repository;
      
     public void bindRepository(SlingRepository repository) {
            this.repository = repository; 
            }
           
     @Override
     protected void doPost(SlingHttpServletRequest request, SlingHttpServletResponse response) throws ServerException, IOException {
       
      try
      {
         //Get the submitted form data that is sent from the
              //CQ web page  
          String id = UUID.randomUUID().toString();
          String firstName = request.getParameter("firstName");
          String lastName = request.getParameter("lastName");
          String address = request.getParameter("address");
          String cat = request.getParameter("cat");
          String state = request.getParameter("state");
          String details = request.getParameter("details");
          String date = request.getParameter("date"); 
          String city = request.getParameter("city"); 
       
          //Encode the submitted form data to JSON
          JSONObject obj=new JSONObject();
          obj.put("id",id);
          obj.put("firstname",firstName);
          obj.put("lastname",lastName);
          obj.put("address",address);
          obj.put("cat",cat);
          obj.put("state",state);
          obj.put("details",details);
          obj.put("date",date);
          obj.put("city",city);
           
             //Get the JSON formatted data    
          String jsonData = obj.toJSONString();
           
             //Return the JSON formatted data
         response.getWriter().write(jsonData);
      }
      catch(Exception e)
      {
          e.printStackTrace();
      }
    }
}
