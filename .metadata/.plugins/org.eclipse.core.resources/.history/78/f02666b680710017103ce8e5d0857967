/*
 * Copyright 1997-2011 Day Management AG
 * Barfuesserplatz 6, 4001 Basel, Switzerland
 * All Rights Reserved.
 *
 * This software is the confidential and proprietary information of
 * Day Management AG, ("Confidential Information"). You shall not
 * disclose such Confidential Information and shall use it only in
 * accordance with the terms of the license agreement you entered into
 * with Day.
 */
package com.day.cq.wcm.foundation.forms;

import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.sling.api.SlingHttpServletRequest;

import java.io.IOException;
import java.io.Writer;


/**
 * Helper class for the forms components for layouting.
 */
public class LayoutHelper {

    private LayoutHelper() {
        // no intances
    }

    /**
     * Print the left column, title and required. This method creates a wrapper
     * div with the class form_leftcol, inside the divs are two divs, the first
     * one containing the label with the class form_leftcollabel. The second
     * inner div contains a star if the field is required, the div has the class
     * form_leftcolmark.
     * <p/>
     * The <code>title</code> is encoded using
     * {@link StringEscapeUtils#escapeHtml4(String)} before it is written to
     * the {@link Writer}.
     *
     * @param fieldId  The id of the field (not the name) - This can be null if
     *                 title is null.
     * @param title    The title of the field (or null)
     * @param required Flag indicating if this field is required.
     * @param out      The writer.
     * @throws IOException If writing fails.
     */
    public static void printTitle(String fieldId,
                                  String title,
                                  boolean required,
                                  Writer out) throws IOException {
        printTitle(fieldId, title, required, false, out);
    }

    /**
     * Print the left column, title and required. This method creates a wrapper
     * div with the class form_leftcol, inside the divs are two divs, the first
     * one containing the label with the class form_leftcollabel. The second
     * inner div contains a star if the field is required, the div has the class
     * form_leftcolmark.
     * <p/>
     * The <code>title</code> is encoded using
     * {@link StringEscapeUtils#escapeHtml4(String)} before it is written to
     * the {@link Writer}.
     *
     * @param fieldId  The id of the field (not the name) - This can be null if
     *                 title is null.
     * @param title    The title of the field (or null)
     * @param required Flag indicating if this field is required.
     * @param hideLabel Option to completely hide the label (removes form_leftcollabel and form_leftcolmark 
     * divs content)
     * @param out      The writer.
     * @throws IOException If writing fails.
     * @since 5.4
     */
    public static void printTitle(String fieldId,
                                  String title,
                                  boolean required,
                                  boolean hideLabel,
                                  Writer out) throws IOException {
        out.write("<div class=\"form_leftcol\"");
        if (hideLabel) {
            out.write(" style=\"display: none;\"");
        }
        if (title != null && title.length() > 0) {
            title = StringEscapeUtils.escapeHtml4(title);
        } else {
            title = "&nbsp;";
        }
        out.write(">");
        out.write("<div class=\"form_leftcollabel\">");
        if (fieldId != null) {
            fieldId = StringEscapeUtils.escapeHtml4(fieldId);
            out.write("<label for=\"" + fieldId + "\">" + title + "</label>");
        } else {
            out.write("<span>" + title + "</span>");
        }
        out.write("</div>");
        out.write("<div class=\"form_leftcolmark\">");
        if (!hideLabel) {
            if (required) {
                out.write(" *");
            } else {
                out.write("&nbsp;");
            }
        }
        out.write("</div>");
        out.write("</div>\n");
    }

    /**
     * Print the description
     * <p/>
     * The <code>description</code> is encoded using
     * {@link StringEscapeUtils#escapeHtml4(String)} before it is written to
     * the {@link Writer}.
     *
     * @param descr    The description of the field (or null)
     * @param out      The writer.
     * @throws IOException If writing fails.
     */
    public static void printDescription(String descr,
                                  Writer out) throws IOException {
        printDescription(null, descr, out);
    }

    /**
     * Print the description
     * <p/>
     * If <code>fieldId</code> is set the description will be enclosed in a label
     * for accessibility.  This facility should only be used when the field has no
     * title, or the title is not used as a label for some reason.
     * <p/>
     * The <code>description</code> is encoded using
     * {@link StringEscapeUtils#escapeHtml4(String)} before it is written to
     * the {@link Writer}.
     *
     * @param descr    The description of the field (or null)
     * @param out      The writer.
     * @throws IOException If writing fails.
     */
    public static void printDescription(String fieldId,
                                        String descr,
                                        Writer out) throws IOException {
        out.write("<div class=\"form_row_description\">");
        if (descr != null && descr.length() > 0) {
            descr = StringEscapeUtils.escapeHtml4(descr);
            if (fieldId != null) {
                fieldId = StringEscapeUtils.escapeHtml4(fieldId);
                out.write("<label for=\"" + fieldId + "\">" + descr + "</label>");
            } else {
                out.write("<span>" + descr + "</span>");
            }
        }
        out.write("</div>\n");
    }

