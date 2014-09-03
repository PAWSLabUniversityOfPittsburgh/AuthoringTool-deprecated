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

function changelist1()
{
var quid=document.jquizmodify.question.value;
var quizID=document.jquizmodify.quiz.value;
document.location.href="jquiz_modify_retrieve.jsp?msg=0&QuestionID="+quid+"&quiz="+quizID;  
}                                                                            
</script>
<h3>Modify Java Question:</h3>
<form name="jquizmodify" method="post">
<table border="1">
<tr>
<td  class="formfieldbold formfielddark">
	<table>
	<tr>
		<td class="formfieldbold formfielddark"><b>Quiz:<font color="red">*</font></b>	</td>
		<td><select name="question" onChange="Javascript:changelist();">
		<%
	Connection connection = null;
		Class.forName(this.getServletContext().getInitParameter("db.driver"));
        connection = DriverManager.getConnection(this.getServletContext().getInitParameter("db.webexURL"),this.getServletContext().getInitParameter("db.user"),this.getServletContext().getInitParameter("db.passwd"));
        Statement statement = connection.createStatement();

	 String uid="";
	 ResultSet rs = null;  
	 rs = statement.executeQuery("SELECT id FROM ent_user where name = '"+userBeanName+"' ");
	 while(rs.next())
	  {
	  	uid=rs.getString(1);  	
	  }  
	  
			 ResultSet rs2 = null;  
			 rs2 = statement.executeQuery("SELECT q.QuestionID,q.Title,q.Privacy FROM ent_jquestion q, ent_user u where (q.Privacy = '1' or u.name='"+userBeanName+"') and q.AuthorID=u.id  order by q.Title ");
			 while(rs2.next())
			  {			  			  				  
			  	if(rs2.getString(3).equals("1")){
			  		if(rs2.getString(1).equals(request.getParameter("QuestionID"))){ 		
			  		   out.write("<option value='"+rs2.getString(1)+"' selected>"+rs2.getString(2)+"</option>");			  	        			  		
			  		}else{
			  		  out.write("<option value='"+rs2.getString(1)+"'>"+rs2.getString(2)+"</option>");			  	        			  		
			  		}
			  	}else{			  		
			  		if(rs2.getString(1).equals(request.getParameter("QuestionID"))){ 		
			  	           out.write("<option value='"+rs2.getString(1)+"' style=background-color:#A9A9D5 selected>"+rs2.getString(2)+"</option>");			  	        			  	      
			  	        }else{
			  	           out.write("<option value='"+rs2.getString(1)+"' style=background-color:#A9A9D5>"+rs2.getString(2)+"</option>");			  	        			  	      
			  	        }
			  	}
			  }				
		%>			
		</select></td>
	</tr>	
	<tr>
		<td class="formfieldbold formfielddark"><b>Question:<font color="red">*</font></b>	</td>
		<td>
			<select name="quiz" onChange="Javascript:changelist1();">
			<%			 
			 ResultSet rs3 = null;  
			 rs3 = statement.executeQuery("SELECT z.QuizID,z.Title,z.Privacy,z.rdfid FROM ent_jquiz z, ent_user u, rel_question_quiz qq where (z.Privacy = '1' or u.name='"+userBeanName+"') and z.AuthorID=u.id and qq.QuizID=z.QuizID and qq.QuestionID='"+request.getParameter("QuestionID")+"' ");			
			 while(rs3.next()){
			 	out.write("<option value='"+rs3.getString(1)+"'>"+rs3.getString(2)+"</option>");
			 }
			%>
			</select>	
			<input type="hidden" name="QuestionID" value="<%=request.getParameter("QuestionID")%>">
			<input type="hidden" name="rdfid" value="<%=request.getParameter("rdfid")%>">
			<input type="submit" value="Retrieve Quiz Data" onClick="submitFunction(this.form,1)">
		</td>
	</tr>
	<tr>
		<td class="formfieldbold formfielddark"><b>Title:<font color="red">*</font></b>	</td>
		<td><input type="text" name="title2" size="45" maxlength="45"></td>
	</tr>
	<tr>
		<td class="formfieldbold formfielddark"><b>rdfID:<font color="red">*</font></b></td>
		<td><input type="text" name="rdfID" size="45" maxlength="45"></td>
	</tr>	
	<tr>
		<td class="formfieldbold formfielddark"><b>Description:	</b></td>
		<td><input type="text" name="description2" size="70" maxlength="255"></td>
	</tr>
	<tr>
		<td class="formfieldbold formfielddark"><b>QuestionType:<font color="red">*</font></b></td>
		<td><select name="questiontype">
			<option value="1">final value</option>
			<option value="2">output</option>
			<option value="3">which line is wrong</option>
			<option value="4">fill in the blank</option>
			<option value="5">dynamic import</option>
			<option value="6">class()</option>			
		</select></td>
	</tr>	
	<tr>
		<td class="formfieldbold formfielddark"><b>Code:<font color="red">*</font></b>	</td>
		<td><textarea cols="80" rows="5" name="quizcode"></textarea></td>
	</tr>
	<tr>
		<td class="formfieldbold formfielddark"><b>Minimum:<font color="red">*</font></b></td>
		
		<td>
		<table><tr>		
		<td><input type="text" name="minvar" size="4" maxlength="4"></td>
		<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td class="formfieldbold formfielddark"><b>Maximum:<font color="red">*</font></b>	</td>
		<td><input type="text" name="maxvar" size="4" maxlength="4"></td>		
		</tr></table>
		</td>
	</tr>
	<tr>
		<td class="formfieldbold formfielddark"><b>Answer Type:</b>	</td>
		<td><select name="anstype">
			<option value="0"></option>
			<option value="1">byte</option>
			<option value="2">short</option>
			<option value="3">int</option>
			<option value="4">long</option>
			<option value="5">float</option>
			<option value="6">boolean</option>
			<option value="7">String</option>
			<option value="8">double</option>
		</select></td>
	</tr>
	
	<tr>
		<td class="formfieldbold formfielddark"><b>Privacy:<font color="red">*</font></b></td>
		<td><input type="RADIO" name="privacy2" value="private">Private <input type="RADIO" name="privacy2" value="public">Public</td>
	</tr>
	<tr>
		<td></td>
		<td></td>		
	</tr>

	</table>
