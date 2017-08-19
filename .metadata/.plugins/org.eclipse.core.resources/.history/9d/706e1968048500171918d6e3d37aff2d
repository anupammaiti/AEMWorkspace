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

import java.awt.Color;
import java.awt.Rectangle;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.jcr.RepositoryException;

import org.apache.sling.api.resource.Resource;
import org.apache.sling.api.resource.ValueMap;

import com.day.cq.commons.jcr.JcrConstants;
import com.day.cq.graphics.Graph;
import com.day.cq.graphics.chart.Axis;
import com.day.cq.graphics.chart.BarChart;
import com.day.cq.graphics.chart.Data;
import com.day.cq.graphics.chart.Grid;
import com.day.cq.graphics.chart.LineChart;
import com.day.cq.graphics.chart.PieChart;
import com.day.cq.wcm.api.designer.Style;
import com.day.cq.wcm.foundation.Table.Cell;
import com.day.cq.wcm.foundation.Table.Row;
import com.day.image.Font;
import com.day.image.Layer;
import com.day.image.LineStyle;

/**
 * Provides convenience methods for displaying charts.
 */
public class Chart {
    /**
     * value of the pie chart type
     */
    public static final String PIE_CHART_TYPE = "pie";

    /**
     * value of the bar chart type
     */
    public static final String BAR_CHART_TYPE = "bar";

    /**
     * value of the line chart type
     */
    public static final String LINE_CHART_TYPE = "line";

    /**
     * name of the title property
     */
    public static final String PN_TITLE = JcrConstants.JCR_TITLE;

    /**
     * name of the chart type property
     */
    public static final String PN_CHART_TYPE = "chartType";

    /**
     * name of the alt name property
     */
    public static final String PN_ALT = "chartAlt";

    /**
     * name of the data property
     */
    public static final String PN_DATA = "chartData";

    /**
     * name of the width property
     */
    public static final String PN_WIDTH = "chartWidth";

    /**
     * name of the width property
     */
    public static final String PN_HEIGHT = "chartHeight";

    /**
     * name of the start angle property for pie charts
     */
    public static final String PN_PC_START_ANGLE = "pieStartAngle";

    /**
     * name of the line width property for line charts
     */
    public static final String PN_LC_LINE_WIDTH = "lineLineWidth";

    /**
     * name of the bar width property for bar charts
     */
    public static final String PN_BC_BAR_WIDTH = "barBarWidth";

    /**
     * name of the bar spacing property for bar charts
     */
    public static final String PN_BC_BAR_SPACING = "barBarSpacing";

    /**
     * name of the background color property
     */
    public static final String PN_BG_COLOR = "bgColor";

    /**
     * name of the label color property
     */
    public static final String PN_LABEL_COLOR = "labelColor";

    /**
     * name of the line color property
     */
    public static final String PN_LINE_COLOR = "lineColor";

    /**
     * name of the data color property
     */
    public static final String PN_DATA_COLORS = "dataColors";
    
    /** Default data color */
    public static final Color DEFAULT_DATA_COLOR = Color.BLUE;

    /**
     * internal properties
     */
    private final ValueMap properties;

    /**
     * map of overlaid properties
     */
    private Map<String, Object> overlaid = new HashMap<String, Object>();

    /**
     * map of default properties
     */
    private Map<String, Object> defaults = new HashMap<String, Object>();

    /**
     * internal data table
     */
    private Table table;

    /**
     * Creates a new chart based on the given resource.
     *
     * @param resource resource of the chart
     * @throws IllegalArgumentException if the given resource is not adaptable to node.
     */
    public Chart(Resource resource) {
        this.properties = resource == null ? ValueMap.EMPTY : resource
                .adaptTo(ValueMap.class);

        defaults.put(PN_WIDTH, 400);
        defaults.put(PN_HEIGHT, 200);
        defaults.put(PN_LINE_COLOR, "808080");
        defaults.put(PN_LABEL_COLOR, "808080");
        defaults.put(PN_CHART_TYPE, PIE_CHART_TYPE);
        defaults.put(PN_PC_START_ANGLE, 0.0);
        defaults.put(PN_LC_LINE_WIDTH, 2.0f);
        defaults.put(PN_BC_BAR_WIDTH, 20);
        defaults.put(PN_BC_BAR_SPACING, 0);

        initChartData();
    }

