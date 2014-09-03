<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>
<%@ page import = "java.text.*" %>


<%@ page import="java.sql.*" %>


<%
           Connection connection = null;
Class.forName(this.getServletContext().getInitParameter("db.driver"));
connection = DriverManager.getConnection(this.getServletContext().getInitParameter("db.webexURL"),this.getServletContext().getInitParameter("db.user"),this.getServletContext().getInitParameter("db.passwd"));

            Statement statement = connection.createStatement();
            
String comment = request.getParameter("ta"); 
String id = request.getParameter("id");
String line = request.getParameter("line");

String command = "update ent_line set Comment = '" +comment+ "' , flag ='1' " +
" where LineIndex = '"+line+"' and DissectionID = '"+id+"' ";
statement.executeUpdate(command); 

response.sendRedirect("http://localhost:8080/example/myexample.jsp?DID="+request.getParameter("id")+" ");     



%>