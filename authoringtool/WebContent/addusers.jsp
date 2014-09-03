<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>

<script type="text/javascript">
<!--

function disableIt(obj)
{
	obj.disabled = !(obj.disabled);
	obj.checked = false;
}

// -->
</script>


<table cellpadding="0" cellspacing="0">
<tr> 
 <td class="tabhead"><nobr>Add Users to the Group</nobr>     </td>
</tr>
<tr> 
 <td class="formtabmain">

<% 		if (userBean.isAdmin() || userBean.isGroupOwner(userBean.getGroupBean())) {
			int MAX_ITEMS_ON_PAGE = 20;
			int thisPage,prevPage;
			Vector userList = (Vector) session.getAttribute("userList");
			if (userList == null) {
%>
				<jsp:forward page="SecurityServlet?action=GETADDGROUPUSERLIST&sender=addusers" />
<%			
			}
			session.removeAttribute("userList");
			session.setAttribute("addUserList", userList);
			String strPageNum = (String) request.getParameter("page");
			int pageNum = 0;
			if (strPageNum != null)
				pageNum = (new Integer(strPageNum)).intValue();
			int firstOnPage	= pageNum * MAX_ITEMS_ON_PAGE;
%>
			<form name="formAddUsers" id="formAddUsers" method="post" action="SecurityServlet?action=ADDUSERSTOGROUP">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td class="formfieldlight">&nbsp;&nbsp;&nbsp;<b>User Login</b>&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td class="formfieldlight">&nbsp;&nbsp;&nbsp;<b>User can modify Group's artifacts&nbsp;&nbsp;</b></td>
				</tr>
<%
				int j = 0;
				for (int i = firstOnPage; i < firstOnPage + MAX_ITEMS_ON_PAGE && i < userList.size(); i++) {
					UserBean uBean = (UserBean) userList.elementAt(i);
					if (userBean.isAdmin() || (!uBean.isGroupOwner(userBean.getGroupBean()) && !uBean.isAdmin())) {
						j++;
%>
				<tr>
					<td class="<%=(j % 2 == 0) ? "formfieldlight" : "formfielddark"%> formfieldaligncenter"> <input type="checkbox" name="<%=(uBean.getId())%>" value="yes" onChange="javascript:disableIt(document.forms[0].<%="rights" + new String((new Integer (uBean.getId())).toString())%>);">&nbsp;<%=(uBean.getLogin())%> </td>				
					
					<td class="<%=(j % 2 == 0) ? "formfieldlight" : "formfielddark"%> formfieldaligncenter"> <input disabled type="checkbox" name="<%="rights" + new String((new Integer (uBean.getId())).toString())%>" value="yes"> </td>
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