    /**
     * Checks if this chart has content
     *
     * @return <code>true</code> if this chart has content
     */
    public boolean hasData() {
        boolean hasData = false;
        if (table != null) {
            for (Table.Row row : table.getRows()) {
                for (Table.Cell cell : row.getCells()) {
                    if ((cell.getText() != null)
                            && (!cell.getText().equals(""))) {
                        hasData = true;
                    }
                }
            }
        }
        return hasData;
    }

    /**
     * Returns the chart alt name as defined by {@value #PN_ALT}
     *
     * @return the alt name
     * @see #PN_ALT
     */
    public String getAlt() {
        return getString(PN_ALT);
    }

    /**
     * Get a property either from the overlaid map or the underlying properties.
     *
     * @param name name of the property
     * @return value of the property or null
     */
    public Object get(String name) {
        Object value = overlaid.get(name);
        if (value == null) {
            value = properties.get(name);
        }
        if (value == null) {
            value = defaults.get(name);
        }
        return value;
    }

    /**
     * Get a string property either from the overlaid map or the underlying
     * properties.
     *
     * @param name name of the property
     * @return string value of the property or null
     */
    public String getString(String name) {
        Object value = get(name);
        if (value != null) {
            return (String) value;
        } else {
            return null;
        }
    }

    /**
     * Get a integer property either from the overlaid map or the underlying
     * properties.
     *
     * @param name name of the property
     * @return integer value of the property or null
     */
    public Integer getInt(String name) {
        Object value = get(name);
        if (value != null) {
            if (value instanceof String) {
                return Integer.valueOf((String) value);
            }
            return (Integer) value;
        } else {
            return null;
        }
    }

    /**
     * Get a double property either from the overlaid map or the underlying
     * properties.
     *
     * @param name name of the property
     * @return double value of the property or null
     */
    public Double getDouble(String name) {
        Object value = get(name);
        if (value != null) {
            if (value instanceof String) {
                return Double.valueOf((String) value);
            }
            return (Double) value;
        } else {
            return null;
        }
    }

    /**
     * Get a float property either from the overlaid map or the underlying
     * properties.
     *
     * @param name name of the property
     * @return double value of the property or null
     */
    public Float getFloat(String name) {
        Object value = get(name);
        if (value != null) {
            if (value instanceof String) {
                return Float.valueOf((String) value);
            }
            return (Float) value;
        } else {
            return null;
        }
    }

    /**
     * Get a color either from the overlaid map or the underlying properties.
     *
     * @param name name of the property
     * @return Color color of the property or null
     */
    public Color getColor(String name) {
        String value = getString(name);

        Color color = null;
        if ((value != null) && (!value.equals(""))) {
            if (!value.startsWith("#")) {
                value = "#" + value;
            }
            color = Color.decode(value);
        }
        return color;
    }

    /**
     * Loads several definitions from style.
     *
     * @param style style to load definitions from
     */
    public void loadStyleData(Style style) {
        if (style != null) {
            overlaid.put(PN_LINE_COLOR, style.get(PN_LINE_COLOR));
            overlaid.put(PN_LABEL_COLOR, style.get(PN_LABEL_COLOR));
            overlaid.put(PN_BG_COLOR, style.get(PN_BG_COLOR));
            overlaid.put(PN_DATA_COLORS, style.get(PN_DATA_COLORS));

            overlaid.put(PN_PC_START_ANGLE, style.get(PN_PC_START_ANGLE));
            overlaid.put(PN_LC_LINE_WIDTH, style.get(PN_LC_LINE_WIDTH));
            overlaid.put(PN_BC_BAR_WIDTH, style.get(PN_BC_BAR_WIDTH));
            overlaid.put(PN_BC_BAR_SPACING, style.get(PN_BC_BAR_SPACING));
        }
        initStyle();
    }

