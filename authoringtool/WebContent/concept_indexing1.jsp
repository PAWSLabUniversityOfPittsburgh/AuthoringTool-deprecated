<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>
<%@ page import="java.sql.*" %>

	<style>
	.multipleSelectBoxControl span{	/* Labels above select boxes*/
		font-family:arial;
		font-size:11px;
		font-weight:bold;
	}
	.multipleSelectBoxControl div select{	/* Select box layout */
		font-family:arial;
		height:100%;
	}
	.multipleSelectBoxControl input{	/* Small butons */
		width:25px;	
	}
	
	.multipleSelectBoxControl div{
		float:left;
	}
		
	.multipleSelectBoxDiv
	</style>

<SCRIPT type="text/javascript" src="<%=request.getContextPath()%>/js/tab.js"></SCRIPT> 
<script src="<%=request.getContextPath()%>/js/jquery1.4.2.js"></script>

<script type="text/javascript">
$(document).ready(function(){
	$("#addBtn").click(function () {
		var question = document.getElementById("question").value;
		var count = document.getElementById("questionClassCount").value;
		var sel = document.getElementById("addConceptList");
		var concept = sel.options[sel.selectedIndex].value;
        var array = new Array();
        array.push(sel);
        for (var i = 0; i < count; i++)
        	{
        	   var selected = document.getElementById(i+"AddRowSelected");
        	   var lines = document.getElementById(i+"AddRowLines");
        	   var className = document.getElementById(i+"AddConceptClass");
        	   if (selected.checked)
        		   {
        		   array.push(selected);
        		   array.push(lines);
        		   array.push(className);
        		   }
        	}
		$.post("AddConcept?question="+question+"&count="+count+"&type=example",array, function() {
			alert("Concept added successfully!");window.location.reload(true); })
		    .success(function() { alert("success");window.location.reload(true); })
		    .error(function() { alert("error"); window.location.reload(true);})
		    .complete(function() { alert("complete");window.location.reload(true); });	
	});	
	
	$("#saveBtn").click(function () {
		var question = document.getElementById("question").value;
		var count = document.getElementById("conceptCount").value;
        var array = new Array();
        for (var i = 0; i < count; i++)
        	{
        	   var selected = document.getElementById(i+"Selected");
        	   var concept = document.getElementById(i+"Concept");
        	   var weight = document.getElementById(i+"Weight");
        	   var direction = document.getElementById(i+"Direction");
        	   if (selected.checked)
        	   {
        		   array.push(selected);
        		   array.push(concept);
        		   array.push(weight);
        		   array.push(direction);    		   
        	   }
        	   else
        		   array.push(concept);
        	}
		$.post("SaveIndexing.jsp?question="+question+"&count="+count+"&type=example",array, function() {
			alert("Indexing saved successfully!"); window.location.reload(true);})
		    .success(function() { alert("success"); window.location.reload(true); })
		    .error(function() { alert("error"); window.location.reload(true);})
		    .complete(function() { alert("complete"); window.location.reload(true); });	
	});	
	
	
	$("input").change(function () {
		var fn =  $(this).attr("fn");
		if (fn == 'lines')
		{
			var input = $(this).val();
			input = input.replace(/\s+/g, '');
			var regex = /^(\d+-\d+)(;\d+-\d+)*$/;
			var match = false;
			 if (input.match(regex)) 
				match = true;
			 else if (input == '')
				match = true;
			 else if (input.match(/^(\d+-\d+)(;\d+-\d+)*;$/))
				match = true;
			 if (match == false)
				 alert("Input should be list of hyphenated digits separated by ;'");

		}
			
	});	
	
	
	$("img").click(function () {
		var fn =  $(this).attr("fn");
		if (fn == 'expand')
		{
		   $(this).attr('src','images/collapse_icon.png');
		   $(this).attr('fn','collapse');
		   showAddConcept('addTable');
		}
		else if (fn == 'collapse')
		{
			document.getElementById('addTable').style.display = "none";
			 $(this).attr('src','images/expand_icon.png');
			 $(this).attr('fn','expand');			
		}
		else if (fn == 'delete')
		{
			var r=confirm("Are you sure you want to delete this concept?");
			if (r==true)
			  {
				var concept = $(this).attr("concept");
				var question = $(this).attr("question");
				$.post("DeleteConcept?question="+question+"&concept="+concept+"&type=example",function() {
					alert("Concept deleted successfully!");window.location.reload(true); })
				    .success(function() { alert("success");window.location.reload(true); })
				    .error(function() { alert("error"); window.location.reload(true);})
				    .complete(function() { alert("complete");window.location.reload(true); });					
			  }		
		}
		else if (fn == 'edit')
		{
			var concept = $(this).attr("concept");
			var question = $(this).attr("question");
			var result = window.showModalDialog('UpdateConcept.jsp?question='+question+"&concept="+concept+"&type=example", question+","+concept+",example", 'dialogHeight=300px;dialogWidth=500px');
			if (result != null)
			{
				window.location.reload(true);
			}
			
		}		
	});	 
});

    
	function cOn(td) {
		if (document.getElementById || (document.all)) {
			td.style.backgroundColor = "#ffffe1";
		}
	}
	function cOut(td) {
		if (document.getElementById || (document.all)) {
			td.style.backgroundColor = "#FFCC00";
		}
	}
	
	
	function checkAll(){
		for (var i=0;i<document.indexForm.elements.length;i++)
		{
		    var e=document.indexForm.elements[i];
			if ((e.name != 'selectAll') && (e.type=='checkbox'))
			{
				e.checked=document.indexForm.selectAll.checked;
				e.onclick();
			}			
		}	
	}
	
	function disableEnableFormElements(concept,question, lines,count)
	{
		if (document.getElementById(count+"Selected").checked == false)
		{
			document.getElementById(count+"Weight").disabled = true;
			document.getElementById(count+"Direction").disabled = true;
			document.getElementById(count+"Row").style.color = "gray";
			document.getElementById(count+"hRef").innerHTML = concept +"&nbsp;&nbsp;";
			document.getElementById(count+"deleteImg").style.opacity = '0.3';
			document.getElementById(count+"editImg").style.opacity = '0.3';
			//for firefox,chrome
			document.getElementById(count+"deleteImg").setAttribute("disabled", "disabled");			
			document.getElementById(count+"editImg").setAttribute("disabled", "disabled");		
		 
			//for ie
			document.getElementById(count+"deleteImg").disabled = true;		
			document.getElementById(count+"editImg").disabled = true;
		}
		else
	    {
			document.getElementById(count+"Weight").disabled = false;
			document.getElementById(count+"Direction").disabled = false;
			document.getElementById(count+"Row").style.color = "black";
			document.getElementById(count+"hRef").innerHTML =  "<a href='javascript:showClassTab(\""+question+"\",\""+lines+"\")'>"+concept+"</a>&nbsp;&nbsp;"
			
			document.getElementById(count+"deleteImg").style.opacity = '1.0';
			document.getElementById(count+"editImg").style.opacity = '1.0';
			document.getElementById(count+"deleteImg").disabled = false;
			document.getElementById(count+"editImg").disabled = false;
		}
	}
	
	function showConceptClass(id,href){
		document.getElementById(id).style.display="table-row";
		document.getElementById(href).innerHTML =  "-";
		document.getElementById(href).href = "javascript:hideConceptClass(\""+id+"\",\""+href+"\")";
    }
	
	function hideConceptClass(id,href)
	{
		document.getElementById(id).style.display="none";
		document.getElementById(href).innerHTML =  "+";
		document.getElementById(href).href  = "javascript:showConceptClass(\""+id+"\",\""+href+"\")";
	}
	
	function showClassTab(question,lines){ 

			for(var i = 0; i < lineCount; i++)
			{
				document.getElementById(question+i).style.backgroundColor = "";
		}					
		
        
        var lineArray = lines.split(';');
        var temp;
        var isFirstLine = true;
		for (var i = 0; i < lineArray.length; i++)
	    {
			var seLine = lineArray[i].split('-');
	    	var start = parseInt(seLine[0],10);
	    	var end = parseInt(seLine[1],10);
	    	
		    for (var j=start; j<=end; j++)
		    {
		       if (isFirstLine == true)
		       {
		    	   temp = seLine[0];
		    	   isFirstLine = false;
		       }
			   document.getElementById(question+j).style.backgroundColor = "yellow";  
		    }		    
		}
		 document.getElementById(question+temp).scrollIntoView();
    }
	
	function showTab(tabIndex){ 
        tabPane.setSelectedIndex(tabIndex);        	 
    }
	
	function showAddConcept(id)
	{
		document.getElementById(id).style.display="table";
	}
	function enableAddRow(classCount)
	{
		var select = document.getElementById('addConceptList');
		var newConcept = select.options[select.selectedIndex].value;
		if (newConcept != '-1')
			{
			  for (var j = 0; j < classCount; j++)
				  {
				    var row =  document.getElementById(j+'AddRow');
				    row.style.color = "black";
				    var select = document.getElementById(j+'AddRowSelected');
				    select.disabled = false;
				    var linesText = document.getElementById(j+'AddRowLines');
				    linesText.disabled = false;
				    var btn = document.getElementById('addBtn');
				    btn.disabled = false;
				  }
			}
		else
			{
			 for (var j = 0; j < classCount; j++)
			  {
			    var row =  document.getElementById(j+'AddRow');
			    row.style.color = "gray";
			    var select = document.getElementById(j+'AddRowSelected');
			    select.disabled = true;
			    var linesText = document.getElementById(j+'AddRowLines');
			    linesText.disabled = true;
			    var btn = document.getElementById('addBtn');
			    btn.disabled = true;
			  }
			}
	}
	
	function disableEnableAddRowLine(line)
	{
        var select = document.getElementById(line+"AddRowSelected");
  	    var lineText = document.getElementById(line+"AddRowLines");
	    var row =  document.getElementById(line+'AddRow');

        if (select.checked == false)
        	{
    		  lineText.disabled = true;
    		  row.style.color = "gray";
        	}
        else
        {
  		  lineText.disabled = false;
  		  row.style.color = "black";
      	}
		
	}	

