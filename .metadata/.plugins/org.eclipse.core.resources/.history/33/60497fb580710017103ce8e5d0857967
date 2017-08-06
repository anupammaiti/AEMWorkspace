/*
 * $Id$
 *
 * Copyright (c) 1997-2003 Day Management AG
 * Barfuesserplatz 6, 4001 Basel, Switzerland
 * All Rights Reserved.
 *
 * This software is the confidential and proprietary information of
 * Day Management AG, ("Confidential Information"). You shall not
 * disclose such Confidential Information and shall use it only in
 * accordance with the terms of the license agreement you entered into
 * with Day.
 */
package com.day.cq.wcm.foundation.impl;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.PushbackInputStream;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URLEncoder;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.httpclient.HostConfiguration;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpMethodBase;
import org.apache.commons.httpclient.HttpState;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.methods.multipart.MultipartRequestEntity;
import org.apache.commons.httpclient.methods.multipart.Part;
import org.apache.commons.httpclient.methods.multipart.StringPart;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.day.cq.rewriter.htmlparser.AttributeList;
import com.day.cq.rewriter.htmlparser.DocumentHandler;
import com.day.cq.rewriter.htmlparser.HtmlParser;
import com.day.cq.wcm.foundation.External.Limit;
import com.day.text.Text;

/**
 * Central rewriter that rewrites HTML pages to pass over its own rewriting
 * engine.
 */
public class Rewriter implements DocumentHandler {

    /**
     * Logger.
     */
    private static final Logger log = LoggerFactory.getLogger(Rewriter.class);

    /**
     * Path to current page.
     */
    private final String pagePath;

    /**
     * Path to current resource.
     */
    private final String resourcePath;

    /**
     * Target to show.
     */
    private final String target;

    /**
     * Reserved parameter name for target URL.
     */
    private final String targetParamName;

    /**
     * Limit, one of {@link Limit#NO}, {@link Limit#HOST}, {@link Limit#OFF}.
     */
    private Limit limit = Limit.NO;

    /**
     * Identifier for action URLs originating from this request.
     */
    private String identifier;

    /**
     * Target URI of page.
     */
    private URI targetURL;

    /**
     * Print writer.
     */
    private PrintWriter writer;

    /**
     * If true, <a href="" type="xyz"> are rewriten to the spool template
     */
    private boolean respectTypeAttribute;

    /**
     * Host prefix.
     */
    private String hostPrefix;

    /**
     * Extra params to pass to the target app
     */
    private Map<String,String> extraParams = new HashMap<String,String>();

    /**
     * Flag that indicates if request input parameters should be passed
     */
    private boolean passInput;

    /**
     * Socket timeout.
     */
    private int soTimeout = 60000;

    /**
     * Connection timeout.
     */
    private int connectionTimeout = 5000;

    /**
     * POST selector.
     */
    protected final String postSelector;

    /**
     * Create a new instance of this class.
     * @param pagePath path to page
     * @param postSelector selector to use for dependent resources
     * @param target target to connect to
     * @param targetParamName parameter name to use when specifying real target
     */
    public Rewriter(String pagePath, String resourcePath,
                    String target, String postSelector, String targetParamName) {
        this.pagePath = pagePath;
        this.resourcePath = resourcePath;
        this.target = target;
        this.postSelector = postSelector;
        this.targetParamName = targetParamName;
    }

    /**
     * Set if input parameters are to be passed to the target application
     * @param passInput <code>true</code> if params are to be passed
     */
    public void setPassInput(boolean passInput) {
        this.passInput = passInput;
    }

    /**
     * Adds an extra parameter to the request
     * @param name
     * @param value
     */
    public void addExtraParameter(String name, String value) {
        extraParams.put(name, value);
    }

    /**
     * Set limit to use.
     * @param limit limit
     */
    public void setLimit(Limit limit) {
        this.limit = limit;
    }

    /**
     * If <code>true</code>, type attributes in a-href are rewritten to the
     * spool template.
     *
     * @param respectTypeAttribute
     */
    public void setRespectTypeAttribute(boolean respectTypeAttribute) {
        this.respectTypeAttribute = respectTypeAttribute;
    }

    /**
     * Set identifier to use.
     * @param identifier identifier
     */
    public void setIdentifier(String identifier) {
        this.identifier = identifier;
    }

    /**
     * Set writer to use when appending new content.
     * @param writer print writer
     */
    private void setWriter(PrintWriter writer) {
        this.writer = writer;
    }

