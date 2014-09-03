package edu.pitt.sis.paws.authoring.servlets;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONException;
import org.json.JSONObject;

import java.sql.*;
/**
 * Servlet implementation class CloneExampleServlet
 */
@WebServlet("/CloneExampleServlet")
public class CloneExampleServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CloneExampleServlet() {
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
        try {
			Class.forName(this.getServletContext().getInitParameter("db.driver"));
			connection = DriverManager.getConnection(this.getServletContext().getInitParameter("db.webexURL"),this.getServletContext().getInitParameter("db.user"),this.getServletContext().getInitParameter("db.passwd"));
		    Statement statement = connection.createStatement();
			ResultSet rs = null;
            String dis = request.getParameter("dis");
            String uid = request.getParameter("uid");
            String sc = request.getParameter("sc");
            String name = "";
            String rdfID = "";
            String des = "";
            int newrdfID = -1;
            int newDisId = -1;
            int privacy = -1;
            String command = "select Name, rdfID,Description from ent_dissection where DissectionID = "+dis;
            rs = statement.executeQuery(command);
            while (rs.next())
   		    {
            	name = rs.getString(1);
   			    rdfID = rs.getString(2);
   			    des = (rs.getString(3)==null?"":rs.getString(3));
   		    }
            command = "select max(DissectionID) from ent_dissection";
            rs = statement.executeQuery(command);
            while (rs.next())
   		    {
   			    newrdfID = rs.getInt(1);
   		    }
            rdfID = rdfID + "_" + newrdfID;
            name = name.replace("'", "\\'");
            des = des.replace("'", "\\'");
            rdfID = rdfID.replace("'", "\\'");
            command = "INSERT INTO ent_dissection (rdfID,Name, Description) values('"+rdfID+"','"+name+"','"+des+"')";
        	statement.executeUpdate(command); 

        	command = "SELECT MAX(DissectionID) FROM ent_dissection WHERE rdfID='"+rdfID+"'";
        	 rs = statement.executeQuery(command);
             while (rs.next())
    		 {
    			    newDisId = rs.getInt(1);
    		 }
             
         	command = "INSERT INTO rel_scope_dissection (ScopeID,DissectionID) VALUES ( "+sc+"," +newDisId+")";         
            statement.executeUpdate(command);  
            
            command = "select privacy from rel_dissection_privacy where DissectionID = "+dis;
            rs = statement.executeQuery(command);
            while (rs.next())
   		    {
   			    privacy = rs.getInt(1);
   		    }
            command = "insert into rel_dissection_privacy (DissectionID, Uid, Privacy) values ("+newDisId+","+uid+","+privacy+") ";
            statement.executeUpdate(command);  

            command = "select Code, LineIndex,Comment from ent_line where DissectionID = "+dis;
            rs = statement.executeQuery(command);
            command = "INSERT INTO ent_line (Code, LineIndex,DissectionID,Comment) VALUES ";
            String code;
            String comment;
            while (rs.next())
   		    {
            	code = rs.getString(1);
            	comment = rs.getString(3);
            	code = code.replace("'", "\\'");
            	comment = comment.replace("'", "\\'");

            	command += "('"+code+"',"+rs.getInt(2)+","+newDisId+",'"+comment+"')";
   			    if (rs.isLast() == false)
   			    	command += ",";
   			    else 
   			    	command += ";";

   		    }
            statement.executeUpdate(command);
            
            try {
            	PrintWriter out= response.getWriter();  
                JSONObject json = new JSONObject(); 
    			json.put("dis", newDisId);
    	        out.print(json);  
    		} catch (JSONException e) {
    			// TODO Auto-generated catch block
    			e.printStackTrace();
    		} 
            
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
              
	}

}