</script>

<!--  following links are for using css styles for tabpane layout and quizjet interface -->
<link href=<%=request.getContextPath()%>/stylesheets/quizjet.css rel="stylesheet" type="text/css" />
<link href=<%=request.getContextPath()%>/stylesheets/tab.css rel="stylesheet" type="text/css" />


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
<script language=javascript>
changelist();
function changeTitle()
{
//TODO
//var selectscope = document.myForm.sc;
var scopeid = 12;
//var scopeid=selectscope.options[selectscope.selectedIndex].value;;
var selectExample = document.myForm.example;
var ex=selectExample.options[selectExample.selectedIndex].value;;

//if (ex != '-1' & scopeid != '-1')
//	{
//	  document.location = "ParserServlet?sc="+scopeid+"&question="+ex+"&type=example";
//	}
//else
document.location.href="concept_indexing1.jsp?sc="+scopeid+"&ex="+ex;

}    

function changeScope()
{
var selectscope = document.myForm.sc;
var scopeid=selectscope.options[selectscope.selectedIndex].value;;
document.location.href="concept_indexing1.jsp?sc="+scopeid+"&ex=-1";

}    
</script>

<%    
    Connection conn  = getConnectionToWebex21();
    ResultSet results = null;
    Statement stmts = null;
    ResultSetMetaData rsmds = null;  
    
    ResultSet rs2 = null;   	
    Statement stmt2 = null;
    ResultSet rs3 = null;   	
    Statement stmt3 = null;
    ResultSet rs4 = null;   	
    Statement stmt4 = null;
    ResultSet rs5 = null;   	
    Statement stmt5 = null;
    ResultSet rs6 = null;   	
    Statement stmt6 = null;
    ResultSetMetaData rsmd6 = null;                      
    ResultSet rs7 = null;   	
    Statement stmt7 = null;
     String sc="";       	
     String uid="";
     ResultSet rs = null;  
     try{     
     stmts = conn.createStatement();       
     rs = stmts.executeQuery("SELECT id FROM ent_user where name = '"+userBeanName+"' ");
	while(rs.next())
	  {
	  	uid=rs.getString(1);  	
	  }     
     }catch (SQLException e) {
         System.out.println("Error occurred " + e);
      }
     
     try {
        stmts = conn.createStatement();
        results = stmts.executeQuery("SELECT s.ScopeID,s.Name FROM ent_scope s, rel_scope_privacy sp where s.ScopeID=sp.ScopeID and (sp.privacy='1' or sp.Uid='"+uid+"') and s.domain = 'JAVA'");                
     }
     catch (SQLException e) {
         System.out.println("Error occurred " + e);
      }

     int columnss=0;     
     try {
  
       rsmds = results.getMetaData();       
       columnss = rsmds.getColumnCount();      
     }
     catch (SQLException e) {
        System.out.println("Error occurred " + e);
     }