    /**
     * Set socket timeout.
     *
     * @param soTimeout socket timeout
     */
    public void setSoTimeout(int soTimeout) {
        this.soTimeout = soTimeout;
    }

    /**
     * Set connection timeout.
     *
     * @param connectionTimeout connection timeout
     */
    public void setConnectionTimeout(int connectionTimeout) {
        this.connectionTimeout = connectionTimeout;
    }

    /**
     * {@inheritDoc}
     */
    public void onStart() throws IOException {
    }

    /**
     * {@inheritDoc}
     */
    public void onStartElement(String name, AttributeList attList,
                               char[] ch, int off, int len,
                               boolean endSlash) {

        String suffix = null;
        String upperName = name.toUpperCase();
        if (limit != Limit.OFF) {
            if (upperName.equals("A")) {
                rewriteARef(attList);
            } else if (upperName.equals("AREA")) {
                rewriteRef(attList, "HREF", false);
            } else if (upperName.equals("BASE")) {
                rewriteBase(attList);
            } else if (upperName.equals("FORM")) {
                suffix = rewriteForm(attList);
            } else if (upperName.equals("FRAME")) {
                rewriteRef(attList, "SRC", true);
            } else if (upperName.equals("IFRAME")) {
                rewriteRef(attList, "SRC", true);
            } else if (upperName.equals("IMG")) {
                rewriteRef(attList, "SRC", true);
            } else if (upperName.equals("INPUT")) {
                rewriteRef(attList, "SRC", true);
            } else if (upperName.equals("LINK")) {
                rewriteRef(attList, "HREF", true);
            } else if (upperName.equals("SCRIPT")) {
                rewriteRef(attList, "SRC", true);
            } else if (upperName.equals("TABLE")) {
                rewriteRef(attList, "BACKGROUND", true);
            } else if (upperName.equals("TD")) {
                rewriteRef(attList, "BACKGROUND", true);
            } else if (upperName.equals("TR")) {
                rewriteRef(attList, "BACKGROUND", true);
            }
        }
        if (attList.isModified()) {
            writer.write(serialize(name, attList, endSlash));
        } else {
            writer.write(ch, off, len);
        }
        if (suffix != null) {
            writer.write(suffix);
        }
    }
    
    /**
     * Rewrite an {@code HREF} inside an {@code A} tag.
     * 
     * @param attList attribute list
     */
    private void rewriteARef(AttributeList attList) {
        String href = attList.getValue("href");
        if (href == null) {
            // no reference to rewrite
            return;
        }
            
        int sep = href.indexOf(':');
        if (sep != -1) {
            String protocol = href.substring(0,  sep);
            if (protocol.equals("mailto") || protocol.equals("javascript") || protocol.equals("ftp")) {
                // no need to rewrite such links
                return;
            }
        }
            
        // check if the A has a type attribute specified or target is set to _blank
        // rewrite all to spool if enabled
        boolean hasType = respectTypeAttribute && attList.containsAttribute("type");
        boolean blankTarget = "_blank".equals(attList.getValue("target"));
        rewriteRef(attList, "HREF", hasType || blankTarget);
    }

    /**
     * Serialize an element start
     * @param name tag name
     * @param attList list of attributes
     * @param endSlash flag indicating whether this tag is XHTML compliant
     * @return string representation
     */
    private String serialize(String name, AttributeList attList,
                             boolean endSlash) {

        StringBuffer buffer = new StringBuffer(256);

        buffer.append("<");
        buffer.append(name);
        Iterator<String> attNames = attList.attributeNames();
        while (attNames.hasNext()) {
            String attName  = attNames.next();
            String attValue = attList.getQuotedValue(attName);
            buffer.append(" ");
            buffer.append(attName);
            if (attValue != null) {
                buffer.append('=');
                buffer.append(attValue);
            }
        }
        if (endSlash) {
            buffer.append(" /");
        }
        buffer.append(">");
        return buffer.toString();
    }

    /**
     * {@inheritDoc}
     */
    public void characters(char[] ch, int off, int len) throws IOException {
        writer.write(ch, off, len);
    }

    /**
     * {@inheritDoc}
     */
    public void onEndElement(String name, char[] ch, int off, int len) {
        writer.write(ch, off, len);
    }

    /**
     * {@inheritDoc}
     */
    public void onEnd() throws IOException {
    }

