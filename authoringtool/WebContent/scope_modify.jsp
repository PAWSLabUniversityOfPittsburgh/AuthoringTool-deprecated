<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>
<%@ include file = "include/connectDB.jsp" %>
<script src="<%=request.getContextPath()%>/js/jquery1.4.2.js"></script>


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
</script>

<script type="text/javascript">
$(document).ready(function(){
	$("img").click(function () {
		var fn = $(this).attr('fn');
		var uname = $(this).attr('uname');
		if (fn == 'clone')
		{
		   var scopeID = $(this).attr('scopeID');
		   $("body").addClass("loading");
		   $('.modal').fadeIn(1);
		   $.post("CloneScopeServlet?scopeID="+scopeID+"&uname="+uname,function() {
			   $("body").removeClass("loading");
			   $('.modal').fadeOut(1);
			   alert("Scope cloned successfully!");window.location.reload(true); })
			    .success(function() { alert("success");window.location.reload(true); })
			    .error(function() { alert("error"); window.location.reload(true);})
			    .complete(function() { alert("complete");window.location.reload(true); });	  
		}
		if (fn == 'delete')
		{
			var scopeID = $(this).attr('scopeID');
			
			if (confirm ("Are you sure you want to delete the scope and all of its examples?"))
            {
				$("body").addClass("loading");
				$('.modal').fadeIn(1);
				$.post("DeleteScopeServlet?scopeID="+scopeID,function(data) {
					$("body").removeClass("loading");
				    $('.modal').fadeOut(1);
					var msg = data.message;
					if (msg != '')
					{
						alert(msg);						
					}
					else
					{
						alert("Scope deleted successfully!");window.location.reload(true);
					}
					   },"json");
            }
				 
		}
	});	
	
	$("textarea").change(function () {
		var input = $(this).val();
		input = input.replace(/\s+/g, '');
		var fn =  $(this).attr("fn");
		if (fn == 'title')
		{
			if (input == '')
				{
				alert("Title cannot be empty!");
				return false;
				}
		}
		else if (fn == 'rdf')
		{
			if (input == '')
		    {
				alert("RDF ID cannot be empty!");
    			return false;
		    }
			else
			{
				 var invalid = false;
				 var curVal = $(this).attr("curVal");
				 for (var index in rdfs)
			     {
					 if (rdfs[index] ==$(this).val())
					 {		
						  if (input != curVal)
							  invalid = true;
					 }
				 }
				 if (invalid)
				 {				
					 alert("RDF ID already exists. Please enter another value.");
					 return false;
				 }
		}
		}
			
	});	
	$("select").change(function () {
		var input = $(this).val();
		if (input == '-1')
		{
			alert("Please select the domain.");
			 return false;
		}
	});
	
});



</script>
<%
stmt = conn.createStatement();
String command = "select rdfID from ent_scope;";
ResultSet rs = stmt.executeQuery(command);
ArrayList<String> rdfList = new ArrayList<String>();
while (rs.next())
{
	rdfList.add(rs.getString(1));
}

%>
<script>
	var rdfs = new Array();
	<%for (String rdf : rdfList){%>
	     rdfs.push("<%=rdf%>");
	<%}%>
</script>
<h2>Modify scope:</h2>
<form method="post" name = "modify_scope" action="scope_modify_save.jsp">
	 <table  style="width: 100%">
	 <tr>	 
	 <td class="formfieldbold formfielddark" width="1%"></td>
		 <td class="formfieldbold formfielddark" ><b>Title</b></td>
	<td class="formfieldbold formfielddark" ><b>RDF ID</b></td>
	<td class="formfieldbold formfielddark"><b>Description</b></td>
    <td class="formfieldbold formfielddark" width="5%"><b>Domain</b></td>
	
	<td class="formfieldbold formfielddark" width="15%"><b>Privacy</b></td>
	 
	 </tr>
