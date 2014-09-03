<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>
<%@ include file = "include/connectDB.jsp" %>
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
	<script type="text/javascript">		
	
		
	var fromBoxArray = new Array();
	var toBoxArray = new Array();
	var selectBoxIndex = 0;
	var arrayOfItemsToSelect = new Array();
		
		
	function moveSingleElement()
	{
		var selectBoxIndex = this.parentNode.parentNode.id.replace(/[^\d]/g,'');
		var tmpFromBox;
		var tmpToBox;
		if(this.tagName.toLowerCase()=='select'){			
			tmpFromBox = this;
			if(tmpFromBox==fromBoxArray[selectBoxIndex])tmpToBox = toBoxArray[selectBoxIndex]; else tmpToBox = fromBoxArray[selectBoxIndex];
		}else{
		
			if(this.value.indexOf('>')>=0){
				tmpFromBox = fromBoxArray[selectBoxIndex];
				tmpToBox = toBoxArray[selectBoxIndex];			
			}else{
				tmpFromBox = toBoxArray[selectBoxIndex];
				tmpToBox = fromBoxArray[selectBoxIndex];	
			}
		}
		
		for(var no=0;no<tmpFromBox.options.length;no++){
			if(tmpFromBox.options[no].selected){
				tmpFromBox.options[no].selected = false;
				tmpToBox.options[tmpToBox.options.length] = new Option(tmpFromBox.options[no].text,tmpFromBox.options[no].value);
				
				for(var no2=no;no2<(tmpFromBox.options.length-1);no2++){
					tmpFromBox.options[no2].value = tmpFromBox.options[no2+1].value;
					tmpFromBox.options[no2].text = tmpFromBox.options[no2+1].text;
					tmpFromBox.options[no2].selected = tmpFromBox.options[no2+1].selected;
				}
				no = no -1;
				tmpFromBox.options.length = tmpFromBox.options.length-1;
											
			}			
		}
		
		
		var tmpTextArray = new Array();
		for(var no=0;no<tmpFromBox.options.length;no++){
			tmpTextArray.push(tmpFromBox.options[no].text + '___' + tmpFromBox.options[no].value);			
		}
		tmpTextArray.sort();
		var tmpTextArray2 = new Array();
		for(var no=0;no<tmpToBox.options.length;no++){
			tmpTextArray2.push(tmpToBox.options[no].text + '___' + tmpToBox.options[no].value);			
		}		
		tmpTextArray2.sort();
		
		for(var no=0;no<tmpTextArray.length;no++){
			var items = tmpTextArray[no].split('___');
			tmpFromBox.options[no] = new Option(items[0],items[1]);
			
		}		
		
		for(var no=0;no<tmpTextArray2.length;no++){
			var items = tmpTextArray2[no].split('___');
			tmpToBox.options[no] = new Option(items[0],items[1]);			
		}
	}
	
	function sortAllElement(boxRef)
	{
		var tmpTextArray2 = new Array();
		for(var no=0;no<boxRef.options.length;no++){
			tmpTextArray2.push(boxRef.options[no].text + '___' + boxRef.options[no].value);			
		}		
		tmpTextArray2.sort();		
		for(var no=0;no<tmpTextArray2.length;no++){
			var items = tmpTextArray2[no].split('___');
			boxRef.options[no] = new Option(items[0],items[1]);			
		}		
		
	}
	function moveAllElements()
	{
		var selectBoxIndex = this.parentNode.parentNode.id.replace(/[^\d]/g,'');
		var tmpFromBox;
		var tmpToBox;		
		if(this.value.indexOf('>')>=0){
			tmpFromBox = fromBoxArray[selectBoxIndex];
			tmpToBox = toBoxArray[selectBoxIndex];			
		}else{
			tmpFromBox = toBoxArray[selectBoxIndex];
			tmpToBox = fromBoxArray[selectBoxIndex];	
		}
		
		for(var no=0;no<tmpFromBox.options.length;no++){
			tmpToBox.options[tmpToBox.options.length] = new Option(tmpFromBox.options[no].text,tmpFromBox.options[no].value);			
		}	
		
		tmpFromBox.options.length=0;
		sortAllElement(tmpToBox);
		
	}
	
	
	/* This function highlights options in the "to-boxes". It is needed if the values should be remembered after submit. Call this function onsubmit for your form */
	function multipleSelectOnSubmit()
	{
		for(var no=0;no<arrayOfItemsToSelect.length;no++){
			var obj = arrayOfItemsToSelect[no];
			for(var no2=0;no2<obj.options.length;no2++){
				obj.options[no2].selected = true;
			}
		}
		
	}
	
	function createMovableOptions(fromBox,toBox,totalWidth,totalHeight,labelLeft,labelRight)
	{		
		fromObj = document.getElementById(fromBox);
		toObj = document.getElementById(toBox);
		
		arrayOfItemsToSelect[arrayOfItemsToSelect.length] = toObj;

		
		fromObj.ondblclick = moveSingleElement;
		toObj.ondblclick = moveSingleElement;

		
		fromBoxArray.push(fromObj);
		toBoxArray.push(toObj);
		
		var parentEl = fromObj.parentNode;
		
		var parentDiv = document.createElement('DIV');
		parentDiv.className='multipleSelectBoxControl';
		parentDiv.id = 'selectBoxGroup' + selectBoxIndex;
		parentDiv.style.width = totalWidth + 'px';
		parentDiv.style.height = totalHeight + 'px';
		parentEl.insertBefore(parentDiv,fromObj);
		
		
		var subDiv = document.createElement('DIV');
		subDiv.style.width = (Math.floor(totalWidth/2) - 15) + 'px';
		fromObj.style.width = (Math.floor(totalWidth/2) - 15) + 'px';

		var label = document.createElement('SPAN');
		label.innerHTML = labelLeft;
		subDiv.appendChild(label);
		
		subDiv.appendChild(fromObj);
		subDiv.className = 'multipleSelectBoxDiv';
		parentDiv.appendChild(subDiv);
		
		
		var buttonDiv = document.createElement('DIV');
		buttonDiv.style.verticalAlign = 'middle';
		buttonDiv.style.paddingTop = (totalHeight/2) - 50 + 'px';
		buttonDiv.style.width = '30px';
		buttonDiv.style.textAlign = 'center';
		parentDiv.appendChild(buttonDiv);
		
		var buttonRight = document.createElement('INPUT');
		buttonRight.type='button';
		buttonRight.value = '>';
		buttonDiv.appendChild(buttonRight);	
		buttonRight.onclick = moveSingleElement;	
		
		//var buttonAllRight = document.createElement('INPUT');
		//buttonAllRight.type='button';
		//buttonAllRight.value = '>>';
		//buttonAllRight.onclick = moveAllElements;
		//buttonDiv.appendChild(buttonAllRight);		
		
		var buttonLeft = document.createElement('INPUT');
		buttonLeft.style.marginTop='10px';
		buttonLeft.type='button';
		buttonLeft.value = '<';
		buttonLeft.onclick = moveSingleElement;
		buttonDiv.appendChild(buttonLeft);		
		
		//var buttonAllLeft = document.createElement('INPUT');
		//buttonAllLeft.type='button';
		//buttonAllLeft.value = '<<';
		//buttonAllLeft.onclick = moveAllElements;
		//buttonDiv.appendChild(buttonAllLeft);
		
		var subDiv = document.createElement('DIV');
		subDiv.style.width = (Math.floor(totalWidth/2) - 15) + 'px';
		toObj.style.width = (Math.floor(totalWidth/2) - 15) + 'px';

		var label = document.createElement('SPAN');
		label.innerHTML = labelRight;
		subDiv.appendChild(label);
				
		subDiv.appendChild(toObj);
		parentDiv.appendChild(subDiv);		
		
		toObj.style.height = (totalHeight - label.offsetHeight) + 'px';
		fromObj.style.height = (totalHeight - label.offsetHeight) + 'px';

			
		selectBoxIndex++;
		
	}			
	</script>




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

