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
            
try{            
 String title1 = request.getParameter("title1");             
 String description1 = request.getParameter("description1");      
 String privacy1 = request.getParameter("privacy1");      
 
 String title1_1 = title1.replace("'","\\'");
 String description1_1 = description1.replace("'","\\'"); 
 
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
 if (privacy1.equals("private")){
 	String command = "insert into ent_jquestion (AuthorID,GroupID,Title,Description,Privacy)"
 	+" values ('"+uid+"','"+gid+"','"+(title1_1)+"','"+(description1_1)+"','0') ";
 	statement.executeUpdate(command);	 	
 	out.write("Topic created successfully!");
 	
 }else {
 	String command = "insert into ent_jquestion (AuthorID,GroupID,Title,Description,Privacy)"
 	+" values ('"+uid+"','"+gid+"','"+(title1_1)+"','"+(description1_1)+"','1') ";
 	statement.executeUpdate(command);	
 	out.write("Topic created successfully!");
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