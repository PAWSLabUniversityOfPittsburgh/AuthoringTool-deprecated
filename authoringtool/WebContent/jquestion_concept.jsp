<%@ page language="java" %>
<%@ page contentType="text/html; charset=utf8" language="java"
	import="java.io.*, java.util.*, edu.pitt.sis.paws.authoring.beans.*, edu.pitt.sis.paws.authoring.data.Const"
	pageEncoding="utf8"%>
<%@page import="org.apache.catalina.core.ApplicationContext"%>
<%@page import="edu.pitt.sis.paws.authoring.data.Const"%>
<%@ page import="java.sql.*" %>	

<%
int colspan = 3;
boolean displaySysManage = false;
UserBean userBean = (UserBean) session.getAttribute("userBean");
String userBeanName = "";
if (userBean != null)
{
	userBeanName = userBean.getName();
	if (userBean.getGroupBean().getName().equals("admins")) {    
		colspan++;
		displaySysManage = true;
	}
}
else
	response.sendRedirect("index.html?action="+"EXPIRED");

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Authoring Tool</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf8" />
<link href="<%=request.getContextPath()%>/stylesheets/authoring.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=request.getContextPath()%>/stylesheets/treetable.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/stylesheets/EditInPlace.js"></script>
<script type="text/javascript" src="<%=request.getContextPath()%>/stylesheets/starrating.js"></script>
<SCRIPT type="text/javascript" src="<%=request.getContextPath()%>/stylesheets/boxover.js"></SCRIPT>
<script type="text/javascript" src="<%=request.getContextPath()%>/stylesheets/getQuiz.js"></script>
<script type="text/javascript">
function toggleMe(a){
var e=document.getElementById(a);
if(!e)return true;
if(e.style.display=="none"){
e.style.display="block"
}
else{
e.style.display="none"
}
return true;
}
</script>
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
	
	<%
	  Connection conn = getConnectionToWebex21();
	  Statement statement = conn.createStatement();
    %>

