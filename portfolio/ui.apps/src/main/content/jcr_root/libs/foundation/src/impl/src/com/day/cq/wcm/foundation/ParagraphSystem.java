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
package com.day.cq.wcm.foundation;

import com.day.cq.commons.DiffInfo;
import com.day.cq.commons.DiffService;
import com.day.text.Text;
import org.apache.sling.api.SlingHttpServletRequest;
import org.apache.sling.api.request.RequestParameter;
import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ResourceResolver;
import org.apache.sling.api.resource.ResourceUtil;
import org.apache.sling.api.resource.ValueMap;
import org.apache.sling.jcr.resource.JcrResourceConstants;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.jcr.Node;
import javax.jcr.RepositoryException;
import javax.jcr.Session;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

/**
 * Provides helper methods for drawing a paragraph system. It detects
 * columns control resources and adds the respective paragraph type and
 * columns control information to the paragraphs.
 */
public class ParagraphSystem {

    /**
     * default logger
     */
    public static final Logger log = LoggerFactory.getLogger(ParagraphSystem.class);

    /**
     * Request parameter for the version diff.
     */
    public static final String PARAMETER_VERSION_DIFF = DiffService.REQUEST_PARAM_DIFF_TO;

    /**
     * Request parameter for the version view.
     */
    public static final String PARAMETER_VERSION_VIEW = "cq_view";

    /**
     * name of the column control type property
     */
    public static final String COL_CTL_TYPE = "controlType";

    /**
     * name of the layout property
     */
    public static final String COL_CTL_LAYOUT = "layout";

    /**
     * resource of this parsys
     */
    private final Resource resource;

    /**
     * resolver
     */
    private final ResourceResolver resolver;

    /**
     * Column control resource type
     */
    private String colCtrlResourceType;

    /**
     * Column control resource type
     */
    private String colCtrlSuffix = "/colctrl";

    /**
     * the css prefix for the column classes
     */
    private String defaultLayout = "1;cq-colctrl-default";

    /**
     * list of paragraphs
     */
    private List<Paragraph> paras;

    /**
     * Version label for displaying a diff
     */
    private final String versionLabel;

    /**
     * Is this a version diff or a version view?
     */
    private final boolean isVersionDiff;

    /**
     * Create the paragraph system based on the given
     * request. This method takes the current resource
     * from the request and evaluates possible request
     * parameters (for version diff etc.
     */
    public static ParagraphSystem create(Resource resource,
                                         SlingHttpServletRequest req) {
        final RequestParameter parameter = req.getRequestParameter(PARAMETER_VERSION_DIFF);
        String label = null;
        if (null != parameter) {
            try {
                label = parameter.getString("UTF-8");
            } catch (UnsupportedEncodingException e) {
                log.warn("create: error while decoding diff view parameter: ", e);
            }
        }

        boolean isDiff = label != null;
        if (label == null) {
            label = req.getParameter(PARAMETER_VERSION_VIEW);
        }
        return new ParagraphSystem(resource, label, isDiff);
    }

    /**
     * Creates a new paragraph system based on the given resource
     *
     * @param resource underlying resource
     */
    public ParagraphSystem(Resource resource) {
        this(resource, null, true);
    }

    /**
     * Creates a new paragraph system based on the given resource
     * and sets up the paragraph system to compare itself to a
     * versioned resource.
     * If the specified version does not exists, the paragraph
     * system is displayed as if no version has been specified.
     *
     * @param resource     underlying resource
     * @param versionLabel optional version label for comparing.
     * @since 5.2
     */
    public ParagraphSystem(Resource resource, String versionLabel) {
        this(resource, versionLabel, true);
    }

    /**
     * Creates a new paragraph system based on the given resource
     * and sets up the paragraph system to compare itself to a
     * versioned resource.
     * If the specified version does not exists, the paragraph
     * system is displayed as if no version has been specified.
     *
     * @param resource     underlying resource
     * @param versionLabel optional version label for comparing.
     * @param isVersionDiff <code>true</code> if this parsys is used for
     *        version diffing
     * @since 5.2
     */
    public ParagraphSystem(Resource resource, String versionLabel, boolean isVersionDiff) {
        this.isVersionDiff = isVersionDiff;
        this.resource = resource;
        this.resolver = resource.getResourceResolver();
        String type = resource.getResourceType() + colCtrlSuffix;
        if (type.startsWith("/")) {
            for (String sp : resolver.getSearchPath()) {
                if (type.startsWith(sp)) {
                    type = type.substring(sp.length());
                    break;
                }
            }
        }
        if (versionLabel != null && versionLabel.trim().length() > 0) {
            this.versionLabel = versionLabel;
        } else {
            this.versionLabel = null;
        }
    }

