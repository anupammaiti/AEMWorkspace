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

import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.el.ELException;
import javax.servlet.jsp.el.ExpressionEvaluator;
import javax.servlet.jsp.el.VariableResolver;

import org.apache.sling.api.SlingHttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.day.cq.security.profile.Profile;

/**
 * <code>ELEvaluator</code> implements an expression language evaluator base on
 * {@link ExpressionEvaluator}. In addition to the standard implicit objects
 * as defined in JSP, this evaluator also exposed CQ specific objects like:
 * <ul>
 * <li>profile: the profile of the current user</li>
 * </ul>
 */
public class ELEvaluator {

    /**
     * The logger instance for this class.
     */
    private static final Logger log = LoggerFactory.getLogger(ELEvaluator.class);

    /**
     * Evaluates the given expression. If an error occurs while evaluating the
     * expression, then the expression is returned as is and the error is logged
     * as warning.
     *
     * @param expr        the expression.
     * @param request     the current request.
     * @param pageContext the current page context.
     * @return the evaluated expression.
     */
    public static String evaluate(String expr,
                                  SlingHttpServletRequest request,
                                  final PageContext pageContext) {
        final Profile profile = request.adaptTo(Profile.class);
        ExpressionEvaluator exprEval = pageContext.getExpressionEvaluator();
        try {
            return (String) exprEval.evaluate(expr, String.class, new VariableResolver() {

                private final VariableResolver base = pageContext.getVariableResolver();

                public Object resolveVariable(String name) throws ELException {
                    Object value = base.resolveVariable(name);
                    if (value == null) {
                        if (name.equals("profile")) {
                            value = profile;
                        }
                    }
                    return value;
                }
            }, null);
        } catch (ELException e) {
            log.warn("Error while evaluating expression: {}", expr, e);
        }
        return expr;
    }
}
