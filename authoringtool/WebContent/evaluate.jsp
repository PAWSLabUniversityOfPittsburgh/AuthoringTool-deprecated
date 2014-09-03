<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>
<%@ page import = "java.text.*" %>
<%@ page import="java.sql.*" %>


<%
           Connection connection = null;
Class.forName(this.getServletContext().getInitParameter("db.driver"));
connection = DriverManager.getConnection(this.getServletContext().getInitParameter("db.webexURL"),this.getServletContext().getInitParameter("db.user"),this.getServletContext().getInitParameter("db.passwd"));

            Statement statement = connection.createStatement();
            
String ex = request.getParameter("ex");
String count = request.getParameter("count");

int hitint = 0;
hitint=Integer.parseInt(request.getParameter("hit"));

int ratingint = 0;
ratingint = Integer.parseInt(request.getParameter("rating"));

float oldfloat = Float.valueOf(request.getParameter("oldRating"));

float newRating;

newRating = ((oldfloat*hitint)+ratingint)/(hitint+1);


String command = "update ent_line set EvaluateHit = '" +(hitint+1)+ "' , Rating = '"+newRating+"' " +
" where LineIndex = '"+count+"' and DissectionID = '"+ex+"' ";
statement.executeUpdate(command);  



out.println("save successfully!");
response.sendRedirect("http://localhost:8080/example/EditExample.jsp?exampleno="+request.getParameter("ex")+" ");     


%>