    /**
     * Make an absolute URL given an (eventually) relative one.
     */
    private String getAbsoluteURL(String relativeURI) {
        if (relativeURI.startsWith("http:") || relativeURI.startsWith("https:")) {
            return relativeURI;
        }
        StringBuffer result = new StringBuffer(256);
        result.append(targetURL.getScheme());
        result.append("://");
        result.append(targetURL.getHost());
        if (targetURL.getPort() != -1) {
            result.append(':');
            result.append(Integer.toString(targetURL.getPort()));
        }
        if (relativeURI.startsWith("/")) {
            result.append(relativeURI);
        } else {
            String targetURI = targetURL.getPath();
            int lastSep = targetURI.lastIndexOf('/');
            if (lastSep != -1) {
                targetURI = targetURI.substring(0, targetURI.lastIndexOf('/') + 1);
            } else {
                targetURI = "/";
            }
            result.append(targetURI);
            result.append(relativeURI);
        }
        return result.toString();
    }

    /**
     * Rewrite a &lt;BASE&gt; tag's <code>href</code> attribute.
     * @param attList attribute list
     */
    private void rewriteBase(AttributeList attList) {
        String href = attList.getValue("HREF");
        if (href != null) {
            if (limit != Limit.HOST || sameHost(href)) {
                try {
                    targetURL = new URI(href);
                } catch (URISyntaxException e) {}

                attList.setValue("HREF", "");
            }
        }
    }

    /**
     * Rewrite a &lt;FORM&gt; tag.
     * @param attList attribute list
     * @return eventual suffix to append after having written
     *         base tag
     */
    private String rewriteForm(AttributeList attList) {
        String action = attList.getValue("ACTION");
        if (action != null) {
            if (limit != Limit.HOST || sameHost(action)) {
                action = getAbsoluteURL(action);

                String formSelector = "";

                String method = attList.getValue("METHOD");
                if ( method != null ) {
                    method = method.toUpperCase();
                    attList.setValue("METHOD", method);
                }
                if ("POST".equals(method)) {
                    formSelector = "." + postSelector;
                }

                attList.setValue("ACTION", pagePath + formSelector + ".html");

                StringBuffer hidden = new StringBuffer();
                hidden.append("<input type=\"hidden\" name=\"");
                hidden.append(targetParamName);
                if (identifier != null) {
                    hidden.append('_');
                    hidden.append(identifier);
                }
                hidden.append("\" value=\"");
                hidden.append(action);
                hidden.append("\">");
                return hidden.toString();
            }
        }
        return null;
    }

    /**
     * Rewrite a generic resource reference and store it back in the attribute
     * list given.
     * @param attList attribute list
     * @param attName attribute name where reference is stored
     * @param appendSelector flag indicating whether we should append selector
     */
    private void rewriteRef(AttributeList attList, String attName, boolean appendSelector) {
        String ref = attList.getValue(attName);
        if (ref != null) {
            if (limit != Limit.HOST || sameHost(ref)) {
                attList.setValue(attName, rewriteURL(ref, appendSelector));
            }
        }
    }

    /**
     * Rewrite a (possible relative) URL.
     * @param url url to rewrite
     * @param appendSelector flag indicating whether we should append selector
     * @return rewritten URL
     */
    private String rewriteURL(String url, boolean appendSelector) {
        StringBuffer newValue = new StringBuffer();
        if (appendSelector) {
            newValue.append(resourcePath);
            newValue.append("?");
        } else {
            newValue.append(pagePath);
            newValue.append(".html?");
        }
        newValue.append(targetParamName);
        if (!appendSelector && identifier != null) {
            newValue.append('_');
            newValue.append(identifier);
        }
        newValue.append('=');
        newValue.append(URLEncoder.encode(getAbsoluteURL(url)));
        return newValue.toString();
    }