    /**
     * Returns the chart layer of this chart.
     *
     * @return the layer
     * @throws IOException         if an I/O error occurs.
     * @throws RepositoryException if a repository error occurs.
     */
    public Layer getChartLayer() throws IOException, RepositoryException {
        Graph graph = getGraph();
        setDataColors(graph);

        Layer layer = graph.draw(true);
        layer.setTransparency(new Color(0xffffffff, true));
        return layer;
    }

    /**
     * Returns the legend layer of this chart.
     *
     * @return the layer
     * @throws IOException         if an I/O error occurs.
     * @throws RepositoryException if a repository error occurs.
     */
    public Layer getLegendLayer() throws IOException, RepositoryException {
        Graph graph = getGraph();
        setDataColors(graph);
        try {
            graph.draw(false);
        } catch (Exception e) {
            // ignore this
        }
        Layer layer = new Layer(1, 1, bgColor);
        layer.setPaint(labelColor);

        if (get(PN_CHART_TYPE).equals(PIE_CHART_TYPE)) {
            int numlines = 0;
            String txt = labels[0];
            if (txt != "") {
                numlines = layer.drawText(0, 0, 165, 0, txt, labelFont,
                        Font.TTANTIALIASED | Font.ALIGN_RIGHT | Font.ALIGN_TOP,
                        labelCs, labelLs);
            }

            layer.drawText(0, 0, 300, 0, "% of Total", labelFont,
                    Font.TTANTIALIASED | Font.ALIGN_RIGHT | Font.ALIGN_TOP,
                    labelCs, labelLs);

            // draw legend: one entry per pie segment
            int y = numlines * (legendLs / 16) + (legendLs / 32);

            ArrayList<Integer> linePos = new ArrayList<Integer>();
            linePos.add(y - 3);

            double sum = 0;
            for (int i = 0; i < legends.length; i++) {
                txt = legends[i];

                numlines = layer.drawText(17, y, 185, 0, txt, legendFont,
                        Font.TTANTIALIASED | Font.ALIGN_LEFT | Font.ALIGN_TOP,
                        legendCs, legendLs);

                layer.drawText(0, y, 165, 0, String.valueOf(samples[i][0]),
                        legendFont, Font.TTANTIALIASED | Font.ALIGN_RIGHT
                        | Font.ALIGN_TOP, legendCs, legendLs);

                txt = String.format("%.02f%%", graph.getYAxis()
                        .getTickSample(i));

                layer.drawText(0, y, 300, 0, txt, legendFont,
                        Font.TTANTIALIASED | Font.ALIGN_RIGHT | Font.ALIGN_TOP,
                        legendCs, legendLs);

                Rectangle rect = new Rectangle(0, y, 15, 11);
                layer.setPaint(getDataColor(i));
                layer.fillRect(rect);
                layer.setPaint(labelColor);

                linePos.add(y + 12);
                y += numlines * (legendLs / 16) + (legendLs / 32);
                sum += samples[i][0];
            }

            // draw summary: 'total.......'
            int heigth = layer.getHeight() + 7;
            layer.drawText(0, heigth, 0, 0, "Total", legendFontBold,
                    Font.TTANTIALIASED | Font.ALIGN_LEFT | Font.ALIGN_TOP,
                    labelCs, labelLs);

            txt = String.format("%s", sum);

            layer.drawText(0, heigth, 165, 0, txt, legendFontBold,
                    Font.TTANTIALIASED | Font.ALIGN_RIGHT | Font.ALIGN_TOP,
                    labelCs, labelLs);

            // draw lines
            layer.setPaint(lineColor);
            for (Integer ypos : linePos) {
                layer.drawLine(0, ypos, 300, ypos);
            }
        } else {
            int y = 0;
            for (int i = 0; i < samples.length; i++) {
                String txt = legends[i];

                int numlines = layer.drawText(20, y, 0, 0, txt, legendFont,
                        Font.TTANTIALIASED | Font.ALIGN_LEFT | Font.ALIGN_TOP,
                        legendCs, legendLs);

                Rectangle rect = new Rectangle(0, y, 15, 11);
                layer.setPaint(getDataColor(i));
                layer.fillRect(rect);
                layer.setPaint(labelColor);

                y += numlines * (legendLs / 16) + (legendLs / 32);
            }
        }
        layer.setTransparency(new Color(0xffffffff, true));
        return layer;
    }

