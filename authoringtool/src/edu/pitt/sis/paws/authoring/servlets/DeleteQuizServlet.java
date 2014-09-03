package edu.pitt.sis.paws.authoring.servlets;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONException;
import org.json.JSONObject;

import java.sql.*;
/**
 * Servlet implementation class DeleteQuizServlet
 */
@WebServlet("/DeleteQuizServlet")
public class DeleteQuizServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DeleteQuizServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		Statement statement = null;
        Connection connection = null;

       String text="";
         
try{
	Class.forName(this.getServletContext().getInitParameter("db.driver"));
	connection = DriverManager.getConnection(this.getServletContext().getInitParameter("db.webexURL"),this.getServletContext().getInitParameter("db.user"),this.getServletContext().getInitParameter("db.passwd"));
	statement = connection.createStatement();
   

String QuestionID = request.getParameter("QuestionID");           

String message="";
int flag1=0;


//ResultSet rs = null;  
//rs = statement.executeQuery("SELECT * FROM rel_question_quiz where QuestionID = '"+QuestionID+"' limit 1 ");
//while(rs.next())
//{
//	flag1 = 1;	
//	message = "This quiz cannot be deleted since it is assigned to some questions.\nChange its questions' quizz or delete them all and try again.";
//}

//if (flag1<=0){
	    String command="delete from rel_question_quiz where QuestionID ='"+QuestionID+"' ";	  		  	
	  	statement.executeUpdate(command);	  	
	  	command="delete from ent_jquestion where QuestionID ='"+QuestionID+"' ";	  		  	
	  	statement.executeUpdate(command);	
	 		
//}
try {
	PrintWriter out= response.getWriter();  
    JSONObject json = new JSONObject(); 
	json.put("message", message);
    out.print(json);  
} catch (JSONException e) {
	// TODO Auto-generated catch block
	e.printStackTrace();
}  
		
} catch (SQLException e) {
	// TODO Auto-generated catch block
	e.printStackTrace();
} catch (ClassNotFoundException e) {
	// TODO Auto-generated catch block
	e.printStackTrace();
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
}	}

}
