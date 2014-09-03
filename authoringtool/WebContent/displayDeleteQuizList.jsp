<%@ page language="java" import="java.util.*,edu.pitt.sis.paws.authoring.beans.QuizBean"%>

<%@ include file = "include/htmltop.jsp" %>

<script language="javascript" type="text/javascript">
<!--
	void function confirmDelete() {
		return confirm("Are you sure you want to delete this quiz?");
	}
	
// -->
</script>

<table cellpadding="0" cellspacing="0">
<tr> 
 <td class="tabhead"><nobr>Quizzes that can be modified</nobr>     </td>
</tr>
<tr> 
 <td class="formtabmain">
<table width="100%" cellpadding="0" cellspacing="0">
<tr>
	<td class="formfielddark"><b>Quiz Title</b></td>
	<td class="formfielddark"><b>Last Modified</b></td>
<%	if(userBean.isAdmin())
	{
%>	<td class="formfielddark">Authored by <%=userBeanName%></td>
<%	}
%>	<td class="formfielddark">Click below to delete</td>
</tr>

<%				List deleteQuizList = new ArrayList();
				deleteQuizList = (List)request.getAttribute("deleteQuizList");
				
				for (ListIterator it = deleteQuizList.listIterator(); it.hasNext();) 
				{
					QuizBean quizBean = (QuizBean) it.next();
%>
<tr>
	<td class="formfieldlight"><%=quizBean.getTitle()%></td>
	<td class="formfieldlight"><%=quizBean.getModified()%></td>
<%					if(userBean.isAdmin())
					{
						if(userBean.getId() == quizBean.getAuthorId())
						{
%>	<td class="formfieldlight">Yes</td>
<%						}
						else
						{
%>	<td class="formfieldlight">No</td>						
<%						}
					}
%>	<td class="formfieldlight"><a href="quizpack.servlets.QuizServlet?request=DELETEQUIZ&quizid=<%=quizBean.getId()%>" onClick="return confirmDelete()">Delete</a></td>
</tr>
<%				}
%>
</table>
</td>
</tr>
</table> 
<%@ include file = "include/htmlbottom.jsp" %>