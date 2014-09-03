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
String uname = userBeanName;

session.setAttribute("EXNO",exno);

	PreparedStatement pstmt=null;
	ResultSet rs=null;
	PreparedStatement pstmt1=null;
	ResultSet rs1=null;	
			
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

	
String sql1 = "select distinct r.rating from assignrate r, assignuser u where r.exno = '"+exno+"' and r.uid = u.uid and u.uname ='"+uname+"' ";
pstmt1 = connection.prepareStatement(sql1);
rs1 = pstmt1.executeQuery();
while(rs1.next()){
	
	if (rs1.getString(1).equals("0.0")){

		String command = "update rel_scope_dissection set EvaluateHit = '" +(hitint+1)+ "' , Rating = '"+newrating+"' " +
		" where DissectionID = '"+exno+"' ";
		statement.executeUpdate(command);  
		
		String command1 = "update assignrate r, assignuser u set r.rating = '"+rating+"' " +
		" where r.exno = '"+exno+"' and r.uid = u.uid and u.uname = '"+uname+"' ";
		statement.executeUpdate(command1);  
		
			
		response.sendRedirect("http://localhost:8080/example/ViewExampleRate.jsp?exampleno="+request.getParameter("ex")+"&newrating="+newrating+"&RDID="+request.getParameter("ex")+" ");     		
		
		}
	else
	{
		%>
		<script language="javascript">
		 <!--
		alert("Ratings can only be submitted Once!")		
		window.location = 'http://localhost:8080/example/home.jsp'
		//-->
		</script>				
		<%
	
	}

}



%>