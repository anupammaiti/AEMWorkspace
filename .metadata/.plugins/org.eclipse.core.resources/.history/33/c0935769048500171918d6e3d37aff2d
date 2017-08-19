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

import java.io.IOException;
import java.io.Reader;
import java.io.StringReader;
import java.io.Writer;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringEscapeUtils;

/**
 * Implements a very basic table parser.
 */
public class Table {

    private LinkedList<Row> rows = new LinkedList<Row>();

    private LinkedList<Column> cols = new LinkedList<Column>();

    private Cell[][] data = new Cell[8][8];

    private Tag caption;

    private List<ColTag> colTags = new LinkedList<ColTag>();

    private Attributes attributes = new Attributes();

    public List<ColTag> getColTags() {
        return colTags;
    }

    public Attributes getAttributes() {
        return attributes;
    }

    public Table setAttribute(String name, String value) {
        if (value == null) {
            attributes.remove(name);
        } else {
            attributes.put(name, value);
        }
        return this;
    }


    public Tag getCaption() {
        return caption;
    }

    public Tag setCaption(String text) {
        if (caption == null) {
            caption = new Tag("caption");
        }
        caption.setInnerHtml(text);
        return caption;
    }

    public Cell getCell(int row, int col, boolean create) {
        Cell cell = null;
        if (row >= rows.size() || col >= cols.size()) {
            if (create) {
                setSize(Math.max(row + 1, rows.size()), Math.max(col + 1, cols.size()));
                cell = data[row][col];
            }
        } else {
            cell = data[row][col];
        }
        return cell;
    }

    public int[][] getIntData(int rowStart, int numRows, int colStart, int numCols) {
        if (rowStart + numRows > rows.size()) {
            numRows = rows.size() - rowStart;
        }
        if (colStart + numCols > cols.size()) {
            numCols = cols.size() - colStart;
        }
        int[][] ret = new int[numRows][numCols];
        for (int r=0; r<numRows; r++) {
            for (int c=0; c<numCols; c++) {
                ret[r][c] = data[r + rowStart][c + colStart].getIntValue();
            }
        }
        return ret;
    }

    public int[][] getIntData() {
        return getIntData(0, rows.size(), 0, cols.size());
    }

    public double[][] getDoubleData(int rowStart, int numRows, int colStart, int numCols) {
        if (rowStart + numRows > rows.size()) {
            numRows = rows.size() - rowStart;
        }
        if (colStart + numCols > cols.size()) {
            numCols = cols.size() - colStart;
        }
        double[][] ret = new double[numRows][numCols];
        for (int r=0; r<numRows; r++) {
            for (int c=0; c<numCols; c++) {
                ret[r][c] = data[r + rowStart][c + colStart].getDoubleValue();
            }
        }
        return ret;
    }

    public double[][] getDoubleData() {
        return getDoubleData(0, rows.size(), 0, cols.size());
    }

    public void setSize(int numRows, int numCols) {
        if (numRows >= data.length || numCols >= data[0].length) {
            Cell[][] newData = new Cell[data.length*2][data[0].length*2];
            for (int r=0; r<rows.size(); r++) {
                System.arraycopy(data[r], 0, newData[r], 0, cols.size());
            }
            data = newData;
        }
        while (rows.size() < numRows) {
            Row row = new Row(rows.size());
            rows.add(row);
            for (Column col : cols) {
                data[row.nr][col.nr] = new Cell(row, col);
            }
        }
        while (rows.size() > numRows) {
            rows.removeLast();
        }
        while (cols.size() < numCols) {
            Column col = new Column(cols.size());
            cols.add(col);
            for (Row row : rows) {
                data[row.nr][col.nr] = new Cell(row, col);
            }
        }
        while (cols.size() > numCols) {
            cols.removeLast();
        }
    }

    public List<Row> getRows() {
        return Collections.unmodifiableList(rows);
    }

    public List<Column> getColumns() {
        return Collections.unmodifiableList(cols);
    }

    public Row getRow(int nr) {
        return nr < rows.size() ? null : rows.get(nr);
    }

    public Column getColumn(int nr) {
        return nr < cols.size() ? null : cols.get(nr);
    }
    
    public int getNumCols() {
        return cols.size();
    }

    public int getNumRows() {
        return rows.size();
    }

    public void clear() {
        rows.clear();
        cols.clear();
    }

