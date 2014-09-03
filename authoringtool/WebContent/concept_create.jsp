<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>
<%@ include file = "include/connectDB.jsp" %>
<%@ page import="java.sql.*" %>

<%
           Statement statement = conn.createStatement();
%>
<script language="javascript">

function send_iswriting(e){
     var key = -1 ;
     var shift ;

     key = e.keyCode ;
     shift = e.shiftKey ;

     if ( !shift && ( key == 13 ) )
     {
          document.form.reset() ;
     }
}

</script>

<h2>Concept Editing:</h2>

<form name="create_voc" method="post" action="concept_create_save.jsp">
<table border="1">
<tr>
	<td><b><input type="radio" name="create" value="addconcept" checked>Create Concept to Vocabulary</b></td>
	<td>
	<table>
	<%
	 ResultSet rs = null;  
	 rs = statement.executeQuery("SELECT * FROM ent_ontology where Privacy='1'");
	%>
	<tr>
		<td class="formfieldbold formfielddark">Ontology:	</td>
		<td>
		<select name="ont">
		<%
		 while(rs.next())
		  {
		  	out.write("<option value="+rs.getString(1)+">"+rs.getString(2)+"</option>");	
		  }	
	  	%>
		</select>
		</td>
	</tr>
	<tr>
		<td class="formfieldbold formfielddark">Type:	</td>
		<td><select name="type"><option value="0">0 (broad)</option><option value="1">1 (specific)</option></select></td>
	</tr>
	<tr>
		<td class="formfieldbold formfielddark">Title:	</td>
		<td><input type="text" name="title" size="45" maxlength="45"></td>
	</tr>
	<tr>
		<td class="formfieldbold formfielddark">Description:	</td>
		<td><input type="text" name="Description" size="70" maxlength="255"></td>
	</tr>
	<tr>
		<td class="formfieldbold formfielddark">rdfID:	</td>
		<td><input type="text" name="rdfID" size="15" maxlength="15"></td>
	</tr>	
	<tr>
		<td></td>
		<td><input type="submit" value="Submit">&nbsp;&nbsp;<input type="reset" value="Clear" OnClick="document.form.message.focus()"></td>
	</tr>
	<tr><td></td><td><br></td></tr>
	</table>
	</td>	
</tr>

<tr>
	<td><b><input type="radio" name="create" value="addvoc">Add Vocabulary</b></td>
	<td>
	<table>
	<tr>
		<td  class="formfieldbold formfielddark">Vocabulary: </td>
		<td><input type="text" name="voc" size="45" maxlength="45">(eg. Java Language)</td>
	</tr>
	<tr>
		<td class="formfieldbold formfielddark">Description:	</td>
		<td><input type="text" name="vocDes" size="70" maxlength="255"></td>
	</tr>
	<tr>
		<td class="formfieldbold formfielddark">rdfID:	</td>
		<td><input type="text" name="vocrdfID" size="15" maxlength="15"></td>
	</tr>	
	<tr>
		<td></td>
		<td><input type="RADIO" name="privacy" value="private" checked>Private <input type="RADIO" name="privacy" value="public">Public</td>
	</tr>	
	<tr>
		<td></td>
		<td><input type="submit" value="Submit">&nbsp;&nbsp;<input type="reset" value="Clear" OnClick="document.form.message.focus()"></td>
	</tr>		
	</table>
	</td>
</tr>
</table>
</form>

</body> 
</html>