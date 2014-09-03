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
			
      <b> Scope Authoring:</b>
			<ul>
				<li><a href="scope_create.jsp">Create</a></li>
				<li><a href="scope_modify.jsp">Modify</a></li>		
			</ul>
			
			
								
				
		 <!--	@roya : These lines are commented for the current release, may be added based on future needs
		 		
		<b> Assign User Example </b>
			<ul>
				<li><a href="assignuser_ex.jsp">to Annotate</a></l
				<li><a href="assignuser_rate.jsp">to Rate</a></li>		
         	</ul>
				 	 //-->		
		<b><img src=images/owner.gif>&nbsp;&nbsp;<a href="myScopes.jsp">My Scopes</a></b>
				 	 
	  </td>
    </tr> 
    </table>	
<%@ include file = "include/htmlbottom.jsp" %>