    public static Table fromXML(String s) {
        try {
            return fromXML(new StringReader(s));
        } catch (IOException e) {
            throw new IllegalStateException(e);
        }
    }

    public static Table fromXML(Reader r) throws IOException {
        return new TableXMLBuilder().parse(r);
    }

    public static Table fromCSV(String s) {
        return new TableCSVBuilder().parse(s);
    }

    public static Table fromCSV(String s, char delim) {
        return new TableCSVBuilder(delim).parse(s);
    }

    public class Row {

        private int nr;

        private Row(int nr) {
            this.nr = nr;
        }

        public int getNr() {
            return nr;
        }

        public boolean isFirst() {
            return nr == 0;
        }

        public boolean isLast() {
            return nr == rows.size() - 1;
        }

        public Table getTable() {
            return Table.this;
        }

        public List<Cell> getCells() {
            // currently just create a new list. optimize later with own class.
            List<Cell> cells = new ArrayList<Cell>(cols.size());
            for (int c=0; c<cols.size(); c++) {
                Cell cell = data[nr][c];
                if (!cell.isInSpan()) {
                    cells.add(cell);
                }
            }
            return cells;
        }

        public Row setHeader(boolean header) {
            for (Cell c: getCells()) {
                c.setHeader(header);
            }
            return this;
        }
    }

    public class Column {

        private int nr;

        private Column(int nr) {
            this.nr = nr;
        }

        public int getNr() {
            return nr;
        }

        public boolean isFirst() {
            return nr == 0;
        }

        public boolean isLast() {
            return nr == cols.size() - 1;
        }

        public Table getTable() {
            return Table.this;
        }

        public List<Cell> getCells() {
            // currently just create a new list. optimize later with own class.
            List<Cell> cells = new ArrayList<Cell>(rows.size());
            for (int r=0; r<rows.size(); r++) {
                Cell cell = data[r][nr];
                if (!cell.isInSpan()) {
                    cells.add(cell);
                }
            }
            return cells;
        }
    }

    public static class Cell {

        private Row row;

        private Column col;

        private String text;

        private Attributes attributes;

        private boolean header;

        private int colSpan = 1;

        private int rowSpan = 1;

        private Cell spanSource;

        private Cell(Row row, Column col) {
            this.row = row;
            this.col = col;
        }

        public Row getRow() {
            return row;
        }

        public Column getCol() {
            return col;
        }

        public Cell getSpanSource() {
            return spanSource;
        }

        public String getText() {
            return text;
        }

        public Cell appendText(char[] ch, int offset, int len) {
            if (text == null) {
                text = new String(ch, offset, len);
            } else {
                text = text + new String(ch, offset, len);
            }
            return this;
        }
        
        public int getIntValue() {
            try {
                return text == null ? 0 : Integer.parseInt(text);
            } catch (NumberFormatException e) {
                return 0;
            }
        }

        public double getDoubleValue() {
            try {
                return text == null ? 0 : Double.parseDouble(text);
            } catch (NumberFormatException e) {
                return Double.NaN;
            }
        }

        public int getColSpan() {
            return colSpan;
        }

        public boolean isInSpan() {
            return spanSource != null;
        }

        private Table getTable() {
            return row.getTable();
        }

        public Cell setColSpan(int colSpan) {
            if (colSpan == 0) {
                colSpan = 1;
            }
            internalSetSpans(rowSpan, colSpan);
            if (attributes == null) {
                attributes = new Attributes();
            }
            if (colSpan > 1) {
                attributes.put("colspan", String.valueOf(this.colSpan));
            } else {
                attributes.remove("colspan");
            }
            return this;
        }

        public int getRowSpan() {
            return rowSpan;
        }

        public Cell setRowSpan(int rowSpan) {
            if (rowSpan == 0) {
                rowSpan = 1;
            }
            internalSetSpans(rowSpan, colSpan);
            if (attributes == null) {
                attributes = new Attributes();
            }
            if (rowSpan > 1) {
                attributes.put("rowspan", String.valueOf(this.rowSpan));
            } else {
                attributes.remove("rowspan");
            }
            return this;
        }

