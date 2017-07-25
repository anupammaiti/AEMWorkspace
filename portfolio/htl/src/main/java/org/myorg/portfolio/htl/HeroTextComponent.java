package org.myorg.portfolio.htl;

import com.adobe.cq.sightly.WCMUse;
import javax.jcr.Node;
 
/**
 * The Class HeroTextComponent.
 */
public class HeroTextComponent extends WCMUse {
 
    /** The hero text bean. */
    private HeroTextBean heroTextBean = null;
     
    @Override
    public void activate() throws Exception {
         
         
        Node currentNode = getResource().adaptTo(Node.class);
        
        heroTextBean = new HeroTextBean();
         
        if(currentNode.hasProperty("jcr:Heading")){
            heroTextBean.setHeadingText(currentNode.getProperty("./jcr:Heading").getString());
        }
        if(currentNode.hasProperty("jcr:description")){
            heroTextBean.setDescription(currentNode.getProperty("./jcr:description").getString());
        }
         
    }
     
     
     
    public HeroTextBean getHeroTextBean() {
        return this.heroTextBean;
    }
}