<%@ page language="java" import="java.util.*,edu.pitt.sis.paws.authoring.beans.QuizBean"%>

<%@ include file = "include/htmltop.jsp" %>

<script language="javascript" type="text/javascript">
<!--
	void function confirmTake() {
		return confirm("This will open a new window in which the quiz will be loaded. Are you ready to take the quiz?");
	}
	
// -->
</script>

<table cellpadding="0" cellspacing="0">
<tr> 
 <td class="tabhead"><nobr>Available Quizzes</nobr></td>
</tr>
<tr> 
 <td class="formtabmain">
<table width="100%" cellpadding="0" cellspacing="0">
<tr>
	<td class="formfielddark"><b>Quiz Title</b></td>
	<td class="formfielddark"><b>Last Modified</b></td>
	<td class="formfielddark">Click below to take quiz</td>
</tr>

<%				List quizList = new ArrayList();
				quizList = (List)request.getAttribute("displayQuizList.quizList");
				
				for (ListIterator it = quizList.listIterator(); it.hasNext();) 
				{
					QuizBean quizBean = (QuizBean) it.next();
%>
<tr>
	<td class="formfieldlight"><%=quizBean.getTitle()%></td>
	<td class="formfieldlight"><%=quizBean.getModified()%></td>
	<td class="formfieldlight"><a href="http://sergeypart.cgi?quizid=<%=quizBean.getId()%>" onClick="return confirmTake()">Take Quiz</a></td>
</tr>
<%				}
%>
</table>
</td>
</tr>
</table> 
<%@ include file = "include/htmlbottom.jsp" %>