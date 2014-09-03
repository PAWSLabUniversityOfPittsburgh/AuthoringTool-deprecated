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


function submitFunction(obj)
{
 var title = document.create_scope.Name.value;
 title = title.replace(/\s+/g, '');
 var rdfID = document.create_scope.rdfID.value;
 rdfID = rdfID.replace(/\s+/g, '');
 var privacy = document.create_scope.privacy;
 var selected = false;
 var sel = document.getElementById("domain");
 var domain = sel.options[sel.selectedIndex].value;
 
 for(var i = 0; i < privacy.length; i++) {
	   if(privacy[i].checked == true) {
		   selected = true;
	   }
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
 else if (domain == '-1')
{
	 alert("Please select the domain.");
	 return false;
}
 else if (selected == false)
 {
	 alert("Please select the privacy.");
	 return false;
 }

 else
 {
	 var invalid = false;
	 rdfID = document.create_scope.rdfID.value;
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
		 obj.action = "scope_create_save.jsp";
		 return true;
		 }
 }
}
</script>

<h2>Create scope:</h2>
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

<form name="create_scope" method="post">
<table>
<tr>
	<td class="formfieldbold formfielddark">Title:<font color="red">*</font>	</td>
	<td><input type="text" name="Name" size="45" maxlength="45"></td>
</tr>
<tr>
	<td class="formfieldbold formfielddark">RDF ID:<font color="red">*</font>	</td>
	<td><input type="text" name="rdfID" size="15" maxlength="15" ></td>
</tr>
<tr>
	<td class="formfieldbold formfielddark">Description:	</td>
	<td><input type="text" name="Description" size="70" maxlength="255"></td>
</tr>
<tr>
	<td class="formfieldbold formfielddark">Domain:<font color="red">*</font>	</td>
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
</tr>
<tr>
	<td class="formfieldbold formfielddark">Privacy:<font color="red">*</font>	</td>
	<td><input type="RADIO" name="privacy" value="private">Private <input type="RADIO" name="privacy" value="public">Public</td>
</tr>
<tr>
	<td></td>
	<td><input type="submit" value="Create" onclick="return submitFunction(this.form)">&nbsp;&nbsp;<input type="reset" value="Clear" OnClick="document.form.message.focus()"></td>
</tr>
</table>
</form>
</body> 
</html>