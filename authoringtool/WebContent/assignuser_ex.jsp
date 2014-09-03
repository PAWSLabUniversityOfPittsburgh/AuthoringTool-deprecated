<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>
<%@ include file = "include/connectDB.jsp" %>


<table cellpadding="0" cellspacing="0">
<tr> 
 <td class="tabhead"><nobr>Assign Users Examples</nobr>     </td>
</tr>
<tr> 
 <td class="formtabmain">

<% 		
		if (!userBean.isAdmin()) {
%>			You do not have sufficient rights to perform this operation. Only <a href="mailto:sas15@pitt.edu">System Administrator</a> can modify users.<br/>
			Return to <a href="home.jsp">Home</a>. 			
<%		} else {
		
			Vector userList = (Vector) session.getAttribute("userList");
%>
<form method="post" action="assign.jsp">
<input type="submit" value="Assign" />

			<table width="100%" cellpadding="0" cellspacing="0" border="2">			
			<tr>	
			<td valign="top">
			<table width="100%" cellpadding="0" cellspacing="0" border="2" >
<%			
         if(userList != null)
         {			
           for (int i = 0; i < userList.size(); i++)
           {
			 UserBean uBean = (UserBean) userList.elementAt(i);
%>			
			<tr>
			<td class="formfieldlight">		
			<input type="radio" <%=(uBean.getId() == userBean.getId()) ? "disabled" : ""%> 
						value="<%=uBean.getName()%>" name="index">
			 <%=uBean.getLogin()%>
			
			<br /></td>	
			
<%
			}
         }
%>		
			</tr>
			</table>		
			</td>
			<td>
<%
PreparedStatement pstmt=null;
ResultSet rs=null;
PreparedStatement pstmt1=null;
ResultSet rs1=null;
PreparedStatement pstmt2=null;
ResultSet rs2=null;
	try{									
		String sql = "select * FROM rel_scope_dissection where TAKEN = '0'";	
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();						   
%>			
				<table  width="100%" cellpadding="3" cellspacing="3">
				<tr><td></td><td>ID</td><td>Example Name</td><td>Example description</td><td>Topic</td><td>Difficulty</td></tr>
				<%while (rs.next()) {
					String sql1 = "select * FROM ent_dissection where DissectionID = '"+rs.getString(2)+"' ";	
					pstmt1 = conn.prepareStatement(sql1);
					rs1 = pstmt1.executeQuery(); 
					while (rs1.next()) { 
						String sql2 = "select * FROM ent_learning_goal where goalid = '"+rs.getString(3)+"' and ScopeID='1' ";	
						pstmt2 = conn.prepareStatement(sql2);
						rs2 = pstmt2.executeQuery(); 
						while (rs2.next()) { 
			        %>
				<tr>
				<td>				
				<input TYPE=checkbox name="id" VALUE="<%=rs.getString(2)%>"> 								
				</td>
				<td><%=rs.getString(2)%>				
				</td>
				<td><%=rs1.getString(2)%>				
				</td>
				<td><%=rs1.getString(3)%></td>
				<td><%=rs.getString(3)%> <%=rs2.getString(2)%></td>
				<td><%=rs.getString(4)%></td>							
				</tr>
				<%}}}%>
				</table>
<%	}catch(SQLException sqle){
			out.println(sqle);
		}catch(Exception e){
			out.println(e);
		}
%>		
			
			</td>
			</tr>
			</table>
		</table>
</form>			
<%
			}
%>

</td>
</tr>
</table>
<%@ include file = "include/htmlbottom.jsp" %>