%>	 
<h3>Please select the example you'd like to index:</h3>
<table style="width: 100%">
<tr>
<td colspan="2">

   <form name="myForm">

	<table>
	<!-- <tr>
		<td class="formfieldbold formfielddark"><b>Scope: </b></td>
		<td>
		<select name="sc" onChange=Javascript:changeScope();>
		<%
		  //  try{
			//      out.write("<option value='-1' selected>Please select the scope</option>");		    		    
		
		  //         for (int j=1; j<=columnss; j++) {                   
		  //		while (results.next()) {  	    
			//	    if (results.getString(1).equals(request.getParameter("sc"))){
			//	    	out.write("<OPTION value="+results.getString(1)+" selected>" +results.getString(1)+"   " + results.getString(2));		    		    
			//	    }else{	
			//	    	out.write("<OPTION value="+results.getString(1)+">" +results.getString(1)+"   " + results.getString(2));		    		    
			//	    }
			//	 }	                       
		   //        } 
		//     }        
		//   finally {
		//    try {
		//      if (stmts != null)
		//       stmts.close();
		//      }  catch (SQLException e) {}
		
		//    }
		             
		%>
		</select>
		</td>
	</tr> -->
	<tr>
		<td class="formfieldbold formfieldlight">Example: </td>
		<td>
		<select name="example" onChange=Javascript:changeTitle();> 
  <% 
  Statement stmt = null;
     try {                
        stmt = conn.createStatement();
        ResultSet result = stmt.executeQuery("SELECT e.DissectionID,e.Name,e.description FROM ent_dissection e, rel_scope_dissection r, rel_dissection_privacy dp where e.DissectionID=r.DissectionID and r.ScopeID ="+ request.getParameter("sc")+" and e.dissectionid = dp.dissectionid and (dp.privacy = 1 or dp.uid = "+uid+") order by e.Name" );                                                        
        int columns=0;
	ResultSetMetaData rsmd = result.getMetaData();       
	 columns = rsmd.getColumnCount();        
       
           if (request.getParameter("ex").equals("-1"))
        		out.println("<option value='-1' selected>Please select the example</option>");
           else
       		out.println("<option value='-1' >Please select the example</option>");

           for (int i=1; i<=columns; i++) {    
        	   
  		while (result.next()) {  
  		    if (result.getString(1).equals(request.getParameter("ex"))){		    
		    	out.write("<OPTION value="+result.getString(1)+" selected>" + result.getString(2));		    		    
		    }else{
		    	out.write("<OPTION value="+result.getString(1)+">" + result.getString(2));		    		    
		    }
		 }	                       
           }                     
        
        stmt.close();        
     } 
     catch (SQLException e) {
        System.out.println("Error " + e);
     }
     
   finally {
    try {
      if (stmt != null)
       stmt.close();
      }  catch (SQLException e) {}     
   }
   %>		
		</select>
		</td>
	</tr>
