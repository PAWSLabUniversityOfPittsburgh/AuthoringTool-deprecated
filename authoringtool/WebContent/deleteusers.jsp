<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>

<table cellpadding="0" cellspacing="0">
<tr> 
 <td class="tabhead"><nobr>Delete Users from the Group</nobr>     </td>
</tr>
<tr> 
 <td class="formtabmain">

<% 		if (userBean.isAdmin() || userBean.isGroupOwner(userBean.getGroupBean())) {
			int MAX_ITEMS_ON_PAGE = 20;
			int thisPage,prevPage;
			Vector userList = (Vector) session.getAttribute("userList");
			if (userList == null) {
%>
				<jsp:forward page="SecurityServlet?action=GETDELETEGROUPUSERLIST&sender=deleteusers" />
<%			
			}			
			session.removeAttribute("userList");
			session.setAttribute("deleteUserList", userList);
			String strPageNum = (String) request.getParameter("page");
			int pageNum = 0;
			if (strPageNum != null)
				pageNum = (new Integer(strPageNum)).intValue();
			int firstOnPage	= pageNum * MAX_ITEMS_ON_PAGE;
%>
			<form name="formDeleteUsers" id="formDeleteUsers" method="post" action="SecurityServlet?action=DELETEUSERSFROMGROUP" onSubmit="return confirm('Are you sure you want to delete these users from the group' + '<%=userBean.getGroupBean().getName()%>' + '?');">
			<table width="100%" cellpadding="0" cellspacing="0">

<%
				int j = 0;
				for (int i = firstOnPage; i < firstOnPage + MAX_ITEMS_ON_PAGE && i < userList.size(); i++) {
					UserBean uBean = (UserBean) userList.elementAt(i);
					if (userBean.isAdmin() || (!uBean.isGroupOwner(userBean.getGroupBean()) && !uBean.isAdmin())) {
						j++;
%>					
				<tr>
					<td class="<%=(j % 2 == 0) ? "formfieldlight" : "formfielddark"%> formfieldaligncenter"> <input type="checkbox" name="<%=(uBean.getId())%>" value="yes">&nbsp;<%=uBean.getLogin()%> </td>
					</tr>
<%
					}
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
						<a href="deleteuserlist.jsp?page=<%=i%>"><%=(i+1)%></a>&nbsp;
<%
					}					
%>			
			</div>
			</td></tr>
			<tr>
			<td class="formbuttons">				    
			<input name="submit" type="submit" value="SUBMIT"/>
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