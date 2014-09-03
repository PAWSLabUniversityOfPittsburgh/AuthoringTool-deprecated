<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>

	<table width="100%" cellpadding="0" cellspacing="0">
    <tr> 
      <td>
    	<table width="100%" cellspacing="0" cellpadding="0">
        <tr> 
          <td class="tabhead" width="1"><nobr>Example Authoring</nobr></td>
          <td width="*">&nbsp;</td>
        </tr>
        </table>
      </td>
    </tr>    
    <tr> 
      <td class="tabmain">
		<b> Modify </b>
			<ul>
                <li><a href="quizinfo.jsp?action=CREATEQUIZ">New</a></li>
				<li><a href="QuizServlet?action=GETMODIFYQUIZLIST">Mofigy</a></li>
				<li><a href="QuizServlet?action=GETDELETEQUIZLIST">Delete</a></li>
			</ul>         
		<b> Create </b>
			<ul>
				<li><a href="quesinfo.jsp?action=CREATEQUESTION">New</a></li>	
				<li><a href="QuestionServlet?action=GETMODIFYQUESLIST">Modify</a></li>            	
				<li><a href="QuestionServlet?action=GETDELETEQUESLIST">Delete</a></li>	

			</ul> 
	  </td>
    </tr> 
    </table>	
<%@ include file = "include/htmlbottom.jsp" %>