    /**
     * Print all errors (if there are any.) If there are error messages for this
     * field, a div for each error message is created. The div has the class
     * form_row, then {@link #printTitle(String, String, boolean, Writer)} is
     * called and a third inner div with the message and the classes
     * form_rightcol and form_error is created.
     *
     * @param request   The current request.
     * @param fieldName The name of the field (not the id!)
     * @param out       The writer.
     * @throws IOException If writing fails.
     */
    public static void printErrors(SlingHttpServletRequest request,
                                   String fieldName,
                                   Writer out) throws IOException {
        printErrors(request, fieldName, false, out);
    }

    /**
     * Print all errors (if there are any.) If there are error messages for this
     * field, a div for each error message is created. The div has the class
     * form_row, then {@link #printTitle(String, String, boolean, Writer)} is
     * called and a third inner div with the message and the classes
     * form_rightcol and form_error is created.
     *
     * @param request   The current request.
     * @param fieldName The name of the field (not the id!)
     * @param out       The writer.
     * @return Returns <code>true</code> if an error has been printed (since 5.5)
     * @throws IOException If writing fails.
     * @since 5.3
     */
    public static boolean printErrors(SlingHttpServletRequest request,
                                   String fieldName,
                                   Writer out,
                                   final int valueIndex) throws IOException {
        return printErrors(request, fieldName, false, out, valueIndex);
    }

    /**
     * Print all errors (if there are any.) If there are error messages for this
     * field, a div for each error message is created. The div has the class
     * form_row, then {@link #printTitle(String, String, boolean, Writer)} is
     * called and a third inner div with the message and the classes
     * form_rightcol and form_error is created.
     *
     * @param request   The current request.
     * @param fieldName The name of the field (not the id!)
     * @param hideLabel Option to completely hide the label (removes form_leftcollabel and form_leftcolmark
     * divs content)
     * @param out       The writer.
     * @throws IOException If writing fails.
     * @since 5.4
     */
    public static void printErrors(SlingHttpServletRequest request,
                                   String fieldName,
                                   boolean hideLabel,
                                   Writer out) throws IOException {
        final ValidationInfo info = ValidationInfo.getValidationInfo(request);
        // check if we have validation errors
        if (info != null) {
            String[] msgs = info.getErrorMessages(fieldName);
            if (msgs != null) {
                for (String msg : msgs) {
                    out.write("<div class=\"form_row\">");
                    printTitle(null, null, false, hideLabel, out);
                    out.write("<div class=\"form_rightcol form_error\">");
					String[] msgParas = msg.split("\n");
					for (int i = 0; i < msgParas.length; i++) {
						out.write(StringEscapeUtils.escapeHtml4(msgParas[i]));
						if (i+1 < msgParas.length) {
							out.write("<br>");
						}
					}
                    out.write("</div>");
                    out.write("</div>");
                }
            }
        }
    }

    /**
     * Print all errors (if there are any.) If there are error messages for this
     * field, a div for each error message is created. The div has the class
     * form_row, then {@link #printTitle(String, String, boolean, Writer)} is
     * called and a third inner div with the message and the classes
     * form_rightcol and form_error is created.
     *
     * @param request   The current request.
     * @param fieldName The name of the field (not the id!)
     * @param hideLabel Option to completely hide the label (removes form_leftcollabel and form_leftcolmark
     * divs content)
     * @param out       The writer.
     * @return Returns <code>true</code> if an error has been printed (since 5.5)
     * @throws IOException If writing fails.
     * @since 5.4
     */
    public static boolean printErrors(SlingHttpServletRequest request,
                                   String fieldName,
                                   boolean hideLabel,
                                   Writer out,
                                   final int valueIndex) throws IOException {
        final ValidationInfo info = ValidationInfo.getValidationInfo(request);
        // check if we have validation errors
        if (info != null) {
            String[] msgs = info.getErrorMessages(fieldName, valueIndex);
            if (msgs != null) {
                for (String msg : msgs) {
                    out.write("<div class=\"form_row\">");
                    printTitle(null, null, false, hideLabel, out);
                    out.write("<div class=\"form_rightcol form_error\">");
					String[] msgParas = msg.split("\n");
					for (int i = 0; i < msgParas.length; i++) {
						out.write(StringEscapeUtils.escapeHtml4(msgParas[i]));
						if (i+1 < msgParas.length) {
							out.write("<br>");
						}
					}
                    out.write("</div>");
                    out.write("</div>");
                }
                return true;
            }
        }
        return false;
    }
}