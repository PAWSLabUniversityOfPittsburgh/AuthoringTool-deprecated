package edu.pitt.sis.paws.authoring.servlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Servlet implementation class CloneServlet
 */
@WebServlet("/CloneServlet")
public class CloneScopeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CloneScopeServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Connection connection = null;
		Statement statement ;
		try {
			Class.forName(this.getServletContext().getInitParameter("db.driver"));
			connection = DriverManager.getConnection(this.getServletContext().getInitParameter("db.webexURL"),this.getServletContext().getInitParameter("db.user"),this.getServletContext().getInitParameter("db.passwd"));
            statement = connection.createStatement();
            
    		try{
    		            
    		 String scopeID = request.getParameter("scopeID");           
             String uname  = request.getParameter("uname");
    		 String uid="";
    		 ResultSet rs = null;  
    		 rs = statement.executeQuery("SELECT id FROM ent_user where name = '"+uname+"' ");
    		 while(rs.next())
    		  {
    		  	uid=rs.getString(1);  	
    		  }

    		 rs = statement.executeQuery("SELECT Name,Description,rdfID,domain FROM ent_scope where ScopeID = "+scopeID);
    		 String name = "";
    		 String rdfID = "";
    		 String description = "";
    		 String domain = "";
    		 int privacy = -1;
    		 while (rs.next())
    		 {
    			 name = rs.getString(1);
    			 description = rs.getString(2);
    			 rdfID = rs.getString(3);
    			 domain = rs.getString(4);
    		 }
    		 String command = "select MAX(ScopeID) from ent_scope";
    	     rs = statement.executeQuery(command);
    	     int newScopeID = -1;
             while (rs.next())
             {
            	 newScopeID = rs.getInt(1);
             }
    		 command = "select privacy from rel_scope_privacy where ScopeID="+scopeID;
    		 rs = statement.executeQuery(command);
    		 while (rs.next())
    		 {
    			privacy = rs.getInt(1); 
    		 }
    		 rdfID = rdfID + "_"+newScopeID;
    		 command = "insert into ent_scope (Name, Description, rdfID,domain) values ('"
    						+ name + "','" + description + "','" + rdfID + "','"+domain+"') ";
    				statement.executeUpdate(command);
    		 command = "select ScopeID from ent_scope  where rdfID = '"+rdfID+"'";
    		 rs = statement.executeQuery(command);
    		 while (rs.next())
    		 {
            	 newScopeID = rs.getInt(1);
    		 }
    				ResultSet rs1 = null;
    				int newscopeID = 0;
    				rs = statement.executeQuery("SELECT scopeID FROM ent_scope where Name = '"+name+"'"+" and Description = '"+description+"' and rdfID = '"+rdfID+"' and domain = '"+domain+"'");
    				while (rs.next()) {
    					newscopeID = rs.getInt(1);
    				}

    				String command1 = "insert into rel_scope_privacy (ScopeID,Uid,privacy)"
    				                  + "values ('"+ newscopeID + "','" + uid + "',"+privacy+")";
    				statement.executeUpdate(command1);
    			
    				
    		//clone all the examples associated with this scope
    	    command = "select  dissectionID from rel_scope_dissection  where ScopeID = "+scopeID;
    	    ResultSet rsDis;
    	    String rdf;
    	    String des;
    	    rs = statement.executeQuery(command);
    	    ResultSet newDisRs;
    	    ResultSet newRdfRs;
    	    ResultSet sprs;
    	    ResultSet liners;
    	    int  newrdfID = -1;
    	    int newDisID = -1;
    	    String dis;
    	    List<String> disList = new ArrayList<String>();
    	    while (rs.next())
    	    {
    	    	disList.add(rs.getString(1));
    	    }
    	    for (int i = 0; i < disList.size(); i++)
    	    {
    	    	dis = disList.get(i);
        		command = "select  Name,Description,rdfID from ent_dissection where DissectionID = "+dis;
        		rsDis = statement.executeQuery(command);
        		if (rsDis.next() == true)
        		{
        			name = rsDis.getString(1);
        			des = (rsDis.getString(2)==null?"":rsDis.getString(2));
        			rdf = rsDis.getString(3);
        			command = "select max(DissectionID) from ent_dissection";
        			newRdfRs = statement.executeQuery(command);
        	        while (newRdfRs.next())
        	   	    {
        	   		    newrdfID = newRdfRs.getInt(1);
        	   	    }
        	        rdf = rdf + "_" + newrdfID;
                    name = name.replace("'", "\\'");
                    des = des.replace("'", "\\'");
                    rdf = rdf.replace("'", "\\'");
        			command = "INSERT INTO ent_dissection (rdfID,Name, Description) VALUES ('"+rdf+"','"+name+"','"+des+"')";
        			statement.executeUpdate(command); 
                	command = "SELECT MAX(DissectionID) FROM ent_dissection WHERE rdfID='"+rdf+"'";
                	newDisRs = statement.executeQuery(command);
                     while (newDisRs.next())
            		 {
            			    newDisID = newDisRs.getInt(1);
            		 }
                     
                 	command = "INSERT INTO rel_scope_dissection (ScopeID,DissectionID) VALUES ( "+newScopeID+"," +newDisID+")";         
                    statement.executeUpdate(command);  
                    
                    command = "select privacy from rel_dissection_privacy where DissectionID = "+dis;
                    sprs = statement.executeQuery(command);
                    while (sprs.next())
           		    {
           			    privacy = sprs.getInt(1);
           		    }
                    command = "insert into rel_dissection_privacy (DissectionID, Uid, Privacy) values ("+newDisID+","+uid+","+privacy+") ";
                    statement.executeUpdate(command);  

                    command = "select Code, LineIndex,Comment from ent_line where DissectionID = "+dis;
                    liners = statement.executeQuery(command);
                    command = "INSERT INTO ent_line (Code, LineIndex,DissectionID,Comment) VALUES ";
                    String code;
                    String comment;
                    while (liners.next())
           		    {
                    	code = liners.getString(1);
                    	comment = (liners.getString(3)==null?"":liners.getString(3));
                    	code = code.replace("'", "\\'");
                    	comment = comment.replace("'", "\\'");
                        command += "('"+code+"',"+liners.getInt(2)+","+newDisID+",'"+comment+"')";
           			    if (liners.isLast() == false)
           			    	command += ",";
           			    else
           			    	command += ";";
           		    }                  
                    statement.executeUpdate(command);
                    
        		}
    	    }
    	  }
    	finally {
				try {
					if (statement != null)
						statement.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
				try {
					if (connection != null)
						connection.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}	

		} catch (ClassNotFoundException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (SQLException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
	}

}
