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
 	String ontID = request.getParameter("ontID"+a+"");	
 	
 	if (request.getParameter("privacy"+a+"").equals("public")){
	 	String command = "update ent_ontology set Name='"+Name+"',Description='"+Description+"',rdfID='"+request.getParameter("rdfID"+a+"")+"',Privacy='1' where ontID='"+ontID+"' ";	
	 	statement.executeUpdate(command); 	
 	}else{
	 	String command = "update ent_ontology set Name='"+Name+"',Description='"+Description+"',rdfID='"+request.getParameter("rdfID"+a+"")+"',Privacy='0' where ontID='"+ontID+"' ";	
	 	statement.executeUpdate(command); 	
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

out.println("modify successfully!");  


%>