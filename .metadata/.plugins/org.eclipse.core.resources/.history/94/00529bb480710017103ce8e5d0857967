/*
 * Copyright 1997-2010 Day Management AG
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

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.lang3.StringEscapeUtils;

import com.day.cq.wcm.api.Page;
import com.day.cq.wcm.api.PageFilter;
import com.day.text.Text;

/**
 * Provides a generic utility class that can be used to draw a navigation.
 * It specifically does this by providing an iterator over navigation elements.
 * <p/>
 * A navigation element reflects a page and can have different {@link Element.Type}s.
 * Note that the same page might be returned 4 times for the different element
 * types. this offers maximal flexibility when drawing the navigation.
 */
public class Navigation implements Iterable<Navigation.Element> {

    /**
     * page filter
     */
    private final PageFilter filter;

    /**
     * navigation depth
     */
    private final int depth;

    /**
     * root page
     */
    private final Page root;

    /**
     * current path
     */
    private final String currentPath;

    /**
     * current path with "/" suffix
     */
    private final String currentPathS;

    /**
     * Creates a new navigation object.
     * @param current the current page
     * @param absParent the abs level of the navigation root
     * @param filter a page filter for filtering the navigation pages
     * @param depth navigation depth.
     */
    public Navigation(Page current, int absParent, PageFilter filter, int depth) {
        currentPath = current.getPath();
        currentPathS = currentPath + "/";
        Page r = current.getAbsoluteParent(absParent);
        root = r == null ? current : r;
        this.filter = filter;
        this.depth = depth;
    }

    /**
     * Returns an iterator over the navigation elements.
     * @return an iterator.
     */
    public Iterator<Element> iterator() {
        List<Element> list = new ArrayList<Element>();
        if (root != null) {
            fillList(list, root.listChildren(filter), depth-1);
        }
        return list.iterator();
    }

    /**
     * Internally fills the list of navigation elements.
     * @param list the list to fill
     * @param pages current iterator over the pages
     * @param limit current recursion limit
     */
    private void fillList(List<Element> list, Iterator<Page> pages, int limit) {
        boolean first = true;
        while (pages.hasNext()) {
            Page p = pages.next();
            Element e = new Element(p);
            e.first = first;
            first = false;
            e.last = !pages.hasNext();
            String path = p.getPath();
            if (path.equals(currentPath)) {
                e.current = true;
                e.onTrail = true;
            } else if (currentPathS.startsWith(path + "/")) {
                e.onTrail = true;
            }
            Iterator<Page> cs = null;
            if (limit > 0) {
                cs = p.listChildren(filter);
            }
            if (cs != null && cs.hasNext()) {
                e.children = true;
            }
            e.type = Element.Type.ITEM_BEGIN;
            list.add(e);
            if (e.children) {
                list.add(new Element(e, Element.Type.NODE_OPEN));
                fillList(list, cs, limit-1);
                list.add(new Element(e, Element.Type.NODE_CLOSE));
            }
            list.add(new Element(e, Element.Type.ITEM_END));
        }
    }

    /**
     * Navigation element.
     */
    public static class Element {

        /**
         * Type of the navigation element
         */
        public static enum Type {

            /**
             * Denotes that is element is an open node, e.g. an &lt;UL> tag.
             */
            NODE_OPEN,

            /**
             * Denotes that this element is the beginning of an item, e.g. an &lt;LI> tag.
             */
            ITEM_BEGIN,

            /**
             * Denotes that this element is the end of an item, e.g. an &lt;/LI> tag.
             */
            ITEM_END,

            /**
             * Denotes that is element is a closed node, e.g. an &lt;/UL> tag.
             */
            NODE_CLOSE
        }

        /**
         * element type
         */
        private Type type = Type.ITEM_BEGIN;

        /**
         * underlying page
         */
        private final Page page;

        /**
         * the navigation title
         */
        private final String title;

        /**
         * <code>true</code> if this element has children
         */
        private boolean children;

        /**
         * <code>true</code> if this element is on the trail
         */
        private boolean onTrail;

        /**
         * <code>true</code> if this element is the current one
         */
        private boolean current;

        /**
         * <code>true</code> if this is the first element of it's siblings
         */
        private boolean first;

        /**
         * <code>true</code> if this is the last element of it's siblings
         */
        private boolean last;

        /**
         * Creates a new element based on a given one, but with a different type.
         * @param e base element
         * @param type new type
         */
        private Element(Element e, Type type) {
            this.type = type;
            page = e.page;
            title = e.title;
            children = e.children;
            onTrail = e.onTrail;
            current = e.current;
            first = e.first;
            last = e.last;
        }

        /**
         * Creates a new element
         * @param page the underlying page
         */
        private Element(Page page) {
            this.page = page;
            String t = page.getNavigationTitle();
            if (t == null) {
                t = page.getTitle();
            }
            title = t == null ? page.getName() : t;
        }

        /**
         * Returns the element type.
         * @return the element type.
         */
        public Type getType() {
            return type;
        }

        /**
         * Returns the underlying page.
         * @return the underlying page.
         */
        public Page getPage() {
            return page;
        }

        /**
         * Returns the escaped path of the underlying page.
         * <p/>
         * Node that the path is escaped using {@link Text#escape(String, char, boolean)}
         *
         * @return the escaped path.
         */
        public String getPath() {
            return Text.escape(page.getPath(), '%', true);
        }

        /**
         * Returns the unescaped navigation title of the underlying page.
         * if the page does not specific a navigation title, the title is used
         * and ultimately it's name.
         *
         * @return the navigation title
         *
         * @see Page#getNavigationTitle()
         * @see Page#getTitle()
         * @see Page#getName()
         */
        public String getRawTitle() {
            return title;
        }

        /**
         * Returns the escaped navigation title of the underlying page. if the
         * page does not specific a navigation title, the title is used and
         * ultimately it's name.
         * <p/>
         * Note that the title is escaped using {@link StringEscapeUtils#escapeHtml4(String)}
         *
         * @return the navigation title
         *
         * @see Page#getNavigationTitle()
         * @see Page#getTitle()
         * @see Page#getName()
         */
        public String getTitle() {
            return StringEscapeUtils.escapeHtml4(title);
        }

        /**
         * Checks if the this element has children.
         * <p/>
         * Note that this is always <code>true</code> for
         * {@link Type#NODE_OPEN} and {@link Type#NODE_CLOSE} elements.
         *
         * @return <code>true</code> if the current element has children.
         */
        public boolean hasChildren() {
            return children;
        }

        /**
         * Checks if this element is on the trail. i.e. if the underlying page
         * is the same or an ancestor of any degree of the current page, passed
         * in the constructor of the navigation object.
         *
         * @return <code>true</code> if this element is on the trail.
         */
        public boolean isOnTrail() {
            return onTrail;
        }

        /**
         * Checks if this element is the current one. i.e. if the underlying page
         * is the same as current one, passed in the constructor of the navigation
         * object.
         *
         * @return <code>true</code> if this element is the current one.
         */
        public boolean isCurrent() {
            return current;
        }

        /**
         * Checks if this element is the first of it's siblings.
         * @return <code>true</code> if this element is the first of it's siblings.
         */
        public boolean isFirst() {
            return first;
        }

        /**
         * Checks if this element is the last of it's siblings.
         * @return <code>true</code> if this element is the last of it's siblings.
         */
        public boolean isLast() {
            return last;
        }
    }
}