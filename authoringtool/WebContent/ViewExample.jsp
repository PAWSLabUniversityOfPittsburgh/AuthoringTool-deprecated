<%@page language="java"%>
<%@ include file = "include/htmltop.jsp" %>
<%@ include file = "include/connectDB.jsp" %>
<%@page import="java.sql.*" %>
<script language="JavaScript">
function CreateWindow()
        {
        msgWindow=window.open("copy.jsp","displayWindow","toolbar=no,width=500,height=300,directories=no,status=no,scrollbars=yes,resize=no,menubar=no")
        }  

</script>


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
	PreparedStatement pstmt4=null;
	ResultSet rs4=null;	
		
	int Max = 0;
	String taken = null;
	String rate = null;
	
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
		rate = rs3.getString(9).substring(0,3);
		}	
				
		session.setAttribute("exno", request.getParameter("exampleno"));
		
  %>		
  	
	<tr valign="top">
	<% while(rs1.next()){		
	%>	
	
	
		<td width="75%" class="formfieldlight formfieldaligntleft formfieldgroovetop">Example : <% out.print(rs1.getString(3)); %></td>					
	<%
	}
	%>
	<td class="formfieldgrooveright formfieldlight formfieldaligntleft formfieldgroovetop"></td>		
	</tr>
	<tr>
		<td class=" formfielddark formfieldaligntleft formfieldgroovetop">								
		<table>
		<tr>
		<td>current Rating: <font color="red" size="3"><b><%out.println(rate);%></b></font>
		&nbsp;&nbsp;&nbsp;&nbsp;<INPUT type="button" value="Copy the Code" onclick="CreateWindow()"></td>				
		</tr>
		</table>						
		</td>
		
		<td class="formfieldgrooveright formfielddark formfieldaligntleft formfieldgroovetop">

		</td>
		
	</tr>
	<tr>
	<td width="98%" class=" formfieldlight formfieldaligntleft formfieldgroovetop"> 	
	<table id="table1"  cellpadding="0" cellspacing="0">
		
<%
		while(rs.next()){		
%>
	
	<tr>
	<td width="50%"><font size="2"><b><pre><%=rs.getString(4)%></pre></b></font></td>
	<td width="29%"><font size="2" color="blue"><%out.print(rs.getString(5));%></font></td>
	<td class="formfieldgrooveleft"></td>
	<td width="20%">	
	<%
	String sql4 = "select * from ent_line_a where DissectionID = '"+request.getParameter("exampleno")+"' "+
	"order by LineIndex,uid";
	pstmt4 = conn.prepareStatement(sql4);
	rs4 = pstmt4.executeQuery();	
		while(rs4.next()){	
			if (rs.getString(3).equals(rs4.getString(3))){		
				if (rs4.getString(4).equals("1")){			
	%>	
				<span style='background-color:#FFFF66'><%=rs4.getString(5)%></span>
				<%} else if (rs4.getString(4).equals("2")){%>
				<span style='background-color:#CCFF66'><%=rs4.getString(5)%></span>
				<%} else if (rs4.getString(4).equals("3")){%>
				<span style='background-color:#CCCC99'><%=rs4.getString(5)%></span>
				<%} else if (rs4.getString(4).equals("4")){%>
				<span style='background-color:#CCFFFF'><%=rs4.getString(5)%></span>
				<%} else if (rs4.getString(4).equals("5")){%>
				<span style='background-color:#FFCCFF'><%=rs4.getString(5)%></span>
				<%} else if (rs4.getString(4).equals("6")){%>
				<span style='background-color:#66FFFF'><%=rs4.getString(5)%></span>
				<%} else if (rs4.getString(4).equals("7")){%>
				<span style='background-color:#FFCC99'><%=rs4.getString(5)%></span>
				<%} else if (rs4.getString(4).equals("8")){%>
				<span style='background-color:#FFFFCC'><%=rs4.getString(5)%></span>																	
				<%} else if (rs4.getString(4).equals("9")){%>
				<span style='background-color:#99FF99'><%=rs4.getString(5)%></span>				
				<%}%>
		<%}}%>			
	</td>	
	</tr>
	
	<% 
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