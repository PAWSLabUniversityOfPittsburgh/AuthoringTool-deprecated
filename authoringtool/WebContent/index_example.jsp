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

<Script language="javascript">  
  function test(){  
  var   sel   =   "";  
  //alert(document.step1.concept.options.length);  
  for(i=0;i<document.step1.concept.options.length;i++){  
  if   (document.step1.concept.options[i].selected   ==   true){  
  if   (sel.length   >   0){  
  sel   =   sel   +   ",";  
  }  
  sel   =   sel   +   document.step1.concept.options[i].value;  
  }  
  }  
  document.step1.browser_Sel.value   =   sel;  
  return   true;  
  }  
  </Script>   
  
<h1>index examples</h1>
<table>
<tr>
<td class="formfieldbold formfielddark"><b><font size="2">Step1</font>:select concepts</b></td>
<td>&nbsp;&nbsp;</td>
<td><font size="2">Step2</font>:choose examples</td>
<td>&nbsp;&nbsp;</td>
<td><font size="2">Step3</font>:assign index to scope</td>
</tr>
</table>
<%
     Connection connection = null;
Class.forName(this.getServletContext().getInitParameter("db.driver"));
connection = DriverManager.getConnection(this.getServletContext().getInitParameter("db.webexURL"),this.getServletContext().getInitParameter("db.user"),this.getServletContext().getInitParameter("db.passwd"));
Statement statement = connection.createStatement();

     ResultSet rs = null; 
     rs = statement.executeQuery("select * from ent_con");        
     int count=0;
%>
<form name="step1" method="post" action="index_example1.jsp" onSubmit="test()">
            <table>                                         
            <tr>
            <td>Concepts:</td>            
            <td>
	   <select name="concept"  multiple="true" size="20">
             <%
	  while(rs.next())
	  { 	

        	out.write("<option value="+rs.getString(1)+">"+rs.getString(2)+"</option");				        	
		count++;  	
          }            
	%> 	
	  </select>
	    </td>
	<td>
		<input type="submit"  value="submit">
		<input type="hidden" value="<%=count%>" name="maxcount">
		<input type="hidden" name="browser_Sel"   value="">  
	</td>
	</tr>
	</table>
</form>
<script language="JavaScript">
<!-- 

function submitFunction(obj,i) {
   if (i==1) obj.action=
      "index_example1.jsp"; 
   obj.submit()
   }
//-->
</script>

</body> 
</html>