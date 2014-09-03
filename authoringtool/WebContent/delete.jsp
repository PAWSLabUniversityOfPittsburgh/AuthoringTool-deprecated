<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>



<%@ page import="java.sql.*" %>


<%
           Connection connection = null;
           ResultSet resultd = null;
           ResultSet resultd1 = null;
           Class.forName(this.getServletContext().getInitParameter("db.driver"));
           connection = DriverManager.getConnection(this.getServletContext().getInitParameter("db.webexURL"),this.getServletContext().getInitParameter("db.user"),this.getServletContext().getInitParameter("db.passwd"));
           Statement statement = connection.createStatement();
try{
	
	int M = Integer.parseInt(request.getParameter("max"));
	
	for (int b=1;b<=M;b++){
		if(request.getParameter("lno") != null) {
			if(Integer.parseInt(request.getParameter("lno")) == b){
							
			String ex = request.getParameter("ex");           
		 			 		
			String command = "delete from ent_line where DissectionID ='"+ex+"' and LineIndex = '"+b+"' ";
			statement.executeUpdate(command); 
					
			for(int a=Integer.parseInt(request.getParameter("lno")); a<=M; a++){ 	 	
			String command1 = "update ent_line set LineIndex = '" +(a-1)+ "' where DissectionID ='"+ex+"' and LineIndex = '"+a+"' ";
			statement.executeUpdate(command1); 
			
			}
		
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


out.println("Example Line deleted successfully!");


%>