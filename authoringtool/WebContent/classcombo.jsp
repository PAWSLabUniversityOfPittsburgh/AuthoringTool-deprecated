<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>
<%@ page import="java.sql.*" %>
<%@page import="java.io.*"%>
<%@page import="java.net.URL"%>


<%
    Connection conn = null;
   
    ResultSet rs1 = null;
    Statement stmts = null;
    ResultSetMetaData rsmds = null;   	
   
    String sc="";       	
    Class.forName(this.getServletContext().getInitParameter("db.driver"));
    conn = DriverManager.getConnection(this.getServletContext().getInitParameter("db.webexURL"),this.getServletContext().getInitParameter("db.user"),this.getServletContext().getInitParameter("db.passwd"));
    
     try {

        stmts = conn.createStatement();
        rs1 = stmts.executeQuery("SELECT * FROM ent_class");        
     }
     catch (SQLException e) {
         System.out.println("Error occurred " + e);
      }

%>
<script type="text/javascript">
<!-- 
function function1(obj,i){	
 if (i==1) obj.action="class_selected.jsp";
 obj.submit();
	
}
//-->
</script>

<h2><b>Import class:</b></h2>
<p>&nbsp;</p>


	<form method="post">
	<table border="1">
	<tr valign="top">
	<td>
		<table border="1" cellpadding="5">
		<tr>	
			<td colspan="5">		
				<INPUT TYPE="button" VALUE="Import" onclick="function1(this.form,1);">
			</td>  
		</tr>
		
		<tr>
		
		<%
			int colcount=0;
			int totalcount=0;
			while(rs1.next())
			  {
				colcount++;
				if (colcount==4){
					out.write("<td><input type=checkbox name="+rs1.getString("ClassID")+" value="+rs1.getString("ClassID")+">");
					out.write("<input type=hidden name="+rs1.getString("ClassID")+" value="+rs1.getString("ClassName")+">");
					out.write("<a href='http://adapt2.sis.pitt.edu/quizjet/class/"+rs1.getString("ClassName")+"' target='_blank'>"+rs1.getString("ClassName")+"</a>&nbsp;&nbsp;");	  	
					out.write("<a href='http://adapt2.sis.pitt.edu/quizjet/class/"+rs1.getString("ClassTester")+"' target='_blank'></a></td></tr>");
					colcount=0;
				}else{
					out.write("<td><input type=checkbox name="+rs1.getString("ClassID")+" value="+rs1.getString("ClassID")+">");
					out.write("<input type=hidden name="+rs1.getString("ClassID")+" value="+rs1.getString("ClassName")+">");
					out.write("<a href='http://adapt2.sis.pitt.edu/quizjet/class/"+rs1.getString("ClassName")+"' target='_blank'>"+rs1.getString("ClassName")+"</a>&nbsp;&nbsp;");	  		  	
					out.write("<a href='http://adapt2.sis.pitt.edu/quizjet/class/"+rs1.getString("ClassTester")+"' target='_blank'></a></td>");
				}		
				totalcount++;
			  }				  
		%><input type="hidden" name="totalcount" value="<%=totalcount%>">
		</tr>
		</form>
		<tr>	
			<td colspan="5">		
			<FORM  ENCTYPE="multipart/form-data" ACTION="single_upload_page.jsp" METHOD=POST>
				<input type="file" name="F1">&nbsp;<input type="submit" value="Upload">
            			<font color="#FF0000" size="2"><strong>Upload </strong></font> </td>              			
            		</form>
		</tr>		
		</table>		
		
	</td>
	<td>
		<table border="0" cellpadding="0" width="300" height="300">
		<tr  valign="top">
			<td class="formfieldgrooveleft formfielddark formfieldgroovetop formfieldgrooveright formfieldgroovebottom">
				<table>
				<tr>
				<td class="tabhead" width="1">code</td>
				<td class="tabhead" width="1">tester</td>
				</tr>
				</table>
			</td>
		</tr>
		</table>
	</td>
	</tr>
	</table>

</body> 
</html>