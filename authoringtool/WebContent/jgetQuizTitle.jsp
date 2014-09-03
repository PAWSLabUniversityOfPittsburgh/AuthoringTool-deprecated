<%@ page import="java.sql.*" %>
<%@ include file = "include/connectDB.jsp" %>
<html>
<head>
<script language="javascript" src="<%=request.getContextPath()%>/stylesheets/getQuiz.js"></script>
</head>

<body>

<%
String rdfID = request.getParameter("q");
int quizID = 0;
String code ="";
Statement st=conn.createStatement();
ResultSet rs=st.executeQuery("select QuizID, Title, Code from ent_jquiz where rdfID ='"+rdfID+"';");
%>
<form method="POST" ACTION="ExtractQuizC">
<pre>
<%
while(rs.next()){
	quizID = rs.getInt("QuizID");	
	code = rs.getString("Code");
	out.println(rs.getString("Code"));	
}//while
	
%>
</pre>
<input type="hidden" name="quiz" value="<%=quizID%>" />
<input type="hidden" name="code" value="<%=code%>" />
<input type="submit" name="QuizTitleForm"" value="Extract">
</form>

</body>
</html>
<%
st.close();
rs.close();
conn.close();
%>
