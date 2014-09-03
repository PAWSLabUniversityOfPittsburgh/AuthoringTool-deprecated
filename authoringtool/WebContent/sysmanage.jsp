<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>

	<table width="100%" cellpadding="0" cellspacing="0">
    <tr> 
     <td>
    	<table width="100%" cellspacing="0" cellpadding="0">
        <tr> 
         <td width="1" class="tabhead"><nobr>System Management</nobr></td>
         <td width="*">&nbsp;</td>
        </tr>
        </table>
     </td>
    </tr>
    
    
    <tr> 
    <td class="tabmain">

<%  
    if(userBean.isAdmin()) {		
%>      	
		<b>User Management</b>:
		<ul>
			<li><a href="userinfo.jsp?action=CREATEUSER">Create New User</a></li><br />
			<li><a href="SecurityServlet?action=GETMODIFYUSERLIST">Modify Existing User</a></li><br />
			<li><a href="SecurityServlet?action=GETDELETEUSERLIST">Delete User</a></li><br />
		</ul>
<%  
	}
	if (userBean.isAdmin() || userBean.isSuperUser()) {		
%>
		<b>Group Management</b>:
		<ul>
			<li><a href="groupinfo.jsp?action=CREATEGROUP">Create New Group</a></li><br />
<%
			System.out.println((userBean.getGroupBean() != null));
			System.out.println(userBean.isGroupOwner(userBean.getGroupBean()));
			if (userBean.isAdmin() || (userBean.getGroupBean() != null && userBean.isGroupOwner(userBean.getGroupBean()))) {
%>			
			<li><a href="groupinfo.jsp?action=MODIFYGROUP">Modify Info of Group <b><%=userBean.getGroupBean().getName()%></b></a></li><br />
			<li><a href="groupusers.jsp">Modify Users of Group <b><%=userBean.getGroupBean().getName()%></b></a></li><br />
			<li><a href="groupinfo.jsp?action=DELETEGROUP">Delete Group <b><%=userBean.getGroupBean().getName()%></b></a></li>
		</ul>	
<%
			} else if (userBean.getGroupBean() != null) {
%>
		</ul>
			You cannot modify group <b><%=userBean.getGroupBean().getName()%></b>. Create a new group using the link above or switch to a group owned by you <a href="myaccount.jsp">here</a>.
				
				
<%				
			}
	}
%>	
	</td>
    </tr> 
    </table>
    	
<%@ include file = "include/htmlbottom.jsp" %>