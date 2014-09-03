<%@page language="java"%>
<%@ include file = "include/htmltop.jsp" %>
<%@ include file = "include/connectDB.jsp" %>
<%@page import="java.sql.*" %>



	<table width="100%" cellpadding="0" cellspacing="0">
	<tr> 
	<td class="tabhead"><nobr>Edit Example/Comments</nobr>     </td>
	</tr>
	<tr>
	<td class="formtabmain">	
	
	<table cellpadding="0" cellspacing="0">
  <% 
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	PreparedStatement pstmt1=null;
	ResultSet rs1=null;
		
	PreparedStatement pstmt2=null;		
	ResultSet rs2=null;	
	PreparedStatement pstmt3=null;
	ResultSet rs3=null;	
	
	int Max = 0;
	String taken = null;	
	
	try{		
		String sql = "select * from ent_line where DissectionID = " + request.getParameter("exampleno");
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();
		
		String sql1 = "select * from ent_dissection where DissectionID = " + request.getParameter("exampleno");
		pstmt1 = conn.prepareStatement(sql1);
		rs1 = pstmt1.executeQuery();		

		String sql2 = "select Max(LineIndex) from ent_line where DissectionID = " + request.getParameter("exampleno");
		pstmt2 = conn.prepareStatement(sql2);
		rs2 = pstmt2.executeQuery();
		while(rs2.next()){	
		Max = Integer.parseInt(rs2.getString(1));
		session.setAttribute("Maxno",Max);
		}
		
		String sql3 = "select * from rel_scope_dissection where DissectionID = " + request.getParameter("exampleno");
		pstmt3 = conn.prepareStatement(sql3);
		rs3 = pstmt3.executeQuery();
		while(rs3.next()){	
		taken = rs3.getString(8);
		session.setAttribute("Taken",taken);		
		}	
				
		session.setAttribute("exno", request.getParameter("exampleno"));

  %>		
  	
	<tr valign="top">
	<% while(rs1.next()){		
	%>	
	
	
		<td width="75%" class="formfieldgrooveleft formfieldlight formfieldaligntleft formfieldgroovetop">Example : <% out.print(rs1.getString(3)); %></td>					
	<%
	}
	%>
	<td class="formfieldgrooveright formfieldlight formfieldaligntleft formfieldgroovetop"></td>		
	</tr>
	<tr>
		<td class="formfieldgrooveleft formfielddark formfieldaligntleft formfieldgroovetop">						
		<table>
		<tr>		
		<td>Rating: </td>
		<td>		
		<font color="red" size="3"><b><%=request.getParameter("newrating").substring(0,3)%></b></font>
		</td>
		
		</tr></table>
				</td>
		<td class="formfieldgrooveright formfielddark formfieldaligntleft formfieldgroovetop">

		</td>
		
	</tr>
	<tr>
	<td width="98%" class="formfieldgrooveleft  formfieldlight formfieldaligntleft formfieldgroovetop"> 	
	<table id="table1">
		
<%
		int cc=0;
		while(rs.next()){		
%>
	
	<tr id="table1_<%=cc%>">
	<td><b>
<%				
		out.print(rs.getString(4)+"<br>");
%>
	</b></td>
	<% if (taken.equals("0")){ %>	
		<form ACTION="" METHOD="POST" id="text">
	      		<td><TEXTAREA NAME="textarea<%=(cc+1)%>" ROWS="3" cols="55"><%out.print(rs.getString(5));%></TEXTAREA></td>
			<td><INPUT TYPE="SUBMIT" VALUE="Save" onClick="submitFunction(this.form,1)"></td>
		 	<input  TYPE="hidden" VALUE=<%=rs.getString(3)%> NAME="count">
			<input  TYPE="hidden" VALUE=<%=rs.getString(2)%> NAME="ex"> 
			<input  TYPE="hidden" VALUE=<%=rs.getString(7)%> NAME="oldRating"> 
			<input  TYPE="hidden" VALUE=<%=rs.getString(8)%> NAME="hit"> 			
	     	
	<% }
	else { %>	
	<td>
<%				
		out.print(rs.getString(5)+"<br>");
%>	
	</td>
	<% } %>
	</tr>
	
	<% cc=cc+1;
		}
		
	}catch(SQLException sqle){
		out.println(sqle);
	}
	finally{
		try{
		if(rs != null)
			rs.close();
		if(pstmt != null)
			pstmt.close();
		if(conn != null)
			conn.close();
		}catch(Exception e){}
	}						
   	%>	     	
   	
		
   	</table>
   	</td>
	<td class="formfieldgrooveright formfieldlight formfieldgroovetop"></td>
	</tr>
	
	</table>
	</td>
	</tr>
	<tr>
	<td class="formbuttonbottom" align="left">		
	
	</form>
	</tr>
	</table>

<script language="JavaScript">
<!-- 

function submitFunction(obj,i) {
   if (i==2) obj.action=
      "evaluate1.jsp";
   if (i==1) obj.action=
      "save_dis.jsp";
   obj.submit()
   }
//-->
</script> 
	



<%@ include file = "include/htmlbottom.jsp" %>