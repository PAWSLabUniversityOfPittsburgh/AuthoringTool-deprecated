package edu.pitt.sis.paws.authoring.servlets;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;

/**
 * Servlet implementation class DeleteExampleServlet
 */
@WebServlet("/DeleteExampleServlet")
public class DeleteExampleServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DeleteExampleServlet() {
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
		ResultSet resultd = null;
		ResultSet resultd1 = null;
		Statement statement = null;
		try {
			String text = request.getParameter("disID");
			String[] temp = text.split(",");

			int disID = Integer.parseInt(temp[0]);

			Class.forName(this.getServletContext()
					.getInitParameter("db.driver"));
			connection = DriverManager.getConnection(this.getServletContext()
					.getInitParameter("db.webexURL"), this.getServletContext()
					.getInitParameter("db.user"), this.getServletContext()
					.getInitParameter("db.passwd"));
			statement = connection.createStatement();
			String command = "delete from ent_line where DissectionID ='"
					+ disID + "'";
			String command1 = "delete from rel_scope_dissection where DissectionID ='"
					+ disID + "'";

			String command2 = "delete from rel_dissection_privacy where DissectionID ='"
					+ disID + "'";
			String command3 = "delete from ent_dissection where DissectionID ='"
					+ disID + "'";
			statement.executeUpdate(command);
			statement.executeUpdate(command1);
			statement.executeUpdate(command2);
			statement.executeUpdate(command3);
			command="delete from ent_jquiz_concept where dissectionID ="+disID;	  		  	
		  	statement.executeUpdate(command);

		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
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

	}

}