        private void internalSetSpans(int rSpan, int cSpan) {
            Table table = getTable();
            int rowNr = row.getNr();
            int colNr = col.getNr();

            // clear old spans
            for (int r = 0; r<rowSpan; r++) {
                for (int c = 0; c<colSpan; c++) {
                    table.getCell(rowNr + r, colNr + c, false).spanSource = null;
                }
            }
            // set new spans
            this.rowSpan = rSpan;
            this.colSpan = cSpan;
            for (int r = 0; r<rowSpan; r++) {
                for (int c = 0; c<colSpan; c++) {
                    if (r + c > 0) {
                        table.getCell(rowNr + r, colNr + c, true).spanSource = this;
                    }
                }
            }
        }

        public Cell setText(CharSequence text) {
            this.text = text.toString();
            return this;
        }

        public boolean isHeader() {
            return header;
        }

        public Cell setHeader(boolean header) {
            this.header = header;
            return this;
        }

        public String getAttribute(String name) {
            if (attributes == null) {
                return null;
            } else {
                return attributes.get(name);
            }
        }

        public Cell setAttribute(String name, String value) {
            if (attributes == null) {
                attributes = new Attributes();
            }
            attributes.put(name, value);
            if (name.equalsIgnoreCase("colspan")) {
                setColSpan(Integer.parseInt(value));
            } else if (name.equalsIgnoreCase("rowspan")) {
                setRowSpan(Integer.parseInt(value));
            }
            return this;
        }

        public Cell clearAttributes() {
            attributes = null;
            internalSetSpans(1, 1);
            return this;
        }

        public Map<String, String> getAttributes() {
            if (attributes == null) {
                return Collections.emptyMap();
            } else {
                return Collections.unmodifiableMap(attributes);
            }
        }

        public void toHtml(Writer out) throws IOException {
            String tag = header ? "th" : "td";
            out.write("<");
            out.write(tag);
            if (attributes != null) {
                attributes.toHtml(out);
            }
            out.write(">");
            if (text != null) {
                out.write(text);
            }
            out.write("</");
            out.write(tag);
            out.write(">");
        }
    }

    public static class Tag {

        protected final String name;

        protected final Attributes attrs = new Attributes();

        protected String innerHtml;

        public Tag(String name) {
            this.name = name;
        }

        public String getName() {
            return name;
        }

        public String getInnerHtml() {
            return innerHtml;
        }

        public Tag setInnerHtml(String innerHtml) {
            this.innerHtml = innerHtml;
            return this;
        }

        public Tag appendInnerHtml(char[] ch, int offset, int len) {
            if (innerHtml == null) {
                innerHtml = new String(ch, offset, len);
            } else {
                innerHtml = innerHtml + new String(ch, offset, len);
            }
            return this;
        }

        public Attributes getAttributes() {
            return attrs;
        }

        public Tag setAttribute(String name, String value) {
            if (value == null) {
                attrs.remove(name);
            } else {
                attrs.put(name, value);
            }
            return this;
        }

        public void toHtml(Writer out) throws IOException {
            out.write("<");
            out.write(name);
            if (attrs != null) {
                attrs.toHtml(out);
            }
            out.write(">");
            if (innerHtml != null) {
                out.write(innerHtml);
                out.write("</");
                out.write(name);
                out.write(">");
            }
        }
    }

    public static class ColTag extends Tag {
        public ColTag() {
            super("col");
        }

        public Tag setInnerHtml(String innerHtml) {
            // ignore
            return this;
        }
    }


    public static class Attributes extends HashMap<String, String> {

        public void toHtml(Writer out) throws IOException {
            for (Map.Entry<String, String> e: entrySet()) {
                out.write(" ");
                out.write(e.getKey());
                out.write("=\"");
                out.write(StringEscapeUtils.escapeHtml4(e.getValue()));
                out.write("\"");
            }
        }
    }

    public void toHtml(Writer out) throws IOException {
        out.write("<table");
        attributes.toHtml(out);
        out.write(">\n");
        if (caption != null) {
            caption.toHtml(out);
            out.write("\n");
        }
        for (Tag cg: colTags) {
            cg.toHtml(out);
            out.write("\n");
        }
        for (Row row: rows) {
            out.write("<tr>");
            for (Column col: cols) {
                Cell cell = data[row.nr][col.nr];
                if (cell.getSpanSource() == null) {
                    data[row.nr][col.nr].toHtml(out);
                }
            }
            out.write("</tr>\n");
        }
        out.write("</table>\n");
    }
}