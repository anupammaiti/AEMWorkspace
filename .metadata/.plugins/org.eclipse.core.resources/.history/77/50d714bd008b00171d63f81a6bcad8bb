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

import java.util.Map;
import java.util.HashMap;
import java.util.Collections;
import java.util.AbstractMap;
import java.util.Set;

/**
 * <code>FileTypes</code> implements a map for human readable file types
 * using the IANA mime type as a key.
 */
public class FileTypes extends AbstractMap<String, String> {

    private static final Map<String, String> TYPES;

    static {
        Map<String, String> tmp = new HashMap<String, String>();
        tmp.put("application/pdf", "Portable Document Format (PDF)");
        tmp.put("application/vnd.ms-word", "Microsoft Word");
        tmp.put("application/msword", "Microsoft Word");
        tmp.put("application/vnd.ms-excel", "Microsoft Excel");
        tmp.put("application/vnd.ms-powerpoint", "Microsoft PowerPoint");
        tmp.put("application/mspowerpoint", "Microsoft PowerPoint");
        tmp.put("application/vnd.oasis.opendocument.database", "OpenOffice Database");
        tmp.put("application/vnd.oasis.opendocument.formula", "OpenOffice Formula");
        tmp.put("application/vnd.oasis.opendocument.graphics", "OpenOffice Graphics");
        tmp.put("application/vnd.oasis.opendocument.presentation", "OpenOffice Presentation");
        tmp.put("application/vnd.oasis.opendocument.spreadsheet", "OpenOffice Spreadsheet");
        tmp.put("application/vnd.oasis.opendocument.text", "OpenOffice Text");
        tmp.put("application/rtf", "Rich Text Format (RTF)");
        tmp.put("text/html", "HyperText Markup Language (HTML)");
        tmp.put("text/xml", "Extensible Markup Language (XML)");
        TYPES = Collections.unmodifiableMap(tmp);
    }

    /**
     * Default constructor.
     */
    public FileTypes() {
        super();
    }

    /**
     * {@inheritDoc}
     */
    public Set<Entry<String, String>> entrySet() {
        return TYPES.entrySet();
    }

    /**
     * Returns the file type (for display) for the given mime type.
     *
     * @param mimeType the mime type.
     * @return the file type for display.
     */
    public String get(Object mimeType) {
        String type = TYPES.get(mimeType);
        if (type == null) {
            type = "Unknown";
        }
        return type;
    }
}
