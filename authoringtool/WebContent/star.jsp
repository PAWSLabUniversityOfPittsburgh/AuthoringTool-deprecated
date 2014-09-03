<%@ page language="java" %>
<%@ include file = "include/htmltop1.jsp" %>
<%@ include file = "include/connectDB.jsp" %>
<table width="100%" cellpadding="0" cellspacing="0">
	<% 	PreparedStatement pstmt2=null;
		ResultSet rs2=null;	
		PreparedStatement pstmt3=null;
		ResultSet rs3=null;
		PreparedStatement pstmt4=null;
		ResultSet rs4=null;
		String rate=null;
						
			try{
				String sql2 = "select * FROM ent_dissection where DissectionID = '"+request.getParameter("RDID")+"' ";	
				pstmt2 = conn.prepareStatement(sql2);
				rs2 = pstmt2.executeQuery();
				
				String sql3 = "select * from ent_line where DissectionID = '"+request.getParameter("RDID")+"' ";
				pstmt3 = conn.prepareStatement(sql3);
				rs3 = pstmt3.executeQuery();	

				String sql4 = "select * from rel_scope_dissection where DissectionID = " + request.getParameter("RDID");
				pstmt4 = conn.prepareStatement(sql4);
				rs4 = pstmt4.executeQuery();
				while(rs4.next()){			
				rate = rs4.getString(9).substring(0,3);
				}				
								
				while (rs2.next()) { 	%>	
		<div id="r<%=request.getParameter("RDID")%>" style="display:none">				
		<table>
				<tr><td>Current Rating: <font color="red"><b><%=rate%></b></font>
				</td><td>
				Give Ratings Here:<script>		
					var ex = "<%=request.getParameter("RDID")%>";   		
					</script>
					<img src="images/star1.gif" onmouseover="highlight(this.id)" onclick="setStar(this.id)" onmouseout="losehighlight(this.id)" id="1" style="width:20px; height:20px; float:left;" />
					<img src="images/star1.gif" onmouseover="highlight(this.id)" onclick="setStar(this.id)" onmouseout="losehighlight(this.id)" id="2" style="width:20px; height:20px; float:left;" />
					<img src="images/star1.gif" onmouseover="highlight(this.id)" onclick="setStar(this.id)" onmouseout="losehighlight(this.id)" id="3" style="width:20px; height:20px; float:left;" />
					<img src="images/star1.gif" onmouseover="highlight(this.id)" onclick="setStar(this.id)" onmouseout="losehighlight(this.id)" id="4" style="width:20px; height:20px; float:left;" />
					<img src="images/star1.gif" onmouseover="highlight(this.id)" onclick="setStar(this.id)" onmouseout="losehighlight(this.id)" id="5" style="width:20px; height:20px; float:left;" />						
					&nbsp;&nbsp;
					<div id="vote" style="font-family:tahoma; color:red;"></div>				
				</td>				
				</tr>								
				<td class="formfielddark formfieldaligntleft formfieldgroovetop"><b>Line</b></td>
				<td class="formfielddark formfieldaligntleft formfieldgroovetop"><b>Dissection</b></td>
				<td class="formfielddark formfieldaligntleft formfieldgroovetop"><b>Annotation</b></td>				
				</tr>
					<%while (rs3.next()) {
					%>	
				
				<tr>					
					<td class="formfielddark formfieldgroovetop" width="30%"><font size="2"><pre><%=rs3.getString(4)%></pre></font></td>														
					<td class="formfielddark formfieldgroovetop" width="30%"><%=rs3.getString(5)%></td>	
					<form METHOD="POST" name="form2" action="myratingsave.jsp">
					<td class="formfielddark formfieldgroovetop" width="26%"><TEXTAREA NAME="rta" ROWS="1" cols="30" >
					</textarea>
					<input type="hidden" value="<%=rs3.getString(3)%>" name="rline">
					<input type="hidden" value="<%=request.getParameter("RDID")%>" name="rid"></td>
					&nbsp;&nbsp;
					<td class="formfielddark formfieldgroovetop"><INPUT TYPE="SUBMIT" VALUE="Save" onClick="submitFunction(this.form,1)" name="button2"></td>					
					</form>										
					<%}								
					%>

				</tr>	
		</table>
		</div>	
				
				
				
			<%
				}
			}catch(SQLException sqle){
				System.out.println(sqle);
			}catch(Exception e){
				System.out.println(e);
			}finally{
				try{
				if(rs2 != null)
					rs2.close();
				if(pstmt2 != null)
					pstmt2.close();
				}catch(Exception e){}
			}
			
							           				
	%>							
</td></tr>
</table>

<script type="text/javascript">
function toggleMe(a){
var e=document.getElementById(a);
if(!e)return true;
if(e.style.display=="none"){
e.style.display="block"
}
else{
e.style.display="none"
}
return true;
}


</script>   
 
