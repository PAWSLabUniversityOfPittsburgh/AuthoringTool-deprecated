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
          <td class="tabhead" width="1"><nobr><a href="TopicAuthoring.jsp" STYLE="text-decoration:none">Topic Authoring</a></nobr></td>                                 
          <td class="tabhead" width="1"><nobr><a href="authoring.jsp" STYLE="text-decoration:none">Quizjet Authoring</a></nobr></td>    
          <td class="tabhead" width="1"><nobr>Example Authoring</nobr></td>                          
          
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
				<li><a href="create_example.jsp">Create</a></li>	
				<li><a href="displayA1.jsp">Modify</a></li>  
				<li><a href="concept_indexing1.jsp?sc=12&ex=-1">Index</a></li> 
				
			</ul>
								
				
		 <!--	@roya : These lines are commented for the current release, may be added based on future needs
		 		
		<b> Assign User Example </b>
			<ul>
				<li><a href="assignuser_ex.jsp">to Annotate</a></l
				<li><a href="assignuser_rate.jsp">to Rate</a></li>		
         	</ul>
				 	 //-->		
		<b><img src=images/owner.gif>&nbsp;&nbsp;<a href="mine.jsp">My Examples</a></b> 				
				 	 
	  </td>
    </tr> 
    </table>	
<%@ include file = "include/htmlbottom.jsp" %>