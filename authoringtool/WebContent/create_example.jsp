<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>
<%@ include file = "include/connectDB.jsp" %>

<script language="javascript">
<!--

function cOn(td){
if(document.getElementById||(document.all && !(document.getElementById))){
td.style.backgroundColor="#ffffe1";
}
}

function cOut(td){
if(document.getElementById||(document.all && !(document.getElementById))){
td.style.backgroundColor="#FFCC00";
}
}
//-->

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

<script src="<%=request.getContextPath()%>/js/jquery1.4.2.js"></script>

<script type="text/javascript">
$(document).ready(function(){
	$("input").click(function () {
		var fn = $(this).attr('fn');
        if (fn == 'create')
        {
        	var topic = document.getElementById("topic").value;

        	 var title = document.create_example.title.value;
    		 title = title.replace(/\s+/g, '');
    		 var rdfID = document.create_example.rdfID.value;
    		 rdfID = rdfID.replace(/\s+/g, '');
    		 var privacy = document.create_example.privacy;
    		 var selected = false;
    		 //var scopesel = document.getElementById("scope");
    		 //var scope = scopesel.options(scopesel.selectedIndex).value; 
    		 var code =  document.create_example.textarea1.value;
    		 var tempCode = code.replace(/\s+/g, '');
    		 for(var i = 0; i < privacy.length; i++) {
    			   if(privacy[i].checked == true) {
    				   selected = true;
    			   }
    			 }
    		 if (topic== "-1")
 			{
 			alert("Please select topic for the example."); return false;
 			}
    		 if (title == "")
    		 {
    			 alert("Title cannot be empty!");
    			 return false;
    		 }
    		 else if (rdfID == "")
    		 {
    			 alert("RDF ID cannot be empty!");
    			 return false;
    		 }
    		 else if (selected == false)
    		 {
    			 alert("Please select the privacy.");
    			 return false;
    		 }
    		 //else if (scope == '-1')
    		 //{
    		//	 alert("Please select the scope.");
    		//	 return false;
    		 //}
    		 else if (code == '' | tempCode =='' )
    		 {
    			 alert("Code cannot be empty!");
    			 return false;
    		 }
    		 else
    		 {
    			 var invalid = false;
        		 rdfID = document.create_example.rdfID.value;

    			 for (var index in rdfs)
    		     {
    				 if (rdfs[index] ==rdfID)
    					 invalid = true;
    			 }
    			 if (invalid)
    			 {
    				 alert("RDF ID already exists. Please enter another value.");
    				 return false;    				 
    			 }
    			 else
    			 {   				 
    				 //$.post("CompileCodeServlet",{code:code},function(data) {
    				    	// var err = data.message;

    				    	// if (err != '')
    				    	// {
    				    	//	alert("Code cannot be compiled due to following errors:\n"+err);   
    				    	//	return false;
    				    	// }
    				    	// else
    				    	// { 	
    				    		$("#eform").submit();
    				    	//	return true;
    				        // }
    				   // }, "json");    				    	 	   
    			 }
    		 }
        }		
	});	
});	


</script>
<%
stmt = conn.createStatement();
String command = "select rdfID from ent_dissection;";
ResultSet rs = stmt.executeQuery(command);
ArrayList<String> rdfList = new ArrayList<String>();
while (rs.next())
{
	rdfList.add(rs.getString(1));
}
%>
<script>
    var uname = "<%=userBeanName%>";
	var rdfs = new Array();
	<%for (String rdf : rdfList){%>
	     rdfs.push("<%=rdf%>");
	<%}%>
</script>
<%
String uid = "";
rs = stmt.executeQuery("SELECT id FROM ent_user where name = '"+userBeanName+"' ");
while(rs.next())
{
	 uid = rs.getString(1);
}
command = "select * from ent_scope s, rel_scope_privacy sp where sp.ScopeID = s.ScopeID and (sp.privacy = 1 or sp.Uid = "+uid+")";
result1 = stmt.executeQuery(command);

%>
<h3>Create example: </h3>


<FORM id = "eform" name = "create_example" METHOD="post" action ="createExampleComment.jsp">
            <table>
 	    
			<tr>
		<td class="formfieldbold formfielddark"><b>Topic:<font color="red">*</font></b>	</td>
		<td><select name="topic" id = "topic">
		<%
		  	out.write("<option value='-1' selected>Please select the topic</option>");

			 rs = stmt.executeQuery("SELECT q.QuestionID,q.Title,q.Privacy,q.authorid FROM ent_jquestion q where (q.Privacy = '1' or q.authorid = "+uid+") order by q.title");
			String imgHtml;
			 while(rs.next())
			  {
				 if (rs.getString(4).equals(uid))
		  				imgHtml = "style=\"background-color:#A9A9D5\" title = \"You are the owner of this quiz\"";
		  			else
		  				imgHtml = "";
			  		out.write("<option value='"+rs.getString(1)+"'"+imgHtml+">"+rs.getString(2)+"</option>");
			  }			
			
		%>			
		</select></td>
	</tr>
	              
            <tr>
            
            <td class="formfieldbold formfielddark"><b>Title:<font color="red">*</font>:</b></td>            
            <td><input type="text" name="title" maxlength="45"></td>
            </tr>
            <tr>
            <td class="formfieldbold formfielddark"><b>RDF ID:<font color="red">*</font>:</b></td>            
            <td><input type="text" name="rdfID"></td>
            </tr>
            <tr>
            <td class="formfieldbold formfielddark"><b>Description:</b></td>            
            <td><textarea  name="chapter" cols="70" rows="3"></textarea></td>
            </tr>
           <!-- 
              <tr>
              <td class="formfieldbold formfielddark"><b>Scope<font color="red">*</font>:</b></td>            
            
             
            <td><select name="Scope" id = "scope">
           
 <%
	//out.write("<option value = '-1' selected>Please select the scope</option>");				

	//while(result1.next()){	
	//	out.write("<option>"+result1.getString(1)+" "+result1.getString(3)+"</option>");				
	//}
            
%>                  
      
            </select>
            </td>           
            </tr> 
            -->  
             <tr>
				    	<td class="formfieldbold formfielddark"><b>Privacy<font color="red">*</font>:</b></td>
				    	<td class="formfieldlight"><input type="radio" name="privacy" value="Private">Private<input type="radio" name="privacy" value="Public">Public</td>
				    </tr>	         

                      
            <tr>
            <td class="formfieldbold formfielddark"><b>Code<font color="red">*</font>:</b></td>            
            <td><TEXTAREA NAME="textarea1"  id = "code" cols="75" ROWS="15"></TEXTAREA>
            <br>
            <input Type= "button" VALUE="Create" fn='create'>
            <input TYPE="reset" VALUE="Clear" OnClick="document.form.message.focus()"></td>
            </tr>
            </table>
</FORM>



</body> 
</html>