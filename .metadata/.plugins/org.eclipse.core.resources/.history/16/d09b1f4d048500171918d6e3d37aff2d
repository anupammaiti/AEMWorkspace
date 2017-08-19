<%@page session="false"%><%--
  Copyright 1997-2008 Day Management AG
  Barfuesserplatz 6, 4001 Basel, Switzerland
  All Rights Reserved.

  This software is the confidential and proprietary information of
  Day Management AG, ("Confidential Information"). You shall not
  disclose such Confidential Information and shall use it only in
  accordance with the terms of the license agreement you entered into
  with Day.

  ==============================================================================

  Timing component
  Provides page rendering timing information

--%>
<%@include file="/libs/foundation/global.jsp"%>
<%@ page import="
    org.apache.sling.api.request.RequestProgressTracker,
    java.util.Iterator,
    java.util.Comparator,
    java.net.URLEncoder,
    java.util.ArrayList,
    java.util.Collections,
    java.util.List" %>

<%!
private static final String TIMER_END = "TIMER_END";

static class ChartBar {
    String input;
	String name;
	String fullname;
	int start;
	int end;
	int elapsed;
	private static final String ELLIPSIS = "...";
	private static final int MAX_LABEL_LENGTH = 25;
	
	/** Line is like
	 *  127 (2009-10-07 14:15:17) TIMER_END{97,/libs/cq/core/components/welcome/welcome.jsp#0}  
	 */
	ChartBar(String line) {
	    try {
	        input = line.trim();
	        end = Integer.valueOf(scan(' '));
	        scan('{');
	        elapsed = Integer.valueOf(scan(','));
            start = end - elapsed;
	        fullname = cutBeforeLast(scan('}'), '#');
		    name = shortForm(fullname);
	    } catch(NumberFormatException ignored) {
	        name = fullname = ignored.toString();
	    }
	}
	 
    /** Remove chars up to separator in this.input, and return result */
    private String scan(char separator) {
        final StringBuilder sb = new StringBuilder();
        for(int i=0; i < input.length(); i++) {
            char c = input.charAt(i);
            if(c == separator) {
                break;
            }
            sb.append(c);
        }
        input = input.substring(sb.length() + 1);
        return sb.toString().trim();
    }
    
    private static String cutBeforeLast(String str, char separator) {
        int pos = str.lastIndexOf(separator);
        if(pos > 0) {
            str = str.substring(0, pos);
        }
        return str;
    }
    
    private static String shortForm(String str) {
        String result = basename(str);
        if(result.length() > MAX_LABEL_LENGTH) {
            result = result.substring(0, MAX_LABEL_LENGTH - ELLIPSIS.length()) + ELLIPSIS;
        }
        return result;
    }
}

static abstract class Getter {
    abstract String get(ChartBar t); 
}

private static String basename(String path) {
    String result = path;
    int pos = path.lastIndexOf('/');
    if(pos > 0) {
        result = result.substring(pos + 1);
    }
    return result;
}

private static String stringList(List<ChartBar> data, String separator, Getter g) {
	StringBuilder result = new StringBuilder();
	for(ChartBar t : data) {
		if(result.length() > 0) {
			result.append(separator);
		}
		result.append(URLEncoder.encode(g.get(t)));
	}
	return result.toString();
}

private static boolean accept(String line) {
    boolean result = line.contains(TIMER_END);
    result &= !line.contains(",resolveServlet(");
    result &= !line.contains("ResourceResolution");
    result &= !line.contains("ServletResolution");
    return result;
}

%>

<%
// Convert RequestProgressTracker TIMER_END messages to timings and operation names
RequestProgressTracker t = slingRequest.getRequestProgressTracker();
ArrayList<ChartBar> chartData = new ArrayList<ChartBar>();
int maxTime = 0;
for(Iterator<String> it = t.getMessages() ; it.hasNext(); ) {
	String line = it.next();
	if(accept(line)) {
	    ChartBar b = new ChartBar(line);
	    chartData.add(b);
	    maxTime = b.end;
	}
}

String title = basename(request.getPathInfo()) + " (" + maxTime + "ms)";

// Sort data according to numeric start time
Collections.sort(chartData, new Comparator<ChartBar>() {
    public int compare(ChartBar a, ChartBar b) {
        if(a.start > b.start) {
            return 1;
        } else if(a.start < b.start) {
            return -1;
        }
        return 0;
    }
});

// Chart API limitations - max 30k pixels!
int chartWidth = 600;
int maxPixels = 300000;
int chartHeight = maxPixels / chartWidth;

// See http://code.google.com/apis/chart/types.html#bar_charts for docs
StringBuilder b = new StringBuilder();
b.append("http://chart.apis.google.com/chart");
b.append("?chtt=" + URLEncoder.encode(title));
b.append("&cht=bhs");
b.append("&chxt=x");
b.append("&chco=c6d9fd,4d89f9");
b.append("&chbh=a");
b.append("&chds=0," + maxTime + ",0," + maxTime);
b.append("&chxr=0,0," + maxTime);
b.append("&chd=t:");
b.append(stringList(chartData, ",", new Getter() { public String get(ChartBar t) { return String.valueOf(t.start); }}));
b.append("|");
b.append(stringList(chartData, ",", new Getter() { public String get(ChartBar t) { return String.valueOf(t.elapsed); }}));
b.append("&chly=");
b.append(stringList(chartData, "|", new Getter() { public String get(ChartBar t) { return t.name; }}));
b.append("&chs=" + chartWidth + "x" + chartHeight);
%>

<%
// Dump data, in comments
out.println("<!--");

/* uncomment the following to get more timing details in the page
out.println("\nRaw RequestProgressTracker data:"); 
StringBuilder mb = new StringBuilder();
Iterator<String> it = t.getMessages();
while(it.hasNext()) {
    mb.append(it.next());
}
out.print(mb.toString());
out.println("\nChartData dump:");
for(ChartBar d : chartData) {
    out.print(d.start);
    out.print(' ');
    out.print(d.fullname);
    out.print(" (");
    out.print(d.elapsed);
    out.println("ms)");
}
*/

out.println("More detailed timing info is available by uncommenting some code in the timing.jsp component");
out.println("Timing chart URL:");
out.println(b.toString());
out.println("-->");
%>
