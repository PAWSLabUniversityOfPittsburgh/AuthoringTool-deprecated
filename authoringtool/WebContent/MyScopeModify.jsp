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

function submitFunction(obj,curRDFID)
{
 var title = document.getElementById("Name").value;
 title = title.replace(/\s+/g, '');
 var rdfID = document.getElementById("rdfID").value;
 rdfID = rdfID.replace(/\s+/g, '');
 var sel = document.getElementById("domain");
 var domain = sel.options[sel.selectedIndex].value;
 
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
 else if (domain == '-1')
 {
 	 alert("Please select the domain.");
 	 return false;
 }
 else
 {
	 var invalid = false;
	 rdfID = document.getElementById("rdfID").value;
	 for (var index in rdfs)
     {
		 if (rdfs[index] ==rdfID)
		 {
			 if (rdfID != curRDFID)
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
		 obj.action = "scope_modify_save.jsp";
		 return true;
		 }
 }
}
</script>

<script type="text/javascript">
$(document).ready(function(){
	$("img").click(function () {
		var fn = $(this).attr('fn');
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
					var err = data.message;
					if (err != '')
						alert(msg);	
					else
						alert("Scope deleted successfully!");window.location = "myScopes.jsp"; 
				      },"json");	 

            }
		}
	});		
});


</script>

<h2>Modify scope:</h2>
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

<form method="post">
	 <table style="width: 100%">
	 <tr>	 
	 <td class="formfieldbold formfielddark"></td>
	 <td class="formfieldbold  formfielddark  " ><b>Title</b></td>
	 <td class="formfieldbold  formfielddark  " ><b>rdfID</b></td>
	 <td class="formfieldbold  formfielddark  " ><b>Description</b></td>
	 <td class="formfieldbold formfielddark" width="5%"><b>Domain</b></td>
	 
	 <td class="formfieldbold  formfielddark  " style="width: 15%" ><b>Privacy</b></td>
	 </tr>
<%	Connection connection = null;
     	Statement statement = conn.createStatement();
     	
	 String uid="";
	 rs = statement.executeQuery("SELECT id FROM ent_user where name = '"+userBeanName+"' ");
	 while(rs.next())
	  {
	  	uid=rs.getString(1);  	
	  }     
 
	 out.write("<tr>");  	 
         ResultSet rs1 = null;      
         rs1 = statement.executeQuery("SELECT distinct s.Name, s.Description, s.rdfID,r.Privacy,r.ScopeID,r.Uid,s.domain FROM ent_scope s, rel_scope_privacy r "+
				"where r.Uid = '"+uid+"' and s.ScopeID=r.ScopeID and s.rdfID = '"+request.getParameter("rdfID")+"'");
	 int cnt=0;
	 String curRDFID = "";
         while(rs1.next())
	  {	  	
         curRDFID = rs1.getString(3);
		 out.write("<tr>"); 	 
		 cnt++;		 
		 out.write("<input type=hidden name='scopeid"+cnt+"' value='"+rs1.getString(5)+"'>");
		 out.write("<td><img src=images/trash.jpg border=0 title = 'Delete scope' fn = 'delete' scopeID='"+rs1.getString(5)+"'></td>");
		 out.write("<td><textarea style='width: 100%;' rows=1 id = 'Name' name='Name"+cnt+"' value='"+rs1.getString(1)+"'>"+rs1.getString(1)+"</textarea></td>"); 		 	 		 		 
		 out.write("<td><textarea style='width: 100%;' rows=1 id = 'rdfID'name='rdfID"+cnt+"' value="+rs1.getString(3)+">"+rs1.getString(3)+"</textarea></td>");
		 out.write("<td><textarea style='width: 100%;' rows=1 name='Description"+cnt+"' value="+rs1.getString(2)+">"+rs1.getString(2)+"</textarea></td>");		 
         
%>
<td>
<select name="domain" id = "domain">
	<option value = '-1'>Please select the domain</option>
	<option value = 'JAVA'>JAVA</option>
	<option value = 'HTML'>HTML</option>
	<option value = 'SQL'>SQL</option>
	<option value = 'C/C++'>C/C++</option>
	<option value = 'VB'>VB.NET</option>
	</select>
</td>
<script>
var sel = document.getElementById("domain");
sel.value = "<%=rs1.getString(7)%>";
</script>
<%
		 if (rs1.getString(4).equals("1")){	
		  	 if (rs1.getString(6).equals(uid)){
				out.write("<td><input type=radio id ='privacy' name='privacy"+cnt+"' value=private>Private<input type=radio id ='privacy' name='privacy"+cnt+"' value=public checked>Public</td>");			 			 		  	 	 	
			 }else{
			 	out.write("<td><input type=radio id ='privacy' name='privacy"+cnt+"' value=private disabled>Private<input type=radio id ='privacy' name='privacy"+cnt+"' value=public checked>Public</td>");			 			 
			 }
		 }else{		 	
		 	 out.write("<td><input type=radio id ='privacy' name='privacy"+cnt+"' value=private checked>Private<input type=radio id ='privacy' name='privacy"+cnt+"' value=public>Public</td>");
		 }
		 
		 out.write("</tr>");   		 
	  }	  	 	 
	  out.write("<input type=hidden name=cnt value='"+cnt+"'>");
%>	

<tr>
<td  class="formfieldbold formfielddark" style="width: 2%"></td>
<td  class="formfieldbold formfielddark"><input type="submit" value="Save" onclick="return submitFunction(this.form,'<%=curRDFID%>')"></td>
<td  class="formfieldbold formfielddark"></td>
<td  class="formfieldbold formfielddark"></td>
<td  class="formfieldbold formfielddark"></td>
<td  class="formfieldbold formfielddark"></td>

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