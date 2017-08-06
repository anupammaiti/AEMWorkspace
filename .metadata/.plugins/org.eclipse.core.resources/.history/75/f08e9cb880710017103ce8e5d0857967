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
package com.day.cq.wcm.foundation.forms.impl;

import java.io.PrintWriter;

import javax.servlet.ServletOutputStream;

import org.apache.sling.api.SlingHttpServletResponse;
import org.apache.sling.api.wrappers.SlingHttpServletResponseWrapper;

public class FormsHandlingResponse extends SlingHttpServletResponseWrapper {

    private ServletOutputStream nullstream;
    private PrintWriter nullwriter;

    public FormsHandlingResponse(SlingHttpServletResponse wrappedResponse) {
        super(wrappedResponse);
    }

    @Override
    public PrintWriter getWriter() {
        if (nullwriter == null) {
            nullwriter = new PrintWriter(getOutputStream());
        }
        return nullwriter;
    }

    @Override
    public ServletOutputStream getOutputStream() {
        if (nullstream == null) {
            nullstream = new ServletOutputStream() {

                @Override
                public void write(int b) {
                    // noop
                }

                @Override
                public void write(byte[] b) {
                    // noop
                }

                @Override
                public void write(byte[] b, int off, int len)
                        {
                    // noop
                }

                @Override
                public void flush() {
                    // noop
                }

                @Override
                public void close() {
                    // noop
                }
            };
        }
        return nullstream;
    }

    @Override
    public void flushBuffer() {
        // noop
    }

    @Override
    public void reset() {
        // noop
    }

    @Override
    public void resetBuffer() {
        // noop
    }
}
