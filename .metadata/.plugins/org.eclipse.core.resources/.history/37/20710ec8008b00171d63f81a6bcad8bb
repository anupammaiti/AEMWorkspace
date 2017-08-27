package apps.portfolio.components.structure.page;

import com.adobe.cq.sightly.WCMUse;
  
public class Page extends WCMUse {

    private String lowerCaseTitle;
    private String keyValue;

    @Override
    public void activate() throws Exception {
        lowerCaseTitle = getProperties().get("pageTitle", "").toLowerCase();
       	org.myorg.portfolio.key.KeyService keyService = getSlingScriptHelper().getService(org.myorg.portfolio.key.KeyService.class);
	   	keyService.setKey(10) ; 

        keyValue = keyService.getKey(); 
    }

    public String getLowerCaseTitle() {
        return lowerCaseTitle;
    }

    public String getValueKey() {
        return keyValue;
    }


   
}

