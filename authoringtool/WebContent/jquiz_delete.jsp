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
            
 String QuestionID = request.getParameter("QuestionID");           
 String QuizID = request.getParameter("QuizID");           
      

  	String command="delete from rel_question_quiz where QuizID ='"+QuizID+"' and QuestionID='"+QuestionID+"' ";	  		  	
  	String command1="delete from ent_jquiz where QuizID ='"+QuizID+"' ";	  		  	
  	statement.executeUpdate(command);	  	
  	statement.executeUpdate(command1);	  	
  	out.println("Question deleted successfully!");  		

 		
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