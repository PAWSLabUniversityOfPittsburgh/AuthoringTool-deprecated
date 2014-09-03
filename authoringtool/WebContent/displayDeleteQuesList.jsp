<%@ page language="java" import="java.util.*,edu.pitt.sis.paws.authoring.beans.QuestionBean "%>
<%@ include file = "include/htmltop.jsp" %>

<script language="javascript" type="text/javascript">
<!--
	void function confirmDelete() {
		return confirm("Are you sure you want to delete this question?");
	}
	
// -->
</script>

<table cellpadding="0" cellspacing="0">
	<tr> 
	 <td class="tabhead"><nobr>Questions that can be deleted</nobr>     </td>
	</tr>
	<tr> 
	 <td class="formtabmain">
	<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td class="formfielddark"><b>Question Title</b></td>
		<td class="formfielddark"><b>Answer Type</b></td>
		<td class="formfielddark"><b>Difficulty</b></td>
		<td class="formfielddark"><b>Complexity</b></td>
<%		if(userBean.isAdmin())
		{
%>		<td class="formfielddark">Authored by <%=userBeanName%></td>
<%		}
%>		<td class="formfielddark">Click below to delete</td>
	</tr>
<%				List deleteQuestionList = new ArrayList();
				deleteQuestionList = (List)request.getAttribute("deleteQuestionList");
				
				for (ListIterator it = deleteQuestionList.listIterator(); it.hasNext();) 
				{
					QuestionBean questionBean = (QuestionBean) it.next();
%>
	<tr>
		<td class="formfieldlight"><%=questionBean.getTitle()%></td>
		<td class="formfieldlight"><%=questionBean.getAnswerType()%></td>
		<td class="formfieldlight"><%=questionBean.getDifficulty()%></td>
		<td class="formfieldlight"><%=questionBean.getComplexity()%></td>
<%					if(userBean.isAdmin())
					{
						if(userBean.getId() == questionBean.getAuthorId())
						{
%>							<td class="formfieldlight">Yes</td>
<%						}
						else
						{
%>		<td class="formfieldlight">No</td>						
<%						}
					}
%>		<td class="formfieldlight"><a href="quizpack.servlets.QuestionServlet?request=DELETEQUESTION&questionid=<%=questionBean.getId()%>" onClick="return confirmDelete()">Delete</a></td>
	</tr>
<%				}
%></table>

	</td>
	</tr> 
	</table>
<%@ include file = "include/htmlbottom.jsp" %>