    /**
     * Sets the columns control resource type used when fixing the structure
     * @param colCtrlResourceType the resource type
     */
    public void setColCtrlResourceType(String colCtrlResourceType) {
        this.colCtrlResourceType = colCtrlResourceType;
    }

    /**
     * Returns the default layout
     *
     * @return the default layout
     */
    public String getDefaultLayout() {
        return defaultLayout;
    }

    /**
     * Sets the default layout in the format:
     * <code>numCols;cssClass</code>
     *
     * @param defaultLayout default layout
     */
    public void setDefaultLayout(String defaultLayout) {
        this.defaultLayout = defaultLayout;
    }

    /**
     * Returns the list of paragraphs of this system
     *
     * @return the list of paragraphs
     */
    public List<Paragraph> paragraphs() {
        initParas(false);
        return paras;
    }

    /**
     * Checks the structure of this paragraph system and fixes it. note that
     * the changes are not saved.
     */
    public void repair() {
        paras = null;
        initParas(true);
    }

    /**
     * internally initialize the list of paragraphs
     * @param fixContentStructure if <code>true</code> the underlying content
     *        is adjusted to a correct layout.
     */
    private void initParas(boolean fixContentStructure) {
        if (paras != null) {
            return;
        }
        Resource versionResource = null;
        // try to create parsys node if not exists
        if (resource.adaptTo(Node.class) == null) {
            if (fixContentStructure) {
                try {
                    String path = resource.getPath();
                    int idx = path.lastIndexOf('/');
                    String parentPath = path.substring(0, idx);
                    String name = path.substring(idx + 1);
                    Session s = resolver.adaptTo(Session.class);
                    Node parentNode = (Node) s.getItem(parentPath);
                    Node parNode = parentNode.addNode(name);
                    parNode.setProperty(JcrResourceConstants.SLING_RESOURCE_TYPE_PROPERTY, resource.getResourceType());
                } catch (Exception e) {
                    log.warn("Could not create missing {} node.", resource.getPath(), e);
                }
            }
        } else {
            // if the parsys does not exists (case above), we don't need to check for
            // an older version!
            if (versionLabel != null) {
                versionResource = DiffInfo.getVersionedResource(resource, versionLabel);
            }
        }
        //if this is a version show, collect versioned paragraphs
        if (versionResource != null && !isVersionDiff) {
            paras = collectParagraphs(versionResource, false);
        } else {
            paras = collectParagraphs(resource, fixContentStructure);
            if (versionResource != null) {
                List<Paragraph> versionedParas = collectParagraphs(versionResource, false);
                compare(paras, versionedParas);
            }
        }
    }

