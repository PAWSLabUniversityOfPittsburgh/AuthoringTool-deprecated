package edu.pitt.sis.paws.authoring.parser;


import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class DeleteConcept
 */
@WebServlet("/DeleteConcept")
public class DeleteConcept extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DeleteConcept() {
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

		String question = request.getParameter("question");
		String concept = request.getParameter("concept");
		String type = request.getParameter("type");
		boolean isExample = false;
		if (type != null)
		{
			if (type.equals("example"))
				isExample = true;
		}

		if (question == null | concept == null)
			return;
		DB db = new DB();
		db.connectToWebex21(this.getServletContext());
		if (db.isConnectedToWebex21())
		{			
			db.deleteQuizConcept(question,concept,isExample);			
			db.disconnectFromWebex21();
		}	
		db  = null;	
	}

}
