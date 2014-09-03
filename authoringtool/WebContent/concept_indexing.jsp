<%@ page language="java" %>
<%@ include file = "include/htmltop.jsp" %>
<%@ include file = "include/connectDB.jsp" %>

<%@ page import="java.sql.*" %>

	<style>
	.multipleSelectBoxControl span{	/* Labels above select boxes*/
		font-family:arial;
		font-size:11px;
		font-weight:bold;
	}
	.multipleSelectBoxControl div select{	/* Select box layout */
		font-family:arial;
		height:100%;
	}
	.multipleSelectBoxControl input{	/* Small butons */
		width:25px;	
	}
	
	.multipleSelectBoxControl div{
		float:left;
	}
		
	.multipleSelectBoxDiv
	</style>

<script language="javascript">
<!--

function cOn(td){
if(document.getElementById||(document.all && !(document.getElementById))){
td.style.backgroundColor="#ffffe1";
}
}

function cOut(td){
if(document.getElementById||(document.all && !(document.getElementById))){
td.style.backgroundColor="#FFCC00";
}
}
//-->
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
<script language=javascript>
changelist();
function changelist()
{
var scopeid=document.myForm.sc.value;
if (scopeid != '-1')
	document.location.href="concept_indexing1.jsp?sc="+scopeid+"&ex=-1";   

}                                                                                
</script>

<%
    ResultSet results = null;
    Statement stmts = null;
    ResultSetMetaData rsmds = null;   	
   
    String sc="";       	
        
     String uid="";
     ResultSet rs = null;
     try{          
     stmts = conn.createStatement();  
     rs = stmts.executeQuery("SELECT id FROM ent_user where name = '"+userBeanName+"' ");
	while(rs.next())
	  {
	  	uid=rs.getString(1);  	
	  }     
     }catch (SQLException e) {
         System.out.println("Error occurred " + e);
      }
     
     try {
        stmts = conn.createStatement();
        results = stmts.executeQuery("SELECT s.ScopeID,s.Name FROM ent_scope s, rel_scope_privacy sp where s.ScopeID=sp.ScopeID and (sp.privacy='1' or sp.Uid='"+uid+"') and s.domain = 'JAVA'");                
     }
     catch (SQLException e) {
         System.out.println("Error occurred " + e);
      }

     columnss=0;     
     try {
  
       rsmds = results.getMetaData();       
       columnss = rsmds.getColumnCount();      
     }
     catch (SQLException e) {
        System.out.println("Error occurred " + e);
     }
%>	 

<form name="myForm">
<table  style="width: 100%">
<tr>
<td>
<!--
	<table name="example" style="width: 100%">
	<tr>
		<td class="formfieldbold formfielddark"><b>Scope: </b></td>
		
		 <td><select name="sc" onChange=Javascript:changelist();> 
		<%
		 //   try{   
		//	      out.write("<option value='-1' selected>Please select the scope</option>");		    		    

		
		 //          for (int j=1; j<=columnss; j++) {                   
		 // 		while (results.next()) {  	    
				    	
		//		    out.write("<OPTION value="+results.getString(1)+">" +results.getString(1)+"   " + results.getString(2));		    		    
				    
			//	 }	                       
		  //         } 
		 //    }        
		  // finally {
		  //  try {
		  //    if (stmts != null)
		  //     stmts.close();
		  //    }  catch (SQLException e) {}
		
		 //   }
		             
		%>
		</select>
		</td> </tr>
		
	
	</table>
		-->
	
</td>
</tr>

<tr>
<td colspan="2" align="center">

</td>
</tr>
</table>
</form>


</body> 
</html>
