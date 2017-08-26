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

import java.io.BufferedReader;
import java.io.IOException;
import java.io.StringReader;
import java.text.FieldPosition;
import java.text.Format;
import java.text.ParsePosition;

/**
 * The <code>AutoFormatter</code> class implements the automatic conversion
 * of line endings to <code>&lt;br></code> HTML lists.
 * <p/>
 * This implementation only supports automatically converting bullet and
 * numbered lists as well as line breaking.
 */
public class TextFormat extends Format {

    /**
     * The default line breaking tag
     */
    private static final String DEFAULT_BR = "<br>";

    /**
     * The default opening tag for ordered lists
     */
    private static final String DEFAULT_TAG_OL_OPEN = "<ol start=\"%s\">";

    /**
     * The default closing tag for ordered lists
     */
    private static final String DEFAULT_TAG_OL_CLOSE = "</ol>";

    /**
     * The default opening tag for items in ordered lists
     */
    private static final String DEFAULT_TAG_OL_ITEM_OPEN = "<li>";

    /**
     * The default closing tag for items in ordered lists
     */
    private static final String DEFAULT_TAG_OL_ITEM_CLOSE = "</li>";

    /**
     * The default opening tag for unordered lists
     */
    private static final String DEFAULT_TAG_UL_OPEN = "<ul>";

    /**
     * The default closing tag for unordered lists
     */
    private static final String DEFAULT_TAG_UL_CLOSE = "</ul>";

    /**
     * The default opening tag for items in unordered lists
     */
    private static final String DEFAULT_TAG_UL_ITEM_OPEN = "<li>";

    /**
     * The default closing tag for items in unordered lists
     */
    private static final String DEFAULT_TAG_UL_ITEM_CLOSE = "</li>";

    /**
     * The normal text formatting state - no list in action
     */
    private static final int STATE_NORMAL = 1;

    /**
     * State where a <em>&lt;ol&gt;</em> tag is currently open
     */
    private static final int STATE_OL = 3;

    /**
     * State where a <em>&lt;ul&gt;</em> tag is currently open
     */
    private static final int STATE_UL = 4;

    /**
     * The tag used for line breaks, default {@link #DEFAULT_BR}
     */
    private String tagBr = DEFAULT_BR;

    /**
     * The tag used to start ordered lists, default {@link #DEFAULT_TAG_OL_OPEN}
     */
    private String tagOlOpen = DEFAULT_TAG_OL_OPEN;

    /**
     * The tag used to end ordered lists, default {@link #DEFAULT_TAG_OL_CLOSE}
     */
    private String tagOlClose = DEFAULT_TAG_OL_CLOSE;

    /**
     * The tag used to start items in ordered lists, default {@link #DEFAULT_TAG_OL_ITEM_OPEN}
     */
    private String tagOlItemOpen = DEFAULT_TAG_OL_ITEM_OPEN;

    /**
     * The tag used to close items in ordered lists, default {@link #DEFAULT_TAG_OL_ITEM_CLOSE}
     */
    private String tagOlItemClose = DEFAULT_TAG_OL_ITEM_CLOSE;

    /**
     * The tag used to start unordered lists, default {@link #DEFAULT_TAG_UL_OPEN}
     */
    private String tagUlOpen = DEFAULT_TAG_UL_OPEN;

    /**
     * The tag used to end ordered lists, default {@link #DEFAULT_TAG_UL_OPEN}
     */
    private String tagUlClose = DEFAULT_TAG_UL_CLOSE;

    /**
     * The tag used to start items in unordered lists, default {@link #DEFAULT_TAG_UL_ITEM_OPEN}
     */
    private String tagUlItemOpen = DEFAULT_TAG_UL_ITEM_OPEN;

    /**
     * The tag used to close items in unordered lists, default {@link #DEFAULT_TAG_UL_ITEM_CLOSE}
     */
    private String tagUlItemClose = DEFAULT_TAG_UL_ITEM_CLOSE;

    private boolean autoBr = true;

    private boolean autoList = true;

    private boolean escapeXML = true;

    public String getTagBr() {
        return tagBr;
    }

    public void setTagBr(String tagBr) {
        this.tagBr = tagBr;
    }

    public String getTagOlOpen() {
        return tagOlOpen;
    }

    public void setTagOlOpen(String tagOlOpen) {
        this.tagOlOpen = tagOlOpen;
    }

    public String getTagOlClose() {
        return tagOlClose;
    }

    public void setTagOlClose(String tagOlClose) {
        this.tagOlClose = tagOlClose;
    }

    public String getTagOlItemOpen() {
        return tagOlItemOpen;
    }

    public void setTagOlItemOpen(String tagOlItemOpen) {
        this.tagOlItemOpen = tagOlItemOpen;
    }

    public String getTagOlItemClose() {
        return tagOlItemClose;
    }

    public void setTagOlItemClose(String tagOlItemClose) {
        this.tagOlItemClose = tagOlItemClose;
    }

    public String getTagUlOpen() {
        return tagUlOpen;
    }

    public void setTagUlOpen(String tagUlOpen) {
        this.tagUlOpen = tagUlOpen;
    }

    public String getTagUlClose() {
        return tagUlClose;
    }

