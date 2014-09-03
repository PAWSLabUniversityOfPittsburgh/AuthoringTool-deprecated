<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>	
<%@ page import="java.io.*,java.util.*" %>

    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>SaveIndexing</title>

</head>
<body>
<%
String question = request.getParameter("question");   
String count = request.getParameter("count");
String type = request.getParameter("type");
boolean isExample = false;
if (type != null)
{
	if (type.equals("example"))
		isExample = true;
}
String table = "ent_jquiz_concept";
if (isExample)
	table = "ent_jexample_concept";
int conceptCount = Integer.parseInt(count.trim());
for (int i = 0; i < conceptCount; i++)
 {
   	 String selected = request.getParameter(i+"Selected");
	 String concept = request.getParameter(i+"Concept");

   	 PreparedStatement pstmt = null;
   	 Connection conn = null;
   	 String query;
   		try {
   			Class.forName(this.getServletContext().getInitParameter("db.driver"));
   			conn = DriverManager.getConnection(this.getServletContext().getInitParameter("db.webexURL"),this.getServletContext().getInitParameter("db.user"),this.getServletContext().getInitParameter("db.passwd"));

   			//	if the concept is null, it means the check box of the concept
   		    //	is not selected by user and this concept should be removed since it 
   		    //	has been previously stored in db by ParserServlet
   			
   			if (selected == null)
   			{
   				query = "delete from "+table+" where title = '"+question+"'" +" and concept = '"+concept+"'";
   				pstmt = conn.prepareStatement(query);
   				pstmt.executeUpdate();
   			}
   			else 
   			{
 		   	    String weight = request.getParameter(i+"Weight");
 		   	    String direction = request.getParameter(i+"Direction");
 		   	    if (direction.equals("outcome"))
 		   	    	direction  = "outcome";
 		   	    else
 		   	    	direction = "prerequisite";
   				query = "update "+table+" set weight = '"+weight+"', direction = '"+ direction+"' where title = '"+question+"'"+" and concept = '"+concept+"'";
   				pstmt = conn.prepareStatement(query);
   				pstmt.executeUpdate();
   			}	
   			 }catch (SQLException e) {
   					e.printStackTrace();
   				} finally {
   					try {   						
   						if (pstmt != null)
   							pstmt.close();
   						try {
   							if (conn != null && (conn.isClosed() == false)) {
   								conn.close();
   							}
   						} catch (SQLException e) {
   							e.printStackTrace();
   						}
   						
   					} catch (Exception e) {
   						if (conn != null && (conn.isClosed() == false)) {
								conn.close();
							}
   						e.printStackTrace();
   					}
                 }
 }
%>
</body>
</html>