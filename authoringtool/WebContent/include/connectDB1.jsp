<%@ page language="java" %>
<%@ page import="java.sql.*" %>	


<%
    Connection conn = null;
    ResultSet result = null;
    Statement stmt = null;
    ResultSetMetaData rsmd = null;

    try {
      Class c = Class.forName(this.getServletContext().getInitParameter("db.driver"));
    }
    catch (Exception e) {
      System.out.println("Error occurred " + e);
     }
     try {
       conn = DriverManager.getConnection(this.getServletContext().getInitParameter("db.webexURL"),this.getServletContext().getInitParameter("db.user"),this.getServletContext().getInitParameter("db.passwd"));
     }
     catch (SQLException e) {
        System.out.println("Error occurred " + e);
     }
     try {
        stmt = conn.createStatement();
        result = stmt.executeQuery("SELECT * FROM rel_scope_dissection where Rating >= '3' limit 5");        
     }
     catch (SQLException e) {
         System.out.println("Error occurred " + e);
      }

     int columns=0;
     int rows=0;
     try {
       rsmd = result.getMetaData();       
       columns = rsmd.getColumnCount();       
     }
     catch (SQLException e) {
        System.out.println("Error occurred " + e);
     }
               
%>