    private List<Paragraph> collectParagraphs(Resource resource, boolean fixStructure) {
        List<Paragraph> paragraphs = new LinkedList<Paragraph>();
        int colNum = 0;
        int numCols = 0;
        String layout = "default";

        LinkedList<Paragraph> toRemove = new LinkedList<Paragraph>();
        LinkedList<Paragraph> toCreate = new LinkedList<Paragraph>();
        Resource lastStartResource = null;
        int lastStartIndex = 0;
        Resource followingLastStartResource = null;

        for (Iterator<Resource> iter = resolver.listChildren(resource); iter.hasNext();) {
            Resource res = iter.next();
            if (lastStartResource != null && followingLastStartResource == null) {
                followingLastStartResource = res;
            }
            if (res.getResourceType().endsWith(colCtrlSuffix)) {
                ValueMap resProps = res.adaptTo(ValueMap.class);
                Paragraph.Type type = null;
                try {
                    type = Paragraph.Type.valueOf(resProps.get(COL_CTL_TYPE, "start").toUpperCase());
                } catch (IllegalArgumentException e) {
                    // ignore. handle later
                }

                if (type == Paragraph.Type.START) {
                    // remember resource type for creation of BREAK's and END
                    colCtrlResourceType = res.getResourceType();

                    // if already in colctrl, there is an end missing.
                    if (numCols > 0 && fixStructure) {
                        while (colNum < numCols - 1) {
                            Paragraph para = new Paragraph(followingLastStartResource, Paragraph.Type.BREAK, ++colNum, layout, numCols);
                            if (followingLastStartResource != null) {
                                paragraphs.add(++lastStartIndex, para);
                            } else {
                                paragraphs.add(para);
                            }
                            toCreate.add(para);
                        }
                        Paragraph para = new Paragraph(followingLastStartResource, Paragraph.Type.END, colNum, layout, numCols);
                        if (followingLastStartResource != null) {
                            paragraphs.add(++lastStartIndex, para);
                        } else {
                            paragraphs.add(para);
                        }
                        toCreate.add(para);

                    }
                    colNum = 0;
                    numCols = 1;
                    layout = resProps.get(COL_CTL_LAYOUT, defaultLayout);
                    int i = layout.indexOf(';');
                    if (i > 0) {
                        try {
                            numCols = Integer.parseInt(layout.substring(0, i));
                        } catch (NumberFormatException e) {
                            // ignore
                        }
                        layout = layout.substring(i + 1);
                    }
                    Paragraph toInsert = new Paragraph(res, type, colNum, layout, numCols);
                    paragraphs.add(toInsert);
                    lastStartResource = res;
                    lastStartIndex = paragraphs.indexOf(toInsert);
                    followingLastStartResource = null;

                } else if (type == Paragraph.Type.BREAK) {
                    Paragraph para = new Paragraph(res, type, ++colNum, layout, numCols);
                    if (numCols > 0) {
                        if (colNum >= numCols) {
                            // if there is a break to many, schedule it for removal
                            toRemove.add(para);
                        } else {
                            paragraphs.add(para);
                        }
                    } else {
                        // if no column control is started, schedule it for removal
                        toRemove.add(para);
                    }

                } else if (type == Paragraph.Type.END) {
                    if (numCols > 0) {
                        // if there are breaks missing, add new ones
                        while (colNum < numCols - 1 && fixStructure) {
                            Paragraph para = new Paragraph(res, Paragraph.Type.BREAK, ++colNum, layout, numCols);
                            paragraphs.add(para);
                            toCreate.add(para);
                        }
                        numCols = 0;
                        colNum = 0;
                        paragraphs.add(new Paragraph(res, Paragraph.Type.END, colNum, layout, numCols));
                    } else {
                        // if no column control is started, schedule it for removal
                        Paragraph para = new Paragraph(res, Paragraph.Type.END);
                        toRemove.add(para);
                    }
                } else {
                    // schedule invalid types for removal
                    Paragraph para = new Paragraph(res, Paragraph.Type.END);
                    toRemove.add(para);
                }
            } else {
                paragraphs.add(new Paragraph(res, Paragraph.Type.NORMAL, colNum, layout, numCols));
            }
        }

        // if column control is not closed add it
        if (numCols > 0 && fixStructure ) {
            // if there are breaks missing, add new ones
            while (colNum < numCols - 1) {
                Paragraph para = new Paragraph(followingLastStartResource, Paragraph.Type.BREAK, ++colNum, layout, numCols);
                if (followingLastStartResource != null) {
                    paragraphs.add(++lastStartIndex, para);
                } else {
                    paragraphs.add(para);
                }
                toCreate.add(para);
            }
            Paragraph para = new Paragraph(followingLastStartResource, Paragraph.Type.END, colNum, layout, numCols);
            if (followingLastStartResource != null) {
                paragraphs.add(++lastStartIndex, para);
            } else {
                paragraphs.add(para);
            }
            toCreate.add(para);
        }

        if (fixStructure) {
            // fix structure
            try {
                fixStructure(toRemove, toCreate);
            } catch (RepositoryException e) {
                log.error("Error while fixing paragraph system structure.", e);
            }
        }
        return paragraphs;
    }

    /**
     * This the structure of the paragraph system. e.g. when breaks are missing.
     *
     * @param toRemove list of paragraphs to remove
     * @param toCreate list of paragraphs to add
     * @return <code>true</code> if content was modified
     * @throws RepositoryException if a repository error occurs
     */
    private boolean fixStructure(List<Paragraph> toRemove, List<Paragraph> toCreate)
            throws RepositoryException {

        // first remove them
        Node parent = resource.adaptTo(Node.class);
        for (Paragraph p : toRemove) {
            Node pn = p.adaptTo(Node.class);
            if (pn != null) {
                pn.remove();
            }
        }

        // then create new ones
        int nr = 0;
        for (Paragraph p : toCreate) {
            String type = p.getType().toString().toLowerCase();
            Node node = parent.addNode("col_" + type + System.currentTimeMillis() + nr++);
            node.setProperty(JcrResourceConstants.SLING_RESOURCE_TYPE_PROPERTY, colCtrlResourceType);
            node.setProperty(COL_CTL_TYPE, type);
            if (p.getResource() != null) {
                String beforeName = Text.getName(p.getResource().getPath());
                parent.orderBefore(node.getName(), beforeName);
            }
        }

        // and save
        return !toCreate.isEmpty() || !toRemove.isEmpty();
    }

