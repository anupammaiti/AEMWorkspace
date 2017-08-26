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

import java.io.IOException;
import java.util.HashSet;

import com.day.cq.rewriter.htmlparser.AttributeList;
import com.day.cq.rewriter.htmlparser.DocumentHandler;
import com.day.cq.rewriter.htmlparser.HtmlParser;

/**
 * Scans HTML output for specified encoding.
 */
class EncodingScanner implements DocumentHandler {

    /**
     * Buffer.
     */
    private final byte[] buf;

    /**
     * Offset.
     */
    private final int off;

    /**
     * Length.
     */
    private final int len;

    /**
     * Encoding scanned.
     */
    private String encoding;

    /**
     * Create a new instance of this class.
     * @param buf byte buffer
     * @param off offset where characters start
     * @param len length of affected buffer
     */
    private EncodingScanner(byte[] buf, int off, int len) {
        this.buf = buf;
        this.off = off;
        this.len = len;
    }

    /**
     * Scan encoding in byte array.
     * @param buf byte buffer
     * @param off offset where characters start
     * @param len length of affected buffer
     */
    public static String scan(byte[] buf, int off, int len) throws IOException {
        return new EncodingScanner(buf, off, len).scan();
    }

    /**
     * Scan encoding in byte array (internal implementation).
     */
    private String scan() throws IOException {
        HashSet<String> set = new HashSet<String>();
        set.add("META");

        char[] ch = new String(buf, off, len, "8859_1").toCharArray();

        HtmlParser parser = new HtmlParser();
        parser.setTagInclusionSet(set);
        parser.setDocumentHandler(this);
        parser.update(ch, 0, ch.length);
        parser.finished();

        return encoding;
    }

    /**
     * {@inheritDoc}
     */
    public void characters(char[] ch, int off, int len) {
    }

    /**
     * {@inheritDoc}
     */
    public void onStartElement(String name, AttributeList attList,
                               char[] ch, int off, int len,
                               boolean endSlash) {

        if (name.equalsIgnoreCase("META")) {
            String contentType = attList.getValue("CONTENT");
            if (contentType != null) {
                int index = contentType.indexOf("charset=");
                if (index != -1) {
                    encoding = contentType.substring(index +
                            "charset=".length()).trim();
                }
            }
        }
    }

    /**
     * {@inheritDoc}
     */
    public void onEndElement(String name, char[] ch, int off, int len) {
    }

    /**
     * {@inheritDoc}
     */
    public void onStart() throws IOException {
    }

    /**
     * {@inheritDoc}
     */
    public void onEnd() throws IOException {
    }
}
