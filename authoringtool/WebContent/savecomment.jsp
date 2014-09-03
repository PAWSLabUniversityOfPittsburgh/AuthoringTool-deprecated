<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>
<%@ page import = "java.text.*" %>




<%@ page import="java.sql.*" %>

<script language="javascript">
<!--

function cOn(td){
if(document.getElementById||(document.all && !(document.getElementById))){
td.style.backgroundColor="#ffffe1";
}
}

function cOut(td){
if(document.getElementById||(document.all && !(document.getElementById))){
td.style.backgroundColor="#FFCC00";
}
}
//-->
</script>




         <%
         ResultSet resultd = null;
         ResultSet resultd1 = null;
         
            Connection connection = null;
            Class.forName(this.getServletContext().getInitParameter("db.driver"));
            connection = DriverManager.getConnection(this.getServletContext().getInitParameter("db.webexURL"),this.getServletContext().getInitParameter("db.user"),this.getServletContext().getInitParameter("db.passwd"));
            
            Statement statement = connection.createStatement();
            
          try{  	    
	    String MaxID ="";
	    resultd = statement.executeQuery("select max(DissectionID) from rel_scope_dissection");        
	        while(resultd.next())
		{ 	
		MaxID = resultd.getString(1);		
		}
	    int Max = Integer.parseInt(MaxID);	
	    
	    String MaxLine="";
	    resultd1 = statement.executeQuery("select max(LineIndex) from ent_line where DissectionID = '"+Max+"' ");        
	    	while(resultd1.next())
	    	{
	    	MaxLine=resultd1.getString(1);
	    	}
	    int Line = Integer.parseInt(MaxLine);	
	    
	    while(Line>0){
	    String comment = request.getParameter("C"+Line+"");
	    comment = comment.replace("'","\\'");
	    String command = "update ent_line set Comment = '"+comment+"' where DissectionID = '"+Max+"' and LineIndex = '"+Line+"' ";	    	   
            statement.executeUpdate(command);              
            Line--;
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
	    
      response.sendRedirect("ParserServlet?sc="+request.getParameter("sc")+"&question="+request.getParameter("ex")+"&type=example&load=javaExampleSaved.jsp");
	 %>
</body> 
</html>