    private Color bgColor;
    private Color labelColor;
    private Color lineColor;

    private Font labelFont;
    private Font legendFont;
    private Font legendFontBold;

    private LineStyle lineStyle;
    private LineStyle gridLineStyle;

    private Double labelLsDef;
    private int labelLs;
    private double labelCs;

    private Double legendLsDef;
    private int legendLs;
    private double legendCs;

    ArrayList<String> dataColors = new ArrayList<String>();

    private void initStyle() {
        bgColor = getColor(PN_BG_COLOR);
        labelColor = getColor(PN_LABEL_COLOR);
        lineColor = getColor(PN_LINE_COLOR);

        labelFont = new Font("Myriad Pro", 9);
        legendFont = new Font("Myriad Pro", 9);
        legendFontBold = new Font("Myriad Pro", 9, Font.BOLD);

        lineStyle = new LineStyle(lineColor);
        gridLineStyle = new LineStyle(lineColor, 3, 2, 0.2f);

        labelLsDef = new Double(8) * 16 * 1.3;
        labelLs = labelLsDef.intValue();
        labelCs = 0;

        legendLsDef = new Double(8) * 16 * 1.3;
        legendLs = legendLsDef.intValue();
        legendCs = 0;

        final String dataColorString = getString(PN_DATA_COLORS);
        if(dataColorString != null) {
            String[] dataColorValues = dataColorString.split(":");
            for (String dataColor : dataColorValues) {
                dataColors.add("#" + dataColor);
            }
        }
    }

    private Color getDataColor(int index) {
        if(dataColors.size() == 0) {
            return DEFAULT_DATA_COLOR;
        }
        return Color.decode(dataColors.get(index % dataColors.size()));
    }

    private void setDataColors(Graph graph) {
        Data data = graph.getData();
        for (int row = 0; row < data.getNumrows(); row++) {
            data.getDataRow(row).setColor(getDataColor(row));
        }
    }

    private Graph getGraph() {
        String chartType = getString(PN_CHART_TYPE);
        Graph graph = new Graph(getInt(PN_WIDTH), getInt(PN_HEIGHT), chartType);
        graph.initGraphSamples(labels, legends, samples);

        graph.setBgColor(bgColor);
        graph.setGrid(new Grid(graph, gridLineStyle));

        //y width is computed depending the max value digits length (7 pixels per char)
        int yaWidth = (("" + this.maxValue).length()) * 7;
        int xaHeight = 20;

        // set chart type specific properties
        if (get(PN_CHART_TYPE).equals(PIE_CHART_TYPE)) {
            ((PieChart) graph.getChart())
                    .setStart(getDouble(PN_PC_START_ANGLE));

            ((PieChart) graph.getChart()).setHeight(getInt(PN_HEIGHT));
            if (properties.get(PN_WIDTH) == null) {
                // make square if width is not explicitly defined
                ((PieChart) graph.getChart()).setWidth(getInt(PN_HEIGHT));
            } else {
                ((PieChart) graph.getChart()).setWidth(getInt(PN_WIDTH));
            }
        } else if (get(PN_CHART_TYPE).equals(LINE_CHART_TYPE)) {
            ((LineChart) graph.getChart())
                    .setLinewidth(getFloat(PN_LC_LINE_WIDTH));

            //max 10 lines per 100px height
            ((LineChart) graph.getChart()).setNumlines(getInt(PN_HEIGHT) / 10);

            initYAxis(graph, yaWidth, xaHeight);
            int xaWidth = initXAxis(graph, yaWidth, xaHeight);

            int xaTickDist = xaWidth / (this.table.getNumCols() - 2);
            graph.getXAxis().setTickdistance(xaTickDist);
        } else if (get(PN_CHART_TYPE).equals(BAR_CHART_TYPE)) {
            ((BarChart) graph.getChart()).setBarwidth(getInt(PN_BC_BAR_WIDTH));
            ((BarChart) graph.getChart())
                    .setBarspacing(getInt(PN_BC_BAR_SPACING));
            ((BarChart) graph.getChart()).setStyle(BarChart.BARS_CASCADE);

            //max 10 lines per 100px height
            ((BarChart) graph.getChart()).setNumlines(getInt(PN_HEIGHT) / 10);

            initYAxis(graph, yaWidth, xaHeight);
            int xaWidth = initXAxis(graph, yaWidth, xaHeight);

            int xaTickDist = xaWidth / (this.table.getNumCols() - 1);
            graph.getXAxis().setTickdistance(xaTickDist);
            graph.getXAxis().setRangetype(Axis.TYPE_CATEG);
        }
        return graph;
    }

