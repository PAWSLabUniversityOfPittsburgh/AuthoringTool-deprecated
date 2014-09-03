<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>
<%@ include file = "include/connectDB.jsp" %>


<h3>My Examples:</h3>
<FORM>
     <table style="width: 100%">
	<tr>
	<td class="formfieldbold formfielddark" width="2%"><b>Preview</b></td>
	<td class="formfieldbold formfielddark" ><b>Title</b></td>
	<td class="formfieldbold formfielddark" width="5%"><b>RDF ID</b></td>
	<td class="formfieldbold formfielddark" ><b>Description</b></td>
	<!-- <td class="formfieldbold formfielddark" ><b>Scope</b></td>-->
    <td class="formfieldbold formfielddark" width="15%"><b>Privacy</b></td>
	</tr>

 <%
     String uid = "";
     ResultSet rs = null;  
     Statement statement = conn.createStatement();
     rs = statement.executeQuery("SELECT id FROM ent_user where name = '"+userBeanName+"' ");
     while(rs.next())
	 {
    	 uid = rs.getString(1);
	 }
     String des = "";
	 rs = statement.executeQuery("SELECT distinct d.DissectionID,d.Name,d.Description,dp.Uid,dp.Privacy,s.Name,s.ScopeID,sp.Privacy,d.rdfID FROM rel_dissection_privacy dp, ent_dissection d, ent_user u,ent_scope s,rel_scope_dissection sd, rel_scope_privacy sp where dp.DissectionID=d.DissectionID and u.name = '"+userBeanName+"' and u.id = dp.Uid and sd.DissectionID=d.DissectionID and s.ScopeID=sd.ScopeID and sp.ScopeID=s.ScopeID order by d.name");
	 while(rs.next())
	  {
	  	out.write("<tr class='formfieldlight'>");	
	  	out.write("<td><center><a href='http://adapt2.sis.pitt.edu/webex/Dissection2?act="+rs.getString(9)+"' target='_blank'><img src='images/preview.jpg' width=20 height=20 border=0></a></center></td>");	
	  	des = rs.getString(3);
	  	if (des == null)
	  		des = "";
	  	%>
	  	<td><a href="<%=request.getContextPath()%>/displayA1.jsp?sc=<%=rs.getString(7)%>&dis=<%=rs.getString(1)%>&uid=<%=uid%>"><%=rs.getString(2)%></a></td>				
	  	<%
	  	out.write("<td>"+rs.getString(9)+"</td>");
	  	out.write("<td>"+des+"</td>");
		
		//if (rs.getString(8).equals("1")){	  					
	  	//	out.write("<td>"+rs.getString(6)+"</td>");				
	  	//}else{
	  	//	out.write("<td bgcolor='#FCF4BD' title = 'private scope'>"+rs.getString(6)+"</td>");
	  	//}
		if (rs.getString(5).equals("1")){
	  		out.write("<td><input type=radio name=privacy"+rs.getString(1)+" value=Private disabled>Private<input type=radio name=privacy"+rs.getString(1)+" value=Public checked >Public&nbsp;&nbsp;</td>");				
	  	}else{
	  		out.write("<td><input type=radio name=privacy"+rs.getString(1)+" value=Private checked>Private<input type=radio name=privacy"+rs.getString(1)+" value=Public disabled>Public&nbsp;&nbsp;</td>");							
	  	}
	  	out.write("</tr>");	
	  }
            
%>                  
    </table>  
</FORM>



</body> 
</html>