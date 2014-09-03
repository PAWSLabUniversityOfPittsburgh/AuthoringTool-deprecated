<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>
<%@ page import = "java.text.*" %>


<%@ page import="java.sql.*" %>


<%
           Connection connection = null;
Class.forName(this.getServletContext().getInitParameter("db.driver"));
connection = DriverManager.getConnection(this.getServletContext().getInitParameter("db.webexURL"),this.getServletContext().getInitParameter("db.user"),this.getServletContext().getInitParameter("db.passwd"));

            Statement statement = connection.createStatement();
              
String ex = request.getParameter("ex");
int exno = Integer.parseInt(ex);
int rating = Integer.parseInt(request.getParameter("a"));
double newrating = 0.0;
int hitint = 0;
double oldrating = 0.0;

	PreparedStatement pstmt=null;
	ResultSet rs=null;
	try{		
		String sql = "select * from rel_scope_dissection where DissectionID = " + exno;
		pstmt = connection.prepareStatement(sql);
		rs = pstmt.executeQuery();
		while(rs.next()){
	
		oldrating = Double.valueOf(rs.getString(9));

		hitint=Integer.parseInt(rs.getString(10));
		
		newrating = ((oldrating*hitint)+rating)/(hitint+1);				
		}
	}catch(SQLException sqle){
		out.println(sqle);
	}

String command = "update rel_scope_dissection set EvaluateHit = '" +(hitint+1)+ "' , Rating = '"+newrating+"' " +
" where DissectionID = '"+exno+"' ";
statement.executeUpdate(command);  

String command1 = "update assignrate set rating = '"+newrating+"' " +
" where exno = '"+exno+"' ";
statement.executeUpdate(command1);  
	
response.sendRedirect("http://localhost:8080/example/star.jsp?RDID="+request.getParameter("ex")+" ");     		






%>