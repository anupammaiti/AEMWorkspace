<%@page session="false"%><%--

  ADOBE CONFIDENTIAL
  __________________

   Copyright 2012 Adobe Systems Incorporated
   All Rights Reserved.

  NOTICE:  All information contained herein is, and remains
  the property of Adobe Systems Incorporated and its suppliers,
  if any.  The intellectual and technical concepts contained
  herein are proprietary to Adobe Systems Incorporated and its
  suppliers and are protected by trade secret or copyright law.
  Dissemination of this information or reproduction of this material
  is strictly forbidden unless prior written permission is obtained
  from Adobe Systems Incorporated.

  ==============================================================================

  Form Address component.

  Constructs a sorted list of countries.  Note that this is the starting point;
  an address component instance can choose to have a commerce service filter
  the list to include only the supported countries, but the commerce service
  cannot add to the list.

  ==============================================================================

--%><%@include file="/libs/foundation/global.jsp"%><%
%><%@ page import="com.day.cq.i18n.I18n,
        java.util.Locale,
        java.util.ResourceBundle,
        java.util.ArrayList,
        java.util.List,
        java.util.Collections,
        java.util.Comparator,
        com.adobe.cq.commerce.api.CommerceConstants" %><%

    final Locale pageLocale = currentPage.getLanguage(true);
    final ResourceBundle bundle = slingRequest.getResourceBundle(pageLocale);
    I18n i18n = new I18n(bundle);

    final List<String> countries = new ArrayList<String>();
    countries.add("AR=" + i18n.get("Argentina"));
    countries.add("AU=" + i18n.get("Australia"));
    countries.add("AT=" + i18n.get("Austria"));
    countries.add("BS=" + i18n.get("Bahamas"));
    countries.add("BH=" + i18n.get("Bahrain"));
    countries.add("BR=" + i18n.get("Brazil"));
    countries.add("CA=" + i18n.get("Canada"));
    countries.add("CL=" + i18n.get("Chile"));
    countries.add("CN=" + i18n.get("China"));
    countries.add("CO=" + i18n.get("Colombia"));
    countries.add("EG=" + i18n.get("Egypt"));
    countries.add("FR=" + i18n.get("France"));
    countries.add("DE=" + i18n.get("Germany"));
    countries.add("GI=" + i18n.get("Gibraltar"));
    countries.add("HK=" + i18n.get("Hong Kong"));
    countries.add("IE=" + i18n.get("Ireland"));
    countries.add("IT=" + i18n.get("Italy"));
    countries.add("JP=" + i18n.get("Japan"));
    countries.add("LU=" + i18n.get("Luxembourg"));
    countries.add("MY=" + i18n.get("Malaysia"));
    countries.add("MX=" + i18n.get("Mexico"));
    countries.add("MC=" + i18n.get("Monaco"));
    countries.add("RU=" + i18n.get("Russia"));
    countries.add("SG=" + i18n.get("Singapore"));
    countries.add("ES=" + i18n.get("Spain"));
    countries.add("CH=" + i18n.get("Switzerland"));
    countries.add("US=" + i18n.get("United States of America"));
    countries.add("AE=" + i18n.get("United Arab Emirates"));
    countries.add("GB=" + i18n.get("United Kingdom"));
    countries.add("UY=" + i18n.get("Uruguay"));
    countries.add("VE=" + i18n.get("Venezuela"));

    // Sort based on translated display text:
    Collections.sort(countries, new Comparator<String>() {
        public int compare(String o1, String o2) {
            return o1.substring(o1.indexOf("=")+1).compareTo(o2.substring(o2.indexOf("=") + 1));
        }
    });
    slingRequest.setAttribute(CommerceConstants.REQ_ATTR_COUNTRYLIST, countries);
%>
