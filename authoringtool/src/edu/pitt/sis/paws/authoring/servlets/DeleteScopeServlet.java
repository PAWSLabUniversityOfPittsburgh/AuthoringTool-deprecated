package edu.pitt.sis.paws.authoring.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONException;
import org.json.JSONObject;

import java.sql.*;
import java.util.ArrayList;

/**
 * Servlet implementation class DeleteScopeServlet
 */
@WebServlet("/DeleteScopeServlet")
public class DeleteScopeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DeleteScopeServlet() {
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
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		Connection connection = null;
		Statement statement;

		try {

			Class.forName(this.getServletContext()
					.getInitParameter("db.driver"));
			connection = DriverManager.getConnection(this.getServletContext()
					.getInitParameter("db.webexURL"), this.getServletContext()
					.getInitParameter("db.user"), this.getServletContext()
					.getInitParameter("db.passwd"));
			statement = connection.createStatement();

			//String text = "";
			String ScopeID = request.getParameter("scopeID");

			String message = "";
			//int flag1 = 0;
			//int flag2 = 0;

			// //@roya commented since we do not care about the learning goal
			// now
			// ResultSet rs = null;
			// rs =
			// statement.executeQuery("SELECT * FROM ent_learning_goal where ScopeID = '"+ScopeID+"' limit 1 ");
			// while(rs.next())
			// {
			// flag1 = 1;
			// }

			//ResultSet rs1 = null;
			//rs1 = statement	.executeQuery("SELECT * FROM rel_scope_dissection where ScopeID = '"+ ScopeID + "' limit 1 ");
			//while (rs1.next()) {
			//	flag2 = 1;
			//	message = "This scope cannot be deleted since it is assigned to some examples.\nChange its examples' scope or delete them all and try again.";
			//}

			// if (flag1<=0){
			//if (flag2 <= 0) {
				String cd = "delete from rel_scope_privacy where ScopeID ='"
						+ ScopeID + "' ";
				String cd1 = "delete from ent_scope where ScopeID ='"
						+ ScopeID + "' ";
				
				ArrayList<String> disList = new ArrayList<String>();
	    	    String command = "select  dissectionID from rel_scope_dissection  where ScopeID = "+ScopeID;
	    	    ResultSet rs = statement.executeQuery(command);
	    	    String dis = "";
	    	    while (rs.next())
	    	    {
	    	    	disList.add(rs.getString(1));
	    	    }
	    	    for (int i = 0; i < disList.size(); i++)
	    	    {
	    	    	dis = disList.get(i);
	    	    	command = "delete from ent_line where DissectionID = "+dis;
	        		statement.executeUpdate(command);
	        		command = "delete from rel_dissection_privacy where DissectionID = "+dis;
		        	statement.executeUpdate(command);
	        		command = "delete from rel_scope_dissection where DissectionID = "+dis+" and ScopeID="+ScopeID;
	        		statement.executeUpdate(command);
	        		command = "delete  from ent_dissection where DissectionID = "+dis;
	        		statement.executeUpdate(command);               	        		
	    	    }
	    	    statement.executeUpdate(cd);
				statement.executeUpdate(cd1);
			//}
			// }
			try {
				PrintWriter out = response.getWriter();
				JSONObject json = new JSONObject();
				json.put("message", message);
				out.print(json);
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} finally {
				try {
					if (statement != null)
						statement.close();
				} catch (SQLException e) {
				}
				try {
					if (connection != null)
						connection.close();
				} catch (SQLException e) {
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
