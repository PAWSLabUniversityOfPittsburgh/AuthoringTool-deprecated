<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>

<%
         	
Connection connection = null;
Class.forName(this.getServletContext().getInitParameter("db.driver"));
connection = DriverManager.getConnection(this.getServletContext().getInitParameter("db.webexURL"),this.getServletContext().getInitParameter("db.user"),this.getServletContext().getInitParameter("db.passwd"));
Statement statement = connection.createStatement();
String MaxID ="";
ResultSet rs3 = null;
rs3 = statement.executeQuery("SELECT Count(*) FROM ent_class;");        
        while(rs3.next())
		{ 	
			MaxID = rs3.getString(1);		
		}            
int totalcount = Integer.parseInt(MaxID);		

List messages = (List) session.getAttribute("messages");
            if (messages == null) {
                messages = new ArrayList();
                session.setAttribute("messages", messages);
            }
            
HashMap ClassMap = new HashMap();            
//int innercnt = 0;
for (int a=0; a<totalcount; a++){
	if (request.getParameter("ClassID"+(a+1))!=null)
	{	
		ClassMap.put("ClassID"+(a+1)+"",request.getParameter("ClassID"+(a+1)));
		ClassMap.put("ClassName"+(a+1)+"",request.getParameter("ClassName"+(a+1)));
		//out.println(request.getParameter("ClassID"+(a+1))+":	"+request.getParameter("ClassName"+(a+1))+"<br>");										
	}		
	messages.add(a, ClassMap);
}


response.sendRedirect(request.getContextPath()+"/jquestion_create1.jsp");
%>

