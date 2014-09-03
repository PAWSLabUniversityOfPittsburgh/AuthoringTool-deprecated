/*
 * Date  : May, 15, 2006
 * Author(s): Sergey Sosnovsky, Girish Chavan
 * Email : sas15@pitt.edu
 */
package edu.pitt.sis.paws.authoring.servlets;

import java.sql.*;
import java.util.*;
import java.util.Date;
import java.net.*;
import java.io.*;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import edu.pitt.sis.paws.authoring.beans.QuestionBean;
import edu.pitt.sis.paws.authoring.beans.QuizBean;
import edu.pitt.sis.paws.authoring.beans.UserBean;
import edu.pitt.sis.paws.authoring.data.Const;
import edu.pitt.sis.paws.utils.SqlUtil;




/**
 * Handles all requests related to Quizzes
 * 
 * Valid Requests 
 * --------------
 * GETQUIZLIST
 * GETMODIFYQUIZLIST
 * GETDELETEQUIZLIST
 * GETQUIZ
 * CREATEQUIZ	 		from AddQuestions.jsp, when quiz is created 
 * MODIFYQUIZ			
 * DELETEQUIZ
 * -------------- 
 */
@SuppressWarnings("serial")
public class QuizServlet extends AbstractServlet {
    
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    public void service(HttpServletRequest req, HttpServletResponse res) {
        
        this.action = req.getParameter(Const.REQ_PARAM_ACT);
        this.session = req.getSession();
        try {
            String dbdrv = this.context.getInitParameter(Const.CON_PARAM_DB_DRIVER);
            String dburl = this.context.getInitParameter(Const.CON_PARAM_WEBEX21_URL);            
            String dbuser = this.context.getInitParameter(Const.CON_PARAM_DB_USER);
            String dbpass = this.context.getInitParameter(Const.CON_PARAM_DB_PASSWORD);
            if (dbdrv == null || dburl == null || dbuser == null || dbpass == null) {
                throw new Exception("db initialization failed: loadData(" +                        
                           "driver = " + dbdrv + ", url = " + dburl +
                           ", user = " + dbuser + ", dbpass = " + dbpass);
            }
            this.dbConn = SqlUtil.getConnection(dbdrv, dburl, dbuser, dbpass);
            // Inherited method to initialize connection to database
        } catch (Exception e) {
            e.printStackTrace();
            return;
        }
	
		try {
			if (this.action.equalsIgnoreCase("GETQUIZLIST")) {
				getQuizList();                
                res.sendRedirect(res.encodeRedirectURL(req.getContextPath() + 
                        "/displayQuizList.jsp?"));
			} else if (this.action.equalsIgnoreCase("GETMODIFYQUIZLIST")) {
				if(getModifyQuizList())
                    res.sendRedirect(res.encodeRedirectURL(req.getContextPath() + 
                            "/displayModifyQuizList.jsp"));
				else
					res.sendRedirect(res.encodeRedirectURL(req.getContextPath() + 
                            "/servletResponse.jsp?" + Const.REQ_PARAM_ACT + "=GETMODIFYQUIZLISTFAILED"));					
			}
			else if (this.action.equalsIgnoreCase("GETDELETEQUIZLIST")) {
				if(getModifyQuizList())
                    res.sendRedirect(res.encodeRedirectURL(req.getContextPath() + 
                            "/displayDeleteQuizList.jsp"));       

				else
					res.sendRedirect(res.encodeRedirectURL(req.getContextPath() + 
                            "/servletResponse.jsp?" + Const.REQ_PARAM_ACT + "=GETDELETEQUIZLISTFAILED"));		
			}
			else if (this.action.equalsIgnoreCase("DELETEQUIZ")) {
				if(deleteQuiz())
					res.sendRedirect(res.encodeRedirectURL(req.getContextPath() + 
                            "/servletResponse.jsp?" + Const.REQ_PARAM_ACT + "=DELETEQUIZOK"));
				else
					res.sendRedirect(res.encodeRedirectURL(req.getContextPath() + 
                            "/servletResponse.jsp?" + Const.REQ_PARAM_ACT + "=DELETEQUIZFAILED"));
			}
			else if (this.action.equalsIgnoreCase("CREATEQUIZ")) {
	            if (createQuiz())
                    res.sendRedirect(res.encodeRedirectURL(req.getContextPath() + 
                            "/servletResponse.jsp?" + Const.REQ_PARAM_ACT + "=CREATEUIZOK"));
		        else
                    res.sendRedirect(res.encodeRedirectURL(req.getContextPath() + 
                            "/servletResponse.jsp?" + Const.REQ_PARAM_ACT + "=CREATEUIZFAILED"));

		    }
			else if (this.action.equalsIgnoreCase("MODIFYQUIZ")) {
				if (modifyQuiz())
                    res.sendRedirect(res.encodeRedirectURL(req.getContextPath() + 
                            "/servletResponse.jsp?" + Const.REQ_PARAM_ACT + "=MODIFYQUIZOK"));
				else
                    res.sendRedirect(res.encodeRedirectURL(req.getContextPath() + 
                            "/servletResponse.jsp?" + Const.REQ_PARAM_ACT + "=MODIFYQUIZFAILED"));
            }   
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
        
    /*--------------------------------------------------------*/
    /*-----------------     createQuiz -------------------------*/
    /*--------------------------------------------------------*/    
    public boolean createQuiz() {
        QuizBean qBean = (QuizBean) this.session.getAttribute("newQuizBean");
        UserBean uBean = (UserBean) this.session.getAttribute("userBean");
        this.session.removeAttribute("newQuizBean");
//      implememnt quiz on Unix and get its URL
        String quizURL = null;
        try {
            quizURL = implementQuiz(uBean.getLogin(), qBean);
            if (quizURL == null)
                throw new Exception();
        } catch (Exception e) {
            System.out.println("[Authoring] saveQuiz(): failed to implement quiz");
            e.printStackTrace();
            return false;
        }

//      update quiz URL and modification date 
        qBean.setUrl(quizURL);
        qBean.setModified(new Date());

//      save quiz to the DB
        try {
            String querInsertQuiz = "INSERT INTO quiz VALUES " +
                        "(authorid, groupid, permission, title, desc, modified, url)" +
                        " (";       
            querInsertQuiz = querInsertQuiz.concat(uBean.getId() + ", ");
            querInsertQuiz = querInsertQuiz.concat(qBean.getGroupId() + ", ");
            querInsertQuiz = querInsertQuiz.concat(qBean.getPermission() + ", ");
            querInsertQuiz = querInsertQuiz.concat(qBean.getTitle() + ", ");
            querInsertQuiz = querInsertQuiz.concat(qBean.getDescription() + ", ");
            querInsertQuiz = querInsertQuiz.concat(qBean.getModified() + ", ");
            querInsertQuiz = querInsertQuiz.concat(qBean.getUrl() + ")");
            SqlUtil.executeUpdate(this.dbConn, querInsertQuiz);

//          save quiz-question mapping to the DB
            Set positions = qBean.getQuestions().keySet();
            Iterator i = positions.iterator();
            while(i.hasNext()) {
                int curPos = ((Integer) i.next()).intValue();
                String querInsertQQMap = "INSERT INTO quizquesmap VALUES +" +
                                        "(quizid, quesid, position) (";
                querInsertQQMap = querInsertQQMap.concat(qBean.getId() + ", ");
                querInsertQQMap = querInsertQQMap.concat(
                        qBean.getQuestions().get(curPos).getId() + ", ");
//              position of a question in the quiz 
                querInsertQQMap = querInsertQQMap.concat(curPos + ")");
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("[Authoring] createQuiz(): failed to save quiz in the DB");
            return false;           
        } 
        return true;
}

    public boolean modifyQuiz() {
        QuizBean qBean = (QuizBean) this.session.getAttribute("modifyQuizBean");
        this.session.removeAttribute("modifyQuizBean");        
        String authorLogin= null;
        String quizURL = null;
        try {
//          get previous quizTitle and the login of quiz author            
            String querSelectAuthorLogin = "SELECT user.login, quiz.url " +
                                           "FROM user, quiz " +
                                           "WHERE user.id = quiz.authorId " +
                                           "AND quiz.Id = " + qBean.getId();
            ResultSet rs = SqlUtil.executeStatement(this.dbConn, querSelectAuthorLogin);
            if (rs.next()) {
                authorLogin = rs.getString("user.login"); 
                quizURL = rs.getString("quiz.url");
            }
            
            if (quizURL == null)
                throw new Exception();
//          reimplememnt quiz on Unix and get its URL
            if (eraseQuiz(quizURL))
                quizURL = implementQuiz(authorLogin, qBean);                
            if (quizURL == null)
                throw new Exception();
        } catch (Exception e) {
            System.out.println("[Authoring] modifyQuiz(): failed to implement quiz");
            e.printStackTrace();
            return false;
        }

//      update quiz URL and modification date
        qBean.setUrl(quizURL);
        qBean.setModified(new Date());

//      save quiz to the DB
        try {
//          update quiz in the DB                
            String querUpdateQuiz = "UPDATE quiz SET";
            querUpdateQuiz = querUpdateQuiz.concat(" authorid = " + qBean.getAuthorId());
            querUpdateQuiz = querUpdateQuiz.concat(", groupid = " + qBean.getGroupId());
            querUpdateQuiz = querUpdateQuiz.concat(", permission = " + qBean.getPermission());
            querUpdateQuiz = querUpdateQuiz.concat(", title = " + qBean.getTitle());
            querUpdateQuiz = querUpdateQuiz.concat(", desc = " + qBean.getDescription());
            querUpdateQuiz = querUpdateQuiz.concat(", modified = " + qBean.getModified());
            querUpdateQuiz = querUpdateQuiz.concat(", url = " + qBean.getUrl());
            querUpdateQuiz = querUpdateQuiz.concat(" WHERE id = " + qBean.getId());
            SqlUtil.executeUpdate(this.dbConn, querUpdateQuiz);

//          delete old quiz-ques mapping            
            String querDeleteQQMap = "DELETE FROM quiz WHERE quizid = " + qBean.getId();
            SqlUtil.executeUpdate(this.dbConn, querDeleteQQMap);

//          save quiz-question mapping to the DB
            Set positions = qBean.getQuestions().keySet();
            Iterator i = positions.iterator();
            while(i.hasNext()) {
                int curPos = ((Integer) i.next()).intValue();
                String querInsertQQMap = "INSERT INTO quizquesmap VALUES +" +
                                        "(quizid, quesid, position) (";
                querInsertQQMap = querInsertQQMap.concat(qBean.getId() + ", ");
                querInsertQQMap = querInsertQQMap.concat(
                        qBean.getQuestions().get(curPos).getId() + ", ");
//              position of a question in the quiz 
                querInsertQQMap = querInsertQQMap.concat(curPos + ")");
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("[Authoring] createQuiz(): failed to save quiz in the DB");
            return false;           
        } 
        return true;
    }

	/*--------------------------------------------------------*/
	/*----------------- 	deleteQuiz -----------------------*/
	/*--------------------------------------------------------*/
	public boolean deleteQuiz() {
        int quizid = 0;
        try {
            quizid = (new Integer((String) this.session.getAttribute("deleteQuizId"))).intValue();
        } catch (NumberFormatException e) {
            e.printStackTrace();
            System.out.println("[Authoring] deleteQuiz(): invalid deleteQuizId");
            return false;
        }
        this.session.removeAttribute("deleteQuizId");      
        String quizURL = null;
        try {
//          get previous quizTitle and the login of quiz author            
            String querSelectAuthorLogin = "SELECT quiz.url " +
                                           "FROM quiz " +
                                           "WHERE quiz.Id = " +  quizid;
            ResultSet rs = SqlUtil.executeStatement(this.dbConn, querSelectAuthorLogin);
            if (rs.next())
                quizURL = rs.getString("quiz.url");            
            if (quizURL == null)
                throw new Exception();
//          reimplememnt quiz on Unix and get its URL
            String querDeleteQuiz = "DELETE FROM quiz WHERE id = " + quizid;
            String querDeleteQuizQuesMap = "DELETE FROM quizquesmap WHERE quizid = " + quizid;        
            SqlUtil.executeUpdate(this.dbConn, querDeleteQuizQuesMap);
            SqlUtil.executeUpdate(this.dbConn, querDeleteQuiz);
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}		
		return true;
	}


	/*--------------------------------------------------------*/
	/*----------------- 	getModifyQuizList ----------------*/
	/*--------------------------------------------------------*/	
	public boolean getModifyQuizList() {
        
		UserBean uBean = (UserBean) this.session.getAttribute("userBean");
		String querGetModifyQuizList = "SELECT * FROM quiz ";
//      if user is an admin, he can delete anything			
		if(!uBean.isAdmin()) {
//          if user is a superuser or have right for a group artifacts, he can 
//          delete any group quizzes and quizzes that can be modified by anyone  
            if (uBean.isSuperUser() || uBean.getRights() == Const.RIGHTS_YES)
                querGetModifyQuizList += "WHERE groupId = " + uBean.getGroupBean().getId() +
                                         " OR quiz.permission = " + Const.PERM_NRAW +
                                         " OR quiz.permission = " + Const.PERM_GRAW +
                                         " OR quiz.permission = " + Const.PERM_ARAW;
//          if it is an ordinary user he can delete only his quizzes in this group and 
//          quizzes that can be modified by anyone             
            else
                querGetModifyQuizList += "WHERE (authotId = " + uBean.getId() + 
                                         " AND groupId = " + uBean.getGroupBean().getId() +
                                         ") OR quiz.permission = " + Const.PERM_NRAW +
                                         " OR quiz.permission = " + Const.PERM_GRAW +
                                         " OR quiz.permission = " + Const.PERM_ARAW;
		}					
		Vector<QuizBean> modifyQuizList = new Vector<QuizBean>();
		try {
            ResultSet rs = SqlUtil.executeStatement(this.dbConn, querGetModifyQuizList);
            while (rs.next()) {
                QuizBean qBean = new QuizBean();
                qBean.setId(rs.getInt("quiz.id"));
                qBean.setAuthorid(rs.getInt("quiz.authorid"));
                qBean.setGroupId(rs.getInt("quiz.groupid"));
                qBean.setPermission(rs.getInt("quiz.permission"));
                qBean.setTitle(rs.getString("quiz.title"));
                qBean.setUrl(rs.getString("quiz.url"));
                qBean.setDescription(rs.getString("quiz.desc"));
                qBean.setModified(rs.getDate("quiz.modified"));					
                
                String querGetQuizQuesId = "SELECT quesId, position FROM quizquesmap" +
                                           "WHERE quizId = " + qBean.getId();
                ResultSet rsQues = SqlUtil.executeStatement(this.dbConn, querGetQuizQuesId);
                while (rsQues.next()) {
                    QuestionBean quesBean = QuestionServlet.getQuestion(this.dbConn, 
                                                                        rsQues.getInt("quesId"));
                    if (quesBean == null)
                        throw new Exception();
                    qBean.addQuestion(rsQues.getInt("position"), quesBean); 
                }
                modifyQuizList.add(qBean);                
            }
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("[Authoring] getDeleteQuizList(): cannot retrieve " +
                               "quizzes to delete from the DB");
			return false;
		}
//      Save the list in the session
		System.out.println("[Authoring] getModifyQuizList(): " + modifyQuizList.size() +
                           "quizzes is retreived from the DB");
		this.session.setAttribute("quizList", modifyQuizList);		
		return true;
    }

	/*--------------------------------------------------------*/
	/*----------------- 	getQuizList ----------------------*/
	/*--------------------------------------------------------*/
	private boolean getQuizList() {
        UserBean uBean = (UserBean) this.session.getAttribute("userBean");
        String querGetQuizList = "SELECT * FROM quiz ";
//      if user is an admin, he can delete anything         
        if(!uBean.isAdmin()) {
//          if user is a superuser or have right for a group artifacts, he can 
//          access any group quizzes and quizzes that can be accessed by anyone  
            if (uBean.isSuperUser() || uBean.getRights() == Const.RIGHTS_YES)
                querGetQuizList += "WHERE groupId = " + uBean.getGroupBean().getId() +
                                         " OR quiz.permission = " + Const.PERM_ARNW +
                                         " OR quiz.permission = " + Const.PERM_ARGW +
                                         " OR quiz.permission = " + Const.PERM_ARAW;
//          if it is an ordinary user he can access only his quizzes in this group and 
//          quizzes that can be accessed by anyone             
            else
                querGetQuizList += "WHERE (authotId = " + uBean.getId() + 
                                         " AND groupId = " + uBean.getGroupBean().getId() +
                                         ") OR quiz.permission = " + Const.PERM_ARNW +
                                         " OR quiz.permission = " + Const.PERM_ARGW +
                                         " OR quiz.permission = " + Const.PERM_ARAW;
        }                   
        Vector<QuizBean> quizList = new Vector<QuizBean>();
        try {
            ResultSet rs = SqlUtil.executeStatement(this.dbConn, querGetQuizList);
            while (rs.next()) {
                QuizBean qBean = new QuizBean();
                qBean.setId(rs.getInt("quiz.id"));
                qBean.setAuthorid(rs.getInt("quiz.authorid"));
                qBean.setGroupId(rs.getInt("quiz.groupid"));
                qBean.setPermission(rs.getInt("quiz.permission"));
                qBean.setTitle(rs.getString("quiz.title"));
                qBean.setUrl(rs.getString("quiz.url"));
                qBean.setDescription(rs.getString("quiz.desc"));
                qBean.setModified(rs.getDate("quiz.modified"));                 
                
                String querGetQuizQuesId = "SELECT quesId, position FROM quizquesmap" +
                                           "WHERE quizId = " + qBean.getId();
                ResultSet rsQues = SqlUtil.executeStatement(this.dbConn, querGetQuizQuesId);
                while (rsQues.next()) {
                    QuestionBean quesBean = QuestionServlet.getQuestion(this.dbConn, 
                                                                        rsQues.getInt("quesId"));
                    if (quesBean == null)
                        throw new Exception();
                    qBean.addQuestion(rsQues.getInt("position"), quesBean); 
                }
                quizList.add(qBean);                
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("[Authoring] getQuizList(): cannot retrieve " +
                               "quizzes to modify from the DB");
            return false;
        }
//      Save the list in the session
        System.out.println("[Authoring] getQuizList(): " + quizList.size() +
                           "quizzes are retrieved from the DB");
        this.session.setAttribute("quizList", quizList);        
        return true;

	}

	/*---------------------------------------------------------*/
	/* ----------------- implementQuiz ------------------------*/
	/* launches makeQuiz.cgi and compileQuiz.sh                */
	/* on the UNIX QuizPACK server      					   */
	/* makeQuiz.cgi creates Quiz folder for new quiz           */
	/* and creates (or overwrites for existed Quiz) ex.c files */
	/* for all questions                                       */
	/* compileQuiz.sh compiles quiz				     	       */
	/*---------------------------------------------------------*/
	public String implementQuiz(String authorLogin, QuizBean qBean)
	throws Exception {

        UserBean uBean = (UserBean) this.session.getAttribute("userBean");
	    // message for cgi scripts
	    String quizMessage = new String();

        quizMessage = quizMessage.concat("<QUIZ>\n");
        quizMessage = quizMessage.concat(uBean.getName());
        quizMessage = quizMessage.concat("\n");
	    quizMessage = quizMessage.concat(qBean.getTitle());
        quizMessage = quizMessage.concat("\n");

        QuestionBean quesBean = null;
	    for (int i = 1; null != (quesBean = qBean.getQuestions().get(i)); i++) {
			// finnish cgi message
			quizMessage = quizMessage.concat("\n<QUESTION>\n");			
			quizMessage = quizMessage.concat(new Integer (i).toString());
			quizMessage = quizMessage.concat("\n<MIN>\n");
			quizMessage = quizMessage.concat(new Integer (quesBean.getMinRandom()).toString());
			quizMessage = quizMessage.concat("\n<MAX>\n");			
			quizMessage = quizMessage.concat(new Integer (quesBean.getMaxRandom()).toString());
			quizMessage = quizMessage.concat("\n<TYPE>\n");			
			quizMessage = quizMessage.concat(quesBean.getAnswerType());
			quizMessage = quizMessage.concat("\n<VAR>\n");			
			quizMessage = quizMessage.concat(quesBean.getTargetVar());
			quizMessage = quizMessage.concat("\n<CODE>\n");
			quizMessage = quizMessage.concat(quesBean.getCode());
			quizMessage = quizMessage.concat("\n<QQUESTION>\n");
		}
	    quizMessage = quizMessage.concat("<QQUIZ>\n");
		// makeQuiz.cgi

		String urlName = new String(this.context.getInitParameter("qp.path") +
                                    this.context.getInitParameter("qp.makeQuiz.url"));
		URL makeQuizUrl = new URL(urlName);
		if (!cgiExchange(makeQuizUrl, quizMessage, true))
	        return ("false");
		else {
		    // compileQuiz.cgi
            urlName = new String(this.context.getInitParameter("qp.path") +
                    this.context.getInitParameter("qp.compileQuiz.url"));
			URL compileQuizUrl = new URL(urlName);
			if (!cgiExchange(compileQuizUrl, uBean.getName() + "/" + qBean.getTitle(), false))
		        return (null);
        }
        this.session.setAttribute("quizUrl", new String(
                this.context.getInitParameter("qp.path") +
                this.context.getInitParameter("qp.quizzes.dir") +
                uBean.getName() + "/" + qBean.getTitle() + 
                "/presenterasp.cgi?app=2&act=" + qBean.getTitle() + "&sub=0"));
        System.out.println((String) this.session.getAttribute("quizUrl"));
        return ("true");
	}
	
	/*--------------------------------------------------------*/
	/* ---------------- cgiExchange --------------------------*/
	/*--------------------------------------------------------*/
	private boolean cgiExchange(URL url, String message, boolean toEncode)
	throws IOException {
	    
	    String cgiResponse = new String();
	    URLConnection connection = url.openConnection();
		connection.setDoOutput(true);
		if (toEncode)
            message = URLEncoder.encode(message, "UTF-8");

		PrintWriter out = new PrintWriter(connection.getOutputStream());
		out.println(message);
		out.close();
		BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));
		cgiResponse = in.readLine();
		in.close();
	    return (cgiResponse.equalsIgnoreCase("true"));
	}

    
    public boolean eraseQuiz(String quizUrl) {
        // remove quiz based on the url
        return true;
    }
}