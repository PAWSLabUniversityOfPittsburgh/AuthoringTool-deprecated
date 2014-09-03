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
 	String Title = request.getParameter("Title"+a+"").replace("'","\\'");
 	String Description = request.getParameter("Description"+a+"").replace("'","\\'");
 	if (request.getParameter("privacy"+a+"").equals("public")){
 		String command = "update ent_jquestion set Title='"+Title+"',Description='"+Description+"',Privacy='1' where QuestionID='"+request.getParameter("jquestionid"+a+"")+"' ";	
 		statement.executeUpdate(command);	
 	}else{
 		String command = "update ent_jquestion set Title='"+Title+"',Description='"+Description+"',Privacy='0' where QuestionID='"+request.getParameter("jquestionid"+a+"")+"' ";	
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

out.println("Topic modified successfully!");  


%>