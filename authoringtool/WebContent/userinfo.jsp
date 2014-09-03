<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>

<script language="JavaScript" type="text/javascript">
<!--
function validateForm() {
    var reName = new RegExp(/\w+/);
    if(!reName.test(document.formUser.name.value)) {
        alert("User name cannot be empty");
        return false;
    }
	var reNotLogPass = new RegExp(/[a-zA-Z0-9_]+[a-zA-Z0-9_;:,-\.]*/); /*\W+*/
    if(!reNotLogPass.test(document.formUser.login.value)) {
        alert("User login can have only alphanumerical symbols and underscores");
        return false;
    }

	if(!reNotLogPass.test(document.formUser.password.value)) {
        alert("User password can have only alphanumerical symbols and underscores");
        return false;
    }
	if (document.formUser.password.value != document.formUser.checkpassword.value) {
		alert("Passwords do not match");
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
	UserBean modifyUserBean = null;
	int index = 0;
 	if (action != null) {		
		if (action.equalsIgnoreCase("MODIFYUSER")) {
			if (userBean.isAdmin()) {
				Vector userList = (Vector) session.getAttribute("userList");
				session.removeAttribute("userList");
				try {
					index = (new Integer ((String) request.getParameter("index"))).intValue();
				} catch (NumberFormatException e) {
					System.out.println("[userinfo.jsp]: incorrect index");
					e.printStackTrace();            
				}
				modifyUserBean = (UserBean) userList.elementAt(index);				
				welcome = "Modify User <i>" + modifyUserBean.getLogin() + "</i>:";
			} 
		} else if (action.equalsIgnoreCase("CREATEUSER")) {
			if (userBean.isAdmin())
				welcome = "Create New User:";
		} else if (action.equalsIgnoreCase("MODIFYUSERINFO"))
			welcome = "Modify Personal Data:";
		if (welcome == null) {
			welcome = "You do not have sufficient rights to perform this operation. " +
					 "Only <a href=\"mailto:roh38@pitt.edu\">System Administrator</a> " +
					 "can create new users.<br/> Return to <a href=\"home.jsp\">Home</a>";
%>

		<td><h3><%=welcome%></h3></td>
    </tr>
<%			
		} else {
		System.out.println((action.equalsIgnoreCase("MODIFYUSER")) ? modifyUserBean.getLogin() :
						   (action.equalsIgnoreCase("MODIFYUSERINFO")) ? userBean.getLogin() : "");
%>
	    <tr> 
		<td><h3><nobr><%=welcome%></nobr> </h3>    </td>
    </tr>
    <tr> 
		<td>	
			<form name="formUser" id="formUser" method="post" action="SecurityServlet?action=<%=action%>" onSubmit="return validateForm();">
						<input type="hidden" name="id" value="
							<%=(action.equalsIgnoreCase("MODIFYUSER")) ? modifyUserBean.getId() :
						   (action.equalsIgnoreCase("MODIFYUSERINFO")) ? userBean.getId() : -1%>
						" />
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td class="formfielddark formfieldaligntright">Name :</td>
					<td >
						<input type="text" name="name" value="<%=""+((action.equalsIgnoreCase("MODIFYUSER"))?""+modifyUserBean.getName().trim():""+((action.equalsIgnoreCase("MODIFYUSERINFO"))?""+userBeanName:""))%>" />&nbsp;
					</td>
				</tr>
				<tr>
					<td class="formfieldlight  formfieldaligntright">Login :</td>
					<td>
						<input type="text" name="login" <%=(!userBean.isAdmin()) ? "readonly" : ""%> value="<%=(action.equalsIgnoreCase("MODIFYUSER"))?modifyUserBean.getLogin().trim():(action.equalsIgnoreCase("MODIFYUSERINFO"))?userBean.getLogin().trim():""%>" />&nbsp;
					</td>
				</tr>
				<tr>
					<td class="formfielddark  formfieldaligntright">Password :</td>
					<td>
						<input type="password" name="password" value="" />&nbsp;
					</td>
				</tr>
				<tr>
					<td class="formfieldlight  formfieldaligntright">Repeat Password :</td>
					<td >
						<input type="password" name="checkpassword" value="">&nbsp;
					</td>
				</tr>
  				<tr>
					<td class="formfielddark  formfieldaligntright">Role :</td>
					<td>
					<% if (userBean.getRole().equals("admin")) {%>
					
					<select name="role" <%=(!userBean.isAdmin()) ? "readonly" : ""%> size="1">
<%			
			String role = (action.equalsIgnoreCase("MODIFYUSER")) ? modifyUserBean.getRole() :
						   (action.equalsIgnoreCase("MODIFYUSERINFO")) ? userBean.getRole() : "";
%>				    	<option <%=(role.equalsIgnoreCase("admin")) ? "selected" : ""%> value="admin">
							System Administrator
						</option>
						<option <%=(role.equalsIgnoreCase("superuser")) ? "selected" : ""%> value="superuser">
							Super User
						</option>
						<option <%=(role.equalsIgnoreCase("user")) ? "selected" : ""%> value="user">
							User
						</option>
				    </select>
				      <%}
				      else {
				      out.println(userBean.getRole());
				      }%>
					</td>
				</tr>   
				</table>
				</td>
				</tr>
				<tr>
					<td>				    
						<input name="submit" type="submit" value="Submit" />
					</td>
				</tr> 
			
			</form>
<%	
		}
	}
%>

    </table>
<%@ include file = "include/htmlbottom.jsp" %>