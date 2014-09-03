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
  
 String Msg="";
 int flag1=0;


 ResultSet rs = null;  
 rs = statement.executeQuery("SELECT * FROM rel_question_quiz where QuestionID = '"+QuestionID+"' limit 1 ");
 while(rs.next())
  {
  	flag1 = 1;	
  }
 
  if (flag1<=0){
	  	String command="delete from ent_jquestion where QuestionID ='"+QuestionID+"' ";	  		  	
	  	statement.executeUpdate(command);	  	
	  	out.println("Quiz deleted successfully!");  		
  }else {
  	out.println("Can't delete!!! still have quizzes within this question!");
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