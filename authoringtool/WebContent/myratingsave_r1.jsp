<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>
<%@ page import = "java.text.*" %>

<%@ page import="java.sql.*" %>


<%
           Connection connection = null;
Class.forName(this.getServletContext().getInitParameter("db.driver"));
connection = DriverManager.getConnection(this.getServletContext().getInitParameter("db.webexURL"),this.getServletContext().getInitParameter("db.user"),this.getServletContext().getInitParameter("db.passwd"));

            Statement statement = connection.createStatement();
          
Integer LineMax = (Integer)session.getValue("Maxno");            
String TA[];
TA = new String[LineMax];
int count =0;



String rid = request.getParameter("rid");
String uname = userBeanName;


session.setAttribute("ID",rid);
		

PreparedStatement pstmt=null;
ResultSet rs=null;

	try{		
		String sql = "select * from assignuser where uname = '"+uname+"' ";
		pstmt = connection.prepareStatement(sql);
		rs = pstmt.executeQuery();
		while (rs.next()){
			
				for (int j=1; j<LineMax; j++){
					TA[j]= String.valueOf(request.getParameter("rta"+j)).trim(); 								
				String command = "insert into ent_line_a (DissectionID,LineIndex,uid,Annotation) values ( '"+rid+"','"+j+"', '"+rs.getString(1)+"', '" +TA[j]+ "') ";			
				String command1 = "delete from ent_line_a where Annotation = '' ";			
			 	statement.executeUpdate(command);				
			 	statement.executeUpdate(command1);
			 	}		 	
												 	
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
	
response.sendRedirect("http://localhost:8080/example/ViewExample.jsp?exampleno="+session.getAttribute("ID")+" ");       

        
%>
