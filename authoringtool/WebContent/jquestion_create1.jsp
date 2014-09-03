<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>
<%@ include file = "include/connectDB.jsp" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>

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
<script type="text/javascript">
<!-- 
function function1(obj,i){	
	var title1 = document.fr1.title1.value;	
	if(title1 == ""){alert("Title is missing!");}	
	else if (!document.fr1.privacy1[0].checked && !document.fr1.privacy1[1].checked){alert("please select Privacy!");}	
	else {   		
		if (title1!="" && (document.fr1.privacy1[0].checked || document.fr1.privacy1[1].checked) && i==1) {obj.action="javaq_create_save1.jsp";}
      	}
	
}

function function2(obj,i){	
	var title2 = document.fr1.title2.value;	
	var quizcode = document.fr1.quizcode.value;	
	var minvar = document.fr1.minvar.value;	
	var maxvar = document.fr1.maxvar.value;		
	if(title2 == ""){alert("Title is missing!");}
	else if(quizcode == ""){alert("Quizcode is missing!");}
	else if(minvar == ""){alert("Minimum Variable is missing!");}
	else if(maxvar == ""){alert("Maximum Variable is missing!");}
	else if (!document.fr1.privacy2[0].checked && !document.fr1.privacy2[1].checked){alert("please select Privacy!");}
	else {
		if (title2!="" && quizcode!="" && minvar!="" && maxvar!="" && (document.fr1.privacy2[0].checked || document.fr1.privacy2[1].checked) && i==2) {obj.action="javaq_create_save2.jsp";}
	}
}   

	
function function3(obj,i){ 	
   if (i==1) 
   {window.open('classcombo.jsp','_blank');}
   }
   
function function4(obj,i){ 
	if(i!=0){	
	   var sessionL = document.fr1.sessionL.value; 	   
	   for(a=1;a<=sessionL;a++){
		  		   						
		   	obj.action="jquestion_create1_delete.jsp?sessionID="+i;   	
		   
	   }
	}
}   
//-->
</script>

<h2>QuizJET Authoring</h2>
<form name="fr1" method="post">
<table border="1">
<tr><td valign="top">
	<h3>Create Java Quiz:</h3>
    </td>
    <td>	
	<table>
	<tr>
		<td class="formfieldbold formfielddark"><b>Title:<font color="red">*</font></b></td>
		<td><input type="text" name="title1" size="45" maxlength="45"></td>
	</tr>
	<tr>
		<td class="formfieldbold formfielddark"><b>Description:</b>	</td>
		<td><input type="text" name="description1" size="70" maxlength="255"></td>
	</tr>
	<tr>
		<td class="formfieldbold formfielddark"><B>Privacy:<font color="red">*</font></b></td>
		<td><input type="RADIO" name="privacy1" value="private">Private <input type="RADIO" name="privacy1" value="public">Public</td>
	</tr>
	<tr>
		<td></td>
		<td><input type="submit" value="Submit" onclick="function1(this.form,1);" >&nbsp;&nbsp;<input type="reset" value="Clear" OnClick="document.form.message.focus()"></td>
	</tr>
	<tr>
		<td></td>
		<td><b><font color="blue" size="3">
		 </font></b></td>
	</tr>	
	</table>	
    </td>
    
<tr>
<tr>
   <td>
	<h3>Create Java Question:</h3>
   </td>
   <td>	
	<table>
	<tr>
		<td class="formfieldbold formfielddark"><b>Quiz:<font color="red">*</font></b>	</td>
		<td><select name="question">
		<%
			 Connection connection = null;
		Class.forName(this.getServletContext().getInitParameter("db.driver"));
        connection = DriverManager.getConnection(this.getServletContext().getInitParameter("db.webexURL"),this.getServletContext().getInitParameter("db.user"),this.getServletContext().getInitParameter("db.passwd"));
          Statement statement = connection.createStatement();
			 ResultSet rs = null;  
			 rs = statement.executeQuery("SELECT q.QuestionID,q.Title,q.Privacy FROM ent_jquestion q, ent_user u where (q.Privacy = '1' or u.name='"+userBeanName+"') and q.AuthorID=u.id ");
			 while(rs.next())
			  {
			  	if(rs.getString(3).equals("1")){
			  		out.write("<option value='"+rs.getString(1)+"'>"+rs.getString(2)+"</option>");
			  	}else{
			  	        out.write("<option value='"+rs.getString(1)+"' style=background-color:#A9A9D5>"+rs.getString(2)+"</option>");			  	        
			  	}
			  }			
			
		%>			
		</select></td>
	</tr>	
	<tr>
		<td class="formfieldbold formfielddark"><b>Title:<font color="red">*</font></b>	</td>
		<td><input type="text" name="title2" size="45" maxlength="45"></td>
	</tr>
	<tr>
		<td class="formfieldbold formfielddark"><b>rdf ID:<font color="red">*</font></b>	</td>
		<td><input type="text" name="rdfID" size="45" maxlength="45"></td>
	</tr>	
	<tr>
		<td class="formfieldbold formfielddark"><b>Description:	</b></td>
		<td><input type="text" name="description2" size="70" maxlength="255"></td>
	</tr>
	<tr>
		<td class="formfieldbold formfielddark"><b>Question Type:	</b></td>
		<td><select name="questiontype" onChange="Javascript:type_change();">
			<option value="1">final value</option>
			<option value="2">output</option>
			<option value="3">which line is wrong</option>
			<option value="4">fill in the blank</option>
			<option value="5">dynamic import</option>			
		    </select>
		    <input type="submit" value="Import Classes" onclick="function3(this.form,1);"><br>
		    <%
		    int sessionL=0;
		    List messages = (List) session.getAttribute("messages");
		        if (messages != null) {		            
		            for (java.util.Iterator i = messages.iterator(); i.hasNext();) {
		                HashMap ClassMap = (HashMap) i.next();
		                sessionL++;
		                  if (ClassMap.get("ClassID"+sessionL+"")!=null){		                  
		                %>
				    <font color="red">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				    <a href="http://adapt2.sis.pitt.edu/quizjet/class/<%=ClassMap.get("ClassName"+sessionL+"")%>" target="_blank"><%= ClassMap.get("ClassName"+sessionL+"") %></a> <input type="submit" onclick="function4(this.form,<%=sessionL%>);" value="delete"></font><br>
		   		 <%		   		 
		   		 }   		
		    	    }		    	    
		    }		    		   
		    //out.write("<input type=hidden name=sessionL value="+sessionL+">");
		    %>		    
		</td>
	</tr>	
	<tr>
		<td class="formfieldbold formfielddark"><b>Code:<font color="red">*</font></b>	</td>
		<td><textarea cols="80" rows="10" name="quizcode"></textarea></td>
	</tr>
	<tr>
		<td class="formfieldbold formfielddark"><b>Minimum:<font color="red">*</font></b></td>
		<td><input type="text" name="minvar" size="4" maxlength="4"></td>
	</tr>
	<tr>
		<td class="formfieldbold formfielddark"><b>Maximum:<font color="red">*</font></b>	</td>
		<td><input type="text" name="maxvar" size="4" maxlength="4"></td>
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
		<td><input type="submit" value="Submit" onclick="function2(this.form,2);">&nbsp;&nbsp;<input type="reset" value="Clear" OnClick="document.form.message.focus()"></td>		
	</tr>

	</table>

   </td>

</tr>
</table>   
</form>

