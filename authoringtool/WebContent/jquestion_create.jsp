<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>
<%@ include file = "include/connectDB.jsp" %>

<!-- hyun{ -->
<%@ page import="java.sql.*" %>
<%@page import="java.io.*"%>
<%@page import="java.net.URL"%>

<%
    Connection conn2 = null;
   
    ResultSet rs1 = null;
    Statement stmts = null;
    ResultSetMetaData rsmds = null;   	
   
    String sc="";       	
    Class.forName(this.getServletContext().getInitParameter("db.driver"));
    conn2 = DriverManager.getConnection(this.getServletContext().getInitParameter("db.webexURL"),this.getServletContext().getInitParameter("db.user"),this.getServletContext().getInitParameter("db.passwd"));
    
     try {

        stmts = conn2.createStatement();
        rs1 = stmts.executeQuery("SELECT * FROM ent_class");        
     }
     catch (SQLException e) {
         System.out.println("Error occurred " + e);
     }

%>
<!--  }hyun -->
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
<!--hyun*  script src="<%=request.getContextPath()%>/js/jquery1.4.2.js"></script>-->
<!-- hyun{ -->
<link rel="stylesheet" href="<%=request.getContextPath()%>/js/themes/base/jquery-ui.css" />
<script src="<%=request.getContextPath()%>/js/jquery-1.9.1.js"></script>
<script src="<%=request.getContextPath()%>/js/ui/jquery-ui.js"></script>
<script src="<%=request.getContextPath()%>/js/ajaxfileupload.js"></script>
<!-- }hyun -->

<script type="text/javascript">
// hyun{
function ajaxFileUpload(){      
    /*
        prepareing ajax file upload
        url: the url of script file handling the uploaded files
                    fileElementId: the file type of input element id and it will be the index of  $_FILES Array()
        dataType: it support json, xml
        secureuri:use secure protocol
        success: call back function when the ajax complete
        error: callback function when the ajax failed
        
    */
    $.ajaxFileUpload
    (
        {
            url:'single_upload_page2.jsp', 
            secureuri:false,
            fileElementId:'fileToUpload',
            dataType: 'json',
            success: function (data, status)
            {
                if(typeof(data.error) != 'undefined')
                {
                    if(data.error != '')
                    {
                        alert(data.error);
                    }else
                    {
                        alert(data.filename);
                        addItemToList(data.filename,data.fileid);
                    }
                }
            },
            error: function (data, status, e)
            {
                alert(e);
            }
        }
    );
    
    return false;

} 

function addItemToList(filename,fileid){
	var content = $( "#class-file-list" ).html();
	var added = "<input type=\"checkbox\" class=\"import-classes-list-item\" name=\"import-classes\" value=\""+fileid+"\">" +
				"<input type=\"hidden\" id=\""+fileid+"\" name=\""+fileid+"\" value=\""+filename+"\">" +
				"<a class=\"import-classes-list-item\" href='http://adapt2.sis.pitt.edu/quizjet/class/"+filename+"' target='_blank'>"+filename+"</a><br />";	  		  	


	$( "#class-file-list" ).html(added+content);
	return false;
}
//}hy

