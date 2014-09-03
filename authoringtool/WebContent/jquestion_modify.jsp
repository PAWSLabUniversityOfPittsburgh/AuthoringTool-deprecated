<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>
<%@ page import="java.sql.*" %>
<%@ include file = "include/connectDB.jsp" %>


<script src="<%=request.getContextPath()%>/js/jquery1.4.2.js"></script>

<script type="text/javascript">
$(document).ready(function(){
	$("img").click(function () {
		var fn = $(this).attr('fn');
		if (fn == 'select')
		{
			var qname = $(this).Attr("qname");
			$("#myForm").attr("action", "ModifyQuestion.jsp?qname="+qname);
			$("#myForm").submit();
		}
});
});
</script>

<script language="JavaScript">
<!-- 

function submitFunction(obj,i) {
   if (i==1) obj.action="jquiz_modify_retrieve.jsp?msg=0";
   if (i==2) {
	var sel = document.getElementById('question');
	var  quizval= sel.options[sel.selectedIndex].value;
    var title2 = document.myForm.title2.value;	

	var quizcode = document.myForm.quizcode.value;

	var minvar = document.myForm.minvar.value;	
	var maxvar = document.myForm.maxvar.value;	
	
	
     if (quizval== "-1")
		{
		alert("Topic is missing!");
		}

	if(title2 == ""){alert("Title is missing!");}
	else if(quizcode == ""){alert("Code is missing!");}
	else if(minvar == ""){alert("Minimum Variable is missing!");}
	else if (isNaN(minvar))
	alert("Minimum Variable should be number!");	
	else if(maxvar == ""){alert("Maximum Variable is missing!");}
	else if (isNaN(maxvar))
		alert("Maximum Variable should be number!");
	else if (!document.myForm.privacy2[0].checked && !document.myForm.privacy2[1].checked){alert("Please select Privacy!");}
	else {
		obj.action="jquiz_modify_save.jsp";
	}    
   }

	obj.submit();
}
//-->
</script>
<script type="text/javascript">


function changeTopic()
{
	var sel = document.getElementById('topic');
	var  topic= sel.options[sel.selectedIndex].value;
	if (topic == -1)
		document.location = "jquestion_modify.jsp";
	else
		document.location = "jquestion_modify.jsp?QuestionID="+topic;
}
function changeQuestion()
{
	var sel = document.getElementById('topic');
	var  topic= sel.options[sel.selectedIndex].value;
	if (topic == -1)
		document.location = "jquestion_modify.jsp";
	var sel = document.getElementById('qid');
	var  qid= sel.options[sel.selectedIndex].value;
	if (qid == -1)
		document.location = "jquestion_modify.jsp?QuestionID="+topic;
	else
		document.location = "jquestion_modify.jsp?QuestionID="+topic+"&qid="+qid;
}
</script>



<%
ResultSet results = null;
Statement statement  = null;
Statement stmts = null;
ResultSetMetaData rsmds = null;   	
String uid="";
ResultSet rs = null;  
try {

    stmts = conn.createStatement();
    rs = stmts.executeQuery("SELECT id FROM ent_user where name = '"+userBeanName+"' ");
	  while(rs.next())
	  {
	  	uid=rs.getString(1);  	
	  }
 }
 catch (SQLException e) {
     System.out.println("Error occurred " + e);
  } 

String questionID = request.getParameter("QuestionID");
String qid = request.getParameter("qid");
String disabled = "";
	 if (questionID == null)
		disabled = "disabled";
%>


<h3>Please select the topic and question that you'd like to modify:</h3>
<FORM Name="myForm" Action="ModifyQuestion.jsp" method = "post">

	<table style = "width :100%">
