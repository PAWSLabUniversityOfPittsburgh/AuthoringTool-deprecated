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
	String sc = request.getParameter("sc"); 
	String ex = request.getParameter("ex"); 
	String ont = request.getParameter("ont"); 
	
	String m[] = request.getParameterValues("toBox"); 

	
	int cnt=0;
	String db[];	
	ResultSet rs1=null;	
	String ID="";
	rs1 = statement.executeQuery("SELECT conID FROM rel_dissection_concept where DissectionID='"+ex+"' ");
	while(rs1.next()){	    
		ID=ID+rs1.getString(1)+",";
		
	}
		ID=ID.substring(0,ID.length()-1);
		String command1 = "delete from rel_dissection_concept where DissectionID='"+ex+"' and ontID='"+ont+"' and conID in ("+ID+") ";
		statement.executeUpdate(command1);    
		
		if (m != null){
		for (int i = 0 ; i < m.length ; i++){
			if (m[i]!=""){
 				String command = "insert into rel_dissection_concept (DissectionID,ontID,conID) values ('"+ex+"','"+ont+"','"+(m[i])+"') ";
				statement.executeUpdate(command);    
			}
		}	

		out.println("concept indexing successfully!");
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