    public void setTagUlClose(String tagUlClose) {
        this.tagUlClose = tagUlClose;
    }

    public String getTagUlItemOpen() {
        return tagUlItemOpen;
    }

    public void setTagUlItemOpen(String tagUlItemOpen) {
        this.tagUlItemOpen = tagUlItemOpen;
    }

    public String getTagUlItemClose() {
        return tagUlItemClose;
    }

    public void setTagUlItemClose(String tagUlItemClose) {
        this.tagUlItemClose = tagUlItemClose;
    }

    public boolean isAutoBr() {
        return autoBr;
    }

    public void setAutoBr(boolean autoBr) {
        this.autoBr = autoBr;
    }

    public boolean isAutoList() {
        return autoList;
    }

    public void setAutoList(boolean autoList) {
        this.autoList = autoList;
    }

    public boolean isEscapeXML() {
        return escapeXML;
    }

    public void setEscapeXML(boolean escapeXML) {
        this.escapeXML = escapeXML;
    }

    /**
     * The <code>TextFormat</code> class does not support parsing, so an
     * <code>UnsupportedOperationException</code> is thrown when trying to
     * parse.
     *
     * @param source The source string to parse. Ignored.
     * @param status The position to define parsing. Ignored.
     * @throws UnsupportedOperationException as it is not yet implemented.
     */
    public Object parseObject(String source, ParsePosition status) {
        throw new UnsupportedOperationException("parse not implemented yet");
    }

    /**
     * Formats the object according to the standard modifiers, which are
     * automatic line breaks and list formatting. This implementation only
     * supports strings and completely ignores the pos parameter.
     *
     * @param obj        The object to format, which must be a String or a
     *                   <code>ClassCastException</code> will be thrown.
     * @param toAppendTo Where to append the formatted data. If <code>null</code>,
     *                   a new string buffer is allocated.
     * @param pos        Formatting position information. Not used.
     * @return a <code>StringBuffer</code> containing the formatted string. This
     *         is either the same as <code>toAppendTo</code> or a newly
     *         allocated <code>StringBuffer</code> if the parameter is
     *         <code>null</code>.
     */
    public StringBuffer format(Object obj, StringBuffer toAppendTo,
                               FieldPosition pos) {
        try {
            if (toAppendTo == null) {
                toAppendTo = new StringBuffer();
            }
            BufferedReader r = new BufferedReader(new StringReader(obj.toString()));
            String line = r.readLine();
            int state = STATE_NORMAL;
            while (line != null) {
                boolean processed = false;
                if (autoList) {
                    int idx = line.indexOf(' ');
                    if (idx > 0) {
                        String pfx = line.substring(0, idx);
                        if (pfx.equals("-")) {
                            if (state == STATE_OL) {
                                toAppendTo.append(tagOlClose);
                                state = STATE_NORMAL;
                            }
                            if (state != STATE_UL) {
                                toAppendTo.append(tagUlOpen);
                                state = STATE_UL;
                            }
                            toAppendTo.append(tagUlItemOpen);
                            toAppendTo.append(escape(line.substring(idx+1)));
                            toAppendTo.append(tagUlItemClose);
                            processed = true;
                        } else if (pfx.matches("^\\d+\\.$")) {
                            if (state == STATE_UL) {
                                toAppendTo.append(tagUlClose);
                                state = STATE_NORMAL;
                            }
                            if (state != STATE_OL) {
                                toAppendTo.append(String.format(tagOlOpen, pfx.substring(0, pfx.length() -1)));
                                state = STATE_OL;
                            }
                            toAppendTo.append(tagOlItemOpen);
                            toAppendTo.append(escape(line.substring(idx+1)));
                            toAppendTo.append(tagOlItemClose);
                            processed = true;
                        }
                    }
                }
                if (!processed) {
                    // close lists
                    if (state == STATE_OL) {
                        toAppendTo.append(tagOlClose);
                        state = STATE_NORMAL;
                    } else if (state == STATE_UL) {
                        toAppendTo.append(tagUlClose);
                        state = STATE_NORMAL;
                    }
                    toAppendTo.append(escape(line));
                    if (autoBr) {
                        toAppendTo.append(tagBr);
                    } else {
                        toAppendTo.append("\n");
                    }
                }
                line = r.readLine();
            }
            // close lists
            if (state == STATE_OL) {
                toAppendTo.append(tagOlClose);
            } else if (state == STATE_UL) {
                toAppendTo.append(tagUlClose);
            }
            return toAppendTo;
        } catch (IOException e) {
            // should never happen since reading from string
            throw new IllegalStateException(e);
        }
    }

    private CharSequence escape(String string) {
        if (!escapeXML) {
            return string;
        }
        StringBuffer buf = new StringBuffer();
        for (int i=0; i<string.length(); i++) {
            char c = string.charAt(i);
            switch (c) {
                case '<':
                    buf.append("&lt;");
                    break;
                case '>':
                    buf.append("&gt;");
                    break;
                case '&':
                    buf.append("&amp;");
                    break;
                case '\"':
                    buf.append("&quot;");
                    break;
                default:
                    buf.append(c);
            }
        }
        return buf;
    }
}
