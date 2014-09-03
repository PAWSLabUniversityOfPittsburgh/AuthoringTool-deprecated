<%@ page language="java"%>
<%@ include file = "include/htmltop.jsp" %>
<% String url = (String)request.getAttribute("url"); %>
<% Integer countLink = (Integer)request.getAttribute("countLink"); %>
<script language="javascript">
function checkAll(){
	for (var i=0;i<document.forms[0].elements.length;i++)
	{
		var e=document.forms[0].elements[i];
		if ((e.name != 'allbox') && (e.type=='checkbox'))
		{
			e.checked=document.forms[0].allbox.checked;
		}
	}
}
</script>
 
  the site u entered is: <%=url%> <br>
  total links were crawled: <%=countLink%>  <br>
      
      <form name="extractdata" action="extract1.jsp" method="post">
      <input type="checkbox" value="on" name="allbox" onclick="checkAll();"/> Check all &nbsp;&nbsp;<input type="submit" value="Extract Concepts" onClick="submitFunction(this.form,3)">&nbsp;&nbsp;<input type="submit" value="import" onClick="submitFunction(this.form,2)"><br>
      <input type="hidden" name="totalcrawl" value=<%=countLink%>>
      <table border="0">
	<tr><td>Crawled Link</td></tr>
  <%
        int i=1;
      	while(i<=countLink){
      		String file = (String)request.getAttribute("'F'"+i);
      		%>
      		<input type="hidden" name=ID<%=i%> value=<%=i%>>
      		      <tr>
      			<td>		
      		<INPUT NAME=OP<%=i%> TYPE="CHECKBOX" VALUE="<%=url+file%>"><a href=<%=url+file%>><%=url+file%></a>
      			</td>

      		     </tr>
      		
      			<%
      		i=i+1;
      	}
      
  %>
  	</table>
      </form>
<script language="JavaScript">
<!-- 

function submitFunction(obj,i) {
   if (i==1) obj.action=
      "extractPkg.jsp";
   if (i==2) obj.action=
      "extract1.jsp";
   if (i==3) obj.action=
      "Main";      
   obj.submit()
   }
//-->
</script>  
<%@ include file = "include/htmlbottom.jsp" %>