<%

      try{
	 
     statement = conn.createStatement();
	 ResultSet rs1 = null;  
	 rs1 = statement.executeQuery("SELECT q.QuestionID,q.AuthorID,q.Privacy,q.Title,q.Description FROM ent_jquestion q, ent_user u where (q.Privacy = '1' or u.name='"+userBeanName+"') and q.AuthorID=u.id order by q.Title ");			
	 String topicSelected = "";
	 
	 
	 out.write("<tr>");
	 out.write("<td class = 'formfielddark' width = '15%'>");
	 out.write("Topic:  ");
	 out.write("</td>");
	 out.write("<td>");
	 out.write("<select id = 'topic' name = 'topic' onchange = changeTopic();>");
	 out.write("<option value = '-1' selected>Please select the topic</option>");
	 while(rs1.next())	 
	  {
		 if (rs1.getString(1).equals(questionID))
			 topicSelected = "selected";
		 else
			 topicSelected = "";

	  		if(rs1.getString(3).equals("0")){
		  		%>
		  		<option class = 'private' name="QuestionID" value="<%=rs1.getString(1)%>" title = 'This topic is private' <%=topicSelected %>><%=rs1.getString(4)%></option>
		  		<%						  		
		  	}else{
		  		%>
		  		<option name="QuestionID" value="<%=rs1.getString(1)%>" <%=topicSelected %>><%=rs1.getString(4)%></option>
		  		<%
		  			  	
		  	
		  	}  		
	  } 
		out.write("</td>");
   		out.write("</tr>");

   	 out.write("<tr>");
	 out.write("<td class = 'formfielddark' width = '15%'>");
	 out.write("Question:  ");
	 out.write("</td>");
	 out.write("<td>");
	 out.write("<select id = 'qid' name = 'qid' onchange = changeQuestion(); "+disabled+">");
	 out.write("<option value = '-1' selected>Please select the question</option>");
	 String questionSelected = "";
	 String query = "SELECT q.QuizID,q.title,q.Description,q.AuthorID,q.Privacy FROM ent_jquiz q, rel_question_quiz qq where qq.QuizID=q.QuizID and qq.QuestionID = "+questionID+" and (q.privacy = 1 or q.authorid = "+uid+") order by q.title";
	 rs1 = statement.executeQuery(query);
	 while(rs1.next())	 
	  {
		 if (rs1.getString(1).equals(qid))
			 questionSelected = "selected";
		 else
			 questionSelected = "";
	  		if(rs1.getString(3).equals("0")){
		  		%>
		  		<option class = 'private' name="quizID" value="<%=rs1.getString(1)%>" title = 'This question is private' <%=questionSelected %>><%=rs1.getString(4)%></option>
		  		<%						  		
		  	}else{
		  		%>
		  		<option name="quizID" value="<%=rs1.getString(1)%>" <%=questionSelected %>><%=rs1.getString(2)%></option>
		  		<%
		  			  	
		  	
		  	}  		
	  } 
		out.write("</td>");
   		out.write("</tr>");       
   
        if (questionID == null | qid == null)
        	return;
%>
<table style="width: 100%;" border="1"  >
	<tr>
	<td >
		<table>
		<tr>
			<td class="formfieldbold formfielddark"><b>Topic:<font color="red">*</font></b>	</td>
			<td><select name="question" id = "question">
			<%
				 ResultSet rs2 = null;  
				 rs2 = statement.executeQuery("SELECT q.QuestionID,q.Title,q.Privacy FROM ent_jquestion q, ent_user u where (q.Privacy = '1' or u.name='"+userBeanName+"') and q.AuthorID=u.id ");
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
				  	           out.write("<option value='"+rs2.getString(1)+"'  selected>"+rs2.getString(2)+"</option>");			  	        			  	      
				  	        }else{
				  	           out.write("<option value='"+rs2.getString(1)+"' >"+rs2.getString(2)+"</option>");			  	        			  	      
				  	        }
				  	}
				  }				
			%>			
			</select></td>
		</tr>	
		
		<%
				 ResultSet rs4 = null;  
				 rs4 = statement.executeQuery("SELECT distinct * FROM ent_jquiz q where q.QuizID='"+qid+"' and (q.authorid = "+uid+" or q.privacy = 1) ");
				 while(rs4.next())	
				 {
		%>
		<tr>
			<td class="formfieldbold formfielddark"><b>Title:<font color="red">*</font></b>	</td>
			<td><input type="text" name="title2" size="45" maxlength="45" value="<%=rs4.getString(4)%>"></td>
		</tr>
		<tr>
			<td class="formfieldbold formfielddark"><b>rdfID:<font color="red">*</font></b>	</td>
			<td><input type="text" name="rdfID" size="45" maxlength="45" value="<%=rs4.getString(11)%>">
			<input type="hidden" name="rdfID" value="<%=rs4.getString(11)%>">
			</td>			
		</tr>	
		<tr>
			<td class="formfieldbold formfielddark"><b>Description:	</b></td>
			<td><textarea style="width: 100%" rows = 3  name="description2" cols="80" ><%=rs4.getString(5)%></textarea></td>
		</tr>
		<tr>
			<td class="formfieldbold formfielddark"><b>AssessmentType:<font color="red">*</font></b></td>
			<td><select name="questiontype">
				<%
				String Qtype[] = new String[3];			
				Qtype[0]="";
				Qtype[1]="final value";
				Qtype[2]="output";					
				for (int a=0;a<Qtype.length;a++){
                    if (a == 0)
                        continue;					
					if (rs4.getInt("QuesType") == a){
						%><option value=<%=a%> selected><%=Qtype[a]%></option><%
					}
					else{
						%><option value=<%=a%>><%=Qtype[a]%></option><%
					}		
				}					
				%>
			</select></td>
		</tr>	
		<tr>
			<%InputStream is =rs4.getBinaryStream(6);
	 		BufferedReader inpStream = new BufferedReader (new InputStreamReader (is));
	 		String streamcode = inpStream.readLine();
	   		String code = "";
			   while(streamcode != null) {		
			    code += streamcode + "\n";		
			    streamcode = inpStream.readLine();		
			   }		
			%>		
			<td class="formfieldbold formfielddark"><b>Code:<font color="red">*</font></b>	</td>
			<td><pre><textarea cols="80" rows="8" name="quizcode" value="<%=code%>"><%out.print(code);%></textarea></pre></td>
		</tr>
		<tr>
			<td class="formfieldbold formfielddark"><b>Minimum:<font color="red">*</font></b></td>
			<td><input type="text" name="minvar" size="4" maxlength="4" value="<%=rs4.getString(7)%>"></td>
			
		</tr>	
			<tr>
			<td class="formfieldbold formfielddark"><b>Maximum:<font color="red">*</font></b>	</td>
			<td><input type="text" name="maxvar" size="4" maxlength="4" value="<%=rs4.getString(8)%>"></td>		
</tr>
		<tr>
			<td class="formfieldbold formfielddark"><b>Answer Type:</b>	</td>
			<td><select name="anstype">			
				<%
				String type[] = new String[9];			
				type[0]="";
				type[1] = "";
				type[2] = "";
				type[3] = "int";
				type[4]="";
				type[5]="float";
				type[6]="";
				type[7]="String";
				type[8]="double";
				for (int a=0;a<type.length;a++){
                    if (a < 3 | a==4 | a==6)
					    continue;
     				if (rs4.getInt("AnsType") == a){
						%><option value=<%=a%> selected><%=type[a]%></option><%
					}
					else{
						%><option value=<%=a%>><%=type[a]%></option><%
					}
				}
				%>
			</select></td>
		</tr>
		
		<tr>
			<td class="formfieldbold formfielddark"><b>Privacy:<font color="red">*</font></b></td>
			<td class="formfieldlight">
			<% 
			if(rs4.getString(10).equals("0")){
			%>
				<input type="RADIO" name="privacy2" value="0" checked>Private <input type="RADIO" name="privacy2" value="1">Public
			<%
			}else{
			%>
				<input type="RADIO" name="privacy2" value="0">Private <input type="RADIO" name="privacy2" value="1" checked>Public
			<%			
			}
			%>
			</td>
		</tr>
		<tr>
			<td></td>
			<td><input type="button" value="Save" onclick="submitFunction(this.form,2);">&nbsp;&nbsp;
			<!-- 
			<input type="button" value="Delete this Question" OnClick="if (confirm('you sure you want to delete this question?')==false){return false;} window.location.href='jquiz_delete.jsp?QuestionID=<%=request.getParameter("QuestionID")%>&QuizID=<%=request.getParameter("qid")%>';"></td>		
	
			 -->	</tr>
			<%}%>
		</table>
	</td>
	<!--  	
	<td>
	
		
		<select multiple name="fromBox" id="fromBox">
		<%
		ResultSet rs5 = null;  
		//rs5 = statement.executeQuery("SELECT distinct c.ClassID,c.ClassName FROM rel_quiz_class q, ent_class c where q.ClassID=c.ClassID  ");		
		rs5 = statement.executeQuery("SELECT distinct c.ClassName, c.ClassID FROM rel_quiz_class q, ent_class c where q.ClassID=c.ClassID and c.ClassName not in (SELECT c.ClassName FROM rel_quiz_class q, ent_class c where q.ClassID=c.ClassID and q.QuizID='"+request.getParameter("qid")+"') ");
		while(rs5.next())	
		{		
		%>
			<option value ="<%=rs5.getInt("ClassID")%>"><%=rs5.getString("ClassName")%></option>
		<%
		}
		%>	
		</select>
		
		<select name="toBox" id="toBox">
		<%
		ResultSet rs6 = null;  		
		rs6 = statement.executeQuery("SELECT distinct * FROM rel_quiz_class q,ent_class c where q.ClassID=c.ClassID and q.QuizID='"+request.getParameter("qid")+"' ");		  
		while(rs6.next())	
		{		
		%>
			<option value ="<%=rs6.getInt("ClassID")%>"><%=rs6.getString("ClassName")%></option>
		<%
		}
		
		%>
		</select>

		<script type="text/javascript">
		createMovableOptions("fromBox","toBox",400,200,'all classes','imported classes');
		</script>
	
		
	
	
	</td>
-->
	</tr>
	</table>
	
	</table>


<%
      }
catch(Exception e)
{
	e.printStackTrace();
}
finally {
    try {
      if (stmts != null)
       stmts.close();
      }  catch (SQLException e) {}

    }
%>
 


				<input type="hidden" name = "quiz" value="<%=request.getParameter("qid")%>" >

  </Form>



</body> 
</html>