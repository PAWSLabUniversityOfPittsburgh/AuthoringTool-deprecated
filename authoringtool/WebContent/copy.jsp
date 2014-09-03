<%@ page import="java.sql.*" %>
<%@ include file = "include/connectDB.jsp" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>code</title>
</head>

<body>


<form>
<script>
<!-- Beginning of JavaScript -
function highlight(x){
document.forms[x].elements[0].focus()
document.forms[x].elements[0].select()
}
// - End of JavaScript - -->
</script>
<textarea name="text" rows="15" cols="43" style="background-color: FFFFFF; color: 0000FF">
  <% 

	PreparedStatement pstmt=null;
	ResultSet rs=null;
	try{		
		String sql = "select Code from ent_line where DissectionID = " + session.getAttribute("exno");
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();	
		while (rs.next()){%><%=rs.getString(1)%>
		<%}%>
<%
	}catch(SQLException sqle){
		out.println(sqle);
	}
	finally{
		try{
		if(rs != null)
			rs.close();
		if(pstmt != null)
			pstmt.close();
		if(conn != null)
			conn.close();
		}catch(Exception e){}
	}	
%>	
</textarea>
<br>
<a href="javascript:highlight(0)">
<font size="-1" color="#FF0000">Select ALL</font></a>
</form>
</body>
</html>