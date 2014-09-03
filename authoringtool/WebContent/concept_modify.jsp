<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>
<%@ include file = "include/connectDB.jsp" %>


<h3>Modify Concept:</h3>
<%
	    Statement statement = conn.createStatement();
     	ResultSet rs2 = null;      
        rs2 = statement.executeQuery("SELECT ontID,Name FROM ent_ontology " );
%>
<form method="post" name="con">
<table border="1">
	<tr>
	<td class="formfieldbold formfielddark"><b>select Vocabulary:</b></td>
	<td>
	<select>
		<%
		while(rs2.next()){
		out.write("<option value='"+rs2.getString(1)+"'>"+rs2.getString(2)+"</option>");
		}
		%>
	</select>
	</td>
	<td><input type="submit" value="Submit"></td>
	</tr>
</table>
</form>
<br>
<h3>Modify Vocabulary:</h3>
<form name="voc" method="post" action="concept_modify_save.jsp">
	 <table border="1">
	 <tr>	 
	 <td class="formfieldbold formfielddark"></td>
	 <td class="formfieldbold  formfielddark  " ><b>Title</b></td>
	 <td class="formfieldbold  formfielddark  " ><b>Description</b></td>
	 <td class="formfieldbold  formfielddark  " ><b>rdfID</b></td>	 
	 <td class="formfieldbold  formfielddark  " ><b>Privacy</b></td>
	 </tr>
<%	     	
	 String uid="";
	 ResultSet rs = null;  
	 rs = statement.executeQuery("SELECT id FROM ent_user where name = '"+userBeanName+"' ");
	 while(rs.next())
	  {
	  	uid=rs.getString(1);  	
	  }     
 
	 out.write("<tr>");  	 
         ResultSet rs1 = null;      
         rs1 = statement.executeQuery("SELECT * FROM ent_ontology " );
	 int cnt=0;
         while(rs1.next())
	  {	  	  	 	 
		 out.write("<tr>"); 	 
		 cnt++;		 
		 out.write("<input type='hidden' name='ontID"+cnt+"' value='"+rs1.getString(1)+"'>");
          	 out.write("<td><a href='concept_delete.jsp?ontID="+rs1.getString(1)+"'><img src=images/trash.jpg border=0></a></td>");		 		 
		 out.write("<td><textarea cols=45 rows=1 name='Name"+cnt+"' value='"+rs1.getString(2)+"'>"+rs1.getString(2)+"</textarea></td>"); 		 	 		 		 
		 out.write("<td><textarea cols=45 rows=1 name='Description"+cnt+"' value='"+rs1.getString(3)+"'>"+rs1.getString(3)+"</textarea></td>"); 		 	 		 		 		 
		 out.write("<td><textarea cols=15 rows=1 name='rdfID"+cnt+"' value='"+rs1.getString(4)+"'>"+rs1.getString(4)+"</textarea></td>");		 
		 if (rs1.getString(5).equals("1")){	
				out.write("<td><input type=radio name='privacy"+cnt+"' value='private'>Private<input type=radio name='privacy"+cnt+"' value='public' checked>Public</td>");			 			 		  	 	 	
		}else{
			 	out.write("<td><input type=radio name='privacy"+cnt+"' value='private' checked>Private<input type=radio name='privacy"+cnt+"' value='public'>Public</td>");			 			 
		}
		 
		 out.write("</tr>");   		 
	  }	  	 	 
	  out.write("<input type=hidden name=cnt value='"+cnt+"'>");
	  
%>	

<tr>
<td  class="formfieldbold formfielddark"></td>
<td  class="formfieldbold formfielddark"><input type="submit" value="Save"></td>
</tr>

</table>
</form>


</body> 
</html>