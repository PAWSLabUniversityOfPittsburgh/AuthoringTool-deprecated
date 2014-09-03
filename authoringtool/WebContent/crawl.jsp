<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>

	<table width="100%" cellpadding="0" cellspacing="0">
    <tr> 
      <td>
    	<table width="100%" cellspacing="0" cellpadding="0">
        <tr> 

          <td class="tabhead" width="1"><nobr><a href="authoring.jsp" STYLE="text-decoration:none">Quizjet Authoring</a></nobr></td>    
          <td class="tabhead" width="1"><nobr><a href="example.jsp" STYLE="text-decoration:none">Example Authoring</a></nobr></td>                          
          <td class="tabhead" width="1"><nobr><a href="conceptAuthoring.jsp" STYLE="text-decoration:none">Concept Authoring</a></nobr></td>
          <td class="tabhead" width="1"><nobr><a href="crawl.jsp" STYLE="text-decoration:none">Crawl Example</a></nobr></td>
          <td width="*">&nbsp;</td>

        </tr>

   
       
        </table>
      </td>
    </tr>    
    <tr> 
      <td class="tabmain">
    <h1>Java Example Crawler</h1>
    <form name="CrawlMainPage" action="CrawlServletT" method="get" >
      <table width="75%">
        <tr> 
          <td width="20%">input the URL</td>
          <td width="80%">
            <input type="text" name="url" size="50" />
          </td>
        </tr>
      </table>
      <p> 
        <input type="submit" name="Submit" value="Start Crawling" />
        <input type="reset" name="Reset" value="Reset" />
      </p>
    </form>		
	  </td>
    </tr> 
    </table>	
<%@ include file = "include/htmlbottom.jsp" %>