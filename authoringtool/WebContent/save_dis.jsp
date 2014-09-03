<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>
<%@ page import = "java.text.*" %>

<%@ page import="java.sql.*" %>


<%
           Connection connection = null;
Class.forName(this.getServletContext().getInitParameter("db.driver"));
connection = DriverManager.getConnection(this.getServletContext().getInitParameter("db.webexURL"),this.getServletContext().getInitParameter("db.user"),this.getServletContext().getInitParameter("db.passwd"));

            Statement statement = connection.createStatement();
            
String text = request.getParameter("textarea1"); 
String ex = request.getParameter("ex");
String count = request.getParameter("count");
String author = userBeanName;

Integer LineMax = (Integer)session.getValue("Maxno");            
String TA[];
TA = new String[LineMax];
for (int j=1; j<LineMax; j++){
	TA[j]= String.valueOf(request.getParameter("textarea1"+j)).trim(); 
	
if (TA[j]==""){
String command = "update ent_line set Comment = '" +TA[j]+ "' , flag ='0' " +
" where LineIndex = '"+j+"' and DissectionID = '"+ex+"' ";
statement.executeUpdate(command);  }
else {
String command = "update ent_line set Comment = '" +TA[j]+ "' , flag ='1' " +
" where LineIndex = '"+j+"' and DissectionID = '"+ex+"' ";
statement.executeUpdate(command);  }

String command3 = "update ent_dissection set Author = '"+author+"' where DissectionID = '"+ex+"' ";
statement.executeUpdate(command3);  

SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
java.util.Date date = new java.util.Date();
String sysdate = dateFormat.format(date);

String command2 = "update rel_scope_dissection set lastmodify_dt = '"+sysdate+"' , taken ='1' " + 
" where DissectionID = '"+ex+"' ";
statement.executeUpdate(command2);
		
}

out.println("save successfully!");
response.sendRedirect("http://localhost:8080/example/EditExample.jsp?exampleno="+request.getParameter("ex")+" "); 

%>