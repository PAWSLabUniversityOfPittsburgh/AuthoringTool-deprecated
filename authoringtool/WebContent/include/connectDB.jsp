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
        result = stmt.executeQuery("SELECT * FROM rel_scope_dissection");        
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
     
     

    ResultSet result1 = null;
    Statement stmt1 = null;
    ResultSetMetaData rsmd1 = null;

     try {
        stmt1 = conn.createStatement();
        result1 = stmt1.executeQuery("SELECT * FROM ent_scope");        
     }
     catch (SQLException e) {
         System.out.println("Error occurred " + e);
      }
   
   
 	int columnss=0;
     try {  
       rsmd1 = result1.getMetaData();       
       columnss = rsmd1.getColumnCount();             
     }
     catch (SQLException e) {
        System.out.println("Error occurred " + e);
     }     
     
            
%>