<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>
<%@ page import = "java.text.*" %>
<%@ page import="java.util.Enumeration" %>
<%@ include file = "include/connectDB.jsp" %>


<%@ page import="java.sql.*" %>


<%
           Statement statement = conn.createStatement();
            
	   Enumeration Enum;
	   Object Obj;
	   String StrArray[];
	   int i;                       
	   int len;

	   PreparedStatement pstmt=null;
	   ResultSet rs=null;

String username = request.getParameter("index");


			
   Enum = request.getParameterNames();
   while(Enum.hasMoreElements()){
      Obj = Enum.nextElement();
      StrArray = request.getParameterValues((String)Obj);      
      for(i=0;i<StrArray.length;i++){                 
      
	   char[] str2 = StrArray[i].toCharArray();			
	   for(int j=0; j < StrArray[i].length(); j++) {
	     if(!Character.isDigit(str2[j])) {
	     break; 
	     }
	     else{
		
	        String command = "update rel_scope_dissection set taken = '1' " +
		" where ScopeID = '1' and DissectionID = '"+StrArray[i]+"' ";	
		statement.executeUpdate(command); 
	        String command1 = "update ent_dissection set Author = '"+username+"' " +
		" where DissectionID = '"+StrArray[i]+"' ";	
		statement.executeUpdate(command1);							      								      									
		
	     }
	   }	
		try{									
			String sql = "select * from assignuser where uname = '"+username+"' " ;	
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();	   
	   	while (rs.next()){
	   	String command2 = "insert into assignexample (uid,exno) values ( '"+rs.getString(1)+"','"+StrArray[i]+"') " ;		
		statement.executeUpdate(command2);
                }
                    		}catch(SQLException sqle){
			out.println(sqle);
		}catch(Exception e){
			out.println(e);
		}
		
      }
   
    }
    
	      
  
out.println("assign successfully!");
response.sendRedirect("assignuser_ex.jsp");     

%>