<!--  the following script is for using tab.js file as external script source -->
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
		$.post("AddConcept?question="+question+"&count="+count,array, function() {
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
		$.post("SaveIndexing.jsp?question="+question+"&count="+count,array, function() {
			alert("Indexing saved successfully!"); window.location = "jquestion_concept.jsp?question="+question})
		    .success(function() { alert("success"); window.location = "jquestion_concept.jsp"; })
		    .error(function() { alert("error"); window.location = "jquestion_concept.jsp";})
		    .complete(function() { alert("complete"); window.location = "jquestion_concept.jsp"; });	
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
				$.post("DeleteConcept?question="+question+"&concept="+concept,function() {
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
			var result = window.showModalDialog('UpdateConcept.jsp?question='+question+"&concept="+concept, question+","+concept+","+"quiz", 'dialogHeight=300px;dialogWidth=500px');
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
	
	function changelist() {
		var sel = document.getElementById('questionList');
		var question = sel.options[sel.selectedIndex].value;
		if (question == -1)
			return;
		document.location = "jquestion_concept.jsp?question="+question;
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
	
	function disableEnableFormElements(count)
	{
		if (document.getElementById(count+"Selected").checked == false)
		{
			document.getElementById(count+"Weight").disabled = true;
			document.getElementById(count+"Direction").disabled = true;
			document.getElementById(count+"Row").style.color = "gray";
			document.getElementById(count+"hRef").style.visibility = "hidden";
			document.getElementById(count+"ExpandRow").style.display = "none";
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
			document.getElementById(count+"hRef").innerHTML = "+";
			document.getElementById(count+"hRef").href = "javascript:showConceptClass(\""+count+"ExpandRow\",\""+count+"hRef\")";
			document.getElementById(count+"hRef").style.visibility = "visible";
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
	
	function showClassTab(className,tabIndex,lines){ 
        tabPane.setSelectedIndex(tabIndex);
        for (var c in tabsName)
	    {
			var lineCount = tabsLineMap[tabsName[c]];
			for(var i = 0; i <= lineCount; i++)
			{
				document.getElementById(tabsName[c]+i).style.backgroundColor = "";
			}					
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
			   document.getElementById(className+j).style.backgroundColor = "yellow";  
		    }		    
		}
		 document.getElementById(className+temp).scrollIntoView();
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


</head>

<body onload="loadStars()">
<%
String uid = "";

if (userBean == null)
{
	response.sendRedirect("index.html?action="+"EXPIRED");

}
else
{
	ResultSet rs = null;  
	statement = conn.createStatement();
	rs = statement.executeQuery("SELECT id FROM ent_user where name = '"+userBean.getName()+"' ");
	while(rs.next())
	{
		 uid = rs.getString(1);
	}	
}

%>
	<center>
<table width="80%" cellspacing="0" cellpadding="0" align="center">
  <tr> 
    <td class="titlebar">Authoring Tool</td>
  </tr>
  <tr> 
    <td>
    <table width="100%" cellspacing="0" cellpadding="0">  		
<%
	if (userBean.getGroupBean() != null) {
	%>
		<td width="1" class="menubar"><nobr><a class="menu" href="authoring.jsp">Authoring</a></nobr></td>
<%
		if(displaySysManage) {
%>	
		<td width="1" class="menubar"><nobr><a class="menu" href="sysmanage.jsp">System Management</a></nobr></td>
<%
		}
%>
		<td width="*" class="menubar">&nbsp;</td>
		<td width="1" class="menubar"><nobr><a class="menu" href="myaccount.jsp">My Account</a></nobr></td>
<%
	}
%>
		<td width="1" class="rightborder menubar"><nobr><a class="menu" href="SecurityServlet?action=LOGOUT">Logout</a></nobr></td>
  	</table>
  	</td>
  </tr>
  <tr> 
    <td class="mainpage">
<% Map<String,Integer> classTabMap = new HashMap<String,Integer>();	
   Map<String, Integer> classLineMap = new HashMap<String,Integer>();
   List<String> ontoConcepts = getOntologyConcepts();
   List<String> allClass = new ArrayList<String>();
   String question = request.getParameter("question");  
 %>
 <h3>Please select the question you'd like to index:</h3>
 
	<table width="100%">	
	    
		<tr >
		
			<td class = 'formfieldlight' colspan="2">Question Name:&nbsp;&nbsp;&nbsp;
			<select name="questionList" id="questionList" onChange=Javascript:changelist(); style = "font-size: 1.0em" >
					<%
						boolean isSelected = false;
					    PreparedStatement pstmt = null;
						ResultSet questionsRs = null;
						try {
							 conn = getConnectionToWebex21();
							 if (isConnectedToDB(conn))
							 {
								String query = "SELECT distinct(q.Title),q.rdfID FROM webex21.ent_jquiz q where (q.privacy = 1 or q.authorid = "+uid+") order by q.Title";
								pstmt = conn.prepareStatement(query);
								questionsRs = pstmt.executeQuery();
								int row = 0;
								out.write("<option selected value='-1'>Please select the question </option>");
								while (questionsRs.next()) {
									isSelected = false;
									if (questionsRs.getString(1).equals(question))
										isSelected = true;
									if (isSelected)
										out.write("<option selected value='"+questionsRs.getString(2)+"'>" + (++row) + " - " + questionsRs.getString(1) + "</option>");
									else
										out.write("<option value='"+questionsRs.getString(2)+"'>"+ (++row) + " - " + questionsRs.getString(1) + "</option>");
								}
							}
       					} catch (SQLException e) {
							e.printStackTrace();
						} finally {
							try {
								if (questionsRs != null)
									questionsRs.close();
								if (pstmt != null)
									pstmt.close();
								disconnectFromDB(conn);
							} catch (Exception e) {
								disconnectFromDB(conn);
								e.printStackTrace();
							}
						}
					%>
			</select></td>
		</tr>
		<% int count = 0;
		if (question != null)
			  { %>		
		<tr>
		<td valign="top" >
		<div class="webfx-main-body">
<!-- begin tab pane -->
<div class="tab-pane" id="tabpane" style="height:507px;width:470px;overflow:auto;border-style:solid;border-width:1px; border-color:rgb(120,172,255);padding: 10px">
<script type="text/javascript">
tabPane = new WebFXTabPane( document.getElementById( "tabpane" ), false );
</script>
<%	
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
ResultSet rs2 = null;
ResultSet quizRs = null;
try
{
	 conn = getConnectionToWebex21();
	 if (isConnectedToDB(conn))
	 {
		statement = conn.createStatement();  

	    Blob photo = null;
	    int min=0;
	    int QuizID=0;    
	    // for recognizing which type of question (1=class)
	    flag=0;
	    
	    String query = "select QuizID,Code,MinVar,QuesType from ent_jquiz where  rdfID = '"+question+"'";      
	    quizRs = statement.executeQuery(query);
	      
	      while (quizRs.next()) {
	        photo = quizRs.getBlob("Code");        
	        min = quizRs.getInt("MinVar");
	        QuizID = quizRs.getInt("QuizID");
	        QuesType = quizRs.getInt("QuesType");
	      }
	     
	      in = photo.getBinaryStream();
	      length = (int) photo.length();

	      bufferSize = 1024;
	      buffer = new byte[bufferSize];    
	      P = min;            
	      position=0;
	      codepart="";
	          
	      //check multiple classes, get class name
	      String sql = "select * from rel_quiz_class where QuizID = '"+QuizID+"' ";      
	      int ClassID=0;
	    		      	    
	       rs1 = statement.executeQuery(sql);     
	       while (rs1.next()) { 
	    	   ClassID=rs1.getInt("ClassID");						
	    	   flag=1;
	       }
	    			    
	       String sql2 = "select * from ent_class c, rel_quiz_class r where c.ClassID = r.ClassID and r.QuizID= '"+QuizID+"' ";      
	       fileName = new ArrayList<String>();
	       rs2 = statement.executeQuery(sql2);  
	       String className;
	       while (rs2.next()) { 
	    	   className = rs2.getString("ClassName");
	    	   fileName.add(className);
	       	if (className.substring(0,1).equals("0") |
	       		className.substring(0,1).equals("1"))
	       		className = className.substring(2,className.length()); 
	       	allClass.add(className);
	       }
	       allClass.add("Tester.java"); // this class always exists and is not in the query result
	       Collections.sort(allClass);
	}    
	
}catch (SQLException e) {
	e.printStackTrace();
} finally {
	try {
		if (quizRs != null)
			quizRs.close();
		if (rs1 != null)
			rs1.close();
		if (rs2 != null)
			rs2.close();
		if (pstmt != null)
			pstmt.close();
		disconnectFromDB(conn);
	} catch (Exception e) {
		disconnectFromDB(conn);
		e.printStackTrace();
    }
}
    
    
int tabNumer = 0;
classTabMap.put("Tester.java",tabNumer); //add first tab
%>      
<!-- begin intro page -->
<div class="tab-page" id="Tester.java">   
<h2 class="tab">Tester Class</h2>

<pre style="white-space:pre-wrap; font-size: 11px"><%   
        //String processing
        String breakline_text="";	
        int linecount = 0;

	      while ((length = in.read(buffer)) != -1) {	
	        StringBuffer text = new StringBuffer(new String(buffer));	        
	        linecount = 0;
	        int loc = (new String(text)).indexOf('\n',position);        		                	        
	        while(loc >= 0){    
		            //text.replace(loc, loc+1,"");		            
		            loc = (new String(text)).indexOf('\n',position);		            
		            String line = "";
		            if (loc>position){	   
		            
		            	line = text.substring(position,loc);	            	
				int  b = line.indexOf("_Param");
				int  b2 = line.lastIndexOf("_Param");
				if (b>0 && b==b2){				
					line= line.substring(0,b) + P + line.substring(b+6);					
					}					
				else if(b>0 && b2>b){
					line= line.substring(0,b) + P + line.substring(b+6,b2) + P +line.substring(b2+6);
				}										
				//for Question Type 3
				if (QuesType !=3 ){
					codepart+=line;  //add up for the compiling file
					
					//2008.09 fix ArrayList<TYPE>
					char[] chars = line.toCharArray();
					StringBuffer buffer1 = new StringBuffer(chars.length);	
					for (int index = 0; index < chars.length; index++) {
					      	char ch1 = chars[index];	      	
					      	if (ch1 == '<')
					      	{   buffer1.append("&lt;");
					      	}else{
		        			    buffer1.append(ch1);
		        			}				 	      
				        }
				        line = buffer1.toString();	
				        out.print("<div id='Tester.java"+linecount+"' >"+linecount+"   "+line+"</div>"); //print each line of the program question
					    linecount = linecount + 1;
				}	           		            			            			   		            			   				
		            			            	
		            	//codepart+=line;	move it up to the else bracket            	
		            }	
		            else
					{
						line = text.substring(position, position+1);
				        out.print("<div id='Tester.java"+linecount+"' >"+linecount+"   "+line+"</div>"); //print each line of the program question
					    linecount = linecount + 1;
					}
		            position=loc+1;	    
	         }
		    classLineMap.put("Tester.java",linecount-1);
	      }

%> 

</pre>
</div>
<!-- end intro page -->      

<%
if(flag==1){ 
	String RealFileName = "";
	for(int j=0;j<fileName.size();j++){
		tabNumer++;
		if(fileName.get(j).substring(0,1).equals("0") |
		   fileName.get(j).substring(0,1).equals("1"))
			RealFileName = fileName.get(j).substring(2,fileName.get(j).length());        	     			   		
	    else
	       RealFileName = fileName.get(j);
	classTabMap.put(RealFileName, tabNumer); //add this tab
	%>
	<!-- begin usage page -->
	<div class="tab-page" id="<%=RealFileName%>">    
    <h2 class="tab"><%=RealFileName%></h2>	
	<pre style="white-space:pre-wrap;font-size: 11px"><%
	try {
		ServletContext context = getServletContext();
		InputStream fstream = context.getResourceAsStream(Const.PATH.CLASS_RELATIVE_PATH+fileName.get(j));
        in = new DataInputStream(fstream);
		BufferedReader br = new BufferedReader(new InputStreamReader(in));
		String strLine;
		int line = -1;
		while ((strLine = br.readLine()) != null) {
		    line++;
			out.println("<div id='"+RealFileName+line+"'>"+line+"   "+strLine+"</div>");
		}		
		in.close();
		classLineMap.put(RealFileName,line);

	} catch (Exception e) {
		e.printStackTrace();} 	  	    	    		    	
	%>
	</pre>
	</div>
	<!-- end usage tab -->
<%
}
}
%>		

</div></div>
		</td>
		<td valign="top">		
		<Form name=indexForm action="SaveIndexing.jsp?question=<%=question%>" method="post"  style = "border-style:solid;border-width:1px; border-color:rgb(120,172,255);padding: 10px;margin:  10px 0px 10px 0px;">
		
<div style="height:420px;width:550px;overflow:auto;border-style:solid;border-width:1px; border-color:rgb(120,172,255);padding: 10px;white-space:pre-wrap;">
<table id = 'conceptTable' class = 'formfieldlight' >
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
		String query = "select distinct concept from ent_jquiz_concept where title = '"+ title + "' order by concept ASC";
		conceptRs = statement.executeQuery(query);
		while (conceptRs.next()) 
			concepts.add(conceptRs.getString(1));		
		%> 	    
		<tr><td valign="baseline" colspan="7"><input type="checkbox" checked="checked" value="on" id="selectAll" name="selectAll" onclick="checkAll();" align="left"> Select All <%=concepts.size() %> concepts
		</td></tr>
		<%
		count = 0;
		for (String c : concepts)
		{
	    %>
	    <tr id='<%=count+"Row"%>'>
	    <td><%=count+1%> </td>
	    <td><input type=checkbox onclick="disableEnableFormElements(<%=count%>);" checked='checked' id='<%=count+"Selected"%>' name='<%=count+"Selected"%>' align="left"></td>
	    <td><a id ='<%=count+"hRef"%>' href="javascript:showConceptClass('<%=count+"ExpandRow"%>','<%=count+"hRef"%>')">+</a><%=c%>&nbsp;&nbsp;</td>
		<%	query = "select weight,direction from ent_jquiz_concept where title ='"+title+"'"+" and concept = '"+c+"'"; 
		    weightDirectionRs = statement.executeQuery(query);
			String direction = "";
			String weight = "";
			while(weightDirectionRs.next())
			{
				weight = weightDirectionRs.getString(1);
				direction = weightDirectionRs.getString(2);	
			}
		%>		
		 <td><select id='<%=count+"Weight"%>' name = '<%=count+"Weight"%>' style="font-size: 1.0em">

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
		<td><select id='<%=count+"Direction"%>' name = '<%=count+"Direction"%>' style="font-size: 1.0em">
		 <% if (direction.equals("prerequisite")){ %>
		    <option value='prerequisite' selected>Prerequisite</option>
		    <option value='outcome'>Outcome</option>
		    
	      <% } else if (direction.equals("outcome")) { %>
	      	 <option value='prerequisite'>Prerequisite</option>	      
	         <option value='outcome' selected>Outcome</option>
	         <%} %>
	      </select></td>
	      
	      <td><img src="images/edit.png" id = '<%=count %>editImg' concept = '<%=c%>' question='<%=question%>' fn = 'edit' ></td>	      
	      <td><img src="images/delete.png" id = '<%=count %>deleteImg' concept = '<%=c%>' question='<%=question%>' fn = 'delete' ></td>
	      
	     </tr>
	     <% 
	      String lines = "";
		  String classLinksHtml = "";
		  query = "select distinct class from ent_jquiz_concept where title = '"+ title + "' and concept = '"+c+"'" ;
		  classRs = statement.executeQuery(query);
		  String curClass;
		  Statement stmt;
		  while (classRs.next())
		  {  
			  lines = "";
			  curClass = classRs.getString(1);
		      query = "select sline,eline from ent_jquiz_concept where title = '"+ title + "' and class = '"+curClass+"' and concept = '"+c+"' and sline != -1 and eline !=-1";
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
            	  classLinksHtml += "<a style=\"float:left;\" href='javascript:showClassTab(\""+curClass+"\","+classTabMap.get(curClass)+",\""+lines+"\")"+"'>"+" "+curClass+" "+"</a>";  
              else
            	  classLinksHtml += "<a style=\"float:left;\" href='javascript:showTab("+classTabMap.get(curClass)+")"+"'>"+" "+curClass+" "+"</a>";  

		  } %>
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
			if (pstmt != null)
				pstmt.close();
			disconnectFromDB(conn); //here connection is closed
		} catch (Exception e) {
			disconnectFromDB(conn); //here connection is closed
			e.printStackTrace();
		}} 		
		}%>		
	
	</table>
</body>
<script>
	var tabsName = new Array();
	<%for (String tab : classTabMap.keySet()){%>
	       tabsName.push("<%=tab%>");
	<%}%>
	var tabsLineMap = new Array();
	<%for (String tab : classLineMap.keySet()){%>
	       tabsLineMap["<%=tab%>"]="<%=classLineMap.get(tab)%>";
    <%}%>

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
	     	

</body> 
</html>