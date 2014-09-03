<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>

<%
		   int sessionL=0;
		   List messages = (List) session.getAttribute("messages");
		        if (messages != null) {		            
		            for (java.util.Iterator i = messages.iterator(); i.hasNext();) {
		                HashMap ClassMap = (HashMap) i.next();
		                sessionL++;
		                if (ClassMap.get("ClassID"+sessionL+"")!=null){		                	
			                if (ClassMap.get("ClassID"+sessionL+"").equals(request.getParameter("sessionID"))){
			                	ClassMap.clear();
	       				}
	       			}
		    	    }
		    }	
	   
		
	response.sendRedirect("jquestion_create1.jsp");
		
	
%>		    
