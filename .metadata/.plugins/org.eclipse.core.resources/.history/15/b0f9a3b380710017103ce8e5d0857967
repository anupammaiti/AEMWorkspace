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

import org.apache.commons.lang3.StringEscapeUtils;

import java.util.LinkedList;
import java.util.Iterator;
import java.io.Writer;
import java.io.PrintWriter;
import java.io.IOException;

import com.day.cq.wcm.api.PageFilter;
import com.day.cq.wcm.api.Page;

//TODO comment
public class Sitemap {
        private LinkedList<Link> links = new LinkedList<Link>();


        public Sitemap(Page rootPage) {
            buildLinkAndChildren(rootPage, 0);
        }

        private void buildLinkAndChildren(Page page, int level) {
            if (page!= null) {
                String title = page.getTitle();
                if (title == null) title = page.getName();
                links.add(new Link(page.getPath(), title, level));

                Iterator<Page> children = page.listChildren(new PageFilter());

                while (children.hasNext()) {
                    Page child = children.next();
                    buildLinkAndChildren(child,level+1);
                }
            }
        }

        public class Link {
            private String path;
            private String title;
            private int level;

            public Link(String path, String title, int level) {
                this.path = path;
                this.title = title;
                this.level = level;
            }

            public String getPath() {
                return path;
            }

            public int getLevel() {
                return level;
            }

            public String getTitle() {
                return title;
            }
        }

        public void draw(Writer w) throws IOException {
            PrintWriter out = new PrintWriter(w);

            int previousLevel = -1;

            for (Link aLink: links) {
                if(aLink.getLevel()>previousLevel) out.print("<div class=\"linkcontainer\">");
                else
                    if(aLink.getLevel()<previousLevel) {
                        for(int i=aLink.getLevel();i<previousLevel;i++)
                            out.print("</div>");
                    }

                out.printf("<div class=\"link\"><a href=\"%s.html\">%s</a></div>", StringEscapeUtils.escapeHtml4(aLink.getPath()), StringEscapeUtils.escapeHtml4(aLink.getTitle()));

                previousLevel = aLink.getLevel();
            }

            for(int i=-1;i<previousLevel;i++)
                out.print("</div>");
        }

        public LinkedList<Link> getLinks() {
            return links;
        }
    }