package org.myorg.portfolio.slingAPIRetrieveContent;

import org.apache.felix.scr.annotations.Component;
import org.apache.felix.scr.annotations.Reference;
import org.apache.felix.scr.annotations.Service;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ResourceResolver;
//Sling Imports
import org.apache.sling.api.resource.ResourceResolverFactory;

import com.day.cq.wcm.api.Page;

//This is a component so it can provide or consume services
@Component

@Service
public class QueryImp implements Query {

	// Inject a Sling ResourceResolverFactory
	@Reference
	private ResourceResolverFactory resolverFactory;

	@Override
	public String getJCRData(String location) {
		try {
			// Get the title of the AEM web page at this specific location -
			// assume its a value such as /content/geometrixx/en/services
			ResourceResolver resourceResolver = resolverFactory.getAdministrativeResourceResolver(null);
			Resource res = resourceResolver.getResource(location);

			// Adapts the resource to another type - in this example to a
			// com.day.cq.wcm.api.page
			Page page = res.adaptTo(Page.class);
			String title = page.getTitle(); // Get the title of the web page
			return title;
		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}

}
