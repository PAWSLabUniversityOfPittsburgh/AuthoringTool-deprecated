<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>

<table cellpadding="0" cellspacing="0">
<tr> 
 <td class="tabhead"><nobr>Modify A User</nobr>     </td>
</tr>
<tr> 
 <td class="formtabmain">

<% 		
		if (!userBean.isAdmin()) {
%>			You do not have sufficient rights to perform this operation. Only <a href="mailto:sas15@pitt.edu">System Administrator</a> can modify users.<br/>
			Return to <a href="home.jsp">Home</a>. 			
<%		} else {
			int MAX_ITEMS_ON_PAGE = 20;
			int thisPage, prevPage;
			Vector userList = (Vector) session.getAttribute("userList");
			String strPageNum = (String) request.getParameter("page");
			int pageNum = 0;
			if (strPageNum != null)
				pageNum = (new Integer(strPageNum)).intValue();
			int firstOnPage	= pageNum * MAX_ITEMS_ON_PAGE;
%>
			<form name="formDeleteUser" id="formDeleteUser" method="post" action="userinfo.jsp?action=MODIFYUSER">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td class="formfieldlight">
<%
				for (int i = firstOnPage; i < firstOnPage + MAX_ITEMS_ON_PAGE && i < userList.size(); i++) {
					UserBean uBean = (UserBean) userList.elementAt(i);
%>					
					<input type="radio" <%=(uBean.getId() == userBean.getId()) ? "disabled" : ""%> 
						value="<%=i%>" name="index">
							<%=uBean.getLogin()%> : <%=uBean.getRole()%><br />
<%
				}
%>				
					</td>
				</tr>
			</table>
			<div align="right">
<%
				for (int i = 0; i < userList.size() / MAX_ITEMS_ON_PAGE; i++) 
					if (i == pageNum) {
%>					
						<%=(i+1)%>
<%
					} else {
%>					
						<a href="modifyuserlist.jsp?page=<%=i%>"><%=(i+1)%></a>&nbsp;
<%
					}
%>						
			</div>
			</td></tr>
			<tr>
			<td class="formbuttons">				    
			<input name="submit" type="submit" value="Modify User" />
			</td>
			</tr> 
		</form>		
<%	
	}
%>
</td>
</tr>
</table>
<%@ include file = "include/htmlbottom.jsp" %>