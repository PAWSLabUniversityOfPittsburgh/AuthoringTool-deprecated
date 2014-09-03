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
            
 String ont = request.getParameter("ont");      
 String type = request.getParameter("type");      
 String title = request.getParameter("title");           
 String rdfID = request.getParameter("rdfID");      
 String description = request.getParameter("Description");       
 
 String voc = request.getParameter("voc");      
 String vocDes = request.getParameter("vocDes"); 
 String vocrdfID = request.getParameter("vocrdfID"); 
 String privacy = request.getParameter("privacy");      
 
 title = title.replace("'","\\'");
 description = description.replace("'","\\'");

 voc = voc.replace("'","\\'");
 vocDes = vocDes.replace("'","\\'");
 
 String uid="";
 ResultSet rs = null;  
 rs = statement.executeQuery("SELECT id FROM ent_user where name = '"+userBeanName+"' ");
 while(rs.next())
  {
  	uid=rs.getString(1);  	
  }

 if(request.getParameter("create").equals("addconcept")){
 	if (title.equals("")){
 		out.println("Title can't be empty!");
 	}else if (rdfID.equals("")){
 		out.println("rdfID can't be empty!");
 	}else{
 		String command = "insert into ent_concept (ontID,typeID,uID,rdfID,title, description) values ('"+ont+"','"+type+"','"+uid+"','"+rdfID+"','" +title+ "','"+description+"') "; 			
 		statement.executeUpdate(command); 
 		out.println("Concept created successfully!");  			 			  	
 	} 	
 }else{
 	if (voc.equals("")){
 		out.println("Can not create null vocabulary!");
 	}else if (vocrdfID.equals("")){
 		out.println("rdfID can't be empty!");
 	}else{
 		if (privacy.equals("private")){		
	 		String command ="insert into ent_ontology (Name,Description,rdfID,Privacy) values ('"+voc+"','"+vocDes+"','"+vocrdfID+"','0')";
	 		statement.executeUpdate(command); 			
	 		out.println("Concept created successfully!!"); 
	 	}else{
	 		String command ="insert into ent_ontology (Name,Description,rdfID,Privacy) values ('"+voc+"','"+vocDes+"','"+vocrdfID+"','1')";
	 		statement.executeUpdate(command); 			
	 		out.println("Concept created successfully!"); 	 	
	 	} 
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