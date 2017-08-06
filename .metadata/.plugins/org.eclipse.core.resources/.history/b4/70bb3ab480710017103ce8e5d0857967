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

/**
 * Implements a very basic table parser.
 */
public class TableCSVBuilder {

    private static final char S_CELL = 'c';
    private static final char S_QUOTE = 'q';
    private static final char S_CR = 'r';
    private static final char S_LF = 'n';

    private final char colDelim;

    public TableCSVBuilder() {
        this('\t');
    }

    public TableCSVBuilder(char colDelim) {
        this.colDelim = colDelim;
    }

    public Table parse(String string) {
        char state = S_CELL;
        StringBuffer cellBuf = new StringBuffer();
        int rowNr = 0;
        int colNr = 0;
        Table table = new Table();
        for (int i=0; i<string.length(); i++) {
            char c = string.charAt(i);
            switch (state) {
                case S_CELL:
                    if (c == '\"') {
                        state = S_QUOTE;
                    } else if (c == '\r' || c == '\n') {
                        if (cellBuf.length() > 0) {
                            table.getCell(rowNr, colNr, true).setText(cellBuf);
                            cellBuf.setLength(0);
                        }
                        rowNr++;
                        colNr = 0;
                        state = c == '\r' ? S_CR : S_LF;
                    } else if (c == colDelim) {
                        table.getCell(rowNr, colNr, true).setText(cellBuf);
                        colNr++;
                        cellBuf.setLength(0);
                    } else {
                        cellBuf.append(c);
                    }
                    break;
                case S_QUOTE:
                    if (c == '\"') {
                        state = S_CELL;
                    } else {
                        cellBuf.append(c);
                    }
                    break;
                case S_CR:
                    state = S_CELL;
                    if (c != '\n') {
                        // backtrack
                        i--;
                    }
                    break;
                case S_LF:
                    state = S_CELL;
                    if (c != '\r') {
                        // backtrack
                        i--;
                    }
                    break;
            }
        }
        // check if last cell was not closed, i.e. there is no terminating CRLF
        if (cellBuf.length() > 0) {
            table.getCell(rowNr, colNr, true).setText(cellBuf);
        }
        return table;
    }

}