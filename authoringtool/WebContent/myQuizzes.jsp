<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>
<%@ include file = "include/connectDB.jsp" %>
<script src="<%=request.getContextPath()%>/js/jquery1.4.2.js"></script>

<script type="text/javascript">
$(document).ready(function(){
	$("img").click(function () {
		var fn = $(this).attr('fn');
		if (fn == 'deleteQuiz')
		{
			var qid = $(this).attr('qid');
			if (confirm('Are you sure you want to delete this quiz?')==true)
			{
				$.post("DeleteQuizServlet?QuestionID="+qid,function(data) {
					var err = data.message;
					if (err != '')
					{
						alert(err);
					}
					else
					{alert("Quiz deleted successfully!");window.location.reload(true);} },"json");	 
			}			
		}
	});	
});	
</script>

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
<h3>My Topics:</h3>
<form name="JQuestionModify" method="post" action="jquestion_modify_save.jsp">

	 <table style="width: 100% ">
	 <tr>	 
	 <!-- 
	 	 <td class="formfieldbold formfielddark" width="1%"></td>
	  -->
	 <td class="formfieldbold  formfielddark  " ><b>Title</b></td>	 
	 <td class="formfieldbold  formfielddark  " ><b>Description</b></td>
	 <td class="formfieldbold  formfielddark  " width="15%"><b>Privacy</b></td>
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
         rs1 = statement.executeQuery("SELECT distinct q.QuestionID, q.Title, q.Description, q.Privacy,q.AuthorID from ent_jquestion q, ent_user u where q.AuthorID=u.id and u.name='"+userBeanName+"' order by q.title");
	 int cnt=0;
         while(rs1.next())
	  {	  	  	 	 
		 out.write("<tr>"); 	 
		 cnt++;		 
		 out.write("<input type=hidden name='jquestionid"+cnt+"' value='"+rs1.getString(1)+"'>");
		 		  
		 		%>
		 		<!-- 
		 		<img src="images/trash.jpg" border="0" title = 'Delete quiz' fn = 'deleteQuiz' qid ='<%=rs1.getString(1)%>'></td>
		 		<td>
		 		 --><%
		 	
		 
		 
		 out.write("<td><textarea style='width: 100%;' rows=2 name='Title"+cnt+"' value='"+rs1.getString(2)+"'>"+rs1.getString(2)+"</textarea></td>"); 		 	 		 		 		 
		 out.write("<td><textarea style='width: 100%;' rows=2 name='Description"+cnt+"' value="+rs1.getString(3)+">"+rs1.getString(3)+"</textarea></td>");		 
		 if (rs1.getString(4).equals("1")){	
		  	 if (rs1.getString(5).equals(uid)){
				out.write("<td class = 'formfieldlight'><input type=radio name='privacy"+cnt+"' value=private>Private<input type=radio name='privacy"+cnt+"' value=public checked>Public</td>");			 			 		  	 	 	
			 }else{
			 	out.write("<td class = 'formfieldlight'><input type=radio name='privacy"+cnt+"' value=private disabled>Private<input type=radio name='privacy"+cnt+"' value=public checked>Public</td>");			 			 
			 }
		 }else{		 	
		 	 out.write("<td class = 'formfieldlight'><input type=radio name='privacy"+cnt+"' value=private checked>Private<input type=radio name='privacy"+cnt+"' value=public>Public</td>");
		 	
		 }
		 
		 out.write("</tr>");   		 
	  }	  	 	 
	  out.write("<input type=hidden name=cnt value='"+cnt+"'>");
%>	

<tr>
<td colspan="4"><input type="submit" value="Save"></td>
</tr>
</table>

</form>
<br>


</body> 
</html>