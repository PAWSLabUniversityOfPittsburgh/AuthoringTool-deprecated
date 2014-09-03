package edu.pitt.sis.paws.authoring.parser;


import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class AddConcept
 */
@WebServlet("/AddConcept")
public class AddConcept extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddConcept() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request,response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String question = request.getParameter("question");
		String classCount = request.getParameter("count");
		String type = request.getParameter("type");
		boolean isExample = false;
		if (type != null)
		{
			if (type.equals("example"))
				isExample = true;
		}

		if (question == null | classCount == null)
			return;
		String concept = request.getParameter("addConceptList");
		if (concept == null)
			return;
		int count = Integer.parseInt(classCount.trim());
		DB db = new DB();
		db.connectToWebex21(this.getServletContext());
		if (db.isConnectedToWebex21())
		{
			int id = 0;
			if (isExample)
				id = db.getExampleID(question);
			else
				id = db.getQuestionID(question);
			boolean hasAtleastOneSelectedClass = false;
			for (int i = 0; i < count; i++)
			{
				String selected = request.getParameter(i+"AddRowSelected");
			    if (selected != null)
			    {
			    	  hasAtleastOneSelectedClass = true;
			    	  String className = request.getParameter(i+"AddConceptClass"); 
			    	  String lines = request.getParameter(i+"AddRowLines");
			    	  lines = lines.replaceAll("\\s","");
			    	  if (lines.equals("") == false)
			    	  {
			    		  if (lines.endsWith(";"))
				    		  lines = lines.substring(0, lines.length()-1);
				    	  String[] lineArray = lines.split(";");
				    	  if (lineArray.length != 0)
				          {
				    		  for (int j = 0; j < lineArray.length; j++)
				    		  {
				    		    String line = lineArray[j];
				    		    String[] seArray = line.split("-");
				    		    if (seArray.length == 2)
				    		    {
				    		    	try{
				    		    		String temp1 = seArray[0].trim();
				    		    		String temp2 = seArray[1].trim();
						    		    int s = Integer.parseInt(temp1);
						    		    int e = Integer.parseInt(temp2);
						    		    db.insertQuizConcept(id,question, concept, className,s,e,isExample,this.getServletContext());
						    		    }catch(NumberFormatException e){	
							    		    db.insertQuizConcept(id,question, concept, className,-1,-1,isExample,this.getServletContext());
						    		    }
				    		    }
				    		    else
					    		    db.insertQuizConcept(id,question, concept, className,-1,-1,isExample,this.getServletContext());
				    		  }
				          }
				    	  else
				    	  {
				    		    db.insertQuizConcept(id,question, concept, className,-1,-1,isExample,this.getServletContext());
				    	  }
			    	  }
			    	  else
			    		    db.insertQuizConcept(id,question, concept, className,-1,-1,isExample,this.getServletContext());
			    }	        
			}
			if (hasAtleastOneSelectedClass == false)
			{
    		    db.insertQuizConcept(id,question, concept,"" ,-1,-1,isExample,this.getServletContext());
			}
			db.disconnectFromWebex21();
		}	
		db  = null;	
	}
}
