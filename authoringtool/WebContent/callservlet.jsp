<%@ page language="java" %>
<!DOCTYPE HTML PUBLIC "-//w3c//dtd html 4.0 transitional//en">
<%
	session.setAttribute("getQuestion.questionid","1");
%>

<html>
<head>
<title>Call the servlet</title>
</head>
<body bgcolor="#FFFFFF">

<form action="servlet/rapai.xml.XSQLServlet" method="post">

	<input name="request" value="GET" type ="hidden" />
	<input name="getQuestion.questionid" value="1" type ="hidden" />

	<input type="submit" name="Submit" value="Submit" />
	
</form>

</body>
</html>