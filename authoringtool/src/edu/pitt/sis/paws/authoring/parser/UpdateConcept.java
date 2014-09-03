package edu.pitt.sis.paws.authoring.parser;


import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class UpdateConcept
 */
@WebServlet("/UpdateConcept")
public class UpdateConcept extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UpdateConcept() {
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
		String classCount = request.getParameter("questionClassCount");
		String type = request.getParameter("type");
		boolean isExample = false;
		if (type != null)
		{
			if (type.equals("example"))
			{
				isExample = true;
			}
		}
		
		int count = Integer.parseInt(classCount.trim());

		if (question == null | concept == null)
			return;
		DB db = new DB();
		db.connectToWebex21(this.getServletContext());
		if (db.isConnectedToWebex21())
		{			
			int id = 0;
			if (isExample)
				id = db.getExampleID(question);
			else
				id = db.getQuestionID(question);
			String className;
			String lines;
			String[] lineArray;
			for (int i = 0; i < count; i++)
			{
				String selected = request.getParameter(i+"RowSelected");
			    if (selected != null)
			    {
			    	  className = request.getParameter(i+"ConceptClass"); 
			    	  lines = request.getParameter(i+"RowLines");
			    	  if (lines.endsWith(";"))
			    		  lines = lines.substring(0, lines.length()-1);
			    	  lineArray = lines.split(";");
			    	  lines = lines.replaceAll("\\s","");
			    	  if (lines.equals("") == false)
			    	  {
				    	  if (lineArray.length != 0)
				          {
			    		      db.deleteQuizConcept(question, concept, className,isExample);
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
						    		    	if (db.classExists(question, concept, className,isExample) == false)
								    		    db.insertQuizConcept(id,question, concept, className,-1,-1,isExample,this.getServletContext());
						    		    }
				    		    }
				    		    else
					    		    db.insertQuizConcept(id,question, concept, className,-1,-1,isExample,this.getServletContext());
				    		    }
				          }
				    	  else
				    	  {
				    		 db.deleteQuizConcept(question, concept, className,isExample);
				    		 db.insertQuizConcept(id,question, concept, className,-1,-1,isExample,this.getServletContext());
				    	  }  
			    	  }
			    	  else
			    	  {
			    		 db.deleteQuizConcept(question, concept, className,isExample);
			    		    db.insertQuizConcept(id,question, concept, className,-1,-1,isExample,this.getServletContext());
			    	  }  	    	 
			    }
			    else
			    {
			    	className = request.getParameter(i+"ConceptClass"); 
			    	if (className == null)
			    		return;
			    	db.deleteQuizConcept(question, concept,className,isExample);
			    }
			    
			}
			db.disconnectFromWebex21();
		}	
		db  = null;	
	}
}