$(document).ready(function(){
	$("input").click(function () {
		var fn = $(this).attr('fn');
		if (fn == 'createQuiz')
		{
			var title1 = document.fr1.title1.value;	
			if(title1 == ""){alert("Title cannot be empty!"); return false;}	
			else if (!document.fr1.privacy1[0].checked && !document.fr1.privacy1[1].checked){alert("Please select the privacy."); return false;}	
			else {   		
				if (title1!="" && (document.fr1.privacy1[0].checked || document.fr1.privacy1[1].checked) && i==1) 
				{$("#fr1").submit(); return true;}
		      	}
		}
		else if (fn == 'createQuestion')
		{
		    var quizval = document.getElementById("quiz").value;
		    var title2 = document.fr2.title2.value;	
   		    title2 = title2.replace(/\s+/g, '');

			var quizcode = document.fr2.quizcode.value;	
			var tmpCode =quizcode;	
			tmpCode = tmpCode.replace(/\s+/g, '');

			var minvar = document.fr2.minvar.value;	
			var maxvar = document.fr2.maxvar.value;	
			var rdf = document.fr2.rdfID.value;
			var tmpRdf = rdf;
			tmpRdf = tmpRdf.replace(/\s+/g, '');
			if (quizval== "-1")
			{
			alert("Please select topic for the question."); return false;
			}
			else if(title2 == ""){alert("Title cannot be empty!"); return false;}
			else if(tmpRdf == ""){alert("RDF ID cannot be empty!");return false;}
			else if(tmpCode == ""){alert("Code cannot be empty!");return false;}
			else if(minvar == "")
			{
				if (minvar == "")
				{
				alert("Minimum Variable cannot be empty!");
				return false;
				}
			}
			else if(maxvar == "" || (maxvar.match(/^\d+$/)==false))
			{
				if (maxvar == "")
				{
				alert("Maximum Variable cannot be empty!");
				return false;
				}
			}
			else if (!document.fr2.privacy2[0].checked && !document.fr2.privacy2[1].checked){alert("Please select the privacy."); return false;}
			else {
				if (isNaN(minvar))
					{
					alert("Minimum Variable should be an integer.");
					return false;
					}
				else if (isNaN(maxvar))
					{
					alert("Maximum Variable should be an integerr.");
					return false;
					}
				else 
				{
					 var invalid = false;
	    			 for (var index in rdfs)
	    		     {
	    				 if (rdfs[index] ==rdf)
	    					 invalid = true;
	    			 }
	    			 if (invalid)
	    			 {
	    				 alert("RDF ID already exists. Please enter another value.");
	    				 return false;    				 
	    			 }
	    			 
	    			 else
	    			 {   				 
 	    				    		$("#fr2").submit();
 	    				    		return true;

 						//hyun{  	
	    				// var mydata = { code:quizcode, 'importclasses' : $("#imported-classes-label").html(), minvar:minvar};
	    				// $.post("CompileCodeServlet",mydata,function(data) {
	    				 //$.post("TESTpost.jsp",mydata,function(data) {
	    				 //hy* $.post("CompileCodeServlet",{code:quizcode},function(data) {
	    				    //	 var err = data.message;

	    				    	// if (err != '')
	    				    	// {
	    				    	//	alert("Code cannot be compiled due to following errors:\n"+err);   
	    				    	//	return false;
	    				    	 //}
	    				    	 //else
	    				    	 //{  
	    				    	//	$("#fr2").submit();//submit those in a form
	    				    	//	return true;
	    				       //  }
	    				    //}, "json");    				    	 	   
	    			 //}hyun
	    			 }
				}
			}
		}

	});	
	    				 
	//hyun{
	function selectedClasses() {
	          // alert("imporing....");
	          var classesstr = "";
	          var classesvals = "";
	          $('input[name="import-classes"]:checked').each(function() {
   				classesstr += " " + $('#'+this.value).val();
   				classesvals += " " + this.value;
			  });
	          $("#imported-classes-label").html(classesstr);
	          $("#import-classes-vals").val(classesvals);
	          $("#import-classes-names").val(classesstr);
	}	
		
	$( "#import-classes-dialog" ).dialog({
	      autoOpen: false,
	      height: 500,
	      width: 700,
	      modal: true,
	      buttons: {
	        "Ok": function() {
	          selectedClasses();
	          $( this ).dialog( "close" );
	        }

	      },
	      close: function() {
	        //
	    	  selectedClasses();
	      }
	});
	
	$("#add-file-button").click(function (){
		var content = $( "#class-file-list" ).html();
		var added = "new class<br />";
		$( "#class-file-list" ).html(added+content);
		return false;
	});
	

	
	$("#import-classes-button").click(function () {
		$( "#import-classes-dialog" ).dialog("open");
	});
	
	//}hyun
});	
</script>

<script type="text/javascript">
<!-- 


	
function function3(obj,i){ 	
   if (i==1) 
   {window.open('classcombo.jsp','_blank');}
   }
//-->
</script>


<%
stmt = conn.createStatement();
String command = "select rdfID from ent_jquiz;";
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
<%

     String uid = "";
     Statement statement = conn.createStatement();
     rs = statement.executeQuery("SELECT id FROM ent_user where name = '"+userBeanName+"' ");
     while(rs.next())
	 {
    	 uid = rs.getString(1);
	 }
 %>
<table>

