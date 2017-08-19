/*
 * Copyright 1997-2008 Day Management AG
 * Barfuesserplatz 6, 4001 Basel, Switzerland
 * All Rights Reserved.
 *
 * This software is the confidential and proprietary information of
 * Day Management AG, ("Confidential Information"). You shall not
 * disclose such Confidential Information and shall use it only in
 * accordance with the terms of the license agreement you entered into
 * with Day.
 */
package com.day.cq.wcm.foundation;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.util.Iterator;

import javax.servlet.RequestDispatcher;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;

import org.apache.felix.scr.annotations.Properties;
import org.apache.felix.scr.annotations.Property;
import org.apache.felix.scr.annotations.Service;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.servlets.SlingSafeMethodsServlet;
import org.apache.sling.api.wrappers.SlingHttpServletResponseWrapper;
import org.apache.sling.commons.json.JSONException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.day.cq.commons.TidyJSONWriter;
import com.day.cq.wcm.api.Page;
import com.day.cq.wcm.api.WCMMode;
import com.day.cq.wcm.api.components.Component;
import com.day.cq.wcm.commons.WCMUtils;

/**
 * Exports a list of form actions.
 */
@org.apache.felix.scr.annotations.Component(metatype = false)
@Service(Servlet.class)
@Properties({
        @Property(name = "sling.servlet.paths", value = "/bin/wcm/foundation/paragraphlist"),
        @Property(name = "sling.servlet.extensions", value = "json"),
        @Property(name = "sling.servlet.methods", value = "GET")
})
public class ParagraphList extends SlingSafeMethodsServlet {

    /**
     * Serial version UID.
     */
    private static final long serialVersionUID = 2156140435583248698L;

    /** Query clause */
    public static final String QUERY = "query";

    @Override
    protected void doGet(
            SlingHttpServletRequest request, SlingHttpServletResponse response)
            throws ServletException, IOException {

        try {
            StringWriter writer = new StringWriter();
            TidyJSONWriter json = new TidyJSONWriter(writer);
            json.object();
            json.key("hits");
            json.array();

            Page page = null;
            try {
                String path = request.getRequestParameter(QUERY).getString().replace("path:", "");
                page = request.getResourceResolver().getResource(path).adaptTo(Page.class);
            }
            catch (Exception e) {
                //
            }

            if (page != null) {
                Resource content = page.getContentResource();
                if (content != null) {
                    try {
                        ParagraphWriter pw = new ParagraphWriter(request, response, json);
                        pw.writeParagraphSystems(content);
                    }
                    catch (JSONException e) {
                        throw new ServletException("Failed to produce JSON output", e);
                    }
                }
            }

            json.endArray();
            json.key("results").value(0);
            json.endObject();

            if ("json".equals(request.getRequestPathInfo().getExtension())) {
                response.setContentType("application/json");
                response.setCharacterEncoding("utf-8");
            }
            response.getWriter().write(writer.toString());

        }
        catch (JSONException e) {
            throw new ServletException("Failed to produce JSON output", e);
        }
    }

    void writeEmptyJSON(SlingHttpServletResponse response)
            throws ServletException, IOException {
    }


    private static class ParagraphWriter {

        /** Logger */
        private final Logger logger = LoggerFactory.getLogger(this.getClass().getName());

        private final TidyJSONWriter json;

        private final SlingHttpServletRequest request;

        private final SlingHttpServletResponse response;

        public ParagraphWriter(
                SlingHttpServletRequest request,
                SlingHttpServletResponse response,
                TidyJSONWriter json) {
            this.request = request;
            this.response = response;
            this.json = json;
        }

        public void writeParagraphSystems(Resource content)
                throws JSONException, IOException {
            // We just want previews, so disable all interactive functionality
            WCMMode.DISABLED.toRequest(request);

            Iterator<Resource> iterator =
                content.getResourceResolver().listChildren(content);
            while (iterator.hasNext()) {
                Resource resource = iterator.next();
                Component component = WCMUtils.getComponent(resource);
                if (component != null && component.isContainer()) {
                    writeParagraphs(resource);
                }
            }

        }

        public void writeParagraphs(Resource container) throws JSONException {
            ParagraphSystem system = new ParagraphSystem(container);
            for (Paragraph paragraph : system.paragraphs()) {
                if (paragraph.getType() == Paragraph.Type.NORMAL) {
                    json.object();
                    json.key("path").value(paragraph.getPath());
                    json.key("excerpt").value(render(paragraph.getPath()));
                    json.endObject();
                }
            }
        }

        public String render(String path) {
            try {
                final Writer buffer = new StringWriter();
                final ServletOutputStream stream = new ServletOutputStream() {
                    @Override
                    public void write(int b) throws IOException {
                        // TODO: Proper character encoding support!
                        buffer.append((char) b);
                    }
                };

                SlingHttpServletResponseWrapper wrapper =
                    new SlingHttpServletResponseWrapper(response) {
                        @Override
                        public ServletOutputStream getOutputStream() {
                            return stream;
                        }
                        @Override
                        public PrintWriter getWriter() throws IOException {
                            return new PrintWriter(buffer);
                        }
                        @Override
                        public SlingHttpServletResponse getSlingResponse() {
                            return super.getSlingResponse();
                        }
                    };

                // TODO: The ".html" suffix is a somewhat strange workaround
                // and should be removed. See SLING-633 for background.
                RequestDispatcher dispatcher =
                    request.getRequestDispatcher(path + ".html");
                dispatcher.include(request, wrapper);
                return buffer.toString();
            } catch (Exception e) {
                logger.error("Exception occured: " + e.getMessage(), e);
                return e.getMessage();
            }
        }
    }

}