<%
     try{
	stmt2 = conn.createStatement();       	
	rs2 = stmt2.executeQuery("SELECT d.Description FROM ent_dissection d where d.DissectionID="+request.getParameter("ex")+" ");
	while(rs2.next()){
%>	

<%
	}
	stmt2.close();        
    }
    finally {
    try {
      if (stmt2 != null)
       stmt2.close();
      }  catch (SQLException e) {}     
   }
%>	
	

	</table>
	</form>
	
</td></tr>


<%
Map<String,Integer> classTabMap = new HashMap<String,Integer>();	
int classLine = 0;
List<String> ontoConcepts = getOntologyConcepts();
List<String> allClass = new ArrayList<String>();
String question = "";
String dissectionId = request.getParameter("ex");
if (dissectionId.equals("-1") == false)
{
InputStream in = null;
int length ;
int bufferSize = 1024;
byte[] buffer = new byte[bufferSize];        
int position=0;
int P = 0;
String codepart="";
int QuesType=0; 
int flag=0;
ArrayList<String> fileName = new ArrayList<String>();
ResultSet rs1 = null;
rs2 = null;
Statement statement = null;
try
{
	 conn = getConnectionToWebex21();
	 if (isConnectedToDB(conn))
	 {
		String query = "SELECT rdfID FROM ent_dissection where dissectionID = "+dissectionId;
		statement = conn.createStatement();
		ResultSet temp = statement.executeQuery(query);
		while(temp.next())
		{
			question = temp.getString(1);
		    allClass.add(0, question);
		}	    
	}    
	
}catch (SQLException e) {
	e.printStackTrace();
} finally {
	try {
		
		if (rs1 != null)
			rs1.close();
		if (rs2 != null)
			rs2.close();
		if (statement != null)
			statement.close();
	} catch (Exception e) {
		e.printStackTrace();
    }
}
    
    
int tabNumer = 0;
classTabMap.put(question,tabNumer); //add first tab
%>
<tr>
		<td valign="top" >
		<div class="webfx-main-body">
<!-- begin tab pane -->
<div class="tab-pane" id="tabpane" style="height:500px;width:470px;overflow:auto;border-style:solid;border-width:1px; border-color:rgb(120,172,255);padding: 10px">
<script type="text/javascript">
tabPane = new WebFXTabPane( document.getElementById( "tabpane" ), false );
</script>      
<!-- begin intro page -->
<div class="tab-page" id="<%=question %>">   
<h2 class="tab"><%=question %></h2>

<pre style="white-space:pre-wrap; font-size: 11px"><%   
int linecount = 0;
try{
	stmt3 = conn.createStatement();
String query = "SELECT l.Code,l.Comment FROM ent_line l where l.DissectionID="+request.getParameter("ex")+" order by l.LineIndex ";
rs3 = stmt3.executeQuery(query);
String line = "";
while(rs3.next()){
	line = rs3.getString(1);
    out.print("<div id='"+question+""+linecount+"' >"+linecount+"   "+line+"</div>"); //print each line of the program question
    linecount++;
}
classLine = linecount;
stmt3.close();        
}
finally {
try {
 if (stmt3 != null)
  stmt3.close();
 }  catch (SQLException e) {}     
}       				
				  

%> 

</pre>
</div>
<!-- end intro page -->      


</div></div>
		</td>
		<td valign="top">		
		<Form name=indexForm style = "border-style:solid;border-width:1px; border-color:rgb(120,172,255);padding: 10px;margin:  10px 0px 10px 0px;">
		
<div style="height:420px;width:550px;overflow:auto;border-style:solid;border-width:1px; border-color:rgb(120,172,255);padding: 10px;white-space:pre-wrap;">
<table id = 'conceptTable' >
	<%
	ArrayList<String> concepts = new ArrayList<String>();
	ResultSet classRs = null;
	ResultSet conceptRs = null;
	ResultSet weightDirectionRs = null;
	try
	{
	    conn = getConnectionToWebex21();
	    if (isConnectedToDB(conn))
	    {
			
		statement = conn.createStatement();
		String title = question;
		String query = "select distinct concept from ent_jexample_concept where title = '"+ title + "' order by concept ASC";
		conceptRs = statement.executeQuery(query);
		while (conceptRs.next()) 
			concepts.add(conceptRs.getString(1));		
		%> 	    
		<tr><td valign="baseline" colspan="7" class = 'formfieldlight'><input type="checkbox" checked="checked" value="on" id="selectAll" name="selectAll" onclick="checkAll();" align="left" >Select All <%=concepts.size() %> concepts
		</td></tr>
		<%
		int count = 0;
		for (String c : concepts)
		{
	    %>
	     <% 
	      String lines = "";
		  String classLinksHtml = "";
		  query = "select distinct class from ent_jexample_concept where title = '"+ title + "' and concept = '"+c+"'" ;
		  classRs = statement.executeQuery(query);
		  String curClass;
		  while (classRs.next())
		  {  
			  lines = "";
			  curClass = classRs.getString(1);
		      query = "select sline,eline from ent_jexample_concept where title = '"+ title + "' and class = '"+curClass+"' and concept = '"+c+"' and sline != -1 and eline !=-1";
		      stmt = conn.createStatement();
		      ResultSet seLineRs = stmt.executeQuery(query);
              while (seLineRs.next())
              {
            	  lines += seLineRs.getInt(1)+"-"+seLineRs.getInt(2);
            	  if (seLineRs.isLast() == false)
            		  lines += ";";
              }
    		  if (seLineRs != null)
            	  seLineRs.close();
              if (stmt != null)
 				stmt.close();
              if (lines.equals("") == false)
            	  classLinksHtml += "<a style=\"float:left;\" href='javascript:showClassTab(\""+curClass+"\",\""+lines+"\")"+"'>"+" "+curClass+" "+"</a>";  

		  } %>
	    <tr id='<%=count+"Row"%>'>
	    <td class = 'formfieldlight'><%=count+1%> </td>
	    <td><input type=checkbox onclick='disableEnableFormElements("<%=c%>","<%=question%>","<%=lines%>",<%=count%>);' checked='checked' id='<%=count+"Selected"%>' name='<%=count+"Selected"%>' align="left"></td>
	    <td class = 'formfieldlight' id ='<%=count+"hRef"%>'><a href='javascript:showClassTab("<%=question%>","<%=lines%>")'><%=c%></a>&nbsp;&nbsp;</td>
		<%	query = "select weight,direction from ent_jexample_concept where title ='"+title+"'"+" and concept = '"+c+"'"; 
		    weightDirectionRs = statement.executeQuery(query);
			String direction = "";
			String weight = "";
			while(weightDirectionRs.next())
			{
				weight = weightDirectionRs.getString(1);
				direction = weightDirectionRs.getString(2);	
			}
		%>		
		 <td ><select id='<%=count+"Weight"%>' name = '<%=count+"Weight"%>'">

		 <% 
              String selected = "";  
		      if (weight != null)
		    	  selected = weight;
		      else
		    	  selected = Const.RELATED_WEIGHT;
              for (String s : Const.WEIGHTS)
              {
            	  out.println("<option value=\""+s+"\""+(selected.equals(s)? "selected" : "")+">"+s+"</option>");
              }
           %>
		 </select>&nbsp;&nbsp;&nbsp;</td>
		<td ><select id='<%=count+"Direction"%>' name = '<%=count+"Direction"%>'">
		 <% if (direction.equals("prerequisite")){ %>
		    <option value='0' selected>Prerequisite</option>
		    <option value='1'>Outcome</option>
		    
	      <% } else if (direction.equals("outcome")) { %>
	      	 <option value='0'>Prerequisite</option>	      
	         <option value='1' selected>Outcome</option>
	         <%} %>
	      </select></td>
	      
	      <td><img src="images/edit.png" id = '<%=count %>editImg' concept = '<%=c%>' question='<%=question%>' fn = 'edit' ></td>	      
	      <td><img src="images/delete.png" id = '<%=count %>deleteImg' concept = '<%=c%>' question='<%=question%>' fn = 'delete' ></td>
	      
	     </tr>
	    
		  <tr id ='<%=count+"ExpandRow"%>' style="display: none;" >	  
		  <td></td><td></td><td colspan="5" > <%=classLinksHtml %></td>
	      </tr>
	     <% 
	count++; }	
		%>
	</table></div>
	<%
	for (int i = 0; i < concepts.size(); i++)
		{
		%>
			<input type="hidden" name='<%=i+"Concept"%>' id='<%=i+"Concept"%>' value='<%=concepts.get(i)%>'>	      
	  <%}%>
    <input type="hidden" name="conceptCount" id = "conceptCount" value="<%=concepts.size()%>">	
    <div style = "margin:  10px;">
    <img src="images/expand_icon.png" id = 'addConceptImg' fn = 'expand'>
    Add More Concepts
    </div>
    <table width="100%" id ="addTable"  style = "display:none;border-style:solid;border-width:1px; border-color:rgb(120,172,255);padding: 10px">    
    <tr><td style = "padding-bottom:10px" colspan="7">
    <select id = 'addConceptList' name = "addConceptList" onchange="enableAddRow(<%=allClass.size()%>)">
    <% 
    List<String> totalConcepts = getOntologyConcepts();
    for (String c : concepts)
    	totalConcepts.remove(c);
    Collections.sort(totalConcepts);
	out.println("<option value='-1'>Please select the concept</option>");
    for (String c: totalConcepts){
	%>
	<option value='<%=c%>'><%=c%></option>
	<% } %>
    </select>
    </td></tr>   
    <%  String tableHtml = "";
  
	  for (int j = 0; j < allClass.size(); j++)
	  {
		  tableHtml += "<tr id = \""+j+"AddRow\" name = \""+j+"AddRow\" style = \"color:gray\"><td><input type=checkbox checked disabled id='"+j+"AddRowSelected' name='"+j+"AddRowSelected' align=\"left\" onchange = \"disableEnableAddRowLine("+j+");\"></td><td>"+" "+allClass.get(j)+"</td><td style = \"padding-left:10px\">start-end lines: <input type=\"text\" id = '"+j+"AddRowLines' name = '"+j+"AddRowLines' disabled fn = 'lines'\"></td><td></td><td></td><td></td><td></td></tr>";
	  }%>	  
	  <tr><td></td><td></td><td style="font-style:italic;color: gray;padding-left: 10px">start-end lines example: 1-3;5-5</td><td></td><td></td><td></td><td></td></tr>
    <%=tableHtml %>
    
    <%
    for (int i = 0; i < allClass.size(); i++)
		{
		%>
	    <input type="hidden" name='<%=i+"AddConceptClass"%>' id='<%=i+"AddConceptClass"%>' value='<%=allClass.get(i)%>'>	      
	  <%}%>
	  	<input type="hidden" id='questionClassCount' value='<%=allClass.size()%>'>	      
	    <input type="hidden" id='question' value='<%=question%>'>	      
	  
    <tr><td colspan="7" align="right"><input type="button"  name ="addBtn" id ="addBtn" value="Add" disabled="disabled"></td></tr>
    </table>
	<div align="right"><input type="button" name = "saveBtn" id = "saveBtn" value="Save"></div>
	</Form>		
	</td>	  
		
	</tr>
	<%
	
	    }//end if connection to db
	}catch (SQLException e) {
		e.printStackTrace();
	} finally {
		try {		
			if (classRs != null)
				classRs.close();
			if (conceptRs != null)
				conceptRs.close();
			if (weightDirectionRs != null)
				weightDirectionRs.close();
			if (statement != null)
				statement.close();
			disconnectFromDB(conn); //here connection is closed
		} catch (Exception e) {
			disconnectFromDB(conn); //here connection is closed
			e.printStackTrace();
		}} 		
		}%>
