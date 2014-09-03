<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>
<%@ page import = "java.text.*" %>
<%@ page import = "java.lang.String" %>

<%@ page import="java.sql.*" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.util.Date" %>
<%
Connection connection = null;
Class.forName(this.getServletContext().getInitParameter("db.driver"));
connection = DriverManager.getConnection(this.getServletContext().getInitParameter("db.webexURL"),this.getServletContext().getInitParameter("db.user"),this.getServletContext().getInitParameter("db.passwd"));
Statement statement = connection.createStatement();
            
Connection connection2 = null;
connection2 = DriverManager.getConnection(this.getServletContext().getInitParameter("db.aggregateURL"),this.getServletContext().getInitParameter("db.user"),this.getServletContext().getInitParameter("db.passwd"));
Statement statement2 = connection2.createStatement();

DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
Date date = new Date();

try{            
 String question = request.getParameter("quiz"); 
 String title2 = request.getParameter("title2");             
 String description2 = request.getParameter("description2"); 
 String questiontype = request.getParameter("questiontype"); 
 String rdfID = request.getParameter("rdfID");     
 String quizcode = request.getParameter("quizcode");  
 String minvar = request.getParameter("minvar");  
 String maxvar = request.getParameter("maxvar");  
 String anstype = request.getParameter("anstype");  
 String privacy2 = request.getParameter("privacy2");      
 
 String title2_1 = title2.replace("'","\\'");
 String description2_1 = description2.replace("'","\\'"); 

 //hyun{
 //System.out.println("Inside javaq_create_save2.jsp");
 String importclassesnames = request.getParameter("import-classes-names"); //10Animal.java 11Person.java 09Mechanic.java
 String importclassesvals = request.getParameter("import-classes-vals");//10 14 18
 //System.out.println(importclassesnames+"\t"+importclassesvals);
 //TODO: check if there is only one class, what are the values of importclassesnames
 //TODO: when having multiple classes, the first element of both importclassesnames and importclassesvals are empty?
 ArrayList<String> importClassNames = new ArrayList<String>();
 ArrayList<String> importClassVals = new ArrayList<String>();
 if (importclassesnames != null && importclassesvals != null && importclassesnames.length() > 0 
		 && importclassesvals.length() > 0){
	String[] splitResult1 = importclassesnames.split("\\s+");
	String[] splitResult2 = importclassesvals.split("\\s+");
    //TODO: need to decide what to do if they mismatch 
 	for (int i = 0; i < splitResult1.length; i++){
 		if (!splitResult1[i].equals("") && splitResult1[i].length() > 0 
 				&& !splitResult1[i].equalsIgnoreCase("null") && !splitResult1[i].equals("\"\"") && !splitResult1[i].equals("''")
 				&& !splitResult2[i].equals("") && splitResult2[i].length() > 0
 				&& !splitResult2[i].equalsIgnoreCase("null") && !splitResult2[i].equals("\"\"") && !splitResult2[i].equals("''")){
 			//System.out.println("The " + (i+1) + "th one:\n" + "importClassName:" + splitResult1[i] + ",id:" + splitResult2[i]);
 			importClassNames.add(splitResult1[i]);
 			importClassVals.add(splitResult2[i]);
 		}
 	}
    //System.out.println("importClassName size:" + importClassNames.size() + ",importClassVal size:" + importClassVals.size());
 }
 //}hyun
 
 String uid="";
 ResultSet rs = null;  
 rs = statement.executeQuery("SELECT id FROM ent_user where name = '"+userBeanName+"' ");
 while(rs.next())
  {
  	uid=rs.getString(1);  	
  }

 String gid="";
 ResultSet rs1 = null;  
 rs1 = statement.executeQuery("SELECT id FROM ent_group where name = '"+userBean.getGroupBean().getName()+"' ");
 while(rs1.next())
  {
  	gid=rs1.getString(1);  	
  }			

 ResultSet rs2 = null;  
 ResultSet rs3 = null;
 if (privacy2.equals("private")){
 	String command = "insert into ent_jquiz (AuthorID,GroupID,Title,Description,Code,MinVar,MaxVar,AnsType,Privacy,rdfID,QuesType)"
 	+" values ('"+uid+"','"+gid+"','"+(title2_1)+"','"+(description2_1)+"','"+quizcode+"','"+minvar+"','"+maxvar+"','"+anstype+"','0','"+rdfID+"','"+questiontype+"') ";
 	statement.executeUpdate(command);

 	String MaxID ="";
	rs3 = statement.executeQuery("SELECT MAX(LAST_INSERT_ID(QuizID)) AS LastID FROM ent_jquiz WHERE AuthorID='"+uid+"' and GroupID='"+gid+"' and Title='"+(title2_1)+"' and Description='"+(description2_1)+"' and Code='"+quizcode+"' and MinVar='"+minvar+"' and MaxVar='"+maxvar+"' and AnsType='"+anstype+"' and Privacy='0' and rdfID='"+rdfID+"' and QuesType='"+questiontype+"';");        
	        while(rs3.next())
		{ 	
		MaxID = rs3.getString(1);		
		}
 	
 	String command1 ="insert into rel_question_quiz (QuestionID,QuizID) values ('"+question+"','"+MaxID+"')";
 	statement.executeUpdate(command1);
 	
	//hyun{ QuizID is always new for a new quiz, so don't need to check whether current relation exists or not; 
	 	for (int i = 0; i < importClassVals.size(); i++){
	 		String command2 = "insert into rel_quiz_class (QuizID,ClassID) values('"+MaxID+"','" + importClassVals.get(i)+"')";
	        statement.executeUpdate(command2);
	 	}
	 	//}hyun

	//     hyun* 
	//     int id_count = 0;	
	//  	List messages = (List) session.getAttribute("messages");
	//  	if (messages != null) {	
	//  		for (java.util.Iterator i = messages.iterator(); i.hasNext();) {
	//  			HashMap ClassMap = (HashMap) i.next();
	//  			id_count++;
	//  			if (ClassMap.get("ClassID"+id_count+"")!=null){
	//  				String command2 = "insert into rel_quiz_class (QuizID,ClassID) values('"+MaxID+"','"
	// 		                +ClassMap.get("ClassID"+id_count+"")+"')";
	// 				statement.executeUpdate(command2);
	// 	       	}
	// 		 }
	//  	}
	// *hyun
 	
		//response.sendRedirect("javaQuestionSaved.jsp");
 	
	 }else {
	 	String command = "insert into ent_jquiz (AuthorID,GroupID,Title,Description,Code,MinVar,MaxVar,AnsType,Privacy,rdfID,QuesType)"
	 	+" values ('"+uid+"','"+gid+"','"+(title2_1)+"','"+(description2_1)+"','"+quizcode+"','"+minvar+"','"+maxvar+"','"+anstype+"','1','"+rdfID+"','"+questiontype+"') ";
	 	statement.executeUpdate(command);
 	
	 	String MaxID ="";
		rs3 = statement.executeQuery("SELECT MAX(LAST_INSERT_ID(QuizID)) AS LastID FROM ent_jquiz WHERE AuthorID='"+uid+"' and GroupID='"+gid+"' and Title='"+(title2_1)+"' and Description='"+(description2_1)+"' and Code='"+quizcode+"' and MinVar='"+minvar+"' and MaxVar='"+maxvar+"' and AnsType='"+anstype+"' and Privacy='1' and rdfID='"+rdfID+"' and QuesType='"+questiontype+"';");        
		        while(rs3.next())
			{ 	
			MaxID = rs3.getString(1);		
			}
 	
	 	String command1 ="insert into rel_question_quiz (QuestionID,QuizID) values ('"+question+"','"+MaxID+"')";
	 	statement.executeUpdate(command1);
 	
	 	//hyun { QuizID is always new for a new quiz, so don't need to check whether current relation exists or not; 
	 	for (int i = 0; i < importClassVals.size(); i++){
	 		String command2 = "insert into rel_quiz_class (QuizID,ClassID) values('"+MaxID+"','" + importClassVals.get(i)+"')";
	        statement.executeUpdate(command2);
	 	}
	 	//}hyun
 	
	// //hyun*
	// 		    int id_count = 0;
	// 		    List messages = (List) session.getAttribute("messages");
	// 		        if (messages != null) {		            
	// 		            for (java.util.Iterator i = messages.iterator(); i.hasNext();) {
	// 		                HashMap ClassMap = (HashMap) i.next();
	// 		                id_count++;
	// 		                if (ClassMap.get("ClassID"+id_count+"")!=null){
	// 					String command2 = "insert into rel_quiz_class (QuizID,ClassID) values('"+MaxID+"','"+ClassMap.get("ClassID"+id_count+"")+"')";
	// 					statement.executeUpdate(command2);
	// 	       			}
	// 		    	    }
	// 		    }
	// //*hyun
 	
	 	//response.sendRedirect("javaQuestionSaved.jsp");
	 }//finish else
	 
	 // add to aggregate ent_content
     // add to aggregate ent_content
     //select topic 
     ResultSet tmpRs = null;  
     tmpRs = statement.executeQuery("SELECT title FROM ent_jquestion where questionid = '"+question+"' ");
     String topicname = "";
     while(tmpRs.next())
     {
  	   topicname=tmpRs.getString(1);  	
     }
     //select login
     tmpRs = null;
     tmpRs = statement.executeQuery("SELECT login FROM ent_user where name = '"+userBeanName+"' ");
     String login = "";
     while(tmpRs.next())
     {
  	   login=tmpRs.getString(1);  	
     }
     String command ="insert into ent_content (content_name,content_type,display_name,`desc`,url,domain,provider_id,visible,creation_date,creator_id,privacy,comment) values "+
    		                                  "('"+rdfID+"','question','"+title2_1+"','"+description2_1+"','http://adapt2.sis.pitt.edu/quizjet/quiz1.jsp?rdfID="+rdfID+"&act="+topicname+"&sub="+rdfID+"&svc=progvis','java','quizjet','1','"+dateFormat.format(date)+"','"+login+"','"+privacy2+"','')";
    		                                 
  	 //TODO should add the user if not exists in ent_creator - currently is done manually
  	 statement2.executeUpdate(command); 

	response.sendRedirect("ParserServlet?question="+rdfID+"&type=quiz&load=javaQuestionSaved.jsp");

 		
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