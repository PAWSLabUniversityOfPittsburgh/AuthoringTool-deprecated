<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>
<%@ include file = "include/connectDB.jsp" %>
<%@ page import="java.sql.*" %>

<script src="<%=request.getContextPath()%>/js/jquery1.4.2.js"></script>

<script type="text/javascript">
$(document).ready(function(){
	$("img").click(function () {
		var fn = $(this).attr('fn');
		if (fn == 'clone')
		{
			var disID = $(this).attr('disID');
		    $.post("CloneExampleServlet?dis="+disID+"&uid="+uid+"&sc="+sc,function(data) {
		    	var newdis = data.dis;
				alert("Example cloned successfully!");window.location = "displayA1.jsp?sc="+sc+"&uid="+uid+"&dis="+newdis; }, "json");	  
		}
		else if (fn == 'delete')
		{
			var disID = $(this).attr('disID');
			if (confirm('Are you sure you want to delete this example?')==true)
			{
				$.post("DeleteExampleServlet?disID="+disID,function() {
					alert("Example deleted successfully!");window.location = "mine.jsp" });	 
			}			
		}
		else if (fn == 'addline')
		{
			var dis = $(this).attr('disID');
			var lno = $(this).attr('lno');
			var max = $(this).attr('max');
			$("body").addClass("loading");
			$('.modal').fadeIn(1);
			$.post("AddExampleLineServlet?dis="+dis+"&lno="+lno+"&max="+max,function() {
				$("body").removeClass("loading");
				$('.modal').fadeOut(1);
				alert("Line added successfully!");window.location.reload(true); });	 
		}
		else if (fn == 'deleteline')
		{
			if (confirm('Are you sure you want to delete this line?')==true)
			{
				$("body").addClass("loading");
				$('.modal').fadeIn(1);
				var dis = $(this).attr('disID');
				var lno = $(this).attr('lno');
				var max = $(this).attr('max');
				$.post("DeleteExampleLineServlet?dis="+dis+"&lno="+lno+"&max="+max,function() {
					$("body").removeClass("loading");
					$('.modal').fadeOut(1);
					alert("Line deleted successfully!");window.location.reload(true); });	 

			}
			
		}
	});	
	
	$("input").click(function () {
		var fn =  $(this).attr("fn");
		if (fn == 'save')
		{
			var title =  $("#Name").val();
			var rdfID = $("#rdfID").val();
			var scope = $('#sel').val();
			title = title.replace(/\s+/g, '');
			rdfID = rdfID.replace(/\s+/g, '');
			if (title == '')
			{
				alert("Title cannot be empty!");
				return false;
			}
			if (rdfID == '')
		    {
				alert("RDF ID cannot be empty!");
	    		return false;
			}
			if (scope == '-1')
			{
				alert("Please select the scope!");
	    		return false;	
			}
			else
			{
				var invalid = false;
				rdfID = $("#rdfID").val();
				var curVal = $("#rdfID").attr("curVal");
				for (var index in rdfs)
				{
					if (rdfs[index] ==rdfID)
					{		
					  if (rdfID != curVal)
						  invalid = true;
					}
				}
				if (invalid)
				{
					alert("RDF ID already exists. Please enter another value.");
					return false;
				}
				else
    			{   				 
    				var min = $("#min").val();
					var max = $("#max").val();
					var code = "";
					for (var i = min; i <= max; i++)
    			    {
						code+= $("#code"+i).val();
						if (i < max)
							code += "\n";
    		     	}
					//$.post("CompileCodeServlet",{code: code},function(data) {
    				 //   	 var err = data.message;

    				  //  	 if (err != '')
    				  // 	 {
    				   // 		alert("Code cannot be compiled due to following errors:\n"+err);   
    				   // 		return false;
    				   // 	 }
    				  //  	 else
    				  //  	 { 	
    				    		$("#eform").submit();
    				    		return true;
    				     //    }
    				//    }, "json");    				    	 	   
    			 }
			}
		}				
	});	
	
});	

</script>

<script language="javascript">
<!--

function changeScope()
{
	var sel = document.getElementById('scope');
	var  scope= sel.options[sel.selectedIndex].value;
	if (scope == -1)
		document.location = "displayA1.jsp";
	else
		document.location = "displayA1.jsp?sc="+scope;
}