    /**
     * Feed HTML into received over a {@link java.net.URLConnection} to an
     * HTML parser.
     * @param in input stream
     * @param contentType preferred content type
     * @param response servlet response
     * @throws java.io.IOException if an I/O error occurs
     */
    private void rewriteHtml(InputStream in, String contentType,
                             HttpServletResponse response)
            throws IOException {

        // Determine encoding if not specified
        String encoding = "8859_1";
        int charsetIndex = contentType.indexOf("charset=");
        if (charsetIndex != -1) {
            encoding = contentType.substring(charsetIndex + "charset=".length()).trim();
        } else {
            byte[] buf = new byte[2048];
            int len = fillBuffer(in, buf);

            String scanned = EncodingScanner.scan(buf, 0, len);
            if (scanned != null) {
                encoding = scanned;
                contentType += "; charset=" + encoding;
            }
            PushbackInputStream pb = new PushbackInputStream(in, buf.length);
            pb.unread(buf, 0, len);
            in = pb;
        }

        // Set appropriate content type and get writer
        response.setContentType(contentType);
        PrintWriter writer = response.getWriter();
        setWriter(writer);

        // Define tags that should be inspected
        HashSet<String> inclusionSet = new HashSet<String>();
        inclusionSet.add("A");
        inclusionSet.add("AREA");
        inclusionSet.add("BASE");
        inclusionSet.add("FORM");
        inclusionSet.add("FRAME");
        inclusionSet.add("IFRAME");
        inclusionSet.add("IMG");
        inclusionSet.add("INPUT");
        inclusionSet.add("LINK");
        inclusionSet.add("SCRIPT");
        inclusionSet.add("TABLE");
        inclusionSet.add("TD");
        inclusionSet.add("TR");
        inclusionSet.add("NOREWRITE");

        HtmlParser parser = new HtmlParser();
        parser.setTagInclusionSet(inclusionSet);
        parser.setDocumentHandler(this);

        BufferedReader reader = null;

        try {
            reader = new BufferedReader(new InputStreamReader(in, encoding));

            char buf[] = new char[2048];
            int len;

            while ((len = reader.read(buf)) != -1) {
                parser.update(buf, 0, len);
            }
            parser.finished();

        } finally {
            if (reader != null) {
                reader.close();
            }
        }
    }

    /**
     * Fill buffer with data from input stream.
     * @param in input stream
     * @param buf byte buffer
     * @return number of bytes actually read
     */
    private int fillBuffer(InputStream in, byte[] buf)
            throws IOException {

        int total = 0;
        while (total < buf.length) {
            int chunk = in.read(buf, total, buf.length - total);
            if (chunk <= 0) {
                break;
            }
            total += chunk;
        }
        return total;
    }

    /**
     * Set host prefix to watch for when rewriting references.
     */
    private void setHostPrefix(URI uri) {
        StringBuffer buf = new StringBuffer();
        buf.append(uri.getScheme());
        buf.append("://");
        buf.append(uri.getHost());

        int port = uri.getPort();
        if (port != -1) {
            buf.append(':');
            buf.append(String.valueOf(port));
        }
        buf.append('/');

        hostPrefix = buf.toString();
    }

    /**
     * Return a flag indicating whether the URL given belongs to the same
     * host as the target URL currently being rendered.
     */
    private boolean sameHost(String ref) {
        if (!ref.startsWith("http:") && !ref.startsWith("https:")) {
            return true;
        }
        return ref.startsWith(hostPrefix);
    }

    /**
     * Process a page.
     */
    public void rewrite(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            targetURL = new URI(target);
        } catch (URISyntaxException e) {
            IOException ioe = new IOException("Bad URI syntax: " + target);
            ioe.initCause(e);
            throw ioe;
        }
        setHostPrefix(targetURL);

        HttpClient httpClient = new HttpClient();
        HttpState httpState = new HttpState();
        HostConfiguration hostConfig = new HostConfiguration();
        HttpMethodBase httpMethod;

        // define host
        hostConfig.setHost(targetURL.getHost(), targetURL.getPort(), targetURL.getScheme());

