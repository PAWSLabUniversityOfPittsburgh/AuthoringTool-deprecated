<%@ page language="java" import="edu.pitt.sis.paws.authoring.beans.UserBean" %>

<%@ include file = "include/htmltop.jsp" %>

	<table cellpadding="0" cellspacing="0">
    <tr> 
     <td class="tabhead"><nobr>Create A User</nobr>     </td>
    </tr>
    <tr> 
     <td class="formtabmain">
<% 			
 			if(request.getParameter("referrer").equalsIgnoreCase("CreateUser"))
 			{
				UserBean newUserBean = new UserBean();
				
				newUserBean.setName(request.getParameter("username"));
				newUserBean.setPassword(request.getParameter("password"));
				newUserBean.setRole(request.getParameter("role"));
				
				session.setAttribute("newUserBean",newUserBean);
	 			
	%>			<jsp:forward page="servlet/quizpack.servlets.SecurityServlet?request=INSERTUSER" /> 	
	<%		}
 			if(!userBean.isAdmin())
			{
%>				You donot have sufficient rights to perform this operation. Only System Administrator can create new users.<br/>
				Return to <a href="home.jsp">Home</a>. 			
<%			}
			else
			{
				UserBean newUserBean = new UserBean();
				newUserBean.setRole("user");
%>				
				<form name="formCreateUser" id="formCreateuser" method="post" action="createUser.jsp">
				<input type="hidden" name="referrer" value="CreateUser" />
				<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
				 <td class="formfieldlight formfieldbottomborder formfieldaligntright">Username :</td>
				 <td class="formfieldlight formfieldbottomborder"><input type="text" name="username" value="<%=newUserBean.getName()%>"/>&nbsp;</td>
				</tr>
				<tr>
				 <td class="formfielddark formfieldbottomborder formfieldaligntright">Password :</td>
				 <td class="formfielddark formfieldbottomborder"><input name="password" type="text" value="<%=newUserBean.getPassword()%>"/>&nbsp;</td>
			    <tr>
			     <td class="formfieldlight formfieldaligntright">Role :</td>
			     <td class="formfieldlight">
			     	<select name="role" size="1">
<%				String selected = "";
					
					if(newUserBean.isSuperUser())
				    	selected="selected=\"selected\"";
				    else
				    	selected="";
%>				      <option value="superuser" <%=selected%> >Super User</option>
<%					selected = "";
					if(newUserBean.isAdmin())
				    	selected="selected=\"selected\"";
				    else
				    	selected="";
%>				      <option value="admin" <%=selected%> >System Administrator</option>
<%					selected = "";
					if(!(newUserBean.isAdmin() || newUserBean.isSuperUser()))
				    	selected="selected=\"selected\"";
				    else
				    	selected="";
%>				      <option value="user" <%=selected%> >User</option>
				    </select>
				  </td>
				 </tr>   
				</table>
	</td>
	</tr>
	<tr>
	<td class="formbuttons">				    
	  <input name="submit" type="submit" value="Create User" />
	</td>
    </tr> 
	</form>
<%
		}
%>  

    </table>
<%@ include file = "include/htmlbottom.jsp" %>