<%	Connection connection = null;
     	Statement statement = conn.createStatement();
   	 int cnt=0;
     String readonly = "";
     String disabled = "";
     	
	 String uid="";
	 rs = statement.executeQuery("SELECT id FROM ent_user where name = '"+userBeanName+"' ");
	 while(rs.next())
	  {
	  	uid=rs.getString(1);  	
	  }     
 
	 out.write("<tr>");  	 
         ResultSet rs1 = null;      
         rs1 = statement.executeQuery("SELECT distinct s.Name, s.Description, s.rdfID,r.Privacy,r.ScopeID,r.Uid,s.domain FROM ent_scope s, rel_scope_privacy r "+
				"where r.Privacy='0' and r.Uid = '"+uid+"' and s.ScopeID=r.ScopeID or (r.Privacy ='1' and s.ScopeID=r.ScopeID)");
         while(rs1.next())
	  {	  	  	 	 
		 out.write("<tr>"); 	 
		 cnt++;		 
		 out.write("<input type=hidden name='scopeid"+cnt+"' value='"+rs1.getString(5)+"'>");
		 		  
		 if (rs1.getString(4).equals("1")){
		 	if (rs1.getString(6).equals(uid)){
		 		out.write("<td><img src=images/trash.jpg border=0 title = 'Delete scope' fn = 'delete' scopeID='"+rs1.getString(5)+"'></td>");
		 	}else {
		 		readonly = "readonly";
		 		disabled = "disabled";
		 		out.write("<td><img src=images/clone.png border=0 fn = 'clone' uname = '"+userBeanName+"' scopeID='"+rs1.getString(5)+"' title = 'Clone scope'></td>");
		 	}
		 }else {
		 	out.write("<td><img src=images/trash.jpg border=0 title = 'Delete scope' fn = 'delete' scopeID='"+rs1.getString(5)+"'></td>");
		 }
		 if (rs1.getString(4).equals("1"))
		 {
			 if (rs1.getString(6).equals(uid))
			 {
				 out.write("<td><textarea style='width: 100%;' rows=1 name='Name"+cnt+"' value='"+rs1.getString(1)+"' fn = 'title' >"+rs1.getString(1)+"</textarea></td>"); 		 	 		 		 
				 out.write("<td><textarea style='width: 100%;' rows=1 name='rdfID"+cnt+"' value='"+rs1.getString(3)+"' fn = 'rdf' curVal = '"+rs1.getString(3)+"'>"+rs1.getString(3)+"</textarea></td>");
				 out.write("<td><textarea style='width: 100%;' rows=1 name='Description"+cnt+"' value='"+rs1.getString(2)+"' >"+rs1.getString(2)+"</textarea></td>");		 
			 }
			 else
			 {
				 out.write("<td><textarea style='width: 100%;' rows=1 name='Name"+cnt+"' value='"+rs1.getString(1)+"' readonly>"+rs1.getString(1)+"</textarea></td>"); 		 	 		 		 
				 out.write("<td><textarea style='width: 100%;' rows=1 name='rdfID"+cnt+"' value="+rs1.getString(3)+" readonly>"+rs1.getString(3)+"</textarea></td>");
				 out.write("<td><textarea style='width: 100%;' rows=1 name='Description"+cnt+"' value='"+rs1.getString(2)+"' readonly>"+rs1.getString(2)+"</textarea></td>");		 
			 }
		 }
		 else
		 {
			 out.write("<td><textarea style='width: 100%;' rows=1 name='Name"+cnt+"' value='"+rs1.getString(1)+"' fn = 'title'>"+rs1.getString(1)+"</textarea></td>"); 		 	 		 		 
			 out.write("<td><textarea style='width: 100%;' rows=1 name='rdfID"+cnt+"' value='"+rs1.getString(3)+"' fn = 'rdf' curVal = '"+rs1.getString(3)+"'>"+rs1.getString(3)+"</textarea></td>");
			 out.write("<td><textarea style='width: 100%;' rows=1 name='Description"+cnt+"' value='"+rs1.getString(2)+"'>"+rs1.getString(2)+"</textarea></td>");		 
		 }
		 %>
		 <td>
<select name="domain<%=cnt%>" id = "domain<%=cnt%>">
	<option value = '-1' <%=disabled %> disabled="disabled">Please select the domain</option>
	<option value = 'JAVA' <%=disabled %> disabled="disabled">JAVA</option>
	<option value = 'HTML' <%=disabled %> disabled="disabled">HTML</option>
	<option value = 'SQL' <%=disabled %> disabled="disabled">SQL</option>
	<option value = 'C/C++' <%=disabled %> disabled="disabled">C/C++</option>
	<option value = 'VB' <%=disabled %> disabled="disabled">VB.NET</option>
	</select>
</td>
<script>
var sel = document.getElementById("domain<%=cnt%>");
sel.value = "<%=rs1.getString(7)%>";
sel.options[sel.selectedIndex].disabled = false;
</script>
		 <%
		 		 if (rs1.getString(4).equals("1")){	
		  	 if (rs1.getString(6).equals(uid)){
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
<script>
var count = <%=cnt%>
</script>
<tr>
<td  colspan="6" class="formfieldbold formfielddark"><input type="submit" value="Save"></td>
</tr>

</table>
</form>


<SCRIPT LANGUAGE="JavaScript">
<!-- Begin
function textCounter(field, countfield, maxlimit) {
if (field.value.length > maxlimit) // if too long...trim it!
field.value = field.value.substring(0, maxlimit);
// otherwise, update 'characters left' counter
else
countfield.value = maxlimit - field.value.length;
}
// End -->
</script>
<div class="modal"><!-- Place at bottom of page --></div>
</body> 
</html>