<%	Connection connection = null;
Class.forName(this.getServletContext().getInitParameter("db.driver"));
connection = DriverManager.getConnection(this.getServletContext().getInitParameter("db.webexURL"),this.getServletContext().getInitParameter("db.user"),this.getServletContext().getInitParameter("db.passwd"));
	Statement statement = connection.createStatement();
	String uid = "";
    ResultSet rs = null;  
    rs = statement.executeQuery("SELECT id FROM ent_user where name = '"+userBeanName+"' ");
    while(rs.next())
	 {
   	 uid = rs.getString(1);
	 }
 %>
     	

<h3>Modify Java Question:</h3>
<form name="jquizmodify" method="post" onsubmit="multipleSelectOnSubmit()">

<table style="width: 100%">
	<tr>
	<td >
		<table>
		<tr>
			<td class="formfieldbold formfielddark"><b>Topic:<font color="red">*</font></b>	</td>
			<td><select name="question" id = "question">
			<%
				 ResultSet rs2 = null;  
				 rs2 = statement.executeQuery("SELECT q.QuestionID,q.Title,q.Privacy FROM ent_jquestion q, ent_user u where (q.Privacy = '1' or u.name='"+userBeanName+"') and q.AuthorID=u.id order by q.title");

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
				  	           out.write("<option value='"+rs2.getString(1)+"' style=background-color:#A9A9D5 selected>"+rs2.getString(2)+"</option>");			  	        			  	      
				  	        }else{
				  	           out.write("<option value='"+rs2.getString(1)+"' style=background-color:#A9A9D5>"+rs2.getString(2)+"</option>");			  	        			  	      
				  	        }
				  	}
				  }				
			%>			
			</select></td>
		</tr>	
		
		<%
				 ResultSet rs4 = null;  
				 rs4 = statement.executeQuery("SELECT distinct * FROM ent_jquiz where QuizID='"+request.getParameter("qid")+"' and (privacy = 1 or authorid = "+uid+") ");
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
				String Qtype[] = new String[2];			
				Qtype[0]="final value";
				Qtype[1]="output";					
				for (int a=0;a<Qtype.length;a++){	
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
		</tr>	
		<tr>
			<td class="formfieldbold formfielddark"><b>Answer Type:</b>	</td>
			<td><select name="anstype">			
				<%
				String type[] = new String[5];			
				type[0]="";
				type[1]="int";
				type[2]="float";
				type[3]="String";
				type[4]="double";
				for (int a=0;a<type.length;a++){						
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
	<td>
	
		<!--  
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
				<input type="hidden" name = "quiz" value="<%=request.getParameter("qid")%>" >
				
	
</form>
<br>


<script language="JavaScript">
<!-- 

function submitFunction(obj,i) {
   if (i==1) obj.action="jquiz_modify_retrieve.jsp?msg=0";
   if (i==2) {
	   
	var quizval = document.getElementById("question").value;
    var title2 = document.jquizmodify.title2.value;	
	var quizcode = document.jquizmodify.quizcode.value;	
	var minvar = document.jquizmodify.minvar.value;	
	var maxvar = document.jquizmodify.maxvar.value;	
	
	
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
	else if (!document.jquizmodify.privacy2[0].checked && !document.jquizmodify.privacy2[1].checked){alert("Please select Privacy!");}
	else {
		obj.action="jquiz_modify_save.jsp";
	}    
   }
	obj.submit();
}
//-->
</script> 


</body> 
</html>