<tr><td><h3>Create Java Question:</h3></td></tr>
   <tr> 
   <td>	
   <form name="fr2" id  ="fr2"  method="post" action = "javaq_create_save2.jsp">
    <!-- hyun{ request.getParameter("import-classes-names") -->
    <input type="hidden" name="import-classes-vals" id="import-classes-vals" value="" />
    <input type="hidden" name="import-classes-names" id="import-classes-names" value="" />
    <!-- }hyun -->
   
   	<table>
	<tr>
		<td class="formfieldbold formfielddark"><b>Topic:<font color="red">*</font></b>	</td>
		<td><select name="quiz" id = "quiz">
		<%
			statement = conn.createStatement();
		  	out.write("<option value='-1' selected>Please select the topic</option>");

			 rs = statement.executeQuery("SELECT q.QuestionID,q.Title,q.Privacy,q.authorid FROM ent_jquestion q where (q.Privacy = '1' or q.authorid = "+uid+") order by q.title");
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
		<td class="formfieldbold formfielddark"><b>Title:<font color="red">*</font></b>	</td>
		<td><input type="text" name="title2" size="45" maxlength="45"></td>
	</tr>
	<tr>
		<td class="formfieldbold formfielddark"><b>RDF ID:<font color="red">*</font></b>	</td>
		<td><input type="text" name="rdfID" size="45" maxlength="45"></td>
	</tr>	
	<tr>
		<td class="formfieldbold formfielddark"><b>Description:	</b></td>
		<td><textarea  name="description2" cols="80" rows="3"></textarea></td>
	</tr>
	<tr>
		<td class="formfieldbold formfielddark"><b>AssessmentType:	</b></td>
		<td><select name="questiontype" onChange="Javascript:type_change();">
			<option value="1">final value</option>
			<option value="2">output</option>
			</select>
		  <!-- hy*
		  <input type="button" value="Import Classes" onclick="function3(this.form,1);"><br>
		   -->  	
		   <!-- yun{ -->   
		    <input id="import-classes-button" type="button" value="Import Classes" /> <br />
		    <div id="imported-classes-label" class=""></div> 
		    <!-- }yun -->
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
			<option value="3">int</option>
			<option value="5">float</option>
			<option value="7">String</option>
			<option value="8">double</option>
		</select></td>
	</tr>
	
	<tr>
		<td class="formfieldbold formfielddark"><b>Privacy:<font color="red">*</font></b></td>
		<td class="formfieldlight"><input type="RADIO" name="privacy2" value="private">Private <input type="RADIO" name="privacy2" value="public" checked>Public</td>
	</tr>
	<tr>
		<td></td>
		<td><input type="button" value="Create" fn = 'createQuestion'>&nbsp;&nbsp;<input type="reset" value="Clear" OnClick="document.form.message.focus()"></td>		
	</tr>

	</table>
	   <!-- hyun{: seems not to receive parameters here from form-->
	<div id="import-classes-dialog">
	<table border="0" cellpadding="5">
		<tr>
		<td style="width:50%;"><h3>Select classes:</h3>
		<div id="class-file-list">
	<%
			int colcount=0;
			int totalcount=0;
			while(rs1.next())
			  {
				//hy:
				String className = rs1.getString("ClassName");
			    String realClassName = className.replaceAll("\\s+", "");
			    //TODO: check in detail: make sure the classname is legal by java, and standard by our definition
			    if (realClassName.length() == 0 || realClassName.equals("") || realClassName.equals("\"\"") || realClassName.equals("''"))
			    	continue;
				colcount++;
				if (false){
				if (colcount==4){
					//input-classes-cell is the new style defined in stylesheets/authoring.css
					out.write("<td class=\"input-classes-cell\"><input type=\"checkbox\" name=\"import-classes\" value=\""+rs1.getString("ClassID")+"\">");
					out.write("<input type=\"hidden\" id=\""+rs1.getString("ClassID")+"\" name=\""+rs1.getString("ClassID")+"\" value=\""+rs1.getString("ClassName")+"\">");
					out.write("<a href='http://adapt2.sis.pitt.edu/quizjet/class/"+rs1.getString("ClassName")+"' target='_blank'>"+rs1.getString("ClassName")+"</a>&nbsp;&nbsp;");	  	
					out.write("<a href='http://adapt2.sis.pitt.edu/quizjet/class/"+rs1.getString("ClassTester")+"' target='_blank'></a></td></tr><tr>");
					colcount=0;
				}else{
					out.write("<td class=\"input-classes-cell\"><input type=\"checkbox\" name=\"import-classes\" value=\""+rs1.getString("ClassID")+"\">");
					out.write("<input type=\"hidden\" id=\""+rs1.getString("ClassID")+"\" name=\""+rs1.getString("ClassID")+"\" value=\""+rs1.getString("ClassName")+"\">");
					out.write("<a href='http://adapt2.sis.pitt.edu/quizjet/class/"+rs1.getString("ClassName")+"' target='_blank'>"+rs1.getString("ClassName")+"</a>&nbsp;&nbsp;");	  		  	
					out.write("<a href='http://adapt2.sis.pitt.edu/quizjet/class/"+rs1.getString("ClassTester")+"' target='_blank'></a></td>");
				}
				}
				out.write("<input type=\"checkbox\" class=\"import-classes-list-item\" name=\"import-classes\" value=\""+rs1.getString("ClassID")+"\">");
				out.write("<input type=\"hidden\" id=\""+rs1.getString("ClassID")+"\" name=\""+rs1.getString("ClassID")+"\" value=\""+rs1.getString("ClassName")+"\">");
				out.write("<a class=\"import-classes-list-item\" href='http://adapt2.sis.pitt.edu/quizjet/class/"+rs1.getString("ClassName")+"' target='_blank'>"+rs1.getString("ClassName")+"</a><br />");	  		  	
				
				totalcount++;
			  }				  
		%>
		</div>
		</td>
		<td style="vertical-align:top;"><h3>Upload classes:</h3>
		<!-- hyun input id="add-file-button" type="button" value="Add File" onclick="addFile();" /><br /> -->
		<input id="fileToUpload" type="file" size="45" name="fileToUpload" class="input" /><br />
		<button class="button" id="buttonUpload" onclick="return ajaxFileUpload();">Upload</button>
		</td>
	    </tr>
	 </table>
	 
	</div>
	<!-- }hyun -->
</form>

   </td></tr>
</table>   

