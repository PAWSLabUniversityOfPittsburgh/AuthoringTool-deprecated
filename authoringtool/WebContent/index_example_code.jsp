<%@ page language="java" %>
<%@ page import="java.sql.*" %>
<?xml version="1.0" encoding="utf8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Example - Authoring - example code</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf8" />
<link href="<%=request.getContextPath()%>/stylesheets/authoring.css" rel="stylesheet" type="text/css" />
</head>
DissectionID: <%=request.getParameter("ex")%><br>
<table>
<tr>
<td>
<pre>
<%
     Connection connection = null;
Class.forName(this.getServletContext().getInitParameter("db.driver"));
connection = DriverManager.getConnection(this.getServletContext().getInitParameter("db.webexURL"),this.getServletContext().getInitParameter("db.user"),this.getServletContext().getInitParameter("db.passwd"));
Statement statement = connection.createStatement();
     
     ResultSet rs = null; 
     rs = statement.executeQuery("SELECT Code, Comment FROM ent_line where DissectionID='"+request.getParameter("ex")+"' order by LineIndex ");
     while(rs.next()){
     	out.write(rs.getString(1)+"	"+rs.getString(2)+"<br>");     	
     }
%>
</pre>
</td>
</tr>
</table>
</html>
