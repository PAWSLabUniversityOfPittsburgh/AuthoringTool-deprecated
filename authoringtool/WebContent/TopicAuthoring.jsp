<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>

	<table width="100%" cellpadding="0" cellspacing="0">
    <tr> 
      <td>
    	<table width="100%" cellspacing="0" cellpadding="0">
        <tr> 
        <!-- 
            <td class="tabhead" width="1"><nobr><a href="ScopeAuthoring.jsp" STYLE="text-decoration:none">Scope Authoring</a></nobr></td>                                 
         -->
          <td class="tabhead" width="1"><nobr>Topic Authoring</nobr></td>                          
          <td class="tabhead" width="1"><nobr><a href="authoring.jsp" STYLE="text-decoration:none">Quizjet Authoring</a></nobr></td>    
          <td class="tabhead" width="1"><nobr><a href="example.jsp" STYLE="text-decoration:none">Example Authoring</a></nobr></td>                          
          
          <!--  @roya : These lines are commented for the current release, may be added based on future needs
          <td class="tabhead" width="1"><nobr><a href="conceptAuthoring.jsp" STYLE="text-decoration:none">Concept Authoring</a></nobr></td>
          <td class="tabhead" width="1"><nobr><a href="crawl.jsp" STYLE="text-decoration:none">Crawl Example</a></nobr></td>
          -->
          <td width="*">&nbsp;</td>
        </tr>

   
       
        </table>
      </td>
    </tr>    
    <tr> 
      <td class="tabmain">
      
			<ul>
				<li><a href="jquiz_create.jsp">Create</a></li>	
				<li><a href="jquiz_modify.jsp">Modify</a></li>
			</ul> 
			
				
			<b><img src=images/owner.gif>&nbsp;&nbsp;<a href="myQuizzes.jsp">My Topics</a></b>
			
		   		
	  </td>
    </tr> 
    </table>	
<%@ include file = "include/htmlbottom.jsp" %>