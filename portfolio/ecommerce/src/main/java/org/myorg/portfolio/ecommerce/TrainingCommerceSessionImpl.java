package org.myorg.portfolio.ecommerce;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Currency;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.UUID;
import javax.jcr.Value;
 
 
 
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.resource.Resource;
 
import com.adobe.cq.commerce.api.CommerceException;
import com.adobe.cq.commerce.common.AbstractJcrCommerceService;
import com.adobe.cq.commerce.common.AbstractJcrCommerceSession;
 
import javax.jcr.Node;
import javax.jcr.RepositoryException;
import javax.jcr.Session;
 
 

import org.apache.jackrabbit.api.JackrabbitSession;
import org.apache.jackrabbit.api.security.user.Authorizable;
import org.apache.jackrabbit.api.security.user.UserManager;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ResourceResolver;
import org.apache.sling.api.resource.ValueMap;
import org.apache.sling.api.wrappers.ValueMapDecorator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
 
 
import com.adobe.cq.commerce.api.CommerceConstants;
import com.adobe.cq.commerce.api.CommerceException;
import com.adobe.cq.commerce.api.CommerceSession;
import com.adobe.cq.commerce.api.PriceInfo;
import com.adobe.cq.commerce.api.Product;
import com.adobe.cq.commerce.api.promotion.Promotion;
import com.adobe.cq.commerce.api.promotion.PromotionHandler;
import com.adobe.cq.commerce.api.promotion.PromotionInfo;
import com.adobe.cq.commerce.api.promotion.PromotionInfo.PromotionStatus;
import com.adobe.cq.commerce.api.promotion.PromotionManager;
import com.adobe.cq.commerce.api.promotion.Voucher;
import com.adobe.cq.commerce.common.promotion.AbstractJcrVoucher;
import com.adobe.granite.security.user.UserProperties;
import com.adobe.granite.security.user.UserPropertiesManager;
import com.day.cq.commons.Language;
import com.day.cq.commons.jcr.JcrUtil;
import com.day.cq.i18n.I18n;
import com.day.cq.personalization.ContextSessionPersistence;
import com.day.cq.personalization.UserPropertiesUtil;
import com.adobe.cq.commerce.api.CommerceSession.CartEntry;
 
public class TrainingCommerceSessionImpl extends AbstractJcrCommerceSession {
    
    protected SlingHttpServletRequest request;
    protected SlingHttpServletResponse response;
    protected Resource resource;
    protected ResourceResolver resolver;
    protected AbstractJcrCommerceService commerceService;
      
    protected List<CartEntry> cart = new ArrayList<CartEntry>();
   // protected List<AbstractJcrVoucher> vouchers = new ArrayList<AbstractJcrVoucher>();
    protected List<String> activePromotions = new ArrayList<String>();
  
    public TrainingCommerceSessionImpl(
            AbstractJcrCommerceService commerceService,
            SlingHttpServletRequest request, SlingHttpServletResponse response,
            Resource resource) throws CommerceException {
        super(commerceService, request, response, resource);
         
        this.PN_UNIT_PRICE="price";
     /*
         this.request = request;
         this.response = response;
         this.resource = resource;
         this.resolver = resource.getResourceResolver();
         this.commerceService = commerceService;*/
          
    }
     
    protected BigDecimal getShipping(String method)
    {
      String[][] shippingCosts = { { "/etc/commerce/shipping-methods/geometrixx-outdoors/ground", "10.00" }, { "/etc/commerce/shipping-methods/geometrixx-outdoors/three-day", "20.00" }, { "/etc/commerce/shipping-methods/geometrixx-outdoors/two-day", "25.00" }, { "/etc/commerce/shipping-methods/geometrixx-outdoors/overnight", "40.00" } };
      for (String[] entry : shippingCosts) {
        if (entry[0].equals(method)) {
          return new BigDecimal(entry[1]);
        }
      }
      return BigDecimal.ZERO;
    }
}
