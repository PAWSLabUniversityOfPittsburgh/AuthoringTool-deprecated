<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>

	<table width="100%" cellpadding="0" cellspacing="0">
    <tr> 
      <td>
    	<table width="100%" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="1" class="tabhead"><nobr><a href="myaccount.jsp" STYLE="text-decoration:none">My Account</a></nobr></td>
         <td width="1" class="tabhead"><nobr>My Authoring</nobr></td>
         <td width="*">&nbsp;</td>
        </tr>

   
       
        </table>
      </td>
    </tr>    
    <tr> 
      <td class="tabmain">
			<ul>
				<li><a href="myQuizzes.jsp">My Topics</a></li>	
				<li><a href="myQuestions.jsp">My Questions</a></li>					
				<!-- ><li><a href="myScopes.jsp">My Scopes</a></li>-->
				<li><a href="mine.jsp">My Examples</a></li>	
				<!--  @roya : These lines are commented for the current release, may be added based on future needs
				<li><a href="myConcepts.jsp">My Concepts</a></li>		
				-->			
								
			</ul> 				
  </td>
    </tr> 
    </table>	
<%@ include file = "include/htmlbottom.jsp" %>