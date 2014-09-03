<%@page language="java"%>
<%@ include file = "include/htmltop.jsp" %>
<%@ include file = "include/connectDB.jsp" %>
<%@page import="java.sql.*" %>
<script language="JavaScript">
function CreateWindow()
        {
        msgWindow=window.open("copy.jsp","displayWindow","toolbar=no,width=400,height=300,directories=no,status=no,scrollbars=yes,resize=no,menubar=no")
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
		<td width="75%" class="formfieldgrooveleft formfieldlight formfieldaligntleft formfieldgroovetop">Example : <% out.print(rs1.getString(3)); %></td>					
	<%
	}
	%>
	<td class="formfieldgrooveright formfieldlight formfieldaligntleft formfieldgroovetop"></td>		
	</tr>
	<tr>
		<td class="formfieldgrooveleft formfielddark formfieldaligntleft formfieldgroovetop">						
		<% if (taken.equals("0")){ %>	
		<table>
		<tr>
		<td>current Rating: <font color="red" size="3"><b><%out.println(rate);%></b></font>&nbsp;&nbsp;</td>
		<td>Rate it Now:</td>
		<td>		
		<script>		
		var ex = "<%=session.getAttribute("exno")%>";   		
		</script>
		<img src="images/star1.gif" onmouseover="highlight(this.id)" onclick="setStar(this.id)" onmouseout="losehighlight(this.id)" id="1" style="width:15px; height:15px; float:left;" />
		<img src="images/star1.gif" onmouseover="highlight(this.id)" onclick="setStar(this.id)" onmouseout="losehighlight(this.id)" id="2" style="width:15px; height:15px; float:left;" />
		<img src="images/star1.gif" onmouseover="highlight(this.id)" onclick="setStar(this.id)" onmouseout="losehighlight(this.id)" id="3" style="width:15px; height:15px; float:left;" />
		<img src="images/star1.gif" onmouseover="highlight(this.id)" onclick="setStar(this.id)" onmouseout="losehighlight(this.id)" id="4" style="width:15px; height:15px; float:left;" />
		<img src="images/star1.gif" onmouseover="highlight(this.id)" onclick="setStar(this.id)" onmouseout="losehighlight(this.id)" id="5" style="width:15px; height:15px; float:left;" />						
		</td>
		<td><div id="vote" style="font-family:tahoma; color:red;"></div></td>		
		</tr>
		</table>
		<% }
		else { %>	
		<table>
		<tr>
		<td>Rating:</td>
		<td>	
		<font color="red" size="3"><b><%out.println(rate);%></b></font>
&nbsp;&nbsp;&nbsp;&nbsp;<INPUT type="button" value="Copy the Code" onclick="CreateWindow()"></td>
		</tr>
		</table>				
		<% } %>		
		</td>		
		<td class="formfieldgrooveright formfielddark formfieldaligntleft formfieldgroovetop">
		</td>		
	</tr>
	<tr>
	<td width="98%" class="formfieldgrooveleft  formfieldlight formfieldaligntleft formfieldgroovetop"> 	
	<table id="table1">
	<form ACTION="save_dis.jsp" METHOD="POST" id="text">
	<tr><td></td>
		<td>		
		<input type="submit" value="Save"> 
		<input type="button" value="Cancel"  onClick="reset();"></td>				
	</tr>
		
<%
		int cc=0;
		while(rs.next()){		
%>
	
	<tr>
		<td><pre><font size="2"><%=rs.getString(4)%></font></pre></td>
	<% if (taken.equals("1")){ %>		
	      	<td><TEXTAREA NAME="textarea1<%=rs.getString(3)%>" ROWS="2" cols="75"><%out.print(rs.getString(5));%></TEXTAREA></td>		
		 	<input  TYPE="hidden" VALUE=<%=rs.getString(3)%> NAME="count">
			<input  TYPE="hidden" VALUE=<%=rs.getString(2)%> NAME="ex"> 
			<input  TYPE="hidden" VALUE=<%=rs.getString(7)%> NAME="oldRating"> 
			<input  TYPE="hidden" VALUE=<%=rs.getString(8)%> NAME="hit"> 				     	
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
	<tr><td></td>
		<td>		
		<input type="submit" value="Save"> 
		<input type="button" value="Cancel"  onClick="reset();"></td>				
	</tr>   	
   	</form>	     	   			
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
<script language="JavaScript">
    function reset(){
    document.reset();
    }
</script>	



<%@ include file = "include/htmlbottom.jsp" %>