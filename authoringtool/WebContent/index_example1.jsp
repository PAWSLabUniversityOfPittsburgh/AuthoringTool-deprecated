<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>
<%@ include file = "include/connectDB.jsp" %>
<%@ page import="java.sql.*" %>

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
<script language="javascript">
function checkAll(){
	for (var i=0;i<document.forms[0].elements.length;i++)
	{
		var e=document.forms[0].elements[i];
		if ((e.name != 'allbox') && (e.type=='checkbox'))
		{
			e.checked=document.forms[0].allbox.checked;
		}
	}
}
</script>
<h2>index examples</h2>
<table>
<tr>
<td><font size="2">Step1: </font><a href="index_example.jsp">select concepts</a></td>
<td>&nbsp;&nbsp;</td>
<td class="formfieldbold formfielddark"><b><font size="2">Step2</font>: choose examples</b></td>
<td>&nbsp;&nbsp;</td>
<td class="formfieldbold formfielddark"><b><font size="2">Step3</font>: assign index to scope</b></td>
</tr>
</table>
<br>

<%
     Connection connection = null;
Class.forName(this.getServletContext().getInitParameter("db.driver"));
connection = DriverManager.getConnection(this.getServletContext().getInitParameter("db.webexURL"),this.getServletContext().getInitParameter("db.user"),this.getServletContext().getInitParameter("db.passwd"));
Statement statement = connection.createStatement();
     
     String selected_con = request.getParameter("browser_Sel");
     
     ResultSet rs1 = null; 
     rs1 = statement.executeQuery("select con_name from ent_con where con_id in ("+selected_con+")");         
     String selected_con_name="";
     while(rs1.next())
     {
     	selected_con_name=selected_con_name+rs1.getString(1)+", ";
     }
     out.write("<b>"+"selected concepts: "+"</b>"+selected_con_name+"<br>");
     
     ResultSet rs = null; 
     rs = statement.executeQuery("select distinct r.DissectionID, e.Name, e.Description from rel_con_dissection r,ent_dissection e where e.DissectionID=r.DissectionID and r.con_id in  ("+selected_con+")");                
     int row = 0;     
     %>
     <br>
     <form method="post" action="index_example2.jsp">
     <table>
     	<tr>     	
		<td class="formfieldbold formfielddark"><input type="checkbox" value="on" name="allbox" onclick="checkAll();"/></td>
     		<td class="formfieldbold formfielddark"><b>ID</b></td>
     		<td class="formfieldbold formfielddark"><b>Name</b></td>
     		<td class="formfieldbold formfielddark"><b>Description</b></td>
     		<td class="formfieldbold formfielddark"><b>Concepts</b></td>     	
     	</tr>
     	
     <%
     ResultSet rs2 = null; 
     PreparedStatement pstmt2=null;
     while(rs.next())    
	  { 	
	  	row++;
	  	out.write("<tr>");
	  	out.write("<td><input type=checkbox name=ID"+row+" value="+rs.getString(1)+"></td>");
		out.write("<td>"+rs.getString(1)+"</td>");		
		out.write("<td><a href=index_example_code.jsp?ex="+rs.getString(1)+" target=_blank>"+rs.getString(2)+"</a></td>"); 
		out.write("<td>"+rs.getString(3)+"</td>");	
		
		try{		
		        String command2 = "select e.con_name from rel_con_dissection r,ent_con e where e.con_id=r.con_id and r.DissectionID='"+rs.getString(1)+"'";                		
			pstmt2 = conn.prepareStatement(command2);
			rs2 = pstmt2.executeQuery();				        
		        int innercount=0;
		        out.write("<td>");
			while(rs2.next())
			{	
				innercount++;
				if (innercount==8){
					out.write("<br>");
					innercount=0;
				}
				out.write(rs2.getString(1)+";");
				
			}
			out.write("</td>");
				
		}catch(SQLException sqle){
		out.println(sqle);
		}catch(Exception e){
		out.println(e);
		}
		
		out.write("</tr>");
	  }     
      %>      		
		<input type="hidden" name="row" value="<%=row%>">
		
        <tr><td><br><br></td></tr>
     	<tr>     	
		<td></td>
     		<td></td>
     		<td></td>
     		<td></td>
     		<td class="formfieldbold formfielddark">     		
     		<table>
     	
	     		<tr>
	     		<td>
	     			<input type="RADIO" name="radioSet" value="button2" checked> assign to NEW scope &nbsp;&nbsp;Name:
	     			<input type="text" name="newscopename"  size="15" maxlength="15" />&nbsp;&nbsp;Description:
	     			<input type="text" name="newscopedes"  size="45" maxlength="45" />
	     		</td>	     			     		

	     		</tr>
	     		<tr>
	     		<td>
	     			<input type="RADIO" name="radioSet" value="button1"> assign to existing scope&nbsp;&nbsp; 
	     			<select name="scopeid" >
	     			<%
	     			ResultSet rs3 = null;      					
 				    rs3 = statement.executeQuery("SELECT * FROM ent_scope");
 				    while(rs3.next())
 				    {
 				    %> 				    	     			     			     			
	     	     			<option value="<%=rs3.getString(1)%>"><%=rs3.getString(2)+": "+rs3.getString(3)%></option>	     		     			
	     			<%
	     			    }
	     			%>	     		    			
	     			</select>
	     		</td>
	       		</tr>
	       		<tr>
	       		<td>
	       			<input type="submit" value="Submit">
	       		</td>
	       		</tr>
		       		
     		</table>
     		</td>     	
     	</tr>
        </table>

</form>	
</body> 
</html>