<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>

<script language="JavaScript" type="text/javascript">
<!--
function validateForm() {
	var reNotName = new RegExp(/\W+/);
    if(reNotName.test(document.formUser.login.value)) {
        alert("Group Name can have only alphanumerical symbols and underscores");
        return false;
    }
	return true;
}
-->
</script>

<table cellpadding="0" cellspacing="0">
    <tr> 
<% 				
	String action = request.getParameter("action");
	String welcome = null;
	int index = 0;
	Vector userList = null;
 	if (action != null) {		
		if ((action.equalsIgnoreCase("MODIFYGROUP") || action.equalsIgnoreCase("DELETEGROUP"))
			&& userBean.getGroupBean() != null) {
			userList = (Vector) session.getAttribute("userList");
			if (userList == null) {
				if (action.equalsIgnoreCase("MODIFYGROUP")) {
%>
				<jsp:forward page="SecurityServlet?action=GETMODIFYGROUPUSERLIST&sender=groupinfo" />
<%			
				} else if (action.equalsIgnoreCase("DELETEGROUP")) {
%>
				<jsp:forward page="SecurityServlet?action=GETDELETEGROUPUSERLIST&sender=groupinfo" />
<%					
				}
			}
		}
		if (action.equalsIgnoreCase("CREATEGROUP")) {
			welcome = "Create New Group:";
		} else if (action.equalsIgnoreCase("MODIFYGROUP")) {
			welcome = "Modify Group <i>" + userBean.getGroupBean().getName() + "</i> :";
		} else if (action.equalsIgnoreCase("DELETEGROUP")) {
			welcome = "Delete Group <i>" + userBean.getGroupBean().getName() + "</i> :";
		} 	
		session.removeAttribute("userList");
%>
	<td class="tabhead"><nobr><%=welcome%></nobr>     </td>
    </tr>
    <tr> 
		<td class="formtabmain">	
			<form name="formGroup" id="formGroup" method="post" action="SecurityServlet?action=<%=action%>" onSubmit="return <%=(action.equalsIgnoreCase("DELETEGROUP")) ? "confirm('Are you sure you want to delete this group?');" : "true" %>">
						<input type="hidden" name="groupId" value="
							<%=(action.equalsIgnoreCase("MODIFYGROUP") || action.equalsIgnoreCase("DELETEGROUP")) ? userBean.getGroupBean().getId() : -1%>
						" />
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td class="formfieldlight formfieldaligntright">Group Name :</td>
					<td class="formfieldlight">
						<input type="text" <%=(action.equalsIgnoreCase("DELETEGROUP")) ? "disabled" :""%> name="name" value="
						<%=(action.equalsIgnoreCase("MODIFYGROUP") || action.equalsIgnoreCase("DELETEGROUP")) ? userBean.getGroupBean().getName() : ""%>
						" />&nbsp;
					</td>
				</tr>
				<tr>
					<td class="formfielddark formfieldaligntright">Number of Users :</td>
					<td class="formfielddark">
						<b><i><%=(action.equalsIgnoreCase("MODIFYGROUP") || action.equalsIgnoreCase("DELETEGROUP")) ? userList.size() : 0%></i></b>
					</td>
				</tr>
				<tr>
					<td class="formfieldlight formfieldaligntright">Group Owner :</td>
					<td class="formfieldlight">						
						<select <%=(action.equalsIgnoreCase("DELETEGROUP")) ? "disabled" :""%> name="ownerId" <%=(!userBean.isAdmin()) ? "readonly" : ""%> size="1">
<%						if (userList != null) { 						
							Iterator i = userList.iterator();
							System.out.println(userList.size());
							while (i.hasNext()) {
								UserBean uBean = (UserBean) i.next();
								System.out.println("user" + uBean.getLogin() + ((uBean.isAdmin()) ? " admin " : ((uBean.isSuperUser() ? " superuser " : ""))));
								if (uBean.isAdmin() || uBean.isSuperUser()) {
%>
								<option <%=(uBean.getId() == userBean.getGroupBean().getOwnerId()) ? "selected" : ""%> value="
								<%=uBean.getId()%>">
									<%=uBean.getLogin()%>
								</option>
<%
								}
							}
						} else {
%>						
								<option selected value="<%=userBean.getId()%>">
									<%=userBean.getLogin()%>
								</option>
<%
						}
%>
				    </select>
					</td>
				</tr>
				</table>
				</td>
				</tr>
				<tr>
					<td colspan="2" class="formbuttons">				    
						<input name="submit" type="submit" value="SUBMIT" />
					</td>
				</tr> 
			
			</form>
<%	
	}
%>

    </table>
<%@ include file = "include/htmlbottom.jsp" %>