<%@ page language="java" import="edu.pitt.sis.paws.authoring.beans.UserBean,java.util.List,java.util.Iterator" %>

<%@ include file = "include/htmltop.jsp" %>

<script language="javascript" type="text/javascript">
<!--
	void function confirmDelete() {
		return confirm("Are you sure you want to delete this user?");
	}
	
// -->
</script>

<table cellpadding="0" cellspacing="0">
<tr> 
 <td class="tabhead"><nobr>Delete A User</nobr>     </td>
</tr>
<tr> 
 <td class="formtabmain">

<% 		if(!userBean.isAdmin())
		{
%>			You donot have sufficient rights to perform this operation. Only System Administrator can delete users.<br/>
			Return to <a href="home.jsp">Home</a>. 			
<%		}
		else
		{
			List userList;
			if(request.getParameter("referrer").equalsIgnoreCase("SecurityServlet")) // this page was called first time
			{
				userList = (List) session.getAttribute("displayDeleteUsers.UserList");
%>
				<form name="formDeleteUser" id="formDeleteUser" method="post" action="servlet/quizpack.servlets.SecurityServlet?request=DELETEUSER">
	<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
	<td class="formfieldlight">
				<select name="userid" size="5">
<%
				for (Iterator it = userList.iterator(); it.hasNext();) 
				{
					UserBean uBean = (UserBean) it.next();
%>					<option value="<%=uBean.getId()%>"><%=uBean.getName()%></option>
<%				}
%>					</select>
	</td>
	</tr>
	</table>
</td>
</tr>
<tr>
<td class="formbuttons">				    
  <input name="submit" type="submit" value="Delete User" onClick="return confirmDelete()" />
</td>
</tr> 
</form>
<%	}
	else
	{
%>		Please use the Delete User option from <a class="menu" href="sysmanage.jsp">System Management to delete a user.</a> <br/>
<%	}		
}/* end of else if Admin */

%>
</table>
<%@ include file = "include/htmlbottom.jsp" %>