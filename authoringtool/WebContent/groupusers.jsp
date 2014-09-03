<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>
	<table width="100%" cellpadding="0" cellspacing="0">
    <tr> 
     <td>
    	<table width="100%" cellspacing="0" cellpadding="0">
        <tr> 
         <td width="1" class="tabhead"><nobr>Modify Group Users</nobr></td>
         <td width="*">&nbsp;</td>
        </tr>
        </table>
     </td>
    </tr>
    <tr> 
    <td class="tabmain">
<%  
	if ((userBean.isAdmin() || userBean.isSuperUser()) && userBean.getGroupBean() != null) {		
%>
		<ul>	
			<li><a href="addusers.jsp">Add Users to the Group <b><%=userBean.getGroupBean().getName()%></b></a></li><br />
			<li><a href="modifyusers.jsp">Modify Users' Rights for the Group <b><%=userBean.getGroupBean().getName()%></b></a></li><br />
			<li><a href="deleteusers.jsp">Delete Users from the Group <b><%=userBean.getGroupBean().getName()%></b></a></li>
		</ul>
<%				
	}
%>	
	</td>
    </tr> 
    </table>    	
<%@ include file = "include/htmlbottom.jsp" %>