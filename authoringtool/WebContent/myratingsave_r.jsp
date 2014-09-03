<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>
<%@ page import = "java.text.*" %>

<%@ page import="java.sql.*" %>


<%
           Connection connection = null;
Class.forName(this.getServletContext().getInitParameter("db.driver"));
connection = DriverManager.getConnection(this.getServletContext().getInitParameter("db.webexURL"),this.getServletContext().getInitParameter("db.user"),this.getServletContext().getInitParameter("db.passwd"));

            Statement statement = connection.createStatement();
            
String annotation = request.getParameter("rta"); 
String rid = request.getParameter("rid");
String rline = request.getParameter("rline");
String uname = userBeanName;


session.setAttribute("ID",rid);
		

PreparedStatement pstmt=null;
ResultSet rs=null;
	try{		
		String sql = "select * from assignuser where uname = '"+uname+"' ";
		pstmt = connection.prepareStatement(sql);
		rs = pstmt.executeQuery();
		while (rs.next()){

			String command = "insert into ent_line_a (DissectionID,LineIndex,uid,Annotation) values ( '"+rid+"','"+rline+"', '"+rs.getString(1)+"', '" +annotation+ "') ";
			
			statement.executeUpdate(command); 
		}
	}catch(SQLException sqle){
		out.println(sqle);
	}
	finally{
		try{
		if(rs != null)
			rs.close();
		if(pstmt != null)
			pstmt.close();
		if(connection != null)
			connection.close();
		}catch(Exception e){}
	}	
	
response.sendRedirect("http://localhost:8080/example/ViewExampleRate.jsp?exampleno="+session.getAttribute("ID")+" ");        
%>
