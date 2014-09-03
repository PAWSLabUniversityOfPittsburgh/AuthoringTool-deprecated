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
            

 String Name1 = request.getParameter("Name");           
 String rdfID = request.getParameter("rdfID");      
 String Description1 = request.getParameter("Description");      
 String privacy = request.getParameter("privacy");      
 String domain = request.getParameter("domain");
 String Name = Name1.replace("'","\\'");
 String Description = Description1.replace("'","\\'");
 
 String uid="";
 ResultSet rs = null;  
 rs = statement.executeQuery("SELECT id FROM ent_user where name = '"+userBeanName+"' ");
 while(rs.next())
  {
  	uid=rs.getString(1);  	
  }


	    
 	if (Name.equals("")){
 		out.println("Title can't be empty!");
 	}else if (rdfID.equals("")){
 		out.println("rdfID can't be empty!");
 	}else{
 		if (privacy.equals("private")){
 			String command = "insert into ent_scope (Name, Description, rdfID,domain) values ('" +Name+ "','"+Description+"','"+rdfID+"','"+domain+"') "; 			
 			statement.executeUpdate(command);
			 
			 ResultSet rs1 = null; 
			 int scopeID=0;
			 rs = statement.executeQuery("SELECT scopeID FROM ent_scope where Name = '"+Name+"'"+" and Description = '"+Description+"' and rdfID = '"+rdfID+"' and domain = '"+domain+"'" );
			 while(rs.next())
			 {
				 scopeID=Integer.parseInt(rs.getString(1));
			 }
			  			
			String command1 = "insert into rel_scope_privacy (ScopeID,Uid,privacy) values ('"+scopeID+"','"+uid+"','0') ";			 
 			statement.executeUpdate(command1);
 			out.println("Scope created successfully!");  

	        }else{
	        	
 			String command = "insert into ent_scope (Name, Description, rdfID,domain) values ('" +Name+ "','"+Description+"','"+rdfID+"','"+domain+"') "; 			 			
 			statement.executeUpdate(command);
 			
			 ResultSet rs1 = null; 
			 int scopeID=0;
			 rs = statement.executeQuery("SELECT scopeID FROM ent_scope where Name = '"+Name+"'"+" and Description = '"+Description+"' and rdfID = '"+rdfID+"' and domain = '"+domain+"'" );
			 while(rs.next())
			 {
			 	scopeID=Integer.parseInt(rs.getString(1));
			 } 		
			 	
 			String command1 = "insert into rel_scope_privacy (ScopeID,Uid,privacy) values ('"+scopeID+"','"+uid+"','1') ";
 			statement.executeUpdate(command1);
 			out.println("Scope created successfully!");  
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



%>