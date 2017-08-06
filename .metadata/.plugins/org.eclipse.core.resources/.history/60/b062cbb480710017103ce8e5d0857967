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

import java.io.Reader;
import java.io.IOException;
import java.util.Set;
import java.util.HashSet;
import java.util.Arrays;

import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.apache.commons.io.IOUtils;
import com.day.cq.rewriter.htmlparser.HtmlParser;

/**
 * <code>TableBuilder</code>...
 */
public class TableXMLBuilder extends DefaultHandler {

    private static final Set<String> TABLE_TAGS = new HashSet<String>(Arrays.asList(
            "TABLE", "/TABLE",
            "TR", "/TR",
            "TD", "/TD",
            "TH", "/TH",
            "CAPTION", "/CAPTION",
            //"THEAD", "/THEAD",
            //"TFOOT", "/TFOOT",
            //"TBODY", "/TBODY",
            //"COLGROUP", "/COLGROUP",
            "COL"
    ));

    private Table table;

    private int rowNr = -1;

    private int colNr;

    private Table.Cell cell = null;

    private Table.Tag caption;

    public Table parse(Reader r) throws IOException {
        table = new Table();
        rowNr = -1;
        colNr = 0;
        cell = null;
        HtmlParser parser = new HtmlParser();
        parser.setTagInclusionSet(TABLE_TAGS);
        parser.setContentHandler(this);
        IOUtils.copy(r, parser);
        parser.close();
        parser.finished();
        return table;
    }

    public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
        // currently only detect td,th,tr
        String name = localName.toLowerCase();
        if (name.equals("table")) {
            addAttributes(table, attributes);
        } else if (name.equals("tr")) {
            rowNr++;
            colNr = 0;
        } else if (name.equals("td") || name.equals("th")) {
            cell = table.getCell(rowNr, colNr, true);
            while (cell.isInSpan()) {
                cell = table.getCell(rowNr, ++colNr, true);
            }
            cell.setHeader(name.equals("th"));
            addAttributes(cell, attributes);
        } else if (name.equals("caption")) {
            caption = table.setCaption("");
            addAttributes(caption, attributes);
        }
    }

    private static void addAttributes(Table.Cell cell, Attributes attrs) {
        for (int i=0; i<attrs.getLength(); i++) {
            String name = attrs.getLocalName(i);
            if (!name.equals("quotes")) {
                String value = attrs.getValue(i);
                cell.setAttribute(name, value);
            }
        }
    }

    private static void addAttributes(Table.Tag tag, Attributes attrs) {
        for (int i=0; i<attrs.getLength(); i++) {
            String name = attrs.getLocalName(i);
            if (!name.equals("quotes")) {
                String value = attrs.getValue(i);
                tag.setAttribute(name, value);
            }
        }
    }

    private static void addAttributes(Table tag, Attributes attrs) {
        for (int i=0; i<attrs.getLength(); i++) {
            String name = attrs.getLocalName(i);
            if (!name.equals("quotes")) {
                String value = attrs.getValue(i);
                tag.setAttribute(name, value);
            }
        }
    }

    public void endElement(String uri, String localName, String qName) throws SAXException {
        // currently only detect td,th,tr
        String name = localName.toLowerCase();
        if (name.equals("tr")) {
            cell = null;
        } else if (name.equals("td") || name.equals("th")) {
            colNr++;
            cell = null;
        } else if (name.equals("caption")) {
            caption = null;
        }
    }

    public void characters(char ch[], int start, int length) throws SAXException {
        if (cell != null) {
            cell.appendText(ch, start, length);
        } else if (caption != null) {
            caption.appendInnerHtml(ch, start, length);
        }
    }
}