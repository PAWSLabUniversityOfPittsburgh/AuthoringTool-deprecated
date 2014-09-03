<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>

	<table width="100%" cellpadding="0" cellspacing="0">
    <tr> 
     <td>
    	<table width="100%" cellspacing="0" cellpadding="0">
        <tr> 
         <td width="1" class="tabhead"><nobr>My Account</nobr></td>
         <td width="1" class="tabhead"><nobr><a href="myAuthorings.jsp" STYLE="text-decoration:none">My Authoring</a></nobr></td>
         <td width="*">&nbsp;</td>
        </tr>
        </table>
     </td>
    </tr>
    
    
    <tr> 
    <td class="tabmain">

<%	Vector groupList = (Vector)session.getAttribute("groupList");
    if (groupList == null)
    	return;
	if(groupList.size() > 1) {
%>  	<b>Switch Group :</b>
      	<br/>
        | 
<%
				ListIterator i = groupList.listIterator();
				while(i.hasNext()) {
	                GroupBean gBean = (GroupBean) i.next();
%>					<a href="SecurityServlet?action=SWITCHGROUP&index=<%=i.previousIndex()%>">
<%					if(gBean.getId() == userBean.getGroupBean().getId()) {
%>						<b><%=gBean.getName()%></b>
<%					}
					else {
%>						<%=gBean.getName()%>
<%					}
%>					</a> |                 
<%				}
	}
%>	
    <ul>
        <li><a href="userinfo.jsp?action=MODIFYUSERINFO">Modify Personal Data</a></li>
        <li><a href="SecurityServlet?action=LOGOUT">Logout</a></li>
    </ul>
	</td>
   </tr> 
   </table>
	
	
<%@ include file = "include/htmlbottom.jsp" %>