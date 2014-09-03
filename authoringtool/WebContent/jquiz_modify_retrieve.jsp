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
<script language="javascript">
function changelist()
{
var quid=document.jquizmodify.question.value;
document.location.href="jquestion_modify1.jsp?QuestionID="+quid;  
}                                                                                
</script>
<%	Connection connection = null;
Class.forName(this.getServletContext().getInitParameter("db.driver"));
connection = DriverManager.getConnection(this.getServletContext().getInitParameter("db.webexURL"),this.getServletContext().getInitParameter("db.user"),this.getServletContext().getInitParameter("db.passwd"));
	Statement statement = connection.createStatement();
 %>
     	

<h3>Modify Java Question:</h3>
<form name="jquizmodify" method="post" onsubmit="multipleSelectOnSubmit()">

<% if(request.getParameter("msg").equals("1")){ 
	out.println("<font color=blue size=4><b>Question saved successfully!</b></font>");	
%>	
	<table border="1">
	<tr>
	<td  class="formfieldbold formfielddark">
		<table>
		<tr>
			<td class="formfieldbold formfielddark"><b>Quiz:<font color="red">*</font></b>	</td>
			<td><select name="question" onChange="Javascript:changelist();">
			<%
				 int QID=0;
				 int QzID=0;
				 String Title="";
				 String Description="";
				 InputStream is=null;
				 int MinVar=0;
				 int MaxVar=0;
				 int Privacy=0;
				 int AnsType=0;
				 int QuesType=0;
				 ResultSet rs3 = null;  				 
				 rs3 = statement.executeQuery("SELECT q.QuestionID,z.QuizID,z.Title,z.Description,z.Code,z.MinVar,z.MaxVar,z.AnsType,z.Privacy,z.QuesType FROM ent_jquestion q, ent_jquiz z, rel_question_quiz r where z.rdfid='"+request.getParameter("rdfID")+"' order by q.Title");
				 //rs3 = statement.executeQuery("SELECT q.QuestionID,z.QuizID,z.Title,z.Description,z.Code,z.MinVar,z.MaxVar,z.AnsType,z.Privacy,z.QuesType FROM ent_jquestion q, ent_jquiz z, rel_question_quiz r where q.QuestionID=r.QuestionID and z.QuizID=r.QuizID and z.rdfID='"+request.getParameter("rdfID")+"' ");
				 while(rs3.next()){
				 	QID = rs3.getInt("QuestionID");
				 	QzID= rs3.getInt("QuizID");
				 	Title= rs3.getString("Title");
				 	Description= rs3.getString("Description");
				 	is = rs3.getBinaryStream("Code");
				 	MinVar= rs3.getInt("MinVar");
				 	MaxVar= rs3.getInt("MaxVar");
				 	Privacy= rs3.getInt("Privacy");
				 	AnsType= rs3.getInt("AnsType");
				 	QuesType= rs3.getInt("QuesType");
				 }
				 				 
				 ResultSet rs2 = null;  
				 rs2 = statement.executeQuery("SELECT q.QuestionID,q.Title,q.Privacy FROM ent_jquestion q, ent_user u where (q.Privacy = '1' or u.name='"+userBeanName+"') and q.AuthorID=u.id ");				 				 				 

				 while(rs2.next())
				  {			  			  				  
				  	if(rs2.getString(3).equals("1")){
				  		if(rs2.getInt(1)==QID){ 		
				  		   out.write("<option value='"+rs2.getInt(1)+"' selected>"+rs2.getString(2)+"</option>");			  	        			  		
				  		}else{
				  		  out.write("<option value='"+rs2.getInt(1)+"'>"+rs2.getString(2)+"</option>");			  	        			  		
				  		}
				  	}else{			  		
				  		if(rs2.getInt(1)==QID){ 		
				  	           out.write("<option value='"+rs2.getInt(1)+"' style=background-color:#A9A9D5 selected>"+rs2.getString(2)+"</option>");			  	        			  	      
				  	        }else{
				  	           out.write("<option value='"+rs2.getInt(1)+"' style=background-color:#A9A9D5>"+rs2.getString(2)+"</option>");			  	        			  	      
				  	        }
				  	}
				  }				
			%>			
			</select></td>	
		</tr>
		<tr>
			<td class="formfieldbold formfielddark"><b>Question:<font color="red">*</font></b>	</td>
			<td>
				<select name="quiz">
				<%
				 ResultSet rs4 = null;  
				 rs4 = statement.executeQuery("SELECT q.QuizID,q.Title,q.Privacy FROM ent_jquiz q, ent_user u where (q.Privacy = '1' or u.name='"+userBeanName+"') and q.AuthorID=u.id ");				 				 				 				
				 while(rs4.next())
				  {			  			  				  
				  	if(rs4.getString(3).equals("1")){
				  		if(rs4.getInt(1)==QzID){ 		
				  		   out.write("<option value='"+rs4.getInt(1)+"' selected>"+rs4.getString(2)+"</option>");			  	        			  		
				  		}else{
				  		  out.write("<option value='"+rs4.getInt(1)+"'>"+rs4.getString(2)+"</option>");			  	        			  		
				  		}
				  	}else{			  		
				  		if(rs4.getInt(1)==QzID){ 		
				  	           out.write("<option value='"+rs4.getInt(1)+"' style=background-color:#A9A9D5 selected>"+rs4.getString(2)+"</option>");			  	        			  	      
				  	        }else{
				  	           out.write("<option value='"+rs4.getInt(1)+"' style=background-color:#A9A9D5>"+rs4.getString(2)+"</option>");			  	        			  	      
				  	        }
				  	}				  
				  }
				  %>				
				</select><input type="button" value="Retrieve Quiz Data" onClick="submitFunction(this.form,1)">
			</td>
		</tr>	
		<tr>
			<td class="formfieldbold formfielddark"><b>Title:<font color="red">*</font></b>	</td>
			<td><input type="text" name="title2" size="45" maxlength="45" value="<%=Title%>"></td>
		</tr>
		<tr>
			<td class="formfieldbold formfielddark"><b>rdfID:<font color="red">*</font></b>	</td>
			<td><input type="text" name="rdfID" size="45" maxlength="45" value="<%=request.getParameter("rdfID")%>">
			<input type="hidden" name="rdfID" value="<%=request.getParameter("rdfID")%>">
			</td>
		</tr>	
		<tr>
			<td class="formfieldbold formfielddark"><b>Description:	</b></td>
			<td><input type="text" name="description2" size="70" maxlength="255" value="<%=Description%>"></td>
		</tr>
		<tr>
			<td class="formfieldbold formfielddark"><b>Assessment Type:<font color="red">*</font></b></td>
			<td><select name="questiontype">
				<%
				String Qtype[] = new String[7];			
				Qtype[1]="final value";
				Qtype[2]="output";
				Qtype[3]="which line is wrong";
				Qtype[4]="fill in the blank";
				Qtype[5]="dynamic import";
				Qtype[6]="class()";			
				for (int a=1;a<7;a++){	
					if (QuesType == a){
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
			<td class="formfieldbold formfielddark"><b>Code:<font color="red">*</font></b>	</td>
			<%
	 		BufferedReader inpStream = new BufferedReader(new InputStreamReader(is));
	 		String streamcode = inpStream.readLine();
	   		String code = "";
			   while(streamcode != null) {		
			    code += streamcode + "\n";		
			    streamcode = inpStream.readLine();		
			   }		
			%>
			<td>
			<pre><textarea cols="80" rows="8" name="quizcode" value="<%=code%>"><%out.println(code);%></textarea></pre></td>
		</tr>
		<tr>
			<td class="formfieldbold formfielddark"><b>Minimum:<font color="red">*</font></b></td>			
			<td>
			<table><tr>		
			<td><input type="text" name="minvar" size="4" maxlength="4" value="<%=MinVar%>"></td>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td class="formfieldbold formfielddark"><b>Maximum:<font color="red">*</font></b>	</td>
			<td><input type="text" name="maxvar" size="4" maxlength="4" value="<%=MaxVar%>"></td>		
			</tr></table>
			</td>
		</tr>	
		<tr>
			<td class="formfieldbold formfielddark"><b>Answer Type:</b>	</td>
			<td><select name="anstype">			
				<%
				String type[] = new String[9];			
				type[0]="";
				type[1]="byte";
				type[2]="short";
				type[3]="int";
				type[4]="long";
				type[5]="float";
				type[6]="boolean";
				type[7]="String";
				type[8]="double";
				for (int a=0;a<=8;a++){						
					if (AnsType == a){
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
			<td>
			<% 
			if(Privacy==1){
			%>
				<input type="RADIO" name="privacy2" value="private" checked>Private <input type="RADIO" name="privacy2" value="public">Public
			<%
			}else{
			%>
				<input type="RADIO" name="privacy2" value="private">Private <input type="RADIO" name="privacy2" value="public" checked>Public
			<%			
			}
			%>
			</td>
		</tr>
		<tr>
			<td></td>
			<td><input type="button" value="Save" onclick="submitFunction(this.form,2);">&nbsp;&nbsp;<input type="button" value="Delete this Question" OnClick="if (confirm('you sure you want to delete this question?')==false){return false;} window.location.href='jquiz_delete.jsp?QuestionID=<%=request.getParameter("QuestionID")%>&QuizID=<%=request.getParameter("quiz")%>';"></td>		
		</tr>		
		</table>
	</td>
	<td><input type="button" value="Preview"  onclick="submitFunction(this.form,3);"></td>
	</tr>
	</table>					
<%	
   }else { 
%>

	<table border="1">
	<tr>
	<td  class="formfieldbold formfielddark">
		<table>
		<tr>
			<td class="formfieldbold formfielddark"><b>Quiz:<font color="red">*</font></b>	</td>
			<td><select name="question" onChange="Javascript:changelist();">
			<%
				 ResultSet rs2 = null;  
				 rs2 = statement.executeQuery("SELECT q.QuestionID,q.Title,q.Privacy FROM ent_jquestion q, ent_user u where (q.Privacy = '1' or u.name='"+userBeanName+"') and q.AuthorID=u.id ");
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
		<tr>
			<td class="formfieldbold formfielddark"><b>Question:<font color="red">*</font></b>	</td>
			<td>
				<select name="quiz">
				<%			 
				 ResultSet rs3 = null;  
				 rs3 = statement.executeQuery("SELECT z.QuizID,z.Title,z.Privacy FROM ent_jquiz z, ent_user u, rel_question_quiz qq where (z.Privacy = '1' or u.name='"+userBeanName+"') and z.AuthorID=u.id and qq.QuizID=z.QuizID and qq.QuestionID='"+request.getParameter("QuestionID")+"' ");			
				 while(rs3.next()){
				 	if (rs3.getString(1).equals(request.getParameter("quiz"))){
				 		out.write("<option value='"+rs3.getString(1)+"' selected>"+rs3.getString(2)+"</option>");
				 	}else{
				 		out.write("<option value='"+rs3.getString(1)+"'>"+rs3.getString(2)+"</option>");
				 	}
				 }
				%>
				</select>
				<input type="button" value="Retrieve Quiz Data" onClick="submitFunction(this.form,1)">
			</td>
		</tr>
		<%
				 ResultSet rs4 = null;  
				 rs4 = statement.executeQuery("SELECT distinct * FROM ent_jquiz where QuizID='"+request.getParameter("quiz")+"' ");
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
			<td><input type="text" name="description2" size="70" maxlength="255" value="<%=rs4.getString(5)%>"></td>
		</tr>
		<tr>
			<td class="formfieldbold formfielddark"><b>AssessmentType:<font color="red">*</font></b></td>
			<td><select name="questiontype">
				<%
				String Qtype[] = new String[7];			
				Qtype[1]="final value";
				Qtype[2]="output";
				Qtype[3]="which line is wrong";
				Qtype[4]="fill in the blank";
				Qtype[5]="dynamic import";
				Qtype[6]="class()";			
				for (int a=1;a<7;a++){	
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
			
			<td>
			<table><tr>		
			<td><input type="text" name="minvar" size="4" maxlength="4" value="<%=rs4.getString(7)%>"></td>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td class="formfieldbold formfielddark"><b>Maximum:<font color="red">*</font></b>	</td>
			<td><input type="text" name="maxvar" size="4" maxlength="4" value="<%=rs4.getString(8)%>"></td>		
			</tr></table>
			</td>
		</tr>	
		<tr>
			<td class="formfieldbold formfielddark"><b>Answer Type:</b>	</td>
			<td><select name="anstype">			
				<%
				String type[] = new String[9];			
				type[0]="";
				type[1]="byte";
				type[2]="short";
				type[3]="int";
				type[4]="long";
				type[5]="float";
				type[6]="boolean";
				type[7]="String";
				type[8]="double";
				for (int a=0;a<=8;a++){						
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
			<td>
			<% 
			if(rs4.getString(10).equals(1)){
			%>
				<input type="RADIO" name="privacy2" value="private" checked>Private <input type="RADIO" name="privacy2" value="public">Public
			<%
			}else{
			%>
				<input type="RADIO" name="privacy2" value="private">Private <input type="RADIO" name="privacy2" value="public" checked>Public
			<%			
			}
			%>
			</td>
		</tr>
		<tr>
			<td></td>
			<td><input type="button" value="Save" onclick="submitFunction(this.form,2);">&nbsp;&nbsp;<input type="button" value="Delete this Question" OnClick="if (confirm('you sure you want to delete this question?')==false){return false;} window.location.href='jquiz_delete.jsp?QuestionID=<%=request.getParameter("QuestionID")%>&QuizID=<%=request.getParameter("quiz")%>';"></td>		
		</tr>
			<%}%>
		</table>
	</td>	
	<td>
	
		
		<select multiple name="fromBox" id="fromBox">
		<%
		ResultSet rs5 = null;  
		//rs5 = statement.executeQuery("SELECT distinct c.ClassID,c.ClassName FROM rel_quiz_class q, ent_class c where q.ClassID=c.ClassID  ");		
		rs5 = statement.executeQuery("SELECT distinct c.ClassName, c.ClassID FROM rel_quiz_class q, ent_class c where q.ClassID=c.ClassID and c.ClassName not in (SELECT c.ClassName FROM rel_quiz_class q, ent_class c where q.ClassID=c.ClassID and q.QuizID='"+request.getParameter("quiz")+"') ");
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
		rs6 = statement.executeQuery("SELECT distinct * FROM rel_quiz_class q,ent_class c where q.ClassID=c.ClassID and q.QuizID='"+request.getParameter("quiz")+"' ");		  
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

	</tr>
	</table>


<%}%>
</form>
<br>
<h3>Modify Java Quiz:</h3>
<form name="JQuestionModify" method="post" action="jquestion_modify_save.jsp">
	 <table border="1">
	 <tr>	 
	 <td class="formfieldbold formfielddark"></td>
	 <td class="formfieldbold  formfielddark  " ><b>Title</b></td>	 
	 <td class="formfieldbold  formfielddark  " ><b>Description</b></td>
	 <td class="formfieldbold  formfielddark  " ><b>Privacy</b></td>
	 </tr>
<%	
	 String uid="";
	 ResultSet rs = null;  
	 rs = statement.executeQuery("SELECT id FROM ent_user where name = '"+userBeanName+"' ");
	 while(rs.next())
	  {
	  	uid=rs.getString(1);  	
	  }  
	   
	 out.write("<tr>");  	 
         ResultSet rs1 = null;      
         rs1 = statement.executeQuery("SELECT distinct q.QuestionID, q.Title, q.Description, q.Privacy,q.AuthorID from ent_jquestion q, ent_user u where q.AuthorID=u.id and (q.Privacy='1' or u.name='"+userBeanName+"') ");
	 int cnt=0;
         while(rs1.next())
	  {	  	  	 	 
		 out.write("<tr>"); 	 
		 cnt++;		 
		 		  
		 if (rs1.getString(4).equals("1")){
		 	if (rs1.getString(5).equals(uid)){
		 		out.write("<td><a href='jquestion_delete.jsp?QuestionID="+rs1.getString(1)+"'><img src=images/trash.jpg border=0></a></td>");
		 	}else {
		 		out.write("<td></td>");
		 	}
		 }else {
		 	out.write("<td><a href='jquestion_delete.jsp?QuestionID="+rs1.getString(1)+"'><img src=images/trash.jpg border=0></a></td>");
		 }
		 
		 out.write("<td><textarea cols=45 rows=1 name='Title"+cnt+"' value='"+rs1.getString(2)+"'>"+rs1.getString(2)+"</textarea></td>"); 		 	 		 		 		 
		 out.write("<td><textarea cols=70 rows=1 name='Description"+cnt+"' value="+rs1.getString(3)+">"+rs1.getString(3)+"</textarea></td>");		 
		 if (rs1.getString(4).equals("1")){	
		  	 if (rs1.getString(5).equals(uid)){
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

<tr>
<td  class="formfieldbold formfielddark"></td>
<td  class="formfieldbold formfielddark"><input type="submit" value="Save"></td>
</tr>
</table>
</form>

<script language="JavaScript">
<!-- 

function submitFunction(obj,i) {
   if (i==1) obj.action="jquiz_modify_retrieve.jsp?msg=0";
   if (i==2) {
   	var title2 = document.jquizmodify.title2.value;	
	var quizcode = document.jquizmodify.quizcode.value;	
	var minvar = document.jquizmodify.minvar.value;	
	var maxvar = document.jquizmodify.maxvar.value;	
	
	var toBox = document.jquizmodify.toBox.value;
		
		
	if(title2 == ""){alert("Title is missing!");}
	else if(quizcode == ""){alert("Quizcode is missing!");}
	else if(minvar == ""){alert("Minimum Variable is missing!");}
	else if(maxvar == ""){alert("Maximum Variable is missing!");}
	else if (!document.jquizmodify.privacy2[0].checked && !document.jquizmodify.privacy2[1].checked){alert("please select Privacy!");}
	else {
		if (title2!="" && quizcode!="" && minvar!="" && maxvar!="" && (document.jquizmodify.privacy2[0].checked || document.jquizmodify.privacy2[1].checked) && i==2) { obj.action="jquiz_modify_save.jsp";}
	}    
   }
   if (i==3){ obj.action="Preview"; obj.target="_blank";}

	obj.submit()
}
//-->
</script> 


</body> 
</html>