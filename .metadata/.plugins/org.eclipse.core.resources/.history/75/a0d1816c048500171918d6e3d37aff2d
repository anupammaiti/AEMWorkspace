/*
 * Copyright 1997-2009 Day Management AG
 * Barfuesserplatz 6, 4001 Basel, Switzerland
 * All Rights Reserved.
 *
 * This software is the confidential and proprietary information of
 * Day Management AG, ("Confidential Information"). You shall not
 * disclose such Confidential Information and shall use it only in
 * accordance with the terms of the license agreement you entered into
 * with Day.
 */
package com.day.cq.wcm.foundation.forms.impl;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletOutputStream;
import javax.servlet.jsp.JspWriter;

import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.wrappers.SlingHttpServletResponseWrapper;

/**
 * This response wrapper ensures that clients of this response directly
 * use the jsp writer to write to.
 */
public class JspSlingHttpServletResponseWrapper extends SlingHttpServletResponseWrapper {

    // The original JspWriter of the wrapped response
    private final JspWriter jspWriter;

    // The PrintWriter returned by the getWriter method. Wraps jspWriter
    private final PrintWriter printWriter;

    public JspSlingHttpServletResponseWrapper(final SlingHttpServletResponse response,
                                              final JspWriter writer) {
        super(response);

        this.jspWriter = writer;
        this.printWriter = new PrintWriter(this.jspWriter);
    }

    /**
     * Returns the writer for this response wrapper.
     */
    public PrintWriter getWriter() {
        return this.printWriter;
    }

    /**
     * Throws an <code>IllegalStateException</code> as this wrapper only
     * supports writers.
     */
    public ServletOutputStream getOutputStream() {
        throw new IllegalStateException();
    }

    /**
     * Resets the buffer of the JspWriter underlying the writer of this
     * instance.
     */
    public void resetBuffer() {
        try {
            this.jspWriter.clearBuffer();
        } catch (IOException ignore) {
            // don't care
        }
    }
}
