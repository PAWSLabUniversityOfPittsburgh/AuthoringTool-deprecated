<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>
<%@ include file = "include/connectDB.jsp" %>

<script language="javascript">
function send_iswriting(e){
     var key = -1 ;
     var shift ;

     key = e.keyCode ;
     shift = e.shiftKey ;

     if ( !shift && ( key == 13 ) )
     {
          document.form.reset() ;
     }
}
</script>
<script src="<%=request.getContextPath()%>/js/jquery1.4.2.js"></script>

<script type="text/javascript">
$(document).ready(function(){
	$("input").click(function () {
		var fn = $(this).attr('fn');
		if (fn == 'createQuiz')
		{
			var title1 = document.fr1.title1.value;	
			if(title1 == ""){alert("Title cannot be empty!"); return false;}	
			else if (!document.fr1.privacy1[0].checked && !document.fr1.privacy1[1].checked){alert("Please select the privacy."); return false;}	
			else {   		
				if (title1!="" && (document.fr1.privacy1[0].checked || document.fr1.privacy1[1].checked) && i==1) 
				{$("#fr1").submit(); return true;}
		      	}
		}
	});	
});	
</script>

<script type="text/javascript">
<!-- 


	
function function3(obj,i){ 	
   if (i==1) 
   {window.open('classcombo.jsp','_blank');}
   }
//-->
</script>



<%

     String uid = "";
     Statement statement = conn.createStatement();
     ResultSet rs = statement.executeQuery("SELECT id FROM ent_user where name = '"+userBeanName+"' ");
     while(rs.next())
	 {
    	 uid = rs.getString(1);
	 }
 %>
<table>
<tr><td>
<form name="fr1" id  ="fr1"  method="post" action = "javaq_create_save1.jsp">

<table>
<tr><td>
<h3>Create Java Topic:</h3></td></tr>

	<tr>
		<td class="formfielddark"><b>Title:<font color="red">*</font></b></td>
		<td><input type="text" name="title1" size="45" maxlength="45"></td>
	</tr>
	<tr>
		<td class="formfielddark"><b>Description:</b>	</td>
		<td><textarea rows = 3 name="description1"  cols="70"></textarea></td>
	</tr>
	<tr>
		<td class="formfielddark"><B>Privacy:<font color="red">*</font></b></td>
		<td class="formfieldlight"><input type="RADIO" name="privacy1" value="private">Private <input type="RADIO" name="privacy1" value="public">Public</td>
	</tr>
	<tr>
		<td></td>
		<td><input type="submit" value="Create" fn = 'createQuiz' >&nbsp;&nbsp;<input type="reset" value="Clear" OnClick="document.form.message.focus()"></td>
	</tr>
	<tr>
		<td></td>
		<td><b><font color="blue" size="3">
		 </font></b></td>
	</tr>	
	</table></form>	</td></tr>

</table>   

