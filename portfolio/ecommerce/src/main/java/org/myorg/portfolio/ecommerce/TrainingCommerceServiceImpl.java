package org.myorg.portfolio.ecommerce;

import java.util.List;

import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ResourceResolver;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
 
import com.adobe.cq.commerce.api.CommerceException;
import com.adobe.cq.commerce.api.CommerceQuery;
import com.adobe.cq.commerce.api.CommerceResult;
import com.adobe.cq.commerce.api.CommerceService;
import com.adobe.cq.commerce.api.CommerceSession;
import com.adobe.cq.commerce.api.Product;
import com.adobe.cq.commerce.api.promotion.Voucher;
import com.adobe.cq.commerce.common.AbstractJcrCommerceService;
import com.adobe.cq.commerce.common.AbstractJcrProduct;
import com.adobe.cq.commerce.common.ServiceContext;
  
public class TrainingCommerceServiceImpl extends AbstractJcrCommerceService implements CommerceService {
    private final Logger log = LoggerFactory.getLogger(TrainingCommerceServiceImpl.class);
     
    private Resource resource;
   // private ResourceResolver resolver;
      
    public TrainingCommerceServiceImpl(ServiceContext services, Resource res) {
        super(services,res);
        log.info("TrainingCommerceServiceImpl : Resource : "+ res);
        this.resource = res;
       // this.resolver = res.getResourceResolver();
    }
  
    public CommerceSession login(SlingHttpServletRequest request,
            SlingHttpServletResponse response) throws CommerceException {
        log.info("TrainingCommerceServiceImpl login : Resources : "+ resource);
        return new TrainingCommerceSessionImpl(this, request, response, resource);
    }
  
    public Product getProduct(final String path) throws CommerceException {
        Resource resource = this.resolver.getResource(path);
        if (resource != null && resource.isResourceType(AbstractJcrProduct.RESOURCE_TYPE_PRODUCT)) {
            return new TrainingProductImpl(resource);
        }
        return null;
    }
     
     
    public List<String> getCountries() throws CommerceException {
        // TODO Auto-generated method stub
        return null;
    }
  
    public List<String> getCreditCardTypes() throws CommerceException {
        // TODO Auto-generated method stub
        return null;
    }
  
    public Voucher getVoucher(String arg0) throws CommerceException {
        // TODO Auto-generated method stub
        return null;
    }
  
    public CommerceResult search(CommerceQuery arg0) throws CommerceException {
        // TODO Auto-generated method stub
        return null;
    }
 
    @Override
    public List<String> getOrderPredicates() throws CommerceException {
        // TODO Auto-generated method stub
        return null;
    }
 
    @Override
    public boolean isAvailable(String serviceType)
      {
        if ("commerce-service".equals(serviceType)) {
          return true;
        }
        return false;
      }
     
   
}