</td>
</tr>
</table>
</form>

<br>
<h3>Modify Java Quiz:</h3>
<form name="JQuestionModify" method="post" action="jquestion_modify_save.jsp">
	 <table border="1">
	 <tr>	 
	 <td class="formfieldbold formfielddark"></td>
	 <td class="formfieldbold  formfielddark  " ><b>Title</b></td>	 
	 <td class="formfieldbold  formfielddark  " ><b>Description</b></td>
	 <td class="formfieldbold  formfielddark  " ><b>Privacy</b></td>
	 </tr>
<%
	   
	 out.write("<tr>");  	 
         ResultSet rs1 = null;      
         rs1 = statement.executeQuery("SELECT distinct q.QuestionID, q.Title, q.Description, q.Privacy,q.AuthorID from ent_jquestion q, ent_user u where q.AuthorID=u.id and (q.Privacy='1' or u.name='"+userBeanName+"') ");
	 int cnt=0;
         while(rs1.next())
	  {	  	  	 	 
		 out.write("<tr>"); 	 
		 cnt++;		 
		 		  
		 if (rs1.getString(4).equals("1")){
		 	if (rs1.getString(5).equals(uid)){
		 		out.write("<td><a href='jquestion_delete.jsp?QuestionID="+rs1.getString(1)+"'><img src=images/trash.jpg border=0></a></td>");
		 	}else {
		 		out.write("<td></td>");
		 	}
		 }else {
		 	out.write("<td><a href='jquestion_delete.jsp?QuestionID="+rs1.getString(1)+"'><img src=images/trash.jpg border=0></a></td>");
		 }
		 
		 out.write("<td><textarea cols=45 rows=1 name='Title"+cnt+"' value='"+rs1.getString(2)+"'>"+rs1.getString(2)+"</textarea></td>"); 		 	 		 		 		 
		 out.write("<td><textarea cols=70 rows=1 name='Description"+cnt+"' value="+rs1.getString(3)+">"+rs1.getString(3)+"</textarea></td>");		 
		 if (rs1.getString(4).equals("1")){	
		  	 if (rs1.getString(5).equals(uid)){
				out.write("<td><input type=radio name='privacy"+cnt+"' value=private>Private<input type=radio name='privacy"+cnt+"' value=public checked>Public</td>");			 			 		  	 	 	
			 }else{
			 	out.write("<td><input type=radio name='privacy"+cnt+"' value=private disabled>Private<input type=radio name='privacy"+cnt+"' value=public checked>Public</td>");			 			 
			 }
		 }else{		 	
		 	 out.write("<td><input type=radio name='privacy"+cnt+"' value=private checked>Private<input type=radio name='privacy"+cnt+"' value=public>Public</td>");
		 	
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
<br>


<script language="JavaScript">
<!-- 

function submitFunction(obj,i) {
   if (i==1) obj.action="jquiz_modify_retrieve.jsp?msg=0";
}
//-->
</script> 
</body> 
</html>