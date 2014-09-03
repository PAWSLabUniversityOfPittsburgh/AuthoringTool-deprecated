<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>
<%@ page import = "java.text.*" %>
<%@ page import = "java.lang.String" %>

<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>


<%
           Connection connection = null;
Class.forName(this.getServletContext().getInitParameter("db.driver"));
connection = DriverManager.getConnection(this.getServletContext().getInitParameter("db.webexURL"),this.getServletContext().getInitParameter("db.user"),this.getServletContext().getInitParameter("db.passwd"));
  Statement statement = connection.createStatement();



String text="";
boolean codeChanged = false;
String rdfID = request.getParameter("rdfID");   

            
try{
                   
 String QuizID = request.getParameter("quiz");           
 String Title = request.getParameter("title2");           
 String Description = request.getParameter("description2");           
 String Code = request.getParameter("quizcode");           
 String MinVar = request.getParameter("minvar");           
 String MaxVar = request.getParameter("maxvar");           
 String AnsType = request.getParameter("anstype");            
 String Privacy = request.getParameter("privacy2");         
 String QuesType = request.getParameter("questiontype");    
 String toBox = request.getParameter("toBox");  
 String quiz = request.getParameter("question");
 String command1 ="";
 String command = "select code,minvar,QuesType from ent_jquiz where QuizID='"+QuizID+"'";	
ResultSet codeRs = statement.executeQuery(command);
int qtype =0;
int minvar=0;
Blob prevCode = null;
String prevCodeString;
while (codeRs.next())
{
 prevCode = codeRs.getBlob(1);
 minvar = codeRs.getInt(2);
 qtype = codeRs.getInt(3);
}
prevCodeString = getSource(prevCode.getBinaryStream(), minvar, qtype);

	 command = "update ent_jquiz set Title='"+Title+"',Description='"+Description+"',Code='"+Code+"', MinVar='"+MinVar+"',MaxVar='"+MaxVar+"',AnsType='"+AnsType+"', Privacy='"+Privacy+"',rdfID='"+rdfID+"', QuesType='"+QuesType+"' where QuizID='"+QuizID+"' ";	
	statement.executeUpdate(command); 	
	command = "update rel_question_quiz set QuestionID='"+quiz+"' where QuizID='"+QuizID+"' ";	
	statement.executeUpdate(command); 	
	command = "update ent_jquiz_concept set Title='"+rdfID+"' where QuizID='"+QuizID+"' ";	
	statement.executeUpdate(command); 	

//2008.09
		int origin_class_cnt = 0;
		ArrayList origin_ClassID = new ArrayList();
		int originalClassID = 0;		
		ResultSet rs6 = null;  		
	        rs6 = statement.executeQuery("SELECT ClassID FROM rel_quiz_class where QuizID='"+QuizID+"'; ");		
		while(rs6.next()){
			//originalClassID = rs6.getInt(1);
			//out.println(originalClassID);
			origin_ClassID.add(rs6.getInt(1));
			origin_class_cnt++;
		}


	
	if (toBox!=null)
	 { 
		   int ClassID = Integer.parseInt(toBox); 
		   if (origin_class_cnt>0){ //class exists in db, can only update
		       //for (int i=0; i<origin_class_cnt; i++){
		       //		command1 = "update rel_quiz_class set ClassID = '"+ClassID+"' where QuizID = '"+QuizID+"'; ";
		       //		out.println(command1);
		       //}	   
		   }else{ //no classes in db, have to insert		   	     
		       		command1 = "insert into rel_quiz_class (QuizID,ClassID) value ('"+QuizID+"','"+ClassID+"'); ";
		       		statement.executeUpdate(command1);
		       		//out.println(command1);		       
		   }
	  }
	  else{
	  	if(origin_class_cnt>0){
		   	command1 = "delete from rel_quiz_class where QuizID='"+QuizID+"' and ClassID='"+origin_ClassID.get(0)+"'; ";	  
	  		statement.executeUpdate(command1); 	
	  		//out.println(command1);  	
	  	}
	  	
	  
	  }
	   	 
	   //int ClassID = Integer.parseInt(toBox); 
	   //if (ClassID!=originalClassID){
	   //	   command1 = "insert into rel_quiz_class (QuizID,ClassID) value ('"+QuizID+"','"+ClassID+"'); ";
	   //	   statement.executeUpdate(command1); 	
		   //out.println(command1);
	   //}	    
	 //}
	//else{
	//   if (originalClassID>0){
	//   	command1 = "delete from rel_quiz_class where QuizID='"+QuizID+"' and ClassID='"+originalClassID+"'; ";	  
	//  	 statement.executeUpdate(command1); 	
	//  	 //out.println(command1);	   
	//   }	   
	//}
 	
 	//if the code has changed, delete all the previous parsing result from the db and reparse
 command = "select code from ent_jquiz where QuizID='"+QuizID+"'";	
 Blob newCode = null;
 codeRs = statement.executeQuery(command);
while (codeRs.next())
{
 newCode = codeRs.getBlob(1);
}
String newCodeString = getSource(newCode.getBinaryStream(), minvar, qtype);

 	if (prevCodeString.equals(newCodeString) == false)
 	{
 		codeChanged = true; 		
 	    command = "delete from ent_jquiz_concept where quizID="+QuizID;	
 		statement.executeUpdate(command); 
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

   if (codeChanged)
   {
	 response.sendRedirect("ParserServlet?question="+rdfID+"&type=quiz&load=JavaQuestionModifyAck.jsp");   
   }
   else
   {
		response.sendRedirect("JavaQuestionModifyAck.jsp");   
   }

%>
<%! 
private String getSource(InputStream in, int minvar, int qtype) {
	
	byte[] buffer = new byte[1024];

	int P = minvar;
	int position = 0;
	String codepart = "";
	try {
		while ( in.read(buffer) != -1) {
			StringBuffer text = new StringBuffer(new String(buffer));
			int linecount = 0;
			int loc = (new String(text)).indexOf('\n', position);
			while (loc >= 0) {
				loc = (new String(text)).indexOf('\n', position);
				String line = "";
				if (loc > position) {

					line = text.substring(position, loc);
					int b = line.indexOf("_Param");
					int b2 = line.lastIndexOf("_Param");
					if (b > 0 && b == b2) {
						line = line.substring(0, b) + P
								+ line.substring(b + 6);
					} else if (b > 0 && b2 > b) {
						line = line.substring(0, b) + P
								+ line.substring(b + 6, b2) + P
								+ line.substring(b2 + 6);
					}
					linecount = linecount + 1; //just for knowing the line number

					// for Question Type 3
					if (qtype != 3) {
						codepart += line; 
					}
				}
				else
				{
					line = text.substring(position, position+1);
					codepart += line; 
				}
				position = loc + 1;
			}
		}
	} catch (IOException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	} 
	return codepart;
}
%>