<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>
<%@ page import = "java.text.*" %>


<%@ page import="java.sql.*" %>

<%
	Connection connection = null;
	Class.forName(this.getServletContext()
	.getInitParameter("db.driver"));
	connection = DriverManager.getConnection(this.getServletContext()
	.getInitParameter("db.webexURL"), this.getServletContext()
	.getInitParameter("db.user"), this.getServletContext()
	.getInitParameter("db.passwd"));
    String ex = request.getParameter("dis");
    String rdfId = "";
	Statement statement = connection.createStatement();
	boolean codeChanged = false;
	String prevCodeString = getExampleCode(ex,connection);
	try {
		int totalline = Integer.parseInt(request.getParameter("max"));
		for (int i = 1; i <= totalline; i++) {
		String text = request.getParameter("comment" + i);
		if (text == null)
			text = "";
		text = text.replace("'", "\\'");			
		String text1 = request.getParameter("code" + i);

		if (text1 == null)
			text1 = "";
		text1 = text1.replace("'", "\\'");

		String command1 = "update ent_line set Code = '"
				+ text1 + "', Comment = '" + text + "' "
				+ " where LineIndex = '" + i
				+ "' and DissectionID = '" + ex + "' ";
		statement.executeUpdate(command1);
		}
		String text2 = request.getParameter("Name");
		String text3 = request.getParameter("Des");
		rdfId = request.getParameter("rdfID");
		text3 = text3.replace("'", "\\'");
		text2 = text2.replace("'", "\\'");
		rdfId = rdfId.replace("'", "\\'");
		String command2 = "update ent_dissection set Name = '" + text2
				+ "',Description = '" + text3 + "',rdfID = '" + rdfId
				+ "'" + " where DissectionID='" + ex + "'";
		statement.executeUpdate(command2);

		if (request.getParameter("privacy").equals("Public")) {
			String command4 = "update rel_dissection_privacy set Privacy = '1' "
					+ "where DissectionID='" + ex + "'";
			statement.executeUpdate(command4);
		} else {
			String command4 = "update rel_dissection_privacy set Privacy = '0' "
					+ "where DissectionID='" + ex + "'";
			statement.executeUpdate(command4);
		}
		String sc = request.getParameter("sc");
		String command4 = "update rel_scope_dissection set ScopeID = '"+sc+"' "
				+ "where DissectionID='" + ex + "'";
		statement.executeUpdate(command4);
		String command5 = "select topicID from rel_topic_dissection "
				+ "where DissectionID='" + ex + "'";
		ResultSet topicRS = statement.executeQuery(command5);
		String curtopicid = "";
		while(topicRS.next())
		{
			curtopicid = topicRS.getString(1);
		}
		String topic = request.getParameter("topic");
		if (topic.equals(curtopicid) == false)
		{
		String command6 = "update rel_topic_dissection set topicID = '"+topic+"' "
				+ "where DissectionID='" + ex + "'";
		statement.executeUpdate(command6);
		}
	String newCodeString = getExampleCode(ex, connection);
	if (prevCodeString.equals(newCodeString) == false)
 	{
		codeChanged = true;
 		String command = "delete from ent_jexample_concept where dissectionId = '"+ex+"'";	
 		statement.executeUpdate(command); 	
 	}
	}
	finally {
		try {
			if (statement != null)
				statement.close();
		} catch (SQLException e) {
		}
		try {
			if (connection != null)
				connection.close();
		} catch (SQLException e) {
		}
	}
	if (codeChanged)
	{
 		response.sendRedirect("ParserServlet?question="+ex+"&type=example&load=JavaExampleModifyAck.jsp");
	}
	else
	{
 		response.sendRedirect("JavaExampleModifyAck.jsp");

	}
%>

<%!
public String getExampleCode(String ex,Connection conn) {
	PreparedStatement ps = null;
	String sqlCommand = "";
	ResultSet rs = null;		
	String separator = System.getProperty( "line.separator" );
	StringBuilder lines = new StringBuilder("");	
	try
	{
		sqlCommand = "SELECT l.Code FROM ent_line l where l.DissectionID="+ex+" order by l.LineIndex ";
		ps = conn.prepareStatement(sqlCommand);
		rs = ps.executeQuery();
		String line;
		while (rs.next())
		{
			line = rs.getString(1);
			line = line.replaceAll("[\\r\\n]", ""); 
			lines.append( line ); 
			lines.append( separator );
		}
	}catch (SQLException e) {
		 e.printStackTrace();
	}
	return  lines.toString( );
}

%>