    private int initXAxis(Graph graph, int yaWidth, int xaHeight) {
        int xaWidth = getInt(PN_WIDTH) - yaWidth;

        graph.getXAxis().setWidth(xaWidth);
        graph.getXAxis().setHeight(xaHeight);
        graph.getXAxis().setStyle(lineStyle);

        graph.getXAxis().setTickstyle(lineStyle);
        graph.getXAxis().setTickfrom(-4);
        graph.getXAxis().setTickto(0);

        graph.getXAxis().setLabelalign(Axis.LABEL_CENTER);
        graph.getXAxis().setLabelfont(labelFont);
        graph.getXAxis().setLabelcolor(labelColor);
        graph.getXAxis().setLabeltype(Axis.LABEL_TYPE_NUMBER);
        graph.getXAxis().setLabeldx(0);
        graph.getXAxis().setLabeldy(-4);

        return xaWidth;
    }

    private int initYAxis(Graph graph, int yaWidth, int xaHeight) {
        int yaHeight = getInt(PN_HEIGHT) - xaHeight;

        //5 is the distance between y labels and y axis   
        graph.getYAxis().setWidth(yaWidth + 5);
        graph.getYAxis().setStyle(lineStyle);

        //default is also max tick distance: 10% of height max 
        int yaTickDist = getInt(PN_HEIGHT) / 10;
        graph.getYAxis().setTickdistance(yaTickDist);
        graph.getYAxis().setTickstyle(lineStyle);

        graph.getYAxis().setLabelalign(Axis.LABEL_BELOW);
        graph.getYAxis().setLabelfont(labelFont);
        graph.getYAxis().setLabelcolor(labelColor);
        graph.getYAxis().setLabeldx(-yaWidth);
        graph.getYAxis().setLabeldy(0);

        return yaHeight;
    }

    private String[] labels;
    private String[] legends;
    private double[][] samples;
    private double maxValue = 0;

    private void initChartData() {
        String data = getString(PN_DATA);
        if ((data != null) && (!data.equals(""))) {
            ArrayList<String> labels = new ArrayList<String>();
            ArrayList<String> legends = new ArrayList<String>();
            ArrayList<Double[]> samples = new ArrayList<Double[]>();

            this.table = Table.fromCSV(data, ',');
            List<Row> rows = this.table.getRows();

            boolean firstRow = true;
            for (int i = 0; i < rows.size(); i++) {
                List<Cell> cells = rows.get(i).getCells();

                if (firstRow) {
                    firstRow = false;
                    for (int j = 0; j < cells.size(); j++) {
                        if (cells.get(j).getText() != null) {
                            labels.add(cells.get(j).getText());
                        } else {
                            labels.add(" ");
                        }
                    }
                } else {
                    legends.add(cells.get(0).getText());

                    ArrayList<Double> dataRow = new ArrayList<Double>();
                    for (int j = 1; j < cells.size(); j++) {
                        String txt = (cells.get(j).getText() != null) ?
                                cells.get(j).getText() :
                                "0.0";
                        dataRow.add(Double.valueOf(txt));
                    }
                    samples.add(dataRow.toArray(new Double[0]));
                }
            }
            int width = 0;
            int height = 0;
            for (Double[] row : samples) {
                if (row.length > width) {
                    width = row.length;
                }
                height++;
            }

            this.labels = labels.toArray(new String[0]);
            this.legends = legends.toArray(new String[0]);
            this.samples = new double[height][width];
            for (int i = 0; i < samples.size(); i++) {
                Double[] row = samples.get(i);
                for (int j = 0; j < row.length; j++) {
                    this.samples[i][j] = row[j];
                    if (row[j] > maxValue) {
                        maxValue = row[j];
                    }
                }
            }
        }
    }
}