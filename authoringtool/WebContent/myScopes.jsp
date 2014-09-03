<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>
<%@ include file = "include/connectDB.jsp" %>


<h2>My scopes:</h2>


<FORM>
     <table style="width: 100%">
	<tr>
	<td class="formfieldbold formfielddark" ><b>Title</b></td>
	<td class="formfieldbold formfielddark" width="5%"><b>RDF ID</b></td>
	<td class="formfieldbold formfielddark" ><b>Description</b></td>
	<td class="formfieldbold formfielddark" width="5%"><b>Domain</b></td>
	<td class="formfieldbold formfielddark" width="15%"><b>Privacy</b></td>
	
	</tr>

 <%
         Statement statement = conn.createStatement();
            
	 ResultSet rs = null;  
	 String uid="";
	 rs = statement.executeQuery("SELECT id FROM ent_user where name = '"+userBeanName+"' ");
	 while(rs.next())
	  {
	  	uid=rs.getString(1);  	
	  } 
	 rs = statement.executeQuery("SELECT distinct r.Privacy,s.Name, s.rdfID,s.Description,r.ScopeID,r.Uid,s.domain FROM ent_scope s, rel_scope_privacy r "+
				"where r.Uid = '"+uid+"' and s.ScopeID=r.ScopeID");
	 while(rs.next())
	  {
	  	out.write("<tr>");	
	  	
	  	out.write("<td><a href='MyScopeModify.jsp?rdfID="+rs.getString(3)+"'>"+rs.getString(2)+"</a></td>");
	  	out.write("<td>"+rs.getString(3)+"</td>");
	  	out.write("<td>"+rs.getString(4)+"</td>");
	  	out.write("<td>"+(rs.getString(7)==null?"":rs.getString(7))+"</td>");		
		if (rs.getInt(1) == 1){
	  		out.write("<td><input type=radio name=privacy"+rs.getString(3)+" value=Private disabled>Private<input type=radio name=privacy"+rs.getString(3)+" value=Public checked>Public&nbsp;&nbsp;</td>");				
	  	}else{
	  		out.write("<td><input type=radio name=privacy"+rs.getString(3)+" value=Private checked>Private<input type=radio name=privacy"+rs.getString(3)+" value=Public disabled>Public&nbsp;&nbsp;</td>");							
	  	}
		out.write("</tr>");	

	  }
            
%>                  
    </table>  
</FORM>



</body> 
</html>