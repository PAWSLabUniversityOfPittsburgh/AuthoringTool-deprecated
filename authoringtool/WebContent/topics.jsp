<%@ page language="java"%>
<%@ include file = "include/htmltop.jsp" %>
<%@ include file = "include/connectDB.jsp" %>
<%@page import = "java.util.*" session="true"%>

	<b>Welcome, <%=userBeanName%>.</b>&nbsp;&nbsp;&nbsp;
<% 	if (userBean.getGroupBean() == null) {
		Vector groupList = (Vector)session.getAttribute("groupList");
		if (groupList != null && groupList.size() >  0) {
%>  	
			<b>Please, choose the topic you are interested in :</b> &nbsp;&nbsp;&nbsp;
<%
			ListIterator i = groupList.listIterator();
			while(i.hasNext()) {
				GroupBean gBean = (GroupBean) i.next();
%>
				<br/> | 
				<a href="SecurityServlet?action=SWITCHGROUP&index=<%=i.previousIndex()%>">	
					<%=gBean.getName()%>
				</a> |&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<%				
				
				if (gBean.getName()=="example_test")
				%>
				<jsp:forward page="one.jsp"/>
				<%
				if  (gBean.getOwnerId() == userBean.getId()) {
%>			
					You are the OWNER of this group
<%
				} else if (userBean.isAdmin() || gBean.getUserRights(new Integer (userBean.getId())) == Const.RIGHTS_YES) {
%>
					You have rights to modify this group's artifacts
<%			
				}			
			}
		} else {
			if (userBean.isAdmin() || userBean.isSuperUser()) {
%>
			You do not have any group associated with your login. Please, first <a href="sysmanage.jsp">create a group</a>.
<%
			} else {	
%>
				You do not have any group associated with your login. Please, contact your teacher or the <a href="mailto:sas15@pitt.edu">System Administator</a>.
<%
			}
		}
	} else {
%>
		You current group is <b><%=userBean.getGroupBean().getName()%></b>.<br /><br />
		
		<table width="98%" cellpadding="0" cellspacing="0">
		<tr>
		<td width="80%">				
		<table border="1" width="100%"> 
		<tr>
			<td width="50%">
			<table width="100%">
		<%
					PreparedStatement pstmt=null;
					ResultSet rs=null;						
					PreparedStatement pstmt1=null;
					ResultSet rs1=null;		
					PreparedStatement pstmt2=null;
					ResultSet rs2=null;	
									
		int goalID = Integer.parseInt(request.getParameter("goalid"));
	try{									
		String sql1 = "select * FROM learning_goal where goalid = '"+goalID+"' and ScopeID = '1'";	
		pstmt1 = conn.prepareStatement(sql1);
		rs1 = pstmt1.executeQuery();				
		while (rs1.next()) {  				
		%>									              									 								
		<tr><td class="classbox">Topic: <%=rs1.getString(2)%></td></tr>
		<%
		}
		}catch(SQLException sqle){
			out.println(sqle);
		}catch(Exception e){
			out.println(e);
		}finally{
			try{
			if(rs1 != null)
				rs.close();
			if(pstmt1 != null)
				pstmt1.close();
			}catch(Exception e){}
		
	  }																												
		%> 			
							
				<tr><td>
				<table width="99%">

					<%																
	try{									
		String sql = "select * FROM rel_scope_dissection where goalid = '"+goalID+"' ";	
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();				
		while (rs.next()) {  	
		
			String sql2 = "select * FROM ent_dissection where DissectionID = '"+rs.getString(2)+"' ";	
			pstmt2 = conn.prepareStatement(sql2);
			rs2 = pstmt2.executeQuery();				
			while (rs2.next()) {  			
		%>
					<tr>
					<td width="40%">		
		<a href="<%="EditExample.jsp?exampleno="+rs.getString(2)%>">                 									 					
		<%=rs2.getString(3)%>				
                      			</a>                      			                    			
                      			</td>										
				
					<td width="5%">
					<% if (rs.getString(8).equals("0")){										
					%>
					<DIV TITLE="header=[free to annotate] body=[]">
					<img src="images/no.gif">
					</DIV>
									
					<%} else {%>
					<DIV TITLE="header=[Annotated] body=[]">
					<img src="images/yes.gif">
					</DIV>
					<%}%>
					</td>
					<td width="5%">
					<DIV TITLE="header=[Add to MyExample] body=[]"><img src="images/add.gif"></DIV></td>
					<td width="25%"><%=rs.getString(7).substring(0,19)%> </td>				
		<%
		}
		}
		}catch(SQLException sqle){
			out.println(sqle);
		}catch(Exception e){
			out.println(e);
		}finally{
			try{
			if(rs != null)
				rs.close();
			if(pstmt != null)
				pstmt.close();
			}catch(Exception e){}
		}																												
		%>				
				
				
					</tr>


				</table>
				</td></tr>							
			</table>
			</td>
			
		</tr>		

		</table>
		
		</td>
		
		<td width="20%">
			<table width="100%" height="400"  cellpadding="10" cellspacing="10">
				<tr valign="top"><td class="classbox">Topics: <br>
									<%	
					while (result1.next()) {  
					if (result1.getString(3).equals("1")){
						%>
				<a href="<%="topics.jsp?goalid="+result1.getString(1)%>"><%=result1.getString(2)%></a><br>
						<%
						}}
						%>
				<br><br>
				<a href="viewall.jsp"><font size="3"><b>View ALL</font></b></a>
				</td></tr>
				<tr><td>
							
				</td></tr>
			</table>
		</td>
		
		</tr>
		

		</table>
<%	
	}
%>

<%@ include file = "include/htmlbottom.jsp" %>
