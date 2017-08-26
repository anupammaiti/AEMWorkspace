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

import com.day.cq.commons.TidyJSONWriter;
import com.day.cq.wcm.api.Page;
import com.day.cq.wcm.api.WCMMode;
import com.day.cq.wcm.api.components.Component;
import com.day.cq.wcm.commons.WCMUtils;
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

import javax.servlet.RequestDispatcher;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.util.Iterator;

/**
 * Exports information about the paragraphs of the addressed page resource.
 */
@org.apache.felix.scr.annotations.Component(metatype = false)
@Service(Servlet.class)
@Properties({
        @Property(name = "sling.servlet.extensions", value = "json"),
        @Property(name = "sling.servlet.selectors", value = "paragraphs"),
        @Property(name = "sling.servlet.resourceTypes", value = "sling/servlet/default"),
        @Property(name = "sling.servlet.methods", value = "GET")
})
public class ParagraphServlet extends SlingSafeMethodsServlet {

    /**
     * Serial version UID.
     */
    private static final long serialVersionUID = 2156140435583248698L;

    @Override
    protected void doGet(
            SlingHttpServletRequest request, SlingHttpServletResponse response)
            throws ServletException, IOException {
        Page page = request.getResource().adaptTo(Page.class);
        if (page == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Page not found: " + request.getResource().getPath());
            return;
        }

        Resource content = page.getContentResource();
        if (content == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Content not found: " + page.getPath());
            return;
        }

        try {
            new ParagraphWriter(request, response).writeParagraphSystems(content);
        } catch (JSONException e) {
            throw new ServletException("Failed to produce JSON output", e);
        }

    }

    private static class ParagraphWriter {

        /**
         * Logger
         */
        private final Logger logger = LoggerFactory.getLogger(this.getClass().getName());
        private final Writer writer;
        private final TidyJSONWriter json;
        private final SlingHttpServletRequest request;
        private final SlingHttpServletResponse response;
        private long count = 0;

        public ParagraphWriter(
                SlingHttpServletRequest request,
                SlingHttpServletResponse response) {
            this.writer = new StringWriter();
            this.json = new TidyJSONWriter(writer);
            this.request = request;
            this.response = response;
        }

        public void writeParagraphSystems(Resource content)
                throws JSONException, IOException {
            // We just want previews, so disable all interactive functionality
            WCMMode.DISABLED.toRequest(request);

            json.object();
            json.key("paragraphs");
            json.array();
            Iterator<Resource> iterator =
                    content.getResourceResolver().listChildren(content);
            while (iterator.hasNext()) {
                Resource resource = iterator.next();
                Component component = WCMUtils.getComponent(resource);
                if (component != null && component.isContainer()) {
                    writeParagraphs(resource);
                }
            }
            json.endArray();
            json.key("count").value(count);
            json.endObject();

            response.setContentType("application/json; charset=UTF-8");
            response.getWriter().write(writer.toString());
        }

        public void writeParagraphs(Resource container) throws JSONException {
            ParagraphSystem system = new ParagraphSystem(container);
            for (Paragraph paragraph : system.paragraphs()) {
                if (paragraph.getType() == Paragraph.Type.NORMAL) {
                    json.object();
                    json.key("path").value(paragraph.getPath());
                    json.key("html").value(render(paragraph.getPath()));
                    json.endObject();
                    count++;
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
