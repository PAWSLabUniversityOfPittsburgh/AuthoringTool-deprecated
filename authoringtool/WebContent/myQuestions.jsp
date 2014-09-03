<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>
<%@ include file = "include/connectDB.jsp" %>
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
<script language="javascript">
function changelist()
{
var quid=document.jquizmodify.question.value;
document.location.href="jquestion_modify1.jsp?msg=0&QuestionID="+quid;  
}                                                                                
</script>
<h3>My Questions:</h3>
<form name="JQuestionModify" method="post" action="jquestion_modify_save.jsp">

	 <table style="width: 100% ">
	 <tr>	
	 <!-- 
	 	 <td class="formfieldbold formfielddark"></td>
	 
	  --> 
	 <td class="formfieldbold  formfielddark  " ><b>Topic</b></td>	 
	 <td class="formfieldbold  formfielddark  " ><b>Question</b></td>
	 <td class="formfieldbold  formfielddark  " ><b>rdfID</b></td>
	 <td class="formfieldbold  formfielddark  " ><b>Description</b></td>
	 <td class="formfieldbold  formfielddark  " ><b>Privacy</b></td>
	 
	 
	 </tr>
<%	 
Statement statement = conn.createStatement();
String uid="";
ResultSet rs = null;  
rs = statement.executeQuery("SELECT id FROM ent_user where name = '"+userBeanName+"' ");
while(rs.next())
 {
 	uid=rs.getString(1);  	
 } 
 
	 out.write("<tr>");  	 
         ResultSet rs1 = null;    
		 rs1 = statement.executeQuery("SELECT q.Title,z.Title,z.rdfID,z.Description,z.privacy,z.QuizID,q.QuestionID FROM ent_jquiz z, ent_user u, rel_question_quiz qq, ent_jquestion q where u.name='"+userBeanName+"' and z.AuthorID=u.id and qq.QuizID=z.QuizID and q.QuestionID = qq.QuestionID order by q.title,z.title");			

	 int cnt=0;
         while(rs1.next())
	  {	  	  	 	 
		 out.write("<tr>"); 	 
		 cnt++;		 
		 out.write("<input type=hidden name='jquestionid"+cnt+"' value='"+rs1.getString(1)+"'>");
		 		  
		 		%>
		 		<!--
		 		<td><a href="jquestion_delete.jsp?QuestionID=<%=rs1.getString(1)%>" onClick="if (confirm('you sure you want to delete this question?')==false){return false;}"><img src="images/trash.jpg" border="0"></a></td>

		 		 -->
		 		<%
		 	
		 
		 
		 out.write("<td class='formfieldlight'>"+rs1.getString(1)+"</td>"); 		 	 		 		 		 
		 out.write("<td class='formfieldlight'><a href = 'ModifyQuestion.jsp?QuestionID="+rs1.getInt(7)+"&qid="+rs1.getInt(6)+"&qname="+rs1.getString(2)+"'>"+rs1.getString(2)+"</a></td>");
		 out.write("<td class='formfieldlight'>"+rs1.getString(3)+"</td>");		 
		 out.write("<td class='formfieldlight'>"+rs1.getString(4)+"</td>");	

		 if (rs1.getString(5).equals("1")){	
			 out.write("<td class='formfieldlight'><input type=radio name='privacy"+cnt+"' value=private disabled>Private<input type=radio name='privacy"+cnt+"' value=public checked>Public</td>");			 			 		  	 	 	
		 }else{		 	
		 	 out.write("<td class='formfieldlight'><input type=radio name='privacy"+cnt+"' value=private checked>Private<input type=radio name='privacy"+cnt+"' value=public disabled>Public</td>");	
		 }
		 
		 out.write("</tr>");   		 
	  }	  	 	 
	  out.write("<input type=hidden name=cnt value='"+cnt+"'>");
%>	

<tr>
</tr>
</table>

</form>
<br>


</body> 
</html>