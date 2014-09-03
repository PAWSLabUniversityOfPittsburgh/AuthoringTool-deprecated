<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>
<%@ include file = "include/connectDB.jsp" %>
<%@ page import="java.sql.*" %>

<%
     Connection connection = null;
Class.forName(this.getServletContext().getInitParameter("db.driver"));
connection = DriverManager.getConnection(this.getServletContext().getInitParameter("db.webexURL"),this.getServletContext().getInitParameter("db.user"),this.getServletContext().getInitParameter("db.passwd"));
Statement statement = connection.createStatement();

     ResultSet rs = null; 
     int MaxScopeID=0;
     rs = statement.executeQuery("SELECT Max(ScopeID) FROM ent_scope");
     while(rs.next())
	  {MaxScopeID=Integer.parseInt(rs.getString(1));}
          
     String totalrow = request.getParameter("row");
     String name = request.getParameter("newscopename");
     String des	= request.getParameter("newscopedes");     
     
     if ((request.getParameter("radioSet")).equals("button2")){
        if (name.equals("")){
        	if (des.equals("")){
        		out.println("no scope name&description");
        	}
        	else{out.println("no scope name");}
        } 
        else if (des.equals("")){        	
        		out.println("no scope description");    
        }
        else {
        	     String command = "insert into ent_scope (ScopeID,Name,Description) values ( '"+(MaxScopeID+1)+"','" +name+ "', '"+des+"') ";
		     statement.executeUpdate(command);
		     
        	     for (int a=1; a<=Integer.parseInt(totalrow); a++){
		     	if ((request.getParameter("ID"+a+""))!=null){
	        	     String command1 = "insert into rel_scope_dissection (ScopeID,DissectionID) values ('" +(MaxScopeID+1)+ "', '"+(request.getParameter("ID"+a+""))+"') ";			     
			     statement.executeUpdate(command1);	
		     	}
		     }		
		      out.println("index successfully!");   
        }
      }
      else if ((request.getParameter("radioSet")).equals("button1")){      		
        	     for (int a=1; a<=Integer.parseInt(totalrow); a++){
		     	if ((request.getParameter("ID"+a+""))!=null){
	        	     String command1 = "insert into rel_scope_dissection (ScopeID,DissectionID) values ('" +(request.getParameter("scopeid"))+ "', '"+(request.getParameter("ID"+a+""))+"') ";			     
			     statement.executeUpdate(command1);				     
		     	}
		     }      		
		      out.println("index successfully!");   
      }
 
%>
     