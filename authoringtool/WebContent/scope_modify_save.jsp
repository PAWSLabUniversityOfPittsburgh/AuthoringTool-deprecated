<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>
<%@ page import = "java.text.*" %>
<%@ page import = "java.lang.String" %>

<%@ page import="java.sql.*" %>

<%
           Connection connection = null;
Class.forName(this.getServletContext().getInitParameter("db.driver"));
connection = DriverManager.getConnection(this.getServletContext().getInitParameter("db.webexURL"),this.getServletContext().getInitParameter("db.user"),this.getServletContext().getInitParameter("db.passwd"));
            Statement statement = connection.createStatement();

String text="";
            
try{
            

 int cnt = Integer.parseInt(request.getParameter("cnt"));           
 
 for (int a=1; a<=cnt; a++){ 	 
 	String Name = request.getParameter("Name"+a+"").replace("'","\\'");
 	String Description = request.getParameter("Description"+a+"").replace("'","\\'");
 	String domain = request.getParameter("domain");
 	String command = "update ent_scope set Name='"+Name+"',Description='"+Description+"',rdfID='"+request.getParameter("rdfID"+a+"")+"' , domain='"+domain+"' where ScopeID='"+request.getParameter("scopeid"+a+"")+"' ";	
 	statement.executeUpdate(command);
 	
 	if (request.getParameter("privacy"+a+"").equals("public")){
 		String command1 = "update rel_scope_privacy set Privacy = '1' where ScopeID='"+request.getParameter("scopeid"+a+"")+"' "; 
 		statement.executeUpdate(command1);	
 	}else{
 		String command1 = "update rel_scope_privacy set Privacy = '0' where ScopeID='"+request.getParameter("scopeid"+a+"")+"' "; 
 		statement.executeUpdate(command1);	
 	}	
 	
 	
 }
  
 		
}	

   finally {
    try {
      if (statement != null)
       statement.close();
      }  catch (SQLException e) {}
      try {
       if (connection != null)
        connection.close();
       } catch (SQLException e) {}      
   }

out.println("Scope modified successfully!");  


%>