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
	<td width="75%" class="formfieldlight formfieldaligntleft formfieldgroovetop">Example : <% out.print(rs1.getString(3)); %>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<INPUT type="button" value="Copy the Code" onclick="CreateWindow()">
	</td>					
		
	<%
	}
	%>
	
	</tr>
	<tr>

		<td class=" formfielddark formfieldaligntleft formfieldgroovetop">								
		<table>
		<tr>
		<td width="10%">current Rating: <font color="red" size="3"><b><%out.println(rate);%></b></font>&nbsp;&nbsp;</td>				
		<form method="post" action="evaluate1.jsp" name="myForm">
		<td  class="formfieldgrooveleft" width="30%">Give Rating:
					<script>						
					var ex = "<%=request.getParameter("exampleno")%>";   		
					</script>
					<img src="images/star1.gif" onmouseover="highlight(this.id)" onclick="setStar(this.id)" onmouseout="losehighlight(this.id)" id="1" style="width:20px; height:20px; float:left;" />
					<img src="images/star1.gif" onmouseover="highlight(this.id)" onclick="setStar(this.id)" onmouseout="losehighlight(this.id)" id="2" style="width:20px; height:20px; float:left;" />
					<img src="images/star1.gif" onmouseover="highlight(this.id)" onclick="setStar(this.id)" onmouseout="losehighlight(this.id)" id="3" style="width:20px; height:20px; float:left;" />
					<img src="images/star1.gif" onmouseover="highlight(this.id)" onclick="setStar(this.id)" onmouseout="losehighlight(this.id)" id="4" style="width:20px; height:20px; float:left;" />
					<img src="images/star1.gif" onmouseover="highlight(this.id)" onclick="setStar(this.id)" onmouseout="losehighlight(this.id)" id="5" style="width:20px; height:20px; float:left;" />						
					&nbsp;&nbsp;
					<div id="vote" style="font-family:tahoma; color:red;"></div>
					<input type="hidden" name="ex" value="<%=request.getParameter("exampleno")%>">
					<input type="hidden" id="rate" name="a">
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	
				<input type="submit" value="Submit">
				<input type="button" value="Cancel" onClick="refresh();">
			</td>
		</form>			
		</tr>		
		</table>						
		</td>		
	<td class="formfieldgrooveright formfielddark formfieldaligntleft formfieldgroovetop">
	</td>

		
	</tr>
	<tr>
	<td width="98%" class=" formfieldlight formfieldaligntleft formfieldgroovetop"> 	
	<table id="table1"  cellpadding="0" cellspacing="0">	
	<tr><td></td><td></td><td class="formfieldgrooveleft"></td>
	<td><form METHOD="POST" name="form2" action="myratingsave_r1.jsp">
				<input type="submit" value="Save"> 
				<input type="button" value="Cancel"  onClick="reset();">
				</td>
	</tr>		
<%
		while(rs.next()){		
%>
	
	<tr>
	<td width="50%"><font size="2"><b><pre><%=rs.getString(4)%></pre></b></font></td>
	<td width="29%"><font size="2" color="blue"><%out.print(rs.getString(5));%></font></td>
	<td class="formfieldgrooveleft"></td>
	<td >							
					<TEXTAREA NAME="rta<%=rs.getString(3)%>" ROWS="1" cols="30" >					
					</textarea>					
					<input type="hidden" value="<%=rs.getString(3)%>" name="rline">
					<input type="hidden" value="<%=request.getParameter("exampleno")%>" name="rid">										
											
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
   	<tr><td></td><td></td><td></td><td>
   	<input type="submit" value="Save">
   	<input type="button" value="Cancel"  onClick="reset();"></td></tr>
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
      "evaluate1.jsp?ex=ex&a=request.getParameter("rate")";
   if (i==1) obj.action=
      "myratingsave_r.jsp";
   obj.submit()
   }
//-->
</script> 
<script language="JavaScript">
    function refresh(){
        window.location.replace("http://localhost:8080/example/ViewExampleRate.jsp?exampleno=<%=request.getParameter("exampleno")%>");
    }
    function reset(){
    document.reset();
    }
</script>



<%@ include file = "include/htmlbottom.jsp" %>