</td>
</tr>
</table>
	</body> 
<script>
	var lineCount=<%=classLine%>;
</script>
</html>
<%!
public Connection getConnectionToWebex21()
{
	Connection conn = null;
	try
	{
		Class.forName(this.getServletContext().getInitParameter("db.driver"));
		conn = DriverManager.getConnection(this.getServletContext().getInitParameter("db.webexURL"),this.getServletContext().getInitParameter("db.user"),this.getServletContext().getInitParameter("db.passwd"));
	}catch (Exception e) {
		e.printStackTrace();
	}
	return conn;
}

public Connection getConnectionToTreemap()
{
	Connection conn = null;
	try
	{
		Class.forName(this.getServletContext().getInitParameter("db.driver"));
		conn = DriverManager.getConnection(this.getServletContext().getInitParameter("db.treemapURL"),this.getServletContext().getInitParameter("db.user"),this.getServletContext().getInitParameter("db.passwd"));
	}catch (Exception e) {
		e.printStackTrace();
	}
	return conn;
}

 public List<String> getOntologyConcepts()
 {
	 List<String> ontoConcepts = new ArrayList<String>();
	 Connection conn = getConnectionToTreemap();
	 PreparedStatement pstmt = null;
	 ResultSet rs = null;
	 if (isConnectedToDB(conn))
	 {
		 try
		 {
			 String sqlCommand = " select distinct concept2 from rel_onto_concept_concept" +
			   					 " where concept2 not in" +
								 " (select concept1 from treemap.rel_onto_concept_concept)" +
			    				 " order by concept2";		
			pstmt = conn.prepareStatement(sqlCommand);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				ontoConcepts.add(rs.getString(1));
			}			 
		 }catch (SQLException e) {
			 e.printStackTrace();
		}			
	  }
	 return ontoConcepts;
 }
 
 public boolean isConnectedToDB(Connection conn)
	{		
		try {
			if (conn != null && (conn.isClosed() == false)) 
				return true;								
					
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;		
	} 
 
	public void disconnectFromDB(Connection conn)
	{
		try {
			if (conn != null && (conn.isClosed() == false)) {
				conn.close();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}		
	}
 
 %>