    private void removeColumnLayoutParagraphs(List<Paragraph> list) {
        Iterator<Paragraph> i = list.iterator();
        while (i.hasNext()) {
            Paragraph p = i.next();
            if (p.getType() != Paragraph.Type.NORMAL) {
                i.remove();
            }
        }
    }

    private void compare(List<Paragraph> orig, List<Paragraph> versioned) {
        // remove column layout paragraphs first
        List<Paragraph> current = new ArrayList<Paragraph>(orig);
        removeColumnLayoutParagraphs(current);
        removeColumnLayoutParagraphs(versioned);

        // number of paragraphs
        int M = current.size();
        int N = versioned.size();

        List<Paragraph> out = new ArrayList<Paragraph>();
        List<Paragraph> in = new ArrayList<Paragraph>();
        List<Paragraph> moved = new ArrayList<Paragraph>();

        // opt[i][j] = length of LCS of x[i..M] and y[j..N]
        int[][] opt = new int[M + 1][N + 1];

        // compute length of LCS and all subproblems via dynamic programming
        for (int i = M - 1; i >= 0; i--) {
            for (int j = N - 1; j >= 0; j--) {
                if (ResourceUtil.getName(current.get(i)).equals(ResourceUtil.getName(versioned.get(j))))
                    opt[i][j] = opt[i + 1][j + 1] + 1;
                else
                    opt[i][j] = Math.max(opt[i + 1][j], opt[i][j + 1]);
            }
        }

        // recover LCS itself and print out non-matching lines to standard output
        int i = 0, j = 0;
        while (i < M && j < N) {
            if (ResourceUtil.getName(current.get(i)).equals(ResourceUtil.getName(versioned.get(j)))) {
                i++;
                j++;
            } else if (opt[i + 1][j] >= opt[i][j + 1]) {
                Paragraph value = current.get(i++);
                Paragraph outP = search(out, value);
                if (outP == null) {
                    in.add(value);
                } else {
                    moved.add(value);
                    out.remove(outP);
                }
            } else {
                Paragraph value = versioned.get(j++);
                Paragraph inP = search(in, value);
                if (inP == null) {
                    out.add(value);
                } else {
                    moved.add(inP);
                    in.remove(inP);
                }
            }
        }

        // dump out one remainder of one string if the other is exhausted
        while (i < M || j < N) {
            if (i == M) {
                Paragraph value = versioned.get(j++);
                Paragraph inP = search(in, value);
                if (inP == null) {
                    out.add(value);
                } else {
                    moved.add(inP);
                    in.remove(inP);
                }
            } else if (j == N) {
                Paragraph value = current.get(i++);
                Paragraph outP = search(out, value);
                if (outP == null) {
                    in.add(value);
                } else {
                    moved.add(value);
                    out.remove(outP);
                }
            }
        }
        // set diff information
        // 1. new paragraphs
        for (Paragraph v : in) {
            v.setDiffInfo(new DiffInfo(null, com.day.cq.commons.DiffInfo.TYPE.ADDED));
        }
        // 2. removed paras
        for (Paragraph v : out) {
            v.setDiffInfo(new DiffInfo(v.getResource(), DiffInfo.TYPE.REMOVED));
            int pos = versioned.indexOf(v) + 1;
            while (pos < versioned.size()) {
                Paragraph nextPara = search(orig, versioned.get(pos));
                if (nextPara != null) {
                    int index = orig.indexOf(nextPara);
                    orig.add(index, v);
                    break;
                }
                pos++;
            }
            if (pos == versioned.size()) {
                orig.add(v);
            }
        }
        // 3. moved paras
        for (Paragraph v : moved) {
            v.setDiffInfo(new DiffInfo(search(versioned, v), DiffInfo.TYPE.MOVED));
        }
        // 4. same paras
        for (Paragraph v : current) {
            if (v.adaptTo(DiffInfo.class) == null) {
                v.setDiffInfo(new DiffInfo(search(versioned, v), DiffInfo.TYPE.SAME));
            }
        }
    }

    private Paragraph search(List<Paragraph> paras, Paragraph rsrc) {
        String title = ResourceUtil.getName(rsrc);
        for (Paragraph p : paras) {
            if (ResourceUtil.getName(p).equals(title)) {
                return p;
            }
        }
        return null;
    }
}