        // create http method
        String method = (String) request.getAttribute("cq.ext.app.method");
        if (method == null) {
            method = request.getMethod();
        }
        method = method.toUpperCase();
        boolean isPost = "POST".equals(method);
        String urlString = targetURL.getPath();
        StringBuffer query = new StringBuffer();
        if (targetURL.getQuery() != null) {
            query.append("?");
            query.append(targetURL.getQuery());
        }
        //------------ GET ---------------
        if ("GET".equals(method)) {
            // add internal props
            Iterator<String> iter = extraParams.keySet().iterator();
            while (iter.hasNext()) {
                String name = iter.next();
                String value = extraParams.get(name);
                if (query.length() == 0) {
                    query.append("?");
                } else {
                    query.append("&");
                }
                query.append(Text.escape(name));
                query.append("=");
                query.append(Text.escape(value));
            }
            if (passInput) {
                // add request params
                @SuppressWarnings("unchecked")
                Enumeration<String> e = request.getParameterNames();
                while (e.hasMoreElements()) {
                    String name = e.nextElement();
                    if (targetParamName.equals(name)) {
                        continue;
                    }
                    String[] values = request.getParameterValues(name);
                    for (int i=0; i<values.length; i++) {
                        if (query.length() == 0) {
                            query.append("?");
                        } else {
                            query.append("&");
                        }
                        query.append(Text.escape(name));
                        query.append("=");
                        query.append(Text.escape(values[i]));
                    }
                }

            }
            httpMethod = new GetMethod(urlString + query);
        //------------ POST ---------------
        } else if ("POST".equals(method)) {
            PostMethod m = new PostMethod(urlString + query);
            httpMethod = m;
            String contentType = request.getContentType();
            boolean mp = contentType != null && contentType.toLowerCase().startsWith("multipart/");
            if (mp) {
                //------------ MULTPART POST ---------------
                List<Part> parts = new LinkedList<Part>();
                Iterator<String> iter = extraParams.keySet().iterator();
                while (iter.hasNext()) {
                    String name = iter.next();
                    String value = extraParams.get(name);
                    parts.add(new StringPart(name, value));
                }
                if (passInput) {
                    // add request params
                    @SuppressWarnings("unchecked")
                    Enumeration<String> e = request.getParameterNames();
                    while (e.hasMoreElements()) {
                        String name = e.nextElement();
                        if (targetParamName.equals(name)) {
                            continue;
                        }
                        String[] values = request.getParameterValues(name);
                        for (int i = 0; i < values.length; i++) {
                            parts.add(new StringPart(name, values[i]));
                        }
                    }
                }
                m.setRequestEntity(
                    new MultipartRequestEntity(
                            parts.toArray(new Part[parts.size()]),
                            m.getParams())
                );
            } else {
                //------------ NORMAL POST ---------------
                // add internal props
                Iterator<String> iter = extraParams.keySet().iterator();
                while (iter.hasNext()) {
                    String name = iter.next();
                    String value = extraParams.get(name);
                    m.addParameter(name, value);
                }
                if (passInput) {
                    // add request params
                    @SuppressWarnings("unchecked")
                    Enumeration e = request.getParameterNames();
                    while (e.hasMoreElements()) {
                        String name = (String) e.nextElement();
                        if (targetParamName.equals(name)) {
                            continue;
                        }
                        String[] values = request.getParameterValues(name);
                        for (int i=0; i<values.length; i++) {
                            m.addParameter(name, values[i]);
                        }
                    }
                }
            }
        } else {
            log.error("Unsupported method ''{}''", method);
            throw new IOException("Unsupported http method " + method);
        }
        log.debug("created http connection for method {} to {}", method, urlString + query);

        // add some request headers
        httpMethod.addRequestHeader("User-Agent", request.getHeader("User-Agent"));
        httpMethod.setFollowRedirects(!isPost);
        httpMethod.getParams().setSoTimeout(soTimeout);
        httpClient.getHttpConnectionManager().getParams().setConnectionTimeout(connectionTimeout);

        // send request
        httpClient.executeMethod(hostConfig, httpMethod, httpState);
        String contentType = httpMethod.getResponseHeader("Content-Type").getValue();

        log.debug("External app responded: {}", httpMethod.getStatusLine());
        log.debug("External app contenttype: {}", contentType);

        // check response code
        int statusCode = httpMethod.getStatusCode();
        if (statusCode >= HttpURLConnection.HTTP_BAD_REQUEST) {
            PrintWriter writer = response.getWriter();
            writer.println("External application returned status code: " + statusCode);
            return;
        } else if (statusCode == HttpURLConnection.HTTP_MOVED_TEMP ||
                statusCode == HttpURLConnection.HTTP_MOVED_PERM) {
            String location = httpMethod.getResponseHeader("Location").getValue();
            if (location == null) {
                response.sendError(HttpURLConnection.HTTP_NOT_FOUND);
                return;
            }
            response.sendRedirect(rewriteURL(location, false));
            return;
        }

        // open input stream
        InputStream in = httpMethod.getResponseBodyAsStream();

        // check content type
        if (contentType != null && contentType.startsWith("text/html")) {
            rewriteHtml(in, contentType, response);
        } else {
            // binary mode
            if (contentType != null) {
                response.setContentType(contentType);
            }
            OutputStream outs = response.getOutputStream();

            try {
                byte buf[] = new byte[8192];
                int len;

                while ((len = in.read(buf)) != -1) {
                    outs.write(buf, 0, len);
                }
            } finally {
                if (in != null) {
                    in.close();
                }
            }
        }
    }
}