function changeExample()
{
	var sel = document.getElementById('example');
	var  dis= sel.options[sel.selectedIndex].value;
	var sel2 = document.getElementById('scope');
	var  scope= sel2.options[sel2.selectedIndex].value;
	if (scope == -1)
		document.location = "displayA1.jsp";
	else
		document.location = "displayA1.jsp?sc="+scope+"&dis="+dis;
}

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
function changelist() {
	var sel = document.getElementById("exampleList");
	var example = sel.options[sel.selectedIndex].value;
	if (example == '-1')
		return;
	document.location = "displayA1.jsp?sc="+sc+"&uid="+uid+"&dis="+example;
} 
	   
function textCounter(field,cntfield,maxlimit) {
	if (field.value.length > maxlimit) // if too long...trim it!

	{field.value = field.value.substring(0, maxlimit);}
	// otherwise, update 'characters left' counter
	else
		{cntfield.value = maxlimit - field.value.length;}
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

//TODO
String scope = request.getParameter("sc");
String dis=request.getParameter("dis");
String authorID = "";
String disabled = "";
String readonly = "";
stmt = conn.createStatement();
String command = "select rdfID from ent_dissection;";
rs = stmt.executeQuery(command);
ArrayList<String> rdfList = new ArrayList<String>();
while (rs.next())
{
	rdfList.add(rs.getString(1));
}
%>

<script>
	var sc = "<%=scope%>";
	var uid = "<%=uid%>";
	var rdfs = new Array();
	<%for (String rdf : rdfList){%>
	     rdfs.push("<%=rdf%>");
	<%}%>
</script>
<%
   
    try {
        stmt = conn.createStatement();
        result = stmt.executeQuery("SELECT d.DissectionID,d.Name,d.Description,dp.Uid FROM ent_dissection d,rel_scope_dissection r, rel_dissection_privacy dp where r.ScopeID = '"+request.getParameter("sc")+"' and d.DissectionID=r.DissectionID and dp.DissectionID=d.DissectionID order by d.name");
     }
     catch (SQLException e) {
         System.out.println("Error occurred " + e);
      }
      
     columns=0;     
     try {
       rsmd = result.getMetaData();       
       columns = rsmd.getColumnCount();       
     }
     catch (SQLException e) {
        System.out.println("Error occurred " + e);
     }

    
%>


<h3>
Please select the scope and example that you'd like to modify.</h3>

<table>

<tr>
<td class = 'formfielddark' width = '15%'>
Scope: </td><td>
<select onchange = changeScope(); name = 'scope' id = 'scope'>

<%
      try{  	  

     statement = conn.createStatement();
	 ResultSet rs1 = null;  
	 rs1 = statement.executeQuery(" select distinct s.scopeID,s.Name,sp.privacy from ent_scope s,rel_scope_privacy sp where sp.scopeID = s.scopeID and"+
			                      " (sp.privacy = 1 or sp.uid = "+ uid+") order by s.Name");
	 
	 out.write("<option value = '-1' selected>Please select the scope</option>");
	 String scopeSelected = "";

	 while(rs1.next())	 
	  {
		 if (rs1.getString(1).equals(scope))
			 scopeSelected = "selected";
		 else
			 scopeSelected = "";
	  		if(rs1.getString(3).equals("0")){
		  		out.write("<option class = 'private' bgcolor='#FCF4BD' title = 'This scope is private' value = '"+rs1.getString(1)+"' "+scopeSelected+">"+rs1.getString(2)+"</option>");
		  	}else{
		  		out.write("<option value = '"+rs1.getString(1)+"' "+scopeSelected+">"+rs1.getString(2)+"</option>");

		  		%>
		  		<%		  	
		  	}	   		
	  } }
	 catch(Exception e){e.printStackTrace();}
	 finally {
	     try {
	       if (stmts != null)
	        stmts.close();
	       }  catch (SQLException e) {}

	     }
            
%>
</select>
</td>
</tr>

<tr>
<td class = 'formfielddark' width = '15%'>
Example: </td><td>
<% String disabledMenu = "";
if (scope == null)
	disabledMenu = "disabled"; %>
<select onchange = changeExample(); name = 'example' id = 'example' <%=disabledMenu %>>

<%
     
try{  	  

     statement = conn.createStatement();
	 ResultSet rs1 = null;
//	 String query = "select distinct d.dissectionID,d.name,dp.privacy from ent_dissection d,rel_dissection_privacy dp, rel_scope_dissection sd, ent_scope s where s.scopeID = "+scope 
//             +"  and sd.scopeID = s.scopeID and d.dissectionID = sd.dissectionID and dp.dissectionID = d.dissectionID and (dp.privacy = 1 or d.author = "+uid+")  order by d.name";
	 String query = "select distinct d.dissectionID,d.name,d.description from ent_dissection d,rel_scope_dissection sd, ent_scope s, rel_dissection_privacy dp where s.scopeID = "+scope 
             +"  and sd.scopeID = s.scopeID and d.dissectionID = sd.dissectionID and dp.dissectionid = d.dissectionid and (dp.uid = "+uid+" or dp.privacy = 1)  order by d.name";

	 rs1 = statement.executeQuery(query);
	 out.write("<option value = '-1' selected>Please select the example</option>");
	 String exampleSelected = "";

	 while(rs1.next())	 
	  {
		 if (rs1.getString(1).equals(dis))
			 exampleSelected = "selected";
		 else
			 exampleSelected = "";
		 //TODO should be added when query consideres privacy
	  		//if(rs1.getString(3).equals("0")){
		  	//	out.write("<option class = 'private' bgcolor='#FCF4BD' title = 'This example is private' value = '"+rs1.getString(1)+"' "+exampleSelected+">"+rs1.getString(2)+"</option>");
		  	//}else{
		  		out.write("<option value = '"+rs1.getString(1)+"' "+exampleSelected+">"+rs1.getString(2)+"</option>");

		  		%>
		  		<%		  	
		  	//}	   		
	  } }
	 catch(Exception e){e.printStackTrace();}
	 finally {
	     try {
	       if (stmts != null)
	        stmts.close();
	       }  catch (SQLException e) {}

	     }
            
%>
</select>
</td>
</tr>
	</table>
<% if (dis == null )
      return;
   if (dis.equals("-1"))
	   return;
String Name = null;
String Des = null;
String rdfID= null;
int privacy = -1;
%>
<form name = "eform" id = "eform" method="post" action = "save.jsp?sc=<%=scope %>&dis=<%=dis%>">
<table id="myTable" style="width: 100%">

<tr>
<td>
<table style="width: 100%">
	
	<tr>		 
	<td class="formfieldbold formfielddark"><b>Topic:<font color="red">*</font></b>	</td>			
	<td class="formfieldbold formfielddark"><b>Title</b></td>
	<td class="formfieldbold formfielddark" width=20%><b>RDF ID</b></td>
	<td class="formfieldbold formfielddark"><b>Description</b></td>
	<td class="formfieldbold formfielddark" width=15%><b>Privacy</b></td>
	</tr>
	
	<tr>
			<%    
  rs = statement.executeQuery("Select distinct e.Name,e.Description,e.rdfID,dp.privacy,dp.Uid from ent_dissection e, rel_dissection_privacy dp where e.DissectionID = '"+dis+"' and dp.DissectionID = e.DissectionID ");
while (rs.next()){
	Name = rs.getString(1);
	Des = (rs.getString(2)==null?"":rs.getString(2));
	rdfID = rs.getString(3);
	privacy  = rs.getInt(4);
	authorID = rs.getString(5);
}
int topicid = -1;
rs = statement.executeQuery("select topicid from webex21.rel_topic_dissection where dissectionid ='"+dis+"'");
while (rs.next()){
	topicid = rs.getInt(1);
}
    
   // if (privacy == 1)
   // {
    //	if (uid.equals(authorID))
    //	{    		
    		//out.write("<td><img src='images/trash.jpg'  title = 'Delete example' fn = 'delete' disID='"+dis+"'></td>");
    //	}
    //	else
    //	{
    		//disabled = "disabled";
    		//readonly = "readonly";
    		//out.write("<td><img src='images/clone.png' title = 'Clone example' fn = 'clone' disID='"+dis+"'></td>");
    //	}
   // }
  //  else
  //  {
		//out.write("<td><img src='images/trash.jpg' title = 'Delete example' fn = 'delete' disID='"+dis+"'></td>");
  //  }    	
	%>
	<td><select name="topic" id = "topic">
			<%
				 ResultSet rs2 = null;  
				 rs2 = statement.executeQuery("SELECT q.QuestionID,q.Title,q.Privacy FROM ent_jquestion q, ent_user u where (q.Privacy = '1' or u.name='"+userBeanName+"') and q.AuthorID=u.id ");
		  		 out.write("<option value='-1' selected>Please select the topic</option>");			  	        			  		

				 while(rs2.next())
				  {			  			  				  
				  		if(rs2.getInt(1)==topicid){ 		
				  		   out.write("<option value='"+rs2.getString(1)+"' selected>"+rs2.getString(2)+"</option>");			  	        			  		
				  		}else{
				  		  out.write("<option value='"+rs2.getString(1)+"'>"+rs2.getString(2)+"</option>");			  	        			  		
				  		}
				  	
				  }				
			%>			
			</select></td>	
    <td><textarea style='width: 100%;' rows='2'  id = 'Name' name='Name' value='<%=Name%>' <%=readonly%>><%=Name%></textarea></td>
    <td><textarea style='width: 100%;' rows='2' curVal = '<%=rdfID%>'  name='rdfID' id='rdfID' value='<%=rdfID%>' <%=readonly%>><%=rdfID%></textarea></td>
    <td><textarea style='width: 100%;' rows='2' name='Des' value='<%=Des%>' <%=readonly%>><%=Des%></textarea></td>
    <%
   // command = "select * from ent_scope s, rel_scope_privacy sp where sp.ScopeID = s.ScopeID and (sp.privacy = 1 or sp.Uid = "+uid+")";
   // ResultSet scrs = statement.executeQuery(command);
	//if (readonly.equals("readonly"))
	//	out.write("<option value = '-1' selected disabled = 'disabled' disabled>Please select the scope</option>");	
	//else
	//	out.write("<option value = '-1' selected>Please select the scope</option>");	

	//while(scrs.next()){	
//		if (scrs.getString(1).equals(scope))
//			 out.write("<option value = '"+scrs.getString(1)+"' selected>"+scrs.getString(3)+"</option>");	
//		else 
	//		if (readonly.equals("readonly"))
//				out.write("<option value = '"+scrs.getString(1)+"' disabled = 'disabled' disabled>"+scrs.getString(3)+"</option>");	
//			else
	//			out.write("<option value = '"+scrs.getString(1)+"'>"+scrs.getString(3)+"</option>");	
//	}
      
    %>
    
    
    
	<td class = 'formfieldlight'>
	
<%
 
  ResultSet rs1=null;
  rs1 = statement.executeQuery("Select Privacy from rel_dissection_privacy where DissectionID = '"+dis+"' ");
  while (rs1.next()){
	if (rs1.getString(1).equals("1")){
		out.write("<input type=radio name=privacy value=Private "+disabled+">Private<input type=radio name=privacy value=Public checked>Public</td>" );	
	}else{
		out.write("<input type=radio name=privacy value=Private checked>Private<input type=radio name=privacy value=Public "+disabled+">Public</td> ");	
	}
  }  
%>
			
	</td>	
</tr>		
</table>
</td>
</tr>
       
<tr>
<td>

<table style="width: 100%">
<tr>
<td class="formfieldbold formfielddark" width="1%"></td>
<td class="formfieldbold formfielddark" width="1%"></td>
<td class="formfieldbold formfielddark"><b>Code</b></td>
<td class="formfieldbold formfielddark"><b>Comment</b></td>
<td class="formfieldbold formfielddark" width="10%"><b>Characters left</b></td>	       
</tr>

<%
    String ex;
    Connection connd = null;
    ResultSet resultd = null;
    Statement stmtd = null;
    ResultSetMetaData rsmdd = null;
    result1 = null;
    stmt1 = null;
    int M = 0;
	int min = 0;

    try {
        stmtd = conn.createStatement();
        resultd = stmtd.executeQuery("SELECT LineIndex, Code, Comment,DissectionID FROM ent_line where DissectionID = '" + dis + "' order by LineIndex");	
	String count = "";
	
	
	stmt1 = conn.createStatement();
	result1 = stmt1.executeQuery("SELECT Min(LineIndex),Max(LineIndex) FROM ent_line where DissectionID = '" + dis + "'");	
	while(result1.next()){
		min = result1.getInt(1);
		M=result1.getInt(2);
	}
        while(resultd.next())
		{    	
        	StringBuffer text = new StringBuffer(resultd.getString(2));
        	int loc = (new String(text)).indexOf('\n');
        	while(loc >= 0){       
	        
	            text.replace(loc, loc+1,"");
	            loc = (new String(text)).indexOf('\r');
	       }
	    	StringBuffer text1 = new StringBuffer(resultd.getString(3)==null?"":resultd.getString(3));
	    	
        	int loc1 = (new String(text1)).indexOf('\n');        	
	        while(loc1 >= 0){       
	        
	            text1.replace(loc1, loc1+1,"");
	            loc1 = (new String(text1)).indexOf('\r');
	       }
	       
	       count = resultd.getString(1);
	       int LineNo = Integer.parseInt(count); 
	       %>
	       
	       <tr>
	       <td><img src='images/trash.jpg' id = 'deleteImg<%=LineNo %>' title = 'Delete this line' fn = 'deleteline' disID='<%=dis%>' lno='<%=resultd.getString(1)%>' max = '<%=M%>'></td> 
	       <td><img src='images/add-icon.png' id = 'AddImg<%=LineNo %>' title = 'Add line above this line' fn = 'addline' disID='<%=dis%>' lno='<%=resultd.getString(1)%>' max = '<%=M%>'></td>
	     
	      <script>
	       var rd = "<%=readonly%>";
	       if (rd == 'readonly')
	       {
				document.getElementById("deleteImg<%=LineNo %>").style.opacity = '0.3';
				document.getElementById("AddImg<%=LineNo %>").style.opacity = '0.3';
	    		//for firefox,chrome
				document.getElementById("deleteImg<%=LineNo %>").setAttribute("disabled", "disabled");			
				document.getElementById("AddImg<%=LineNo %>").setAttribute("disabled", "disabled");		
			 
				//for ie
				document.getElementById("deleteImg<%=LineNo %>").disabled = true;		
				document.getElementById("AddImg<%=LineNo %>").disabled = true;

	       }
	      </script>	     	      
	       <td><TEXTAREA style="width: 100%;" ROWS="2" id ="code<%=resultd.getString(1)%>" NAME="code<%=resultd.getString(1)%>" <%=readonly%>><%=text%></textarea></td>
	       <td><TEXTAREA style="width: 100%;" ROWS="2" NAME="comment<%=resultd.getString(1)%>" wrap="physical" onKeyDown="textCounter(this.form.comment<%=resultd.getString(1)%>,this.form.remLen<%=resultd.getString(1)%>,2048)" onKeyUp="textCounter(this.form.comment<%=resultd.getString(1)%>,this.form.remLen<%=resultd.getString(1)%>,2048)" <%=readonly%>><%=text1%></textarea></td>
   	     <td><input readonly style='width: 100%;' type="text" name=remLen<%=resultd.getString(1)%> size="4" value="2048"></td>      
 	       <input  TYPE="hidden" VALUE=<%=resultd.getString(1)%> NAME="count<%=resultd.getString(1)%>">
	                	      	  
   	       </tr>      
   	       <% 	       
        	}                                       	             
        %>
        <tr>
        <td></td><td></td>
        <td  colspan="3">
        
        <input type="button" name="save" fn = 'save' value = "Save" <%=disabled %>>
                <input type="hidden" name="sel" value = "<%=scope %>">
        
        
        </td>
        </tr>
        </table>	      	  
        
       </td></tr>
        <%
     }
     catch (SQLException e) {
         System.out.println("Error occurred " + e);
      }
        
   finally {
    try {
      if (stmt != null)
       stmt.close();
      }  catch (SQLException e) {}
    try {
        if (conn != null)
         conn.close();
        } catch (SQLException e) {e.printStackTrace();}
       
   }     

%>    

</table>

 <input type="hidden" name="sc" value=<%=request.getParameter("sc")%>>
        <input  TYPE="hidden" VALUE=<%=M%> NAME="max" id = "max">
	    <input  TYPE="hidden" VALUE=<%=min%> NAME="min" id = "min"> 
	    
</form>
</body>
</html>