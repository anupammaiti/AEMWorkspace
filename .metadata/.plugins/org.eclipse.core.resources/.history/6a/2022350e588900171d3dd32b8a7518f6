package org.myorg.portfolio.PDFService;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;

import javax.jcr.Session;

import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
//PDFBOX 
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.edit.PDPageContentStream;
import org.apache.pdfbox.pdmodel.font.PDFont;
import org.apache.pdfbox.pdmodel.font.PDType1Font;
import org.apache.sling.api.resource.ResourceResolver;
//Sling Imports
import org.apache.sling.api.resource.ResourceResolverFactory ;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory; 

//This is a component so it can provide or consume services
@Component
   
@Service
public class PDFServiceImpl implements PDFService {
  
      
/** Default log. */
protected final Logger log = LoggerFactory.getLogger(this.getClass());
           
private Session session;
               
//Inject a Sling ResourceResolverFactory
@Reference
private ResourceResolverFactory resolverFactory;
      
@Override
public String createPDF(String filename,String value) {
// This custom AEM service creates a PDF document using PDFBOX API and stores the PDF in the AEM JCR
          
try
{
    //Create the PDFBOx Object
    // Create a new empty document
    PDDocument document = new PDDocument();
  
    // Create a document and add a page to it
    PDPage page = new PDPage();
    document.addPage( page );
     
    log.info("GOT HERE");
  
    // Create a new font object selecting one of the PDF base fonts
    PDFont font = PDType1Font.HELVETICA_BOLD;
  
    // Start a new content stream which will "hold" the to be created content
    PDPageContentStream contentStream = new PDPageContentStream(document, page);
  
    // Define a text content stream using the selected font, moving the cursor and drawing the text "Hello World"
    contentStream.beginText();
    contentStream.setFont( font, 12 );
    contentStream.moveTextPositionByAmount( 100, 700 );
    contentStream.drawString( value );
    contentStream.endText();
  
    // Make sure that the content stream is closed:
    contentStream.close();
              
    //Save the PDF into the AEM DAM
    ByteArrayOutputStream out = new ByteArrayOutputStream();
                  
    document.save(out);
                  
    byte[] myBytes = out.toByteArray(); 
        InputStream is = new ByteArrayInputStream(myBytes) ; 
    String damLocation = writeToDam(is,filename);
    document.close();
              
    //....
    return damLocation; 
    }
catch(Exception e)
{
    e.printStackTrace();
}
    return null;
}
      
      
//Save the uploaded file into the Adobe CQ DAM
private String writeToDam(InputStream is, String fileName)
{
    try
    {
    //Invoke the adaptTo method to create a Session used to create a QueryManager
    ResourceResolver resourceResolver = resolverFactory.getAdministrativeResourceResolver(null);
      
  //Use AssetManager to place the file into the AEM DAM
    com.day.cq.dam.api.AssetManager assetMgr = resourceResolver.adaptTo(com.day.cq.dam.api.AssetManager.class);
    String newFile = "/content/dam/pdf/"+fileName ; 
    assetMgr.createAsset(newFile, is, "application/pdf", true);
     
    log.info("THE PDF Asset was placed into the DAM");       
  
               
    // Return the path to the document that was stored in CRX. 
    return newFile;
}
catch(Exception e)
{
    e.printStackTrace();
}
return null; 
}
}